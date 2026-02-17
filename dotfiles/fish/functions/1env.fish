function 1env --description "Manage .env files with 1Password"
    set -l config_file ~/.config/1env/config
    set -l config_dir ~/.config/1env
    set -l state_dir ~/.local/state/1env

    # Helper: get configured vault (inherits config_file from parent scope)
    function __1env_get_vault -V config_file
        if test -f $config_file
            cat $config_file
        else
            return 1
        end
    end

    # Helper: ensure initialized
    function __1env_require_init -V config_file
        if not test -f $config_file
            echo "Error: 1env not initialized. Run '1env init <vault>' first."
            return 1
        end
    end

    # Helper: get project name from current directory
    function __1env_default_project
        basename (pwd)
    end

    # Parse arguments
    set -l cmd ""
    set -l args

    if test (count $argv) -eq 0
        set cmd "source"
        set args
    else
        switch $argv[1]
            case init
                set cmd "init"
                set args $argv[2..-1]
            case import
                set cmd "import"
                set args $argv[2..-1]
            case -a --all
                set cmd "all"
                set args $argv[2..-1]
            case -c --clear
                set cmd "clear"
                set args $argv[2..-1]
            case -l --list
                set cmd "list"
                set args $argv[2..-1]
            case -s --status
                set cmd "status"
                set args $argv[2..-1]
            case -h --help
                set cmd "help"
            case '-*'
                echo "Unknown option: $argv[1]"
                return 1
            case '*'
                set cmd "source"
                set args $argv
        end
    end

    switch $cmd
        case help
            echo "1env - Manage .env files with 1Password"
            echo ""
            echo "Usage:"
            echo "  1env init <vault>                  Initialize with vault name"
            echo "  1env import [env] [-f file] [-i]   Import .env to 1Password"
            echo "  1env import <project> <env> [-f file] [-i]"
            echo "  1env [env]                         Source env vars"
            echo "  1env <project> <env>               Source with explicit project"
            echo "  1env -a/--all                      Source all projects"
            echo "  1env -c/--clear [project]          Clear sourced vars"
            echo "  1env -l/--list [project]           List available envs"
            echo "  1env -s/--status                   Show sourced envs"
            echo "  1env -h/--help                     Show this help"
            echo ""
            echo "Project defaults to current directory name."
            echo "Items are stored as <project>/<env> (e.g. myapp/staging)."

        case init
            if test (count $args) -lt 1
                echo "Usage: 1env init <vault>"
                return 1
            end

            set -l vault $args[1]

            # Create config directory and save vault
            mkdir -p $config_dir
            echo $vault >$config_file
            echo "Initialized 1env with vault: $vault"

        case import
            __1env_require_init; or return 1

            set -l vault (__1env_get_vault)
            set -l project (__1env_default_project)
            set -l env_name "default"
            set -l env_file ".env"
            set -l interactive false

            # Parse import arguments
            set -l positional
            set -l i 1
            while test $i -le (count $args)
                switch $args[$i]
                    case -f --file
                        set i (math $i + 1)
                        if test $i -le (count $args)
                            set env_file $args[$i]
                        else
                            echo "Error: -f requires a file path"
                            return 1
                        end
                    case -i --interactive
                        set interactive true
                    case '-*'
                        echo "Unknown option: $args[$i]"
                        return 1
                    case '*'
                        set positional $positional $args[$i]
                end
                set i (math $i + 1)
            end

            # Apply positional args
            if test (count $positional) -ge 2
                set project $positional[1]
                set env_name $positional[2]
            else if test (count $positional) -ge 1
                set env_name $positional[1]
            end

            set -l item_title "$project/$env_name"
            set -l fields

            if test "$interactive" = true
                # Interactive mode: prompt for KEY=VALUE pairs
                echo "Enter environment variables as KEY=VALUE (empty line to finish):"
                while true
                    read -l -P "> " line
                    if test -z "$line"
                        break
                    end

                    # Parse KEY=VALUE (value can be empty)
                    if not string match -q '*=*' -- "$line"
                        echo "Invalid format. Use KEY=VALUE"
                        continue
                    end

                    set -l key (string split -m 1 '=' -- "$line")[1]
                    set -l value (string split -m 1 '=' -- "$line")[2]

                    if test -z "$key"
                        echo "Invalid format. Use KEY=VALUE"
                        continue
                    end

                    if test -z "$value"
                        echo "  Skipped: $key (empty value - use \"\" for empty string)"
                        continue
                    end

                    set -l field "$key"'[password]='"$value"
                    set fields $fields $field
                    echo "  Added: $key"
                end
            else
                # File mode: read from .env file
                if not test -f $env_file
                    echo "Error: File '$env_file' not found"
                    return 1
                end

                # Parse .env file and build field arguments
                while read -l line
                    # Trim whitespace and carriage returns (Windows line endings)
                    set line (string trim -- "$line" | string replace -r '\r$' '')

                    # Strip 'export ' prefix if present
                    set line (string replace -r '^export\s+' '' -- "$line")

                    # Skip empty lines and comments
                    if test -z "$line"; or string match -q '#*' "$line"
                        continue
                    end

                    # Skip lines without =
                    if not string match -q '*=*' -- "$line"
                        continue
                    end

                    # Parse KEY=VALUE (handle = in value)
                    set -l key (string trim -- (string split -m 1 '=' -- "$line")[1])
                    set -l value (string split -m 1 '=' -- "$line")[2]

                    # Strip trailing semicolon from value
                    set value (string replace -r ';?\s*$' '' -- "$value")

                    # Strip surrounding quotes, but keep "" for empty quoted strings
                    if test "$value" = '""' -o "$value" = "''"
                        # Keep as "" so 1Password stores it
                        set value '""'
                    else
                        set value (string replace -r '^["\'](.*)["\']\s*$' '$1' -- "$value")
                    end

                    if test -n "$key" -a -n "$value"
                        set -l field "$key"'[password]='"$value"
                        set fields $fields $field
                    end
                end <$env_file
            end

            if test (count $fields) -eq 0
                echo "Error: No environment variables to import"
                return 1
            end

            # Print action
            if test "$interactive" = true
                echo "Importing to $item_title in vault '$vault'..."
            else
                echo "Importing $env_file as $item_title to vault '$vault'..."
            end

            # Check if item already exists
            if op item get "$item_title" --vault "$vault" >/dev/null 2>&1
                # Merge: update existing + add new fields, keep untouched ones
                if op item edit "$item_title" --vault "$vault" $fields >/dev/null
                    echo "Merged "(count $fields)" variables into existing $item_title"
                else
                    echo "Error: Failed to update item in 1Password"
                    return 1
                end
            else
                # New item
                if op item create --vault "$vault" --title "$item_title" --category login $fields >/dev/null
                    echo "Created $item_title with "(count $fields)" variables"
                else
                    echo "Error: Failed to create item in 1Password"
                    return 1
                end
            end

        case source
            __1env_require_init; or return 1

            set -l vault (__1env_get_vault)
            set -l project (__1env_default_project)
            set -l env_name "default"

            # Apply positional args
            if test (count $args) -ge 2
                set project $args[1]
                set env_name $args[2]
            else if test (count $args) -ge 1
                set env_name $args[1]
            end

            set -l item_title "$project/$env_name"

            # Auto-clear previous env from same project
            mkdir -p $state_dir
            for state_file in $state_dir/$project-*.vars
                if test -f "$state_file"
                    set -l old_env (basename "$state_file" .vars | string replace "$project-" "")
                    echo "Auto-clearing previous env: $project/$old_env"
                    while read -l var_name
                        set -e $var_name
                    end <"$state_file"
                    rm -f "$state_file"
                end
            end

            # Get item from 1Password
            set -l json_output
            if not set json_output (op item get "$item_title" --vault "$vault" --format json 2>&1)
                echo "Error: Could not find '$item_title' in vault '$vault'"
                echo ""
                echo "Available items:"
                1env --list
                return 1
            end

            # Parse JSON and export variables
            set -l var_names
            set -l fields (echo $json_output | jq -r '.fields[]? | select(.type == "CONCEALED") | "\(.label)=\(.value)"')

            for field in $fields
                set -l key (string split -m 1 '=' -- "$field")[1]
                set -l value (string split -m 1 '=' -- "$field")[2]

                # Strip 'export ' prefix if present (from older imports)
                set key (string replace -r '^export\s+' '' -- "$key")

                # Skip standard login fields
                if contains "$key" "password" "username"
                    continue
                end

                if test -n "$key"
                    set -gx $key "$value"
                    set var_names $var_names $key
                end
            end

            if test (count $var_names) -eq 0
                echo "Warning: No environment variables found in '$item_title'"
                return 0
            end

            # Save var names to state file
            set -l state_file $state_dir/$project-$env_name.vars
            printf '%s\n' $var_names >$state_file

            echo "Sourced "(count $var_names)" variables from $item_title"

        case all
            __1env_require_init; or return 1

            set -l vault (__1env_get_vault)

            # Get all items from vault
            set -l items (op item list --vault "$vault" --format json 2>/dev/null | jq -r '.[].title')

            if test -z "$items"
                echo "No items found in vault '$vault'"
                return 0
            end

            for item in $items
                # Parse project/env from title
                set -l parts (string split '/' -- "$item")
                if test (count $parts) -eq 2
                    echo "Sourcing $item..."
                    1env $parts[1] $parts[2]
                end
            end

        case clear
            set -l project_filter ""
            if test (count $args) -ge 1
                set project_filter $args[1]
            end

            mkdir -p $state_dir
            set -l cleared 0

            for state_file in $state_dir/*.vars
                if not test -f "$state_file"
                    continue
                end

                set -l filename (basename "$state_file" .vars)

                # If project filter specified, check if matches
                if test -n "$project_filter"
                    if not string match -q "$project_filter-*" "$filename"
                        continue
                    end
                end

                # Clear variables
                while read -l var_name
                    set -e $var_name
                    set cleared (math $cleared + 1)
                end <"$state_file"

                rm -f "$state_file"
                echo "Cleared: "(string replace '-' '/' "$filename")
            end

            if test $cleared -eq 0
                echo "No sourced variables to clear"
            else
                echo "Cleared $cleared variables"
            end

        case list
            __1env_require_init; or return 1

            set -l vault (__1env_get_vault)
            set -l project_filter ""

            if test (count $args) -ge 1
                set project_filter $args[1]
            end

            # Get all items from vault
            set -l items (op item list --vault "$vault" --format json 2>/dev/null | jq -r '.[].title' | sort)

            if test -z "$items"
                echo "No items found in vault '$vault'"
                return 0
            end

            for item in $items
                if test -n "$project_filter"
                    # Only show items matching project filter
                    if string match -q "$project_filter/*" "$item"
                        echo $item
                    end
                else
                    echo $item
                end
            end

        case status
            mkdir -p $state_dir
            set -l found 0

            for state_file in $state_dir/*.vars
                if not test -f "$state_file"
                    continue
                end

                set -l filename (basename "$state_file" .vars)
                set -l display_name (string replace '-' '/' "$filename")

                set -l var_count (wc -l <"$state_file" | string trim)

                # Check if vars are actually exported in this shell
                set -l first_var (head -1 "$state_file")
                if set -q $first_var
                    echo "$display_name ($var_count vars)"
                else
                    echo "$display_name (stale - not sourced in this shell)"
                end
                set found (math $found + 1)
            end

            if test $found -eq 0
                echo "No environments currently sourced"
            end
    end
end

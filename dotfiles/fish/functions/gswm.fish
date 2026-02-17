function gswm -d "git switch to main or master"
    if git show-ref --verify --quiet refs/heads/main
        git switch main
    else
        git switch master
    end
end

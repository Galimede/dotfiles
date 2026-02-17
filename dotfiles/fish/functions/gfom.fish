function gfom -d "git fetch origin main or master"
    if git show-ref --verify --quiet refs/remotes/origin/main
        git fetch origin main
    else
        git fetch origin master
    end
end

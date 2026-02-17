function gunwip -d "undo last wip commit"
    if git log -n 1 --pretty=%s | grep -q -c "\-\-wip\-\-"
        git reset HEAD~1
    else
        echo "Last commit is not a WIP commit"
    end
end

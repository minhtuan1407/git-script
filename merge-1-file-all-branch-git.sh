#!/bin/bash

all_branches=$(git ls-remote --heads origin | sed 's?.*refs/heads/??')

for branches in $all_branches; do
    git cherry-pick --abort
    git pull --all --no-edit
done

commit_id_with_hosts=$(git log -1 --all --format=%H hosts_all_server)

for branches in $all_branches; do
    if [[ $branches =~ ^main-* ]] ; then
        git checkout $branches
        git pull --all --no-edit
        git cherry-pick $commit_id_with_hosts
        git checkout --theirs file_name
        git add file_name
        git commit -m "change: script update file_name"
        git push origin $branches
    fi
done

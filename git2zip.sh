#!/bin/bash

if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    echo "Please enter the command in the following formats:"
    echo "./git2zip.sh <github_repo_link>"
    echo "./git2zip.sh <github_repo_link> <rev>"
    echo "./git2zip.sh <github_repo_link> <start> <end>"
    echo "example: bash git2zip.sh https://github.com/rmccue/test-repository 5e58..e53f"
elif [ $# -eq 3 ]
then
    repolink=${1:?Must provide a repository link}
    start=${2:?Must provide start hash}
    end=${3:?Must provide end hash}
    reponame=$(echo $repolink | awk -F/ '{print $NF}' | sed -e 's/.git$//') &&
    repolinknogit=$(echo $repolink | sed -e 's/.git$//') &&
    #git clone $repolink $reponame &&
    echo "git clone Finished" &&
    cd $reponame &&
    git log --pretty='format:%H' ${start}..${end} > ../gitlog${reponame}${start}${end}.txt &&
    echo "git log Finished" &&
    cd .. &&
    mkdir -p ${reponame}${start}${end}Commits &&
    echo "mkdir Finished" &&
    cat gitlog${reponame}${start}${end}.txt | xargs -I % sh -c 'wget '${repolinknogit}'/archive/%.zip -P ./'${reponame}${start}${end}'Commits/' &&
    echo "wget Finished" 
elif [ $# -eq 2 ]
then
    repolink=${1:?Must provide a repository link}
    rev=${2:?Must provide revisions}
    reponame=$(echo $repolink | awk -F/ '{print $NF}' | sed -e 's/.git$//') &&
    repolinknogit=$(echo $repolink | sed -e 's/.git$//') &&
    #git clone $repolink $reponame &&
    echo "git clone Finished" &&
    cd $reponame &&
    git log --pretty='format:%H' ${rev} > ../gitlog${reponame}${rev}.txt &&
    echo "git log Finished" &&
    cd .. &&
    mkdir -p ${reponame}${rev}Commits &&
    echo "mkdir Finished" &&
    cat gitlog${reponame}${rev}.txt | xargs -I % sh -c 'wget '${repolinknogit}'/archive/%.zip -P ./'${reponame}${rev}'Commits/' &&
    echo "wget Finished" 
elif [ $# -eq 1 ]
then
    repolink=${1:?Must provide an repository link}
    reponame=$(echo $repolink | awk -F/ '{print $NF}' | sed -e 's/.git$//') &&
    repolinknogit=$(echo $repolink | sed -e 's/.git$//') &&
    git clone $repolink $reponame &&
    echo "git clone Finished" &&
    cd $reponame &&
    git log --pretty='format:%H' > ../gitlog${reponame}all.txt &&
    echo "git log Finished" &&
    cd .. &&
    mkdir -p ${reponame}Commits &&
    echo "mkdir Finished" &&
    cat gitlog${reponame}all.txt | xargs -I % sh -c 'wget '${repolinknogit}'/archive/%.zip -P ./'${reponame}'Commits/' &&
    echo "wget Finished"
else
    echo "Incorrect arguements supplied"
    echo "Please enter the command in the following formats:"
    echo "./git2zip.sh <github_repo_link>"
    echo "./git2zip.sh <github_repo_link> <rev>"
    echo "./git2zip.sh <github_repo_link> <start> <end>"
    echo "example: bash git2zip.sh https://github.com/rmccue/test-repository 5e58..e53f"
fi

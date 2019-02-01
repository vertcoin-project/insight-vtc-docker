#!/bin/bash
#
# Simple script to perform operations against the various vertcore repos in one go and transform package.json for local development.
#
# usage: repos <action> [<repo>]
#
# <action>    The action to run against the repositories. Possible values:
#  check      Shows the current status of the repo(s). [Default]
#  clone      Clones the repo(s). Also updates package.json dependencies to point to local folders.
#  install    Installs the repo(s) via 'npm install'.
#  reinstall  Uninstalls the repo(s), deleting node_modules and package-lock.json, and then installs them again.
#  reset      Performs a hard reset of the repo(s).
#  test       Runs test on the repo(s).
#  update     Fetches and pulls the latest commits for the repo(s). Also updates package.json dependencies to point to local folders.
#
# <repo>      The name of the repo to run the command against, or omit to run against all.
# 

# list of repos
repos="vertcore-build vcoin vertcore-lib vertcore-message vertcore-p2p vertcore-node insight-vtc-api insight-vtc-ui vertcore"
gitcollection="vertcoin-project"

# update package.json dependencies to point to local folders
function updatepackagejson() {
    for repo in $repos
    do
        sed -i -e "s/git:\/\/github.com\/$gitcollection\/$repo.git/file:..\/$repo/g" ./package.json
        sed -i -e "s/git:\/\/github.com\/$gitcollection\/$repo/file:..\/$repo/g" ./package.json        
    done
    echo "updated package.json dependencies"
}
# display git status
function checkrepo() {
    cd $1
    git status
    cd ..
}
# hard reset
function resetrepo() {
    cd $1
    git reset --hard
    cd ..
}
# fetch & pull changes (also update package.json)
function updaterepo() {
    cd $1
    git fetch
    git pull
    updatepackagejson
    cd ..
}
# install (or reinstall)
function installrepo() {
    cd $1
    if [ "$2" == "Y" ]; then
        npm uninstall
        rm -rf node_modules
        rm package-lock.json
    fi
    npm install
    cd ..
}
# clone (Also update package.json)
function clonerepo() {
    git clone "https://github.com/$gitcollection/$1.git"
    cd $1
    if [ "$1" == "insight-vtc-api" ] || [ "$1" == "vertcore-lib" ] || [ "$1" == "vertcore-node" ] || [ "$1" == "vertcore-p2p" ]; then
        git checkout vcoin
    fi
    updatepackagejson
    cd ..
}
# run tests
function testrepo() {
    cd $1
    npm test
    cd ..
}

for repo in $repos
do
    if [ "$2" != "" ] && [ "$2" != $repo ]; then
        continue
    elif [ "$1" == "clone" ]; then
        echo "cloning $repo..."
        clonerepo $repo
    elif [ "$1" == "test" ]; then
        echo "testing $repo..."
        testrepo $repo
    elif [ "$1" == "reset" ]; then
        echo "resetting $repo..."
        resetrepo $repo
    elif [ "$1" == "update" ]; then
        echo "updating $repo..."
        updaterepo $repo
    elif [ "$1" == "install" ]; then
        echo "installing $repo..."
        installrepo $repo
    elif [ "$1" == "reinstall" ]; then
        echo "reinstalling $repo..."
        installrepo $repo Y
    elif [ "$1" == "check" ] || [ "$1" == "" ]; then
        echo "$repo:"
        checkrepo $repo
    else
        echo "unrecognised command: $1"
    fi
    echo ""
done


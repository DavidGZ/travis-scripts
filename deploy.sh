#!/bin/sh

OUT="$1"

# only if the deploy key isn't already present for some reason
if [ ! -f ".travis/deploy-key" ]
then
    if [ "${TRAVIS_PULL_REQUEST}" = "false" ]
    then
        # regular commit, must have encrypted key/iv
        if [ ! -z "$2" -a ! -z "$3" ]
        then
            openssl aes-256-cbc -K "$2" -iv "$3" -in ".travis/deploy-key.enc" -out ".travis/deploy-key" -d
        fi
    else
        # pull request, try to get the deploy key (ignore key/iv even if available)
        wget -O ".travis/deploy-key" "${BASE_RAW_URL}/travis-pr/master/pr-deploy-key"
    fi
fi

if [ -f ".travis/deploy-key" ]
then
    eval "$(ssh-agent -s)"
    chmod 600 ".travis/deploy-key"
    ssh-add ".travis/deploy-key"

    git clone "${PUBLISH_REPO}" ".travis/publish" && cd ".travis/publish"
    git rm -rf "${PUBLISH_PATH}"
    mkdir -p "${PUBLISH_PATH}"
    cp -r "${OUT}"/* "${PUBLISH_PATH}"
    git add "${PUBLISH_PATH}" && git commit -m "${COMMIT_MESSAGE}" \
        && (while true; do git push; [ $? -ne 0 ] || break; git pull --rebase; done)
fi

# it's possible to hook 'deploy' on:
# - pages (https://docs.travis-ci.com/user/deployment/pages)
# - releases (https://docs.travis-ci.com/user/deployment/releases)
#
# but it requires a personal token, having a user-agnostic deploy key is much more transparent

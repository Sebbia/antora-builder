#!/usr/bin/env bash

set -e
set -x

USER_NAME=builder
GROUP_NAME=builder

USER_ID=$1
GROUP_ID=$2

if grep -q ":x:${GROUP_ID}:" /etc/group; then
    sed -r -i "s/\w+:x:${GROUP_ID}/${GROUP_NAME}:x:${GROUP_ID}/" /etc/group
else
    if which groupadd >/dev/null; then
        groupadd -g ${GROUP_ID} ${GROUP_NAME}
    else
        addgroup -g ${GROUP_ID} ${GROUP_NAME}
    fi
fi

if grep -q ":x:${USER_ID}:" /etc/passwd; then
    sed -r -i "s/\w+:x:${USER_ID}:[0-9]+:/${USER_NAME}:x:${USER_ID}:${GROUP_ID}:/" /etc/passwd
else
    if which useradd >/dev/null; then
        useradd -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME}
    else
        adduser -D -u ${USER_ID} -G ${GROUP_NAME} ${USER_NAME}
    fi
fi

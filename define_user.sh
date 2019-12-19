#!/usr/bin/env bash

USER_NAME=builder
GROUP_NAME=builder

USER_ID=$1
GROUP_ID=$2

if grep -q ":x:${GROUP_ID}:" /etc/group; then
    sed -r -i "s/\w+:x:${GROUP_ID}/${GROUP_NAME}:x:${GROUP_ID}/" /etc/group
else
    groupadd -g ${GROUP_ID} ${GROUP_NAME}
fi

if grep -q ":x:${USER_ID}:" /etc/passwd; then
    sed -r -i "s/\w+:x:${USER_ID}:[0-9]+:/${USER_NAME}:x:${USER_ID}:${GROUP_ID}:/" /etc/passwd
else
    useradd -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME}
fi

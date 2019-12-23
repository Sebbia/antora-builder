#!/bin/bash

set -e

TMP=/tmp/antora-builder.zip
INSTALL_DIR=${HOME}/.antora-builder

curl https://codeload.github.com/Sebbia/antora-builder/zip/master > ${TMP}
[ -d /tmp/antora-builder-master ] && rm -rf /tmp/antora-builder-master
unzip -d /tmp ${TMP}

[ -d ${INSTALL_DIR} ] && rm -rf ${INSTALL_DIR}
mv /tmp/antora-builder-master ${INSTALL_DIR}

NEXT_STEP=

if [ -d ${HOME}/bin ]; then
    [ ! -f ${HOME}/bin/sebbia-antora-builder ] && ln -s ${INSTALL_DIR}/sebbia-antora-builder.sh ${HOME}/bin/sebbia-antora-builder
    chmod +x ${HOME}
else
    BIN_DIR=${INSTALL_DIR}/bin

    mkdir -p ${BIN_DIR}
    ln -s ${INSTALL_DIR}/sebbia-antora-builder.sh ${BIN_DIR}/sebbia-antora-builder
    chmod +x ${BIN_DIR}/sebbia-antora-builder

    updateProfile() {
        FILE_PATH="${HOME}/$1"
        [ -f "${FILE_PATH}" ] || return 1
        grep -q "${BIN_DIR}" ${FILE_PATH} && return 0
        echo -e "\nexport PATH=${BIN_DIR}:\${PATH}" >> ${FILE_PATH}
    }

    if updateProfile ".bash_profile" || updateProfile ".bashrc" || updateProfile ".profile"; then
        NEXT_STEP="\nWARNING: Before you start you have to reload your terminal application\n"
    else
        echo "Cannot install. Your system is not supported. We are sorry :("
        exit 1
    fi
fi

echo
echo "                                                   ____________ "
echo "Sebbia Antora Builder installed successfully!     < SUCCESS!!! >"
echo "Just proceed with:                                 ------------ "
echo "                                                          \   ^__^"
echo "  $ sebbia-antora-builder                                  \  (oo)\_______"
echo "                                                              (__)\       )\/\\"
echo "                                                                  ||----w |"
echo "                                                                  ||     ||"
echo -e "$NEXT_STEP"

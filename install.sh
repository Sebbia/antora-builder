#!/bin/bash

set -e

TMP=/tmp/antora-builder.zip
INSTALL_DIR=${HOME}/.antora-builder

curl https://codeload.github.com/Sebbia/antora-builder/zip/master > ${TMP}
unzip -d ${HOME} ${TMP}
mv ${HOME}/antora-builder-master ${INSTALL_DIR}
ln -s ${INSTALL_DIR}/sebbia-antora-builder.sh ${HOME}/bin/sebbia-antora-builder
chmod +x ${HOME}/bin/sebbia-antora-builder

echo
echo "                                                   ____________ "
echo "Sebbia Antora Builder installed successfully!     < SUCCESS!!! >"
echo "Just proceed with:                                 ------------ "
echo "                                                          \   ^__^"
echo "  $ sebbia-antora-builder                                  \  (oo)\_______"
echo "                                                              (__)\       )\/\\"
echo "                                                                  ||----w |"
echo "                                                                  ||     ||"
echo

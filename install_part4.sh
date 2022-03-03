#!/bin/bash

USER=''

INSTALL_GITHUB_REPO=https://github.com/zachary-silver/arch-linux-install.git

git clone ${INSTALL_GITHUB_REPO} /home/${USER}/arch-linux-install

echo -e "\n\nNow run 'cd arch-linux-install' and then 'bash ./setup.sh'!\n\n"

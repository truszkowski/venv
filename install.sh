#!/bin/bash

mkdir -p ~/.venv/{venv,bash,cmake}

cp -rpf bash/* ~/.venv/bash/
cp -rpf cmake/* ~/.venv/cmake/

echo -e "\033[32;1mAdd into your '~/.bashrc' file:"
echo -e ""
echo -e "  source \${HOME}/.venv/bash/venv.sh"
echo -e ""
echo -e "Then reset your shell."
echo -e "\033[0m"

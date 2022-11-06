#!/bin/bash
# Install tmux locally without root access

# Locally-installed programs go here.
mkdir ~/.local/bin -p
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="$HOME/local/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc
echo 'export MANPATH="$HOME/local/share/man:$MANPATH"' >> ~/.bashrc

# tmux latest version
mkdir ~/.local/bin -p
cd ~/.local/bin
curl -s https://api.github.com/repos/kiyoon/tmux-appimage/releases/latest \
| grep "browser_download_url.*appimage" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi - \
&& chmod +x tmux.appimage
./tmux.appimage --appimage-extract
rsync -a squashfs-root/usr/ ~/.local/
rm ~/bin/tmux.appimage
rm -rf squashfs-root
echo 'export TERMINFO="$HOME/.local/share/terminfo"  # tmux needs this' >> ~/.bashrc

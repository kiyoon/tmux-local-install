#!/bin/bash
# Install tmux locally without root access

add_env_to_profile() {
	file="$1"
	envname="$2"
	envval="$3"
	value_extracted=$(eval echo "$envval")

	current_value=$(eval "echo \$$envname")

	if [[ :"$current_value": != *:"$value_extracted":* ]]
	then
		echo "export $envname=\"$envval:\$$envname\"" >> "$file"
	fi
}

add_line_to_profile() {
	file="$1"
	line="$2"

	grep -qF -- "$line" "$file" || echo "$line" >> "$file"
}

# Locally-installed programs go here.
add_env_to_profile ~/.bashrc 'PATH' '$HOME/.local/bin'
add_env_to_profile ~/.bashrc 'LD_LIBRARY_PATH' '$HOME/.local/lib'
add_env_to_profile ~/.bashrc 'MANPATH' '$HOME/.local/share/man'

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
rm tmux.appimage
rm -rf squashfs-root
add_line_to_profile ~/.bashrc 'export TERMINFO="$HOME/.local/share/terminfo"  # tmux needs this'

cd -
\source ~/.bashrc

echo "tmux installed at $HOME/.local/bin/tmux"
echo "Run 'tmux' to start tmux."

#!/bin/bash
set -e

link_dots() {
	local dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	local config_dir="$dotfiles_dir/config"
	local local_dir="$dotfiles_dir/local"

    _link() {
        mkdir -p "$(dirname "$2")"
        [[ -e "$2" && ! -L "$2" ]] && mv "$2" "$2.bak"
        [[ -L "$2" ]] && rm "$2"
        ln -sf "$1" "$2"
    }
    
    if [[ -d "$config_dir" ]]; then
        mkdir -p "$HOME/.config"
        while IFS= read -r -d '' file; do
            _link "$file" "$HOME/.config/${file#$config_dir/}"
        done < <(find "$config_dir" -type f -print0)
    fi
    
    if [[ -d "$local_dir" ]]; then
        mkdir -p "$HOME/.local"
        while IFS= read -r -d '' file; do
            _link "$file" "$HOME/.local/${file#$local_dir/}"
        done < <(find "$local_dir" -type f -print0)
    fi
}

setup_bashrc() {
    local line='[ -f "$HOME/.config/bash/bashrc" ] && source "$HOME/.config/bash/bashrc"'
    while true; do
        printf "Add bash config to:\n1) System (/etc/bash.bashrc)\n2) User (~/.bashrc)\nChoice: "
        read ch
        case $ch in
            1) sudo bash -c "grep -qxF '$line' /etc/bash.bashrc || echo '$line' >> /etc/bash.bashrc"
               echo "Added to /etc/bash.bashrc"; break ;;
            2) grep -qxF "$line" ~/.bashrc 2>/dev/null || echo "$line" >> ~/.bashrc
               echo "Added to ~/.bashrc"; break ;;
            *) echo "Invalid input" ;;
        esac
    done
}

install_packages() {
    mkdir -p "$HOME/.local/bin"
    
    local packages=(
        "neovim     neovim/neovim         nvim-linux-x86_64.appimage          bin    nvim"
        "yazi       sxyazi/yazi           x86_64-unknown-linux-musl.zip       zip    yazi"
        "ya         sxyazi/yazi           x86_64-unknown-linux-musl.zip       zip    ya"
        "fzf        junegunn/fzf          linux_amd64.tar.gz                  tar    fzf"
        "fd         sharkdp/fd            x86_64-unknown-linux-musl.tar.gz    tar    fd"
        "ripgrep    BurntSushi/ripgrep    x86_64-unknown-linux-musl.tar.gz    tar    rg"
        "tmux       tmux/tmux-builds      linux-x86_64.tar.gz                 tar    tmux"
    )
    
    _github_url() { 
        curl -s "https://api.github.com/repos/$1/releases/latest" | 
            grep "browser_download_url" | 
            grep "$2" | 
            head -1 | 
            cut -d '"' -f 4
    }
    
    _install_bin() {
        local name=$1 url=$2 binary=$3
        curl -L -o "/tmp/$name" "$url" || wget -O "/tmp/$name" "$url"
        cp -f "/tmp/$name" "$HOME/.local/bin/$binary"
        chmod +x "$HOME/.local/bin/$binary"
        rm -f "/tmp/$name"
    }
    
    _install_zip() {
        local name=$1 url=$2 binary=$3
        local zip_file="/tmp/$name.zip"
        local extract_dir="/tmp/$name"
        curl -L -o "$zip_file" "$url" || wget -O "$zip_file" "$url"
        unzip -qo "$zip_file" -d "$extract_dir"
        find "$extract_dir" -type f -name "$binary" -exec cp -f {} "$HOME/.local/bin/" \;
        rm -rf "$zip_file" "$extract_dir"
    }
    
    _install_tar() {
        local name=$1 url=$2 binary=$3
        local tar_file="/tmp/$name.tar.gz"
        local extract_dir="/tmp/$name"
        curl -L -o "$tar_file" "$url" || wget -O "$tar_file" "$url"
        mkdir -p "$extract_dir"
        tar -xf "$tar_file" -C "$extract_dir"
        find "$extract_dir" -type f -name "$binary" -exec cp -f {} "$HOME/.local/bin/" \;
        rm -rf "$tar_file" "$extract_dir"
    }

    for pkg in "${packages[@]}"; do
		read -r name repo pattern type binary <<< "$pkg"
        
        echo "Installing $name..."
        url=$(_github_url "$repo" "$pattern")
        if [ -z "$url" ]; then
            echo "Failed to get URL for $name"
            continue
        fi
        echo "URL: $url"
        case $type in
            bin) _install_bin "$name" "$url" "$binary" ;;
            zip) _install_zip "$name" "$url" "$binary" ;;
            tar) _install_tar "$name" "$url" "$binary" ;;
        esac
        echo "$name installed"
    done
}

case "${1:-all}" in
	dots) link_dots ;;
    bash) setup_bashrc ;;
    packages) install_packages ;;
    all) link_dots; setup_bashrc; install_packages ;;
    *) echo "Usage: $0 [dots|bash|packages|all]"; exit 1 ;;
esac

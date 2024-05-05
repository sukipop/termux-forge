#!/usr/bin/env bash
requirements=("git")

# Function to print error message
error() {
    local errmsg="${1:-Unknown error}"
    echo -e "\033[0;31mError\033[0m $errmsg\n" 1>&2
}

# Ensure required packages are available
missing_pkgs=()
for pkg in "${requirements[@]}"; do
    if ! command -v "$pkg" &> /dev/null; then
        missing_pkgs+=("$pkg")
    fi
done
if [[ "${#missing_pkgs[@]}" -gt 0 ]]; then
    error "Missing packages: ${missing_pkgs[@]}"
    exit 1
fi

# Ensure packages.txt is available
if [[ ! -f "packages.txt" ]]; then
    error "Missing file: packages.txt"
    exit 1
fi

# Install packages listed in packages.txt
pkg update -y
pkg upgrade -y
while read -r pkg; do
    if [[ "$pkg" == '#'* ]]; then
        continue
    else
        pkg=$(echo "$pkg" | cut -d' ' -f1)
    fi
    pkg install -y "$pkg"
done < "packages.txt"

# Set up zsh
cp "assets/etc/zshrc" "$PREFIX/etc/zshrc"
mkdir -p "$HOME/.config"
if ! git clone git@github.com:sukipop/zsh-config.git "$HOME/.config/zsh"; then
    if ! git clone https://github.com/sukipop/zsh-config "$HOME/.config/zsh"; then
         error "Failed to clone zsh-config"
    fi
fi

# Enable zsh
if [[ "$SHELL" != "$PREFIX/bin/zsh" ]]; then
    chsh -s zsh
fi

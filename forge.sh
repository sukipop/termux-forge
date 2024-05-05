#!/usr/bin/env bash
requirements=()

# Function to print error message
error() {
    local errmsg="${1:-Unknown error}"
    echo -e "Error: ${errmsg}\n" 1>&2
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

mkdir -p "$HOME/.config"

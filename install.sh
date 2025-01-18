#!/bin/bash

restart_nautilus() {
    read -p "Do you want to restart Nautilus (Files) [Y/n]? " VAR
    if [[ $VAR =~ ^[Yy]$ ]]; then
        nautilus -q
    fi
}

cp_file() {
    local FILE="vscode-nautilus.py"
    local TARGDIR="$1"

    if [[ ! -d $TARGDIR ]]; then
        mkdir -v -p "$TARGDIR"
    fi

    cp -v "$FILE" "$TARGDIR"
    set_location "$TARGDIR"
    restart_nautilus
}

cp_file_sudo() {
    local FILE="vscode-nautilus.py"
    local TARGDIR="$1"

    if [[ ! -d $TARGDIR ]]; then
        sudo mkdir -v -p "$TARGDIR"
    fi

    sudo cp -v "$FILE" "$TARGDIR"
    set_location "$TARGDIR"
    restart_nautilus
}

set_location() {
    local TARGDIR="$1"

    if [[ -e "/usr/bin/code" ]]; then
        echo "VSCode is installed in /usr/bin/code"
        sed -i "s|COMMAND_REPLACE|/usr/bin/code|g" "$TARGDIR/vscode-nautilus.py"
        sed -i "s|INSTALL_PATH_REPLACE|/usr/bin/code|g" "$TARGDIR/vscode-nautilus.py"

    elif [[ -e "/usr/bin/code-insiders" ]]; then
        echo "VSCode is installed in /usr/bin/code-insiders"
        sed -i "s|COMMAND_REPLACE|/usr/bin/code-insiders|g" "$TARGDIR/vscode-nautilus.py"
        sed -i "s|INSTALL_PATH_REPLACE|/usr/bin/code-insiders|g" "$TARGDIR/vscode-nautilus.py"

    elif [[ -e "/snap/bin/code" ]]; then
        echo "VSCode is installed in /snap/bin/code"
        sed -i "s|COMMAND_REPLACE|/snap/bin/code|g" "$TARGDIR/vscode-nautilus.py"
        sed -i "s|INSTALL_PATH_REPLACE|/snap/bin/code|g" "$TARGDIR/vscode-nautilus.py"

    elif [[ -e "/var/lib/flatpak/app/com.visualstudio.code/current/active/files/bin/code" ]]; then
        echo "VSCode is installed with Flatpak"
        sed -i "s|COMMAND_REPLACE|flatpak run com.visualstudio.code|g" "$TARGDIR/vscode-nautilus.py"
        sed -i "s|INSTALL_PATH_REPLACE|/var/lib/flatpak/app/com.visualstudio.code/current/active/files/bin/code|g" "$TARGDIR/vscode-nautilus.py"

    elif [[ -e "/usr/bin/codium" ]]; then
        echo "VSCodium is installed in /usr/bin/codium"
        sed -i "s|COMMAND_REPLACE|/usr/bin/codium|g" "$TARGDIR/vscode-nautilus.py"
        sed -i "s|INSTALL_PATH_REPLACE|/usr/bin/codium|g" "$TARGDIR/vscode-nautilus.py"
        sed -i "s|Open in Code|Open in Codium|g" "$TARGDIR/vscode-nautilus.py"
        sed -i "s|Open this folder/file in VSCode|Open this folder/file in VSCodium|g" "$TARGDIR/vscode-nautilus.py"

    elif [[ -e "/snap/bin/codium" ]]; then
        echo "VSCodium is installed in /snap/bin/codium"
        sed -i "s|COMMAND_REPLACE|/snap/bin/codium|g" "$TARGDIR/vscode-nautilus.py"
        sed -i "s|INSTALL_PATH_REPLACE|/snap/bin/codium|g" "$TARGDIR/vscode-nautilus.py"
        sed -i "s|Open in Code|Open in Codium|g" "$TARGDIR/vscode-nautilus.py"
        sed -i "s|Open this folder/file in VSCode|Open this folder/file in VSCodium|g" "$TARGDIR/vscode-nautilus.py"

    elif [[ -e "/var/lib/flatpak/app/com.vscodium.codium/current/active/files/bin/codium" ]]; then
        echo "VSCodium is installed with Flatpak"
        sed -i "s|COMMAND_REPLACE|flatpak run com.vscodium.codium|g" "$TARGDIR/vscode-nautilus.py"
        sed -i "s|INSTALL_PATH_REPLACE|/var/lib/flatpak/app/com.vscodium.codium/current/active/files/bin/codium|g" "$TARGDIR/vscode-nautilus.py"
        sed -i "s|Open in Code|Open in Codium|g" "$TARGDIR/vscode-nautilus.py"
        sed -i "s|Open this folder/file in VSCode|Open this folder/file in VSCodium|g" "$TARGDIR/vscode-nautilus.py"

    else
        echo "Could not find VSCode/VSCodium installation path."
        read -p "Please enter the path to VSCode/VSCodium: " VAR
        sed -i "s|COMMAND_REPLACE|${VAR}|g" "$TARGDIR/vscode-nautilus.py"
        if [[ ${VAR} =~ "codium" ]]; then
            sed -i "s|Open in Code|Open in Codium|g" "$TARGDIR/vscode-nautilus.py"
            sed -i "s|Open this folder/file in VSCode|Open this folder/file in VSCodium|g" "$TARGDIR/vscode-nautilus.py"
        fi
    fi
}

main() {
    if [[ $UID -ne 0 ]]; then
        read -p "This script is running without sudo. Install for the current user [y/N]? " VAR
        if [[ $VAR =~ ^[Yy]$ ]]; then
            TARGDIR="$HOME/.local/share/nautilus/extensions"
            mkdir -p "$TARGDIR"
            cp_file "$TARGDIR"
        else
            read -p "Do you want to install for all users [y/N]? " VAR
            if [[ $VAR =~ ^[Yy]$ ]]; then
                TARGDIR="/usr/share/nautilus-python/extensions"
                cp_file_sudo "$TARGDIR"
            else
                echo "Installation aborted!"
            fi
        fi
    else
        read -p "This script is running with sudo. Install for all users [y/N]? " VAR
        if [[ $VAR =~ ^[Yy]$ ]]; then
            TARGDIR="/usr/share/nautilus-python/extensions"
            cp_file "$TARGDIR"
        else
            echo "Installation aborted!"
        fi
    fi
}

main

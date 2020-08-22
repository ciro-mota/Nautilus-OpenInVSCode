# Nautilus context menu: Open in VSCode
Dependency to install before: `nautilus-python` (`python-nautilus` package on Debian / Ubuntu)
```bash
sudo apt install python3-nautilus
```
## Install 
- VSCode:
    ```bash
    ./install.sh
    or
    sudo ./install.sh
    ```
- VSCode Insider:
    ```bash
    ./install-insiders.sh.sh
    or
    sudo ./install-insiders.sh.sh
    ```
## Uninstall 
- Current User:
    ```bash
    rm ~/.local/share/nautilus-python/extensions/vscode-nautilus.py
    or
    rm ~/.local/share/nautilus-python/extensions/vscodeinsiders-nautilus.py
    ```
- All User:
    ```bash
    sudo rm /usr/share/nautilus-python/extensions/vscode-nautilus.py
    or
    sudo rm /usr/share/nautilus-python/extensions/vscodeinsiders-nautilus.py
    ```
### Restart Nautilus
```bash
nautilus -q
```
# Screenshot
![](Figures/Screenshot.png "Screenshot")
![](Figures/Screenshot.gif "Screenshot")

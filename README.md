<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset="Images/dark.png">
        <source media="(prefers-color-scheme: light)" srcset="Images/light.png">
        <img alt="SettingsKit." src="Images/light.png" width="600">
    </picture>
</p>

# Binder

A light-weight, macOS native image viewer.

## Installation
Go to the [releases](https://github.com/ssalggnikool/Binder/releases) page, and download the `.dmg` for your system.

## Build

1. Make sure you have create-dmg installed, using `npm install --global create-dmg`
    - Optional: `brew install graphicsmagick imagemagick`
      - This is for the simple volume icon, this is not needed but optional.

2. Run `make package`
    - This will try to sign it with an identity of `0`, it will appear it failed with `make: *** [package] Error 2`, but it will still create the dmg.
    
## Credits

<p align="left">
    <img align="left" height="50px" width="50px" src="https://images.weserv.nl/?url=https://github.com/ssalggnikool.png&amp;fit=cover&amp;mask=circle&amp;maxage=7d" alt="Avatar">
    <b><a href="https://github.com/ssalggnikool">Samara</a></b>
    <br>
    <sub>The maker</sub>
</p>

<p align="left">
    <img align="left" height="50px" width="50px" src="https://images.weserv.nl/?url=https://github.com/HAHALOSAH.png&amp;fit=cover&amp;mask=circle&amp;maxage=7d" alt="Avatar">
    <b><a href="https://github.com/HAHALOSAH">HAHALOSAH</a></b>
    <br>
    <sub>Bug fixes (thank you lots)</sub>
</p>

<p align="left">
    <img align="left" height="50px" width="50px" src="https://images.weserv.nl/?url=https://github.com/NSAntoine.png&amp;fit=cover&amp;mask=circle&amp;maxage=7d" alt="Avatar">
    <b><a href="https://github.com/NSAntoine">Serena</a></b>
    <br>
    <sub>Preferences code from Antoine</sub>
</p>
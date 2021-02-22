## oh-ny-zsh or powerline not present

This means the git submodule has not been run and therefore the projects are not present

```
git submodule init
git submodule update
```

If that simply won't connect, try running ${DOTFILES}/bin/grsm (git remove submodules) and try again 

## Compliant directories

```
sudo chmod -R 755 /usr/local/share/zsh
sudo chown -R root:staff /usr/local/share/zsh
```

## Fonts

Run the below to configure the font and then run script/bootstrap again to re-init the .zshrc directory from the dotfiles project. This is by far the easiest solution and is recommended

```
p10k configure
```

Otherwise attempt to install the fonts manually:
```  
sudo apt-get update
sudo apt-get install fonts-font-awesome
sudo apt-get install fonts-powerlinew
```

Direct installations of the fonts:

- https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
- https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
- https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
- https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

MesloGS NF might be required as well. For some terminals such as windows terminal or termintaor, configuration of this can be done in settings/preferences for the app and the font library specified.

A useful guide for installation in different terminal applications: https://stackoverflow.com/questions/61160791/why-are-font-awesome-characters-not-rendered-or-replaced-on-my-terminal-shell

## Font not appearing in vscode

add the following to settings.json

```
    "terminal.integrated.fontFamily": "MesloLGS NF",
    "terminal.integrated.rendererType": "canvas",
    "terminal.integrated.shell.osx": "/bin/zsh"
```
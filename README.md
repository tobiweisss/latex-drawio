# LaTeX-drawio-docker
This repository contains a docker image which can be used for building LaTeX projects.
The docker image contains a TeXLive-full installation (without docs and language packs, beside english and german).
It also conatins a installation of drawio which can be used to build pdf files from `*.drawio` files.

## Usage
To pull the latest version of this image use `docker pull ghcr.io/tobiweisss/latex-drawio:latest`

To simplify the usage the container introduces the `latex-build` command to automatically build `<your-file>.drawio.pdf` from ever `<your-file>.drawio` in the specified directory. After that the script calls `latexmk -pdf` for building all the `*.tex` files.

Following Options are available: </br>
    -h, --help:     Show the help message </br>
    -d, --dir:      Specify the input directory to search for `*.tex` and `*.drawio` files. Default is the current directory</br>
    -c, --clean:    Clean up all auxiliary files </br>
    -p, --pdf:      Use pdfLaTeX for building the `*.tex` files </br>
    -l, --lualatex: Use LuaLaTeX for building the `*.tex` files </br>
    -x, --xelatex:  Use XeLaTeX for building the `*.tex` files </br>

## Intended use with LaTeX-Workshop in a VS Code devcontainer
If you want to use this image in combination with the [Visual Studio Code LaTeX Workshop extension](https://github.com/James-Yu/LaTeX-Workshop) you can use the devcontainer provided in [examples/.devcontainer/](examples/.devcontainer/). This devcontainer is configured to build your LaTeX project using the provided script, when you click on `build` or press `Ctrl + Alt + B`. In the LaTex Workshop extension you can find six new recipes called `latex-build 🐱☕`, `latex-build-lualatex 😻☕` and `latex-build-xelatex 🙀☕` to build the project using `latex-build` and `latex-build-clean 🐱☕`, `latex-build-clean-lualatex 😻☕` and `latex-build-clean-xelatex 🙀☕` recipe to build the project and clean up afterwards using `latex-build -c`.<br>
This setup allows you to build and edit your LaTeX projects on every machine running Docker and VS Code.

In the [examples/.devcontainer/devcontainer.json](examples/.devcontainer/devcontainer.json) file you can find an example how to bind your local directories into the container. This might be useful for templates in your host `~/texmf` directory or custom fonts in your hosts `~/.fonts`directory.
>[!CAUTION]
> If your host directories contain symlinks this will not work, because the linked path does (probably) not exist inside the container!

## Thanks to
* [rlespinasse](https://github.com/rlespinasse/docker-drawio-desktop-headless) dockerized version of drawio
* [James-Yu](https://github.com/James-Yu) for the VS Code LaTeX Workshop Extension
* [tobiil](https://github.com/tobiil) for contribution

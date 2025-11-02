# LaTeX-drawio-docker
This repository contains a docker image which can be used for building LaTeX projects.
The docker image contains a TeXLive-full installation (without docs and language packs, beside english and german).
It also contains a installation of drawio which can be used to build pdf files from `*.drawio` files.

## Usage
To pull the latest version of this image use `docker pull ghcr.io/tobiweisss/latex-drawio:latest`

To simplify the usage the container introduces the `latex-build` command to automatically build `<your-file>.drawio.pdf` from ever `<your-file>.drawio` in the specified directory. After that the script calls `latexmk -pdf` for building all the `*.tex` files.

Following Options are available: </br>
| Short Option      |  Long Option      | Description            |
|-------------|------------------------|------------------------|
| -h | --help:    | Show the help message |
| -d | --dir:     | Specify the input directory to search for `*.tex` and `*.drawio` files. Default is the current directory |
| -c | --clean:   | Clean up all auxiliary files |
| -p | --pdf:     | Use pdfLaTeX for building the `*.tex` files |
| -x | --xelatex: | Use XeLaTeX for building the `*.tex` files |
| -l | --lualatex:| Use LuaLaTeX for building the `*.tex` files |

Beside the `latex-build` script, the container also provides the `drawio-build` script to only build the `*.drawio` files to `*.drawio.pdf` files and the `latex-clean` script to only clean up auxiliary files.

## Intended use with LaTeX-Workshop in a VS Code devcontainer
If you want to use this image in combination with the [Visual Studio Code LaTeX Workshop extension](https://github.com/James-Yu/LaTeX-Workshop) you can use the devcontainer provided in [examples/.devcontainer/](examples/.devcontainer/). This devcontainer is configured to build your LaTeX project using the provided script, when you click on `build` or press `Ctrl + Alt + B`. In the LaTeX Workshop extension you can find eight new recipes called:
</br>
| Recipe                    	| Description                                                                     	| Command                                                 	|
|---------------------------	|---------------------------------------------------------------------------------	|---------------------------------------------------------	|
| `latex-build 🐱☕`          	| Build all `*.tex` and `*.drawio` files using pdfLaTeX                           	| same as calling `latex-build` or `latex-build -p`       	|
| `lualatex-build 😻☕`       	| Build all `*.tex` and `*.drawio` files using LuaLaTeX                           	| same as calling `latex-build -l`                        	|
| `xelatex-build 🙀☕`        	| Build all `*.tex` and `*.drawio` files using XeLaTeX                            	| same as calling `latex-build -x`                        	|
| `latex-build-clean 🐱☕`    	| Build all `*.tex` and `*.drawio` files using pdfLaTeX and clean auxiliary files 	| same as calling `latex-build -c` or `latex-build -p -c` 	|
| `lualatex-build-clean 😻☕` 	| Build all `*.tex` and `*.drawio` files using LuaLaTeX and clean auxiliary files 	| same as calling `latex-build -l -c`                     	|
| `xelatex-build-clean 🙀☕`  	| Build all `*.tex` and `*.drawio` files using XeLaTeX and clean auxiliary files  	| same as calling `latex-build -x -c`                     	|
| `drawio-build 🖊️`          	 | Build all `*.drawio` files                                                      	 | same as calling `drawio-build`                          	 |
| `latex-clean 🗑️`           	 | Only clean up all auxiliary files                                               	 | same as calling `latex-clean`                           	 |
</br></br>

In the [examples/.devcontainer/devcontainer.json](examples/.devcontainer/devcontainer.json) file you can find an example how to bind your local directories into the container. This might be useful for templates in your host `~/texmf` directory or custom fonts in your hosts `~/.fonts`directory.

>[!CAUTION]
> If your host directories contain symlinks this will not work, because the linked path does (probably) not exist inside the container!

## Thanks to
* [rlespinasse](https://github.com/rlespinasse/docker-drawio-desktop-headless) dockerized version of drawio
* [James-Yu](https://github.com/James-Yu) for the VS Code LaTeX Workshop Extension
* [tobiil](https://github.com/tobiil) for contribution

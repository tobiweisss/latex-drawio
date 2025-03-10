# LaTeX-drawio-docker
This repository contains a docker image which can be used for building LaTeX projects.
The docker image contains a TeXLive-full installation (without docs and language packs, beside english and german).
It also conatins a installation of drawio which can be used to build pdf files from `*.drawio` files.

## Usage
To pull the latest version of this image use `docker pull ghcr.io/tobiweisss/latex-drawio:latest`

To simplify the usage the usage the container introduces the `latex-build` command to automatically build `<your-file>.drawio.pdf` from ever `<your-file>.drawio` in the specified directory. After that the script calls `latexmk -pdf` for building all the `*.tex` files.

Following Options are available:
    -h, --help:     Show the help message
    -d, --dir:      Specify the input directory to search for *.tex and *.drawio files. Default is the current directory
    -c, --clean:    Clean up all auxiliary files 

## Thanks to 
[rlespinasse](https://github.com/rlespinasse/docker-drawio-desktop-headless) dockerized version of drawio which is used as baseimage

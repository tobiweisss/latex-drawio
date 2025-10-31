#!/bin/bash

usage(){
    echo "Usage: $0"
    echo "Options: "
    echo "  -h, --help          Show this help message and exit"
    echo "  -d, --dir           Directory to search for the input files [*.tex, *.bib, *.drawio]. Default is the current directory"
    echo "  -c, --clean         Clean the auxiliary files after building the pdf"
    echo "  -p, --pdf           Use latexmk with pdflatex to build the pdf (default)"
    echo "  -x, --xelatex       Use latexmk with xelatex to build the pdf"
    echo "  -l, --lualatex      Use latexmk with lualatex to build the pdf"
}

has_argument() {
    [[ ("$1" == *=* && -n ${1#*=}) || ( ! -z "$2" && "$2" != -*)  ]];
}

extract_argument() {
  echo "${2:-${1#*=}}"
}

# Parse the command line arguments
handle_options() {
  while [ $# -gt 0 ]; do
    case $1 in
      -h | --help)
        usage
        exit 0
        ;;
      -c | --clean)
        clean=true
        ;;
      -d | --dir*)
        if ! has_argument $@; then
          echo "File not specified." >&2
          usage
          exit 1
        fi

        dir=$(extract_argument $@)

        shift
        ;;
      -p | --pdf)
        engine="pdflatex"
        ;;
      -x | --xelatex)
        engine="xelatex"
        ;;
      -l | --lualatex)
        engine="lualatex"
        ;;
      *)
        echo "Invalid option: $1" >&2
        usage
        exit 1
        ;;
    esac
    shift
  done
}



# Check if the latex command is available
if ! [ -x "$(command -v pdflatex)" ]; then
  echo 'Error: pdflatex is not installed.' >&2
  exit 1
fi

# Check if the bibtex command is available
if ! [ -x "$(command -v bibtex)" ]; then
  echo 'Error: bibtex is not installed.' >&2
  exit 1
fi

# Check if the latexmk command is available
if ! [ -x "$(command -v latexmk)" ]; then
  echo 'Error: latexmk is not installed.' >&2
  exit 1
fi

# Check if the drawio command is available
if ! [ -x "$(command -v drawio)" ]; then
  echo 'Error: drawio is not installed.' >&2
  exit 1
fi

# Parse the command line arguments
handle_options $@

if [ -z "$dir" ]; then
  dir="."
fi

if [ -z "$clean" ]; then
  clean=false
fi

cd $dir

# Exit on error, unset variables and pipe fails
set -eou pipefail

bash /usr/bin/drawio-build

echo ""
echo "##################################################"
echo "Building the latex files"
echo "##################################################"
echo ""

# Build the latex files using latexmk and pdflatex
# Use safe parameter expansion (${engine:-}) so referencing the variable
# doesn't fail when 'set -u' (treat unset as error) is enabled.
if [ -z "${engine:-}" ]; then
  engine="pdflatex"
fi

if [ "${engine:-}" = "pdflatex" ]; then
  latexmk -pdf -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error
elif [ "${engine:-}" = "xelatex" ]; then
  latexmk -xelatex -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error
elif [ "${engine:-}" = "lualatex" ]; then
  latexmk -lualatex -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error
else
  latexmk -pdf -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error
fi

if [ "$clean" = true ]; then
  bash /usr/bin/latex-clean
fi

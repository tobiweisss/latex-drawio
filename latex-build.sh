#!/bin/bash

usage(){
    echo "Usage: $0"
    echo "Options: "
    echo "  -h, --help          Show this help message and exit"
    echo "  -d, --dir           Directory to search for the input files [*.tex, *.bib, *.drawio]. Default is the current directory"
    echo "  -c, --clean         Clean the auxiliary files after building the pdf"
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

cd $dir

# Search for the drawio files in the current directory and all its subdirectories
drawio_files=$(find . -type f -name "*.drawio")
# Convert the drawio files to pdf files 
for drawio_file in $drawio_files
do
  drawio --no-sandbox -x -f pdf -o $drawio_file.pdf --crop -t $drawio_file
done

# Build the latex files using latexmk and pdflatex
latexmk -pdf

if [ "$clean" = true ]; then
  # Remove the auxiliary files if exist
  rm -f **/*.aux **/*.log **/*.out **/*.toc **/*.run.xml **/*.fls **/*.blg **/*.bbl **/*.fdb_latexmk **/*.synctex.gz **/*.bcf **/*.nav **/*.snm **/*.lol **/*.lof **/*.lot
fi
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

if [ -z "$clean" ]; then
  clean=false
fi

cd $dir

# Exit on error, unset variables and pipe fails
set -eou pipefail

# Search for the drawio files in the current directory and all its subdirectories
drawio_files=$(find ~+ -type f -name "*.drawio")

# Convert the drawio files to pdf files if they are newer or the pdf doesn't exist
echo "##################################################"
echo "Converting drawio files to pdf files"
echo "##################################################"
echo ""

for drawio_file in $drawio_files
do
  pdf_file="${drawio_file}.pdf"
  filename=$(basename "$drawio_file" .drawio)

  # Check if drawio file is newer than the pdf file or if the pdf does not exist
  if [[ ! -f "$pdf_file" || "$drawio_file" -nt "$pdf_file" ]]; then
    echo "Converting $filename.drawio"
    xvfb-run -a drawio -x -f pdf -o "$pdf_file" --crop -t "$drawio_file" --no-sandbox --disable-gpu 2>&1 | grep -Fvf "/usr/share/latex-build/unwanted-logs.txt"
  else
    echo "Skipping: $filename.drawio (PDF is up-to-date)"
  fi
done

echo ""
echo "##################################################"
echo "Building the latex files"
echo "##################################################"
echo ""

#Build the latex files using latexmk and pdflatex
latexmk -pdf -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error

if [ "$clean" = true ]; then
  # Remove the auxiliary files if exist
  rm -f **/*.aux **/*.log **/*.out **/*.toc **/*.run.xml **/*.fls **/*.blg **/*.bbl **/*.fdb_latexmk **/*.bcf **/*.nav **/*.snm **/*.lol **/*.lof **/*.lot
  # For some reason the glob pattern does not match the files in the root directory
  rm -f *.aux *.log *.out *.toc *.run.xml *.fls *.blg *.bbl *.fdb_latexmk *.bcf *.nav *.snm *.lol *.lof *.lot
fi
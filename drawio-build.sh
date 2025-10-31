#!/bin/bash
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
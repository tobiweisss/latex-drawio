#!/bin/bash
# Remove auxiliary files if exist
echo ""
echo "##################################################"
echo "Cleaning auxiliary files..."
echo "##################################################"
echo ""

rm -f **/*.aux **/*.log **/*.out **/*.toc **/*.run.xml **/*.fls **/*.blg **/*.bbl **/*.fdb_latexmk **/*.synctex.gz **/*.bcf **/*.nav **/*.snm **/*.lol **/*.lof **/*.lot **/*.mtc* **/*.xdv
rm -f *.aux *.log *.out *.toc *.run.xml *.fls *.blg *.bbl *.fdb_latexmk *.synctex.gz *.bcf *.nav *.snm *.lol *.lof *.lot *.mtc* *.xdv
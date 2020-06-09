#!/bin/bash
find . -depth -name '* *' -execdir ksh -c '
    mv "$0" "${0// /}"
' {} \;
find . -name "*.pdf" -type f | while read -r ff; do
mkdir pdfs ;
pdftotext $ff pdfs/ff_V1.txt ;
ocrmypdf -l por --sidecar aa2.txt --tesseract-timeout=0 --force-ocr $ff tmp.pdf
pdfimages -png tmp.pdf pdfs/I ;
cd pdfs ;
convert -colorspace gray -fill white -resize 150% -sharpen 0x5 toc -- *.png ff_PNG.pdf ;
rm *.png ;
parallel --tag -j 2 ocrmypdf -l por --sidecar 'ff_V2.txt' --force-ocr --output-type pdf '{}' '{}' ::: *.pdf ;
cd .. ;
cat pdfs/ff_V2.txt > $ff.txt ;
        rm tmp.pdf aa2.txt ;
        rm -r pdfs ;
done

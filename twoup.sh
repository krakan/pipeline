#!/bin/bash

TMP=$(mktemp -d)

for file
do
    name=${file%.pdf}
    pdftk $file burst output $TMP/$name-%02d.pdf

    for f in $TMP/$name-??.pdf
    do
        pdfjam --a4paper --quiet --scale 0.90 --frame true --landscape --outfile ${f%.pdf}-frame.pdf $f
    done

    pdfjam --a4paper --quiet --nup 1x2 --frame false --offset '7mm 0' --twoside $TMP/$name-??-frame.pdf --outfile $name-print.pdf

    ls -l $name-print.pdf &&
    rm -rf $TMP
done

#!/bin/bash

PROG="main"

pdflatex $PROG.tex
bibtex main
pdflatex $PROG.tex
pdflatex $PROG.tex
rm *.aux *.bbl *.log *.blg *.out *.spl

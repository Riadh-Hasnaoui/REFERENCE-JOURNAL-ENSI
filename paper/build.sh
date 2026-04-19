#!/usr/bin/env bash
# build.sh — Compile the ACM TOSEM LaTeX paper
# Usage: cd paper && bash build.sh
set -e
pdflatex -interaction=nonstopmode main
bibtex main
pdflatex -interaction=nonstopmode main
pdflatex -interaction=nonstopmode main
echo "Build complete: main.pdf"

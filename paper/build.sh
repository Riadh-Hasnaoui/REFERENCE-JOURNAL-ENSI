#!/usr/bin/env bash
# build.sh — Build the LaTeX paper
# Usage: ./build.sh  (from the paper/ directory)
set -euo pipefail

echo "[1/4] First pdflatex pass..."
pdflatex -interaction=nonstopmode main

echo "[2/4] BibTeX pass..."
bibtex main

echo "[3/4] Second pdflatex pass..."
pdflatex -interaction=nonstopmode main

echo "[4/4] Third pdflatex pass..."
pdflatex -interaction=nonstopmode main

echo "Done. Output: main.pdf ($(du -h main.pdf | cut -f1))"

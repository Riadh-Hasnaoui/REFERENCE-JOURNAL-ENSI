# ACM TOSEM SLR — LaTeX Modular Template

**Paper:** *How Do LLM-Based Agents Represent Code Repositories? A Systematic Literature Review*  
**Target:** ACM Transactions on Software Engineering and Methodology (TOSEM)

---

## How to compile on Overleaf (recommended)

1. Create a new **Blank Project** in Overleaf.
2. Upload **all files listed below** from the root of this repository into the Overleaf project root (do **not** create sub-folders).
3. In Overleaf **Menu → Main document**, set it to **`sample-acmsmall.tex`**.
4. Click **Recompile**.

### Files to upload

| File | Role |
|------|------|
| `sample-acmsmall.tex` | **Main file** – compile this one |
| `acmart.cls` | ACM LaTeX class (required) |
| `ACM-Reference-Format.bst` | ACM BibTeX style (required) |
| `references.bib` | Bibliography (168 entries) |
| `introduction.tex` | Section 1 – Introduction |
| `methodology.tex` | Section 2 – Methodology & SLR Protocol |
| `section3.tex` | Section 3 – Taxonomy of PARs |
| `section4.tex` | Section 4 – Task–Paradigm Mapping |
| `section5.tex` | Section 5 – Findings (RQ1–RQ5) |
| `section6.tex` | Section 6 – Related Work |
| `section7.tex` | Section 7 – Threats to Validity |
| `section8.tex` | Section 8 – Conclusion |
| `section9.tex` | Appendix – Primary Studies Table |

> **Important:** keep all files in the **same folder** (the Overleaf project root).  
> Never add `\documentclass` inside section files — they already contain only `\section{...}` content.

---

## How to compile locally

```bash
cd paper
bash build.sh
```

The `paper/` directory contains the canonical source, organised into a `sections/` sub-directory.  
The root-level flat files (`introduction.tex`, `section3.tex`, …) are Overleaf-friendly copies kept in sync.

---

## Paper structure

| # | File | Content |
|---|------|---------|
| 1 | `introduction.tex` | Motivation, RQs, contributions, scope |
| 2 | `methodology.tex` | Search strategy, PRISMA flow, quality assessment |
| 3 | `section3.tex` | PAR taxonomy (PAR-1 … PAR-7) |
| 4 | `section4.tex` | Bidirectional task–paradigm mapping |
| 5 | `section5.tex` | Findings answering RQ1–RQ5 |
| 6 | `section6.tex` | Related work & comparison with prior surveys |
| 7 | `section7.tex` | Threats to validity (Wohlin taxonomy) |
| 8 | `section8.tex` | Conclusion and research agenda |
| A | `section9.tex` | Appendix: complete primary studies table |

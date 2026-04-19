# REFERENCE-JOURNAL-ENSI

## Research Repository for ACM TOSEM 2026 Systematic Literature Review

**Title:** *A Taxonomy of Code Repository Representation Approaches for LLM-Based Software Engineering: A Systematic Literature Review*

**Author:** Riadh Hasnaoui, National School of Computer Science (ENSI)

**Target Venue:** ACM Transactions on Software Engineering and Methodology (TOSEM), Q1

---

## Repository Overview

This repository contains all primary research papers, methodological references, and supporting materials for the above SLR. To facilitate AI-assisted analysis, the full text of all PDF documents has been extracted to the [`extracted_text/`](./extracted_text/) directory.

---

## Repository Structure

```
REFERENCE-JOURNAL-ENSI/
│
├── README.md                                          ← This file
│
├── extracted_text/                                    ← ⭐ Text extracts of all PDFs (AI-readable)
│   ├── reference.txt                                  ← Full bibliography classified PAR-1 to PAR-7 + EVAL
│   ├── related_work.txt                               ← Related Work (Travaux Connexes) section
│   ├── inclusion_exclusion_criteria.txt               ← IC/EC filtering criteria
│   ├── methodology/                                   ← SLR methodology reference documents
│   │   ├── kitchenham_slr_methodology.txt             ← Kitchenham & Charters (2007) SLR guidelines
│   │   ├── thematic_synthesis_steps.txt               ← Cruzes & Dybå (2011) thematic synthesis
│   │   ├── snowballing_wohlin_2014.txt                ← Wohlin (2014) snowballing guidelines
│   │   ├── empirical_standards.txt                    ← ACM SIGSOFT Empirical Standards v0.2
│   │   ├── PRISMA_2020_checklist.txt                  ← PRISMA 2020 reporting checklist
│   │   └── PRISMA_2020_flow_diagram.txt               ← PRISMA 2020 flow diagram template
│   └── papers/                                        ← 159 individual paper text extracts
│
├── Association_for_Computing_Machinery__ACM__...zip   ← ACM TOSEM LaTeX template (Small Standard Format)
│
├── reference.pdf                                      ← Bibliography: PAR-1 to PAR-7 + EVAL sections
├── Related Work(Travaux Connexes).pdf                 ← Related Work references
├── critères d'inclusion exclusion.pdf                 ← Inclusion/Exclusion criteria
├── PRISMA_2020_checklist.pdf                          ← PRISMA 2020 checklist
├── PRISMA_2020_flow_diagram_new_SRs_v2.pdf            ← PRISMA 2020 flow diagram
├── EMPIRICAL STANDARDSfor Software Engineering Research.pdf
├── méthodologie de Kitchenham pour conduire un SLR [...].pdf
├── Recommended_Steps_for_Thematic_Synthesis_in_Software_Engineering.pdf
├── Snowballing — Méthode Wohlin [2014].pdf
│
└── [159 individual research paper PDFs]               ← Primary literature corpus
```

---

## Paper Classification Taxonomy

The `extracted_text/reference.txt` file contains the full bibliography organized into **7 primary categories (PAR)** plus **1 evaluation section**:

### PAR-1 — Repository-Level Code Embedding & Dense Representation
*Dense vector representations of code at repository scale, including pre-trained models and fine-tuned embeddings.*

**Key papers:** CodeBERT (Feng et al., 2020), GraphCodeBERT (Guo et al., 2021), UniXcoder (Guo et al., 2022), LongCoder (Guo et al., 2023), and others covering contrastive learning for code search, cross-file context alignment, and hierarchical context pruning.

### PAR-2 — Retrieval-Augmented Context Construction (RAG cross-file)
*Approaches using retrieval-augmented generation (RAG) to dynamically fetch relevant code snippets and cross-file context for LLM prompting.*

**Key papers:** ReACC (Lu et al., 2022), RepoCoder (Zhang et al., 2023), RepoFusion/CoCoMIC (Ding et al., 2024), Dataflow-guided RAG (Cheng et al., 2024), Repoformer (Wu et al., 2024), and many others.

### PAR-3 — Graph-Based & Structural Representation
*Use of Abstract Syntax Trees (AST), Control Flow Graphs (CFG), Program Dependence Graphs (PDG), call graphs, and code knowledge graphs to represent repository structure.*

**Key papers:** GraphCodeBERT (Guo et al., 2021), CodexGraph (Liu et al., 2025), RepoGraph (Ouyang et al., 2025), GraphCoder (Liu et al., 2024), A³-CodGen (Liao et al., 2024), and others.

### PAR-4 — Execution & Dynamic Representation
*Dynamic context construction via execution traces, runtime information, test results, and compiler feedback.*

**Key papers:** Iterative refinement with compiler feedback (Bi et al., 2024), SWE-bench (Jimenez et al., 2024), test-driven approaches.

### PAR-5 — Memory-Augmented Context
*Agent memory systems (episodic, semantic, procedural) for maintaining persistent repository-level context across interactions.*

**Key papers:** CodePlan (Bairi et al., 2024), MetaGPT (Hong et al., 2023), memory-based coding agents.

### PAR-6 — Compression & Summarization
*Context window management through hierarchical summarization, code chunking, compression, and selective retrieval.*

**Key papers:** Hierarchical Repository Summarization (Dhulshette et al., 2025), LongCodeZip (Shi et al., 2025), context pruning approaches.

### PAR-7 — Agentic & Iterative Context Exploration
*Multi-agent frameworks, iterative search strategies, and autonomous navigation of code repositories.*

**Key papers:** SWE-agent (Yang et al., 2024), AutoCodeRover (Zhang et al., 2024), CodeAgent (Zhang et al., 2024), OpenHands (Wang et al., 2025), SWE-Search (Antoniades et al., 2024), and many others.

### SECTION: Evaluation Infrastructure & Benchmarks
*Benchmarks and evaluation frameworks for repository-level SE tasks.*

**Key papers:** SWE-bench (Jimenez et al., 2024), RepoBench (Liu et al., 2024), CrossCodeEval (Ding et al., 2023), DevEval (Li et al., 2024), REPOCOD (Liang et al., 2025), and many others.

---

## Related Work

The `extracted_text/related_work.txt` file contains references for the Related Work section (Travaux Connexes), including:

- Hou et al. (2024) — *Large Language Models for Software Engineering: A Systematic Literature Review*. ACM TOSEM.
- Husein et al. (2025) — *Large Language Models for Code Completion: A Systematic Literature Review*. Computer Standards & Interfaces.
- Jiang et al. (2026) — *A Survey on Large Language Models for Code Generation*. ACM TOSEM.
- Tao et al. (2026) — *Retrieval-Augmented Code Generation: A Survey with Focus on Repository-Level Approaches*. arXiv.
- Zhang et al. (2026) — *A Survey on Large Language Models for Software Engineering*. Science China Information Sciences.

---

## Inclusion / Exclusion Criteria (Summary)

See full criteria in `extracted_text/inclusion_exclusion_criteria.txt`.

### Inclusion Criteria (IC)
| ID | Criterion |
|----|-----------|
| **IC1** | Proposes, implements, or empirically evaluates a method for repository-level context extraction/representation for LLM-based SE |
| **IC2** | Targets at least one of: Code Completion (O1), Code Generation (O2), Code Search (O3), Bug Fixing (O4), Refactoring/Translation (O5), Test Generation (O6), Code Review/Analysis (O7) |
| **IC3** | Published in a recognized peer-reviewed venue (ICSE, FSE, ASE, ISSTA, NeurIPS, ICML, ICLR, ACL, TSE, TOSEM, etc.) or arXiv pre-print meeting maturity conditions |

### Exclusion Criteria (EC)
| ID | Criterion |
|----|-----------|
| **EC1** | Purely new LLM architecture / pre-training / RLHF — no repo context mechanism |
| **EC2** | Works only at function/class/snippet level — no cross-file or project-level scope |
| **EC3** | No empirical evaluation (position papers, tutorials, extended abstracts) |
| **EC4** | Secondary study (SLR, survey, mapping study) — kept only for Related Work |
| **EC5** | Out of scope domain (cybersecurity, smart contracts, hardware, bioinformatics) |
| **EC6** | Duplicate — only the most recent peer-reviewed version retained |

---

## SLR Methodology

This SLR follows the guidelines of **Kitchenham & Charters (2007)** for systematic literature reviews in Software Engineering, combined with **PRISMA 2020** reporting standards.

### Search Strategy
- **Primary databases:** ACM Digital Library, IEEE Xplore, Springer Link, arXiv, Semantic Scholar
- **Search period:** 2019–2026
- **Snowballing:** Wohlin (2014) guidelines

### Quality Assessment
Evaluated against the ACM SIGSOFT Empirical Standards (v0.2) for Secondary Studies (systematic reviews).

### Synthesis Method
Thematic synthesis following Cruzes & Dybå (2011) — five-step approach adapted for software engineering SLRs.

---

## ACM TOSEM LaTeX Template

The file `Association_for_Computing_Machinery__ACM____Small_Standard_Format_Template.zip` contains the official ACM Small Standard Format template for journal submission to ACM TOSEM.

---

## How to Use This Repository (for AI-Assisted Analysis)

Since AI tools cannot read binary PDF files directly, all document content has been extracted to plain text files in the `extracted_text/` directory:

1. **To analyze the full bibliography classification:** Read `extracted_text/reference.txt`
2. **To access Related Work references:** Read `extracted_text/related_work.txt`
3. **To check inclusion/exclusion criteria:** Read `extracted_text/inclusion_exclusion_criteria.txt`
4. **To read any individual paper:** Find the corresponding `.txt` file in `extracted_text/papers/`
5. **For SLR methodology:** Read files in `extracted_text/methodology/`

---

## Citation

If you use or reference materials from this repository, please cite the corresponding paper once published.

**Hasnaoui, Riadh.** *A Taxonomy of Code Repository Representation Approaches for LLM-Based Software Engineering: A Systematic Literature Review.* ACM Transactions on Software Engineering and Methodology (TOSEM), 2026 (under review).

---

*National School of Computer Science (ENSI), Tunisia*

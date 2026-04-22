PARTIE 1 — CRITÈRES DE FILTRAGE (IC/EC)

IC1 — PARADIGME DE REPRÉSENTATION REPOSITORY

L'étude propose, implémente ou évalue empiriquement une méthode d'extraction et de représentation du contexte à l'échelle d'un dépôt de code (repository-level context) pour alimenter un LLM dans une tâche automatisée d'ingénierie logicielle.

Exemples inclus ✅ : RAG inter-fichiers (cross-file), graphes de dépendances globaux, résumés hiérarchiques de projets, mémoires d'agents, traces d'exécution multi-modules.

IC2 — OBJECTIF SE COUVERT

L'étude cible explicitement et évalue au moins l'un des 7 objectifs d'ingénierie logicielle suivants :

O1 : Code Completion (Complétion de code)

O2 : Code Generation (Génération de code à partir d'issues/NL)

O3 : Code Search (Recherche de code / Localisation de fonctionnalités)

O4 : Bug Fixing / Issue Resolution (Correction de bugs)

O5 : Refactoring / Code Translation (Traduction ou restructuration de code)

O6 : Test Generation (Génération de tests multi-fichiers)

O7 : Code Review / Code Analysis (Analyse statique et revue)

IC3 — QUALITÉ DE LA PUBLICATION ET LITTÉRATURE GRISE

Les études doivent être validées par les pairs (peer-reviewed) dans une conférence ou revue reconnue de premier plan dans les domaines du Génie Logiciel (SE), des Langages de Programmation (PL) ou de l'Intelligence Artificielle / Traitement du Langage Naturel (AI/NLP) :

Niveau A (Top-Tier Conferences) :  
Génie Logiciel & PL : ICSE, FSE, ASE, ISSTA, PLDI.

Intelligence Artificielle, NLP & Data : NeurIPS, ICML, ICLR, ACL, EMNLP, NAACL, AAAI, KDD.

Inclusions explicites des sous-tracks majeurs : Les tracks de type "Findings" (ACL Findings, NAACL Findings), les sessions "Datasets and Benchmarks" (NeurIPS D\&B), les "System Demonstrations" (EMNLP Demos) ainsi que les actes complémentaires officiels (ICSE-Companion, FSE Companion).

Niveau A & Revues Q1 (Excellence) :

Revues Majeures : TSE, TOSEM, TOIS, EMSE, ESWA (Q1, IF ≥ 7.5).

Conférences : MSR, ICSME, SANER, FORGE, ESEM, LREC-COLING.

Niveau B (Conférences et Revues Solides en SE) : APSEC, ICPC, SCAM, EASE, JSS (Journal of Systems and Software), IST (Information and Software Technology).

Workshops Officiels (co-localisés avec des venues A/A) :

Sont acceptés les ateliers spécialisés bénéficiant d'un peer-review rigoureux sous l'égide de grandes conférences, tels que : LLM4Code (@ ICSE), ASEW (@ ASE), ISSREW (@ ISSRE).  
Exception pour la Littérature Grise (arXiv / Pre-prints) : Étant donné la vélocité extrême du domaine des LLMs appliqués au code, un pre-print n'est inclus que s'il remplit rigoureusement l'une des deux conditions empiriques suivantes :

Condition A (Pre-prints matures, \> 12 mois) : L'article possède ≥ 50 citations, ce qui atteste d'une validation par l'impact communautaire compensant l'absence de peer-review formel.

Condition B (Pre-prints récents, ≤ 12 mois) : L'article est évalué sur un benchmark standardisé et public (ex. SWE-bench, RepoEval, CrossCodeEval) ET fournit des artefacts ouverts et reproductibles (dépôt GitHub public contenant le code source de l'approche).CRITÈRES D'EXCLUSION (EC)

EC1 — ARCHITECTURE LLM PURE

La contribution principale est strictement limitée à la proposition d'une nouvelle architecture de modèle fondamental, d'une méthode de pré-entraînement ou d'un fine-tuning (ex. RLHF), sans mécanisme spécifique d'extraction ou de structuration du contexte du dépôt de code.

EC2 — GRANULARITÉ INSUFFISANTE

L'approche opère exclusivement au niveau d'une fonction, d'une classe ou d'un snippet de code isolé (standalone), sans aucune capacité démontrée à ingérer ou exploiter un contexte inter-fichiers (cross-file) ou à l'échelle du projet.

EC3 — PAS D'ÉVALUATION EMPIRIQUE

Le document est purement théorique, est un position paper, un tutoriel ou un résumé (extended abstract) ne présentant aucune expérience ni évaluation quantitative sur des données ou des dépôts de code réels.

EC4 — ÉTUDE SECONDAIRE

Le document est une revue systématique de la littérature (SLR), un mapping study, un survey ou une méta-analyse. (Note : Ces études seront exclues du corpus primaire mais conservées pour enrichir la section "Related Work" et effectuer du Snowballing).

EC5 — DOMAINE HORS SCOPE

L'application cible un domaine trop spécifique ou non généralisable au génie logiciel classique (ex. détection de vulnérabilités en cybersécurité, smart contracts/blockchain, conception hardware/Verilog, bioinformatique, ou NLP général sans lien direct avec le code source).

EC6 — DOUBLON

Il s'agit d'une version antérieure ou d'un doublon d'une étude déjà incluse. Dans ce cas, seule la version la plus récente et validée par les pairs est conservée dans le corpus final.


\#\# RETRIEVAL-AUGMENTED CODE GENERATION: A SURVEY WITH

\#\# FOCUS ON REPOSITORY-LEVEL APPROACHES

\`\`\`  
Yicheng Tao  
Carnegie Mellon University  
yichengtao@cmu.edu  
\`\`\`  
\`\`\`  
Yao Qin  
Chinese University of Hong Kong  
1155240806@link.cuhk.edu.hk  
\`\`\`  
\`\`\`  
Yepang Liu∗  
Southern University of Science and Technology  
liuyp1@sustech.edu.cn  
\`\`\`  
\#\# ABSTRACT

\`\`\`  
Recent advancements in large language models (LLMs) have substantially improved automated  
code generation. While function-level and file-level generation have achieved promising results,  
real-world software development typically requires reasoning across entire repositories. This gives  
rise to the challenging task of Repository-Level Code Generation (RLCG), where models must  
capture long-range dependencies, ensure global semantic consistency, and generate coherent code  
spanning multiple files or modules. To address these challenges, Retrieval-Augmented Generation  
(RAG) has emerged as a powerful paradigm that integrates external retrieval mechanisms with LLMs,  
enhancing context-awareness and scalability. In this survey, we provide a comprehensive review  
of research on Retrieval-Augmented Code Generation (RACG), with an emphasis on repository-  
level approaches. We categorize existing work along several dimensions, including generation  
strategies, retrieval modalities, model architectures, training paradigms, and evaluation protocols.  
Furthermore, we summarize widely used datasets and benchmarks, analyze current limitations, and  
outline key challenges and opportunities for future research. Our goal is to establish a unified  
analytical framework for understanding this rapidly evolving field and to inspire continued progress  
in AI-powered software engineering.  
\`\`\`  
\#\# 1 Introduction

\`\`\`  
Recent advances in Large Language Models (LLMs) have transformed natural language processing and increasingly  
reshaped software engineering. General-purpose models such as GPT-5 \[ 1 \], Claude Opus 4.1 \[ 2 \], and Gemini 2\.  
Pro \[ 3 \] now achieve state-of-the-art results on benchmarks like SWE-Bench \[ 4 \], while code-oriented LLMs including  
CodeLlama \[ 5 \], Qwen-Coder \[ 6 \], and StarCoder \[ 7 \] demonstrate strong syntactic and semantic code understanding.  
IDE-integrated assistants such as GitHub Copilot \[ 8 \], Cursor \[ 9 \], and Windsurf \[ 10 \] also exemplify this trend, offering  
real-time suggestions and in-context explanations. More recently, agent-based systems like OpenAI Codex \[ 11 \], Gemini  
CLI \[12\], and Claude Code \[13\] further push toward autonomous, workflow-driven programming support.  
\`\`\`  
\`\`\`  
Despite this progress, most deployed systems rely on shallow retrieval (e.g., file- or text-based search) and struggle with  
repository-scale reasoning. Strong models may already “memorize” common libraries, while weaker ones suffer from  
context overload \[ 14 \]. In practice, large software projects consist of interdependent modules distributed across many  
files—posing challenges in long-range dependency modeling, global semantic consistency, and cross-file reasoning.  
This motivates the emerging field of Repository-Level Code Generation (RLCG), which emphasizes holistic reasoning  
over entire repositories (Figure 1).  
\`\`\`  
\`\`\`  
Scaling model size or context length only partially addresses RLCG’s issues and is infeasible for most locally  
deployed models. Privacy and compliance further restrict cloud-based deployment, as proprietary code cannot be  
∗Corresponding author.  
\`\`\`  
\# arXiv:2510.04905v2 \[cs.SE\] 25 Jan 2026

\`\`\`  
Write a quick sort algorithm.  
\`\`\`  
\`\`\`  
............  
def authenticate(username, password):  
for user in registered\_users:  
if user.username \== username:\# Code to be completed  
if user.password\_hash \==  
hash\_password(password):  
\`\`\`  
(^) \*\*return Falsereturn True  
............\*\*  
user.py utils.py  
\*\*def quick\_sort(arr):  
if len(arr) \<= 1:  
return arr else:  
pivot \= arr\[len(arr) // 2\]  
less \= \[x for x in arr if x \< pivot\] equal \= \[x for x in arr if x \== pivot\]  
greater \= \[x for x in arr if x \> pivot\] return quick\_sort(less) \+ equal \+  
quick\_sort(greater)\*\*  
General Code Generation Repository-Level Code Generation  
main.py  
Figure 1: Comparison between General Code Generation and Repository-Level Code Generation  
safely transmitted or stored externally \[ 15 , 16 \]. Meanwhile, most LLMs are trained primarily on public, outdated  
repositories \[17\], limiting adaptability to enterprise settings.  
A promising alternative is Retrieval-Augmented Generation (RAG), which dynamically retrieves relevant content to  
construct context-aware prompts. RAG improves scalability, interpretability, and explainability while reducing reliance  
on model memorization. Extending this idea to software engineering yields Retrieval-Augmented Code Generation  
(RACG), encompassing sparse, dense, and graph-based retrieval as well as agent-style pipelines integrating static  
analysis and iterative reasoning \[18, 19, 20, 21\].  
Despite growing attention, existing surveys mainly focus on snippet-level generation or general software engineering  
tasks \[ 22 , 23 \], with limited discussion of retrieval-based or repository-level methods \[ 24 , 25 , 26 , 27 , 28 \]. To bridge  
this gap, we present a comprehensive review of Retrieval-Augmented Code Generation (RACG), with emphasis  
on Repository-Level techniques. We categorize existing works by retrieval strategies, generation architectures,  
backbone models, benchmarks, and application domains, and identify open challenges such as long-range reasoning,  
privacy-preserving retrieval, and repository-wide consistency.  
Key Contributions.

\- We present the first comprehensive survey on Retrieval-Augmented Code Generation (RACG), emphasizing  
    repository-level reasoning challenges.  
\- We classify RACG methods by retrieval, integration, and generation strategies, providing a structured taxonomy of  
    the field.  
\- We compare representative models and benchmarks across major design dimensions.  
\- We highlight open research directions, including multimodal generation, efficient context construction, and  
    fine-grained evaluation.

\#\# 2 Preliminaries

This section defines key concepts and terminology central to this survey, distinguishing Repository-Level Code  
Generation (RLCG) from traditional code generation and outlining the components of Retrieval-Augmented Code  
Generation (RACG) frameworks.

2.1 Repository-Level Code Generation (RLCG)

Repository-Level Code Generation involves generating, modifying, or reasoning about code across an entire software  
repository rather than isolated snippets. Unlike function- or file-level tasks, RLCG tackles large, multi-module, and  
interdependent codebases—reflecting real-world software complexity.

Typical applications include:

\- Cross-file Code Completion: Predicting or synthesizing missing code segments by leveraging repository-wide  
    context, from single lines to full functions.  
\- Issue or PR Resolution: Automatically fixing reported problems by locating relevant files and generating patches  
    consistent with project conventions.

\`\`\`  
Open-source/  
Private  
Repository  
\`\`\`  
\`\`\`  
Relevant  
Code Snippets  
\`\`\`  
\`\`\`  
Code Task  
\`\`\`  
\`\`\`  
Generator  
\`\`\`  
\`\`\`  
Code Completion  
soup \= BeautifulSoup(  
response.text,  
"html.parser")  
\`\`\`  
\`\`\`  
Github Issue  
Resolution  
Safetensors import of  
Gemma3 fails  
Sparse Dense Graph quantization \> 0.6.5.  
\`\`\`  
\`\`\`  
Retriever  
\`\`\`  
\`\`\`  
Input Context Downstream Tasks  
\`\`\`  
\`\`\`  
GenerationStrategy  
Word index Code Vector Code Graph  
\`\`\`  
\`\`\`  
Code Base Retrieval Strategy  
\`\`\`  
\`\`\`  
Figure 2: Retrieval-Augmented Code Generation, focusing on Repository-Level approaches.  
\`\`\`  
Other relevant tasks include test generation, bug fixing, program repair, and large-scale refactoring. Overall, RLCG  
demands reasoning over long-range dependencies, maintaining global consistency, and supporting incremental evo-  
lution. It bridges software engineering and language modeling, marking a step toward intelligent, repository-aware  
programming assistants.

2.2 Retrieval-Augmented Code Generation (RACG)

Retrieval-Augmented Code Generation enhances LLMs with external software knowledge via retrieval. Unlike pure  
LLM generation, RACG dynamically retrieves relevant information—such as code, documentation, or graphs—to  
construct context-aware prompts.

For repository-level tasks, RACG enables models to integrate long-range knowledge without exceeding context limits.  
A typical RACG pipeline consists of:

\- Retriever: Selects relevant repository content given a query or partial code. Common approaches include:  
    \- Identifier Matching: Exact name or signature matching.  
    \- Sparse Retrieval: Uses lexical or sparse-vector matching (e.g., TF-IDF, BM25).  
    \- Dense Retrieval: Neural embeddings (e.g., CodeBERT, UniXcoder) with nearest-neighbor search.  
    \- Graph-based Retrieval: Utilizing ASTs, call graphs via traversal or subgraph matching.  
    \- Hybrid Retrieval: Combining lexical, embedding, and structural signals for balanced precision and recall.  
\- Generator: A language model (e.g., GPT-4o, CodeLlama) that synthesizes code using retrieved context for  
    semantically consistent generation.

Different retrieval strategies affect the granularity and quality of generation: vector-based retrieval offers efficiency  
but limited structural insight, while graph-based methods better capture dependencies and consistency. Recent work  
explores iterative or agent-style RACG frameworks, where retrieval and generation proceed in multi-step reasoning or  
tool-based loops \[18, 29\].

Overall, RACG provides a modular and extensible foundation that bridges the gap between LLMs and the large-scale,  
structured nature of modern software repositories.

\#\# 3 Methodology

This section outlines the methodology used to conduct a systematic literature review. We adopt a structured review  
approach inspired by established guidelines in software engineering literature \[ 30 , 27 , 22 \]. The methodology encom-  
passes research question formulation, data collection, inclusion and exclusion filtering, quality assessment, snowballing,  
and topic categorization.

3.1 Research Questions

To define the scope and guide the review process, we formulate the following research questions (RQs), each targeting a  
key dimension of the evolving research landscape in Retrieval-Augmented Code Generation.

(^1) From 2017 to 2023, FSE was jointly held with ESEC under the name The ACM Joint European Software Engineering Conference  
and Symposium on the Foundations of Software Engineering (ESEC/FSE). Since 2024, it has been held independently as The ACM  
International Conference on the Foundations of Software Engineering (FSE).

\- RQ1: How is Retrieval-Augmented Generation applied to code, and what innovations exist?  
    This question investigates how RAG techniques are adapted for both code-level and repository-level generation  
    scenarios. It encompasses the design of retrieval modules, fusion strategies, training paradigms, and agent  
    architectures that enhance long-range dependency modeling and global code consistency.  
\- RQ2: What are the core settings and evaluation practices in Repository-Level Code Generation?  
    This question examines the general setup of RLCG systems, covering downstream task types, supported program-  
    ming languages, and backbone model choices. It also discusses how evaluation benchmarks and metrics reflect  
    practical software development demands.  
\- RQ3: What are the main bottlenecks and future directions for Retrieval-Augmented Code Generation?  
    This question identifies current limitations in RACG research, including retrieval noise, graph complexity, and  
    scalability challenges. It further explores emerging directions that bridge the gap between research prototypes and  
    real-world software engineering applications.

\`\`\`  
3.2 Data Collection Process  
\`\`\`  
\`\`\`  
To address our research questions and construct a comprehensive corpus on RACG, we adopted a two-stage data  
collection pipeline.  
\`\`\`  
We first manually reviewed recent publications from leading AI and software engineering venues (e.g., ICLR, NeurIPS,  
ICML, IJCAI, AAAI, JMLR, ACL, EMNLP, ICSE, FSE, ASE, TOSEM, TSE, ISSTA) to identify key studies potentially  
missed by keyword search. From this step, we derived and refined a set of search terms strongly related to RACG.  
Next, we conducted automated searches using the finalized keywords across multiple bibliographic platforms, including  
ACM Digital Library, IEEE Xplore, arXiv, OpenReview, and the ACL Anthology. Searches were restricted to titles and  
abstracts to ensure cross-platform consistency. The search period spanned from January 1, 2023 to August 31, 2025,  
covering work released after ChatGPT’s public debut. This process produced 579 candidate papers, screened according  
to the criteria in Section 3.3.

\`\`\`  
3.3 Inclusion and Exclusion Criteria  
\`\`\`  
\`\`\`  
A paper was included if it met all of the following:  
\`\`\`  
\- The task involves retrieval-augmented, cross-file, or repository-level settings that enhance code generation.  
\- The study proposes a novel RAG-based approach or analyzes retrieval’s impact on generation quality.  
\- The full text is accessible and written in English.

\`\`\`  
A paper was excluded if it:  
\`\`\`  
\- Focuses solely on standalone code generation or static analysis tools without pretrained LMs.  
\- Uses RAG only as a minor component without methodological contribution.  
\- Targets tasks like vulnerability or clone detection, or purely retrieval model training without generation.  
\- Presents only conceptual discussions or ethical commentary without technical contributions.

\`\`\`  
3.4 Quality Assessment  
\`\`\`  
\`\`\`  
37.3%  
\`\`\`  
\`\`\`  
8.2%  
\`\`\`  
\`\`\`  
5.5% 5.5%  
5.5%  
4.5%  
3.6%  
3.6%  
1.8%  
1.8%  
1.8%  
1.8%  
1.8%1.8%  
1.8%  
13.6%  
\`\`\`  
\`\`\`  
ArXiv(41)  
\`\`\`  
\`\`\`  
ACL(9)  
\`\`\`  
\`\`\`  
ICSE(6) FSE(6)  
ASE(6)  
EMNLP(5)  
\`\`\`  
\`\`\`  
ICML(4)  
\`\`\`  
\`\`\`  
ICLR(4)  
ISSTA(2)  
TSE(2)  
NIPS(2)  
NAACL(2)  
COLM(2)  
TOSEM(2)  
COLING(2)  
\`\`\`  
\`\`\`  
Others(15)  
\`\`\`  
\`\`\`  
Total: 110 papers  
\`\`\`  
\`\`\`  
Venues  
ArXiv  
ACL  
FSE  
ICSE  
ASE  
EMNLP  
ICML  
ICLR  
ISSTA  
TSE  
NIPS  
NAACL  
COLM  
TOSEM  
COLING  
Others  
\`\`\`  
\`\`\`  
Figure 3: Distribution of selected RACG papers.  
\`\`\`  
\`\`\`  
Each paper was evaluated for: (1) relevance to RACG,  
(2) methodological clarity, (3) retrieval–generation in-  
tegration, and (4) reproducibility. Works failing these  
criteria were excluded. For arXiv papers, we required a  
detailed method section and solid experimental results.  
\`\`\`  
\`\`\`  
3.5 Snowballing and Final Corpus  
\`\`\`  
\`\`\`  
Backward snowballing was applied to identify founda-  
tional and related works missed by keyword searches.  
After screening and quality checks, 110 papers were  
retained, covering intersections of software engineering,  
NLP, and machine learning.  
\`\`\`  
\#\#\# 4

\`\`\`  
0 1 2 3 4 5  
\`\`\`  
\`\`\`  
University of Illinois Urbana-Champaign 4  
\`\`\`  
\`\`\`  
Nanyang Technological University 4  
\`\`\`  
\`\`\`  
Carnegie Mellon University 4  
\`\`\`  
\`\`\`  
University of Chinese Academy of Sciences 5  
\`\`\`  
\`\`\`  
Peking University 5  
\`\`\`  
\`\`\`  
Zhejiang University 5  
\`\`\`  
\`\`\`  
Top Universities  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6  
\`\`\`  
\`\`\`  
ByteDance 2  
\`\`\`  
\`\`\`  
Salesforce 2  
\`\`\`  
\`\`\`  
Amazon 3  
\`\`\`  
\`\`\`  
Alibaba 3  
\`\`\`  
\`\`\`  
Ant Group 3  
\`\`\`  
\`\`\`  
Microsoft 6  
\`\`\`  
\`\`\`  
Top Companies  
\`\`\`  
\`\`\`  
Figure 4: Top contributing institutions in RACG research.  
\`\`\`  
\`\`\`  
3.6 Topic Categorization and Analysis  
\`\`\`  
We manually annotated each paper by task, architecture,  
retrieval method, and target domain, forming the basis  
for the taxonomy and trend analyses presented later.  
Figure 3 shows that arXiv dominates with 41 papers (37.3%), followed by top-tier venues such as ACL, FSE, ICSE, and  
ASE. This reflects the fast publication cycle in software engineering and the growing integration of code generation  
within AI research.  
Institutionally, leading contributors include Zhejiang University, Peking University, UCAS, Carnegie Mellon University,  
and major industry labs such as Microsoft, Alibaba, and Ant Group. While Chinese institutions dominate numerically,  
the field is globally collaborative, with active participation from North America, Europe, and Singapore.

\#\# 4 Literature Review

\`\`\`  
This section surveys recent advances in Retrieval-Augmented Code Generation (RACG), with particular emphasis  
on repository-level settings. Our survey is organized around three core research questions, which together provide a  
structured understanding of how retrieval-augmented paradigms enhance code generation capabilities across scales, as  
illustrated in Figure 5\.  
RQ1 (RACG Adaptation & Innovations) explores how retrieval-augmented generation techniques are applied and  
extended in code contexts. This includes analyses of retrieval strategies (4.1), training paradigms (4.2), and agent  
architectures (4.3), which together reveal innovations for improving long-range dependency and global consistency.  
\`\`\`  
\`\`\`  
RQ1: RACG RQ1: RACG RQ1: RACG RQ1: RACG RQ1: RACG Adaptation & InnovationsAdaptation & InnovationsAdaptation & InnovationsAdaptation & InnovationsAdaptation & Innovations  
\`\`\`  
\`\`\`  
RQ2: RLCG Core Settings & EvaluationRQ2: RLCG Core Settings & EvaluationRQ2: RLCG Core Settings & EvaluationRQ2: RLCG Core Settings & EvaluationRQ2: RLCG Core Settings & Evaluation  
\`\`\`  
\`\`\`  
RQ3: Bottlenecks & Future DirectionsRQ3: Bottlenecks & Future DirectionsRQ3: Bottlenecks & Future DirectionsRQ3: Bottlenecks & Future DirectionsRQ3: Bottlenecks & Future Directions  
\`\`\`  
\`\`\`  
4.1 RAG Strategies4.1 RAG Strategies4.1 RAG Strategies4.1 RAG Strategies4.1 RAG Strategies  
\`\`\`  
\`\`\`  
4.2 Training Paradigms4.2 Training Paradigms4.2 Training Paradigms4.2 Training Paradigms4.2 Training Paradigms  
\`\`\`  
\`\`\`  
4.3 Agent 4.3 Agent 4.3 Agent 4.3 Agent 4.3 Agent ArchitecturesArchitecturesArchitecturesArchitecturesArchitectures  
\`\`\`  
\`\`\`  
4.4 Downstream 4.4 Downstream 4.4 Downstream 4.4 Downstream 4.4 Downstream TasksTasksTasksTasksTasks  
\`\`\`  
\`\`\`  
4.5 Programming Language Support4.5 Programming Language Support4.5 Programming Language Support4.5 Programming Language Support4.5 Programming Language Support  
\`\`\`  
\`\`\`  
4.6 Backbone Models4.6 Backbone Models4.6 Backbone Models4.6 Backbone Models4.6 Backbone Models  
\`\`\`  
\`\`\`  
5.1 Limitations5.1 Limitations5.1 Limitations5.1 Limitations5.1 Limitations  
\`\`\`  
\`\`\`  
5.2 Future Directions5.2 Future Directions5.2 Future Directions5.2 Future Directions5.2 Future Directions  
\`\`\`  
\`\`\`  
Figure 5: Mapping between research questions and corresponding sur-  
vey sections. Each flow indicates the relationship between a specific RQ  
and the sections that address it, providing a clear roadmap for readers to  
navigate the survey content.  
\`\`\`  
\`\`\`  
RQ2 (RLCG Settings & Evaluation) fo-  
cuses on the general setup of repository-level  
code generation, examining downstream task  
formulations (4.4), supported programming  
languages (4.5), and backbone models for re-  
trieval and generation (4.6). This perspective  
highlights how evaluation benchmarks and  
technical choices reflect real-world software  
development requirements.  
RQ3 (Bottlenecks & Future Directions)  
identifies major challenges and open prob-  
lems and further discusses emerging opportu-  
nities, as detailed in our analyses of current  
limitations (5.1) and prospective directions  
(5.2). While nearly every section touches on  
issues relevant to RQ3, we summarize here  
only the most direct contributions.  
Specifically, in this section, we examine  
the design of retrieval strategies, contrasting  
\`\`\`

non-graph-based and graph-based approaches  
alongside hybrid pipelines. We analyze how training paradigms—ranging from fine-tuning to reinforcement learn-  
ing—enhance RACG performance by aligning retrieval and generation modules. We discuss the growing application  
of agent-based architectures, which introduce iteration, tool usage, and autonomy into RACG systems. Additionally,  
we analyze representative downstream tasks and benchmark datasets that support systematic evaluation, summarize  
programming language coverage in current studies, and review the backbone models adopted for retrieval and generation.

Through this structured taxonomy, we identify common patterns and design choices, as well as gaps in retrieval  
precision, training methodology, evaluation realism, and deployment readiness. This analysis not only contextualizes  
existing research but also establishes a foundation for identifying promising future directions in software engineering.

4.1 RAG Strategies

Retrieval-Augmented Code Generation methods can be broadly categorized into two major paradigms: non-graph-  
based and graph-based implementations. Each offers distinct advantages and recent advances have seen increasing  
convergence between the two. Hybrid approaches are grouped according to their predominant reliance on graph-based  
or non-graph-based components.

Non-graph-based RAG approaches typically retrieve relevant code snippets, comments, or documentation based on  
lexical similarity (including basic identifier matching) or semantic similarity via dense embeddings. Importantly,  
recent developments have significantly extended the capabilities of non-graph-based methods. Many now incorporate  
additional contextual signals, such as file paths, surrounding code blocks, dependency metadata, or even pseudo-  
structural cues. This evolution has transformed non-graph-based retrieval into a sophisticated and adaptable framework,  
capable of supporting complex, repository-level tasks.

In contrast, graph-based RAG methods leverage the inherently structured nature of code to construct explicit graph  
representations, such as Abstract Syntax Trees (ASTs), data-flow graphs, or dependency graphs. Nodes typically  
represent code entities (e.g., functions, classes, variables), while edges encode relationships such as function calls,  
inheritance, import statements, or data/control flow. By exploiting graph connectivity and traversal patterns, graph-based  
methods enable more structurally grounded and contextually precise retrieval, which is particularly beneficial for tasks  
requiring global reasoning, such as cross-file completion or multi-module consistency checking. While graph-based  
methods offer high fidelity and structural awareness, they also introduce challenges in preprocessing, graph maintenance,  
and computational overhead—especially when applied to large-scale, heterogeneous repositories.

\`\`\`  
Ultimately, non-graph-based and graph-based RAG approaches represent two complementary and increasingly  
interconnected research directions. The former emphasizes flexibility, generality, and ease of deployment; the  
latter offers fine-grained structural reasoning and improved semantic alignment. Ongoing work in this space  
increasingly explores hybrid designs that integrate structural priors into lightweight retrieval pipelines, reflecting  
a broader trend toward unifying semantics and scalability in RACG systems.  
\`\`\`  
4.1.1 Non-Graph-based RAG

Non-graph-based RAG methods retrieve relevant code snippets or documentation without explicitly constructing or  
relying on graph representations. Traditionally, these approaches treat the code repository as a flat collection of text  
segments—typically functions, files, or documentation blocks—and retrieve relevant chunks via lexical or semantic  
similarity. Early systems relied on simple identifier matching and classical lexical retrieval techniques such as BM25 \[ 98 \]  
or Jaccard similarity \[ 99 \], and more recent efforts leverage dense retrieval models such as GraphCodeBERT \[ 100 \] or  
UniXcoder \[101\] to perform embedding-based matching.

While originally lightweight and straightforward to implement as it’s universally adopted in RAG systems in various  
domains, non-graph-based approaches specialized in code have evolved substantially. Modern RACG systems often  
enhance basic retrieval pipelines through optimization along three main axes: retrieval strategies, retrieval content  
construction, and static analysis integration.

Retrieval Strategy Optimization. Numerous works focus on improving retrieval effectiveness through architectural  
or algorithmic innovations. Early efforts such asReACC\[ 31 \],CEDAR\[ 32 \] andRAP-Gen\[ 33 \] integrate hybrid retrieval  
(BM25 \+ dense embeddings) to balance precision and recall.RepoCoder\[ 18 \], a foundational work in RACG, introduces  
iterative retrieval, where retrieved context is progressively refined over multiple rounds.CODEGENAPI\[ 34 \] targets  
private repositories by retrieving potentially useful APIs.kNM-LM\[ 35 \] decouples the domain database from the language  
model (storing only tokens the LM fails to predict) and applies Bayesian inference to combine database outputs with

RAG Strategies

\`\`\`  
Non-Graph-based  
\`\`\`  
\`\`\`  
Retrieval Strategy  
Optimization  
\`\`\`  
\`\`\`  
Pioneer Strategies  
\`\`\`  
\`\`\`  
ReACC \[31\], CEDAR \[32\], RAP-Gen \[33\],  
RepoCoder \[18\], CODEGENAPI \[34\],  
kNM-LM \[35\]  
\`\`\`  
\`\`\`  
Adaptive Retrieval  
& Policy Learning  
\`\`\`  
\`\`\`  
kNN-TRANX \[36\], ProCC \[37\], FT2Ra \[38\],  
ARCS \[39\], CODEFILTER \[40\],  
SWE-Fixer \[41\]  
Scalable &  
Information-Efficient  
Context Selection  
\`\`\`  
\`\`\`  
HCP \[42\], RepoMinCoder \[43\]  
\`\`\`  
\`\`\`  
Retrieval Fidelity &  
Structural Awareness  
\`\`\`  
\`\`\`  
CoRet \[44\], CCCI \[45\], HyRACC \[46\],  
De-Hallucinator \[47\], Fedrushkov et al. \[48\]  
\`\`\`  
\`\`\`  
Learning from  
Feedback  
& Self-Expression  
\`\`\`  
\`\`\`  
RepoGenReflex \[49\], SelfRACG \[50\]  
\`\`\`  
\`\`\`  
Low-Resource  
Retrieval RAR \[51\], PERC \[52\]  
\`\`\`  
\`\`\`  
Retrieval Content  
Construction  
\`\`\`  
\`\`\`  
Query Reformulation  
& Multi-Perspective  
Retrieval  
\`\`\`  
\`\`\`  
ProCC \[37\], RLPG \[53\], RRG \[54\],  
ReCo \[55\]  
\`\`\`  
\`\`\`  
(Conversion-based  
Retrieval)  
\`\`\`  
\`\`\`  
SACL \[56\], Kondo et al. \[57\],  
Code2JSON \[58\], Chen et al. \[59\],  
CodeBridge \[60\]  
\`\`\`  
\`\`\`  
Context Structuring  
& Hierarchical  
Construction  
\`\`\`  
\`\`\`  
cAST \[61\], R^2 C^2 \-Coder \[62\],  
A^3 \-CodGen \[63\], RepoFuse \[64\],  
RAMBO \[65\], RepoGenix \[66\]  
\`\`\`  
\`\`\`  
Knowledge Base  
Expansion &  
API Integration  
\`\`\`  
\`\`\`  
EVOR \[67\], AllianceCoder \[68\],  
Deng et al. \[69\]  
\`\`\`  
\`\`\`  
Static Analysis  
Integration  
\`\`\`  
\`\`\`  
STALL+ \[70\], MGD \[71\], IDECoder \[72\],  
CatCoder \[73\], RRR \[74\]  
\`\`\`  
\`\`\`  
Graph-based  
\`\`\`  
\`\`\`  
Data or Control Flow  
Involvement  
\`\`\`  
\`\`\`  
DraCo \[75\], CodeGRAG \[76\], GraphCoder \[77\],  
SaraCoder \[78\]  
\`\`\`  
\`\`\`  
Line-level Indexing RepoGraph \[19\], PKG \[79\], GraphCoder \[77\],SaraCoder \[78\]  
\`\`\`  
\`\`\`  
Knowledge Graph  
Utilization  
\`\`\`  
\`\`\`  
ContextModule \[80\], KGCompass \[81\], PKG \[79\],  
Abedu \[82\], Prometheus \[83\]  
\`\`\`  
\`\`\`  
Retrieval Algorithm  
Adaptation  
\`\`\`  
\`\`\`  
RepoHYPER \[84\], AutoCodeRover \[85\],  
LingmaAgent \[86\], CocoGen \[87\], OrcaLoca \[29\],  
DSrepair \[88\], RepoScope \[89\], SaraCoder \[78\]  
\`\`\`  
\`\`\`  
Other Innovations  
\`\`\`  
\`\`\`  
CoCoMIC \[90\], CodeRAG \[91\], CGM \[92\],  
LocAgent \[93\], CoSIL \[94\], HCGS \[95\],  
CodeRCSG \[96\], SynFix \[97\] SaraCoder \[78\]  
\`\`\`  
\`\`\`  
Figure 6: Taxonomy of RAG Strategies.  
\`\`\`

LM predictions. Subsequent works introduce increasingly sophisticated retrieval and context selection mechanisms to  
enhance the adaptability and precision of RACG systems.

(1) Adaptive Retrieval and Policy Learning. Several systems focus on dynamically adjusting retrieval behavior.  
kNN-TRANX\[ 36 \] employs a three-stage optimization process, featuring syntax-constrained token-level retrieval via  
ASDL rules, a meta-k network that adapts retrieval weights using distance and count features, and a confidence network  
that fuses kNN and neural predictions based on confidence- and k-value–aware weighting. ProCC\[ 37 \] leverages  
LinUCB \[ 102 \] for online adaptation of retrieval strategies, whileFT2Ra\[ 38 \] exploits∆logits as retrieval signals,  
simulating fine-tuning effects via adaptive learning rates and multi-round retrieval.ARCS\[ 39 \] introduces an agentic  
mechanism that decomposes complex queries into sub-queries to handle retrieval difficulty adaptively.CODEFILTER\[ 40 \]  
introduces explicit retrieval-control tokens (\<EC\>,\<MC\>) and polarity markers (\<pos\>,\<neg\>,\<neu\>) to guide selective  
context integration.SWE-Fixer\[ 41 \] adopts a coarse-to-fine paradigm, using BM25 for candidate narrowing followed  
by a fine-tuned 7B model (e.g., Qwen2.5) for re-ranking.

(2) Scalable and Information-Efficient Context Selection. To address scalability in large codebases,HCP\[ 42 \]  
proposes hierarchical context pruning to retain structurally relevant functions while discarding unrelated content.  
RepoMinCoder\[ 43 \] formulates context selection as an information-loss minimization problem, identifying the most  
informative subset of code segments under strict length constraints.

(3) Retrieval Fidelity and Structural Awareness. Several methods aim to enhance retrieval precision through structure-  
and semantics-aware optimization.CoRet\[ 44 \] jointly models code semantics, repository structure, and call-graph  
dependencies to improve retrieval fidelity.CCCI\[ 45 \] employs file-level classifiers to ensure contextual consistency,  
whileHyRACC\[ 46 \] fuses probability distributions from both the LM and a token database for adaptive confidence  
calibration.De-Hallucinator\[ 47 \] retrieves project-specific API references to mitigate hallucinations in LLM-based  
generation.Fedrushkov et al.\[ 48 \] introduce explicit indentation tokens to capture syntactic hierarchy and employ  
contrastive learning to eliminate hard negatives during training.

(4) Learning from Feedback and Self-Expression. Beyond traditional retrieval pipelines,RepoGenReflex\[ 49 \]  
builds on a Verbal Reinforcement Learning framework, where a Reflector module produces natural-language feedback  
that is iteratively stored and reused. Similarly,SelfRACG\[ 50 \] enables LLMs to explicitly express their information  
needs, thereby improving self-guided retrieval and contextual grounding.

(5) Low-Resource Retrieval. To support underrepresented programming languages,RAR\[ 51 \] employs a dual-retriever  
design: the driver retriever (RD) first retrieves information from either the example corpus (E) or the document  
grammar library (D), while the influenced retriever (RI) subsequently retrieves the complementary type by leveraging  
the results ofRD, thereby maximizing data utilization in low-resource settings.PERC\[ 52 \] also targets underrepresented  
code by retrieving examples that contain reusable algorithmic plans and converting source code into pseudocode to  
better align low-resource programming languages with high-resource ones.

Retrieval Content Construction. Another line of research improves retrieval effectiveness by enriching or restructur-  
ing the retrieval corpus and query formulation. Typical techniques include context pruning, which selectively retains  
structurally relevant code segments to reduce noise and memory overhead; query rewriting and optimization, where  
initial queries are reformulated (e.g., through prompt engineering or multi-perspective construction) to better capture  
semantic intent; and knowledge base curation and augmentation, which reorganizes repository artifacts or supplements  
missing content (e.g., API descriptions or documentation) to enhance the informativeness of retrieved contexts.

(1) Query Reformulation and Multi-Perspective Retrieval. Several methods focus on improving query expressiveness  
and semantic alignment.ProCC\[ 37 \] proposes a prompt-based multi-perspective retriever, constructing queries from  
lexical semantics, hypothesis lines, and code summaries.RLPG\[ 53 \] defines multiple rule-based strategies to extract  
relevant contexts and trains a predictor to assess whether a candidate context is beneficial for generation.RRG\[ 54 \] adds a  
reconstruction step to mitigate retrieval–generation preference misalignment, thereby improving prompt informativeness.  
ReCo\[ 55 \] rewrites both the query and the codebase using an LLM to ensure stylistic consistency and semantic alignment  
between them.

A related subdirection under query reformulation focuses on conversion-based retrieval, where code or documentation  
is transformed into alternative textual forms to improve semantic compatibility between queries and targets.SACL\[ 56 \]  
mitigates biases through semantically enhanced code reranking (generating functional descriptions of code and fusing  
the retrieval scores of code and descriptions) and contextual localization (generating semantic descriptions for repository  
files).Kondo et al.\[ 57 \] convert code snippets into text using LLMs and adopt a “Pred+Explain” strategy—predicting  
the next line alongside a natural-language explanation—to enhance retrieval quality. Similarly,Code2JSON\[ 58 \] bridges  
the gap between code and natural language by extracting semantic representations through structured parsing.Chen  
et al.\[ 59 \] propose three retrieval strategies: Header2Code (using method headers as queries), NL2Code (using

code comments as queries), and NL2NL (retrieving similar comments and then their associated code), with the last  
strategy yielding the best performance.CodeBridge\[ 60 \] further decomposes query–code matching into two simpler  
tasks—query–comment and code–code matching—to bridge domain gaps.

(2) Context Structuring and Hierarchical Construction. A second direction focuses on reorganizing or compressing  
the retrieval corpus to provide structured and information-dense contexts.cAST\[ 61 \] recursively partitions ASTs and  
merges text nodes into semantically coherent units, preserving both structure and meaning.R^2 C^2 \-Coder\[ 62 \] constructs  
both abstract- and fragment-level retrieval pools and dynamically composes prompts using coarse-grained global  
and fine-grained local contexts.A^3 \-CodGen\[ 63 \] integrates information from local code elements (e.g., functions,  
attributes), cross-file entities, and third-party libraries to enrich prompt construction.RepoFuse\[ 64 \] combines dual  
contexts—similar code and structurally related methods—and applies a rank-truncated generation strategy to compress  
prompt length while preserving informativeness.RAMBO\[ 65 \] further identifies repository-specific “key code elements”  
and related usages to construct highly relevant prompts. Finally,RepoGenix\[ 66 \] employs context-aware selection by  
combining analogous context (dependency-related code) and relevant context (similar code blocks) into fixed-length  
prompts, introducing a relevance score as a proactive filtering criterion.

\`\`\`  
Table 1: Static analysis integration.  
System Usage  
STALL+ \[70\] Cross-file Dependent Contexts used in Prompt Formulation, Decoding Control, Post-processing  
MGD \[71\] Feedback Loop Ensures Generation with Consistent Type, Identifiers, API protocol, Enum Values  
IDECoder \[72\] Retrieve Contexts of Code Element, Project Structure, Developer Intention, Error Feedback  
CatCoder \[73\] Build a Type Dependency Graph to Guide Prompts within Scope for Practicality  
RRR \[74\] Iteratively Refines Context for Undefined Symbols & Dependencies, Class & Member Metadata  
\`\`\`  
(3) Knowledge Base Expansion and API Integration. Another strand of work enhances the retrieval corpus itself  
through adaptive updates or content curation.EVOR\[ 67 \] supports dynamic expansion of knowledge base through  
iterative updates, enabling adaptation to evolving codebases. AllianceCoder\[ 68 \] leverages LLMs to generate  
API-level descriptions as retrieval queries, improving semantic matching for usage-related tasks. AndDeng et  
al.\[ 69 \] retrieve APIs based on LLM-generated code drafts, bypassing explicit import statements to capture implicit  
dependencies.

Static Analysis Integration. To better align retrieval with the actual code semantics, several recent systems in-  
corporate static analysis directly into the retrieval pipeline.STALL+\[ 70 \] integrates static analysis outputs at multi-  
ple stages—including prompt formulation, decoding control, and post-processing—to improve retrieval precision.  
Monitor-Guided Decoding (MGD)\[ 71 \] builds a feedback loop between a static analyzer and the LLM decoder,  
adjusting logits via masking to enforce type-consistent generation.IDECoder\[ 72 \] exploits IDE-level static analysis to  
retrieve precise contexts directly from the repository.CatCoder\[ 73 \] employs a type-dependency graph constructed  
via static analysis to guide prompt composition. Retrieve-Repotools-Reflect (RRR)\[ 74 \] iteratively refines  
repository context via static analysis tools and integrates feedback from test outcomes to improve the quality.

Overall, the non-graph-based paradigm has undergone substantial evolution beyond early lexical retrieval. With the  
integration of advanced dense retrievers, dynamic corpus construction, and static-analysis-guided context selection,  
these systems can now support complex repository-level tasks with impressive flexibility, precision, and scalability.

4.1.2 Graph-based RAG

Graph-based RAG integrates explicit code structure through graph representations. Rather than treating code as a  
flat sequence, these methods encode syntactic and semantic relationships via graphs, enabling more accurate context  
retrieval and improved global consistency during code generation. While each method introduces unique innovations  
and focuses on different aspects, they share several common design principles.

Table 2 provides a systematic comparison of recent graph-based RAG approaches, categorized by the types of nodes  
and edges used in their graph construction. This comparison highlights the structural richness and semantic coverage of  
each method. To facilitate a clearer understanding, we next outline the common edge and node types as well as the  
observed design patterns that underpin these graph constructions.

Edge Types. Edges represent relationships or dependencies between code entities. We consider six common types:

\`\`\`  
Table 2: Comparison of Graph-Based RAG Methods  
\`\`\`  
Method Edge Types Node Types  
Contain Import Inherit Invoke Data F. Ctrl F. DirectoryModule Class Function Line

DraCo \[75\]✓✓✓✓✓×✓✓✓✓×  
RepoGraph \[19\]✓××✓××××✓✓✓  
PKG \[79\]✓××××××××✓✓  
CodeGRAG \[76\]✓××✓✓✓×××✓×  
GraphCoder \[77\]×××✓✓✓××××✓  
CoCoMIC \[90\]✓✓×××××✓✓✓×  
RepoHYPER \[84\]✓✓✓✓×××✓✓✓×  
CodexGraph \[103\]✓×✓✓×××✓✓✓×  
LingmaAgent \[86\]✓×✓✓××✓✓✓✓×  
CocoGen \[87\]✓✓✓××××✓✓✓×  
CodePlan \[104\]✓✓✓✓×××✓✓✓×  
CodeRAG \[91\]✓✓✓✓×××✓✓✓×  
ContextModule \[80\]✓××✓×××✓✓✓×  
CGM \[92\]✓✓✓✓××✓✓✓✓×  
OrcaLoca \[29\]✓××✓××✓✓✓✓×  
LocAgent \[93\]✓✓✓✓××✓✓✓✓×  
CoSIL \[94\]✓✓✓✓××✓✓✓✓×  
KGCompass \[81\]✓××✓×××✓✓✓×  
AutoCodeRover \[85\]✓××××××✓✓✓×  
Mihir et al. \[105\]✓××××××✓✓✓×  
SWE-Debate \[106\]✓✓✓✓××××✓✓×  
HCGS \[95\]✓✓✓✓×××✓✓✓×  
Prometheus \[83\]✓×××××✓✓✓✓×  
RepoScope \[89\]✓✓✓✓××××✓✓×  
SynFix \[97\]✓✓×✓××✓✓✓✓×  
SaraCoder \[78\]✓✓××✓✓×✓✓✓×

\- Contain: Captures structural inclusion, most commonly representing classes containing functions. Methods that  
    model inclusion relationships across multiple code blocks are also categorized under this type.  
\- Import: Encodes static dependencies via language-level import/include statements across modules or packages.  
\- Inherit: Represents class-level inheritance relationships.  
\- Invoke: Captures runtime call relations between functions or methods, crucial for modeling execution semantics.  
\- Data Flow (Data F.): Tracks how data flows between variables, parameters, or return values.  
\- Control Flow (Ctrl F.): Reflects control dependencies induced by conditionals, loops, or branching.

Node Types. Nodes are the fundamental units representing code entities at different granularity levels:

\- Directory: The top-level physical organization of a repository.  
\- Module: Corresponds to a single source file (e.g.,.py,.java,.cpp); though often called File in prior work, we  
    distinguish Module here as the logical layer between Directory and Class.  
\- Class / Function: Core units in most programming languages and frequent retrieval targets in downstream tasks.  
\- Line: The smallest addressable unit in code. Its use indicates support for fine-grained retrieval, highlighting  
    line-level indexing and alignment.

Observed Design Patterns. From the table, several trends and insights emerge:

\- Contain and Invoke as Foundational Edges. Most methods includeContainandInvokeedges, indicating  
    their foundational role in representing code structure. Even methods that do not explicitly model invocation likely  
    assume it implicitly or extract it externally.  
\- Three-Level Node Hierarchy Dominance.Module–Class–Functionnodes often co-occur, forming a de facto  
    standard three-tier abstraction. Models that includeLine-level nodes (e.g.,PKG\[ 79 \],GraphCoder\[ 77 \]) usually  
    lack higher-level context like Module or Class, favoring fine-grained reasoning at the cost of global awareness.

\- DataFlow as a Semantic Enhancer. Only a few methods (DraCo\[ 75 \],CodeGRAG\[ 76 \],GraphCoder\[ 77 \], and  
    SaraCoder\[ 78 \]) explicitly modelDataFlow, capturing variable-level semantics for tasks like code completion or  
    bug detection. Incorporating data flow in RAG systems is challenging, as models must rely on static analysis rather  
    than executing code, often requiring language-specific parsing and limiting scalability. Despite this, it remains a  
    promising direction for improving semantic precision in RACG.  
\- Limited Use of ControlFlow Edges. While most methods do not incorporateControlFlowedges, some—such  
    asCodeGRAG\[ 76 \],SaraCoder\[ 78 \] andGraphCoder\[ 77 \] have explored their use. However, widespread adoption  
    remains limited due to the complexity of extracting control-flow graphs (CFGs), ambiguity in cross-function  
    control flows, and the observation that many downstream tasks rely more heavily on structural and semantic cues  
    than on precise execution traces.  
\- Multi-Level Graph Integration as a Future Trend. Recent models likeLocAgent\[ 93 \] andCoSIL\[ 94 \] construct  
    graphs that span from directories to functions, enabling holistic repository modeling. Others likeDraCo\[ 75 \] and  
    CodeGRAG\[ 76 \] emphasize integrating both structure and semantics, suggesting that future work may focus on  
    multi-perspective graphs combining hierarchical structure with data and control flows.

Graph-specific Innovations and Limitations. Beyond standard graph construction strategies, several studies intro-  
duce distinctive innovations in graph-based code retrieval. As mentioned earlier, data flow and control flow remain  
relatively underexplored, yet works such asDraCo\[ 75 \],CodeGRAG\[ 76 \], andGraphCoder\[ 77 \] have actively investi-  
gated these areas. CoCoMIC \[90\] adopts a causal attention mechanism, encoding each code node into a single token to  
enable fine-grained dependency modeling.CodeRAG\[ 91 \] proposes a dual-graph architecture capturing deep correlations  
between requirements and code, further enhanced with dynamic reasoning tools.CGM\[ 92 \] integrates semantic and  
structural information by mapping code graph nodes into the LLM input space while introducing graph structures  
through attention masks.LocAgent\[ 93 \] presents a graph-guided LLM agent framework, exposing the graph to the LLM  
as a tool to support multi-hop reasoning.CoSIL\[ 94 \] leverages a module call graph to precisely identify suspicious files  
and iteratively explores context via the function call graph.HCGS\[ 95 \] performs bottom-up traversal of the code graph,  
aggregating low-level function context into higher-level summaries to generate code representations rich in dependency  
information.CodeRCSG\[ 96 \] encodes semantic graphs using a GNN and maps the graph embeddings to the same feature  
space as language model embeddings.SynFix\[ 97 \] constructs a RelationGraph to ensure that all dependencies are  
updated when fixing issues. Finally, External identifier disambiguation enhancement inSaraCoder\[ 78 \] constructs a  
cross-file symbolic association graph via a structured symbol table and import statement parsing, accurately mapping  
symbol references in the current file to entity definitions in external files.

Some approaches further adopt knowledge graph (KG)-based designs, incorporating external or contextual information  
beyond code-only structures.ContextModule\[ 80 \] logs user behavior and aggregates multiple information sources  
for retrieval.KGCompass\[ 81 \] integrates code entities (files, classes, functions) with repository artifacts (issues, pull  
requests) into a comprehensive KG, retrieving relevant nodes based on function-level similarity.PKG\[ 79 \] represents  
both code and text as a directed acyclic graph (DAG) and employs tree-pruning techniques to enhance semantic search  
precision.Abedu\[ 82 \] collects software repository data—including commits, issues, files, and users—to construct a  
knowledge graph, whilePrometheus\[ 83 \] converts the entire codebase into a unified knowledge graph using multi-agent  
mechanisms, supporting multiple programming languages and equipped with Docker-based execution tools.

Although many works emphasize graph construction, the retrieval algorithms over these graphs are often underexplored.  
Typically, initial code snippets are located via matching and then expanded using kNN,n-hop subgraphs, BFS, or DFS.  
Some methods enhance this with hybrid similarity metrics.RepoHYPER\[ 84 \] combines search-extension strategies  
with link prediction to refine the retrieved context.AutoCodeRover\[ 85 \] integrates hierarchical code search with  
Spectrum-Based Fault Localization to guide the search.LingmaAgent\[ 86 \] employs Monte Carlo Tree Search (MCTS)  
to navigate large-scale code graphs and accurately localize target code.CocoGen\[ 87 \] stores the graph in a database and  
translates compiler errors into SQL queries for code location, whereas OrcaLoca \[29\] uses an action scheduler queue  
to dynamically guide LLM-based graph traversal.DSrepair\[ 88 \] stores graphs as RDF triples and queries them via  
SPARQL.RepoScope\[ 89 \] starts from import entities to perform depth-first search, scoring entities based on similarity  
and intra-repository call patterns to predict potential call chains.SaraCoder\[ 78 \] proposes Decaying Subgraph Edit  
Distance (D-SED) to make graph similarity calculation more aligned with code "logical importance", thereby improving  
the semantic accuracy of retrieval.

Despite their strengths, graph-based methods often require substantial manual effort for detail handling and construction.  
Since syntax structures vary significantly across programming languages, such approaches suffer from reduced  
portability compared to non-graph-based methods.

4.1.3 Data Source for RAG

In typical RACG tasks, the input is the current repository, and retrieval is restricted to the files within it \[ 18 , 75 \].  
Another common practice is to combine API documentation, which reflects function-level usage from a complementary  
perspective \[68, 69\].

However, several works have proposed alternative data sources to enrich retrieval and enhance model performance:

\- PKG\[ 79 \] adopts the PythonAlpaca dataset (containing Python programming Q\&A pairs) and the Tutorials dataset  
    (containing programming tutorial texts) as knowledge sources.  
\- EvoR\[ 67 \] integrates heterogeneous data, including web search results (blogs, tutorials, community discussions),  
    official documentation, execution feedback, and code snippets.  
\- ContextModule\[ 80 \] leverages user behavioral code datasets collected from real editing actions within a company  
    environment. It records the final completed code (either generated by a model or manually written) and applies  
    rule-based filtering plus manual annotation to curate high-quality samples.  
\- A^3 \-CodGen\[ 63 \] constructs a knowledge base of function libraries and third-party libraries, showing stronger  
    capabilities in library reuse compared to existing tools such as GitHub Copilot.  
\- SWE-Exp \[107\] retrieves high-quality repair trajectory experiences to guide code modification.  
\- CodeGuarder \[108\] extracts data from real-world vulnerability databases to inform secure code generation.  
\- Abedu et al.\[ 82 \] exploit software repository data, including commits, issues, files, users, and their relationships,  
    as a structured knowledge graph.  
\- Tony et al.\[ 109 \] retrieve the top-10 related items fromSecGuide, investigating the effect of integrating  
    task-specific secure coding guidelines into LLM prompts for safer code generation.  
\- RTLFixer\[ 110 \] leverages compiler error logs by categorizing syntax errors and augmenting them with detailed  
    human expert explanations. These logs, erroneous code snippets, and expert annotations are stored in a retrieval  
    database to guide error correction.  
\- Kranti et al.\[ 111 \] focus on a Minecraft collaborative building task, where LLMs are trained to predict  
    builders’ action sequences by framing action prediction as code generation—mapping in-game operations (e.g.,  
    placing or picking up blocks) to function calls such asplace()orpick(). The retrieval dataset is derived from  
    Minecraft collaborative dialogue interactions.

\`\`\`  
Overall, the variety of data sources highlights an important trend: while early approaches primarily  
relied on repository-local context or API documentation, recent works broaden the retrieval space to include  
behavioral traces, vulnerability records, human feedback, and external web resources. This diversification  
not only improves task-specific performance (e.g., code repair, security, third-party library usage) but also  
reveals that the choice of retrieval corpus is a critical factor in determining the effectiveness of RAG systems for  
software engineering.  
\`\`\`  
4.1.4 Effectiveness of RAG Approaches

The effectiveness of RAG is not a settled issue, and the presence of a retrieval component does not necessarily guarantee  
superior performance.Peng et al.\[ 112 \] conduct a systematic comparison between long-context language models  
(LC) and RAG-based methods in RLCG tasks. Their findings reveal that when repositories are relatively small and  
well-structured, LC models can match or even outperform RAG. However, as repository size grows or structural  
complexity increases, RAG demonstrates clear advantages.

Several studies have provided strong evidence for the effectiveness of RAG. For instance,CodeGen4Libs\[ 113 \] confirm  
through a user study involving 66 developers the practical necessity of library-oriented code generation and retrieval-  
enhanced automation.Chen et al.\[ 114 \] investigate the role of RAG when working with uncommon API libraries,  
demonstrating that retrieval substantially improves code generation accuracy. Interestingly, their work also finds that  
LLMs are tolerant to mild noise in documentation, and that BM25 retrieval achieves the best performance for code  
matching. Similarly,Yang et al.\[ 115 \] show that RACG significantly improves model performance, where BM  
retrieval and Sequential Integration Fusion strike an appealing balance of simplicity and effectiveness, while Sketch  
Filling Fusion—though more computationally expensive—yields further gains.Marko et al.\[ 116 \] also highlight  
that RAG-based models surpass small fine-tuned models for code retrieval tasks.

On the other hand, some works investigate the possibility of forgoing RAG entirely by strengthening the intrinsic  
capabilities of LLMs through long-context modeling. For example,SelectSolve\[ 117 \] demonstrates that in fully  
observable environments such as SWE-bench, simply providing the entire codebase to a long-context LLM with  
proper prompting can achieve, and sometimes surpass, the performance of carefully designed multi-tool agent systems.  
Oskooei et al.\[ 118 \] employ hierarchical summarization to facilitate repository-level comprehension.SoRFT\[ 119 \]  
trains models on multiple localization and editing tasks through a combination of rejection sampling, supervised fine-  
tuning, and reinforcement learning with PPO.CoLT\[ 120 \] further reinforces the utilization of long-context information  
through explicit RL signals.ToolGen\[ 20 \] fine-tunes models with augmented functions annotated by a\<COMP\>token,  
enabling the model to learn trigger points for invoking external completion tools. Blinn et al.\[ 121 \] integrate  
LLM-based generation into a real-time sketching environment, leveraging the language server to supply semantically  
relevant contextual cues.

Industrial practice has also provided empirical evidence. Tencent explores RAG in the large-scale, closed-source WeChat  
codebase for code completion, showing that similarity-based retrieval outperforms identifier-based retrieval \[ 122 \]. Also,  
Wang et al.\[ 123 \] report that with the right embedding models, RAG achieves higher accuracy than fine-tuning  
alone, with BM25 again striking an excellent balance between retrieval effectiveness and efficiency. They further show  
that combining RAG with fine-tuning yields additional improvements. Researchers at Jetbrain find that despite being  
trained on only 1B repository-level tokens, their approach achieves competitive performance on the Long Code Arena  
benchmark \[124\].

\`\`\`  
In summary, the effectiveness of RAG approaches is context-dependent. While RAG often excels in large or  
complex repositories, alternative strategies leveraging long-context LLMs and task-specific enhancements can  
sometimes match or surpass RAG in smaller, more structured settings. Industrial deployments further validate  
the practical value of RAG, especially when combined with fine-tuning and efficient retrieval methods. Taken  
together, these findings suggest that RAG is not universally superior, but rather part of a broader design space  
where trade-offs among context length, retrieval cost, and model capacity must be carefully balanced.  
\`\`\`  
4.2 The Role of Training in Enhancing RACG Performance

Although RACG systems can be implemented in a lightweight, zero-shot manner—without additional training—early  
work such asDraCo\[ 75 \] andRepoGraph\[ 19 \] still demonstrated promising results. However, recent research in RACG  
increasingly treats training as a vital component for improving performance. This shift reflects the growing recognition  
that aligning retrieval modules with generation tasks and adapting pre-trained models to code-specific domains. Most  
training strategies are self-supervised or unsupervised in nature, owing to the scarcity of high-quality labeled data and  
the inherent structure of code that enables meaningful learning signals without annotation.

Retrieval module training. ReACC\[ 31 \] constructs a hybrid retriever combining BM25 with a dense retriever initial-  
ized by GraphCodeBERT and further pre-trained using contrastive learning and semantics-preserving augmentations  
such as identifier renaming and dead code insertion.kNN-TRANX\[ 36 \], one of the early code search works relevant to  
RACG, is built upon the BertranX seq2tree model to learn mappings from natural language queries to abstract syntax  
trees (ASTs). It additionally introduces a meta-k network and a confidence network, which are jointly trained to enhance  
retrieval reliability and prediction confidence.CodeGenAPI\[ 34 \] targets the retrieval of potentially useful APIs from  
private library documentation, employing dual-encoder dense retrieval techniques to balance inference with retrieval.  
CodeGRAG\[ 76 \] jointly encodes code and textual views using CodeT5+ and UniXCoder, while a graph neural network  
captures the structural view; the model is optimized through structure-preserving contrastive alignment. Similarly,  
InferFix\[ 125 \] trains a retriever using contrastive learning to identify semantically similar bugs and corresponding  
fixes from historical data.CONAN-R\[ 126 \] enhances code and documentation representations by pretraining CodeT  
with code–document alignment (CDA) and masked entity prediction (MEP).RLPG\[ 53 \] generates multiple candidate  
contexts via prompt templates and trains a Prompt Proposal Classifier to select the most relevant one.CoRet\[ 44 \]  
introduces a novel log-likelihood-based loss function and incorporates call graph and file path information during  
training. It ties the weights of the query and code encoders, replacing the\<CLS\>token with mean pooling to produce  
robust embeddings.CodeFilter\[ 40 \] also uses likelihood-based scoring methods to label each cross-file code block,  
employing special tokens (\<EC\>,\<MC\>for retrieval control;\<pos\>,\<neg\>,\<neu\>for marking retrieval result polarity).  
SWE-Fixer\[ 41 \] employs a coarse-to-fine retriever that combines BM25 with a fine-tuned 7B model to enhance retrieval  
precision.SweRank\[ 127 \] utilizes dual-encoder embedding models as code retrievers and instruction-tuned LLMs  
as code re-rankers.CodeXEmbed\[ 128 \] unifies various code-related tasks across multiple programming languages  
into a cohesive contrastive training framework.SelfRACG\[ 50 \] enables LLMs to self-express information needs by

performing inner product retrieval from hidden states of the next token, incorporating retrieval learning and preference  
alignment.

Generation module training. ReACC\[ 31 \] fine-tunes a CodeGPT-adapted model by concatenating retrieved candidates  
with incomplete code to guide generation.RepoFormer\[ 129 \] employs a multi-task self-supervised learning objective  
that jointly optimizes retrieval decision-making and code generation, thereby teaching the model when and how to  
leverage cross-file information.CoCoMic\[ 87 \] introduces a special\<SUM\>token and locale embeddings to cross-file  
nodes, which are encoded and integrated with in-file context via layer-wise joint attention.CONAN-G\[ 126 \] employs  
dual-view code representations and a Fusion-in-Decoder (FiD) architecture, using documentation as prompts to improve  
semantic understanding.R^2 C^2 \-Coder\[ 62 \] builds a candidate training set incorporating both abstract structural and  
snippet-level contexts to fine-tune LLMs.InferFix\[ 125 \] applies supervised fine-tuning on bug-labeled prompts  
augmented with retrieved fix examples.RepoFusion\[ 130 \], based onRLPG\[ 53 \], further aligns large language models  
with task objectives and retrieved contexts.CMFT\[ 131 \] implements curriculum learning to gradually tackle increasingly  
challenging completions.CGM\[ 92 \] uses a two-stage approach, beginning with subgraph reconstruction pre-training  
followed by noisy fine-tuning to align LLMs with downstream tasks.LocAgent\[ 93 \] performs supervised fine-tuning  
and knowledge distillation on a 7B model after bootstrapping a larger Qwen2.5-32B model with successful planning  
trajectories. Meanwhile,SWE-Fixer\[ 41 \]’s edit model generates patch completions using chain-of-thought (CoT)  
training data.Fedrushkov et al.\[ 48 \] implement bidirectional training through bidirectional attention for masked  
next-token prediction and employ the top-k outputs (excluding ground truth) as hard negatives for contrastive learning.  
CodeRCSG\[ 96 \] integrates queries, retrieved text, and graph representations, jointly fine-tuning the code language model,  
graph neural network, and projection mechanism.

Domain-specific tuning has also emerged as a key trend:DroidCoder\[ 132 \] targets Android-specific code completion,  
while RTLRepoCoder \[133\] adapts models to Verilog.

Reinforcement learning has also been adopted to refine both retrievers and generators. RLCoder\[ 134 \] trains its  
retriever (RLRetriever) using a reward function based on weighted perplexity improvement, introducing a stop signal  
mechanism to identify useful candidates.RRR\[ 54 \] adopts a two-stage training strategy: initially, a code refactorer  
is trained via supervised fine-tuning to generate concise, target-aligned code variants. AlthoughSoRFT\[ 119 \] and  
CoLT\[ 120 \] do not explicitly employ RAG, they nonetheless demonstrate the potential of reinforcement learning (RL)  
in enhancing code generation tasks. These explorations illustrate how RL can serve as a bridge between retrieval quality  
and generation fidelity, enabling models to adapt their behavior rather than static supervision.

\`\`\`  
Overall, training—whether for retrieval modules, generation modules, or both—plays a pivotal role in elevating  
the capabilities of RACG systems, enabling them to better understand project-level contexts, leverage structural  
dependencies, and generate high-quality, coherent code.  
\`\`\`  
4.3 The Application of Agent Architectures in RACG Tasks

Agent-based systems have seen increasing adoption across diverse domains such as web search, finance, robotics,  
science, and software engineering \[ 135 , 136 , 137 , 138 , 139 , 140 , 141 \]. Their appeal lies in the ability to decompose  
complex tasks, iteratively refine outputs, and dynamically adapt based on feedback from the environment or user  
interactions.

Despite their growing presence, the definition of what constitutes an “agent” remains inconsistent across the literature.  
In this work, we define an agent as a system capable of perceiving its environment, making decisions via planning or  
learned policies, and executing actions iteratively to achieve a goal—with minimal reliance on hardcoded logic. The  
key objective is to transition from static, deterministic inference pipelines to dynamic, feedback-driven workflows that  
can reason, adapt, and recover from errors or uncertainty.

To assess the agent-based architectures in RACG, we introduce a three-tier classification framework, as illustrated in  
Figure 7\. This framework distinguishes systems by their architectural complexity and degree of autonomy:

\- Level 0: Non-agent systems—Static, hardcoded workflows with no iteration or decision-making.  
\- Level 1: Partial agent systems—Systems with partial agent-like properties such as self-checking or iterative  
    refinement, or demonstrated compatibility with existing agent workflows.  
\- Level 2: Fully autonomous agents—Architectures that autonomously plan, adapt, and interact with external tools  
    or knowledge sources.

\`\`\`  
Retrieval  
\`\`\`  
\`\`\`  
Generation  
\`\`\`  
\`\`\`  
Judge  
\`\`\`  
\`\`\`  
Retrieval  
\`\`\`  
\`\`\`  
Generation  
\`\`\`  
\`\`\`  
Agent  
\`\`\`  
\`\`\`  
Retrieval ... Tools Generation  
\`\`\`  
\`\`\`  
Planning Memory  
\`\`\`  
\`\`\`  
Level 0 Level 1 Level 2  
\`\`\`  
\`\`\`  
75.2%  
\`\`\`  
\`\`\`  
8.9%  
\`\`\`  
\`\`\`  
15.8%  
\`\`\`  
\`\`\`  
Level 0  
\`\`\`  
\`\`\`  
Level 1  
\`\`\`  
\`\`\`  
Level 2  
\`\`\`  
\`\`\`  
Architecture LevelsLevel 0(76%)  
Level 1(9%)Level 2  
(16%)  
\`\`\`  
Figure 7: Three-tier classification of agent-based architectures in RACG (left), ranging from non-agent systems (Level 0\)  
to partial agent systems (Level 1\) and fully autonomous agents (Level 2). The distribution of systems across levels is  
illustrated in the pie chart (right).

\`\`\`  
Agent Architectures  
\`\`\`  
\`\`\`  
L0: Non-agent Most RACG work  
\`\`\`  
\`\`\`  
L1: Partial-agent  
\`\`\`  
\`\`\`  
Highly Interoperable RepoGraph \[19\]  
\`\`\`  
\`\`\`  
Iterative Refinement  
\`\`\`  
\`\`\`  
RepoCoder \[18\], EvoR \[67\], CocoGen \[87\],  
CoSIL \[94\], Tom et al. \[109\], APT \[142\],  
FT2Ra \[38\], De-Hallucinator \[47\]  
\`\`\`  
\`\`\`  
L2: Fully-agent  
\`\`\`  
\`\`\`  
SWE-agent \[21\], CodexGraph \[103\], SWE-Exp \[107\], ARCS \[39\],  
SWE-Debate \[106\], Prometheus \[83\], RRR \[74\], CodeRAG \[91\],  
LingmaAgent \[86\], OrcaLoca \[29\], LocAgent \[93\], CodePlan \[104\],  
AutoCodeRover \[85\], OpenHands \[143\]  
\`\`\`  
\`\`\`  
Figure 8: Taxonomy of Agent Architectures.  
\`\`\`  
This three-tier categorization, visualized in Figure 7, provides a structured basis for analyzing RACG systems.

4.3.1 Level 0: Non-agent Systems

Our survey reveals that the vast majority of RACG approaches fall under Level 0, following fixed pipelines without  
dynamic decision-making or environment interaction. This reflects the highly goal-driven nature of many RACG tasks  
where deterministic workflows suffice, while also highlighting untapped opportunities for agent-based exploration.

A particularly noteworthy Level 0 system isAgentless \[ 144 \], which embraces simplicity through a “lo-  
cate–repair–verify” workflow. By deliberately avoiding agent-like complexity, it offers two main advantages: (i)  
easier interpretation and debugging by removing the need for autonomous decision-making, and (ii) reduced com-  
putational overhead for practical deployment. While lacking adaptivity, such systems demonstrate that well-crafted  
pipelines can deliver strong performance in targeted scenarios.

The majority of training-intensive RACG systems remain at Level 0, indicating that current training efforts have focused  
on optimizing static components (e.g., retrievers or generators), with limited progress toward end-to-end autonomy or  
interactive reasoning.

4.3.2 Level 1: Partial Agent Systems

Level 1 systems exhibit partial agent properties—such as iteration, refinement, or self-feedback—without being fully  
autonomous. Alternatively, some methods are designed for seamless integration with agent-based pipelines in a modular  
or “plug-and-play” fashion.

Two main categories can be observed. The first includes systems not explicitly structured as agents but highly  
interoperable with existing frameworks; for instance, RepoGraph \[19\] can be readily incorporated into pipelines such  
asSWE-Agent\[ 21 \], demonstrating architectural flexibility and effectiveness. The second category performs explicit  
iterative refinement:RepoCoder\[ 18 \] updates retrieval queries based on prior completions,EvoR\[ 67 \] co-evolves  
queries and knowledge with runtime feedback, whileCocoGen\[ 87 \] andCoSIL\[ 94 \] incorporate compiler signals  
or iterative graph search for repair.Tom et al.\[ 109 \] propose a Recursive Criticism and Improvement paradigm  
combined with RAG. APT \[142\] leverages newly generated test cases to guide subsequent test generation. FT2Ra \[38\]  
simulates multi-round updates akin to model fine-tuning, but performs the updates using retrieved information rather

than parameter modification. Finally,De-Hallucinator\[ 47 \] iteratively retrieves suitable APIs based on initial  
predictions.

A key challenge for Level 1 systems is stability: iterative feedback may cause semantic drift or compounding errors if  
model preferences are misaligned. Addressing this requires more robust control and human-in-the-loop strategies.

4.3.3 Level 2: Fully Autonomous Agent Frameworks

A small but growing number of RACG systems fall under Level 2, introducing fully agentic architectures with  
autonomous scanning, planning, tool usage, and reasoning capabilities.

SWE-agent\[ 21 \] enhances LLM execution through a custom Agent–Computer Interface (ACI) for structured tool  
interaction.CodexGraph\[ 103 \] coordinates two agents: a primary LLM agent producing natural language queries,  
and a translation agent converting these into graph queries for iterative reasoning.SWE-Exp\[ 107 \] leverages trajectory  
experience for issue resolution, whileARCS\[ 39 \] introduces difficulty-aware retrieval, decomposing harder queries into  
sub-queries.

Multi-agent systems represent a promising direction. SWE-Debate\[ 106 \] adopts a competitive debate framework  
generating fault-propagation chains for bug localization.Prometheus\[ 83 \] constructs a unified knowledge graph and  
collaboratively resolves GitHub issues across multiple languages.

An emerging line of work integrates external tools into LLM-driven retrieval.RRR\[ 74 \] empowers LLMs to iteratively  
explore repository contexts using static analysis tools.CodeRAG\[ 91 \] dynamically interleaves reasoning with tool  
calls—web search, graph reasoning, code testing—throughout generation.

More sophisticated strategies includeLingmaAgent\[ 86 \], which uses MCTS to enhance repository exploration and  
patch generation.OrcaLoca\[ 29 \] combines relevance-based action scheduling, action decomposition, and context  
pruning for efficient navigation. LocAgent \[93\] performs multi-hop reasoning over code graphs.

Some Level 2 systems extend beyond bug localization.CodePlan\[ 104 \] monitors AST changes for synchronized  
repository-wide updates.AutoCodeRover\[ 85 \] integrates AST traversal, iterative retrieval, and SBFL for enhanced  
patch synthesis.

OpenHands\[ 143 \] proposes a general-purpose agent interacting via an AgentDelegateAction protocol. Its CodeAc-  
tAgent demonstrates strong performance across code-generation tasks, suggesting promising directions for scalable,  
collaborative agent systems in RACG pipelines.

\`\`\`  
In conclusion, agent architectures in RACG range from static pipelines (Level 0\) to partially agentic systems  
with iterative refinement (Level 1\) and fully autonomous frameworks featuring planning and tool use (Level 2).  
Level 0 remains dominant due to its simplicity and practicality for repository-scale generation, while Levels 1–  
offer promising directions toward iterative reasoning, adaptive retrieval, and autonomous decision-making—key  
for tackling complex real-world software engineering tasks.  
\`\`\`  
4.4 Downstream Tasks and Benchmarks for RLCG

Since RACG is a broad topic, our survey reveals that the landscape of benchmarks is highly fragmented, with a large  
number of heterogeneous and sometimes loosely defined tasks. To ensure both clarity and reliability, we restrict our  
focus to benchmarks that are formally defined and directly relevant to RLCG. Narrowing the scope to benchmarks that  
are intrinsically linked to RLCG allows us to concentrate on the central problem of RAG for code generation, rather  
than being distracted by loosely related or underspecified tasks.

4.4.1 Downstream Tasks

RLCG systems have been applied to a variety of downstream tasks, depending on the specific retrieval strategy and  
model design. Among these, three tasks have received the most attention: cross-file code completion, GitHub issue  
resolution, and coding ability evaluation. The first two have already been discussed in Section 2.1, as they address  
practical software engineering scenarios that require reasoning beyond a single file or function. Cross-file completion  
focuses on predicting missing or future code snippets using information from other files in the repository, while issue  
resolution attempts to automate the repair or implementation of functionalities linked to GitHub issues.

Coding ability evaluation tasks, represented by benchmarks such asHumanEval\[ 145 \] andMBPP\[ 146 \], aim to measure  
a model’s capacity to understand problem descriptions and generate correct, executable solutions. Although these

benchmarks are less grounded in real-world development workflows, they provide a standardized environment to  
test whether RACG methods can enhance model reasoning and synthesis under external knowledge augmentation.  
This setting also facilitates systematic comparisons with other improvement strategies such as instruction tuning, data  
augmentation, or chain-of-thought prompting.

Beyond these, several additional downstream tasks have been explored. Code search (e.g.,CoNaLa\[ 147 \]) evaluates a  
model’s ability to retrieve or synthesize code snippets from natural language queries. Program repair (e.g.,TFix\[ 148 \])  
focuses on generating patches for buggy code, while Test Generation investigates the synthesis of unit tests or assertions  
to verify program correctness. Together, these tasks illustrate the growing versatility of RACG systems across different  
dimensions of software intelligence.

4.4.2 Benchmarks

We now turn to the benchmarks commonly used for evaluating RLCG systems. In our survey of existing literature,  
we observe that many works rely on self-constructed benchmarks. This trend can be attributed to two main factors:  
first, custom-designed benchmarks enable authors to emphasize the unique strengths of their proposed models; second,  
the creation of new benchmarks is relatively feasible, often involving data collection, static analysis, and unit test  
integration. However, the proliferation of such benchmarks introduces challenges for fair and consistent evaluation  
across systems.

It is worth noting that there exists a vast number of RACG/RLCG-related benchmark efforts, reflecting both the diversity  
and complexity of the field. While some of these benchmarks have even undergone peer review, in this survey we only  
include those that have been utilized in at least one other published work, ensuring rigor and validity. Based on their  
primary proposed tasks, we further categorize and introduce several representative benchmarks that have been widely  
adopted across multiple studies.

\`\`\`  
Table 3: Overview of representative benchmarks.  
\`\`\`  
\`\`\`  
Category Benchmark Size Programming Language Date Link  
\`\`\`  
\`\`\`  
Line Completion  
\`\`\`  
\`\`\`  
RepoEval \[18\] 3573 Python 2023-03 link  
RepoBench \[149\] 496843 Python, Java 2024-01 link  
CrossCodeEval \[150\] 9928 Python, Java, TypeScript, and C\# 2023-11 link  
\`\`\`  
\`\`\`  
Function Generation  
\`\`\`  
\`\`\`  
CoderEval \[151\] 460 Python, Java 2024-02 link  
DevEval \[152\] 1874 Python 2024-05 link  
EvoCodeBench \[153\] 275 Python 2024-03 link  
\`\`\`  
\`\`\`  
Real-World Resolution  
\`\`\`  
\`\`\`  
SWE-bench \[4\] 2294 Python 2023-10 link  
Long Code Arena \[154\] —-^4 Python, Java, Kotlin 2024-06 link  
\`\`\`  
\`\`\`  
General Purpose  
\`\`\`  
\`\`\`  
Aider Polyglot \[155\] 225 Multi-language 2024-12 link  
LiveCodeBench \[156\] 300+ Python 2024-03 link  
HumanEval \[145\] 164 Python 2021-07 link  
MBPP \[146\] 974 Python 2021-08 link  
CodeXGLUE \[157\] —-^5 Multi-language 2021-03 link  
\`\`\`  
Repository-Level Line Completion.

\- RepoEval \[ 18 \] (fromRepoCoder) contains 1,600 line completions, 1,600 API calls, and 373 function completions  
    from high-quality Python repositories (2022+). It evaluates functional correctness via repository-native unit tests  
    and snapshots (Jan 2023\) across three granularity levels: lines, API calls, and functions.  
\- RepoBench \[ 149 \] supports Python and Java and decomposes RLCG into retrieval (RepoBench-R), completion  
    (RepoBench-C), and pipeline (RepoBench-P) tasks. Built from newly crawled GitHub data, it evaluates retrieval  
    by Accuracy@k and completion by EM/ES.

(^3) Calculated based on data from RepoBench-Python and RepoBench-Java on Hugging Face.  
(^4) Long Code Arena encompasses 6 distinct tasks, making it inappropriate to compute the overall size of the benchmark.  
(^5) CodeXGLUE encompasses 10 distinct tasks from 14 datasets, making it inappropriate to compute the overall size.

\`\`\`  
Python Java Universal C\#TypeScript Others C++JavaScript Rust Go  
Programming Language  
\`\`\`  
\`\`\`  
0  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
40  
\`\`\`  
\`\`\`  
60  
\`\`\`  
\`\`\`  
80  
\`\`\`  
\`\`\`  
Count  
\`\`\`  
\`\`\`  
Figure 9: Programming Language Distribution  
\`\`\`  
\- CrossCodeEval \[ 150 \] introduces 10,000 cross-file completion examples across four languages (Python, Java,  
    TypeScript, C\#). Using static analysis for import resolution, it evaluates three prompt settings: in-file only, retrieved  
    cross-file, and combined contexts.

Repository-Level Function Generation.

\- CoderEval \[ 151 \] includes 460 real-world problems (Python/Java) over six context levels, emphasizing non-  
    standalone functions. It standardizes input as “signature \+ doc \+ context,” with automated Docker-basedPass@k  
    and Acc@k evaluation.  
\- EvoCodeBench \[153\] provides 275 realistic Python samples aligned with evolving repositories, featuring depen-  
    dency structures and dynamic updates. Tasks pair NL requirements with signatures, references, and test cases,  
    evaluated by Pass@k and Recall@k.  
\- DevEval \[ 152 \] offers 1,874 manually annotated samples from 117 repositories across 10 domains, requiring  
    function generation given signatures, NL requirements, and cross-file context.

Pragmatic and Real-World Issue Resolution.

\- SWE-bench \[ 4 \] features 2,294 real-world issues from 12 Python repos, where models generate patches validated  
    by tests. Variants include SWE-bench-lite, \-verified, \-multilingual, and \-multimodal \[158\].  
\- Long Code Arena \[ 154 \] comprises six long-context benchmarks for project-level tasks (e.g., bug localization,  
    library-based generation), offering curated datasets and standardized evaluation tools.

Foundational General-Purpose Benchmarks.

\- Polyglot Leaderboard \[ 155 \] evaluates multilingual coding across languages under a unifiedpass@kmetric,  
    serving as a major reference for cross-model comparison.  
\- LiveCodeBench \[ 156 \] includes 300+ recent problems (2023–2024) for code generation, self-repair, and execution,  
    designed for contamination-free generalization evaluation.  
\- HumanEval \[ 145 \] provides 164 Python problems with signatures, docstrings, and tests, widely used forpass@k  
    evaluation despite limited realism.  
\- MBPP \[ 146 \] offers 974 beginner-level Python problems in natural language, supporting few-shot and fine-tuning  
    evaluations with predictable scaling.  
\- CodeXGLUE \[ 157 \] is a suite of 10 code tasks across 14 datasets (e.g., translation, completion), providing baselines  
    (CodeBERT, CodeGPT) and a unified evaluation framework.

4.5 Programming Language Support

We analyzed the programming language distribution in retrieval-augmented code generation systems based on explicit  
mentions in papers, including cases of cross-lingual transfer.

As shown in Figure 9, Python dominates with 79 occurrences, likely due to its popularity in AI ecosystems, dynamic  
syntax, and widespread use in software engineering and data science. Java follows with 38 instances, reflecting its  
strong presence in enterprise development. C++, C\#, JavaScript, and TypeScript each appear in 6 cases, indicating  
interest in statically typed industrial languages. Languages like Rust and Go show limited support (1–2 occurrences),  
possibly due to smaller community efforts or limited training data.

This distribution reveals that RACG research has largely centered on Python-centric scenarios. From a research  
perspective, Python offers a favorable environment for rapid prototyping given its minimal syntax, rich libraries, and  
prevalence in academic benchmarks. However, limited support for languages like Rust or Go suggests potential bias in  
model evaluation and training data, which may hinder generalization to real-world, multi-language codebases. Statically  
typed and compiled languages often involve complex syntax and rigid structure that pose challenges for tokenization,  
retrieval alignment, and generation fidelity.

As the field matures, we expect greater emphasis on cross-language generalization through multilingual training or  
language-specific adapters. However, closing the gap between academic prototypes and practical deployment across  
heterogeneous repositories remains an open challenge, further exacerbated by limited language diversity in evaluation  
benchmarks—for instance, the widely-used SWE-bench is exclusively Python-based, making it difficult to assess  
system effectiveness on languages like Java, C++, or JavaScript that are prevalent in industrial codebases.

4.5.1 Universal Language Support

Notably, cases with support for general-purpose programming languages rank third. This indicates that cross-language  
capabilities play a crucial role in retrieval-augmented code generation.Zhu et al.\[ 159 \] demonstrate that cross-  
language RACG can significantly enhance the generation ability of multilingual code LLMs, which suggests that  
leveraging diverse programming languages for retrieval can improve model generalization and robustness.

Most of these works transform different programming languages into unified representations and architectures.  
Code2JSON\[ 58 \] employs zero-shot LLM techniques to convert code into structured natural language features.  
CodeXEmbed\[ 128 \] unifies all tasks (e.g., code retrieval, text retrieval) into a consistent format, supporting bidi-  
rectional conversion between text and code.CodeRCSG\[ 96 \] constructs Cross-Lingual Semantic Graphs by encoding  
retrieved code semantic graphs with GNNs and integrating them with input text embeddings.Prometheus\[ 83 \] provides  
a unified knowledge graph representation by transforming code from different languages into a common graph structure.

Other approaches introduce the Language Server Protocol (LSP), which offers several advantages: a unified interface,  
automated management, standardized protocols, and multi-language support.HCGS\[ 95 \] utilizes a modifiedmultilspy  
library as the LSP client, whileBlinn et al.\[ 121 \] proposeChatLSP, a framework that provides unified contextual  
services for diverse programming languages.

4.6 Backbone Models for Retrieval and Generation

In this section, we categorize and list the commonly used backbone models in RACG systems. Retrieval models  
are further divided into dense and sparse types based on their representation and matching strategies. We note that  
the models included here are representative rather than exhaustive, aiming to cover widely adopted examples across  
academic literature.

Dense Retrieval Models. Dense retrievers encode queries and documents into continuous vectors via neural encoders.  
Representative models include:

\- UniXcoder \[ 101 \]: A cross-modal model combining code ASTs and comments. Using prefix-adapters and  
    multimodal contrastive learning, it produces precise embeddings for code understanding and generation.  
\- CodeT5 \[ 160 \]: An encoder–decoder model with identifier-aware pre-training and bimodal dual generation,  
    effectively capturing semantic cues from variable and function names.  
\- Voyage-Code \[ 161 \]: An embedding model for code retrieval integrating Matryoshka learning and quantization-  
    aware training, enhancing multilingual embedding precision with low cost.  
\- Stella \[ 162 \]: A high-performance text embedding model trained via multi-stage distillation and MRL-based  
    dimensionality reduction, yielding robust semantic embeddings.  
\- GraphCodeBERT \[ 100 \]: Incorporates data flow graphs and graph-guided masked attention to model variable-level  
    dependencies beyond syntax.  
\- CodeBERT \[ 163 \]: A bimodal Transformer trained on NL–PL pairs and unimodal data, strong in code search and  
    documentation generation.  
\- Ada-Embedding-002 \[ 164 \]: A general-purpose embedding model from OpenAI offering dense text–code repre-  
    sentations with strong generalization for retrieval and RAG.

Sparse Retrieval Models. Sparse retrievers rely on lexical overlap or simple similarity metrics. Despite lacking  
semantics, they remain effective and interpretable:

\- BM25 \[ 165 \]: A TF–IDF–based ranking function that scores documents by query term matches with length  
    normalization. A strong baseline when exact keyword matching is crucial.  
\- Jaccard Similarity \[ 166 \]: Measures intersection-over-union between token sets, useful for capturing structural  
    overlap between query and code snippets.

Code Generation Models. These models generate code based on retrieved context and task instructions. We  
categorize them into open-source and proprietary models.

Table 4: Overview of selected open-source code generation models, including details such as the developing organization,  
model size (with some MoE models in the format of "full parameters (activation parameters)"), vocabulary size, context  
window length, total number of training tokens, and release date.

Model Organization Size Vocab Context Tokens Date

CodeGen \[167\] Salesforce AI 350M, 2B, 6B, 16B 50K 2048 577.2B 2022-

CodeGen2 \[168\] Salesforce AI 1B, 3.7B, 7B, 16B 50K 2048 400B-1.4T 2023-

SantaCoder \[169\] BigCode 1.1B 48K 2048 236B 2023-

StarCoder(Base) \[170\] BigCode 1B, 3B, 7B, 15.5B 48K 8192 1T 2023-

StarCoder2 \[171\] BigCode 3B, 7B, 15B 48K 16K 4T 2024-

Code LLaMA \[172\] Meta 7B, 13B, 34B, 70B 31K 16K-100K 500B-1T 2023-

DeepSeek-Coder \[173\] DeepSeek 1.3B, 5.7B, 6.7B, 33B 32K 16K 2T 2024-

DeepSeek-Coder-V2 \[174\] DeepSeek 16B(2.4B), 236B(21B) 100K 16K-128K 6T 2024-

CodeQwen1.5 \[175\] Alibaba 7B 90K 64K 3T 2024-

Qwen2.5-Coder \[176\] Alibaba 0.5B, 1.5B, 3B, 7B, 14B, 32B 149K 32K-128K 5.5T 2024-

Qwen3-Coder \[6\] Alibaba 30B(3B), 480B(35B) 148K 256K-1M 7.5T 2025-

Open-source Model Series

\- CodeGen \[ 167 \]: A decoder-only Transformer family by Salesforce (up to∼16B parameters), trained on multi-  
    lingual NL–PL data. It shows strong zero-shot and multi-turn synthesis on benchmarks such as HumanEval and  
    MTPB.  
\- SantaCoder \[ 169 \]: A compact 1.1B model from BigCode trained on Python, Java, and JavaScript (The Stack  
    v1.1). Using Multi-Query Attention and Fill-in-the-Middle (FIM) training, it achieves efficient inference and strong  
    infilling accuracy.  
\- StarCoder \[ 170 \]: A∼15.5B model trained on∼1T tokens (80+ languages) and fine-tuned on Python. It supports  
    8K context, FIM, and multi-query attention, reaching∼40% pass@1 on HumanEval and surpassing earlier open  
    multilingual models.  
\- Code LLaMA \[ 172 \]: Meta’s LLaMA 2–based code models (7B–34B) supporting long-context completion and  
    instruction-following, achieving state-of-the-art performance among open-source code LLMs.  
\- DeepSeek-Coder \[ 173 \]: A Chinese open-source model trained from scratch on∼2T tokens (87% code). With  
    16K context and fill-in-the-blank objectives, it performs strongly in multilingual code completion and infilling.  
\- Qwen2.5-Coder \[ 176 \]: Alibaba’s multilingual series (up to 32B), supporting 128K context and∼92 programming  
    languages. It excels in code completion, generation, repair, and reasoning across multilingual settings.

Proprietary Model Series

\- GPT and o Series (e.g., GPT-5, GPT-5 mini, GPT-4o, o3) \[ 1 \]: Developed by OpenAI, this series leads in code  
    generation and reasoning. GPT-5 offers large-context reasoning for complex coding, while the o-series (e.g., o3,  
    o4-mini) emphasizes optimized multi-step reasoning and efficient long-context handling.  
\- Claude Series (e.g., Claude Opus 4, Sonnet 4.5) \[ 2 \]: From Anthropic, Claude 4.5 models excel at coding and  
    structured reasoning. Opus 4 is recognized for long-running, agentic workflows, and Sonnet 4 offers high coding  
    precision at lower cost.  
\- Gemini Series (e.g., Gemini 2.5 Pro, Flash-Lite) \[ 3 \]: Developed by Google DeepMind, Gemini 2.5 Pro combines  
    strong coding, multimodal reasoning, and a 1M-token context. Flash-Lite provides a cost-efficient variant while  
    retaining solid code performance.

Table 5: Overview of selected proprietary code generation models, including details such as the developing organization,  
context window length, cost, release date and official SWE-bench score.

\`\`\`  
Model Organization Context Cost (Input/Output) Date SWE-bench  
\`\`\`  
\`\`\`  
GPT-4o OpenAI 128K $2.50/$10.00 2024-05 21.62%  
GPT-5 OpenAI 400K $1.25/$10.00 2025-08 65.00%  
GPT-5 mini OpenAI 400K $0.25/$2.00 2025-08 59.80%  
o3 OpenAI 200K $2.00/$8.00 2025-04 58.40%  
Claude Opus 4 Anthropic 200K $15.00/$75.00 2025-05 67.60%  
Claude Sonnet 4 Anthropic 200K $3.00/$15.00 2025-05 64.93%  
Claude Sonnet 4.5 Anthropic 200K $3.00/$15.00 2025-09 70.60%  
Gemini 2.5 Pro Google 1M $1.25/$10.00 2025-03 53.60%  
Gemini 2.5 Flash Google 1M $0.30/$2.50 2025-03 28.73%  
\* SWE-bench Verified score with mini-swe-agent  
Costs shown are per million tokens (input/output) with no cache in USD  
Context window shown as input token limit for Gemini Model(K \= thousand, M \= million)  
\`\`\`  
\`\`\`  
Figure 10: Distribution of base gen-  
eration models used in the surveyed  
papers.  
\`\`\`  
We also conducted a survey of the base generation models adopted in each paper,  
focusing specifically on the models used in the recommended configurations  
rather than those included solely for baseline comparison. This distinction allows  
us to better understand the models authors truly relied on in their proposed  
systems.

We categorized the models into three groups: (1) large open-source models (\>10B  
parameters), (2) small open-source models (\<10B parameters), and (3) proprietary  
models.

Our analysis reveals that small open-source models and proprietary models  
appear with comparable frequency and are significantly more popular than large  
open-source models. The prevalence of small models may be due to limited  
computational resources in academic or exploratory research settings, or because  
they can already achieve satisfactory performance on many tasks. Meanwhile,  
proprietary models are widely adopted, potentially due to two key reasons: (i)  
their superior performance on complex reasoning and generation tasks, and (ii)  
their ease of integration via API, reducing engineering and infrastructure overhead.

In contrast, large open-source models (\>10B) are used far less frequently. This may stem from their high resource  
demands, including substantial GPU memory and inference time, which can pose barriers to adoption in both academic  
and industrial settings without dedicated infrastructure.

\#\# 5 Challenges & Opportunities

5.1 Limitations of Existing Approaches

Despite rapid progress, RACG systems face several core limitations:

Context window constraints and long-range dependencies remain a fundamental bottleneck. While RAG frameworks  
retrieve relevant content externally, they often fail to preserve semantic continuity across distant code segments, leading  
to outputs that lack coherence with repository-wide structures.

Graph-based RAG models suffer from complexity and noise. Graph representations capture structural relationships  
effectively but are computationally expensive to construct and prone to retrieval noise. The absence of standardized  
edge semantics and traversal algorithms often results in redundant context that impairs generation quality.

Insufficient dataset scale and diversity limits evaluation validity. Current benchmarks are small, Python-centric, and  
synthetically constructed. Few evaluate multilingual repositories or account for software evolution dynamics.

Limited deployment readiness undermines practical impact. Most models are evaluated in isolation, lacking inte-  
gration with IDEs, CI pipelines, or automated test suites—preventing meaningful adoption and reducing refinement  
opportunities.

5.2 Future Directions

Multimodal code generation can leverage documentation, issue discussions, architectural diagrams, execution logs,  
and commit histories to improve semantic grounding, especially in underspecified scenarios.

LLM agent integration with graph-based RAG enables interactive, task-driven workflows. Agents can navigate code  
graphs, plan multi-step actions, invoke analysis tools, and refine outputs iteratively—offering greater autonomy and  
explainability.

Scalable architectures using long-context transformers, hierarchical retrieval, and memory summarization can enable  
reasoning over entire repositories without prohibitive costs, supporting real-time development feedback.

Multilingual repository support is critical for modern projects combining multiple languages. Cross-language  
alignment and retrieval strategies are needed for heterogeneous codebases.

Repository-wide coordinated editing tasks—such as package migration, test fixes, and type annotation inser-  
tion—require reasoning over inter-file dependencies. Recent work like CodePlan demonstrates their practical value.

Realistic production-level evaluation should simulate engineering workflows: bug fixes, API migrations, and CI/CD  
contributions. This provides accurate performance assessment grounded in practical utility.

Fine-grained evaluation metrics beyond exact match and pass@k should include static analysis success rates,  
integration test results, type-checking consistency, and developer satisfaction scores.

Bridging retrieval and generation represents the core challenge of RACG. Pre-LLM code intelligence focused on  
retrieval (NL2Code, Code2Code search), while LLMs emphasize generative modeling. Effective integration—where  
retrieved artifacts dynamically inform and constrain generation—is key to achieving models that are both grounded in  
real codebases and capable of creative, context-aware synthesis.

\#\# 6 Conclusion

As software development increasingly relies on complex, modular, and large-scale code repositories, the limitations of  
traditional code generation systems—restricted to function- or file-level reasoning—have become more apparent. In this  
survey, we explored the emerging paradigm of Retrieval-Augmented Code Generation with a focus on Repository-  
Level, which emphasizes enhancing large language models with retrieval mechanisms that provide structurally and  
semantically relevant external context.

We provided a comprehensive taxonomy of retrieval strategies, fusion techniques, generation architectures, training  
methodologies, and evaluation protocols. We highlighted the strengths and trade-offs of non-graph-based versus  
graph-based retrieval-augmented systems, discussed the role of agent-based architectures in enabling interactive and  
autonomous reasoning, and analyzed common downstream tasks and benchmarks that shape current evaluation standards  
in RACG research.

Despite promising advances, RACG systems still face significant challenges—ranging from retrieval efficiency and  
context selection to graph complexity, benchmark scarcity, and real-world deployment barriers. These obstacles  
highlight a rich landscape of open problems and research opportunities.

Looking ahead, we envision RACG systems evolving toward more effective multimodal retrieval, robust graph-  
agent integration, memory-efficient long-context modeling, and tighter coupling with practical software engineering  
workflows. We also anticipate the emergence of more holistic evaluation metrics that capture semantic correctness,  
structural integrity, and practical usability.

Ultimately, by bridging retrieval-augmented language modeling with the structural semantics of large-scale codebases,  
RACG research holds the potential to transform LLMs from passive suggestion engines into intelligent, context-aware  
assistants capable of actively supporting collaborative software development.

\#\# References

\`\`\`  
\[1\]OpenAI. Introducing gpt-5.https://openai.com/index/introducing-gpt-5/, August 2025\. OpenAI  
\`\`\`

\`\`\`  
official website.  
\[2\]Anthropic. Write beautiful code, ship powerful products. https://www.anthropic.com/solutions/  
coding, August 2025\. Anthropic official website, “Solutions – Coding” page.  
\[3\]Google DeepMind. Gemini.https://deepmind.google/models/gemini/, August 2025\. Google DeepMind  
official website.  
\[4\]Carlos E Jimenez, John Yang, Alexander Wettig, Shunyu Yao, Kexin Pei, Ofir Press, and Karthik R Narasimhan.  
SWE-bench: Can language models resolve real-world github issues? In The Twelfth International Conference on  
Learning Representations, 2024\.  
\[5\]Baptiste Roziere, Jonas Gehring, Fabian Gloeckle, Sten Sootla, Itai Gat, Xiaoqing Ellen Tan, Yossi Adi, Jingyu  
Liu, Romain Sauvestre, Tal Remez, et al. Code llama: Open foundation models for code. arXiv preprint  
arXiv:2308.12950, 2023\.  
\[6\] Qwen Team. Qwen3 technical report, 2025\.  
\[7\]Raymond Li, Loubna Ben Allal, Yangtian Zi, Niklas Muennighoff, Denis Kocetkov, Chenghao Mou, Marc  
Marone, Christopher Akiki, Jia Li, Jenny Chim, et al. Starcoder: may the source be with you\! arXiv preprint  
arXiv:2305.06161, 2023\.  
\[8\]GitHub. Github copilot: Your ai pair programmer.https://github.com/features/copilot, August 2025\.  
GitHub features page.  
\[9\] Anysphere. Cursor: The ai code editor. https://cursor.com/en, August 2025\. Anysphere official website.  
\`\`\`  
\[10\] Codeium. Windsurf: The ai code editor. https://windsurf.com/, August 2025\. Codeium official website.

\[11\]OpenAI. Introducing codex.https://openai.com/index/introducing-codex/, May 2025\. OpenAI blog  
post.

\[12\]Google. Gemini cli.https://google-gemini.github.io/gemini-cli/, August 2025\. Google official  
website.

\[13\]Anthropic. Claude code: Deep coding at terminal velocity.https://www.anthropic.com/claude-code,  
August 2025\. Anthropic official website.

\[14\]Zora Zhiruo Wang, Akari Asai, Xinyan Velocity Yu, Frank F. Xu, Yiqing Xie, Graham Neubig, and Daniel Fried.  
CodeRAG-bench: Can retrieval augment code generation? In Luis Chiruzzo, Alan Ritter, and Lu Wang, editors,  
Findings of the Association for Computational Linguistics: NAACL 2025, pages 3199–3214, Albuquerque, New  
Mexico, April 2025\. Association for Computational Linguistics.

\[15\]Kang Chen, Xiuze Zhou, Yuanguo Lin, Shibo Feng, Li Shen, and Pengcheng Wu. A survey on privacy risks and  
protection in large language models. arXiv preprint arXiv:2505.01976, 2025\.

\[16\]God of Prompt. Local llm setup for privacy-conscious businesses. God of Prompt (blog), 2025\. https:  
//www.godofprompt.ai/blog/local-llm-setup-for-privacy-conscious-businesses.

\[17\]Otterly.AI Blog. Knowledge cutoff dates of all llms explained. https://otterly.ai/blog/  
knowledge-cutoff/, February 2024\. Accessed on September 4, 2025\.

\[18\]Fengji Zhang, Bei Chen, Yue Zhang, Jacky Keung, Jin Liu, Daoguang Zan, Yi Mao, Jian-Guang Lou, and  
Weizhu Chen. RepoCoder: Repository-level code completion through iterative retrieval and generation. In  
Houda Bouamor, Juan Pino, and Kalika Bali, editors, Proceedings of the 2023 Conference on Empirical Methods  
in Natural Language Processing, pages 2471–2484, Singapore, December 2023\. Association for Computational  
Linguistics.

\[19\]Siru Ouyang, Wenhao Yu, Kaixin Ma, Zilin Xiao, Zhihan Zhang, Mengzhao Jia, Jiawei Han, Hongming Zhang,  
and Dong Yu. Repograph: Enhancing AI software engineering with repository-level code graph. In The  
Thirteenth International Conference on Learning Representations, 2025\.

\[20\]Chong Wang, Jian Zhang, Yebo Feng, Tianlin Li, Weisong Sun, Yang Liu, and Xin Peng. Teaching code llms to  
use autocompletion tools in repository-level code generation. ACM Trans. Softw. Eng. Methodol., 34(7), August  
2025\.

\[21\]John Yang, Carlos E Jimenez, Alexander Wettig, Kilian Lieret, Shunyu Yao, Karthik Narasimhan, and Ofir Press.  
Swe-agent: Agent-computer interfaces enable automated software engineering. Advances in Neural Information  
Processing Systems, 37:50528–50652, 2024\.

\[22\]Juyong Jiang, Fan Wang, Jiasi Shen, Sungju Kim, and Sunghun Kim. A survey on large language models for  
code generation. ACM Trans. Softw. Eng. Methodol., July 2025\. Just Accepted.

\[23\]Junwei Liu, Kaixin Wang, Yixuan Chen, Xin Peng, Zhenpeng Chen, Lingming Zhang, and Yiling Lou. Large  
language model-based agents for software engineering: A survey, 2024\.

\[24\]Yunfan Gao, Yun Xiong, Xinyu Gao, Kangxiang Jia, Jinliu Pan, Yuxi Bi, Yi Dai, Jiawei Sun, Meng Wang, and  
Haofen Wang. Retrieval-augmented generation for large language models: A survey, 2024\.

\[25\]Wenqi Fan, Yujuan Ding, Liangbo Ning, Shijie Wang, Hengyun Li, Dawei Yin, Tat-Seng Chua, and Qing Li. A  
survey on rag meeting llms: Towards retrieval-augmented large language models. In Proceedings of the 30th  
ACM SIGKDD Conference on Knowledge Discovery and Data Mining, KDD ’24, page 6491–6501, New York,  
NY, USA, 2024\. Association for Computing Machinery.

\[26\]Yihong Dong, Xue Jiang, Jiaru Qian, Tian Wang, Kechi Zhang, Zhi Jin, and Ge Li. A survey on code generation  
with llm-based agents, 2025\.

\[27\]Junda He, Christoph Treude, and David Lo. Llm-based multi-agent systems for software engineering: Literature  
review, vision, and the road ahead. ACM Trans. Softw. Eng. Methodol., 34(5), May 2025\.

\[28\]Yanlin Wang, Wanjun Zhong, Yanxian Huang, Ensheng Shi, Min Yang, Jiachi Chen, Hui Li, Yuchi Ma, Qianxiang  
Wang, and Zibin Zheng. Agents in software engineering: survey, landscape, and vision. Automated Software  
Engineering, 32(2):70, 2025\.

\[29\]Zhongming Yu, Hejia Zhang, Yujie Zhao, Hanxian Huang, Matrix Yao, Ke Ding, and Jishen Zhao. Orcaloca: An  
LLM agent framework for software issue localization. In Forty-second International Conference on Machine  
Learning, 2025\.

\[30\]Kai Petersen, Robert Feldt, Shahid Mujtaba, and Michael Mattsson. Systematic mapping studies in software  
engineering. In Proceedings of the 12th International Conference on Evaluation and Assessment in Software  
Engineering, EASE’08, page 68–77, Swindon, GBR, 2008\. BCS Learning & Development Ltd.

\[31\]Shuai Lu, Nan Duan, Hojae Han, Daya Guo, Seung-won Hwang, and Alexey Svyatkovskiy. ReACC: A retrieval-  
augmented code completion framework. In Smaranda Muresan, Preslav Nakov, and Aline Villavicencio, editors,  
Proceedings of the 60th Annual Meeting of the Association for Computational Linguistics (Volume 1: Long  
Papers), pages 6227–6240, Dublin, Ireland, May 2022\. Association for Computational Linguistics.

\[32\]Noor Nashid, Mifta Sintaha, and Ali Mesbah. Retrieval-based prompt selection for code-related few-shot  
learning. In 2023 IEEE/ACM 45th International Conference on Software Engineering (ICSE), pages 2450–2462,  
2023\.

\[33\]Weishi Wang, Yue Wang, Shafiq Joty, and Steven C.H. Hoi. Rap-gen: Retrieval-augmented patch generation  
with codet5 for automatic program repair. In Proceedings of the 31st ACM Joint European Software Engineering  
Conference and Symposium on the Foundations of Software Engineering, ESEC/FSE 2023, page 146–158, New  
York, NY, USA, 2023\. Association for Computing Machinery.

\[34\]Daoguang Zan, Bei Chen, Yongshun Gong, Junzhi Cao, Fengji Zhang, Bingchao Wu, Bei Guan, Yilong Yin, and  
Yongji Wang. Private-library-oriented code generation with large language models. Knowledge-Based Systems,  
326:113934, 2025\.

\[35\]Ze Tang, Jidong Ge, Shangqing Liu, Tingwei Zhu, Tongtong Xu, Liguo Huang, and Bin Luo. Domain adaptive  
code completion via language models and decoupled domain databases. In 2023 38th IEEE/ACM International  
Conference on Automated Software Engineering (ASE), pages 421–433, 2023\.

\[36\]Xiangyu Zhang, Yu Zhou, Guang Yang, and Taolue Chen. Syntax-aware retrieval augmented code generation. In  
Houda Bouamor, Juan Pino, and Kalika Bali, editors, Findings of the Association for Computational Linguistics:  
EMNLP 2023, pages 1291–1302, Singapore, December 2023\. Association for Computational Linguistics.

\[37\]Hanzhuo Tan, Qi Luo, Ling Jiang, Zizheng Zhan, Jing Li, Haotian Zhang, and Yuqun Zhang. Prompt-based code  
completion via multi-retrieval augmented generation. ACM Trans. Softw. Eng. Methodol., March 2025\. Just  
Accepted.

\[38\]Qi Guo, Xiaohong Li, Xiaofei Xie, Shangqing Liu, Ze Tang, Ruitao Feng, Junjie Wang, Jidong Ge, and Lei Bu.  
Ft2ra: A fine-tuning-inspired approach to retrieval-augmented code completion. In Proceedings of the 33rd ACM  
SIGSOFT International Symposium on Software Testing and Analysis, ISSTA 2024, page 313–324, New York,  
NY, USA, 2024\. Association for Computing Machinery.

\[39\] Manish Bhattarai, Miguel Cordova, Javier Santos, and Dan O’Malley. Arcs: Agentic retrieval-augmented code  
synthesis with iterative refinement, 2025\.

\[40\]Yanzhou Li, Shangqing Liu, Kangjie Chen, Tianwei Zhang, and Yang Liu. Impact-driven context filtering for  
cross-file code completion. In Second Conference on Language Modeling, 2025\.

\[41\]Chengxing Xie, Bowen Li, Chang Gao, He Du, Wai Lam, Difan Zou, and Kai Chen. SWE-fixer: Training open-  
source LLMs for effective and efficient GitHub issue resolution. In Wanxiang Che, Joyce Nabende, Ekaterina  
Shutova, and Mohammad Taher Pilehvar, editors, Findings of the Association for Computational Linguistics:  
ACL 2025, pages 1123–1139, Vienna, Austria, July 2025\. Association for Computational Linguistics.

\[42\]Lei Zhang, Yunshui Li, Jiaming Li, Xiaobo Xia, Jiaxi Yang, Run Luo, Minzheng Wang, Longze Chen, Junhao Liu,  
Qiang Qu, and Min Yang. Hierarchical context pruning: Optimizing real-world code completion with repository-  
level pretrained code llms. Proceedings of the AAAI Conference on Artificial Intelligence, 39(24):25886–25894,  
Apr. 2025\.

\[43\]Yifan Li, Ensheng Shi, Dewu Zheng, Kefeng Duan, Jiachi Chen, and Yanlin Wang. Repomincoder: Improving  
repository-level code generation based on information loss screening. In Proceedings of the 15th Asia-Pacific  
Symposium on Internetware, Internetware ’24, page 229–238, New York, NY, USA, 2024\. Association for  
Computing Machinery.

\[44\]Fabio Fehr, Prabhu Teja Sivaprasad, Luca Franceschi, and Giovanni Zappella. Coret: Improved retriever for  
code editing, 2025\.

\[45\]Hangzhan Jin and Mohammad Hamdaqa. Ccci: Code completion with contextual information for complex data  
transfer tasks using large language models, 2025\.

\[46\]Chuanyi Li, Jiwei Shang, Yi Feng, and Bin Luo. Hyracc: A hybrid retrieval-augmented framework for more  
efficient code completion. In 2025 IEEE/ACM Second International Conference on AI Foundation Models and  
Software Engineering (Forge), pages 61–66, 2025\.

\[47\] Aryaz Eghbali and Michael Pradel. De-hallucinator: Mitigating llm hallucinations in code generation tasks via  
iterative grounding, 2024\.

\[48\]Dmitriy Fedrushkov, Denis Tereshchenko, Sergey Kovalchuk, and Artem Aliev. Improving project-level code  
generation using combined relevant context. In Michael H. Lees, Wentong Cai, Siew Ann Cheong, Yi Su,  
David Abramson, Jack J. Dongarra, and Peter M. A. Sloot, editors, Computational Science – ICCS 2025, pages  
438–445, Cham, 2025\. Springer Nature Switzerland.

\[49\]Jicheng Wang, Yifeng He, and Hao Chen. Repogenreflex: Enhancing repository-level code completion with  
verbal reinforcement and retrieval-augmented generation, 2024\.

\[50\]Qian Dong, Jia Chen, Qingyao Ai, Hongning Wang, Haitao Li, Yi Wu, Yao Hu, Yiqun Liu, and Shaoping Ma.  
Selfracg: Enabling llms to self-express and retrieve for code generation, 2025\.

\[51\]Avik Dutta, Mukul Singh, Gust Verbruggen, Sumit Gulwani, and Vu Le. RAR: Retrieval-augmented retrieval for  
code generation in low resource languages. In Yaser Al-Onaizan, Mohit Bansal, and Yun-Nung Chen, editors,  
Proceedings of the 2024 Conference on Empirical Methods in Natural Language Processing, pages 21506–21515,  
Miami, Florida, USA, November 2024\. Association for Computational Linguistics.

\[52\]Jaeseok Yoo, Hojae Han, Youngwon Lee, Jaejin Kim, and Seung-won Hwang. PERC: Plan-as-query example  
retrieval for underrepresented code generation. In Owen Rambow, Leo Wanner, Marianna Apidianaki, Hend Al-  
Khalifa, Barbara Di Eugenio, and Steven Schockaert, editors, Proceedings of the 31st International Conference  
on Computational Linguistics, pages 7982–7997, Abu Dhabi, UAE, January 2025\. Association for Computational  
Linguistics.

\[53\]Disha Shrivastava, Hugo Larochelle, and Daniel Tarlow. Repository-level prompt generation for large language  
models of code. In Proceedings of the 40th International Conference on Machine Learning, ICML’23. JMLR.org,  
2023\.

\[54\]Xinyu Gao, Yun Xiong, Deze Wang, Zhenhan Guan, Zejian Shi, Haofen Wang, and Shanshan Li. Preference-  
guided refactored tuning for retrieval augmented code generation. In Proceedings of the 39th IEEE/ACM  
International Conference on Automated Software Engineering, ASE ’24, page 65–77, New York, NY, USA,

2024\. Association for Computing Machinery.

\[55\]Haochen Li, Xin Zhou, and Zhiqi Shen. Rewriting the code: A simple method for large language model  
augmented code search. In Lun-Wei Ku, Andre Martins, and Vivek Srikumar, editors, Proceedings of the 62nd  
Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers), pages 1371–1389,  
Bangkok, Thailand, August 2024\. Association for Computational Linguistics.

\[56\]Dhruv Gupta, Gayathri Ganesh Lakshmy, and Yiqing Xie. Sacl: Understanding and combating textual bias in  
code retrieval with semantic-augmented reranking and localization, 2025\.

\[57\]Mizuki Kondo, Daisuke Kawahara, and Toshiyuki Kurabayashi. Improving repository-level code search with  
text conversion. In Yang (Trista) Cao, Isabel Papadimitriou, Anaelia Ovalle, Marcos Zampieri, Francis Ferraro,  
and Swabha Swayamdipta, editors, Proceedings of the 2024 Conference of the North American Chapter of

\`\`\`  
the Association for Computational Linguistics: Human Language Technologies (Volume 4: Student Research  
Workshop), pages 130–137, Mexico City, Mexico, June 2024\. Association for Computational Linguistics.  
\`\`\`  
\[58\]Aryan Singhal, Rajat Ghosh, Ria Mundra, Harshil Dadlani, and Debojyoti Dutta. Code2JSON: Can a zero-shot  
LLM agent extract code features for code RAG? In ICLR 2025 Third Workshop on Deep Learning for Code,  
2025\.

\[59\]Junkai Chen, Xing Hu, Zhenhao Li, Cuiyun Gao, Xin Xia, and David Lo. Code search is all you need? improving  
code suggestions with code search. In Proceedings of the IEEE/ACM 46th International Conference on Software  
Engineering, ICSE ’24, New York, NY, USA, 2024\. Association for Computing Machinery.

\[60\]Keyu Liang, Zhongxin Liu, Chao Liu, Zhiyuan Wan, David Lo, and Xiaohu Yang. Zero-shot cross-domain code  
search without fine-tuning. Proc. ACM Softw. Eng., 2(FSE), June 2025\.

\[61\]Yilin Zhang, Xinran Zhao, Zora Zhiruo Wang, Chenyang Yang, Jiayi Wei, and Tongshuang Wu. cast: Enhancing  
code retrieval-augmented generation with structural chunking via abstract syntax tree, 2025\.

\[62\]Ken Deng, Jiaheng Liu, He Zhu, Congnan Liu, Jingxin Li, Jiakai Wang, Peng Zhao, Chenchen Zhang, Yanan Wu,  
Xueqiao Yin, Yuanxing Zhang, Wenbo Su, Bangyu Xiang, Tiezheng Ge, and Bo Zheng. R2c2-coder: Enhancing  
and benchmarking real-world repository-level code completion abilities of code large language models, 2024\.

\[63\]Dianshu Liao, Shidong Pan, Xiaoyu Sun, Xiaoxue Ren, Qing Huang, Zhenchang Xing, Huan Jin, and Qinying  
Li. A^3 A3-CodGen: A Repository-Level Code Generation Framework for Code Reuse With Local-Aware,  
Global-Aware, and Third-Party-Library-Aware. IEEE Transactions on Software Engineering, 50(12):3369–3384,  
December 2024\.

\[64\]Ming Liang, Xiaoheng Xie, Gehao Zhang, Xunjin Zheng, Peng Di, wei jiang, Hongwei Chen, Chengpeng Wang,  
and Gang Fan. Repofuse: Repository-level code completion with fused dual context, 2024\.

\[65\]Tuan-Dung Bui, Duc-Thieu Luu-Van, Thanh-Phat Nguyen, Thu-Trang Nguyen, Son Nguyen, and Hieu Dinh Vo.  
Rambo: Enhancing rag-based repository-level method body completion, 2024\.

\[66\]Ming Liang, Xiaoheng Xie, Gehao Zhang, Xunjin Zheng, Peng Di, Wei Jiang, Hongwei Chen, Chengpeng Wang,  
and Gang Fan. Repogenix: Dual context-aided repository-level code completion with language models. In  
Proceedings of the 39th IEEE/ACM International Conference on Automated Software Engineering, ASE ’24,  
page 2466–2467, New York, NY, USA, 2024\. Association for Computing Machinery.

\[67\]Hongjin Su, Shuyang Jiang, Yuhang Lai, Haoyuan Wu, Boao Shi, Che Liu, Qian Liu, and Tao Yu. EvoR:  
Evolving retrieval for code generation. In Yaser Al-Onaizan, Mohit Bansal, and Yun-Nung Chen, editors,  
Findings of the Association for Computational Linguistics: EMNLP 2024, pages 2538–2554, Miami, Florida,  
USA, November 2024\. Association for Computational Linguistics.

\[68\]Wenchao Gu, Juntao Chen, Yanlin Wang, Tianyue Jiang, Xingzhe Li, Mingwei Liu, Xilin Liu, Yuchi Ma, and  
Zibin Zheng. What to retrieve for effective retrieval-augmented code generation? an empirical study and beyond,  
2025\.

\[69\]Le Deng, Xiaoxue Ren, Chao Ni, Ming Liang, David Lo, and Zhongxin Liu. Enhancing project-specific code  
completion by inferring internal api information. IEEE Transactions on Software Engineering, pages 1–17, 2025\.

\[70\]Junwei Liu, Yixuan Chen, Mingwei Liu, Xin Peng, and Yiling Lou. Stall+: Boosting llm-based repository-level  
code completion with static analysis, 2024\.

\[71\]Lakshya A Agrawal, Aditya Kanade, Navin Goyal, Shuvendu K. Lahiri, and Sriram K. Rajamani. Monitor-  
guided decoding of code lms with static analysis of repository context. In Proceedings of the 37th International  
Conference on Neural Information Processing Systems, NIPS ’23, Red Hook, NY, USA, 2023\. Curran Associates  
Inc.

\[72\]Yichen Li, Yun Peng, Yintong Huo, and Michael R. Lyu. Enhancing llm-based coding tools through native  
integration of ide-derived static context. In Proceedings of the 1st International Workshop on Large Language  
Models for Code, LLM4Code ’24, page 70–74, New York, NY, USA, 2024\. Association for Computing  
Machinery.

\[73\]Zhiyuan Pan, Xing Hu, Xin Xia, and Xiaohu Yang. Enhancing repository-level code generation with integrated  
contextual information, 2024\.

\[74\]Ajinkya Deshpande, Anmol Agarwal, Shashank Shet, Arun Iyer, Aditya Kanade, Ramakrishna Bairi, and Suresh  
Parthasarathy. Class-level code generation from natural language using iterative, tool-enhanced reasoning over  
repository, 2024\.

\[75\]Wei Cheng, Yuhan Wu, and Wei Hu. Dataflow-guided retrieval augmentation for repository-level code completion.  
In Lun-Wei Ku, Andre Martins, and Vivek Srikumar, editors, Proceedings of the 62nd Annual Meeting of the  
Association for Computational Linguistics (Volume 1: Long Papers), pages 7957–7977, Bangkok, Thailand,  
August 2024\. Association for Computational Linguistics.

\[76\]Kounianhua Du, Jizheng Chen, Renting Rui, Huacan Chai, Lingyue Fu, Wei Xia, Yasheng Wang, Ruiming Tang,  
Yong Yu, and Weinan Zhang. Codegrag: Bridging the gap between natural language and programming language  
via graphical retrieval augmented generation, 2025\.

\[77\]Wei Liu, Ailun Yu, Daoguang Zan, Bo Shen, Wei Zhang, Haiyan Zhao, Zhi Jin, and Qianxiang Wang. Graphcoder:  
Enhancing repository-level code completion via coarse-to-fine retrieval based on code context graph. In  
Proceedings of the 39th IEEE/ACM International Conference on Automated Software Engineering, ASE ’24,  
page 570–581, New York, NY, USA, 2024\. Association for Computing Machinery.

\[78\]Xiaohan Chen, Zhongying Pan, Quan Feng, Yu Tian, Shuqun Yang, Mengru Wang, Lina Gong, Yuxia Geng, Piji  
Li, and Xiang Chen. Saracoder: Orchestrating semantic and structural cues for profit-oriented repository-level  
code completion, 2025\.

\[79\]Iman Saberi and Fatemeh Fard. Context-augmented code generation using programming knowledge graphs.  
arXiv preprint arXiv:2410.18251, 2024\.

\[80\]Zhanming Guan, Junlin Liu, Jierui Liu, Chao Peng, Dexin Liu, Ningyuan Sun, Bo Jiang, Wenchao Li, Jie Liu,  
and Hang Zhu. Contextmodule: Improving code completion via repository-level contextual information. arXiv  
preprint arXiv:2412.08063, 2024\.

\[81\]Boyang Yang, Haoye Tian, Jiadong Ren, Shunfu Jin, Yang Liu, Feng Liu, and Bach Le. Enhancing repository-  
level software repair via repository-aware knowledge graphs, 2025\.

\[82\]Samuel Abedu, SayedHassan Khatoonabadi, and Emad Shihab. Synergizing llms and knowledge graphs: A  
novel approach to software repository-related question answering, 2024\.

\[83\]Zimin Chen, Yue Pan, Siyu Lu, Jiayi Xu, Claire Le Goues, Martin Monperrus, and He Ye. Prometheus: Unified  
knowledge graphs for issue resolution in multilingual codebases, 2025\.

\[84\]Huy N. Phan, Hoang N. Phan, Tien N. Nguyen, and Nghi D. Q. Bui. Repohyper: Search-expand-refine on  
semantic graphs for repository-level code completion. In 2025 IEEE/ACM Second International Conference on  
AI Foundation Models and Software Engineering (Forge), pages 14–25, 2025\.

\[85\]Yuntong Zhang, Haifeng Ruan, Zhiyu Fan, and Abhik Roychoudhury. Autocoderover: Autonomous program  
improvement. In Proceedings of the 33rd ACM SIGSOFT International Symposium on Software Testing and  
Analysis, ISSTA 2024, page 1592–1604, New York, NY, USA, 2024\. Association for Computing Machinery.

\[86\]Yingwei Ma, Qingping Yang, Rongyu Cao, Binhua Li, Fei Huang, and Yongbin Li. Alibaba lingmaagent:  
Improving automated issue resolution via comprehensive repository exploration. In Proceedings of the 33rd  
ACM International Conference on the Foundations of Software Engineering, FSE Companion ’25, page 238–249,  
New York, NY, USA, 2025\. Association for Computing Machinery.

\[87\]Zhangqian Bi, Yao Wan, Zheng Wang, Hongyu Zhang, Batu Guan, Fangxin Lu, Zili Zhang, Yulei Sui, Hai  
Jin, and Xuanhua Shi. Iterative refinement of project-level code context for precise code generation with  
compiler feedback. In Lun-Wei Ku, Andre Martins, and Vivek Srikumar, editors, Findings of the Association for  
Computational Linguistics: ACL 2024, pages 2336–2353, Bangkok, Thailand, August 2024\. Association for  
Computational Linguistics.

\[88\]Shuyin Ouyang, Jie M. Zhang, Zeyu Sun, and Albert Merono Penuela. Knowledge-enhanced program repair for  
data science code. In 2025 IEEE/ACM 47th International Conference on Software Engineering (ICSE), pages  
898–910, 2025\.

\[89\]Yang Liu, Li Zhang, Fang Liu, Zhuohang Wang, Donglin Wei, Zhishuo Yang, Kechi Zhang, Jia Li, and Lin Shi.  
Enhancing repository-level code generation with call chain-aware multi-view context, 2025\.

\[90\]Yangruibo Ding, Zijian Wang, Wasi Ahmad, Murali Krishna Ramanathan, Ramesh Nallapati, Parminder Bhatia,  
Dan Roth, and Bing Xiang. CoCoMIC: Code completion by jointly modeling in-file and cross-file context. In  
Nicoletta Calzolari, Min-Yen Kan, Veronique Hoste, Alessandro Lenci, Sakriani Sakti, and Nianwen Xue, editors,  
Proceedings of the 2024 Joint International Conference on Computational Linguistics, Language Resources and  
Evaluation (LREC-COLING 2024), pages 3433–3445, Torino, Italia, May 2024\. ELRA and ICCL.

\[91\]Jia Li, Xianjie Shi, Kechi Zhang, Lei Li, Ge Li, Zhengwei Tao, Jia Li, Fang Liu, Chongyang Tao, and Zhi Jin.  
Coderag: Supportive code retrieval on bigraph for real-world code generation, 2025\.

\`\`\`  
\[92\]Hongyuan Tao, Ying Zhang, Zhenhao Tang, Hongen Peng, Xukun Zhu, Bingchang Liu, Yingguang Yang, Ziyin  
Zhang, Zhaogui Xu, Haipeng Zhang, Linchao Zhu, Rui Wang, Hang Yu, Jianguo Li, and Peng Di. Code graph  
model (cgm): A graph-integrated large language model for repository-level software engineering tasks, 2025\.  
\[93\]Zhaoling Chen, Robert Tang, Gangda Deng, Fang Wu, Jialong Wu, Zhiwei Jiang, Viktor Prasanna, Arman  
Cohan, and Xingyao Wang. LocAgent: Graph-guided LLM agents for code localization. In Wanxiang Che,  
Joyce Nabende, Ekaterina Shutova, and Mohammad Taher Pilehvar, editors, Proceedings of the 63rd Annual  
Meeting of the Association for Computational Linguistics (Volume 1: Long Papers), pages 8697–8727, Vienna,  
Austria, July 2025\. Association for Computational Linguistics.  
\[94\]Zhonghao Jiang, Xiaoxue Ren, Meng Yan, Wei Jiang, Yong Li, and Zhongxin Liu. Cosil: Software issue  
localization via llm-driven code repository graph searching, 2025\.  
\[95\]David Sounthiraraj, Jared Hancock, Yassin Kortam, Ashok Javvaji, Prabhat Singh, and Shaila Shankar. Code-  
craft: Hierarchical graph-based code summarization for enhanced context retrieval, 2025\.  
\[96\]Zhijie Jiang, Zejian Shi, Xinyu Gao, and Yun Xiong. Enhancing code generation through retrieval of cross-lingual  
semantic graphs. In 2024 31st Asia-Pacific Software Engineering Conference (APSEC), pages 151–160, 2024\.  
\[97\]Xunzhu Tang, Jiechao Gao, Jin Xu, Tiezhu Sun, Yewei Song, Saad Ezzini, Wendkûuni C. Ouédraogo, Jacques  
Klein, and Tegawendé F. Bissyandé. SynFix: Dependency-aware program repair via RelationGraph analysis.  
In Wanxiang Che, Joyce Nabende, Ekaterina Shutova, and Mohammad Taher Pilehvar, editors, Findings of the  
Association for Computational Linguistics: ACL 2025, pages 4878–4894, Vienna, Austria, July 2025\. Association  
for Computational Linguistics.  
\[98\]S. E. Robertson and S. Walker. Some simple effective approximations to the 2-poisson model for probabilistic  
weighted retrieval. In Bruce W. Croft and C. J. van Rijsbergen, editors, SIGIR ’94, pages 232–241, London,  
\`\`\`  
1994\. Springer London.  
\[99\]Paul Jaccard. Etude de la distribution florale dans une portion des alpes et du jura. Bulletin de la Societe Vaudoise  
des Sciences Naturelles, 37:547–579, 01 1901\.

\[100\]Daya Guo, Shuo Ren, Shuai Lu, Zhangyin Feng, Duyu Tang, Shujie LIU, Long Zhou, Nan Duan, Alexey  
Svyatkovskiy, Shengyu Fu, Michele Tufano, Shao Kun Deng, Colin Clement, Dawn Drain, Neel Sundaresan,  
Jian Yin, Daxin Jiang, and Ming Zhou. Graphcode{bert}: Pre-training code representations with data flow. In  
International Conference on Learning Representations, 2021\.

\[101\]Daya Guo, Shuai Lu, Nan Duan, Yanlin Wang, Ming Zhou, and Jian Yin. UniXcoder: Unified cross-modal  
pre-training for code representation. In Smaranda Muresan, Preslav Nakov, and Aline Villavicencio, editors,  
Proceedings of the 60th Annual Meeting of the Association for Computational Linguistics (Volume 1: Long  
Papers), pages 7212–7225, Dublin, Ireland, May 2022\. Association for Computational Linguistics.

\[102\]Lihong Li, Wei Chu, John Langford, and Robert E. Schapire. A contextual-bandit approach to personalized news  
article recommendation. In Proceedings of the 19th International Conference on World Wide Web, WWW ’10,  
page 661–670, New York, NY, USA, 2010\. Association for Computing Machinery.

\[103\]Xiangyan Liu, Bo Lan, Zhiyuan Hu, Yang Liu, Zhicheng Zhang, Fei Wang, Michael Qizhe Shieh, and Wenmeng  
Zhou. CodexGraph: Bridging large language models and code repositories via code graph databases. In Luis  
Chiruzzo, Alan Ritter, and Lu Wang, editors, Proceedings of the 2025 Conference of the Nations of the Americas  
Chapter of the Association for Computational Linguistics: Human Language Technologies (Volume 1: Long  
Papers), pages 142–160, Albuquerque, New Mexico, April 2025\. Association for Computational Linguistics.

\[104\]Ramakrishna Bairi, Atharv Sonwane, Aditya Kanade, Vageesh D. C., Arun Iyer, Suresh Parthasarathy, Sriram  
Rajamani, B. Ashok, and Shashank Shet. Codeplan: Repository-level coding using llms and planning. Proc.  
ACM Softw. Eng., 1(FSE), July 2024\.

\[105\]Mihir Athale and Vishal Vaddina. Knowledge graph based repository-level code generation. In 2025 IEEE/ACM  
International Workshop on Large Language Models for Code (LLM4Code), page 169–176. IEEE, May 2025\.

\[106\]Han Li, Yuling Shi, Shaoxin Lin, Xiaodong Gu, Heng Lian, Xin Wang, Yantao Jia, Tao Huang, and Qianxiang  
Wang. Swe-debate: Competitive multi-agent debate for software issue resolution, 2025\.

\[107\]Silin Chen, Shaoxin Lin, Xiaodong Gu, Yuling Shi, Heng Lian, Longfei Yun, Dong Chen, Weiguo Sun, Lin Cao,  
and Qianxiang Wang. Swe-exp: Experience-driven software issue resolution, 2025\.

\[108\]Bo Lin, Shangwen Wang, Yihao Qin, Liqian Chen, and Xiaoguang Mao. Give llms a security course: Securing  
retrieval-augmented code generation via knowledge injection, 2025\.

\[109\]Catherine Tony, Emanuele Iannone, and Riccardo Scandariato. Retrieve, refine, or both? using task-specific  
guidelines for secure python code generation, 2025\. manuscript available athttps://emaiannone.github.  
io/assets/pdf/c6.pdf.

\[110\]Yunda Tsai, Mingjie Liu, and Haoxing Ren. Rtlfixer: Automatically fixing rtl syntax errors with large language  
model. In Proceedings of the 61st ACM/IEEE Design Automation Conference, DAC ’24, New York, NY, USA,

2024\. Association for Computing Machinery.

\[111\]Chalamalasetti Kranti, Sherzod Hakimov, and David Schlangen. Retrieval-augmented code generation for  
situated action generation: A case study on Minecraft. In Yaser Al-Onaizan, Mohit Bansal, and Yun-Nung Chen,  
editors, Findings of the Association for Computational Linguistics: EMNLP 2024, pages 11159–11170, Miami,  
Florida, USA, November 2024\. Association for Computational Linguistics.

\[112\]YIBO PENG, Zora Zhiruo Wang, and Daniel Fried. Can long-context language models solve repository-level  
code generation? In LTI Student Research Symposium 2025, 2025\.

\[113\]Mingwei Liu, Tianyong Yang, Yiling Lou, Xueying Du, Ying Wang, and Xin Peng. Codegen4libs: A two-stage  
approach for library-oriented code generation. In 2023 38th IEEE/ACM International Conference on Automated  
Software Engineering (ASE), pages 434–445, 2023\.

\[114\]Jingyi Chen, Songqiang Chen, Jialun Cao, Jiasi Shen, and Shing-Chi Cheung. When llms meet api documentation:  
Can retrieval augmentation aid code generation just as it helps developers?, 2025\.

\[115\]Zezhou Yang, Sirong Chen, Cuiyun Gao, Zhenhao Li, Xing Hu, Kui Liu, and Xin Xia. An empirical study of  
retrieval-augmented code generation: Challenges and opportunities. ACM Trans. Softw. Eng. Methodol., 34(7),  
August 2025\.

\[116\]Marko Hostnik and Marko Robnik-Šikonja. Retrieval-augmented code completion for local projects using large  
language models. Expert Systems with Applications, 292:128596, 2025\.

\[117\]Mingjian Jiang, Yangjun Ruan, Luis Lastras, Pavan Kapanipathi, and Tatsunori Hashimoto. Putting it all into  
context: Simplifying agents with lclms, 2025\.

\[118\]Amirkia Rafiei Oskooei, Selcan Yukcu, Mehmet Cevheri Bozoglan, and Mehmet S. Aktas. Repository-level  
code understanding by llms via hierarchical summarization: Improving code search and bug localization. In  
Osvaldo Gervasi, Beniamino Murgante, Chiara Garau, Yeliz Karaca, Maria Noelia Faginas Lago, Francesco  
Scorza, and Ana Cristina Braga, editors, Computational Science and Its Applications – ICCSA 2025 Workshops,  
pages 88–105, Cham, 2026\. Springer Nature Switzerland.

\[119\]Zexiong Ma, Chao Peng, Pengfei Gao, Xiangxin Meng, Yanzhen Zou, and Bing Xie. SoRFT: Issue resolv-  
ing with subtask-oriented reinforced fine-tuning. In Wanxiang Che, Joyce Nabende, Ekaterina Shutova, and  
Mohammad Taher Pilehvar, editors, Proceedings of the 63rd Annual Meeting of the Association for Computa-  
tional Linguistics (Volume 1: Long Papers), pages 11427–11441, Vienna, Austria, July 2025\. Association for  
Computational Linguistics.

\[120\]Jia Li, Hao Zhu, Huanyu Liu, Xianjie Shi, He Zong, Yihong Dong, Kechi Zhang, Siyuan Jiang, Zhi Jin, and  
Ge Li. aixcoder-7b-v2: Training llms to fully utilize the long context in repository-level code completion, 2025\.

\[121\]Andrew Blinn, Xiang Li, June Hyung Kim, and Cyrus Omar. Statically contextualizing large language models  
with typed holes. Proc. ACM Program. Lang., 8(OOPSLA2), October 2024\.

\[122\]Zezhou Yang, Ting Peng, Cuiyun Gao, Chaozheng Wang, Hailiang Huang, and Yuetang Deng. A deep dive into  
retrieval-augmented generation for code completion: Experience on wechat, 2025\.

\[123\]Chaozheng Wang, Zezhou Yang, Shuzheng Gao, Cuiyun Gao, Ting Peng, Hailiang Huang, Yuetang Deng,  
and Michael Lyu. Rag or fine-tuning? a comparative study on lcms-based code completion in industry. In  
Proceedings of the 33rd ACM International Conference on the Foundations of Software Engineering, FSE  
Companion ’25, page 93–104, New York, NY, USA, 2025\. Association for Computing Machinery.

\[124\]Maksim Sapronov and Evgeniy Glukhov. On pretraining for project-level code completion. In ICLR 2025 Third  
Workshop on Deep Learning for Code, 2025\.

\[125\]Matthew Jin, Syed Shahriar, Michele Tufano, Xin Shi, Shuai Lu, Neel Sundaresan, and Alexey Svyatkovskiy.  
Inferfix: End-to-end program repair with llms. In Proceedings of the 31st ACM Joint European Software  
Engineering Conference and Symposium on the Foundations of Software Engineering, ESEC/FSE 2023, page  
1646–1656, New York, NY, USA, 2023\. Association for Computing Machinery.

\[126\]Xinze Li, Hanbin Wang, Zhenghao Liu, Shi Yu, Shuo Wang, Yukun Yan, Yukai Fu, Yu Gu, and Ge Yu. Building  
a coding assistant via the retrieval-augmented language model. ACM Trans. Inf. Syst., 43(2), January 2025\.

\[127\]Revanth Gangi Reddy, Tarun Suresh, JaeHyeok Doo, Ye Liu, Xuan Phi Nguyen, Yingbo Zhou, Semih Yavuz,  
Caiming Xiong, Heng Ji, and Shafiq Joty. Swerank: Software issue localization with code ranking, 2025\.

\[128\]Ye Liu, Rui Meng, Shafiq Joty, silvio savarese, Caiming Xiong, Yingbo Zhou, and Semih Yavuz. CodeXEmbed:  
A generalist embedding model family for multilingual and multi-task code retrieval. In Second Conference on  
Language Modeling, 2025\.

\[129\]Di Wu, Wasi Uddin Ahmad, Dejiao Zhang, Murali Krishna Ramanathan, and Xiaofei Ma. Repoformer: selective  
retrieval for repository-level code completion. In Proceedings of the 41st International Conference on Machine  
Learning, ICML’24. JMLR.org, 2024\.

\[130\]Disha Shrivastava, Denis Kocetkov, Harm de Vries, Dzmitry Bahdanau, and Torsten Scholak. Repofusion:  
Training code models to understand your repository, 2023\.

\[131\]Hitesh Sagtani, Rishabh Mehrotra, and Beyang Liu. Improving fim code completions via context & curriculum  
based learning. In Proceedings of the Eighteenth ACM International Conference on Web Search and Data  
Mining, WSDM ’25, page 801–810, New York, NY, USA, 2025\. Association for Computing Machinery.

\[132\]Xinran Yu, Chun Li, Minxue Pan, and Xuandong Li. Droidcoder: Enhanced android code completion with  
context-enriched retrieval-augmented generation. In Proceedings of the 39th IEEE/ACM International Conference  
on Automated Software Engineering, ASE ’24, page 681–693, New York, NY, USA, 2024\. Association for  
Computing Machinery.

\[133\]Peiyang Wu, Nan Guo, Junliang Lv, Xiao Xiao, and Xiaochun Ye. Rtlrepocoder: Repository-level rtl code  
completion through the combination of fine-tuning and retrieval augmentation, 2025\.

\[134\]Yanlin Wang, Yanli Wang, Daya Guo, Jiachi Chen, Ruikai Zhang, Yuchi Ma, and Zibin Zheng. RLCoder:  
Reinforcement Learning for Repository-Level Code Completion. In 2025 IEEE/ACM 47th International  
Conference on Software Engineering (ICSE), pages 1140–1152, Los Alamitos, CA, USA, May 2025\. IEEE  
Computer Society.

\[135\]Xiaoxi Li, Jiajie Jin, Guanting Dong, Hongjin Qian, Yutao Zhu, Yongkang Wu, Ji-Rong Wen, and Zhicheng Dou.  
Webthinker: Empowering large reasoning models with deep research capability, 2025\.

\[136\]Xu Yang, Xiao Yang, Shikai Fang, Bowen Xian, Yuante Li, Jian Wang, Minrui Xu, Haoran Pan, Xinpeng Hong,  
Weiqing Liu, et al. R\&d-agent: Automating data-driven ai solution building through llm-powered automated  
research, development, and evolution. arXiv preprint arXiv:2505.14738, 2025\.

\[137\]Yuante Li, Xu Yang, Xiao Yang, Minrui Xu, Xisen Wang, Weiqing Liu, and Jiang Bian. R\&d-agent-quant: A  
multi-agent framework for data-centric factors and model joint optimization. arXiv preprint arXiv:2505.15155,  
2025\.

\[138\]Shyam Sundar Kannan, Vishnunandan L. N. Venkatesh, and Byung-Cheol Min. Smart-llm: Smart multi-agent  
robot task planning using large language models. In 2024 IEEE/RSJ International Conference on Intelligent  
Robots and Systems (IROS), pages 12140–12147, 2024\.

\[139\]Sirui Hong, Mingchen Zhuge, Jonathan Chen, Xiawu Zheng, Yuheng Cheng, Jinlin Wang, Ceyao Zhang,  
Zili Wang, Steven Ka Shing Yau, Zijuan Lin, Liyang Zhou, Chenyu Ran, Lingfeng Xiao, Chenglin Wu, and  
Jürgen Schmidhuber. MetaGPT: Meta programming for a multi-agent collaborative framework. In The Twelfth  
International Conference on Learning Representations, 2024\.

\[140\]Haoxue Wang, Keli Wen, Yuante Li, Qiancheng Qu, Xiangxu Mu, Xinjie Shen, Jiaqi Gao, Chenyang Chang,  
Chuhan Xie, San Yu Cheung, Zhuoyuan Hu, Xinyu Wang, Sirui Bi, and Bi’an Du. Quantmind: A context-  
engineering based knowledge framework for quantitative finance, 2025\.

\[141\]Alireza Ghafarollahi and Markus J. Buehler. Sciagents: Automating scientific discovery through multi-agent  
intelligent graph reasoning, 2024\.

\[142\]Zhe Zhang, Xingyu Liu, Yuanzhang Lin, Xiang Gao, Hailong Sun, and Yuan Yuan. Llm-based unit test generation  
via property retrieval, 2024\.

\[143\]Xingyao Wang, Boxuan Li, Yufan Song, Frank F. Xu, Xiangru Tang, Mingchen Zhuge, Jiayi Pan, Yueqi Song,  
Bowen Li, Jaskirat Singh, Hoang H. Tran, Fuqiang Li, Ren Ma, Mingzhang Zheng, Bill Qian, Yanjun Shao,  
Niklas Muennighoff, Yizhe Zhang, Binyuan Hui, Junyang Lin, Robert Brennan, Hao Peng, Heng Ji, and Graham  
Neubig. Openhands: An open platform for AI software developers as generalist agents. In The Thirteenth  
International Conference on Learning Representations, 2025\.

\[144\]Chunqiu Steven Xia, Yinlin Deng, Soren Dunn, and Lingming Zhang. Demystifying llm-based software  
engineering agents. Proc. ACM Softw. Eng., 2(FSE), June 2025\.

\[145\]Mark Chen, Jerry Tworek, Heewoo Jun, Qiming Yuan, Henrique Ponde De Oliveira Pinto, Jared Kaplan, Harri  
Edwards, Yuri Burda, Nicholas Joseph, Greg Brockman, et al. Evaluating large language models trained on code.  
arXiv preprint arXiv:2107.03374, 2021\.

\[146\]Jacob Austin, Augustus Odena, Maxwell Nye, Maarten Bosma, Henryk Michalewski, David Dohan, Ellen Jiang,  
Carrie Cai, Michael Terry, Quoc Le, and Charles Sutton. Program synthesis with large language models, 2021\.

\[147\]Pengcheng Yin, Bowen Deng, Edgar Chen, Bogdan Vasilescu, and Graham Neubig. Learning to mine aligned  
code and natural language pairs from stack overflow. In International Conference on Mining Software Reposito-  
ries, MSR, pages 476–486. ACM, 2018\.

\[148\]Berkay Berabi, Jingxuan He, Veselin Raychev, and Martin T. Vechev. Tfix: Learning to fix coding errors with a  
text-to-text transformer. In ICML, 2021\.

\[149\]Tianyang Liu, Canwen Xu, and Julian McAuley. Repobench: Benchmarking repository-level code auto-  
completion systems. In The Twelfth International Conference on Learning Representations, 2024\.

\[150\]Yangruibo Ding, Zijian Wang, Wasi Uddin Ahmad, Hantian Ding, Ming Tan, Nihal Jain, Murali Krishna  
Ramanathan, Ramesh Nallapati, Parminder Bhatia, Dan Roth, and Bing Xiang. Crosscodeeval: a diverse and  
multilingual benchmark for cross-file code completion. In Proceedings of the 37th International Conference on  
Neural Information Processing Systems, NIPS ’23, Red Hook, NY, USA, 2023\. Curran Associates Inc.

\[151\]Hao Yu, Bo Shen, Dezhi Ran, Jiaxin Zhang, Qi Zhang, Yuchi Ma, Guangtai Liang, Ying Li, Qianxiang Wang,  
and Tao Xie. Codereval: A benchmark of pragmatic code generation with generative pre-trained models. In  
Proceedings of the IEEE/ACM 46th International Conference on Software Engineering, ICSE ’24, New York,  
NY, USA, 2024\. Association for Computing Machinery.

\[152\]Jia Li, Ge Li, Yunfei Zhao, Yongmin Li, Huanyu Liu, Hao Zhu, Lecheng Wang, Kaibo Liu, Zheng Fang, Lanshen  
Wang, Jiazheng Ding, Xuanming Zhang, Yuqi Zhu, Yihong Dong, Zhi Jin, Binhua Li, Fei Huang, Yongbin Li,  
Bin Gu, and Mengfei Yang. DevEval: A manually-annotated code generation benchmark aligned with real-world  
code repositories. In Lun-Wei Ku, Andre Martins, and Vivek Srikumar, editors, Findings of the Association for  
Computational Linguistics: ACL 2024, pages 3603–3614, Bangkok, Thailand, August 2024\. Association for  
Computational Linguistics.

\[153\]Jia Li, Ge Li, Xuanming Zhang, Yunfei Zhao, Yihong Dong, Zhi Jin, Binhua Li, Fei Huang, and Yongbin Li.  
Evocodebench: an evolving code generation benchmark with domain-specific evaluations. In Proceedings of the  
38th International Conference on Neural Information Processing Systems, NIPS ’24, Red Hook, NY, USA, 2025\.  
Curran Associates Inc.

\[154\]Egor Bogomolov, Aleksandra Eliseeva, Timur Galimzyanov, Evgeniy Glukhov, Anton Shapkin, Maria Tigina,  
Yaroslav Golubev, Alexander Kovrigin, Arie van Deursen, Maliheh Izadi, and Timofey Bryksin. Long code  
arena: a set of benchmarks for long-context code models, 2024\.

\[155\]Aider Team. Aider polyglot leaderboard.https://aider.chat/docs/leaderboards/, 2024\. Accessed:  
2025-08-21.

\[156\]Naman Jain, King Han, Alex Gu, Wen-Ding Li, Fanjia Yan, Tianjun Zhang, Sida Wang, Armando Solar-Lezama,  
Koushik Sen, and Ion Stoica. Livecodebench: Holistic and contamination free evaluation of large language  
models for code. In The Thirteenth International Conference on Learning Representations, 2025\.

\[157\]Shuai Lu, Daya Guo, Shuo Ren, Junjie Huang, Alexey Svyatkovskiy, Ambrosio Blanco, Colin Clement, Dawn  
Drain, Daxin Jiang, Duyu Tang, Ge Li, Lidong Zhou, Linjun Shou, Long Zhou, Michele Tufano, MING GONG,  
Ming Zhou, Nan Duan, Neel Sundaresan, Shao Kun Deng, Shengyu Fu, and Shujie LIU. CodeXGLUE: A  
machine learning benchmark dataset for code understanding and generation. In Thirty-fifth Conference on Neural  
Information Processing Systems Datasets and Benchmarks Track (Round 1), 2021\.

\[158\]John Yang, Carlos E Jimenez, Alex L Zhang, Kilian Lieret, Joyce Yang, Xindi Wu, Ori Press, Niklas Muennighoff,  
Gabriel Synnaeve, Karthik R Narasimhan, Diyi Yang, Sida Wang, and Ofir Press. SWE-bench multimodal: Do  
AI systems generalize to visual software domains? In The Thirteenth International Conference on Learning  
Representations, 2025\.

\[159\]Qiming Zhu, Jialun Cao, Xuanang Chen, Yaojie Lu, Hongyu Lin, Xianpei Han, Le Sun, and Shing-Chi Cheung.  
Across programming language silos: A study on cross-lingual retrieval-augmented code generation, 2025\.

\[160\]Yue Wang, Weishi Wang, Shafiq Joty, and Steven C.H. Hoi. CodeT5: Identifier-aware unified pre-trained  
encoder-decoder models for code understanding and generation. In Marie-Francine Moens, Xuanjing Huang,  
Lucia Specia, and Scott Wen-tau Yih, editors, Proceedings of the 2021 Conference on Empirical Methods in  
Natural Language Processing, pages 8696–8708, Online and Punta Cana, Dominican Republic, November 2021\.  
Association for Computational Linguistics.

\[161\]Voyage AI. voyage-code-3: more accurate code retrieval with lower dimensional, quantized embeddings.  
https://blog.voyageai.com/2024/12/04/voyage-code-3/, December 2024\. Voyage AI blog post.

\[162\]Dun Zhang, Jiacheng Li, Ziyang Zeng, and Fulong Wang. Jasper and stella: distillation of sota embedding  
models. arXiv preprint arXiv:2412.19048, 2024\.

\[163\]Zhangyin Feng, Daya Guo, Duyu Tang, Nan Duan, Xiaocheng Feng, Ming Gong, Linjun Shou, Bing Qin, Ting  
Liu, Daxin Jiang, et al. Codebert: A pre-trained model for programming and natural languages. arXiv preprint  
arXiv:2002.08155, 2020\.

\[164\]OpenAI. text-embedding-ada-002. https://platform.openai.com/docs/models/  
text-embedding-ada-002, August 2025\. OpenAI API documentation.

\[165\]Stephen E. Robertson, Steve Walker, Susan Jones, Micheline M. Hancock-Beaulieu, and Mike Gatford. Okapi at  
trec-3. Proceedings of the Third Text REtrieval Conference (TREC-3), pages 109–126, 1995\.

\[166\]Paul Jaccard. Comparative study of the floral distribution in a portion of the alps and the jura. Bulletin of the  
Vaud Society of Natural Sciences, 37:547–579, 1901\.

\[167\]Erik Nijkamp, Bo Pang, Hiroaki Hayashi, Lifu Tu, Huan Wang, Yingbo Zhou, Silvio Savarese, and Caiming  
Xiong. Codegen: An open large language model for code with multi-turn program synthesis. ICLR, 2023\.

\[168\]Erik Nijkamp, Hiroaki Hayashi, Caiming Xiong, Silvio Savarese, and Yingbo Zhou. Codegen2: Lessons for  
training llms on programming and natural languages. ICLR, 2023\.

\[169\] Loubna Ben Allal, Raymond Li, Denis Kocetkov, Chenghao Mou, Christopher Akiki, Carlos Munoz Ferrandis,  
Niklas Muennighoff, Mayank Mishra, Alex Gu, Manan Dey, et al. Santacoder: don’t reach for the stars\! arXiv  
preprint arXiv:2301.03988, 2023\.

\[170\]Raymond Li, Loubna Ben Allal, Yangtian Zi, Niklas Muennighoff, Denis Kocetkov, Chenghao Mou, Marc  
Marone, Christopher Akiki, Jia Li, Jenny Chim, et al. Starcoder: may the source be with you\! arXiv preprint  
arXiv:2305.06161, 2023\.

\[171\]Anton Lozhkov, Raymond Li, Loubna Ben Allal, Federico Cassano, Joel Lamy-Poirier, Nouamane Tazi, Ao Tang,  
Dmytro Pykhtar, Jiawei Liu, Yuxiang Wei, et al. Starcoder 2 and the stack v2: The next generation. arXiv  
preprint arXiv:2402.19173, 2024\.

\[172\]Baptiste Roziere, Jonas Gehring, Fabian Gloeckle, Sten Sootla, Itai Gat, Xiaoqing Ellen Tan, Yossi Adi, Jingyu  
Liu, Romain Sauvestre, Tal Remez, et al. Code llama: Open foundation models for code. arXiv preprint  
arXiv:2308.12950, 2023\.

\[173\]Daya Guo, Qihao Zhu, Dejian Yang, Zhenda Xie, Kai Dong, Wentao Zhang, Guanting Chen, Xiao Bi, Yu Wu,  
YK Li, et al. Deepseek-coder: When the large language model meets programming–the rise of code intelligence.  
arXiv preprint arXiv:2401.14196, 2024\.

\[174\]DeepSeek-AI, Qihao Zhu, Daya Guo, Zhihong Shao, Dejian Yang, Peiyi Wang, Runxin Xu, Y. Wu, Yukun Li,  
Huazuo Gao, Shirong Ma, Wangding Zeng, Xiao Bi, Zihui Gu, Hanwei Xu, Damai Dai, Kai Dong, Liyue Zhang,  
Yishi Piao, Zhibin Gou, Zhenda Xie, Zhewen Hao, Bingxuan Wang, Junxiao Song, Deli Chen, Xin Xie, Kang  
Guan, Yuxiang You, Aixin Liu, Qiushi Du, Wenjun Gao, Xuan Lu, Qinyu Chen, Yaohui Wang, Chengqi Deng,  
Jiashi Li, Chenggang Zhao, Chong Ruan, Fuli Luo, and Wenfeng Liang. Deepseek-coder-v2: Breaking the  
barrier of closed-source models in code intelligence, 2024\.

\[175\]Jinze Bai, Shuai Bai, Yunfei Chu, Zeyu Cui, Kai Dang, Xiaodong Deng, Yang Fan, Wenbin Ge, Yu Han, Fei  
Huang, Binyuan Hui, Luo Ji, Mei Li, Junyang Lin, Runji Lin, Dayiheng Liu, Gao Liu, Chengqiang Lu, Keming  
Lu, Jianxin Ma, Rui Men, Xingzhang Ren, Xuancheng Ren, Chuanqi Tan, Sinan Tan, Jianhong Tu, Peng Wang,  
Shijie Wang, Wei Wang, Shengguang Wu, Benfeng Xu, Jin Xu, An Yang, Hao Yang, Jian Yang, Shusheng Yang,  
Yang Yao, Bowen Yu, Hongyi Yuan, Zheng Yuan, Jianwei Zhang, Xingxuan Zhang, Yichang Zhang, Zhenru  
Zhang, Chang Zhou, Jingren Zhou, Xiaohuan Zhou, and Tianhang Zhu. Qwen technical report. arXiv preprint  
arXiv:2309.16609, 2023\.

\[176\]Binyuan Hui, Jian Yang, Zeyu Cui, Jiaxi Yang, Dayiheng Liu, Lei Zhang, Tianyu Liu, Jiajun Zhang, Bowen Yu,  
Keming Lu, et al. Qwen2. 5-coder technical report. arXiv preprint arXiv:2409.12186, 2024\.


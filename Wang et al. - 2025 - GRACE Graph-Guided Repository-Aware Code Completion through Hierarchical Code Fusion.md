\#\# GRACE: Graph-Guided Repository-Aware Code Completion

\#\# through Hierarchical Code Fusion

\#\# Xingliang Wang

\#\#\# Zhejiang University

\#\#\# Hangzhou, Zhejiang, China

\#\#\# wangxingliang@zju.edu.cn

\#\# Baoyi Wang

\#\#\# Zhejiang University

\#\#\# Hangzhou, Zhejiang, China

\#\#\# wangbaoyi@zju.edu.cn

\#\# Haoran Xu

\#\#\# Zhejiang University

\#\#\# Hangzhou, Zhejiang, China

\#\#\# haoran.x@zju.edu.cn

\#\# Chen Zhi∗

\#\#\# Zhejiang University

\#\#\# Hangzhou, Zhejiang, China

\#\#\# zjuzhichen@zju.edu.cn

\#\# Junxiao Han

\#\#\# Hangzhou City University

\#\#\# Hangzhou, Zhejiang, China

\#\#\# hanjx@hzcu.edu.cn

\#\# Xinkui Zhao

\#\#\# Zhejiang University

\#\#\# Hangzhou, Zhejiang, China

\#\#\# zhaoxinkui@zju.edu.cn

\#\# Jianwei Yin

\#\#\# Zhejiang University

\#\#\# Hangzhou, Zhejiang, China

\#\#\# zjuyjw@zju.edu.cn

\#\# Shuiguang Deng

\#\#\# Zhejiang University

\#\#\# Hangzhou, Zhejiang, China

\#\#\# dengsg@zju.edu.cn

\#\# ABSTRACT

\`\`\`  
Large language models (LLMs) excel in localized code completion  
but struggle with repository-level tasks due to limited context win-  
dows and complex semantic and structural dependencies across  
codebases. While Retrieval-Augmented Generation (RAG) mitigates  
context scarcity by retrieving relevant code snippets, current ap-  
proaches face significant limitations. They overly rely on textual  
similarity for retrieval, neglecting structural relationships such as  
call chains and inheritance hierarchies, and lose critical structural  
information by naively concatenating retrieved snippets into text  
sequences for LLM input. To address these shortcomings, we pro-  
pose GRACE, a novel framework that reimagines code repositories  
as hierarchical, semantically rich graph databases, fundamentally  
advancing repository-level code completion. GRACE constructs a  
multi-level, multi-semantic code graph that unifies file structures,  
abstract syntax trees, function call graphs, class hierarchies, and  
data flow graphs to capture both static and dynamic code seman-  
tics. For retrieval, GRACE employs a Hybrid Graph Retriever that  
integrates graph neural network-based structural similarity with  
textual retrieval, refined by a graph attention network-based re-  
ranker to prioritize topologically relevant subgraphs. To enhance  
context, GRACE introduces a structural fusion mechanism that  
merges retrieved subgraphs with the local code context and serial-  
izes the unified graph into LLM-readable text with explicit structural  
markers, preserving essential dependencies like function calls and  
inheritance. This work provides the first systematic analysis of  
∗Corresponding author  
\`\`\`  
\`\`\`  
Permission to make digital or hard copies of all or part of this work for personal or  
classroom use is granted without fee provided that copies are not made or distributed  
for profit or commercial advantage and that copies bear this notice and the full citation  
on the first page. Copyrights for components of this work owned by others than the  
author(s) must be honored. Abstracting with credit is permitted. To copy otherwise, or  
republish, to post on servers or to redistribute to lists, requires prior specific permission  
and/or a fee. Request permissions from permissions@acm.org.  
Conference ICSE ’26, April 12-18, 2026, Rio de Janeiro, Brazil  
©2026 Copyright held by the owner/author(s). Publication rights licensed to ACM.  
ACM ISBN 978-1-4503-XXXX-X/2026/06... $15.  
https://doi.org/XXXXXXX.XXXXXXX  
\`\`\`  
\`\`\`  
graph structures in repository-level code completion, introducing  
a novel multi-semantic graph representation, a structure-aware  
hybrid retrieval and reranking strategy, and an innovative graph  
fusion technique that prevents structural information loss. Exten-  
sive experiments on public repository-level benchmarks demon-  
strate that GRACE significantly outperforms state-of-the-art meth-  
ods across all metrics. Using DeepSeek-V3 as the backbone LLM,  
GRACE surpasses the strongest graph-based RAG baselines by 8.19%  
EM and 7.51% ES points on every dataset. The code is available at  
https://anonymous.4open.science/r/grace\_icse-C3D5.  
\`\`\`  
\#\# CCS CONCEPTS

\- Do Not Use This Code→Generate the Correct Terms for  
Your Paper;Generate the Correct Terms for Your Paper; Generate  
the Correct Terms for Your Paper; Generate the Correct Terms for  
Your Paper.

\#\# KEYWORDS

\`\`\`  
Code Completion, Code Generation, Large Language Model, Graph,  
RAG  
ACM Reference Format:  
Xingliang Wang, Baoyi Wang, Haoran Xu, Chen Zhi, Junxiao Han, Xinkui  
Zhao, Jianwei Yin, and Shuiguang Deng. 2026\. GRACE: Graph-Guided  
Repository-Aware Code Completion through Hierarchical Code Fusion.  
InProceedings of ICSE ’26: 48th International Conference on Software Engi-  
neering (Conference ICSE ’26).ACM, New York, NY, USA, 13 pages. https:  
//doi.org/XXXXXXX.XXXXXXX  
\`\`\`  
\#\# 1 INTRODUCTION

\`\`\`  
In recent years, large language models\[ 3 , 10 , 11 , 15 , 16 , 33 , 34 , 40 , 56 \]  
have demonstrated remarkable capabilities in function-level or file-  
level code completion tasks\[ 6 , 49 , 52 , 55 , 57 \]. However, real-world  
software development typically involves large-scale, multi-module  
code repositories whose complexity far exceeds that of individual  
files. In this context, code completion faces significant challenges:  
(1) the vast scale of codebases exceeds the limited context window  
\`\`\`  
\# arXiv:2509.05980v1 \[cs.SE\] 7 Sep 2025

Conference ICSE ’26, April 12-18, 2026, Rio de Janeiro, Brazil Trovato et al.

of LLMs\[ 41 \]; (2) intricate semantic and structural dependencies (e.g.,  
inheritance, implementation, call chains, data flow) exist between  
code entities (classes, functions, variables). These factors lead to  
a substantial degradation in performance when LLMs are directly  
applied to repository-level code completion\[45, 46, 51, 53\].  
To address these issues, the Retrieval-Augmented Generation  
(RAG) paradigm has gradually become the mainstream solution\[ 2 ,  
20 , 25 , 35 , 53 \]. Although RAG partially mitigates the context limi-  
tation problem, existing RAG techniques for repository-level code  
completion suffer from two critical limitations.  
First, most existing studies\[ 22 , 50 , 53 \] rely on semantic similarity  
to retrieve relevant code while neglecting structural information  
as shown in Figure 1\. Current RAG methods typically treat code as  
plain text sequences and primarily rely on traditional text retrieval  
techniques such as BM25\[ 39 \], embedding-based similarity, or TF-  
IDF. This approach struggles to capture the rich structural informa-  
tion inherent in code\[ 36 \], including class inheritance hierarchies,  
interface implementation patterns, cross-module call dependen-  
cies, and complex dataflow paths. While a few studies attempt to  
incorporate simple graph structures\[ 12 , 27 \] like Abstract Syntax  
Trees (ASTs)\[ 19 , 21 \], their utilization of code structural information  
remains rudimentary, failing to adequately exploit deep semantic  
relationships. Second, the utilization of retrieved results is limited  
to text-level concatenation. Existing methods\[ 24 , 30 , 37 \] commonly  
adopt simple sequential concatenation strategies as shown in Figure  
1, feeding the concatenation of retrieved code snippets into the LLM.  
This approach entirely ignores potential structural relationships  
between the retrieved code snippets and the incomplete code, such  
as variable definition-use chains, method override inheritance, and  
cross-snippet call dependencies. The absence of this information  
severely constrains the LLM’s ability to understand and leverage  
the retrieved context.  
To address these issues, we propose a fundamental paradigm  
shift: modeling the entire code repository as a hierarchical, semantically-  
rich code graph database and designing a novel graph-based RAG  
pipeline on this foundation. The core of this approach lies in lever-  
aging the graph structure’s ability to express code elements and  
their rich semantic relationships. However, applying this concept  
to repository-level code completion RAG pipelines faces several  
core challenges:

\`\`\`  
(1)Graph Construction: How to transform a large and complex  
code repository into a unified graph structure that can both  
comprehensively represent code entities (classes, methods,  
variables, etc.) and precisely characterize the complex re-  
lationships between entities (calls, inheritance, data flows,  
etc.)?  
(2)Graph Retrieval: How to design a high-performance retrieval  
strategy on the constructed code graph that captures both  
structural similarity and semantic relevance to provide opti-  
mal contextual information for the code completion task?  
(3) Graph Augmentation: How to effectively fuse the retrieved  
graph structure information with the code-to-be-completed,  
fully utilizing the structural associations between them to  
enhance the LLM’s code understanding and generation ca-  
pabilities?  
\`\`\`  
\`\`\`  
To systematically address these challenges, we propose theGraph-  
GuidedRepository-AwareCode Completion through Hierarchical  
Code Fusion (GRACE) framework. In the graph construction phase,  
we extract and build a multi-level, multi-semantic hybrid code  
graph from the code repository. We categorize the graph structures  
into three levels: repo-level, module-level, and function-level. We  
capture semantic relationships of different granularities at each  
level. Through organic fusion between levels, we construct a uni-  
fied code graph capable of expressing both static structural features  
and dynamic behavioral patterns of code. In the graph retrieval  
phase, we propose a Hybrid Graph Retriever (HGR) that innova-  
tively combines GNN-based structural retrieval with traditional text  
semantic retrieval. Structural retrieval identifies code snippets with  
similar topological patterns (such as similar call chains or inheri-  
tance structures) through subgraph matching, while text retrieval  
captures semantic-level relevance. We further design a graph-aware  
reranking mechanism to refine the preliminary retrieval results,  
ensuring the prioritization of the most relevant structured context.  
In the graph enhancement phase, we propose a Graph Fusion and  
Enhancement mechanism that fuses the optimal retrieved code  
subgraph with the graph structure of the code-to-be-completed  
both semantically and structurally, forming a more informationally  
complete enhanced context graph, thereby significantly improving  
the LLM’s understanding of code structure.  
The main contributions of this paper are as follows:  
\`\`\`  
\- We are the first to systematically propose a multi-level, multi-  
    semantic code graph construction method for repository-level  
    code completion, effectively addressing the insufficient utiliza-  
    tion of code structural information in existing methods.  
\- We design and implement a hybrid graph retrieval strategy that  
    integrates structural and semantic retrieval, combined with a  
    graph-aware reranking mechanism, significantly improving the  
    quality and relevance of retrieved context.  
\- We innovatively propose a graph fusion enhancement mecha-  
    nism that, for the first time, focuses on and utilizes the structural  
    associations between retrieved code and code-to-be-completed,  
    effectively solving the structural information loss problem in  
    traditional RAG methods.  
\- We conduct comprehensive experimental evaluations on multi-  
    ple public repository-level code completion benchmark datasets,  
    with results showing that the GRACE framework significantly  
    outperforms existing state-of-the-art methods. Using DeepSeek-  
    V3 as the backbone LLM, GRACE surpasses the strongest graph-  
    based RAG baselines by 8.19% EM and 7.51% ES points on four  
    datasets.

\#\# 2 METHODOLOGY

\#\# 2.1 Multi-level Code Graph Construction

\`\`\`  
In repository-level code completion tasks, the hierarchical structure  
and multi-dimensional semantic relationships of code are crucial for  
understanding code context. Code repositories inherently exhibit  
hierarchical and multi-relational characteristics. From project file  
structures to function statements, code entities at different granu-  
larities (such as packages, modules, classes, and functions) carry  
semantic information at different levels. Traditional graph represen-  
tations typically only use simple file structures and ASTs, failing to  
\`\`\`

GRACE: Graph-Guided Repository-Aware Code Completion through Hierarchical Code Fusion Conference ICSE ’26, April 12-18, 2026, Rio de Janeiro, Brazil

\`\`\`  
Generate a class to  
validate the data of  
payment service  
\`\`\`  
\`\`\`  
Traditional  
semantic  
retrieval  
\`\`\`  
\`\`\`  
Code Repository  
\`\`\`  
\`\`\`  
Retrieved incorrect references class  
\`\`\`  
\`\`\`  
Graph concatenation  
\`\`\`  
\`\`\`  
Graph  
retrieval  
\`\`\`  
\`\`\`  
Retrived correct subgraph  
\`\`\`  
\`\`\`  
Set Invalid Rules Service  
\`\`\`  
\`\`\`  
validators  
PaymentData  
\`\`\`  
\`\`\`  
Validation Result  
\`\`\`  
\`\`\`  
Set Invalid Rules Service  
\`\`\`  
\`\`\`  
validators  
PaymentData  
\`\`\`  
\`\`\`  
Validation Result  
\`\`\`  
\`\`\`  
PaymentValidator  
\`\`\`  
\`\`\`  
BaseClass  
\`\`\`  
\`\`\`  
Sequential Concatenation  
\`\`\`  
\`\`\`  
LLM  
\`\`\`  
\`\`\`  
User Query  
\`\`\`  
Figure 1: Comparison of standard RAG-based code completion with GRACE. Conventional RAG retrieves code solely by semantic  
similarity and fuses it via naive concatenation, ignoring structural relations and often producing inaccurate completions.

comprehensively capture cross-level semantic dependencies, result-  
ing in the loss of critical context during the retrieval-augmented  
process. To fully capture this rich structured information, we pro-  
pose a multi-level, multi-semantic code graph construction method  
that models the entire code repository as a unified hierarchical  
graph structure through a three-level abstraction and structured  
connection mechanism.

2.1.1 Multi-level Code Graph Structure Design.We divide the repository-  
level code graph structure into three levels, with each level focusing  
on code semantics at different granularities:

2.1.2 Construction of Unified Hierarchical Graph.To achieve uni-  
fied representation and efficient retrieval across levels, we integrate  
the extracted multi-granularity graph structures into a unified multi-  
relational hierarchical graphG=(V,E,T𝑣,T𝑒), whereVrepre-  
sents the set of nodes across all levels,Erepresents the set of edges  
including both intra-level and cross-level edges,T𝑣represents the  
set of node types, including files, classes, functions, statements,  
etc.;T𝑒represents the set of edge types, including calls, inheritance,  
definitions, uses, etc.  
To avoid naming conflicts between different levels, we assign a  
globally unique identifier (UUID) to each node and maintain a map-  
ping table that records the original information of nodes, including  
the graph type they belong to (e.g.,𝑔𝑟𝑎𝑝ℎ\_𝑡𝑦𝑝𝑒="call\_graph"),  
node type, and attribute information. Node attributes include code  
text, location information (file path, line number), semantic type  
(such as variable types, function signatures), and structural features  
(such as cyclomatic complexity, nesting depth). Edge attributes  
include edge type, weight (such as call frequency, dependency  
strength), and context information (such as call parameters, condi-  
tional constraints). These attribute information not only preserve  
the original semantics of the code but also provide rich features for  
subsequent graph retrieval and matching.  
To bridge the three granularities, we introduce a set of care-  
fully designed cross-level edges (see Figure 2 (a)). At the reposi-  
tory–module boundary, every file node is linked to the functions it

\`\`\`  
Table 1: Hierarchical graph representations leveraged by our  
RAG framework  
\`\`\`  
\`\`\`  
Level Graph Type Semantics Captured  
\`\`\`  
\`\`\`  
Repository  
\`\`\`  
\`\`\`  
Folder Structure Graph  
\`\`\`  
\`\`\`  
Directory hierarchy; nodes  
are folders/files, edges de-  
note containment.  
\`\`\`  
\`\`\`  
Cross-file Dep. Tree  
\`\`\`  
\`\`\`  
Import and reference rela-  
tions between files, reflect-  
ing module coupling.  
\`\`\`  
\`\`\`  
Module  
\`\`\`  
\`\`\`  
Function Call Graph Call relations among func-  
tions.  
\`\`\`  
\`\`\`  
Type Dep. Graph  
\`\`\`  
\`\`\`  
Dependencies between type  
definitions and their usages.  
\`\`\`  
\`\`\`  
Class Inheritance Graph  
\`\`\`  
\`\`\`  
Inheritance, implemen-  
tation, and composition  
relations among classes.  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Abstract Syntax Tree Syntactic structure of code.  
\`\`\`  
\`\`\`  
Control Flow Graph  
\`\`\`  
\`\`\`  
Possible execution paths of  
the program.  
\`\`\`  
\`\`\`  
Data Flow Graph  
\`\`\`  
\`\`\`  
Definition–use relations of  
variables.  
\`\`\`  
\`\`\`  
declares, thereby localising definition sites; file-level dependencies  
are further propagated to the corresponding inter-function calls,  
while cross-file type usages and inheritance relations are mapped to  
explicit “type-reference” and “interface-inheritance” edges. Moving  
down to the module-function boundary, each function in the call  
graph is anchored to the root of its abstract syntax tree, and variable  
types are aligned with data-flow vertices so that type information  
constrains the data-flow analysis. Within a single function, AST  
\`\`\`

\`\`\`  
Conference ICSE ’26, April 12-18, 2026, Rio de Janeiro, Brazil Trovato et al.  
\`\`\`  
\`\`\`  
self.payment\_  
rules\_service \=  
payment\_rules  
\_service  
Hybird Graph  
Retriver  
\`\`\`  
\#\#\# Encode Retrieve Enhancement Predict

\`\`\`  
Code/Graph  
Vector  
\`\`\`  
\`\`\`  
Ranked Subgraphs  
with Socre  
\`\`\`  
\`\`\`  
Code/Graph  
Encoder  
\`\`\`  
\`\`\`  
Graph \-Aware  
Reranker  
\`\`\`  
\`\`\`  
Retrived  
Subgraphs  
\`\`\`  
\`\`\`  
(b) Hybird Graph Retriver  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
0\.  
0\.  
Multi-Level  
Graph Index  
Fusion Graph  
(c) Code Graph Fusion Enhancement  
\`\`\`  
\#\#\#\# LLM

\`\`\`  
Node Feature Fusion  
\`\`\`  
\`\`\`  
Graph Attention Network  
\`\`\`  
\`\`\`  
Graph  
Structure  
Fusion  
\`\`\`  
\`\`\`  
Code Graph Fusion  
Zoom Enhancement  
In  
\`\`\`  
\`\`\`  
Zoom  
In  
\`\`\`  
\`\`\`  
services  
\`\`\`  
\`\`\`  
project\_root  
\`\`\`  
\`\`\`  
user\_service  
auth\_service  
product\_service  
payment  
\`\`\`  
\`\`\`  
payment\_  
gateway  
validators  
base  
user\_validator  
product\_validator  
auth\_validator  
\`\`\`  
\`\`\`  
payment\_  
processor  
\`\`\`  
\#\#\# Code Repository

\#\#\# Class PaymentData

\#\#\# Validator:

\`\`\`  
User Code  
\`\`\`  
\`\`\`  
Repo Level Folder Structure  
\`\`\`  
\`\`\`  
Call Graph Class Inheritance Tree Type Dependency Graph  
\`\`\`  
\`\`\`  
Abstract Syntax Tree  
\`\`\`  
\`\`\`  
Control Flow Graph  
\`\`\`  
\`\`\`  
Data Flow Graph  
\`\`\`  
\`\`\`  
File LocationCross-ModuleInvocation Cross-file TypeDependencies  
\`\`\`  
\`\`\`  
Method Invocation Type Inference Class Hierarchy  
\`\`\`  
\`\`\`  
Syntax Analysis  
\`\`\`  
\`\`\`  
Control Dependency  
\`\`\`  
\`\`\`  
Data Dependency  
\`\`\`  
\`\`\`  
Function  
Level  
\`\`\`  
\`\`\`  
Module  
Level  
\`\`\`  
\`\`\`  
Cross-file Dependencies  
\`\`\`  
\`\`\`  
Interface  
Integration  
\`\`\`  
\#\#\# Multi-level Code Graph

\`\`\`  
(a) Multi-level  
Code Graph  
Construction  
\`\`\`  
\`\`\`  
Figure 2: Framework of GRACE, which consists of three main components: (a) multi-level code graph construction, (b) hybrid  
graph retriever, and (c) code graph fusion enhancement.  
\`\`\`  
\`\`\`  
nodes are connected to the control-flow graph to reflect the influ-  
ence of syntax on execution order; control-flow vertices are then  
tied to data-flow vertices, capturing how branching and looping  
conditions restrict the propagation of values. These cross-level con-  
nections weave repository, module, and function views into one  
heterogeneous graph, providing a unified and semantically rich  
backdrop for subsequent retrieval and code completion.  
Through the above multi-level graph construction method, we  
transform complex code repositories into a structured, hierarchical  
code knowledge base, providing a solid foundation for subsequent  
graph retrieval and code completion tasks.  
\`\`\`  
\#\# 2.2 Hybrid Graph Retriever

After constructing the multi-level code graph, the key challenge  
lies in retrieving the most relevant context from this large-scale  
graph database to assist code completion. In repository-level code  
completion scenarios, developers often need to understand not  
only what a piece of code does (semantic information) but also

\`\`\`  
how it interacts with other components (structural information).  
For instance, when completing a method call, knowing similar  
function implementations helps, but understanding the inheritance  
hierarchy, method overrides, and calling patterns provides crucial  
constraints for generating correct completions. Traditional retrieval  
methods that rely solely on textual similarity miss these structural  
dependencies, leading to semantically plausible but structurally  
incorrect suggestions. To address this fundamental limitation, we  
propose the Hybrid Graph Retriever (HGR) (see Figure 2 (b)), which  
synergistically combines semantic retrieval for capturing functional  
similarity and graph-based structural retrieval for understanding  
code relationships, thereby providing comprehensive context for  
more accurate code completion.  
\`\`\`  
\`\`\`  
2.2.1 Dual-Path Encoding Mechanism.The Hybrid Graph Retriever  
employs a dual-path encoding strategy that captures both the se-  
mantics and structure of code, each serving distinct but comple-  
mentary roles in code completion.  
\`\`\`

\`\`\`  
GRACE: Graph-Guided Repository-Aware Code Completion through Hierarchical Code Fusion Conference ICSE ’26, April 12-18, 2026, Rio de Janeiro, Brazil  
\`\`\`  
Semantic Encoding Path: For semantic information in code,  
we employ the pre-trained Code embedding model (codet5p-110m-  
embedding) to encode code snippets. This model, pre-trained on  
large-scale mixed code-natural language corpora, effectively cap-  
tures functional semantics, variable naming conventions, and com-  
ment information. For each code snippet𝑐, the semantic encoder  
generates a corresponding semantic vectorv𝑐∈R𝑑𝑠:  
v𝑐 \= EmbedCodeT5p(𝑐)∈R𝑑𝑠, (1)

where𝑑𝑠denotes the semantic embedding dimension. The gener-  
ated semantic vectors are indexed using Hierarchical Navigable  
Small World (HNSW) graphs, supporting efficient approximate  
nearest neighbor search. Notably, the hierarchical nature of HNSW  
aligns well with our multi-level code graph structure—upper layers  
provide fast navigation across different modules while lower layers  
enable precise retrieval within specific code regions.  
Structural Encoding Path: For structural information in code,  
we encode this structural information through a combination of  
node embeddings and Laplacian positional encoding: First, we uti-  
lize the code language model to encode the code content of each  
node𝑣∈Vin the graph, obtaining node embeddingsv𝑐∈R𝑑^1. Sec-  
ond, to capture the global positional information of nodes within  
the graph, we compute the normalized Laplacian matrix:

\`\`\`  
L=I−D−^1 /^2 AD−^1 /^2 ,  
whereAis the adjacency matrix andDis the degree matrix. We  
take the eigenvectors corresponding to the first𝑑 2 smallest non-  
zero eigenvalues ofLas the positional encodingv𝑠∈R𝑑^2 for each  
node. The final graph structural representation is obtained through  
concatenation:  
\`\`\`  
h𝑣 \= \[v𝑐;v𝑠\] ∈R𝑑^1 \+𝑑^2 , (2)  
This dual encoding mechanism preserves both the local semantic  
information of nodes and encodes their positional features within  
the global graph structure.  
2.2.2 Hybrid Retrieval Strategy.Based on the dual-path encoding,  
the Hybrid Graph Retriever executes semantic and structural re-  
trieval in parallel, fully leveraging the complementary advantages  
of both retrieval paradigms.  
Semantic Similarity Retrieval: Given a query code snippet𝑞,  
we first generate the query vectorv𝑞through the semantic encoder.  
Using the HNSW index, we retrieve the Top-𝑘𝑠most semantically  
relevant code snippets based on cosine similarity:

\`\`\`  
SemSim(𝑞,𝑐)=  
\`\`\`  
\`\`\`  
v𝑞·v𝑐  
∥v𝑞∥∥v𝑐∥  
Semantic retrieval effectively captures code snippets with similar  
functionality but different implementations, demonstrating good  
generalization capability.  
Structural Similarity Retrieval: In parallel, we parse the query  
code into a local graph structure𝐺𝑞and generate graph embeddings  
h𝐺𝑞through the structural encoder. We retrieve the Top-𝑘𝑔most  
structurally matching subgraphs from the graph vector index:  
\`\`\`  
\`\`\`  
StructSim(𝐺𝑞,𝐺𝑐)=  
\`\`\`  
\`\`\`  
h𝐺𝑞·h𝐺𝑐  
∥h𝐺𝑞∥∥h𝐺𝑐∥  
\`\`\`  
\`\`\`  
Structural retrieval identifies code snippets with similar calling  
patterns, inheritance relationships, or control flow structures, which  
is crucial for understanding the deep semantics of code.  
2.2.3 Graph-Aware Reranking Mechanism.The candidate sets re-  
trieved from semantic and structural dimensions may overlap or  
contain complementary information. To optimize the final retrieval  
results, we design a graph-aware reranking mechanism. We first  
merge the Top-𝑘𝑠candidate setCsemfrom semantic retrieval with  
the Top-𝑘𝑔candidate setCstructfrom structural retrieval, obtaining  
the combined candidate setC=Csem∪Cstruct. For each candidate  
𝑐𝑖∈ Cin the merged set, we compute its relevance score:  
Score(𝑐𝑖)=𝛼·SemSim(𝑞,𝑐𝑖)+( 1 −𝛼)·StructSim(𝐺𝑞,𝐺𝑐𝑖),  
where𝛼∈ \[ 0 , 1 \]is a balancing parameter controlling the relative  
importance of semantic and structural similarity. In practice, we  
employ an adaptive attention mechanism to dynamically adjust𝛼:  
𝛼=𝜎(𝑊𝛼\[v𝑞;h𝐺𝑞\]+𝑏𝛼),  
where𝑊𝛼and𝑏𝛼are learnable parameters, and𝜎is the sigmoid  
function. This adaptive mechanism automatically adjusts the weights  
of semantic and structural information based on query.  
To avoid overly homogeneous retrieval results, we introduce  
diversity constraints. Through the Maximal Marginal Relevance  
(MMR) algorithm, we enhance result diversity while maintaining  
relevance:  
MMR(𝑐𝑖)=𝜆·Score(𝑐𝑖)−( 1 −𝜆)·max  
𝑐𝑗∈𝑆  
\`\`\`  
\`\`\`  
Sim(𝑐𝑖,𝑐𝑗),  
\`\`\`  
\`\`\`  
where𝑆is the set of already selected candidates code snippets, and  
𝜆controls the balance between relevance and diversity.  
\`\`\`  
\#\# 2.3 Code Graph Fusion Enhancement

\`\`\`  
After obtaining high-quality retrieval results, effectively leveraging  
this structured information becomes a critical factor determining  
code completion quality. Traditional RAG approaches simply con-  
catenate retrieved code snippets with the code to be completed,  
ignoring potential structural associations between them. This treat-  
ment leads to the loss of valuable structural information (such  
as cross-snippet call dependencies, shared type constraints, and  
similar control flow patterns) before being fed into the LLM.  
To address this limitation, we propose a graph fusion enhance-  
ment mechanism (see Figure 2 (c)). The core idea is to construct a  
query graph from the user’s incomplete code and then perform deep  
fusion between multiple retrieved code subgraphs and the query  
graph across two dimensions: node features and graph structure.  
This creates a unified enhanced context graph that provides the  
LLM with more complete and structured contextual information.  
\`\`\`  
\`\`\`  
2.3.1 Fusion Mechanism Design.The query graph𝐺𝑞=(𝑉𝑞,𝐸𝑞)is  
an AST graph structure constructed from the user’s current incom-  
plete code snippet. This graph contains local syntactic structures,  
variable definitions, function calls, and other information from the  
code to be completed. However, due to the code’s incompleteness,  
it often lacks necessary contextual dependencies.  
Rich structural associations exist between retrieved code sub-  
graphs and the query graph, which are invaluable for code comple-  
tion tasks. Similar function implementations in retrieved subgraphs  
can provide implementation patterns and parameter constraints for  
\`\`\`

\`\`\`  
Conference ICSE ’26, April 12-18, 2026, Rio de Janeiro, Brazil Trovato et al.  
\`\`\`  
\`\`\`  
incomplete functions in the query graph, offering crucial semantic  
completion cues. Additionally, complete call paths in retrieved sub-  
graphs can provide contextual validation for function calls in the  
query graph, ensuring call chain completeness.  
Our dual-dimensional fusion approach leverages these associ-  
ations through complementary mechanisms. Node feature fusion  
aligns query graph nodes with retrieved graph nodes in seman-  
tic space, enabling the LLM to identify functionally similar code  
entities and generate semantically consistent completions. Simulta-  
neously, graph structure fusion preserves and extends dependencies  
between code components, enabling the LLM to understand call  
constraints and data flow, thereby generating structurally correct  
completions.  
\`\`\`  
\`\`\`  
2.3.2 Node Feature Fusion.Node feature fusion aims to establish  
correspondences between query graphs and retrieved graphs in  
semantic space. Given a query graph𝐺𝑞=(𝑉𝑞,𝐸𝑞)and𝑘retrieved  
subgraphs{𝐺 1 ,𝐺 2 , ...,𝐺𝑘}, we first obtain node representations for  
each graph through graph neural network encoders:  
\`\`\`  
\#\#\#\# H𝑞=GNN(𝐺𝑞) ∈R|𝑉𝑞|×𝑑 (3)

\#\#\#\# H𝑖=GNN(𝐺𝑖) ∈R|𝑉𝑖|×𝑑, 𝑖= 1 , 2 , ...,𝑘 (4)

\`\`\`  
To integrate multiple retrieval results, we perform weighted  
aggregation of retrieved graphs based on retrieval relevance scores:  
\`\`\`  
\#\#\#\# H𝑟=

\#\#\#\# ∑︁𝑘

\`\`\`  
𝑖= 1  
\`\`\`  
\#\#\#\# 𝑤𝑖·H𝑖 (5)

\`\`\`  
where weights𝑤𝑖are obtained through normalization of re-  
trieval relevance scores. Subsequently, we compute cross-attention  
between query graph nodes and aggregated retrieved graph nodes:  
\`\`\`  
\`\`\`  
A=softmax  
\`\`\`  
\#\#\#\# H𝑞H𝑇𝑟

\#\#\#\# √

\#\#\#\# 𝑑

\#\#\#\# \!

\#\#\#\# ∈R|𝑉𝑞|×|𝑉𝑟| (6)

\`\`\`  
This attention mechanism enables the identification of function-  
ally similar code entities (e.g., functions with identical functionality)  
and provision of semantic alignment foundation for subsequent  
structural fusion.  
\`\`\`  
\`\`\`  
2.3.3 Graph Structure Fusion.Building upon semantic alignment  
from node features, we further establish connections between query  
graphs and retrieved graphs at the graph structure level. For node  
pairs(𝑣𝑞,𝑣𝑟)with attention weights exceeding threshold𝜃, we  
create cross-graph edges in the fusion graph:  
\`\`\`  
\`\`\`  
𝐸fusion=𝐸𝑞∪𝐸𝑟∪{(𝑣𝑞,𝑣𝑟)|A𝑣𝑞,𝑣𝑟\>𝜃} (7)  
\`\`\`  
To ensure fusion graph quality and code semantic correctness,  
we introduce several essential constraints. First, we enforce type  
consistency by only connecting type-compatible nodes, such as  
function calls with function definitions or variables of the same  
type. Second, we preserve critical paths and dependency relation-  
ships from original graphs to avoid disrupting code’s inherent logic.  
Finally, we eliminate redundancy by merging semantically equiva-  
lent nodes to avoid information duplication and confusion.

\`\`\`  
2.3.4 Graph-to-Text Serialization.In order to input the structured  
enhanced context graph into the LLM, we employ a semantic graph  
serialization method that preserves both structural and semantic  
information. Our serialization template explicitly expresses node  
types and relationship types, providing structural clarity that facili-  
tates LLM comprehension. The representation maintains semantic  
richness by preserving property information and weight informa-  
tion, while the natural language format ensures comprehensibility  
for effective LLM processing. The final prompt template combines  
the serialized graph structure with the original code context:  
\`\`\`  
\`\`\`  
Prompt Template 2.1:  
\`\`\`  
1\. \[Role\]  
You are a world-class AI code completion expert. Your purpose  
    is to help developers write code faster and more accurately. You  
will be given the user’s current code context and a relevant code  
    knowledge subgraph retrieved from the entire codebase. Your task  
    is to predict the single most likely line of code to complete at the  
    cursor position.  
    2\. \[Context Information\]  
    2.1 User’s Current Code Context

\`\`\`  
repo name: {repo\_name}  
File Path: {current\_file\_path}  
{code\_before\_cursor}  
2.2 Retrieved Code Context  
{code\_context}  
2.3 Retrieved Code Knowledge Graph  
{graph\_context}  
\`\`\`  
2\. \[Task Instruction\]  
Analyze the user’s current code context to understand their im-  
mediate goal. Examine the provided code knowledge subgraph,  
focusing on class definitions, function signatures, and usage pat-  
terns. Synthesize this information to infer the most logical next  
line of code. Outputexactly oneline of code for insertion and a  
concise explanation referencing specific nodes from the subgraph.  
3\. \[Output Format\]  
Return a single valid JSON object:  
{  
"completed\_code ": "The suggested code.",  
"explanation ": "Brief rationale referencing  
subgraph nodes.",  
"confidence\_score ": 0.87,  
"referenced\_nodes ": \[  
"node\_id\_of\_relevant\_function",  
"node\_id\_of\_relevant\_class"  
\]  
}  
4\. \[Constraints and Rules\]  
\- The completed\_code must contain exactly one line.  
\- Explanations must remain concise and grounded in the subgraph.  
\- If uncertain, lower the confidence\_score; if impossible, return  
an empty code line with confidence 0.0.

\`\`\`  
GRACE: Graph-Guided Repository-Aware Code Completion through Hierarchical Code Fusion Conference ICSE ’26, April 12-18, 2026, Rio de Janeiro, Brazil  
\`\`\`  
\`\`\`  
Through this graph fusion enhancement mechanism, we provide  
the LLM with rich context that encompasses both semantic similar-  
ity and structural consistency, thereby significantly improving the  
accuracy and executability of code completion.  
\`\`\`  
\#\# 2.4 Algorithm Implementation

The complete algorithmic flow for GRACE is presented in Algo-  
rithm 1\. The process can be decomposed into five distinct phases: (1)  
Query Graph Construction, (2) Hybrid Graph Retrieval, (3) Graph  
Fusion Enhancement, (4) Prompt Serialization, and (5) LLM Infer-  
ence.  
Phase 1: Query Graph Construction.The process starts with  
the user’s incomplete code snippetC, which is parsed into an Ab-  
stract Syntax Tree (AST). From this AST, we build the query graph  
𝐺𝑞=(𝑉𝑞,𝐸𝑞).  
Phase 2: Hybrid Graph Retrieval.Our retrieval mechanism  
adopts a hybrid approach that combines both semantic and struc-  
tural similarity, aiming to leverage the complementary strengths of  
the two retrieval methods.  
For thesemantic path, we first encode the query graph𝐺𝑞into  
a high-dimensional vector embeddingv𝑞using the CodeT5p model.  
We then use this embedding to retrieve the top-𝑘𝑠semantically  
similar snippets via HNSW from the pre-indexed repository vectors.  
Concurrently, thestructural pathperforms a graph similarity  
search to find the top-𝑘𝑔subgraphs, that are structurally analogous  
to the query graph𝐺𝑞. Finally, the candidate sets from both paths  
are merged and reranked based on a combined score to select the  
final top-𝑘most relevant graphs for the next phase.  
Phase 3: Graph Fusion Enhancement.This phase integrates  
the retrieved knowledge with the original query context. We extract  
dense node embeddings for the query graphH𝑞and each retrieved  
graphH𝑖, then aggregate them into a context matrixH𝑟weighted  
by reranking scores. Next, we compute a cross-attention matrixA  
between query and retrieved nodes to identify relevant code parts.  
If the attention score between nodes exceeds a threshold and their  
types match, a cross-graph edge is added.  
Phase 4: Prompt Serialization.LLMs require linear text input,  
so we serialize the fused graph𝐺𝑓 into a sequence of natural-  
language triples.  
Phase 5: LLM Inference.The current prompt includes both the  
original contextual information and the retrieved relevant context,  
which are provided to the LLM.

\#\# 3 EXPERIMENT

\#\# 3.1 Experiment Setup

\`\`\`  
Datasets: We employ two publicly available benchmarks that re-  
quire cross-file reasoning:RepoEval-Updated\[ 30 \] andCross-  
CodeEval\[ 13 \].CrossCodeEvalspans four languages (Python, Java,  
TypeScript, and C); the Python split contains 2,665 test cases from  
471 repositories, each demanding inter-file context to obtain the  
ground-truth line.RepoEval-Updatedrefreshes the original RepoEval\[ 53 \]  
by (i) removing repositories created before 2022-03-31 to mitigate  
training-data leakage and (ii) adding new Python and Java projects  
created up to 2023-01-01. Tasks are categorised intoline-leveland  
API-levelcompletion following \[29\].  
\`\`\`  
\`\`\`  
Algorithm 1GRACE: Graph-guided Repository-Aware Code Com-  
pletion Pipeline  
Require:Incomplete code snippetCwith cursor position; full  
repositoryR  
Ensure:Predicted next line of codeℓˆ  
// Phase 1: Query Graph Construction  
Build AST ofCand extract local symbols  
Construct query graph𝐺𝑞=(𝑉𝑞,𝐸𝑞)from AST nodes and edges  
// Phase 2: Hybrid Graph Retrieval  
Encode𝐺𝑞semantically (CodeT5p)→vectorv𝑞  
Encode repository graphs structurally (GNN \+ Laplacian)→  
index  
Semantic path: HNSW search→top-𝑘𝑠subgraphsCsem  
Structural path: Graph similarity search→top-𝑘𝑔subgraphs  
Cstruct  
MergeCsem∪Cstructand rerank  
Select top-𝑘retrieved subgraphs{𝐺 1 ,.. .,𝐺𝑘}  
// Phase 3: Graph Fusion Enhancement  
Obtain node embeddings{H𝑞,H 1 ,.. .,H𝑘}  
Aggregate retrieved node featuresH𝑟←  
\`\`\`  
\#\#\#\# Í

\#\#\#\# 𝑖𝑤𝑖H𝑖

\`\`\`  
Compute cross-attentionA=softmax(H𝑞H𝑟⊤/  
\`\`\`  
\#\#\#\# √

\#\#\#\# 𝑑)

\`\`\`  
Add cross-graph edges(𝑣𝑞,𝑣𝑟)ifA𝑞𝑟\>𝜃and type-consistent  
Form fused graph𝐺𝑓=(𝑉𝑞∪𝑉𝑟,𝐸𝑞∪𝐸𝑟∪𝐸cross)  
// Phase 4: Prompt Serialization  
Serialize𝐺𝑓to natural-language triples; concatenate with code  
context to obtain promptP  
// Phase 5: LLM Inference  
Query LLM with promptP; receive JSON output  
Parse fieldcompleted\_codeas predictionℓˆ  
returnℓˆ  
\`\`\`  
\`\`\`  
LLMs: We use Qwen2.5-Coder-14B, GPT-4o mini and DeepSeek-V  
as the backbone LLMs.  
Evaluation Metrics: We adopt four complementary measures:  
exact-match accuracy (EM), edit similarity (ES),Recall, and the  
token-levelF1score. EM counts character-wise equality with the  
reference. ES is 1 −Lev/max(|pred|,|ref|), where Lev denotes the  
Levenshtein distance. Recall quantifies the proportion of reference  
tokens recovered, while F1 is the harmonic mean of precision and  
recall.  
Baselines: We compare GRACE against five representative meth-  
ods:No RAG(plain context completion),Vanilla RAG(sliding-  
window retrieval),GraphCoder\[ 30 \],RepoFuse\[ 24 \], andRL-  
Coder\[ 48 \]. We try to adjust all baselines to the optimal parameters.  
Other Setup: The total input window is fixed at 2,048 tokens, split  
evenly between retrieved context and local context. RAG-based  
methods retrieve at most𝑘 \= 10 code snippets; the maximum  
generation length is 100 tokens. GRACE encodes both textual and  
structural inputs viacodet5p-110m-embedding(768-dim), followed  
by HNSW (semantic path,𝑀= 32 ,𝑒𝑓\_𝑠𝑒𝑎𝑟𝑐ℎ= 256 ) and a flat Faiss  
index (structural path) for efficient nearest-neighbour search. At-  
tention threshold𝜃is set to 0.4 and the adaptive fusion weight𝛼is  
tuned on a held-out validation split. Experiments are conducted on  
NVIDIA A6000 GPU.  
\`\`\`

Conference ICSE ’26, April 12-18, 2026, Rio de Janeiro, Brazil Trovato et al.

RQs: To comprehensively evaluate the performance of GRACE we  
propose the following research questions:

\- RQ1-Effectiveness of GRACE:Does GRACE outperform  
    state-of-the-art baselines on repository-level code-completion  
    benchmarks?  
\- RQ2-Component Analysis:How do individual architec-  
    tural choices influence performance?  
\- RQ3-Model Scale Affection:How does the backbone LLM  
    size affect GRACE’s effectiveness?  
\- RQ4-Hyperparameter Sensitivity:How sensitive is GRACE  
    to the retrieval depth𝑘?

\#\# 3.2 RQ1: Effectiveness of GRACE

Table 2 compares GRACE with six competitive baselines across two  
realistic benchmarks (CrossCodeEvalandRepoEval-Updated),  
two programming languages (Python and Java), and three repre-  
sentative backbone LLMs (GPT4o-mini,Qwen2.5-Coder-14B, and  
DeepSeek-V3).  
Overall superiority.Table 2 shows that GRACE secures the  
top position in35/48metric–language–dataset combinations and  
ranks second in nine more,consistently outperforming all six  
baselines. This demonstrates the robustness of graph-augmented  
retrieval and hierarchical fusion for practical repository-level com-  
pletion.  
Effect of backbone size.Moving from a mid-size backbone  
(Qwen2.5-Coder-14B) to a larger one (DeepSeek-V3) widens the  
margin between GRACE and the best non-graph competitor from  
2.3 ppto5.4 pp(EM on Python/CrossCodeEval). This confirms  
our hypothesis thatlarger LLMs can better leverage the fine-grained  
structural cues surfaced by graph retrieval.  
Dataset sensitivity.OnCrossCodeEval, which stresses cross-  
file reasoning, GRACE achieves the highestF1onall 12%LLM–language  
pairs. On the more diverseRepoEval-Updated, it attains83.95% re-  
callin the Python subset—4.7%higher thanVanilla RAG—showcasing  
strong generalizability.  
Head-to-head with strong baselines.AlthoughRepoFuse  
occasionally edges out GRACE in raw recall, its aggressive long-  
context retrieval inflates noise and lowers precision, depressingF  
by up to8.6%. Under the largest backboneDeepSeek-V3, GRACE  
delivers anaverage gain of \+8.19% EMand+7.51% ESoverRepo-  
Fuse, and+7.94% EM/+6.83% ESoverRLCoderacross all datasets,  
highlighting its scalability advantages.  
Graph-structured retrieval coupled with hierarchical fu-  
sion boosts LLM code-completion accuracy, and the benefit  
amplifies with model scale and dataset complexity.

\#\# 3.3 RQ2: Component Analysis

Table 3 reveals the contribution of each design choice in GRACE.  
Key findings are as follows:  
(1)Hybrid Graph Retriever matters.Substituting it with a lexical  
BM25 search cutsF1 by 4–6%(e.g.82.76%→78.97%on CrossCodeEval-  
Py), showing that purely textual retrieval cannot surface the struc-  
turally relevant context.  
(2)Graph fusion is decisive.Removing the fusion stage (“w/o  
Fusion”) causes the sharpest drop—up to–6.2% F1and–5.4%

\`\`\`  
EM—because naïve concatenation fails to reconcile overlaps and  
noise among retrieved snippets.  
(3)Rich relations beyond AST are still needed.Limiting the graph  
to AST edges closes part of the gap but remains2–3%behind full  
GRACE, confirming that call-, data- and control-flow links offer  
complementary cues.  
Together, these ablations underline three indispensable pillars  
of GRACE: precise hybrid retrieval, hierarchical graph fusion, and  
a multi-relation code graph—all required to reach thestate-of-the-  
art 80–83% F1achieved by the complete system.  
\`\`\`  
\#\# 3.4 RQ3: Model Scale Affection

\`\`\`  
We examine how the capacity of the backbone LLM influences the  
effectiveness of GRACE. Figure 3 reports results on six Qwen vari-  
ants ranging from 0.6B to 32B parameters.Key findings.Scaling  
the Qwen backbone from0.6Bto32Bparameters boostsF1by  
\+56.3%(24.20% to80.46%),EMby+15.1%, andESby a remarkable  
\+75.7%. A closer inspection shows two distinct phases.  
\`\`\`  
\- Sub-billion to 7B.Gains are steady but moderate: every dou-  
    bling of model size yields roughly \+10% in ES.  
\- 14B→32B.Improvements accelerate; ES jumps by \+12.4%  
    and F1 by \+12.8%, indicating that larger models extract and  
    leverage the graph-structured cues far more effectively.  
Together with RQ1, this confirms that GRACE not only scales  
gracefully butsynergiseswith high-capacity LLMs, pointing to an  
orthogonal avenue of progress relative to pure parameter scaling.

\`\`\`  
0.6B 1.5B 3B 7B 14B 32B  
Qwen Size  
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
Score  
\`\`\`  
\`\`\`  
EM  
ES  
Recall  
F  
\`\`\`  
\`\`\`  
Figure 3: Impact of Qwen backbone size on the performance  
of GRACE on CrossCodeEval dataset.  
\`\`\`  
\#\# 3.5 RQ4: Hyperparameter Sensitivity

\`\`\`  
We study how the retrieval depth𝑘affects GRACE’s performance  
on RepoEval-Updated dataset. As shown in Figure 4, enlarging𝑘  
from 1 to 3 consistently boosts all four metrics, because a broader  
candidate set increases the likelihood of retrieving truly relevant  
context. Beyond𝑘= 3 , the curves flatten:F1varies within 0 .5%  
andEMwithin 0 .2%between𝑘= 3 and𝑘= 5\. This plateau indi-  
cates that our hierarchical fusion module is already able to distill  
sufficient information from the top-3 subgraphs, and that adding  
more neighbours mostly introduces redundant edges rather than  
novel cues. Therefore, we adopt𝑘= 3 as the default, striking a good  
balance between accuracy and retrieval cost.  
\`\`\`

\`\`\`  
GRACE: Graph-Guided Repository-Aware Code Completion through Hierarchical Code Fusion Conference ICSE ’26, April 12-18, 2026, Rio de Janeiro, Brazil  
\`\`\`  
\`\`\`  
Table 2: Performance comparison between GRACE and baselines on Different LLMs and Datasets  
\`\`\`  
\`\`\`  
GPT-4o mini Qwen2.5-Coder-14b DeepSeek v  
Code Identifier Code Identifier Code Identifier  
Method EM ES Recall F1 EM ES Recall F1 EM ES Recall F1 EM ES Recall F1 EM ES Recall F1 EM ES Recall F  
\`\`\`  
\`\`\`  
CrossCode-  
Eval  
Python  
\`\`\`  
\`\`\`  
No RAG 5.59 55.40 77.79 75.92 10.47 55.85 44.56 42.731.16 35.89 83.64 68.44 1.84 38.48 40.77 27.779.53 44.48 88.49 73.09 14.07 47.22 53.52 37\.  
Vallina RAG9.31 58.54 78.74 77.39 15.95 58.97 48.80 47.282.85 40.53 83.68 70.19 4.47 42.62 45.11 32.9613.32 47.31 88.05 73.95 18.87 50.58 53.95 40\.  
GraphCoder8.07 57.24 79.20 77.25 13.32 57.76 47.95 45.691.16 39.40 84.13 70.00 2.03 41.53 45.85 32.0410.54 43.14 88.60 72.01 15.01 46.45 53.46 36\.  
RepoFuse 22.36 66.12 83.52 81.67 30.96 67.86 62.41 59.845.33 45.88 86.9073.04 6.83 48.15 58.81 41.4522.93 54.45 90.80 77.76 29.16 57.76 67.80 51\.  
RLCoder 25.4468.8984.89 82.94 35.8370.9765.8163.377.2847.9587.2674.079.8750.3058.8943.3726.4557.3690.6278.8334.3060.9668.0554.  
Grace 31.38 71.3183.6982.7632.8573.64 74.71 74.6313.96 63.3280.4677.67 15.38 61.31 63.69 72.7632.85 63.64 94.71 83.96 43.96 73.32 80.46 67\.  
\`\`\`  
\`\`\`  
CrossCode-  
Eval  
Java  
\`\`\`  
\`\`\`  
No RAG 12.01 63.52 79.01 79.55 19.82 62.80 52.66 52.699.21 59.64 79.42 77.81 16.78 60.62 52.37 50.4221.18 68.22 84.61 83.29 29.27 68.33 62.11 59\.  
Vallina RAG15.85 65.57 79.75 80.32 24.17 64.77 55.50 55.7611.64 61.54 81.11 79.26 20.29 62.66 54.80 52.7125.99 70.23 84.91 83.91 35.06 70.44 64.41 62\.  
GraphCoder15.01 65.32 80.29 80.59 23.09 64.79 55.56 55.519.91 60.49 80.23 78.59 18.65 61.27 53.94 51.5523.14 67.15 85.33 82.62 31.00 67.71 62.81 59\.  
RepoFuse 28.3871.31 83.69 83.7639.08 71.6665.3665.1520.6668.2583.9382.53 33.6169.8 64.90 62.8638.76 76.86 88.01 87.58 50.40 77.65 74.17 72\.  
RLCoder 31.772.7284.0384.1141.5172.67 66.9366.7921.4668.0784.2082.4533.05 69.51 65.0562.9440.9177.3988.3887.6551.9978.0574.3873.  
Grace 26.7277.91 85.4383.3841.7070.72 60.0374.1117.25 67.57 83.66 81.68 32.8573.64 74.71 75.0342.37 79.59 90.82 90.15 55.19 79.15 85.03 89\.  
\`\`\`  
\`\`\`  
RepoEval-  
Updated  
Python  
\`\`\`  
\`\`\`  
No RAG 21.35 50.07 74.53 69.51 29.50 53.30 54.11 46.9222.20 50.06 76.23 70.29 29.65 53.53 54.68 46.9129.45 59.41 84.07 77.57 37.90 62.43 66.75 57\.  
Vallina RAG30.7056.59 79.24 74.34 38.55 59.90 60.46 53.5229.6054.09 80.26 73.67 36.55 57.47 59.14 51.1837.45 62.8186.8680.0244.65 66.1070.55 61\.  
GraphCoder29.70 58.8681.8576.4938.70 62.1264.4256.5229.05 56.9380.54 74.6837.70 60.5463.16 55.0534.45 61.81 85.99 79.19 43.10 65.15 69.77 60\.  
RepoFuse 32.1056.25 80.00 74.1939.6559.47 62.79 54.4532.8055.81 80.69 74.0840.2558.90 63.2353.9738.8562.44 86.25 79.20 47.0065.69 72.6962.  
RLCoder 28.75 57.84 80.86 75.21 37.30 60.85 63.75 55.3526.40 52.6381.2973.58 34.10 56.25 60.26 50.8234.80 61.80 86.30 79.27 43.05 65.41 70.36 60\.  
Grace 29.5260.63 83.95 79.9639.1568.54 66.52 60.2329.2057.4580.9678.3138.4762.83 68.69 70.0857.26 76.25 89.22 85.20 52.70 70.43 77.59 72\.  
\`\`\`  
\`\`\`  
RepoEval-  
Updated  
Java  
\`\`\`  
\`\`\`  
No RAG 17.70 56.25 75.29 75.22 26.50 57.08 55.80 51.0817.80 55.95 76.29 75.30 26.95 57.39 57.30 51.8426.10 63.85 80.45 79.59 36.15 64.62 65.85 60\.  
Vallina RAG23.45 58.81 76.43 76.19 31.40 59.25 58.80 53.9421.80 56.43 76.75 75.43 29.65 57.37 57.56 51.8830.60 63.77 80.98 79.62 39.50 64.80 66.68 60\.  
GraphCoder25.75 60.5777.43 77.2534.45 61.7261.1656.6326.80 60.9778.45 77.8736.5562.2161.8957.0830.80 64.38 81.15 79.93 39.50 65.32 66.77 61\.  
RepoFuse 24.35 58.53 77.04 76.15 33.10 59.97 59.52 54.2424.1058.65 78.4976.81 33.05 60.25 61.11 54.9632.5566.1481.7080.6743.1067.5869.3063.  
RLCoder 25.3060.4077.8077.3934.3061.4160.89 56.1323.60 57.98 78.02 76.48 31.80 59.13 59.78 54.0831.95 66.08 81.28 80.58 41.20 66.59 68.51 63\.  
Grace 23.85 59.3881.15 79.9332.50 60.3266.77 61.0923.2 59.8580.96 78.31 38.47 62.83 68.69 70.0833.37 70.46 84.62 86.27 45.21 67.37 72.36 70\.  
\`\`\`  
\`\`\`  
Table 3: Ablation study of GRACE. BM25: replace hybrid  
graph retriever with BM25; w/o Fusion: remove graph–fusion  
stage and simply concatenate retrieved code; AST-Only: build  
graphs from abstract syntax trees only. Metrics are macro-  
averaged overCodeandIdentifiertasks.  
\`\`\`  
\`\`\`  
Dataset Metric GRACE BM25 w/o Fusion AST-Only  
CrossCodeEval  
Python  
\`\`\`  
\#\#\#\# EM 31.38 27.36 25.98 28\.

\#\#\#\# F1 82.76 78.97 76.59 79\.

\`\`\`  
CrossCodeEval  
Java  
\`\`\`  
\#\#\#\# EM 26.72 23.59 22.36 24\.

\#\#\#\# F1 83.38 80.33 79.11 81\.

\`\`\`  
RepoEval-  
Updated Python  
\`\`\`  
\#\#\#\# EM 29.52 26.48 25.7 27\.

\#\#\#\# F1 79.96 75.82 74.12 76\.

\`\`\`  
RepoEval-  
Updated Java  
\`\`\`  
\#\#\#\# EM 23.85 21.40 20.30 21\.

\#\#\#\# F1 79.93 77.13 76.24 78\. 89

\#\# 4 DISCUSSION

\#\# 4.1 Threats to Validity

Internal validity:(1)Implementation correctness. GRACE com-  
prises several non-trivial components (graph extractor, hybrid re-  
triever, fusion module). Implementation bugs or sub-optimal en-  
gineering choices could artificially inflate or deflate performance.  
We have released the full source code to facilitate auditing and  
reproduction.  
External validity:(1)Dataset representativeness. Our experiments  
rely on two public repository-level completion benchmarks drawn

\`\`\`  
1 2 3 4 5  
Retrieval Depth k  
\`\`\`  
\`\`\`  
30  
\`\`\`  
\`\`\`  
40  
\`\`\`  
\`\`\`  
50  
\`\`\`  
\`\`\`  
60  
\`\`\`  
\`\`\`  
70  
\`\`\`  
\`\`\`  
80  
\`\`\`  
\`\`\`  
Score  
\`\`\`  
\`\`\`  
EM ES Recall F  
\`\`\`  
\`\`\`  
Figure 4: Effect of retrieval depth𝑘on the macro performance  
of GRACE.  
\`\`\`  
\`\`\`  
mainly from Python and Java projects. Results may not generalise  
to other languages (e.g., C/C++, Go, Rust) or industrial monore-  
pos with proprietary frameworks. Extending GRACE to additional  
ecosystems forms part of future work. (2)Repository scale. Although  
the chosen corpora contain hundreds of files, very large codebases  
(millions of LOC) could stress graph construction time or memory.  
Our complexity analysis highlights potential bottlenecks; we plan  
incremental indexing strategies to mitigate this threat.  
Construct validity:(1)Evaluation metrics. We adopt standard  
EM, ES, F1 and Recall, which capture syntactic correctness but  
not semantic soundness (e.g., compilation success). Complemen-  
tary metrics such as pass@k on unit tests or human assessment  
\`\`\`

\`\`\`  
Conference ICSE ’26, April 12-18, 2026, Rio de Janeiro, Brazil Trovato et al.  
\`\`\`  
\`\`\`  
could yield different conclusions. (2)Baseline selection. We com-  
pare against strong text-centric RAG baselines but omit approaches  
that leverage IDE signals or test-aware feedback. While orthogonal  
to our contribution, their inclusion might narrow the observed  
performance gap.  
\`\`\`  
\#\# 4.2 Complexity Analysis

\`\`\`  
This section analyzes the complexity of the proposed graph fu-  
sion enhancement mechanism. Let𝑛𝑞=|𝑉𝑞|and|𝐸𝑞|denote the  
numbers of nodes and edges in the query graph, and𝑛𝑟=|𝑉𝑟|=  
Í𝑘  
𝑖= 1 |𝑉𝑖|,|𝐸𝑟|=  
\`\`\`  
\#\#\#\# Í𝑘

\`\`\`  
𝑖= 1 |𝐸𝑖|those of the𝑘retrieved sub-graphs.𝐿is  
the number of GNN layers and𝑑the hidden dimension.  
Phase 1: Query graph construction.Parsing the incomplete  
snippet into an AST and building local CFG/DFG is linear in the  
source length, denoted𝑂(|C|). As|C|≈𝑛𝑞, we treat this as𝑂(𝑛𝑞).  
Phase 2: Hybrid graph retrieval.Semantic encoding of𝐺𝑞  
uses a GNN:𝑂(𝐿|𝐸𝑞|𝑑). Semantic ANN search on an HNSW index  
over𝑁𝑠snippets costs𝑂(log𝑁𝑠+𝑘𝑠). Structural encoding of𝐺𝑞  
(concatenating node embedding and Laplacian PE) is𝑂(𝐿|𝐸𝑞|𝑑);  
graph-vector search over𝑁𝑔indexed sub-graphs is𝑂(log𝑁𝑔+𝑘𝑔).  
Overall retrieval complexity:  
\`\`\`  
\`\`\`  
𝑂  
\`\`\`  
\#\#\#\# 

\`\`\`  
𝐿|𝐸𝑞|𝑑+log𝑁𝑠+log𝑁𝑔+𝑘𝑠+𝑘𝑔  
\`\`\`  
\#\#\#\#

\#\#\#\# .

\`\`\`  
Phase 3: Graph fusion enhancement.Computing node em-  
beddings for the𝑘retrieved graphs:𝑂  
\`\`\`  
\#\#\#\# 

\#\#\#\# 𝐿|𝐸𝑟|𝑑

\#\#\#\#

. Cross-attention  
between query and retrieved nodes dominates:𝑂(𝑛𝑞𝑛𝑟𝑑). Edge  
construction and filtering add𝑂(𝑛𝑞𝑛𝑟).  
Phase 4: Prompt serialization.Serialising the fused graph is  
linear in its size:𝑂(𝑛𝑞+𝑛𝑟+|𝐸𝑞|+|𝐸𝑟|).  
Phase 5: LLM inference.This depends on prompt length𝑇  
(tokens) and LLM architecture; we denote it𝑂(LLM(𝑇)).  
Overall time complexity.The end-to-end pipeline is therefore  
bounded by

𝑂

\#\#\#\# 

\`\`\`  
𝐿(|𝐸𝑞|+|𝐸𝑟|)𝑑+𝑛𝑞𝑛𝑟𝑑+log𝑁𝑠+log𝑁𝑔+𝑘𝑠+𝑘𝑔+LLM(𝑇)  
\`\`\`  
\#\#\#\#

\#\#\#\# .

\`\`\`  
In practice, the cross-attention term𝑂(𝑛𝑞𝑛𝑟𝑑)becomes the pri-  
mary bottleneck when the retrieved context is large, while HNSW  
search and GNN encoding remain sub-linear or linear in repository  
size due to indexing.  
\`\`\`  
\#\# 5 RELATED WORK

\#\# 5.1 Large Language Models for Code

\`\`\`  
In recent years, the rapid advancement of Large Language Models  
(LLMs) has significantly enhanced the performance of software  
engineering tasks such as code completion\[ 1 , 16 , 32 , 47 \]. These  
models are broadly classified into closed-source and open-source  
variants.  
Proprietary models, such as OpenAI’s GPT-4\[ 34 \], which was de-  
veloped upon its pioneering model Codex\[ 8 \], along with Google’s  
Gemini 2.5\[ 17 \] and Anthropic’s Claude 3.5 Sonnet\[ 4 \], have achieved  
leading positions on multiple code benchmarks like HumanEval\[ 8 \]  
and MBPP\[ 5 \]. Concurrently, the open-source community has wit-  
nessed the emergence of numerous high-performance models. This  
includes powerful general-purpose LLMs with strong coding capa-  
bilities, such as Llama 3\[ 15 \], Qwen 2.5\[ 38 \], and DeepSeek-V3\[ 26 \],  
as well as dedicated code models like Code Llama\[ 40 \], StarCoder\[ 23 ,  
\`\`\`  
\`\`\`  
31 \], and DeepSeek-Coder\[ 16 , 58 \].The prevailing paradigm for these  
models is to represent source code as a linear sequence of tokens,  
with training centered on autoregressive objectives like Next Token  
Prediction or Fill-in-the-Middle\[7\].  
Despite their proficiency in generating syntactically correct code  
snippets, these models perform suboptimally on repository-level  
code completion tasks, which better reflect real-world software  
development scenarios, due to their limited context windows\[28\].  
\`\`\`  
\#\# 5.2 Repository-level Code Completion

\`\`\`  
In real-world software development, coding often requires referenc-  
ing the contextual information of the entire codebase. Consequently,  
the task of repository-level code completion, which effectively lever-  
ages this information, is gaining increasing attention from both  
academia and industry\[ 13 , 29 \]. Although LLMs have demonstrated  
powerful capabilities in code generation, their inherent context  
window limitations make it difficult for them to directly process  
large-scale codebases\[14, 53\].  
To overcome this limitation, researchers have introduced the  
Retrieval-Augmented Generation (RAG) framework\[ 18 , 20 , 22 , 44 ,  
50 , 54 \]. AceCoder\[ 22 \] finds relevant reference examples by search-  
ing the codebase for programs similar to the current requirement,  
helping the model generate more accurate code. APICoder\[ 50 \],  
which includes an APIRetriever and an APICoder, retrieves poten-  
tially useful API information from a private library’s API docu-  
mentation based on the task; this information is then passed to the  
APICoder as a reference for code generation. kNN-TRANX\[ 54 \] is a  
token-level retrieval-augmented code generation method that im-  
proves code generation performance while reducing retrieval noise.  
RepoCoder\[ 53 \] proposes an iterative retrieval-generation pipeline  
to further enhance the performance of standard RAG methods.  
While RAG effectively extends the model’s contextual scope, these  
methods primarily rely on semantic similarity for retrieval and  
often overlook the structural information of the code.  
Consequently, a growing body of research has attempted to repre-  
sent code as a graph structure to capture its complex dependencies.  
For example, GraphCoder\[ 30 \] captures the contextual information  
of a codebase through a Code Context Graph (CCG) and then em-  
ploys a two-stage coarse-to-fine retrieval strategy. RepoHyper\[ 37 \]  
constructs a repository-level semantic graph and performs graph  
expansion and retrieval operations upon it to obtain more precise  
structured context. CoCoMIC\[ 14 \] utilizes a Dependency Graph  
search from the field of program analysis; during completion, it  
first locates the node corresponding to the segment to be completed  
and then treats its neighboring nodes as supplementary context.  
RepoFuse\[ 24 \] proposes a Repo-specific Semantic Graph, retrieves  
both Semantic Context and Similar Context, and filters for the most  
beneficial context through a Relevance-Guided Context Selection  
method\[9, 37\].  
Furthermore, another line of work focuses on how to integrate  
the retrieved information into the generation model most efficiently.  
For instance, methods like RepoFusion\[ 42 \] and RepoPrompts\[ 43 \]  
have proposed different strategies to optimize the interaction be-  
tween the retrieved information and the LLM, aiming to maximize  
its assistive effect on the generation process.  
\`\`\`

\`\`\`  
GRACE: Graph-Guided Repository-Aware Code Completion through Hierarchical Code Fusion Conference ICSE ’26, April 12-18, 2026, Rio de Janeiro, Brazil  
\`\`\`  
\#\# 6 CONCLUSION

This paper presents GRACE, an innovative graph-based retrieval-  
augmented code completion framework that systematically ad-  
dresses the critical limitations of existing repository-level code  
completion techniques. By modeling code repositories as hierar-  
chical, semantically-rich code graph databases, we fundamentally  
transform the limited perspective of traditional RAG methods. The  
core innovations of the GRACE framework are manifested in three  
aspects: First, we construct a multi-level, multi-semantic hybrid  
code graph that comprehensively captures structural information  
at different granularities from repository-level to function-level;  
Second, our designed hybrid graph retriever significantly improves  
retrieval relevance by integrating GNN-based structural retrieval  
with text semantic retrieval; Finally, our proposed graph fusion  
enhancement mechanism achieves, for the first time, effective uti-  
lization of structural associations between retrieved code and code-  
to-be-completed. Experimental results validate the effectiveness of  
GRACE. Compared to existing state-of-the-art methods, GRACE  
demonstrate the critical value of graph structural information for  
repository-level code completion tasks. Future work will explore  
dynamic graph updating for evolving codebases and generalize  
GRACE to multilingual software environments.

Conference ICSE ’26, April 12-18, 2026, Rio de Janeiro, Brazil Trovato et al.

\#\# REFERENCES

\[1\]Josh Achiam, Steven Adler, Sandhini Agarwal, Lama Ahmad, Ilge Akkaya, Floren-  
cia Leoni Aleman, Diogo Almeida, Janko Altenschmidt, Sam Altman, Shyamal  
Anadkat, et al.2023. Gpt-4 technical report.arXiv preprint arXiv:2303.  
(2023).  
\[2\]Lakshya A Agrawal, Aditya Kanade, Navin Goyal, Shuvendu K Lahiri, and Sri-  
ram K Rajamani. 2023\. Guiding language models of code with global context  
using monitors.arXiv preprint arXiv:2306.10763(2023).  
\[3\]Loubna Ben Allal, Raymond Li, Denis Kocetkov, Chenghao Mou, Christopher  
Akiki, Carlos Munoz Ferrandis, Niklas Muennighoff, Mayank Mishra, Alex Gu,  
Manan Dey, et al.2023. Santacoder: don’t reach for the stars\!arXiv preprint  
arXiv:2301.03988(2023).  
\[4\]Anthropic. 2024\. Claude 3.5 Sonnet. https://www.anthropic.com/news/claude-3-  
5-sonnet. 2024\.  
\[5\]Jacob Austin, Augustus Odena, Maxwell Nye, Maarten Bosma, Henryk  
Michalewski, David Dohan, Ellen Jiang, Carrie Cai, Michael Terry, Quoc Le,  
et al.2021. Program synthesis with large language models. arXiv preprint  
arXiv:2108.07732(2021).  
\[6\]Ramakrishna Bairi, Atharv Sonwane, Aditya Kanade, Vageesh D C, Arun Iyer,  
Suresh Parthasarathy, Sriram Rajamani, Balasubramanyan Ashok, and Shashank  
Shet. 2024\. Codeplan: Repository-level coding using llms and planning.Proceed-  
ings of the ACM on Software Engineering1, FSE (2024), 675–698.  
\[7\]Mohammad Bavarian, Heewoo Jun, Nikolas Tezak, John Schulman, Christine  
McLeavey, Jerry Tworek, and Mark Chen. 2022\. Efficient training of language  
models to fill in the middle.arXiv preprint arXiv:2207.14255(2022).  
\[8\]Mark Chen, Jerry Tworek, Heewoo Jun, Qiming Yuan, Henrique Ponde  
De Oliveira Pinto, Jared Kaplan, Harri Edwards, Yuri Burda, Nicholas Joseph,  
Greg Brockman, et al.2021. Evaluating large language models trained on code.  
arXiv preprint arXiv:2107.03374(2021).  
\[9\]Wei Cheng, Yuhan Wu, and Wei Hu. 2024\. Dataflow-guided retrieval augmen-  
tation for repository-level code completion.arXiv preprint arXiv:2405.  
(2024).  
\[10\]Aakanksha Chowdhery, Sharan Narang, Jacob Devlin, Maarten Bosma, Gaurav  
Mishra, Adam Roberts, Paul Barham, Hyung Won Chung, Charles Sutton, Se-  
bastian Gehrmann, et al.2023. Palm: Scaling language modeling with pathways.  
Journal of Machine Learning Research24, 240 (2023), 1–113.  
\[11\]Fenia Christopoulou, Gerasimos Lampouras, Milan Gritta, Guchun Zhang, Yin-  
peng Guo, Zhongqi Li, Qi Zhang, Meng Xiao, Bo Shen, Lin Li, et al.2022. Pangu-  
coder: Program synthesis with function-level language modeling.arXiv preprint  
arXiv:2207.11280(2022).  
\[12\]Colin B Clement, Shuai Lu, Xiaoyu Liu, Michele Tufano, Dawn Drain, Nan Duan,  
Neel Sundaresan, and Alexey Svyatkovskiy. 2021\. Long-range modeling of source  
code files with eWASH: Extended window access by syntax hierarchy.arXiv  
preprint arXiv:2109.08780(2021).  
\[13\]Yangruibo Ding, Zijian Wang, Wasi Ahmad, Hantian Ding, Ming Tan, Nihal Jain,  
Murali Krishna Ramanathan, Ramesh Nallapati, Parminder Bhatia, Dan Roth,  
et al.2023. Crosscodeeval: A diverse and multilingual benchmark for cross-file  
code completion.Advances in Neural Information Processing Systems36 (2023),  
46701–46723.  
\[14\]Yangruibo Ding, Zijian Wang, Wasi Uddin Ahmad, Murali Krishna Ramanathan,  
Ramesh Nallapati, Parminder Bhatia, Dan Roth, and Bing Xiang. 2022\. Cocomic:  
Code completion by jointly modeling in-file and cross-file context.arXiv preprint  
arXiv:2212.10007(2022).  
\[15\]Aaron Grattafiori, Abhimanyu Dubey, Abhinav Jauhri, Abhinav Pandey, Abhishek  
Kadian, Ahmad Al-Dahle, Aiesha Letman, Akhil Mathur, Alan Schelten, Alex  
Vaughan, et al.2024. The llama 3 herd of models.arXiv preprint arXiv:2407.  
(2024).  
\[16\]Daya Guo, Qihao Zhu, Dejian Yang, Zhenda Xie, Kai Dong, Wentao Zhang,  
Guanting Chen, Xiao Bi, Yu Wu, YK Li, et al.2024. DeepSeek-Coder: When the  
Large Language Model Meets Programming–The Rise of Code Intelligence.arXiv  
preprint arXiv:2401.14196(2024).  
\[17\]Koray Kavukcuoglu. 2025\. Gemini 2.5: Our most intelligent AI model.  
https://blog.google/technology/google-deepmind/gemini-model-thinking-  
updates-march-2025/. 2025\.  
\[18\]Urvashi Khandelwal, Omer Levy, Dan Jurafsky, Luke Zettlemoyer, and Mike  
Lewis. 2019\. Generalization through memorization: Nearest neighbor language  
models.arXiv preprint arXiv:1911.00172(2019).  
\[19\]Seohyun Kim, Jinman Zhao, Yuchi Tian, and Satish Chandra. 2021\. Code pre-  
diction by feeding trees to transformers. In2021 IEEE/ACM 43rd International  
Conference on Software Engineering (ICSE). IEEE, 150–162.  
\[20\]Patrick Lewis, Ethan Perez, Aleksandra Piktus, Fabio Petroni, Vladimir Karpukhin,  
Naman Goyal, Heinrich Küttler, Mike Lewis, Wen-tau Yih, Tim Rocktäschel,  
et al.2020. Retrieval-augmented generation for knowledge-intensive nlp tasks.  
Advances in neural information processing systems33 (2020), 9459–9474.  
\[21\]Jian Li, Yue Wang, Michael R Lyu, and Irwin King. 2017\. Code completion with  
neural attention and pointer networks.arXiv preprint arXiv:1711.09573(2017).

\`\`\`  
\[22\]Jia Li, Yunfei Zhao, Yongmin Li, Ge Li, and Zhi Jin. 2023\. Acecoder: Utilizing  
existing code to enhance code generation.arXiv preprint arXiv:2303.17780(2023).  
\[23\]Raymond Li, Loubna Ben Allal, Yangtian Zi, Niklas Muennighoff, Denis Kocetkov,  
Chenghao Mou, Marc Marone, Christopher Akiki, Jia Li, Jenny Chim, et al.2023.  
Starcoder: may the source be with you\!arXiv preprint arXiv:2305.06161(2023).  
\[24\]Ming Liang, Xiaoheng Xie, Gehao Zhang, Xunjin Zheng, Peng Di, Hongwei  
Chen, Chengpeng Wang, Gang Fan, et al.2024. Repofuse: Repository-level code  
completion with fused dual context.arXiv preprint arXiv:2402.14323(2024).  
\[25\]Dianshu Liao, Shidong Pan, Qing Huang, Xiaoxue Ren, Zhenchang Xing, Huan  
Jin, and Qinying Li. 2023\. Context-aware code generation framework for code  
repositories: Local, global, and third-party library awareness.CoRR(2023).  
\[26\]Aixin Liu, Bei Feng, Bing Xue, Bingxuan Wang, Bochao Wu, Chengda Lu, Cheng-  
gang Zhao, Chengqi Deng, Chenyu Zhang, Chong Ruan, et al.2024. Deepseek-v  
technical report.arXiv preprint arXiv:2412.19437(2024).  
\[27\]Fang Liu, Ge Li, Yunfei Zhao, and Zhi Jin. 2020\. Multi-task learning based pre-  
trained language model for code completion. InProceedings of the 35th IEEE/ACM  
international conference on automated software engineering. 473–485.  
\[28\]Nelson F Liu, Kevin Lin, John Hewitt, Ashwin Paranjape, Michele Bevilacqua,  
Fabio Petroni, and Percy Liang. 2023\. Lost in the middle: How language models  
use long contexts.arXiv preprint arXiv:2307.03172(2023).  
\[29\]Tianyang Liu, Canwen Xu, and Julian McAuley. 2023\. Repobench: Benchmarking  
repository-level code auto-completion systems.arXiv preprint arXiv:2306.  
(2023).  
\[30\]Wei Liu, Ailun Yu, Daoguang Zan, Bo Shen, Wei Zhang, Haiyan Zhao, Zhi Jin, and  
Qianxiang Wang. 2024\. Graphcoder: Enhancing repository-level code completion  
via code context graph-based retrieval and language model. arXiv preprint  
arXiv:2406.07003(2024).  
\[31\]Anton Lozhkov, Raymond Li, Loubna Ben Allal, Federico Cassano, Joel Lamy-  
Poirier, Nouamane Tazi, Ao Tang, Dmytro Pykhtar, Jiawei Liu, Yuxiang Wei,  
et al.2024. Starcoder 2 and the stack v2: The next generation.arXiv preprint  
arXiv:2402.19173(2024).  
\[32\]Ziyang Luo, Can Xu, Pu Zhao, Qingfeng Sun, Xiubo Geng, Wenxiang Hu,  
Chongyang Tao, Jing Ma, Qingwei Lin, and Daxin Jiang. 2023\. Wizardcoder:  
Empowering code large language models with evol-instruct.arXiv preprint  
arXiv:2306.08568(2023).  
\[33\]Erik Nijkamp, Hiroaki Hayashi, Caiming Xiong, Silvio Savarese, and Yingbo  
Zhou. 2023\. Codegen2: Lessons for training llms on programming and natural  
languages.arXiv preprint arXiv:2305.02309(2023).  
\[34\] OpenAI. 2024\. Hello GPT-4o. https://openai.com/index/hello-gpt-4o/. 2024\.  
\[35\]Md Rizwan Parvez, Wasi Uddin Ahmad, Saikat Chakraborty, Baishakhi Ray, and  
Kai-Wei Chang. 2021\. Retrieval augmented code generation and summarization.  
arXiv preprint arXiv:2108.11601(2021).  
\[36\]Boci Peng, Yun Zhu, Yongchao Liu, Xiaohe Bo, Haizhou Shi, Chuntao Hong, Yan  
Zhang, and Siliang Tang. 2024\. Graph retrieval-augmented generation: A survey.  
arXiv preprint arXiv:2408.08921(2024).  
\[37\]Huy Nhat Phan, Hoang Nhat Phan, Tien N Nguyen, and Nghi DQ Bui. 2024\.  
Repohyper: Better context retrieval is all you need for repository-level code  
completion.CoRR(2024).  
\[38\]Qwen, :, An Yang, Baosong Yang, Beichen Zhang, Binyuan Hui, Bo Zheng, Bowen  
Yu, Chengyuan Li, Dayiheng Liu, Fei Huang, Haoran Wei, Huan Lin, Jian Yang,  
Jianhong Tu, Jianwei Zhang, Jianxin Yang, Jiaxi Yang, Jingren Zhou, Junyang  
Lin, Kai Dang, Keming Lu, Keqin Bao, Kexin Yang, Le Yu, Mei Li, Mingfeng Xue,  
Pei Zhang, Qin Zhu, Rui Men, Runji Lin, Tianhao Li, Tianyi Tang, Tingyu Xia,  
Xingzhang Ren, Xuancheng Ren, Yang Fan, Yang Su, Yichang Zhang, Yu Wan,  
Yuqiong Liu, Zeyu Cui, Zhenru Zhang, and Zihan Qiu. 2025\. Qwen2.5 Technical  
Report. arXiv:2412.15115 \[cs.CL\] https://arxiv.org/abs/2412.  
\[39\]Stephen Robertson, Hugo Zaragoza, et al.2009. The probabilistic relevance  
framework: BM25 and beyond.Foundations and Trends®in Information Retrieval  
3, 4 (2009), 333–389.  
\[40\]Baptiste Roziere, Jonas Gehring, Fabian Gloeckle, Sten Sootla, Itai Gat, Xiao-  
qing Ellen Tan, Yossi Adi, Jingyu Liu, Romain Sauvestre, Tal Remez, et al.2023.  
Code llama: Open foundation models for code.arXiv preprint arXiv:2308.  
(2023).  
\[41\]Freda Shi, Xinyun Chen, Kanishka Misra, Nathan Scales, David Dohan, Ed H Chi,  
Nathanael Schärli, and Denny Zhou. 2023\. Large language models can be easily  
distracted by irrelevant context. InInternational Conference on Machine Learning.  
PMLR, 31210–31227.  
\[42\]Disha Shrivastava, Denis Kocetkov, Harm de Vries, Dzmitry Bahdanau, and  
Torsten Scholak. 2023\. Repofusion: Training code models to understand your  
repository.arXiv preprint arXiv:2306.10998(2023).  
\[43\]Disha Shrivastava, Hugo Larochelle, and Daniel Tarlow. 2023\. Repository-level  
prompt generation for large language models of code. InInternational Conference  
on Machine Learning. PMLR, 31693–31715.  
\[44\]Hanzhuo Tan, Qi Luo, Ling Jiang, Zizheng Zhan, Jing Li, Haotian Zhang, and  
Yuqun Zhang. 2024\. Prompt-based code completion via multi-retrieval augmented  
generation.ACM Transactions on Software Engineering and Methodology(2024).  
\[45\]Ze Tang, Jidong Ge, Shangqing Liu, Tingwei Zhu, Tongtong Xu, Liguo Huang,  
and Bin Luo. 2023\. Domain adaptive code completion via language models and  
\`\`\`

GRACE: Graph-Guided Repository-Aware Code Completion through Hierarchical Code Fusion Conference ICSE ’26, April 12-18, 2026, Rio de Janeiro, Brazil

decoupled domain databases. In2023 38th IEEE/ACM International Conference on  
Automated Software Engineering (ASE). IEEE, 421–433.  
\[46\]Hongyuan Tao, Ying Zhang, Zhenhao Tang, Hongen Peng, Xukun Zhu,  
Bingchang Liu, Yingguang Yang, Ziyin Zhang, Zhaogui Xu, Haipeng Zhang, et al.

2025\. Code Graph Model (CGM): A Graph-Integrated Large Language Model for  
Repository-Level Software Engineering Tasks.arXiv preprint arXiv:2505.  
(2025).  
\[47\]Yue Wang, Hung Le, Akhilesh Deepak Gotmare, Nghi DQ Bui, Junnan Li, and  
Steven CH Hoi. 2023\. Codet5+: Open code large language models for code  
understanding and generation.arXiv preprint arXiv:2305.07922(2023).  
\[48\]Yanlin Wang, Yanli Wang, Daya Guo, Jiachi Chen, Ruikai Zhang, Yuchi Ma, and  
Zibin Zheng. 2024\. Rlcoder: Reinforcement learning for repository-level code  
completion.arXiv preprint arXiv:2407.19487(2024).  
\[49\]Sushma Reddy Yadavalli, Lokesh Chandra Das, and Myounggyu Won. 2023\. Rlpg:  
Reinforcement learning approach for dynamic intra-platoon gap adaptation  
for highway on-ramp merging. In2023 IEEE/RSJ International Conference on  
Intelligent Robots and Systems (IROS). IEEE, 5514–5521.  
\[50\]Daoguang Zan, Bei Chen, Zeqi Lin, Bei Guan, Yongji Wang, and Jian-Guang Lou.  
2022\. When language model meets private library.arXiv preprint arXiv:2210.  
(2022).  
\[51\]Daoguang Zan, Bei Chen, Dejian Yang, Zeqi Lin, Minsu Kim, Bei Guan, Yongji  
Wang, Weizhu Chen, and Jian-Guang Lou. 2022\. CERT: continual pre-training  
on sketches for library-oriented code generation.arXiv preprint arXiv:2206.  
(2022).

\`\`\`  
\[52\]Daoguang Zan, Bei Chen, Fengji Zhang, Dianjie Lu, Bingchao Wu, Bei Guan,  
Yongji Wang, and Jian-Guang Lou. 2022\. Large language models meet NL2Code:  
A survey.arXiv preprint arXiv:2212.09420(2022).  
\[53\]Fengji Zhang, Bei Chen, Yue Zhang, Jacky Keung, Jin Liu, Daoguang Zan, Yi Mao,  
Jian-Guang Lou, and Weizhu Chen. 2023\. Repocoder: Repository-level code com-  
pletion through iterative retrieval and generation.arXiv preprint arXiv:2303.  
(2023).  
\[54\]Xiangyu Zhang, Yu Zhou, Guang Yang, and Taolue Chen. 2023\. Syntax-aware  
retrieval augmented code generation. InFindings of the Association for Computa-  
tional Linguistics: EMNLP 2023\. 1291–1302.  
\[55\]Ziyin Zhang, Chaoyu Chen, Bingchang Liu, Cong Liao, Zi Gong, Hang Yu, Jianguo  
Li, and Rui Wang. 2023\. Unifying the perspectives of nlp and software engineering:  
A survey on language models for code.arXiv preprint arXiv:2311.07989(2023).  
\[56\]Qinkai Zheng, Xiao Xia, Xu Zou, Yuxiao Dong, Shan Wang, Yufei Xue, Lei Shen,  
Zihan Wang, Andi Wang, Yang Li, et al.2023. Codegeex: A pre-trained model for  
code generation with multilingual benchmarking on humaneval-x. InProceedings  
of the 29th ACM SIGKDD Conference on Knowledge Discovery and Data Mining.  
5673–5684.  
\[57\]Zibin Zheng, Kaiwen Ning, Yanlin Wang, Jingwen Zhang, Dewu Zheng, Mingxi  
Ye, and Jiachi Chen. 2023\. A survey of large language models for code: Evolution,  
benchmarking, and future trends.arXiv preprint arXiv:2311.10372(2023).  
\[58\]Qihao Zhu, Daya Guo, Zhihong Shao, Dejian Yang, Peiyi Wang, Runxin Xu,  
Y Wu, Yukun Li, Huazuo Gao, Shirong Ma, et al.2024. Deepseek-coder-v2:  
Breaking the barrier of closed-source models in code intelligence.arXiv preprint  
arXiv:2406.11931(2024).  
\`\`\`


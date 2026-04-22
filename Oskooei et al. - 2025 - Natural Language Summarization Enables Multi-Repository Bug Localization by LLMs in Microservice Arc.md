\#\# Natural Language Summarization Enables Multi-Repository Bug

\#\# Localization by LLMs in Microservice Architectures

\#\# Amirkia Rafiei Oskooei

\#\#\# amirkia.oskooei@intellica.net

\#\#\# amirkia.oskooei@std.yildiz.edu.tr

\#\#\# Intellica Business Intelligence Consultancy, R\&D

\#\#\# Center

\#\#\# Yildiz Technical University, Dept. of Computer Eng.

\#\#\# Istanbul, Turkey

\#\# S. Selcan Yukcu

\#\#\# selcan.yukcu@intellica.net

\#\#\# Intellica Business Intelligence Consultancy, R\&D

\#\#\# Center

\#\#\# Istanbul, Turkey

\#\# Mehmet Cevheri Bozoglan

\#\#\# cevheri.bozoglan@intellica.net

\#\#\# Intellica Business Intelligence Consultancy, R\&D

\#\#\# Center

\#\#\# Istanbul, Turkey

\#\# Mehmet S. Aktas

\#\#\# aktas@yildiz.edu.tr

\#\#\# Yildiz Technical University, Department of Computer

\#\#\# Engineering

\#\#\# Istanbul, Turkey

\`\`\`  
Figure 1: A comparison of isolated vs. context-aware summarization. (Red) An isolated summary describes a file’s low-level  
implementation details. (Green) Our context-aware approach, primed with a repository-level "seed context," produces a summary  
that explains the file’s architectural role and purpose, which is more effective for bug localization.  
\`\`\`  
\#\# Abstract

\`\`\`  
Bug localization in multi-repository microservice architec-  
tures is challenging due to the semantic gap between natural  
language bug reports and code, LLM context limitations,  
and the need to first identify the correct repository. We pro-  
pose reframing this as a natural language reasoning task  
by transforming codebases into hierarchical NL summaries  
\`\`\`  
\`\`\`  
Permission to make digital or hard copies of all or part of this work  
for personal or classroom use is granted without fee provided that  
copies are not made or distributed for profit or commercial advantage  
and that copies bear this notice and the full citation on the first page.  
Copyrights for components of this work owned by others than the au-  
thor(s) must be honored. Abstracting with credit is permitted. To copy  
otherwise, or republish, to post on servers or to redistribute to lists,  
requires prior specific permission and/or a fee. Request permissions  
from permissions@acm.org.  
ICSE 2026, Rio de Janeiro, Brazil  
© 2026 Copyright held by the owner/author(s). Publication rights  
licensed to ACM.  
ACM ISBN 978-1-4503-XXXX-X/2026/  
https://doi.org/XXXXXXX.XXXXXXX  
\`\`\`  
\`\`\`  
and performing NL-to-NL search instead of cross-modal re-  
trieval. Our approach builds context-aware summaries at  
file, directory, and repository levels, then uses a two-phase  
search: first routing bug reports to relevant repositories, then  
performing top-down localization within those repositories.  
Evaluated on DNext, an industrial system with 46 reposito-  
ries and 1.1M lines of code, our method achieves Pass@10 of  
0.82 and MRR of 0.50, significantly outperforming retrieval  
baselines and agentic RAG systems like GitHub Copilot and  
Cursor. This work demonstrates that engineered natural lan-  
guage representations can be more effective than raw source  
code for scalable bug localization, providing an interpretable  
repository→directory→file search path, which is vital for  
building trust in enterprise AI tools by providing essential  
transparency.  
\`\`\`  
\#\# CCS Concepts

\- Computing methodologies→Natural language processing;  
Artificial intelligence;• Software and its engineering;

\# arXiv:2512.05908v1 \[cs.SE\] 5 Dec 2025

\`\`\`  
ICSE 2026, April 12, 2026, Rio de Janeiro, Brazil Rafiei Oskooei et al.  
\`\`\`  
\#\# Keywords

Bug Localization, Code Retrieval, Microservice architecture,  
Large Language Model (LLM), Natural Language Processing  
(NLP), Software Engineering,

ACM Reference Format:  
Amirkia Rafiei Oskooei, S. Selcan Yukcu, Mehmet Cevheri Bo-  
zoglan, and Mehmet S. Aktas. 2026\. Natural Language Summa-  
rization Enables Multi-Repository Bug Localization by LLMs in  
Microservice Architectures. In \_Proceedings of 2026 International  
Conference on Software Engineering (ICSE 2026).\_ ACM, New  
York, NY, USA, 9 pages. https://doi.org/XXXXXXX.XXXXXXX

\#\# 1 Introduction

Large Language Models (LLMs) are increasingly applied  
to complex software engineering tasks like bug localization.  
However, current methods, which primarily rely on Retrieval-  
Augmented Generation (RAG) over raw source code, face  
significant challenges in large-scale, industrial settings. These  
systems often struggle with three key limitations. First, they  
must bridge the \_semantic gap\_ , where the natural language  
of a user’s bug report often lacks semantic overlap with the  
technical terms in the code. Second, they are constrained by  
the LLM’s \_finite context window\_ , which prevents them from  
comprehending an entire codebase holistically. Third, they are  
often designed with an implicit \_single-repository assumption\_.  
This makes them ineffective for large-scale software projects  
composed of many interacting microservices, as they lack a  
mechanism to first route a bug report to the correct repository  
(codebase) before localization can begin.  
In this work, we explore an alternative paradigm. As il-  
lustrated in Figure 2, most current methods move \_down\_ the  
abstraction ladder, transforming source code (PL) into low-  
level vector embeddings for similarity search. We hypothesize  
that for complex bug localization, it is more effective to move  
\_up\_ the ladder. By representing code at a higher level of ab-  
straction—natural language (NL) summaries—we reframe  
the problem. This shift from a cross-modal retrieval task to  
a unified NL-to-NL reasoning task is designed to directly  
leverage the powerful semantic understanding of modern  
LLMs.  
We present a methodology to realize this approach. To  
manage the scale of enterprise systems, we first transform  
the source code across all repositories within a project into a  
compact, hierarchical NL knowledge base. This is achieved  
through \_context-aware summarization\_ , which creates semanti-  
cally rich descriptions that capture the architectural purpose  
of each component. This compact representation helps miti-  
gate the LLM’s context window limitations. The knowledge  
base is then navigated using a scalable, \_two-phase hierarchi-  
cal search\_ that first identifies the most probable repository  
before performing a targeted, top-down search for the faulty  
file.  
Our primary contributions are:  
∙A methodology for transforming a multi-repository  
software project into a hierarchical NL knowledge base,

\`\`\`  
Figure 2: The levels of code abstraction. While traditional  
methods move down from Programming Language (PL) to low-  
level vector embeddings, our approach moves up, transforming  
PL into a higher-level Natural Language (NL) representation  
to enable semantic reasoning with LLMs.  
\`\`\`  
\`\`\`  
enabling a scalable, end-to-end bug localization work-  
flow.  
∙A two-phase search framework that explicitly addresses  
the multi-repository routing problem, a critical chal-  
lenge for bug localization in microservice architectures.  
∙A comprehensive empirical evaluation on a large-scale  
industrial project, demonstrating the effectiveness of  
our approach over strong RAG and retrieval-based  
baselines.  
∙An interpretable and auditable reasoning process (repos-  
itory→directory→file), which can enhance developer  
trust in AI-powered tools.  
\`\`\`  
\#\# 2 Methodology

\`\`\`  
To address the challenges of scale, context, and architectural  
complexity outlined in Section 1, our methodology is designed  
as a two-stage process. First, we transform the entire multi-  
repository codebase into a compact and semantically rich  
NL Knowledge Base. Second, we employ a Two-Phase Search  
to efficiently navigate this knowledge base and pinpoint the  
source of a bug. This approach systematically converts a  
cross-modal search problem into a more effective NL-to-NL  
reasoning task.  
\`\`\`  
\#\# 2.1 Building Knowledge Base

\`\`\`  
The primary obstacle to applying LLMs on enterprise-scale  
systems is the finite context window. To overcome this, we  
construct a hierarchical representation of the codebase that  
is both compact and information-rich. This offline process  
involves two key steps.  
\`\`\`  
\`\`\`  
Repository-Level Seed Context. The process begins by gen-  
erating a high-quality, repository-level summary for each  
microservice, which serves as a "seed context." This holistic  
summary ensures that lower-level descriptions understand  
their architectural role, a critical distinction shown in Fig-  
ure 1\. To generate this seed context, we prompt an LLM  
with a comprehensive set of artifacts, a process detailed in  
Figure 3:  
∙ The Repository Tree: The directory and file structure.  
\`\`\`

\`\`\`  
Natural Language Summarization Enables Multi-Repository Bug Localization by LLMs in Microservice ArchitecturesICSE 2026, April 12, 2026, Rio de Janeiro, Brazil  
\`\`\`  
\`\`\`  
∙Source Code: A linearized version of the codebase (code  
snippets).  
∙Processed Attachments: Project documentation, includ-  
ing READMEs and descriptive text extracted from  
diagrams (e.g., UML, ER) using a multi-modal OCR  
and Vision-Language Model (VLM) pipeline.  
\`\`\`  
\_Bottom-Up Aggregation.\_ With the seed context established,  
we then construct the knowledge tree in a bottom-up fashion  
(Figure 4). For each source file, an LLM is prompted with  
its raw code \_and\_ the repository’s seed context to generate a  
concise, context-aware summary. These file-level summaries  
(the leaves of our tree) are then aggregated at the directory  
level. For each major directory (e.g.,/service,/controller),  
its constituent file summaries are provided to the LLM to  
generate a coherent directory-level summary, forming the  
intermediate nodes of the knowledge tree.

\#\# 2.2 Two-Phase Search

\`\`\`  
During inference, we leverage the NL knowledge base to  
perform an efficient top-down search. This process is explicitly  
designed to handle the multi-repository nature of microservice  
architectures.  
\`\`\`  
\_Phase 1: Search Space Routing.\_ Given a bug report, the  
first challenge is to identify the correct microservice (reposi-  
tory). As illustrated in Figure 5, our framework routes the  
query by prompting an LLM to compare the bug report  
against the high-level, repository-level summaries of all mi-  
croservices. This produces a ranked list of candidate repos-  
itories, ensuring the subsequent search is focused only on  
relevant code repositories.  
\_Phase 2: Top-Down Bug Localization.\_ Within each candi-  
date repository, we perform a two-step hierarchical search  
to find the specific buggy file (Figure 6). First, the LLM  
performs \_Directory-Level Filtering\_ by comparing the bug  
report against all directory-level summaries to identify the  
top- \_𝑘\_ most relevant directories. Second, the search space  
is narrowed to the files within these directories for a final  
\_File-Level Ranking\_. The LLM performs a detailed analysis of  
these filtered file summaries to produce the final ranked list  
of files most likely to be the source of the bug.  
This structuredrepository → directory → filesearch  
path provides an inherently transparent and auditable rea-  
soning process.^1 By decomposing the localization task into a  
series of explicit, verifiable steps, our method addresses the  
"black box" nature of many end-to-end systems, contributing  
to the goal of Explainable AI in developer tools.

\#\# 3 Experiments and Evaluation

We conduct an empirical study to evaluate our proposed  
architecture for LLM-based bug localization. Our evaluation  
aims to answer two primary questions: (1) How effectively  
does our NL-to-NL approach perform against state-of-the-art

(^1) To enhance the quality of reasoning at each stage, all prompts used dur-  
ing the inference process explicitly leverage Chain-of-Thought (CoT)  
prompting techniques.  
baselines on a complex, multi-repository benchmark? (2) How  
critical is the hierarchical search component to the method’s  
accuracy and efficiency?

\#\# 3.1 Experimental Setup

\`\`\`  
Dataset. Our evaluation is performed on DNext \[ 7 \], a pro-  
prietary, industrial-scale microservice system for the telecom-  
munications sector. Its scale (see Table 1\) and use of real-  
world, often noisy, bug reports provide a challenging bench-  
mark that standard academic datasets cannot replicate. The  
ground truth for each bug ticket is the set of files modified  
in the pull request that resolved the issue.  
\`\`\`  
\`\`\`  
Table 1: Statistics of the DNext microservice dataset.  
\`\`\`  
\`\`\`  
Metric Value  
Programming Language Java  
Number of Repositories 46  
Total Number of Code Files 7,  
Total Physical Lines of Code ∼1.1M  
Number of Bug Tickets 87  
Average Buggy Files per Ticket 7\.  
\`\`\`  
\`\`\`  
Baselines. We compare our method against two strong  
categories of baselines. For all LLM-based methods, including  
our own, we use the gpt-4.1 model to ensure a fair comparison  
of reasoning capabilities.  
∙Flat Retrieval: We use traditional IR baselines, UniX-  
coder \[ 10 \] and GraphCodeBERT \[ 11 \], to retrieve the  
most similar code files based on cosine similarity be-  
tween embeddings.  
∙Agentic RAG: We evaluate against state-of-the-art,  
repository-aware code assistants that operate on source  
code via RAG. We use two leading commercial systems:  
GitHub Copilot \[9\] and Cursor \[4\].  
Metrics. We evaluate performance using standard metrics:  
Pass@k and Recall@k. Pass@k measures the proportion of  
bug reports where at least one correct file is found in the  
top- 𝑘 results. Recall@k measures the fraction of all correct  
files for a given bug that are successfully retrieved within the  
top- 𝑘 results. Given that the maximum number of modified  
files for any bug in our dataset is 10 (average 7.2), we set  
𝑘 \= 10 as a fair and comprehensive threshold that covers the  
full scope of a typical fix without artificially inflating scores  
with a large retrieval window. For the preliminary search  
space routing phase, we use a tighter 𝑘 \= 3\.  
\`\`\`  
\#\# 3.2 Main Results

\`\`\`  
Search Space Routing Performance. Table 2 shows our  
method’s effectiveness at the critical first step: routing a  
bug to the correct microservice. Our summary-based router  
outperforms the Agentic RAG baselines on coverage metrics  
(Pass@3 and Recall@3). This is a crucial advantage for am-  
biguous bugs that may span multiple services, as our method  
\`\`\`

\`\`\`  
ICSE 2026, April 12, 2026, Rio de Janeiro, Brazil Rafiei Oskooei et al.  
\`\`\`  
\`\`\`  
Figure 3: The generation process for the repository-level summary. A multimodal pipeline processes various repository documents  
into a single text format. These attachments, along with the repository tree and source code, are used to prompt an LLM to  
create a comprehensive summary that serves as the seed context for all downstream tasks.  
\`\`\`  
\`\`\`  
Figure 4: Bottom-up construction of the knowledge tree. Leaf  
nodes (file-level summaries) are generated first, using the  
repository-level summary as seed context. These are then  
aggregated to create intermediate nodes (directory-level sum-  
maries), forming a hierarchical NL representation of the code-  
base.  
\`\`\`  
\`\`\`  
is more likely to include all relevant repositories in the initial  
search space.  
\`\`\`  
Table 2: Search Space Routing performance. Our NL-to-NL  
approach is more effective at identifying the correct set of  
candidate repositories.

\`\`\`  
Approach Pass@3 Recall@3 MRR  
Flat Retrieval N/A N/A N/A  
Agentic RAG  
GitHub Copilot 0.82 0.82 0\.  
Cursor 0.91 0.91 0\.  
Ours 0.93 0.93 0\.  
\`\`\`  
\`\`\`  
Bug Localization Performance. Table 3 shows the end-to-  
end file localization performance. Our hierarchical approach  
achieves the highest Pass@10 and MRR, indicating it is  
both more likely to find a correct file and to rank the first  
correct file higher than any baseline. It also matches the  
best-performing baseline (Cursor) on Recall@10, the metric  
most sensitive to multi-file bugs. These results validate our  
central hypothesis: a structured search over an NL knowledge  
\`\`\`  
\`\`\`  
Figure 5: The Search Space Routing process. The LLM com-  
pares a bug report against repository-level summaries to iden-  
tify a ranked list of candidate microservices, focusing the  
search.  
\`\`\`  
\`\`\`  
base can be a more accurate and effective paradigm than  
retrieving from raw source code in some use cases.  
\`\`\`  
\#\# 3.3 Ablation Study: The Impact of Hierarchy

\`\`\`  
To validate our claim that the hierarchical search is a critical  
component for both accuracy and efficiency, we conduct  
an ablation study. We compare our full method against an  
ablated version, which omits the directory-level filtering step.  
In this version, after routing to the correct repository, the  
LLM is prompted with the bug report and the summaries  
of all files within that repository to produce a final ranking  
directly.  
\`\`\`

\`\`\`  
Natural Language Summarization Enables Multi-Repository Bug Localization by LLMs in Microservice ArchitecturesICSE 2026, April 12, 2026, Rio de Janeiro, Brazil  
\`\`\`  
\`\`\`  
Figure 6: The top-down bug localization process. The search is  
first narrowed to candidate directories (Upper Red Rectangle)  
before a focused search over file-level summaries finds the  
exact bug location (Lower Red Rectangle).  
\`\`\`  
Table 3: File-level bug localization performance. Our approach  
outperforms both retrieval and Agentic RAG baselines.

\`\`\`  
Approach Pass@10 Recall@10 MRR  
Flat Retrieval  
UniXcoder 0.23 0.16 0\.  
GraphCodeBERT 0.62 0.34 0\.  
Agentic RAG  
GitHub Copilot 0.61 0.27 0\.  
Cursor 0.57 0.49 0\.  
Ours (Hierarchical) 0.82 0.49 0\.  
\`\`\`  
Table 4: Ablation study on the impact of hierarchical search.  
The ‘w/o filtering‘ row shows the significant performance  
degradation and cost increase when the directory-level filtering  
is removed.

\`\`\`  
Method Pass@10 Recall@10 MRR Avg.  
Tokens  
w/ filtering 0.82 0.49 0.50 37K  
\+ 38K  
w/o filtering 0\.  
(-18%)  
\`\`\`  
\#\#\#\# 0\.

\`\`\`  
(-37%)  
\`\`\`  
\#\#\#\# 0\.

\#\#\#\# (-54%) 108K

\`\`\`  
(+44%)  
\`\`\`  
The results of our ablation study, presented in Table 4,  
powerfully validate our central architectural claim. Removing  
the directory-level filtering step forces the LLM to solve a  
classic "needle-in-a-haystack" problem, searching for a few  
relevant files within the noisy context of an entire repository’s  
summaries. This leads to a catastrophic drop in performance  
across all metrics, with MRR plummeting by 54% and Re-  
call@10 falling by 37%. In contrast, our hierarchical method  
acts as a cognitive scaffold, breaking the complex localization  
task into manageable steps to focus the LLM’s reasoning.  
This approach is not only substantially more accurate but  
also more scalable, as the ablated version requires a 44%  
increase in prompt tokens, making it prohibitively expensive

\`\`\`  
and proving that our hierarchical design is critical for both  
performance and cost-effectiveness.  
\`\`\`  
\#\# 3.4 Qualitative Analysis

\`\`\`  
To understand why our NL-to-NL approach succeeds where  
retrieval fails, we present two case studies in Figure 7\. These  
examples show how reasoning over the conceptual purpose  
of code, rather than just its keywords, allows our method to  
solve complex bugs.  
\`\`\`  
\#\# 4 Related Works

\`\`\`  
Our work is situated at the intersection of code retrieval,  
LLM-based bug localization, and code summarization.  
NL-to-PL Code Retrieval. The foundational challenge in  
bug localization is bridging the cross-modal gap between  
natural language (NL) and programming language (PL).  
Foundational models like CodeBERT \[ 8 \], UniXcoder \[ 10 \],  
and GraphCodeBERT \[ 11 \] established the viability of joint  
NL-PL embeddings by incorporating code structure. While  
subsequent work has sought to mitigate the persistent vocab-  
ulary mismatch through techniques like dynamic execution  
features \[ 18 \] or NL-augmented retrieval \[ 3 \], these methods  
still operate on the difficult cross-modal boundary our NL-  
to-NL approach is designed to circumvent.  
\`\`\`  
\`\`\`  
LLM-based Bug Localization. Modern systems leverage  
LLMs for more sophisticated reasoning. Strategies include  
augmenting the query or code before retrieval \[ 13 , 16 \], com-  
bining retrieval with iterative codebase analysis \[ 1 \], or lever-  
aging structured context via external memory \[ 25 \] and code  
graphs \[ 17 \]. State-of-the-art agentic frameworks like OrcaLoca \[ 26 \]  
and COSIL \[ 14 \] demonstrate impressive navigation, and hier-  
archical approaches like BugCerberus \[ 2 \] use specialized mod-  
els at different granularities. However, BugCerberus focuses  
on vertical granularity (File→Statement) within a single  
repository context. Despite their power, these frameworks  
are architecturally constrained to single-repository settings.  
They fundamentally lack a mechanism for multi-repository  
routing, making them unsuitable for modern microservice  
architectures where identifying the correct repository is the  
critical first step. Our two-phase framework directly addresses  
this critical gap.  
\`\`\`  
\`\`\`  
Automatic Code Summarization. The field of automatic  
code summarization \[ 22 \] provides the foundation for our rep-  
resentation engineering. Research has shown that code search  
is significantly improved when code snippets are paired with  
NL descriptions \[ 12 \]. Recent advances have moved beyond  
method-level summaries to tackle higher-level units using  
hierarchical \[ 6 , 19 , 20 , 23 \] and context-aware \[ 21 \] generation  
strategies. While our previous work \[ 19 \] demonstrated the  
feasibility of hierarchical summarization for single-repository  
contexts, this paper extends that foundation into a compre-  
hensive framework for multi-repository microservice archi-  
tectures. We introduce the Search Space Router to solve the  
critical "missing link" of repository identification and enhance  
the summarization strategy with context-aware propagation.  
\`\`\`

\`\`\`  
ICSE 2026, April 12, 2026, Rio de Janeiro, Brazil Rafiei Oskooei et al.  
\`\`\`  
\`\`\`  
Case Study 1: Conditional Logic Bug  
Bug Report: "Revision number is not increased in certain cases.  
External Reference is added but revision remains as zero. However,  
a PATCH request to replace the ‘/name‘ field does increase the  
revision... This should be fixed for financialAccount and partyAc-  
count  
The Challenge: A successful tool must understand the code’s con-  
ditional business logic—why one PATCH operation behaves differ-  
ently from another—not just find files related to "Account".  
Baseline Failure: The Agentic RAG retrieved generic files, such as:  
∙ controller/PartyAccountController.java  
∙ model/FinancialAccount.java  
Analysis: This approach completely missed the nuanced validation  
logic central to the bug.  
Our Method’s Success: Our method identified the crucial service  
classes and, most importantly, the specific validator governing the  
patch operation:  
∙ service/FinancialAccountService.java  
∙ validation/PartyAccountJsonPatch...Validator.java  
Analysis: By understanding the file’s architectural role, it pin-  
pointed the exact component responsible for the faulty logic.  
\`\`\`  
Case Study 2: Referential Integrity Bug  
Bug Report: \_"There’s a data integrity issue in order management.  
The system is allowing us to create new service orders that refer  
to service specifications that don’t actually exist in the catalog..."\_  
The Challenge: The bug is caused by a missing validation check  
between two different business domains. The tool must reason  
about the expected interaction, not just search for existing code.  
Baseline Failure: The Agentic RAG identified the general topic  
(‘ServiceOrder‘) but returned irrelevant mappers and high-level  
application files:  
∙ controller/ServiceOrderController.java  
∙ mapper/ServiceOrderMapper.java  
\_Analysis: It found the right topic but could not diagnose the specific,  
missing integrity check.\_  
Our Method’s Success: Our method correctly identified the special-  
ized validator classes where the missing logic should have been  
implemented:  
∙ validators/OrderItemServiceSpec...PatchValidator.java  
∙ util/ServiceSpecificationExistenceValidatorHelper.java  
\_Analysis: It succeeded by reasoning about the required interaction  
between system components, even when the code for it was absent.\_

\`\`\`  
Figure 7: Qualitative analysis of two challenging bugs. Our  
method succeeds by reasoning about conceptual logic, while  
the baseline fails by relying on superficial keyword matching.  
\`\`\`  
\`\`\`  
Critically, retrieval over NL summaries has been shown to be  
a viable alternative to searching over code \[ 24 \]. While this  
body of work typically treats summaries as a documenta-  
tion end-product, our key contribution is to systematically  
engineer these summaries into a task-specific intermediate  
\`\`\`  
\`\`\`  
representation. By doing so, we transform bug localization  
from a difficult cross-modal retrieval problem into a more  
tractable NL-to-NL reasoning task optimized for scale and  
architectural complexity.  
\`\`\`  
\`\`\`  
Positioning Our Work. Our contribution is therefore not a  
new summarization model, but rather a novel act of represen-  
tation engineering. We systematically apply established sum-  
marization techniques to build a purpose-built NL knowledge  
base, an intermediate representation designed specifically for  
the task of bug localization (which is a re-usable asset for  
other use-cases as mentioned in Section 5). This architec-  
tural pattern is the key that unlocks two distinct advantages  
over existing methods: it provides the holistic context nec-  
essary to solve the critical multi-repository routing problem,  
and it reframes the task into a unified NL-to-NL reasoning  
challenge that better leverages the semantic power of LLMs.  
Consequently, our framework is not only more scalable for  
complex microservice environments but also inherently more  
interpretable, offering a non-black-box reasoning path that  
is critical for enterprise adoption where developer trust is  
paramount.  
\`\`\`  
\#\# 5 Discussion

\`\`\`  
Our empirical results validate our central hypothesis: for  
bug localization in complex systems, an engineered natural  
language representation of source code can be sometimes  
more effective than the code itself. Our findings, including  
the ablation study, confirm that the hierarchical search over  
this representation is not only more accurate but also more  
cost-effective. This section discusses the broader implications  
of this architectural shift and acknowledges the limitations  
of our work.  
\`\`\`  
\`\`\`  
Implications for AI-Powered Developer Tools. This work  
has several practical implications for the design of future SE  
tools:  
∙A Scalable Architecture for Microservices: The single-  
repository assumption of most current tools is a criti-  
cal architectural limitation. Our two-phase framework  
offers a concrete, scalable solution for applying LLM-  
based reasoning to enterprise-scale, multi-repository  
systems—a ubiquitous industrial paradigm.  
∙A New Paradigm via Reusable Knowledge Bases: The  
hierarchical NL knowledge base is a reusable asset.  
Beyond bug localization, it can power a new class of  
developer tools for tasks like conceptual code search,  
automated onboarding of new engineers, and architec-  
tural analysis, similar to tools such as DeepWiki \[ 5 \].  
Our system is also capable of integrating with current  
code agents, allowing them to collaborate in identifying  
the location of the bugs and then resolving them.  
∙Enhancing Trust through Interpretability: The “black  
box” nature of many AI tools is a barrier to enterprise  
adoption. Our method’s transparent reasoning path  
(repository → directory → file) is auditable by  
developers, fostering the trust required for effective  
\`\`\`

\`\`\`  
Natural Language Summarization Enables Multi-Repository Bug Localization by LLMs in Microservice ArchitecturesICSE 2026, April 12, 2026, Rio de Janeiro, Brazil  
\`\`\`  
\`\`\`  
human-AI collaboration in high-stakes environments,  
as discussed by \[15\].  
\`\`\`  
\`\`\`  
Limitations and Future Work. Our study has two primary  
limitations. First, the initial generation of the knowledge  
base is computationally intensive. As detailed in Appen-  
dix D, while the initial construction of the hierarchical NL  
knowledge base is a one-time offline process, it introduces a  
non-negligible computational cost (≈$80 for DNext). In our  
industrial integration, this process is performed after each  
major release rather than after every commit. This scheduling  
choice is motivated by the nature of the generated summaries:  
since they capture the high-level purpose and architectural role  
of files rather than their exact implementation details, rapid  
implementation changes rarely invalidate them. However, as  
projects scale, both the cost and the maintenance scheduling  
algorithm for updating these summaries should be addressed  
in future work to improve efficiency and sustainability.  
Second, our evaluation, while substantial, was conducted  
on a single large-scale industrial Java project. Validating the  
approach on projects in other languages (e.g., Python, Go)  
and architectural patterns (e.g., monolithic architectures) is  
an important next step for assessing generalizability.  
\`\`\`  
\#\# 6 Conclusion

\`\`\`  
Bug localization in modern, multi-repository software sys-  
tems is a critical bottleneck where existing RAG-based tools  
fail due to architectural and context limitations. In this pa-  
per, we introduced a novel framework that reframes this  
challenge as a tractable NL-to-NL reasoning task. By sys-  
tematically engineering source code into a hierarchical NL  
knowledge base and navigating it with a scalable, two-phase  
search, our approach improves upon strong RAG and retrieval  
baselines on a large-scale industrial benchmark. Ultimately,  
this work demonstrates the power of representation engi-  
neering in software engineering. By shifting the paradigm  
from retrieving over raw code to reasoning over a curated,  
human-understandable knowledge base, we open a promising  
new direction for AI-powered developer tools that are more  
scalable, accurate, and trustworthy.  
\`\`\`  
\#\# Acknowledgments

This work was conducted at the R\&D Center of Intellica  
Business Intelligence Consultancy and was supported by  
the Scientific and Technological Research Council of Turkey  
(TÜBİTAK) under the TEYDEB 1501 program (Grant No.  
3240105).  
A generative AI tool (Gemini 2.5 Pro) was used solely to  
assist with grammar and clarity improvements; the authors  
bear full responsibility for the scientific content and integrity  
of this work.

\#\# References

\`\`\`  
\[1\]Moumita Asad, Rafed Muhammad Yasir, Armin Geramirad, and  
Sam Malek. 2025\. Leveraging Large Language Model for In-  
formation Retrieval-based Bug Localization. arXiv preprint  
arXiv:2508.00253 (2025).  
\`\`\`  
\`\`\`  
\[2\]Jianming Chang, Xin Zhou, Lulu Wang, David Lo, and Bixin Li.  
\`\`\`  
2025\. Bridging Bug Localization and Issue Fixing: A Hierarchi-  
cal Localization Framework Leveraging Large Language Models.  
\_arXiv preprint arXiv:2502.15292\_ (2025).  
\[3\]Junkai Chen, Xing Hu, Zhenhao Li, Cuiyun Gao, Xin Xia, and  
David Lo. 2024\. Code search is all you need? improving code  
suggestions with code search. In \_Proceedings of the IEEE/ACM  
46th international conference on software engineering\_. 1–13.  
\[4\]Cursor AI. 2025\. \_Cursor AI\_. https://cursor.sh/ \[Accessed  
2025-09-20\].  
\[5\] DeepWiki Project. 2025\. \_DeepWiki\_. https://deepwiki.org/ \[Ac-  
cessed 2025-09-03\].  
\[6\]Nilesh Dhulshette, Sapan Shah, and Vinay Kulkarni. 2025\. Hi-  
erarchical repository-level code summarization for business ap-  
plications using local llms. In \_2025 IEEE/ACM International  
Workshop on Large Language Models for Code (LLM4Code)\_.  
IEEE, 145–152.  
\[7\]DNext Technology. 2025\. \_DNext Technology: Cloud Native  
Digital Customer Engagement Platform\_. https://www.dnext-  
technology.com/ \[Accessed 2025-09-02\].  
\[8\]Zhangyin Feng, Daya Guo, Duyu Tang, Nan Duan, Xiaocheng  
Feng, Ming Gong, Linjun Shou, Bing Qin, Ting Liu, Daxin Jiang,  
et al.2020. CodeBERT: A Pre-Trained Model for Programming  
and Natural Languages. In \_Findings of the Association for Com-  
putational Linguistics: EMNLP 2020\_. 1536–1547.  
\[9\]GitHub, Inc. and OpenAI. 2021\. \_GitHub Copilot\_. https://github.  
com/features/copilot \[Accessed 2025-09-20\].  
\[10\]Daya Guo, Shuai Lu, Nan Duan, Yanlin Wang, Ming Zhou, and  
Jian Yin. 2022\. UniXcoder: Unified Cross-Modal Pre-training for  
Code Representation. In \_Proceedings of the 60th Annual Meeting  
of the Association for Computational Linguistics (Volume 1:  
Long Papers)\_. 7212–7225.  
\[11\]Daya Guo, Shuo Ren, Shuai Lu, Zhangyin Feng, Duyu Tang,  
Shujie Liu, Long Zhou, Nan Duan, Alexey Svyatkovskiy, Shengyu  
Fu, et al.2020. Graphcodebert: Pre-training code representations  
with data flow. \_arXiv preprint arXiv:2009.08366\_ (2020).  
\[12\]Geert Heyman and Tom Van Cutsem. 2020\. Neural Code Search  
Revisited: Enhancing Code Snippet Retrieval through Natural  
Language Intent. CoRR abs/2008.12193 (2020). \_arXiv preprint  
arXiv:2008.12193\_ (2020).  
\[13\]Sarthak Jain, Aditya Dora, Ka Seng Sam, and Prabhat Singh.  
2024\. Llm agents improve semantic code search. \_arXiv preprint  
arXiv:2408.11058\_ (2024).  
\[14\]Zhonghao Jiang, Xiaoxue Ren, Meng Yan, Wei Jiang, Yong Li,  
and Zhongxin Liu. 2025\. CoSIL: Software Issue Localization via  
LLM-Driven Code Repository Graph Searching. \_arXiv preprint  
arXiv:2503.22424\_ (2025).  
\[15\]Tomek Korbak, Mikita Balesni, Elizabeth Barnes, Yoshua Bengio,  
Joe Benton, Joseph Bloom, Mark Chen, Alan Cooney, Allan  
Dafoe, Anca Dragan, et al.2025. Chain of thought monitorability:  
A new and fragile opportunity for ai safety. \_arXiv preprint  
arXiv:2507.11473\_ (2025).  
\[16\]Haochen Li, Xin Zhou, and Zhiqi Shen. 2024\. Rewriting the code:  
A simple method for large language model augmented code search.  
\_arXiv preprint arXiv:2401.04514\_ (2024).  
\[17\]Wei Liu, Ailun Yu, Daoguang Zan, Bo Shen, Wei Zhang, Haiyan  
Zhao, Zhi Jin, and Qianxiang Wang. 2024\. Graphcoder: Enhancing  
repository-level code completion via code context graph-based  
retrieval and language model. \_arXiv preprint arXiv:2406.\_  
(2024).  
\[18\]Jorge Martinez-Gil. 2024\. Improving source code similarity detec-  
tion through graphcodebert and integration of additional features.  
\_arXiv preprint arXiv:2408.08903\_ (2024).  
\[19\]Amirkia Rafiei Oskooei, Selcan Yukcu, Mehmet Cevheri Bozoglan,  
and Mehmet S Aktas. 2025\. Repository-Level Code Understand-  
ing by LLMs via Hierarchical Summarization: Improving Code  
Search and Bug Localization. In \_International Conference on  
Computational Science and Its Applications\_. Springer, 88–105.  
\[20\]David Sounthiraraj, Jared Hancock, Yassin Kortam, Ashok Jav-  
vaji, Prabhat Singh, and Shaila Shankar. 2025\. Code-Craft: Hier-  
archical Graph-Based Code Summarization for Enhanced Context  
Retrieval. \_arXiv preprint arXiv:2504.08975\_ (2025).  
\[21\]Chia-Yi Su, Aakash Bansal, Yu Huang, Toby Jia-Jun Li, and  
Collin McMillan. 2025\. Context-aware code summary generation.  
\_Journal of Systems and Software\_ (2025), 112580\.  
\[22\]Weisong Sun, Yun Miao, Yuekang Li, Hongyu Zhang, Chunrong  
Fang, Yi Liu, Gelei Deng, Yang Liu, and Zhenyu Chen. 2024\.  
Source code summarization in the era of large language models.

\`\`\`  
ICSE 2026, April 12, 2026, Rio de Janeiro, Brazil Rafiei Oskooei et al.  
\`\`\`  
\`\`\`  
Setup: The target microservice (repository) is opened as  
the root folder in the IDE (VS Code with GitHub Copilot  
/ Cursor). The agent’s context is therefore limited to that  
single repository.  
\`\`\`  
\`\`\`  
Prompt: You are a bug localizer. Given the bug descrip-  
tion below, rank the top-10 files that likely cause the  
bug. Rank them in order of relevance.  
\`\`\`  
Figure 8: Prompt template for file-level bug localization using  
Agentic RAG baselines.

\`\`\`  
Setup: All 46 microservice repositories are opened to-  
gether in a single workspace from their shared root di-  
rectory. This allows the agent to see all folders simulta-  
neously.  
\`\`\`  
\`\`\`  
Prompt: You are a multi-repository bug localizer, se-  
lecting a search space within a large microservice archi-  
tecture. Each microservice is represented as a folder in  
workspace. Given the bug description below, rank the  
top-3 microservices (folders) that likely cause the bug.  
Rank them in order of relevance.  
\`\`\`  
\`\`\`  
Figure 9: Prompt template for multi-repository routing (search  
space selection) using Agentic RAG baselines.  
\`\`\`  
\`\`\`  
arXiv preprint arXiv:2407.07959 (2024).  
\[23\]Weisong Sun, Yiran Zhang, Jie Zhu, Zhihui Wang, Chunrong  
Fang, Yonglong Zhang, Yebo Feng, Jiangping Huang, Xingya  
Wang, Zhi Jin, et al.2025. Commenting Higher-level Code Unit:  
Full Code, Reduced Code, or Hierarchical Code Summarization.  
arXiv preprint arXiv:2503.10737 (2025).  
\[24\]Vali Tawosia, Salwa Alamir, Xiaomo Liu, and Manuela Veloso.  
\`\`\`  
2025\. Meta-RAG on Large Codebases Using Code Summarization.  
\_arXiv preprint arXiv:2508.02611\_ (2025).  
\[25\]Inseok Yeo, Duksan Ryu, and Jongmoon Baik. 2025\. Improving  
LLM-Based Fault Localization with External Memory and Project  
Context. \_arXiv preprint arXiv:2506.03585\_ (2025).  
\[26\]Zhongming Yu, Hejia Zhang, Yujie Zhao, Hanxian Huang, Ma-  
trix Yao, Ke Ding, and Jishen Zhao. 2025\. Orcaloca: An llm  
agent framework for software issue localization. \_arXiv preprint  
arXiv:2502.00350\_ (2025).

\#\# A Commercial Tool Prompting Strategy

To ensure a fair and reproducible comparison against the  
Agentic RAG baselines (GitHub Copilot and Cursor), we  
followed a standardized prompting procedure. Figures 8 and  
9 detail the exact setup and prompt templates used for both  
the multi-repository routing and file-level localization tasks.

\#\# B Version Information

All interactions with the Agentic RAG baselines were con-  
ducted using their respective interactive “Chat” or “Ask”  
modes to ensure the full reasoning capabilities of the under-  
lying models were engaged. The specific versions used in our  
experiments were:  
∙GitHub Copilot: We utilized version v1.104 (release  
date: August 29, 2025\) of the VS Code extension.

\`\`\`  
∙Cursor: We utilized version v1.5 (release date: August  
21, 2025\) of the standalone IDE.  
\`\`\`  
\#\# C Prompt Templates

\`\`\`  
To provide further insight into our methodology, this section  
contains the core prompt templates used for both the offline  
knowledge base generation and the online bug localization  
phases. Figure 10 illustrates the six key prompts that power  
our framework. These templates are simplified for clarity but  
represent the essential structure and inputs provided to the  
LLM at each stage of the process.  
\`\`\`  
\#\# D Cost of Knowledge Base Construction

\`\`\`  
To summarize the entire project and generate the hierarchical  
NL knowledge base, we usedgpt-4.1-mini. The total cost for  
summarizing all repositories was approximately $80 (USD).  
While this is a manageable one-time cost in our industrial  
setting, it highlights the need for future research on scheduling  
algorithms to incrementally update and maintain summaries  
in a cost-efficient manner.  
\`\`\`

\`\`\`  
Natural Language Summarization Enables Multi-Repository Bug Localization by LLMs in Microservice ArchitecturesICSE 2026, April 12, 2026, Rio de Janeiro, Brazil  
\`\`\`  
(a) Repository Summary Generation (b) File Summary Generation (c) Directory Summary Aggregation

\`\`\`  
(d) Multi-Repository Routing (e) Directory-Level Filtering (f) File-Level Ranking  
\`\`\`  
\`\`\`  
Figure 10: Core prompt templates used in our methodology. The top row (a-c) corresponds to the offline Knowledge Base  
generation phase, while the bottom row (d-f) corresponds to the online, inference-time bug localization phase.  
\`\`\`


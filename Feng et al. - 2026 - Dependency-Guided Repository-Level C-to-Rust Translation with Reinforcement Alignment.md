\#\# Dependency-Guided Repository-Level C-to-Rust Translation with

\#\# Reinforcement Alignment

\#\# Jia Feng∗

\#\#\#\# Harbin Institute of Technology

\#\#\#\# Shenzhen, China

\#\#\#\# jiafeng@stu.hit.edu.cn

\#\# Wenjie Gan∗

\#\#\#\# Southeast University

\#\#\#\# Nanjing, China

\#\#\#\# wenjiegan@seu.edu.cn

\#\# Cuiyun Gao†

\#\#\#\# Harbin Institute of Technology

\#\#\#\# Shenzhen, China

\#\#\#\# gaocuiyun@hit.edu.cn

\#\# Chaozheng Wang

\#\#\#\# The Chinese University of Hong Kong

\#\#\#\# Hong Kong, China

\#\#\#\# adf111178@gmail.com

\#\# Feng Luo

\#\#\#\# Harbin Institute of Technology

\#\#\#\# Shenzhen, China

\#\#\#\# hitszluofeng@foxmail.com

\#\# Xin Xia

\#\#\#\# Zhejiang University

\#\#\#\# Hangzhou, China

\#\#\#\# xin.xia@acm.org

\#\# Ge Li

\#\#\#\# Peking University

\#\#\#\# Beijing, China

\#\#\#\# lige@pku.edu.cn

\#\# Kui Liu

\#\#\#\# Huawei

\#\#\#\# Shenzhen, China

\#\#\#\# kui.liu@huawei.com

\#\#\# Abstract

\`\`\`  
Automating C-to-Rust migration is critical for enhancing software  
security without compromising performance. Traditional rule-based  
methods often struggle with diverse C idioms, yielding unidiomatic  
and rigid Rust translations. In contrast, Large Language Models  
(LLMs), enriched by massive code corpora, offer a superior alterna-  
tive due to their cross-language generalization, enabling the gener-  
ation of idiomatic and maintainable Rust code. However, applying  
LLMs to C-to-Rust migration still poses several challenges. First,  
existing LLM-based approaches fail to adequately handle cross-file  
references. They either overlook the dependencies or incorporate  
entire files as context, thereby hindering the model’s ability to ac-  
curately capture dependency information for translation. Second,  
the complex dependencies and structured inputs/outputs make it  
difficult to validate the syntactic correctness and functional equiva-  
lence of repository-level translations. Furthermore, the scarcity of  
large-scale C-Rust parallel data constrains the inherent generation  
capabilities of LLMs, resulting in limited performance.  
To address these challenges, we propose DepTrans, which syn-  
ergizes model-level capability enhancement with a structured infer-  
ence framework. DepTrans first employs the Reinforcement-Aligned  
Syntax Training module to bolster the model’s intrinsic generation  
capabilities through multi-task fine-tuning and feedback-driven  
reinforcement learning. Building upon this enhanced foundation  
\`\`\`  
\`\`\`  
∗Equal contribution.  
†Corresponding author  
\`\`\`  
\`\`\`  
Permission to make digital or hard copies of all or part of this work for personal or  
classroom use is granted without fee provided that copies are not made or distributed  
for profit or commercial advantage and that copies bear this notice and the full citation  
on the first page. Copyrights for components of this work owned by others than the  
author(s) must be honored. Abstracting with credit is permitted. To copy otherwise, or  
republish, to post on servers or to redistribute to lists, requires prior specific permission  
and/or a fee. Request permissions from permissions@acm.org.  
FSE Companion ’26, Montreal, QC, Canada  
© 2026 Copyright held by the owner/author(s). Publication rights licensed to ACM.  
ACM ISBN 978-x-xxxx-xxxx-x/YYYY/MM  
https://doi.org/10.1145/3803437.  
\`\`\`  
\`\`\`  
model, the Dependency-Guided Iterative Refinement module iden-  
tifies the fine-grained cross-file dependencies as enriched context  
for the initial translation, and further iteratively refines the gener-  
ated Rust code to ensure the syntactic correctness and functional  
equivalence. To facilitate the model training and repository-level  
evaluation, we construct a large-scale corpus of 85k training sam-  
ples and a specialized benchmark of 145 repository-level instances.  
Experimental results show that DepTrans achieves a compilation  
success rate of 60.7% and a computational accuracy of 43.5%, out-  
performing the strongest baseline by 22.8% and 17.3%, respectively.  
Moreover, DepTrans successfully builds 7 out of 15 industrial-scale  
C projects from Huawei’s internal codebase, demonstrating its po-  
tential in enterprise-level C-to-Rust migration.  
\`\`\`  
\#\#\# Keywords

\`\`\`  
C-to-Rust Translation, Dependency-Guided, Reinforcement Learn-  
ing, Large Language Models  
\`\`\`  
\`\`\`  
ACM Reference Format:  
Jia Feng, Wenjie Gan, Cuiyun Gao, Chaozheng Wang, Feng Luo, Xin Xia,  
Ge Li, and Kui Liu. 2026\. Dependency-Guided Repository-Level C-to-Rust  
Translation with Reinforcement Alignment. In 34th ACM Joint European  
Software Engineering Conference and Symposium on the Foundations of Soft-  
ware Engineering (FSE Companion ’26), July 5–9, 2026, Montreal, QC, Canada.  
ACM, New York, NY, USA, 12 pages. https://doi.org/10.1145/3803437.  
\`\`\`  
\#\#\# 1 Introduction

\`\`\`  
System-level development demands a rigorous balance between  
performance and memory safety \[ 7 \]. While C provides the neces-  
sary low-level control, its inherent lack of memory safety remains a  
primary source of critical vulnerabilities \[ 32 \]. Rust has emerged as  
a compelling alternative, offering C-equivalent performance while  
enforcing memory safety via its static ownership system \[ 1 , 26 \].  
Consequently, migrating legacy C codebases to Rust is now a strate-  
gic priority for enhancing software security \[ 8 , 25 \]. However, the  
\`\`\`  
\# arXiv:2604.02852v1 \[cs.SE\] 3 Apr 2026

\`\`\`  
FSE Companion ’26, July 5–9, 2026, Montreal, QC, Canada Jia Feng, Wenjie Gan, Cuiyun Gao, Chaozheng Wang, Feng Luo, Xin Xia, Ge Li, and Kui Liu  
\`\`\`  
manual migration process is prohibitively labor-intensive and error-  
prone, necessitating the development of robust, automated C-to-  
Rust translation solutions \[28\].  
In recent years, tools like C2Rust \[ 22 \] have automated C-to-Rust  
migration by mapping C syntax to Rust constructs. However, these  
rule-based methods often produce Rust code that retains C-style de-  
sign \[ 19 \], such as raw pointers and unsafe blocks \[ 14 , 18 \]. Although  
the output is typically compilable, it is frequently unidiomatic \[ 13 \],  
requiring developers to invest manual efforts in post-translation  
refactoring. With the rapid development of large language models  
(LLMs), they have demonstrated impressive performance in various  
code-related tasks \[ 20 , 29 , 39 , 47 \]. Previous studies \[ 31 , 42 , 48 \] have  
shown that compared to rule-based tools such as C2Rust, LLMs  
offer clear advantages in producing Rust code that better aligns  
with the idiomatic practices of the language, significantly reduc-  
ing the manual refactoring \[ 5 , 33 , 48 \]. Despite the effectiveness of  
LLMs, existing LLM-based approaches also face critical challenges.  
First, LLMs frequently struggle with the fine-grained dependencies  
of large-scale repositories, leading to fragmented and inconsistent  
translations \[ 11 , 27 , 45 \]. Simply translating functions in isolation  
or cramming entire files into the prompt typically yields subopti-  
mal results, as the model fails to maintain a coherent global view  
across file boundaries, resulting in broken references and incon-  
sistent program logic \[ 34 , 40 \]. Second, the complex dependencies  
and structured inputs/outputs of repository-level software make it  
exceptionally difficult to validate syntactic correctness and func-  
tional equivalence. The reliance on intricate data structures defined  
across multiple modules hinders the generation of standalone test  
cases, thereby depriving the model of the high-quality diagnos-  
tic feedback—such as compiler diagnostics or execution traces—  
essential for driving effective iterative self-refinement \[ 12 , 37 , 43 \].  
Finally, the scarcity of parallel C-Rust repositories in training cor-  
pora hinders models from learning the complex mappings required  
for cross-file coherence. Without sufficient exposure to diverse  
repository-level patterns, LLMs frequently generate code with un-  
resolved references or fragmented logic. This lack of architectural  
awareness leads to significantly degraded compilation success rates  
and functional accuracy in large-scale migrations \[4, 27, 30\].  
To address these challenges, we propose DepTrans, a dependency-  
guided approach for repository-level C-to-Rust translation. The core  
of DepTrans lies in its synergy between model-level capability  
enhancement and a structured inference framework. First, we intro-  
duce Reinforcement-Aligned Syntax Training (RAST) to bolster the  
model’s intrinsic dependency awareness and task-specific adapta-  
tion. This two-stage scheme employs multi-task fine-tuning to cap-  
ture distant structural correlations, followed by compiler-feedback  
reinforcement learning to further enforce syntactic correctness and  
functional equivalence. By optimizing the model’s fundamental  
translation and repair capabilities, RAST provides a robust founda-  
tion for handling complex repository structures. Second, building  
upon the enhanced model, we develop a Dependency-Guided Itera-  
tive Refinement (DGIR) framework to orchestrate the translation  
process. This involves a Cross-Language Dependency Alignment  
strategy that decomposes C projects into manageable units and  
performs incremental, bottom-up translation following topological  
orders. By mapping extracted C dependencies to a semantically  
aligned Rust dependency pool, the framework provides precise,

\`\`\`  
fine-grained context. Furthermore, a Consistency-Guided Refinement  
strategy iteratively optimizes the translation by integrating com-  
piler diagnostics with LLM-based self-consistency checks, ensuring  
the output is both syntactically valid and functionally aligned.  
To facilitate both training and evaluation, we construct a large-  
scale corpus of 85k instances, comprising 82.5k instances for multi-  
task fine-tuning and 2.5k high-quality instances for reinforcement  
learning. For evaluation, we curate a specialized benchmark of  
145 repository-level instances with complex cross-file dependen-  
cies to rigorously assess contextual reasoning. Experimental re-  
sults demonstrate that even without RAST’s task-specific adapta-  
tion, DGIR alone enables Qwen2.5-Coder-32B to achieve a 57.2%  
compilation success rate and 41.4% computational accuracy, out-  
performing the strongest baseline by 19.3 and 15.2 percentage  
points, respectively. Remarkably, after applying our RAST, a smaller  
Qwen2.5-Coder-7B reaches 60.7% compilation success and 43.5%  
accuracy, surpassing the untrained 32B model. Finally, validation on  
15 industrial-scale projects from Huawei’s database system shows  
that our model successfully migrates 7 projects to a buildable state,  
demonstrating the potential of DepTrans for enterprise-level C-to-  
Rust migration.  
The main contributions of this paper are as follows.  
1)We introduce a two-stage training paradigm combining multi-  
task fine-tuning with compiler-feedback reinforcement learn-  
ing, enhancing the model’s cross-file dependency awareness  
and task-specific adaptation.  
2)We propose a dependency-guided framework that integrates  
fine-grained dependency with consistency-driven iterative  
refinement to ensure syntactic and functional correctness in  
repository-level translation.  
3)We construct a large-scale corpus of 85k training samples  
and a dependency-intensive benchmark of 145 repository-  
level samples, providing a foundation for both training and  
evaluating C-to-Rust translation.  
4)Extensive experiments demonstrate our approach’s effective-  
ness in dependency comprehension and its practical poten-  
tial for enterprise-level migration.  
Our source code and experimental data are publicly available at  
https://github.com/2726f j/C2RustRep.  
\`\`\`  
\#\#\# 2 Methodology

\`\`\`  
This section details the architecture of DepTrans, which inte-  
grates model-level training with a structured inference framework.  
We first present the Reinforcement-Aligned Syntax Training in Sec-  
tion 2.1, designed to bolster the model’s intrinsic dependency aware-  
ness and self-correction capabilities. Building upon this foundation,  
Section 2.2 introduces the Dependency-Guided Iterative Refinement  
framework, which serves as the inference engine to orchestrate  
repository-level translation and compiler-driven refinement.  
\`\`\`  
\#\#\# 2.1 Reinforcement-Aligned Syntax Training

\`\`\`  
While the inference framework provides structural guidance, the  
model’s intrinsic ability to handle repository-level nuances often  
\`\`\`

\`\`\`  
Dependency-Guided Repository-Level C-to-Rust Translation with Reinforcement Alignment FSE Companion ’26, July 5–9, 2026, Montreal, QC, Canada  
\`\`\`  
\`\`\`  
Test  
\`\`\`  
\`\`\`  
Rust  
Compiler  
\`\`\`  
\`\`\`  
Unit  
Tests  
\`\`\`  
\`\`\`  
Reward Calculation  
𝑅𝑐𝑜𝑚𝑝 𝑅𝑎𝑙𝑖𝑔𝑛  
(Compilation  
Reward)  
\`\`\`  
\`\`\`  
(Alignment  
Reward)  
\`\`\`  
\`\`\`  
GRPO Loss  
\`\`\`  
\`\`\`  
Generated  
Rust Code  
\`\`\`  
\`\`\`  
Reference  
Model  
\`\`\`  
\`\`\`  
Base  
Model  
\`\`\`  
\`\`\`  
KL Divergence  
\`\`\`  
\`\`\`  
(A) Reinforcement-Aligned Syntax Training (RAST)  
\`\`\`  
\`\`\`  
Frozen Model  
\`\`\`  
\`\`\`  
Trained Model  
\`\`\`  
\`\`\`  
Update  
\`\`\`  
\`\`\`  
TRANS  
Dataset  
CHECK  
Dataset  
REPAIR  
Dataset  
\`\`\`  
\#\# .

\`\`\`  
Policy  
Model  
\`\`\`  
\`\`\`  
(B) Dependency-Guided Iterative Refinement (DGIR)  
\`\`\`  
\`\`\`  
C Repo  
\`\`\`  
\`\`\`  
Call Graph  
Analysis  
\`\`\`  
\`\`\`  
Rust Units  
\`\`\`  
\`\`\`  
Semantic Mapping  
& Dependency  
Alignment  
\`\`\`  
\`\`\`  
Aligned Context &  
Dependencies  
\`\`\`  
\`\`\`  
Generate  
Rust Code  
\`\`\`  
\`\`\`  
Compile  
Check Compilation  
Error？  
Compile Repair Yes  
error message and context  
Consistency  
Check  
\`\`\`  
\`\`\`  
No  
ConsistencyRepair Yes Inconsistent？  
\`\`\`  
\`\`\`  
Rust Code  
\`\`\`  
\`\`\`  
No  
\`\`\`  
\`\`\`  
Build Input  
\`\`\`  
\`\`\`  
inconsistent description  
\`\`\`  
\`\`\`  
Rust Repo  
\`\`\`  
\`\`\`  
Multi-Task Loss ModelMFT  
\`\`\`  
\`\`\`  
Initial  
Policy  
\`\`\`  
\`\`\`  
Weight  
InitializationRAST  
\`\`\`  
\- 7B

\`\`\`  
Figure 1: Overview of DepTrans.  
\`\`\`  
remains a bottleneck. LLMs frequently struggle with cross-file struc-  
tural dependencies and lack a specialized “translation-detection-  
repair” synergy. To bridge this gap, we propose Reinforcement-  
Aligned Syntax Training (RAST), a two-stage paradigm designed  
to bolster the model’s fundamental awareness of global repository  
logic and its adaptive capacity for the migration task, as shown in  
Figure 1 (part A).

\`\`\`  
2.1.1 Multi-Task Fine-Tuning. While the inference framework pro-  
vides structural guidance, the model’s intrinsic ability to handle  
repository-level nuances often remains a bottleneck. LLMs fre-  
quently struggle with cross-file structural dependencies and lack a  
specialized synergy between translation, detection, and repair. To  
bridge this gap, we formulate the initial training stage as a multi-  
task learning problem. This approach forces the model to internalize  
the relationship between C logic and Rust syntax while developing  
an acute sensitivity to migration pitfalls.  
Specifically, the model simultaneously learns three interlinked  
tasks: (1) C-to-Rust Translation, where the model generates seman-  
tically equivalent Rust code given a C source and its dependency  
context; (2) Syntax Error Detection, where the model assesses Rust  
code integrity and provides diagnostic feedback; and (3) Code Re-  
pair, where the model corrects erroneous Rust snippets based on  
error descriptions. To enable task-specific adaptation, each train-  
ing sample is prepended with a distinct\[TaskTag\]. We employ a  
unified autoregressive language modeling objective:  
\`\`\`  
\#\#\#\#\# LMTL=−

\#\#\#\#\# ∑︁𝑇

\`\`\`  
𝑖= 1  
\`\`\`  
\`\`\`  
log𝑃𝜃(𝑦𝑖| 𝑦\<𝑖,𝑥, \[TaskTag\]) (1)  
\`\`\`  
where𝑥is the input prompt,𝑦is the target output sequence, and  
𝜃is the model parameters. By jointly optimizing these objectives,  
the model acquires the requisite “inner logic” to effectively power  
the Dependency-Guided Iterative Refinement framework, as detailed  
in Section 2.2. This synergistic training transforms the model from  
a passive generator into an active, self-correcting agent capable of  
autonomous architectural reasoning.

\`\`\`  
2.1.2 Compiler-Feedback Reinforcement Learning. While multi-  
task fine-tuning establishes a foundational mapping, the maximum  
likelihood objective often prioritizes token-level probability over  
the rigorous, binary requirements of a compiler. To bridge the gap  
between "plausible" and "executable" code, we introduce a rein-  
forcement learning stage using Group Relative Policy Optimization  
(GRPO) \[ 15 \]. This stage aligns the model with the strict type sys-  
tem of Rust by treating the compiler and test suite as an interactive  
environment for policy optimization.  
\`\`\`  
\`\`\`  
Optimization Objective. For each question𝑞, GRPO samples a  
group of outputs{𝑜 1 ,𝑜 2 ,.. .,𝑜𝐺}from the old policy𝜋𝜃𝑜𝑙𝑑and opti-  
mizes the policy model 𝜋𝜃by maximizing the following objective:  
\`\`\`  
\#\#\#\#\# J𝐺𝑅𝑃𝑂(𝜃)=E

\`\`\`  
h  
𝑞 ∼ 𝑃(𝑄),{𝑜𝑖}𝐺𝑖= 1 ∼ 𝜋𝜃𝑜𝑙𝑑(𝑂|𝑞)  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\#\#\#\#\# 1

\#\#\#\#\# 𝐺

\#\#\#\#\# ∑︁𝐺

\`\`\`  
𝑖= 1  
\`\`\`  
\#\#\#\#\#

\`\`\`  
min  
\`\`\`  
\#\#\#\#\#

\#\#\#\#\# 𝜋𝜃(𝑜𝑖|𝑞)

\#\#\#\#\# 𝜋𝜃𝑜𝑙𝑑(𝑜𝑖|𝑞)

\`\`\`  
𝐴𝑖, clip  
\`\`\`  
\#\#\#\#\#

\#\#\#\#\# 𝜋𝜃(𝑜𝑖|𝑞)

\#\#\#\#\# 𝜋𝜃𝑜𝑙𝑑(𝑜𝑖|𝑞)

\#\#\#\#\# , 1 − 𝜀, 1 \+ 𝜀

\#\#\#\#\#

\#\#\#\#\# 𝐴𝑖

\#\#\#\#\#

\#\#\#\#\# − 𝛽D𝐾𝐿(𝜋𝜃||𝜋𝑟𝑒𝑓)

\#\#\#\#\#

\#\#\#\#\# (2)

\`\`\`  
where the advantage𝐴𝑖is computed by normalizing the rewards  
within each group to emphasize relative quality, thereby eliminating  
the need for a separate value network:  
\`\`\`  
\`\`\`  
𝐴𝑖=  
\`\`\`  
\`\`\`  
𝑟𝑖− mean({𝑟 1 ,𝑟 2 ,.. .,𝑟𝐺})  
std({𝑟 1 ,𝑟 2 ,.. .,𝑟𝐺})  
\`\`\`  
\#\#\#\#\# (3)

\`\`\`  
The KL divergence term is efficiently estimated as:  
\`\`\`  
\`\`\`  
D𝐾𝐿(𝜋𝜃||𝜋𝑟𝑒𝑓)=  
\`\`\`  
\#\#\#\#\# 𝜋𝑟𝑒𝑓(𝑜𝑖|𝑞)

\#\#\#\#\# 𝜋𝜃(𝑜𝑖|𝑞)

\`\`\`  
− log  
\`\`\`  
\#\#\#\#\# 𝜋𝑟𝑒𝑓(𝑜𝑖|𝑞)

\#\#\#\#\# 𝜋𝜃(𝑜𝑖|𝑞)

\#\#\#\#\# − 1 (4)

\`\`\`  
where𝜋𝑟𝑒𝑓is the SFT-tuned reference policy. This objective en-  
sures training stability by preventing the policy from deviating  
excessively from the reference.  
\`\`\`  
\`\`\`  
Reward Design. To reinforce both syntactic and semantic in-  
tegrity, we design a hybrid reward function𝑅(𝑎)= 𝛼𝑅comp+  
𝛽𝑅align.  
\`\`\`

FSE Companion ’26, July 5–9, 2026, Montreal, QC, Canada Jia Feng, Wenjie Gan, Cuiyun Gao, Chaozheng Wang, Feng Luo, Xin Xia, Ge Li, and Kui Liu

\- Syntactic Validity (𝑅comp): To penalize invalid syntax, we  
    define𝑅comp= 1 \+𝑁^1 err, where𝑁erris the count of diagnos-  
    tic errors from the Rust compiler. This forces the model to  
    prioritize compilability.  
\- Functional Alignment (𝑅align): For function-level samples  
    with test cases,𝑅alignis the pass rate of the unit tests. For  
    repository-level samples where execution is infeasible,𝑅align  
    is the CodeBLEU score against the reference, which ensures  
    structural and data-flow consistency in complex migration  
    scenarios.  
Guided by the need for computational efficiency, we implement  
the RAST paradigm on Qwen2.5-Coder-7B \[ 21 \]. By assigning bal-  
anced reward weights (𝛼= 1 ,𝛽= 1 ), we prioritize syntactic and  
functional integrity equally, demonstrating that RAST can elicit  
expert-level capabilities even from smaller-scale models. We de-  
note this optimized version as RAST-7B, an efficient engine for  
repository-level translation. The sensitivity of reward weights is  
further discussed in Section 5.2.2.

\#\#\# 2.2 Dependency-Guided Iterative Refinement

To address the complexities of repository-scale migration, we de-  
sign the Dependency-Guided Iterative Refinement (DGIR) framework  
as the core inference engine of DepTrans. As illustrated in Figure 1  
(part B), the framework operates through two synergistic modules:  
First, the Cross-Language Dependency Alignment Module ensures  
structural consistency by performing an incremental, bottom-up  
translation following the topological order of dependencies. It ex-  
tracts precise context from both C call graphs and a categorized  
Rust dependency pool to guide the LLM’s initial generation. Second,  
the Consistency-Guided Translation Refinement Module capitalizes  
on the LLM’s self-refinement potential. It utilizes the aligned depen-  
dencies alongside compiler diagnostics and self-consistency checks  
to iteratively repair errors, ensuring that the final output achieves  
high syntactic validity even in the absence of extensive test suites.  
Each component is described in detail in the following sections.

2.2.1 Cross-Language Dependency Alignment. Repository-level trans-  
lation is hindered by the fragmentation of semantic context across  
file boundaries. Without explicit dependency modeling, LLMs of-  
ten generate code that references undefined symbols or violates  
target-language module structures. To mitigate this, we propose  
a Cross-Language Dependency Alignment module that bridges the  
semantic gap between the source C repository and the target Rust  
environment through three steps.

1\. Dependency Graph Construction in C. To determine the  
optimal translation sequence and capture the logical scope of each  
function, we first model the structural dependencies of the C project.  
Using Tree-Sitter \[ 2 \], we construct a global call graph by travers-  
ing all source files and mapping inter-function relationships. The  
motivation behind this graph is twofold: it allows us to identify  
the topological order for incremental bottom-up translation, and  
it enables the extraction of a comprehensive dependency set for  
each function. This set includes not only invoked functions but also  
critical global context such as headers, global variables, structs, and  
macro definitions.  
2\. Categorized Dependency Pooling in Rust. While C de-  
pendencies provide the "requirement," the target Rust environment

\`\`\`  
provides the "available resources." To facilitate precise mapping,  
we build a structured Rust-side dependency pool by extracting and  
categorizing elements into ten syntactic types, includingstruct,  
enum,function, andtrait. Critically, for types such asstruct  
andtrait, we explicitly link their associatedimplblocks. This  
categorization is essential because Rust’s modularity and method  
implementation patterns differ significantly from C’s procedural  
structure, requiring a more granular organization of target-side  
assets.  
\`\`\`  
3\. Semantic Alignment and Augmentation. The final step  
is to resolve the cross-language mapping between C requirements  
and Rust implementations. We employ BGE-M3 \[ 6 \] to vectorize  
all Rust structures, leveraging its superior cross-lingual semantic  
representation to overcome syntactic divergence. For each C de-  
pendency, we perform a cosine similarity-based retrieval from the  
Rust pool to find its semantically equivalent counterpart. To ensure  
semantic completeness, if a retrieved Rust function resides within  
animplblock, we automatically augment the context with the cor-  
responding parent structure. This look-ahead mechanism prevents  
the generation of "orphaned" methods and ensures that the LLM  
receives a logically complete context for translation.

\`\`\`  
2.2.2 Consistency-Guided Translation Refinement. Direct LLM trans-  
lation at the repository level often produces "hallucinated" syntax or  
logic shifts that violate cross-file invariants. To bridge this gap, we  
propose a two-stage refinement module designed to maximize the  
LLM’s self-refinement potential. By providing structured contextual  
grounding and multi-dimensional feedback, the module empowers  
the model to iteratively identify and rectify its own translation  
errors.  
\`\`\`  
1\. Dependency-Aware Context Construction. To provide  
the necessary "knowledge base" for effective self-refinement, we  
transform aligned dependencies into a granularity-adaptive prompt.  
Following the topological order from Section 2.2.1, we process func-  
tional units incrementally. To avoid distracting the model with ex-  
cessive noise, large structural dependencies (e.g., extensive structs)  
are abstracted into concise docstrings, while smaller, pivotal code  
segments are provided verbatim. Furthermore, the LLM is prompted  
to generate a cross-language bridge docstring that maps C logic  
to Rust-idiomatic intent. This hybrid context ensures the model  
has a clear semantic blueprint to guide its initial generation and  
subsequent refinement iterations.  
2\. Iterative Repair via Multi-Dimensional Feedback. Rec-  
ognizing that LLMs perform best when given explicit "hints" about  
their mistakes, we implement a feedback-driven repair loop that  
acts as the primary engine for self-refinement.  
\- Diagnostic-Driven Repair: Upon compilation, hardware-level  
syntax or type errors are fed back to the LLM. This provides  
a precise corrective signal, allowing the model to refine the  
Rust code until it satisfies the rigorous constraints of the  
Rust compiler.  
\- Consistency-Guided Verification: In the absence of executable  
test suites, we utilize semantic consistency checks \[ 41 \] to  
provide a high-level refinement signal. By acting as a dual-  
language auditor, the LLM compares the C source with its  
Rust translation to uncover logical discrepancies. These iden-  
tified mismatches serve as a heuristic guide for self-correction,

\`\`\`  
Dependency-Guided Repository-Level C-to-Rust Translation with Reinforcement Alignment FSE Companion ’26, July 5–9, 2026, Montreal, QC, Canada  
\`\`\`  
\`\`\`  
enabling the model to iteratively align the functional behav-  
ior of the two languages without requiring external test  
oracles.  
\`\`\`  
\#\#\# 3 Training and Evaluation Data Construction

\`\`\`  
To address the data scarcity issue and bolster the inherent genera-  
tion capabilities of LLMs, we curated a multi-granularity dataset for  
C-to-Rust migration, including the repository-level and function-  
level corpora.  
\`\`\`  
\#\#\# 3.1 Repository-Level Dataset Construction

To capture authentic cross-file dependencies, we curate a high-  
quality repository-level dataset through a three-phase pipeline,  
focusing on real-world migration logic.  
Phase 1: Project Selection and Structural Parsing. We iden-  
tify candidate repository pairs by searching GitHub for keywords  
such as “migration,” “rewrite,” and “C to Rust.” We specifically  
select projects where both versions are maintained by the same  
organization to ensure functional alignment. Following common  
practice \[ 27 \], we filter for projects with\> 10 stars and verified  
buildability. Beyond file parsing, we use Tree-Sitter \[ 2 \] and call  
graph analysis to retain only functions with active cross-function  
dependencies, ensuring the dataset captures true repository-level  
complexity.  
Phase 2: Hybrid Semantic Alignment. To identify equiva-  
lent functions, we employ a three-step filtering process: (1) Coarse  
Retrieval: We utilize BGE-M3 \[ 6 \], a widely-used model for cross-  
lingual code retrieval, to efficiently retrieve top candidates via co-  
sine similarity. (2) Model-based Re-ranking: We leverage Qwen2.5-  
Coder-32B to perform semantic verification, exploiting its reason-  
ing capabilities to filter out false positives. (3) Manual Audit: The  
first and second authors conduct a final review of the aligned pairs  
within the full repository context to resolve any subtle discrepancies  
and ensure high-fidelity ground truth.  
Phase 3: Test-based Coverage Identification. To determine  
which functions are verifiable via execution, we employ a straight-  
forward function-level deletion strategy. For each Rust function,  
we temporarily remove its body and executecargo test. If this  
leads to a test failure, we interpret it as a definitive signal that the  
function’s logic is covered by the existing test suite, marking it as a  
“test-verifiable” sample.

\#\#\# 3.2 Function-Level Dataset Construction

To overcome the scarcity of parallel repositories, we construct a  
large-scale synthetic dataset to bolster the model’s fundamental  
translation and self-correction capabilities.  
Phase 1: Seed Selection and Diversity Filtering. We utilize  
xCodeEval \[ 23 \] as our primary source, as it provides a vast collec-  
tion of C functions with associated test cases. We filter for functions  
with token counts between 64 and 2,048 to exclude trivial boiler-  
plate code while ensuring samples fit within standard LLM context  
windows. Inspired by prior work on data deduplication \[ 3 \], we en-  
sure semantic diversity by generating embeddings with BGE-M3 \[ 6 \]  
and applying𝐾-means clustering. This process allows us to sample  
representative functions across diverse C idioms, preventing the  
model from over-fitting on repetitive logic patterns.

\`\`\`  
Table 1: Statistical summary of the datasets across different  
stages. "Max", "Min", and "Average" refer to the maximum,  
minimum and average token counts per sample, respectively.  
\`\`\`  
\`\`\`  
Type Dataset Name \#Samples Max Min Average  
Multi-task Fine-tuning  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
SyntaxCheck 32,066 1,030 66 182  
CodeTrans 32,066 1,030 66 182  
CodeFix 18,743 1,033 80 242  
Reinforcement Learning  
Function FucnTrans 2,370 1,921 30 305  
Repository RepoTrans 310 1,717 16 257  
Evaluation  
\`\`\`  
\`\`\`  
Repository  
\`\`\`  
\`\`\`  
DCBench 125 4,769 31 316  
IMCBench 20 453 31 157  
\`\`\`  
\`\`\`  
Phase 2: Compiler-Guided Synthesis. To obtain high-quality  
C-Rust pairs, we employ an automated translation-and-refinement  
pipeline. Each C function is initially translated by an LLM, followed  
by an iterative optimization process guided strictly by Rust compiler  
diagnostics. This strategy ensures that the ground-truth authority  
rests on the rigorous compiler rather than the generative model,  
resulting in syntactically valid and idiomatic Rust counterparts.  
Phase 3: Multi-Task Label Generation. Based on the syn-  
thesis trajectories, we derive labels for three synergistic tasks: (1)  
Translation, using successfully compiled C-Rust pairs as ground  
truth; (2) Detection, using both successful and failed attempts to  
train the model on error identification; and (3) Repair, using the  
logs of the refinement process to provide realistic error-correction  
trajectories for supervised fine-tuning.  
\`\`\`  
\#\#\# 3.3 Dataset Statistics

\`\`\`  
Following the construction pipelines detailed in Section 3.1 and  
Section 3.2, we curate a multi-stage dataset to support RAST and  
rigorous evaluation. Table 1 provides a comprehensive breakdown  
of the sample counts and token distributions.  
Multi-task Fine-tuning Dataset. To equip the model with fun-  
damental translation and self-repair capabilities, we construct three  
specialized tasks under the function-level category: (1) CodeTrans  
for C-to-Rust translation, (2) SyntaxCheck for error detection and  
analysis, and (3) CodeFix for iterative code repair. These tasks, to-  
taling over 82k samples, provide a balanced coverage of syntactic  
and functional patterns required for cross-language migration.  
Reinforcement Learning Dataset. To further align the model  
with compilation and functional requirements, we utilize a hybrid  
RL dataset. This includes 2,370 function-level samples (Function)  
and 310 repository-level samples (Repository). The latter specifi-  
cally incorporates cross-file dependencies to bolster the model’s  
ability to navigate architectural constraints during the alignment  
process.  
Evaluation Benchmarks. For a robust assessment of repository-  
level migration, we establish two benchmarks under the Repository  
category derived from parallel C/Rust projects. DCBench, sourced  
\`\`\`

\`\`\`  
FSE Companion ’26, July 5–9, 2026, Montreal, QC, Canada Jia Feng, Wenjie Gan, Cuiyun Gao, Chaozheng Wang, Feng Luo, Xin Xia, Ge Li, and Kui Liu  
\`\`\`  
\`\`\`  
from the deltachat-core repository, comprises 125 samples with an  
average of 316 tokens. Its complex dependencies and 175-file scale  
provide a highly challenging testbed for contextual reasoning. In  
contrast, IMCBench, derived from incubator-milagro-crypto, con-  
tains 20 samples from a 121-file codebase, serving as an additional  
setting to evaluate basic dependency handling.  
\`\`\`  
\#\#\# 4 Experimental setup

\#\#\# 4.1 Selected LCMs

We evaluate our framework across two state-of-the-art Large Code  
Model families. DeepSeek-Coder (DSC) \[ 16 \] represents a LLaMA-  
based decoder-only architecture, for which we select the 6.7B and  
33B instruction-tuned variants. Qwen2.5-Coder (QWC) \[ 21 \] provides  
extensive long-context support (128K tokens), and we utilize its  
7B, 14B, and 32B versions. This diverse configuration allows for  
a comprehensive analysis of how model scale and architectural  
capabilities influence syntactic validity and semantic fidelity in  
complex C-to-Rust migration.

\#\#\# 4.2 Research Questions

\`\`\`  
In this work, we conduct comprehensive experiments to answer  
the following research questions:  
\`\`\`  
\- RQ1: How does DepTrans perform in C-to-Rust transla-  
    tion when faced with intricate, repository-level dependency  
    structures?  
\- RQ2: How do the individual components of the DGIR frame-  
    work and the reward configurations of RAST-7B contribute  
    to the overall migration quality?  
\- RQ3: Can DepTrans effectively handle real-world, large-  
    scale industrial projects with stringent reliability require-  
    ments?  
To address RQ1, we evaluate both our DGIR and RAST-7B on  
DCBench and IMCBench, which feature varying degrees of rich,  
cross-file dependencies ranging from standalone modules to intri-  
cate architectures. To answer RQ2, we perform a series of ablation  
studies, systematically decoupling the DGIR’s components and  
varying the RAST reward signals to quantify their respective im-  
pacts on syntactic and semantic performance. For RQ3, we assess  
the practical utility of DepTrans on HWBench, a benchmark com-  
prising 15 industrial C projects from Huawei’s database systems.  
With codebases ranging from 1,000 to 3,000 lines.

\#\#\# 4.3 Compared Methods

4.3.1 Baselines in RQ1. We compare DGIR with three baselines  
to evaluate the effectiveness of context capture and utilization: (1)  
Base, which translates C to Rust without auxiliary context; (2) RAG,  
which uses retrieval-augmented generation via fine-tuned BGE-M  
(𝑘= 1 , 3 , 5 ); and (3) File Context, which provides the complete C/Rust  
file pairs (excluding target functions) as input. By focusing on these  
baselines, we isolate the impact of structured dependency guidance  
from raw or retrieved context. This setup is chosen because exist-  
ing C-to-Rust tools are primarily designed for function-level tasks  
and lack the architectural capacity to handle the repository-scale  
dependencies our framework addresses. To evaluate model-level en-  
hancements, we compare RAST-7B with baseline models of varying

\`\`\`  
scales. All candidates are integrated into the same DGIR framework  
to isolate the impact of our RAST paradigm from inference-level  
optimizations, thereby ensuring a controlled and fair assessment of  
the model’s intrinsic migration capabilities.  
4.3.2 Ablation Studies for RQ2. To quantify the individual contribu-  
tion of each component within DGIR, we evaluate four variants: (1)  
Plain Deps, which provides raw dependencies without fine-grained  
structure rewriting or import recovery; (2) w/o Compile, which dis-  
ables compiler-guided repair; (3) w/o Consistency, which removes  
semantic consistency checking; and (4) w/o Repair, which disables  
all iterative refinement. This systematic ablation allows us to disen-  
tangle the performance gains attributed to structured dependency  
modeling versus iterative self-correction. For RAST-7B, we investi-  
gate the impact of different reward weighting strategies by varying  
the ratio𝛼:𝛽: Comp-Only (1:0), focusing exclusively on syntactic  
validity; Align-Only (0:1), prioritizing functional consistency; Bal-  
anced (1:1), our default setting treating both signals equally; and  
Align-Heavy (1:2), which emphasizes semantic correctness.  
\`\`\`  
\`\`\`  
4.3.3 Evaluation for RQ3. To evaluate practical effectiveness in  
real-world scenarios, we compare DepTrans against two project-  
level strategies: (1) Base, which translates all C files simultaneously  
following previous work’s setting \[ 24 \]; and (2) Sactor \[ 48 \], a two-  
stage pipeline combining C2Rust \[ 22 \] static translation with LLM-  
based refinement. This comparison demonstrates that DepTrans’s  
integrated dependency modeling handles complex module rela-  
tionships more effectively than naive global prompting or rigid  
multi-stage pipelines.  
\`\`\`  
\#\#\# 4.4 Performance Metrics

\`\`\`  
We adopt three metrics: (1) Compilation Success Rate (CSR) \[ 31 \],  
the proportion of compilable translations; (2) Computational Ac-  
curacy (CA) \[ 31 , 44 \], functional equivalence with reference out-  
puts; and (3) CodeBLEU \[ 35 \], structural and lexical similarity to  
reference Rust code. For HWBench, we report Num Build \[ 24 \]  
(projects compiled), since these industrial projects lack Rust test  
cases.  
\`\`\`  
\#\#\# 4.5 Implementation Details

\`\`\`  
Experiments are run on four NVIDIA A100 (40GB) GPUs. For multi-  
task fine-tuning, we use a learning rate of1e-4with cosine decay;  
for reinforcement alignment,5e-5. The per-device batch size is 2  
with gradient accumulation of 8, and all models are trained for 3  
epochs. We apply sequence packing, gradient checkpointing, and  
LoRA (𝑟= 16 , scaling=32, dropout=0.1) for efficiency, and adopt  
ZeRO-3 in DeepSpeed for memory optimization. Inference uses  
greedy decoding withtemperature=0,top\_p=1, and a maximum  
of 4096 tokens.  
\`\`\`  
\#\#\# 5 Evaluation Result

\#\#\# 5.1 RQ1: Effectiveness Evaluation

\`\`\`  
5.1.1 Effectiveness of DGIR in C-to-Rust Translation. We evaluate  
the effectiveness of DGIR on the C-to-Rust translation task using  
two benchmark datasets: DCBench and IMCBench. These datasets  
are derived from real-world open-source projects, representing  
diverse levels of complexity. The detailed results are presented  
\`\`\`

\`\`\`  
Dependency-Guided Repository-Level C-to-Rust Translation with Reinforcement Alignment FSE Companion ’26, July 5–9, 2026, Montreal, QC, Canada  
\`\`\`  
\`\`\`  
Table 2: Evaluation results of DGIR compared with baselines on the DCBench and IMCBench datasets. Under each metric, the  
best performance is highlighted in bold. The↑/↓represents the performance of the DGIR compared with the best-performing  
baseline on computational accuracy (CA) and compilation success rate (CSR).  
\`\`\`  
\`\`\`  
Dataset Method DSC-6.7B DSC-33B QWC-7B QWC-14B QWC-32B  
CSR CA CSR CA CSR CA CSR CA CSR CA  
\`\`\`  
\`\`\`  
DCBench  
\`\`\`  
\`\`\`  
Base 4.0 2.4 8.0 4.8 8.8 4.8 9.6 5.6 8.8 4\.  
RAG (k=1) 6.4 3.2 8.8 6.4 8.0 3.2 12.0 5.6 10.4 4\.  
RAG (k=3) 10.4 4.8 8.0 5.6 8.8 3.2 12.0 5.6 10.4 4\.  
RAG (k=5) 7.2 3.2 7.2 4.0 8.0 4.8 15.2 8.0 12.0 6\.  
File Context 21.6 15.2 18.4 16.0 20.8 13.6 32.0 22.4 30.4 22\.  
DGIR 34.4 26.4 34.4 27.2 42.4 28.0 44.5 27.7 51.2 36\.  
\`\`\`  
\`\`\`  
IMCBench  
\`\`\`  
\`\`\`  
Base 50.0 5.0 50.0 5.0 50.0 5.0 55.0 10.0 50.0 5\.  
RAG (k=1) 60.0 25.0 55.0 20.0 50.0 5.0 60.0 25.0 50.0 5\.  
RAG (k=3) 55.0 10.0 55.0 20.0 55.0 5.0 60.0 25.0 50.0 10\.  
RAG (k=5) 60.0 25.0 60.0 35.0 55.0 10.0 60.0 40.0 55.0 20\.  
File Context 85.0 40.0 70.0 35.0 80.0 45.0 80.0 55.0 85.0 50\.  
DGIR 95.0 65.0 85.0 45.0 80.0 30.0 100.0 70.0 95.0 70\.  
\`\`\`  
\#\#\#\#\# TOTAL

\`\`\`  
Base 10.3 2.8 13.8 4.8 14.5 4.8 15.9 6.2 14.5 4\.  
RAG (k=1) 13.8 6.2 15.2 8.3 13.8 3.4 18.6 8.3 15.9 4\.  
RAG (k=3) 16.6 5.5 14.5 7.6 15.2 3.4 18.6 8.3 15.9 5\.  
RAG (k=5) 14.5 6.2 14.5 8.3 14.5 5.5 21.4 12.4 17.9 8\.  
File Context 30.3 18.6 25.5 18.6 29.0 17.9 38.6 26.9 37.9 26\.  
DGIR 42.8 31.7 41.4 29.7 47.6 28.3 52.2 33.6 57.2 41\.  
\`\`\`  
\`\`\`  
Table 3: Evaluation results of RAST-7B compared with baseline models on the DCBench and IMCBench datasets. The best  
result under each metric is highlighted in bold.  
\`\`\`  
\`\`\`  
Model DCBench IMCBench TOTAL  
CSR CA CodeBLEU CSR CA CodeBLEU CSR CA CodeBLEU  
DSC-6.7B 34.4 26.4 55.8 95.0 65.0 54.4 42.8 31.7 55\.  
DSC-33B 34.4 27.2 60.1 85.0 45.0 57.1 41.4 29.7 59\.  
QWC-7B 42.4 28.0 59.0 80.0 30.0 52.7 47.6 28.3 58\.  
QWC-14B 44.5 27.7 61.2 100.0 70.0 56.5 52.2 33.6 60\.  
QWC-32B 51.2 36.8 61.8 95.0 70.0 58.9 57.2 41.4 61\.  
RAST-7B 56.0 40.8 65.9 90.0 60.0 62.2 60.7 43.5 65\.  
\`\`\`  
in Table 2\. Based on the experimental results, we make the following  
key observations:  
(1)DGIR achieves superior overall performance by effec-  
tively resolving repository-level dependencies. On the struc-  
turally complex DCBench, DGIR consistently outperforms all base-  
lines across all model sizes. For instance, with Qwen2.5-Coder-32B,  
DGIR achieves a compilation success rate of 51.2% and a computa-  
tional accuracy of 36.8%, outperforming the best-performing base-  
line File Context by 20.8% and 14.4%, respectively. This gap under-  
scores that merely providing file context is insufficient for capturing  
the global dependency information necessary for repository-level  
consistency. On IMCBench, while reduced complexity benefits  
most methods, DGIR remains superior in functional correctness.  
With Qwen2.5-Coder-14B and 32B, DGIR achieves a computational  
accuracy of 70.0%, exceeding the best baseline by up to 20%. Even  
with DSC-6.7B, the computational accuracy improves from 40.0%  
(File Context) to 65.0% with DGIR. These results underscore that

\`\`\`  
by modeling global project structures and integrating feedback-  
driven repair, DGIR not only facilitates syntactic correctness but  
also enhances the preservation of semantic equivalence.  
(2) DGIR exhibits strong generalization across varying  
model capacities. For example, with DSC-6.7B, the compilation  
success rate increases from 30.3% (File Context) to 42.8%, and the  
computational accuracy from 18.6% to 31.7%. Similar trends are  
observed for larger models: under Qwen2.5-Coder-32B, the compi-  
lation success rate reaches 57.2% and the computational accuracy  
41.4%, showing absolute improvements of 19.3% and 15.2% over  
File Context, respectively. These results confirm that DGIR not  
only benefits from large models but also substantially boosts the  
performance of smaller, more resource-efficient models.  
\`\`\`

\`\`\`  
FSE Companion ’26, July 5–9, 2026, Montreal, QC, Canada Jia Feng, Wenjie Gan, Cuiyun Gao, Chaozheng Wang, Feng Luo, Xin Xia, Ge Li, and Kui Liu  
\`\`\`  
\`\`\`  
Finding 1: DGIR improves translation quality across diverse  
benchmarks and model scales, achieving absolute gains of up to  
15.2% in CA and 19.3% in CSR compared to the strongest baselines.  
The framework demonstrates strong generalization, effectively  
empowering both large-scale and resource-efficient models.  
\`\`\`  
5.1.2 Effectiveness of RAST-7B in C-to-Rust translation. As shown  
in Table 3, RAST-7B demonstrates the effectiveness of our two-stage  
training methodology across both datasets. Based on the results,  
we make the following observations:  
(1) RAST-7B achieves state-of-the-art overall performance  
across all evaluated metrics. In total, RAST-7B delivers the best  
aggregate results with 60.7% CSR, 43.5% CA, and a 65.4 CodeBLEU  
score, outperforming all baseline models. On IMCBench, it achieves  
a 90.0% CSR and the highest CodeBLEU of 62.2, showcasing its su-  
perior ability to maintain semantic equivalence during translation.  
Compared to its base model QWC-7B, RAST-7B improves CA from  
30.0% to 60.0%, effectively doubling the functional correctness.  
(2) RAST-7B outperforms baseline models with larger pa-  
rameter scales. For example, on the DCBench, RAST-7B achieves  
a 56.0% CSR and 40.8% CA, notably outperforming the much larger  
QWC-32B (51.2% CSR, 36.8% CA). This confirms that our RAST par-  
adigm allows smaller models to capture intricate repository-level  
logic more effectively than general-purpose larger models.

\`\`\`  
Finding 2: RAST-7B markedly outperforms baseline models  
across all metrics, achieving comparable performance to much  
larger models through our two-stage training approach, demon-  
strating the practical effectiveness of integrating multi-task learn-  
ing with compiler feedback.  
\`\`\`  
\#\#\# 5.2 RQ2: Ablation Studies

\`\`\`  
5.2.1 Ablation Study of DGIR. To evaluate the contribution of each  
component in DGIR, we design four ablated variants: Plain Deps  
(removing structural rewriting and import recovery), w/o Compile  
(removing compiler feedback), w/o Consistency (removing semantic  
consistency checking), and w/o Repair (removing the iterative repair  
loop). Experimental results are presented in Table 4\.  
Experimental results confirm that every component of  
DGIR is indispensable. First, removing structural rewriting (Plain  
Deps) causes a clear decline in overall accuracy; for instance, the  
Total CA on QWC-32B drops from 41.4% to 35.9%, indicating that  
fine-grained structural alignment is fundamental for capturing ef-  
fective repository context. Second, removing compiler feedback  
(w/o Compile) directly impacts syntactic validity; specifically, the  
compilation success rate (CSR) on DCBench with QWC-14B de-  
creases from 44.5% to 34.4%, proving that compiler-driven repair is  
essential for guaranteeing high compilation rates. Third, excluding  
semantic consistency checks (w/o Consistency) significantly com-  
promises functional correctness. Notably, the functional accuracy  
on IMCBench (QWC-32B) drops sharply from 70.0% to 45.0%. In-  
terestingly, this performance decay is negligible on smaller-scale  
models, suggesting that consistency guidance is more effective for  
models with stronger reasoning capabilities, whereas it may be  
considered optional for smaller models with limited self-correction  
potential. Finally, removing the entire iterative repair loop (w/o  
Repair) results in the most severe degradation across metrics; for  
\`\`\`  
\`\`\`  
example, the CSR on DCBench (QWC-7B) plummets from 42.4% to  
29.6%, validating that the iterative refinement process is the core en-  
gine for bridging the gap between initial translation and executable,  
correct code.  
\`\`\`  
\`\`\`  
5.2.2 Ablation Study of RAST-7B. We further analyze the impact of  
different reward weighting strategies in the reinforcement learning  
phase. As shown in Table 5, we evaluate four RAST-7B variants  
with distinct reward configurations.  
A balanced reward configuration is critical for achieving  
robust translation. Specifically, the Compilation-Only (1:0) strat-  
egy causes performance degradation, evidenced by a near-perfect  
Total CSR (97.9%) but a complete failure in functional correctness  
(0.0% Total CA), as the model learns to exploit the reward mech-  
anism by generating trivial, safe outputs (e.g.,panic\!) to satisfy  
compilation constraints without implementing actual logic. Con-  
versely, exclusively prioritizing or over-emphasizing alignment  
rewards (Test-Only 0:1 and Test-Heavy 1:2) compromises syntactic  
reliability; for instance, while the 1:2 variant achieves the highest  
semantic similarity (Total CodeBLEU 66.5%), it suffers a decline in  
computational accuracy compared to the balanced setting (40.8% vs.  
43.5%). Ultimately, the Balanced (1:1) configuration demonstrates su-  
perior robustness, achieving the highest Total CA of 43.5% alongside  
a competitive compilation rate, confirming that the joint optimiza-  
tion of syntactic validity and functional alignment is requisite for  
high-fidelity migration.  
\`\`\`  
\`\`\`  
Finding 3: The ablation studies indicate that both the modular  
components of DGIR and the balanced reward configuration in  
RAST-7B are important. Structural guidance and iterative repair  
contribute complementary benefits, while reward balancing be-  
tween compilation and test execution helps mitigate degenerate  
behaviors and improves translation quality.  
\`\`\`  
\#\#\# 5.3 RQ3: Industrial Project-level Migration

\`\`\`  
To evaluate DepTrans in industrial contexts, we introduce HW-  
Bench, a dataset of 15 Huawei C projects with code sizes ranging  
from 1,000 to 3,000 lines. The evaluation metric is the number of  
projects that can be successfully built (Build), reflecting practical  
applicability in real-world enterprise settings. The results are sum-  
marized in Table 6\.  
DepTrans demonstrates superior robustness and practical  
effectiveness in industrial-scale migration. On HWBench, the  
Base strategy nearly fails across all configurations, while Sactor  
achieves only modest improvements (e.g., 5 builds on QWC-32B).  
In contrast, DGIR independently attains superior performance, with  
6 and 7 successful builds on QWC-14B and QWC-32B, respectively,  
even without RAST adaptation. When RAST is integrated, RAST-  
7B’s successful builds increase from 3 to 7, effectively matching the  
performance of the much larger QWC-32B model. This underscores  
both the robustness of our inference framework and the efficiency  
of our task-specific tuning.  
\`\`\`  
\`\`\`  
Finding 4: DepTrans demonstrates strong robustness and prac-  
tical effectiveness in industrial-scale C-to-Rust migration, notably  
improving build success rates and supporting enterprise-level  
code translation.  
\`\`\`

\`\`\`  
Dependency-Guided Repository-Level C-to-Rust Translation with Reinforcement Alignment FSE Companion ’26, July 5–9, 2026, Montreal, QC, Canada  
\`\`\`  
\`\`\`  
Table 4: Ablation study on DGIR. Under each metric, the best performance is highlighted in bold.  
\`\`\`  
\`\`\`  
Dataset Method DSC-6.7B DSC-33B QWC-7B QWC-14B QWC-32B  
CSR CA CSR CA CSR CA CSR CA CSR CA  
\`\`\`  
\`\`\`  
DCBench  
\`\`\`  
\`\`\`  
Plain Deps 22.4 19.2 24.8 20.2 23.2 15.2 40.7 30.1 42.4 33\.  
w/o Compile 28.8 20.0 22.4 19.2 36.8 26.4 34.4 26.4 36.0 28\.  
w/o Consistency 34.4 23.2 34.4 28.0 39.2 28.0 45.5 33.3 44.0 35\.  
w/o Repair 20.8 17.6 28.8 27.2 29.6 23.2 42.4 33.6 36.8 28\.  
DGIR 34.4 26.4 34.4 27.2 42.4 28.0 44.5 27.7 51.2 36\.  
\`\`\`  
\`\`\`  
IMCBench  
\`\`\`  
\`\`\`  
Plain Deps 95.0 55.0 90.0 60.0 70.0 35.0 85.0 45.0 85.0 50\.  
w/o Compile 80.0 50.0 70.0 45.0 65.0 30.0 70.0 35.0 80.0 45\.  
w/o Consistency 95.0 60.0 85.0 60.0 65.0 30.0 80.0 40.0 80.0 45\.  
w/o Repair 75.0 50.0 70.0 40.0 75.0 25.0 85.0 55.0 80.0 65\.  
DGIR 95.0 65.0 85.0 45.0 80.0 30.0 100.0 70.0 95.0 70\.  
\`\`\`  
\#\#\#\#\# TOTAL

\`\`\`  
Plain Deps 32.4 24.1 33.8 25.7 29.7 17.9 46.8 32.1 48.3 35\.  
w/o Compile 35.9 24.1 29.0 22.8 40.7 26.9 39.3 27.6 42.1 31\.  
w/o Consistency 42.8 28.3 41.4 32.4 42.8 28.3 50.3 34.3 49.0 36\.  
w/o Repair 28.3 22.1 34.5 29.0 35.9 23.4 48.3 36.6 42.8 33\.  
DGIR 42.8 31.7 41.4 29.7 47.6 28.3 52.2 33.6 57.2 41\.  
\`\`\`  
\`\`\`  
Table 5: Ablation study on different reward weighting strategies during training. All models are based on the RAST-7B variant.  
RAST-7B-𝛼:𝛽denotes a model trained with compilation and test rewards weighted by𝛼and𝛽, respectively. The best result  
under each metric is highlighted in bold.  
\`\`\`  
\`\`\`  
Model DCBench IMCBench TOTAL  
CSR CA CodeBLEU CSR CA CodeBLEU CSR CA CodeBLEU  
RAST-7B-1:0 97.6 0.0 47.2 100.0 0.0 37.8 97.9 0.0 45\.  
RAST-7B-0:1 53.6 38.2 66.0 90.0 50.0 64.6 58.6 39.8 65\.  
RAST-7B-1:1 56.0 40.8 65.9 90.0 60.0 62.2 60.7 43.5 65\.  
RAST-7B-1:2 56.1 39.3 66.8 90.0 50.0 64.4 60.8 40.8 66\.  
Table 6: Results of DepTrans compared with baselines on  
HWBench. The best performance is highlighted in bold.  
\`\`\`  
\`\`\`  
Method DSC-6.7B DSC-33B QWC-7B QWC-14B QWC-32B RAST-7B  
Base 0 0 0 0 1 \-  
Sactor 1 3 2 2 5 \-  
DGIR 2 3 3 6 7 7  
\`\`\`  
\#\#\# 6 Discussion

\#\#\# 6.1 Case Study

We present a case study on theauthenticate\_streamfunction to  
illustrate the effectiveness of DepTrans (Figure 2). This function  
relies on implicit buffer and cryptographic dependencies defined in  
external modules, which pose a significant challenge for translation  
approaches lacking project-wide context. As shown in Figure 2,  
baseline methods exhibit critical failures: direct translation pro-  
duces scope errors (e.g.,error\[E0425\]) and ownership violations  
such asuse of moved value, as it fails to recognize external  
module interfaces and Rust’s strict borrowing rules. In contrast,  
DepTrans generates a syntactically valid and idiomatic translation.  
By explicitly modeling cross-module dependencies and mapping  
them to a semantically aligned Rust dependency pool, DepTrans  
correctly resolves module-qualified calls (e.g.,crypto::hash) and

\`\`\`  
ensures functional integrity. This demonstrates DepTrans’s supe-  
rior ability to navigate the structural complexities of repository-  
scale C-to-Rust migration.  
\`\`\`  
\#\#\# 6.2 Impact of Repair Iterations in DGIR

\`\`\`  
We evaluate the impact of repair iteration counts on Qwen2.5-  
Coder-7B by varying compiler repair (1–5) with fixed consistency  
repair (2), and varying consistency repair (1–5) with fixed compiler  
repair (3). As shown in Figure 3, we report the compilation rate,  
accuracy, and token consumption for each configuration.  
Increasing repair iterations improves performance but in-  
curs higher costs. For compiler-guided repair, computational  
accuracy rises from 31.03% at iteration 1 to a peak of 35.17% at  
iteration 4, yet this comes with a sharp increase in token consump-  
tion exceeding 100k at iteration 5\. Similarly, consistency-guided  
repair shows marginal improvements, where iteration 5 achieves  
the highest compilation rate of 53.10% but consumes substantially  
more tokens than iteration 1 which attains identical computational  
accuracy.  
To balance translation performance with inference overhead, we  
recommend setting the compiler-guided repair iteration count to  
2–3 and the consistency repair iteration count to 1 or 3\. This con-  
figuration maximizes computational efficiency while maintaining  
robust migration quality in real-world pipelines.  
\`\`\`

FSE Companion ’26, July 5–9, 2026, Montreal, QC, Canada Jia Feng, Wenjie Gan, Cuiyun Gao, Chaozheng Wang, Feng Luo, Xin Xia, Ge Li, and Kui Liu

\`\`\`  
int authenticate\_stream(...) {  
...  
// ① implicit buffer dependency (defined in another module)  
size\_t n \= buffer\_append(ctx-\>buf, ...);  
...  
// ② implicit crypto dependency  
if (crypto\_hash(ctx-\>algo, ..., hash) \!= 0 )  
return ERR\_CRYPTO;  
...  
}  
\`\`\`  
\`\`\`  
pub fn authenticate\_stream(...) \- \> Result\<AuthResult, AuthError\> {  
...  
// ① buffer dependency not aware  
let n \= buffer\_append(ctx.buf, ...); // ×  
// error\[E 0425 \]: cannot find function \`buffer\_append\` in this scope  
// error\[E 0382 \]: use of moved value \`ctx.buf\`  
...  
\`\`\`  
\`\`\`  
// ② crypto dependency not imported / not aware  
crypto\_hash(ctx.algo, buffer\_data(ctx.buf), ..., \&mut hash)?; // ×  
// error\[E 0425 \]: cannot find function \`crypto\_hash\` in this scope  
// error\[E 0106 \]: missing lifetime specifier  
...  
}  
pub fn authenticate\_stream(...) \- \> Result\<AuthResult, AuthError\> {  
...  
// ① buffer dependency explicitly modeled modules  
ctx.buf.append(...)?; // √  
let data \= ctx.buf.read\_exact(...)?; ...  
\`\`\`  
\`\`\`  
// ② crypto dependency explicitly modeled  
let hash \= crypto::hash(ctx.algo, \&data)?; // √  
...  
\`\`\`  
\`\`\`  
Ok(AuthResult { ... })  
}  
\`\`\`  
\`\`\`  
Original C Code  
\`\`\`  
\`\`\`  
Direct Translating  
\`\`\`  
\`\`\`  
DepTrans Translating  
\`\`\`  
Figure 2: Case study of authenticate\_stream translation gen-  
erated by Qwen2.5-Coder-7B.

\`\`\`  
1 2 3 4 5  
Iteration  
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
Rate (%)  
\`\`\`  
\`\`\`  
Compile Repair Iteration  
\`\`\`  
\`\`\`  
1 2 3 4 5  
Iteration  
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
Rate (%)  
\`\`\`  
\`\`\`  
Consistency Repair Iteration  
\`\`\`  
\`\`\`  
50000  
\`\`\`  
\`\`\`  
70000  
\`\`\`  
\`\`\`  
90000  
\`\`\`  
\`\`\`  
110000  
\`\`\`  
\`\`\`  
Token Consumption 68000  
\`\`\`  
\`\`\`  
74000  
\`\`\`  
\`\`\`  
80000  
\`\`\`  
\`\`\`  
86000  
\`\`\`  
\`\`\`  
Token Consumption  
\`\`\`  
\`\`\`  
Compile Rate Pass Rate Token Consumption  
\`\`\`  
Figure 3: Impact of compilation repair and consistency repair  
iterations on translation performance and average token  
consumption.

\`\`\`  
Table 7: Evaluation results of DepTrans compared with base-  
lines on CRust-Bench. “Build” indicates the number of suc-  
cessfully compiled projects, and “Test” represents the num-  
ber of projects passing all test cases. The best performance  
under each metric is highlighted in bold.  
\`\`\`  
\#\#\#\# Model

\#\#\#\# Build Test

\#\#\#\# Base Sactor DGIR Base Sactor DGIR

\#\#\#\# DSC-6.7B 0 4 6 0 0 0

\#\#\#\# DSC-33B 1 12 10 0 2 1

\#\#\#\# QWC-7B 0 5 11 0 2 2

\#\#\#\# QWC-14B 1 8 20 0 2 4

\#\#\#\# QWC-32B 6 12 26 0 4 5

\#\#\#\# RAST-7B \- \- 27 \- \- 5

\`\`\`  
Table 8: Evaluation of unsafe code ratio (%) in translated Rust  
\`\`\`  
\`\`\`  
Model DCBench IMCBench CRustBench HWBench  
DSC-6.7B 0.98 0 3.39 2\.  
DSC-13B 0.55 0 0.1 1\.  
QWC-7B 1.015 0 1.26 2\.  
QWC-14B 0.44 0 0.24 1\.  
QWC-32B 0 0 0.25 0\.  
RAST-7B 0.32 0 0.54 1\.  
\`\`\`  
\#\#\# 6.3 How does DepTrans perform in

\#\#\# open-source benchmarks?

\`\`\`  
We further evaluate DepTrans on CRust-Bench \[ 24 \], which com-  
prises 100 open-source C projects with manually written Rust test  
cases.  
DepTrans demonstrates superior generalization and ro-  
bustness on open-source benchmarks. As shown in Table 7,  
DepTrans consistently outperforms baselines across all metrics.  
Specifically, with QWC-32B, it compiles 26 projects, doubling the 12  
builds by Sactor, and increases test-passing projects to 5\. Integrating  
RAST-7B yields state-of-the-art results with 27 builds and 5 passes,  
confirming the system’s robustness on complex repositories.  
\`\`\`  
\#\#\# 6.4 How safe is the Rust code generated by

\#\#\# DepTrans?

\`\`\`  
To assess the safety of Rust code produced by DepTrans, we mea-  
sure the proportion of “unsafe” lines in translated projects, as sum-  
marized in Table 8\. Lower values indicate safer code, i.e., fewer  
instances requiring explicit “unsafe” blocks.  
DepTrans consistently minimizes unsafe code ratios across  
all benchmarks. For instance, the unsafe code ratio remains below  
3% for all models on DCBench and HWBench. Even on the com-  
plex CRustBench, the ratio stays remarkably low, exemplified by  
3.39% for DSC-6.7B, which confirms the framework’s capability to  
effectively reduce memory safety risks and ensure maintainability.  
\`\`\`

\`\`\`  
Dependency-Guided Repository-Level C-to-Rust Translation with Reinforcement Alignment FSE Companion ’26, July 5–9, 2026, Montreal, QC, Canada  
\`\`\`  
\#\#\# 6.5 Threats To Validity

Limited LCMs. We reduce selection bias by evaluating five di-  
verse LCMs with different sizes. Moreover, our core contributions,  
including dependency enhancement and iterative repair, are model-  
agnostic and can be easily applied to other architectures.  
Potential Data Leakage. Since pretraining data is not public,  
we cannot fully rule out leakage. However, the poor performance of  
simple prompting suggests this is not a major issue. The significant  
gains from our framework confirm that the improvements come  
from our method rather than the model just memorizing the data.

\#\#\# 7 Related Work

Existing C-to-Rust migration approaches follow two primary paradigms:  
rule-based and LLM-based. Rule-based approaches, such as C2Rust \[ 22 \],  
leverage compiler infrastructures to ensure structural equivalence,  
while subsequent works incorporate static analysis \[ 17 , 46 \] and  
alias emulation \[ 9 , 10 \] to enhance safety. Although these tools pro-  
vide high functional fidelity, the resulting code is often unidiomatic  
and fails to fully utilize Rust’s safety guarantees.  
LLM-based approaches aim to bridge this gap by learning id-  
iomatic patterns from large-scale corpora. Recent studies have ex-  
plored direct translation with feedback loops \[ 36 , 42 , 48 \] or hybrid  
refinement strategies that post-process rule-based outputs \[ 33 , 38 \].  
These diverse explorations have collectively highlighted two per-  
sistent, open challenges in the field: the difficulty of maintaining  
coherence across complex repository-level dependencies and the  
scarcity of high-quality parallel data. Our work, DepTrans, specifi-  
cally addresses these architectural and data-level bottlenecks.

\#\#\# 8 Conclusion

\`\`\`  
In this paper, We propose a novel approach for repository-level C-to-  
Rust translation. It consists of two key components: a dependency-  
guided translation framework and a two-stage training paradigm.  
The framework extracts fine-grained dependencies from C code,  
maps them to their Rust equivalents, and constructs precise trans-  
lation context to guide LLM-based generation. It further applies  
compiler diagnostics and LLM-based consistency checks for itera-  
tive error repair. The training paradigm combines multi-task fine-  
tuning with compiler-feedback reinforcement learning, supported  
by our constructed dataset of function-level and repository-level  
C-Rust pairs. Extensive experiments show that our approach con-  
sistently improves compilation success and functional correctness  
over strong baselines, demonstrating its effectiveness for practical  
migration scenarios.  
\`\`\`  
\#\#\# Acknowledgment

\`\`\`  
This research is supported by National Natural Science Foundation  
of China under project (No. 62472126\) and CCF-Huawei Populus  
Grove Fund.  
\`\`\`  
\#\#\# References

\`\`\`  
\[1\]\[n. d.\]. Rust (programming language). https://en.wikipedia.org/wiki/Rust\_  
(programming\_language).  
\[2\] \[n. d.\]. tree-sitter. 2023\. https://github.com/tree-sitter/tree-sitter.  
\[3\]Amro Abbas, Kushal Tirumala, Dániel Simig, Surya Ganguli, and Ari S Mor-  
cos. 2023\. Semdedup: Data-efficient learning at web-scale through semantic  
deduplication. arXiv preprint arXiv:2303.09540 (2023).  
\`\`\`  
\`\`\`  
\[4\]Yannick Assogba and Donghao Ren. \[n. d.\]. Evaluating Long Range Dependency  
Handling in Code Generation LLMs. Transactions on Machine Learning Research  
(\[n. d.\]).  
\[5\]Xuemeng Cai, Jiakun Liu, Xiping Huang, Yijun Yu, Haitao Wu, Chunmiao Li, Bo  
Wang, Imam Nur Bani Yusuf, and Lingxiao Jiang. 2025\. RustMap: Towards Project-  
Scale C-to-Rust Migration via Program Analysis and LLM. CoRR abs/2503.  
(2025). arXiv:2503.17741 doi:10.48550/ARXIV.2503.  
\[6\]Jianlyu Chen, Shitao Xiao, Peitian Zhang, Kun Luo, Defu Lian, and Zheng Liu.  
\`\`\`  
2024\. M3-Embedding: Multi-Linguality, Multi-Functionality, Multi-Granularity  
Text Embeddings Through Self-Knowledge Distillation. In Findings of the Asso-  
ciation for Computational Linguistics, ACL 2024, Bangkok, Thailand and virtual  
meeting, August 11-16, 2024, Lun-Wei Ku, Andre Martins, and Vivek Srikumar  
(Eds.). Association for Computational Linguistics, 2318–2335. doi:10.18653/V1/  
2024.FINDINGS-ACL.  
\[7\]John Criswell, Nicolas Geoffray, and Vikram S. Adve. 2009\. Memory Safety for  
Low-Level Software/Hardware Interactions. In 18th USENIX Security Symposium,  
Montreal, Canada, August 10-14, 2009, Proceedings, Fabian Monrose (Ed.). USENIX  
Association, 83–100.  
\[8\]DARPA. \[n. d.\]. TRACTOR: Translating All C to Rust. https://www.darpa.mil/  
research/programs/translating-all-c-to-rust.  
\[9\] Mehmet Emre, Peter Boyland, Aesha Parekh, Ryan Schroeder, Kyle Dewey, and  
Ben Hardekopf. 2023\. Aliasing Limits on Translating C to Safe Rust. Proc. ACM  
Program. Lang. 7, OOPSLA1 (2023), 551–579. doi:10.1145/  
\[10\]Mehmet Emre, Ryan Schroeder, Kyle Dewey, and Ben Hardekopf. 2021\. Trans-  
lating C to safer Rust. Proc. ACM Program. Lang. 5, OOPSLA (2021), 1–29.  
doi:10.1145/  
\[11\]Jia Feng, Jiachen Liu, Cuiyun Gao, Chun Yong Chong, Chaozheng Wang, Shan  
Gao, and Xin Xia. 2024\. Complexcodeeval: A benchmark for evaluating large code  
models on more complex code. In Proceedings of the 39th IEEE/ACM International  
Conference on Automated Software Engineering. 1895–1906.  
\[12\]Pietro Ferrara, Vincenzo Arceri, and Agostino Cortesi. 2024\. Challenges of  
software verification: the past, the present, the future. International Journal on  
Software Tools for Technology Transfer 26, 4 (2024), 421–430.  
\[13\]Aymeric Fromherz and Jonathan Protzenko. 2024\. Compiling C to Safe Rust,  
Formalized. CoRR abs/2412.15042 (2024). arXiv:2412.15042 doi:10.48550/ARXIV.  
2412\.  
\[14\]Yifei Gao, Chengpeng Wang, Pengxiang Huang, Xuwei Liu, Mingwei Zheng,  
and Xiangyu Zhang. 2025\. PR2: Peephole Raw Pointer Rewriting with LLMs  
for Translating C to Safer Rust. CoRR abs/2505.04852 (2025). arXiv:2505.  
doi:10.48550/ARXIV.2505.  
\[15\]Daya Guo, Dejian Yang, Haowei Zhang, Junxiao Song, Peiyi Wang, Qihao Zhu,  
Runxin Xu, Ruoyu Zhang, Shirong Ma, Xiao Bi, et al.2025. DeepSeek-R1 in-  
centivizes reasoning in LLMs through reinforcement learning. Nature 645, 8081  
(2025), 633–638.  
\[16\]Daya Guo, Qihao Zhu, Dejian Yang, Zhenda Xie, Kai Dong, Wentao Zhang,  
Guanting Chen, Xiao Bi, Yu Wu, YK Li, et al.2024. DeepSeek-Coder: When the  
Large Language Model Meets Programming–The Rise of Code Intelligence. arXiv  
preprint arXiv:2401.14196 (2024).  
\[17\]Jaemin Hong and Sukyoung Ryu. 2023\. Concrat: An Automatic C-to-Rust Lock  
API Translator for Concurrent Programs. In 45th IEEE/ACM International Confer-  
ence on Software Engineering, ICSE 2023, Melbourne, Australia, May 14-20, 2023\.  
IEEE, 716–728. doi:10.1109/ICSE48619.2023.  
\[18\]Jaemin Hong and Sukyoung Ryu. 2024\. To Tag, or Not to Tag: Translating C’s  
Unions to Rust’s Tagged Unions. In Proceedings of the 39th IEEE/ACM International  
Conference on Automated Software Engineering, ASE 2024, Sacramento, CA, USA,  
October 27 \- November 1, 2024, Vladimir Filkov, Baishakhi Ray, and Minghui Zhou  
(Eds.). ACM, 40–52. doi:10.1145/3691620.  
\[19\] Jaemin Hong and Sukyoung Ryu. 2025\. Forcrat: Automatic I/O API Translation  
from C to Rust via Origin and Capability Analysis. arXiv:2506.01427 \[cs.SE\]  
https://arxiv.org/abs/2506.  
\[20\]Baizhou Huang, Shuai Lu, Xiaojun Wan, and Nan Duan. 2024\. Enhancing Large  
Language Models in Coding Through Multi-Perspective Self-Consistency. In  
Proceedings of the 62nd Annual Meeting of the Association for Computational  
Linguistics (Volume 1: Long Papers), ACL 2024, Bangkok, Thailand, August 11-16,  
2024 , Lun-Wei Ku, Andre Martins, and Vivek Srikumar (Eds.). Association for  
Computational Linguistics, 1429–1450. doi:10.18653/V1/2024.ACL-LONG.  
\[21\]Binyuan Hui, Jian Yang, Zeyu Cui, Jiaxi Yang, Dayiheng Liu, Lei Zhang, Tianyu  
Liu, Jiajun Zhang, Bowen Yu, Keming Lu, et al.2024. Qwen2. 5-coder technical  
report. arXiv preprint arXiv:2409.12186 (2024).  
\[22\]Immunant, Inc. \[n. d.\]. C2Rust: Source-to-Source C-to-Rust Transpiler. https:  
//c2rust.com.  
\[23\]Mohammad Abdullah Matin Khan, M. Saiful Bari, Xuan Do Long, Weishi Wang,  
Md. Rizwan Parvez, and Shafiq Joty. 2024\. XCodeEval: An Execution-based  
Large Scale Multilingual Multitask Benchmark for Code Understanding, Gen-  
eration, Translation and Retrieval. In Proceedings of the 62nd Annual Meeting  
of the Association for Computational Linguistics (Volume 1: Long Papers), ACL  
2024, Bangkok, Thailand, August 11-16, 2024, Lun-Wei Ku, Andre Martins, and  
Vivek Srikumar (Eds.). Association for Computational Linguistics, 6766–6805.

FSE Companion ’26, July 5–9, 2026, Montreal, QC, Canada Jia Feng, Wenjie Gan, Cuiyun Gao, Chaozheng Wang, Feng Luo, Xin Xia, Ge Li, and Kui Liu

doi:10.18653/V1/2024.ACL-LONG.  
\[24\]Anirudh Khatry, Robert Zhang, Jia Pan, Ziteng Wang, Qiaochu Chen, Greg  
Durrett, and Isil Dillig. 2025\. CRUST-Bench: A Comprehensive Benchmark for  
C-to-safe-Rust Transpilation. CoRR abs/2504.15254 (2025). arXiv:2504.  
doi:10.48550/ARXIV.2504.  
\[25\]Per Larsen. 2024\. Migrating C to Rust for Memory Safety. IEEE Secur. Priv. 22, 4  
(2024), 22–29. doi:10.1109/MSEC.2024.  
\[26\] Kornel Lesiński. \[n. d.\]. Speed of Rust vs C. https://kornel.ski/rust-c-speed.  
\[27\]Jia Li, Hao Zhu, Huanyu Liu, Xianjie Shi, He Zong, Yihong Dong, Kechi Zhang,  
Siyuan Jiang, Zhi Jin, and Ge Li. 2025\. aiXcoder-7B-v2: Training LLMs to Fully  
Utilize the Long Context in Repository-level Code Completion. arXiv preprint  
arXiv:2503.15301 (2025).  
\[28\]Ruishi Li, Bo Wang, Tianyu Li, Prateek Saxena, and Ashish Kundu. 2025\. Translat-  
ing C To Rust: Lessons from a User Study. In 32nd Annual Network and Distributed  
System Security Symposium, NDSS 2025, San Diego, California, USA, February 24-28,  
2025\. The Internet Society.  
\[29\]Shuqing Li, Qisheng Zheng, Cuiyun Gao, Jia Feng, and Michael R. Lyu. 2025\.  
Extended Reality Cybersickness Assessment via User Review Analysis. Proc. ACM  
Softw. Eng. 2, ISSTA, Article ISSTA058 (June 2025), 23 pages. doi:10.1145/  
\[30\]Jiaheng Liu, Dawei Zhu, Zhiqi Bai, Yancheng He, Huanxuan Liao, Haoran Que,  
Zekun Wang, Chenchen Zhang, Ge Zhang, Jiebin Zhang, et al.2025. A comprehen-  
sive survey on long context language modeling. arXiv preprint arXiv:2503.  
(2025).  
\[31\]Feng Luo, Kexing Ji, Cuiyun Gao, Shuzheng Gao, Jia Feng, Kui Liu, Xin Xia, and  
Michael R Lyu. 2025\. Integrating Rules and Semantics for LLM-Based C-to-Rust  
Translation. arXiv preprint arXiv:2508.06926 (2025).  
\[32\]Microsoft Security Response Center. 2019\. A Proactive Approach to More Secure  
Code. https://msrc.microsoft.com/blog/2019/07/a-proactive-approach-to-more-  
secure-code/.  
\[33\]Vikram Nitin, Rahul Krishna, Luiz Lemos do Valle, and Baishakhi Ray. 2025\.  
C2SaferRust: Transforming C Projects into Safer Rust with NeuroSymbolic Tech-  
niques. CoRR abs/2501.14257 (2025). arXiv:2501.14257 doi:10.48550/ARXIV.2501.  
14257  
\[34\]Rangeet Pan, Ali Reza Ibrahimzada, Rahul Krishna, Divya Sankar, Lam-  
bert Pouguem Wassi, Michele Merler, Boris Sobolev, Raju Pavuluri, Saurabh  
Sinha, and Reyhaneh Jabbarvand. 2024\. Lost in translation: A study of bugs  
introduced by large language models while translating code. In Proceedings of  
the IEEE/ACM 46th International Conference on Software Engineering. 1–13.  
\[35\]Shuo Ren, Daya Guo, Shuai Lu, Long Zhou, Shujie Liu, Duyu Tang, Neel Sundare-  
san, Ming Zhou, Ambrosio Blanco, and Shuai Ma. 2020\. Codebleu: a method for  
automatic evaluation of code synthesis. arXiv preprint arXiv:2009.10297 (2020).  
\[36\]Manish Shetty, Naman Jain, Adwait Godbole, Sanjit A. Seshia, and Koushik Sen.

2024\. Syzygy: Dual Code-Test C to (safe) Rust Translation using LLMs and  
Dynamic Analysis. CoRR abs/2412.14234 (2024). arXiv:2412.14234 doi:10.48550/  
ARXIV.2412.  
\[37\]HoHyun Sim, Hyeonjoong Cho, Yeonghyeon Go, Zhoulai Fu, Ali Shokri, and  
Binoy Ravindran. 2025\. Large Language Model-Powered Agent for C to Rust  
Code Translation. arXiv preprint arXiv:2505.15858 (2025).  
\[38\]HoHyun Sim, Hyeonjoong Cho, Yeonghyeon Go, Zhoulai Fu, Ali Shokri, and  
Binoy Ravindran. 2025\. Large Language Model-Powered Agent for C to Rust  
Code Translation. CoRR abs/2505.15858 (2025). arXiv:2505.15858 doi:10.48550/  
ARXIV.2505.  
\[39\]Chaozheng Wang, Jia Feng, Shuzheng Gao, Cuiyun Gao, Zongjie Li, Ting Peng,  
Hailiang Huang, Yuetang Deng, and Michael Lyu. 2025\. Beyond PEFT: Layer-Wise  
Optimization for More Effective and Efficient Large Code Model Tuning. Proc.  
ACM Softw. Eng. 2, FSE, Article FSE071 (June 2025), 24 pages. doi:10.1145/  
\[40\]Chaofan Wang, Guanjie Qiu, Xiaodong Gu, and Beijun Shen. 2025\. APIRAT:  
Integrating Multi-source API Knowledge for Enhanced Code Translation with  
LLMs. arXiv preprint arXiv:2504.14852 (2025).  
\[41\]Ruiqi Wang, Jiyu Guo, Cuiyun Gao, Guodong Fan, Chun Yong Chong, and Xin  
Xia. 2025\. Can llms replace human evaluators? an empirical study of llm-as-a-  
judge in software engineering. Proceedings of the ACM on Software Engineering  
2, ISSTA (2025), 1955–1977.  
\[42\]Aidan Z. H. Yang, Yoshiki Takashima, Brandon Paulsen, Josiah Dodds, and  
Daniel Kroening. 2024\. VERT: Verified Equivalent Rust Transpilation with  
Large Language Models as Few-Shot Learners. arXiv:2404.18852 \[cs.PL\] https:  
//arxiv.org/abs/2404.  
\[43\]Shiyu YANG, Yusheng GUO, Akihiro TABATA, and Yoshiki HIGO. 2025\. Con-  
structing a Dataset of Functionally Equivalent Python Methods Using Test Gen-  
eration Techniques. IEICE Transactions on Information and Systems (2025).  
\[44\]Zhen Yang, Fang Liu, Zhongxing Yu, Jacky Wai Keung, Jia Li, Shuo Liu, Yifan  
Hong, Xiaoxue Ma, Zhi Jin, and Ge Li. 2024\. Exploring and Unleashing the Power  
of Large Language Models in Automated Code Translation. Proc. ACM Softw.  
Eng. 1, FSE (2024), 1585–1608. doi:10.1145/  
\[45\]Shangbo Yun, Shuhuai Lin, Xiaodong Gu, and Beijun Shen. 2024\. Project-specific  
code summarization with in-context learning. Journal of Systems and Software  
216 (2024), 112149\.

\`\`\`  
\[46\]Hanliang Zhang, Cristina David, Yijun Yu, and Meng Wang. 2023\. Ownership  
Guided C to Rust Translation. In Computer Aided Verification \- 35th International  
Conference, CAV 2023, Paris, France, July 17-22, 2023, Proceedings, Part III (Lecture  
Notes in Computer Science, Vol. 13966), Constantin Enea and Akash Lal (Eds.).  
Springer, 459–482. doi:10.1007/978-3-031-37709-9\_  
\[47\]Ziyin Zhang, Chaoyu Chen, Bingchang Liu, Cong Liao, Zi Gong, Hang Yu, Jian-  
guo Li, and Rui Wang. 2024\. Unifying the Perspectives of NLP and Software  
Engineering: A Survey on Language Models for Code. Trans. Mach. Learn. Res.  
2024 (2024). https://openreview.net/forum?id=hkNnGqZnpa  
\[48\]Tianyang Zhou, Haowen Lin, Somesh Jha, Mihai Christodorescu, Kirill Levchenko,  
and Varun Chandrasekaran. 2025\. LLM-Driven Multi-step Translation from C  
to Rust using Static Analysis. CoRR abs/2503.12511 (2025). arXiv:2503.  
doi:10.48550/ARXIV.2503.  
\`\`\`


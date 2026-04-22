\`\`\`  
Findings of the Association for Computational Linguistics: ACL 2025, pages 7150–  
July 27 \- August 1, 2025 ©2025 Association for Computational Linguistics  
\`\`\`  
\# DependEval: Benchmarking LLMs for Repository Dependency

\# Understanding

\#\# Junjia Du^1 , Yadi Liu^2 , Hongcheng Guo^3 \*, Jiawei Wang^4 ,

\#\# Haojian Huang^5 ,Yunyi Ni^1 ,Zhoujun Li^3 ,

(^1) Nanyang Technological University (^2) Tsinghua University, (^3) Beihang University  
(^4) ShanghaiTech University (^5) The University of Hong Kong

\#\# Abstract

\`\`\`  
While large language models (LLMs) have  
shown considerable promise in code genera-  
tion, real-world software development demands  
advanced repository-level reasoning. This in-  
cludes understanding dependencies, project  
structures, and managing multi-file changes.  
However, the ability of LLMs to effectively  
comprehend and handle complex code reposi-  
tories has yet to be fully explored. To address  
challenges, we introduce a hierarchical bench-  
mark designed to evaluate repositorydepen-  
dencyunderstanding (DEPENDEVAL). Bench-  
mark is based on 2683 repositories collected  
from real-world websites. It evaluates models  
on three core tasks:Dependency Recognition,  
Repository Construction, andMulti-file Edit-  
ing, across 8 programming languages from ac-  
tual code repositories. Our evaluation of over  
25 LLMs reveals substantial performance gaps  
and provides valuable insights into repository-  
level code understanding^1  
\`\`\`  
\#\# 1 Introduction

\#\# “It’s not that we use a language to ex-

\#\# press our thoughts, but that we use a

\#\# language to understand our thoughts.”

\#\# – Donald Knuth

Large Language Models (LLMs) have made sig-  
nificant strides in automated code generation and  
comprehension (Feng et al., 2020; Rozière et al.,  
2023; Chaudhary, 2023; Hui et al., 2024a; Nijkamp  
et al., 2023a), enabling tasks like code comple-  
tion, bug fixing, and documentation. However,  
real-world software development involves com-  
plex repository-wide reasoning, including depen-  
dency understanding, project structures, and multi-  
file modifications (Wu et al., 2024a; Zhang et al.,  
2023b; Shrivastava et al., 2023a). While LLMs  
\*Corresponding author.

(^1) We provide code and datasets at https://github.com/ink7-  
sudo/DependEval.  
show potential in software engineering, their ability  
to handle large-scale repositories remains underex-  
plored.  
Existing benchmarks (Peng et al., 2024; Chai  
et al., 2024; Liu et al., 2023a; Cassano et al., 2023\)  
typically evaluate LLMs at the function or file level,  
often focusing on isolated code snippets. However,  
large software projects require an evaluation frame-  
work that captures repository-wide reasoning. Pre-  
vious benchmarks, such as SWE-bench (Jimenez  
et al., 2023), focus on bug fixing but neglect chal-  
lenges like dependency resolution, project construc-  
tion, and structured multi-file edits. Additionally,  
existing methods (Liu et al., 2023b; Zhang et al.,  
2023a; Ding et al., 2023\) lack fine-grained insights  
into model performance across repository reason-  
ing aspects.  
To address these limitations, we introduceDE-  
PENDEVAL, a hierarchical benchmark designed to  
evaluate LLMs’ ability to reason about structured  
code repositories through three progressively chal-  
lenging tasks: (1)Dependency Recognition: As-  
sessing the model’s ability to infer and resolve inter-  
file dependencies. (2)Repository Construction:  
Evaluating models on generating structured, mod-  
ular project layouts. (3)Multi-File Editing: Test-  
ing models’ ability to make coordinated changes  
across multiple files while maintaining consistency.  
Unlike existing benchmarks (Ding et al., 2023;  
Liu et al., 2023b),DEPENDEVALprovides fine-  
grained metrics for static analysis, architectural  
reasoning, and cross-file consistency.  
We evaluateDEPENDEVALwith 25+ LLMs,  
making the following key contributions:

\- DEPENDEVALis the first multilingual bench-  
    mark with over 2,500 cases designed for hier-  
    archical assessment of repository-scale under-  
    standing in LLMs, enabling a comprehensive  
    evaluation of LLMs’ understanding capabili-  
    ties at the code repository level.  
7150

\- It provides fine-grained metrics, enabling de-  
    tailed analysis of repository reasoning capa-  
    bilities.  
\- Larger models tend to perform better, partic-  
    ularly on complex cross-file reasoning tasks,  
    but performance gains diminish as task com-  
    plexity increases, suggesting that scaling  
    alone is not enough for mastering repository-  
wide code comprehension.  
\- Experiment analysis shows that LLMs strug-  
    gle with key challenges in large-scale soft-  
ware development, such as dependency pars-  
ing, function call inference, and maintaining  
consistency across file modifications, high-  
lighting key challenges in applying LLMs to  
large-scale software development.

\#\# 2 Related Work

Code Large Language Models. The rapid ad-  
vancement of generative language models has  
spurred extensive research on AI applications in  
software engineering (Black et al., 2022; Brown  
et al., 2020; Radford et al., 2019; Touvron et al.,  
2023). Models (Achiam et al., 2023; Chen et al.,  
2021; Chowdhery et al., 2023; Nijkamp et al.,  
2023b,c; Li et al., 2023; Lozhkov et al., 2024;  
Roziere et al., 2023; Guo et al., 2024b) have demon-  
strated significant performance improvements on  
various code-related tasks. These advancements  
have accelerated the development of code assistant  
tools like Copilot^2 , TONGYI Lingma (Hui et al.,  
2024a), and Cursor^3.  
Repository-level Code Evaluation. Recent  
repository-level code benchmarks (Allal et al.,  
2023; Liu et al., 2023c; Shrivastava et al., 2023b;  
Zhang et al., 2023b; Ding et al., 2023; Liu et al.,  
2024; Allal et al., 2023; Liu et al., 2023b) assess  
code LLMs’ capabilities at various granularities,  
from individual lines and API calls to full func-  
tion implementations. SWE-Bench (Jimenez et al.,  
2023\) challenges LLMs with real-world scenarios  
using issues and pull requests from popular Python  
repositories on GitHub, while DevBench (Li et al.,  
2024a) breaks the development process into stages  
to evaluate AI performance at each step. How-  
ever, these datasets often neglect detailed reposi-  
tory code understanding. Most difficulty catego-  
rizations focus on the number of files involved,

(^2) https://github.com/features/copilot  
(^3) https://www.cursor.com/  
overlooking the internal structure and semantic  
context within projects. To better evaluate multi-  
lingual, repository-based code understanding,DE-  
PENDEVALextends to 8 programming languages  
and includes three designed tasks. The detailed  
comparison is in Table 1\.  
Benchmark Task Scope Languages\#Repo  
MBPP (Austin et al., 2021)HumanEval (Liu et al., 2023a) Code GenerationCode Generation FunctionFunction 11 N/AN/A  
ClassEval (Du et al., 2023)RepoEval (Zhang et al., 2023c) Code GenerationCode Completion ClassRepo-level 11 N/A 14  
RepoBench (Liu et al., 2023b)CrossCodeEval (Ding et al., 2023\) Retrieval & CompletionCode Completion Repo-levelRepo-level 24 1,6691,  
EvoCodeBench (Li et al., 2024b)RepoMasterEval (Wu et al., 2024b)Code GenerationCode Completion Repo-levelRepo-level (^12256)  
DEPENDEVAL Hierarchical Dependency ReasoningRepo-level 8 2,  
Table 1: Comparison of features between existing bench-  
marks andDEPENDEVAL

\#\# 3 DependEval

\`\`\`  
3.1 Overview  
DependEval is a multi-language benchmark span-  
ning eight programming languages (C, C++, C\#,  
TypeScript, JavaScript, Java, PHP, and Python) to  
evaluate the capability of large language models  
(LLMs) in three hierarchical understanding tasks  
in Figure 7\. We propose three tasks—Dependency  
Recognition, Repository Construction, and Multi-  
file Editing. Dependency Recognitionreflects  
whether a model can infer the invocation order  
between files, which is crucial for resolving ref-  
erences and ensuring the correct program flow.  
Repository Constructionevaluates the model’s  
ability to organize code structure from natural lan-  
guage requirements, testing architectural reasoning.  
Multi-file Editingsimulates real-world develop-  
ment scenarios where modifications span multiple  
files, requiring models to maintain semantic and  
dependency consistency across components.  
\`\`\`  
\`\`\`  
3.2 Data Collection and Filtering  
Our data comes from real-world GitHub reposito-  
ries, ensuring authenticity and practical relevance  
for evaluating code understanding tasks. We collect  
multilingual repositories in languages such as C,  
C++, C\#, TypeScript, JavaScript, Java, PHP, and  
Python, using GitHub’s official API to crawl repos-  
itories and their README files. These are selected  
from open-source repositories created before De-  
cember 16, 2024, with a focus on those with the  
highest star counts (e.g., above 50 stars) and exclud-  
ing forks to mitigate data leakage and ensure qual-  
ity. We apply filtering rules similar to Deepseek-  
Coder (Guo et al., 2024a) to remove lower-quality  
\`\`\`

\`\`\`  
Analyze the project  
description. Generate a  
project structure that shows the dependencies  
between files.  
\`\`\`  
\`\`\`  
Analyze the project  
description. Generate a  
project structure that shows the dependencies  
between files.  
\`\`\`  
\`\`\`  
Analyze their content  
and determine the  
dependency relationship between files.  
\`\`\`  
\`\`\`  
Analyze their content  
and determine the  
dependency relationship between files.  
\`\`\`  
\`\`\`  
Add an option to save the  
displayed images to disk.  
Add an option to save the  
displayed images to disk.  
\`\`\`  
\`\`\`  
Repository ConstructionRepository Construction Dependency RecognitionDependency Recognition MultiMulti--file Editingfile Editing  
\`\`\`  
\`\`\`  
\[ip\_basic/dataset\_sparsity.py\],  
\[ip\_basic/depth\_completion.py\],  
\[depth\_map.py\] \[depth\_completion.py\]  
\`\`\`  
\`\`\`  
import ip\_basic cv2 /vis\_utils.py  
defcv2\_show\_image():...  
from ip ip\_basic \_basic/depth importvis\_ \_completion utils .py  
vis\_utils.cv2\_show\_image(...)  
\`\`\`  
\`\`\`  
\[ip\_basic/vis\_utils.py,  
ip\_basic/depth\_completion.py\]  
\`\`\`  
\`\`\`  
Construction Graph Dependency Detection  
\`\`\`  
\`\`\`  
import ip\_basic cv2 /vis\_utils.py  
defcv2\_show\_image():...  
from ip ip\_basic \_basic/depth importvis\_ \_completion utils .py  
vis\_utils.cv2\_show\_image(...)  
\`\`\`  
\`\`\`  
ip\_basic/vis\_utils.py  
import\# Aftercv  
defcv2\_show\_image(..., if save\_path: cv2.imwrite(save\_pathsave\_path=None, image)):  
ip\_basic/depth\_completion.py  
from\# Afterip\_basicimportvis\_utils  
save\_pathvis\_utils.cv2\_show\_image(..., \= 'process/' \+ key \+ '.pngsave\_path=save\_path)  
\`\`\`  
\`\`\`  
"Image Processing for Basic Depth Completion"^ {“{ “^ A Python module that provides"file": "file”: "depth\_completion.py"vis\_utils.py","function": .... }...”},  
\`\`\`  
\`\`\`  
DDescription:escription: FFiles:iles:  
\`\`\`  
\`\`\`  
\`\`\`  
\`\`\`  
Code Modify  
\`\`\`  
\`\`\`  
Figure 1: Overview ofDEPENDEVAL. It contains 3 tasks including Repository Construction, Dependency  
Recognition, and Multi-file Editing. The first task analyzes the project description to generate a structure showing  
the dependencies between files. The second task identifies the content of the files to determine the relationships  
between them. Finally, the third task modifies the code to add functionality for saving displayed images to disk.  
\`\`\`  
code. Additionally, we filter READMEs based on  
structural integrity, practical utility, and content  
clarity. Detailed filtering criteria can be seen in  
Appendix B. After filtering and removing dupli-  
cates, we retain 15,576 high-quality repositories  
and README files.

\`\`\`  
3.3 Dependency Code Snippets Generation  
\`\`\`  
After downloading repositories from GitHub, we  
concatenate interdependent code files into snippets  
based on their dependency relationships. This in-  
volves parsing each file for import statements to  
identify internal module dependencies. Details on  
the import expressions considered for each lan-  
guage are provided in Appendix A. Call chains and  
code snippets are generated by selecting a starting  
file and appending its dependent files in reference  
order. Multiple call chains of varying lengths can  
be extracted from each repository, capturing both  
short and long inter-file relationships. In addition  
to the filtering criteria in Section 3.2, we exclude  
repositories that fail to cover all dependencies or  
do not pass integrity checks, ensuring only valid,  
self-contained code fragments are included.

\`\`\`  
3.4 Task Construction  
3.4.1 Dependency Recognition  
Task Settings. The Dependency Recognition  
task is designed to evaluate the model’s ability to  
accurately identify and understand the calling rela-  
\`\`\`  
\`\`\`  
tionships between files within a codebase. Given  
a set of code filesF, with dependency relationsD  
extracted as described in Section 3.3, we define the  
set of dependencies as:  
\`\`\`  
\`\`\`  
D  
△  
\={(fi,fj)|fidirectly invokesfj}. (1)  
\`\`\`  
\`\`\`  
The model is required to generate a unique or-  
dered listP \= \[p 1 ,p 2 ,...,pn\], wherepi ∈ F,  
such that:  
\`\`\`  
\`\`\`  
∀(fi,fj)∈D, π−^1 (fj)\< π−^1 (fi), (2)  
\`\`\`  
\`\`\`  
where the output listPmust respect all dependen-  
cies inD. Here,π−^1 (f)denotes the position of file  
fin the listP.  
3.4.2 Repository Construction  
Task Settings. The Repository Construction task  
evaluates the ability of LLMs to generate a coher-  
ent file structure based on natural language require-  
ments and file names with functional descriptions.  
Given natural language requirementsRand a set  
of filesF={f 1 ,f 2 ,...,fn}with functional de-  
scriptionsD={d 1 ,d 2 ,...,dn}, the inputXis:  
\`\`\`  
\`\`\`  
X  
△  
\= (R,{(fi,di)}ni=1), (3)  
\`\`\`  
\`\`\`  
whereR is the requirement, and each (fi,di)  
pair represents a file fi and its descriptiondi.  
The model generates a set of valid ordered lists  
\`\`\`

\`\`\`  
Step1 : Data Crawling and Filtering  
\`\`\`  
\`\`\`  
... Repositories  
Dependency  
parser  
\`\`\`  
\`\`\`  
Step4 : Evaluation  
\`\`\`  
\`\`\`  
Step2 : Dependency Snippets Generation  
\`\`\`  
\`\`\`  
b.py  
\`\`\`  
\`\`\`  
b  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
d  
e f  
\`\`\`  
\`\`\`  
Dependency  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
b concat  
c  
\`\`\`  
\`\`\`  
concat  
\`\`\`  
\`\`\`  
a  
b  
c  
...  
\`\`\`  
\`\`\`  
Step3 : Test Sample Generation  
\`\`\`  
\`\`\`  
Task1:Dependency Recognition  
\`\`\`  
\`\`\`  
Task2:Repository Construction  
\`\`\`  
\`\`\`  
Task3: Multi-file Editing  
\`\`\`  
\`\`\`  
Features to be added  
Multi-file Code  
Snippets  
\`\`\`  
\`\`\`  
Modified Code  
\`\`\`  
\`\`\`  
\[b.py, c.py\]  
\`\`\`  
\`\`\`  
Code Snippet  
b concat  
c  
\`\`\`  
\`\`\`  
LLM  
Human Review  
.py  
\`\`\`  
\`\`\`  
bc  
\`\`\`  
\`\`\`  
abc  
...  
\`\`\`  
\`\`\`  
LLM  
Human Review  
\`\`\`  
\`\`\`  
Task  
\`\`\`  
\`\`\`  
Task  
\`\`\`  
\`\`\`  
...  
\[a.py, c.py, d.py\]  
\`\`\`  
\`\`\`  
\[a.py, b.py\] Graph Construction  
Graph Match F1 Score^  
\`\`\`  
\`\`\`  
\[b.py, c.py\] Exact Match  
\`\`\`  
\`\`\`  
Called Code Segment: Invoking Code Segment:  
Modified Complete Code:  
\`\`\`  
\`\`\`  
Task  
\`\`\`  
\`\`\`  
LLM Judge  
\`\`\`  
\`\`\`  
Reference  
\`\`\`  
\`\`\`  
Evaluation on LLMs  
\`\`\`  
\`\`\`  
Input Data CurationOutput ExampleGround Truth  
\`\`\`  
\`\`\`  
...  
import a  
...  
\`\`\`  
\`\`\`  
Project Requirements  
File names: Function Description  
\`\`\`  
\`\`\`  
\[a.py, b.py, d.py\]  
\`\`\`  
\`\`\`  
\[b.py, c.py\]  
...  
\`\`\`  
\`\`\`  
75 C  
C++  
\`\`\`  
\`\`\`  
C\#  
\`\`\`  
\`\`\`  
Python  
Java  
\`\`\`  
\`\`\`  
PHP  
\`\`\`  
\`\`\`  
Typescript  
\`\`\`  
\`\`\`  
Javascript  
\`\`\`  
\`\`\`  
Figure 2: Pipeline for data curation ofDEPENDEVAL. It consists of four steps: data crawling and filtering (Step 1),  
dependency snippet generation (Step 2), test sample generation for dependency recognition (Step 3), and evaluation  
using metrics like Exact Match and Graph Match F1 Score (Step 4).  
\`\`\`  
\`\`\`  
P \= {P 1 ,P 2 ,...,Pm}, where each listPi \=  
\[pi 1 ,pi 2 ,...,pin\]consists of filespij ∈ F, with  
each filepijbeing invoked or depended upon by  
the subsequent filepi(j+1).  
\`\`\`  
Sample Curation. The construction process be-  
gins by extracting complete dependency relation-  
ships from the repository to identify invocation  
chains, which serve as the ground truth for evalu-  
ation. We filter repositories to include only those  
with fewer than 12 invocation chains, ensuring all  
files are comprehensively covered. Next, GPT-  
processes the README and individual code files  
to generate a natural language requirement, includ-  
ing an overall repository description and functional  
descriptions for each file. Detailed prompt is in  
Appendix E.1.

Human in the Loop. Finally, human review se-  
lects the final set of samples. We evaluate the  
generated natural language requirements based on  
criteria such as the coherence and completeness  
of repository descriptions, accuracy of functional  
descriptions, and correctness of reflected depen-  
dency relationships. Detailed criteria are provided  
in Appendix C.1. We also ensure a diverse range  
of topic types in the selected repositories to rep-  
resent real-world scenarios, with further details in  
Appendix D.

\`\`\`  
3.4.3 Multi-file Editing  
Task Settings The Multi-file Editing task eval-  
uates the model’s ability to add new functional-  
ities across multiple files while preserving inter-  
file dependencies. Given a set of filesC \=  
{f 1 ,f 2 ,...,fm}, where eachfiis invoked byfi+1,  
and a functionality requirementR, the task involves  
two scenarios:  
\`\`\`  
\- In-place Edits: Modify the existing filesC  
    to incorporateR, while maintaining inter-  
    dependencies, resulting in a new setCnew=  
    {f 1 ′,f 2 ′,...,fm′}.  
\- Expansion Edits: ModifyCand create a new  
    filefnewto integrateR, resulting in an ex-  
    panded setCnew={f 1 ′,f 2 ′,...,fm′}∪{fnew},  
    ensuring proper invocation relationships.

\`\`\`  
This approach reflects real-world scenarios where  
AI-driven code editors like Cursor^4 help developers  
modify multiple files based on natural language  
requirements.  
\`\`\`  
\`\`\`  
Sample Curation. We concatenate files from in-  
vocation chains of lengths 2, 3, and 4, then input  
\`\`\`  
(^4) Cursor is an AI-powered code editor designed to assist  
developers.https://www.cursor.com/

\`\`\`  
Task \# Examples Avg. \# Input Tokens Avg. \# Output Tokens  
Subtask C C++ C\# Java PHP Python JavaScript TypeScript  
Multi-file Editing (In-place Edits)  
Chain Length 2 30 38 49 42 49 60 58 42 21453 4832  
Chain Length 3 53 35 34 33 37 50 33 33 28634 5424  
Chain Length 4 39 38 33 33 60 24 32 28 32423 6367  
Multi-file Editing (Expansion Edits) Chain Length 2Chain Length 3^44354521235442413833453849364234213552554273197844  
Sub-total 201 177 193 191 217 217 208 187 \- \-  
Dependency Recognition \- 180 180 180 180 180 180 180 180 12549 232  
Repository Construction \- 58 49 41 52 57 58 45 36 3247 341  
Total 439 406 414 423 454 455 433 403 20742 4617  
\`\`\`  
\`\`\`  
Table 2: Statistic ofDEPENDEVAL. This table shows the number of examples and average token counts for each  
task and subtask across different programming languages.  
\`\`\`  
\`\`\`  
these code snippets into GPT-4o. Using a step-  
by-step prompt, GPT-4o identifies cross-file inter-  
actions, proposes new features, and generates the  
corresponding modified code, including feature de-  
scriptions and explanations. Sample outputs for  
different invocation lengths and scenarios are pro-  
vided in Appendix E.2.  
\`\`\`  
Human in the Loop. We first apply an LLM-  
based filtering process to pre-select samples, ensur-  
ing basic quality and consistency with the task.  
GPT-4o evaluates samples based on predefined  
criteria, such as clarity of the feature description  
and logical implementation. Human annotators  
then manually review and correct the pre-selected  
samples, verifying the correctness of descriptions,  
logic, and code consistency. Annotators also ensure  
that errors in GPT-4o-generated code are corrected,  
curating gold labels for evaluation. Details about  
the process and our crowdsourcing can be found in  
Appendix C.2 and Appendix G, respectively.

3.5 Features of DEPENDEVAL  
Statistic. We present the statistic ofDEPENDE-  
VALin Table 2\. We use the Qwen2.5-Coder (Hui  
et al., 2024b) tokenizer to compute the number of  
tokens. After the filtering and curation process, our  
test samples cover a total of 2,683 real-world repos-  
itories. Length distribution ofDEPENDEVALis in  
Figure 3\. More results about project topics are in  
Appendix D.

\`\`\`  
Future Extensions. DEPENDEVAL currently  
supports 8 popular languages. In addition to re-  
leasing our test samples on GitHub, we have also  
open-sourced all the scripts used for crawling and  
curating these samples. Therefore,DEPENDEVAL  
can potentially be extended to other languages and  
the community to use our tools to create more sam-  
ples as needed.  
\`\`\`  
(^00500010000) Sample String Length 15000 20000 25000 30000  
50  
100  
150  
200  
Frequency  
\-75-  
\+  
\+  
\+42+41+  
\+  
\-4-  
\+12+25+27+22+  
\-9-19-

\-  
    \-

\`\`\`  
Sample String Length Distribution in task2\_c.json Mean Frequency  
\`\`\`  
\`\`\`  
Figure 3: Length Distribution ofDEPENDEVAL.  
\`\`\`  
\#\# 4 Experiments

\`\`\`  
4.1 Models  
We evaluate over 25 models, ranging from 1.5B  
to 670B+ parameters, including both open-source  
large language models and closed-source general  
LLMs. For general models, we test GPT-4o-  
mini (OpenAI, 2023), Claude series (Anthropic,  
2023), Phi series (Abdin et al., 2024a,b), PaLM2-  
CodeChat (Anil et al., 2023), Llama3.3^5 , and  
Qwen2.5 (Qwen et al., 2025). For code models, we  
evaluate CodeLlama (Rozière et al., 2023), Open-  
Coder (Huang et al., 2024), Qwen-Coder (Hui et al.,  
2024a), DeepSeekCoder (Guo et al., 2024a), Code-  
Stral (MistralAI, 2024), Yi-Coder^6 , and Granite-  
Coder (Mishra et al., 2024).  
\`\`\`  
\`\`\`  
4.2 Implementation Details  
Our evaluation framework is built on the Trans-  
formers library (Wolf et al., 2020). We use a one-  
shot prompt for the Dependency Recognition and  
Repository Construction tasks, while the Multi-  
File Editing task is performed in a zero-shot set-  
ting, without additional training. All experiments  
are run on 16 NVIDIA A800-SXM4-80GB GPUs  
with the same hyperparameters for code generation  
across all models. Detailed settings and prompts  
are provided in Appendix E.3.  
\`\`\`  
(^5) https://ai.meta.com/blog/meta-llama-3/  
(^6) https://huggingface.co/01-ai/Yi-Coder-9B

\`\`\`  
Models DR RCC ME DR C++RC ME DR RCC\# ME DRPythonRC ME DR JavaRC ME DR PHPRC ME DRTypescriptRC ME DRJavascriptRC ME Avg.-  
Open-Source Large Language Models (1.5B+)  
OpenCoder-1.5B-InstructYi-Coder-1.5B-Chat 7.413.9511.239.03 0.457.39 10.641.5911.939.62 13.240.57 4.844.62 5.689.58 0.017.63 10.344.55 21.488.8016.664.34 0.000.00 2.836.98 0.359.761.452.17 14.5215.96 2.267.708.472.04 10.7310.98 0.507.92 2.173.66 4.9312.73 0.018.17 5.098.  
Qwen2.5-Coder-3B-InstructQwen2.5-Coder-3B 6.474.4627.345.23 3.624.64 11.859.4430.388.26 4.314.51 8.045.5915.195.72 3.334.66 13.738.93 46.3614.206.869.95 0.0010.0023.362.15 1.346.494.507.22 30.147.37 2.575.9811.765.59 24.305.52 5.803.55 6.459.55 27.456.51 10.618.30 13.486.  
Phi-3.5-mini-128k-instruct(3.82B)Granite-3b-code-instruct-128k 10.278.2217.633.43 4.971.31 13.389.7017.4115.84 8.762.01 13.489.1510.680.81 8.501.01 15.0711.1924.029.01 4.953.01 9.095.11 17.932.38 5.961.013.7017.2425.5813.06 2.580.778.4611.5121.795.76 5.571.01 7.0217.0522.385.98 6.621.42 11.576.  
Open-Source Large Language Models (7B+)  
CodeLlama-7b-Instruct-hfCodestral-mamba(7B) 9.228.0026.0918.2124.7913.2316.2211.8123.9418.0125.1013.25 9.166.2516.2710.2630.6412.6716.007.63 28.8330.4326.1418.4213.105.74 17.7716.9118.7912.674.004.00 33.9527.6718.6211.4311.689.52 28.3020.4112.7411.329.496.96 26.9821.0320.7310.12 19.5213.  
Granite-8b-code-instruct-128kYi-Coder-9B-Chat 15.852.4736.3312.8816.098.62 19.144.7348.0617.9710.5510.6311.465.1315.676.5212.876.02 13.676.94 28.8913.1321.0413.1013.605.22 25.1210.4813.3911.6112.506.02 35.5124.3612.609.7812.988.26 35.3716.2922.997.95 11.4510.8432.2918.9815.796.25 18.8111.  
Qwen2.5-Coder-7B-InstructQwen2.5-Coder-7B 12.4116.8523.3120.3017.587.39 14.1826.1622.3021.9013.2519.1811.8620.1112.147.6914.877.63 16.5028.8133.3219.3716.6619.230.0018.9917.7319.8013.189.768.8722.0132.7119.7115.317.7014.9130.8725.1015.9718.347.92 10.6124.1226.0619.0215.298.17 15.0219.  
CodeLlama-13b-Instruct-hfPhi-4(14B) 46.026.4133.5020.0923.6018.2353.706.7639.5921.0220.6321.2533.339.0914.5511.7423.6216.6749.2611.8833.0929.0431.9916.4231.077.79 26.1318.6413.9318.6735.637.02 21.6828.9715.418.4254.297.10 21.7621.9116.0013.3262.3210.3723.1825.6611.2713.21 30.6515.  
Qwen2.5-Coder-14B-InstructQwen2.5-Coder-14B 11.3811.38 6.896.89 13.6213.6213.2113.2113.2713.2714.3114.3113.8913.89 9.559.5513.3313.3317.3317.3339.3339.3316.8616.863.453.45 8.898.89 11.3411.343.803.80 3.353.35 12.5712.5713.2213.2214.1514.1515.8015.8012.5712.5718.6818.6818.3018.30 13.3026.  
Codestral-2501(24B) 37.7847.1229.4555.5644.7129.4040.5622.1231.0045.5661.1835.6237.2228.4227.4326.1134.0121.6257.7832.4131.0060.5633.6933.50 37\.  
Open-Source Large Language Models (32B+)  
Qwen2.5-Coder-32B-InstructCodeLlama-34b-Instruct-hf 52.228.7724.5949.4023.0030.2970.005.6223.8958.2731.0036.6742.781.4411.3924.0627.0041.0010.5661.1133.0146.9331.2837.122.6343.8920.5833.0426.3235.922.3750.5631.5337.4719.6714.713.7963.1323.8341.4717.3244.803.5557.2224.0235.9621.2340.36 17.8543.  
Llama-3.3-70b-instructQwen2.5-Coder-32B 15.8817.7817.2610.0023.509.49 25.7734.6418.2012.0033.4214.8818.8916.2911.3730.0225.8611.3821.669.44 23.2022.1023.1118.5420.512.22 13.0312.3017.0018.5214.5617.2226.6312.0020.458.9426.1413.8919.3710.0915.356.19 24.4039.6626.3018.1220.715.08 20.9415.  
DeepSeek-Coder-V2-Lite-Instruct(21/236B)Qwen-2.5-72b-instruct 43.898.9436.3321.4815.7224.8767.2211.6748.6125.2921.6028.6935.567.7816.3212.4937.2125.8651.1111.6741.3320.4522.9324.6140.5616.6715.4712.0233.0639.9743.3312.7827.5319.9632.1811.6765.5612.4329.6125.1519.2639.5961.6714.8629.8319.5017.8335.59 35.5720.  
DeepSeek-V3(37/671B) 68.5464.2536.9783.0563.1547.4654.7526.8541.2263.4867.8937.9948.3133.5144.3267.0551.5840.5483.3353.6543.6088.8353.1340.11 54\.  
Closed-Source Large Language Models (API)  
Claude-3.5-sonnet-20241022GPT-4o-mini-2024-07-18 52.7850.5663.1241.9042.0039.5555.5660.0066.0049.5957.0045.1730.0030.0027.9313.5643.7541.0625.5651.6761.9541.4355.8338.379.4437.7830.8131.1647.6744.9348.3347.1960.9225.7144.3325.7353.8951.6757.6228.6046.3342.8762.7860.0057.3826.0742.1239.78 47.6340.  
Palm-2-codechat-bisonGemini-1.5-flash-latest 52.788.8922.4952.1712.3736.4211.1758.3333.2956.1916.8044.4910.9836.6722.103.0320.8339.8858.899.60 10.6127.4925.4636.329.4437.782.6913.1014.1147.059.7135.0019.6229.4218.8233.249.7758.8916.2544.1416.1557.189.6657.7813.8235.9016.0546.88 14.2342.  
\`\`\`  
\`\`\`  
Table 3: Results of different models on theDEPENDEVAL. We utilize green(1st) blue(2nd) yellow(3rd) to  
distinguish the top three results within different sizes.  
\`\`\`  
\`\`\`  
(a)DR tasks (b)RC tasks (c)ME tasks  
\`\`\`  
\`\`\`  
Figure 4: Results of different tasks inDEPENDEVAL. The radar charts show the performance of various models  
across Dependency Recognition(a), Repository Construction(b), and Multi-file Editing(c) tasks. Each line represents  
a different model, with performance measured for different programming languages.  
\`\`\`  
\`\`\`  
4.3 Evaluation Metrics  
Dependency Recognition. For the Dependency  
Recognition task, we calculate theExact Match  
Rate(EMR), which measures the proportion of  
instances where the predicted dependency chain  
exactly matches the ground truth:  
\`\`\`  
\#\#\# EMR

\`\`\`  
△  
\=  
|{i|EMi= 1}|  
N  
\`\`\`  
\#\#\# (4)

where

\`\`\`  
EMi=  
\`\`\`  
\#\#\# {∑

\`\`\`  
j⊮(pj=gj)  
|Pi| , if|Pi|\>^0  
0 , otherwise  
\`\`\`  
\#\#\# (5)

\`\`\`  
Here,PiandGidenote the predicted and ground-  
truth dependency sets, and⊮(·)is an indicator func-  
tion, capturing the proportion of fully correct pre-  
dictions.  
Repository Construction. For Repository Con-  
struction, we evaluate structural similarity by com-  
paring the predicted and ground-truth dependency  
graphs. Given a set of predicted file invoca-  
tion chains, we construct a directed graphGp=  
(Vp,Ep)and similarly for the ground-truth graph  
Gg= (Vg,Eg). We then compute precision, recall,  
and F1-score for both nodes and edges:  
\`\`\`  
\`\`\`  
F1=  
2 ×Precision×Recall  
Precision+Recall  
\`\`\`  
\#\#\# (6)

\`\`\`  
Finally, we combine node and edge F1-scores (i.e.  
F1nand F1e) as follows:  
\`\`\`  
\`\`\`  
F1com=w 1 ×F1n+w 2 ×F1e, (7)  
\`\`\`  
wherew 1 andw 2 are empirically set to 0\. 15 and  
0\. 85 , respectively.

Multi-file Editing. Inspired by FairEval (Wang  
et al., 2023\) to reduce bias in LLMs as judge mod-  
els, we prompt the large language model (LLM),  
denoted asLLM(·), to evaluate the correctness and  
completeness of multi-file edits. The LLM com-  
pares the generated code with the corrected ver-  
sion provided by human annotators in section 3.4.3.  
We define the following metrics: Correctness (C):  
Measures how accurately the files meet the ex-  
pected functionality. Purpose Alignment (PA):  
Assesses how well the code aligns with its intended  
purpose. Functionality Accuracy (FA): Evalu-  
ates the accuracy of the functionality across files.  
Functionality Completeness (FC): Checks if all re-  
quired aspects of functionality are addressed. Code  
Quality (CQ): Reflects the overall quality of the  
code. The detailed prompts are in Appendix E.4.  
The combined score is calculated as:

\`\`\`  
Score=λ 1 ·LLM(C)+λ 2 ·LLM(PA)  
\+λ 3 ·LLM(FA)+λ 4 ·LLM(FC)  
\+λ 5 ·LLM(CQ),  
\`\`\`  
\#\#\# (8)

where the weighting parameters are empirically set  
as follows:λ 1 \=λ 2 \= 0\. 25 ,λ 3 \=λ 4 \= 0\. 20 , and  
λ 5 \= 0\. 10\.

4.4 Main Results  
In the following discussions, we will refer to spe-  
cific tasks using the following abbreviations: ME  
(Multi-file Editing), DR (Dependency Recogni-  
tion), and RC (Repository Construction).

4.4.1 Overall Evaluation  
Model Size & Type and Performance. Larger  
models generally outperform smaller ones,  
as seen in open-source architectures like  
Codellama-34B-InstructandQwen-Coder-32B,  
which consistently show better performance  
than their smaller counterparts. This suggests  
that increasing model capacity enhances the  
ability to manage complex dependency rela-  
tionships in code repositories. Interestingly,  
Qwen-Coder-32B surpasses larger general  
models like Llama-3.3-70b-instruct and

\`\`\`  
Qwen-2.5-72b-instruct, highlighting that  
domain-specific training can be more effective  
than simply scaling model size. This implies that  
targeted pretraining on high-quality code datasets  
and instruction tuning for software engineering  
tasks are key to improving performance.  
\`\`\`  
\`\`\`  
Task-Specific. Larger models show clear ad-  
vantages in DR and RC tasks. For instance,  
DeepSeek-V3(37/671B) excels in DR, demon-  
strating strong ability to understand complex inter-  
file dependencies. However, Multi-file Editing re-  
mains a more intricate task, even larger models face  
challenges in maintaining consistency and accuracy  
across multiple files  
\`\`\`  
\`\`\`  
Language-Specific. Closed-source models gen-  
erally show more stable performance across lan-  
guages in the ME task. Performance also varies  
by language, with Python and JavaScript yielding  
better results, particularly in Dependency Recog-  
nition and Repository Construction tasks. In con-  
trast, languages like C\# and Java are more chal-  
lenging. Models perform better in languages with  
static, modular structures, while languages with  
complex interdependencies or dynamic features  
pose more difficulty for multi-file editing and de-  
pendency recognition.  
\`\`\`  
\`\`\`  
Closed-source vs. Open-source Models. On  
average, closed-source models outperform most  
open-source ones. However, DeepSeek-V3sur-  
passesClaude-3.5-sonnet-20241022, showing  
that top-tier open-source models remain compet-  
itive. While models likeQwen2.5-Coder-32B  
and DeepSeek-V3 excel in simpler tasks like  
DR, they struggle with more complex ones like  
ME. In contrast, closed-source models, especially  
Claude-3.5-sonnet-20241022, perform better in  
RC and ME, indicating stronger reasoning and gen-  
eralization abilities for multi-file editing and repos-  
itory understanding.  
\`\`\`  
\`\`\`  
4.4.2 Takeaways from Task-specific  
Evaluation  
Dependency Relationships are Crucial for ME.  
Models strong in Dependency Recognition excel  
in Multi-file Editing. This correlation shows that  
capturing and modifying dependencies is key to ac-  
curate, consistent changes across large codebases.  
LLMs Struggle with Directory Structure.LLMs  
may lack the prior knowledge needed to effectively  
organize hierarchical project structures, which is  
\`\`\`

reflected in the generally lower RC scores com-  
pared to DR. To improve performance, incorpo-  
rating more structured code repositories into the  
training data could help LLMs learn better patterns  
for organizing directory structures.  
Cross-File Modifications Remain Challenging.  
Even closed-source models struggle with cross-file  
modifications in ME, requiring better consistency  
and a global view across files. Improving training  
with real-world ME examples could help.

\#\# 5 Analysis

\`\`\`  
5.1 Multilingual Analysis  
Figure 4 shows the performance of various models  
across multiple programming languages for three  
tasks. We selected the top two models for each  
parameter range. Key insights include as follows.  
LLMs struggle with statically typed languages.  
In Dependency Recognition and Repository Con-  
struction, languages like Python, JavaScript, and  
TypeScript perform better due to their clear mod-  
ular structures and explicit imports. In contrast,  
PHP and C\# present challenges with flexible file  
inclusion and complex project files, respectively.  
Intricate interdependencies challenge multi-file  
editing (ME).Models perform worse in C and  
C++, where complex cross-file modifications are  
needed, like pointer tracking and header updates.  
Languages such as Python and Java, with struc-  
tured class designs, perform better in ME.  
\`\`\`  
5.2 Instruction Following  
Language-wise Analysis. In Figure 5\.  
deepseek-chat is the strongest model over-  
all, demonstrating its strong adaptability across  
various programming languages. More complex  
languages, such as C++ and PHP, pose challenges  
for all models. Most models show weaker  
instruction-following abilities in these languages,  
indicating poor understanding and execution  
capabilities. In contrast, languages like JavaScript  
and Python are relatively easier to process,  
resulting in higher instruction-following rates for  
these languages.  
Task-wise Analysis. In Figure 6\. At the task  
level,deepseek-chatsignificantly outperforms  
other models, showcasing its efficient handling  
of multiple tasks. Most models perform well on  
theRepository ConstructionandDependency  
Recognitiontasks, which are relatively easier as  
they mainly focus on file relationships and de-

\`\`\`  
Figure 5: Instruction-following performance covering 8  
different languages.  
\`\`\`  
\`\`\`  
0  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
1  
\`\`\`  
\`\`\`  
Instruction Following Rate  
\`\`\`  
\`\`\`  
Multi-file Editing Dependency Recognition Repository Construction  
\`\`\`  
\`\`\`  
Figure 6: Instruction-following performance covering 3  
different tasks.  
pendencies. On the other hand, theMulti-file  
Editingtask is more challenging, requiring mod-  
els to simultaneously understand modifications  
across multiple files and their collaboration, which  
leads to poorer performance for some models.  
\`\`\`  
\#\# 6 Conclusion

\`\`\`  
We introduceDEPENDEVAL, a benchmark de-  
signed to evaluate the repository-level dependency  
understanding of LLMs. Built on a diverse set  
of 15,576 real-world repositories, the benchmark  
covers three key tasks: Dependency Recognition,  
Repository Construction, and Multi-file Editing,  
across eight programming languages. Our evalu-  
ation of over 25 LLMs reveals significant perfor-  
mance gaps, highlighting the difficulties models  
face when managing complex code repositories.  
These insights point to the need for LLMs to im-  
prove their handling of dependencies, project struc-  
tures, and multi-file modifications. Our work sets  
the stage for future advancements in enhancing the  
repository-level reasoning capabilities of LLMs.  
\`\`\`

\#\# 7 Limitations

Not Enough Languages. WhileDEPENDEVAL  
evaluates models across 8 programming languages,  
this scope is limited and may not fully capture the  
performance of models in other popular or emerg-  
ing languages. Expanding the range of supported  
languages will provide a more comprehensive eval-  
uation of LLMs’ capabilities across diverse coding  
environments.  
Not Enough Tasks. Currently, the benchmark fo-  
cuses on three core tasks: Dependency Recognition,  
Repository Construction, and Multi-file Editing.  
While these tasks are crucial, they do not encom-  
pass all the challenges faced in real-world software  
development. Including additional tasks such as  
debugging, code refactoring, or performance opti-  
mization would offer a more complete assessment  
of LLMs in software engineering contexts.  
Not Enough Models. Although we evaluate over  
25 models, this number is not sufficient to represent  
the full range of LLMs available, particularly as  
new models continue to emerge. Expanding the  
model pool would provide deeper insights into the  
performance of various model architectures and  
sizes, ensuring a more robust evaluation.  
Future Updates. As the field of large language  
models evolves,DEPENDEVALwill be updated to  
include more languages, tasks, and models. This  
will help ensure the benchmark remains relevant  
and continues to provide valuable insights into the  
growing capabilities of LLMs in handling complex  
software engineering tasks.

\#\# References

\`\`\`  
Marah Abdin, Jyoti Aneja, Hany Awadalla, Ahmed  
Awadallah, Ammar Ahmad Awan, Nguyen Bach,  
Amit Bahree, Arash Bakhtiari, Jianmin Bao, Harkirat  
Behl, Alon Benhaim, Misha Bilenko, Johan Bjorck,  
Sébastien Bubeck, Martin Cai, Qin Cai, Vishrav  
Chaudhary, Dong Chen, Dongdong Chen, Weizhu  
Chen, Yen-Chun Chen, Yi-Ling Chen, Hao Cheng,  
Parul Chopra, Xiyang Dai, Matthew Dixon, Ro-  
nen Eldan, Victor Fragoso, Jianfeng Gao, Mei Gao,  
Min Gao, Amit Garg, Allie Del Giorno, Abhishek  
Goswami, Suriya Gunasekar, Emman Haider, Jun-  
heng Hao, Russell J. Hewett, Wenxiang Hu, Jamie  
Huynh, Dan Iter, Sam Ade Jacobs, Mojan Javaheripi,  
Xin Jin, Nikos Karampatziakis, Piero Kauffmann,  
Mahoud Khademi, Dongwoo Kim, Young Jin Kim,  
Lev Kurilenko, James R. Lee, Yin Tat Lee, Yuanzhi  
Li, Yunsheng Li, Chen Liang, Lars Liden, Xihui  
Lin, Zeqi Lin, Ce Liu, Liyuan Liu, Mengchen Liu,  
\`\`\`  
\`\`\`  
Weishung Liu, Xiaodong Liu, Chong Luo, Piyush  
Madan, Ali Mahmoudzadeh, David Majercak, Matt  
Mazzola, Caio César Teodoro Mendes, Arindam Mi-  
tra, Hardik Modi, Anh Nguyen, Brandon Norick,  
Barun Patra, Daniel Perez-Becker, Thomas Portet,  
Reid Pryzant, Heyang Qin, Marko Radmilac, Liliang  
Ren, Gustavo de Rosa, Corby Rosset, Sambudha Roy,  
Olatunji Ruwase, Olli Saarikivi, Amin Saied, Adil  
Salim, Michael Santacroce, Shital Shah, Ning Shang,  
Hiteshi Sharma, Yelong Shen, Swadheen Shukla, Xia  
Song, Masahiro Tanaka, Andrea Tupini, Praneetha  
Vaddamanu, Chunyu Wang, Guanhua Wang, Lijuan  
Wang, Shuohang Wang, Xin Wang, Yu Wang, Rachel  
Ward, Wen Wen, Philipp Witte, Haiping Wu, Xiaoxia  
Wu, Michael Wyatt, Bin Xiao, Can Xu, Jiahang Xu,  
Weijian Xu, Jilong Xue, Sonali Yadav, Fan Yang,  
Jianwei Yang, Yifan Yang, Ziyi Yang, Donghan Yu,  
Lu Yuan, Chenruidong Zhang, Cyril Zhang, Jianwen  
Zhang, Li Lyna Zhang, Yi Zhang, Yue Zhang, Yu-  
nan Zhang, and Xiren Zhou. 2024a. Phi-3 technical  
report: A highly capable language model locally on  
your phone.Preprint, arXiv:2404.14219.  
Marah Abdin, Jyoti Aneja, Harkirat Behl, Sébastien  
Bubeck, Ronen Eldan, Suriya Gunasekar, Michael  
Harrison, Russell J. Hewett, Mojan Javaheripi, Piero  
Kauffmann, James R. Lee, Yin Tat Lee, Yuanzhi  
Li, Weishung Liu, Caio C. T. Mendes, Anh Nguyen,  
Eric Price, Gustavo de Rosa, Olli Saarikivi, Adil  
Salim, Shital Shah, Xin Wang, Rachel Ward, Yue  
Wu, Dingli Yu, Cyril Zhang, and Yi Zhang. 2024b.  
Phi-4 technical report.Preprint, arXiv:2412.08905.  
Josh Achiam, Steven Adler, Sandhini Agarwal, Lama  
Ahmad, Ilge Akkaya, Florencia Leoni Aleman,  
Diogo Almeida, Janko Altenschmidt, Sam Altman,  
Shyamal Anadkat, et al. 2023\. Gpt-4 technical report.  
Loubna Ben Allal, Raymond Li, Denis Kocetkov,  
Chenghao Mou, Christopher Akiki, Carlos Munoz  
Ferrandis, Niklas Muennighoff, Mayank Mishra,  
Alex Gu, Manan Dey, et al. 2023\. Santa-  
coder: don’t reach for the stars\! arXivpreprint  
arXiv:2301.03988.  
Rohan Anil, Andrew M. Dai, Orhan Firat, Melvin John-  
son, Dmitry Lepikhin, Alexandre Passos, Siamak  
Shakeri, Emanuel Taropa, Paige Bailey, Zhifeng  
Chen, Eric Chu, Jonathan H. Clark, Laurent El  
Shafey, Yanping Huang, Kathy Meier-Hellstern, Gau-  
rav Mishra, Erica Moreira, Mark Omernick, Kevin  
Robinson, Sebastian Ruder, Yi Tay, Kefan Xiao,  
Yuanzhong Xu, Yujing Zhang, Gustavo Hernandez  
Abrego, Junwhan Ahn, Jacob Austin, Paul Barham,  
Jan Botha, James Bradbury, Siddhartha Brahma,  
Kevin Brooks, Michele Catasta, Yong Cheng, Colin  
Cherry, Christopher A. Choquette-Choo, Aakanksha  
Chowdhery, Clément Crepy, Shachi Dave, Mostafa  
Dehghani, Sunipa Dev, Jacob Devlin, Mark Díaz,  
Nan Du, Ethan Dyer, Vlad Feinberg, Fangxiaoyu  
Feng, Vlad Fienber, Markus Freitag, Xavier Gar-  
cia, Sebastian Gehrmann, Lucas Gonzalez, Guy Gur-  
Ari, Steven Hand, Hadi Hashemi, Le Hou, Joshua  
Howland, Andrea Hu, Jeffrey Hui, Jeremy Hur-  
witz, Michael Isard, Abe Ittycheriah, Matthew Jagiel-  
\`\`\`

\`\`\`  
ski, Wenhao Jia, Kathleen Kenealy, Maxim Krikun,  
Sneha Kudugunta, Chang Lan, Katherine Lee, Ben-  
jamin Lee, Eric Li, Music Li, Wei Li, YaGuang Li,  
Jian Li, Hyeontaek Lim, Hanzhao Lin, Zhongtao Liu,  
Frederick Liu, Marcello Maggioni, Aroma Mahendru,  
Joshua Maynez, Vedant Misra, Maysam Moussalem,  
Zachary Nado, John Nham, Eric Ni, Andrew Nys-  
trom, Alicia Parrish, Marie Pellat, Martin Polacek,  
Alex Polozov, Reiner Pope, Siyuan Qiao, Emily Reif,  
Bryan Richter, Parker Riley, Alex Castro Ros, Au-  
rko Roy, Brennan Saeta, Rajkumar Samuel, Renee  
Shelby, Ambrose Slone, Daniel Smilkov, David R.  
So, Daniel Sohn, Simon Tokumine, Dasha Valter,  
Vijay Vasudevan, Kiran Vodrahalli, Xuezhi Wang,  
Pidong Wang, Zirui Wang, Tao Wang, John Wiet-  
ing, Yuhuai Wu, Kelvin Xu, Yunhan Xu, Linting  
Xue, Pengcheng Yin, Jiahui Yu, Qiao Zhang, Steven  
Zheng, Ce Zheng, Weikang Zhou, Denny Zhou, Slav  
Petrov, and Yonghui Wu. 2023\. Palm 2 technical  
report.Preprint, arXiv:2305.10403.  
\`\`\`  
Anthropic. 2023\. Introducing Claude.

Jacob Austin, Augustus Odena, Maxwell Nye, Maarten  
Bosma, Henryk Michalewski, David Dohan, Ellen  
Jiang, Carrie Cai, Michael Terry, Quoc Le, et al. 2021\.  
Program synthesis with large language models.arXiv  
preprintarXiv:2108.07732.

Sidney Black, Stella Biderman, Eric Hallahan, Quentin  
Anthony, Leo Gao, Laurence Golding, Horace  
He, Connor Leahy, Kyle McDonell, Jason Phang,  
Michael Pieler, Usvsn Sai Prashanth, Shivanshu  
Purohit, Laria Reynolds, Jonathan Tow, Ben Wang,  
and Samuel Weinbach. 2022\. GPT-NeoX-20B: An  
open-source autoregressive language model. In  
ProceedingsofBigScienceEpisode\#5–Workshop  
onChallenges\&Perspectives inCreatingLarge  
LanguageModels, pages 95–136, virtual+Dublin.  
Association for Computational Linguistics.

Tom B. Brown, Benjamin Mann, Nick Ryder, Melanie  
Subbiah, Jared Kaplan, Prafulla Dhariwal, Arvind  
Neelakantan, Pranav Shyam, Girish Sastry, Amanda  
Askell, Sandhini Agarwal, Ariel Herbert-Voss,  
Gretchen Krueger, Tom Henighan, Rewon Child,  
Aditya Ramesh, Daniel M. Ziegler, Jeffrey Wu,  
Clemens Winter, Christopher Hesse, Mark Chen, Eric  
Sigler, Mateusz Litwin, Scott Gray, Benjamin Chess,  
Jack Clark, Christopher Berner, Sam McCandlish,  
Alec Radford, Ilya Sutskever, and Dario Amodei.

2020\. Language models are few-shot learners. In  
AdvancesinNeuralInformationProcessingSystems  
33: Annual Conference on Neural Information  
ProcessingSystems2020,NeurIPS2020,December  
6-12,2020,virtual.

Federico Cassano, John Gouwar, Daniel Nguyen, Syd-  
ney Nguyen, Luna Phipps-Costin, Donald Pinckney,  
Ming-Ho Yee, Yangtian Zi, Carolyn Jane Anderson,  
Molly Q Feldman, et al. 2023\. Multipl-e: a scal-  
able and polyglot approach to benchmarking neu-  
ral code generation.IEEETransactionsonSoftware  
Engineering.

\`\`\`  
Linzheng Chai, Shukai Liu, Jian Yang, Yuwei Yin,  
Ke Jin, Jiaheng Liu, Tao Sun, Ge Zhang, Changyu  
Ren, Hongcheng Guo, et al. 2024\. Mceval: Mas-  
sively multilingual code evaluation.arXivpreprint  
arXiv:2406.07436.  
\`\`\`  
\`\`\`  
Sahil Chaudhary. 2023\. Code Alpaca: An instruction-  
following LLaMA model for code generation.  
\`\`\`  
\`\`\`  
Mark Chen, Jerry Tworek, Heewoo Jun, Qiming  
Yuan, Henrique Ponde De Oliveira Pinto, Jared Ka-  
plan, Harri Edwards, Yuri Burda, Nicholas Joseph,  
Greg Brockman, et al. 2021\. Evaluating large  
language models trained on code. arXivpreprint  
arXiv:2107.03374.  
\`\`\`  
\`\`\`  
Aakanksha Chowdhery, Sharan Narang, Jacob Devlin,  
Maarten Bosma, Gaurav Mishra, Adam Roberts, Paul  
Barham, Hyung Won Chung, Charles Sutton, Se-  
bastian Gehrmann, et al. 2023\. Palm: Scaling lan-  
guage modeling with pathways.JournalofMachine  
LearningResearch, 24(240):1–113.  
\`\`\`  
\`\`\`  
Yangruibo Ding, Zijian Wang, Wasi Uddin Ah-  
mad, Hantian Ding, Ming Tan, Nihal Jain, Mu-  
rali Krishna Ramanathan, Ramesh Nallapati, Par-  
minder Bhatia, Dan Roth, and Bing Xiang.  
\`\`\`  
2023\. Crosscodeeval: A diverse and multilin-  
gual benchmark for cross-file code completion. In  
AdvancesinNeuralInformationProcessingSystems  
36: Annual Conference on Neural Information  
Processing Systems 2023, NeurIPS 2023, New  
Orleans,LA,USA,December 10 \- 16,2023.

\`\`\`  
Xueying Du, Mingwei Liu, Kaixin Wang, Hanlin Wang,  
Junwei Liu, Yixuan Chen, Jiayi Feng, Chaofeng  
Sha, Xin Peng, and Yiling Lou. 2023\. Classe-  
val: A manually-crafted benchmark for evaluating  
llms on class-level code generation.arXivpreprint  
arXiv:2308.01861.  
\`\`\`  
\`\`\`  
Zhangyin Feng, Daya Guo, Duyu Tang, Nan Duan, Xi-  
aocheng Feng, Ming Gong, Linjun Shou, Bing Qin,  
Ting Liu, Daxin Jiang, and Ming Zhou. 2020\. Code-  
bert: A pre-trained model for programming and nat-  
ural languages. InFindingsoftheAssociationfor  
ComputationalLinguistics: EMNLP2020,Online  
Event,16-20November 2020 , volume EMNLP 2020  
ofFindingsofACL, pages 1536–1547. Association  
for Computational Linguistics.  
\`\`\`  
\`\`\`  
Daya Guo, Qihao Zhu, Dejian Yang, Zhenda Xie,  
Kai Dong, Wentao Zhang, Guanting Chen, Xiao  
Bi, Y Wu, YK Li, et al. 2024a. Deepseek-  
coder: When the large language model meets  
programming–the rise of code intelligence. arXiv  
preprintarXiv:2401.14196.  
\`\`\`  
\`\`\`  
Daya Guo, Qihao Zhu, Dejian Yang, Zhenda Xie,  
Kai Dong, Wentao Zhang, Guanting Chen, Xiao  
Bi, Yu Wu, YK Li, et al. 2024b. Deepseek-  
coder: When the large language model meets  
programming–the rise of code intelligence. arXiv  
preprintarXiv:2401.14196.  
\`\`\`

Siming Huang, Tianhao Cheng, Jason Klein Liu, Jiaran  
Hao, Liuyihan Song, Yang Xu, J Yang, JH Liu,  
Chenchen Zhang, Linzheng Chai, et al. 2024\. Open-  
coder: The open cookbook for top-tier code large  
language models.arXivpreprintarXiv:2411.04905.

Binyuan Hui, Jian Yang, Zeyu Cui, Jiaxi Yang, Day-  
iheng Liu, Lei Zhang, Tianyu Liu, Jiajun Zhang,  
Bowen Yu, Kai Dang, et al. 2024a. Qwen2. 5-coder  
technical report.arXivpreprintarXiv:2409.12186.

Binyuan Hui, Jian Yang, Zeyu Cui, Jiaxi Yang, Day-  
iheng Liu, Lei Zhang, Tianyu Liu, Jiajun Zhang,  
Bowen Yu, Keming Lu, Kai Dang, Yang Fan,  
Yichang Zhang, An Yang, Rui Men, Fei Huang,  
Bo Zheng, Yibo Miao, Shanghaoran Quan, Yun-  
long Feng, Xingzhang Ren, Xuancheng Ren, Jingren  
Zhou, and Junyang Lin. 2024b. Qwen2.5-coder tech-  
nical report.Preprint, arXiv:2409.12186.

Carlos E Jimenez, John Yang, Alexander Wettig,  
Shunyu Yao, Kexin Pei, Ofir Press, and Karthik  
Narasimhan. 2023\. Swe-bench: Can language mod-  
els resolve real-world github issues?arXivpreprint  
arXiv:2310.06770.

Bowen Li, Wenhan Wu, Ziwei Tang, Lin Shi, John Yang,  
Jinyang Li, Shunyu Yao, Chen Qian, Binyuan Hui,  
Qicheng Zhang, Zhiyin Yu, He Du, Ping Yang, Dahua  
Lin, Chao Peng, and Kai Chen. 2024a. Devbench: A  
comprehensive benchmark for software development.  
CoRR, abs/2403.08604.

Jia Li, Ge Li, Xuanming Zhang, Yihong Dong, and  
Zhi Jin. 2024b. Evocodebench: An evolving code  
generation benchmark aligned with real-world code  
repositories.Preprint, arXiv:2404.00599.

Raymond Li, Loubna Ben Allal, Yangtian Zi, Niklas  
Muennighoff, Denis Kocetkov, Chenghao Mou, Marc  
Marone, Christopher Akiki, Jia Li, Jenny Chim, et al.

2023\. Starcoder: may the source be with you\!arXiv  
preprintarXiv:2305.06161.

Jiaheng Liu, Ken Deng, Congnan Liu, Jian Yang, Shukai  
Liu, He Zhu, Peng Zhao, Linzheng Chai, Yanan  
Wu, Ke Jin, Ge Zhang, Zekun Moore Wang, Guoan  
Zhang, Bangyu Xiang, Wenbo Su, and Bo Zheng.

2024\. M2rc-eval: Massively multilingual repository-  
level code completion evaluation.

Jiawei Liu, Chunqiu Steven Xia, Yuyao Wang, and Ling-  
ming Zhang. 2023a. Is your code generated by chat-  
gpt really correct? rigorous evaluation of large lan-  
guage models for code generation. arXivpreprint  
arXiv:2305.01210, abs/2305.01210.

Tianyang Liu, Canwen Xu, and Julian McAuley.  
2023b. Repobench: Benchmarking repository-  
level code auto-completion systems.arXivpreprint  
arXiv:2306.03091.

Tianyang Liu, Canwen Xu, and Julian J. McAuley.  
2023c. Repobench: Benchmarking repository-level  
code auto-completion systems. abs/2306.03091.

\`\`\`  
Anton Lozhkov, Raymond Li, Loubna Ben Allal, Fed-  
erico Cassano, Joel Lamy-Poirier, Nouamane Tazi,  
Ao Tang, Dmytro Pykhtar, Jiawei Liu, Yuxiang Wei,  
et al. 2024\. Starcoder 2 and the stack v2: The next  
generation.  
\`\`\`  
\`\`\`  
Mayank Mishra, Matt Stallone, Gaoyuan Zhang, Yikang  
Shen, Aditya Prasad, Adriana Meza Soria, Michele  
Merler, Parameswaran Selvam, Saptha Surendran,  
Shivdeep Singh, et al. 2024\. Granite code models:  
A family of open foundation models for code intelli-  
gence.arXivpreprintarXiv:2405.04324.  
\`\`\`  
\`\`\`  
MistralAI. 2024\. Codestral. https://mistral.ai/  
news/codestral. 2024.05.29.  
\`\`\`  
\`\`\`  
Erik Nijkamp, Hiroaki Hayashi, Caiming Xiong, Sil-  
vio Savarese, and Yingbo Zhou. 2023a. Codegen2:  
Lessons for training llms on programming and natu-  
ral languages.CoRR, abs/2305.02309.  
\`\`\`  
\`\`\`  
Erik Nijkamp, Hiroaki Hayashi, Caiming Xiong, Sil-  
vio Savarese, and Yingbo Zhou. 2023b. Codegen2:  
Lessons for training llms on programming and natu-  
ral languages.arXivpreprintarXiv:2305.02309.  
\`\`\`  
\`\`\`  
Erik Nijkamp, Bo Pang, Hiroaki Hayashi, Lifu Tu,  
Huan Wang, Yingbo Zhou, Silvio Savarese, and  
Caiming Xiong. 2023c. Codegen: An open large  
language model for code with multi-turn program  
synthesis. InInternationalConferenceonLearning  
Representations.  
\`\`\`  
\`\`\`  
OpenAI. 2023\. Gpt-4 technical report.arXivpreprint  
arXiv:2303.08774.  
\`\`\`  
\`\`\`  
Qiwei Peng, Yekun Chai, and Xuhong Li. 2024\.  
Humaneval-xl: A multilingual code generation  
benchmark for cross-lingual natural language gen-  
eralization.arXivpreprintarXiv:2402.16694.  
\`\`\`  
\`\`\`  
Qwen, :, An Yang, Baosong Yang, Beichen Zhang,  
Binyuan Hui, Bo Zheng, Bowen Yu, Chengyuan Li,  
Dayiheng Liu, Fei Huang, Haoran Wei, Huan Lin,  
Jian Yang, Jianhong Tu, Jianwei Zhang, Jianxin Yang,  
Jiaxi Yang, Jingren Zhou, Junyang Lin, Kai Dang,  
Keming Lu, Keqin Bao, Kexin Yang, Le Yu, Mei Li,  
Mingfeng Xue, Pei Zhang, Qin Zhu, Rui Men, Runji  
Lin, Tianhao Li, Tianyi Tang, Tingyu Xia, Xingzhang  
Ren, Xuancheng Ren, Yang Fan, Yang Su, Yichang  
Zhang, Yu Wan, Yuqiong Liu, Zeyu Cui, Zhenru  
Zhang, and Zihan Qiu. 2025\. Qwen2.5 technical  
report.Preprint, arXiv:2412.15115.  
\`\`\`  
\`\`\`  
Alec Radford, Jeff Wu, Rewon Child, David Luan,  
Dario Amodei, and Ilya Sutskever. 2019\. Language  
models are unsupervised multitask learners.OpenAI  
preprint.  
\`\`\`  
\`\`\`  
Baptiste Rozière, Jonas Gehring, Fabian Gloeckle, Sten  
Sootla, Itai Gat, Xiaoqing Ellen Tan, Yossi Adi,  
Jingyu Liu, Tal Remez, Jérémy Rapin, et al. 2023\.  
Code Llama: Open foundation models for code.  
arXivpreprintarXiv:2308.12950.  
\`\`\`

Baptiste Roziere, Jonas Gehring, Fabian Gloeckle, Sten  
Sootla, Itai Gat, Xiaoqing Ellen Tan, Yossi Adi,  
Jingyu Liu, Tal Remez, Jérémy Rapin, et al. 2023\.  
Code llama: Open foundation models for code.

Disha Shrivastava, Denis Kocetkov, Harm de Vries,  
Dzmitry Bahdanau, and Torsten Scholak. 2023a. Re-  
pofusion: Training code models to understand your  
repository.arXivpreprintarXiv:2306.10998.

Disha Shrivastava, Hugo Larochelle, and Daniel Tar-  
low. 2023b. Repository-level prompt generation for  
large language models of code. InProceedingsofthe  
40thInternationalConferenceonMachineLearning,  
volume 202 ofProceedingsofMachineLearning  
Research, pages 31693–31715. PMLR.

Hugo Touvron, Thibaut Lavril, Gautier Izacard, Xavier  
Martinet, Marie-Anne Lachaux, Timothée Lacroix,  
Baptiste Rozière, Naman Goyal, Eric Hambro,  
Faisal Azhar, et al. 2023\. Llama: Open and effi-  
cient foundation language models. arXivpreprint  
arXiv:2302.13971.

Peiyi Wang, Lei Li, Liang Chen, Zefan Cai, Dawei Zhu,  
Binghuai Lin, Yunbo Cao, Qi Liu, Tianyu Liu, and  
Zhifang Sui. 2023\. Large language models are not  
fair evaluators.arXivpreprintarXiv:2305.17926.

Thomas Wolf, Lysandre Debut, Victor Sanh, Julien  
Chaumond, Clement Delangue, Anthony Moi, Pier-  
ric Cistac, Tim Rault, Rémi Louf, Morgan Funtow-  
icz, Joe Davison, Sam Shleifer, Patrick von Platen,  
Clara Ma, Yacine Jernite, Julien Plu, Canwen Xu,  
Teven Le Scao, Sylvain Gugger, Mariama Drame,  
Quentin Lhoest, and Alexander M. Rush. 2020\. Hug-  
gingface’s transformers: State-of-the-art natural lan-  
guage processing.Preprint, arXiv:1910.03771.

Di Wu, Wasi Uddin Ahmad, Dejiao Zhang, Murali Kr-  
ishna Ramanathan, and Xiaofei Ma. 2024a. Repo-  
former: Selective retrieval for repository-level code  
completion. InForty-firstInternationalConference  
onMachineLearning,ICML2024,Vienna,Austria,  
July21-27,2024. OpenReview.net.

Qinyun Wu, Chao Peng, Pengfei Gao, Ruida Hu, Haoyu  
Gan, Bo Jiang, Jinhe Tang, Zhiwen Deng, Zhanming  
Guan, Cuiyun Gao, Xia Liu, and Ping Yang. 2024b.  
Repomastereval: Evaluating code completion via  
real-world repositories.Preprint, arXiv:2408.03519.

Fengji Zhang, Bei Chen, Yue Zhang, Jacky Keung, Jin  
Liu, Daoguang Zan, Yi Mao, Jian-Guang Lou, and  
Weizhu Chen. 2023a. Repocoder: Repository-level  
code completion through iterative retrieval and gen-  
eration. InProceedingsofthe 2023 Conferenceon  
EmpiricalMethodsinNaturalLanguageProcessing,  
EMNLP2023, Singapore,December6-10, 2023 ,  
pages 2471–2484. Association for Computational  
Linguistics.

Fengji Zhang, Bei Chen, Yue Zhang, Jin Liu, Daoguang  
Zan, Yi Mao, Jian-Guang Lou, and Weizhu Chen.  
2023b. Repocoder: Repository-level code comple-  
tion through iterative retrieval and generation.arXiv  
preprintarXiv:2303.12570.

\`\`\`  
Fengji Zhang, Bei Chen, Yue Zhang, Jin Liu, Daoguang  
Zan, Yi Mao, Jian-Guang Lou, and Weizhu Chen.  
2023c. RepoCoder: Repository-level code comple-  
tion through iterative retrieval and generation.arXiv  
preprintarXiv:2303.12570, abs/2303.12570.  
\`\`\`

\#\# A Import Statements

\`\`\`  
Python Basic import(and rename): Use the "import" keyword followed by the module name or "as" keyword to give it an  
alias, like "import xx","import xx as xxx".  
Import specific content from a module(and rename): Use the "from" keyword followed by the module name and "import"  
keyword (and "as" keyword), such as "from a import b as c".  
Import multiple functions: use a comma-separated list within the import statement for importing multiple functions from a  
module or package,like "from mymodule import function1, function2".  
Absolute references: An absolute reference specifies the complete path to a resource from the root directory. For instance,  
"from mypackage.mymodule","import myfunction".  
Relative references: A relative reference specifies a path starting from the current location in the directory structure. For  
example, "from. import sibling\_module".  
\`\`\`  
\`\`\`  
C Basic include: Use the \#include directive followed by the header file name. Standard library headers are enclosed in angle  
brackets \< \>, while user-defined headers are enclosed in double quotes " ". For example, \#include \<xx.h\> or \#include "xx.h".  
Include specific content from a header file(and rename): C can use typedef or \# define to rename data types or functions.  
For example, typedef old\_type new\_type; or \#define new\_func old\_func.  
Absolute references: An absolute reference specifies the complete path to a resource from the root directory. In C, this is  
typically used for specifying the full path to a header file or source file. For example, \#include "/usr/include/myheader.h".  
Relative references: A relative reference specifies a path starting from the current location in the directory structure. For  
example, \#include "./myheader.h" includes a header file from the current directory, or \#include "../myheader.h" includes a  
header file from the parent directory.  
\`\`\`  
\`\`\`  
C++ Basic include: Use the \#include directive followed by the header file name. Standard library headers are enclosed in  
angle brackets \< \>, while user-defined headers are enclosed in double quotes " ". For example, \#include \<xx.h\> or \#include  
"xx.h".  
Include specific content from a header file(and rename): C++ allows you to include specific parts of a header file by using  
namespace to refer to certain namespaces or classes. You can also rename or alias types or functions using using directives,  
like "using namespace std" or "using std::vector".  
Absolute references: An absolute reference specifies the complete path to a resource from the root directory. In C++, this is  
typically used for specifying the full path to a header file or source file. For example, \#include "/usr/include/myheader.h".  
Relative references: A relative reference specifies a path starting from the current location in the directory structure. For  
example, \#include "./myheader.h" includes a header file from the current directory, or \#include "../myheader.h" includes a  
header file from the parent directory.  
\`\`\`  
\`\`\`  
C\# Basic using): In C\#, you use the "using" keyword to import namespaces, which allow access to classes, structs, and other  
members within those namespaces. For example, "using System"; allows access to the classes in the "System" namespace.  
Import specific content from a namespace: C\# can import specific types (such as classes or methods) from a namespace by  
"using" followed by the type name. For instance, "using System.Console".  
Absolute references: In C\#, absolute references are typically used for referencing fully qualified type names (including the  
namespace). For example, "System.Console.xx".  
\`\`\`  
\`\`\`  
PHP Basic include: Use the "include" or "require" keyword followed by the path to the file you wish to include. You  
can also use include\_once or require\_once to ensure the file is included only once. For example, "include ’myfile.php’" or  
"require ’myfile.php’".  
Include specific content from a file: PHP can include an entire file or use functions and classes defined in the included file.  
To rename or alias functions, classes, or variables, you would use PHP’s "use" keyword in the context of namespaces. For  
example, "use MyNamespace".  
Absolute references: An absolute reference specifies the full path from the root directory. In PHP, this would be used to  
include files from a specific path on the server, such as: "include ’/xx/xx/xx.php’".  
Relative references: A relative reference specifies a path relative to the current directory. For example, "include ’./xx.php’"  
or "include ’../xx.php’".  
\`\`\`  
\`\`\`  
JAVA Basic import: In Java, the "import" keyword is used to include classes or entire packages from other files. By default,  
Java does not support aliasing in imports like some other languages. To import a class, use "import package.ClassName".  
Import all classes from a package: Java allows importing all the classes from a package by using the \* wildcard. For  
example, "import java.util.\*".  
Absolute references: An absolute reference in Java specifies the full path to a class, starting from the root of the classpath.  
For example, "import xx.xx.MyClass".  
Static imports: Java allows importing static members of a class, such as methods or constants, using the import static  
keyword. For example, import static java.lang.Math.\*; allows access to static methods like Math.sqrt() without needing to  
prefix them with Math.  
\`\`\`

\`\`\`  
JavaScript Basic import(and rename): Use the import keyword to bring in modules or specific parts of modules. The  
general syntax is import \<module\> from ’\<module-name\>’, where \<module\> is the exported entity. To rename an import,  
the as keyword can be used, like import originalName as alias from ’\<module-name\>’.  
Import specific content from a module(and rename): JavaScript allows importing specific functions, objects, or values  
from a module. This can be done by using the syntax. Additionally, renaming is possible with the as keyword. For example,  
import func1 as f1, func2 from ’\<module-name\>’ imports func1 as f1 and func2 as-is.  
Import multiple items from a module: Multiple exports from the same module can be imported in a single statement.  
These are separated by commas inside curly braces. For example, import func1, func2, constant from ’\<module-name\>’.  
Absolute references: An absolute reference in JavaScript specifies the complete URL or file path to the module or resource.  
This often starts from the root directory or the full URL. For example, import func from ’/modules/myModule.js’ or import  
func from ’https://example.com/myModule.js’.  
Relative references: A relative reference in JavaScript refers to the file path starting from the current location in the directory  
structure. This can be done using ./ for the current directory or ../ for the parent directory. For example, import func from  
’./myModule.js’ imports from the current directory, while import func from ’../myModule.js’ imports from the parent  
directory.  
\`\`\`  
\`\`\`  
TypeScript Basic import(and rename): Use the import keyword to bring in modules or specific components from modules.  
The syntax is import \<module\> from ’\<module-name\>’, where \<module\> refers to the default export of the module. To  
rename an import, the as keyword is used, such as import originalName as alias from ’\<module-name\>’.  
Import specific content from a module(and rename): TypeScript supports importing specific parts of a module using curly  
braces. The as keyword can also be used to rename the imported elements. For example, import func1 as f1, func2 from  
’\<module-name\>’ imports func1 as f1 and func2 with its original name.  
Import multiple items from a module: Multiple items from the same module can be imported by listing them inside  
curly braces, separated by commas. For instance, import func1, func2, variable from ’\<module-name\>’ imports multiple  
functions and variables from the module.  
Absolute references: An absolute reference in TypeScript specifies the full path to a module, either from the root di-  
rectory or via a full URL. For example, "import myFunction from ’/xx/myModule’" or "import myFunction from  
’https://xx/myModule’".  
Relative references: A relative reference specifies the file path starting from the current directory. For example, "import  
myFunction from ’./myModule’" or "import myFunction from ’../myModule’".  
\`\`\`  
\#\# B Repository Collection

\`\`\`  
B.1 Repo Filter Criteria  
\`\`\`  
We collect public GitHub repositories created before December 16, 2024, and focus on eight specific  
programming languages. To streamline data processing, we apply several filtering criteria.  
First, we exclude files where the average line length exceeds 100 characters or the maximum line length  
surpasses 1000 characters. Additionally, files with fewer than 25% alphabetic characters are removed.  
At the repository level, we enforce the following main conditions. (1) Repositories must fall within  
the specified creation timeframe and must not be forks to ensure originality. (2) They must be primarily  
written in one of the eight target programming languages listed in Table 2\. (3) They must meet size  
and popularity constraints: repositories should be smaller than 1MB for manageability, and they must  
have at least three stars to reflect a minimum level of community interest. (4) Repositories must have  
at least one commit in the last six months before the collection date to ensure they are not abandoned.  
(5) Repositories must have at least one open or closed issue or pull request to indicate some level of  
engagement from developers. (6) For repositories using dependency managers (e.g., package.json for  
JavaScript, requirements.txt for Python), we check that these files are present and not empty to ensure the  
repository is functional. (7) Repositories must contain a README file with at least 100 words to ensure  
they provide sufficient context for analysis. (8) To maintain consistency, we exclude repositories that mix  
multiple programming languages beyond a small threshold (e.g., more than 10% of files in a secondary  
language).

\`\`\`  
B.2 README Filter Criteria  
To ensure that the README file effectively serves its purpose by providing structured and comprehensive  
information, we apply the following filtering criteria: (1) Structured Formatting: The README must  
include appropriate titles and headings to organize content, making it easier for readers to navigate. (2)  
Content Sufficiency: The document should meet a minimum character threshold to ensure it provides a  
meaningful overview of the project rather than being overly brief. (3) Setup Instructions: The README  
must contain setup-related keywords such as install, build, setup, download, compile, train, or run, ensuring  
\`\`\`

\`\`\`  
that it provides essential instructions for setting up and using the project. (4) Project Structure References:  
It should explicitly reference specific files or directories within the repository to help users understand  
the project’s organization and locate key resources quickly. (5) License Information: The presence of  
a license section or a direct reference to a LICENSE file is required to clarify usage permissions and  
distribution rights.  
\`\`\`  
\`\`\`  
B.3 Detailed Task Sample Filter Process  
\`\`\`  
We applied different filtering strategies for the three tasks, with all prioritizing task difficulty and diversity  
of repository topics.  
Dependency Recognition Task. We categorized code snippets by token length (≤8K, 8K–16K,\>16K),  
but found an imbalance across languages. For example, in the\>16K category, C had 1,329 samples, while  
PHP had only 141\. We initially selected 100 samples from each token length range for every language.  
After removing duplicate snippets from the same repository, we developed scripts to analyze invocation  
chain length, character length, and repository topic distribution. If imbalances were detected, we manually  
adjusted the sample selection, resulting in 180 samples per language.  
Repository Construction Task: We selected repositories with fewer than 12 invocation chains while  
ensuring full file coverage. This resulted in varying sample counts across languages (e.g., Python: 230,  
Java: 70). To manage manual verification costs, we aimed for 40–60 samples per language. Human  
review filtered out non-compliant cases (Appendix C.1), and we adjusted the distribution to approximate  
normality as in the dependency recognition task.  
Multi-file Editing Task: We selected code snippets with chains of lengths 2, 3, and 4, ensuring they  
came from different repositories. For each language, we generated 500–2000 samples (varying by  
language) using GPT-4o. We then verified if the number of generated files matched the requirements and  
used LLM to check whether the generated snippets met the criteria. We ran multiple rounds of refinement  
and removed code comments from the snippets. Human annotators applied manual corrections, discarding  
non-compliant samples and finalizing the dataset.

\#\# C Human Review Criteria

\`\`\`  
C.1 Repository Construction  
Human annotators perform the following criteria to select the final set of samples:  
First, the repository description should provide a brief and clear summary of the purpose and func-  
tionality of the repository. It should be logically coherent, free from contradictions, and align with the  
functional components of the repository. In addition, the description should include all important features  
and functionalities of the repository, ensuring a comprehensive overview. Next, the functional description  
for each file should clearly outline the core features and capabilities of the file. It should be accurate and  
brief, reflecting the actual code behavior of the file while adhering to the conventions and terminology of  
the repository.  
Finally, the relationships between files, functions, and modules should be accurately represented in the  
generated descriptions. The dependencies of each file and the interactions within the repository must be  
clearly conveyed, ensuring that the dependencies reflect the actual structure of the repository.  
\`\`\`  
\`\`\`  
C.2 Multi-file Editing  
\`\`\`  
After the LLM-based filtering step, pre-selected samples are passed to human annotators for manual  
verification. This process is designed to ensure accuracy and consistency across multiple files.  
First, annotators check whether the new functionalities are described in a way that is consistent with the  
code’s behavior and the intended programming logic. They then confirm that the changes align with the  
existing codebase, are semantically correct, and do not introduce errors or bugs. Modifications must be  
coherent not only within the specific file but throughout the project, maintaining consistency in terms of  
structure, style, and performance. Annotators also cross-check that all modified files reflect the appropriate  
changes, ensuring that updates in one file do not conflict with others.

Static Analysis for Code Correctness. We use static analysis tools to ensure syntax correctness.  
After verifying the logic of newly implemented functionalities, annotators apply language-specific static  
analyzers to detect syntax errors:

\- C, C++:Cppcheck  
\- C\#:StyleCop  
\- Python:Pylint  
\- Java:SpotBugs  
\- TypeScript/JavaScript:ESLint  
\- PHP:PHPCS

\`\`\`  
Finally, annotators manually correct any remaining issues, including syntax errors and logical inconsisten-  
cies with the intended requirements, to produce gold-standard code for evaluation.  
\`\`\`  
\#\# D Diversity of Data

\`\`\`  
Figure 7: Topic distribution. Different programming languages and frameworks into various fields, such as  
Development, Tools, Systems, Data Science, and more.  
\`\`\`  
\#\# E Prompt Templates

\`\`\`  
E.1 Curating Prompts for Dependency Recognition Data  
Data Curation for Dependency Recognition  
\`\`\`  
\`\`\`  
You are an AI assistant that summarizes file functionality. Your task: 1\. Read the file content  
provided by the user. 2\. Analyze and understand the file’s main purpose. 3\. Summarize the  
core functionality in 1-2 concise sentences. 4\. Provide only the summary, without any additional  
information or commentary.  
\`\`\`

\`\`\`  
Data Curation for Dependency Recognition  
\`\`\`  
\`\`\`  
You are an AI assistant that summarizes project functionality. Your task: 1\. Read the README  
content provided by the user. 2\. Analyze and understand the project’s main purpose and features. 3\.  
Summarize the core functionality of the project in 2-3 concise sentences. 4\. Provide the summary  
in JSON format with two keys: "description" and "function". 5\. The "description" should briefly  
describe what the project is. 6\. The "function" should summarize the main features or capabilities  
of the project.  
Example output:  
{  
"description":␣"An␣AI-powered␣game␣solver␣for␣2048",  
"function":␣"Utilizes␣expectimax␣optimization␣with␣efficient␣bitboard␣representation␣to␣  
play␣2048.␣Can␣control␣browser-based␣game␣and␣provides␣both␣command-line␣and␣browser-  
control␣versions."  
}  
\`\`\`  
E.2 Curating Prompts for Multi-file Editing Data

\`\`\`  
Data Curation for In-place Edits with Chain Length 2  
\`\`\`  
\`\`\`  
Based on the above code snippets, complete the following instructions and output according to the  
format required in Step 3: 1\. Identify interactions across two files:Identify a segment in one file  
(\#file 1\) that is invoked by another file (\#file 2). Exclude import parts in both files and specify only  
relevant code segments in the corresponding files. 2\. Add a new feature:• Modify the part in \#file 1  
that is being invoked by \#file 2.• Update the corresponding code in \#file 2 to handle the changes in  
\#file 1.• If new code snippets are required, append them at the end of each file. 3\. Output format:  
{  
"called\\\_code\\\_segment":␣"\\\#file␣1␣segment␣being␣invoked␣(excluding␣\`import\`)",  
"invoking\\\_code\\\_segment":␣"\\\#file␣2␣segment␣invoking␣\\\#file␣1␣(excluding␣\`import\`)",  
"feature\\\_description":␣"Description␣of␣the␣new␣feature",  
"detailed\\\_feature\\\_description":␣"General␣explanation␣of␣the␣modification␣approach.",  
"modified\\\_complete\\\_code":␣"Provide␣the␣complete␣code␣with␣the␣required␣modifications␣for␣  
both␣files.␣Include␣the␣modified␣code␣snippets␣for␣\\\#file␣1␣and␣\\\#file␣2.␣Use␣comments:  
␣\\\#Modify␣for␣modified␣parts␣and␣\\\#New␣for␣newly␣added␣parts␣to␣indicate␣whether␣the␣  
change␣is␣an␣addition␣or␣modification."  
}  
\`\`\`  
\`\`\`  
Data Curation for In-place Edits with Chain Length 3  
\`\`\`  
\`\`\`  
Based on the above code snippets, complete the following instructions and output according to the  
format required in Step 3\.  
\`\`\`  
1\. \*\*Identify interactions across three files:\*\*  
\- Identify a segment in one file (‘\#file 1‘) that is invoked by another file (‘\#file 2‘). \- Identify how  
this interaction is further used or invoked in a third file (‘\#file 3‘). \- Check if ‘\#file 2‘ contains a  
segment invoked by ‘\#file 3‘. If so, document this invocation explicitly. \- Exclude ‘import‘ parts in  
all cases and specify only relevant code segments in the corresponding files.  
2\. \*\*Add a new feature:\*\*  
\- Modify the part in ‘\#file 1‘ that is being called by ‘\#file 2‘. \- Update ‘\#file 2‘ to handle the  
modified code from ‘\#file 1‘ and ensure any related code segments used by ‘\#file 3‘ are updated  
accordingly. \- If ‘\#file 3‘ directly interacts with updated segments in ‘\#file 2‘, modify the code in  
‘\#file 3‘ to accommodate the changes. \- If new code snippets are required, append them at the end  
of each file.  
3\. Output format:

{  
"called\\\_code\\\_segment\\\_file\\\_1":␣"Relevant␣\\\#file␣1␣segment␣being␣invoked␣(excluding␣\`  
import\`)",  
"invoking\\\_code\\\_segment\\\_file\\\_2":␣"Relevant␣\\\#file␣2␣segment␣invoking␣\\\#file␣1␣(excluding␣  
\`import\`)",  
"called\\\_code\\\_segment\\\_file\\\_2":␣"Relevant␣\\\#file␣2␣segment␣being␣invoked␣by␣\\\#file␣3␣(  
excluding␣\`import\`)",  
"using\\\_code\\\_segment\\\_file\\\_3":␣"Relevant␣\\\#file␣3␣segment␣using␣or␣interacting␣with␣\\\#file  
␣2␣or␣\\\#file␣1␣(excluding␣\`import\`)",  
"feature\\\_description":␣"Description␣of␣the␣new␣feature",  
"detailed\\\_feature\\\_description":␣"General␣explanation␣of␣the␣modification␣approach,  
including any changes to interactions between \\\#file 2 and \\\#file 3.",  
␣␣"modified\\\_complete\\\_code":␣"Provide the complete code with the required modifications for  
all three files. Include the modified code snippets for \\\#file 1, \\\#file 2, and \\\#file 3\.  
Use comments:␣\\\#Modify␣for␣modified␣parts␣and␣\\\#New␣for␣newly␣added␣parts␣to␣indicate␣  
whether␣the␣change␣is␣an␣addition␣or␣modification."  
}

Data Curation for In-place Edits with Chain Length 4

Based on the above code snippets, complete the following instructions and output according to the  
format required in Step 4\.

1\. Identify interactions across four files:  
\- Identify a segment in one file (\#file 1\) that is invoked by another file (\#file 2).• Identify how this  
interaction is further used or invoked in a third file (\#file 3).• Check if \#file 2 contains a segment  
invoked by \#file 3\. If so, document this invocation explicitly.• Check if \#file 3 contains a segment  
invoked by a fourth file (\#file 4). If so, document this invocation explicitly.• Exclude import parts  
in all cases and specify only relevant code segments in the corresponding files.  
2\. Add a new feature:  
\- Modify the part in \#file 1 that is being called by \#file 2.• Update \#file 2 to handle the modified  
code from \#file 1 and ensure any related code segments used by \#file 3 are updated accordingly.  
\- If \#file 3 directly interacts with updated segments in \#file 2, modify the code in \#file 3 to  
accommodate the changes.• Update \#file 4 if it interacts with or depends on any updated segments  
in \#file 3\. • If new code snippets are required, append them at the end of each file.  
3\. Output format:

{  
"called\\\_code\\\_segment\\\_file\\\_1":␣"Relevant␣\\\#file␣1␣segment␣being␣invoked␣(excluding␣\`  
import\`)",  
"invoking\\\_code\\\_segment\\\_file\\\_2":␣"Relevant␣\\\#file␣2␣segment␣invoking␣\\\#file␣1␣(excluding␣  
\`import\`)",  
"called\\\_code\\\_segment\\\_file\\\_2":␣"Relevant␣\\\#file␣2␣segment␣being␣invoked␣by␣\\\#file␣3␣(  
excluding␣\`import\`)",  
"using\\\_code\\\_segment\\\_file\\\_3":␣"Relevant␣\\\#file␣3␣segment␣using␣or␣interacting␣with␣\\\#file  
␣2␣or␣\\\#file␣1␣(excluding␣\`import\`)",  
"called\\\_code\\\_segment\\\_file\\\_3":␣"Relevant␣\\\#file␣3␣segment␣being␣invoked␣by␣\\\#file␣4␣(  
excluding␣\`import\`)",  
"using\\\_code\\\_segment\\\_file\\\_4":␣"Relevant␣\\\#file␣4␣segment␣using␣or␣interacting␣with␣\\\#file  
␣3␣(excluding␣\`import\`)",  
"feature\\\_description":␣"Description␣of␣the␣new␣feature",  
"detailed\\\_feature\\\_description":␣"General␣explanation␣of␣the␣modification␣approach,  
including any changes to interactions between the four files.",  
␣␣"modified\\\_complete\\\_code":␣"Provide the complete code with the required modifications for  
all four files. Include the modified code snippets for \\\#file 1, \\\#file 2, \\\#file 3, and  
\\\#file 4\. Use comments:␣\\\#Modify␣for␣modified␣parts␣and␣\\\#New␣for␣newly␣added␣parts␣to␣  
indicate␣whether␣the␣change␣is␣an␣addition␣or␣modification."  
}

\`\`\`  
Data Curation for Expansion Edits with Chain Length 2  
\`\`\`  
\`\`\`  
Based on the above code snippets, complete the following instructions and output according to the  
format required in Step 3:  
\`\`\`  
1\. \*\*Identify interactions across two files:\*\*  
\- Identify a segment in one file (\#file 1\) that is invoked by another file (\#file 2). \- Exclude import  
parts in both files and specify only relevant code segments in the corresponding files.  
2\. \*\*Add a new feature:\*\*  
\- Modify the part in \#file 1 that is being invoked by \#file 2\. \- Create a new file (‘\#file 3‘) to  
implement additional functionality for the new feature. \- Update \#file 1 to invoke code from \#file  
3 where applicable. \- Update \#file 2 to invoke code from \#file 3 where applicable. \- Ensure the  
changes maintain compatibility across \#file 1 and \#file 2\. \- If new code snippets are required,  
append them at the end of each file.  
3\. Output format:

\`\`\`  
{  
"called\\\_code\\\_segment":␣"\\\#file␣1␣segment␣being␣invoked␣(excluding␣\`import\`)",  
"invoking\\\_code\\\_segment":␣"\\\#file␣2␣segment␣invoking␣\\\#file␣1␣(excluding␣\`import\`)",  
"new\\\_file\\\_code\\\_segment":␣"Relevant␣code␣snippets␣added␣in␣\\\#file␣3␣(excluding␣\`import\`)",  
"feature\\\_description":␣"Description␣of␣the␣new␣feature",  
"detailed\\\_feature\\\_description":␣"General␣explanation␣of␣the␣modification␣approach,  
including the purpose and integration of \\\#file 3.",  
␣␣"modified\\\_complete\\\_code":␣"Provide the complete code with the required modifications for  
\\\#file 1, \\\#file 2, and the new file (\\\#file 3). Use comments:␣\\\#Modify␣for␣modified␣  
parts␣and␣\\\#New␣for␣newly␣added␣parts␣to␣indicate␣whether␣the␣change␣is␣an␣addition␣or␣  
modification."  
}  
\`\`\`  
\`\`\`  
Data Curation for Expansion Edits with Chain Length 3  
\`\`\`  
\`\`\`  
Extended Instruction for Interactions Across Three Files  
Based on the above code snippets, complete the following instructions and output according to the  
format required in Step 3:  
\`\`\`  
1\. Identify interactions across three files:• Identify a segment in one file (\#file 1\) that is invoked  
by another file (\#file 2).• Identify how this interaction is further used or invoked in a third file  
(\#file 3).• Check if \#file 2 or \#file 3 contains segments that directly or indirectly depend on \#file 1  
or interact with one another. Document these invocations explicitly.• Exclude import parts in all  
cases and specify only relevant code segments in the corresponding files.  
2\. Add a new feature:• Modify the part in \#file 1 that is being invoked by \#file 2 and/or \#file 3.•  
Create a new file (\#file 4\) to implement additional functionality for the new feature.• Update \#file  
1 to invoke code from \#file 4 where applicable.• Update \#file 2 and/or \#file 3 to handle changes  
in \#file 1 and invoke relevant code from \#file 4.• Ensure compatibility across all interactions  
involving \#file 1, \#file 2, \#file 3, and the new file (\#file 4).• If new code snippets are required,  
append them at the end of each file.  
3\. Output format:

\`\`\`  
{  
"called\\\_code\\\_segment\\\_file\\\_1":␣"\\\#file␣1␣segment␣being␣invoked␣(excluding␣\`import\`)",  
"invoking\\\_code\\\_segment\\\_file\\\_2":␣"\\\#file␣2␣segment␣invoking␣\\\#file␣1␣(excluding␣\`import\`)  
",  
"invoking\\\_code\\\_segment\\\_file\\\_3":␣"\\\#file␣3␣segment␣invoking␣\\\#file␣1␣or␣\\\#file␣2␣(  
excluding␣\`import\`)",  
"new\\\_file\\\_code\\\_segment":␣"Relevant␣code␣snippets␣added␣in␣\\\#file␣4␣(excluding␣\`import\`)",  
"feature\\\_description":␣"Description␣of␣the␣new␣feature",  
"detailed\\\_feature\\\_description":␣"General␣explanation␣of␣the␣modification␣approach,  
including the purpose and integration of \\\#file 4.",  
␣␣"modified\\\_complete\\\_code":␣"Provide the complete code with the required modifications for  
\\\#file 1, \\\#file 2, \\\#file 3, and the new file (\\\#file 4). Use comments:␣\\\#Modify␣for␣  
modified␣parts␣and␣\\\#New␣for␣newly␣added␣parts␣to␣indicate␣whether␣the␣change␣is␣an␣  
addition␣or␣modification."  
}  
\`\`\`  
E.3 Prompts for Inference

\`\`\`  
Prompt Template Used for Dependency Recognition  
\`\`\`  
\`\`\`  
There are files \#filename. Analyze their content and determine the dependency relationship  
between files. Output with the following request.  
1.Don’t give analysis process and using the same file title.  
2.Simply and only output the dependency relationship list using its file names with the format  
\[’a.py’,’b.py’,’c.py’\] if b depends on a , c depends on b.  
3.You must strictly output the response with the format:\[’a.py’,’b.py’,’c.py’\] Example output:  
\["file1.py", "file2.py", "file3.py"\]  
Here’s the code snippet: \#code\_content.  
\`\`\`  
\`\`\`  
Prompt Template Used for Repository Construction  
\`\`\`  
\`\`\`  
You are an AI assistant tasked with generating a project structure based on the given repository  
information. Your task:  
\`\`\`  
1\. Analyze the project description, function, and file information provided.  
2\. Generate a project structure that shows the dependencies between files.  
3\. Return the structure in the format \[\[file1, file2, file3\], \[file4, file5\], ...\], where each sublist  
represents a chain of dependencies (file2 calls file1, file3 calls file2, etc.).  
4\. Provide only the list structure, without any additional explanation.  
5\. You must strictly follow the output format.  
Here’s the project information:  
Project Description: \#description Project Function: \#function  
Files in the project: \#files  
Based on this information, please generate the project structure showing the dependencies between  
files. Remember to return only the list structure without any additional explanation.  
Example output format:  
\[\["file1.py", "file2.py", "file3.py"\], \["file4.py", "file5.py"\]\]

\`\`\`  
Prompt Template Used for Multi-file Editing  
\`\`\`  
\`\`\`  
Based on the above code snippets, complete the following instructions and output according to the  
format specified in Step 3:  
\`\`\`  
1\. Identify the segment in one file that is invoked by another file (excluding the import parts) and  
specify the relevant code segment in the called file. 2\. Modify the given code to implement the

\#function. This requires modifying the part being called. If new code snippets are needed, add  
them to the end of each respective file. 3\. Output format:

{  
"called\\\_code\\\_segment":␣"\\\#file␣1␣segment␣being␣invoked␣(excluding␣\`import\`)",  
"invoking\\\_code\\\_segment":␣"\\\#file␣2␣segment␣invoking␣\\\#file␣1␣(excluding␣\`import\`)",  
"feature\\\_description":␣"Description␣of␣the␣new␣feature",  
"detailed\\\_feature\\\_description":␣"General␣explanation␣of␣the␣modification␣approach",  
"modified\\\_complete\\\_code":␣"Provide␣the␣complete␣code␣with␣the␣required␣modifications.␣  
Output␣the␣modified␣code␣snippets.␣Use␣comments␣like␣\\\#Modify␣for␣modified␣parts␣and␣\\\#  
New␣for␣newly␣added␣parts␣to␣indicate␣whether␣the␣change␣is␣an␣addition␣or␣modification  
."  
}

E.4 Prompts for Evaluation

\`\`\`  
Prompt Template Used for Evaluating Multi-file Editing  
\`\`\`  
\`\`\`  
Gt: {gt} Pred: {pred}  
Using Gt as the correct answer, compare the content of Pred with Gt and evaluate Pred based on the  
following aspects. Each aspect contains tailored evaluation criteria to handle the complexities of  
multi-file interactions and feature integration. The output must follow the JSON format described  
in Point 6\.  
Evaluation Aspects  
\`\`\`  
1\. Correctness of Function Calls Objective: Evaluate the accuracy of all function calls between seg-  
ments and across files.• Ensure:• Each invoking\_code\_segment correctly calls its corresponding  
called\_code\_segment as per Gt.• Calls include appropriate parameter matching, order, and context  
alignment.• Evaluation Criteria:• Does the function signature match, including parameter names,  
types, and order?• Are correct arguments passed, meeting expectations in feature\_description  
and detailed\_feature\_description?• Is the pre- or post-logic necessary for context included?• Are  
cross-file dependencies invoked correctly, as shown in modified\_complete\_code?  
Scoring Rules:• 5 points: All function calls are completely correct and match Gt, including  
parameters, order, and logical dependencies.• 4 points: Mostly correct with minor parameter or  
comment issues but no major gaps.• 3 points: Partially correct; missing key parameters, logic, or  
dependencies.• 2 points: Significant issues in invocation logic, causing likely runtime errors.• 0-1  
points: Calls are incorrect, incomplete, or not implemented.  
2\. Alignment with Feature Requirements Objective: Check if the code in Pred aligns with  
the intended feature and modification goals.• Ensure:• Every call reflects requirements in fea-  
ture\_description and detailed\_feature\_description.• The new or modified logic directly implements  
the required functionality.• Evaluation Criteria:• Does the logic adhere to the functional goals  
described?• Does it integrate with multi-file dependencies correctly (if applicable)?• Are the new  
components in new\_file\_code\_segment aligned with expectations?  
Scoring Rules:• 5 points: Perfectly aligned with feature requirements; implementation is logically  
complete.• 4 points: Correctly aligned but with potential optimizations or minor improvements.•  
3 points: Partially fulfills requirements with clear gaps in alignment.• 2 points: Loosely aligned  
with significant logic missing.• 0-1 points: Not aligned or entirely unrelated to the described  
requirements.  
3\. Accuracy of Functionality Implementation Objective: Verify the correctness of the implemen-  
tation, focusing on functional outcomes. • Evaluation Criteria: • Does the functionality fully  
satisfy the requirements in feature\_description?• Are components correctly loaded, initialized, or  
referenced? • Are all dependencies resolved for seamless multi-file integration?  
Scoring Rules:• 5 points: Fully accurate implementation without functional defects.• 4 points:  
Mostly accurate with minor issues or deviations.• 3 points: Partially correct but lacking essential  
steps or logic.• 2 points: Basic framework present but largely incomplete.• 0-1 points: Non-  
functional due to missing or incorrect logic.  
4\. Completeness of Implementation Objective: Ensure that all functional components, including  
new and modified ones, are fully implemented.• Evaluation Criteria:• Are all required segments  
across files defined and updated per Gt?• Does the implementation cover all subparts described  
in detailed\_feature\_description?• Are all new dependencies (\#New segments) and modifications  
(\#Modify segments) accounted for?  
Scoring Rules: • 5 points: Complete implementation with no omissions. • 4 points: Nearly  
complete, with only minor omissions.• 3 points: Significant missing functionality, but partially  
meets requirements.• 2 points: Too many missing components, achieving minimal functionality.•  
0-1 points: Nearly all components are missing or incorrect.  
5\. Code Quality Objective: Assess the overall quality, maintainability, and readability of the  
code. • Evaluation Criteria:• Readability: Clear naming, concise comments, and consistent

style.• Maintainability: Modular structure, minimal duplication, and extensibility.• Efficiency:  
Appropriate algorithms, data structures, and resource use.  
Scoring Rules:• 5 points: Excellent quality with clean, efficient, and maintainable code.• 4 points:  
Good quality, but minor readability or efficiency issues.• 3 points: Average quality; readable but  
not optimized or modular.• 2 points: Poor quality; lacks structure or suffers from inefficiencies.•  
0-1 points: Unreadable, unstructured, or inefficient code.

6\. JSON Output Format

{  
"correctness\_score":␣5,  
"purpose\_alignment\_score":␣4,  
"functionality\_accuracy\_score":␣5,  
"functionality\_completeness\_score":␣4,  
"code\_quality\_score":␣5  
}

\#\# F Task Case

\`\`\`  
Instance of Dependency Recognition  
\`\`\`  
\`\`\`  
"files":\["’bilireq/bilireq/login/\_init\_.py’", "’bilireq/bilireq/typing.py’", "’bilire-  
q/test/test\_login.py’"\],  
"content":  
import asyncio  
from base64 import b64encode  
from io import BytesIO  
from typing import Optional, Union  
from qrcode.image.pure import PyPNGImage  
from qrcode.main import QRCode  
from \_typing import T\_Auth  
from auth import Auth, WebAuth  
from ..exceptions import ResponseCodeError  
from ..utils import get, post  
from .pwd\_login import pwd\_login as \_pwd\_login  
from .qrcode\_login import get\_qrcode\_login\_info, get\_qrcode\_login\_result  
from .sms\_login import send\_sms  
from .sms\_login import sms\_login as \_sms\_login  
from .web\_qrcode\_login import get\_web\_qrcode\_login\_info, get\_web\_qrcode\_login\_url  
BASE\_URL \= "https://passport.bilibili.com/api/v2/oauth2/"  
async def refresh\_token(auth: T\_Auth \= None, \*, reqtype="app", \*\*kwargs):  
url \= f"{BASE\_URL}refresh\_token"  
return await post(url, auth=auth, reqtype=reqtype, \*\*kwargs)  
async def get\_token\_info(auth: T\_Auth \= None, \*, reqtype="app", \*\*kwargs):  
url \= f"{BASE\_URL}info"  
return await get(url, auth=auth, reqtype=reqtype, \*\*kwargs)  
class Login:  
auth\_code: str  
qrcode\_url: str  
tel: int  
cid: int  
captcha\_key: str  
async def get\_web\_qrcode\_url(self) \-\> str :  
r \= await get\_web\_qrcode\_login\_url()  
self.auth\_code \= r\["qrcode\_key"\]  
self.qrcode\_url \= r\["url"\]  
return self.qrcode\_url  
async def get\_qrcode\_url(self) \-\> str :  
r \= await get\_qrcode\_login\_info()  
self.auth\_code \= r\["auth\_code"\]  
self.qrcode\_url \= r\["url"\]  
return self.qrcode\_url  
async def get\_qrcode(self, url: Optional\[ str \] \= None,  
print\_qr=False, base64\_encode=False,  
url \= url or (await self.get\_qrcode\_url()  
if login\_type \== "app"  
else await self.get\_web\_qrcode\_url())  
qr \= QRCode()  
qr.add\_data(url)  
if print\_qr:  
qr.print\_tty()  
return None  
img \= qr.make\_image(image\_factory=PyPNGImage)  
\`\`\`

\`\`\`  
buf \= BytesIO()  
img.save(buf)  
if not base64\_encode:  
return buf.getvalue()  
return b64encode(buf.getvalue()).decode()  
async def web\_qrcode\_login(self, auth\_code=None, retry=-1, interval=1):  
auth\_code \= auth\_code or self.auth\_code  
\# Implementation continues...  
\`\`\`  
"gt":\["’bilireq/bilireq/\_typing.py’", "’bilireq/bilireq/login/\_init\_.py’", "’bilireq/test/test\_login.py’"  
\]

Instance of Repository Construction

"repo": "got-your-back",  
"description": "GYB is a command-line tool for backing up Gmail messages to a local computer.",  
"function": "Utilizes Gmail’s API over HTTPS to securely download and store emails locally,  
offering installation options for Linux, MacOS, and Windows.",  
"files": \[ { "file": "got-your-back/fmbox.py", "function": "This library provides functionality  
to read and manipulate mbox files sequentially, allowing extraction, modification, and removal  
of email headers, as well as iterating through messages in an mbox file." }, "file": "got-your-  
back/gyb.py", "function": "This script is a command-line tool for backing up and restoring Gmail  
messages. It supports various actions such as backup, restore, count, purge, and label management,  
and integrates with Google APIs for Gmail and Google Workspace services. The tool uses OAuth  
2.0 for authentication and supports both user accounts and service accounts." , "file": "got-your-  
back/labellang.py", "function": "Unable to read file content." \],  
"gt": "\[\[’got-your-back/labellang.py’, ’got-your-back/gyb.py’\], \[’got-your-back/fmbox.py’, ’got-  
your-back/gyb.py’\]\]"

Instance of Repository Construction

"repo": "ip\_basic",

"content":

'import␣ip\_basic/ip\_basic/vis\_utils.py'  
\*\*import\*\* cv2

\*\*def\*\* cv2\_show\_image(window\_name, image, size\_wh=None, location\_xy=None):  
"""Helper function for specifying window size and location when displaying images with cv2.

\`\`\`  
Args:  
window\_name: str window name  
image: ndarray image to display  
size\_wh: window size (w, h)  
location\_xy: window location (x, y)  
"""  
if size\_wh is not None:  
cv2.namedWindow(window\_name, cv2.WINDOW\_KEEPRATIO | cv2.WINDOW\_GUI\_NORMAL)  
cv2.resizeWindow(window\_name, \*size\_wh)  
else :  
cv2.namedWindow(window\_name, cv2.WINDOW\_AUTOSIZE)  
if location\_xy is not None:  
cv2.moveWindow(window\_name, \*location\_xy)  
\`\`\`

\`\`\`  
cv2.imshow(window\_name, image)  
\`\`\`  
'import␣ip\_basic/demos/depth\_completion.py'  
\*\*import\*\* glob  
\*\*import\*\* os  
\*\*import\*\* sys  
\*\*import\*\* time  
\*\*import\*\* cv2  
\*\*import\*\* numpy as np  
\*\*import\*\* png  
\*\*from\*\* ip\_basic \*\*import\*\* depth\_map\_utils  
\*\*from\*\* ip\_basic \*\*import\*\* vis\_utils

\*\*def\*\* main():  
"""Depth maps are saved to the'outputs'folder."""  
\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#  
\# Options  
\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#  
\# Validation set  
input\_depth\_dir \= os.path.expanduser('\~/Kitti/depth/depth\_selection/val\_selection\_cropped/  
velodyne\_raw')  
data\_split \='val'  
\# Test set  
\# input\_depth\_dir \= os.path.expanduser('\~/Kitti/depth/depth\_selection/  
test\_depth\_completion\_anonymous/velodyne\_raw')  
\# data\_split \='test'  
\# Fast fill with Gaussian blur @90Hz (paper result)  
fill\_type \='fast'  
extrapolate \= True  
blur\_type \='gaussian'  
\# Fast Fill with bilateral blur, no extrapolation @87Hz (recommended)  
\# fill\_type \='fast'  
\# extrapolate \= False  
\# blur\_type \='bilateral'  
\# Multi-scale dilations with extra noise removal, no extrapolation @ 30Hz  
\# fill\_type \='multiscale'  
\# extrapolate \= False  
\# blur\_type \='bilateral'  
\# Save output to disk or show process  
save\_output \= True  
\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#  
\# Processing  
\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#  
\*\*if\*\* save\_output:  
\# Save to Disk  
show\_process \= False  
save\_depth\_maps \= True  
\*\*else\*\* :  
\*\*if\*\* fill\_type \=='fast':  
\*\*raise\*\* ValueError('"fast"␣fill␣does␣not␣support␣show\_process')  
\# Show Process  
show\_process \= True  
save\_depth\_maps \= False  
\# Create output folder  
this\_file\_path \= os.path.dirname(os.path.realpath(\_\_file\_\_))  
outputs\_dir \= this\_file\_path \+'/outputs'  
os.makedirs(outputs\_dir, exist\_ok=True)  
output\_folder\_prefix \='depth\_'+ data\_split  
output\_list \= \*\*sorted\*\* (os.listdir(outputs\_dir))

\*\*if len\*\* (output\_list) \> 0:  
split\_folders \= \[folder \*\*for\*\* folder \*\*in\*\* output\_list \*\*if\*\* folder.startswith(  
output\_folder\_prefix)\]  
\*\*if len\*\* (split\_folders) \> 0:  
last\_output\_folder \= split\_folders\[-1\]  
last\_output\_index \= \*\*int\*\* (last\_output\_folder.split('\_')\[-1\])  
\*\*else\*\* :  
last\_output\_index \= \-1  
\*\*else\*\* :  
last\_output\_index \= \-1  
output\_depth\_dir \= outputs\_dir \+'/{}\_{:03d}'. \*\*format\*\* (output\_folder\_prefix,  
last\_output\_index \+ 1\)

\*\*if\*\* save\_output:  
\*\*if not\*\* os.path.exists(output\_depth\_dir):  
os.makedirs(output\_depth\_dir)  
\*\*else\*\* :  
\*\*raise\*\* FileExistsError('Already␣exists\!')  
\*\*print\*\* ('Output␣dir:', output\_depth\_dir)

\# Get images in sorted order  
images\_to\_use \= \*\*sorted\*\* (glob.glob(input\_depth\_dir \+'/\*'))

\# Rolling average array of times for time estimation  
avg\_time\_arr\_length \= 10  
last\_fill\_times \= np.repeat(\[1.0\], avg\_time\_arr\_length)  
last\_total\_times \= np.repeat(\[1.0\], avg\_time\_arr\_length)

num\_images \= \*\*len\*\* (images\_to\_use)  
\*\*for\*\* i \*\*in range\*\* (num\_images):

\`\`\`  
depth\_image\_path \= images\_to\_use\[i\]  
\# Calculate average time with last n fill times  
avg\_fill\_time \= np.mean(last\_fill\_times)  
avg\_total\_time \= np.mean(last\_total\_times)  
\# Show progress  
sys.stdout.write('\\rProcessing␣{}␣/␣{},␣'  
'Avg␣Fill␣Time:␣{:.5f}s,␣'  
'Avg␣Total␣Time:␣{:.5f}s,␣'  
'Est␣Time␣Remaining:␣{:.3f}s'. format (  
i, num\_images \- 1, avg\_fill\_time, avg\_total\_time,  
avg\_total\_time \* (num\_images \- i)))  
sys.stdout.flush()  
\# Start timing  
start\_total\_time \= time.time()  
\# Load depth projections from uint16 image  
depth\_image \= cv2.imread(depth\_image\_path, cv2.IMREAD\_ANYDEPTH)  
projected\_depths \= np.float32(depth\_image / 256.0)  
\# Fill in  
start\_fill\_time \= time.time()  
if fill\_type \=='fast':  
final\_depths \= depth\_map\_utils.fill\_in\_fast(  
projected\_depths, extrapolate=extrapolate, blur\_type=blur\_type)  
elif fill\_type \=='multiscale':  
final\_depths, process\_dict \= depth\_map\_utils.fill\_in\_multiscale(  
projected\_depths, extrapolate=extrapolate, blur\_type=blur\_type,  
show\_process=show\_process)  
else :  
raise ValueError('Invalid␣fill\_type␣{}'. format (fill\_type))  
end\_fill\_time \= time.time()  
\# Display images from process\_dict  
if fill\_type \=='multiscale' and show\_process:  
\`\`\`

\`\`\`  
img\_size \= (570, 165\)  
x\_start \= 80  
y\_start \= 50  
x\_offset \= img\_size\[0\]  
y\_offset \= img\_size\[1\]  
x\_padding \= 0  
y\_padding \= 28  
img\_x \= x\_start  
img\_y \= y\_start  
max\_x \= 1900  
row\_idx \= 0  
for key, value in process\_dict.items():  
image\_jet \= cv2.applyColorMap(  
np.uint8(value / np.amax(value) \* 255),  
cv2.COLORMAP\_JET)  
vis\_utils.cv2\_show\_image(  
key, image\_jet,  
img\_size, (img\_x, img\_y))  
img\_x \+= x\_offset \+ x\_padding  
if (img\_x \+ x\_offset \+ x\_padding) \> max\_x:  
img\_x \= x\_start  
row\_idx \+= 1  
img\_y \= y\_start \+ row\_idx \* (y\_offset \+ y\_padding)  
\# Save process images  
cv2.imwrite('process/'+ key \+'.png', image\_jet)  
cv2.waitKey()  
\# Save depth images to disk  
if save\_depth\_maps:  
depth\_image\_file\_name \= os.path.split(depth\_image\_path)\[1\]  
\# Save depth map to a uint16 png (same format as disparity maps)  
file\_path \= output\_depth\_dir \+'/'+ depth\_image\_file\_name  
with open (file\_path,'wb') as f:  
depth\_image \= (final\_depths \* 256).astype(np.uint16)  
\# pypng is used because cv2 cannot save uint16 format images  
writer \= png.Writer(width=depth\_image.shape\[1\],  
height=depth\_image.shape\[0\],  
bitdepth=16,  
greyscale=True)  
writer.write(f, depth\_image)  
end\_total\_time \= time.time()  
\# Update fill times  
last\_fill\_times \= np.roll(last\_fill\_times, \-1)  
last\_fill\_times\[-1\] \= end\_fill\_time \- start\_fill\_time  
\# Update total times  
last\_total\_times \= np.roll(last\_total\_times, \-1)  
last\_total\_times\[-1\] \= end\_total\_time \- start\_total\_time  
\`\`\`  
\*\*if\*\* \_\_name\_\_ \== "\_\_main\_\_":  
main()

"called\_code\_segment":

\*\*def\*\* cv2\_show\_image(window\_name, image, size\_wh=None, location\_xy=None):  
"""Helper function for specifying window size and location when

\`\`\`  
displaying images with cv2.  
Args:  
window\_name: str window name  
image: ndarray image to display  
size\_wh: window size (w, h)  
location\_xy: window location (x, y)  
"""  
if size\_wh is not None:  
cv2.namedWindow(window\_name,  
cv2.WINDOW\_KEEPRATIO | cv2.WINDOW\_GUI\_NORMAL)  
cv2.resizeWindow(window\_name, \*size\_wh)  
else :  
cv2.namedWindow(window\_name, cv2.WINDOW\_AUTOSIZE)  
if location\_xy is not None:  
cv2.moveWindow(window\_name, \*location\_xy)  
cv2.imshow(window\_name, image)  
\`\`\`  
"feature\_description": "Add an option to save the displayed images to disk.",  
"detailed\_feature\_description": "Modify the ‘cv2\_show\_image‘ function in \#file 1 to accept an  
additional parameter ‘save\_path‘ which, if provided, will save the displayed image to the specified  
path. Update the invocation in \#file 2 to include this new parameter and save the images to a  
specified directory.",  
"modified\_complete\_code":  
\# file 1  
\*\*import\*\* cv2

\*\*def\*\* cv2\_show\_image(window\_name, image, size\_wh=None, location\_xy=None, save\_path=None):  
"""  
Helper function for specifying window size and location when displaying images with cv2.  
Args:  
window\_name: str, window name  
image: ndarray, image to display  
size\_wh: tuple, window size (w, h)  
location\_xy: tuple, window location (x, y)  
save\_path: str, path to save the image  
"""  
\*\*if\*\* size\_wh \*\*is not\*\* None:  
cv2.namedWindow(window\_name, cv2.WINDOW\_KEEPRATIO | cv2.WINDOW\_GUI\_NORMAL)  
cv2.resizeWindow(window\_name, \*size\_wh)  
\*\*else\*\* :  
cv2.namedWindow(window\_name, cv2.WINDOW\_AUTOSIZE)  
\*\*if\*\* location\_xy \*\*is not\*\* None:  
cv2.moveWindow(window\_name, \*location\_xy)  
cv2.imshow(window\_name, image)  
\*\*if\*\* save\_path \*\*is not\*\* None:  
cv2.imwrite(save\_path, image)

\# file 2  
\*\*if\*\* fill\_type \=='multiscale' \*\*and\*\* show\_process:  
img\_size \= (570, 165\)  
x\_start \= 80  
y\_start \= 50  
x\_offset \= img\_size\[0\]  
y\_offset \= img\_size\[1\]  
x\_padding \= 0  
y\_padding \= 28

\`\`\`  
img\_x \= x\_start  
img\_y \= y\_start  
max\_x \= 1900  
row\_idx \= 0  
for key, value in process\_dict.items():  
image\_jet \= cv2.applyColorMap(np.uint8(value / np.amax(value) \* 255), cv2.COLORMAP\_JET)  
save\_path \='process/'+ key \+'.png'  
vis\_utils.cv2\_show\_image(key, image\_jet, img\_size, (img\_x, img\_y), save\_path=save\_path)  
img\_x \+= x\_offset \+ x\_padding  
if (img\_x \+ x\_offset \+ x\_padding) \> max\_x:  
img\_x \= x\_start  
row\_idx \+= 1  
img\_y \= y\_start \+ row\_idx \* (y\_offset \+ y\_padding)  
cv2.waitKey()  
\`\`\`  
\#\# G Crowdsourcing

In conducting our study, we identified several potential risks to participants. Firstly, there is a risk to  
privacy and confidentiality, as participants are required to share personal information. To mitigate this, all  
data will be anonymized and stored securely, with access restricted to authorized personnel only. Secondly,  
there may be psychological risks, such as discomfort or stress during the tasks. To address this, we have  
included detailed instructions and debriefing sessions to ensure participants feel supported throughout the  
process. Additionally, participants have the right to withdraw from the study at any time without penalty.  
Lastly, while there are no significant physical risks associated with our procedures, we will monitor  
participants for any signs of distress and provide appropriate support. We pay each participant an hourly  
rate of $10. The primary participants we recruit are college students majored in software engineering with  
master degree (Age ranging 23-28).


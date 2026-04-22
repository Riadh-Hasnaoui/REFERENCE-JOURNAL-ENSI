\`\`\`  
Findings of the Association for Computational Linguistics: ACL 2025, pages 10134–  
July 27 \- August 1, 2025 ©2025 Association for Computational Linguistics  
\`\`\`  
\# DI-BENCH: Benchmarking Large Language Models on Dependency

\# Inference with Testable Repositories at Scale

\#\# Linghao Zhang\*1,2, Junhao Wang\*1,3, Shilin He†^1 , Chaoyun Zhang^1 , Yu Kang^1 , Bowen Li^4 ,

\#\# Jiaheng Wen\*1,5,Chengxing Xie^4 ,Maoquan Wang^1 ,Yufan Huang^1 ,Elsie Nallipogu^1 ,

\#\# Qingwei Lin^1 ,Yingnong Dang^1 ,Saravan Rajmohan^1 ,Dongmei Zhang^1 ,Qi Zhang^1

(^1) Microsoft, (^2) Wuhan University, (^3) Tongji University,  
(^4) Shanghai AI Laboratory, (^5) Zhejiang University

\#\# Abstract

\`\`\`  
Large Language Models have advanced auto-  
mated software development, however, it re-  
mains a challenge to correctly infer depen-  
dencies, namely, identifying the internal com-  
ponents and external packages required for a  
repository to successfully run. Existing stud-  
ies highlight that dependency-related issues  
cause over 40% of observed runtime errors  
on the generated repository. To address this,  
we introduceDI-BENCH^1 , a large-scale bench-  
mark and evaluation framework specifically  
designed to assess LLMs’ capability on depen-  
dency inference. The benchmark features 581  
repositories with testing environments across  
Python, C\#, Rust, and JavaScript. Extensive  
experiments with textual and execution-based  
metrics reveal that the current best-performing  
model achieves only a 48% execution pass  
rate on Python, indicating significant room for  
improvement. DI-BENCHestablishes a new  
viewpoint for evaluating LLM performance on  
repositories, paving the way for more robust  
end-to-end software synthesis.  
\`\`\`  
\#\# 1 Introduction

\`\`\`  
Large Language Models (LLMs) have revolu-  
tionized automated software development, scal-  
ing from function-level code completion (GitHub,  
2023\) to repository-level code synthesis (Wang  
et al., 2024; Qian et al., 2024; Ibrahimzada et al.,  
2024). A pivotal yet often overlooked step in this  
process is ensuring that generated repositories are  
fully executable. This requires accurate inference  
and integration of all necessary dependencies, both  
internal (across project components) and external  
(from package ecosystems). Without robust de-  
pendency inference, even the most advanced code  
\*Work done during internship at Microsoft.  
†Correspondence to: shilhe@microsoft.com.  
\`\`\`  
(^1) Code and data: https://github.com/Microsoft/  
DI-Bench  
A Python Repository  
src/  
metrics.py  
main.py  
$\_\_init$\_\_.py  
tests/  
test\_main.py  
pyproject.toml  
README.md  
$$...  
\[build-system\]  
build-backend \= $$...  
\[project\]  
name \= "A Python Project"  
authors \= \[$$...\]  
classifiers \= {$$...}  
dependencies \= \[  
"pandas$==1.5.3",  
"scikit-learn$==1.1.0",  
\]  
\[tool.setuptools\]  
$$...  
pyproject.toml  
Crucial for exec\!  
Figure 1: An example of Python project dependencies.  
generation solutions risk failing at runtime, im-  
peding further iteration, evaluation, and reliable  
deployment.  
As illustrated in Figure 1, dependency inference  
involves understanding the intricate relationships  
within the codebase and mapping out the exter-  
nal packages required for execution. Such depen-  
dencies are typically documented in configuration  
files that may vary from language to language (see  
Appendix A). Correctly reconstructing these rela-  
tionships is a foundational capability: it not only  
ensures that code generation tools produce func-  
tional and self-contained repositories, but it also in-  
forms deeper reasoning about project architecture  
and build systems (PyPI, 2024; crates.io, 2024).  
Consequently, mastering dependency inference is  
a critical leap forward for enabling robust, end-to-  
end software synthesis and maintenance.  
Despite the significance of dependency infer-  
ence, current LLM-based approaches struggle in  
this area. Works like ChatDev (Qian et al., 2024\)  
and DevBench (Li et al., 2024a)—pioneers in  
repository-level generation using multi-agent LLM  
systems—have reported that dependency-related  
issues (e.g., missing or incorrectly specified mod-  
ules) account for over 50% of their observed run-  
time errors. MetaGPT (Hong et al., 2024\) also  
demonstrates that missing or incorrectly generated  
dependencies represent one of the most significant  
10134

hallucinations when LLMs attempt to generate the  
entire project. These challenges highlight the dif-  
ficulty that state-of-the-art models face in accu-  
rately navigating build systems and package repos-  
itories. Although existing repository-level bench-  
marks such as SWEBench (Jimenez et al., 2023),  
RepoBench (Liu et al., 2023), and DevBench (Li  
et al., 2024a) offer valuable insights into a model’s  
ability to handle large contexts and generate code  
at scale, none focuses on systematically evaluating  
dependency inference capabilities.  
To address this critical gap, we introduceDI-  
BENCH, the first comprehensive repository-level  
benchmark dedicated to dependency inference.DI-  
BENCHcomprises 581 verified repositories, includ-  
ing 387 regular-sized and 194 large-sized, across  
four popular programming languages (Python, C\#,  
Rust, and JavaScript). Each repository is carefully  
curated to assess a model’s ability to identify both  
internal and external dependencies. We pair this  
dataset with a rigorous, multi-faceted evaluation  
framework. Beyond measuring textual matching  
accuracy between model-generated and ground-  
truth dependencies, we propose a novel CI-based  
execution evaluation by reusing each repository’s  
intrinsic Continuous Integration (CI) pipelines as  
automated test harnesses. This approach enables  
scalable and objective assessment of end-to-end ex-  
ecutability, eliminating the costly and error-prone  
need for manual environment setup.  
Through comprehensive experiments involv-  
ing various LLMs and prompting strategies, we  
observed that even the best-performing LLM  
achieved only a 48% executability rate on Python.  
This finding highlightssignificant room for future  
improvementin this area. Our analysis revealed  
that several factors influence performance, includ-  
ing the dependency amount and repository size.  
Notably, issues such as hallucination and chal-  
lenges related to dependency metadata emerged  
as critical bottlenecks that adversely affect model  
performance.  
In summary, our contributions are as follows:

\- DI-BENCHBenchmark:We introduce a pio-  
    neering, large-scale, dependency-focused bench-  
    mark featuring 581 repositories spanning 4 pop-  
    ular programming languages. It establishes a  
    new standard for evaluating LLMs’ capabilities  
    in realistic, repository-scale scenarios.  
\- Dual-Use CI Infrastructure:We leverage CI  
    workflows not only to identify executable reposi-

\`\`\`  
tories during dataset curation but also to serve as  
a reliable, fully automated test environment. By  
using CI pipelines, we ensure that dependency  
checks remain robust, scalable, and faithful to  
real-world development practices.  
\`\`\`  
\- Granular Evaluation Metrics: We combine  
    coarse-grained runtime executability measures  
    with fine-grained precision and recall on inferred  
    dependencies. This dual-layered approach en-  
    ables systematic analysis of both functional cor-  
    rectness and textual accuracy with richer in-  
    sights.

\`\`\`  
By spotlighting dependency inference and offering  
a dedicated benchmark, our work lays the founda-  
tion for advancing LLMs toward robust, end-to-end  
repository-level software synthesis.  
\`\`\`  
\#\# 2 Related Works

\`\`\`  
Repository-level coding tasks have attracted in-  
creasing attention in recent years. Many bench-  
marks (Zhang et al., 2023; Liu et al., 2023; Ding  
et al., 2023\) center on code completion tasks at var-  
ious granularities \- from individual lines and API  
calls to entire function implementations. SWE-  
Bench and its variant (Jimenez et al., 2023; Yang  
et al., 2024\) challenge LLMs and LLM-powered  
systems with real-world scenarios, using issues  
and pull requests from popular Python reposi-  
tories on GitHub. While these benchmarks fo-  
cus on assistant-like tasks, recent work explores  
LLMs’ capabilities in complete project generation.  
DevBench (Li et al., 2024a) decomposes the de-  
velopment process into distinct stages and eval-  
uates AI performance at each stage. Agent-As-  
a-Judge (Zhuge et al., 2024\) introduces DevAI,  
innovatively employing LLM agents as evaluators  
of development outcomes.  
However, existing works have not adequately  
addressed build configuration evaluation: code  
completion tasks (Zhang et al., 2023; Liu et al.,  
2023; Ding et al., 2023\) do not generate build  
files, and issue-fixing benchmarks like SWE-  
Bench (Jimenez et al., 2023\) contain only 1% of  
patches related to build configurations. In reposi-  
tory generation tasks (Li et al., 2024a; Zhuge et al.,  
2024), build file generation is merely treated as one  
subtask without dedicated evaluation.  
Recent works on dependency or version spe-  
cific code generation (Wu et al., 2024b; Liu et al.,  
2024b; Islah et al., 2024; Kuhar et al., 2024\) have  
\`\`\`

\`\`\`  
import sklearn.metrics  
import pandas as pd  
def get\_metric():  
if task $== 'classification':  
if label\[columns\[ 0 \]\].nunique() \> 2:  
metric \= 'accuracy'  
else:  
metric \= 'roc\_auc'  
else:  
metric \= 'r2'  
assert metric in sklearn.metrics.SCORERS.keys()  
\`\`\`  
\`\`\`  
🤖 LLM  
\`\`\`  
\`\`\`  
Generate code:  
\`\`\`  
\`\`\`  
Cannot be executed directly ❌  
Need dependency packages\!  
\`\`\`  
\`\`\`  
Generate configuration file:  
\`\`\`  
\`\`\`  
dependencies \= \[  
"pandas$\>=0.20.3",  
"scikit-learn$\>=1.2.2",  
\]  
\`\`\`  
\`\`\`  
🤖 LLM  
\`\`\`  
\`\`\`  
dependencies \= \[  
"pandas$==1.5.3",  
"scikit-learn$==1.1.0",  
\]  
\`\`\`  
\`\`\`  
Ground Truth  
\`\`\`  
\# 🤕

\`\`\`  
Version mismatch:  
requires scikit-learn\<=1.1.  
Deprecated in version 1.2.  
\`\`\`  
\`\`\`  
Run test AttributeError: module  
'sklearn.metrics' has  
no attribute 'SCORERS'  
\`\`\`  
\# 🙂

\`\`\`  
Run test  
Test Pass\!  
\`\`\`  
\`\`\`  
LLM may fail to identify dependencies  
used in its generated code  
\`\`\`  
\# 🧑💻 Help me write the code do the following: ...

\`\`\`  
Figure 2: An example of incorrectly identifying dependencies used in code.  
\`\`\`  
explored code generation tasks based on evolving  
dependencies and API usage changes. Our paper  
aims to infer the dependencies from existing code,  
which can be seen as the reverse process. Prior  
research in dependency inference (Ye et al., 2022;  
damnever, 2024\) has predominantly focused on  
Python ecosystems using traditional program anal-  
ysis techniques, while lacking broader language  
coverage. Our study fills in this gap by providing  
a benchmark specifically designed for evaluating  
dependency inference capability across multiple  
mainstream languages.

\#\# 3 Dependency Inference

Although many studies focus on repository code  
generation with LLMs recently, there exists a sig-  
nificant gap between the generated code and theex-  
ecutableandoperationalsoftware,Dependency. In  
this paper, we adaptDependency Inference, which  
aims to generate a list of dependencies based on the  
source code. As shown in Figure 2, the code gener-  
ated by LLM cannot be executed directly without  
installing the required dependencies; However, it is  
non-trivial to identify the correct dependencies us-  
ing LLMs. The example shows that the LLM gen-  
erates dependencies with a wrong version (‘scikit-  
learn==1.1.0’ rather than ‘scikit-learn\>=1.2.2’),  
resulting in execution failure.

Automatic and accurate dependency inference  
makes end-to-end code development possible by  
installing the inferred dependencies for execution.  
Furthermore, it can enable key scenarios like fully-  
automated evaluation and iterative code improve-  
ment with execution feedback. Besides the reposi-  
tory, dependency inference can be also applied to  
small code snippets like Python Notebook, incre-  
mental code changes, andetc.

\`\`\`  
Formally, the task is formulated as below: Given  
a software repository containing many source  
code files and build configuration files where  
dependency-related sections are masked, the de-  
pendency inference task aims to generate a list of  
inferred dependencies to fill into the configuration.  
Formally, we define the task as:  
F: (R,{bm 1 , bm 2 , ..., bmk})→{b 1 , b 2 , ..., bk} (1)  
whereRdenotes the repository including all source  
files,bmi is a build configuration file with depen-  
dency masked/removed,biis a build configura-  
tion with the inferred dependencies. The output  
candidate space consists of every possible com-  
binations of dependencies and versions for each  
programming language, while format and gram-  
mar of dependencies are also considered during  
evaluation. For example, in a Python project, given  
apyproject.tomlfile with masked dependency  
sections and all source code files, the task is to edit  
pyproject.tomlfile to specifying all dependen-  
cies required by the project.  
\`\`\`  
\#\# 4 DI-BENCH

\`\`\`  
Focused on the task ofdependency inference, we in-  
troduceDI-BENCH, a meticulously curated, large-  
scale benchmark dataset and evaluation framework  
at the repository level.DI-BENCHencompasses  
581 real-world, testable repository instances across  
4 programming languages, providing a comprehen-  
sive platform for assessing LLM-based methods in  
identifying and managing repository dependencies.  
\`\`\`  
\`\`\`  
4.1 Statistics & Features  
DI-BENCH’s instances, sourced from real-world  
repositories, are categorized into two subsets based  
on repository size:regularandlarge. Theregu-  
larsubset includes repositories with fewer than  
\`\`\`

\`\`\`  
Table 1: Comparison of features between existing benchmarks and DI-BENCH  
\`\`\`  
\`\`\`  
Benchmark Task Evaluation Scope Languages \#Repo Curation  
MBPP (Austin et al., 2021\) Code Generation Unit Tests Function Python N/A Manual  
HumanEval (Chen et al., 2021\) Code Generation Unit Tests Function Python N/A Manual  
ClassEval (Du et al., 2023\) Code Generation Unit Tests Class Python N/A Manual  
RepoEval (Zhang et al., 2023\) Code Completion Textual & Unit Tests Repo-level Python 14 Manual  
RepoBench (Liu et al., 2023\) Retrieval & Completion Only Textual Repo-level Python, Java 1,669 Automated  
CrossCodeEval (Ding et al., 2023\) Code Completion Only Textual Repo-level Python, Java, C\#, TS 1,002 Automated  
EvoCodeBench (Li et al., 2024b) Code Generation Unit Tests Repo-level Python 25 Automated  
RepoMasterEval (Wu et al., 2024a) Code Completion Unit Tests Repo-level Python, TS 6 Manual  
DI-BENCH Dependency Inference Textual & Test Suite Repo-level Python, Rust, C\#, JS 581 Automated  
\`\`\`  
\`\`\`  
Table 2: Statistical summary of DI-BENCH  
\`\`\`  
\`\`\`  
Subset Lang \#Files \#LoC \#Tokens \#Deps. \#Tests  
\`\`\`  
\`\`\`  
Regular  
\`\`\`  
\`\`\`  
Python 30.9 3.0K 31K 5.5 47\.  
Rust 20.2 3.4K 32K 10.8 21\.  
C\# 69.7 4.1K 39K 25.9 30\.  
JS 14.9 1.6K 15K 5.7 42\.  
Avg. 33.9 3.0K 29K 11.9 35\.  
\`\`\`  
\`\`\`  
Large  
\`\`\`  
\`\`\`  
Python 268.3 45.6K 519K 11.8 547\.  
Rust 95.0 23.9K 283K 45.4 155\.  
C\# 353.9 37.3K 369K 44.5 132\.  
JS 144.9 26.0K 367K 16.2 304\.  
Avg. 218.0 33.4K 385K 29.7 285\.  
\`\`\`  
120k tokens^2 , ensuring they fit within the con-  
text length limits of recent LLMs. It comprises  
387 instances with an average of 11.9 dependen-  
cies. Thelargesubset consists of 194 reposito-  
ries with more than 120k tokens and the average  
dependency count is 29.7. Table 2 provides de-  
tailed statistics ofDI-BENCH, while Figure 10  
illustrates the overall distribution of token and de-  
pendency counts using Kernel Density Estimation  
(KDE) curves. The dataset exhibits a wide size  
distribution, with smaller repositories being more  
prevalent. Table 1 shows a comparative analysis of  
features distinguishingDI-BENCHfrom existing  
code task benchmarks. The unique attributes of  
DI-BENCHinclude:  
Beyond Code. DI-BENCHfocuses on a crucial  
challenge in real-world software development: de-  
pendency inference. This essential aspect is often  
overlooked in existing studies.  
Test Execution.DI-BENCHnot only evaluates re-  
sult correctness through textual matching but also  
executes project test suites, providing a straightfor-  
ward and reliable evaluation.  
Practical and Verified. The repository instances  
included inDI-BENCH are sourced from real-  
world projects on GitHub, thus making the bench-  
mark both practical and challenging. Each project

(^2) Token counts are calculated with Llama 3.2 tokenizer.  
undergoes verification to ensure its validity.  
Diverse Long Inputs. The dataset includes two  
subsets, regular and large, with a wide distribution  
of context lengths, ranging from small repositories  
with a few files to large projects with over 200 files.  
Continually Updatable. We have developed a  
dataset curation pipeline that is fully automated,  
scalable, and continuously updatable, eliminating  
the need for manual annotation to set up environ-  
ments and run tests.  
Open Solution. Our evaluation framework fea-  
tures two complementary datasets: while both the  
regular and large sets welcome various approaches  
including language models and agentic systems,  
the large set presents additional challenges of  
model context limits, specifically motivating the  
exploration of novel methodologies.  
4.2 Dataset Construction  
Creating a dataset that supports execution-based  
evaluation at the repository level is challenging.  
Previous works often involve manual setting up  
environments and writing test scripts, which can  
require significant human and engineering effort  
and cannot scale up to larger datasets. As shown in  
Table 1, the existing largest repository-level bench-  
mark supporting test execution contains only 25  
repositories. To address this, we leverage GitHub  
Actions (GitHub, 2024)—a widely used continu-  
ous integration (CI) tool that allows developers to  
automate test execution through YAML configura-  
tion files. By reusing these developer-written CI  
workflows within repositories, we propose an au-  
tomated curation pipeline that eliminates human  
engagement during the benchmark construction,  
ultimately resulting in a dataset of 581 testable  
repositories—23 times larger than the largest pre-  
vious benchmark. With the large-scale dataset, we  
can provide more generalizable insights and more  
robust evaluations. Figure 3 illustrates steps to  
construct DI-BENCHwith details listed below.

\`\`\`  
‣4 Languages  
\`\`\`  
\`\`\`  
‣Stars \> 100  
\`\`\`  
\`\`\`  
‣Github Actions Enabled  
\`\`\`  
\`\`\`  
‣Size \< 10 MB  
\`\`\`  
\`\`\`  
Repository Crawling  
\`\`\`  
\`\`\`  
Candidate Repos  
\`\`\`  
\`\`\`  
Test Job Locating  
‣Which is Testing CI?  
.github/  
└──workflows/  
├──lint.yml  
├──test.yml  
└──publish.yml  
namejobs: Main test :  
\`\`\`  
$test$... (^) :  
(^) stepsruns-on: : ubuntu-latest

\- namerun: pip install .\[dev\] : Install dependencies  
\- namerun: pytest ./test\_folder : Run test

\`\`\`  
Locate Testing Job  
\`\`\`  
\`\`\`  
Execution Validating  
‣CI Runner  
\`\`\`  
\`\`\`  
‣ Run actions/setup-python  
‣ Install dependencies  
‣Run test  
$== 132 passed, 3 skipped in 320.76s $==  
‣ Complete Job  
\`\`\`  
\`\`\`  
‣ Run actions/checkout 1s  
55s  
1m 21s  
5m 20s  
0s  
\`\`\`  
\`\`\`  
Verified mask Repo Instance  
\`\`\`  
\`\`\`  
Figure 3: CI-based curation pipeline for DI-BENCH.  
\`\`\`  
Repository Crawling. The goal of this phase  
is to collect GitHub repositories that meet the  
following criteria: 1\) Written in one of the four  
programming languages: Python, C\#, Rust, or  
JavaScript (the characteristics of these languages  
and their dependency configurations are detailed  
in Appendix A). These languages are popular, pos-  
sess a standardized dependency packages ecosys-  
tem, and have clear standards for specifying de-  
pendencies. 2\) Have more than 100 stars, serv-  
ing as a quality filter criterion. 3\) Repository  
size is less than 10MB to avoid extremely large  
repositories and maintain a manageable dataset  
size. 4\) Most importantly, the repository must have  
GitHub Actions enabled, indicated by the presence  
of the.github/workflowsfolder. Repositories  
that meet these criteria proceed as candidate repos-  
itories into subsequent phases.

Test Job Locating. Repositories often define  
multiple workflows to perform tasks unrelated to  
testing, such as linting and publishing. These tasks  
may also be defined within different jobs in the  
same workflow configuration file. Due to the lack  
of a specific naming convention, we introduce an  
LLM-assisted locating process to identify the spe-  
cific jobs responsible for executing project tests.  
At the execution stage, only the test job will be run.

Execution Validating. We use act (nektos,  
2024\) as a local runner for GitHub Actions, en-  
abling local execution of repository testing CI.  
In this phase, by executing the test jobs of can-  
didate repositories, we obtain those that success-  
fully follow the workflow and pass all tests as ex-  
pected. The validation phase ensures that the se-  
lected repositories are correct and executable, high-  
lighting the advantage of our proposed CI-based  
testing approach: fully automated and scalable.

\`\`\`  
Dependency Masking. After the validation, we  
utilized an automated script to remove the sections  
specifying dependencies in the configuration files.  
We further performed sanitization by removing any  
existing dependency lock files (e.g., in JavaScript)  
to prevent potential ground truth leakage and en-  
sure proper execution. This process ultimately pro-  
duced the instances included in DI-BENCH.  
\`\`\`  
\#\# 5 Experiment Setup

\`\`\`  
This section provides a detailed description of the  
experimental settings, including the LLMs, base-  
line methods, and evaluation metrics.  
\`\`\`  
\`\`\`  
Baseline Methods. We designed three baseline  
systems with various prompting strategies to eval-  
uate how LLMs perform in thedependency in-  
ferencetask, intentionally avoiding complex tech-  
niques such as agent-based methods.  
\`\`\`  
\- All-In-One: The approach concatenates all the  
    source code of a repository into a single query for  
    model generation. It serves as a straightforward  
    yet computationally intensive baseline.  
\- File-Iterate: The method processes each individ-  
    ual file in the repository to generate dependen-  
    cies, with the results subsequently aggregated  
    to feed into the model for generating the final  
    output. This simulates a modular and distributed  
    reasoning approach.  
\- Imports-Only: The approach collects all import-  
    related statements from the code base as the in-  
    put context to LLMs usingtree-sitter(tree-sitter,  
    2024). For Python and JavaScript, we extract all  
    importstatements; for C\# and Rust, we extract  
    allusestatements. More details about tree-sitter  
    are provided in the Appendix H.4.

\`\`\`  
Additionally, we report the human performance  
in Appendix C via recruiting experienced develop-  
ers. Two additional baselines including program  
analysis approach and Retrieval-Augmented Gener-  
ation (RAG) baseline are presented in Appendix E.  
Metrics. we use textual and execution-based met-  
rics, and the fake rate in evaluation.  
\`\`\`  
\- Textual Accuracy: This metric assesses whether  
    the generated dependencies align with the  
    ground truth from a textual matching perspec-  
    tive. We compute thePrecision(ratio of correct  
    dependencies among model-generated ones),Re-  
    call(Ratio of correct dependencies among all  
    ground-truth ones), andF1(The harmonic mean  
    of the above).  
\- Executability Rate: This metric measures  
    whether the project can be successfully built and  
       executed through CI testing pipeline with the  
       generated dependencies. A score of 1 is assigned  
       if all tests passed successfully; otherwise, a score  
       of 0 will be given. Whether the tests pass is the  
       most direct and reliable indicator of the correct-  
       ness of the generated dependencies.  
\- Fake Rate: This metric represents the propor-  
    tion of the generated dependencies that cannot  
    be found in the package ecosystem (for external  
    dependencies) or in the local repository direc-  
    tory (for internal dependencies). It highlights the  
    hallucination issue in LLMs, where non-existent  
    dependencies or versions are generated.

Models. Since code repositories are usually very  
long, we choose LLMs that support at least  
128k context windows as the backbone mod-  
els, including proprietary models: GPT-4o (Ope-  
nAI, 2024b), GPT-4o-mini (OpenAI, 2024a),  
Claude 3.5 Sonnet (Anthropic, 2025), and Gem-  
ini 2.0 Flash (Google, 2025), and open-source  
models: Qwen-Coder-V2.5-Instruct (Hui et al.,  
2024), Llama 3.1-Instruct (Grattafiori et al., 2024),  
DeepSeek-Coder-V2-Lite-Instruct (MoE) (Guo  
et al., 2024\) and DeepSeek V3 (Liu et al., 2024a).  
Detailed settings on model serving are presented  
in Appendix H.5.

\#\# 6 Experimental Results

\`\`\`  
6.1 Performance of Baseline Methods  
\`\`\`  
We start by conducting preliminary experiments  
utilizing three baseline systems — All-In-One,

\`\`\`  
File-Iterate, and Imports-Only on GPT-4o and GPT-  
4o-Mini (Table 10 in Appendix F.1), encompass-  
ing both the regular and large subsets. Table 3  
shows the results with several key insights:  
Challenging Nature of Dependency Inference  
Dependency inference presents a significant chal-  
lenge for contemporary LLMs. In the regular sub-  
set (\< 120k tokens), even the best-performing mod-  
els achieved executability rates of below 50% for  
scripting languages such as Python and JavaScript  
and only around 10% for compiled languages like  
Rust and C\#. These findings underscore the lim-  
itations of current models in accurately inferring  
dependencies in various languages.  
Impact of Repository Size Large repositories,  
characterized by extensive contexts and complex  
dependency structures, are more challenging for  
dependency inference. Executability rates in the  
large subset were markedly lower across all base-  
line methods compared to the regular subset. For  
File-Iterate and Imports-Only, the performance gap  
was especially evident, indicating the difficulty of  
adapting these methods to large repositories.  
Importance of Models and Prompting Strate-  
gies The choice of backbone LLMs and the con-  
struction of prompts play crucial roles in deter-  
mining performance outcomes. For instance, the  
All-In-One approach with GPT-4o, by merging  
the entire code base into a single query, consis-  
tently outperformed other methods on executability.  
However, this approach does not work for larger  
repositories. While the File-Iterate and Imports-  
Only methods can process large repositories, their  
performance significantly declined without the full  
code context. The finding reveals the trade-off be-  
tween prompting strategies and repository sizes to  
achieve optimal performance on the task.  
Hallucination Issues A recurring issue across  
all methods was the generation of hallucinated de-  
pendencies, i.e., non-existent packages or versions,  
as indicated by the Fake Rate. Specifically, we  
observed a remarkably higher Fake Rate on large  
subset with Imports-Only method. In Section 6.3,  
we will show that the hallucination adversely af-  
fected the executability.  
\`\`\`  
\`\`\`  
6.2 Performance of Different Models  
For simplicity, we report benchmark results on the  
DI-BENCHRegular dataset using the All-In-One  
approach in the following sections. The method  
\`\`\`

\`\`\`  
Table 3: Performance of benchmark methods across programming languages and repository sizes on GPT-4o, where  
Exec denotes the executability rate, P/R/F1 denote Precision, Recall, and F1-score, FR denotes Fake Rate, which is  
the lower, the better. Note that the Large repositories cannot fit into the All-In-One method (denoted with ‘-’).  
\`\`\`  
\`\`\`  
Lang Method Regular Large  
Exec P R F1 FR Exec P R F1 FR  
\`\`\`  
\`\`\`  
Python  
\`\`\`  
\`\`\`  
All-In-One 42.9 61.8 73.6 67.2 2.8 \- \- \- \- \-  
File-Iterate 29.6 38.1 75.6 50.7 4.5 8.0 19.5 35.3 25.1 6\.  
Imports-Only 36.7 56.5 74.9 64.4 3.9 18.0 36.9 46.9 41.3 23\.  
\`\`\`  
\`\`\`  
Rust  
\`\`\`  
\`\`\`  
All-In-One 11.2 93.7 74.4 82.9 0.8 \- \- \- \- \-  
File-Iterate 7.1 74.7 75.6 75.2 1.1 2.0 45.0 68.8 54.4 6\.  
Imports-Only- 4.1 88.9 65.0 75.1 1.0 2.0 84.9 50.6 63.4 12\.  
\`\`\`  
\`\`\`  
C\#  
\`\`\`  
\`\`\`  
All-In-One 13.5 59.9 39.4 47.5 3.7 \- \- \- \- \-  
File-Iterate 5.2 27.7 34.1 30.6 6.8 0.0 20.4 33.0 25.2 6\.  
Imports-Only 3.1 52.7 29.8 38.1 5.2 0.0 49.1 19.2 27.6 6\.  
\`\`\`  
\`\`\`  
JavaScript  
\`\`\`  
\`\`\`  
All-In-One 43.2 86.9 67.7 76.1 4.8 \- \- \- \- \-  
File-Iterate 32.6 52.2 62.6 57.0 2.9 15.6 34.2 52.1 41.3 2\.  
Imports-Only 22.1 73.6 46.7 57.1 6.2 6.7 55.4 15.5 24.2 2\.  
\`\`\`  
\`\`\`  
29.8%  
\`\`\`  
\`\`\`  
17.5% 22.8%  
\`\`\`  
\`\`\`  
14.0%  
\`\`\`  
\`\`\`  
10.5%5.3% Missing Dependency in testCategories  
Dependency Not Found in build  
Invalid Dependency Version in build  
Mismatched Dependency Version in test  
Other Failure in test  
Other Failure in build  
\`\`\`  
\`\`\`  
Figure 4: Distribution of failure categories (GPT-4o,  
All-In-One setting, Python).  
\`\`\`  
has shown superior performance in Table 3 and can  
reflect a zero-shot setting for the dependency infer-  
ence task. Specifically, in this section, we evaluate  
various LLMs and report the results in Table 4\.  
It reveals Claude 3.5 Sonnet achieves outstand-  
ing performances across all languages. Notably,  
DeepSeek V3 outperforms all models on Python  
and JavaScript. The Qwen-7B model demonstrates  
superior performance than the other two small  
open-sourced models. In addition, we vary the  
model sizes based on the QWen2.5-Coder-Instruct  
series, where the model size ranges from 3B, 7B,  
14B to 32B. We observed that the model in gen-  
eral achieves better performance when increasing  
the model size. The results and more analysis are  
presented in Appendix F.2.  
Failure Categories and Distribution. To better  
understand why the execution failed with model-  
generated dependencies, we manually analyzed  
the failure cases of GPT-4o, the best-performing  
model, under the All-In-One setting in Python.  
As shown in Figure 4, the most common failure  
category is “Missing Dependency in Test”, which

\`\`\`  
means that the model missed to generate some de-  
pendencies that are required during the testing eval-  
uation. Additionally, “Dependency Not Found in  
Build” and “Invalid Dependency Version in Build”  
also account for a significant proportion. These in-  
dicate that the model-generated dependency spec-  
ifications either include nonexistent packages or  
specify nonexistent versions, leading to failures  
when installing generated dependencies. More  
analysis on case studies and representative root  
causes are presented in Appendix G.  
\`\`\`  
\`\`\`  
6.3 Further Analysis and Ablation Study  
In this section, we conduct further analysis with  
focuses on how repository size and the amount  
of dependencies affect dependency inference per-  
formance, as well as the impact of dependency  
metadata and the hallucination issue.  
Challenges in dependency inference for larger  
repositories with more dependencies. As illus-  
trated in Figure 5, inference accuracy decreases  
significantly as the number of dependencies grows.  
This trend is consistent across all languages, partic-  
ularly those with complex dependency structures  
like Rust and JavaScript. The decline in perfor-  
mance is attributed to the difficulty of maintaining  
accurate dependency mappings as their quantity  
increases, highlighting spaces for future enhance-  
ment of LLMs. Besides, we made further analysis  
about how the repository size affect the perfor-  
mance on the regular dataset and results are de-  
picted in Figure 13 (Appendix F.3). We observed  
a negative correlation between repository size and  
model performance, which aligns with the find-  
\`\`\`

\`\`\`  
Table 4: Model performance across programming languages with the All-In-One approach on DI-BENCH.  
\`\`\`  
\`\`\`  
Language Model Size Exec P R F1 FR  
\`\`\`  
\`\`\`  
Python  
\`\`\`  
\`\`\`  
GPT-4o \- 42.9 61.8 73.6 67.2 2\.  
GPT-4o-mini \- 24.5 56.5 57.5 57.0 2\.  
Gemini 2.0 Flash \- 42.0 75.0 73.8 74.4 1\.  
Claude 3.5 Sonnet \- 39.0 74.4 79.6 76.9 1\.  
Qwen2.5-Coder-7B-Instruct 7B 22.4 55.4 44.7 49.5 5\.  
Llama-3.1-8B-Instruct 8B 13.3 28.8 38.4 32.9 4\.  
DeepSeek-Coder-V2-Lite-Instruct 16B(MoE) 17.3 48.0 48.6 48.3 18\.  
DeepSeek V3 671B(MoE) 48.0 72.5 74.3 73.4 1\.  
\`\`\`  
\`\`\`  
Rust  
\`\`\`  
\`\`\`  
GPT-4o \- 11.2 93.7 74.4 82.9 0\.  
GPT-4o-mini \- 7.1 76.0 49.1 59.7 1\.  
Gemini 2.0 Flash \- 14.0 94.7 76.2 84.5 1\.  
Claude 3.5 Sonnet \- 39.0 96.8 92.6 94.7 8\.  
Qwen2.5-Coder-7B-Instruct 7B 6.1 71.3 41.0 52.0 2\.  
Llama-3.1-8B-Instruct 8B 1.0 58.2 37.0 45.2 10\.  
DeepSeek-Coder-V2-Lite-Instruct 16B(MoE) 2.0 75.9 40.8 53.0 2\.  
DeepSeek V3 671B(MoE) 20.0 93.5 82.5 87.7 1\.  
\`\`\`  
\`\`\`  
C\#  
\`\`\`  
\`\`\`  
GPT-4o \- 13.5 59.9 39.4 47.5 3\.  
GPT-4o-mini \- 4.2 41.5 22.3 29.0 11\.  
Gemini 2.0 Flash \- 21.0 65.1 48.2 55.4 4\.  
Claude 3.5 Sonnet \- 31.0 74.7 54.1 62.8 0\.  
Qwen2.5-Coder-7B-Instruct 7B 1.0 22.7 17.1 19.5 14\.  
Llama-3.1-8B-Instruct 8B 0.0 15.2 7.6 10.1 23\.  
DeepSeek-Coder-V2-Lite-Instruct 16B(MoE) 1.0 33.6 7.4 12.1 9\.  
DeepSeek V3 671B(MoE) 16.0 60.0 38.9 47.2 3\.  
\`\`\`  
\`\`\`  
JavaScript  
\`\`\`  
\`\`\`  
GPT-4o \- 43.2 86.9 67.7 76.1 4\.  
GPT-4o-mini \- 16.8 84.6 31.6 46.0 2\.  
Gemini 2.0 Flash \- 24.0 89.6 71.9 79.8 1\.  
Claude 3.5 Sonnet \- 53.0 88.0 87.7 87.9 2\.  
Qwen2.5-Coder-7B-Instruct 7B 16.8 81.8 43.3 56.6 3\.  
Llama-3.1-8B-Instruct 8B 9.5 67.2 16.7 26.8 1\.  
DeepSeek-Coder-V2-Lite-Instruct 16B(MoE) 17.9 83.9 32.0 46.3 2\.  
DeepSeek V3 671B(MoE) 54.0 79.1 77.6 78.3 9\.  
\`\`\`  
Table 5: Execution success improvement by replacing  
predicted dependency metadata with oracle metadata.

\`\`\`  
Language Exec Exec (with Orac.) ∆  
Python 42.9 55.1 \+28.4%  
Rust 11.2 38.8 \+246.4%  
C\# 13.5 15.6 \+15.6%  
JavaScript 43.2 67.4 \+50.5%  
\`\`\`  
ing obtained in Table 3\. This suggests that long-  
context reasoning (Hsieh et al., 2024; Bai et al.,  
2024\) remains a significant challenge for LLMs, as  
longer input contexts lead to increased complexity.

Reasoning the dependency metadata is a bot-  
tleneck. In previous experiments, we found that  
while textual accuracy was relatively high, the exe-  
cutability rate was significantly lower. For exam-  
ple, GPT-4o achieved a precision of 61.8% and  
recall of 73.6% on Python, while the executability  
rate was only 42.9%. We suspect this discrepancy

\`\`\`  
arises from incorrect metadata generation in depen-  
dencies, such as package version constraints, extra  
features and so on, (examples can be found in Ap-  
pendix A). To validate this hypothesis, we replaced  
the predicted dependencies with oracle metadata  
and observed a notable increase in the executability  
rate. As shown in Table 5, the Python executability  
rate improved from 42.9% to 55.1%, representing  
a relative increase of 28.4%. It demonstrates the  
importance of accurate dependency metadata for  
successful execution of dependency configurations.  
Hallucination hurts the executability. We ob-  
served all models generate hallucinated dependen-  
cies that do not exist, as indicated by the fake rate.  
Although the fake rate was relatively low, exclud-  
ing the hallucinated dependencies can improve the  
executability, as shown in Table 6\. These improve-  
ments, though modest, reinforce the need for more  
accurate dependency predictions. Hallucination  
issues remain one of the primary obstacles to im-  
\`\`\`

\`\`\`  
0-44-88-1212-1616-2020-24\>  
\`\`\`  
\`\`\`  
0  
\`\`\`  
\`\`\`  
10  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
30  
\`\`\`  
\`\`\`  
40  
\`\`\`  
\`\`\`  
Number of Instances  
\`\`\`  
\`\`\`  
Python  
TotalExec Pass  
\`\`\`  
\`\`\`  
0-4 4-88-1212-1616-2020-24\>  
\`\`\`  
\`\`\`  
0  
\`\`\`  
\`\`\`  
5  
\`\`\`  
\`\`\`  
10  
\`\`\`  
\`\`\`  
15  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
25  
\`\`\`  
\`\`\`  
30  
\`\`\`  
\`\`\`  
35 Rust Total  
Exec Pass  
\`\`\`  
\`\`\`  
0-88-1616-2424-3232-4040-48\>  
Dependency Count  
\`\`\`  
\`\`\`  
0  
\`\`\`  
\`\`\`  
5  
\`\`\`  
\`\`\`  
10  
\`\`\`  
\`\`\`  
15  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
25  
\`\`\`  
\`\`\`  
Number of Instances  
\`\`\`  
\`\`\`  
C\#  
Total  
Exec Pass  
\`\`\`  
\`\`\`  
0-4 4-88-1212-1616-2020-24\>  
Dependency Count  
\`\`\`  
\`\`\`  
0  
\`\`\`  
\`\`\`  
10  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
30  
\`\`\`  
\`\`\`  
40  
\`\`\`  
\`\`\`  
50  
JavaScript  
Total  
Exec Pass  
\`\`\`  
\`\`\`  
Figure 5: Execution pass rate w.r.t dependency count.  
\`\`\`  
\`\`\`  
Table 6: Impact of hallucination on exeutability rate.  
\`\`\`  
\`\`\`  
Language Exec Exec w.o. Fake Dep. ∆  
Python 41.8 43.8 \+4.8%  
Rust 11.2 13.3 \+18.8%  
C\# 12.5 13.5 \+8.9%  
JavaScript 43.2 43.2 \+0%  
\`\`\`  
\`\`\`  
proving the reliability of dependency inference.  
\`\`\`  
\#\# 7 Conclusion

We introduceDI-BENCH, the first benchmark ded-  
icated to dependency inference across 581 repos-  
itories in four programming languages: Python,  
C\#, Rust, and JavaScript. In addition to measur-  
ing textual accuracy, we propose a novel CI-based  
evaluation that incorporates actual tests execution.  
Extensive experiments on various open-source and  
proprietary LLMs demonstrate that even the most  
advanced models struggle to infer dependencies  
accurately, highlighting opportunities for future ad-  
vancements. We believe this study lays the ground-  
work for repository-level code development, with  
dependency inference serving as a pivotal step to-  
ward fully automated code generation.

\#\# Limitations

\`\`\`  
Our study acknowledges several limitations.  
❶Due to constraints in computing resources, our  
evaluation primarily focused on five mainstream  
models, selecting smaller model sizes. While these  
models are sufficiently representative, broadening  
the scope to include a greater variety of LLMs  
\`\`\`  
\`\`\`  
with diverse sizes could potentially enrich our find-  
ings.❷In our experiments, we employed the GPT-  
4o and GPT-4o mini models, which operate as  
black boxes. The outputs may vary due to poten-  
tial model upgrades or fluctuations in resources.  
To mitigate this issue, we provide the dates of the  
model versions used as a reference and set the tem-  
perature to 0 to ensure more consistent outputs.  
❸Test coverage for each repository may not be  
exhaustive, meaning some test cases might not en-  
compass every possible code path. However, as  
the tests were developed by project contributors,  
the results are expected to reflect practical settings  
accurately.  
\`\`\`

\#\# References

Anthropic. 2025\. Claude 3.5 Sonnet. https://www.  
anthropic.com/news/claude-3-5-sonnet.

Jacob Austin, Augustus Odena, Maxwell Nye, Maarten  
Bosma, Henryk Michalewski, David Dohan, Ellen  
Jiang, Carrie Cai, Michael Terry, Quoc Le, et al.

2021\. Program synthesis with large language models.  
arXiv preprint arXiv:2108.07732.

Yushi Bai, Xin Lv, Jiajie Zhang, Hongchang Lyu,  
Jiankai Tang, Zhidian Huang, Zhengxiao Du, Xiao  
Liu, Aohan Zeng, Lei Hou, Yuxiao Dong, Jie Tang,  
and Juanzi Li. 2024\. Longbench: A bilingual, mul-  
titask benchmark for long context understanding.  
Preprint, arXiv:2308.14508.

Mark Chen, Jerry Tworek, Heewoo Jun, Qiming  
Yuan, Henrique Ponde de Oliveira Pinto, Jared Ka-  
plan, Harri Edwards, Yuri Burda, Nicholas Joseph,  
Greg Brockman, Alex Ray, Raul Puri, Gretchen  
Krueger, Michael Petrov, Heidy Khlaaf, Girish Sas-  
try, Pamela Mishkin, Brooke Chan, Scott Gray,  
Nick Ryder, Mikhail Pavlov, Alethea Power, Lukasz  
Kaiser, Mohammad Bavarian, Clemens Winter,  
Philippe Tillet, Felipe Petroski Such, Dave Cum-  
mings, Matthias Plappert, Fotios Chantzis, Eliza-  
beth Barnes, Ariel Herbert-Voss, William Hebgen  
Guss, Alex Nichol, Alex Paino, Nikolas Tezak, Jie  
Tang, Igor Babuschkin, Suchir Balaji, Shantanu Jain,  
William Saunders, Christopher Hesse, Andrew N.  
Carr, Jan Leike, Josh Achiam, Vedant Misra, Evan  
Morikawa, Alec Radford, Matthew Knight, Miles  
Brundage, Mira Murati, Katie Mayer, Peter Welinder,  
Bob McGrew, Dario Amodei, Sam McCandlish, Ilya  
Sutskever, and Wojciech Zaremba. 2021\. Evaluating  
large language models trained on code. Preprint,  
arXiv:2107.03374.

crates.io. 2024\. The Rust community’s crate registry.  
https://crates.io/.

damnever. 2024\. A tool to generate require-  
ments.txt for Python project, and more than that.  
https://github.com/damnever/pigar.

Yangruibo Ding, Zijian Wang, Wasi Uddin Ahmad,  
Hantian Ding, Ming Tan, Nihal Jain, Murali Krishna  
Ramanathan, Ramesh Nallapati, Parminder Bhatia,  
Dan Roth, and Bing Xiang. 2023\. Crosscodeeval:  
A diverse and multilingual benchmark for cross-file  
code completion.Preprint, arXiv:2310.11248.

Xueying Du, Mingwei Liu, Kaixin Wang, Hanlin Wang,  
Junwei Liu, Yixuan Chen, Jiayi Feng, Chaofeng  
Sha, Xin Peng, and Yiling Lou. 2023\. Classe-  
val: A manually-crafted benchmark for evaluating  
llms on class-level code generation.arXiv preprint  
arXiv:2308.01861.

GitHub. 2023\. GitHub Copilot – Your AI pair program-  
mer.https://github.com/features/copilot.

GitHub. 2024\. GitHub Actions: Automate your work-  
flow from idea to production. https://github.  
com/features/actions.

\`\`\`  
Google. 2025\. Gemini 2.0 Flash.https://deepmind.  
google/technologies/gemini/flash/.  
Aaron Grattafiori, Abhimanyu Dubey, Abhinav Jauhri,  
Abhinav Pandey, and et al. Abhishek Kadian.  
\`\`\`  
2024\. The llama 3 herd of models. Preprint,  
arXiv:2407.21783.  
Daya Guo, Qihao Zhu, Dejian Yang, Zhenda Xie,  
Kai Dong, Wentao Zhang, Guanting Chen, Xiao  
Bi, Yu Wu, YK Li, et al. 2024\. Deepseek-coder:  
When the large language model meets programming–  
the rise of code intelligence. arXiv preprint  
arXiv:2401.14196.  
Sirui Hong, Mingchen Zhuge, Jonathan Chen, Xiawu  
Zheng, Yuheng Cheng, Jinlin Wang, Ceyao Zhang,  
Zili Wang, Steven Ka Shing Yau, Zijuan Lin, Liyang  
Zhou, Chenyu Ran, Lingfeng Xiao, Chenglin Wu,  
and Jürgen Schmidhuber. 2024\. MetaGPT: Meta pro-  
gramming for a multi-agent collaborative framework.  
InThe Twelfth International Conference on Learning  
Representations (ICLR).  
Cheng-Ping Hsieh, Simeng Sun, Samuel Kriman, Shan-  
tanu Acharya, Dima Rekesh, Fei Jia, Yang Zhang,  
and Boris Ginsburg. 2024\. Ruler: What’s the real  
context size of your long-context language models?  
Preprint, arXiv:2404.06654.  
Binyuan Hui, Jian Yang, Zeyu Cui, Jiaxi Yang, Day-  
iheng Liu, Lei Zhang, Tianyu Liu, Jiajun Zhang,  
Bowen Yu, Keming Lu, et al. 2024\. Qwen2. 5-coder  
technical report.arXiv preprint arXiv:2409.12186.  
Ali Reza Ibrahimzada, Kaiyao Ke, Mrigank Pawagi,  
Muhammad Salman Abid, Rangeet Pan, Saurabh  
Sinha, and Reyhaneh Jabbarvand. 2024\. Repository-  
level compositional code translation and validation.  
arXiv preprint arXiv:2410.24117.  
Nizar Islah, Justine Gehring, Diganta Misra, Eilif  
Muller, Irina Rish, Terry Yue Zhuo, and Mas-  
simo Caccia. 2024\. Gitchameleon: Unmasking the  
version-switching capabilities of code generation  
models.arXiv preprint arXiv:2411.05830.  
Carlos E Jimenez, John Yang, Alexander Wettig,  
Shunyu Yao, Kexin Pei, Ofir Press, and Karthik  
Narasimhan. 2023\. Swe-bench: Can language mod-  
els resolve real-world github issues?arXiv preprint  
arXiv:2310.06770.  
Sachit Kuhar, Wasi Uddin Ahmad, Zijian Wang, Ni-  
hal Jain, Haifeng Qian, Baishakhi Ray, Murali Kr-  
ishna Ramanathan, Xiaofei Ma, and Anoop Deoras.  
2024\. Libevolutioneval: A benchmark and study  
for version-specific code generation.arXiv preprint  
arXiv:2412.04478.  
Bowen Li, Wenhan Wu, Ziwei Tang, Lin Shi, John  
Yang, Jinyang Li, Shunyu Yao, Chen Qian, Binyuan  
Hui, Qicheng Zhang, Zhiyin Yu, He Du, Ping Yang,  
Dahua Lin, Chao Peng, and Kai Chen. 2024a. De-  
vbench: A comprehensive benchmark for software  
development.Preprint, arXiv:2403.08604.

Jia Li, Ge Li, Xuanming Zhang, Yihong Dong, and  
Zhi Jin. 2024b. Evocodebench: An evolving code  
generation benchmark aligned with real-world code  
repositories.arXiv preprint arXiv:2404.00599.

Aixin Liu, Bei Feng, Bing Xue, Bingxuan Wang,  
Bochao Wu, Chengda Lu, Chenggang Zhao, Chengqi  
Deng, Chenyu Zhang, Chong Ruan, et al. 2024a.  
Deepseek-v3 technical report. arXiv preprint  
arXiv:2412.19437.

Tianyang Liu, Canwen Xu, and Julian McAuley.

2023\. Repobench: Benchmarking repository-level  
code auto-completion systems. arXiv preprint  
arXiv:2306.03091.

Zeyu Leo Liu, Shrey Pandit, Xi Ye, Eunsol Choi, and  
Greg Durrett. 2024b. Codeupdatearena: Benchmark-  
ing knowledge editing on api updates.arXiv preprint  
arXiv:2407.06249.

nektos. 2024\. act: Run your GitHub Actions locally.  
https://nektosact.com/.

OpenAI. 2024a. GPT-4o mini: advancing cost-efficient  
intelligence.

OpenAI. 2024b. Hello GPT-4o. https://openai.  
com/index/hello-gpt-4o/.

PyPI. 2024\. Find, install and publish Python packages  
with the Python Package Index. https://https:  
//pypi.org/.

Chen Qian, Wei Liu, Hongzhang Liu, Nuo Chen, Yufan  
Dang, Jiahao Li, Cheng Yang, Weize Chen, Yusheng  
Su, Xin Cong, Juyuan Xu, Dahai Li, Zhiyuan Liu,  
and Maosong Sun. 2024\. Chatdev: Communica-  
tive agents for software development. Preprint,  
arXiv:2307.07924.

tree-sitter. 2024\. Tree-sitter.https://tree-sitter.  
github.io/tree-sitter/.

Xingyao Wang, Boxuan Li, Yufan Song, Frank F.  
Xu, Xiangru Tang, Mingchen Zhuge, Jiayi Pan,  
Yueqi Song, Bowen Li, Jaskirat Singh, Hoang H.  
Tran, Fuqiang Li, Ren Ma, Mingzhang Zheng, Bill  
Qian, Yanjun Shao, Niklas Muennighoff, Yizhe  
Zhang, Binyuan Hui, Junyang Lin, Robert Bren-  
nan, Hao Peng, Heng Ji, and Graham Neubig.

2024\. OpenHands: An Open Platform for AI Soft-  
ware Developers as Generalist Agents. Preprint,  
arXiv:2407.16741.

Qinyun Wu, Chao Peng, Pengfei Gao, Ruida Hu, Haoyu  
Gan, Bo Jiang, Jinhe Tang, Zhiwen Deng, Zhanming  
Guan, Cuiyun Gao, et al. 2024a. Repomastereval:  
Evaluating code completion via real-world reposito-  
ries.arXiv preprint arXiv:2408.03519.

Tongtong Wu, Weigang Wu, Xingyu Wang, Kang Xu,  
Suyu Ma, Bo Jiang, Ping Yang, Zhenchang Xing,  
Yuan-Fang Li, and Gholamreza Haffari. 2024b. Ver-  
sicode: Towards version-controllable code genera-  
tion.arXiv preprint arXiv:2406.07411.

\`\`\`  
John Yang, Carlos E. Jimenez, Alex L. Zhang, Kil-  
ian Lieret, Joyce Yang, Xindi Wu, Ori Press,  
Niklas Muennighoff, Gabriel Synnaeve, Karthik R.  
Narasimhan, Diyi Yang, Sida I. Wang, and Ofir  
Press. 2024\. Swe-bench multimodal: Do ai systems  
generalize to visual software domains? Preprint,  
arXiv:2410.03859.  
Hongjie Ye, Wei Chen, Wensheng Dou, Guoquan Wu,  
and Jun Wei. 2022\. Knowledge-based environment  
dependency inference for python programs. In 2022  
IEEE/ACM 44th International Conference on Soft-  
ware Engineering (ICSE), pages 1245–1256.  
Fengji Zhang, Bei Chen, Yue Zhang, Jacky Keung, Jin  
Liu, Daoguang Zan, Yi Mao, Jian-Guang Lou, and  
Weizhu Chen. 2023\. Repocoder: Repository-level  
code completion through iterative retrieval and gen-  
eration.arXiv preprint arXiv:2303.12570.  
Mingchen Zhuge, Changsheng Zhao, Dylan Ash-  
ley, Wenyi Wang, Dmitrii Khizbullin, Yunyang  
Xiong, Zechun Liu, Ernie Chang, Raghuraman Kr-  
ishnamoorthi, Yuandong Tian, Yangyang Shi, Vikas  
Chandra, and Jürgen Schmidhuber. 2024\. Agent-  
as-a-judge: Evaluate agents with agents.Preprint,  
arXiv:2410.10934.  
\`\`\`

\#\# A Example of Configuration Files

This section introduces the types of configuration  
files for the four languages involved in this paper.  
These files specify project dependencies and serve  
as carriers for storing inference results. They also  
exercise the capabilities of LLMs to interact with  
modern programming languages build systems, it  
is important to provide a clear demonstration here.  
Python (Figure 6)pyproject.tomlis the con-  
figuration file used by most Python projects. It  
includes sections for specifying metadata such as  
package names and authors, defining project de-  
pendencies, and configuring various development  
tools.

\`\`\`  
Figure 6: An example ofpyproject.tomlin Python  
\`\`\`  
Rust(Figure 7)Cargo.tomlis the configuration  
file used in Rust projects. A single repository may  
contain multiple local crates, each with its own  
Cargo.toml, requiring proper configuration of in-  
ternal dependency references.

C\#(Figure 8\) Similar to Rust projects, C\# repos-  
itories are often structured as solutions contain-  
ing multiple internal projects. Each project uses a  
.csprojconfiguration file to specify external and  
internal dependencies and configure compilation  
options.

JavaScript(Figure 9)package.jsonis the con-  
figuration file used in JavaScript projects, particu-

\`\`\`  
Figure 7: An example ofCargo.tomlin Rust  
\`\`\`  
\`\`\`  
larly those managed with Node.js. It defines meta-  
data such as the project name, version, and descrip-  
tion, and specifies dependencies, scripts, and entry  
points for the project.  
It can be found that dependency management  
constitutes the majority of the configuration files.  
\`\`\`  
\#\# B Distribution of DI-BENCHDataset on

\#\# Token Count and Dependency Amount

\`\`\`  
Figure 10 illustrates the distribution of token and  
dependency counts across different programming  
languages (Python, Rust, C\#, and JavaScript) for  
both Regular and Large repositories. For Regu-  
lar repositories, the token count distribution shows  
that Python and Rust have a higher density at lower  
token counts, indicating that these languages typi-  
cally have smaller codebases. In contrast, C\# and  
JavaScript display a more spread-out distribution,  
suggesting a wider range of codebase sizes. When  
examining Large repositories, the token count dis-  
tribution shifts substantially, with all languages  
showing a lower density, highlighting the increased  
complexity and size of codebases in larger reposi-  
tories.  
The dependency count distribution for Regular  
repositories reveals that most dependencies are con-  
centrated in the lower range across all languages,  
\`\`\`

\`\`\`  
Figure 8: An example ofexample.csprojin C\#  
\`\`\`  
\`\`\`  
Figure 9: An example ofpackage.jsonin JavaScript  
\`\`\`  
with Python and Rust having slightly higher den-  
sities at lower counts. For Large repositories, the  
dependency count distribution shows a similar pat-  
tern but with slightly higher densities for C\# and  
JavaScript, indicating these languages tend to have  
more dependencies in larger codebases.

\#\# C Human Experiment

Since repository-level dependency inference is a  
new task in LLM benchmarking, we conducted  
a human experiment onDI-BENCHto better un-  
derstand the general manner and performance of  
human developers in this task and to uncover the  
gap between LLMs and humans.

(^0) 0k 25k 50k 75k100k  
1  
2  
3  
Density (Regular)  
1e 5  
Python  
Rust  
C\#  
JavaScript  
0.000 0 50 100 150  
0\.  
0\.  
0\.  
0\.  
120k500k1000k1500k2000k2500k  
Token count  
0\.  
0\.  
1\.  
1\.  
2\.  
Density (Large)  
1e 6  
0 50 100 150  
Dependency count  
0\.  
0\.  
0\.  
0\.  
Figure 10: Distribution of token and dependency count.  
Experiment Setting InDI-BENCH, LLMs need  
to curate the list of dependencies by going through  
the entire repository. To mimic this process, we  
recruited 4 developers who have at least two years  
Python development experience as annotators. We  
sampled 40 repositories from the Python language  
of the regular subset for labelling, and each repos-  
itory involves two annotators to ensure the anno-  
tation quality. For each repository, the annotator  
needs to produce a list of dependencies (includ-  
ing name and version) by reading the source code  
in which the original dependencies were removed.  
It is worth noting that the human annotators are  
allowed to execute the code to test whether the de-  
pendency list is correct and use as feedback. We  
also set a 20-minute time limit for completing each  
repository. The complete instructions for human  
annotators can be found in Figure 11\.  
Results Table 7 presents the average metric  
scores of annotators on the sampled instances, com-  
pared with three prompting baselines of GPT-4o.  
Human performance slightly exceeded the best  
score achieved by GPT-4o. In practice, all the  
dependencies are crafted by human developers by  
iteratively identifying the dependency information  
during code development. In our experiment, de-  
velopers inferred the used packages and versions  
by consulting dependency package’s documenta-  
tion and analyzing API usage in the code. When  
dependency resolution fails or test execution en-  
counters errors, developers can iteratively refine  
their answers by referring to the error messages.  
We observed that participants often relied on search  
and multi-round debugging to complete their an-  
swers. This further highlights the significant room  
for improvement in methods on our benchmark.

1 \# Instructions for Human Annotators  
2  
3 \#\# What You Receive:  
4 A Python repository where the dependency section in pyproject.toml is masked (only  
this file is affected).  
5  
6 \#\# What You Do:  
7 1\. Analyze and infer the dependencies used in the repository.  
8 2\. Edit pyproject.toml in place , filling in the dependency section.  
9 3\. Ensure comprehensive coverage of all dependencies used in the code.  
10 4\. Complete each repository within 20 minutes.  
11 5\. Specify versions and metadata if necessary.  
12 6\. Use command \-line tools and execute code as needed.  
13  
14 \#\# What You Deliver:  
15 A repository with the dependency section in pyproject.toml fully restored.  
16  
17 \#\# Data Consent Notice:  
18 By participating in this annotation task , you agree that your annotations will be  
used as part of a human experiment dataset for research purposes. The collected  
data will be included in a research paper and made publicly available.

\`\`\`  
Figure 11: Instructions for human annotators.  
\`\`\`  
\`\`\`  
Approach Exec P R F1 FR  
All-In-One 47.5 63.3 78.5 70.1 1\.  
File-Iterate 25.0 37.4 75.1 49.9 4\.  
Imports-Only 35.0 54.5 80.4 65.0 3\.  
Human 77.5 82.4 91.9 86.9 1\.  
\`\`\`  
\`\`\`  
Table 7: Human Performance vs. LLM Baselines (on  
40 Python Instances)  
\`\`\`  
\`\`\`  
An agentic approach capable of searching external  
information and performing interactive debugging  
would be a promising direction.  
\`\`\`  
\`\`\`  
Approach Exec P R F1 FR  
All-In-One 42.9 61.8 73.6 67.2 2\.  
File-Iterate 29.6 38.1 75.6 50.7 4\.  
Imports-Only 36.7 56.5 74.9 64.4 3\.  
Pigar 29.0 24.3 44.3 31.4 0\.  
\`\`\`  
\`\`\`  
Table 8: Program analysis-based traditional method vs.  
LLM baselines  
\`\`\`  
\#\# D Program Analysis Baseline

\`\`\`  
Several tools are available for analyzing external  
dependencies in Python codebases, we choose pi-  
gar(damnever, 2024\) as a baseline. The perfor-  
mance of pigar in our python subset is shown in  
Table 8\. The lower score showing that LLM’s mo-  
tivation on dependency inference.  
\`\`\`  
\#\# E RAG Baseline

\`\`\`  
We propose a simple Retrieval-Augmented Gen-  
eration (RAG) approach based on our Imports-  
Only baseline for dependency inference. For each  
source file, the method utilizes tree-sitter to ex-  
tract dependency-related statements. These state-  
ments serve as queries to retrieve semantically sim-  
ilar content within the same file. The underly-  
ing hypothesis is that code segments with textual  
similarity to import statements may contain infor-  
mation for determining appropriate dependency  
versions. We conduct experiments with two re-  
trieval approaches: BM25, and Embedding-based  
retrieval using OpenAI’s text-embedding-ada-  
model. Performance are shown in Table 9\. Our  
experimental results reveals several key limitations  
in our current RAG implementation. First, using  
dependency-related statements as queries may be  
overly simplistic, failing to capture the rich con-  
textual information needed for dependency version  
selection. Second, while the retrieved code seg-  
ments show textual similarity to the queries, they  
may not contain the critical information necessary  
for version determination. Finally, our approach to  
utilizing the retrieved content requires refinement,  
as we need more effective strategies for integrating  
and leveraging this information. The chunk size for  
BM25 and embeddin 512 and we use top-3 retrieve  
results.  
These findings suggest substantial room for im-  
provement in RAG methods on our benchmark. Fu-  
ture research directions could explore more sophis-  
\`\`\`

\`\`\`  
Lang Approach Exec P R F1 FR  
Python All-In-One 42.9 61.8 73.6 67.2 2\.  
File-Iterate 29.6 38.1 75.6 50.7 4\.  
Imports-Only 36.7 56.5 74.9 64.4 3\.  
RAG(BM25) 36.0 60.6 71.2 65.5 3\.  
RAG(embedding) 34.0 63.9 69.5 66.6 1\.  
Rust All-In-One 11.2 93.7 74.4 82.9 0\.  
File-Iterate 7.1 74.7 75.6 75.2 1\.  
Imports-Only 4.1 88.9 65.0 75.1 1\.  
RAG(BM25) 4.0 87.1 59.4 70.6 2\.  
RAG(embedding) 3.0 92.7 60.2 73.0 1\.  
C\# All-In-One 13.5 59.9 39.4 47.5 3\.  
File-Iterate 5.2 27.7 34.1 30.6 6\.  
Imports-Only 3.1 52.7 29.8 38.1 5\.  
RAG(BM25) 2.0 89.4 62.7 73.7 1\.  
RAG(embedding) 7.0 53.1 33.3 40.9 4\.  
Javascript All-In-One 43.2 86.9 67.7 76.1 4\.  
File-Iterate 32.6 52.2 62.6 57.0 2\.  
Imports-Only 22.1 73.6 46.7 57.1 6\.  
RAG(BM25) 11.0 80.1 40.9 54.2 4\.  
RAG(embedding) 12.0 75.8 37.4 50.1 3\.  
\`\`\`  
Table 9: Import-Only baseline Combined with Different  
RAG Methods for Context Enhancement vs. Other  
Baselines

ticated query construction approaches that incor-  
porate code semantic features and project context;  
enhance similarity computation methods to retrieve  
more relevant content; and design more effective  
strategies for analyzing and integrating retrieved  
information. Additionally, the integration of code  
analysis techniques and project dependency graphs  
could potentially enhance the performance of RAG  
methods.

\#\# F Additional Experiments

F.1 Performance of Baseline Methods with  
GPT-4o-mini

Table 10 presents the performance of various  
benchmark methods across different languages and  
repository sizes (Regular and Large) on GPT-4o-  
mini. Notably, the effectiveness of these meth-  
ods varies significantly between Regular and Large  
repositories, with performance generally declining  
as repository size increases. Python and Rust show  
relatively higher performance in Regular reposito-  
ries compared to C\# and JavaScript, which struggle  
more consistently across both repository sizes. Fur-  
thermore, the Imports-Only method for Python and  
File-Iterate method for Rust stand out with com-  
paratively better performance in Regular reposito-  
ries. The results indicate that while some methods  
perform well in smaller repositories, there is a sig-  
nificant drop in effectiveness in larger repositories,  
underscoring the importance of optimizing meth-

\`\`\`  
ods to handle different repository scales efficiently.  
The conclusion aligns with the findings we ob-  
tained in Section 6.1. Besides, the variability sug-  
gests that a one-size-fits-all approach is insufficient,  
and tailored strategies are necessary to maintain  
high performance across different contexts.  
\`\`\`  
\`\`\`  
F.2 Performance When Varying the Model  
Size  
Figure 12 presents the performance of All-In-One  
approach on Regular dataset with different sizes of  
Qwen2.5-Coder-Instruct models. We observed a  
general trend where larger models consistently im-  
proved executability and textual accuracy metrics  
across four languages. Besides, when increasing  
the model size for compiled languages ike Rust  
and C\#, textual accuracy increases sharply, but the  
executability remains relative low, demonstrating  
the great value of our execution-based evaluation  
in benchmarking.  
\`\`\`  
\`\`\`  
3B 7BModel Size14B 32B  
\`\`\`  
\`\`\`  
0  
\`\`\`  
\`\`\`  
10  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
30  
\`\`\`  
\`\`\`  
Exec Pass  
\`\`\`  
\`\`\`  
Exec Pass vs Model Size  
PythonRust  
C\#JavaScript  
\`\`\`  
\`\`\`  
3B 7BModel Size14B 32B  
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
F1 Score  
\`\`\`  
\`\`\`  
F1 Score vs Model Size  
\`\`\`  
\`\`\`  
Figure 12: Model performance across programming  
languages for Qwen2.5-Coder-Instruct  
\`\`\`  
\`\`\`  
F.3 Performance When Varying the  
Repository Size  
In Table 3, we can observe that that dependency  
inference performance deteriorates when applied  
to larger datasets. However, whether this finding  
is generally applicable is unconfirmed. Therefore,  
we conducted a further analysis within the regular  
dataset which contains repositories of varying sizes.  
The results are depicted in Figure 13, showing a  
decline in executability rates as repository size in-  
creases. Hence, there exists a negative correlation  
between repository size and model performance  
both between and within datasets. This suggests  
that long-context reasoning remains a significant  
challenge for LLMs, as longer input contexts lead  
to increased complexity in managing the project  
dependencies. This finding aligns with previous  
studies on long-context reasoning (Hsieh et al.,  
2024; Bai et al., 2024).  
\`\`\`

Table 10: Performance of benchmark methods across programming languages and repository sizes on GPT-4o-mini  
(Continue to Table 3 with a different model)

\`\`\`  
Lang Method Regular Large  
Exec P R F1 FR Exec P R F1 FR  
\`\`\`  
\`\`\`  
Python  
\`\`\`  
\`\`\`  
All-In-One 25.5 56.5 57.5 57.0 2.0 \- \- \- \- \-  
File-Iterate 21.4 41.7 63.7 50.4 2.8 14.0 31.0 27.6 29.2 4\.  
Imports-Only 30.6 59.0 62.0 60.5 1.6 18.0 45.4 32.3 37.7 3\.  
\`\`\`  
\`\`\`  
Rust  
\`\`\`  
\`\`\`  
All-In-One 7.1 76.0 49.1 59.7 1.0 \- \- \- \- \-  
File-Iterate 4.1 74.8 60.4 66.8 1.5 0.0 36.9 45.2 40.6 4\.  
Imports-Only 1.0 77.7 49.4 60.4 1.0 0.0 64.1 23.8 34.7 4\.  
\`\`\`  
\`\`\`  
C\#  
\`\`\`  
\`\`\`  
All-In-One 3.1 41.2 18.8 25.8 12.6 \- \- \- \- \-  
File-Iterate 3.1 25.0 22.8 23.8 15.6 0.0 19.2 13.6 15.9 5\.  
Imports-Only 3.1 44.2 23.5 30.7 6.7 0.0 34.7 14.1 20.1 6\.  
\`\`\`  
\`\`\`  
JavaScript  
\`\`\`  
\`\`\`  
All-In-One 17.9 84.6 31.6 46.0 2.5 \- \- \- \- \-  
File-Iterate 16.8 45.7 25.8 33.0 7.2 2.2 27.0 20.2 23.1 3\.  
Imports-Only 13.7 67.5 19.0 29.6 1.3 2.2 57.9 9.1 15.7 0\.  
\`\`\`  
\`\`\`  
0-20k20k-40k40k-60k60k-80k80k-100k  
100k-120k  
\`\`\`  
\`\`\`  
0  
\`\`\`  
\`\`\`  
10  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
30  
\`\`\`  
\`\`\`  
40  
\`\`\`  
\`\`\`  
Number of Instances  
\`\`\`  
\`\`\`  
Python  
Total  
Exec Pass  
\`\`\`  
\`\`\`  
0-20k20k-40k40k-60k60k-80k80k-100k  
100k-120k  
\`\`\`  
\`\`\`  
0  
\`\`\`  
\`\`\`  
10  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
30  
\`\`\`  
\`\`\`  
40  
\`\`\`  
\`\`\`  
Rust  
Total  
Exec Pass  
\`\`\`  
\`\`\`  
0-20k20k-40k40k-60k60k-80k80k-100k  
Repository Size 100k-120k  
\`\`\`  
\`\`\`  
0  
\`\`\`  
\`\`\`  
5  
\`\`\`  
\`\`\`  
10  
\`\`\`  
\`\`\`  
15  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
25  
\`\`\`  
\`\`\`  
30  
\`\`\`  
\`\`\`  
35  
\`\`\`  
\`\`\`  
Number of Instances  
\`\`\`  
\`\`\`  
C\#  
Total  
Exec Pass  
\`\`\`  
\`\`\`  
0-20k20k-40k40k-60k60k-80k80k-100k  
Repository Size 100k-120k  
\`\`\`  
\`\`\`  
0  
\`\`\`  
\`\`\`  
10  
\`\`\`  
\`\`\`  
20  
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
JavaScript  
Total  
Exec Pass  
\`\`\`  
\`\`\`  
Figure 13: Execution pass rate w.r.t repository size  
\`\`\`  
\#\# G Case Study

To gain a better understanding of the root causes  
and patterns of LLM errors in dependency reason-  
ing, we conduct an in-depth analysis of a repre-  
sentative sample for each error category (Figure  
4\) in this section. Figure 14–17 presents the de-  
tailed information of four fail instances inferred  
by GPT-4o, including a comparison between the  
model-generated results and the ground truth, as  
well as the error messages encountered during fail-  
ure.

\- Missing Dependency in test(Figure 14): In the  
    open2c\_bioframeinstance, the model missed  
    the matplotlib package, resulting in a Modu-

\`\`\`  
leNotFoundError during test execution.  
\`\`\`  
\- Dependency Not Found in build(Figure 15):  
    In themrtolkien\_fastapi\_simple\_security  
    instance, the model inferred a dependency named  
    sqlite3, which does not exist in pip, causing the  
    pip install command to fail.  
\- Invalid Dependency Version in build(Fig-  
    ure 16): In theZuehlke\_ConfZinstance, the  
    model specified an invalid version for the de-  
    pendency python-dotenv, which requires Python  
\>=3.8, while the project is using Python 3.7. This  
caused the pip install stage to fail due to unre-  
solved dependencies.  
\- Mismatched Dependency Version in test(Fig-  
    ure 17): In thecodeskyblue\_tidevice3in-  
    stance, the model correctly inferred the depen-  
    dency pymobiledevice3 but specified an incor-  
    rect version, preventing the import of certain  
    attributes in the code.

\`\`\`  
We found that the model often fails due to infer-  
ring incorrect dependency versions or missing de-  
pendencies used in the code. Our ablation study in  
Section 6.3 also demonstrates that reasoning about  
dependency metadata (e.g., versions) is a bottle-  
neck. This indicates that the model’s dependency-  
related knowledge for the four languages is insuffi-  
cient and exhibits a significant degree of hallucina-  
tion.  
\`\`\`

\`\`\`  
\# Instance: \` open2c\_bioframe \`  
\#\# Dependencies Generated by GPT-4o  
dependencies \= \[  
"numpy",  
"pandas",  
"requests",  
"pyyaml",  
"importlib\_metadata; python\_version\<'3.8'",  
\]  
\#\# Ground Truth  
dependencies \= \[  
"matplotlib",  
"numpy\>=1.10, \<3",  
"pandas\>=1.3",  
"pyyaml",  
"requests",  
"typing-extensions ; python\_version\<'3.9'",  
"importlib-metadata ;  
↪→ python\_version\<'3.8'",  
"importlib-resources ;  
↪→ python\_version\<'3.9'",  
\]  
\#\# Error Message  
\[CI/Test\] | bioframe/vis.py:4: in \<module\>  
\[CI/Test\] | import matplotlib as mpl  
\[CI/Test\] | E ModuleNotFoundError: No  
↪→ module named'matplotlib'  
\`\`\`  
\`\`\`  
Figure 14: A case of the categoryMissing Dependency  
in test  
\`\`\`  
\`\`\`  
\# Instance: \` mrtolkien\_fastapi\_simple\_security \`  
\#\# Dependencies Generated by GPT-4o  
\[tool.poetry.dependencies\]  
python \= "\>=3.7.2,\<4"  
fastapi \= "^0.95.0"  
pydantic \= "^1.10.0"  
starlette \= "^0.20.4"  
sqlite3 \= { version \= "\*", optional \= true }  
\#\# Ground Truth  
\[tool.poetry.dependencies\]  
python \= "\>=3.7.2,\<4"  
fastapi \= "\>=0.70"  
urllib3 \= "\>=1.26.12"  
\#\# Error Message  
\[Python Tests/tests\] | Updating dependencies  
\[Python Tests/tests\] | Resolving  
↪→ dependencies...  
\[Python Tests/tests\] |  
\[Python Tests/tests\] | Because  
fastapi-simple-security depends on sqlite  
(\*) which does not match any versions,  
version solving failed.  
\`\`\`  
\`\`\`  
↪→  
↪→  
↪→  
\[Python Tests/tests\] Failure \- Main Install  
↪→ python dependencies  
\`\`\`  
Figure 15: A case of the categoryDependency Not  
Found in build

\`\`\`  
\# Instance: \` Zuehlke\_ConfZ \`  
\#\# Dependencies Generated by GPT-4o  
\[tool.poetry.dependencies\]  
python \= "^3.7.2"  
pydantic \= "^1.10.2"  
PyYAML \= "^6.0"  
toml \= "^0.10.2"  
python-dotenv \= "^1.0.0"  
\#\# Ground Truth  
\[tool.poetry.dependencies\]  
python \= "^3.7.2"  
pydantic \= "\>=1.9.0, \<3.0.0"  
PyYAML \= "\>=5.4.1, \<7.0.0"  
python-dotenv \= "\>=0.19.2, \<2.0.0"  
toml \= "^0.10.2"  
\#\# Error Message  
\[test/run-test\] | The current project's  
Python requirement (\>=3.7.2,\<4.0.0) is not  
compatible with some of the required  
packages Python requirement:  
\`\`\`  
\`\`\`  
↪→  
↪→  
↪→  
\[test/run-test\] | \- python-dotenv requires  
Python \>=3.8, so it will not be satisfied  
for Python \>=3.7.2,\<3.  
\`\`\`  
\`\`\`  
↪→  
↪→  
\[test/run-test\] |  
\[test/run-test\] | Because no versions of  
python-dotenv match \>1.0.0,\<1.0.1 ||  
\>1.0.1,\<2.0.  
\`\`\`  
\`\`\`  
↪→  
↪→  
\[test/run-test\] | and python-dotenv (1.0.0)  
requires Python \>=3.8, python-dotenv is  
forbidden.  
\`\`\`  
\`\`\`  
↪→  
↪→  
\[test/run-test\] | So, because python-dotenv  
↪→ (1.0.1) requires Python \>=3.  
\[test/run-test\] | and confz depends on  
python-dotenv (^1.0.0), version solving  
failed.  
\`\`\`  
\`\`\`  
↪→  
↪→  
\`\`\`  
\`\`\`  
Figure 16: A case of the categoryInvalid Dependency  
Version in build  
\`\`\`  
\#\# H Experimental Settings

\`\`\`  
H.1 Baseline All-In-One  
In All-In-One, our baseline approach feeds the  
entire codebase as input context to the LLM and  
processes the task through a single LLM call. The  
model simultaneously generates all build configu-  
rations, which are then parsed to obtain the updated  
build files. The complete prompt template used for  
this approach is detailed in Figure 18\.  
\`\`\`  
\`\`\`  
H.2 Baseline Imports-Only  
Imports-Only follows the same prompting strategy  
as All-In-One with a single LLM call. The key  
distinction lies in the input composition: while All-  
In-One includes the complete codebase, Imports-  
Only only incorporates the import statements from  
source files in the input context. This selective ap-  
proach focuses the model’s attention on the most  
\`\`\`

\`\`\`  
\# Instance: \` codeskyblue\_tidevice3 \`  
\#\# Dependencies Generated by GPT-4o  
\[tool.poetry.dependencies\]  
python \= "^3.8"  
click \= "^8.1.3"  
pymobiledevice3 \= "^1.0.0"  
requests \= "^2.31.0"  
pydantic \= "^1.10.2"  
Pillow \= "^10.0.0"  
packaging \= "^23.1"  
fastapi \= "^0.95.2"  
uvicorn \= "^0.22.0"  
imageio \= "^2.31.1"  
\#\# Ground Truth  
\[tool.poetry.dependencies\]  
python \= "^3.8"  
pymobiledevice3 \= "^4.2.3"  
click \= "\*"  
pydantic \= "^2.5.3"  
fastapi \= "\*"  
requests \= "\*"  
numpy \= "\*"  
imageio \= {extras \= \["ffmpeg"\], version \=  
↪→ "^2.33.1"}  
pillow \= "^10.0"  
zeroconf \= "^0.132.2"  
\#\# Error Message  
\[Python Package/test\] | tidevice3/api.py:17:  
↪→ in \<module\>  
\[Python Package/test\] | from  
pymobiledevice3.lockdown import  
LockdownClient, create\_using\_usbmux, usbmux  
\`\`\`  
\`\`\`  
↪→  
↪→  
\[Python Package/test\] | E ImportError:  
cannot import name'create\_using\_usbmux'  
from'pymobiledevice3.lockdown'  
(/project/.venv/lib/python3.8/site-packages  
/pymobiledevice3/lockdown.py)  
\`\`\`  
\`\`\`  
↪→  
↪→  
↪→  
↪→  
\`\`\`  
Figure 17: A case of the categoryMismatched Depen-  
dency Version in test

dependency-relevant code segments. We leverage  
tree-sitter to extract import statements across dif-  
ferent programming languages, with detailed usage  
information provided in Appendix H.4.

H.3 Baseline File-Iterate

File-Iterate employs a two-stage prompting strat-  
egy. In the first stage, it processes source files  
individually, applying the same prompt template  
which is detailed in Appendix H.1 as previous base-  
lines but with a single file as context per LLM call.  
This generates separate build files edits for each  
source file. In the second stage, for each build file,  
we merge its various updates from the first stage  
using a dedicated LLM call, where the prompt is  
shown in Figure 19\. The merge prompt template is  
detailed in Appendix H.3. The final output consists

\`\`\`  
of the comprehensively updated build files derived  
from this two-stage process.  
\`\`\`  
\`\`\`  
H.4 Tree-sitter  
Tree-sitter is a parsing system widely used in  
code analysis that generates concrete syntax trees  
for source code. In our implementation, we uti-  
lize Tree-sitter to extract import statements and  
dependency-related code segments across different  
programming languages. Tree-sitter’s language-  
agnostic nature and robust parsing capabilities en-  
able our system to maintain consistent analysis  
quality across Python, JavaScript, Rust, and other  
supported languages. Tree-sitter queries provide a  
powerful pattern-matching language for searching  
syntax trees. The query language allows precise  
targeting of syntax tree patterns using a declarative,  
S-expression-based syntax. Below is the queries  
we used to extract import statements.  
1 \# Python  
2 \[( import\_statement)  
(import\_from\_statement)\] @import  
3  
4 \# Rust  
5 (use\_declaration) @use  
6  
7 \# C\#  
8 (using\_directive) @use  
9  
10 \# JavaScript  
11 (import\_statement) @import  
\`\`\`  
\`\`\`  
H.5 Model Serving  
For GPT-4o and GPT-4o-mini, we utilize the spe-  
cific versions gpt-4o-20240806 and gpt-4o-mini-  
20240718, accessed through the OpenAI API. For  
Gemini-2.0-Flash we utilize the specific version of  
gemini-2.0-flash-001, accessed through the Google  
API. For Claude-3.5-Sonnet we utilize the specific  
version of claude-3-5-sonnet-20241022, accessed  
through the Anthropic API. For opensource mod-  
els, we employ checkpoints available on Hugging  
Face. We serve deepseek-v3 and deepseek-r1 with  
A100 GPU cluster, and other models with 4 A  
GPUs in single node using VLLM. The decoding  
strategy is configured as greedy decoding with a  
maximum output token limit of 8,000.  
\`\`\`

1 Edit the build files to include all necessary dependency \-related configurations to  
ensure the project builds and runs successfully. Output a copy of each build file.  
2  
3 You will receive four sections of information to configure dependencies in build  
files:  
4 1\. \*\* Project Structure \*\*: A tree structure representing the project's layout.  
5 2\. \*\* Environment Specifications \*\*: Details about the operating system and language  
SDK where the project will run.  
6 3\. \*\* Source Code \*\*: The full source code of the project.  
7 4\. \*\* Build Files \*\*: Build files missing dependency configurations , which you will  
need to update.  
8  
9 \!Important Notes:  
10 1\. The project may include multiple build files. Ensure you update all of them  
with the necessary dependency configurations.  
11 2\. Only edit the files listed in the "Build Files" section.  
12 3\. Limit your edits strictly to dependency configurations within the build files.  
13  
14 To suggest changes to a file you MUST return the entire content of the updated  
file.  
15 You MUST use this \*file listing\* format:  
16  
17 path/to/filename.js  
18 \`\`\`  
19 // entire file content ...  
20 // ... goes in between  
21 \`\`\`  
22  
23 Every \*file listing\* MUST use this format:  
24 \- First line: the filename with any originally provided path; no extra markup ,  
punctuation , comments , etc. \*\*JUST\*\* the filename with path.  
25 \- Second line: opening \`\`\`  
26 \- ... entire content of the file ...  
27 \- Final line: closing \`\`\`  
28  
29 To suggest changes to a file you MUST return a \*file listing\* that contains the  
entire content of the file.  
30 \*NEVER\* skip , omit or elide content from a \*file listing\* using "..." or by adding  
comments like "... rest of code ..."\!  
31 Create a new file you MUST return a \*file listing\* which includes an appropriate  
filename , including any appropriate path.  
32  
33 \--- Begin of Project Structure \---  
34 {project\_structure}  
35 \--- End of Project Structure \---  
36  
37 \--- Begin of Environment Specifications \---  
38 {env\_specs}  
39 \--- End of Environment Specifications \---  
40  
41 \--- Begin of Source Code \---  
42 {src\_section}  
43 \--- End of Source Code \---  
44  
45 \--- Begin of Build Files \---  
46 {build\_section}  
47 \--- End of Build Files \---

\`\`\`  
Figure 18: Prompt template used to generate build file.  
\`\`\`

1 Here is a list of edits to a project's build files , which is generated by add  
dependency configuration according to each source file. Edit the build files to  
merge all edits in the "Build File Edits" section to ensure the project builds and  
runs successfully. Output a copy of the build file.  
2  
3 You will receive four sections of information to configure dependencies in build  
files:  
4 1\. \*\* Project Structure \*\*: A tree structure representing the project's layout.  
5 2\. \*\* Environment Specifications \*\*: Details about the operating system and language  
SDK where the project will run.  
6 3\. \*\* Build File Edits \*\*: A list of edited build file , which you will need to merge.  
7 4\. \*\* Build File \*\*: Build files missing dependency configurations , which you will  
need to update based on above edits.  
8  
9 To suggest changes to a file you MUST return the entire content of the updated  
file.  
10 You MUST use this \*file listing\* format:  
11  
12 path/to/filename.js  
13 \`\`\`  
14 // entire file content ...  
15 // ... goes in between  
16 \`\`\`  
17  
18 Every \*file listing\* MUST use this format:  
19 \- First line: the filename with any originally provided path; no extra markup ,  
punctuation , comments , etc. \*\*JUST\*\* the filename with path.  
20 \- Second line: opening \`\`\`  
21 \- ... entire content of the file ...  
22 \- Final line: closing \`\`\`  
23  
24 To suggest changes to a file you MUST return a \*file listing\* that contains the  
entire content of the file.  
25 \*NEVER\* skip , omit or elide content from a \*file listing\* using "..." or by adding  
comments like "... rest of code ..."\!  
26 Create a new file you MUST return a \*file listing\* which includes an appropriate  
filename , including any appropriate path.  
27  
28 \--- Begin of Project Structure \---  
29 {project\_structure}  
30 \--- End of Project Structure \---  
31  
32 \--- Begin of Environment Specifications \---  
33 {env\_specs}  
34 \--- End of Environment Specifications \---  
35  
36 \--- Begin of Build File Edits \---  
37 {build\_file\_edits}  
38 \--- End of Build Files Edits \---  
39  
40 \--- Begin of Build File \---  
41 {build\_section}  
42 \--- End of Build File \---

\`\`\`  
Figure 19: Prompt used to merge build file edits.  
\`\`\`


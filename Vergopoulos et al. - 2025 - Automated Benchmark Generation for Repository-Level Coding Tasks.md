\#VAutomated Benchmark Generation for Repository-Level Coding Tasks  
\`\`\`  
Konstantinos Vergopoulos1 \* Mark Niklas Müller1 \* Martin Vechev1 2  
\`\`\`  
\#\# Abstract

\`\`\`  
Code Agent development is an extremely active  
research area, where a reliable performance met-  
ric is critical for tracking progress and guiding  
new developments. This demand is underscored  
by the meteoric rise in popularity ofSWE-Bench–  
a benchmark that challenges code agents to gen-  
erate patches addressing GitHub issues given the  
full repository as context. The correctness of gen-  
erated patches is then evaluated by executing a  
human-written test suite extracted from the repos-  
itory after the issue’s resolution.  
However, constructing benchmarks likeSWE-  
Bench requires substantial manual effort to set up  
historically accurate execution environments for  
testing. Crucially, this severely limits the num-  
ber of considered repositories, e.g., just 12 for  
SWE-Bench. Considering so few repositories, se-  
lected for their popularity runs the risk of leading  
to a distributional mismatch, i.e., the measured  
performance may not be representative of real-  
world scenarios running the riks of misguiding  
development efforts.  
In this work, we address this challenge and in-  
troduceSETUPAGENT, a fully automated sys-  
tem capable of historically accurate dependency  
setup, test execution, and result parsing. Using  
SETUPAGENT, we generate two new datasets:  
(i)SWEE-Bench an extended version ofSWE-  
Bench encompassing hundreds of repositories,  
and (ii)SWA-Bench a benchmark focusing on ap-  
plications rather than libraries. Comparing these  
datasets toSWE-Bench with respect to their char-  
acteristics and code agent performance, we find  
significant distributional differences, including  
lower issue description quality and detail level,  
higher fix complexity, and most importantly up to  
60% lower agent success rates.  
\`\`\`  
\*Equal contribution (^1) LogicStar AI (^2) Department of Computer  
Science, ETH Zurich. Correspondence to: Mark Niklas Müller  
\<mark@logicstar.ai\>.  
Proceedings of the 42 ndInternational Conference on Machine  
Learning, Vancouver, Canada. PMLR 267, 2025\. Copyright 2025  
by the author(s).

\#\# 1\. Introduction

\`\`\`  
Code Agents are quickly becoming one of the most promis-  
ing and actively researched applications of Large Language  
Models (LLMs); partly due to their potential to revolution-  
ize the 700 billion dollar software industry (Statista). To  
measure progress and more importantly steer further de-  
velopments in this field, high-quality datasets and bench-  
marks are crucial. In particular, it is essential that they are  
representative of real-world use cases, sufficiently large to  
allow meaningful statistical analysis, and diverse and recent  
enough to avoid unintentional overfitting and contamination.  
\`\`\`  
\`\`\`  
Existing Benchmarks However, function-level bench-  
marks like HumanEval (Chen et al., 2021), popular for  
evaluating LLM’s coding performance, are unrepresentative  
of real-world use, lack diversity, and are becoming satu-  
rated. To address these limitations,SWE-Bench (Jimenez  
et al., 2024\) was proposed as the first repository-level cod-  
ing benchmark based on real-world tasks, i.e., resolving  
GitHub issues. Yet, it still suffers from several limitations.  
(i) It is limited to few repositories, potentially leading to  
overfitting to these specific codebases. (ii) Its sole focus on  
libraries in contrast to applications raises generalizability  
questions. (iii) Its focus on popular repositories not only  
makes it less representative but also increases the chances  
of contamination with general codebase knowledge. (iv)  
Its static nature leads to most or even all instances being  
created before recent models’ knowledge cutoff, allowing  
even the exact instances to be present in the training data.  
\`\`\`  
\`\`\`  
Creating Repository-Level Benchmarks To address  
these challenges, we would like to create more diverse  
benchmarks and update them frequently with new tasks.  
However, while the GitHub Issues and Pull Requests (PRs),  
serving as task descriptions and reference solutions, respec-  
tively, forSWE-Bench-like benchmarks can be scraped  
automatically, evaluating the correctness of a solution, re-  
quires the repository’s test suite to be executed. This, in turn,  
requires setting up historically accurate execution environ-  
ments, identifying the correct test commands, and parsing  
the results. Prior work addressed this problem either manu-  
ally (Jimenez et al., 2024\) or by aggressively filtering out  
instances where default commands were unsuccessful (Jain  
et al., 2024c). However, both approaches yield limited di-  
versity and don’t lend themselves to frequent updates.  
\`\`\`

\`\`\`  
GitHub Repository  
\`\`\`  
\`\`\`  
Cmd. Extraction  
Iterative Improvements Validation  
\`\`\`  
\`\`\`  
Outputs  
Context  
\`\`\`  
\`\`\`  
Reference Commands  
\`\`\`  
\`\`\`  
CI/CD Files  
\`\`\`  
\`\`\`  
Text Files  
\`\`\`  
\`\`\`  
Online Docs Links  
\`\`\`  
\`\`\`  
Initial  
Commands  
\`\`\`  
\`\`\`  
Install  
Cmds  
\`\`\`  
\`\`\`  
Install  
Exec  
\`\`\`  
\`\`\`  
Test  
Cmds  
\`\`\`  
\`\`\`  
Test  
Exec  
\`\`\`  
\`\`\`  
Parse  
\`\`\`  
\`\`\`  
Check  
Results  
\`\`\`  
\`\`\`  
Rejected  
\`\`\`  
\#\# ✗

\`\`\`  
Install  
Cmds  
Test  
Cmds  
Result  
Parser  
\`\`\`  
\# ✓

Figure 1.Overview of SETUPAGENTwhere a \-icon represents an LLM driven step and a \-icon represents execution feedback.

This Work: SETUPAGENT To address this challenge,  
we proposeSETUPAGENT, the first method to automate  
this setup process, enabling us to create repository-level  
code benchmarks fully automatically from a list of GitHub  
repositories.SETUPAGENTworks in three key phases (il-  
lustrated in Figure 1): (i) Command Extraction (green in  
Figure 1), (ii) Iterative Testing and Improvement (blue ),  
and (iii) Validation (purple ). In the extraction phase,SE-  
TUPAGENTanalyzes relevant context, such asREADME.md  
files, CI/CD configurations, and referenced web pages, to  
propose installation and testing commands. During the itera-  
tive improvement phase,SETUPAGENTthen executes these  
commands in a clean environment and leverages an LLM to  
systematically diagnose and resolve issues. Finally, in the  
validation phase,SETUPAGENTensures that the generated  
commands are reliable by verifying the correctness of the  
setup based on test results, only accepting configurations  
that meet a predefined success threshold.

This Work: Generated Benchmarks We demonstrate  
SETUPAGENT’s capability to generate coding benchmarks  
from a list of repositories by creatingSWA- andSWEE-  
Bench, each addressing specific shortcomings ofSWE-  
Bench. Both are designed to be representative of real-world  
use cases, consider many repositories leading to diverse  
benchmarks, and can be frequently updated without manual  
effort to avoid contamination and overfitting.SWA-Bench  
focuses on software applications, containing 44 projects  
whileSWEE-Bench focuses on diversity and less popular  
projects containing 366 Python repositories. Comparing  
SWA- andSWEE-Bench toSWE-Bench, we find signifi-  
cant distributional differences, including lower repository  
age and popularity at issue creation, a larger focus on recent  
issues, and significantly more complex reference code fixes  
(2-4x more modified files and lines). Evaluating popular  
code agents on these datasets, we find significant perfor-  
mance differences for some models and statistically signifi-  
cant signs of contamination, highlighting the importance of  
evaluating on representative benchmarks.

\`\`\`  
Key Contributions of this work are:  
\`\`\`  
\- We proposeSETUPAGENT, the first method for au-  
    tonomously creating historically accurate execution  
    environments.  
\- We leverageSETUPAGENTto create two datasets for  
    repository-level code generationSWA- andSWEE-  
    Bench, focusing on applications and diverse projects,  
    respectively.  
\- We extensively analyzeSWA- andSWEE-Bench in  
    terms of their characteristics and corresponding code  
    agent performance.

\#\# 2\. Related Work

\`\`\`  
Code Agents To fully leverage the potential of LLMs  
for code generation, they have been equipped with tools  
to interact with their environment without additional user  
input, e.g., by searching, viewing, and editing code, (Wang  
et al., 2024a). These so-called code agents have shown  
great promise on complex tasks (Bouzenia et al., 2024a;  
OpenDevin, 2024; Zhang et al., 2024; Yang et al., 2024b;  
Xia et al., 2024; Aider, 2024; Ridnik et al., 2024; Wang  
et al., 2024b). In this work, we evaluate some of the best-  
performing open-source agents.  
\`\`\`  
\`\`\`  
Code Generation Benchmarks With the success of  
LLMs in the domain of code generation, an increasing va-  
riety of function-level code generation benchmarks were  
proposed to assess their capabilities (Chen et al., 2021;  
Hendrycks et al., 2021; Austin et al., 2021; Jain et al., 2024a;  
Huang et al., 2024). However, not only were these increas-  
ingly saturated by state-of-the-art models but their focus  
on interview-style function-level coding challenges makes  
them also unrepresentative of the complexities of real-world  
codebases and software engineering tasks.  
To address these limitations, a range of repository-level  
code-generation benchmarks have been proposed recently  
(Liu et al., 2023; Jain et al., 2024b; Jimenez et al., 2024).  
\`\`\`

However, a repository-level context not only makes code  
generation but also dataset generation more challenging as it  
requires a historically accurate execution environment to be  
set up, the project’s test suite to be run, and detailed results  
to be extracted. The required manual effort led to existing  
datasets focusing on a relatively small number of popular  
repositories. As a result, they are prone to overfitting, often  
lack diversity, and can easily contaminate the training data.

Automatic Dataset Generation These challenges could  
be addressed via automatic dataset generation, which has  
been successfully applied to function-level benchmarks by  
scraping tasks from coding challenge websites and doing  
varying levels of manual post-processing (Hendrycks et al.,  
2021; Jain et al., 2024a; Huang et al., 2024).

Jimenez et al. (2024) transfer these ideas to repository-level  
benchmarks, automatically scraping GitHub repositories, is-  
sues, and pull requests resolving these issues to createSWE-  
Bench consisting of 12 repositories and 2294 instances.  
However, they still created the required execution environ-  
ments and test commands manually. Further, the resulting  
issues were shown to suffer from underspecified descrip-  
tions and overly specific tests (Chowdhury et al., 2024).

Jain et al. (2024b) createR2E, a function-level synthe-  
sis benchmark with repository context by scraping GitHub  
repositories and masking out the function to be generated.  
They automated the setup by applying a default approach for  
projects with asetup.pyorpyproject.tomlfile, au-  
tomatically generating equivalence tests, and filtering out all  
instances where this approach fails. However, this approach  
aggressively filters projects with more complex installation  
procedures, not only introducing a selection bias but also  
yielding only 246 instances.

In this work, we combine the more interesting repository-  
level tasks with a fully automated benchmark generation  
process, by introducing and leveragingSETUPAGENTto  
automatically extract the installation and testing procedures  
for every task instance, allowing us to create larger and more  
diverse benchmarks efficiently.

Bouzenia & Pradel (2024), concurrently proposedEXECU-  
TIONAGENT, a tool to automatically set up and test reposi-  
tories. However, it is 60 times slower thanSETUPAGENT,  
does not support historical states, and does not extract results  
at test-level granularity. Even if the latter two shortcomings  
were addressed, it would remain infeasibly slow taking, e.g.,  
over 4 months to generate SWEE-Bench^1.

\#\# 3\. Autonomous Environment Setup

In this Section, we first outline the requirements for a setup  
and testing agent to be used for benchmark generation and  
then describe the agent we develop for this purpose.

(^1) Extrapolated from∼150 repositories.  
3.1. Notation and Definitions  
We first introduce notation to describe repository-level cod-  
ing tasks, adapted from Mündler et al. (2024). Given a  
codebaseR, we obtainR◦Xby applying the code patchX.  
We similarly denote the test suiteTwithT◦Safter apply-  
ing the test patchS. A single testt∈Tcan either pass (P)  
or fail (F) when executed against the codebaseRin an ex-  
ecution environmentE. We write:execE(t,R)∈ {P,F}  
and let the orderP \> Fhold.  
A repository-level coding task can be written as the tu-  
ple(R,T,I,E,S∗,X∗), whereRandTare the original  
codebase and test suite, respectively,I is the issue de-  
scription,Ethe execution environment, andS∗andX∗  
the reference test and code patch, respectively. By ex-  
ecuting all teststi ∈T◦S∗in the execution environ-  
mentE, first against the original (R) and then the patched  
codebase (R◦X∗), we obtain the reference test behavior  
b∗i= (execE(ti,R)→execE(ti,R◦X∗)). We calltiwith,  
e.g.,b∗i \=F→Pa fail-to-pass test as it fails before the  
reference fix is applied but passes afterward. We let the  
partial orderF→P \> F→FandP→P \> P→Fhold.  
The task is now to generate a patch X′, given  
only (R,T,I,E), such that the test behavior b′i \=  
execE(ti,R)→execE(ti,R◦X′)matches or improves  
on the reference result, i.e.,b′i≥b∗ifor all teststi∈T◦S∗.  
3.2. Setup Agent Requirements  
A generic setup agent targeting individual, up-to-date reposi-  
tories only has to satisfy one main requirement:Correctness

\- It must extract and run the installation and testing com-  
    mands before parsing the test results. However, benchmark  
    generation, i.e., generating the execution environmentE  
    given the remaining components of a coding task, imposes  
    additional requirements:Historical Accuracy– Benchmark  
    instances are based on specific, often outdated versions of a  
    codebaseR. The execution environmentEmust thus use  
    historically accurate dependency versions to reproduce the  
    original issue faithfully and avoid version incompatibilities.  
    Efficiency– To generate a dataset of many hundreds of in-  
    stances, the setup agent must be efficient enough to keep  
    total runtime reasonable (hours or at most few days).Gran-  
    ularity– Evaluating agent success requires test-level results  
    to be parsed from the test suite output.

\`\`\`  
3.3. SETUPAGENT  
Overview SETUPAGENTworks in three phases illustrated  
in Figure 1: (1) Extraction ( in Figure 1), (2) Iterative  
testing and imporvement ( ), and (3) Validation ( ). In  
the first phase,SETUPAGENTextracts a first version of the  
installation and testing commands from all relevant files, ref-  
erenced webpages, and, if available, successful commands  
\`\`\`

from similar versions of this repository. In the second phase,  
SETUPAGENTiteratively executes first the installation and  
then testing commands, analyses the results and updates the  
commands. Finally, in the third phase,SETUPAGENTvali-  
dates the resulting commands by executing them, extracting  
the test results, and rejecting the proposed commands, if  
too few tests pass. Validated commands are then returned  
to the user and saved in a reference database to facilitate  
installations of different versions of the same repository.

\`\`\`  
Input:  
Please extract all commands required to install  
\<project\_name\> in a clean environment and run its  
test suite from the context below.  
’’’  
\#\# README.md  
\<file\_content\>  
\#\# CONTRIBUTING.md  
\<file\_content\>  
’’’  
LLM Response:  
’’’bash  
apt-get install \-y graphviz \# installation  
pip install \-r req.txt \# installation  
nox \-e test \# testing  
’’’  
Installation Commands :  
apt-get install \-y graphviz  
uv pip install \-r req.txt \-exclude-newer 2022-04-  
Testing Commands :  
nox \-e test  
\`\`\`  
Figure 2.Illustration of the extraction phase ofSETUPAGENT.  
Please see App. B for the full-length prompts.

Extraction Phase The goal of the Extraction Phase is  
to extract an initial version of the installation and test-  
ing commands. We illustrate it in Figure 2, using a sig-  
nificantly simplified prompt and shortened response for  
illustration purposes. In the first step,SETUPAGENTre-  
views all relevant files to identify the correct Python version.  
If available, it is directly parsed from thesetup.pyor  
pyproject.tomlfile, otherwise version constraints are  
extracted from different sources using an LLM and then  
resolved while taking issue creation time into account to en-  
sureHistorical Accuracy. Next,SETUPAGENTuses a heuris-  
tic to identify possibly relevant context likeREADME.md  
andCONTRIBUTING.mdfiles, CI/CD configurations, and  
referenced webpages. It then reviews these sources and  
directly rejects those not containing information relevant to  
installation or testing, thus keeping its context size small  
and improvingEfficiency. Finally,SETUPAGENTprompts  
an LLM to extract the installation and testing commands  
from the chosen sources. To ensureHistorical Accuracy,  
SETUPAGENTenforces the use of theuvenvironment man-  
ager for Python dependencies, configuring it to exclude  
dependency versions released after the issue creation.

Iterative Improvement Phase SETUPAGENTnow tries  
to install and test the project in a clean Docker container  
using the extracted commands. If any of the installation  
steps fail, i.e., exit with a non-zero exit code, or the test

\`\`\`  
Input:  
You are trying to install and test \<project\_name\>  
using the following commands.  
’’’bash  
\<commands\>  
’’’  
Modify the commands to resolve the following error:  
’’’  
...  
ModuleNotFoundError: No module named ’rustworkx’  
’’’  
LLM Response:  
We have to install rustworks first:  
’’’bash  
pip install rustworkx  
’’’  
Updated Installation Commands :  
apt-get install \-y graphviz  
uv pip install \-r req.txt exclude-newer 2022-04-  
uv pip install rustworkx exclude-newer 2022-04-  
\`\`\`  
\`\`\`  
Figure 3.Illustration of the iterative improvement phase ofSETU-  
PAGENT, where the error message was obtained by executing the  
commands from the previous iteration.  
\`\`\`  
\`\`\`  
commands fail with an error,SETUPAGENTselects the rel-  
evant sections of the error messages and then prompts an  
LLM to identify the issue and propose a modification of the  
installation commands to fix it. We illustrate this in Figure 3,  
whereSETUPAGENTadds a missing dependency. NowSE-  
TUPAGENTtries to resolve issues apparent in the test results,  
analyzing the logs to determine whether a failure is due to  
incorrect test commands, an incorrect installation, or a bug  
in the codebase. Depending on the result,SETUPAGENT  
prompts an LLM to modify the installation or testing com-  
mands to fix the issue or passes the repo on to the validation  
phase. This iterative improvement is repeated until all er-  
rors are resolved or an iteration limit is reached. Using a  
moderate iteration limit of 4 steps, we achieve significantly  
improvedCorrectnesswithout sacrificingEfficiency.  
\`\`\`  
\`\`\`  
Input:  
Please assess whether \<project\_name\> was installed  
and its test suite executed correctly given the  
resulting printout.  
Answer YES or NO.  
’’’  
...  
\===== 2597 passed, 3 failed in 10.85s \=====  
’’’  
LLM Response:  
YES  
\`\`\`  
\`\`\`  
Figure 4.Illustration of the first step in the Validation phase.  
\`\`\`  
\`\`\`  
Validation Phase In the validation phase,SETUPAGENT  
first queries an LLM to assess whether the installation and  
testing were successful, illustrated in Figure 4\. If the LLM  
judges the installation to be successful,SETUPAGENTup-  
dates the test framework’s configuration to return test-level  
results, e.g., by adding-rAto apytestcommand, thus  
ensuringGranularity. It then selects the correct parser from  
a pre-defined set to extract test-level results and checks  
the number of passing and failing tests. We consider the  
installation to be successful if at least 95% of tests pass.  
\`\`\`

\#\#\# 2013 − 01 2019 − 01 2025 − 01

\`\`\`  
Issue Creation Date  
\`\`\`  
\`\`\`  
SWE  
SWA  
SWEE  
\`\`\`  
\`\`\`  
0 4000 8000  
Repo Age \[Days\]  
\`\`\`  
\`\`\`  
SWE  
SWA  
SWEE  
\`\`\`  
\#\#\# 0 40000 80000

\`\`\`  
\# GitHub Stars  
\`\`\`  
\#\#\# 0\. 0

\#\#\# 0\. 5

\#\#\# 1\. 0

\`\`\`  
SWE  
SWA  
SWEE  
\`\`\`  
Figure 5.PDFs (left and middle) and CDF (right) of PR creation dates (left), repository age at PR creation time (middle), and number of  
GitHub stars (right) for SWA, SWEE, and SWE-Bench.

\#\# 4\. Code Generation Benchmarks

In this Section, we describe how we leverageSETUPAGENT  
to createSWA- andSWEE-Bench, two new benchmarks  
addressing specific limitations ofSWE-Bench. We compare  
these datasets withSWE-Bench and provide insights into  
distributional differences.

Automatically Generated Benchmarks By creating ex-  
ecution environments automatically, we address two core  
limitations of manually generated repository-level bench-  
marks: (i) we can consider many more repositories without  
requiring infeasible manual labor, thus improving diversity  
and reducing the risk of overfitting and (ii) we can easily  
update benchmarks by creating new tasks from recent PRs  
and issues, thus ensuring that models are not contaminated  
with benchmark instances (see Figures 5 and 6).

SWA-Bench Many practitioners using Code Agents de-  
velop software applications that suffer from different types  
of bugs compared to libraries due to architectural and struc-  
tural differences. AsSWE-Bench only considers libraries,  
we design SWA-Bench to focus only on applications.

SWEE-Bench We observe that more popular repositories  
tend to have higher-quality codebases and issue descrip-  
tions. This includes, e.g., a more consistent (file) structure  
and naming conventions, better documentation including de-  
tailed docstrings for most functions, and issue descriptions  
following a precise template (see Figures 7 and 8). AsSWE-  
Bench focuses on particularly popular Python repositories,  
the resulting tasks can be unrepresentative of real-world  
use. Therefore, we designSWEE-Bench with a focus on  
diverse and less popular (median of 365 vs 16k stars) Python  
repositories (see Figure 5).

4.1. Dataset Creation

Source Repositories ForSWA-Bench, we combine a list  
of 468 popular Python applications (Hashemi, 2024\) with  
a list of 50 Python projects from Bouzenia et al. (2024b),  
leading to a total of 475 candidate repositories after dedu-  
plication. ForSWEE-Bench, we consider the 8000 most

\`\`\`  
Table 1.SWEEpipeline from projects to tasks. A PR is valid if it  
resolves an issue, modifies a test file, and is merged. An instance  
valid, if it has additionally at least oneF→Ptest.  
Step \# Repos \# PRs  
Initial Projects 8000  
\+GH Repo Found 7057  
\+Preprocessing 5097  
\+Permissive License 3800  
\+Has valid PR 2377  
\+SETUPAGENTsucceeds 514  
\+Getnper\_repovalid PRs 2115  
\+SETUPAGENTsucceeds 1513  
\+valid instance 885  
\`\`\`  
\`\`\`  
downloaded PyPi projects at the time (van Kemenade et al.,  
2024\) with between 100k and 1.5B monthly downloads and  
0 to 25k stars, leading to good diversity while focusing on  
relevant projects.  
\`\`\`  
\`\`\`  
Dataset Creation withSETUPAGENT We combine the  
original PR filtering process from Jimenez et al. (2024) with  
ourSETUPAGENTas follows: For every project, we first  
locate the corresponding repository, deduplicate the results,  
and filter out repositories that are not published under a  
permissive license. We then scrape issues and pull requests  
for each repository until we find the most recent PR that  
is merged, resolved an issue, and modified a test file. We  
call this a valid PR. We then useSETUPAGENTto set up an  
execution environmentEfor the corresponding codebase  
R(see Section 3). For repositories where this succeeds, we  
scrape additional PRs until we havenper\_repovalid ones  
or, forSWEE, reach a maximum of 500 PRs. We then use  
SETUPAGENTto create the execution environmentEfor  
each corresponding codebaseRin reverse chronological  
order per repository, populatingSETUPAGENT’s reference  
commands database to speed up the setup process. Finally,  
we split every PR into a reference code patchX∗and test  
patchS∗. We execute the full test suiteT◦S∗before  
and after the code patch is applied, i.e., onRandR◦X∗,  
respectively, to obtain the reference test behaviorsb∗i. We  
then filter out PRs, where test execution fails in one of  
these settings or which have noF→Ptest, i.e. ∄t∈  
\`\`\`

T◦S∗: execE(t,R)→execE(t,R◦X∗) \=F→P. The  
remaining PRs form the valid instances of the generated  
benchmark. We choosenper\_repo= 50forSWA-Bench  
andnper\_repo= 10forSWEE-Bench to obtain the desired  
number of tasks and show the number of repositories and  
PRs this leads to in Tables 1 and 10, respectively.

Ease of Use To make benchmark generation and use  
as easy as possible, SETUPAGENTonly requires a list  
of repositories to generate a dataset in a format compat-  
ible with SWE-Bench along with docker images with  
all dependencies installed. We publishSWA-Bench on  
HuggingFace and the corresponding docker containers at  
logicstarai/swa-bench. A suitable evaluation harness is avail-  
able at github.com/logic-star-ai/SWEBench.

\`\`\`  
Repository Proportion  
\`\`\`  
\`\`\`  
SWE  
\`\`\`  
\`\`\`  
SWA  
\`\`\`  
\`\`\`  
SWEE  
\`\`\`  
Figure 6.Comparison of the repository distribtuion ofSWEE-,  
SWA-, and SWE-Bench across instances.

4.2. Benchmark Characteristics

Diversity We compare the distribution of instances over  
repositories in Figure 6 and observe that while instances in  
SWEare heavily concentrated in only a few repositories,  
with over 50% of instances belonging to only two out of  
12 total repositories,SWA- andSWEE-Bench show much  
more diversity with 535 instances from 44 repositories and  
885 from 366 repositories. See App. C for a full list.

Codebase Characteristics We compare benchmarks with  
respect to codebase characteristics in Table 2 and Figure 5  
and observe thatSWE-Bench, compared to,SWA- and  
especiallySWEE-Bench contains significantly older and  
more popular (\# GitHub stars) repositories and larger, more  
complex codebases (\# files and \# lines of code).

Issue Description Quality To assess the issue description  
quality, we measure the number of words, error messages,  
and code blocks they contain as well as the overlap between  
the files mentioned there and modified in the reference fix  
and the overlap between the issue description and the ref-  
erence solution itself. We show cumulative distribution  
functions (CDFs) of the aforementioned characteristics in  
Figure 7\. We observe that whileSWA-Bench has more  
detailed issue descriptions (longer, more code blocks, and  
more error messages), they do not seem to be of higher qual-  
ity (less overlap with the reference solution and equal file  
mentions). ComparingSWE-Bench andSWEE-Bench, we

\`\`\`  
Table 2.Comparison of mean dataset characteristics.  
SWA SWEE SWE  
\`\`\`  
\`\`\`  
Codebase \# Files\# Lines 112k^899 14.8k^771491 321k  
\`\`\`  
\`\`\`  
Issue Descriptions  
\`\`\`  
\`\`\`  
\# Words 240.2 125.1 181\.  
\# Error Messages 0.20 0.13 0\.  
\# Code Blocks 1.53 1.19 1\.  
\`\`\`  
\`\`\`  
Tests  
\`\`\`  
\`\`\`  
\#P→P 564.2 226.6 120\.  
\#F→P 38.8 38.1 13\.  
\#F→F 3.7 1.4 3\.  
\#P→F 0.11 0.03 0\.  
\`\`\`  
\`\`\`  
Test Patches  
\`\`\`  
\`\`\`  
\# Edited Files 1.89 2.05 1\.  
\# Edited Lines 74.8 91.5 39\.  
\# Added Tests 9.10 23.78 6\.  
\# Removed Tests 16.77 2.49 0\.  
\`\`\`  
\`\`\`  
Fix Patches \# Edited Files\# Edited Lines 104.33.26 169.93.26 1.6641.  
\`\`\`  
\`\`\`  
0 500 1000  
\# Words in Issue Desc.  
\`\`\`  
\`\`\`  
0\. 0  
\`\`\`  
\`\`\`  
0\. 5  
\`\`\`  
\`\`\`  
1\. 0  
SWE  
SWA  
SWEE  
0 3 6  
\# Codeblocks  
\`\`\`  
\`\`\`  
0\. 0  
\`\`\`  
\`\`\`  
0\. 5  
\`\`\`  
\`\`\`  
1\. 0  
SWE  
SWA  
SWEE  
0 3 6  
\# Error Messages  
\`\`\`  
\`\`\`  
0\. 8  
\`\`\`  
\`\`\`  
0\. 9  
\`\`\`  
\`\`\`  
1\. 0  
SWE  
SWA  
SWEE  
\`\`\`  
0\. (^50) \# File Name Contained 0 3 6  
0\. 75  
1\. 00  
SWE  
SWA  
SWEE  
(^0) Longest Overlapping String 20 40  
0\. 0  
0\. 5  
1\. 0  
SWE  
SWA  
SWEE  
0\. (^70) \# Fix Lines in Issue Desc. 0 4 8  
0\. 85  
1\. 00  
SWE  
SWA  
SWEE  
Figure 7.CDFs over issue description characteristics. Number of  
words (top left), number of code blocks (top middle), number of  
error messages (top right), number of filenames contained in the  
issue description and modified in the reference solution (bottom  
left), the overlap between the issue description and the reference  
solution in terms of longest string match (bottom middle) and  
complete lines (bottom right). A CDF further down and to the  
right indicates a higher value.  
observe longer issue descriptions and slightly more overlap  
with the reference solution inSWE-Bench but otherwise  
similar characteristics.  
Fix Complexity To assess the complexity of required  
fixes, we measure the number of lines and files modified in  
the reference solution and the number of tests that flip from  
passing to failing (and vice versa). We show CDFs in Fig-  
ure 8 and observe that whileSWEE- andSWA-Bench have  
similar distributions across all these metrics,SWE-Bench  
fixes are significantly less complex by all metrics.  
4.3. Manual Review  
WhileSETUPAGENTensures that at least 95% of tests pass,  
some quality issues may still remain. To assess their fre-  
quency and impact, we conduct a manual review focusing

\`\`\`  
0 250 500  
\# Lines in Fix  
\`\`\`  
\`\`\`  
0\. 0  
\`\`\`  
\`\`\`  
0\. 5  
\`\`\`  
\`\`\`  
1\. 0  
SWE  
SWA  
SWEE  
0 8 16  
\# Files in Fix  
\`\`\`  
\`\`\`  
0\. 0  
\`\`\`  
\`\`\`  
0\. 5  
\`\`\`  
\`\`\`  
1\. 0  
SWE  
SWA  
SWEE  
\`\`\`  
(^0) \# Flipped Tests 10 20  
0\. 0  
0\. 5  
1\. 0  
SWE  
SWA  
SWEE  
Figure 8.CDFs over fix-complexity characteristics. Number of  
edited lines (left), number of edited files (top middle), number  
affected tests, i.e.,F→P+P→F(right). A CDF further down  
and to the right indicates higher characteristic values.  
on two types of issues: (i) dataset quality along the lines of  
SWE-Bench Verified (Chowdhury et al., 2024), i.e., whether  
the issue is sufficiently well-specified to be resolved with-  
out further information and whether the tests are suitable  
to check its resolution and (ii) setup success, i.e., whether  
SETUPAGENTwas able to set up the environment correctly  
and run the tests as expected.  
Dataset Quality In line with prior work (Chowdhury et al.,  
2024), we focus on two main aspects: (i) task specificity, i.e.,  
whether the issue is sufficiently well-specified to resolve it  
without further information and (ii) test quality, i.e., whether  
the added unit tests check for the described behaviour or are  
overly specific to concrete implementations such as exactly  
matching error messages. We assess both of these criteria on  
a scale from 0 to 3, where 0 is the best score and 3 the worst,  
using the same annotation guide as Chowdhury et al. (2024).  
That is, we scored issue specificity and clarity on a scale of 0  
(well-specified issue with clear success criteria) to 3 (almost  
impossible to solve correctly without further instructions)  
and test quality from 0 (test perfectly covers valid solutions)  
to 3 (tests are too narrow or broad or requiring information  
not provided in the issue description). On both scales, 0 and  
1 are considered acceptable, while 2 and 3 are insufficient.  
We conducted a manual review of 30 randomly chosen SWA  
instances and observed the following: 21 (70%) instances  
have a meaningful and sufficiently complete issue descrip-  
tion, and 20 (67%) of these additionally have suitable tests  
(27 or 90% across all instances) to check whether the issue  
was fixed. This is in line with the results of Chowdhury  
et al. (2024) and shows that the majority of issues are solve-  
able, with current performance levels still leaving significant  
room for improvement, makingSWAa suitable benchmark  
for current and future code generation systems.  
Setup Success To validate the automated assessment used  
bySETUPAGENTto determine whether an instance was set-  
up correctly, we assess both the extracted setup and testing  
steps as follows. (i) We score the setup on a binary scale  
of 0 (correct setup that is functionally equivalent with the  
described setup and 1 (incorrect setup). (ii) We score testing  
on a scale from 0 (functionally equivalent to described test-  
ing) to 2 (tests only partially or not at all executed), where  
both 0 and 1 are considered acceptable.  
We manually review the same 30 instances as above and  
observe the following: All instances run the correct tests  
with 23 (77%) using exactly the same test commands as  
provided in the reference. 22 (73%) of these instances  
additionally have a fully correct installation/setup. These  
results indicate thatSETUPAGENThas no trouble extracting  
the correct testing steps, with the setup proving slightly  
more challenging but also forgiving considering that 95%  
of tests passed despite minor setup errors.

\#\# 5\. Experimental Evaluation

\`\`\`  
In this Section, we first evaluate the effectiveness of SETU-  
PAGENTfor dataset creation and then analyze Code Agent  
performance across datasets.  
\`\`\`  
\`\`\`  
5.1. Experimental Setup  
Models We consider a range of models across sizes, cost  
points, and model providers. For exact versions, see Table 9  
in App. A. Unless otherwise specified, we useGPT-4O-  
MINIas the underlying model for all agents. For decod-  
ing, we use the default parameters for all Code Agents and  
greedy decoding for SETUPAGENT.  
\`\`\`  
\`\`\`  
Code Agents We evaluate three state-of-the-art Code  
Agents from the top of theSWE-Bench leaderboard^2 which  
most likely have been optimized forSWE-Bench (Open-  
Hands (Wang et al., 2024b), AutoCodeRover-v2.0 (Zhang  
et al., 2024)), and SWE-Agent v1 (Yang et al., 2024a) and  
ZeroShot (Jimenez et al., 2024\) with oracle context (files  
modified in the ground truth fix) and BM25 retrieval which  
prompts LLMs directly without any optimization forSWE-  
Bench. We report the portion of resolved instances as accu-  
racy (Acc.) for all Code Agents.  
\`\`\`  
\`\`\`  
Code Execution We run all code execution (both forSE-  
TUPAGENTand all Code Agents) in separate Docker con-  
tainers to improve reproducibility and security. ForSETU-  
PAGENT, we use an Ubuntu 22.04 container as the base  
image and pre-install a range of common build dependen-  
cies but do not provide any Python dependencies.  
\`\`\`  
\`\`\`  
5.2. Effectiveness of SETUPAGENT  
We evaluate the effectiveness ofSETUPAGENTin creating  
SWA- andSWEE-Bench by analyzing the frequency of  
fully successful environment and testing setups in Table 3\.  
We observeSETUPAGENTis able to extract historically  
correct execution environments for 20-30% of repositories  
without reference commands and for 55-75% of instances  
\`\`\`  
(^2) swebench.com accessed in November 2024

Table 3.SETUPAGENTsuccess rates at extracting installation and  
test commands as well as parsing the resulting test output.

\`\`\`  
Success  
\`\`\`  
\`\`\`  
SWA  
Repos 28 .6%  
Instances 58 .5%  
\`\`\`  
\`\`\`  
SWEE  
Repos 21 .6%  
Instances 71 .5%  
\`\`\`  
Table 4.Ablation study onSETUPAGENT, reporting the number of  
successfully extracted execution environments for SWA-Bench.

\`\`\`  
\# Repositories  
SETUPAGENT 44  
only CI/CD Files 33  
only Text Files 15  
no Iterative Improvement 11  
\`\`\`  
for these repositories. Without reference commands,SE-  
TUPAGENTtakes 76 minutes to attempt to install all 154  
repositories considered forSWAafter deduplication and  
license checks and thus takes only about 30s on average per  
repository. When creatingSWEE-Bench, we deactivate the  
web browsing ability of SETUPAGENT.

Ablation We evaluate the impact ofSETUPAGENT’s com-  
ponents in an ablation study onSWA-Bench, reporting  
results in Table 4\. We observe that especially the use of  
CI/CD config files and the iterative improvement are crucial  
for SETUPAGENT’s success.

Failure Analaysis To understandSETUPAGENT’s failure  
cases, we conduct a small case study, manually inspecting  
five failed instances fromSWA-Bench, and observe the fol-  
lowing: In all instances, errors in the build process cause  
the failure. For all but one instance, finding the installation  
instructions requires following two or more links on web  
pages. In all but two instances, the only described way to test  
the application requires running docker containers, which  
SETUPAGENTdoes not support. In two instances, installa-  
tion and/or testing requires the use of makefiles, referencing  
multiple substeps. Finally, in one instanceSETUPAGENT  
chooses the wrong requirement file and then begins to in-  
stall missing testing dependencies. We believe this points  
to exciting future work improvingSETUPAGENT’s web-  
browsing capabilities and docker support.

5.3. Agent Performance Across Datasets

We conduct all below experiments on the fullSWAand  
uniformly subsampled versions ofSWEEandSWE-Full  
of identical size (535 instances) due to cost constraints.

We report Code Agent performance in Table 5 and observe

\`\`\`  
Table 5.Issue resolution rates (accuracy) of various agents on  
SWA-, SWEE-, and SWE-Bench, all with GPT-4O-MINI.  
SWA SWEE SWE  
Openhands 3 .9% 4.4% 4.6%  
AutoCodeRover v2 8 .4% 9.0% 8.2%  
SWE-Agent v1 2 .6% 7.5% 7.1%  
ZeroShot(Oracle) 0 .9% 2.2% 2.8%  
ZeroShot(BM25) 1 .3% 2.8% 1.5%  
\`\`\`  
\`\`\`  
surprisingly small differences in performance between all  
three datasets when usingGPT-4O-MINIfor most agents,  
with SWE-Agent performing significantly worse on SWA.  
To assess the interaction of agent performance and model  
selection, we evaluate AutoCodeRover v2 (Zhang et al.,  
2024\) across a range of LLMs, showing results in Table 6\.  
Interestingly, we observe a large variance in the accuracy  
difference betweenSWEandSWAacross models. While  
GPT-4O-MINIperforms similarly well on all benchmarks,  
all other models perform much better onSWEE- and even  
better onSWE-Bench. We show later that this may be due  
to lower performances for instances created after the models  
knowledge cutoff.  
\`\`\`  
\`\`\`  
Table 6.Performance of AutocodeRover v2 (Zhang et al., 2024\)  
using different underlying LLMs.  
SWA SWEE SWE  
GPT-4O-MINI 8 .4% 9.0% 8.2%  
GPT-4O 10 .2% 15.1% 16.6%  
HAIKU-3.5 10 .8% 12.9% 13.6%  
LLAMA3.3 70B 8 .8% 10.8% 12.5%  
QWEN2.5† 3% 2% 4%  
DEEPSEEKV3† 8% 13% 26%  
†Evaluated on 100 random instances.  
\`\`\`  
\`\`\`  
5.4. Benchmark Analaysis  
In Section 4, we observed interesting distributional dif-  
ferences between the instance characteristics ofSWA-,  
SWEE-,andSWE-Bench. Now, we explore how these  
characteristics correlate with agent performance, reporting  
Spearman’s rank correlation coefficientsρand p-values for  
AutoCodeRover v2 andGPT-4Oin Table 7\. We observe  
that only characteristics computed with knowledge of the  
solution have a statistically significant correlation with per-  
formance. In particular, the overlap of the issue with the  
reference code patch in terms of file names, and number  
of lines has a strong positive correlation with performance,  
while all fix complexity metrics have a strong negative cor-  
relation with performance.  
\`\`\`  
\`\`\`  
Data Contamination We analyze the accuracy (Acc) of  
AutoCodeRover v2 onSWA- andSWEE-Bench, depend-  
ing on whether a PR was created before or after a model’s  
knowledge cutoff (KC), showing results in Table 8\. We re-  
\`\`\`

Table 7.Spearman’s rank correlation coefficientsρand p-value be-  
tween accuracy and instance characteristics, separated by whether  
statistic can be computed without axes to ground truth. Statistically  
significant (p \<1%) correlations are highlighted in bold. Positive  
ρindicate that a larger characteristic value is associated with better  
performance.

\`\`\`  
Characteristic ρ SWAp-value ρ SWEEp-value ρ SWEp-value  
Repo Age \-0.06 2\. 0 × 10 −^1 \-0.02 5\. 8 × 10 −^1 \-0.02 7\. 0 × 10 −^1  
\# GitHub Stars \-0.03 4\. 8 × 10 −^1 \-0.02 7\. 2 × 10 −^1 0.07 1\. 3 × 10 −^1  
\# Words in Issue \-0.06 1\. 8 × 10 −^1 0.00 9\. 6 × 10 −^1 0.01 7\. 7 × 10 −^1  
\# Code Blocks in Issue 0.00 9\. 7 × 10 −^1 0.04 3\. 4 × 10 −^1 \-0.06 1\. 7 × 10 −^1  
\# Error Messages in Issue 0.03 4\. 6 × 10 −^1 0.09 3\. 7 × 10 −^2 \-0.04 3\. 5 × 10 −^1  
\# Fix File Names in Issue 0.12 4\. 5 × 10 −^3 0.19 1\. 2 × 10 −^5 0.18 2\. 5 × 10 −^5  
Longest Fix Substring in Issue \-0.04 3\. 7 × 10 −^1 \-0.11 1\. 1 × 10 −^2 0.04 3\. 1 × 10 −^1  
\# Fix Lines in Issue 0.09 3\. 7 × 10 −^2 0.06 1\. 7 × 10 −^1 0.17 1\. 1 × 10 −^4  
\# Lines in Fix \-0.28 5\. 0 × 10 −^11 \-0.40 1\. 3 × 10 −^21 \-0.28 6\. 2 × 10 −^11  
\# Files in Fix \-0.12 6\. 2 × 10 −^3 \-0.26 1\. 6 × 10 −^9 \-0.16 1\. 4 × 10 −^4  
\# Affected Tests \-0.18 3\. 3 × 10 −^5 \-0.25 4\. 0 × 10 −^9 \-0.15 7\. 2 × 10 −^4  
\`\`\`  
Table 8.Accuracy of AutocodeRover v2 (Zhang et al., 2024\) on  
SWA-Bench instances split between those created before and  
after the model’s knowledge cutoff (KC) and the p-value of the  
underlying resolution rate being the same or higher after the KC.

\`\`\`  
Dataset Model \# after KC Acc before KC Acc after KC p-value  
\`\`\`  
\`\`\`  
SWA  
\`\`\`  
\`\`\`  
GPT-4O-MINI 249 9.4% 7.2% 17.90%  
GPT-4O 249 12.2% 7.2% 2.65%  
HAIKU-3.5 44 11.0% 9.1% 34.83%  
\`\`\`  
\`\`\`  
SWEE  
\`\`\`  
\`\`\`  
GPT-4O-MINI 230 8.2% 10.0% 76.50%  
GPT-4O 230 15.4% 15.2% 47.56%  
HAIKU-3.5 102 13.6% 9.8% 15.01%  
\`\`\`  
port the (one-sided) p-value of observing these results under  
the null hypothesis that the success rate is not lower after the  
KC (computed using a t-test and normal approximation of  
the binomial distribution). We observe that onSWA-Bench  
all considered models have a lower success rate after the  
KC with the difference being statistically significant only  
forGPT-4O. Interestingly, we observe no such signs on  
SWEE-Bench which contains much less popular projects  
and is thus less prone to contamination. While allSWE  
instances are too old to conduct a similar analysis, we ob-  
serve that the performance delta betweenSWEandSWAis  
correlated with the drop in accuracy over the KC onSWA.

\#\# 6\. Conclusion

We introducedSETUPAGENT, the first method for auto-  
mated and historically accurate execution environment setup  
for Python codebases. SETUPAGENTenables us to cre-  
ate repository-level code benchmarks fully automatically  
from a list of GitHub repositories. We demonstrated its  
effectiveness by creating two new benchmarks,SWA- and  
SWEE-Bench, focusing on applications and diversity of  
codebases, respectively, and addressing several limitations  
of existing repository-level code benchmarks. In particular,  
their automated generation allows us to consider many more  
repositories, increasing diversity and reducing the risk of  
overfitting, and update the benchmarks over time, minimiz-  
ing the risk of data contamination.

\`\`\`  
We extensively analyzedSWA- andSWEE-Bench, observ-  
ing significant distributional differences compared toSWE-  
Bench in fix-complexity characteristics that are strongly  
correlated with agent success. We further found statisti-  
cally significant performance degradation forSWA-Bench  
instances created after the knowledge cutoff for one model.  
Together, these findings highlight the importance of eval-  
uating on diverse, representative, and frequently updated  
benchmarks and thus the value of our automated bench-  
mark generation approach. We believeSETUPAGENTcan  
facilitate this by enabling practitioners to quickly turn their  
specific target domain into a high-quality representative  
benchmark.  
\`\`\`  
\#\# Impact Statement

\`\`\`  
This paper presents work advancing Code Agent evaluation  
and may thus amplify all positive and negative societal im-  
pacts of improved Code Agents. Our work shows that eval-  
uating Code Agents on diverse and up-to-date benchmarks  
is critical to obtain representative results, withSWE-Bench  
(and even moreSWE \-VERIFIED) consisting of unusually  
easy problems. These findings may relativize some recent  
predictions of code agents soon replacing human software  
developers and show that the field is still far from achieving  
this goal. Beyond this, our work on automated execution  
environment setup has the goal of advancing the field of  
Machine Learning for code more generally. There are many  
potential additional societal consequences of our work, none  
of which we feel must be specifically highlighted here.  
\`\`\`  
\#\# Acknowledgements

\`\`\`  
We would like to thank the anonymous reviewers for their  
valuable feedback and suggestions, which helped improve  
the quality of this paper.  
\`\`\`

\#\# References

Aider. Aider is SOTA for both SWE Bench and SWE Bench  
Lite, 2024\.

Anthropic. Model card addendum: Claude  
3.5 haiku and upgraded claude 3.5 son-  
net. https://assets.anthropic.  
com/m/1cd9d098ac3e6467/original/  
Claude-3-Model-Card-October-Addendum.  
pdf, 2024\.

Austin, J., Odena, A., Nye, M. I., Bosma, M., Michalewski,  
H., Dohan, D., Jiang, E., Cai, C. J., Terry, M., Le, Q. V.,  
and Sutton, C. Program synthesis with large language  
models.ArXiv preprint, abs/2108.07732, 2021\.

Bouzenia, I. and Pradel, M. You name it, I run it: An  
LLM agent to execute tests of arbitrary projects.CoRR,  
abs/2412.10133, 2024\. doi: 10.48550/ARXIV.2412.  
10133\.

Bouzenia, I., Devanbu, P. T., and Pradel, M. Repaira-  
gent: An autonomous, llm-based agent for program repair.  
CoRR, 2024a.

Bouzenia, I., Krishan, B. P., and Pradel, M. Dypybench: A  
benchmark of executable python software.Proc. ACM  
Softw. Eng., 1(FSE), 2024b. doi: 10.1145/3643742.

Chen, M., Tworek, J., Jun, H., Yuan, Q., de Oliveira Pinto,  
H. P., Kaplan, J., Edwards, H., Burda, Y., Joseph, N.,  
Brockman, G., Ray, A., Puri, R., Krueger, G., Petrov,  
M., Khlaaf, H., Sastry, G., Mishkin, P., Chan, B., Gray,  
S., Ryder, N., Pavlov, M., Power, A., Kaiser, L., Bavar-  
ian, M., Winter, C., Tillet, P., Such, F. P., Cummings, D.,  
Plappert, M., Chantzis, F., Barnes, E., Herbert-Voss, A.,  
Guss, W. H., Nichol, A., Paino, A., Tezak, N., Tang,  
J., Babuschkin, I., Balaji, S., Jain, S., Saunders, W.,  
Hesse, C., Carr, A. N., Leike, J., Achiam, J., Misra,  
V., Morikawa, E., Radford, A., Knight, M., Brundage,  
M., Murati, M., Mayer, K., Welinder, P., McGrew, B.,  
Amodei, D., McCandlish, S., Sutskever, I., and Zaremba,  
W. Evaluating large language models trained on code.  
ArXiv preprint, abs/2107.03374, 2021\.

Chowdhury, N., Aung, J., Shern, C. J., Jaffe, O., Sherburn,  
D., Starace, G., Mays, E., Dias, R., Aljubeh, M., Glaese,  
M., Jimenez, C. E., Yang, J., Ho, L., Patwardhan, T.,  
Liu, K., and Madry, A. Introducing SWE-bench verified,  
2024\.

Grattafiori, A., Dubey, A., Jauhri, A., Pandey, A., Kadian,  
A., Al-Dahle, A., Letman, A., Mathur, A., Schelten, A.,  
Vaughan, A., et al. The llama 3 herd of models.ArXiv  
preprint, abs/2407.21783, 2024\.

\`\`\`  
Hashemi, M. Awesome python applica-  
tions. https://github.com/mahmoud/  
awesome-python-applications, 2024\.  
\`\`\`  
\`\`\`  
Hendrycks, D., Basart, S., Kadavath, S., Mazeika, M., Arora,  
A., Guo, E., Burns, C., Puranik, S., He, H., Song, D., and  
Steinhardt, J. Measuring coding challenge competence  
with APPS. InProceedings of the NeurIPS Track on  
Datasets and Benchmarks, 2021\.  
\`\`\`  
\`\`\`  
Huang, Y., Lin, Z., Liu, X., Gong, Y., Lu, S., Lei, F.,  
Liang, Y., Shen, Y., Lin, C., Duan, N., and Chen, W.  
Competition-level problems are effective LLM evalua-  
tors. InFindings of the Association for Computational  
Linguistics, ACL 2024, Bangkok, Thailand and virtual  
meeting, August 11-16, 2024, 2024\. doi: 10.18653/V1/  
2024.FINDINGS-ACL.803.  
\`\`\`  
\`\`\`  
Jain, N., Han, K., Gu, A., Li, W., Yan, F., Zhang, T.,  
Wang, S., Solar-Lezama, A., Sen, K., and Stoica, I. Live-  
codebench: Holistic and contamination free evaluation of  
large language models for code.CoRR, abs/2403.07974,  
2024a. doi: 10.48550/ARXIV.2403.07974.  
\`\`\`  
\`\`\`  
Jain, N., Shetty, M., Zhang, T., Han, K., Sen, K., and Stoica,  
I. R2E: turning any github repository into a programming  
agent environment. InForty-first International Confer-  
ence on Machine Learning, ICML 2024, Vienna, Austria,  
July 21-27, 2024, 2024b.  
\`\`\`  
\`\`\`  
Jain, N., Shetty, M., Zhang, T., Han, K., Sen, K., and Stoica,  
I. R2e: Turning any github repository into a programming  
agent test environment. InICLR 2024, 2024c.  
\`\`\`  
\`\`\`  
Jimenez, C. E., Yang, J., Wettig, A., Yao, S., Pei, K., Press,  
O., and Narasimhan, K. R. Swe-bench: Can language  
models resolve real-world github issues? InProc. of  
ICLR, 2024\.  
\`\`\`  
\`\`\`  
Liu, A., Feng, B., Xue, B., Wang, B., Wu, B., Lu, C., Zhao,  
C., Deng, C., Zhang, C., Ruan, C., et al. Deepseek-v  
technical report.ArXiv preprint, abs/2412.19437, 2024\.  
\`\`\`  
\`\`\`  
Liu, T., Xu, C., and McAuley, J. J. Repobench: Bench-  
marking repository-level code auto-completion systems.  
CoRR, abs/2306.03091, 2023\. doi: 10.48550/ARXIV.  
2306.03091.  
\`\`\`  
\`\`\`  
Mündler, N., Mueller, M. N., He, J., and Vechev, M. Swt-  
bench: Testing and validating real-world bug-fixes with  
code agents. InThe Thirty-eighth Annual Conference on  
Neural Information Processing Systems, 2024\.  
\`\`\`  
\`\`\`  
OpenAI. Openai model docs. https://platform.  
openai.com/docs/models/gpt-4o, 2025\.  
\`\`\`  
\`\`\`  
OpenDevin. Opendevin: Code less, make more, 2024\.  
\`\`\`

Qwen Team. Qwen32.5 technical report. ArXiv preprint,  
abs/2412.15115, 2024\.

Ridnik, T., Kredo, D., and Friedman, I. Code genera-  
tion with alphacodium: From prompt engineering to  
flow engineering. CoRR, abs/2401.08500, 2024\. doi:  
10.48550/ARXIV.2401.08500.

Statista. Statista market insights. https:  
//www.statista.com/outlook/tmo/  
software/worldwide.

van Kemenade, H., Paterson, C., Thoma, M., Si, R., and Dol-  
lenstein, Z. hugovk/top-pypi-packages: Release 2024.12,  
2024\.

Wang, L., Ma, C., Feng, X., Zhang, Z., Yang, H., Zhang, J.,  
Chen, Z., Tang, J., Chen, X., Lin, Y., Zhao, W. X., Wei,  
Z., and Wen, J. A survey on large language model based  
autonomous agents.Frontiers Comput. Sci., 2024a.

Wang, X., Li, B., Song, Y., Xu, F. F., Tang, X., Zhuge, M.,  
Pan, J., Song, Y., Li, B., Singh, J., Tran, H. H., Li, F.,  
Ma, R., Zheng, M., Qian, B., Shao, Y., Muennighoff, N.,  
Zhang, Y., Hui, B., Lin, J., Brennan, R., Peng, H., Ji, H.,  
and Neubig, G. OpenHands: An Open Platform for AI  
Software Developers as Generalist Agents, 2024b.

Xia, C. S., Deng, Y., Dunn, S., and Zhang, L. Agentless:  
Demystifying llm-based software engineering agents.  
CoRR, abs/2407.01489, 2024\. doi: 10.48550/ARXIV.  
2407.01489.

Yang, J., Jimenez, C. E., Wettig, A., Lieret, K., Yao,  
S., Narasimhan, K., and Press, O. Swe-agent: Agent-  
computer interfaces enable automated software engineer-  
ing. CoRR, abs/2405.15793, 2024a. doi: 10.48550/  
ARXIV.2405.15793.

Yang, J., Jimenez, C. E., Wettig, A., Lieret, K., Yao, S.,  
Narasimhan, K., and Press, O. SWE-agent: Agent Com-  
puter Interfaces Enable Software Engineering Language  
Models, 2024b.

Zhang, Y., Ruan, H., Fan, Z., and Roychoudhury, A. Au-  
tocoderover: Autonomous program improvement.CoRR,  
abs/2404.05427, 2024\. doi: 10.48550/ARXIV.2404.  
05427\.

\#\# A. Appendix: Experiments

Below, we provide the exact model versions we used in Table 9\.

\`\`\`  
Table 9.LLM Details inlcuding Knowledge Cutoff (KC)  
Model Name Model ID API Provider KC Reference  
GPT-4O gpt-4o-2024-08-06 OpenAI Oct 2023 OpenAI (2025)  
GPT-4O-MINI gpt-4o-mini-2024-07-18 OpenAI Oct 2023 OpenAI (2025)  
HAIKU-3.5 claude-3-5-haiku-20241022 Anthropic Jul 2024 Anthropic (2024)  
DEEPSEEKV3 DeepSeek-V3 TogetherAI \- Liu et al. (2024)  
LLAMA3.3 70B Meta-Llama-3.3-70B-Instruct-Turbo TogetherAI Dec 2023 Grattafiori et al. (2024)  
QWEN2.5 Qwen2.5-72B-Instruct-Turbo TogetherAI Qwen Team (2024)  
\`\`\`  
A.1. Ablations

\`\`\`  
Table 11.Repeatability of SETUPAGENT  
Run Successes Symmetric Difference to Run 1  
1 27 \-  
2 27 0  
3 26 1  
\`\`\`  
Repeatability While benchmarks need only be constructed once  
and thus the repeatability ofSETUPAGENThas no impact on the  
value and repeatability of benchmark’s it creates, repeatability is an  
important aspect for the usability of such a system. Therefore, we  
conducted an experiment runningSETUPAGENTthree times on 100  
random candidate repositories fromSWEEin a setup like for Table 5\.  
We show results in Table 11, where we report the number of successfully installed repositories and the symmetric difference  
in installed repositories compared to the first run. We find thatSETUPAGENTis highly repeatable, with only one repository  
being installed in the first and second run that was not installed in the third run.

\#\# B. Appendix: Prompts

In this Section, we provide the full-length prompts used by SETUPAGENT.

Table 10.SWApipeline from projects to tasks. A PR is valid if it resolves an issue, modifies a test file, and is merged. An instance valid,  
if it has additionally at least oneF→Ptest.

\`\`\`  
Step \# Repos \# PRs  
Initial Projects 475  
\+GH Repo Found 440  
\+Preprocessing 427  
\+Permissive License 227  
\+Has valid PR 154  
\+SETUPAGENTsucceeds 44  
\+Get up to 50 valid PRs 1527  
\+SETUPAGENTsucceeds 893  
\+valid instance 535  
\`\`\`  
\`\`\`  
Prompt to suggest relevant files  
\`\`\`  
\`\`\`  
You are a senior developer contributing to the http://www.github.com/\<repo\_id\>  
project by solving issues. You have created a Docker environment with  
Ubuntu, and now you want to install the repository in development mode  
(meant for active development and testing) and run the tests. The first  
step is to locate the installation instructions and the test commands.  
I will provide you a list of filenames or file paths (e.g., README.md,  
contributing.md), which typically include instructions for installation  
and testing. The files can be either filenames (e.g., README.md) or file  
paths (e.g., docs/maintaining/installing/install-from-source.rst). From the  
provided list of filenames or file paths your task is: 1\. Identify those  
likely related to installation or testing based on their names. 2\. Exclude  
those that are clearly irrelevant. 3\. If unsure, include the file/path in  
your response. 4\. Return only the files/paths from the given list, exactly  
as they appear, without modifying their names or structure 5\. If a full  
path is given, return the full path, not just the filename. 6\. Use the  
following format for your response \<ANSWER\>: file 1, ...file n, filepath 1,  
...filepath k  
\<REASONING\>: \<YOUR REASONING\>  
Example input:  
‘‘‘  
readme.md, contributing.md, contributors.md,  
docs/maintaining/installing/install-from-source.rst,  
docs/source/lib/install\_datatypes.rst,  
docs/html/ux-research-design/contribute.md  
‘‘‘  
A reasonable output is:  
‘‘‘  
\<ANSWER\>: readme.md, contributing.md,  
docs/maintaining/installing/install-from-source.rst,  
\<REASONING\>: The files readme.md and contributing.md  
commonly contain installation and testing instructions, while  
docs/maintaining/installing/install-from-source.rst is likely related to  
installation as the name suggests  
‘‘‘  
Here are the file names  
‘‘‘  
\<file 1\>, \<file 2\>, ..., \<file k\>  
‘‘‘  
Please read the names carefully, ask yourself the purpose of each file based  
on the name before including it in your response. Use the given format for  
your answer and please do not add any extra comment or text.  
\`\`\`  
\`\`\`  
Figure 9.Prompt for choosing relevant files to installation and testing  
\`\`\`

\`\`\`  
Prompt to suggest external sources of information  
\`\`\`  
\`\`\`  
You are a senior developer contributing to the GitHub project at  
http://www.github.com/\<repo\_id\> by solving issues. Your goal is to install the  
repository in development mode and run its tests.  
You have created a Docker environment with Ubuntu, and now you are searching  
for the installation instructions and test commands.  
I will provide you with the content of common repository files (e.g.,  
README.md, CONTRIBUTING.md). Your task is to analyze the provided text  
and identify all external links that contain relevant information to  
\`\`\`  
1\. Installation instructions for this project.  
2\. Test commands or instructions for running the tests for this project.  
3\. Contribution guidelines.

\`\`\`  
Please provide the links you found following the criteria below.  
a. Exclude links to generalpurpose documentation for external tools (e.g.,  
Tox, Pytest, or other frameworks/libraries).  
b. If you are unsure about the relevance of a link, better include it.  
c. Order the links from most to least relevant.  
d. Do not add any comment or text.  
e. Use the following format:  
LINK: \<LINK 1\>  
LINK: \<LINK 2\>  
...LINK: \<LINK n\>  
Here is the text:  
’’’  
\<text\_content\>  
’’’  
\`\`\`  
\`\`\`  
Figure 10.Prompt to suggest potentially relevant external sources  
\`\`\`  
\`\`\`  
Prompt to determine importance of a url content  
\`\`\`  
\`\`\`  
You are a senior developer working on the GitHub project at  
http://www.github.com/\<repo\_id\>. You have set up a Docker environment with Ubuntu,  
and now your goal is to install the repository in development mode and run  
its tests.  
Your task is to carefully review the content of the following link:  
\<current\_link\>, and determine if it includes installation instructions or  
test commands for the \<repo\_id\> project.  
Please follow these steps:  
\`\`\`  
1\. Look carefully in the provided content for any potential installation  
commands or test commands related to the \<repo\_id\> project.  
2\. Ask yourself if the located instructions are reasonable, legitimate  
and can be practically executed to install or to test the \<repo\_id\> project  
only.  
Please provide your answer using the following format:  
INSTALLATION/TEST COMMANDS: \<TRUE|FALSE\>  
REASONING: \<REASONING\>  
\*\*Important Notes\*\*  
Answer with TRUE only if the content explicitly includes valid and usable  
installation or test commands.  
    If you do not find any relevant commands, or if the instructions are  
vague, ambiguous, impractical, or unrelated answer FALSE.  
    When in doubt, answer FALSE.  
Content of the link \<current\_link\>:  
’’’  
\<clean\_content\> ’’’

Figure 11.Prompt for determining if a link is relevant to installation and testing in the extraction phase of the SETUPAGENT

\`\`\`  
Extract Install Command Prompt  
\`\`\`  
\`\`\`  
You are a senior developer working on the project located at  
http://www.github.com/\<repo\_id\>. You have created a Docker environment with  
Ubuntu, cloned the repository, and navigated to the directory \<repo\_dir\>.  
Your next step is to install the project in development mode, which is  
intended for active development and testing. I’ll provide you with  
important text files (e.g., README.md) and important continuous integration  
(CI) configuration files, which typically contain instructions for  
developers on installation and testing. The format provided will be the  
file name followed by its content.  
Your task is to identify and return the bash commands necessary for the  
correct installation of the repository. This includes system dependencies,  
project installation in development mode, and any prerequisites or  
configuration commands.  
\`\`\`  
\`\`\`  
\*\*IMPORTANT NOTES\*\*  
\`\`\`  
1\. Include system dependencies installation commands required for the  
project (e.g., via apt, yum, curl, etc.).  
2\. Include installation commands necessary for setting up the project in  
development mode.  
3\. Include prerequisites installation and configuration commands, such as  
those for npm or any other required setup.  
3\. If comprehensive installation instructions are provided, return them  
without any modifications.  
4\. Only exclude commands related to creating or activating virtual  
environments.

\`\`\`  
The returned commands should meet the following criteria:  
\`\`\`  
1\. Enclosed in quotes.  
2\. Focused strictly on commands necessary for both system dependency  
installation and development-mode installation of the project.  
3\. Free from any comments or text.  
4\. Accurate and executable without errors.

If no installation commands are present, return NONE.  
Here is the text:  
‘‘‘  
\<context\>  
‘‘‘  
Take your time to carefully analyze the content. Make sure that your  
response includes only the necessary installation bash commands. Ask  
yourself if the provided content is sufficient for installation. And for  
each command, ask yourself what’s the purpose of the command and if it is  
necessary.  
An example of the expected response is:  
‘‘‘bash  
install\_command\_  
install\_command\_  
‘‘‘  
Please provide the installation commands in the above specified format.

\`\`\`  
Figure 12.Prompt used for extraction of installation commands in extraction phase of SETUPAGENT  
\`\`\`

\`\`\`  
Extract Test Command Prompt  
\`\`\`  
\`\`\`  
You are a senior developer working on the http://www.github.com/\<repo\_id\> project.  
You have created a Docker environment with Ubuntu, cloned the repository,  
and installed it in development mode (meant for active development and  
testing).  
You are now inside the \<repo\_dir\> directory and your next goal is to run  
the unit tests. I will provide you with some important text files (e.g.,  
README.md) and important continuous integration (CI) congiguration files,  
which typically include instructions for running tests. The format provided  
will be the file name followed by its content.  
Your task is to identify and return the exact bash commands required to run  
the tests.  
The returned commands should meet the following criteria:  
\`\`\`  
1\. Enclosed in quotes.  
2\. Free from any comments or text.  
3\. Accurate and executable without errors.  
If no test commands are present, return NONE.  
Here is the text:  
‘‘‘  
\<context\>  
‘‘‘  
Take your time to analyze the content carefully. Ensure that only the  
necessary bash commands for running the tests are included. Ask yourself  
the purpose of each command before including it in your response.  
An example of the expected response is:  
‘‘‘bash  
test\_command\_  
test\_command\_  
‘‘‘  
Please provide the test commands in the above specified format.

\`\`\`  
Figure 13.Prompt used for extraction of test commands in the extraction phase of SETUPAGENT  
\`\`\`

\`\`\`  
Prompt for determining error causes  
\`\`\`  
You are a developer working on the project at \[http://www.github.com/\<repo\_id\>.\](http://www.github.com/\<repo\_id\>.) You  
created an environment with python version \<python\_version\>. Your goal is  
to install the repository in development mode (meant for active development  
and testing) and run the unit tests.  
The installation commands are:  
‘‘‘bash  
\<install\_command\_1\>  
\<install\_command\_2\>  
...  
\<install\_command\_k\>  
‘‘‘  
The testing commands are:  
‘‘‘bash  
\<test\_command\_1\>  
\<test\_command\_2\>  
...  
\<test\_command\_k\>  
‘‘‘  
You received the following error message after executing the command  
\<error\_command\>:  
’’’  
\<error\_message\>  
’’’  
Your task is to analyze the error message and determine its causes.  
You can return one of the following answers:

1\. \<PYTHON\>, if the error is caused by incompatibilities between the python  
version and any used package.  
2\. \<INSTALLATION\>, if the error is caused by an installation command or is  
related to any missing package, regardless if it a testing related framework  
or not. All the required packages must be installed in the installation  
phase.  
3\. \<TESTING\>, if the error is caused by any testing command (e.g., an  
invalid flag in the test command)  
4\. \<UNDECIDABLE\>, if you cannot determine what causes the error.  
Please read the error message carefully and try to spot the commands that  
are responsible for the error. Always provide the reasoning for your  
answer.  
Use the following format:  
RESULT: \<PYTHON, INSTALLATION, TESTING, UNDECIDABLE\>  
REASONING: \<YOUR REASONING\>

\`\`\`  
Figure 14.Prompt for determining the error cause in the iterative improvement phase of the SETUPAGENT  
\`\`\`

\`\`\`  
Prompt for fixing python version  
\`\`\`  
\`\`\`  
You are a senior developer working on the project at  
http://www.github.com/\<repo\_id\>. Your goal is to install the repository in  
development mode (meant for active development and testing) and run the  
unit tests.  
You created an environment with python version \<python\_version\>, but you are  
unsure if the python version is correct.  
You received the following error message while testing the repository:  
’’’  
\<error\_message\>  
’’’  
A senior software developer colleague has provided an explanation of why  
things are not working as expected with the current commands:  
\<Reasoning from the answer to the prompt for determining the error cause\>.  
Use his reasoning to resolve the current error we are facing.  
Your task is to determine a compatible Python version for the current state  
of the repository. Carefully read the error message and identify the most  
suitable Python version.  
Please follow this answer format:  
\`\`\`  
1\. Return \<NONE\> if the error is unrelated to the Python version or you  
cannot determine a compatible version.  
2\. If a specific Python version is compatible, return only the version  
number (e.g., ̈2.7 ̈).  
3\. Do not include any additional comments or text in your response.

\`\`\`  
Figure 15.Prompt for fixing python version used in the iterative improvement phase of SETUPAGENT  
\`\`\`  
\`\`\`  
Prompt for fixing installation commands 1  
\`\`\`  
\`\`\`  
You are a senior developer working on the project at  
http://www.github.com/\<repo\_id\>. You are working in an enviroment with python  
version \<python\_version\>. You have attempted to install the repository  
in development mode (meant for active development and testing) using the  
following bash commands:  
‘‘‘bash  
\<install\_command\_1\>  
\<install\_command\_2\>  
...  
\<install\_command\_n\>  
‘‘‘  
However, the command \<error\_command\> failed and we received the following  
error message:  
’’’  
\<error\_message\> ’’’  
Your task is to fix the above error. Think carefully what causes the error  
and try to spot the commands that are responsible for it. Please provide  
the updated installation steps in a bash code block, following these rules:  
\`\`\`  
1\. You have to use always uv pip instead of regular pip.  
2\. Return \<NONE\> if you can not fix the command.  
3\. Do not add any comments or text.  
For example:  
‘‘‘bash  
apt-get install \-y \<package\_name\>  
uv pip install \-r requirements.txt  
‘‘‘

Figure 16.Prompt for fixing the installation commands used in the iterative improvement phase ofSETUPAGENTwhen the error occurs in  
the building process of containers

\`\`\`  
Prompt for fixing installation commands 2  
\`\`\`  
You are a senior developer working on the project at  
\[http://www.github.com/\<repo\_id\>.\](http://www.github.com/\<repo\_id\>.) You tried to install the repository in  
development mode, which is intended for active development and testing,  
however the installation failed.  
You are working in an enviroment with python version \<python\> and you tried  
to use the following bash commands for the installation:  
‘‘‘bash  
\<install\_command\_1\>  
\<install\_command\_2\>  
...  
\<install\_command\_n\>  
‘‘‘  
During the execution of these commands, you received the following error  
message: ’’’  
\<error\_message\> ’’’  
A senior software developer colleague has provided an explanation of why  
things are not working as expected with the current commands:  
\<Reasoning from the answer to the prompt for determining the error cause\>.  
Use his reasoning to resolve the current error we are facing.  
Your task is to carefully read the error message and determine which  
commands are causing the error. Reason about every command if it is causing  
the error. If you conclude that the problem is related to any of the  
commands, update the installation bash script to solve the problem. Note  
that you can also add new commands to fix the problem. If you decide to  
update the installation bash script you have to follow these rules:

1\. Provide the updated installation steps in a bash code block.  
2\. Use uv pip instead of regular pip.  
2\. Return NONE if the error is not related to the installation steps or you  
are not able to fix it.  
3\. Do not add any comments or text.  
For example:  
The initial installation command is:  
‘‘‘bash  
uv pip install ̇  
‘‘‘  
However, the error message states that the \<package\_name\> package is not  
installed. Then you would update the installation command to:  
‘‘‘bash  
uv pip install ̇  
uv pip install \<package\_name\> ‘‘‘

\`\`\`  
Figure 17.Prompt for fixing the installation commands used in the iterative improvement phase of SETUPAGENT  
\`\`\`

\`\`\`  
Prompt for fixing testing commands  
\`\`\`  
You are a senior developer working on the project at  
\[http://www.github.com/\<repo\_id\>.\](http://www.github.com/\<repo\_id\>.) You installed the repository in an enviroment  
with python version \<python\_version\> and now you are trying to run the unit  
tests.  
You run the tests using the following bash commands:  
‘‘‘bash  
\<test\_command\_1\>  
\<test\_command\_2\>  
...  
\<test\_command\_k\>  
‘‘‘  
However, at the moment we receive the following error message:  
’’’ \<error\_message\> ’’’  
A senior software developer colleague has provided an explanation of why  
things are not working as expected with the current commands:  
\<Reasoning from the answer to the prompt for determining the error cause\>.  
Use his reasoning to resolve the current error we are facing.  
Your task is to read the produced error message carefully, determine what  
the problem is and try to fix it. Ask yourself which test command could  
cause this problem. If you conclude that the problem is related to the test  
commands, update the test commands to solve the problem.  
Please provide the updated test commnds in a bash code block, following  
these rules:

1\. You have to always use uv pip instead of regular pip.  
2\. Return NONE if the error is not related to the test command or you  
cannot fix it.  
3\. Do not add any comments or text.  
4\. Add a command only if you are sure that it is correct.  
For example: The initial testing command was:  
‘‘‘bash  
pytest test\_file.py run all ‘‘‘ However, if in this case we would need the  
flag ’-v’ and the maximal number of failing tests to be 1, we would have to  
correct the command to:  
‘‘‘bash  
pytest test\_file.py maxfail=1 v ‘‘‘

\`\`\`  
Figure 18.Prompt for fixing the installation commands used in the iterative improvement phase of SETUPAGENT  
\`\`\`

\#\# C. Appendix – Dataset Details

Below, we list all repositories along with the number of corresponding tasks in SWA-Bench.

\`\`\`  
SWA-Bench– Repositories  
\`\`\`  
1\. iterative/dvc \- 42  
2\. streamlink/streamlink \- 35  
3\. spack/spack \- 35  
4\. PrefectHQ/prefect \- 34  
5\. xonsh/xonsh \- 32  
6\. mitmproxy/mitmproxy \- 31  
7\. python-pillow/Pillow \- 29  
8\. mkdocs/mkdocs \- 23  
9\. hynek/structlog \- 22  
10\. pallets/click \- 21  
11\. locustio/locust \- 20  
12\. jpadilla/pyjwt \- 17  
13\. elastic/elasticsearch-dsl-py \- 17  
14\. pallets-eco/wtforms \- 17  
15\. ipython/ipython \- 16  
16\. python-poetry/poetry \- 15  
17\. conan-io/conan \- 15  
18\. sabnzbd/sabnzbd \- 14  
19\. Zulko/moviepy \- 14  
20\. nvbn/thefuck \- 12  
21\. arrow-py/arrow \- 11  
22\. benoitc/gunicorn \- 8  
23\. cookiecutter/cookiecutter \- 8  
24\. pypa/pipenv \- 7  
25\. graphql-python/graphene \- 6  
26\. pypa/bandersnatch \- 5  
27\. AtsushiSakai/PythonRobotics \- 4  
28\. hynek/doc2dash \- 3  
29\. PythonCharmers/python-future \- 3  
30\. aimhubio/aim \- 2  
31\. dbcli/pgcli \- 2  
32\. geopython/pycsw \- 2  
33\. dbader/schedule \- 2  
34\. kibitzr/kibitzr \- 1  
35\. getnikola/nikola \- 1  
36\. geopy/geopy \- 1  
37\. Maratyszcza/PeachPy \- 1  
38\. gawel/pyquery \- 1  
39\. Suor/funcy \- 1  
40\. simonw/datasette \- 1  
41\. cowrie/cowrie \- 1  
42\. pypa/pip \- 1  
43\. StevenBlack/hosts \- 1  
44\. jupyter/nbgrader \- 1

\`\`\`  
Below, we list all repositories along with the number of corresponding tasks in SWEE-Bench.  
\`\`\`

SWEE-Bench– Repositories Part I

1\. python-attrs/attrs \- 9  
2\. dgasmith/opt\_einsum \- 9  
3\. jazzband/tablib \- 8  
4\. MartinThoma/flake8-simplify \- 8  
5\. matthewwithanm/python-markdownify \- 8  
6\. stephenhillier/starlette\_exporter \- 8  
7\. sciunto-org/python-bibtexparser \- 8  
8\. davidhalter/parso \- 8  
9\. marshmallow-code/flask-smorest \- 7  
10\. adamchainz/blacken-docs \- 7  
11\. MarketSquare/robotframework-tidy \- 7  
12\. lundberg/respx \- 7  
13\. seperman/deepdiff \- 7  
14\. Stranger6667/hypothesis-graphql \- 7  
15\. cantools/cantools \- 7  
16\. didix21/mdutils \- 7  
17\. marshmallow-code/apispec \- 7  
18\. softlayer/softlayer-python \- 6  
19\. gorakhargosh/watchdog \- 6  
20\. pygments/pygments \- 6  
21\. dask-contrib/dask-histogram \- 6  
22\. andialbrecht/sqlparse \- 6  
23\. mirumee/ariadne \- 6  
24\. tableau/tabcmd \- 6  
25\. gerrymanoim/exchange\_calendars \- 5  
26\. snowplow/snowplow-python-tracker \- 5  
27\. joerick/pyinstrument \- 5  
28\. scikit-rf/scikit-rf \- 5  
29\. matthewwardrop/formulaic \- 5  
30\. laspy/laspy \- 5  
31\. python-control/python-control \- 5  
32\. mwouts/itables \- 5  
33\. AzureAD/microsoft-authentication-library-for-python  
\- 5  
34\. firebase/firebase-admin-python \- 5  
35\. ethereum/eth-account \- 5  
36\. davidhalter/jedi \- 5  
37\. agronholm/typeguard \- 5  
38\. Delgan/loguru \- 5  
39\. pytransitions/transitions \- 5  
40\. lovasoa/marshmallow\_dataclass \- 5  
41\. aio-libs/yarl \- 5  
42\. PyCQA/pyflakes \- 5  
43\. python/importlib\_metadata \- 5  
44\. konradhalas/dacite \- 5  
45\. ilevkivskyi/typing\_inspect \- 5  
46\. jupyter/jupyter\_core \- 5  
47\. getsentry/responses \- 5  
48\. beartype/plum \- 4  
49\. open2c/bioframe \- 4  
50\. developmentseed/morecantile \- 4  
51\. nats-io/nats.py \- 4  
52\. nipy/nipype \- 4  
53\. python-quantities/python-quantities \- 4  
54\. stac-utils/pystac-client \- 4  
55\. luolingchun/flask-openapi3 \- 4  
56\. sayanarijit/expandvars \- 4  
57\. jpadilla/pyjwt \- 4  
58\. NowanIlfideme/pydantic-yaml \- 4  
59\. john-kurkowski/tldextract \- 4  
60\. geopandas/geopandas \- 4  
61\. cloudevents/sdk-python \- 4  
62\. jupyter/nbformat \- 4  
63\. matthew-brett/delocate \- 4  
64\. iterative/shtab \- 4  
65\. jsonpickle/jsonpickle \- 4  
66\. ethereum/eth-utils \- 4  
67\. mhe/pynrrd \- 4  
68\. adamjstewart/fiscalyear \- 4  
69\. pytest-dev/pytest-xdist \- 4  
70\. facelessuser/wcmatch \- 4  
71\. scikit-hep/awkward \- 4  
72\. tomplus/kubernetes\_asyncio \- 4  
73\. ipython/traitlets \- 4  
74\. David-Wobrock/sqlvalidator \- 4  
75\. omry/omegaconf \- 4  
76\. python-lsp/python-lsp-server \- 4  
77\. cogeotiff/rio-tiler \- 3  
78\. wjohnson/pyapacheatlas \- 3

\`\`\`  
SWEE-Bench – Repositories Part II  
\`\`\`  
79\. adamchainz/django-htmx \- 3  
80\. mwclient/mwclient \- 3  
81\. executablebooks/sphinx-book-theme \- 3  
82\. scikit-hep/vector \- 3  
83\. patrick-kidger/equinox \- 3  
84\. christiansandberg/canopen \- 3  
85\. regebro/pyroma \- 3  
86\. nephila/giturlparse \- 3  
87\. cookiecutter/cookiecutter \- 3  
88\. serge-sans-paille/pythran \- 3  
89\. tomasvotava/fastapi-sso \- 3  
90\. jsvine/pdfplumber \- 3  
91\. scrapy/protego \- 3  
92\. SmileyChris/django-countries \- 3  
93\. cscorley/whatthepatch \- 3  
94\. pythological/kanren \- 3  
95\. pypa/virtualenv \- 3  
96\. fastavro/fastavro \- 3  
97\. marshmallow-code/marshmallow-sqlalchemy \-  
    3  
98\. gazpachoking/jsonref \- 3  
99\. lepture/mistune \- 3  
100\. scikit-learn-contrib/category\_encoders \-  
3  
101\. simonw/sqlite-utils \- 3  
102\. executablebooks/mdit-py-plugins \- 3  
103\. tsutsu3/linkify-it-py \- 3  
104\. hhatto/autopep8 \- 3  
105\. cubewise-code/mdxpy \- 3  
106\. joblib/joblib \- 3  
107\. python-trio/trio-typing \- 3  
108\. nalepae/pandarallel \- 3  
109\. tableau/server-client-python \- 3  
110\. r1chardj0n3s/parse \- 3  
111\. ipython/ipython \- 3  
112\. pypa/readme\_renderer \- 3  
113\. jaraco/zipp \- 3  
114\. docker/docker-py \- 3  
115\. joshy/striprtf \- 3  
116\. googleapis/python-pubsub \- 3  
117\. TylerYep/torchinfo \- 3  
118\. scrapy/w3lib \- 3  
119\. googleapis/google-auth-library-python-oauthlib  
\- 3  
120\. agronholm/cbor2 \- 3  
121\. weiwei/junitparser \- 3  
122\. conan-io/conan \- 3  
123\. python/importlib\_resources \- 3  
124\. timvink/mkdocs-git-authors-plugin \- 3  
125\. agronholm/exceptiongroup \- 3  
126\. magmax/python-inquirer \- 3  
127\. PrefectHQ/prefect \- 3  
128\. Yelp/detect-secrets \- 3  
129\. Chilipp/autodocsumm \- 3  
130\. jaraco/keyring \- 3  
131\. Pylons/waitress \- 3  
132\. pypa/setuptools \- 3  
133\. barrust/pyspellchecker \- 2  
134\. bluesky/ophyd \- 2  
135\. OpenMath/py-openmath \- 2  
136\. readthedocs/sphinx-notfound-page \- 2  
137\. canonical/operator \- 2  
138\. ekzhu/datasketch \- 2  
139\. dhatim/python-license-check \- 2  
140\. Shoobx/xmldiff \- 2  
141\. ewels/rich-click \- 2  
142\. jaraco/path \- 2  
143\. yu-iskw/dbt-artifacts-parser \- 2  
144\. symerio/pgeocode \- 2  
145\. daggaz/json-stream \- 2  
146\. jazzband/dj-database-url \- 2  
147\. nipunsadvilkar/pySBD \- 2  
148\. adamchainz/django-linear-migrations \- 2  
149\. mwouts/jupytext \- 2  
150\. MrBin99/django-vite \- 2  
151\. ml31415/numpy-groupies \- 2  
152\. regebro/svg.path \- 2  
153\. gmr/flatdict \- 2  
154\. aws-samples/sample-python-helper-aws-appconfig  
\- 2  
155\. behave/behave \- 2

\`\`\`  
SWEE-Bench – Repositories Part III  
\`\`\`  
156\. thesimj/envyaml \- 2  
157\. codingjoe/django-select2 \- 2  
158\. allisson/python-simple-rest-client \- 2  
159\. christianhelle/autofaker \- 2  
160\. esphome/aioesphomeapi \- 2  
161\. oauthlib/oauthlib \- 2  
162\. rustedpy/result \- 2  
163\. graphql-python/graphene \- 2  
164\. benmoran56/esper \- 2  
165\. eerimoq/bincopy \- 2  
166\. keleshev/schema \- 2  
167\. PyCQA/flake8 \- 2  
168\. kjd/idna \- 2  
169\. jupyter/nbconvert \- 2  
170\. scikit-hep/hist \- 2  
171\. spulec/freezegun \- 2  
172\. jupyter/nbclient \- 2  
173\. PythonCharmers/python-future \- 2  
174\. tortoise/pypika-tortoise \- 2  
175\. rthalley/dnspython \- 2  
176\. mkaranasou/pyaml\_env \- 2  
177\. terraform-compliance/cli \- 2  
178\. googleapis/python-firestore \- 2  
179\. googleapis/python-api-core \- 2  
180\. scrapy/cssselect \- 2  
181\. python-humanize/humanize \- 2  
182\. jdepoix/youtube-transcript-api \- 2  
183\. dedupeio/dedupe \- 2  
184\. databricks/databricks-cli \- 2  
185\. bluesky/event-model \- 2  
186\. workos/workos-python \- 2  
187\. kynan/nbstripout \- 2  
188\. assertpy/assertpy \- 2  
189\. dbt-labs/hologram \- 2  
190\. sendgrid/python-http-client \- 2  
191\. keis/base58 \- 2  
192\. attwad/python-osc \- 2  
193\. wireservice/csvkit \- 2  
194\. adamchainz/time-machine \- 2  
195\. MagicStack/immutables \- 2  
    196\. vinitkumar/json2xml \- 2  
    197\. frispete/keyrings.cryptfile \- 2  
    198\. swansonk14/typed-argument-parser \- 2  
    199\. scottwernervt/favicon \- 2  
    200\. slackapi/python-slack-sdk \- 2  
    201\. nginxinc/crossplane \- 2  
    202\. hetznercloud/hcloud-python \- 2  
    203\. dbader/schedule \- 2  
    204\. amplify-education/python-hcl2 \- 2  
    205\. jazzband/contextlib2 \- 2  
    206\. theskumar/python-dotenv \- 2  
    207\. raimon49/pip-licenses \- 2  
    208\. locustio/locust \- 2  
    209\. astanin/python-tabulate \- 2  
    210\. alecthomas/voluptuous \- 2  
    211\. django-crispy-forms/crispy-bootstrap5 \- 2  
    212\. geospace-code/pymap3d \- 2  
    213\. tedder/requests-aws4auth \- 2  
    214\. pyvisa/pyvisa-py \- 1  
    215\. nithinmurali/pygsheets \- 1  
    216\. mlenzen/collections-extended \- 1  
    217\. emcconville/wand \- 1  
    218\. rsalmei/alive-progress \- 1  
    219\. rycus86/prometheus\_flask\_exporter \- 1  
    220\. fastapi-users/fastapi-users \- 1  
    221\. google/mobly \- 1  
    222\. scrapy/itemadapter \- 1  
    223\. ncclient/ncclient \- 1  
    224\. google/duet \- 1  
    225\. di/calver \- 1  
    226\. beancount/smart\_importer \- 1  
    227\. bridgecrewio/python-hcl2 \- 1  
    228\. construct/construct \- 1  
    229\. devrimcavusoglu/pybboxes \- 1  
    230\. richardpenman/whois \- 1  
    231\. cvxpy/cvxpy \- 1  
    232\. elastic/ecs-logging-python \- 1  
    233\. pythonarcade/pytiled\_parser \- 1  
    234\. astropy/extension-helpers \- 1

\`\`\`  
SWEE-Bench – Repositories Part IV  
\`\`\`  
235\. SAP/python-pyodata \- 1  
236\. Azure/azure-functions-durable-python \- 1  
237\. IdentityPython/djangosaml2 \- 1  
238\. jwodder/check-wheel-contents \- 1  
239\. Zulko/moviepy \- 1  
240\. xhtml2pdf/xhtml2pdf \- 1  
241\. cknd/stackprinter \- 1  
242\. guillp/jwskate \- 1  
243\. jmcarp/flask-apispec \- 1  
244\. timofurrer/colorful \- 1  
245\. miso-belica/sumy \- 1  
246\. kvesteri/intervals \- 1  
247\. marcotcr/lime \- 1  
248\. wkentaro/gdown \- 1  
249\. realpython/codetiming \- 1  
250\. jaraco/tempora \- 1  
251\. jendrikseipp/vulture \- 1  
252\. pycontribs/ruyaml \- 1  
253\. albumentations-team/albumentations \- 1  
254\. nose-devs/nose2 \- 1  
255\. jongracecox/anybadge \- 1  
256\. patrys/httmock \- 1  
257\. maxfischer2781/asyncstdlib \- 1  
258\. pgzip/pgzip \- 1  
259\. arvkevi/kneed \- 1  
260\. rasterio/affine \- 1  
261\. circus-tent/circus \- 1  
262\. xchwarze/samsung-tv-ws-api \- 1  
263\. jaraco/portend \- 1  
264\. fabiocaccamo/python-benedict \- 1  
265\. numpy/numpy-financial \- 1  
266\. praw-dev/prawcore \- 1  
267\. scipy/oldest-supported-numpy \- 1  
268\. logtail/logtail-python \- 1  
269\. polkascan/py-scale-codec \- 1  
270\. Knio/pynmea2 \- 1  
271\. jazzband/django-configurations \- 1  
272\. allenai/cached\_path \- 1  
273\. click-contrib/click-aliases \- 1  
    274\. Pylons/hupper \- 1  
    275\. cloudscale-ch/cloudscale-python-sdk \- 1  
    276\. alessandromaggio/pythonping \- 1  
    277\. imageio/imageio-ffmpeg \- 1  
    278\. podhmo/python-node-semver \- 1  
    279\. netbox-community/pynetbox \- 1  
    280\. kumar303/mohawk \- 1  
    281\. SpamScope/mail-parser \- 1  
    282\. perrygeo/python-rasterstats \- 1  
    283\. pahaz/sshtunnel \- 1  
    284\. python-hyper/h11 \- 1  
    285\. razorpay/razorpay-python \- 1  
    286\. zeroSteiner/rule-engine \- 1  
    287\. mocobeta/janome \- 1  
    288\. glut23/webvtt-py \- 1  
    289\. benoitc/gunicorn \- 1  
    290\. mcmtroffaes/pybtex-docutils \- 1  
    291\. alexmojaki/executing \- 1  
    292\. sigmavirus24/github3.py \- 1  
    293\. ccpem/mrcfile \- 1  
    294\. csinva/imodels \- 1  
    295\. click-contrib/click-help-colors \- 1  
    296\. srossross/rpmfile \- 1  
    297\. hgrecco/pint \- 1  
    298\. django-ses/django-ses \- 1  
    299\. gmr/pamqp \- 1  
    300\. spotify/annoy \- 1  
    301\. PyCQA/pycodestyle \- 1  
    302\. regebro/tzlocal \- 1  
    303\. mapado/haversine \- 1  
    304\. scientific-python/lazy-loader \- 1  
    305\. grappa-py/grappa \- 1  
    306\. flexmock/flexmock \- 1  
    307\. jg-rp/liquid \- 1  
    308\. prompt-toolkit/python-prompt-toolkit \- 1  
    309\. jaraco/jaraco.context \- 1  
    310\. aio-libs/multidict \- 1  
    311\. rsheftel/pandas\_market\_calendars \- 1

\`\`\`  
SWEE-Bench – Repositories Part V  
\`\`\`  
312\. mkdocs/mkdocs \- 1  
313\. websocket-client/websocket-client \- 1  
314\. DataDog/datadog-lambda-python \- 1  
315\. iterative/dvclive \- 1  
316\. cogeotiff/rio-cogeo \- 1  
317\. erikrose/parsimonious \- 1  
318\. facelessuser/pymdown-extensions \- 1  
319\. pypa/build \- 1  
320\. mkdocs/mkdocs-redirects \- 1  
321\. dlint-py/dlint \- 1  
322\. klen/peewee\_migrate \- 1  
323\. afq984/python-cxxfilt \- 1  
324\. kinverarity1/lasio \- 1  
325\. Turbo87/utm \- 1  
326\. django/daphne \- 1  
327\. executablebooks/sphinx-design \- 1  
328\. interpretml/slicer \- 1  
329\. google/yapf \- 1  
330\. sensein/etelemetry-client \- 1  
331\. MKuranowski/aiocsv \- 1  
332\. executablebooks/sphinx-tabs \- 1  
333\. pexpect/pexpect \- 1  
334\. pythological/etuples \- 1  
335\. frankie567/httpx-oauth \- 1  
336\. sarugaku/resolvelib \- 1  
337\. python273/telegraph \- 1  
338\. boolangery/py-lua-parser \- 1  
339\. Electrostatics/mmcif\_pdbx \- 1  
    340\. pyca/service-identity \- 1  
    341\. diff-match-patch-python/diff-match-patch \-  
       1  
    342\. xlwings/jsondiff \- 1  
    343\. mapbox/cligj \- 1  
    344\. cthoyt/pystow \- 1  
    345\. Rapptz/discord.py \- 1  
    346\. gahjelle/pyplugs \- 1  
    347\. Colin-b/pytest\_httpx \- 1  
    348\. LLNL/certipy \- 1  
    349\. spec-first/connexion \- 1  
    350\. Yelp/bravado \- 1  
    351\. mkorpela/pabot \- 1  
    352\. scrapy/parsel \- 1  
    353\. alexmojaki/pure\_eval \- 1  
    354\. graphql-python/graphql-core \- 1  
    355\. joke2k/faker \- 1  
    356\. averbis/averbis-python-api \- 1  
    357\. jupyter/jupyter\_client \- 1  
    358\. jaraco/inflect \- 1  
    359\. GreyZmeem/python-logging-loki \- 1  
    360\. suminb/base62 \- 1  
    361\. youknowone/wirerope \- 1  
    362\. xnuinside/simple-ddl-parser \- 1  
    363\. executablebooks/sphinx-thebe \- 1  
    364\. Pylons/webob \- 1  
    365\. SethMMorton/fastnumbers \- 1  
    366\. python-semver/python-semver \- 1


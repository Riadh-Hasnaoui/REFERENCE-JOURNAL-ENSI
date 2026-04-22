\#\# Proceedings of the 63rd Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers), pages 17160–

\#\# July 27 \- August 1, 2025 ©2025 Association for Computational Linguistics

\# FEA-Bench: A Benchmark for Evaluating Repository-Level Code

\# Generation for Feature Implementation

\#\# Wei Li

♡\*

\#\# , Xin Zhang

♠†‡

\#\# , Zhongxin Guo

♠

\#\# , Shaoguang Mao

♠

\#\# Wen Luo

♡

\#\# , Guangyue Peng

♡

\#\# , Yangyu Huang

♠

\#\# , Houfeng Wang

♡†

\#\# , Scarlett Li

♠

♡

\#\# State Key Laboratory of Multimedia Information Processing,

\#\# School of Computer Science, Peking University

♠

\#\# Microsoft Research Asia

\#\# weili22@stu.pku.edu.cn

\#\# xinzhang3@microsoft.com, wanghf@pku.edu.cn

\#\# Abstract

\#\# Implementing new features in repository-level

\#\# codebases is a crucial application of code gen-

\#\# eration models. However, current benchmarks

\#\# lack a dedicated evaluation framework for this

\#\# capability. To fill this gap, we introduce FEA-

\#\# Bench, a benchmark designed to assess the

\#\# ability of large language models (LLMs) to

\#\# perform incremental development within code

\#\# repositories. We collect pull requests from

\#\# 83 GitHub repositories and use rule-based and

\#\# intent-based filtering to construct task instances

\#\# focused on new feature development. Each task

\#\# instance containing code changes is paired with

\#\# relevant unit test files to ensure that the solu-

\#\# tion can be verified. The feature implementa-

\#\# tion requires LLMs to simultaneously possess

\#\# code completion capabilities for new compo-

\#\# nents and code editing abilities for other rel-

\#\# evant parts in the code repository, providing

\#\# a more comprehensive evaluation method of

\#\# LLMs’ automated software engineering capa-

\#\# bilities. Experimental results show that LLMs

\#\# perform significantly worse in the FEA-Bench,

\#\# highlighting considerable challenges in such

\#\# repository-level incremental code development.

\#\# Our code will soon be publicly available at

\#\# https://github.com/microsoft/FEA-Bench.

\#\# 1 Introduction

\#\# The remarkable text generation capabilities of large

\#\# language models (LLMs) (Achiam et al., 2023\)

\#\# have extended their impact into the domain of code

\#\# generation (Xu et al., 2022), which has led to the

\#\# emergence of developer assistants such as Copilot,

\#\# Cursor, Devin, etc. An important research topic is

\#\# evaluating the effectiveness of LLMs in generating

\#\# code across diverse scenarios. Many of the existing

\#\# benchmarks focus on evaluating standalone pro-

\#\# gramming problems, such as HumanEval, MBPP,

\#\# \*Work done during internship at MSRA.

\#\#\# †

\#\# Corresponding author.

\#\#\# ‡

\#\# Project leader.

\#\# Figure 1: The proposed FEA-Bench aims to evaluate

\#\# incremental repository development, while SWE-bench

\#\# (Jimenez et al., 2024\) focuses on repairing issues.

\#\# and LiveCodeBench (Chen et al., 2021; Austin

\#\# et al., 2021; Jain et al., 2024). These benchmarks

\#\# offer little insight into the challenges developers

\#\# face in real-world projects, where codebases are

\#\# composed of multiple interconnected files. In such

\#\# projects, modifications in one part of the code of-

\#\# ten necessitate corresponding edits elsewhere. This

\#\# type of collaborative, large-scale development is

\#\# referred to as repository-level code development.

\#\# In the realm of repository-level code generation,

\#\# much of the current evaluation effort is centered

\#\# around code completion (Li et al., 2024b; Yang

\#\# et al., 2024a). Code completion refers to gener-

\#\# ating correct code snippets at specified locations

\#\# within a given code context. However, this task

\#\# is inherently limited—it typically targets localized

\#\# generation and does not account for broader impli-

\#\# cations beyond the scope of completion.

\#\# Recent advancements in the capabilities of

\#\# LLMs have expanded their potential role from

\#\# merely suggesting code snippets to managing the

\#\# full lifecycle of repository development. A promi-

\#\# nent benchmark in this domain is SWE-bench

\#\# (Jimenez et al., 2024), which evaluates LLMs on

\#\# resolving issues, primarily focusing on bug fixes

\#\# within repositories. In practice, as shown in Fig-

\#\# ure 1, a more critical aspect of software engineer-

\#\# ing is the launch of new features, which often en-

\#\# tails introducing new functions or even entire files

\#\# 17160

into the repository. The continuous implementa-

tion of new features drives software growth and

is a key focus of automated software engineering.

We define such tasks as repository-level incremen-

tal code development. In this work, to bridge the

gap in benchmarks for this domain, we construct

a dataset derived from pull requests in GitHub

repositories that specifically focus on adding new

components, with the overarching goal of imple-

menting new features. Each task instance in our

dataset is paired with its corresponding unit test

files, culminating in the creation of theFeature

ImplementationBenchmark (FEA-Bench), which

comprises 1,401 task instances sourced from 83

diverse GitHub repositories.

Statistically, our dataset exhibits characteristics

that significantly differ from the bug-fix-oriented

SWE-bench. Task instances in FEA-Bench require

the implementation of new functions and classes

in Python and involve substantially longer code

generation compared to SWE-Bench. Experimen-

tal results demonstrate that current LLMs perform

poorly on the proposed benchmark. According to

our execution-based metrics, the best-performing

LLM, DeepSeek-R1, successfully resolves only

about 10% of the task instances. The key contribu-

tions of this paper are as follows:

\- We introduce the task of repository-level incre-

mental code development, addressing a criti-

cal challenge in real-world software engineer-

ing where the continuous implementation of

new features is essential for sustaining soft-

ware growth.

\- We construct the first benchmark to evalu-

ate repository-level incremental code devel-

opment. By employing parsing and other fil-

tering methods, we constructed a dataset com-

posed of feature implementation tasks, offer-

ing execution-based evaluation.

\- Using an automated pipeline, we scale the test

data to include 83 diverse code repositories,

ensuring high diversity. We will publicly re-

lease our data collection and evaluation code-

base, allowing FEA-Bench to be continuously

updated and expanded.

2 Related Work

2.1 Code Large Language Models

Large language models (LLMs) have revolution-

ized software engineering by enabling code gener-

ation, debugging, and translation capabilities (Pan

et al., 2024; Li et al., 2023a; Joshi et al., 2023;

Shi et al., 2024). Large-scale pre-trained LLMs

such as GPT-4 (Achiam et al., 2023), CodeLlama

(Roziere et al., 2023), DeepSeek-Coder (Guo et al.,

2024; Zhu et al., 2024), and Qwen2.5-Coder (Hui

et al., 2024\) have demonstrated proficiency in gen-

erating functional code across multiple program-

ming languages. Recent advancements also include

instruction-tuned models like Starcoder (Li et al.,

2023b), WizardCoder (Luo et al., 2023), Wave-

Coder (Yu et al., 2024b), Magicoder (Wei et al.,

2024\) and EpiCoder (Wang et al., 2025). With

these advancements, code LLMs are poised to fur-

ther revolutionize how developers interact with

code, promising increased efficiency in software

creation. Additionally, the integration of agents

(Luo et al., 2025\) has further enhanced the per-

formance of LLMs in software engineering tasks

(Yang et al., 2024b; Xia et al., 2024; Zhang et al.,

2024). In this paper, we further evaluate the per-

formance of current LLMs in the incremental code

development scenarios at the repository level. This

investigation aims to drive the research on code

LLMs toward addressing more intricate software

engineering challenges, thereby advancing the ca-

pabilities of these models in handling sophisticated

development tasks.

2.2 Code Generation Benchmarks

Recent code generation benchmarks, such as Hu-

manEval (Chen et al., 2021\) and MBPP (Austin

et al., 2021), have primarily focused on synthe-

sizing standalone functions or scripts from natu-

ral language, while subsequent efforts like APPS

(Hendrycks et al., 2021), EvalPlus (Liu et al.,

2023a), CoderEval (Yu et al., 2024a), ClassEval

(Du et al., 2023), BigCodeBench (Zhuo et al.,

2024), and FullStackBench (Liu et al., 2024b) have

expanded evaluation to more complex scenarios.

However, these benchmarks largely overlook the

repository-level challenges of real-world software

development, a gap addressed by recent works

(Bairi et al., 2024; Zhang et al., 2023). Because

of the wild applications of auto code completion

tools like Github Copilot (Dakhel et al., 2023),

most repository-level code generation benchmarks

aim to evaluate the code completion capabilities of

LLMs (Liu et al., 2023b). Repository-level code

completion aims to generate code for incomplete

code snippets within a repository (Wang et al.,

2024). Benchmarks such as DevEval (Li et al.,

2024b), EvoCodeBench (Li et al., 2024a), Codev-

Bench (Pan et al., 2024), and ExecRepoBench

(Yang et al., 2024a) evaluate this capability. How-

ever, code completion data constructed by remov-

ing a single line or function body can suffer from

future context leakage issues (Zheng et al., 2024).

In practice, autonomous development of a code

repository should include all edits to the code,

rather than simply completing the specified code

under perfect context. SWE-bench (Jimenez et al.,

2024\) focuses on repairing repositories’ issues by

revising existing programs. This highlights the

need for models to effectively modify and inte-

grate changes within the repository. Our work fills

another gap of incremental repository-level devel-

opment by introducing a benchmark that evaluates

LLMs on the implementation of new features, fur-

ther bridging the divide between code completion

and real-world software engineering.

3 Benchmark Construction

3.1 Overview

The task instances in FEA-Bench are constructed

based on existing pull request (PR) data from

GitHub. As illustrated in Figure 2, each task in-

stance contains the following elements:

❶Feature RequestContent of the pull request

and corresponding issues (if any) provide essential

information regarding the new feature or function-

ality to be developed.

❷Definition of New ComponentsThis in-

cludes the signatures and documentation of newly

added functions and classes. The name of the

new component must be consistent with that in

PR, which is the prerequisite for completing the

task, because unit tests are written based on the

specified name.

❸Environment SetupThis includes the rele-

vant information for the repository and specifies

the base commit of the code repository for each

task instance. Besides, the configurations of the

building execution environment are also included.

❹PatchIt describes the changes made to the

code in the repository and can be processed by

\`\`\`  
theunidiffstandard library  
1  
\`\`\`  
. Additionally, the

changes can be applied to the repository using the

git applytool. A patch can be divided into a

test patch and a gold patch; the former pertains to

changes in test codes, while the latter involves the

other changes affecting the software itself.

\`\`\`  
1  
https://github.com/matiasb/python-unidiff  
\`\`\`  
\`\`\`  
Figure 2: An example of the task instances from the  
FEA-Bench. During the inference of LLMs, the first  
two items: feature request and new components are  
considered as known information. The environment  
setup serves as a prerequisite for creating the testbed  
and environment. Python file patches and unit tests are  
used as labels and evaluation metrics and should not be  
leaked during the inference of LLMs.  
\`\`\`  
❺Unit TestThe correctness of the code changes

is verified based on the result of running these tests.

We get the ground truth status by actually running

pytestbefore and after applying the gold patch.

Our data collection pipeline is developed based

on SWE-bench. As shown in Figure 3, the pro-

posed collection pipeline ensures data diversity and

comprehensiveness, enabling a robust evaluation

of LLMs’ capabilities in implementing new fea-

tures at the repository level. By making our data

collection and evaluation codes publicly available,

we aim to facilitate continuous updates and the cre-

ation of new versions of FEA-Bench. In the rest of

this section, we will discuss the construction and

the characteristics of FEA-Bench.

3.2 Repository Collection

To determine the scope of GitHub repositories for

data collection, we initially focus on the GitHub

repositories corresponding to Python packages

\`\`\`  
listed on the Top PyPI website  
2  
\`\`\`  
. Packages appear-

ing on this list are generally influential Python soft-

\`\`\`  
2  
https://hugovk.github.io/top-pypi-packages/  
\`\`\`

Figure 3: The data collection pipeline for the FEA-Bench. First, determine the scope of GitHub repositories from

which task instances will be collected. Next, gather pull requests as task instances and apply filtering criteria to

\`\`\`  
select instances that meet the purpose of adding new features. Finally, use the included test files to execute unit tests,  
ensuring that only task instances with reproducible test results are included in FEA-Bench. For a more detailed  
construction process, please refer to Appendix A.2.  
\`\`\`  
ware with high data quality, and most repositories

use a unifiedpytestformat for testing, which facil-

itates later execution. This leaderboard contains

8,000 Python packages. We obtain approximately

600 repositories that meet the criteria of having a

license and more than 1,000 pull requests by apply-

ing a filtering process.

Fast ValidationExcept for repositories already

included in SWE-bench, the remaining reposito-

ries do not have customized installation procedures

or testing methods. While environment configura-

tions vary among different Python packages,pip

\`\`\`  
offers a unified installation approach  
3  
\`\`\`  
. And we

adoptpytestas the default method for unit testing.

Based on these settings, for each repository, we ex-

tract the first 20 pull requests that include changes

to test files and observe the unit test status. Reposi-

tories that have at least one task instance where the

unit tests passed with the default configuration are

retained, as they possess the potential to generate

task instances that meet our criteria.

After this fast validation process, in addition to

the 18 Python packages included in the SWE-bench

dataset, another 101 Python packages are identified

as sources for extracting repository-level data for

our benchmark.

3.3 Task Collection and Filtering

Based on existing repository data, we crawl all pull

requests and consider those that include changes

to test files as possible task instances. Given our

focus on the incremental feature development task,

we introduce the following steps to obtain the final

task instances for FEA-Bench through filtering:

Extraction of new componentsFor each task in-

stance candidate, we perform parsing on all Python

scripts involved in the gold patch. We compare the

state before and after applying the patch to iden-

tify newly added components, including classes

\#\#\# 3

pip install \-e.

and functions, and extract their signatures and doc-

strings as metadata.

Filtering based on new componentsWe re-

tain only those task instances that contain at least

one new component. To ensure that implementing

new features is the primary purpose of the pull re-

quest, we further restrict the new components to

occupy more than 25% of all edited lines in gold

patch. This threshold is set relatively low because

code changes often need to include modifications

to other related code in addition to the new compo-

nents themselves.

Intent-based filteringThe pull requests filtered

using the above rule-based approach still include

some that are not primarily aimed at feature imple-

mentation. Therefore, we use GPT-4o to classify

the intent based on the pull request description.

Only pull requests classified as "new feature" are

retained.

Verification by running unit testsFor each in-

stance, we first set up the environment and testbed.

We then apply the test patch and run the unit test

files involved in the test patch. Theoretically, some

unit tests should fail at this stage. After applying

the gold patch, we rerun the same unit tests. If the

configuration is correct, all unit tests should pass.

Unlike SWE-bench, we do not impose restrictions

on whetherImportErrororAttributeErroroc-

curs before applying the gold patch, as these errors

are almost inevitable before new components are

implemented. Instead, to ensure data quality, we

exclude samples where tests remain in the failed

status after applying the gold patch. The status

of each test function before and after applying the

gold patch is recorded.

After task collection and filtering, 83 out of 119

repositories collected by the method in Section

3.2 produce 1,401 task instances for new feature

implementation.

\`\`\`  
FEA-Bench SWE-bench  
Full Lite Full Verified  
\`\`\`  
\`\`\`  
|Repositories| 83 48 12 12  
|Tasks| 1401 200 2294 500  
\`\`\`  
\`\`\`  
\# Lines of oracle files 2115.5 1366.8 1961.3 1488\.  
\# Files edited 2.62 1.54 1.66 1\.  
\# Lines edited 128.5 68.1 37.71 14\.  
\`\`\`  
\`\`\`  
\# Lines of added components 87.1 47.2 10.9 2\.  
% Added components 67.8 69.3 28.9 14\.  
\# Functions added 4.49 2.02 0.73 0\.  
\# Classes added 0.78 0 0.064 0\.  
\`\`\`  
\`\`\`  
Table 1: Statistics for FEA-Bench and its lite subset,  
as well as for SWE-bench and its verified subset. The  
metrics include: 1\) the number of task instances and in-  
volved repositories; 2\) the average total number of lines  
in all Python files involved in code changes (i.e., the  
\`\`\`  
Oraclesetting described in Section 4.2), and the average

\`\`\`  
number of edited files and lines; 3\) the average number  
of lines of new components, the average percentage of  
new component lines relative to all edited lines, and the  
average number of added functions and classes.  
\`\`\`  
3.4 Benchmark Characteristics

Semi-guided software engineering taskAlthough

the signatures for new components are provided,

the primary objective of the FEA-Bench is to eval-

uate the whole solution of new feature implementa-

tion. This is a comprehensive real-world software

engineering task, distinct from code completion.

As shown in Table 1, each instance in FEA-Bench

involves an average of 128.5 modified lines, with

87.1 lines attributed to the new components them-

selves. This indicates that approximately 41.4 lines

of changes are made elsewhere in the repository.

Implementing new features not only requires the

ability to generate code for specified new compo-

nents but also necessitates making complementary

changes within the existing repository.

Lite versionWe have also curated a subset to

serve as a lite version of our dataset. This subset is

filtered based on criteria including higher quality

and lower difficulty. This lite version is particu-

larly useful for evaluating systems that are compu-

tationally intensive and time-consuming. Detailed

information can be found in Section A.3.

New components driven generation taskFrom

Table 1, we can observe that, on average, the num-

ber of lines for new components in each FEA-

Bench task instance is more than 8 ×that of SWE-

bench. Furthermore, the new components account

for approximately 67.8% of all edited lines in FEA-

Bench, compared to just 28.9% in SWE-bench.

The difference in this metric between FEA-Bench

lite and SWE-bench verified is even more pro-

nounced. These statistics indicate that the task

instances in FEA-Bench are primarily aimed at

implementing new features. In SWE-bench, the

average number of new functions is 0.73, indicat-

ing that its task instances mainly involve editing

existing code rather than incremental development.

Complex solutionsWhile SWE-bench focuses

on fixing issues, which generally involve simpler

problems, the task instances in FEA-Bench exhibit

greater complexity. From Table 1, whether mea-

sured by the number of edited lines or edited files,

the solutions of task instances in FEA-Bench are

notably more complex than those in SWE-bench.

4 Experimental Design

4.1 Models

Due to its repository-level code generation char-

acteristics, FEA-Bench requires models to have a

long context window. We evaluate representative

code LLMs and general-purpose LLMs with strong

foundational capabilities on the FEA-Bench. The

code LLMs used in our evaluation include CodeL-

\`\`\`  
lama, Codestral  
4  
, Qwen2.5-Coder, and DeepSeek-  
\`\`\`  
Coder-V2 (Roziere et al., 2023; Hui et al., 2024;

Zhu et al., 2024). For general-purpose LLMs,

we evaluate the performance of GPT-4, GPT-4o

(Achiam et al., 2023; Hurst et al., 2024\) and

DeepSeek-V3 (Liu et al., 2024a), as well as models

with long chain-of-thought (CoT) capabilities such

as o1 and DeepSeek-R1 (Jaech et al., 2024; Guo

et al., 2025).

4.2 Context

To explore the capabilities and potential limits of

LLMs in implementing new features within code

repositories, we construct different prompts from

several perspectives based on our collected data.

Each task instance is evaluated using various con-

text settings to provide a comprehensive under-

standing of model performance.

New component hintsIn FEA-Bench, informa-

tion about new components can be derived from

two sources: 1\) signatures and documentation

of newly extracted functions and classes, and 2\)

changes in non-Python files within the patch, which

often contain relevant information about the new

components. Based on this, we have two settings:

Brief.Only provides the signatures of new compo-

\#\#\# 4

https://mistral.ai/en/news/codestral

\`\`\`  
FEA-Bench FEA-Bench lite  
Model Size Window Oracle BM25 (27K) Oracle BM25 (27K)  
Detailed Brief Detailed Brief Detailed Brief Detailed Brief  
\`\`\`  
CodeLlama

\`\`\`  
13B 16K 0.14 0.43 × × 0.0 0.0 × ×  
34B 16K 0.57 0.57 × × 0.0 0.0 × ×  
\`\`\`  
Qwen2.5-Coder

\`\`\`  
14B 32K 3.57 3.57 3.71 2.93 3.5 4.5 3.5 2\.  
32B 32K 4.43 3.64 3.85 2.78 6.0 5.5 2.0 2\.  
\`\`\`  
Codestral-22B 22B 32K 0.86 0.93 1.43 1.36 0.5 1.0 0.0 0\.

\`\`\`  
DeepSeek-Coder-V2 16B 128K 0.21 0.29 0.57 0.36 0.0 0.5 0.0 0\.  
DeepSeek-R1-Distill 32B 128K 3.78 4.07 4.78 4.21 5.5 7.5 7.0 5\.  
DeepSeek-V3 671B 64K 8.14 6.92 8.21 7.64 14.5 10.5 13.0 12\.  
DeepSeek-R1 671B 64K 9.92 8.35 10.49 9.85 14.5 14.5 12.0 13\.  
\`\`\`  
\`\`\`  
GPT-4 128K 4.71 4.21 3.14 2.86 6.0 6.5 2.0 1\.  
GPT-4o 128K 6.14 5.57 5.28 4.50 5.0 5.0 4.0 3\.  
o1-mini 128K 1.93 1.86 2.28 2.57 2.0 3.5 1.0 2\.  
o1 200K 7.28 6.57 6.78 6.64 10.0 12.5 5.0 7\.  
\`\`\`  
Table 2: The resolved ratios on FEA-Bench (lite) task instances. The evaluation is conducted on single-round

generation outputs by each model and a task instance is considered resolved only if all unit tests are passed. The

prompt using BM25 retrieved files is limited to length of 27K tokens. This ensures that, with a maximum generation

of 4K tokens, the total length will not exceed 32K tokens, which is the context window limits of most tested models.

"Detailed" and "Brief" refer to the levels of hints regarding new components in prompt, as mentioned in Section 4.2.

nents.Detailed.Includes all the aforementioned

information.

Retrieval methodGiven the extensive amount

of code across multiple files in a repository, selec-

tive inclusion of file contents as context is neces-

sary. Firstly, the README file and files containing

new components are always included in the context.

For other files, similar to SWE-bench, we divide

retrieval methods into:Oracle.Includes all files

involved in the patch in the context.BM25.Re-

trieves relevant files across the entire repository by

BM25 algorithm (Robertson et al., 2009\) based on

the content of the pull request, and ranks them by

relevance and filling the context until reaching a

specified length.

Output formatGenerating an entire file can

lead to interruptions due to generation limits and

is costly. Therefore, our experiments offer two

edit-based generation settings:Natural.Generates

code edits in a natural format as pairs of before-

and-after snippets, which can be converted into

patches applicable to the code repository through

post-processing.Patch.Directly generates edits in

patch format. Since patches use line numbers for

fragment location, this setting includes line num-

bers in the context’s code content.

The details of prompt and experimental settings

are shown in Appendix B.

5 Evaluation Results

The performance of LLMsThe evaluation results

of FEA-Bench are presented in Table 2\. It is ob-

served that inOracleandDetailedprompt settings,

the best resolved ratio of task instances is 9.92%,

indicating the poor performance of LLMs in the in-

cremental development task at the repository level.

Generally, the models with larger parameter sizes

demonstrate better results. Among code LLMs,

Qwen2.5-Coder exhibited performance compara-

ble to that of GPT-4, highlighting its superiority

in the domain of code generation. Despite this,

general-purpose LLMs with stronger foundational

capabilities can approach the performance of spe-

cialized code LLMs. For example, R1-Distill,

which shares the same underlying architecture as

Qwen2.5-Coder, showed competitive performance.

Among the models evaluated, the latest DeepSeek-

V3 and R1 models achieve the best performance,

significantly outperforming OpenAI’s GPT-4 and

o1 series. This underscores the importance of foun-

dational capabilities in LLMs for repository-level

development tasks. Additionally, the performance

on the lite version is slightly higher, but the relative

trends remain largely consistent. When computa-

tional resources are limited, the metrics from FEA-

Bench lite can be used to reflect the performance

on the full benchmark.

The performance under different contextsAs

\`\`\`  
BM25 (27K) BM25 (40K)  
Retrieval Metrics (%)  
Precision Avg. 40.26 31\.  
Recall Avg. 76.04 77\.  
Recall All 51.61 53\.  
\`\`\`  
\`\`\`  
Resolved Ratio (%)  
Detailed Brief Detailed Brief  
\`\`\`  
\`\`\`  
GPT-4 3.14 2.86 3.14 2\.  
GPT-4o 5.28 4.50 4.78 4\.  
\`\`\`  
\`\`\`  
Table 3: The retrieval metrics and the instance resolved  
ratios under 27K and 40K token length limits of the  
prompt inBM25retrieval mode.  
\`\`\`  
shown in Table 2, we evaluate the performance of

LLMs under different settings of new component

hints and retrieval methods. Overall, detailed new

component hints lead to better model performance.

However, in the results from FEA-Bench lite, brief

hints that only provide signatures performed bet-

ter. This discrepancy could be attributed to the lack

of structured presentation of new components and

their documentation within the prompt, as illus-

trated in Figure 6\. Regarding retrieval methods, the

Oraclesetting generally outperforms theBM25set-

ting, although the difference is not substantial. This

may be because code files containing new compo-

nents, which are regarded as known conditions in

the FEA-Bench, ensure a certain baseline perfor-

mance. Considering the simplest instances in the

dataset: those involving modifications to only one

code file. Since instances in FEA-Bench always

include new components, the unique code file is

known information. In this case,BM25retrieved

files supplement additional information, which can

lead to better model performance compared to the

Oraclesetting.

6 Discussion

6.1 Retrieved Files in Context

We aim to investigate whether providing more code

context helps LLMs improve new feature develop-

ment. Therefore, we conducted experiments by

increasing the prompt limit from 27K to 40K to-

kens, which surpasses the original context window

limit of Qwen2.5-Coder but can contain more re-

trieved files. The results are presented in Table 3\.

The evaluated models include GPT-4 and GPT-4o,

and we also report the average precision and recall

of Python files in the context relative to those in the

gold patch, as well as the proportion of instances

\`\`\`  
%Apply %Resolved  
Model Natural Patch Natural Patch  
\`\`\`  
\`\`\`  
Qwen2.5-Coder(32B) 44.82 12.92 4.43 1\.  
R1-Distill(32B) 55.75 19.06 3.78 1\.  
GPT-4 59.10 33.26 4.71 3\.  
GPT-4o 66.38 19.49 6.14 1\.  
o1 57.03 \- 7.28 \-  
DeepSeek-V3 69.09 \- 8.14 \-  
DeepSeek-R1 73.16 \- 9.92 \-  
\`\`\`  
\`\`\`  
Table 4: The impact of output formatsNaturalandPatch.  
We show the success rates of applying code edits to the  
code repository and the final resolved ratios. The ex-  
periments on directly generating patches are conducted  
only on the models shown in the first four columns.  
\`\`\`  
where all involved files are recalled.

Although the recalls slightly improve at the limit

of 40K tokens, model performance decreases. This

indicates that current LLMs still struggle to extract

useful information from long contexts in repository-

level code development tasks. To improve perfor-

mance on FEA-Bench, enhancing the precision of

retrieval may be an effective approach than simply

increasing the context length.

6.2 Output Format of Edits

Direct repository-level code development outputs

edits rather than new code itself. How LLMs can

better generate edits remains an open question.

Therefore, we analyze the impact of output formats

using the two configurations described in Section

4.2. The two rightmost columns of Table 4 illustrate

a comparison between theNaturaland thePatch

generation method, with the former demonstrat-

ing significantly higher performance. The possible

reason is that generating patches imposes stricter

formatting requirements, which current LLMs find

challenging to adhere to accurately. Therefore, the

main results presented in Table 2 adopt the perfor-

mance byNaturalgeneration method.

Whether using patches converted by converting

before-and-after code snippets inNaturalmode or

directly generating patches inPatchmode, during

evaluation, these patches must be applied to the

repository. The success rates of thegit applyare

shown in the middle two columns of Table 4\. It

can be observed that the success rate in theNatural

prompt mode is significantly higher, contributing

to the superior performance of LLMs inNatural

mode. Further observation reveals a significant

positive correlation between the success rate of ap-

plying patches and the resolved ratio, regardless of

whetherNaturalorPatchmode is used. DeepSeek-

\`\`\`  
Agentless Agentless-Lite Oracle BM25 (27K)  
%Reso. %Apply %Reso. %Apply %Reso. %Apply %Reso. %Apply  
\`\`\`  
\`\`\`  
DeepSeek-V3 \- \- 11.0 71.0 14.5 70.5 13.0 69\.  
GPT-4 \- \- 3.5 94.5 6.0 54.0 2.0 37\.  
GPT-4o 9.0 87.5 9.5 96.0 5.0 60.0 4.0 53\.  
o1-mini 4.5 69.5 4.5 81.5 2.0 32.5 1.0 23\.  
o1 14.0 90.5 10.0 89.5 10.0 49.5 5.0 33\.  
\`\`\`  
\`\`\`  
Table 5: The performance of Agentless on FEA-Bench lite, compared to the direct retrieval byOracleandBM25.  
"%Reso." refers to the resolved ratio of task instances, while "%Apply" indicates the success rate of applying the  
generated code edits to the repository.  
\`\`\`  
Figure 4: The resolved ratios grouped by the categories of the repositories.

R1, which performs the best on FEA-Bench, has

the highest values for both metrics. This indicates

that the format of code edits is a critical factor lim-

iting the performance of LLMs on such tasks.

6.3 Evaluation of Agent Frameworks

To further evaluate the performance of current state-

of-the-art methods on FEA-Bench, we conduct ex-

periments on the lite subset using the cost-efficient

Agentless and Agentless-lite frameworks (Xia et al.,

2024). We compare the final performance of us-

ing these agents with that of directly construct-

ing the context usingOracleandBM25retrieval

methods, as shown in Table 5\. Notably,Agent-

lessimproves the resolved ratio of task instances

overBM25for most models, with the largest gains

observed for GPT-4o, o1-mini, and o1. This im-

provement strongly correlates with the increased

success rate of applying code edits, highlighting the

challenge of adhering to the required code editing

format, as discussed in Section 6.2. Overall, Agent-

less and Agentless-lite perform similarly, with no

significant advantage over the results under the

Oraclesetting. This indicates that current meth-

ods still have substantial room for improvement in

repository-level new feature implementation.

6.4 Performances across Repositories

To further analyze LLMs’ performance at a finer

granularity, we examine resolved ratios across dif-

ferent categories of repositories. We classify reposi-

tories into several categories, as shown in Appendix

A.1. The performance of DeepSeek-R1, o1, and

GPT-4o across different categories is illustrated in

Figure 4\. The resolved ratios of different models

vary across categories; task instances in theTest-

ingcategory (from the repo: joke2k/faker) have

the highest resolved ratio, followed by theInternet

category. For the remaining categories, the pass

ratio of the three models are at a similar level.

Among the three LLMs, GPT-4o shows slightly

weaker performance compared to the other models,

but its trend is largely consistent with o1. Notably,

DeepSeek-R1 exhibits weaker performance in the

Testingcategory but significantly outperforms both

GPT-4o and o1 in all other categories. This sug-

gests that integrating different models might further

enhance overall performance on FEA-Bench.

6.5 Performances under Different Complexity

of New Components

To further investigate whether the implementation

of new components adds pressure on LLMs in com-

pleting feature implementation tasks, we examine

the relationship between the number of new func-

tions and the number of resolved instances. The

number of added functions is more indicative of

the complexity of new components, as functions

are more atomic compared to classes. Figure 5 il-

lustrates the distribution of task instances and those

solved by R1 with respect to the number of added

functions. Excluding instances where the number

\`\`\`  
Figure 5: Histogram of the number of added functions  
both in all task instances and resolved task instances  
by DeepSeek-R1 (underNaturalandDetailedprompt  
settings).  
\`\`\`  
of added functions is zero (i.e., adding only classes

for storing variables), it is evident that the resolved

ratio decreases as the number of added functions

increases. The resolved ratio is 18.96% when the

number of added functions is 1, 8.24% when it is

2, and 5.47% when it is greater than or equal to

3\. This indicates that implementing new features

is a more challenging task than fixing bugs, which

constitute the majority of instances in SWE-bench.

Moreover, the more complex the new components,

the higher the difficulty of successful implementa-

tion.

7 Conclusion

In this paper, we introduce FEA-Bench, a novel

benchmark for evaluating the repository-level in-

cremental code development capabilities of large

language models (LLMs). Our benchmark focuses

on the critical task of implementing new features

by adding new components to existing code repos-

itories. Through our comprehensive dataset and

rigorous evaluation, we demonstrate that current

LLMs face significant challenges in this domain.

We also analyzed that the retrieval method of files,

the output format, the repository itself, and the

complexity of new components all impact the im-

plementation of new features. Our work highlights

the need for further advancements in LLMs’ rea-

soning and generation capabilities to better address

real-world software engineering tasks. We hope

that FEA-Bench will serve as a valuable resource

for the research community, driving progress in

this important area.

Limitations

Our constructed data and experiments have cer-

tain limitations. First, our benchmark includes

only Python repositories, as Python projects are

easier to execute and generally follow consistent

testing frameworks. Second, the quantity of high-

quality data suitable for repository-level incremen-

tal development is limited. High-quality and us-

able pull requests for new feature development are

relatively scarce. Many repository-level code de-

velopments for implementing new functionalities

were committed during the early stages of repos-

itories, without going through the rigorous code

review process typical of the open-source commu-

nity, resulting in lower data quality that cannot be

utilized. Furthermore, the software’s early-stage

developments might not even have been conducted

using the GitHub platform, posing a challenge for

data collection and utilization. Consequently, FEA-

Bench, which is built on publicly available data and

subjected to stringent filtering, may exhibit certain

scenario limitations.

Due to the long context involved in repository-

level code development, the cost of conducting

experiments using LLMs is relatively high. There-

fore, the experimental results are based on a sin-

gle round generation, akin to Pass@1, which may

introduce a certain level of bias into the results.

Additionally, given the scarcity of API resources

for models like DeepSeek-V3 and R1, some results

in the main experiments presented in Table 2 are

missing. We hope that more affordable models

similar to DeepSeek can be further developed to

facilitate research and applications in the field of

repository-level code development.

Ethics Statement

We collected the data from publicly available

Github repositories only for research purposes. All

the repositories have licenses that allow free soft-

ware use. LLMs are used only for classification

during the construction of the FEA-Bench dataset,

so no harmful information can be created in the

dataset. The dataset and code for our proposed

method will be made publicly available for aca-

demic research. However, we should note that

the inference results of the task instances from the

benchmark may contain code that is harmful to

computer systems. Evaluation by docker is recom-

mended, just like SWE-bench.

Additionally, the ChatGPT platform was used as

an AI assistant for refining the paper writing.

Acknowledgments

This work was supported by National Science and

Technology Major Project (No. 2022ZD0116308)

and National Natural Science Foundation of China

(62036001). The corresponding author is Xin

Zhang and Houfeng Wang.

References

\`\`\`  
Josh Achiam, Steven Adler, Sandhini Agarwal, Lama  
Ahmad, Ilge Akkaya, Florencia Leoni Aleman,  
Diogo Almeida, Janko Altenschmidt, Sam Altman,  
Shyamal Anadkat, et al. 2023\. Gpt-4 technical report.  
ArXiv preprint, abs/2303.08774.  
\`\`\`  
\`\`\`  
Jacob Austin, Augustus Odena, Maxwell Nye, Maarten  
Bosma, Henryk Michalewski, David Dohan, Ellen  
Jiang, Carrie Cai, Michael Terry, Quoc Le, et al.  
\`\`\`  
2021\. Program synthesis with large language models.  
ArXiv preprint, abs/2108.07732.

\`\`\`  
Ramakrishna Bairi, Atharv Sonwane, Aditya Kanade,  
Arun Iyer, Suresh Parthasarathy, Sriram Rajamani,  
B Ashok, and Shashank Shet. 2024\. Codeplan:  
Repository-level coding using llms and planning.  
Proceedings of the ACM on Software Engineering,  
1(FSE):675–698.  
\`\`\`  
\`\`\`  
Mark Chen, Jerry Tworek, Heewoo Jun, Qiming Yuan,  
Henrique Ponde De Oliveira Pinto, Jared Kaplan,  
Harri Edwards, Yuri Burda, Nicholas Joseph, Greg  
Brockman, et al. 2021\. Evaluating large lan-  
guage models trained on code. ArXiv preprint,  
abs/2107.03374.  
\`\`\`  
\`\`\`  
Arghavan Moradi Dakhel, Vahid Majdinasab, Amin  
Nikanjam, Foutse Khomh, Michel C Desmarais, and  
Zhen Ming Jack Jiang. 2023\. Github copilot ai pair  
programmer: Asset or liability?Journal of Systems  
and Software, 203:111734.  
\`\`\`  
\`\`\`  
Xueying Du, Mingwei Liu, Kaixin Wang, Hanlin Wang,  
Junwei Liu, Yixuan Chen, Jiayi Feng, Chaofeng  
Sha, Xin Peng, and Yiling Lou. 2023\. Classe-  
val: A manually-crafted benchmark for evaluating  
llms on class-level code generation.ArXiv preprint,  
abs/2308.01861.  
\`\`\`  
\`\`\`  
Daya Guo, Dejian Yang, Haowei Zhang, Junxiao Song,  
Ruoyu Zhang, Runxin Xu, Qihao Zhu, Shirong Ma,  
Peiyi Wang, Xiao Bi, et al. 2025\. Deepseek-r1: In-  
centivizing reasoning capability in llms via reinforce-  
ment learning.ArXiv preprint, abs/2501.12948.  
\`\`\`  
\`\`\`  
Daya Guo, Qihao Zhu, Dejian Yang, Zhenda Xie,  
Kai Dong, Wentao Zhang, Guanting Chen, Xiao  
Bi, Yu Wu, YK Li, et al. 2024\. Deepseek-coder:  
When the large language model meets programming–  
the rise of code intelligence. ArXiv preprint,  
abs/2401.14196.  
\`\`\`  
\`\`\`  
Dan Hendrycks, Steven Basart, Saurav Kadavath, Man-  
tas Mazeika, Akul Arora, Ethan Guo, Collin Burns,  
Samir Puranik, Horace He, Dawn Song, et al. 2021\.  
Measuring coding challenge competence with apps.  
ArXiv preprint, abs/2105.09938.  
\`\`\`  
\`\`\`  
Binyuan Hui, Jian Yang, Zeyu Cui, Jiaxi Yang, Day-  
iheng Liu, Lei Zhang, Tianyu Liu, Jiajun Zhang,  
Bowen Yu, Keming Lu, et al. 2024\. Qwen2. 5-coder  
technical report.ArXiv preprint, abs/2409.12186.  
\`\`\`  
\`\`\`  
Aaron Hurst, Adam Lerer, Adam P Goucher, Adam  
Perelman, Aditya Ramesh, Aidan Clark, AJ Os-  
trow, Akila Welihinda, Alan Hayes, Alec Radford,  
et al. 2024\. Gpt-4o system card. ArXiv preprint,  
abs/2410.21276.  
\`\`\`  
\`\`\`  
Aaron Jaech, Adam Kalai, Adam Lerer, Adam Richard-  
son, Ahmed El-Kishky, Aiden Low, Alec Helyar,  
Aleksander Madry, Alex Beutel, Alex Carney, et al.  
\`\`\`  
2024\. Openai o1 system card. ArXiv preprint,  
abs/2412.16720.

\`\`\`  
Naman Jain, King Han, Alex Gu, Wen-Ding Li, Fanjia  
Yan, Tianjun Zhang, Sida Wang, Armando Solar-  
Lezama, Koushik Sen, and Ion Stoica. 2024\. Live-  
codebench: Holistic and contamination free eval-  
uation of large language models for code. ArXiv  
preprint, abs/2403.07974.  
\`\`\`  
\`\`\`  
Carlos E Jimenez, John Yang, Alexander Wettig,  
Shunyu Yao, Kexin Pei, Ofir Press, and Karthik R  
Narasimhan. 2024\. SWE-bench: Can language mod-  
els resolve real-world github issues? InThe Twelfth  
International Conference on Learning Representa-  
tions.  
\`\`\`  
\`\`\`  
Harshit Joshi, José Pablo Cambronero Sánchez, Sumit  
Gulwani, Vu Le, Gust Verbruggen, and Ivan Radicek.  
\`\`\`  
2023\. Repair is nearly generation: Multilingual pro-  
gram repair with llms. InThirty-Seventh AAAI Con-  
ference on Artificial Intelligence, AAAI 2023, Thirty-  
Fifth Conference on Innovative Applications of Artifi-  
cial Intelligence, IAAI 2023, Thirteenth Symposium  
on Educational Advances in Artificial Intelligence,  
EAAI 2023, Washington, DC, USA, February 7-14,  
2023 , pages 5131–5140. AAAI Press.

\`\`\`  
Jia Li, Ge Li, Zhuo Li, Zhi Jin, Xing Hu, Kechi Zhang,  
and Zhiyi Fu. 2023a. Codeeditor: Learning to edit  
source code with pre-trained models.ACM Trans-  
actions on Software Engineering and Methodology,  
32(6):1–22.  
\`\`\`  
\`\`\`  
Jia Li, Ge Li, Xuanming Zhang, Yihong Dong, and  
Zhi Jin. 2024a. Evocodebench: An evolving code  
generation benchmark aligned with real-world code  
repositories.ArXiv preprint, abs/2404.00599.  
\`\`\`  
\`\`\`  
Jia Li, Ge Li, Yunfei Zhao, Yongmin Li, Huanyu  
Liu, Hao Zhu, Lecheng Wang, Kaibo Liu, Zheng  
Fang, Lanshen Wang, et al. 2024b. Deveval:  
A manually-annotated code generation benchmark  
aligned with real-world code repositories. ArXiv  
preprint, abs/2405.19856.  
\`\`\`

Raymond Li, Loubna Ben Allal, Yangtian Zi, Niklas

\`\`\`  
Muennighoff, Denis Kocetkov, Chenghao Mou, Marc  
Marone, Christopher Akiki, Jia Li, Jenny Chim, et al.  
2023b. Starcoder: may the source be with you\!  
ArXiv preprint, abs/2305.06161.  
\`\`\`  
Aixin Liu, Bei Feng, Bing Xue, Bingxuan Wang,

\`\`\`  
Bochao Wu, Chengda Lu, Chenggang Zhao, Chengqi  
Deng, Chenyu Zhang, Chong Ruan, et al. 2024a.  
Deepseek-v3 technical report. ArXiv preprint,  
abs/2412.19437.  
\`\`\`  
Jiawei Liu, Chunqiu Steven Xia, Yuyao Wang, and Ling-

\`\`\`  
ming Zhang. 2023a. Is your code generated by chat-  
gpt really correct? rigorous evaluation of large lan-  
guage models for code generation. InAdvances in  
Neural Information Processing Systems 36: Annual  
Conference on Neural Information Processing Sys-  
tems 2023, NeurIPS 2023, New Orleans, LA, USA,  
December 10 \- 16, 2023\.  
\`\`\`  
Siyao Liu, He Zhu, Jerry Liu, Shulin Xin, Aoyan Li, Rui

\`\`\`  
Long, Li Chen, Jack Yang, Jinxiang Xia, ZY Peng,  
et al. 2024b. Fullstack bench: Evaluating llms as full  
stack coder.ArXiv preprint, abs/2412.00535.  
\`\`\`  
Tianyang Liu, Canwen Xu, and Julian McAuley.

\`\`\`  
2023b. Repobench: Benchmarking repository-level  
code auto-completion systems. ArXiv preprint,  
abs/2306.03091.  
\`\`\`  
Junyu Luo, Weizhi Zhang, Ye Yuan, Yusheng Zhao, Jun-

\`\`\`  
wei Yang, Yiyang Gu, Bohan Wu, Binqi Chen, Ziyue  
Qiao, Qingqing Long, et al. 2025\. Large language  
model agent: A survey on methodology, applications  
and challenges.arXiv preprint arXiv:2503.21460.  
\`\`\`  
Ziyang Luo, Can Xu, Pu Zhao, Qingfeng Sun, Xi-

\`\`\`  
ubo Geng, Wenxiang Hu, Chongyang Tao, Jing Ma,  
Qingwei Lin, and Daxin Jiang. 2023\. Wizardcoder:  
Empowering code large language models with evol-  
instruct.ArXiv preprint, abs/2306.08568.  
\`\`\`  
Zhenyu Pan, Rongyu Cao, Yongchang Cao, Yingwei

\`\`\`  
Ma, Binhua Li, Fei Huang, Han Liu, and Yongbin  
Li. 2024\. Codev-bench: How do llms understand  
developer-centric code completion?ArXiv preprint,  
abs/2410.01353.  
\`\`\`  
Stephen Robertson, Hugo Zaragoza, et al. 2009\. The

\`\`\`  
probabilistic relevance framework: Bm25 and be-  
yond.Foundations and Trends®in Information Re-  
trieval, 3(4):333–389.  
\`\`\`  
Baptiste Roziere, Jonas Gehring, Fabian Gloeckle, Sten

\`\`\`  
Sootla, Itai Gat, Xiaoqing Ellen Tan, Yossi Adi,  
Jingyu Liu, Tal Remez, Jérémy Rapin, et al. 2023\.  
Code llama: Open foundation models for code.  
ArXiv preprint, abs/2308.12950.  
\`\`\`  
Yuling Shi, Songsong Wang, Chengcheng Wan, and

\`\`\`  
Xiaodong Gu. 2024\. From code to correctness: Clos-  
ing the last mile of code generation with hierarchical  
debugging.ArXiv preprint, abs/2410.01215.  
\`\`\`  
\`\`\`  
Yanlin Wang, Yanli Wang, Daya Guo, Jiachi Chen,  
Ruikai Zhang, Yuchi Ma, and Zibin Zheng. 2024\.  
Rlcoder: Reinforcement learning for repository-level  
code completion.ArXiv preprint, abs/2407.19487.  
\`\`\`  
\`\`\`  
Yaoxiang Wang, Haoling Li, Xin Zhang, Jie Wu, Xiao  
Liu, Wenxiang Hu, Zhongxin Guo, Yangyu Huang,  
Ying Xin, Yujiu Yang, et al. 2025\. Epicoder: Encom-  
passing diversity and complexity in code generation.  
arXiv preprint arXiv:2501.04694.  
\`\`\`  
\`\`\`  
Yuxiang Wei, Zhe Wang, Jiawei Liu, Yifeng Ding, and  
Lingming Zhang. 2024\. Magicoder: Empowering  
code generation with oss-instruct. InForty-first Inter-  
national Conference on Machine Learning.  
\`\`\`  
\`\`\`  
Chunqiu Steven Xia, Yinlin Deng, Soren Dunn, and  
Lingming Zhang. 2024\. Agentless: Demystify-  
ing llm-based software engineering agents. ArXiv  
preprint, abs/2407.01489.  
\`\`\`  
\`\`\`  
Frank F. Xu, Uri Alon, Graham Neubig, and Vincent Jo-  
sua Hellendoorn. 2022\. A systematic evaluation of  
large language models of code. InProceedings of the  
6th ACM SIGPLAN International Symposium on Ma-  
chine Programming, MAPS 2022, page 1–10, New  
York, NY, USA. Association for Computing Machin-  
ery.  
\`\`\`  
\`\`\`  
Jian Yang, Jiajun Zhang, Jiaxi Yang, Ke Jin, Lei Zhang,  
Qiyao Peng, Ken Deng, Yibo Miao, Tianyu Liu, Zeyu  
Cui, et al. 2024a. Execrepobench: Multi-level exe-  
cutable code completion evaluation.ArXiv preprint,  
abs/2412.11990.  
\`\`\`  
\`\`\`  
John Yang, Carlos E Jimenez, Alexander Wettig, Kil-  
ian Lieret, Shunyu Yao, Karthik Narasimhan, and  
Ofir Press. 2024b. Swe-agent: Agent-computer inter-  
faces enable automated software engineering.ArXiv  
preprint, abs/2405.15793.  
\`\`\`  
\`\`\`  
Hao Yu, Bo Shen, Dezhi Ran, Jiaxin Zhang, Qi Zhang,  
Yuchi Ma, Guangtai Liang, Ying Li, Qianxiang  
Wang, and Tao Xie. 2024a. Codereval: A bench-  
mark of pragmatic code generation with generative  
pre-trained models. InProceedings of the 46th  
IEEE/ACM International Conference on Software  
Engineering, pages 1–12.  
\`\`\`  
\`\`\`  
Zhaojian Yu, Xin Zhang, Ning Shang, Yangyu Huang,  
Can Xu, Yishujie Zhao, Wenxiang Hu, and Qiufeng  
Yin. 2024b. WaveCoder: Widespread and versatile  
enhancement for code large language models by in-  
struction tuning. InProceedings of the 62nd Annual  
Meeting of the Association for Computational Lin-  
guistics (Volume 1: Long Papers), pages 5140–5153,  
Bangkok, Thailand. Association for Computational  
Linguistics.  
\`\`\`  
\`\`\`  
Fengji Zhang, Bei Chen, Yue Zhang, Jacky Keung, Jin  
Liu, Daoguang Zan, Yi Mao, Jian-Guang Lou, and  
Weizhu Chen. 2023\. RepoCoder: Repository-level  
code completion through iterative retrieval and gen-  
eration. InProceedings of the 2023 Conference on  
Empirical Methods in Natural Language Processing,  
pages 2471–2484, Singapore. Association for Com-  
putational Linguistics.  
\`\`\`

\`\`\`  
Yuntong Zhang, Haifeng Ruan, Zhiyu Fan, and Ab-  
hik Roychoudhury. 2024\. Autocoderover: Au-  
tonomous program improvement. InProceedings  
of the 33rd ACM SIGSOFT International Symposium  
on Software Testing and Analysis, ISSTA 2024, page  
1592–1604, New York, NY, USA. Association for  
Computing Machinery.  
\`\`\`  
\`\`\`  
Dewu Zheng, Yanlin Wang, Ensheng Shi, Ruikai Zhang,  
Yuchi Ma, Hongyu Zhang, and Zibin Zheng. 2024\.  
Towards more realistic evaluation of llm-based code  
generation: an experimental study and beyond.ArXiv  
preprint, abs/2406.06918.  
\`\`\`  
\`\`\`  
Qihao Zhu, Daya Guo, Zhihong Shao, Dejian Yang,  
Peiyi Wang, Runxin Xu, Y Wu, Yukun Li, Huazuo  
Gao, Shirong Ma, et al. 2024\. Deepseek-coder-v2:  
Breaking the barrier of closed-source models in code  
intelligence.ArXiv preprint, abs/2406.11931.  
\`\`\`  
\`\`\`  
Terry Yue Zhuo, Minh Chien Vu, Jenny Chim, Han Hu,  
Wenhao Yu, Ratnadira Widyasari, Imam Nur Bani  
Yusuf, Haolan Zhan, Junda He, Indraneil Paul, et al.  
\`\`\`  
2024\. Bigcodebench: Benchmarking code genera-  
tion with diverse function calls and complex instruc-  
tions.ArXiv preprint, abs/2406.15877.

A Dataset Details

A.1 Repositories

The task instances in FEA-Bench are derived

from 83 Python packages corresponding to GitHub

repositories. For each package, we obtained its

license information and topic classification from

the PyPI website. For packages missing the topic

attribute, we utilized their README files and em-

ployed GPT-4o to classify them into topics avail-

able on the PyPI website^5. Finally, considering

the distribution of the topics of task instances in

FEA-Bench, we further simplify the topics to sev-

eral categories to facilitate data visualization and

analysis, as presented in Section 6.4.

The relevant information regarding the involved

code repositories is summarized in Table 6\.

A.2 Construction Details

Table 7 shows the number of remaining task in-

stances for each stage during the data collection

process. In Section 3.2, we mentioned that after the

fast validation step, including the 18 repositories

from SWE-bench, a total of 119 repositories (18 \+

101\) are available for further data collection. On

this basis, we crawl the pull requests from GitHub

to obtain code changes. Files with names contain-

ing words liketestare identified as unit test files

executable bypytest.

\`\`\`  
5  
https://pypi.org/classifiers/  
\`\`\`  
Initially, we filter pull requests (PRs) based on

whether they were merged, resulting in the number

of PRs shown in the "\# PR" column of Table 7\.

Next, we excluded PRs without any test files, leav-

ing only those PRs with the necessary conditions

to be considered valid task instances, as indicated

by the "\# All tasks" column. Further filtering was

conducted according to the third and fourth stages

illustrated in Figure 3, retaining only those PRs that

introduce at least one new component and are clas-

sified as "new feature" types by GPT-4o based on

the PR content. Additionally, instances with patch

lengths exceeding 8K (8192) tokens are excluded

to remove long-tail distributions and noise. The

remaining candidate task instances are listed under

the "\# Candidates" column. This filtering step does

not exist in SWE-bench, leading to a smaller num-

ber of candidate task instances in our benchmark

dataset.

Finally, for each instance, we apply the test

patch to the repository in the base commit state

to verify that unit tests could accurately evaluate

the corresponding code edits. Similar to SWE-

bench, our pipeline annotates each instance with

the corresponding repository version and provides

environment and installation configurations based

on versions. For repositories included in SWE-

bench, we directly utilize their environment setup

and test configurations grouped by versions. For

other repositories, minimal installation instructions

(pip install \-e .) and basicpytesttesting

configurations are used. Initially, we run the unit

tests directly and observe the pass status. Subse-

quently, we apply the gold patch from the PR and

execute the unit tests again. We allowed errors such

asAttributeErrorandImportErrorin the first

test, which are common when new components are

not yet implemented, but these errors are not per-

mitted in SWE-bench data collection pipeline. For

the second test after applying the gold patch, any

FAILED status is unacceptable to ensure data qual-

ity. After this execution-based filtering process, the

final task instances constitute the FEA-Bench task

instances, as shown in the "\# in Full" column of

Table 7\.

We only present information for repositories that

have at least one instance in FEA-Bench. Specifi-

cally, out of the 119 repositories identified during

the repository collection phase, only 83 repositories

contain at least one task instance.

\`\`\`  
You will be provided with a partial code base and an feature request which requires a  
new feature to add in the code repository.  
\`\`\`  
Premise

\`\`\`  
Request  
Content  
\`\`\`  
\`\`\`  
\<request\>  
Pull Request Title \+ Pull Request Body  
Comments before first commit  
\</request\>  
\`\`\`  
\`\`\`  
Issue  
Content  
(If any)  
\`\`\`  
\`\`\`  
Here is the discussion in the issues of the pull request.  
\<issues\>  
Issue Title \+ Issue Body  
Comments before first commit  
\</issues\>  
\`\`\`  
\`\`\`  
Doc  
Changes  
(If any)  
\`\`\`  
\`\`\`  
To implement the new features mentioned above, some design in this repository need  
to be modified, as the modification in document files:  
\<description changes\>  
Gold patches that are not from .py files  
\</description changes\>  
\`\`\`  
\`\`\`  
New  
Components  
\`\`\`  
\`\`\`  
There are several new functions or classes that need to be implemented, using the definitions below:  
\<definitions\>  
\[start of new definitions in file 1 \]  
(definition of namespace of new component 1 :)  
signature of new component 1 in file 1  
(definition of namespace of new component 2 :)  
signature of new component 2 in file 1  
...  
\[end of new definitions in file 1 \]  
\[start of new definitions in file 2 \]  
...  
\</definitions\>  
\`\`\`  
\+ \_docstring of new component 1 in file 1\_

\+ \_docstring of new component 2 in file 1\_

Code Files

\`\`\`  
All the involved readme files and code files are listed below  
with their contents. If a file's content is indicated as empty, it  
means that the file does not yet exist in the current repository  
and needs to be created with new content.  
\<code\>  
\[start of file 1 \]  
All content in file 1; In "Patch" mode, line number is added  
\[end of file 1 \]  
\[start of file 2 \]  
...  
\</code\>  
\`\`\`  
\`\`\`  
README files  
\`\`\`  
\`\`\`  
Files with new  
components  
\`\`\`  
\`\`\`  
Files Retrieved  
("Oracle" or BM25)  
\`\`\`  
\`\`\`  
De-duplication  
\`\`\`  
\`\`\`  
Output  
Instruction  
"Natural" Format Output Instructions / "Patch" Format Instructions  
\`\`\`  
Figure 6: The prompt for the inference of the task instances.

A.3 FEA-Bench lite

The feature implementation task proposed in this

study, as one primary type of repository-level in-

cremental code development tasks, require LLMs

with long context capabilities to perform reasoning

over extensive file contents. Such inference is com-

putationally expensive. Considering the possible

evaluation of multi-round code generation systems,

it is necessary to select a high-quality subset for

more efficient evaluation. Therefore, we establish

stricter criteria to curate a higher-quality, lower-

difficulty FEA-Bench lite subset.

Instances meeting any of the following low-

quality criteria are excluded:

\- The feature request descriptions contain fewer

than 40 words.

\- The instance involves cascading issues or com-

mit SHA-256 references.

\- The descriptions contain images.

Additionally, to limit task difficulty, instances

meeting any of the following criteria are also ex-

cluded:

\- Involve deleting code files.  
\- Involve more than three code files.  
\- The gold patch contains More than 10 code

change hunks.

\- Natural-formatted code change content ex-

ceeding 4K(4096) tokens.

\- Contain new class(es).  
\- Contain more than ten added functions.

Beyond the lite subset, we also expect to col-

laborate with professional software engineers to

annotate a verified subset, similar to SWE-bench

Verified  
6  
.

B Inference

B.1 Prompt

In Section 4.2, we present different prompt set-

tings for the context of inference. A more detailed

prompt structure is illustrated in Figure 6\. The

prompt is constructed using the first two items

shown in Figure 2 as known input information. The

feature request includes both pull request content

and issue content. Information about new com-

ponents and related code files is listed straightfor-

wardly within the prompt.

In Figure 6, the italicized text indicates place-

holders that need to be filled with specific data

of each task instance, while the other text repre-

sents standard prompt content. Red text highlights

additional information for detailed hints of new

components, and blue text indicates parts that need

to be modified when directly generating patches as

results.

In this study, we provide two formats for generat-

ing code edits:NaturalandPatch. The correspond-

ing output instructions are illustrated in Figure 7\.

To ensure that the models produce outputs in the

correct format, both modes are accompanied by

detailed instructions and examples.

We include several different prompts mentioned

above for each task instance in the dataset files.

B.2 Generation Configurations

For models with fewer than 32 billion parameters,

we utilized the vLLM framework  
7  
on an 8-GPU

NVIDIA A100 workstation, employing tensor par-

allelism for inference. The maximum number of

generated tokens is limited to 4096, matching the

generation length limits of used OpenAI GPT-

and GPT-4o in our experiments.

\#\#\# 6

\`\`\`  
https://openai.com/index/introducing-swe-bench-  
verified/  
7  
https://github.com/vllm-project/vllm  
\`\`\`  
For larger open-source and all closed-source

models, specifically DeepSeek-V3, R1, and Ope-

nAI series models, we invoke their APIs for infer-

ence. The versions of the OpenAI models used are

as follows:

\- GPT-4:gpt-4-turbo-2024-04-  
\- GPT-4o:gpt-4o-2024-05-  
\- o1:o1-2024-12-  
\- o1-mini:o1-mini-2024-09-

When possible, the temperature and top-p set-

tings are fixed at 0.2 and 0.95, respectively. For

DeepSeek-V3 and R1, the max output tokens are

8K (8192). For o1 and o1-mini, the max output

tokens is 100,000 and 65,536 (64K), respectively.

During the inference process, LLMs perform a

single generation for each task instance in FEA-

Bench, and the output is converted into a patch

for evaluation. The evaluation tools are adapted

from the SWE-bench evaluation scripts which are

based on docker, ensuring safety and easy use for

the evaluation process.

"Natural" Format Output Instructions

Please solve the feature request with adding the functions or classes between  
the \<definitions\> and \</definitions\>. You do not need to output any changes  
or edits for description files like .md or .rst files.  
I need you to make multiple edits across one or more files in a repository to  
implement a specific feature or improvement mentioned above.  
For each edit, output the changes in the following format:

\`\`\`  
\<edit\>  
\[start of the snippet before editing in \<file\_path\>\]  
\<code\_before\_edit\>  
\[end of the snippet before editing in \<file\_path\>\]

\[start of the snippet after editing in \<file\_path\>\]  
\<code\_after\_edit\>  
\[end of the snippet after editing in \<file\_path\>\]  
\</edit\>  
\`\`\`

Notes:

\- The \<file\_path\> is the relative path of the file being edited.  
\- The \<code\_before\_edit\> snippet should include several lines before and  
after the modified region, unless the file was originally empty.  
\- If a file was originally empty, leave \<code\_before\_edit\> blank but ensure  
\<code\_after\_edit\> includes the new content.  
\- Ensure the edits are sequential and address all necessary changes to achieve  
the requested feature.

Here is an example of the output format:  
\<edit\>  
\[start of the snippet before editing in src/code.py\]  
def factorial(a):  
res \= 1  
while a \>= 0:  
res \*= a  
return res  
\[end of the snippet before editing in src/code.py\]

\[start of the snippet after editing in src/code.py\]  
def factorial(a):  
assert type(a) \== int and a \>= 0  
res \= 1  
while a \>= 2:  
res \*= a  
a \-= 1  
return res  
\[end of the snippet after editing in src/code.py\]  
\</edit\>

\<edit\>  
\[start of the snippet before editing in src/code.py\]  
def exact\_dividion(x, y):  
return x % y \== 0  
\[end of the snippet before editing in src/code.py\]

\[start of the snippet after editing in src/code.py\]  
def exact\_dividion(x, y):  
assert type(x) \== type(y) \== int and x \> 0 and y \> 0  
return x % y \== 0  
\[end of the snippet after editing in src/code.py\]  
\</edit\>

\<edit\>  
\[start of the snippet before editing in src/demo.py\]  
\[end of the snippet before editing in src/demo.py\]

\[start of the snippet after editing in src/demo.py\]  
from code import factorial  
print(factorial(5))  
\[end of the snippet after editing in src/demo.py\]  
\</edit\>  
I need you to solve the feature request with a series of edits in the format  
shown above. Respond below:

\`\`\`  
"Patch" Format Instructions  
Please solve the feature request with adding the functions or classes between  
the \<definitions\> and \</definitions\>. You do not need to output any changes  
or edits for description files like .md or .rst files.  
I need you to make multiple edits across one or more files in a repository to  
implement a specific feature or improvement mentioned above.  
The edits should be output in patch format.  
\`\`\`  
\`\`\`  
Here is an example of a patch file. It consists of changes to the code base.  
It specifies the file names, the line numbers of each change, and the removed  
and added lines.  
A single patch file can contain changes to multiple files.  
\`\`\`  
\`\`\`  
\<patch\>  
diff \--git a/src/code.py b/src/code.py  
\--- a/src/code.py  
\+++ b/src/code.py  
@@ \-1,11 \+1,14 @@  
def factorial(a):  
\+ assert type(a) \== int and a \>= 0  
res \= 1  
\`\`\`  
\- while a \>= 0:  
\+ while a \>= 2:  
res \*= a  
\+ a \-= 1  
return res  
\#  
\#  
\#  
\#  
def exact\_dividion(x, y):  
\+ assert type(x) \== type(y) \== int and x \> 0 and y \> 0  
return x % y \== 0  
diff \--git a/src/demo.py b/src/demo.py  
new file mode 100644  
\--- /dev/null  
\+++ b/src/demo.py  
@@ \-0,0 \+1,2 @@  
\+from code import factorial  
\+print(factorial(5))  
\</patch\>

\`\`\`  
I need you to solve the provided feature request by generating a single patch  
file that I can apply directly to this repository using git apply. Please respond  
with a single patch file in the format shown above.  
Respond below:  
\`\`\`  
Figure 7: The output instructions at the rear of the inference prompt.

Repo Name License Topic Category Source  
astropy/astropy BSD-3-Clause Scientific/Engineering::Astronomy Physics SWE-Bench  
django/django BSD-3-Clause Internet::WWW/HTTP Internet SWE-Bench  
matplotlib/matplotlib Other Scientific/Engineering::Visualization Other SWE-Bench  
mwaskom/seaborn BSD-3-Clause Scientific/Engineering::Visualization Other SWE-Bench  
pallets/flask BSD-3-Clause Internet::WWW/HTTP Internet SWE-Bench  
pvlib/pvlib-python BSD-3-Clause Scientific/Engineering::Physics Physics SWE-Bench  
pydata/xarray Apache-2.0 Scientific/Engineering::Information Analysis Other SWE-Bench  
pydicom/pydicom Others Scientific/Engineering::Medical Science Apps. Medical SWE-Bench  
pylint-dev/astroid LGPL-2.1 Software Development::Libraries Libraries SWE-Bench  
pylint-dev/pylint GPL-2.0 Software Development::Quality Assurance Other SWE-Bench  
pyvista/pyvista MIT Scientific/Engineering::Information Analysis Other SWE-Bench  
scikit-learn/scikit-learn BSD-3-Clause Scientific/Engineering::Artificial Intelligence AI SWE-Bench  
sphinx-doc/sphinx BSD-2-Clause Text Processing::Markup Other SWE-Bench  
sqlfluff/sqlfluff MIT Software Development::Quality Assurance Other SWE-Bench  
sympy/sympy Others Scientific/Engineering::Mathematics Mathematics SWE-Bench  
Aider-AI/aider Apache-2.0 Software Development::Code Generators Other Fast-Validation  
Cog-Creators/Red-DiscordBot GPL-3.0 Communications::Chat Other Fast-Validation  
DLR-RM/stable-baselines3 MIT Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
EleutherAI/lm-evaluation-harness MIT Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
Project-MONAI/MONAI Apache-2.0 Scientific/Engineering::Medical Science Apps. Medical Fast-Validation  
PyThaiNLP/pythainlp Apache-2.0 Text Processing::Linguistic Other Fast-Validation  
RDFLib/rdflib BSD-3-Clause Software Development::Libraries Libraries Fast-Validation  
Textualize/rich MIT Software Development::Libraries Libraries Fast-Validation  
Textualize/textual MIT Software Development::User Interfaces Other Fast-Validation  
TileDB-Inc/TileDB-Py MIT Software Development::Libraries Libraries Fast-Validation  
astronomer/astronomer-cosmos Apache-2.0 Software Development::Build Tools Build Tools Fast-Validation  
atlassian-api/atlassian-python-api Apache-2.0 Internet::WWW/HTTP Internet Fast-Validation  
aws-cloudformation/cfn-lint MIT-0 Software Development::Quality Assurance Other Fast-Validation  
aws-powertools/powertools-lambda-python MIT-0 Software Development::Libraries Libraries Fast-Validation  
aws/sagemaker-python-sdk Apache-2.0 Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
biopragmatics/bioregistry MIT Scientific/Engineering::Bio-Informatics Other Fast-Validation  
boto/boto3 Apache-2.0 Software Development::Libraries Libraries Fast-Validation  
boto/botocore Apache-2.0 Software Development::Libraries Libraries Fast-Validation  
cocotb/cocotb BSD-3-Clause Scientific/Engineering::Electronic Design Automation (EDA) Other Fast-Validation  
conan-io/conan MIT Software Development::Build Tools Build Tools Fast-Validation  
deepset-ai/haystack Apache-2.0 Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
docker/docker-py Apache-2.0 Software Development::Libraries Libraries Fast-Validation  
dpkp/kafka-python Apache-2.0 Software Development::Libraries Libraries Fast-Validation  
embeddings-benchmark/mteb Apache-2.0 Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
facebookresearch/hydra MIT Software Development::Libraries Libraries Fast-Validation  
fairlearn/fairlearn MIT Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
falconry/falcon Apache-2.0 Internet::WWW/HTTP Internet Fast-Validation  
google-deepmind/optax Apache-2.0 Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
googleapis/python-aiplatform Apache-2.0 Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
googleapis/python-bigquery Apache-2.0 Internet::WWW/HTTP Internet Fast-Validation  
gradio-app/gradio Apache-2.0 Scientific/Engineering::Human Machine Interfaces Other Fast-Validation  
graphql-python/graphene MIT Software Development::Libraries Libraries Fast-Validation  
huggingface/accelerate Apache-2.0 Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
huggingface/datasets Apache-2.0 Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
huggingface/huggingface\_hub Apache-2.0 Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
huggingface/pytorch-image-models Apache-2.0 Software Development::Libraries Libraries Fast-Validation  
huggingface/trl Apache-2.0 Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
joblib/joblib BSD-3-Clause Software Development::Libraries Libraries Fast-Validation  
joke2k/faker MIT Software Development::Testing Testing Fast-Validation  
lark-parser/lark MIT Text Processing::Linguistic Other Fast-Validation  
minio/minio-py Apache-2.0 Software Development::Libraries Libraries Fast-Validation  
open-mmlab/mmengine Apache-2.0 Utilities Other Fast-Validation  
openvinotoolkit/datumaro MIT Scientific/Engineering::Image Processing Other Fast-Validation  
pgmpy/pgmpy MIT Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
pre-commit/pre-commit MIT Software Development::Quality Assurance Other Fast-Validation  
prometheus/client\_python Apache-2.0 System::Monitoring Other Fast-Validation  
prompt-toolkit/python-prompt-toolkit BSD-3-Clause Software Development::User Interfaces Other Fast-Validation  
pygments/pygments BSD-2-Clause Software Development::Documentation Other Fast-Validation  
pyocd/pyOCD Apache-2.0 Software Development::Debuggers Other Fast-Validation  
pypa/hatch MIT Software Development::Build Tools Build Tools Fast-Validation  
pyro-ppl/pyro Apache-2.0 Scientific/Engineering::Artificial Intelligence AI Fast-Validation  
python-hyper/h2 MIT Internet::WWW/HTTP Internet Fast-Validation  
roboflow/supervision MIT Scientific/Engineering::Image Processing Other Fast-Validation  
rytilahti/python-miio GPL-3.0 Home Automation Other Fast-Validation  
saleweaver/python-amazon-sp-api MIT Internet::WWW/HTTP Internet Fast-Validation  
scrapy/scrapy BSD-3-Clause Software Development::Libraries Libraries Fast-Validation  
scverse/scanpy BSD-3-Clause Scientific/Engineering::Bio-Informatics Other Fast-Validation  
slackapi/bolt-python MIT Communications::Chat Other Fast-Validation  
slackapi/python-slack-sdk MIT Communications::Chat Other Fast-Validation  
snowflakedb/snowflake-connector-python Apache-2.0 Software Development::Libraries Libraries Fast-Validation  
softlayer/softlayer-python MIT Software Development::Libraries Libraries Fast-Validation  
spec-first/connexion Apache-2.0 Internet::WWW/HTTP Internet Fast-Validation  
statsmodels/statsmodels BSD-3-Clause Scientific/Engineering::Information Analysis Other Fast-Validation  
tfranzel/drf-spectacular BSD-3-Clause Software Development::Documentation Other Fast-Validation  
tobymao/sqlglot MIT Database::Database Engines/Servers Database Fast-Validation  
tornadoweb/tornado Apache-2.0 Internet::WWW/HTTP Internet Fast-Validation  
tortoise/tortoise-orm Apache-2.0 Database::Front-Ends Database Fast-Validation  
wagtail/wagtail BSD-3-Clause Internet::WWW/HTTP Internet Fast-Validation

Table 6: The information of the repositories involved in FEABench.

\#\# Repository Name Class (Short) Max PR No. \# PR \# All tasks \# Candidates \# in Full \# in Lite

\- sympy/sympy Mathematics  
\- joke2k/faker Testing  
\- conan-io/conan Build Tools  
\- tobymao/sqlglot Database  
\- scikit-learn/scikit-learn AI  
\- pvlib/pvlib-python Physics  
\- deepset-ai/haystack AI  
\- Project-MONAI/MONAI Medical  
\- matplotlib/matplotlib Other  
\- sphinx-doc/sphinx Other  
\- googleapis/python-aiplatform AI  
\- astropy/astropy Physics  
\- Textualize/textual Other  
\- falconry/falcon Internet  
\- softlayer/softlayer-python Libraries  
\- Textualize/rich Libraries  
\- rytilahti/python-miio Other  
\- sqlfluff/sqlfluff Other  
\- google-deepmind/optax AI  
\- pydata/xarray Other  
\- boto/boto3 Libraries  
\- roboflow/supervision Other  
\- RDFLib/rdflib Libraries  
\- huggingface/datasets AI  
\- aws-cloudformation/cfn-lint Other  
\- boto/botocore Libraries  
\- pgmpy/pgmpy AI  
\- huggingface/huggingface\_hub AI  
\- prometheus/client\_python Other  
\- pypa/hatch Build Tools  
\- scrapy/scrapy Libraries  
\- slackapi/python-slack-sdk Other  
\- django/django Internet  
\- pydicom/pydicom Medical  
\- pylint-dev/pylint Other  
\- embeddings-benchmark/mteb AI  
\- python-hyper/h2 Internet  
\- mwaskom/seaborn Other  
\- pyvista/pyvista Other  
\- dpkp/kafka-python Libraries  
\- lark-parser/lark Other  
\- astronomer/astronomer-cosmos Build Tools  
\- fairlearn/fairlearn AI  
\- huggingface/accelerate AI  
\- docker/docker-py Libraries  
\- huggingface/trl AI  
\- joblib/joblib Libraries  
\- open-mmlab/mmengine Other  
\- openvinotoolkit/datumaro Other  
\- pygments/pygments Other  
\- pyocd/pyOCD Other  
\- pyro-ppl/pyro AI  
\- tortoise/tortoise-orm Database  
\- DLR-RM/stable-baselines3 AI  
\- EleutherAI/lm-evaluation-harness AI  
\- PyThaiNLP/pythainlp Other  
\- TileDB-Inc/TileDB-Py Libraries  
\- atlassian-api/atlassian-python-api Internet  
\- aws/sagemaker-python-sdk AI  
\- googleapis/python-bigquery Internet  
\- gradio-app/gradio Other  
\- graphql-python/graphene Libraries  
\- prompt-toolkit/python-prompt-toolkit Other  
\- snowflakedb/snowflake-connector-python Libraries  
\- spec-first/connexion Internet  
\- statsmodels/statsmodels Other  
\- tornadoweb/tornado Internet  
\- pallets/flask Internet  
\- pylint-dev/astroid Libraries  
\- Aider-AI/aider Other  
\- Cog-Creators/Red-DiscordBot Other  
\- aws-powertools/powertools-lambda-python Libraries  
\- biopragmatics/bioregistry Other  
\- cocotb/cocotb Other  
\- facebookresearch/hydra Libraries  
\- huggingface/pytorch-image-models Libraries  
\- minio/minio-py Libraries  
\- pre-commit/pre-commit Other  
\- saleweaver/python-amazon-sp-api Internet  
\- scverse/scanpy Other  
\- slackapi/bolt-python Other  
\- tfranzel/drf-spectacular Other  
\- wagtail/wagtail Internet


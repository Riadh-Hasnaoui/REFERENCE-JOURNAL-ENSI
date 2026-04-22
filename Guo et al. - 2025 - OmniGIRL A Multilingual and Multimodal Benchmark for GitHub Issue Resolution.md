\#\# OmniGIRL: A Multilingual and Multimodal Benchmark for

\#\# GitHub Issue Resolution

\#\#\# LIANGHONG GUO,Sun Yat-sen University, Zhuhai Key Laboratory of Trusted Large Language Models,

\`\`\`  
China  
\`\`\`  
\#\#\# WEI TAO,Independent Researcher, China

\#\#\# RUNHAN JIANG,Sun Yat-sen University, China

\#\#\# YANLIN WANG∗,Sun Yat-sen University, Zhuhai Key Laboratory of Trusted Large Language Models,

\`\`\`  
China  
\`\`\`  
\#\#\# JIACHI CHEN,Sun Yat-sen University, Zhuhai Key Laboratory of Trusted Large Language Models, China

\#\#\# XILIN LIU,Huawei Cloud Computing Technologies Co., Ltd., China

\#\#\# YUCHI MA,Huawei Cloud Computing Technologies Co., Ltd., China

\#\#\# MINGZHI MAO,Sun Yat-sen University, China

\#\#\# HONGYU ZHANG,Chongqing University, China

\#\#\# ZIBIN ZHENG,Sun Yat-sen University, Zhuhai Key Laboratory of Trusted Large Language Models, China

\#\# Leaderboard Dataset GitHub Repo

\`\`\`  
The GitHub issue resolution task aims to resolve issues reported in repositories automatically. With advances  
in large language models (LLMs), this task has gained increasing attention, and several benchmarks are  
proposed to evaluate the issue resolution ability of LLMs. However, existing benchmarks have three main  
limitations. First, current benchmarks focus on a single programming language, limiting the evaluation of  
issues from repositories across different languages. Second, they usually cover a narrow range of domains,  
which may fail to represent the diversity of real-world issues. Third, existing benchmarks rely solely on  
textual information in issue descriptions, overlooking multimodal information such as images in issues. In  
this paper, we propose OmniGIRL, aGitHubIssueResoLution benchmark that is multilingual, multimodal,  
and multi-domain. OmniGIRL includes 959 task instances, which are collected from repositories across four  
programming languages (i.e., Python, JavaScript, TypeScript, and Java) and eight different domains. Our  
evaluation shows that current LLMs show limited performances on OmniGIRL. Notably, the best-performing  
model, GPT-4o, resolves only 8.6% of the issues. Besides, we find that current LLMs struggle to resolve issues  
requiring understanding images. The best performance is achieved by Claude-3.5-Sonnet, which resolves only  
\`\`\`  
\`\`\`  
∗Corresponding author.  
\`\`\`  
\`\`\`  
Authors’ Contact Information: Lianghong Guo, Sun Yat-sen University, Zhuhai Key Laboratory of Trusted Large Language  
Models, Zhuhai, China, guolh8@mail2.sysu.edu.cn; Wei Tao, Independent Researcher, Shenzhen, China, wtao@ieee.org;  
Runhan Jiang, Sun Yat-sen University, Zhuhai, China, guolh8@mail2.sysu.edu.cn; Yanlin Wang, Sun Yat-sen University,  
Zhuhai Key Laboratory of Trusted Large Language Models, Zhuhai, China, wangylin36@mail.sysu.edu.cn; Jiachi Chen, Sun  
Yat-sen University, Zhuhai Key Laboratory of Trusted Large Language Models, Zhuhai, China, chenjch86@mail.sysu.edu.cn;  
Xilin Liu, Huawei Cloud Computing Technologies Co., Ltd., Shenzhen, China, liuxilin3@huawei.com; Yuchi Ma, Huawei  
Cloud Computing Technologies Co., Ltd., Shenzhen, China, mayuchi1@huawei.com; Mingzhi Mao, Sun Yat-sen University,  
Zhuhai, China, mcsmmz@mail.sysu.edu.cn; Hongyu Zhang, Chongqing University, Chongqing, China, hyzhang@cqu.  
edu.cn; Zibin Zheng, Sun Yat-sen University, Zhuhai Key Laboratory of Trusted Large Language Models, Zhuhai, China,  
zhzibin@mail.sysu.edu.cn.  
\`\`\`  
\`\`\`  
This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.  
©2025 Copyright held by the owner/author(s).  
ACM 2994-970X/2025/7-ARTISSTA  
https://doi.org/10.1145/  
\`\`\`  
\# arXiv:2505.04606v1 \[cs.SE\] 7 May 2025

\`\`\`  
ISSTA002:2 L. Guo, W. Tao, R. Jang, Y. Wang, J. Chen, X. Liu, Y. Ma, M. Mao, H. Zhang, Z. Zheng  
\`\`\`  
\`\`\`  
10.5% of the issues with image information. Finally, we analyze the reasons behind current LLMs’ failure on  
OmniGIRL, providing insights for future improvements.  
CCS Concepts:•Software and its engineering→Software maintenance tools.  
Additional Key Words and Phrases: Github Issue Resolution, Benchmark, Large Language Models  
\`\`\`  
ACM Reference Format:  
Lianghong Guo, Wei Tao, Runhan Jiang, Yanlin Wang, Jiachi Chen, Xilin Liu, Yuchi Ma, Mingzhi Mao, Hongyu  
Zhang, and Zibin Zheng. 2025\. OmniGIRL: A Multilingual and Multimodal Benchmark for GitHub Issue  
Resolution.Proc. ACM Softw. Eng.2, ISSTA, Article ISSTA002 (July 2025), 23 pages. https://doi.org/10.1145/  
3728871

\`\`\`  
1 Introduction  
The GitHub issue resolution task aims to automatically resolve a wide variety of issues proposed by  
developers in code repositories. These issues include diverse tasks such as fixing bugs, adding new  
features, refactoring code, writing documentation, etc \[ 17 , 46 \]. Effectively addressing these issues  
is crucial for maintaining and evolving real-world software systems. With the development of large  
language models (LLMs), this task has gained increasing attention \[ 13 , 19 , 31 , 33 , 47 , 50 , 52 , 57 , 63 \].  
Several benchmarks \[ 10 , 27 , 38 , 59 \] currently exist for the GitHub issue resolution task. SWE-  
bench \[ 27 \] is the first benchmark in this area, consisting of 2,294 real-world issues from 12 Python  
repositories. Subsequently, OpenAI proposes SWE-bench Verified \[ 38 \], a subset of SWE-bench with  
500 instances verified by experienced developers to provide a more robust evaluation. Additionally,  
SWE-bench-java \[ 59 \] is introduced to extend the task to the Java programming language, including  
93 task instances from 6 Java repositories. Although various benchmarks have been proposed, there  
are still some limitations that prevent them from fully capturing the diversity of real-world issue  
resolution tasks. The primary limitations are as follows:  
\`\`\`  
\- L1: Focusing on a Single Programming Language.Existing benchmarks typically focus  
    on issues from repositories in a single programming language, such as Python or Java, which  
    limits their capacity to assess the LLMs’ ability to resolve issues across multiple programming  
    languages.  
\- L2: Limited Repository Diversity.Current benchmarks, such as SWE-bench \[ 27 \], largely  
    rely on issues from a limited range of domains, e.g., scientific computing, machine learning,  
    and visualization. To better represent real-world issue resolution tasks, more repositories from  
    a wider variety of domains are needed.  
\- L3: Ignoring Multimodal Information.Previous benchmarks focus solely on textual infor-  
    mation in issue descriptions, overlooking multimodal information. Users often use images,  
    such as screenshots of error messages or debugging outputs, to help illustrate issues more  
    clearly. Without incorporating this information, LLMs may have difficulty fully understanding  
    the issue, leading to inaccurate evaluations.  
In this paper, we presentOmniGIRL, a benchmark forGitHubIssueResoLution that incorpo-  
rates multiple aspects of diversity in programming languages, repository domains and modality of  
input information. We first select four most popular programming languages (i.e., Python, Type-  
Script, JavaScript, and Java) as target languages,^1 and collect a candidate list of the most widely  
used repositories based on download counts from package management tools (i.e., pip \[ 3 \], npm \[ 2 \],  
maven \[ 7 \]). From this candidate list, we select 15 repositories from various domains and collect  
real-world issues from these repositories to construct task instances. After validating the collected

(^1) https://github.blog/news-insights/research/the-state-of-open-source-and-ai/

\`\`\`  
OmniGIRL: A Multilingual and Multimodal Benchmark for GitHub Issue Resolution ISSTA002:  
\`\`\`  
task instances, we obtain a total of 959 task instances covering a variety of domains in four program-  
ming languages (addressingL1andL2). In addition to textual information in issue descriptions,  
we find some issues include other modalities. For instance, users use images, such as screenshots  
of error messages, to describe issues more clearly. We manually examine issue descriptions on  
OmniGIRL and identify 19 instances containing images providing crucial information for resolving  
the issues. Moreover, we find that users sometimes share website links to online code platforms,  
which typically contain code reproducing the issue. We annotate these links in the dataset, offering  
future researchers the opportunity to explore how to leverage such resources to enhance issue  
resolution performance (addressingL3).  
We evaluate state-of-the-art LLMs on OmniGIRL, and the results show that the best-performing  
method, GPT-4o with the Agentless-X approach,^2 resolves only 8.6% of issues, highlighting the  
challenges of resolving issues from repositories in multiple languages. Additionally, we observe  
that the Agentless-X method performs worse on TypeScript and JavaScript tasks than Java and  
Python. Besides, we evaluate two advanced LLMs with visual abilities in the task instances with  
images as visual inputs, with Claude-3.5-Sonnet achieving a best resolve rate of only 10.5% and  
GPT-4o achieving just 1.6%. The results show that both LLMs show limited performance on issues  
requiring understanding images.  
Finally, we analyze the reasons why LLMs fail to resolve issues on OmniGIRL. First, we observe  
that when using the Agentless method, Claude-3.5-Sonnet often struggles to generate outputs that  
follow the specified format outlined in the prompt. This formatting issue leads to intermediate  
results that cannot be parsed correctly, preventing the generation of patches in the next stage. As a  
result, Claude-3.5-Sonnet achieves a low issue resolve rate of only 1.9% on OmniGIRL. However,  
we find that the resolve rate increases to 7.4% by modifying the prompt simply. Second, we find  
that the current LLMs have a significantly lower resolve rate on issues that require modifications  
across multiple files compared to those requiring single-file changes. Besides, for issues needing  
multi-file modifications, we find models tend to modify a single file, highlighting a limitation in the  
cross-file issue resolution capabilities of LLMs.  
In summary, our contributions are as follows:

\- We introduce OmniGIRL, a GitHub issue resolution benchmark with multi-aspect diversity in  
    programming languages, repository domains and modality of input information.  
\- We evaluate LLMs’ issue resolving abilities on OmniGIRL, revealing that current models  
    demonstrate limited overall performance across multiple programming languages.  
\- We evaluate LLMs’ performance on issues that require visual information, revealing their  
    limited capability in resolving issues with multimodal inputs.  
\- We conduct an analysis to investigate the reasons why LLMs fail to resolve issues, providing  
    insights for improving issue resolving performance of LLMs in the future.  
2 Background and Related Work  
2.1 GitHub Issue Resolution  
The GitHub issue resolution task aims to resolve issues reported in the GitHub repository auto-  
matically \[ 27 , 59 \]. When evaluating the issue resolution ability of tools, we follow the pipeline as  
shown in Figure 1\. During the inference stage, the tool receives the issue descriptions along with  
the corresponding codebase and generates a patch that contains all necessary code changes to the  
original codebase. In the evaluation stage, the generated patch is applied to the codebase, and all  
test cases related to this issue are run. After obtaining the test log, we check the statuses of the test

(^2) Because the Agentless \[ 52 \] method is designed for Python language, we extend this method to other programming  
languages without changing the key design of this method. The multilingual version of this method is called Agentless-X.

\`\`\`  
ISSTA002:4 L. Guo, W. Tao, R. Jang, Y. Wang, J. Chen, X. Liu, Y. Ma, M. Mao, H. Zhang, Z. Zheng  
\`\`\`  
\`\`\`  
Table 1\. Overview of existing GitHub issue resolution datasets.  
\`\`\`  
\`\`\`  
Dataset Year Programming Languages \# Repositories \# Instances w/ Visual  
Python Java TypeScript JavaScript Input  
SWE-bench \[42\] 2023 ✓ × × × 12 2,294 ×  
SWE-bench-Java \[9\] 2024 × ✓ × × 6 91 ×  
SWE-bench-Verified \[30\] 2024 ✓ × × × 12 500 ×  
OmniGIRL 2024 ✓✓✓✓ 15 959 ✓  
\`\`\`  
\`\`\`  
Issue:  
@applymethod is  
invalid after upgrade to  
3.3.1...  
\`\`\`  
\`\`\`  
GitHub Issue  
Resolution Tool  
Input Generate Patch:+12- 20  
\`\`\`  
\`\`\`  
(a) Inference  
\`\`\`  
\`\`\`  
(b) EvaluationCodebase  
Edited Codebase  
\`\`\`  
\`\`\`  
Running Tests  
\`\`\`  
\`\`\`  
Test Log  
\`\`\`  
\`\`\`  
Passtests/apply.test.js  
Stable  
✓@apply (207 ms)  
✓@apply error with unknown..  
\`\`\`  
\`\`\`  
Issue Descriptions Generated Patch  
\`\`\`  
\`\`\`  
Input  
\`\`\`  
\`\`\`  
Fig. 1\. Overview of the evaluation pipeline of GitHub issue resolution.  
\`\`\`  
\`\`\`  
cases. The issue is considered resolved if all related test cases pass successfully. Some key concepts  
are listed below:  
\`\`\`  
\- Issue Descriptions:descriptions about reported issues in the format of texts or images.  
\- Generated Patch:a generated file including all code changes in the code repository to  
    resolve reported issues. All code changes are formatted in the GitHub diff format.  
\- Codebase:the code repository containing the reported issue and all relevant code files  
    necessary for resolving the issue.  
\- Test Log:a log file containing all test results, which is used to verify the correctness of  
    results.

\`\`\`  
2.2 LLM-based Methods for GitHub Issue Resolution  
\`\`\`  
With the development of LLMs, many researchers attempt to explore their potential for automating  
GitHub issue resolution. Jimenez et al. \[ 27 \] are the first to use LLMs, such as GPT-4, to resolve  
issues in SWE-bench \[ 27 \]. However, the performances of LLMs were limited at that time, with  
the best-performing model, Claude-2, resolving only 1.96% of issues. Inspired by the success of  
agent frameworks in software engineering tasks \[ 23 , 26 , 29 \], some researchers propose agent-  
based methods \[ 18 , 19 , 31 , 43 , 47 , 50 , 57 , 61 , 63 \] to enhance the performance of LLMs in issue  
resolution tasks. Tao et al. \[ 47 \] propose the first multi-agent-based issue resolution framework,  
MAGIS, to improve the issue resolution ability of LLMs. Yang et al. \[ 57 \] propose the SWE-agent  
framework to build an LLM-based agent that can autonomously utilize designed tools to resolve  
issues. Besides, some works also utilize existing software engineering techniques \[ 28 , 32 , 51 \] to  
improve the performance of LLMs. Zhang et al. propose the AutoCodeRover \[ 63 \] method, which  
enhances the localization of edited code by analyzing the structure of the repository. Inspired by

\`\`\`  
OmniGIRL: A Multilingual and Multimodal Benchmark for GitHub Issue Resolution ISSTA002:  
\`\`\`  
existing LLM-based APR tools \[ 18 , 21 , 25 , 53 , 54 , 62 \], Xia et al. \[ 52 \] propose the Agentless method,  
which uses a hierarchical process to find the edit location. Compared with agent-based frameworks,  
software engineering oriented methods can achieve comparable performance and cost less.  
Following previous studies \[ 11 , 40 , 41 \], we can divide current LLM-based issue resolution methods  
into three types: RAG-based method, LLM workflow-based method, and LLM agent-based method.  
The RAG-based methods use a retriever to directly retrieve similar code files from the codebase  
to enhance issue resolution. However, these methods, such as the BM25 retrieval-based method,  
demonstrate limited performance on this task \[ 27 \]. The second type, the LLM workflow-based  
method, breaks down the issue resolution process into predefined stages, where LLMs follow a  
fixed sequence to complete tasks. For example, Agentless \[ 52 \] employs a structured workflow  
with a localization stage to retrieve relevant code and a patch generation stage to generate a final  
patch. Finally, the LLM agent-based method, such as AutoCodeRover \[ 63 \] and SWE-agent \[ 57 \],  
allow LLMs to autonomously interact with the codebase, using tools to collect key information and  
resolve tasks dynamically.

2.3 Benchmarks for GitHub Issue Resolution  
Recently, several benchmarks have been introduced to evaluate the issue resolution abilities of LLMs,  
as summarized in Table 1\. Jimenez et al. \[ 27 \] propose SWE-bench, the first GitHub issue resolution  
benchmark, comprising 2,294 resolved issues from 12 Python repositories. Subsequently, OpenAI  
releases SWE-bench Verified \[ 38 \], a subset of SWE-bench containing 500 task instances verified by  
experienced developers to ensure correctness. Zan et al. \[ 59 \] further introduce SWE-bench-java,  
with 91 task instances from 6 Java repositories.  
However, existing benchmarks have some limitations. Unlike other software engineering tasks \[ 67 \],  
where benchmarks evaluate LLMs’ coding abilities across multiple languages \[ 14 , 16 , 20 , 44 , 45 ,  
55 , 56 , 58 , 60 , 64 – 66 \], current issue resolution benchmarks typically focus on a single language,  
which restricts evaluation diversity. Additionally, benchmarks like SWE-bench \[ 27 \] collect data  
from limited domains, such as scientific computing, machine learning, and visualization. Moreover,  
current benchmarks focus solely on text information in issue descriptions, overlooking multi-  
modal data such as images. To address these limitations, we proposeOmniGIRL, aGitHubIssue  
ResoLution benchmark withOmni-aspect diversity in programming languages, repository domains  
and modality of input information.  
3 OmniGIRL Construction  
In this section, we introduce the process of building OmniGIRL. As shown in Figure 2, this process  
includes five stages: (a) language and repository selection, (b) pull request data collection, (c) task  
instance construction, (d) execution-based verification and (e) unnecessary image filtering.

\`\`\`  
3.1 Language and Repository Selection  
3.1.1 Language Selection.Before building our multilingual benchmark, we first select widely used  
programming languages as target languages. Based on the latest GitHub report,^3 JavaScript, Python,  
TypeScript, and Java are among the most popular languages, reflecting their extensive use in the  
developer community. Besides, these languages are widely used in different domains: Python is  
common in AI and data science, JavaScript and TypeScript are crucial for web development, and  
Java is widely applied in large-scale systems and backend development. Considering the popularity  
and significance of these languages, we choose them as our target languages.  
\`\`\`  
(^3) https://github.blog/news-insights/research/the-state-of-open-source-and-ai/

\`\`\`  
ISSTA002:6 L. Guo, W. Tao, R. Jang, Y. Wang, J. Chen, X. Liu, Y. Ma, M. Mao, H. Zhang, Z. Zheng  
\`\`\`  
\`\`\`  
Collecting  
\`\`\`  
\`\`\`  
Candidate Repos Target Repos  
To p 4 u s e d  
\`\`\`  
\`\`\`  
Selected Languages  
To p 2 00 Filtering  
\`\`\`  
\`\`\`  
Different  
Domains  
\`\`\`  
\`\`\`  
15 Repos Collecting  
\`\`\`  
\`\`\`  
GitHub API  
Request  
\`\`\`  
\`\`\`  
Raw PRs  
Pull  
Requests Attribute Filtering  
With Related Issues  
With Changed Tests  
\`\`\`  
\`\`\`  
Filtered PRs  
Pull  
Requests  
\`\`\`  
\`\`\`  
Filtered PRs  
Pull  
Requests  
\`\`\`  
\`\`\`  
Built Instances  
Ta s k  
Extracting instances  
Key Issue  
Information  
\`\`\`  
\`\`\`  
Result  
Ta s k  
Instances  
\`\`\`  
\`\`\`  
Constructed Environment  
Execution  
Environment ExecutionVerification-based  
Existing Tests from  
Fail to Pass  
\`\`\`  
\`\`\`  
Constructing  
Reading Repos'  
Documents  
\`\`\`  
\`\`\`  
(a) Language and Repository Selection (b) Pull Request Data Collection  
\`\`\`  
\`\`\`  
(c) Task Instance Construction (d) Execution-Based Verification  
Final Results  
Final Task  
Filtering Instances  
Unnecessary  
Images  
\`\`\`  
\`\`\`  
(d) Unnecessary Image Filtering  
\`\`\`  
\`\`\`  
Fig. 2\. Overview of benchmark construction.  
\`\`\`  
\`\`\`  
3.1.2 Repository Selection.To ensure the popularity of the target repositories, we use the download  
counts from language-specific package management tools. For Python, we select repositories based  
on pip download counts. For Java, we use Maven, and for JavaScript and TypeScript, we rely on  
npm. For each language, we select the top 200 repositories with the highest download counts. Next,  
using the GitHub API \[ 6 \], we collect the tags from these repositories. Based on the tags, we select  
15 popular repositories from different domains as our target repositories. This approach ensures  
that our selection covers diverse fields and focuses on highly used repositories.  
\`\`\`  
3.2 Pull Request Data Collection  
3.2.1 Collection of Pull Requests.In GitHub repositories, developers submit pull requests to report  
potential issues and resolve existing issues. In this stage, we use the GitHub Developer API \[ 6 \] to  
collect pull requests from each repository. We then retain only those pull requests in the merged state.  
This is because merged pull requests have been generally reviewed by the repository maintainers  
and successfully integrated into the codebase. Additionally, we set a cutoff date of July 31, 2024,  
and only keep pull requests that were merged before this date, using this as a starting point for  
future data collection.  
3.2.2 Attribute-Based Filtering.To make that each collected data contains issue descriptions and  
tests to verify the correctness of submitted solutions, following the approach of SWE-bench \[ 27 \],  
we use the attribute-based filtering method to filter the collected pull requests data further:

\- Keep PRs resolving at least one issue.In the GitHub repository, when submitting a pull  
    request that resolves some issues, the developer uses statements like “fix \#403” in the title or  
    body to indicate which issues are resolved. Following the implementation code of SWE-bench,^4  
we first gather all text content from the title, body, and commit messages of each pull request.  
We then extract each issue number (e.g., “\#403”) from this aggregated content using regular  
expressions. Finally, we filter out pull request data without any relevant issue number.  
\- Keep PRs with test files changed.When fixing a bug or adding a new feature, developers  
    often submit a pull request containing code changes in test files. These test files offer a great  
    solution to verify whether the bug is fixed or the feature is implemented successfully. Following  
    SWE-bench,^4 we first identify test files in the changed files of a pull request by checking if  
    their full paths contain keywords like “test” or “testing”. Then, we filter out pull request data  
without any test file changed.

(^4) https://github.com/princeton-nlp/SWE-bench/blob/main/swebench/collect/utils.py

\`\`\`  
OmniGIRL: A Multilingual and Multimodal Benchmark for GitHub Issue Resolution ISSTA002:  
\`\`\`  
\`\`\`  
Repo: tailwindlabs/tailwindcss InstanceID: tailwindlabs\_\_tailwindcss- 10212  
CreatedAt : 2023 \- 04 \- 04  
\`\`\`  
\`\`\`  
PR ID: 10212 Version: 3\.  
BaseCommit: d731049... IssueIDs: \["10180"\]  
Fail2Pass: \["tests/default-extractor.test.js"\]  
\`\`\`  
\`\`\`  
Pass2Pass: \[\]  
\`\`\`  
\`\`\`  
Div content with brackets\[\]prevents arbitrary class from being generated  
This works:https://play.tailwindcss.com/0VLICQ8oUW  
\`\`\`  
\`\`\`  
This does not work:https://play.tailwindcss.com/5KJf7xDKv  
\`\`\`  
\`\`\`  
Website Links: \['http...', 'http...'\] Issue Images: \[...\]  
Issue Descriptions  
\`\`\`  
\`\`\`  
src/lib/defaultExtractor.js  
30 letutility \= regex.any(\[  
31 \- // Arbitrary properties  
32 \- /\\\[\[^\\s:'"\`\]+:\[^\\s\]+\\\]/,  
31 \+ // Arbitrary properties (without square brackets)  
32 \+ /\\\[\[^\\s:'"\`\]+:\[^\\s\\\[\\\]\]+\\\]/,  
33 \+  
34 \+ // Arbitrary properties with balanced square brackets  
35 \+  
36 \+ // with square brackets to work in arbitrary properties  
37 \+ // while fixing a problem with the regex matching too much  
38 \+ /\\\[\[^\\s:'"\`\]+:\[^\\s\]+?\\\[\[^\\s\]+?\\\]\[^\\s\]+?\\\]/,  
\`\`\`  
\`\`\`  
tests/default-extractor.test.js  
488  
489 \- expect(extractions).toContain(\`text-\[\#bada 55 \]\`)  
490 \- })  
491 \+  
492 \+ test('arbitrary properties followed by square bracketed stuff', () \=\>{  
493 \+ letextractions \=defaultExtractor(  
494 \+ '\<div class="h-16 items-end border border-white \[display:inherit\]"\>\[foo\]\</div\>‘  
495 \+ )  
496 \+  
497 \+ expect(extractions).toContain(\`\[display:inherit\]\`)  
498 \+ })  
\`\`\`  
\`\`\`  
Test Patch  
\`\`\`  
\`\`\`  
Patch  
\`\`\`  
\`\`\`  
Fig. 3\. An example of task instancetailwindlabs\_\_tailwindcss-10212.  
\`\`\`  
\`\`\`  
3.3 Task Instance Construction  
\`\`\`  
After collecting raw data of pull requests, we build task instances using GitHub Developer API \[ 6 \]  
to obtain key information from each pull request. An example of a task instance is shown in Figure 3\.  
Here, we introduce the attributes of this task instance:

\- Repo.This attribute refers to which repository the task instance belongs to. In Figure 3, this  
    instance is from the repository “tailwindlabs/tailwindcss”.  
\- PR ID.This attribute refers to which pull request the task instance belongs to. Each pull  
    request has a unique ID, such as 10212\.  
\- Instance ID.This attribute is a unique identifier for the task instance, composed of “Repo”  
    and “PR ID”. For example, the “tailwindlabs\_\_tailwindcss-10943” means this task instance is  
    obtained from pull \#10943 in the repository “tailwindlabs/tailwindcss”.  
\- Created At.This attribute refers to the date when the pull request was created.  
\- Issue IDs.This attribute refers to the ID numbers of the issues that are resolved by the pull  
    request. For example, the issue number of instance “tailwindlabs\_\_tailwindcss-10943” is 10937,  
which means this pull request resolves the issue \#10937.  
\- Issue Descriptions.This attribute refers to the text descriptions of issues related to the task  
    instance. For example, as shown in Figure 3, the problem statement describes unexpected  
    results of running programs. In the evaluation, this problem statement serves as the input  
    of the task instance. Following the approach of SWE-bench, we extract and concatenate the  
    issue’s title and body to form the content of the problem statement.  
\- Issue Images.This attribute refers to images in issue descriptions. As shown in Figure 3,  
    this user attaches two images to describe the unexpected results of running programs. In the  
    evaluation, these images can provide visual information for resolving issues. Since GitHub  
    uses URLs to display images, we extract URLs containing “png” or “jpg” from the issue body  
    of task instances. We then manually check whether these images are relevant to the content  
    of the issue. Because not all task instances include images, this is an optional attribute.  
\- Website Links.This attribute refers to some website links users share to help describe reported  
    issues. As shown in Figure 3, this user shares two links to an online code execution platform,

\`\`\`  
ISSTA002:8 L. Guo, W. Tao, R. Jang, Y. Wang, J. Chen, X. Liu, Y. Ma, M. Mao, H. Zhang, Z. Zheng  
\`\`\`  
\`\`\`  
where the reproduced code and execution results are presented. These links provide execution  
environments for developers to understand issues by debugging. We manually check website  
links in each issue and keep website links that are crucial for resolving this issue. This is an  
optional attribute because not all task instances include such links.  
\`\`\`  
\- Version.This attribute refers to the version of the repository when the pull request was  
    created. Since different versions of the code repository may require different environment  
    setups, this information helps construct the appropriate code environment for each task  
    instance. Considering that version information is typically updated in configuration files,  
we locate the configuration file corresponding to each task instance and extract the version  
information. For example, Python versions are usually stored in thesetup.pyfile, JavaScript  
and TypeScript versions inpackage.json, and Java versions inpom.xml.  
\- Base Commit.This attribute is a unique commit ID that the original pull request is based  
    on. Using the base\_commit, we can revert the GitHub repository to the state before the pull  
    request was applied. This helps us construct the correct code repository environment for the  
    target issues. We extract this information using the GitHub Developer API \[6\].  
\- Test Patch.This attribute refers to the code changes in the pull request that are used to test  
    the modified source code. In the evaluation, this content is used to run tests to verify the  
    correctness of the submitted solution. Following the approach of SWE-bench \[ 27 \], we check  
    the file paths of each hunk in the code changes and retain only those where the file path  
    contains keywords like “test” or “testing”. Additionally, for Java, we consider any Java file  
where the file name starts or ends with “Test” (e.g.,TestClass.javaorMyClassTest.java)  
as part of the test patch.  
\- Patch.This attribute refers to the code changes in the pull request that specifically address  
    resolving the issue. This content provides the ground truth solution for the issue. To collect  
    this data, we first examine each hunk in the code changes and filter out hunks related to testing.  
Then, we use the Python library Pygments \[ 22 \] to check the file paths in each hunk and  
determine if they belong to the source files of the target programming language. For example,  
in Python repositories, files ending in “.py” are recognized as Python source files. This helps  
us exclude irrelevant files, such as documentation files ending in “.md”. Additionally, we  
collect certain configuration files that are crucial for the patch’s correctness. For instance, for  
JavaScript, we gather changes inpackage.json, and for Java, we include changes inpom.xml.  
These specific changes are important for ensuring the patch’s correctness.  
\- FAIL2PASS.This attribute refers to tests or test cases that are changed from “fail” status to  
    “pass” status after applying the gold patch. These tests or test cases are used to verify whether  
       the submitted solution can resolve issues in the task instance.  
\- PASS2PASS.This attribute refers to tests or test cases that maintain a “pass” status both before  
    and after applying the gold patch. This attribute can be used to verify whether the submitted  
    solution does not change the function of the original source code.

3.4 Execution-Based Verification  
In this section, we conduct execution-based verification to make each task instance have paired  
tests to check the correctness of submitted solutions. First, we construct an execution environment  
for each task instance and verify its correctness. Second, following the approach of SWE-bench \[ 27 \],  
we conduct execution-based filtering to filter task instances without FAIL2PASS tests or test cases.  
The remaining task instances are considered valid data on OmniGIRL.

\`\`\`  
3.4.1 Environment Construction.Before conducting execution-based filtering, we create an isolated  
execution environment for each task instance using Docker \[ 5 \] to minimize potential conflicts  
\`\`\`

\`\`\`  
OmniGIRL: A Multilingual and Multimodal Benchmark for GitHub Issue Resolution ISSTA002:  
\`\`\`  
\`\`\`  
across environments. For each task instance, we define all setup commands in aDockerfileand  
bash scripts, which are then executed to set up the Docker environment for each instance.  
The execution environment includes the codebase before the issue was resolved and its required  
dependencies. For each task instance, we first useGit\[ 49 \] to clone the repository. Then, with the  
task instance’s “Base Commit” attribute, we useGitto revert the repository to the state before the  
pull request addressing the issue was submitted. To set up the correct dependencies, we refer to  
development documentation in the codebase, such asREADME.mdandCONTRIBUTING.md, which  
often provide guidance on how to build dependencies. Following these instructions, we install  
the necessary dependencies for the codebase. The process described above is written into the  
Dockerfileand bash scripts to automate the construction of the docker environment.  
\`\`\`  
\`\`\`  
3.4.2 Environment Verification.After building the execution environment successfully, we need to  
verify its correctness. In this step, our aim is to ensure that all tests in the test patch can be passed  
after applying the gold patch to the environment. Firstly, we update test files by applying the test  
patch to the codebase. Then, we apply the gold patch to the codebase and run relevant tests to  
obtain test results. We consider the constructed environment successfully verified only if all test  
cases pass. Otherwise, we think this environment needs further improvements.  
\`\`\`  
\`\`\`  
3.4.3 Execution-Based Filtering.After building the execution environment, the next step is to  
verify if the tests can effectively evaluate the correctness of the submitted patch. Ideally, after  
applying the solution (gold patch), we expect the status of certain test cases to change from “fail”  
to “pass”, indicating that the solution has addressed specific issues. We refer to these as FAIL2PASS  
test cases, which serve to verify that the patch has resolved the intended issue in the task instance.  
Test cases that maintain a ’pass’ status throughout this process are called PASS2PASS test cases.  
These help ensure that the submitted patch does not change the original functionality of the code.  
Following the approach of SWE-bench \[ 27 \], we first run the relevant tests before and after  
applying the gold patch to observe whether there exist FAIL2PASS test cases. Then, We only retain  
task instances that contain at least one FAIL2PASS test case. Finally, we manually check whether  
the FAIL2PASS test cases match the tests added or modified in the test patch, ensuring higher  
reliability in our evaluation process.  
\`\`\`  
\`\`\`  
3.5 Unnecessary Image Filtering  
\`\`\`  
After building task instances, we manually check images in each task instance to determine whether  
these images are essential for resolving issues. For example, while some users utilize screenshots of  
error messages to describe issues, these error messages may already be included in the text of the  
issue descriptions. In such cases, we filter these unnecessary images, as they do not provide crucial  
information for resolving issues. The results of the filtering process are presented in Table 2\. Before  
filtering, the dataset contains 39 task instances with an average of 1.7 images per instance, covering  
ten repositories across all four languages. After filtering out unnecessary images, OmniGIRL  
remains 19 instances with an average of 1.8 images per instance, now covering seven repositories  
across three languages (e.g., Python, TypeScript, and JavaScript).  
4 OmniGIRL  
4.1 Statistics of OmniGIRL

After constructing the benchmark, OmniGIRL includes 959 instances collected from 15 repositories,  
covering four programming languages: Python, JavaScript, TypeScript, and Java. The details of the  
repositories included in the dataset are presented in Table 3, which lists the programming language  
used, the number of instances, and the license for each repository. The licenses ensure that our  
dataset can be freely accessed and used for research purposes.

ISSTA002:10 L. Guo, W. Tao, R. Jang, Y. Wang, J. Chen, X. Liu, Y. Ma, M. Mao, H. Zhang, Z. Zheng

\`\`\`  
Table 2\. Results of filtering unnecessary images.  
\`\`\`  
\`\`\`  
Language Before Filtering After Filtering  
\# Instances \# Avg Images \# Repos \# Instances \# Avg Images \# Repos  
All 39 1.7 10 19 1.8 7  
Python 7 1.3 2 2 1.0 2  
TypeScript 15 1.7 2 12 1.9 2  
JavaScript 15 1.8 3 5 1.8 3  
Java 2 1.5 2 0 0.0 0  
\`\`\`  
\`\`\`  
Table 3\. Statistics of OmniGIRL repositories.  
\`\`\`  
\`\`\`  
Repository \# Instances \# Languages License  
python/mypy 189 Python BSD 3-Clause  
pyca/cryptography 21 Python BSD 3-Clause  
dateutil/dateutil 36 Python BSD 3-Clause  
tqdm/tqdm 23 Python MIT  
statsmodels/statsmodels 76 Python BSD 3-Clause  
redis/redis-py 29 Python MIT  
iamkun/dayjs 93 JavaScript MIT  
prettier/prettier 119 JavaScript MIT  
webpack/webpack 58 JavaScript MIT  
jestjs/jest 31 TypeScript MIT  
babel/babel 79 TypeScript MIT  
tailwindlabs/tailwindcss 100 TypeScript MIT  
netty/netty 54 Java Apache-2.  
google/gson 21 Java Apache-2.  
assertj/assertj 30 Java Apache-2.  
\`\`\`  
\`\`\`  
Table 4\. Data analysis for our benchmark.  
\`\`\`  
\`\`\`  
Mean Max  
Issue Text Length (Words) 194 1,  
\`\`\`  
\`\`\`  
Codebase \# Lines (non-test)\# Files (non-test) 257K^995 1,010K3,  
\`\`\`  
\`\`\`  
Gold Patch  
\`\`\`  
\`\`\`  
\# Lines edited 46.3 1,  
\# Files edited 1.2 30  
\# Func. edited 2.2 131  
\`\`\`  
\`\`\`  
Tests \# Fail to Pass\# Total 135.13.3 1,0564,  
\`\`\`  
We also analyze the characteristics of task instances, as summarized in Table 4\. We can find that  
task instances contain a long issue text, including 194 words on average. The codebase includes  
995 files and 257K lines of code on average, showing the complexity of the codebase. Besides, the  
gold patches require modifications across 46 lines, 2.2 functions, and 1.2 files on average. These  
characteristics highlight the complexity of GitHub issue resolution tasks.

\`\`\`  
OmniGIRL: A Multilingual and Multimodal Benchmark for GitHub Issue Resolution ISSTA002:  
\`\`\`  
\`\`\`  
Table 5\. Categories of background knowledge in different programming languages contained in gold patch.  
\`\`\`  
\`\`\`  
Language of Repository Background Knowledge Contained in Gold Patch  
Python “Decorator”; “Generator”; “Iterator”; “Reflection”; “Wraps”  
JavaScript “Anonymous Functions”; “Arrow Functions”; “Event-driven”; “Interface”;  
TypeScript “Anonymous Functions”; “Arrow Functions”; “Enum”; “Generics”; “Interface”; “Type Aliases”;  
Java “Abstract Classes”; “Annotations”; “Generics”; “Inheritance”; “Interface”; “Reflection”;  
\`\`\`  
\`\`\`  
4.2 Diversity of OmniGIRL  
In this section, we introduce the diversity of OmniGIRL from three aspects: diversity of programming  
languages, diversity of repository domains, and diverse modality of input information.  
\`\`\`  
4.2.1 Diversity of Programming Languages.Our dataset contains issues from repositories in four  
widely used programming languages: Python, Java, JavaScript, and TypeScript. Python is known  
for its readability and extensive library support and is widely used in data science and machine  
learning. Java is commonly used in large-scale applications due to its great performance and  
robustness. JavaScript dominates web development with its dynamic capabilities. TypeScript is a  
statically typed superset of JavaScript, which adds type safety to JavaScript’s flexibility. Resolving  
issues from repositories across different programming languages requires distinct background  
knowledge. For each issue, we use its gold patch as a reference to analyze the required background  
knowledge. Each label of background knowledge can be found in developer documentation of these  
four languages \[ 24 , 34 , 35 , 39 \]. The analysis results are shown in Table 5\. For example, we find issues  
in the JavaScript repository require background knowledge of both JavaScript and TypeScript (e.g.,  
“Arrow Functions” and “interface”). By identifying this rich background knowledge, our dataset  
enables researchers to design issue resolution methods applicable across different programming  
languages.

\`\`\`  
4.2.2 Diversity of Repository Domains.In this section, we present the diverse range of domains  
covered by the repositories included in our benchmark. We first collect a brief introduction from  
the GitHub summary of each repository and label them with relevant domain tags. As shown in  
Table 6, our benchmark covers domains as follow:  
\`\`\`  
\- Code quality (35.2%).Code quality tool is widely used to help developers improve code  
    readability and maintainability. For instance, “Prettier” automatically formats code to ensure  
    consistent style, making it more readable and maintainable.  
\- Web development (24.7%).Web development tools like “tailwindcss” are widely used for  
    building modern, responsive user interfaces, facilitating efficient web development and ensur-  
    ing compatibility with modern browsers and frameworks.  
\- Time tools (13.5%).Repositories such as “dateutil” provide crucial utilities for handling time  
    and date operations. These libraries are widely used in various applications, particularly in  
    scheduling and time-sensitive tasks across industries.  
\- Network tools (8.7%).Repositories like “redis-py” provide fundamental tools for managing  
    databases and building scalable network applications. These libraries are key to developing  
    high-performance, distributed systems.  
\- Statistical modeling (7.9%).The “statsmodels” library provides rich statistical and economet-  
    ric tools essential for data-driven decision-making and financial trend modeling. Maintaining  
    this repository requires rich knowledge of statistics and econometrics.  
\- Developer utility (4.4%).Developer Utility provides tools to enhance development productiv-  
    ity. For instance, “gson” simplifies JSON parsing and serialization in Java, while “tqdm” offers  
    progress bars for Python, helping developers efficiently monitor and manage tasks.

ISSTA002:12 L. Guo, W. Tao, R. Jang, Y. Wang, J. Chen, X. Liu, Y. Ma, M. Mao, H. Zhang, Z. Zheng

\`\`\`  
Table 6\. Repository summary and domain tags.  
\`\`\`  
\`\`\`  
Repository Summary Domain Tag  
python/mypy Optional static typing for Python Code quality  
prettier/prettier Opinionated code formatter for JavaScript Code quality  
assertj/assertj Library providing typed assertions for Java Code quality  
webpack/webpack A bundler for javascript to pack modules Web development  
babel/babel Compiler for writing next generation JavaScript. Web development  
tailwindlabs/tailwindcss Utility-first CSS framework for UI development Web development  
dateutil/dateutil Extensions to the standard Python datetime features Time tool  
iamkun/dayjs Lightweight immutable date-time library Time tool  
redis/redis-py Redis python client Network tool  
netty/netty Asynchronous network application framework Network tool  
statsmodels/statsmodels Statistical modeling and econometrics in Python Statitics modeling  
tqdm/tqdm Fast, Extensible Progress Bar for Python and CLI Developer utility  
google/gson Java library for JSON serialization and deserialization Developer utility  
jestjs/jest Testing Framework for JavaScript Test tool  
pyca/cryptography Cryptographic recipes and primitives for Python Cryptography  
\`\`\`  
\- Test tool (3.2%).Test tools such as “jest” automate software testing, ensuring code correctness,  
    reliability, and performance by detecting bugs and verifying expected functionality.  
\- Cryptography (2.4%).The “cryptography” repository offers essential cryptographic primitives  
    and recipes, playing a critical role in securing communications and data, especially in sensitive  
    fields like cybersecurity and financial services.

4.2.3 Diversity of Input Information Modalities.Previous benchmarks only focus on text infor-  
mation in issue descriptions, overlooking diverse multimodal information on issues. By manually  
reviewing issues in our benchmark, we identify three modalities of input: text information, image  
information, and website information.  
Textual information.Text is the most common modality in GitHub issues, where users typically  
describe issues with details such as environment setup, reproduction code, error messages, etc.  
Image information.In addition to textual information, users often upload images to provide  
key details of reported issues. After analyzing images contained on OmniGIRL, we classify them  
into three types based on their purpose, as shown in Figure 4:

\- Screenshots of reproduced code.Some users prefer to attach screenshots to demonstrate  
    the code that reproduces an issue, as shown in Figure 4 (a).  
\- Error messages or logs.Some users prefer taking screenshots of error messages or logs  
    instead of copying the text, especially when the error is long or has complex formatting. In  
    Figure 4 (b), the user uploads a screenshot to show the error messages.  
\- Unexpected output or behavior of code.These images are used to report unexpected results  
    or behaviors after running the program. Unlike the previous two categories, these images  
    often cannot be easily converted to text and require LLMs to understand the semantics of  
    images with visual ability. For instance, in Figure 4 (c), after updating the code version, the  
    user noticed that the colors of the elements were incorrect. They used images to show the  
    unexpected changes in the element colors.

Image information presents new challenges for current LLMs, requiring models with visual abilities  
to understand images, extract key issue details, and ultimately assist in resolving issues.  
Website information.Website information refers to some website links that provide important  
details related to an issue. For example, in the JavaScript and TypeScript GitHub communities,  
users often share links to online code execution platforms to help others reproduce reported issues.

\`\`\`  
OmniGIRL: A Multilingual and Multimodal Benchmark for GitHub Issue Resolution ISSTA002:  
\`\`\`  
\`\`\`  
（ a) Screenshots of reproduced code (b) Error messages or logs (c) Unexpected code results  
Issue: In v3.3.2, some behaviors of pseudo  
elements are not as expected, for example,  
the marker color cannot be changed correctly,  
while this works correctly in v3.3.1..  
V3.3.1 V3.3.  
\`\`\`  
\`\`\`  
Issue: \[Bug\]: Babel crashes when using  
await as an identifier in ForInOfHead. Input  
code for( await of \[1, 2, 3\] ) { console.log  
(await) } ... However, Babel fails to transpile  
the input code:  
\`\`\`  
\`\`\`  
Issue: The function "normalize" with  
dataTypes.jsleads to errors when using with  
some plugins like plaiceholderwithin 11ty for  
example ...  
\`\`\`  
\`\`\`  
Fig. 4\. Examples of images contained in issue descriptions.  
\`\`\`  
\`\`\`  
Issue : tailwindlabs/tailwindcss/issues/12318 Website Link : https://play.tailwindcss.com/BuKHeMD2uv  
\`\`\`  
\`\`\`  
Fig. 5\. An example of website links within an issue.  
\`\`\`  
As shown in Figure 5, instead of providing the reproduced code directly, a user shares a link in  
the issue description that directs to “Tailwind Play”, a website for debugging Tailwind CSS code  
online. These links allow developers to execute the reproduced code and observe errors in real-time.  
Unlike textual or image information, website information requires models to have web-browsing  
capabilities to interact with the website and obtain crucial information about issues.  
Distribution of different modality.We analyze the modalities present in each issue to calculate  
their distribution. Our analysis shows that all issues include text information, with 24.0% (230/959)  
also including website information, 4.1% (39/959) containing image information, This distribution  
highlights the diversity of multimodal data on OmniGIRL.

(^4) https://github.com/tailwindlabs/tailwindcss/issues/

\`\`\`  
ISSTA002:14 L. Guo, W. Tao, R. Jang, Y. Wang, J. Chen, X. Liu, Y. Ma, M. Mao, H. Zhang, Z. Zheng  
\`\`\`  
\`\`\`  
Table 7\. Overview of evaluated LLMs.  
\`\`\`  
\`\`\`  
Model Company Size Context Window With Visual Ability Release Date  
DeepSeek-V2.5 DeepSeek 236B 128K No Sep 2024  
GPT-4o-2024-08-06 OpenAI Unknown 128K Yes Aug 2024  
Claude-3.5-Sonnet-2024-06-25 Anthropic Unknown 200K Yes Jun 2024  
\`\`\`  
5 Evaluation  
In this section, we first evaluate the issue resolution ability of three advanced LLMs on OmniGIRL.  
We then evaluate the performances of LLMs on issues that requires image understanding. Finally,  
we investigate why LLMs fail to resolve issues on OmniGIRL. Note that we only evaluate LLM-based  
methods here because, according to the SWE-bench leaderboard \[ 15 \], the most advanced tools  
are primarily LLM-based. However, our benchmark is designed to evaluate the issue resolution  
ability of any tools, including those that do not rely on LLMs. In summary, we answer the following  
research questions:

\- RQ1:How do the most advanced LLMs perform on OmniGIRL?  
\- RQ2:How do the most advanced LLMs perform in resolving issues with images?  
\- RQ3:What are the main reasons for LLM failures on OmniGIRL?

\`\`\`  
5.1 Experimental Setup  
5.1.1 Model Selection.The GitHub issue resolution task is challenging for LLMs, requiring under-  
standing the issue and locating the edition location in the codebase and generating correct patches.  
Considering the difficulty of this task, we need to choose LLMs with strong coding capabilities  
and long text understanding abilities. In addition, since some task instances on OmniGIRL include  
visual input such as images, we also need to select LLMs with visual understanding capabilities. We  
select three representative state-of-the-art LLMs for evaluation: GPT-4o-2024-08-06 \[ 37 \], Claude-  
3.5-Sonnet-2024-06-25 \[ 12 \] and DeepSeek-V2.5 \[ 48 \], as shown in Table 7\. For simplicity, we refer to  
these models as GPT-4o, Claude-3.5-Sonnet, and DeepSeek-V2.5 in the following sections.  
\`\`\`  
5.1.2 Evaluation Method.Due to the complexity of issue resolution tasks, it is challenging to  
obtain correct results by directly feeding issue descriptions and codebases into LLMs. Therefore,  
we evaluate LLMs using some advanced GitHub issue resolution approaches. As mentioned in  
Section 2.2, we can divide current issue resolution approaches into three types following previous  
studies \[ 11 , 40 , 41 \]: retrieval augmentation-based method, LLM workflow-based method, and  
LLM agent-based method. To ensure a comprehensive evaluation, we select one representative  
method from each category. Based on the SWE-bench leaderboard \[ 15 \], we choose baselines  
with high performance and reasonable cost. Given the limited performance of current RAG-based  
methods \[ 27 , 47 \], we choose the oracle retrieval method for evaluation. For the LLM workflow-based  
method, we select the Agentless \[ 52 \] method, which is ranked 5th in the SWE-bench-Verified \[ 15 \].  
And for the agent-based method, we choose the AutoCoderOver \[ 63 \] method, which is ranked 2nd  
in the SWE-bench-Full \[ 15 \]. These methods not only demonstrate advanced performance but also  
have reasonable costs according to previous studies \[52\].  
Finally, we use three methods: the oracle retrieval \[ 27 , 47 \], the Agentless method \[ 52 \] and the  
AutoCodeRover method \[63\]. The descriptions of these methods are listed as follows:  
Oracle Retrieval.The oracle retrieval \[ 27 , 47 \] method provides both the issue description and  
the specific code files that require editing as inputs. These files are identified directly from the

\`\`\`  
OmniGIRL: A Multilingual and Multimodal Benchmark for GitHub Issue Resolution ISSTA002:  
\`\`\`  
gold patch in each task instance. This approach enables an ideal-condition evaluation, simulating a  
scenario where developers accurately locate the files necessary for resolving the issue.  
Agentless-X.Considering that current issue resolution frameworks are designed primarily for  
Python, we select the Agentless approach \[ 52 \] as a baseline and adapt it to support additional  
languages (e.g., JavaScript, TypeScript, and Java), enabling evaluation on OmniGIRL. We refer to  
this multilingual adaptation as Agentless-X. We choose Agentless as our baseline because it can  
achieve comparable performance while maintaining lower costs compared to other methods.  
The original Agentless approach is a two-phase method for issue resolution. First, the localization  
phase uses a hierarchical approach where the LLM successively identifies the relevant files, specific  
classes or methods, and finally, locates the exact code lines to be edited. Second, in the repair phase,  
the LLM generates a patch based on the locations identified in the first phase.  
In Agentless-X, we retain Agentless’s original design and expand it to support multiple languages.  
The original Agentless approach uses AST tools to parse file structures during the localization stage.  
In Agentless-X, we use different AST tools for each language: Babel \[ 4 \] for JavaScript/TypeScript and  
JParser \[ 1 \] for Java. Additionally, we rewrite LLM prompts in multilingual versions. For parameter  
settings, we follow the default setting from the original Agentless implementation.^5  
AutoCodeRover-X.^6 We choose the AutoCodeRover \[ 63 \] method as our baseline. Similar to  
the Agentless method, the AutoCodeRover method only supports Python language. We adapt this  
method to support additional languages (e.g., JavaScript, TypeScript, and Java), enabling evaluation  
of our multilingual benchmark. We refer to this multilingual adaption as AutoCodeRover-X.  
The original AutoCodeRover method resolves issues using two LLM-based agents: the context  
retrieval agent and the patch generation agent. First, given issue descriptions and codebase as input,  
the context retrieval agent searches code information related to the given issue. In this stage, the  
agent searches relevant code information by calling code search tools iteratively until the agent  
thinks that enough code information is retrieved. Then, the retrieved code information is input  
to the patch generation agent. This agent will keep refining the generated patch until it can be  
applied successfully or until the maximum number of attempts is reached.  
In AutoCodeRover-X, we retain AutoCodeRover’s original design and expand it to support multi-  
ple languages. The context retrieval agent uses AST tools to parse file structures. In AutoCodeRover-  
X, we use different AST tools for each language: Babel \[ 4 \] for JavaScript/TypeScript and tree-  
sitter \[ 8 \] for Java. Additionally, we rewrite LLM prompts in multilingual versions. For parameter  
settings, we follow the default setting from the original AutoCodeRover implementation \[36\].  
5.1.3 Evaluation Metrics.Following previous studies \[ 27 , 47 , 52 \], we use these metrics to evaluate  
the performance of LLMs:

\- Resolve Rate:the percentage of task instances that are resolved.  
\- Apply Rate:the percentage of generated patches that are intergrated to codebase using  
    Git \[49\] tool without any errors.  
\- Cost:the average cost of evaluating task instances.

\`\`\`  
5.2 Performance of LLMs on OmniGIRL  
\`\`\`  
We evaluate three advanced LLMs with three methods on OmniGIRL. The results are presented  
in Table 8\. First, we can find that performance of advanced LLMs on OmniGIRL remains limited.  
Among the evaluated models, GPT-4o with Agentless-X method achieves the highest resolve rate of  
8.6% and apply rate of 87.4% on OmniGIRL. And GPT-4o with AutoCodeRover-X method achieves  
the second best performance with the resolve rate of 8.1% and apply rate of 85.8% on OmniGIRL.

(^5) https://github.com/OpenAutoCoder/Agentless. We use the Agentless-v1 for evaluation.  
(^6) We use the AutoCodeRover(v20240620) for evaluation.

\`\`\`  
ISSTA002:16 L. Guo, W. Tao, R. Jang, Y. Wang, J. Chen, X. Liu, Y. Ma, M. Mao, H. Zhang, Z. Zheng  
\`\`\`  
Moreover, Claude-3.5-Sonnet with oracle retrieval method achieves the third best performance  
with the resolve rate of 7.8% and apply rate of 61.8% on OmniGIRL. However, the performance of  
these LLMs across both methods remains limited, highlighting the need for further improvements  
in the issue resolution ability of LLMs.  
Second, the results show that the Agentless-X method and the AutoCodeRover-X outperform the  
oracle retrieval method for both GPT-4o and DeepSeek-V2.5. Specifically, for GPT-4o, Agentless-X  
increases the resolve rate from 2.5% to 8.6%, while AutoCodeRover-X improves it to 8.1%. Similarly,  
DeepSeek-V2.5’s performance also improves, with Agentless-X raising the resolve rate from 2.7% to  
3.9% and AutoCodeRover-X enhancing it further to 6.0%. These results demonstrate the effectiveness  
of the Agentless and the AutoCoderRover in improving the issue resolution ability of LLMs.  
Third, we find that for Claude-3.5-Sonnet, both the oracle retrieval method and the AutoCodeRover-  
X method perform better, achieving resolve rates of 7.8% and 7.6%, respectively, while its perfor-  
mance with the Agentless-X method is limited to only 1.9%. We believe this higher performance  
with oracle retrieval is due to Claude-3.5-Sonnet’s strong capability in understanding long code  
segments, which allows it to make accurate code changes when the correct file locations are  
provided. In contrast, with Agentless-X method, Claude-3.5-Sonnet’s performance is limited be-  
cause it often fails to produce results in the expected format during the localization stage. This  
inconsistency makes it hard to parse the location output correctly, ultimately preventing patch  
generation. The detailed discussion of this issue is in Section 5.4. Compared to the Agentless-X  
method, AutoCodeRover-X achieves better performance on Claude-3.5-Sonnet, demonstrating its  
robustness in enhancing the performance of different LLMs.  
Last, we observe that both the Agentless-X method and the AutoCodeRover-X method perform  
worse on JavaScript and TypeScript than on Java and Python. This is likely due to the design of  
these methods, which both rely on AST tools to parse repository files and locate key structures,  
such as classes and methods. Specifically, they focus on extracting information from traditional  
object-oriented constructs like classes and methods but do not account for other critical structures.  
In Python and Java, essential information is typically organized within classes and methods,  
so this AST-based extraction is effective. However, in JavaScript and TypeScript repositories,  
code frequently relies on types and interfaces to define important structures that are not part of  
the traditional class or method constructs. This makes it challenging for the original extraction  
method to capture this information effectively. Additionally, JavaScript and TypeScript always  
use anonymous and arrow functions, which AST tools struggle to parse compared to standard  
functions. For these methods to handle JavaScript and TypeScript more effectively, it would need  
to account for these language-specific features, such as arrow functions, anonymous functions, and  
the use of types and interfaces.

\`\`\`  
RQ1 Summary:The performances of current LLMs remain limited on OmniGIRL. Besides,  
the Agentless-X method and the AutoCodeRover-X can effectively enhance issue resolution  
preformance of GPT-4o and DeepSeek-V2.5. However, while Claude-3.5-Sonnet achieves good  
performance with the oracle retrieval method and the AutoCodeRover-X method, it struggles  
with Agentless-X. Lastly, Agentless-X and AutoCodeRover-X perform better on Java and Python  
compared to JavaScript and TypeScript.  
\`\`\`  
\`\`\`  
5.3 Performances of LLMs on Issues With Visual Inputs  
\`\`\`  
We evaluate two advanced LLMs with visual understanding capabilities, GPT-4o and Claude-3.5-  
Sonnet, on a set of 19 task instances that require understanding images in issues. This evaluation  
uses all three baselines. Additionally, given the relatively small size of the subset, we repeat each

\`\`\`  
OmniGIRL: A Multilingual and Multimodal Benchmark for GitHub Issue Resolution ISSTA002:  
\`\`\`  
\`\`\`  
Table 8\. Performance comparison across different LLMs on OmniGIRL. In the table, DeepSeek-V2.5 is short for  
DeepSeek, GPT-4o-2024-08-06 is short for GPT-4o, and Claude-3.5-Sonnet-2024-06-25 is short for Claude-3.5.  
\`\`\`  
\`\`\`  
Model Oracle Retrieval Agentless-X AutoCodeRover-X  
Resolve Rate Apply Rate Cost($) Resolve Rate Apply Rate Cost($) Resolve Rate Apply Rate Cost($)  
DeepSeek (All) 2.7% (26/959) 49.0% (470/959) 0.005 3.9% (37/959) 52.0% (499/959) 0.010 6.0 % (58/959) 53.0% (508/959) 0\.  
Python 1.3% (5/374) 49.7% (186/374) 0.008 6.1% (23/374) 70.9% (265/374) 0.014 7.2 % (27/374) 53.2% (199/374) 0\.  
TypeScript 1.9% (4/210) 45.2% (95/210) 0.003 1.9% (4/210) 44.3% (93/210) 0.006 4.3 % (9/210) 46.7% (98/210) 0\.  
JavaScript 2.2% (6/270) 48.5% (131/270) 0.003 2.6% (7/270) 37.0% (100/270) 0.009 3.7 % (10/270) 53.3% (144/270) 0\.  
Java 10.5% (11/105) 55.2% (58/105) 0.038 2.9% (3/105) 39.0% (41/105) 0.007 11.4 % (12/105) 63.8% (67/105) 0\.  
GPT-4o (All) 2.7% (26/959) 42.6% (409/959) 0.069 8.6% (82/959) 87.4% (838/959) 0.098 8.1 % (78/959) 85.8% (823/959) 0\.  
Python 1.9% (7/374) 42.5% (159/374) 0.112 8.8% (33/374) 89.3% (334/374) 0.090 9.9 % (37/374) 89.6% (335/374) 0\.  
TypeScript 3.3% (7/210) 44.3% (93/210) 0.035 6.2% (13/210) 85.2% (179/210) 0.095 6.2 % (13/210) 78.6% (165/210) 0\.  
JavaScript 1.9% (5/270) 40.0% (108/270) 0.049 6.3% (17/270) 87.8% (237/270) 0.113 3.7 % (10/270) 84.4% (228/270) 0\.  
Java 6.7% (7/105) 46.7% (49/105) 0.003 18.1% (19/105) 83.8% (88/105) 0.053 17.1 % (18/105) 90.5% (95/105) 0\.  
Claude-3.5 (All) 7.8% (75/959) 61.8% (593/959) 0.110 1.9% (18/959) 14.6%(140/959) 0.272 7.6 % (73/959) 61.5% (590/959) 0\.  
Python 5.1% (19/374) 52.9% (198/374) 0.179 1.6% (6/374) 1.6% (55/374) 0.335 8.8 % (33/374) 80.5% (301/374) 0\.  
TypeScript 6.7% (14/210) 70.0% (147/210) 0.047 1.0% (2/210) 10.5% (22/210) 0.170 4.3 % (9/210) 33.8% (71/210) 0\.  
JavaScript 8.5% (23/270) 63.3% (171/270) 0.073 2.2% (6/270) 18.5% (50/270) 0.178 4.1 % (11/270) 46.7% (126/270) 0\.  
Java 18.1% (19/105) 73.3% (77/105) 0.063 3.8% (4/105|) 12.4% (13/105) 0.342 19.0 % (20/105) 87.6% (92/105) 0\.  
\`\`\`  
\`\`\`  
experiment three times to minimize the effects of randomness. To investigate the effect of visual  
inputs, we conduct experiments under three different settings:  
\`\`\`  
\- Text Only.In this setting, we do not provide the actual images from issues to LLMs. Instead,  
    we only include the image URLs as text, without any visual information.  
\- Text & Image.In this setting, both the text and images from issues are input to LLMs. The  
    LLMs use its visual capabilities to understand the images and resolve the issue.  
\- Image-augmented Text.This is a two-stage approach. In the first stage, we use a prompt to  
    instruct models to understand images and to rewrite the issue text with visual information.  
    In the second stage, the rewritten text, augmented with image details, is used as input to the  
    model. Compared to the second setting, this approach allows us to better understand how the  
    model processes and interprets the visual information.

The results are shown in Table 9, highlighting three key conclusions. First, current LLMs show  
limited performance on issues requiring image understanding. Using oracle retrieval method,  
which provides the correct files, Claude-3.5-Sonnet achieves the best performance, resolving only  
10.5% of the issues in the image-augmented text setting. In contrast, GPT-4o resolves only 5.3% of  
issues with the AutoCodeRover-X method. Second, leveraging visual information is beneficial for  
resolving issues requiring image understanding. When using oracle retrieval method, compared to  
the “Text only” setting, Claude-3.5-Sonnet’s resolve rate increases from 3.5% to 10.5% in the “Image-  
augmented Text” setting. Similarly, with the AutoCodeRover-X method, GPT-4o does not resolve  
any issue in the “Text only” setting. However, when image information is included, the resolve  
rate increases to 3.1% in the “Text & Image” setting and further improves to 5.3% in the “Image-  
augmented Text” setting. Third, LLMs using the Agentless-X method and the AutoCodeRover-X  
method both struggle to resolve issues requiring image understanding. Despite its solid performance  
on OmniGIRL, Agentless-X failed to resolve any issues requiring image understanding on both  
models. Similarly, AutoCodeRover-X also shows limited performance in this area, with GPT-4o  
resolving at most 5.3% of issues, while Claude-3.5-Sonnet failed to resolve any. These results  
highlight that current methods need improvements to utilize visual information effectively.

\`\`\`  
ISSTA002:18 L. Guo, W. Tao, R. Jang, Y. Wang, J. Chen, X. Liu, Y. Ma, M. Mao, H. Zhang, Z. Zheng  
\`\`\`  
\`\`\`  
Table 9\. Performance comparison across different LLMs on OmniGIRL-V. In this table, Claude-3.5-Sonnet-  
2024-06-25 is short for Claude-3.5 and the “Image-augmented Text” setting is short for IAG-Text.  
\`\`\`  
\`\`\`  
Model Setting Oracle Retrieval Agentless-X AutoCodeRover-X  
Resolve Rate Apply Rate Cost($) Resolve Rate Apply Rate Cost($) Resolve Rate Apply Rate Cost($)  
\`\`\`  
\`\`\`  
GPT-4o  
\`\`\`  
\`\`\`  
Text Only 1.6% (1/57) 45.6% (26/57) 0.036 0% (0/57) 42.1% (24/57) 0.096 0% (0/57) 84.2% (48/57) 0\.  
Text & Images 1.6% (1/57) 33.3% (19/57) 0.038 0% (0/57) 26.3% (15/57) 0.110 3.5% (2/57) 77.2% (44/57) 0\.  
IAG-Text 1.6% (1/57) 52.6% (30/57) 0.046 0% (0/57) 38.6% (22/57) 0.109 5.3% (3/57) 78.9% (45/57) 0\.  
\`\`\`  
\`\`\`  
Claude-3.  
\`\`\`  
\`\`\`  
Text Only 3.5% (2/57) 50.9% (29/57) 0.058 0% (0/57) 57.9% (33/57) 0.210 0% (0/57) 84.2% (48/57) 0\.  
Text & Images 3.5% (2/57) 59.6% (34/57) 0.062 0% (0/57) 63.2% (36/57) 0.224 0% (0/57) 61.4% (35/57) 0\.  
IAG-Text 10.5% (6/57) 59.6% (34/57) 0.074 0% (0/57) 52.6% (30/57) 0.233 0% (0/57) 68.4% (39/57) 0\.  
\`\`\`  
\`\`\`  
RQ2 Summary:Our evaluation shows that current LLMs struggle with issues requiring image  
understanding. Besides, leveraging visual information is beneficial for resolving issues requiring  
image understanding. However, we find LLMs with Agentless-X and AutoCodeRover-X show  
limited performances on issues requiring image understanding, highlighting the need for these  
methods to utilize visual information effectively.  
\`\`\`  
5.4 Failure Analysis  
To investigate why LLMs fail to resolve issues on OmniGIRL, we analyze their behavior at the  
localization and patch generation stages, identifying one type of failure at each stage.  
Parsing failure of structural output.This type of failure occurs in the localization stage of the  
Agentless-X method. It happens when the model fails to follow the specified output format given in  
the prompt. In the example shown in Figure 6, the prompt instructs LLMs to provide the locations  
to be edited (e.g., class names, function names, method names, and line numbers) and to wrap these  
results with a code block. Then, this method uses regex expressions to parse the localization results  
from responses of LLMs. We can find that both GPT-4o and DeepSeek-V2.5 follow the prompt’s  
instructions, successfully enclosing their output in code blocks, allowing the results to be parsed  
correctly and used in the following repair stage. However, Claude-3.5-Sonnet does not follow this  
format; instead of enclosing the location information in a code block, it provides the output in plain  
text, which leads to a parsing failure. As a result, no location information is passed to the repair  
stage, and no patch can be generated from Claude-3.5-Sonnet in the following repair stage.  
To further explore the impact of this error, we compute the parsing success rate for each model  
in the localization stage of the Agentless-X framework, as shown in Table 10\. GPT-4o achieves the  
highest parsing success rate at 97.2%, while Claude-3.5-Sonnet obtains a much lower success rate  
of 11.8%. This parsing error significantly affects Claude-3.5-Sonnet’s ability to generate patches,  
leading to a lower overall resolve rate (1.9%). However, we find that this failure can be mitigated  
effectively by adding format constraints in original prompt. In our experiments, we append the  
original prompt with “You must wrap the results with\`\`\`”. We find this prompt increases the  
Claude-3.5-Sonnet’s parsing success rate and hence increases the resolve rate from 1.9% to 7.4%.  
This results highlight the importance of building robust prompts in current methods.  
Insufficient ability of cross-file issue resolution.This type of failure occurs in the patch  
generation stage of all evaluated baselines. In the issue resolution task, resolving issues that require  
modifications across multiple files is particularly challenging. To investigate LLMs’ ability to resolve  
single-file and cross-file issues, we categorize issues on OmniGIRL into these two types. For each  
issue, we use its gold patch as a reference and check how many files need to be modified to resolve  
the issue. If multiple files are modified in the gold patch of the issue, we classify this issue as a cross-  
file issue; otherwise, it is categorized as a single-file issue. And then we analyze performances of

\`\`\`  
OmniGIRL: A Multilingual and Multimodal Benchmark for GitHub Issue Resolution ISSTA002:  
\`\`\`  
\`\`\`  
Please provide the class name,  
function or method name, or the exact  
line numbers that need to be edited.  
\#\#\# Examples:  
\`\`\`  
full\_path1/file1.py  
line: 10  
class: MyClass  
line: 51  
full\_path2/file2.py  
function: MyClass2.my\_method  
line: 12  
full\_path3/file3.py  
function: my\_function  
line: 24  
line: 156  
\`\`\`  
Return just the location(s)  
\`\`\`  
\`\`\`  
Prompt  
\`\`\`  
\`\`\`  
Based on the problem description and the provided code  
skeleton, here are the locations that likely need inspection or editing to fix the ANSI color code issue in the progress  
bar:  
tqdmclass: /\_tqdm.pytqdm  
function: function: \_\_format\_meterinit\_\_  
function: \_\_repr\_\_  
function: refresh  
\`\`\`  
\`\`\`  
\`\`\` tqdm/\_tqdm.py  
function: tqdm.format\_meter  
function: tqdm.\_\_init\_\_  
\`\`\`  
\`\`\`  
\`\`\`  
\`\`\`  
tqdmfunction: /\_tqdm.pytqdm.format\_meter  
function: tqdm.\_\_init\_\_  
function: function: tqdm.set\_descriptiontqdm.set\_description\_str  
.... \`\`\`  
\`\`\`  
\`\`\`  
Response  
GPT-4o  
\`\`\`  
\`\`\`  
Claude-3.  
\`\`\`  
\- Sonnet

\`\`\`  
DeepSeek-V2.  
\`\`\`  
\`\`\`  
Parse Success  
\`\`\`  
\`\`\`  
Parse Failure  
\`\`\`  
\`\`\`  
Parse Success  
\`\`\`  
\`\`\`  
Block Found\!  
\`\`\`  
\`\`\`  
No Block  
\`\`\`  
\`\`\`  
Block Found\!  
\`\`\`  
\`\`\`  
Fig. 6\. Responses of different LLMs in the localization stage of Agentless-X.  
\`\`\`  
\`\`\`  
Table 10\. Parsing success rate of LLMs with the Agentless-X method on OmniGIRL.  
\`\`\`  
\`\`\`  
Model Agentless-X  
Prompt Setting Parsing success Rate Resolve Rate Apply Rate  
GPT-4o default 97.2% (932/959) 8.6% (82/959) 87.4% (838/959)  
DeepSeek-V2.5 default 82.5% (791/959) 3.9% (37/959) 52.2% (501/959)  
Claude-3.5-Sonnet default 10.0% (96/959) 1.9% (18/959) 17.6% (169/959)  
Claude-3.5-Sonnet new prompt 98.5% (945/959) 7.4% (71/959) 63.3% (607/959)  
\`\`\`  
LLMs in two types of issues. As shown in Table 11, we can observe that LLMs perform significantly  
worse on cross-file issues compared to single-file issues.  
We assume one reason LLMs perform poorly on cross-file issues is their tendency to modify  
only a single file. To investigate this assumption, we first examine the number of files modified in  
the patches generated by LLMs for cross-file issues. Then, we calculate the proportion of patches  
that include modifications to multiple files versus those with changes to only a single file. We find  
that, even with the oracle retrieval method, which provides the relevant files to the model, LLMs  
still primarily edit a single file. Specifically, Claude-3.5-Sonnet modifies a single file in 74.9% of  
issues, GPT-4o in 72.9%, and DeepSeek-V2.5 in 86.3%. Moreover, with the Agentless-X method, all  
models modify a single file in 100% of issues. Additionally, with the AutoCodeRover-X method,  
Claude-3.5-Sonnet modifies a single file in 93.3% of issues, GPT-4o in 82.4%, and DeepSeek-V2.  
in 90.0%. These results highlight the insufficient ability of current LLMs in resolving issues that  
require modifying multiple files.

\`\`\`  
RQ3 Summary:Our analysis shows that Claude-3.5-Sonnet struggles to generate results in  
the expected format during the Agentless-X localization stage, leading to poor issue resolution  
performance. We find that adding specific format instructions to the prompt can improve Claude-  
3.5-Sonnet’s results. Additionally, current LLMs perform poorly on cross-file issues and tend to  
modify only a single file, even when multiple files require changes.  
\`\`\`

\`\`\`  
ISSTA002:20 L. Guo, W. Tao, R. Jang, Y. Wang, J. Chen, X. Liu, Y. Ma, M. Mao, H. Zhang, Z. Zheng  
\`\`\`  
\`\`\`  
Table 11\. Performance comparison across different LLMs on OmniGIRL for cross-file and single-file issues.  
\`\`\`  
\`\`\`  
Model Method Single-file Issues Cross-file Issues  
Resolve Rate Apply Rate Resolve Rate Apply Rate  
\`\`\`  
\`\`\`  
GPT-4o  
\`\`\`  
\`\`\`  
Oracle Retrieval 3.5% (21/601) 42.9% (258/601) 1.4% (5/358) 42.2% (151/358)  
Agentless-X 12.0% (72/601) 87.4% (525/601) 2.8% (10/358) 87.4% (313/358)  
AutoCodeRover-X 11.5% (69/601) 88.4% (531/601) 2.5% (9/358) 81.6% (292/358)  
\`\`\`  
\`\`\`  
DeepSeek-V2.5 Oracle RetrievalAgentless-X 3.7% (22/601)5.2% (31/601) 50.6% (304/601)52.4% (315/601) 1.1% (4/358)1.7% (6/358) 46.4% (166/358)51.4% (184/358)  
AutoCodeRover-X 8.5% (51/601) 55.9% (336/601) 1.9% (7/358) 48.0% (172/358)  
\`\`\`  
\`\`\`  
Claude-3.5-Sonnet Oracle Retrieval 10.5% (63/601) 66.1% (397/601) 3.4% (12/358) 54.7% (196/358)  
Agentless-X 2.5% (15/601) 13.6% (82/601) 0.8% (3/358) 16.2% (58/358)  
AutoCodeRover-X 10.8% (65/601) 63.4% (381/601) 2.2% (8/358) 58.3% (209/358)  
\`\`\`  
6 Discussion  
Potential Impacts.First, we propose a GitHub issue resolution benchmark that captures  
diversity across programming languages, repository domains, and modalities of input information.  
This allows researchers to more effectively evaluate any method of resolving issues in different  
programming languages and with multimodal data. Second, our error analysis highlights specific  
limitations in current methods and LLMs, such as poor performance on TypeScript and JavaScript  
issues and challenges in resolving cross-file issues, etc. These findings provide insights for improving  
LLMs and issue resolution techniques. Third, we have made our data collection code and tutorial  
publicly available, allowing other researchers to collect GitHub issue resolution data to build a new  
evaluation benchmark or training dataset.  
Limitations and future directions.First, following the SWE-bench \[ 27 \], we collect data  
based on repository popularity, which may introduce bias because of overlooking less popular but  
potentially valuable repositories. To address this, we have open-sourced our data collection code  
and tutorial, enabling other researchers to collect data from repositories they consider valuable.  
Additionally, we plan to expand our benchmark in the future to include data from a broader  
range of repositories to mitigate this bias. Second, following the SWE-bench \[ 27 \], we use attribute  
filtering and execution-based filtering to remove invalid instances. However, this approach may  
filter out some instances. For example, using path keywords to identify test files could miss files  
that don’t follow conventional naming patterns, and filtering out instances without FAIL2PASS  
tests excludes issues like performance improvements. We do this to ensure that the tests for each  
instance can reliably evaluate the correctness of the solution. In the future, we plan to use more  
advanced techniques, like machine learning-based file identification, to identify test files. Besides,  
we plan to expand the benchmark to include more issue types. Finally, we do not evaluate the  
effects of web information, as there are currently no methods to resolve issues using the website  
information contained in the issue description. In the future, we will evaluate potential approaches  
to incorporate web-based information into issue resolution.  
7 Conclusion  
In this paper, we propose OmniGIRL, a GitHub issue resolution benchmark with multi-aspect  
diversity in programming languages, repository domains and modality of input information. The  
evaluation results demonstrate that current LLMs show limited performances on OmniGIRL.  
Besides, we also find that current LLMs struggle to resolve issues that require understanding  
images. Furthermore, we analyze the reasons behind LLM’s failure on OmniGIRL, to shed light on  
future performance improvements of LLMs on OmniGIRL.

OmniGIRL: A Multilingual and Multimodal Benchmark for GitHub Issue Resolution ISSTA002:21

8 Data Availability

Our code and data are available at https://github.com/DeepSoftwareAnalytics/OmniGIRL.

Acknowledgments

This work is supported by CCF-Huawei Populus Grove Fund CCF-HuaweiSE202403, the National  
Natural Science Foundation of China (62032025) and the Guangdong Basic and Applied Basic  
Research Foundation (2023A1515012292).

References  
\[1\] \[n. d.\]. JParser: JSON Stream Parser for Java. https://github.com/javadev/jparser. Accessed: 2023-10-26.  
\[2\] \[n. d.\]. npm \- Node Package Manager. https://www.npmjs.com/. Accessed: 2023-10-25.  
\[3\] \[n. d.\]. pip \- The Python Package Installer. https://pip.pypa.io/en/stable/. Accessed: 2023-10-25.  
\[4\] 2024\. Babel. https://babeljs.io/.  
\[5\] 2024\. docker. https://www.docker.com/.  
\[6\] 2024\. github-rest-api. https://docs.github.com/en/rest.  
\[7\] 2024\. maven. https://maven.apache.org/.  
\[8\] 2024\. tree-sitter. https://tree-sitter.github.io/.  
\[9\]Wasi Uddin Ahmad, Md Golam Rahman Tushar, Saikat Chakraborty, and Kai-Wei Chang. 2021\. Avatar: A parallel  
corpus for java-python program translation.arXiv preprint arXiv:2108.11590(2021).  
\[10\]Reem Aleithan, Haoran Xue, Mohammad Mahdi Mohajer, Elijah Nnorom, Gias Uddin, and Song Wang. 2024\. SWE-  
Bench+: Enhanced Coding Benchmark for LLMs.arXiv preprint arXiv:2410.06992(2024).  
\[11\]Anthropic. 2024\. Building Effective Agents. https://www.anthropic.com/research/building-effective-agents Accessed:  
2024-12-31.  
\[12\] Anthropic. 2024\. claude-3-5-sonnet. https://www.anthropic.com/news/claude-3-5-sonnet.  
\[13\]Daman Arora, Atharv Sonwane, Nalin Wadhwa, Abhav Mehrotra, Saiteja Utpala, Ramakrishna Bairi, Aditya Kanade,  
and Nagarajan Natarajan. 2024\. MASAI: Modular Architecture for Software-engineering AI Agents.arXiv preprint  
arXiv:2406.11638(2024).  
\[14\]Ben Athiwaratkun, Sanjay Krishna Gouda, Zijian Wang, Xiaopeng Li, Yuchen Tian, Ming Tan, Wasi Uddin Ahmad,  
Shiqi Wang, Qing Sun, Mingyue Shang, et al.2023. Multi-lingual Evaluation of Code Generation Models.OpenReview  
(2023). https://arxiv.org/abs/2210.14868 ICLR 2023\.  
\[15\] SWE bench Team. 2024\. SWE-bench Leaderboard. https://www.swebench.com/ Accessed: 2024-12-30.  
\[16\]BigCode. 2023\. MultiPL-E: A Multi-programming Language Benchmark for Evaluating Code Generation. https:  
//nuprl.github.io/MultiPL-E/  
\[17\]Tegawendé F. Bissyandé, David Lo, Lingxiao Jiang, Laurent Réveillère, Jacques Klein, and Yves Le Traon. 2013\. Got  
issues? Who cares about it? A large scale investigation of issue trackers from GitHub. InISSRE. IEEE Computer Society,  
188–197.  
\[18\]Islem Bouzenia, Premkumar Devanbu, and Michael Pradel. 2024\. Repairagent: An autonomous, llm-based agent for  
program repair.arXiv preprint arXiv:2403.17134(2024).  
\[19\]Dong Chen, Shaoxin Lin, Muhan Zeng, Daoguang Zan, Jian-Gang Wang, Anton Cheshkov, Jun Sun, Hao Yu, Guo-  
liang Dong, Artem Aliev, et al.2024. CodeR: Issue Resolving with Multi-Agent and Task Graphs.arXiv preprint  
arXiv:2406.01304(2024).  
\[20\]Jiachi Chen, Qingyuan Zhong, Yanlin Wang, Kaiwen Ning, Yongkun Liu, Zenan Xu, Zhe Zhao, Ting Chen, and Zibin  
Zheng. 2024\. RMCBench: Benchmarking Large Language Models’ Resistance to Malicious Code. InProceedings of the  
39th IEEE/ACM International Conference on Automated Software Engineering. 995–1006.  
\[21\]Yang Chen. 2024\. Flakiness Repair in the Era of Large Language Models. InProceedings of the 2024 IEEE/ACM 46th  
International Conference on Software Engineering: Companion Proceedings. 441–443.  
\[22\] Pygments contributors. 2023\. Pygments: Python syntax highlighter. https://pygments.org/ Version 2.15.1.  
\[23\]Robert Feldt, Sungmin Kang, Juyeon Yoon, and Shin Yoo. 2023\. Towards autonomous testing agents via conversational  
large language models. In2023 38th IEEE/ACM International Conference on Automated Software Engineering (ASE). IEEE,  
1688–1693.  
\[24\]Python Software Foundation. 2024\. Python Documentation. https://docs.python.org/3/contents.html Accessed:  
2024-10-29.  
\[25\]Dávid Hidvégi, Khashayar Etemadi, Sofia Bobadilla, and Martin Monperrus. 2024\. Cigar: Cost-efficient program repair  
with llms.arXiv preprint arXiv:2402.06598(2024).

ISSTA002:22 L. Guo, W. Tao, R. Jang, Y. Wang, J. Chen, X. Liu, Y. Ma, M. Mao, H. Zhang, Z. Zheng

\[26\]Yanxian Huang, Wanjun Zhong, Ensheng Shi, Min Yang, Jiachi Chen, Hui Li, Yuchi Ma, Qianxiang Wang, Zibin Zheng,  
and Yanlin Wang. 2024\. Agents in Software Engineering: Survey, Landscape, and Vision.arXiv preprint arXiv:2409.09030  
(2024).  
\[27\]Carlos E Jimenez, John Yang, Alexander Wettig, Shunyu Yao, Kexin Pei, Ofir Press, and Karthik Narasimhan. 2023\.  
Swe-bench: Can language models resolve real-world github issues?arXiv preprint arXiv:2310.06770(2023).  
\[28\]James A Jones and Mary Jean Harrold. 2005\. Empirical evaluation of the tarantula automatic fault-localization technique.  
InProceedings of the 20th IEEE/ACM international Conference on Automated software engineering. 273–282.  
\[29\]Junwei Liu, Kaixin Wang, Yixuan Chen, Xin Peng, Zhenpeng Chen, Lingming Zhang, and Yiling Lou. 2024\. Large  
language model-based agents for software engineering: A survey.arXiv preprint arXiv:2409.02977(2024).  
\[30\]Jiawei Liu, Chunqiu Steven Xia, Yuyao Wang, and Lingming Zhang. 2024\. Is your code generated by chatgpt really  
correct? rigorous evaluation of large language models for code generation.Advances in Neural Information Processing  
Systems36 (2024).  
\[31\]Yizhou Liu, Pengfei Gao, Xinchen Wang, Chao Peng, and Zhao Zhang. 2024\. MarsCode Agent: AI-native Automated  
Bug Fixing.arXiv preprint arXiv:2409.00899(2024).  
\[32\]Yiling Lou, Ali Ghanbari, Xia Li, Lingming Zhang, Haotian Zhang, Dan Hao, and Lu Zhang. 2020\. Can automated  
program repair refine fault localization? a unified debugging approach. InProceedings of the 29th ACM SIGSOFT  
International Symposium on Software Testing and Analysis. 75–87.  
\[33\]Yingwei Ma, Qingping Yang, Rongyu Cao, Binhua Li, Fei Huang, and Yongbin Li. 2024\. How to Understand Whole  
Software Repository?arXiv preprint arXiv:2406.01422(2024).  
\[34\]Mozilla Developer Network (MDN). 2024\. JavaScript Documentation. https://developer.mozilla.org/en-US/docs/Web/  
JavaScript Accessed: 2024-10-29.  
\[35\]Microsoft. 2024\. TypeScript Handbook. https://www.typescriptlang.org/docs/handbook/intro.html Accessed:  
2024-10-29.  
\[36\]NUS APR. 2024\. AutoCodeRover Configuration Example. https://github.com/nus-apr/auto-code-rover/blob/main/  
conf/example.conf Accessed: 2025-01-02.  
\[37\] Openai. 2024\. gpt-4o. https://platform.openai.com/docs/models.  
\[38\]OpenAI. 2024\. SWE-bench Verified: A Human-Validated Subset for AI Model Evaluation. https://openai.com/index/  
introducing-swe-bench-verified. Accessed: 2024-10-21.  
\[39\]Oracle. 2024\. The Java Tutorials \- Inheritance and Interfaces. https://docs.oracle.com/javase/tutorial/java/IandI/  
Accessed: 2024-10-29.  
\[40\]Siru Ouyang, Wenhao Yu, Kaixin Ma, Zilin Xiao, Zhihan Zhang, Mengzhao Jia, Jiawei Han, Hongming Zhang, and  
Dong Yu. 2024\. RepoGraph: Enhancing AI Software Engineering with Repository-level Code Graph.arXiv preprint  
arXiv:2410.14684(2024).  
\[41\]Jiayi Pan, Xingyao Wang, Graham Neubig, Navdeep Jaitly, Heng Ji, Alane Suhr, and Yizhe Zhang. 2024\. Training  
Software Engineering Agents and Verifiers with SWE-Gym.arXiv preprint arXiv:2412.21139(2024).  
\[42\]Ruchir Puri, David S Kung, Geert Janssen, Wei Zhang, Giacomo Domeniconi, Vladimir Zolotov, Julian Dolby, Jie Chen,  
Mihir Choudhury, Lindsey Decker, et al.2021. Codenet: A large-scale ai for code dataset for learning a diversity of  
coding tasks.arXiv preprint arXiv:2105.12655(2021).  
\[43\]Haifeng Ruan, Yuntong Zhang, and Abhik Roychoudhury. 2024\. SpecRover: Code Intent Extraction via LLMs.arXiv  
preprint arXiv:2408.02232(2024).  
\[44\]Wei Tao, Yanlin Wang, Ensheng Shi, Lun Du, Shi Han, Hongyu Zhang, Dongmei Zhang, and Wenqiang Zhang. 2021\.  
On the Evaluation of Commit Message Generation Models: An Experimental Study. InICSME. IEEE, 126–136.  
\[45\]Wei Tao, Yanlin Wang, Ensheng Shi, Lun Du, Shi Han, Hongyu Zhang, Dongmei Zhang, and Wenqiang Zhang. 2022\. A  
large-scale empirical study of commit message generation: models, datasets and evaluation.Empir. Softw. Eng.27, 7  
(2022), 198\.  
\[46\]Wei Tao, Yucheng Zhou, Yanlin Wang, Hongyu Zhang, Haofen Wang, and Wenqiang Zhang. 2024\. KADEL: Knowledge-  
Aware Denoising Learning for Commit Message Generation.ACM Trans. Softw. Eng. Methodol.33, 5 (2024), 133:1–133:32.  
\[47\]Wei Tao, Yucheng Zhou, Yanlin Wang, Wenqiang Zhang, Hongyu Zhang, and Yu Cheng. 2024\. MAGIS: LLM-Based  
Multi-Agent Framework for GitHub Issue Resolution.arXiv preprint arXiv:2403.17927(2024).  
\[48\]DeepSeek Team. 2024\. DeepSeek-V2.5: Advanced Open-Source Large Language Model. https://www.deepseek.com/.  
Accessed: 2024-11-01.  
\[49\] Linus Torvalds et al. \[n. d.\].Git. https://git-scm.com/  
\[50\]Xingyao Wang, Boxuan Li, Yufan Song, Frank F Xu, Xiangru Tang, Mingchen Zhuge, Jiayi Pan, Yueqi Song, Bowen Li,  
Jaskirat Singh, et al.2024. Opendevin: An open platform for ai software developers as generalist agents.arXiv preprint  
arXiv:2407.16741(2024).  
\[51\]W Eric Wong, Ruizhi Gao, Yihao Li, Rui Abreu, and Franz Wotawa. 2016\. A survey on software fault localization.IEEE  
Transactions on Software Engineering42, 8 (2016), 707–740.

OmniGIRL: A Multilingual and Multimodal Benchmark for GitHub Issue Resolution ISSTA002:23

\[52\]Chunqiu Steven Xia, Yinlin Deng, Soren Dunn, and Lingming Zhang. 2024\. Agentless: Demystifying llm-based software  
engineering agents.arXiv preprint arXiv:2407.01489(2024).  
\[53\]Chunqiu Steven Xia, Yuxiang Wei, and Lingming Zhang. 2023\. Automated program repair in the era of large pre-trained  
language models. In2023 IEEE/ACM 45th International Conference on Software Engineering (ICSE). IEEE, 1482–1494.  
\[54\]Chunqiu Steven Xia and Lingming Zhang. 2023\. Keep the Conversation Going: Fixing 162 out of 337 bugs for $0.42  
each using ChatGPT.arXiv preprint arXiv:2304.00385(2023).  
\[55\]Weixiang Yan, Haitian Liu, Yunkun Wang, Yunzhe Li, Qian Chen, Wen Wang, Tingyu Lin, Weishan Zhao, Li Zhu,  
Shuiguang Deng, et al.2023. Codescope: An execution-based multilingual multitask multidimensional benchmark for  
evaluating llms on code understanding and generation.arXiv preprint arXiv:2311.08588(2023).  
\[56\]Weixiang Yan, Yuchen Tian, Yunzhe Li, Qian Chen, and Wen Wang. 2023\. Codetransocean: A comprehensive  
multilingual benchmark for code translation.arXiv preprint arXiv:2310.04951(2023).  
\[57\]John Yang, Carlos E Jimenez, Alexander Wettig, Kilian Lieret, Shunyu Yao, Karthik Narasimhan, and Ofir Press. 2024\.  
Swe-agent: Agent-computer interfaces enable automated software engineering.arXiv preprint arXiv:2405.15793(2024).  
\[58\]Hao Yu, Bo Shen, Dezhi Ran, Jiaxin Zhang, Qi Zhang, Yuchi Ma, Guangtai Liang, Ying Li, Qianxiang Wang, and Tao  
Xie. 2024\. Codereval: A benchmark of pragmatic code generation with generative pre-trained models. InProceedings  
of the 46th IEEE/ACM International Conference on Software Engineering. 1–12.  
\[59\]Daoguang Zan, Zhirong Huang, Ailun Yu, Shaoxin Lin, Yifan Shi, Wei Liu, Dong Chen, Zongshuai Qi, Hao Yu, Lei Yu,  
et al. 2024\. SWE-bench-java: A GitHub Issue Resolving Benchmark for Java.arXiv preprint arXiv:2408.14354(2024).  
\[60\]Jiarui Zhang, Yicheng Luo, Yutao Xu, et al.2023. HumanEval-X: Extending HumanEval to Evaluate Code Generation  
in Multilingual Contexts.arXiv preprint arXiv:2303.17568(2023). https://arxiv.org/abs/2303.17568  
\[61\]Kexun Zhang, Weiran Yao, Zuxin Liu, Yihao Feng, Zhiwei Liu, Rithesh Murthy, Tian Lan, Lei Li, Renze Lou, Jiacheng  
Xu, et al.2024. Diversity empowers intelligence: Integrating expertise of software engineering agents.arXiv preprint  
arXiv:2408.07060(2024).  
\[62\]Lyuye Zhang, Kaixuan Li, Kairan Sun, Daoyuan Wu, Ye Liu, Haoye Tian, and Yang Liu. 2024\. Acfix: Guiding llms with  
mined common rbac practices for context-aware repair of access control vulnerabilities in smart contracts.arXiv  
preprint arXiv:2403.06838(2024).  
\[63\]Yuntong Zhang, Haifeng Ruan, Zhiyu Fan, and Abhik Roychoudhury. 2024\. Autocoderover: Autonomous program  
improvement. InProceedings of the 33rd ACM SIGSOFT International Symposium on Software Testing and Analysis.  
1592–1604.  
\[64\]Dewu Zheng, Yanlin Wang, Ensheng Shi, Hongyu Zhang, and Zibin Zheng. 2024\. How Well Do LLMs Generate Code  
for Different Application Domains? Benchmark and Evaluation.arXiv preprint arXiv:2412.18573(2024).  
\[65\]Dewu Zheng, Yanlin Wang, Ensheng Shi, Ruikai Zhang, Yuchi Ma, Hongyu Zhang, and Zibin Zheng. 2024\. Towards more  
realistic evaluation of LLM-based code generation: an experimental study and beyond.arXiv preprint arXiv:2406.06918  
(2024).  
\[66\]Qinkai Zheng, Xiao Xia, Xu Zou, Yuxiao Dong, Shan Wang, Yufei Xue, Lei Shen, Zihan Wang, Andi Wang, Yang Li,  
et al.2023. Codegeex: A pre-trained model for code generation with multilingual benchmarking on humaneval-x. In  
Proceedings of the 29th ACM SIGKDD Conference on Knowledge Discovery and Data Mining. 5673–5684.  
\[67\]Zibin Zheng, Kaiwen Ning, Jiachi Chen, Yanlin Wang, Wenqing Chen, Lianghong Guo, and Weicheng Wang. 2023\. To-  
wards an understanding of large language models in software engineering tasks (2023).arXiv preprint arXiv:2308.11396  
(2023).

Received 2024-10-31; accepted 2025-03-31


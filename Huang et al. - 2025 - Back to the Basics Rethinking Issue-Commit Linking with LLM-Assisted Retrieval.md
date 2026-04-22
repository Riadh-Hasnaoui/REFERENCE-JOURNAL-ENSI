\#\# Back to the Basics:

\#\# Rethinking Issue-Commit Linking with LLM-Assisted Retrieval

\#\# Huihui Huang♦, Ratnadira Widyasari♦, Ting Zhang♥, Ivana Clairine Irsan♦, Jieke Shi♦, Han Wei

\#\# Ang♠, Frank Liauw♠, Eng Lieh Ouh♦, Lwin Khin Shar♦, Hong Jin Kang♣, and David Lo♦

\#\#\# ♦School of Computing and Information Systems, Singapore Management University, Singapore

\#\#\# ♥Faculty of Information Technology, Monash University, Australia

\#\#\# ♠GovTech, Singapore

\#\#\# ♣School of Computer Science, University of Sydney, Australia

\#\#\# {hhhuang, ratnadiraw.2020, ivanairsan, jiekeshi, elouh, lkshar, davidlo}@smu.edu.sg

\#\#\# ting.zhang@monash.edu, {ang\_han\_wei, frank\_liauw}@tech.gov.sg, hongjin.kang@sydney.edu.au

\#\# Abstract

\`\`\`  
Issue-commit linking, which connects issues with commits that fix  
them, is crucial for software maintenance. Existing approaches have  
shown promise in automatically recovering these links. Evaluations  
of these techniques assess their ability to identify genuine links  
from plausible but false links. However, these evaluations overlook  
the fact that, in reality, when a repository has more commits, the  
presence of more plausible yet unrelated commits may interfere  
with the tool in differentiating the correct fix commits. To address  
this, we propose the Realistic Distribution Setting (RDS) and use it to  
construct a more realistic evaluation dataset that includes 20 open-  
source projects. By evaluating tools on this dataset, we observe  
that the performance of the state-of-the-art deep learning-based  
approach drops by more than half, while the traditional Information  
Retrieval method, VSM, outperforms it.  
Inspired by these observations, we propose EasyLink, which  
utilizes a vector database as a modern Information Retrieval tech-  
nique. To address the long-standing problem of the semantic gap  
between issues and commits, EasyLink leverages a large language  
model to rerank the commits retrieved from the database. Under our  
evaluation, EasyLink achieves an average Precision@1 of 75.03%,  
improving over the state-of-the-art by over four times. Additionally,  
this paper provides practical guidelines for advancing research in  
issue-commit link recovery.  
\`\`\`  
\#\# Keywords

\`\`\`  
Issue-Commit Link Recovery, Software Traceability  
ACM Reference Format:  
Huihui Huang♦, Ratnadira Widyasari♦, Ting Zhang♥, Ivana Clairine Irsan♦,  
Jieke Shi♦, Han Wei Ang♠, Frank Liauw♠, Eng Lieh Ouh♦, Lwin Khin Shar  
♦, Hong Jin Kang♣, and David Lo♦. 2026\. Back to the Basics: Rethinking  
Issue-Commit Linking with LLM-Assisted Retrieval. In 2026 IEEE/ACM 48th  
International Conference on Software Engineering (ICSE ’26), April 12–18,  
\`\`\`  
\`\`\`  
†Jieke Shi and Ting Zhang are the corresponding authors.  
\`\`\`  
\`\`\`  
Permission to make digital or hard copies of all or part of this work for personal or  
classroom use is granted without fee provided that copies are not made or distributed  
for profit or commercial advantage and that copies bear this notice and the full citation  
on the first page. Copyrights for third-party components of this work must be honored.  
For all other uses, contact the owner/author(s).  
ICSE ’26, Rio de Janeiro, Brazil  
© 2026 Copyright held by the owner/author(s).  
ACM ISBN 979-8-4007-2025-3/26/  
https://doi.org/10.1145/3744916.  
\`\`\`  
\`\`\`  
2026, Rio de Janeiro, Brazil. ACM, New York, NY, USA, 13 pages. https:  
//doi.org/10.1145/3744916.  
\`\`\`  
\#\# 1 Introduction

\`\`\`  
Software traceability involves establishing relationships between  
different software artifacts and is essential for safety-critical sys-  
tems \[ 9 , 10 \]. A critical task in this domain is issue-commit linking,  
which connects issues, i.e., bug reports, to the commits that resolve  
them \[ 28 \], playing a vital role in software provenance. It also plays  
a key role for developers in assessing security risks \[ 30 , 41 , 42 \] and  
gaining deeper insights about security flaws \[37, 69\].  
Prior studies \[ 3 , 53 \] have revealed that many issue-commit links  
can be missing during the development of large-scale projects. Man-  
ually recovering these links is not only time-consuming but error-  
prone, even for experienced developers \[54\].  
To address this, several studies \[ 14 , 31 , 49 , 54 , 63 , 72 \] have pro-  
posed learning-based approaches to automatically recover issue-  
commit links, achieving strong performance on datasets collected  
from open-source repositories.  
The evaluation method requires the tool to distinguish fix com-  
mits (i.e., “true links”) from plausible but non-fix commits (i.e., “false  
links”). However, prior studies’ evaluations often lack realism.❶  
Some studies use an unrealistic time window to select commits. For  
example, studies \[ 4 , 40 , 54 , 64 \] rely on a narrow 7-day time window  
to select potential fix commits, which may miss many true links.  
Another example involves studies \[ 14 , 49 \] that require the issue  
close time to select commits, but in practice, when commits are  
missing, the issue may not have a close time.❷Another limitation  
is the unrealistic false link distributions in prior evaluation datasets.  
Some \[ 31 , 54 \] use evaluation datasets where the number of false  
and true links is equal, an unrealistic assumption since false links  
far outnumber true links in reality \[ 14 \]. Recently, Zhang et al. \[ 72 \]  
addressed this issue by using an imbalanced dataset with a fixed  
number of false links per issue. Still, this method overlooks a cru-  
cial factor: a higher commit frequency results in a larger pool of  
plausible commits for the tool to differentiate from the actual fix  
commit, making the task inherently more difficult.  
Therefore, we propose to construct a more realistic evaluation  
dataset under the Realistic Distribution Setting (RDS). We began  
with an in-depth analysis of the issues and commits from open-  
source repositories used in prior studies \[ 14 , 31 , 36 , 72 \]. According  
to our observation, after fetching all commits in each repository,  
approximately 97% of fix commits were made within one year  
\`\`\`  
\# arXiv:2507.09199v3 \[cs.SE\] 6 Oct 2025

\`\`\`  
ICSE ’26, April 12–18, 2026, Rio de Janeiro, Brazil Huang et al.  
\`\`\`  
from issue creation. These findings suggest that, in practice, the  
corresponding fix commit for an issue is likely to be found among  
the commits made within one year after the issue’s creation. We  
thus include the genuinely linked commit as the true link and  
consider all non-fix commits made within one year of an issue’s  
creation as candidate commits linked to the given issue as false  
links when constructing evaluation datasets.  
After collecting issues and commits from 20 open-source projects  
analyzed in prior studies \[ 14 , 31 , 36 , 72 \], we first successfully repli-  
cate the performance of the state-of-the-art method, EALink \[ 72 \],  
using the original evaluation method they reported. However, when  
we switched the experimental setup to the Realistic Distribution  
Setting, we find that the average Precision@1 of EALink dropped  
to 14.43%, surprisingly underperforming the Vector Space Model  
(VSM) \[ 1 \], a traditional Information Retrieval (IR) technique, which  
achieves a Precision@1 of 46.59%, suggesting that there is great  
room for improving issue-commit linking using IR techniques.  
Meanwhile, as recent years have witnessed huge advances in the  
IR field, modern IR techniques that use embedding models to cap-  
ture semantic-level similarities have demonstrated better perfor-  
mance than those traditional techniques evaluated in previous stud-  
ies \[ 14 , 31 , 72 \] that measure token-level textual similarities, such as  
VSM \[ 1 \] and Latent Semantic Indexing (LSI) \[ 35 \]. This also presents  
an opportunity to boost issue-commit linking performance and  
motivates our paper.  
In this paper, we propose EasyLink, a novel method that inte-  
grates modern IR techniques and Large Language Models (LLMs)  
to enhance issue-commit linking performance in realistic settings  
by capturing deeper semantic relationships between issues and  
commits. EasyLink operates in two stages. The first stage fetches a  
set of commits that share similarities to a given issue, and the sec-  
ond stage reranks them by their relevance to the issue. Concretely,  
in the first stage, EasyLink leverages recent advances in Informa-  
tion Retrieval by using a modern vector database (optimized for  
high-dimensional similarity search) \[ 15 \] to fetch the most similar  
commits for each issue. In the second stage, EasyLink prompts an  
LLM (GPT-4o \[ 44 \]) to rerank the results. We use LLMs for their  
strong ability to capture the semantic relationship between issues  
and commits, bridging the semantic gap, as the most similar commit  
does not guarantee that it is the fix for the issue \[ 14 , 31 , 72 \]. Ea-  
syLink achieves an average Precision@1 of 75.03%, outperforming  
EALink \[ 72 \] by four times in our realistic datasets and by more  
than 30% in Precision@1 on EALink’s original evaluation setup. We  
also conduct an ablation analysis on each of EasyLink’s two stages.  
Our results demonstrate that advances in IR, such as context-aware  
dense embeddings \[ 39 , 60 , 67 \] and efficient vector search \[ 15 , 65 \],  
have been largely overlooked in the software traceability literature.  
Notably, even the out-of-the-box use of a vector database achieves  
a high average Precision@1 of 61.57%. Additionally, the strong per-  
formance of the reranking step, which improves Precision@1 by  
13.46%, highlights the capability of LLMs to bridge the semantic  
gap between issues and commits \[ 22 , 49 \]. Finally, we discuss the  
lessons learned from our work, such as the need to consider mod-  
ern IR baselines, for future research on software traceability. Our  
implementation has been made available at \[45\].  
This paper makes the following contributions:

\`\`\`  
(1)Constructing a more realistic evaluation dataset: To achieve  
a more realistic evaluation, we propose the Realistic Distribution  
Setting (RDS), which adjusts the number of candidate commits  
for generating false links according to the quantity of commits  
in the repository. This results in a dataset that more accurately  
reflects real-world practices.  
(2)A comprehensive evaluation benchmark: We include the  
datasets from recent studies \[ 14 , 31 , 36 , 72 \]. Our benchmark  
includes 9,319 issues from 20 projects, with an average of 1,  
false links constructed per issue. To the best of our knowledge,  
this dataset is the largest in the literature.  
(3)Reevaluation of the state-of-the-art approach: After suc-  
cessfully replicating the strong performance of EALink \[ 72 \],  
the state-of-the-art approach, we switched the evaluation pro-  
cedure under RDS, which offers a greater challenge due to a  
higher number of false links. On the same set of projects used  
in the evaluation of EALink, its average Precision@1 of 53.67%  
decreases to 28.05%, underperforming traditional IR baselines.  
(4)A new state-of-the-art for issue-commit linking: We pro-  
pose EasyLink, which leverages modern IR techniques, includ-  
ing an off-the-shelf database FAISS \[ 15 \], and addresses the prob-  
lem of semantic gap \[ 22 , 49 \] by prompting an LLM to rerank the  
retrieved results. In our evaluation, EasyLink improves over  
EALink in average Precision@1 from 14.43% to 75.03%.  
The rest of the paper is organized as follows. Section 2 outlines  
the background of this work, including the limitations of exist-  
ing work. Section 3 details the evaluation dataset construction  
under the Realistic Distribution Setting (RDS). Section 4 introduces  
EasyLink. Section 5 describes the experimental setup. Section 6  
presents the experimental results. Section 7 revisits the classical  
baseline, discusses the lessons learned and threats to validity. Sec-  
tion 8 reviews related work. Finally, Section 9 concludes the paper.  
\`\`\`  
\#\# 2 Background

\#\# 2.1 Issue-Commit Linking Recovery

\`\`\`  
Issue-commit links play an essential role in maintaining software  
traceability, supporting critical tasks such as impact analysis \[ 2 , 24 ,  
47 \], regression testing \[ 38 \], and project management \[ 46 \]. Due to  
the high cost of manually maintaining these links, they are often  
incomplete \[ 26 \], highlighting the need for automated methods.  
Automatic issue-commit linking considers a large set of commits  
that are made in the period after each issue’s creation and identifies  
the right commits that address the issue. Figure 1 shows an example  
that demonstrates the challenge of automatically linking issues to  
commits. It presents an issue along with two commits. The first  
commit shares more matched words and has the highest similarity  
to the issue, but it is not the fix, while the second commit is the  
correct fix commit. An issue-commit linker that considers keyword  
counts would incorrectly prioritize the first commit as there are a  
greater number of matches of the keywordnb-javac. While both  
commits mentionnb-javac, the top-ranked commit updates the  
JAR for JDK-12, whereas the issue specifies that nb-javac 11 should  
be upgraded, tested, and deployed. This highlights two challenges.  
First, it shows the need for approaches that go beyond surface-  
level similarities. Second, it demonstrates the sensitivity of the  
\`\`\`

Rethinking Issue-Commit Linking with LLM-Assisted Retrieval ICSE ’26, April 12–18, 2026, Rio de Janeiro, Brazil

\`\`\`  
An example of an issue, the incorrectly top-ranked  
commit, and the correct commit.  
\`\`\`  
\`\`\`  
The input issue, with summary and description, is shown  
below.  
Issue ID: NETBEANS-  
\`\`\`  
\`\`\`  
Summary:  
nb-javac 11 upgrade in NetBeans  
Description:  
Should cover below tasks in NetBeans \- nb-javac 11 testing :  
\`\`\`  
\- Run tests for modules java.completion, java.editor,  
    java.editor.base, java.hints, java.source,  
    java.source.base, lib.nbjavac  
\- Update libs.javacimpl and libs.javacapi jars, upload updated  
    nb-javac jars  
\- Upload nb-javac module jars in update center

\`\`\`  
The top-ranked commit message in the initial results is  
shown below but is incorrect.  
Commit ID: 4fd115aeae3b8423de9ced22d52914e60a1c5800.  
\`\`\`  
\`\`\`  
Updation for external nb-javac jar in libs.javacapi and  
libs.javaimpl modules with nb-javac jar for jdk-  
\`\`\`  
\`\`\`  
The correct commit message is shown below.  
Commit ID: 3055661e4dd1c7d587012c917cbec31b27ae9e  
\`\`\`  
\`\`\`  
Uptake nb-javac 11 jars for java tests runtime  
\`\`\`  
Figure 1: Example of an issue with the incorrect top-ranked  
commit and the correct commit. An issue-commit linking  
approach has to bridge the semantic gap and distinguish the  
correct commit from similar ones in a potentially large set.

evaluations of their effectiveness to the number of commits that  
share keywords or resemble the ground-truth commit.  
Many automatic issue-commit link recovery methods have been  
proposed. Some studies employ traditional feature- and rule-based  
methods \[ 4 , 40 , 57 , 68 \], which rely on predefined heuristics such as  
keyword matching or the recency of the commits. However, these  
heuristics tend to be inadequate \[ 5 \]. Some approaches \[ 29 , 36 , 49 , 63 ,  
64 \] adopt traditional machine learning techniques, such as support  
vector machines, to reduce the reliance on manual rules. Recently,  
deep learning methods \[ 22 , 54 , 70 \] have demonstrated improved  
performance. A key challenge of the task is the semantic gap that  
exists between issues and commits \[ 14 , 31 , 72 \]. Prior work \[ 31 \]  
attempted to address this issue using BERT-based methods, such  
as CodeBERT \[ 17 \], which leverage contextual understanding. The  
state-of-the-art method, EALink \[72\], employs knowledge distilla-  
tion to transfer knowledge to a smaller model and utilizes multi-task  
learning to improve both accuracy and efficiency.

\#\# 2.2 Limitations in Evaluation

The experiments in prior studies evaluate approaches based on their  
ability to distinguish the true link from false links constructed using  
other commits. However, these studies use unrealistic methods to  
construct false links and the evaluation dataset.

\`\`\`  
Unrealistic Time Window Selection: Some works \[ 4 , 40 , 54 ,  
64 \] assume that fix commits fall within a 7-day time window before  
or after the issue’s create/update/close time or the comment create  
time, treating all other commits in this period as non-fix commits.  
However, this approach is inadequate when fixes take a longer  
time, requiring tools to distinguish the correct fix commit from  
more plausible commits. From our preliminary analysis of selected  
projects, we found that only 59% of issues had a corresponding  
fix commit within seven days of their creation. Additionally, some  
works \[ 14 , 49 \] require the issue’s close time to select commits. Under  
a practical scenario, the issue fix/close date is unknown—precisely  
also why issue-commit recovery is necessary—and approaches need  
to distinguish the fix commit while the issue remains open. There-  
fore, selecting commits based on the issue’s fix/close date may also  
lack realism.  
Unrealistic False Link Distribution: When constructing the  
evaluation dataset, some works \[31, 36, 54\] use a balanced dataset  
(i.e., an equal number of false links and true links) to evaluate  
their tools. This evaluation setting is unrealistic because, in reality,  
false links outnumber true links \[ 14 \]. Zhang et al. \[ 72 \] address the  
balanced dataset limitation by constructing a fixed number of 99  
false links per issue. While this results in more false links than  
true links, it still overlooks that the number of potentially linked  
commits depends on the number of commits made in the same time  
period as the ground-truth link. Moreover, as shown in Figure 2,  
when sampling unrelated commits to construct the false links, prior  
work \[ 72 \] only selects commits from other ground-truth links. In  
other words, they construct false links for an issue by connecting  
it only to other commits that are already linked to other issues. In  
practice, an approach has to consider all commits from the same  
time period, regardless of whether they are linked to specific issues.  
This is a superset of commits compared to the ground-truth links.  
In Section 3, we show that the number of commits made within a  
one-year time frame is at least 80% larger than the constant number  
of 99 commits considered by Zhang et al. \[ 73 \]. As a result, the  
evaluation setups of prior work may not adequately reflect how  
these approaches would be used in practice.  
\`\`\`  
\#\# 3 Evaluation Dataset Construction Under the

\#\# Realistic Distribution Setting

\`\`\`  
This section describes our new evaluation setting, Realistic Distri-  
bution Setting (RDS), for constructing a more realistic evaluation  
dataset. By adaptively constructing false links for an issue based on  
the commits in the period after each issue creation, aligning with  
the repository’s development activity, our method addresses the  
limitations of prior evaluations.  
We combine datasets from four recent studies \[ 14 , 31 , 36 , 72 \]  
into a unified benchmark covering 20 projects, ensuring broader  
coverage and a consistent benchmark for comparison. Evaluations  
in the previous studies \[ 31 , 36 , 72 \] did not use a shared benchmark,  
and each of their datasets had only up to 12 projects \[ 36 \]. Our  
dataset fills the need for a large, shared benchmark.  
\`\`\`  
\#\# 3.1 Ground Truth Dataset Selection

\`\`\`  
We selected datasets from four recent studies, covering 20 open-  
source software projects over a span of 20 years. These datasets  
\`\`\`

\`\`\`  
ICSE ’26, April 12–18, 2026, Rio de Janeiro, Brazil Huang et al.  
\`\`\`  
\`\`\`  
Issue Commit Label  
\!\! "\! 1  
\!\! "" 1  
\#\# $$ 1  
\#$ $% 1  
\`\`\`  
\`\`\`  
Commit  
$&  
$'  
$(  
$)  
\`\`\`  
\`\`\`  
Issue Commit Label  
\#\* $$ 0  
\#\* $% 0  
A total of 99 false links per issue.  
\`\`\`  
\`\`\`  
Commit  
C\_  
C\_  
C\_  
In total 99 sampled  
commits  
\`\`\`  
\`\`\`  
Commits in the Real-world  
Repository  
\`\`\`  
\`\`\`  
True Links in the Dataset  
The tool distinguishes the  
fix commit from linked  
commits and considers  
only 99 false links per issue  
in the evaluation dataset.  
\`\`\`  
\`\`\`  
The tool distinguishes the  
fix commit from more  
plausible commits in the  
real-world repository, with  
false links constructed  
based on the true  
distribution of commits  
within the same time  
frame.  
\`\`\`  
\`\`\`  
Commit  
"\!  
""  
$$  
$%  
\`\`\`  
\`\`\`  
Sample commits for I\_  
\`\`\`  
\`\`\`  
Prior work on false links  
construction for \#\*  
\`\`\`  
\`\`\`  
Issue Commit Label  
\#\* $$ 0  
\#\* $% 0  
\#\* $& 0  
\#\* $' 0  
\#\* $( 0  
\#\* $) 0  
More false links if the repository  
has a higher commit frequency.  
\`\`\`  
\`\`\`  
RDS false links  
construction for \#\*  
\`\`\`  
Figure 2: Illustration of the evaluation limitation in prior  
work.𝐶 1 and𝐶 2 are the fix commits of issue𝐼 1\. False links will  
be constructed for𝐼 1 .𝐶 3 and𝐶 4 are commits already linked  
to the issue in the true links dataset.𝐶𝑎,𝐶𝑏,𝐶𝑐, and𝐶𝑑are  
commits present in the repository but not in the true links  
dataset, and they are ensured not to be the fix commit of 𝐼 1\.

\`\`\`  
use explicit issue tags (e.g., “\#123”, “JIRA-456”) in commit messages  
to construct the true links. We include the same issues and true  
links from these datasets, resulting in a total of 9,319 issues in  
the benchmark. For datasets with incomplete information detected  
through a manual check, we re-fetched the necessary data, such  
as issue comments, code diffs, and committed files (i.e., the source  
code files after applying the commits).  
\`\`\`  
\- From Zhang et al.’s dataset \[ 72 \], we include the issues from  
    all six projects, Ambari, Calcite, Groovy, Ignite, Isis, and Netbeans,  
    in our benchmark.  
\- From Dong et al.’s dataset \[ 14 \], we include the issues from five  
    projects, Pig, Maven, Infinispan, Drools, and Derby. This dataset  
    also includes Groovy, which is already included in our benchmark  
    from Zhang et al.’s dataset \[ 72 \]. As they were missing issue  
    comments, code diffs, and committed files, we refetched these  
    data.  
\- From Lin et al.’s dataset \[ 31 \], we include the issues from all  
    three projects: Pgcli, Flask, and Keras. As the issue comments and  
    committed files were missing, we refetched them.  
\- From Mazrae et al.’s dataset \[ 36 \], we include the issues from  
    six projects, Beam, Flink, Freemarker, Airflow, Arrow, and Cassan-  
    dra, out of 12 projects. The six other projects from this dataset  
    are already included in Zhang et al.’s dataset \[ 72 \]. As this dataset  
    provides only postprocessed data, we re-fetched the original  
    issue summaries, issue descriptions, issue comments, commit  
    messages, code diffs, and committed files.

\#\# 3.2 Preparing Commits

\`\`\`  
For constructing false links, the set of all commits in each repository  
is required. First, we clone the GitHub repository locally, which  
enables faster access to commit data without API requests. From the  
cloned repository, all commit IDs are obtained using thegit log  
command. Each commit is then processed to retrieve its metadata,  
including the parent commit IDs, author, committer, commit time,  
and commit message, usinggit show. Additionally, the list of  
\`\`\`  
\`\`\`  
Algorithm 1: False Links Construction under RDS  
Input: test\_set\_true\_links⊲ Contains true issue-commit  
pairs labeled as 1  
Input: commits\_pool⊲ Contains all fetched commits  
(Subsection 3.2)  
Result: evaluation\_dataset  
1 Function EvalSetGen(test\_set\_true\_links, commits\_pool):  
2 evaluation\_dataset←∅  
3 sampled\_issue\_id\_list←  
test\_set\_true\_links\[issue\_id\].unique()\[:1000\]  
4 for each issue\_id in sampled\_issue\_id\_list do  
5 true\_links← test\_set\_true\_links\[issue\_id\]  
6 issue← true\_links\[0\].issue\_info  
7 candidate\_commits← { commit∈ commits\_pool|  
8 commit.time≥ issue.create\_time and  
9 commit.time≤ issue.create\_time \+ 𝜖 and  
10 commit≠ issue.fix\_commit }  
11 false\_links← {(issue, commit, label=0)|  
12 commit∈ candidate\_commits }  
13 evaluation\_dataset.append(false\_links)  
14 evaluation\_dataset.append(true\_links)  
15 return evaluation\_dataset  
\`\`\`  
\`\`\`  
modified file paths for each commit is identified, and their content  
at the specific commit state is retrieved. The corresponding code  
diffs are also extracted and stored. Table 1 presents the number of  
commits fetched for each project in the column “\#Commits”.  
The following information is fetched during the process:  
\`\`\`  
\- Commit ID: A unique hash value assigned to each commit,  
    serving as its identifier.  
\- Parent Commit IDs: The hash(es) of the immediate predecessor  
    commit(s) of the current commit.  
\- Author: The person who originally wrote the changes.  
\- Committer: The person who applied the changes to the reposi-  
    tory.  
\- Commit Time: The commit’s creation timestamp.  
\- Commit Message: The description of the commit.  
\- Changed Files: List of paths of the files modified in the commit.  
\- Code Diffs: The changes introduced by the commit.  
\- Committed Files: Source code files after applying the commit.  
Note that while our work only requires the commit ID, commit  
time, and commit message, we collect all commit information since  
other approaches may utilize this additional data.

\#\# 3.3 Constructing False Links

\`\`\`  
For a more realistic evaluation dataset, the number of false links  
should match the actual number of commits that may be viable for  
linking to each issue in practice. For each issue in the evaluation  
dataset, under the Realistic Distribution Setting (RDS), false links  
will be adaptively constructed to better align with the repository’s  
level of activity. We include all commits submitted in the time  
window within which the true commit can appear. To determine  
the size of the time window, we perform an analysis and find that  
\`\`\`

\`\`\`  
Rethinking Issue-Commit Linking with LLM-Assisted Retrieval ICSE ’26, April 12–18, 2026, Rio de Janeiro, Brazil  
\`\`\`  
\`\`\`  
Vector Database Indexing and Retrieval(Sec. 4.1)  
Issue  
\`\`\`  
\`\`\`  
LLM-Assisted Reranking(Sec 4.2 )  
Prompt  
\`\`\`  
\`\`\`  
Reranked Results  
\`\`\`  
\`\`\`  
Rank Commit ID Similarity Score Label  
1 4fd115ae... 0.7069 0  
2 3055661e... 0.6843 1  
3 ...... ...... ......  
\`\`\`  
\`\`\`  
Rank Commit ID Label  
1 3055661e... 1  
2 4fd115ae... 0  
3 ...... ......  
\`\`\`  
\`\`\`  
Role: UserContent:  
Given the following issue summary and description:  
{Rerankissue\_textthe provided commits based on their relevance to the issue. Only }  
output the commit IDs in descending order of relevance, formatted as  
follows:  
\['1-{{commit\_id}}', '2-{{commit\_id}}', '3-{{commit\_id}}', ...\]  
Do not include any additional text or explanation in the output.  
Commits:  
Commit ID: {commit\_id}. Commit Message: {message}  
Commit ID: {commit\_id}. Commit Message: {message}  
...... (there should be 10 commits in total)  
Output:  
\['1-daa281...', '2-48135...', '3-984a8...', '...', '8-3acfa0...', '9-8f9bf9...', '10-610f68...'\]  
\`\`\`  
\`\`\`  
Issue ID NETBEANS- 803  
Summary nb-javac11 upgrade in NetBeans  
DescriptionShould cover below tasks in NetBeans \-  
nb-javac11 testing :  
\`\`\`  
\- Run tests for modules java ...

\`\`\`  
sentence-transformers  
/all-MiniLM-L6-v  
huggingface.co  
\`\`\`  
\`\`\`  
Commit ID 4fd115aeae3b8423d......  
Commit MessageCommit ID Updation17cbec31b27ae9e3......for nb-javacjar ......  
Commit MessageCommit ID Updation3055661e4dd1c7d58......for nb-javacjar ......  
Commit MessageUptake nb-javac11 jars for ...  
Commits  
\`\`\`  
\`\`\`  
0.12 \-0.45 0.78 ... 0\.  
\`\`\`  
\- 0.79 0.87 0.34 ... \-0.  
    0.87 \-0.45-0.34 ... 0\.  
    0.23 \-0.35 0.81 ... \-0.  
       Commits Embeddings

\`\`\`  
Issue Embedding  
\`\`\`  
\`\`\`  
FAISS  
Vector Database  
\`\`\`  
\`\`\`  
Initial Results  
\`\`\`  
\`\`\`  
Figure 3: Overview of EasyLink. EasyLink consists of two key steps—the first step utilizes a vector database to retrieve initial  
ranked results, and the second step prompts an LLM to rerank the results.  
\`\`\`  
\`\`\`  
approximately 97% of all issues have their ground truth commit  
submitted within one year of their creation (7-day time window:  
59%, 30-day time window: 77%, 6-month time window: 92%). This  
observation aligns with previous studies analyzing bug reports (e.g.,  
Rodrigues et al. \[ 51 \], Zhang et al. \[ 73 \]). Consequently, we apply a  
one-year time window to select candidate commits from the com-  
mits pool (as described in Subsection 3.2) for each issue. Specifically,  
for a true link denoted as𝑡𝑖={𝐼𝑖,𝐶𝑖}, where𝐼𝑖represents the issue  
and𝐶𝑖the commit in the true link, the candidate commit𝐶𝑗is  
determined using Equation 1\. If the commit time of𝐶𝑗is within  
one year after the creation time of𝐼𝑖, we treat𝐶𝑗as a candidate  
commit. By linking𝐶𝑗to𝐼𝑖, we generate the false link𝑓𝑖={𝐼𝑖,𝐶𝑗}.  
\`\`\`  
\`\`\`  
is\_candidate(𝐼𝑖,𝐶𝑗)=𝑐𝑟𝑒𝑎𝑡𝑒𝑑(𝐼𝑖) ≤ 𝑐𝑜𝑚𝑚𝑖𝑡𝑡𝑒𝑑(𝐶𝑗)  
∧ 𝑐𝑜𝑚𝑚𝑖𝑡𝑡𝑒𝑑(𝐶𝑗) ≤ 𝑐𝑟𝑒𝑎𝑡𝑒𝑑(𝐼𝑖)+𝜖,  
𝜖= one year.  
\`\`\`  
\#\#\#\# (1)

Algorithm 1 details the construction of the evaluation dataset.  
We first split the entire ground-truth dataset into training and test  
sets following a 4:1 ratio \[ 14 , 54 , 72 \]. The inputs to the algorithm are  
the true links from the test set and the commits pool for the project,  
which is prepared using the process described in Subsection 3.2.  
First, following the method used by EALink \[ 72 \], we randomly  
sample up to 1,000 unique issue IDs from the test set, forming  
the listsampled\_issue\_id\_list. If fewer than 1,000 unique issues are  
available, all issues are included. Then, for eachissue\_idin this list,  
we extract the true links for that issue from the test set. We use  
the term “links” (plural) because an issue may be linked to more  
than one commit \[ 72 \]. In line 6 of the algorithm, we extract only  
the issue information for the issue being processed (including issue  
ID, summary, description, etc.), denoted asissue. Next, as shown  
in lines 7 to 10 of the algorithm, we filter thecandidate\_commits  
to include all commits whose creation time is no earlier than the  
issue’s creation time and strictly earlier than one year after the  
issue’s creation time. Additionally, the commit should not be the fix  
commit of the issue. We then construct thefalse\_linksby pairing

\`\`\`  
Table 1: Statistics of the benchmark  
\`\`\`  
\`\`\`  
Project name \#Commits \#Unique issue\_id false links per issueAverage \# of  
Ambari★ 24809 1000 3978\.  
Calcite★ 5889 551 516\.  
Groovy★ 20862 1000 1064\.  
Ignite★ 28869 1000 2611\.  
Isis★ 24945 652 1265\.  
Netbeans★ 10501 159 1279\.  
Derby† 8040 43 363\.  
Drools† 16585 182 630\.  
Infinispan† 17078 399 1110\.  
Maven† 14685 61 377\.  
Pig† 3675 45 197\.  
Flask‡ 5353 151 357\.  
Keras‡ 11248 111 454\.  
Pgcli‡ 2364 105 356\.  
Airflow§ 27123 961 1882\.  
Arrow§ 16947 1000 2058\.  
Beam§ 43595 865 6096\.  
Cassandra§ 29867 25 2560\.  
Flink§ 35767 1000 3251\.  
Freemarker§ 2492 9 179\.  
Note: Each project is annotated with a superscript representing its original dataset  
source:★Zhang et al. \[72\],†Dong et al. \[14\],‡Lin et al. \[31\],§Mazrae et al. \[36\]  
\`\`\`  
\`\`\`  
theissuewith each commit incandidate\_commitsand labeling the  
pair as 0\. Finally, we append both thetrue\_linksand thefalse\_links  
for the issue to the evaluation dataset and then proceed to process  
the next issue. Note that this algorithm is executed separately for  
each project, as each project has its own test dataset and commits  
pool. Following prior work \[ 54 , 72 \], issue tags (e.g., “\#123”, “JIRA-  
456”) in the issue and commit text are removed to prevent potential  
data leakage.  
Table 1 shows the statistics of the evaluation dataset. The dataset  
includes the same issues as used in the evaluation of prior stud-  
ies \[ 14 , 31 , 36 , 72 \]. Each issue has an average of 1,530 false links,  
\`\`\`

\`\`\`  
ICSE ’26, April 12–18, 2026, Rio de Janeiro, Brazil Huang et al.  
\`\`\`  
with a minimum of 179 (Freemarker). In contrast, for each issue,  
EALink \[ 72 \] constructs a constant number of 99 false links per issue,  
which is substantially smaller than the number of commits within  
a one-year time frame from issue creation. Note that an issue may  
be fixed by one or more commits \[ 72 \]. In our evaluation dataset,  
17% of issues were fixed by multiple commits.

\#\# 4 The EasyLink Approach

\`\`\`  
This section details EasyLink. Figure 3 shows an overview of Ea-  
syLink, which consists of two stages: the first stage uses a vector  
database for scalable retrieval to fetch commits ranked by their  
similarity to the issue and the second stage prompts an LLM to  
rerank them by their relevance to the issue. We elaborate the key  
steps, vector database indexing and retrieval, and LLM-assisted  
reranking below.  
\`\`\`  
\#\# 4.1 Vector Database Indexing and Retrieval

The process begins by embedding the commit messages using  
an embedding tool, retaining the commit ID as metadata. Simi-  
larly, the issue summary and description are concatenated and  
embedded together, with the issue ID retained as metadata. To  
generate the embeddings, we utilize the Sentence-Transformers  
library \[ 50 \] with theall-MiniLM-L6-v2model, a lightweight and  
efficient transformer based on Microsoft’s MiniLM architecture \[ 67 \].  
We chose this model because it is the most downloaded and most  
liked sentence-similarity model on Hugging Face, indicating strong  
community trust and widespread adoption. This model employs  
self-attention distillation to capture contextual information effec-  
tively while maintaining computational efficiency. Given an input  
text𝑇 , the embedding process can be defined as follows:  
E= MiniLM(𝑇) (2)

where E∈ R^384 represents the output embedding vector in a 384-  
dimensional space.  
After generating embeddings, we use a vector database for in-  
dexing and retrieval. We use FAISS \[ 15 \]—an off-the-shelf library de-  
signed for efficient nearest neighbor (NN) retrieval in high-dimensional  
spaces. We believe that switching FAISS with another vector data-  
base with comparable capability would produce similar results, as  
shown in Subsection 6.3,  
To retrieve commits from the vector database, we compute the  
cosine similarity score, following prior studies \[ 49 , 54 , 72 \]. The  
computation is given by the following equation:

\`\`\`  
sim(q, e𝑖)=  
\`\`\`  
\`\`\`  
q· e𝑖  
∥q∥ 2 ∥e𝑖∥ 2  
\`\`\`  
\#\#\#\# (3)

where e𝑖is the𝑖-th element of the commit message embeddings E=  
⟨e 1 ,e 2 ,.. .,e𝑛⟩that are indexed by the vector database for efficient  
access, and q is the issue embedding. A higher score between the  
query issue and the commit message indicates greater similarity,  
enabling the ranking of commit messages and the generation of a  
list of candidate commits.

\#\# 4.2 LLM-Assisted Reranking

\`\`\`  
Due to the semantic gap between issues and commits \[ 14 , 31 , 72 \],  
retrieving the most similar commit does not guarantee finding  
the one that fixed the issue. While the correct commit may have  
\`\`\`  
\`\`\`  
been retrieved, it could be obscured by incorrect commits that  
exhibit greater similarity to the issue. To address this, we rerank  
the retrieved commits using a large language model (LLM).  
In this phase, the top-𝑘commits from the initial retrieval are  
provided to the LLM with a structured prompt, as shown in Figure 3\.  
The prompt includes the issue text (summary and description),  
along with each commit’s ID and message. We also specify an  
output format instructing the LLM to return a reranked list of  
commit IDs. The LLM will analyze these commits and produce a  
reranked list based on contextual understanding and issue-commit  
relevance. Outputs that do not match the expected format (0.1% of  
the time) default to the initial retrieval results.  
In detail, we adopt a zero-shot approach guided by prompts  
with ChatGPT (gpt-4o), following recent studies \[ 19 , 25 , 66 \], which  
demonstrate gpt-4o advanced capabilities in understanding complex  
textual relationships. The parameter𝑘controls the additional cost  
incurred for increasing precision. While it is possible to rerank all  
fetched commits for higher precision, this requires a longer prompt  
for the LLM, requiring more computation resources. For the value  
of𝑘, we select𝑘=10 for its balance of precision and efficiency. We  
later show that this allows a high Precision@1 without incurring a  
high cost. This will be discussed in Subsection 6.3.  
\`\`\`  
\#\# 5 Experimental Setup

\#\# 5.1 Research Questions

\`\`\`  
This work aims to answer the following research questions (RQs):  
\`\`\`  
\`\`\`  
RQ1: How does the state-of-the-art tool perform on a real-  
istic evaluation dataset? This question investigates the perfor-  
mance of the state-of-the-art EALink \[ 72 \] on the evaluation dataset  
constructed under the Realistic Distribution Setting (RDS). First,  
we replicate the successful performance of EALink on their orig-  
inal evaluation dataset. Next, we investigate the performance of  
EALink after expanding the evaluation onto a larger benchmark.  
Afterwards, to understand the sensitivity of its performance to  
the evaluation dataset, we investigate how much the performance  
of EALink changes when evaluated under Realistic Distribution  
Setting and compare it with the traditional IR method, VSM.  
\`\`\`  
\`\`\`  
RQ2: How does EasyLink perform on the same realistic eval-  
uation dataset? This research question is concerned with the  
effectiveness of EasyLink. We assess EasyLink in terms of both its  
ability to distinguish true links from false links and its efficiency.  
We analyze the sensitivity of the performance of EasyLink to the  
evaluation setup by comparing its performance on the different  
evaluation methods.  
RQ3: Does EasyLink’s performance change under different  
configurations? This question aims to investigate the effect of  
different settings of EasyLink. We explore different embedding  
models for the vector database and various𝑘value settings for the  
LLM-assisted stage to assess whether these changes will signifi-  
cantly affect EasyLink’s performance.  
\`\`\`  
\#\# 5.2 Experiment Setting

\`\`\`  
5.2.1 Hardware Configuration. The experiments were conducted  
on a machine equipped with two Intel(R) Xeon(R) Platinum 8480C  
\`\`\`

\`\`\`  
Rethinking Issue-Commit Linking with LLM-Assisted Retrieval ICSE ’26, April 12–18, 2026, Rio de Janeiro, Brazil  
\`\`\`  
\`\`\`  
CPUs @ 3.80GHz, 2.0 TiB of main memory, and one NVIDIA H  
80GB HBM3 GPU.  
\`\`\`  
5.2.2 LLM Setup. We utilized the ChatGPT model GPT-4o provided  
by OpenAI, specifically thegpt-4o-2024-11-20version, with its  
default configuration. The temperature was set to the default value  
of 1.0, and the model was sampled once per query. The input token  
size was limited to a 128k token context window per API constraints,  
with no additional adjustments or fine-tuning.

5.2.3 Baseline Description. We use EALink^1 \[ 72 \] as the baseline,  
which is a state-of-the-art tool that outperforms T-BERT \[ 31 \] and  
DeepLink \[ 54 \]. It distills knowledge from CodeBERT \[ 17 \] into a  
smaller model, fine-tuned with multi-task contrastive learning. We  
follow its original methodology, using the provided code and the  
same hyperparameters. As a fundamental baseline, we also run  
VSM^2 \[56\], which is widely used in other studies \[14, 31, 72\].

\#\# 5.3 Evaluation Metrics

We adopt the same metrics used by Zhang et al. \[ 72 \], which use stan-  
dard metrics for information retrieval tasks \[ 48 , 55 \]: Precision@𝑘  
(P@𝑘), Normalized Discounted Cumulative Gain (NDCG@𝑘), Mean  
Reciprocal Rank (MRR), and Hit Ratio (Hit@𝑘) for evaluation. We  
also include Recall@𝑘 , which was overlooked in prior studies.

\- Precision@k evaluates the proportion of relevant commits (i.e.,  
    commits that belong to the correct issue-commit links) within  
    the top 𝑘 retrieved results:

\`\`\`  
Precision@k=  
\`\`\`  
\#\#\#\# 1

\#\#\#\# |𝑄|

\#\#\#\# ∑︁

\`\`\`  
𝑖∈𝑄  
\`\`\`  
\`\`\`  
Rel𝑖  
𝑘  
\`\`\`  
\#\#\#\# , (4)

\`\`\`  
where𝑄is the query set,|𝑄|its size, andRel𝑖the number of  
correctly linked commits in the top 𝑘 results for query 𝑖.  
\`\`\`  
\- Hit@k measures the likelihood that at least one correct commit  
    appears within the top 𝑘 retrieved results:

\`\`\`  
Hit@k=  
\`\`\`  
\#\#\#\# 1

\#\#\#\# |𝑄|

\#\#\#\# ∑︁

\`\`\`  
𝑖  
\`\`\`  
\`\`\`  
I(Rank𝑖≤ 𝑘), (5)  
\`\`\`  
\`\`\`  
whereI(·)returns 1 if the highest-ranked relevant commit for  
query𝑖is within the top𝑘, and 0 otherwise. Hit@1 is equivalent  
to Precision@1.  
\`\`\`  
\- Recall@k evaluates the proportion of relevant commits re-  
    trieved within the top 𝑘 results:

\`\`\`  
Recall@k=  
\`\`\`  
\#\#\#\# 1

\#\#\#\# |𝑄|

\#\#\#\# ∑︁

\`\`\`  
𝑖∈𝑄  
\`\`\`  
\`\`\`  
Rel𝑖  
TotalRel𝑖  
\`\`\`  
\#\#\#\# , (6)

\`\`\`  
where𝑄is the query set,|𝑄|its size,Rel𝑖the number of retrieved  
relevant commits, andTotalRel𝑖the total relevant commits for  
query 𝑖.  
\`\`\`  
\- MRR (Mean Reciprocal Rank) evaluates how early the first rele-  
    vant commit appears in the ranked list for each query:

\#\#\#\# MRR=

\#\#\#\# 1

\#\#\#\# |𝑄|

\#\#\#\# ∑︁|𝑄|

\`\`\`  
𝑖= 1  
\`\`\`  
\#\#\#\# 1

\`\`\`  
Rank𝑖  
\`\`\`  
\#\#\#\# , (7)

(^1) We use EALink provided code and data from https://github.com/KDEGroup/EALink.  
(^2) We implemented VSM using the Gensim library (https://pypi.org/project/gensim)  
Table 2: Performance of EALink on evaluation datasets con-  
structed using different methods  
False Links=99 RDS  
P@1 (Hit@1) 32.52 14.43 (↓ 55 .63%)  
P@10 7.08 3.64 (↓ 48 .59%)  
Hit@10 59.46 30.76 (↓ 48 .27%)  
Recall@10 56.68 28.06 (↓ 50 .49%)  
MRR 41.16 20.21 (↓ 50 .90%)  
NDCG@1 20.52 9.10 (↓ 55 .65%)  
NDCG@10 30.84 15.52 (↓ 49 .67%)  
Note: Results are averaged over 20 projects. The column False Links=99 shows  
EALink’s performance on a dataset constructed with a fixed 99 false links per is-  
sue, while the column RDS shows its performance on a dataset constructed under  
Realistic Distribution Setting (RDS). The parentheses in the RDS column show the  
percentage change in performance.  
where|𝑄|is the number of queries, andRank𝑖is the position  
of the first correctly linked commit for query𝑖. A higher MRR  
indicates earlier retrieval of relevant commits.

\- NDCG@k (Normalized Discounted Cumulative Gain) assesses  
    how well relevant commits are ranked within the top𝑘retrieved  
    results:

\`\`\`  
NDCG@k=  
\`\`\`  
\#\#\#\# 1

\#\#\#\# 𝑍𝑘

\#\#\#\# ∑︁𝑘

\`\`\`  
𝑖= 1  
\`\`\`  
\#\#\#\# 2 𝑟𝑖− 1

\`\`\`  
log 2 (𝑖+ 1 )  
\`\`\`  
\#\#\#\# , (8)

\`\`\`  
where𝑍𝑘is a normalization factor ensuring the ideal ranking  
achieves a value of 1\. The term𝑟𝑖represents the relevance score of  
the commit at position𝑖(𝑟𝑖= 1 for a correct match, 0 otherwise).  
\`\`\`  
\#\# 6 Results

\#\# 6.1 RQ1: How does the state-of-the-art tool

\#\# perform on a realistic evaluation dataset?

\`\`\`  
To ensure we replicate EALink \[ 72 \] correctly and perform a fair  
comparison, we ran EALink on both the evaluation dataset con-  
structed using its original method and the dataset created under  
the Realistic Distribution Setting (RDS), then compared the results.  
In the original experiments of Zhang et al., EALink was trained  
using a balanced dataset and then tested on an imbalanced dataset.  
We reused the same code for training.  
Following EALink’s original evaluation \[ 72 \], we first used their  
false link generation method to construct an evaluation dataset  
using projects provided by them: Ambari, Calcite, Groovy, Ignite,  
Isis, and NetBeans. For any given issue, it randomly samples 99 of  
the commits in the ground truth test dataset to construct false links.  
Next, with this evaluation dataset, which we refer to as the original  
evaluation dataset, we evaluated EALink. EALink obtains an aver-  
age Precision@1 of 53.67%, which matches the 53.90% Precision@  
reported in the paper, indicating that our replication was success-  
ful. Then, we expanded the evaluation to 20 projects (introduced  
in Subsection 3.1). The results, shown in the first column of Table 2,  
indicate an average Precision@1 of 32.52%.  
Then, we ran EALink on the evaluation dataset constructed un-  
der the Realistic Distribution Setting. Unlike the original evaluation  
dataset of Zhang et al. \[ 72 \], which had a fixed number of 99 false  
links per issue, our evaluation generates more false links for repos-  
itories with a larger number of commits. This results in an average  
\`\`\`

\`\`\`  
ICSE ’26, April 12–18, 2026, Rio de Janeiro, Brazil Huang et al.  
\`\`\`  
\`\`\`  
Table 3: Comparison of linking effectiveness on the original  
dataset with a constant 99 false links constructed per issue.  
This comprises the six projects provided by Zhang et al. \[ 72 \]  
(Ambari, Calcite, Groovy, Ignite, Isis, and NetBeans)  
\`\`\`  
\`\`\`  
EALink Vector DB EasyLink  
P@1 (Hit@1) 53.67 81.83 90.04(↑ 67 .77%)  
P@10 8.94 11.14 11.14(↑ 24 .61%)  
Hit@10 72.56 92.89 92.89(↑ 28 .02%)  
Recall@10 69.03 89.93 89.93(↑ 30 .28%)  
MRR 60.13 85.87 91.38(↑ 51 .97%)  
NDCG@1 33.86 51.63 56.81(↑ 67 .78%)  
NDCG@10 41.33 56.31 58.07(↑ 40 .50%)  
Note: The parentheses in the EasyLink column show the improvements over EALink.  
Bold numbers indicate the highest performance. All values are in %.  
\`\`\`  
number of false links per issue of 1,530. In the second column of Ta-  
ble 2, we present the results of running the tool on our evaluation  
dataset, which shows a significant performance drop compared to  
the original evaluation dataset. Across the 20 projects, EALink’s Pre-  
cision@1 decreases to 14.43%, a decline of 55.63%. Similarly, Hit@  
drops from nearly 60% to about 30%, reducing by half. On the six  
projects provided by EALink (including Ambari, Calcite, and four  
others), the average Precision@1 decreases from 53.67% to 28.05%.  
Additionally, we evaluated the traditional IR method, VSM, on the  
same evaluation dataset. Its results are presented in Table 4\. Sur-  
prisingly, EALink underperforms the traditional IR method, VSM.  
VSM achieves a Precision@1 of 46.59% and demonstrates better  
performance across all other metrics. These results suggest that the  
use of VSM would be preferred over EALink in a realistic setting.

\`\`\`  
Answer to RQ1: We constructed an evaluation dataset un-  
der the Realistic Distribution Setting (RDS), which considers  
more false links per issue when there is higher commit activity  
during a given period, better reflecting the practical use of an  
issue-commit link recovery technique on a repository. Under  
this evaluation, the average Precision@1 of the state-of-the-art  
tool declines to 14.43% compared to a VSM baseline with a Pre-  
cision@1 of 46.59%.  
\`\`\`  
\#\# 6.2 RQ2: How does EasyLink perform on the

\#\# same realistic evaluation dataset?

6.2.1 Comparison of Effectiveness. To ensure a fair comparison,  
we first evaluated the vector database and EasyLink on the dataset  
constructed using the EALink method \[ 72 \], which generates 99 false  
links per issue and includes the six projects provided by EALink.  
The results, shown in Table 3, indicate that EasyLink achieves a Pre-  
cision@1 of 90.04%, significantly outperforming EALink’s 53.67%.  
The vector database method also outperforms EALink, achieving a  
Precision@1 of 81.83%.  
Furthermore, we compared them using our more realistic eval-  
uation dataset. As presented in Table 4, the vector database ap-  
proach achieves an average Precision@1 of 61.57%, a significant  
improvement over EALink’s 14.43%. With LLM-assisted rerank-  
ing, EasyLink further enhances Precision@1 by an average of  
13.46%, reaching 75.03%, representing a 420.0% increase compared to

\`\`\`  
Table 4: Comparison of linking effectiveness on the dataset  
constructed under RDS  
\`\`\`  
\`\`\`  
Metric EALink VSM Vector DB EasyLink  
P@1 (Hit@1) 14.43 46.59 61.57 75.03 (↑ 420 .0%)  
P@10 3.64 8.70 10.09 10.09 (↑ 177 .2%)  
Hit@10 30.76 70.94 83.38 83.38 (↑ 171 .1%)  
Recall@10 28.06 67.22 78.84 78.84 (↑ 181 .0%)  
MRR 20.21 55.10 69.21 78.52 (↑ 288 .5%)  
NDCG@1 9.10 29.39 38.85 46.86 (↑ 415 .0%)  
NDCG@10 15.52 39.45 47.98 51.08 (↑ 229 .1%)  
Note: Results are averaged over 20 projects (%). The parentheses show the improve-  
ments over EALink. Since P@10, Hit@10, and Recall@10 only assess whether the true  
commits are included within the top 10 results, without considering its exact rank,  
they are the same for both the vector database and EasyLink. Bold numbers indicate  
the highest performance.  
\`\`\`  
\`\`\`  
Table 5: Comparison of training and testing time cost  
\`\`\`  
\`\`\`  
EALink Vector DB EasyLink  
Train  
(Total / Per Link) 100.68h / 4.39s N/A N/A  
Test  
(Total / Per Issue) 17.78h / 6.87s 2.26h / 0.87s 14.02h / 5.42s  
Note: “Total” indicates the overall time for all 20 projects. “Per Link” (training) is  
the average time per link, computed as total training time divided by the number of  
training links. “Per Issue” (testing) is the average time per issue, based on total testing  
time divided by the number of evaluation issues. Testing times for Vector DB and  
EasyLink include embedding, indexing, and retrieval.  
\`\`\`  
\`\`\`  
EALink. Following the Mann-Whitney U test \[ 34 \], the improvement  
of EasyLink over EALink in every metric is statistically significant  
(p-value\<0.01) and exhibits a large effect size \[ 11 \] (Cohen’s D\>  
0.8). These results demonstrate that EasyLink is effective in issue-  
commit link recovery and that LLMs can be effectively leveraged  
to enhance performance.  
\`\`\`  
\`\`\`  
6.2.2 Comparison of Efficiency. Efficiency is an important aspect of  
software traceability, especially when used in large-scale industrial  
settings \[ 9 , 61 \]. Therefore, we calculated the training and testing  
times required for three approaches—EALink, the vector database,  
and the EasyLink—to compare their efficiency. The results, shown  
in Table 5, indicate that for the 20 projects, EALink requires 100\.  
hours for training, with an average of 4.39 seconds per link in the  
training set. However, approaches using a vector database do not  
require training on a specific issue-commit link dataset, making  
them easier to use and more practical with less human effort.  
Regarding testing time, EALink requires a total of 17.78 hours  
for the 20 projects, averaging 6.87 seconds per issue, while the  
vector database approach takes only 2.26 hours in total, averaging  
0.87 seconds per issue. These differences are statistically significant  
according to the Mann-Whitney U test \[ 34 \] (p-value\<0.01) and  
demonstrate a large effect size (Cohen’s D\>0.8). Additionally,  
the LLM-assisted method (i.e., EasyLink) takes 14.02 hours for  
testing, which is faster than EALink and achieves a significantly  
higher performance. These results demonstrate that the use of  
vector database is an efficient solution. It eliminates the need for  
pretraining models and reduces testing time. By incorporating an  
LLM reranking step, EasyLink achieves a high precision while  
\`\`\`

\`\`\`  
Rethinking Issue-Commit Linking with LLM-Assisted Retrieval ICSE ’26, April 12–18, 2026, Rio de Janeiro, Brazil  
\`\`\`  
\`\`\`  
Table 6: Comparison of linking effectiveness while varying  
the choice of embedding method  
\`\`\`  
\`\`\`  
MiniLM MPNet OpenAI  
P@1 (Hit@1) 61.57 62.73 70\.  
P@10 10.09 10.18 10\.  
Hit@10 83.38 83.00 87\.  
Recall@10 78.84 78.40 82\.  
MRR 69.21 70.39 76\.  
NDCG@1 38.85 39.58 44\.  
NDCG@10 47.98 48.32 51\.  
Test Time (hour) 2.26h 3.22h 28.72h  
Model Size 22.7M params 109M params Cloud-based  
Note: Results are averaged over 20 projects. All values are in %, except for test time  
and model size.  
\`\`\`  
\`\`\`  
eliminating the need for training models. In practice, each issue  
requires about 758 input tokens and 266 output tokens, leading to  
an estimated cost of only $0.009 per issue when using GPT-4o.  
\`\`\`  
\`\`\`  
Answer to RQ2: Our results show that on the realistic evalua-  
tion dataset, EasyLink achieves a Precision@1 of 75.03%, outper-  
forming EALink (which achieves 14.43%) by 420.0%. Moreover,  
using the vector database-based method eliminates the need  
for pretraining on task-specific data, making it a more efficient  
solution.  
\`\`\`  
\#\# 6.3 RQ3: Does EasyLink’s performance change

\#\# under different configurations?

6.3.1 Vector Database: Evaluating Different Embedding Models. We  
evaluated two additional embedding models for use in the vec-  
tor database. The first model,all-mpnet-base-v2, built upon Mi-  
crosoft’s MPNet architecture \[ 60 \], is a sentence transformer and the  
second-most-downloaded sentence-similarity model on Hugging  
Face (the most popular is used in EasyLink). The second model,  
text-embedding-ada-002, is the default model for OpenAI embed-  
dings \[39\], which is a larger model designed for higher precision.  
Table 6 presents the results comparing three embedding models.  
The comparison between MiniLM (used in EasyLink) and MPNet  
shows that the model we selected in our tool requires less time  
while achieving comparable performance. Although OpenAI em-  
beddings provide better performance—with Precision@1 increasing  
from 61.57% to 70.10% (an improvement of 8.53%)—they require  
28.72 hours to complete the experiment, approximately 11 times  
longer than the MiniLM model. Given the high computational cost,  
MiniLM is a more practical option.

6.3.2 LLM-Assisted Reranking: Exploring Different Top-𝑘Values.  
To further analyze the effect of the𝑘setting, we conduct experi-  
ments with different top-𝑘values, specifically𝑘= 5 , 10 , 15 , 20\. We  
conducted this experiment across 20 projects using the realistic  
evaluation dataset. The results in Figure 4 show that increasing  
𝑘—meaning reranking a larger set of top results—generally leads to  
better performance, specifically higher Precision@1 and NDCG@1.  
However, this improvement comes with a significant increase in  
time cost and requires processing more input tokens, leading to a  
higher cost in invoking OpenAI API. While setting𝑘= 5 results in

\`\`\`  
relatively lower performance, increasing𝑘to 10, 15, or 20 does not  
lead to significant performance gains. Considering performance,  
time, and resource costs, we find that𝑘= 10 provides the best  
trade-off. Additionally, compared to the straight line in the figure  
representing the Precision@1 of EALink’s when run on the same  
evaluation dataset, our approach outperforms EALink across dif-  
ferent𝑘values. This shows that its performance does not rely on  
tuning 𝑘.  
\`\`\`  
\`\`\`  
Answer to RQ3: For vector database retrieval, using different  
embedding models with similar runtime costs yields comparable  
results. In the LLM-assisted reranking stage, increasing the𝑘  
value consistently improves performance over the baseline but  
increases test time cost.  
\`\`\`  
\#\# 7 Discussion

\#\# 7.1 Revisiting Classical Baselines

\`\`\`  
In addition to recent learning-based methods, it is important to  
include classical baselines when revisiting research progress on  
issue-commit link recovery. We therefore evaluate ReLink \[ 68 \], an  
approach that extends beyond the basic VSM, using our constructed  
dataset. Since ReLink outputs positive issue-commit links rather  
than ranked candidates, we aligned the evaluation by treating Ea-  
syLink’s top-ranked commit per issue as its predicted link and  
computed precision, recall, and F1 score accordingly. The average  
results across 20 projects show that ReLink achieves 10.92% preci-  
sion, 12.59% recall, and 10.79% F1 score, whereas EasyLink reaches  
75.03% precision, 50.75% recall, and 58.75% F1 score, significantly  
outperforming ReLink. Unlike ReLink, which relies on explicit issue  
tags in commit messages (removed in our setup) and operates at the  
set level, EasyLink leverages semantic relevance and ranks candi-  
dates per issue, making it more robust in large and noisy candidate  
pools.  
\`\`\`  
\#\# 7.2 Lessons learned and Implications

\`\`\`  
Keep your feet on the ground – evaluation should match  
practice. Our results suggest that the performance of issue-commit  
linking approaches is sensitive to their evaluation setups, which em-  
phasizes the importance of the evaluation of proposed techniques  
to reflect the conditions under real-world practices. Future research  
should use evaluations that better reflect a practical usage scenario.  
Back to the basics – IR techniques are strong baselines. Our  
results showed that the VSM baseline, a dated IR model \[ 1 \] proposed  
by Wu et al. \[ 68 \] for issue-commit linking, was effective. This is  
consistent with the “Easy over hard” principle advocated by Fu and  
Menzies \[ 18 \]. This finding has practical implications – practitioners  
may find that the use of simple and fast approaches match the  
performance of more complex approaches.  
\`\`\`  
\`\`\`  
Don’t forget your roots – updating baselines.  
Studies on issue-commit linking have included traditional IR  
baselines, such as the Vector Space Model (VSM) \[ 56 \], Latent Dirich-  
let Allocation (LDA) \[ 6 \], and Latent Semantic Indexing (LSI) \[ 12 \].  
However, recent studies continue to rely on traditional methods as  
baselines without considering recent advances in the IR literature.  
\`\`\`

\`\`\`  
ICSE ’26, April 12–18, 2026, Rio de Janeiro, Brazil Huang et al.  
\`\`\`  
\`\`\`  
71.25 75.03 75\.  
\`\`\`  
\`\`\`  
75\.  
\`\`\`  
\`\`\`  
75.47 78.52 79.48 80\.  
\`\`\`  
\`\`\`  
44.95 46.86 47.41 47\.  
\`\`\`  
\`\`\`  
503  
\`\`\`  
\`\`\`  
841  
\`\`\`  
\`\`\`  
1149  
\`\`\`  
\`\`\`  
1287  
\`\`\`  
\`\`\`  
400  
\`\`\`  
\`\`\`  
900  
\`\`\`  
\`\`\`  
1400  
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
5 10 15 20  
\`\`\`  
\`\`\`  
Performance Metrics Test Time Cost (min)  
\`\`\`  
\`\`\`  
k values  
\`\`\`  
\`\`\`  
P@1 (Hit@1) MRR ND CG@  
P@1 (Hit@1) \- EALink Test Time Cost (min)  
\`\`\`  
\`\`\`  
14\.  
\`\`\`  
Figure 4: Effect of varying𝑘in EasyLink during reranking:  
A higher𝑘slightly raises performance (left axis: P@1, MRR,  
NDCG@1) while significantly increasing test time cost (right  
axis).

\`\`\`  
Table 7: Comparison of EALink and EALink+LLM  
\`\`\`  
\`\`\`  
Metric EALink EALink+LLM Improvement  
P@1 (Hit@1) 14.43 26.04 ↑ 80\.  
P@10 3.64 3.64 \-  
Hit@10 30.76 30.76 \-  
Recall@10 28.06 28.06 \-  
MRR 20.21 28.55 ↑ 41\.  
NDCG@1 9.10 16.96 ↑ 86\.  
NDCG@10 15.52 18.79 ↑ 21\.  
Note: Results (%) are averaged over 20 projects on our dataset constructed under the  
Realistic Distribution Setting (RDS).  
\`\`\`  
\`\`\`  
In our experiments, the out-of-the-box use of a modern baseline, the  
vector database FAISS \[ 15 \], already achieves a strong performance.  
This shows that vector databases provide an effective retrieval ap-  
proach for issue-commit linking, highlighting the need to update  
baselines to reflect the latest advancements in IR methods. We call  
for the need for newly proposed methods to be evaluated with  
baselines that are continuously updated to accurately measure real  
progress.  
\`\`\`  
From good to great – effectiveness of LLMs in retrieval refine-  
ment. Our experiments demonstrate that a reranking step using  
LLMs is highly effective in overcoming the semantic gap, consistent  
with findings in information retrieval systems \[ 20 , 62 , 75 \]. To assess  
whether LLM-based reranking can also enhance the performance  
of EALink \[ 72 \], a deep learning-based method, we conducted ex-  
periments on our realistic evaluation dataset, including 20 projects.  
As shown in Table 7, with LLM reranking assistance, we observe  
a Precision@1 improvement of 80.45%, increasing from 14.43% to  
26.04%. This demonstrates the LLM’s effectiveness in refining ini-  
tially imprecise results. Future work can explore the optimization  
of LLM prompts and apply domain-specific fine-tuning to further  
improve the refinement step.

\#\# 7.3 Threats to Validity

\`\`\`  
Threats to Internal Validity. Threats to internal validity refer  
to errors in our experiments or implementation issues. To avoid  
implementation errors, we replicated the baseline tool, EALink \[ 72 \],  
using its publicly available code. We ensured that we replicated  
its previously reported results before extending the experiments.  
Therefore, the threats to internal validity are minimal.  
Threats to Construct Validity. A potential threat to construct va-  
lidity is the selection of evaluation metrics. We use widely adopted  
metrics—Precision@𝑘, Hit@𝑘, MRR, and NDCG@𝑘—from prior  
studies \[ 14 , 36 , 54 , 72 \] and information retrieval tasks \[ 48 , 55 \]. We  
also included Recall@k, a standard information retrieval evalua-  
tion metric, overlooked in prior issue-commit linking work. Conse-  
quently, we believe that any threat to construct validity is minimal.  
\`\`\`  
\`\`\`  
Threats to External Validity. Threats to external validity refer  
to factors that might limit the generalizability of our findings. Our  
benchmark is the largest in the literature, which provides confi-  
dence that our findings are not specific to only a few projects. One  
threat is the number of times our experiments were performed. To  
mitigate the effect of randomness, we repeated our experiments  
five times. For all metrics, the average results exhibit standard devi-  
ations below 1%. Given the stability of the results, repeating the  
experiments would not yield different findings. As such, there are  
minimal threats to external validity.  
\`\`\`  
\#\# 8 Related Work

\`\`\`  
Traceability Link Recovery: Traceability link recovery methods  
create links between artifacts such as requirements, design docu-  
ments, architecture models, and source code. Research has applied  
classic IR techniques \[ 7 , 16 , 21 , 33 , 43 , 71 \]. Recent work \[ 19 , 52 \]  
utilized LLMs but also found that their level of effectiveness has still  
been unable to support practical automatic link recovery \[19, 23\].  
Traditional Approaches for Issue-Commit Linking: Tradi-  
tional approaches combine heuristics and expert annotation to link  
commits with bug reports. Bachmann et al. \[ 4 \] used interactive  
heuristic linking. Wu et al. \[ 68 \] filtered candidates by textual sim-  
ilarity, timing, and committer mapping. It also learned optimal  
thresholds from training data. Nguyen et al. \[ 40 \] improved per-  
formance by adding code change analysis. Schermann et al. \[ 57 \]  
leveraged developer identity, time proximity, and resource overlap.  
These methods often miss links \[5\].  
\`\`\`  
\`\`\`  
Machine Learning-Based Approaches: Machine learning meth-  
ods improve linking accuracy by reducing the need for handcrafted  
heuristics. Le et al. \[ 29 \] enriched commit messages via code summa-  
rization. Sun et al. \[ 64 \] refined feature extraction with non-source  
documents and code file filtering. Sun et al. \[ 63 \] used positive-  
unlabeled learning to address limited labeled data. Rath et al. \[ 49 \]  
combined process, stakeholder, structural, and textual similarity  
metrics. Mazrae et al. \[ 36 \] incorporated non-textual cues such as au-  
thorship, timestamps, and status. Dong et al. \[ 14 \], a semi-supervised  
framework, tackled data imbalance and sparsity. These approaches  
were later improved by deep learning.  
\`\`\`

\`\`\`  
Rethinking Issue-Commit Linking with LLM-Assisted Retrieval ICSE ’26, April 12–18, 2026, Rio de Janeiro, Brazil  
\`\`\`  
\`\`\`  
Deep Learning-Based Approaches: Recent works focused on  
the use of deep learning. Ruan et al. \[ 54 \] learned semantic repre-  
sentations with word embeddings and RNNs, while Xie et al. \[ 70 \]  
combined RNNs with SVMs and a code knowledge graph from ASTs  
for semantic and code context. Lin et al. \[ 31 \] leveraged a BERT-  
based framework pre-trained on CodeSearchNet and fine-tuned on  
small datasets to address data sparsity. Zhu et al. \[ 74 \] employed  
deep semi-supervised learning and iteratively retrained its model  
using pseudo-labels on unlabeled data. Zhang et al. \[ 72 \] employed  
knowledge distillation to improve both accuracy and efficiency.  
Despite these improvements, we found that the approaches were  
assessed using evaluations whose realism could be improved.  
\`\`\`  
Replication Studies: Our study found that the data used in  
evaluations for issue-commit link recovery may have the draw-  
back of an unrealistic distribution of false links. Some other stud-  
ies \[ 8 , 13 , 27 , 32 , 58 , 59 \] have also emphasized the importance of  
using methods and data that evaluate tools in different settings.  
While some works \[ 14 , 31 , 36 , 54 , 72 \] have investigated issues of  
data cleanliness and data leakage, our work is the first replication  
study of issue-commit linkers and highlights the importance of  
evaluating them using realistic evaluation data that match the real  
development history.

\#\# 9 Conclusion and Future Work

\`\`\`  
In this study, we successfully replicate the strong performance of  
the state-of-the-art work on issue-commit linking. To investigate  
it further, we constructed a new benchmark under a proposed  
Realistic Distribution Setting (RDS) that adaptively constructs false  
links based on the level of development activity in the same time  
frame as the ground-truth link. To the best of our knowledge, the  
benchmark is the largest in the literature, consisting of 9,319 unique  
issues from 20 open-source projects, with an average of 1,530 false  
links constructed per issue. We find that the use of an off-the-shelf IR  
method outperforms the state-of-the-art technique. Building on our  
findings, we propose EasyLink, a scalable and efficient approach  
that combines retrieval with an additional step of reranking using  
an LLM. In terms of average Precision@1, EasyLink outperforms  
the state-of-the-art approach by more than four times.  
In the future, we plan to extend EasyLink for other tasks in  
software traceability, such as mapping features to their implemen-  
tations and linking requirements to code changes.  
\`\`\`  
\#\# Acknowledgments

This research / project is supported by the National Research Foun-  
dation, Singapore, and the Smart Nation Group under the Smart  
Nation Group’s Translational R\&D Grant (Award No. TRANS2023-  
TGC02). Any opinions, findings and conclusions or recommenda-  
tions expressed in this material are those of the author(s) and do  
not reflect the views of National Research Foundation, Singapore  
or the Smart Nation Group.

\#\# References

\`\`\`  
\[1\]Giuliano Antoniol, Gerardo Canfora, Gerardo Casazza, Andrea De Lucia, and  
Ettore Merlo. 2002\. Recovering Traceability Links between Code and Documen-  
tation. IEEE Trans. Software Eng. 28, 10 (2002), 970–983. https://doi.org/10.1109/  
TSE.2002.  
\[2\]Thazin Win Win Aung, Huan Huo, and Yulei Sui. 2020\. A Literature Review of  
Automatic Traceability Links Recovery for Software Change Impact Analysis. In  
\`\`\`  
\`\`\`  
ICPC ’20: 28th International Conference on Program Comprehension, Seoul, Republic  
of Korea, July 13-15, 2020\. ACM, 14–24. https://doi.org/10.1145/3387904.  
\[3\]Adrian Bachmann and Abraham Bernstein. 2009\. Software process data quality  
and characteristics: a historical view on open and closed source projects. In  
Proceedings of the Joint International and Annual ERCIM Workshops on Principles of  
Software Evolution (IWPSE) and Software Evolution (Evol) Workshops (Amsterdam,  
The Netherlands) (IWPSE-Evol ’09). Association for Computing Machinery, New  
York, NY, USA, 119–128. https://doi.org/10.1145/1595808.  
\[4\]Adrian Bachmann, Christian Bird, Foyzur Rahman, Premkumar T. Devanbu,  
and Abraham Bernstein. 2010\. The missing links: bugs and bug-fix commits. In  
Proceedings of the 18th ACM SIGSOFT International Symposium on Foundations of  
Software Engineering, 2010, Santa Fe, NM, USA, November 7-11, 2010, Gruia-Catalin  
Roman and André van der Hoek (Eds.). ACM, 97–106. https://doi.org/10.1145/  
1882291\.  
\[5\]Christian Bird, Adrian Bachmann, Eirik Aune, John Duffy, Abraham Bernstein,  
Vladimir Filkov, and Premkumar T. Devanbu. 2009\. Fair and balanced?: bias  
in bug-fix datasets. In Proceedings of the 7th joint meeting of the European  
Software Engineering Conference and the ACM SIGSOFT International Sympo-  
sium on Foundations of Software Engineering, 2009, Amsterdam, The Netherlands,  
August 24-28, 2009, Hans van Vliet and Valérie Issarny (Eds.). ACM, 121–130.  
https://doi.org/10.1145/1595696.  
\[6\]David M. Blei, Andrew Y. Ng, and Michael I. Jordan. 2003\. Latent Dirichlet  
Allocation. J. Mach. Learn. Res. 3 (2003), 993–1022. https://jmlr.org/papers/v3/  
blei03a.html  
\[7\]Markus Borg, Per Runeson, and Anders Ardö. 2014\. Recovering from a decade: a  
systematic mapping of information retrieval approaches to software traceability.  
Empir. Softw. Eng. 19, 6 (2014), 1565–1616. https://doi.org/10.1007/S10664-013-  
9255-Y  
\[8\] Partha Chakraborty, Krishna Kanth Arumugam, Mahmoud Alfadel, Meiyappan  
Nagappan, and Shane McIntosh. 2024\. Revisiting the Performance of Deep  
Learning-Based Vulnerability Detection on Realistic Datasets. IEEE Transactions  
on Software Engineering 50, 8 (2024), 2163–2177. https://doi.org/10.1109/TSE.2024.  
3423712  
\[9\]Jane Cleland-Huang, Olly Gotel, and Andrea Zisman (Eds.). 2012\. Software and  
Systems Traceability. Springer. https://doi.org/10.1007/978-1-4471-2239-  
\[10\]Jane Cleland-Huang, Orlena C. Z. Gotel, Jane Huffman Hayes, Patrick Mäder,  
and Andrea Zisman. 2014\. Software traceability: trends and future directions.  
In Future of Software Engineering Proceedings (Hyderabad, India) (FOSE 2014).  
Association for Computing Machinery, New York, NY, USA, 55–69. https://doi.  
org/10.1145/2593882.  
\[11\]Jacob Cohen. 2013\. Statistical power analysis for the behavioral sciences. routledge.  
\[12\]Scott Deerwester, Susan T Dumais, George W Furnas, Thomas K Landauer, and  
Richard Harshman. 1990\. Indexing by latent semantic analysis. Journal of the  
American society for information science 41, 6 (1990), 391–407.  
\[13\]Yangruibo Ding, Yanjun Fu, Omniyyah Ibrahim, Chawin Sitawarin, Xinyun  
Chen, Basel Alomair, David A. Wagner, Baishakhi Ray, and Yizheng Chen. 2025\.  
Vulnerability Detection with Code Language Models: How Far are We?. In 47th  
IEEE/ACM International Conference on Software Engineering, ICSE 2025, Ottawa,  
ON, Canada, April 26 \- May 6, 2025\. IEEE, 1729–1741. https://doi.org/10.1109/  
ICSE55347.2025.  
\[14\]Liming Dong, He Zhang, Wei Liu, Zhiluo Weng, and Hongyu Kuang. 2022\. Semi-  
supervised pre-processing for learning-based traceability framework on real-  
world software projects. In Proceedings of the 30th ACM Joint European Software  
Engineering Conference and Symposium on the Foundations of Software Engineering,  
ESEC/FSE 2022, Singapore, Singapore, November 14-18, 2022, Abhik Roychoudhury,  
Cristian Cadar, and Miryung Kim (Eds.). ACM, 570–582. https://doi.org/10.1145/  
3540250\.  
\[15\]Matthijs Douze, Alexandr Guzhva, Chengqi Deng, Jeff Johnson, Gergely Szilvasy,  
Pierre-Emmanuel Mazaré, Maria Lomeli, Lucas Hosseini, and Hervé Jégou. 2024\.  
The Faiss library. CoRR abs/2401.08281 (2024). https://doi.org/10.48550/ARXIV.  
2401.08281 arXiv:2401.  
\[16\]Marc Eaddy, Alfred V. Aho, Giuliano Antoniol, and Yann-Gaël Guéhéneuc. 2008\.  
CERBERUS: Tracing Requirements to Source Code Using Information Retrieval,  
Dynamic Analysis, and Program Analysis. In The 16th IEEE International Confer-  
ence on Program Comprehension, ICPC 2008, Amsterdam, The Netherlands, June  
10-13, 2008, René L. Krikhaar, Ralf Lämmel, and Chris Verhoef (Eds.). IEEE Com-  
puter Society, 53–62. https://doi.org/10.1109/ICPC.2008.  
\[17\]Zhangyin Feng, Daya Guo, Duyu Tang, Nan Duan, Xiaocheng Feng, Ming Gong,  
Linjun Shou, Bing Qin, Ting Liu, Daxin Jiang, and Ming Zhou. 2020\. CodeBERT:  
A Pre-Trained Model for Programming and Natural Languages. In Findings of  
the Association for Computational Linguistics: EMNLP 2020, Online Event, 16-  
November 2020 (Findings of ACL, Vol. EMNLP 2020), Trevor Cohn, Yulan He, and  
Yang Liu (Eds.). Association for Computational Linguistics, 1536–1547. https:  
//doi.org/10.18653/V1/2020.FINDINGS-EMNLP.  
\[18\]Wei Fu and Tim Menzies. 2017\. Easy over hard: a case study on deep learning. In  
Proceedings of the 2017 11th Joint Meeting on Foundations of Software Engineering,  
ESEC/FSE 2017, Paderborn, Germany, September 4-8, 2017, Eric Bodden, Wilhelm  
\`\`\`

ICSE ’26, April 12–18, 2026, Rio de Janeiro, Brazil Huang et al.

Schäfer, Arie van Deursen, and Andrea Zisman (Eds.). ACM, 49–60. https://doi.  
org/10.1145/3106237.  
\[19\]Dominik Fuchß, Tobias Hey, Jan Keim, Haoyu Liu, Niklas Ewald, Tobias Thirolf,  
and Anne Koziolek. 2025\. LiSSA: Toward Generic Traceability Link Recovery  
Through Retrieval- Augmented Generation. In 47th IEEE/ACM International Con-  
ference on Software Engineering, ICSE 2025, Ottawa, ON, Canada, April 26 \- May 6,  
2025\. IEEE, 1396–1408. https://doi.org/10.1109/ICSE55347.2025.  
\[20\]Jingtong Gao, Bo Chen, Xiangyu Zhao, Weiwen Liu, Xiangyang Li, Yichao  
Wang, Zijian Zhang, Wanyu Wang, Yuyang Ye, Shanru Lin, Huifeng Guo,  
and Ruiming Tang. 2024\. LLM-enhanced Reranking in Recommender Sys-  
tems. CoRR abs/2406.12433 (2024). https://doi.org/10.48550/ARXIV.2406.  
arXiv:2406.  
\[21\]Malcom Gethers, Rocco Oliveto, Denys Poshyvanyk, and Andrea De Lucia. 2011\.  
On integrating orthogonal information retrieval methods to improve traceability  
recovery. In IEEE 27th International Conference on Software Maintenance, ICSM  
2011, Williamsburg, VA, USA, September 25-30, 2011\. IEEE Computer Society,  
133–142. https://doi.org/10.1109/ICSM.2011.  
\[22\] Jin Guo, Jinghui Cheng, and Jane Cleland-Huang. 2017\. Semantically enhanced  
software traceability using deep learning techniques. In Proceedings of the 39th  
International Conference on Software Engineering (Buenos Aires, Argentina) (ICSE  
’17). IEEE Press, 3–14. https://doi.org/10.1109/ICSE.2017.  
\[23\]Jane Huffman Hayes, Alex Dekhtyar, and Senthil Karthikeyan Sundaram. 2006\.  
Advancing Candidate Link Generation for Requirements Tracing: The Study of  
Methods. IEEE Trans. Software Eng. 32, 1 (2006), 4–19. https://doi.org/10.1109/  
TSE.2006.  
\[24\]Abram Hindle, Daniel M. Germán, and Richard C. Holt. 2008\. What do large  
commits tell us?: a taxonomical study of large commits. In Proceedings of the  
2008 International Working Conference on Mining Software Repositories, MSR 2008  
(Co-located with ICSE), Leipzig, Germany, May 10-11, 2008, Proceedings, Ahmed E.  
Hassan, Michele Lanza, and Michael W. Godfrey (Eds.). ACM, 99–108. https:  
//doi.org/10.1145/1370750.  
\[25\]Raisa Islam and Owana Marzia Moushi. 2024\. Gpt-4o: The cutting-edge advance-  
ment in multimodal llm. Authorea Preprints (2024).  
\[26\]Maliheh Izadi, Pooya Rostami Mazrae, Tom Mens, and Arie van Deursen. 2022\.  
LinkFormer: Automatic Contextualised Link Recovery of Software Artifacts in  
both Project-based and Transfer Learning Settings. CoRR abs/2211.00381 (2022).  
https://doi.org/10.48550/ARXIV.2211.00381 arXiv:2211.  
\[27\]Hong Jin Kang, Khai Loong Aw, and David Lo. 2022\. Detecting False Alarms  
from Automatic Static Analysis Tools: How Far are We?. In 44th IEEE/ACM 44th  
International Conference on Software Engineering, ICSE 2022, Pittsburgh, PA, USA,  
May 25-27, 2022\. ACM, 698–709. https://doi.org/10.1145/3510003.  
\[28\]Masanari Kondo, Yutaro Kashiwa, Yasutaka Kamei, and Osamu Mizuno. 2022\.  
An empirical study of issue-link algorithms: which issue-link algorithms should  
we use? Empir. Softw. Eng. 27, 6 (2022), 136\. https://doi.org/10.1007/S10664-022-  
10120-X  
\[29\]Tien-Duy B. Le, Mario Linares Vásquez, David Lo, and Denys Poshyvanyk. 2015\.  
RCLinker: automated linking of issue reports and commits leveraging rich con-  
textual information. In Proceedings of the 2015 IEEE 23rd International Conference  
on Program Comprehension, ICPC 2015, Florence/Firenze, Italy, May 16-24, 2015, An-  
drea De Lucia, Christian Bird, and Rocco Oliveto (Eds.). IEEE Computer Society,  
36–47. https://doi.org/10.1109/ICPC.2015.  
\[30\]Kaixuan Li, Jian Zhang, Sen Chen, Han Liu, Yang Liu, and Yixiang Chen. 2024\.  
PatchFinder: A Two-Phase Approach to Security Patch Tracing for Disclosed  
Vulnerabilities in Open-Source Software. In Proceedings of the 33rd ACM SIGSOFT  
International Symposium on Software Testing and Analysis, ISSTA 2024, Vienna,  
Austria, September 16-20, 2024, Maria Christakis and Michael Pradel (Eds.). ACM,  
590–602. https://doi.org/10.1145/3650212.  
\[31\]Jinfeng Lin, Yalin Liu, Qingkai Zeng, Meng Jiang, and Jane Cleland-Huang. 2021\.  
Traceability Transformed: Generating more Accurate Links with Pre-Trained  
BERT Models. In 43rd IEEE/ACM International Conference on Software Engineering,  
ICSE 2021, Madrid, Spain, 22-30 May 2021\. IEEE, 324–335. https://doi.org/10.1109/  
ICSE43902.2021.  
\[32\]Yue Liu, Chakkrit Tantithamthavorn, Yonghui Liu, Patanamon Thongtanunam,  
and Li Li. 2024\. Automatically Recommend Code Updates: Are We There Yet?  
ACM Trans. Softw. Eng. Methodol. 33, 8, Article 217 (Dec. 2024), 27 pages. https:  
//doi.org/10.1145/  
\[33\]Andrea De Lucia, Fausto Fasano, Rocco Oliveto, and Genoveffa Tortora. 2007\.  
Recovering traceability links in software artifact management systems using  
information retrieval methods. ACM Trans. Softw. Eng. Methodol. 16, 4 (2007), 13\.  
https://doi.org/10.1145/1276933.  
\[34\]Henry B Mann and Donald R Whitney. 1947\. On a test of whether one of  
two random variables is stochastically larger than the other. The annals of  
mathematical statistics (1947), 50–60.  
\[35\]Andrian Marcus, Jonathan I. Maletic, and Andrey Sergeyev. 2005\. Recov-  
ery of Traceability Links between Software Documentation and Source Code.  
Int. J. Softw. Eng. Knowl. Eng. 15, 5 (2005), 811–836. https://doi.org/10.1142/  
S  
\[36\]Pooya Rostami Mazrae, Maliheh Izadi, and Abbas Heydarnoori. 2021\. Automated  
Recovery of Issue-Commit Links Leveraging Both Textual and Non-textual Data.

\`\`\`  
In IEEE International Conference on Software Maintenance and Evolution, ICSME  
2021, Luxembourg, September 27 \- October 1, 2021\. IEEE, 263–273. https://doi.org/  
10.1109/ICSME52107.2021.  
\[37\]Andrew Meneely, Harshavardhan Srinivasan, Ayemi Musa, Alberto Rodriguez  
Tejeda, Matthew Mokary, and Brian Spates. 2013\. When a Patch Goes Bad: Explor-  
ing the Properties of Vulnerability-Contributing Commits. In 2013 ACM / IEEE  
International Symposium on Empirical Software Engineering and Measurement,  
Baltimore, Maryland, USA, October 10-11, 2013\. IEEE Computer Society, 65–74.  
https://doi.org/10.1109/ESEM.2013.  
\[38\]Leila Naslavsky and Debra J. Richardson. 2007\. Using traceability to support  
model-based regression testing. In 22nd IEEE/ACM International Conference on  
Automated Software Engineering (ASE 2007), November 5-9, 2007, Atlanta, Georgia,  
USA, R. E. Kurt Stirewalt, Alexander Egyed, and Bernd Fischer (Eds.). ACM,  
567–570. https://doi.org/10.1145/1321631.  
\[39\]Arvind Neelakantan, Tao Xu, Raul Puri, Alec Radford, Jesse Michael Han, Jerry  
Tworek, Qiming Yuan, Nikolas Tezak, Jong Wook Kim, Chris Hallacy, Johannes  
Heidecke, Pranav Shyam, Boris Power, Tyna Eloundou Nekoul, Girish Sastry,  
Gretchen Krueger, David Schnurr, Felipe Petroski Such, Kenny Hsu, Madeleine  
Thompson, Tabarak Khan, Toki Sherbakov, Joanne Jang, Peter Welinder, and  
Lilian Weng. 2022\. Text and Code Embeddings by Contrastive Pre-Training. CoRR  
abs/2201.10005 (2022). arXiv:2201.10005 https://arxiv.org/abs/2201.  
\[40\]Anh Tuan Nguyen, Tung Thanh Nguyen, Hoan Anh Nguyen, and Tien N. Nguyen.  
\`\`\`  
2012\. Multi-layered approach for recovering links between bug reports and fixes.  
In 20th ACM SIGSOFT Symposium on the Foundations of Software Engineering  
(FSE-20), SIGSOFT/FSE’12, Cary, NC, USA \- November 11 \- 16, 2012, Will Tracz,  
Martin P. Robillard, and Tevfik Bultan (Eds.). ACM, 63\. https://doi.org/10.1145/  
2393596\.  
\[41\]Truong Giang Nguyen, Thanh Le-Cong, Hong Jin Kang, Xuan-Bach Dinh Le, and  
David Lo. 2022\. VulCurator: a vulnerability-fixing commit detector. In Proceedings  
of the 30th ACM Joint European Software Engineering Conference and Symposium  
on the Foundations of Software Engineering, ESEC/FSE 2022, Singapore, Singapore,  
November 14-18, 2022, Abhik Roychoudhury, Cristian Cadar, and Miryung Kim  
(Eds.). ACM, 1726–1730. https://doi.org/10.1145/3540250.  
\[42\]Giang Nguyen-Truong, Hong Jin Kang, David Lo, Abhishek Sharma, Andrew E.  
Santosa, Asankhaya Sharma, and Ming Yi Ang. 2022\. HERMES: Using Commit-  
Issue Linking to Detect Vulnerability-Fixing Commits. In IEEE International Con-  
ference on Software Analysis, Evolution and Reengineering, SANER 2022, Honolulu,  
HI, USA, March 15-18, 2022\. IEEE, 51–62. https://doi.org/10.1109/SANER53432.  
2022\.  
\[43\]Rocco Oliveto, Malcom Gethers, Denys Poshyvanyk, and Andrea De Lucia. 2010\.  
On the Equivalence of Information Retrieval Methods for Automated Traceability  
Link Recovery. In The 18th IEEE International Conference on Program Compre-  
hension, ICPC 2010, Braga, Minho, Portugal, June 30-July 2, 2010\. IEEE Computer  
Society, 68–71. https://doi.org/10.1109/ICPC.2010.  
\[44\] OpenAI. 2024\. GPT-4o. https://openai.com/index/hello-gpt-4o/.  
\[45\]EasyLink: Replication Package. 2025\. Replication package of EasyLink. https:  
//figshare.com/s/d495f11c4cc5c1c72e  
\[46\]Michael C. Panis. 2010\. Successful Deployment of Requirements Traceabil-  
ity in a Commercial Engineering Organization...Really. In RE 2010, 18th IEEE  
International Requirements Engineering Conference, Sydney, New South Wales,  
Australia, September 27 \- October 1, 2010\. IEEE Computer Society, 303–307.  
https://doi.org/10.1109/RE.2010.  
\[47\]Ranjith Purushothaman and Dewayne E. Perry. 2005\. Toward Understanding the  
Rhetoric of Small Source Code Changes. IEEE Trans. Software Eng. 31, 6 (2005),  
511–526. https://doi.org/10.1109/TSE.2005.  
\[48\]Filip Radlinski and Nick Craswell. 2010\. Comparing the sensitivity of informa-  
tion retrieval metrics. In Proceeding of the 33rd International ACM SIGIR Confer-  
ence on Research and Development in Information Retrieval, SIGIR 2010, Geneva,  
Switzerland, July 19-23, 2010, Fabio Crestani, Stéphane Marchand-Maillet, Hsin-  
Hsi Chen, Efthimis N. Efthimiadis, and Jacques Savoy (Eds.). ACM, 667–674.  
https://doi.org/10.1145/1835449.  
\[49\]Michael Rath, Jacob Rendall, Jin L. C. Guo, Jane Cleland-Huang, and Patrick  
Mäder. 2018\. Traceability in the wild: automatically augmenting incomplete trace  
links. In Proceedings of the 40th International Conference on Software Engineering,  
ICSE 2018, Gothenburg, Sweden, May 27 \- June 03, 2018, Michel Chaudron, Ivica  
Crnkovic, Marsha Chechik, and Mark Harman (Eds.). ACM, 834–845. https:  
//doi.org/10.1145/3180155.  
\[50\]Nils Reimers and Iryna Gurevych. 2019\. Sentence-BERT: Sentence Embed-  
dings using Siamese BERT-Networks. In Proceedings of the 2019 Conference  
on Empirical Methods in Natural Language Processing and the 9th International  
Joint Conference on Natural Language Processing, EMNLP-IJCNLP 2019, Hong  
Kong, China, November 3-7, 2019, Kentaro Inui, Jing Jiang, Vincent Ng, and  
Xiaojun Wan (Eds.). Association for Computational Linguistics, 3980–3990.  
https://doi.org/10.18653/V1/D19-  
\[51\]Irving Muller Rodrigues, Daniel Aloise, Eraldo Rezende Fernandes, and Michel R.  
Dagenais. 2020\. A Soft Alignment Model for Bug Deduplication. In MSR ’20:  
17th International Conference on Mining Software Repositories, Seoul, Republic of

Rethinking Issue-Commit Linking with LLM-Assisted Retrieval ICSE ’26, April 12–18, 2026, Rio de Janeiro, Brazil

Korea, 29-30 June, 2020, Sunghun Kim, Georgios Gousios, Sarah Nadi, and Joseph  
Hejderup (Eds.). ACM, 43–53. https://doi.org/10.1145/3379597.  
\[52\]Alberto D. Rodriguez, Katherine R. Dearstyne, and Jane Cleland-Huang. 2023\.  
Prompts Matter: Insights and Strategies for Prompt Engineering in Automated  
Software Traceability. In 31st IEEE International Requirements Engineering Con-  
ference, RE 2023 \- Workshops, Hannover, Germany, September 4-5, 2023, Kurt  
Schneider, Fabiano Dalpiaz, and Jennifer Horkoff (Eds.). IEEE, 455–464. https:  
//doi.org/10.1109/REW57809.2023.  
\[53\]Bilyaminu Auwal Romo, Andrea Capiluppi, and Tracy Hall. 2014\. Filling the Gaps  
of Development Logs and Bug Issue Data. In Proceedings of The International  
Symposium on Open Collaboration (Berlin, Germany) (OpenSym ’14). Association  
for Computing Machinery, New York, NY, USA, 1–4. https://doi.org/10.1145/  
2641580\.  
\[54\]Hang Ruan, Bihuan Chen, Xin Peng, and Wenyun Zhao. 2019\. DeepLink: Re-  
covering issue-commit links based on deep learning. J. Syst. Softw. 158 (2019).  
https://doi.org/10.1016/J.JSS.2019.  
\[55\]Tetsuya Sakai and Noriko Kando. 2008\. On information retrieval metrics designed  
for evaluation with incomplete relevance assessments. Inf. Retr. 11, 5 (2008), 447–

470\. https://doi.org/10.1007/S10791-008-9059-  
\[56\]G. Salton, A. Wong, and C. S. Yang. 1975\. A vector space model for automatic  
indexing. Commun. ACM 18, 11 (Nov. 1975), 613–620. https://doi.org/10.1145/  
361219\.  
\[57\]Gerald Schermann, Martin Brandtner, Sebastiano Panichella, Philipp Leitner, and  
Harald C. Gall. 2015\. Discovering loners and phantoms in commit and issue  
data. In Proceedings of the 2015 IEEE 23rd International Conference on Program  
Comprehension, ICPC 2015, Florence/Firenze, Italy, May 16-24, 2015, Andrea De  
Lucia, Christian Bird, and Rocco Oliveto (Eds.). IEEE Computer Society, 4–14.  
https://doi.org/10.1109/ICPC.2015.  
\[58\]Martin J. Shepperd, Qinbao Song, Zhongbin Sun, and Carolyn Mair. 2013\. Data  
Quality: Some Comments on the NASA Software Defect Datasets. IEEE Trans.  
Software Eng. 39, 9 (2013), 1208–1215. https://doi.org/10.1109/TSE.2013.  
\[59\]Jieke Shi, Zhou Yang, and David Lo. 2025\. Efficient and Green Large Language  
Models for Software Engineering: Literature Review, Vision, and the Road Ahead.  
ACM Trans. Softw. Eng. Methodol. 34, 5, Article 137 (May 2025), 22 pages. https:  
//doi.org/10.1145/  
\[60\]Kaitao Song, Xu Tan, Tao Qin, Jianfeng Lu, and Tie-Yan Liu. 2020\. MPNet:  
Masked and Permuted Pre-training for Language Understanding. In Advances  
in Neural Information Processing Systems 33: Annual Conference on Neural In-  
formation Processing Systems 2020, NeurIPS 2020, December 6-12, 2020, virtual,  
Hugo Larochelle, Marc’Aurelio Ranzato, Raia Hadsell, Maria-Florina Balcan,  
and Hsuan-Tien Lin (Eds.). https://proceedings.neurips.cc/paper/2020/hash/  
c3a690be93aa602ee2dc0ccab5b7b67e-Abstract.html  
\[61\]George Spanoudakis and Andrea Zisman. 2005\. Software traceability: a roadmap.  
In Handbook of software engineering and knowledge engineering: vol 3: recent  
advances. World Scientific, 395–428.  
\[62\] Weiwei Sun, Lingyong Yan, Xinyu Ma, Shuaiqiang Wang, Pengjie Ren, Zhumin  
Chen, Dawei Yin, and Zhaochun Ren. 2023\. Is ChatGPT Good at Search?  
Investigating Large Language Models as Re-Ranking Agents. In Proceedings  
of the 2023 Conference on Empirical Methods in Natural Language Processing,  
EMNLP 2023, Singapore, December 6-10, 2023, Houda Bouamor, Juan Pino, and  
Kalika Bali (Eds.). Association for Computational Linguistics, 14918–14937.  
https://doi.org/10.18653/V1/2023.EMNLP-MAIN.  
\[63\]Yan Sun, Celia Chen, Qing Wang, and Barry W. Boehm. 2017\. Improving missing  
issue-commit link recovery using positive and unlabeled data. In Proceedings of  
the 32nd IEEE/ACM International Conference on Automated Software Engineering,  
ASE 2017, Urbana, IL, USA, October 30 \- November 03, 2017, Grigore Rosu, Massi-  
miliano Di Penta, and Tien N. Nguyen (Eds.). IEEE Computer Society, 147–152.  
https://doi.org/10.1109/ASE.2017.

\`\`\`  
\[64\]Yan Sun, Qing Wang, and Ye Yang. 2017\. FRLink: Improving the recovery of  
missing issue-commit links by revisiting file relevance. Inf. Softw. Technol. 84  
(2017), 33–47. https://doi.org/10.1016/J.INFSOF.2016.11.  
\[65\]Jianguo Wang, Xiaomeng Yi, Rentong Guo, Hai Jin, Peng Xu, Shengjun Li, Xi-  
angyu Wang, Xiangzhou Guo, Chengming Li, Xiaohai Xu, Kun Yu, Yuxing  
Yuan, Yinghao Zou, Jiquan Long, Yudong Cai, Zhenxiang Li, Zhifeng Zhang,  
Yihua Mo, Jun Gu, Ruiyi Jiang, Yi Wei, and Charles Xie. 2021\. Milvus: A  
Purpose-Built Vector Data Management System. In Proceedings of the 2021 In-  
ternational Conference on Management of Data (Virtual Event, China) (SIGMOD  
’21). Association for Computing Machinery, New York, NY, USA, 2614–2627.  
https://doi.org/10.1145/3448016.  
\[66\]Tianyu Wang, Nianjun Zhou, and Zhixiong Chen. 2024\. Enhancing Computer  
Programming Education with LLMs: A Study on Effective Prompt Engineering  
for Python Code Generation. CoRR abs/2407.05437 (2024). https://doi.org/10.  
48550/ARXIV.2407.05437 arXiv:2407.  
\[67\]Wenhui Wang, Furu Wei, Li Dong, Hangbo Bao, Nan Yang, and Ming Zhou. 2020\.  
MiniLM: Deep Self-Attention Distillation for Task-Agnostic Compression of  
Pre-Trained Transformers. In Advances in Neural Information Processing Systems  
33: Annual Conference on Neural Information Processing Systems 2020, NeurIPS  
2020, December 6-12, 2020, virtual, Hugo Larochelle, Marc’Aurelio Ranzato, Raia  
Hadsell, Maria-Florina Balcan, and Hsuan-Tien Lin (Eds.). https://proceedings.  
neurips.cc/paper/2020/hash/3f5ee243547dee91fbd053c1c4a845aa-Abstract.html  
\[68\]Rongxin Wu, Hongyu Zhang, Sunghun Kim, and Shing-Chi Cheung. 2011\. Re-  
Link: recovering links between bugs and changes. In SIGSOFT/FSE’11 19th ACM  
SIGSOFT Symposium on the Foundations of Software Engineering (FSE-19) and  
ESEC’11: 13th European Software Engineering Conference (ESEC-13), Szeged, Hun-  
gary, September 5-9, 2011, Tibor Gyimóthy and Andreas Zeller (Eds.). ACM, 15–25.  
https://doi.org/10.1145/2025113.  
\[69\]Zhaonan Wu, Yanjie Zhao, Chen Wei, Zirui Wan, Yue Liu, and Haoyu Wang. 2025\.  
COmmitSHield: Tracking Vulnerability Introduction and Fix in Version Control  
Systems. In 47th IEEE/ACM International Conference on Software Engineering,  
ICSE 2025 \- Companion Proceedings, Ottawa, ON, Canada, April 27 \- May 3, 2025\.  
IEEE, 279–290. https://doi.org/10.1109/ICSE-COMPANION66252.2025.  
\[70\]Rui Xie, Long Chen, Wei Ye, Zhiyu Li, Tianxiang Hu, Dongdong Du, and Shikun  
Zhang. 2019\. DeepLink: A Code Knowledge Graph Based Deep Learning Ap-  
proach for Issue-Commit Link Recovery. In 26th IEEE International Conference on  
Software Analysis, Evolution and Reengineering, SANER 2019, Hangzhou, China,  
February 24-27, 2019, Xinyu Wang, David Lo, and Emad Shihab (Eds.). IEEE,  
434–444. https://doi.org/10.1109/SANER.2019.  
\[71\]Zhou Yang, Jieke Shi, Shaowei Wang, and David Lo. 2021\. IncBL: Incremental  
Bug Localization. In 2021 36th IEEE/ACM International Conference on Automated  
Software Engineering (ASE). 1223–1226. https://doi.org/10.1109/ASE51524.2021.  
9678546  
\[72\]Chenyuan Zhang, Yanlin Wang, Zhao Wei, Yong Xu, Juhong Wang, Hui Li, and  
Rongrong Ji. 2023\. EALink: An Efficient and Accurate Pre-Trained Framework  
for Issue-Commit Link Recovery. In 38th IEEE/ACM International Conference on  
Automated Software Engineering, ASE 2023, Luxembourg, September 11-15, 2023\.  
IEEE, 217–229. https://doi.org/10.1109/ASE56229.2023.  
\[73\]Ting Zhang, DongGyun Han, Venkatesh Vinayakarao, Ivana Clairine Irsan,  
Bowen Xu, Ferdian Thung, David Lo, and Lingxiao Jiang. 2023\. Duplicate Bug  
Report Detection: How Far Are We? ACM Trans. Softw. Eng. Methodol. 32, 4  
(2023), 97:1–97:32. https://doi.org/10.1145/  
\[74\]Jianfei Zhu, Guanping Xiao, Zheng Zheng, and Yulei Sui. 2024\. Deep semi-  
supervised learning for recovering traceability links between issues and commits.  
J. Syst. Softw. 216 (2024), 112109\. https://doi.org/10.1016/J.JSS.2024.  
\[75\]Yutao Zhu, Huaying Yuan, Shuting Wang, Jiongnan Liu, Wenhan Liu, Chen-  
long Deng, Zhicheng Dou, and Ji-Rong Wen. 2023\. Large Language Mod-  
els for Information Retrieval: A Survey. CoRR abs/2308.07107 (2023). https:  
//doi.org/10.48550/ARXIV.2308.07107 arXiv:2308.  
\`\`\`


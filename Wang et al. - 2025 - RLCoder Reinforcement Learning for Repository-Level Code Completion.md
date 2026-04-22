\# RLCoder: Reinforcement Learning for

\# Repository-Level Code Completion

\#\#\# Yanlin Wang^1 , Yanli Wang^1 , Daya Guo^1 , Jiachi Chen^1 ∗, Ruikai Zhang^2 , Yuchi Ma^2 , Zibin Zheng^1

(^1) Sun Yat-sen University, Zhuhai, China  
{wangylin36, chenjch86, zhzibin}@mail.sysu.edu.cn,{wangyli58, guody5}@mail2.sysu.edu.cn,  
(^2) Huawei Cloud Computing Technologies Co., Ltd., Shenzhen, China  
{zhangruikai1, mayuchi1}@huawei.com  
Abstract—Repository-level code completion aims to generate  
code for unfinished code snippets within the context of a  
specified repository. Existing approaches mainly rely on retrieval-  
augmented generation strategies due to limitations in input  
sequence length. However, traditional lexical-based retrieval  
methods like BM25 struggle to capture code semantics, while  
model-based retrieval methods face challenges due to the lack  
of labeled data for training. Therefore, we propose RLCoder, a  
novel reinforcement learning framework, which can enable the  
retriever to learn to retrieve useful content for code completion  
without the need for labeled data. Specifically, we iteratively eval-  
uate the usefulness of retrieved content based on the perplexity  
of the target code when provided with the retrieved content as  
additional context, and provide feedback to update the retriever  
parameters. This iterative process enables the retriever to learn  
from its successes and failures, gradually improving its ability to  
retrieve relevant and high-quality content. Considering that not  
all situations require information beyond code files and not all  
retrieved context is helpful for generation, we also introduce a  
stop signal mechanism, allowing the retriever to decide when to  
retrieve and which candidates to retain autonomously. Extensive  
experimental results demonstrate that RLCoder consistently  
outperforms state-of-the-art methods on CrossCodeEval and  
RepoEval, achieving 12.2% EM improvement over previous  
methods. Moreover, experiments show that our framework can  
generalize across different programming languages and further  
improve previous methods like RepoCoder. We provide the code  
and data at https://github.com/DeepSoftwareAnalytics/RLCoder.  
Index Terms—Repository-Level Code Completion, Reinforce-  
ment Learning, Perplexity, Stop Signal Mechanism  
I. INTRODUCTION  
With the advancement of large language models for code  
(code LLMs) \[1\]–\[5\], code completion has emerged as one of  
the most important features in integrated development environ-  
ments (IDEs) \[6\]–\[11\]. However, due to the vast size of code  
repositories and the limitations of context length in models,  
repository-level code completion, which involves generating  
code suggestions within the context of an entire repository,  
cannot practically leverage the entire repository directly as  
context \[12\]. Therefore, previous works \[12\]–\[17\] typically  
employ a retrieval-augmented-generation (RAG) strategy. In  
this approach, the unfinished code in the current file serves  
as a query to retrieve code candidates from the entire repos-  
itory, providing cross-file context. These candidates are then  
\* Jiachi Chen is the corresponding author.  
concatenated with the unfinished code before being fed into  
code LLMs. To retrieve relevant code snippets from other files,  
various retrievers are adopted. RepoFuse \[15\] uses lexical-  
based method BM25 \[18\] as the retriever to retrieve code  
snippets that are textually similar with the unfinished code.  
RepoCoder \[13\] and RepoHyper \[19\] use the model-based  
approach that encodes code candidates and unfinished code  
into vectors and employs dense retrieval to find similar codes.  
Although these efforts have shown promising performance  
in repository-level code generation, we have identified the  
following problems in retrieval.  
P1 Labeled Data Dependency.Lexical-based methods such  
as BM25 \[18\] cannot capture code semantics, while  
model-based methods \[12\], \[19\], \[20\] are capable of  
understanding code semantics but are hampered by the  
lack of ground-truth candidate data for training. This  
labeled data is hard to obtain, as it requires significant  
effort in data parsing and expert labeling, limiting its  
generalizability.  
P2 Candidate Construction Issue. Previous methods of  
code candidate construction mainly employ the fixed  
window strategy \[13\] or dependency parsing \[12\], \[21\].  
However, the fixed window strategy may disrupt the con-  
tinuity of the code. Methods based on dependency parsing  
can only focus on limited context in the dependency  
graph and can not be applied to complex scenarios.  
P3 Non-Selective Retrieval.Previous studies typically di-  
rectly retrieve several candidates to serve as the context  
for generation, neglecting when to retrieve and which  
candidates to retain. Unnecessary candidates can detract  
from the performance in completion scenarios that do not  
require repository context.  
In this paper, we propose RLCODER, a reinforcement learn-  
ing framework for repository-level code completion to address  
the aforementioned problems. Firstly, we propose a code-  
base construction pipeline with a simple yet effective Split-  
Aggregate strategy. This approach allows better code continu-  
ity of the candidates, which we refer to as natural candidates  
(addressingP2). Secondly, during the training stage, we di-  
verge from supervised learning methods that depend on labeled  
data. Instead, we train a retriever named RLRetriever that  
learns what to retrieve based on feedback from a specifically  
1140  
2025 IEEE/ACM 47th International Conference on Software Engineering (ICSE)  
1558-1225/25/$31.00 ©2025 IEEE  
DOI 10.1109/ICSE55347.2025.  
2025 IEEE/ACM 47th International Conference on Software Engineering (ICSE) | 979-8-3315-0569-1/25/$31.00 ©2025 IEEE | DOI: 10.1109/ICSE55347.2025.

designed evaluator, without needing labeled data (addressing  
P1). Specifically, we iteratively evaluate the usefulness of  
retrieved content based on the perplexity of the target code  
when provided with the retrieved content as additional context,  
and provide feedback to update the retriever parameters,  
which enables the retriever to learn from its successes and  
failures, gradually improving its ability to retrieve relevant  
and high-quality content. Moreover, to mitigate hallucinations  
often observed in repository-level code completions, typically  
due to incorrect identifier or API usage \[16\], we design a  
weighted perplexity (PPL) mechanism that allocates higher  
weights to certain important tokens in perplexity calculation.  
Furthermore, considering that not all candidates retrieved are  
useful for generation, we introduce a stop signal mechanism  
to evaluate the usefulness of candidates, allowing the retriever  
to decide when to retrieve and which candidates to retain  
autonomously (addressingP3). Finally, in the inference stage,  
given an unfinished code as input, RLCoder retrieves natural  
candidates from the codebase, retains the useful candidates,  
and then feeds them along with the unfinished code into the  
generator (a backbone LLM) for target code generation.  
We evaluate RLCoder with extensive experiments with  
several LLMs on CrossCodeEval \[22\] and RepoEval \[13\].  
Experimental results show that our framework achieves 12.2%  
improvement of Exact Match compared with previous meth-  
ods. Furthermore, RLCoder demonstrates high generalizabil-  
ity, showing effectiveness across various LLMs and program-  
ming languages. Additionally, experiments show that RLCoder  
can be integrated into previous methods such as RepoCoder  
to enhance code completion performance further.  
Our main contributions are:

\- We propose RLCoder, a reinforcement learning frame-  
    work for repository-level code completion. To our knowl-  
    edge, we are the first to train the retriever without labeled  
    data for repository-level code completion. Besides, we  
    design a mechanism that uses the weighted perplexity  
    of the target code as the reward to further enhance  
    performance.  
\- We introduce a simple yet effective Split-Aggregate  
    candidate construction strategy based on human pro-  
    gramming habits. This method avoids the disruption of  
    code continuity and outperforms fixed window candidates  
    indicated by the experimental results.  
\- We propose a stop signal mechanism to evaluate the  
    usefulness of candidates and discard useless candidates  
    for more effective code completion.  
\- We perform an extensive evaluation of RLCoder. Experi-  
    mental results show that RLCoder outperforms the state-  
    of-the-art methods and demonstrates generalizability and  
    applicability.

\`\`\`  
II. BACKGROUND  
\`\`\`  
A. Retrieval-Augmented Generation

Retrieval-augmented generation (RAG) \[23\] is an approach  
that enhances the quality of generation by retrieving from

\`\`\`  
external knowledge bases. This method includes three key  
components \[24\]:retriever,generator, andaugmentation tech-  
niques. Theretrieveris used to find relevant information from  
a large-scale dataset or knowledge base, including pertinent  
documents, facts, or text snippets that are relevant to the  
input query or prompt. The retrieved information is fed into  
thegenerator, which integrates this external knowledge into  
the generation stage.Augmentation techniquesfocus on how  
retrieved information is integrated into the generation process.  
To formalize the RAG process, consider a scenario where we  
want to generate code based on a queryqand a set of retrieved  
candidates{c 1 , c 2 , ..., cn}. The process can be described by the  
following formula:  
\`\`\`  
\`\`\`  
Code=Generate(q,Retrieve(q,{c 1 , c 2 , ..., cn})) (1)  
\`\`\`  
\`\`\`  
where the Retrieve(·) function selects the most relevant  
candidates based on the query q from the candidate set  
{c 1 , c 2 , ..., cn}, and the Generate(·)function then takes the  
query and the retrieved candidates to generate the target code.  
In recent years, researchers have conducted a substantial  
amount of research related to RAG, highlighting its promising  
potential for future applications \[23\], \[25\]–\[28\]. Many studies  
have utilized RAG for code-related research \[29\]–\[42\]. In  
repository-level code completion, due to the massive amount  
of code in the repository and limited context of generator \[12\],  
it is impractical to use the entire repository as the context for  
generation. Therefore, most current methods employ the RAG  
method to retrieve suitable candidates from the repository for  
generation \[12\], \[13\], \[16\], \[17\].  
\`\`\`  
\`\`\`  
in\_regex: Pattern\[str\],  
in\_style: \_styles.Style,  
out\_style: \_styles.Style,  
) \-\> None:  
"""  
Initializes the :class:\`.Converter\` instance.  
"""  
self.\_escape\_start \= len(escape\_char) if escape\_char is not None else 0  
"""  
\*\_escape\_start\* (:class:\`int\`) is the offset used to  
skip the escapecharacter.  
"""  
self.\_expand\_tuples: bool \= expand\_tuples  
"""  
\*\_expand\_tuples\* (:class:\`bool\`) is whether to convert tuples into a  
sequence of parameters.  
"""  
\`\`\`  
\`\`\`  
class Converter(object):  
"""  
The :class:\`.Converter\` class is the base class for implementing the  
conversion from one in-style parameter to another out-style parameter.  
"""  
def \_\_init\_\_(  
self,  
escape\_char: Optional\[str\],  
expand\_tuples: bool,  
\`\`\`  
\`\`\`  
Code Continuity is Disrupted\!  
\`\`\`  
\`\`\`  
Candidate 1  
\`\`\`  
\`\`\`  
Candidate 2  
\`\`\`  
\`\`\`  
Candidate 3  
\`\`\`  
\`\`\`  
Fig. 1\. Using fixed window candidates may disrupt the continuity of code  
semantics, resulting in the definition of functions being split across different  
code snippets.  
\`\`\`  
\`\`\`  
B. Repository-Level Code Completion  
Traditional code completion \[1\], \[43\] usually focused on  
generating code with in-file context. With the development  
of LLMs \[3\]–\[5\], \[44\], repository-level code completion is  
\`\`\`  
\`\`\`  
1141  
\`\`\`

\`\`\`  
\# neo4j-python-driver/src/neo4j/\_data.py  
...  
defkeys(self) \-\>t.List\[str\]:  
""" Return the keys of the record.  
:returns: list of key names  
"""  
returnlist(self.\_\_keys)  
defvalues(self, \*keys: \_K) \-\> t.List\[t.Any\]:  
""" Return the values of the record, optionally filtering to  
include only certain values by index or key.  
:param keys: indexes or keys of the items to include; if none  
are provided, all values will be included  
:returns: list of values  
""" Query (Unfinished Code)  
\`\`\`  
\`\`\`  
ifkeys:  
return\[self\[key\] forkeyinkeys\]  
else:  
returnlist(self) Generation without Retrieval  
\`\`\`  
\`\`\`  
ifnotkeys:  
returnlist(self.\_\_values)  
return\[self\[key\] forkeyinkeys\]  
\`\`\`  
\`\`\`  
\# neo4j-python-driver/src/neo4j/\_sync/work/result.py  
...  
def values(  
self, \*keys: \_TResultKey  
) \-\> t.List\[t.List\[t.Any\]\]:  
"""Return the remainder of the result asa listof values lists.  
:param keys: fields to returnforeach remaining record.  
Optionally filtering to include only certain values by index orkey.  
:returns: listof values lists  
:raises ResultConsumedError: ifthe transaction fromwhich this result  
was obtained has been closed orthe Result has been explicitly  
consumed.  
Retrieved Context  
\`\`\`  
\`\`\`  
Generation with Retrieval  
\`\`\`  
\`\`\`  
Attribute Does Not Exist\!  
\`\`\`  
Fig. 2\. Due to the limitations of LLMs, inappropriate retrieval can mislead  
generation, resulting in attempts to call an non-existent attribute.

gradually gaining attention as it better reflects real-world  
scenarios \[12\], \[13\], \[22\], \[45\]. To formalize repository-level  
code completion, we conceptualize the process as selecting the  
most relevant snippets (candidates) from a code repository and  
generating code based on the query. This can be encapsulated  
in a formula as follows:

\`\`\`  
Code=Generate(q,Retrieve(q,codebase)) (2)  
\`\`\`  
whereqrepresents the query or the prompt for code com-  
pletion. Codebase symbolizes code snippets from the code  
repository. Retrieve(q,codebase)is the function that selects the  
most relevant code snippets (candidates) from the repository  
based on the queryq. Generate(q,candidates)is the generation  
function that generates the target code based on the queryq  
and the selected candidates.  
Previous work highlights the importance of integrating both  
the in-file and cross-file context in repository-level code com-  
pletion \[12\]. This implies that the model needs to understand  
not only the local context but also third-party libraries and  
global modules \[21\]. Fusing analogy context and rationale  
context can greatly ensure the integrity of the retrieval code-  
base \[15\]. Iterative retrieval and generation method \[13\],  
\[16\] involves concatenating the results generated from the  
previous iteration with the prior context to form a query. This  
query is then used for the subsequent round of retrieval and  
generation. Additionally, agents \[17\], \[46\]–\[48\] that assist in  
code completion through invoking tools or collaborating with  
each other is also a remarkable approach.

\`\`\`  
RLRetriever Evaluator  
𝒇(𝒙)Weighted Perplexity Reward  
\`\`\`  
\`\`\`  
Unfinished Code ...  
RetrivedCodes  
Codebase  
\`\`\`  
\`\`\`  
\</\>  
Training  
\`\`\`  
\`\`\`  
GitHub  
Repos  
\`\`\`  
\`\`\`  
Unfinished Code  
\`\`\`  
\`\`\`  
Codebase  
\`\`\`  
\`\`\`  
\</\>  
\`\`\`  
\`\`\`  
Inference  
\`\`\`  
\`\`\`  
Current  
Repo RLRetriever Generator  
\`\`\`  
\`\`\`  
...  
RetrivedCodes  
\`\`\`  
\`\`\`  
TargetCode  
\`\`\`  
\`\`\`  
Fig. 3\. Overview of RLCoder.  
\`\`\`  
\`\`\`  
Limitations:There are still some issues that need to be ad-  
dressed for current repository-level code completion methods.  
First, the lack of labeled data limits the generalizability of  
many learning-based approaches. For example, CoCoMIC \[12\]  
can only be used in trained repositories and struggles to expand  
to other languages and repositories. RepoHyper \[19\] uses a  
subset of the benchmark as training data and sets the gold  
candidate as the label.Second, previous works mostly adopted  
fixed window candidates \[13\] or candidates based on depen-  
dency parsing \[12\]. Methods based on dependency parsing  
only consider the nodes in the dependency parse graph, ne-  
glecting other code in the repository. This can lead to omitting  
many potentially useful code pieces during retrieval. Methods  
using fixed window candidates, as shown in Figure 1, may split  
the signature of the “\_\_init\_\_” function into two different  
candidates. This situation may lead to the retriever fetching the  
required code snippet without capturing the full parameter list.  
As a result, this partial information could confuse the generator  
leading to incorrect function calls.Third, current work lacks  
an evaluation of the necessity for candidates. As illustrated in  
Figure 2, the task can be correctly completed using only the  
in-file preceding context. However, if the context retrieved is  
blindly used, it may mislead the generation due to LLM’s  
own capability limitation. In this case, there is a function  
definition for “keys” in the unfinished code, which calls the  
“\_\_keys” attribute. The code snippet retrieved happens to  
have a function definition for “values”, leading the model  
to mistakenly believe there is a corresponding “\_\_values”  
attribute defined, thus calling a non-existent “\_\_values”  
attribute during code generation.  
\`\`\`  
\`\`\`  
III. METHODOLOGY  
A. Overview  
In this section, we introduce RLCoder, a reinforcement  
learning framework for repository-level code completion. The  
overview of RLCoder is shown in Figure 3, comprising  
two stages: training and inference. In the training stage, the  
major objective is to train the retriever RLRetriever, the key  
component of our framework. First, to train RLRetriever, we  
\`\`\`  
\`\`\`  
1142  
\`\`\`

\`\`\`  
Filter  
\`\`\`  
\`\`\`  
Code Repositories  
\`\`\`  
\`\`\`  
Dependency  
Analysis  
\`\`\`  
\`\`\`  
Code Clusters  
Candidates  
\`\`\`  
\`\`\`  
Target Code  
\`\`\`  
\`\`\`  
Fig. 4\. Data construction pipeline.  
\`\`\`  
construct data from repositories collected from GitHub and  
obtain unfinished code, target code, and candidate codebase.  
Then, RLRetriever will retrieve from the candidate codebase  
using unfinished code as the query. Finally, the retrieved code  
candidates will be evaluated by the evaluator and obtain the  
weight perplexity reward to update the parameters of RLRe-  
triever. Through repeated iterations, RLRetriever enhances its  
retrieval capability via continuous feedback and learning. In  
the inference stage, given unfinished code and the current  
repository context, we first construct codebase from current  
repository. Then, we use the RLRetriever trained in the training  
stage to retrieve from the codebase using the unfinished code.  
Finally, we use the retrieved codes as context to concatenate  
with the unfinished code and feed them into the generator for  
target code generation.

B. Data Construction

Repository-level code completion tasks typically refer to  
generating partial code within the given repository code  
context, generally including a line, an API, or a part of a  
function body \[13\]. To ensure the retriever we train meets  
the requirements of repository-level code retrieval, we need to  
simulate such scenarios. Figure 4 shows the pipeline of our  
data construction process, which includes the following steps:  
repository filtering, dependency analysis, target code selection,  
and candidate construction.  
1\) Repository Selection:We randomly select 10,000 large-  
scale Python and Java repositories from GitHub that were cre-  
ated before March 2023 and meet the following requirements:  
(1) have cross-file dependencies for constructing our training  
dataset; and (2) not included in well-known benchmarks such  
as CrossCodeEval \[22\] and RepoEval \[13\], which are used in  
our evaluation. This filtering process aims at preventing po-  
tential data leakage, ensuring the reliability of the evaluation.  
2\) Dependency Analysis:To ensure our training data con-  
tains a substantial quantity of cross-file context dependencies,  
we implement a dependency analysis for each repository. The  
methodology is outlined in Algorithm 1\. Specifically, to get  
the code files that are related to each other, we analyze  
the importstatements within code files and construct a  
dependency graph that represents the relationships between  
these files. Based on whether dependencies exist between  
code files, we categorize them into clusters of interdependent  
code files. Through this process, we obtain 27,919 Python  
file clusters and 41,647 Java file clusters. We eliminate any  
cluster that contains only a single file. For clusters comprising  
multiple files, we employ a topological sorting based on the  
in-degree and out-degree of files. This means that, aside from

\`\`\`  
Algorithm 1Dependency Analysis and Clustering.  
Require:Set of code filesF  
Ensure:Clusters of interdependent code filesClusters  
G←ConstructDependencyGraph(F)  
Clusters←IdentifyClusters(G)  
for allclusterinClustersdo  
ifSize(cluster) \== 1then  
Clusters←Clusters−{cluster}  
else  
SortedCluster←TopologicalSort(cluster)  
UpdateclusterinClusterswithSortedCluster  
end if  
end for  
return Clusters  
\`\`\`  
\`\`\`  
the first file, each file in the cluster will contain code segments  
that depend on one or more of other files.  
3\) Target Code Selection: Within the clusters of interde-  
pendent code files, we designate files other than the first file  
as the ones to be completed. We select a random position  
within these files, excluding the beginning and end to ensure  
ample context for the code to be completed. This position  
serves as the starting point for the target code segment that  
needs completion. To formalize this process, we define the  
target code segment to be masked and completed asCtarget,  
starting from positionpstartwith lengthl, wherepstartis  
chosen randomly within the constraints mentioned above. The  
selection ofpstartcan be expressed as:  
\`\`\`  
\`\`\`  
pstart=Random(pmin, pmax) (3)  
\`\`\`  
\`\`\`  
wherepmin andpmax define the permissible range within  
the file, excluding the very beginning and ending segments  
to ensure sufficient context. The lengthlof the target code  
Ctargetis also determined randomly, with the constraint that  
the entire segmentCtargetmust lie within the boundary of the  
code file:  
Ctarget=C\[pstart:pstart+l\] (4)  
After identifyingCtarget, wemaskthis segment within the file  
to simulate an unfinished code scenario that needs completion.  
Upon maskingCtarget, the segment designated for completion,  
we intentionally exclude the file containing the masked code  
when assembling candidates. To formalize this concept, we  
define a binary selection function for candidate files asS(fi),  
wherefirepresents a candidate file:  
\`\`\`  
\`\`\`  
S(fi) \=  
\`\`\`  
\#\#\#\# (

\`\`\`  
0 ifCtarget∈fi,  
1 otherwise  
\`\`\`  
\#\#\#\# (5)

\`\`\`  
4\) Candidate Construction:Unlike previous works that uti-  
lized fixed window candidates \[13\], \[16\] or candidates parsed  
from dependencies \[12\], we propose a simple yet effective  
Split-Aggregate candidate construction strategy inspired by  
human programming habits. We term these candidates as natu-  
ral candidates. Specifically, programmers often write code with  
continuous semantic information together, using blank lines as  
\`\`\`  
\`\`\`  
1143  
\`\`\`

separators to facilitate readability. As shown in the left part of  
Figure 5, code and its corresponding comments are usually not  
separated by blank lines. In fact, blank lines are usually used to  
separate code snippets with different semantics and usage. This  
practice naturally forms continuous code segments. The Split-  
Aggregate strategy is outlined in Algorithm 2\. Specifically,  
we divide the code in a file into several mini-blocks based  
on blank lines and then aggregate these mini-blocks into  
candidates by a certain length. During aggregation, the mini-  
blocks are concatenated to form candidates in such a way that  
the length of any candidate does not exceed a preset threshold  
valueT.

Algorithm 2Split-Aggregate Strategy  
Require:Code FileF, ThresholdT  
Ensure:Candidate setC  
Blocks←SplitIntoBlocks(F)  
C←∅  
for allblockinBlocksdo  
ifLineCount(block)\< Tthen  
Aggregate←block  
while LineCount(Aggregate) \< T and block ̸\=  
Last(Blocks)do  
block←Next(block)  
Aggregate←Aggregate+block  
end while  
C←C∪{CreateCandidate(Aggregate)}  
else  
C←C∪SplitBlock(block, T)  
end if  
end for  
return C

C. Reinforcement Learning-based RLRetriever Training

1\) Design of Reward: For reinforcement learning, reward  
is feedback from the external environment that assists a model  
in learning specific capabilities based on the feedback. In the  
scenario of repository-level code completion, the most intuitive  
indicator of reward is whether the generated code can be  
executed to obtain the expected results. However, obtaining  
feedback through actual execution is difficult. On the one  
hand, it’s challenging to set up the execution environment  
for repository code. Even if the execution environment is  
established, execution can be time-consuming, and there may  
be a lack of corresponding test cases to evaluate the accuracy  
of the execution results.

In the context of repository-level code completion, our  
primary aim is to identify the optimal candidatecfrom a  
set of possibilities that maximizes the likelihood of accurately  
generating the target code sequenceygiven the contextual  
informationx. This objective can be formally articulated as:

\`\`\`  
max  
c  
P(y|x, c) (6)  
\`\`\`  
\`\`\`  
It is evident that this maximization is equivalent to minimizing  
the negative log-likelihood:  
\`\`\`  
\`\`\`  
min  
c  
−logP(y|x, c) (7)  
\`\`\`  
\`\`\`  
Perplexity (PPL), a standard measure for evaluating the pre-  
dictive performance of probabilistic models, is defined as the  
exponential of the average negative log-likelihood (NLL) over  
a sequence. Minimizing NLL thereby directly corresponds to  
minimizing the perplexity of the target code sequencey:  
\`\`\`  
\`\`\`  
min  
c  
P P L(y|x, c) \=e−  
N^1 PNi=1logP(yi|x,c,y\<i)  
(8)  
\`\`\`  
\`\`\`  
whereyirepresents the i-th token in the target code sequence  
y.  
In the domain of code completion, the first few tokens  
generated play a pivotal role in shaping the entire output.  
Considering this, we give more attention to the first few tokens.  
Besides, errors in repository-level code completion often occur  
due to hallucinations caused by a lack of understanding of the  
entire repository, such as generating incorrect or non-existent  
APIs. Therefore, we assign a higher focus on the identifier  
tokens. To further refine the model’s focus, we introduce a  
weighted variantP P Lw:  
\`\`\`  
\`\`\`  
P P Lw(y|x, c) \=e  
\`\`\`  
\`\`\`  
−PN^1  
i=1wi  
\`\`\`  
\`\`\`  
PN  
i=1wi·logP(yi|x,c,y\<i)  
(9)  
\`\`\`  
\`\`\`  
The weightwifor each token of the target code is determined  
by a function that considers the token’s position in the se-  
quence and whether it is an identifier, which can be represented  
as:  
\`\`\`  
\`\`\`  
wi=  
\`\`\`  
\#\#\#\#

\#\#\#\#

\#\#\#\#

\`\`\`  
wfirst ifi≤k,  
wapi ifyi∈APIs,  
1 otherwise  
\`\`\`  
\#\#\#\# (10)

\`\`\`  
where the firstktokens are assigned by a weightwfirstto  
reflect their significant impact on the overall quality of the  
generated code. If the i-th token is part of an API or an  
identifier, it is assigned a weightwapi to acknowledge the  
importance of accurate and contextually appropriate identifiers  
in code completion.  
We define the reward for choosing a particular candidateci,  
cjfrom the set of all candidatesCas follows:  
\`\`\`  
\`\`\`  
r(ci) \=  
\`\`\`  
\#\#\#\# (

\`\`\`  
1 ifP P Lw(ci)≤P P Lw(cj),∀cj∈C,  
0 otherwise  
\`\`\`  
\#\#\#\# (11)

\`\`\`  
where P P Lw(ci) denotes the weighted perplexity of the  
target code given candidateci, serving as an abbreviation for  
P P Lw(y|x, ci). The rewardr(ci), equivalently referred to as  
reward(ci, x, C)in the formulations, is assigned a value of  
1 if the candidateciexhibits a PPL that is equal to or lower  
than that of any other candidate in the setC. Conversely, a  
reward of 0 is allocated tociif it fails to meet this criterion.  
Building on the concept of this reward mechanism, we  
further define our objective function,L, as an aggregation  
of the logarithmic probabilities of choosing each candidate,  
\`\`\`  
\`\`\`  
1144  
\`\`\`

\`\`\`  
class Converter(object):  
"""The :class:\`.Converter\` class is the base class for  
implementing theconversion from one in-style  
parameter to another out""" \-style parameter.  
def \_\_init\_\_(  
selfescape\_char, : Optional\[str\],  
expand\_tuples: bool,  
in\_regexin\_style: Pattern\[: \_styles.Stylestr\],,  
out\_style: \_styles.Style,  
) \-\> None:  
"""  
Initializes the :""" class:\`.Converter\` instance.  
selfif escape\_char.\_escape\_start is not= len None(escape\_char else 0 )  
"""  
\*\_escape\_start\* (:class:\`int\`) is the offse  
used to skip the escape""" character.  
self""".\_expand\_tuples: bool \= expand\_tuples  
\*\_expand\_tuples\* (:class:\`bool\`) is whether to  
convert tuples into a""" sequence of parameters.  
\`\`\`  
\`\`\`  
class Converter(object):  
"""  
The :class:\`.Converter\` class is the base class for  
implementing theconversion from one in-style  
parameter to another out""" \-style parameter.  
def \_\_init\_\_(  
selfescape\_char, : Optional\[str\],  
expand\_tuples: bool,  
in\_regexin\_style: Pattern\[: \_styles.Stylestr\],,  
out\_style: \_styles.Style,  
) \-\> None:  
"""Initializes the :class:\`.Converter\` instance.  
"""  
self.\_escape\_start \= len(escape\_char)  
if escape\_char is not None else 0  
"""  
\*\_escape\_start\* (:class:\`int\`) is the offse  
used to skip the escape""" character.  
self.\_expand\_tuples: bool \= expand\_tuples  
"""\*\_expand\_tuples\* (:class:\`bool\`) is whether to  
convert tuples into asequence of parameters.  
"""  
\`\`\`  
\`\`\`  
RawCode MiniBlocks Candidates  
\`\`\`  
\`\`\`  
Split  
\`\`\`  
\`\`\`  
Aggregate  
\`\`\`  
\`\`\`  
class Converter(object):  
"""  
The :implementing theclass:\`.Converterconversion from one in\` class is the base class for-style  
parameter to another out-style parameter.  
"""  
def \_\_init\_\_(  
self,  
escape\_charexpand\_tuples: Optional\[: bool, str\],  
in\_regex: Pattern\[str\],  
in\_styleout\_style: \_: \_styles.Stylestyles.Style,,  
) \- \> """None:  
Initializes the :class:\`.Converter\` instance.  
"""  
self.\_escape\_start \= len(escape\_char)  
if"""^ escape\_char^ is^ not^ None^ else^0  
\*\_escape\_start\* (:class:\`int\`) is the offse  
used to skip the escape""" character.  
self.\_expand\_tuples: bool \= expand\_tuples  
"""\*\_expand\_tuples\* (:class:\`bool\`) is whether to  
convert tuples into asequence of parameters.  
"""  
\`\`\`  
\`\`\`  
Candidates  
\`\`\`  
\`\`\`  
Fig. 5\. Candidate construction strategy.  
\`\`\`  
weighted by the corresponding reward. This is mathematically  
represented as:

\#\#\#\# L=

\`\`\`  
Xn  
\`\`\`  
\`\`\`  
i=  
\`\`\`  
\`\`\`  
(reward(ci, x, C)×logp(ci|x, C)) (12)  
\`\`\`  
where nis the total number of candidates in set C, and  
p(ci|x, C)denotes the probability of selecting candidateci  
given the contextxand the set of candidatesC.

\`\`\`  
1st candidate  
\`\`\`  
\`\`\`  
2nd candidate  
\`\`\`  
\`\`\`  
3rd candidate  
\`\`\`  
\`\`\`  
4th candidate  
\`\`\`  
\`\`\`  
5th candidate  
\`\`\`  
\`\`\`  
6th candidate  
\`\`\`  
\`\`\`  
7th candidate  
\`\`\`  
\`\`\`  
8th candidate  
\`\`\`  
\`\`\`  
Unfinished Code  
\`\`\`  
\#\# ...

\`\`\`  
1st candidate  
\`\`\`  
\`\`\`  
2nd candidate  
\`\`\`  
\`\`\`  
3rd candidate  
\`\`\`  
\`\`\`  
4th candidate  
\`\`\`  
\`\`\`  
5th candidate  
\`\`\`  
\`\`\`  
6th candidate  
\`\`\`  
\`\`\`  
7th candidate  
\`\`\`  
\`\`\`  
8th candidate  
\`\`\`  
\`\`\`  
Unfinished Code  
\`\`\`  
\#\# ...

\`\`\`  
1st candidate  
\`\`\`  
\`\`\`  
2nd candidate  
\`\`\`  
\`\`\`  
3rd candidate  
\`\`\`  
\`\`\`  
4th candidate  
\`\`\`  
\`\`\`  
5th candidate  
\`\`\`  
\`\`\`  
6th candidate  
\`\`\`  
\`\`\`  
7th candidate  
\`\`\`  
\`\`\`  
8th candidate  
\`\`\`  
\`\`\`  
Unfinished Code  
\`\`\`  
\#\# ...

\`\`\`  
Stop Signal Retained Candidate DisgardedCandidate  
\`\`\`  
\`\`\`  
(a) (b) (c)  
Fig. 6\. Stop signal mechanism examples.  
\`\`\`  
2\) Stop Signal Mechanism for Candidates Selection:  
Previous works often overlook when to retrieve and which  
candidates to retain after retrieval. Specifically, after obtaining  
the topkcandidates, traditional methods simply truncate this  
list to the topicandidates, determined by a predefined context  
length. However, this method overlooks the fact that not every  
retrieved candidate contributes positively to the generation  
process, and some may even have a negative impact. There-

\`\`\`  
fore, discerning which candidates to retain is crucial for code  
completion performance.  
The core of the stop signal mechanism is the empty can-  
didate. In the retrieval phase, the empty candidate serves as  
a stop signal and is sent to the retriever together with other  
ordinary candidates. During training, the evaluator gives each  
candidate a weighted PPL score to measure the degree of  
helping generate target code. For candidates ranked below the  
stop signal, we consider them to be useless or harmful and  
should not be used; if the stop signal ranked 1st, it means  
that the generation doesn’t require retrieval. During inference,  
we recall the candidates one by one until encountering the  
stop signal or reach the maximum context limit. As shown  
in Figure 6, the stop signal is outside the maximum context  
in example-(a). The stop signal is ranked 4th in example-  
(b), which means that only the first three candidates will be  
retained. The stop signal is ranked 1st in example-(c), which  
means that all candidates will be disgarded.  
3\) Learning from Reward:As depicted in Figure 3, RLRe-  
triever is fine-tuned through a dynamic learning process where  
it receives rewards from the evaluator to update its parameters.  
This iterative learning process enables RLRetriever to progres-  
sively improve its retrieval results, leading to the selection of  
code candidates with progressively higher quality.  
\`\`\`  
\`\`\`  
D. Code Completion with RLCoder  
\`\`\`  
\`\`\`  
As shown in the lower half of Figure 3, during the inference  
stage, given unfinished code and the current repository context,  
we first construct the candidate codebase from the current  
repository using the Split-Aggregate method. Then, we retrieve  
code candidates using the unfinished code with the trained  
RLRetriever. Inherently, the stop signal strategy mentioned  
in Section III-C2 is embedded in the retrieved results to  
retain only the useful candidates. Finally, the unfinished code,  
\`\`\`  
\`\`\`  
1145  
\`\`\`

\`\`\`  
TABLE I  
BENCHMARK STATISTICS.  
Benchmark Category \#Samples Avg. \#Lines Avg. \#Tokens  
\`\`\`  
\`\`\`  
CrossCodeEval PythonJava^26652139 1.001.09 14.4516.  
\`\`\`  
\`\`\`  
RepoEval Python (Line)Python (API)^16001600 1.002.48 15.0334.  
\`\`\`  
together with these selected candidates, is provided as input  
to the generator for code completion.

\`\`\`  
IV. EXPERIMENTALSETUP  
\`\`\`  
A. Baselines

1\) For RLCoder:To evaluate the effectiveness of RLCoder,  
we compare it with the RawRAG method and RepoCoder  
framework. Besides, we use a popular dense retriever UniX-  
coder \[49\] in these experiments.

\- RawRAGrefers to the standard retrieval and generation  
    approach in the repository-level code completion task. For  
    the unfinished code to generate, RawRAG uses the left  
    context of unfinished code as the query to find the relevant  
    code in the repository to build prompts for generation.  
\- RepoCoder\[13\] is the state-of-the-art framework for  
    repository-level code completion. It uses an iterative  
    retrieval and generation approach to generate target code.  
2\) For RLRetriever: To evaluate the effectiveness of RL-  
Retriever, we compare it with the following commonly used  
retrieval methods in RAG:  
\- NoRetrievalstands for direct generation with unfinished  
code, without retrieval.  
\- BM25\[18\] calculates scores for code candidates based  
on the frequency of query terms in each candidate. It  
adjusts for candidate length and the average candidate  
length across the entire database to prevent bias towards  
longer candidates.  
\- UniXcoder\[49\] is a dense retriever that encodes both  
the query and the code snippets into dense vector spaces.  
This encoding facilitates the identification and retrieval of  
semantically relevant code snippets from a large corpus  
based on the similarity of vector representations.  
\- UniXcoder-SFT is a retriever that we trained using  
supervised fine-tuning of UniXcoder. Due to the lack  
of labeled data, we use the candidate with the lowest  
perplexity of target code as the label to fine-tune the  
retriever.

B. Benchmarks

We evaluate RLCoder on widely used benchmarks for code  
completion: CrossCodeEval and RepoEval.

\- CrossCodeEval\[22\] is a diverse and multilingual code  
    completion benchmark, and we use the Python and Java  
    parts of it.  
\- RepoEval\[13\] is a benchmark proposed simultaneously  
    with RepoCoder \[13\]. The benchmark consists of the

\`\`\`  
latest repositories that cover the line-level, API-level, and  
function-level completion tasks. We use the line-level and  
API-level tasks among it for evaluation.  
Table I shows the statistics of the benchmarks.\#Samples  
stands for the number of samples in a benchmark,Avg.  
\#LinesandAvg. \#Tokensstands for the average num-  
bers of lines and tokens of the target code snippets in the  
benchmark, respectively. Tokens are tokenized by the tokenizer  
of DeepSeekCoder-1B.  
\`\`\`  
\`\`\`  
C. Evaluation Metrics  
We measure the performance of our approach using the  
widely used metricsExact Match (EM)andEdit Similarity  
(ES)\[50\]. These metrics are widely used in previous code  
completion studies \[12\], \[13\], \[16\], \[22\]. EM assesses the  
precision of code completion by checking if the generated code  
matches the expected code exactly. It treats the entire code  
snippet as a single unit. ES measures the similarity between the  
generated code and the expected code by calculating the edit  
distance. It reflects the number of edits needed to transform  
the generated code into the expected code.  
\`\`\`  
\`\`\`  
D. Experimental Details  
All experiments are conducted on a machine with two  
Tesla A100 GPUs, each with 80 GB memory. In the training  
stage, we use the parameters of UniXcoder \[49\] to initialize  
RLRetriever and use DeepSeekCoder-1B as the evaluator. The  
batch size is 16 and the learning rate is 5 e−^5. We train the  
model for 20 epochs with 2000 samples per epoch and perform  
early stopping. In the inference and evaluation stage, we use  
five different backbone models as the generators.  
\`\`\`  
\`\`\`  
V. EVALUATIONRESULTS  
In this section, we report and analyze the experimental  
results to answer the following research questions (RQs):  
\`\`\`  
\- RQ1:How effective is RLCoder in repository-level code  
    completion?  
\- RQ2:How effective is RLRetriever compared to other  
    retrieval methods?  
\- RQ3:Does each component of RLCoder contribute to its  
    performance?  
\- RQ4:How is the generalizability of RLCoder?

\`\`\`  
A. RQ1: Effectiveness of RLCoder  
To evaluate the effectiveness of RLCoder, we com-  
pare it with the RawRAG framework \[35\] and Re-  
poCoder \[13\] with five backbone LLMs, i.e., CodeLlama-  
7B \[3\], StartCoder-7B \[4\], StarCoder2-7B, DeepSeekCoder-  
1B \[5\], and DeepSeekCoder-7B. We evalaute the performance  
on CrossCodeEval \[22\] and RepoEval \[13\] benchmarks.  
From the experimental results shown in Table II, we can find  
that the proposed RLCoder demonstrates effectiveness on all  
backbone language models across the four evaluated datasets,  
except for RLCoderDeepSeekCoder-7B evaluated on RepoEval  
API, where its performance is on par with its corresponding  
best baseline RepoCoderDeepSeekCoder-7B. We can also observe  
\`\`\`  
\`\`\`  
1146  
\`\`\`

\`\`\`  
TABLE II  
PERFORMANCE OF DIFFERENT MODELS. THE SUPERSCRIPTS IN PERCENTAGE DENOTE THE IMPROVEMENT RATIOS OFRLCODER OVER THE  
CORRESPONDING BEST BASELINE.  
\`\`\`  
\`\`\`  
Model CrossCodeEval (Python) CrossCodeEval (Java) RepoEval (Line) RepoEval (API)  
EM ES EM ES EM ES EM ES  
RawRAGCodeLlama-7B 21.76 69.09 23.42 66.13 42.31 64.35 34.38 61\.  
RepoCoderCodeLlama-7B 23.34 70.84 24.17 66.56 43.94 65.81 37.00 63\.  
RLCoderCodeLlama-7B 26.60↑14.0% 72.27↑2.0% 26.23↑8.5% 67.61↑1.6% 46.63↑6.1% 67.92↑3.2% 37.94↑2.5% 64.31↑1.3%  
RawRAGStarCoder-7B 22.33 69.60 22.16 67.80 43.81 64.83 31.94 56\.  
RepoCoderStarCoder-7B 23.15 70.71 22.53 68.22 45.69 66.90 33.44 57\.  
RLCoderStarCoder-7B 25.82↑11.5% 72.11↑2.0% 24.73↑9.8% 69.08↑1.3% 47.38↑3.7% 68.46↑2.3% 34.88↑4.3% 58.11↑0.5%  
RawRAGStarCoder2-7B 22.89 70.66 23.42 69.13 44.44 65.95 34.50 58\.  
RepoCoderStarCoder2-7B 24.35 71.71 23.75 69.59 45.81 67.37 36.44 59\.  
RLCoderStarCoder2-7B 27.17↑11.6% 73.24↑2.1% 26.23↑10.4% 70.51↑1.3% 48.25↑5.3% 68.61↑1.8% 38.00↑4.3% 61.21↑2.2%  
RawRAGDeepSeekCoder-1B 19.74 67.68 18.89 62.47 39.31 62.04 33.00 60\.  
RepoCoderDeepSeekCoder-1B 20.23 68.78 19.59 62.35 40.88 63.56 35.13 61\.  
RLCoderDeepSeekCoder-1B 23.98↑18.5% 70.44↑2.4% 20.80↑6.2% 63.39↑1.7% 44.19↑8.1% 66.48↑4.6% 36.06↑2.6% 62.72↑1.3%  
RawRAGDeepSeekCoder-7B 23.30 70.84 22.49 66.78 45.69 66.67 38.00 65\.  
RepoCoderDeepSeekCoder-7B 26.98 72.96 24.96 66.52 46.38 67.51 39.31 66\.  
RLCoderDeepSeekCoder-7B 30.28↑12.2% 74.42↑2.0% 26.09↑4.5% 67.31↑1.2% 48.75↑5.1% 69.43↑2.8% 39.88↑1.5% 66.22↑-0.1%  
\`\`\`  
\`\`\`  
0 2 4 6 8 10 12 14 16 18 20  
Epoch  
\`\`\`  
\`\`\`  
12  
\`\`\`  
\`\`\`  
14  
\`\`\`  
\`\`\`  
16  
\`\`\`  
\`\`\`  
18  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
22  
\`\`\`  
\`\`\`  
EM  
\`\`\`  
\`\`\`  
Language  
Python  
Java  
\`\`\`  
\`\`\`  
Fig. 7\. Performance trajectory curve during the training process.  
\`\`\`  
that among all models, RLCoderDeepSeekCoder-7Bachieves the  
best performance with EM score of 30.28, improving its cor-  
responding best baseline RepoCoderDeepSeekCoder-7Bby 12.2%  
on CrossCodeEval Python and 5.1% on RepoEval Line.  
Furthermore, to investigate the efficacy of our training  
process, we plot the performance trajectory curve across the  
training epochs on CrossCodeEval, as illustrated in Figure 7\.  
The result shows that the EM score gradually increases with  
each epoch until stabilizing, indicating the effectiveness of our  
training process.

\`\`\`  
RQ1 Summary: Our approach significantly outperforms  
current state-of-the-art methods for all backbone LLMs,  
improving the CrossCodeEval benchmark by 12.2% and  
RepoEval 5.1%. The performance trajectory further demon-  
strates the efficacy of our training process.  
\`\`\`  
B. RQ2: Effectiveness of RLRetriever

To assess the effectiveness of RLRetriever, the key module  
of RLCoder, we conduct a comparative study. We evaluate

\`\`\`  
RLCoder equipped with different retrieval methods described  
in Section IV-A, including NoRetrieval, BM25 \[18\], UniX-  
coder \[49\], and our enhanced model UniXcoder-SFT. Table III  
shows the experimental results on the CrossCodeEval and Re-  
poEval benchmarks. The results yield the following findings:  
\`\`\`  
\- Our proposed RLRetriever consistently outperforms com-  
    parative baseline methods under all metrics in both bench-  
    marks, underscoring its superior performance.  
\- All retrieval-based methods (i.e., BM25, UniXCoder,  
    UniXcoder-SFT, and RLRetriever) perform better than  
    NoRetrieval, showing the inherent value of the retrieval  
    process itself.  
\- Both UniXcoder-SFT and RLRetriever show better per-  
    formance than UniXcoder, indicating that retrieval train-  
    ing can enhance the performance. Notably, our rein-  
    forcement learning-based training method exhibits better  
    performance over supervised fine-tuning.  
We proposed the perplexity-based feedback, because it’s  
both lightweight and can simulate the finetuning objectives of  
code completion. As shown in Figure 8, we have plotted the  
scores of EM, ES, and Perplexity (PPL) for DeepSeekCoder-  
7B on two datasets. It can be observed that lower PPL  
generally corresponds to higher EM and ES metrics.

\`\`\`  
RQ2 Summary: RLRetriever consistently outperforms  
other retrieval methods. Furthermore, the results affirms  
the significance of the retrieval and training processes,  
particularly highlighting the advantages of our reinforcement  
learning-based training approach.  
\`\`\`  
\`\`\`  
C. RQ3: Contributions of Each Component  
To understand the contributions of each component to  
RLCoder, we conduct an ablation study on RLCoder. Specif-  
ically, we remove each component of RLCoder each time  
\`\`\`  
\`\`\`  
1147  
\`\`\`

\`\`\`  
TABLE III  
EXPERIMENTAL RESULTS OFRLCODER EQUIPPED WITH DIFFERENT RETRIEVAL METHODS. THE BACKBONELLMUSED ISDEEPSEEKCODER-7B. THE  
SUPERSCRIPTS IN PERCENTAGE DENOTE THE IMPROVEMENT RATIOS OF OUR RETRIEVAL MODELRLRETRIEVER OVER THE CORRESPONDING BEST  
BASELINE RETRIEVER.  
\`\`\`  
\`\`\`  
Retrieval Method CrossCodeEval (Python) CrossCodeEval (Java) RepoEval (Line) RepoEval (API)  
EM ES EM ES EM ES EM ES  
NoRetrieval 9.46 62.79 11.41 63.81 39.63 61.95 30.44 59\.  
BM25 18.31 68.38 17.48 65.23 45.94 66.67 38.25 65\.  
UniXcoder 23.30 70.84 22.49 66.78 45.69 66.67 38.00 65\.  
UniXcoder-SFT 27.28 72.90 25.11 66.39 46.75 67.28 37.69 65\.  
RLRetreiver 30.28↑11.0% 74.42↑2.1% 26.09↑3.9% 67.31↑1.4% 48.75↑4.3% 69.43↑3.2% 39.88↑5.8% 66.22↑1.9%  
\`\`\`  
\`\`\`  
TABLE IV  
ABLATION STUDY RESULTS ONCROSSCODEEVAL ANDREPOEVAL.  
\`\`\`  
\`\`\`  
Model CrossCodeEval (Python) CrossCodeEval (Java) RepoEval (Line) RepoEval (API)  
EM ES EM ES EM ES EM ES  
RLCoder 30.28 74.42 26.09 67.31 48.75 69.43 39.88 66\.  
w/o RL 23.30↓23.1% 70.84↓4.8% 22.49↓13.8% 66.78↓0.8% 45.69↓6.3% 66.67↓4.0% 38.00↓4.7% 65.66↓0.8%  
w/o WP 27.35↓9.7% 72.82↓2.1% 25.67↓1.6% 67.43↑0.2% 47.44↓2.7% 67.83↓2.3% 38.81↓2.7% 65.25↓1.5%  
w/o NC 29.31↓3.2% 73.91↓0.7% 24.03↓7.9% 66.49↓1.2% 47.13↓3.3% 68.11↓1.9% 38.63↓3.1% 65.56↓1.0%  
w/o SS 29.57↓2.34% 74.49↑0.09% 25.57↓1.99% 67.42↑0.16% 47.31↓2.95% 68.23↓1.73% 39.63↓0.63% 65.87↓0.53%  
\`\`\`  
\`\`\`  
Baseline BM25 Unixcoder  
Unixcoder-SFTRLRetriever  
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
cceval\_python  
PPLEM  
ES  
\`\`\`  
\`\`\`  
Baseline BM25 Unixcoder  
Unixcoder-SFTRLRetriever  
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
70 cceval\_java PPL  
EMES  
\`\`\`  
\`\`\`  
Baseline BM25 Unixcoder  
Unixcoder-SFTRLRetriever  
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
70 repoeval\_line PPL  
EMES  
\`\`\`  
\`\`\`  
Baseline BM25 Unixcoder  
Unixcoder-SFTRLRetriever  
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
repoeval\_api  
PPLEM  
ES  
\`\`\`  
Fig. 8\. The relationship between PPL and EM, ES: lower PPL corresponds  
to higher EM and ES.

and study the performance of the ablated model. The ex-  
perimental results are shown in Table IV. “w/o RL” means  
using retriever without reinforcement learning. “w/o WP”  
means utilizing unweighted perplexity of the target code as  
the reward. “w/o NC” means using fixed window candidates  
instead of our natural candidates, “w/o SS” means using  
retriever without the stop signal mechanism. From Table IV,  
we can see that the performance of the model drops after  
removing any one component, indicating that each component  
contributes to the effectiveness of RLCoder. Especially, the  
performance drops the most significantly for “RLCoder w/o  
RL”, indicating that the reinforcement learning mechanism  
is the most important component in RLCoder. We observe  
that unweighted perplexity and no stop mechanism can be

\`\`\`  
TABLE V  
ADDITIONAL ABLATION STUDY FOR THE STOP SIGNAL MECHANISM.  
NOTE THAT,CONTRARY TOEMANDES,LOWERPPLSCORES  
CORRESPOND TO BETTER PERFORMANCE.  
\`\`\`  
\`\`\`  
Model EM ES PPL  
RawRAGCodeLlama-7B 10.3 65.2 2\.  
RLCoderCodeLlama-7B 11.1 66.4 2\.  
w/o Stop Signal 9.9↓10.81% 66.1↓0.45% 2.1152↑1.52%  
RawRAGStarCoder-7B 8.9 59.2 2\.  
RLCoderStarCoder-7B 10.1 61.3 2\.  
w/o Stop Signal 9.1↓9.90% 60.1↓1.96% 2.7100↑1.52%  
RawRAGStarCoder2-7B 9.1 60.5 2\.  
RLCoderStarCoder2-7B 10.3 60.2 2\.  
w/o Stop Signal 9.3↓9.71% 60.5↑0.50% 2.6115↑1.55%  
RawRAGDeepSeekCoder-1B 9.6 64.9 2\.  
RLCoderDeepSeekCoder-1B 10.5 66.7 2\.  
w/o Stop Signal 10.0↓4.76% 65.9↓1.20% 2.4138↑1.57%  
RawRAGDeepSeekCoder-7B 11.5 66.6 2\.  
RLCoderDeepSeekCoder-7B 12.2 68.6 2\.  
w/o Stop Signal 11.8↓3.28% 67.9↓1.02% 2.3157↑1.46%  
\`\`\`  
\`\`\`  
beneficial to ES performance in some cases, but still harm  
EM performance. In fact, ES mainly considers the similarity  
between two pieces of code. The introduction of the stop  
signal and weighted perplexity can both affect code similarity.  
The stop signal reduces useless but similar candidates, while  
weighted perplexity emphasizes API tokens more rather than  
all tokens. This can potentially reduce the similarity between  
generated and target code. Although these strategies weaken  
similarity, they improve code correctness. So removing the  
stop signal and weighted perplexity decreases in EM across  
all benchmarks.  
Since CrossCodeEval and RepoEval are specifically curated  
\`\`\`  
\`\`\`  
1148  
\`\`\`

to evaluate code completion ability in scenarios requiring  
cross-file context, the improvement brought by the stop signal  
is expected to be minor. To further evaluate the practical  
effectiveness of the stop signal mechanism, we construct a  
new dataset GitHubEval that construct code completion targets  
at random positions within repositories, thus incorporating  
instances that may not necessitate cross-file context. Following  
the same construction procedure as the training dataset, we  
obtain 1000 samples for evaluation. The results shown in  
Table V indicate that the stop signal is an important component  
in RLCoder, without which, the EM scores drop significantly  
by an average of 7.69%.

\`\`\`  
RQ3 Summary: Reinforcement learning mechanism is the  
most important component in RLCoder. Other components  
of RLCoder also contributes to its superior performance,  
with the stop signal mechanism showing further enhance-  
ments in scenarios involving target code completion that  
both require and do not require cross-file context.  
\`\`\`  
D. RQ4: Generalizability of RLCoder

To explore the generalizability of RLCoder, we conduct  
an evaluation with a setting different from the training stage.  
Specifically, we train a new retriever by fusing RLCoder and  
RepoCoder. Then, we evaluate the performance of the fused  
model. As shown in Table VI, we find that RepoCoder trained  
using the framework of RLCoder significantly outperforms  
the original RepoCoder method. Specifically, the improvement  
rates in EM for Python and Java are 12.4% and 8.1% on  
CrossCodeEval, respectively. This result indicates that our  
training framework can be integrated into other models to  
further improve their performance. Note that when comparing  
“RepoCoder w/ RLCoder” to RLCoder, they have comparable  
performance (with “RepoCoder w/ RLCoder” slightly better).  
However, considering that RepoCoder requires multiple itera-  
tions of retrieval and generation, we opt for RLCoder, which  
accomplishes code completion in a single round, as the default  
setting in this work.

\`\`\`  
RQ4 Summary: The training pipeline of RLCoder shows  
generalizability on all datasets in applying to other frame-  
works.  
\`\`\`  
E. Case Study

We illustrate the effectiveness of RLCoder through a case  
study presented in Figure 9\. The left-hand side shows the  
incomplete code, groundtruth code, and the gold candidate  
we labelled for this case. We can see that RLCoder ranks the  
gold candidate as the first candidate and generates the correct  
code. A possible reason that other methods fail to retrieve  
the correct code is that these methods rely on the surface-  
level similarity between the query and the candidate. The bad

\`\`\`  
candidate, despite sharing several tokens with the query (as  
highlighted in the figure), does not contribute meaningfully to  
the correct code completion. In contrast to RepoCoder, which  
iteratively uses generated code for retrieval and generation but  
still depends heavily on query-candidate similarity, RLCoder  
leverages the perplexity of generating target code from a  
given candidate. This approach enables RLRetriever to bypass  
candidates that are seemingly useful but actually useless,  
focusing instead on those more likely to aid in accurate code  
generation. This strategic prioritization explains RLCoder’s  
success in both retrieving the gold candidate and generating  
the correct target code.  
\`\`\`  
\#\#\#\# VI. RELATEDWORK

\`\`\`  
A. Code Completion  
Code completion, recognized as one of the most crucial  
tasks in modern integrated development environments (IDEs),  
has garnered significant attention from researchers \[51\]–\[55\].  
Traditional approaches to code completion typically rely on  
rule-based methods or leverage code examples to predict  
the next sequence of code \[56\]–\[58\]. While these methods  
have shown some effectiveness, they often struggle to adapt  
to the complexities and nuances of real-world programming  
scenarios. In recent years, deep learning-based methods \[9\],  
\[10\], \[54\], \[59\]–\[71\] have been explored to improve the  
performance of code completion. Recent studies found that  
code search can enhance code completion performance \[72\].  
With the development of large language models \[73\]–\[82\],  
many researchers have introduced LLMs into code comple-  
tion \[83\]–\[87\]. Equipped with LLMs, many studies have  
employed RAG for code completion/generation \[32\], \[34\]–  
\[37\], \[40\]. For example, RedCoder \[35\] enhances code gen-  
eration and summarization by integrating relevant past work  
using dense retrieval techniques. To enhance private library  
code generation, APICoder \[37\] was proposed to employ  
API documentation to train models to better generate these  
libraries. DocPrompting \[36\] introduces a method to enhance  
code generation by using code documentation to address  
the challenge of generating code for unseen functions and  
libraries. AceCoder \[34\] improves code generation by inte-  
grating example retrieval and guided generation. ReCode \[40\]  
improves neural code generation by incorporating subtree  
retrieval from existing code examples. kNN-TRANX \[32\]  
improves code generation from natural language by using  
syntax-aware retrieval, reducing noise and computational time.  
\`\`\`  
\`\`\`  
B. Repository-Level Code Completion  
Repository-level code completion, which leverages the  
broader context of an entire code repository, has become a fo-  
cal point for research in the field of code completion and many  
studies have attempted to improve repository-level code com-  
pletion performance \[12\]–\[17\], \[19\], \[21\], \[48\]. CoCoMIC \[12\]  
and RepoHyper \[19\] enhance code completion capabilities  
\`\`\`  
\`\`\`  
1149  
\`\`\`

\`\`\`  
TABLE VI  
EXPERIMENTAL RESULTS OFREPOCODER INTEGRATED WITHRLCODER.  
\`\`\`  
\`\`\`  
Method CrossCodeEval (Python) CrossCodeEval (Java) RepoEval (Line) RepoEval (API)  
EM ES EM ES EM ES EM ES  
RawRAG 23.30 70.84 22.49 66.78 45.69 66.67 38.00 65\.  
RLCoder 30.28 74.42 26.09 67.31 48.75 69.43 39.88 66\.  
RepoCoder 26.98 72.96 24.96 66.52 46.38 67.51 39.31 66\.  
w/ RLCoder 30.32↑12.4% 74.79↑2.5% 26.98↑8.1% 67.81↑1.9% 49.44↑6.6% 69.76↑3.3% 41.25↑4.9% 67.08↑1.2%  
\`\`\`  
\`\`\`  
\# similarity\_filter.py  
fromfrom typing common.constantsimport List import Constants  
from common.utils import Utils  
RATE \= 2  
class SimilarityFilter:  
def \_\_init\_\_(selfalgorithm\_type, detect\_data: str: List\[, anomalyfloat\_\], duration: int):  
self.algorithm\_type \=algorithm\_type  
selfself..detect\_dataanomaly\_duration \= self \=.minus\_dataanomaly\_duration(detect\_data)  
def run(self):  
"""  
Check if the current data is similar to the historical data.  
:return: True if the current data is similar to the historical data."""  
agg\_list \= Utils.  
\`\`\`  
\`\`\`  
\# utils.py  
@staticmethod  
def agg\_diff\_fe\_calc(input\_data: List\[float\], agg\_length: int) \-\> list:  
...diff\_func: Callable\[\[Any, Any\], None\] \= lambda a, b: np.sum(a) \- np.sum(b)  
diff \= \[\]  
for i in range(len(input\_data) \- 2 \* agg\_length \+ 1 ):  
post \= input\_data\[i \+ agg\_length:i \+ 2 \* agg\_length\]  
pre \= input\_data\[i:i \+ agg\_length\]  
diff.append(diff\_func(post, pre))  
return diff  
\`\`\`  
\`\`\`  
Gold Candidate RawRAGUniXcoder aggregate\_data(self.detect\_data, self.anomaly\_duration)  
RawRAGUniXcoder-SFT agg\_diff\_fe\_calc(self.detect\_data, Constants.AGG\_LENGTH)  
\`\`\`  
\`\`\`  
get\_agg\_list(self.detect\_data, self.anomaly\_duration)  
\`\`\`  
\`\`\`  
RLCoder agg\_diff\_fe\_calc(self.detect\_data, self.anomaly\_duration)  
\`\`\`  
\`\`\`  
Query (IncompleteCode)  
\`\`\`  
\`\`\`  
Code To Generate  
\`\`\`  
\`\`\`  
\# diff\_outlier\_detector.py  
class DiffOutlierDetector:  
def \_\_selfinit.algorithm\_type\_\_(self, detect\_data \=algorithm\_type: List\[float\], algorithm\_type: str):  
self.detect\_data \= self.minus\_data(detect\_data)  
self.default\_point \= 4  
self.alarm\_last\_time \= 15  
\`\`\`  
selfself..tk\_deltadefault\_ (^) duration= 2.0 \= 1  
\# output  
self.real\_duration \= 0  
def run"""(self):  
Detect an anomaly using the previous difference.  
\*\*Bad Candidate\*\*  
3rd Candidate  
1st Candidate  
Not Found  
1st Candidate  
\*\*Groundtruth\*\* agg\_diff\_fe\_calc(self.detect\_data, self.anomaly\_duration)  
\*\*RepoCoder\*\*  
Not Found  
Not Found  
Fig. 9\. Case study. An example sources from CrossCodeEval with thetaskidbeingprojectccpython/210. The highlight token represents the identical  
tokens exists in both the query and the bad candidate.  
through dependency analysis and learning-based methods but  
they encounter the problem of difficulty in obtaining training  
data and poor generalizability. CodePlan \[14\], RepoFuse \[15\]  
andA^3 \-CodeGen \[21\] employ static code analysis to obtain  
relevant candidates. RepoCoder \[13\] and De-Hallucinator \[16\]  
adopt an approach through iterative retrieval and generation.  
CodeAgent \[17\] and ToolGen \[48\] explore tool invocation to  
help code completion.  
Although these efforts show promising performance, there  
are still many areas for improvement. Existing methods often  
overlook the importance of retriever, leading to the retrieved  
candidates not being needed for generation. Additionally,  
the lack of training data makes it difficult to fine-tune the  
retriever. RLCoder differs from them in that it does not require  
labeled data for training. Instead, it obtains feedback from  
the generator as a reward for training. Besides, to evaluate  
the usefulness of candidates, RLCoder uses a novel stop  
signal mechanism to determine when to retrieve and which  
candidates to retain. Furthermore, we propose a new candidate  
construction strategy for repository code.

\#\#\#\# VII. CONCLUSION

\`\`\`  
In this paper, we propose RLCoder, a novel reinforcement  
learning framework for repository-level code completion. We  
enable the retriever to learn iteratively by obtaining feedback  
from the evaluator. Besides, unlike using fixed window candi-  
dates or candidates parsing from dependency, we introduce  
a simple yet effective Split-Aggregate candidate construc-  
tion method based on human programming habits. Moreover,  
we propose the stop signal to avoid using useless cross-  
file context. Experimental results indicate that RLCoder is  
capable of ignoring thoseseemingly useful but actually useless  
candidates, capturing ones that are beneficial for accurate code  
generation. This feature lets RLCoder achieve state-of-the-  
art performance on repository-level code completion. Besides,  
RLCoder demonstrates good generalizability and applicability  
to further enhancing existing methods.  
\`\`\`  
\`\`\`  
ACKNOWLEDGEMENTS  
The work described in this paper is supported by CCF-  
Huawei Populus Grove Fund CCF-HuaweiSE202301.  
\`\`\`  
\`\`\`  
1150  
\`\`\`

\#\#\#\# REFERENCES

\[1\] M. Chen, J. Tworek, H. Jun, Q. Yuan, H. P. d. O. Pinto, J. Kaplan,  
H. Edwards, Y. Burda, N. Joseph, G. Brockmanet al., “Evaluating large  
language models trained on code,”arXiv preprint arXiv:2107.03374,  
2021\.  
\[2\] E. Nijkamp, B. Pang, H. Hayashi, L. Tu, H. Wang, Y. Zhou, S. Savarese,  
and C. Xiong, “Codegen: An open large language model for code with  
multi-turn program synthesis,”arXiv preprint arXiv:2203.13474, 2022\.  
\[3\] B. Roziere, J. Gehring, F. Gloeckle, S. Sootla, I. Gat, X. E. Tan, Y. Adi,  
J. Liu, T. Remez, J. Rapinet al., “Code llama: Open foundation models  
for code,”arXiv preprint arXiv:2308.12950, 2023\.  
\[4\] R. Li, L. B. Allal, Y. Zi, N. Muennighoff, D. Kocetkov, C. Mou,  
M. Marone, C. Akiki, J. Li, J. Chimet al., “Starcoder: may the source  
be with you\!”arXiv preprint arXiv:2305.06161, 2023\.  
\[5\] D. Guo, Q. Zhu, D. Yang, Z. Xie, K. Dong, W. Zhang, G. Chen,  
X. Bi, Y. Wu, Y. Liet al., “Deepseek-coder: When the large language  
model meets programming–the rise of code intelligence,”arXiv preprint  
arXiv:2401.14196, 2024\.  
\[6\] F. Liu, Z. Fu, G. Li, Z. Jin, H. Liu, Y. Hao, and L. Zhang, “Non-  
autoregressive line-level code completion,”ACM Transactions on Soft-  
ware Engineering and Methodology, 2024\.  
\[7\] C. Wang, J. Hu, C. Gao, Y. Jin, T. Xie, H. Huang, Z. Lei, and Y. Deng,  
“How practitioners expect code completion?” inProceedings of the 31st  
ACM Joint European Software Engineering Conference and Symposium  
on the Foundations of Software Engineering, 2023, pp. 1294–1306.  
\[8\] V. J. Hellendoorn, S. Proksch, H. C. Gall, and A. Bacchelli, “When  
code completion fails: A case study on real-world completions,” in  
2019 IEEE/ACM 41st International Conference on Software Engineering  
(ICSE). IEEE, 2019, pp. 960–970.  
\[9\] M. Izadi, R. Gismondi, and G. Gousios, “Codefill: Multi-token code  
completion by jointly learning from structure and naming sequences,”  
inProceedings of the 44th International Conference on Software Engi-  
neering, 2022, pp. 401–412.  
\[10\] W. Zhou, S. Kim, V. Murali, and G. A. Aye, “Improving code autocom-  
pletion with transfer learning,” inProceedings of the 44th International  
Conference on Software Engineering: Software Engineering in Practice,  
2022, pp. 161–162.  
\[11\] M. Izadi, J. Katzy, T. van Dam, M. Otten, R. M. Popescu, and  
A. van Deursen, “Language models for code completion: A practical  
evaluation,”arXiv preprint arXiv:2402.16197, 2024\.  
\[12\] Y. Ding, Z. Wang, W. U. Ahmad, M. K. Ramanathan, R. Nallapati,  
P. Bhatia, D. Roth, and B. Xiang, “Cocomic: Code completion by jointly  
modeling in-file and cross-file context,” 2023\.  
\[13\] F. Zhang, B. Chen, Y. Zhang, J. Keung, J. Liu, D. Zan, Y. Mao, J.-  
G. Lou, and W. Chen, “Repocoder: Repository-level code completion  
through iterative retrieval and generation,” 2023\.  
\[14\] R. Bairi, A. Sonwane, A. Kanade, A. Iyer, S. Parthasarathy, S. Rajamani,  
B. Ashok, S. Shetet al., “Codeplan: Repository-level coding using llms  
and planning,”arXiv preprint arXiv:2309.12499, 2023\.  
\[15\] M. Liang, X. Xie, G. Zhang, X. Zheng, P. Di, H. Chen, C. Wang,  
G. Fanet al., “Repofuse: Repository-level code completion with fused  
dual context,”arXiv preprint arXiv:2402.14323, 2024\.  
\[16\] A. Eghbali and M. Pradel, “De-hallucinator: Iterative grounding for llm-  
based code completion,”arXiv preprint arXiv:2401.01701, 2024\.  
\[17\] K. Zhang, J. Li, G. Li, X. Shi, and Z. Jin, “Codeagent: Enhancing code  
generation with tool-integrated agent systems for real-world repo-level  
coding challenges,”arXiv preprint arXiv:2401.07339, 2024\.  
\[18\] S. Robertson, H. Zaragozaet al., “The probabilistic relevance frame-  
work: Bm25 and beyond,”Foundations and Trends® in Information  
Retrieval, vol. 3, no. 4, pp. 333–389, 2009\.  
\[19\] H. N. Phan, H. N. Phan, T. N. Nguyen, and N. D. Bui, “Repohyper:  
Better context retrieval is all you need for repository-level code com-  
pletion,”arXiv preprint arXiv:2403.06095, 2024\.  
\[20\] D. Wu, W. U. Ahmad, D. Zhang, M. K. Ramanathan, and X. Ma,  
“Repoformer: Selective retrieval for repository-level code completion,”  
arXiv preprint arXiv:2403.10059, 2024\.  
\[21\] D. Liao, S. Pan, Q. Huang, X. Ren, Z. Xing, H. Jin, and Q. Li, “Context-  
aware code generation framework for code repositories: Local, global,  
and third-party library awareness,”arXiv preprint arXiv:2312.05772,  
2023\.  
\[22\] Y. Ding, Z. Wang, W. Ahmad, H. Ding, M. Tan, N. Jain, M. K.  
Ramanathan, R. Nallapati, P. Bhatia, D. Rothet al., “Crosscodeeval:

\`\`\`  
A diverse and multilingual benchmark for cross-file code completion,”  
Advances in Neural Information Processing Systems, vol. 36, 2024\.  
\[23\] Y. Gao, Y. Xiong, X. Gao, K. Jia, J. Pan, Y. Bi, Y. Dai, J. Sun, and  
H. Wang, “Retrieval-augmented generation for large language models:  
A survey,”arXiv preprint arXiv:2312.10997, 2023\.  
\[24\] P. Zhao, H. Zhang, Q. Yu, Z. Wang, Y. Geng, F. Fu, L. Yang, W. Zhang,  
and B. Cui, “Retrieval-augmented generation for ai-generated content:  
A survey,”arXiv preprint arXiv:2402.19473, 2024\.  
\[25\] B. Cao, D. Cai, L. Cui, X. Cheng, W. Bi, Y. Zou, and S. Shi, “Retrieval  
is accurate generation,”arXiv preprint arXiv:2402.17532, 2024\.  
\[26\] Z. He, Z. Zhong, T. Cai, J. D. Lee, and D. He, “Rest: Retrieval-based  
speculative decoding,”arXiv preprint arXiv:2311.08252, 2023\.  
\[27\] N. Nashid, M. Sintaha, and A. Mesbah, “Retrieval-based prompt se-  
lection for code-related few-shot learning,” in2023 IEEE/ACM 45th  
International Conference on Software Engineering (ICSE). IEEE, 2023,  
pp. 2450–2462.  
\[28\] Y. Liu, S. Yavuz, R. Meng, D. Radev, C. Xiong, and Y. Zhou, “Uni-  
parser: Unified semantic parser for question answering on knowledge  
base and database,”arXiv preprint arXiv:2211.05165, 2022\.  
\[29\] S. Lu, N. Duan, H. Han, D. Guo, S.-w. Hwang, and A. Svyatkovskiy,  
“Reacc: A retrieval-augmented code completion framework,”arXiv  
preprint arXiv:2203.07722, 2022\.  
\[30\] C. Yu, G. Yang, X. Chen, K. Liu, and Y. Zhou, “Bashexplainer:  
Retrieval-augmented bash code comment generation based on fine-  
tuned codebert,” in2022 IEEE International Conference on Software  
Maintenance and Evolution (ICSME). IEEE, 2022, pp. 82–93.  
\[31\] J. A. Li, Y. Li, G. Li, X. Hu, X. Xia, and Z. Jin, “Editsum: A  
retrieve-and-edit framework for source code summarization,” in 2021  
36th IEEE/ACM International Conference on Automated Software En-  
gineering (ASE). IEEE, 2021, pp. 155–166.  
\[32\] X. Zhang, Y. Zhou, G. Yang, and T. Chen, “Syntax-aware retrieval  
augmented code generation,” inThe 2023 Conference on Empirical  
Methods in Natural Language Processing, 2023\.  
\[33\] J. Zhang, X. Wang, H. Zhang, H. Sun, and X. Liu, “Retrieval-based  
neural source code summarization,” inProceedings of the ACM/IEEE  
42nd International Conference on Software Engineering, 2020, pp.  
1385–1397.  
\[34\] J. Li, Y. Zhao, Y. Li, G. Li, and Z. Jin, “Acecoder: Utilizing existing code  
to enhance code generation,”arXiv preprint arXiv:2303.17780, 2023\.  
\[35\] M. R. Parvez, W. U. Ahmad, S. Chakraborty, B. Ray, and K.-W.  
Chang, “Retrieval augmented code generation and summarization,”  
arXiv preprint arXiv:2108.11601, 2021\.  
\[36\] S. Zhou, U. Alon, F. F. Xu, Z. Wang, Z. Jiang, and G. Neubig,  
“Docprompting: Generating code by retrieving the docs,”arXiv preprint  
arXiv:2207.05987, 2022\.  
\[37\] D. Zan, B. Chen, Z. Lin, B. Guan, Y. Wang, and J.-G. Lou, “When  
language model meets private library,”arXiv preprint arXiv:2210.17236,  
2022\.  
\[38\] A. Madaan, S. Zhou, U. Alon, Y. Yang, and G. Neubig, “Language  
models of code are few-shot commonsense learners,”arXiv preprint  
arXiv:2210.07128, 2022\.  
\[39\] Y. Wang, H. Le, A. D. Gotmare, N. D. Bui, J. Li, and S. C. Hoi,  
“Codet5+: Open code large language models for code understanding  
and generation,”arXiv preprint arXiv:2305.07922, 2023\.  
\[40\] S. A. Hayati, R. Olivier, P. Avvaru, P. Yin, A. Tomasic, and  
G. Neubig, “Retrieval-based neural code generation,”arXiv preprint  
arXiv:1808.10025, 2018\.  
\[41\] N. Beau and B. Crabb ́e, “The impact of lexical and grammatical  
processing on generating code from natural language,”arXiv preprint  
arXiv:2202.13972, 2022\.  
\[42\] T. Ahmed, K. S. Pai, P. Devanbu, and E. T. Barr, “Automatic semantic  
augmentation of language model prompts (for code summarization),” in  
2024 IEEE/ACM 46th International Conference on Software Engineer-  
ing (ICSE). IEEE Computer Society, 2024, pp. 1004–1004.  
\[43\] J. Austin, A. Odena, M. Nye, M. Bosma, H. Michalewski, D. Dohan,  
E. Jiang, C. Cai, M. Terry, Q. Leet al., “Program synthesis with large  
language models,”arXiv preprint arXiv:2108.07732, 2021\.  
\[44\] S. Bubeck, V. Chandrasekaran, R. Eldan, J. Gehrke, E. Horvitz, E. Ka-  
mar, P. Lee, Y. T. Lee, Y. Li, S. Lundberget al., “Sparks of artificial  
general intelligence: Early experiments with gpt-4,” arXiv preprint  
arXiv:2303.12712, 2023\.  
\[45\] H. Yu, B. Shen, D. Ran, J. Zhang, Q. Zhang, Y. Ma, G. Liang, Y. Li,  
Q. Wang, and T. Xie, “Codereval: A benchmark of pragmatic code  
generation with generative pre-trained models,” inProceedings of the  
\`\`\`  
\`\`\`  
1151  
\`\`\`

46th IEEE/ACM International Conference on Software Engineering,  
2024, pp. 1–12.  
\[46\] S. Hong, X. Zheng, J. Chen, Y. Cheng, J. Wang, C. Zhang, Z. Wang,  
S. K. S. Yau, Z. Lin, L. Zhouet al., “Metagpt: Meta programming for  
multi-agent collaborative framework,”arXiv preprint arXiv:2308.00352,  
2023\.  
\[47\] D. Huang, Q. Bu, J. M. Zhang, M. Luck, and H. Cui, “Agentcoder:  
Multi-agent-based code generation with iterative testing and optimisa-  
tion,”arXiv preprint arXiv:2312.13010, 2023\.  
\[48\] C. Wang, J. Zhang, Y. Feng, T. Li, W. Sun, Y. Liu, and X. Peng,  
“Teaching code llms to use autocompletion tools in repository-level code  
generation,”arXiv preprint arXiv:2401.06391, 2024\.  
\[49\] D. Guo, S. Lu, N. Duan, Y. Wang, M. Zhou, and J. Yin, “Unixcoder:  
Unified cross-modal pre-training for code representation,”arXiv preprint  
arXiv:2203.03850, 2022\.  
\[50\] V. I. Levenshteinet al., “Binary codes capable of correcting deletions,  
insertions, and reversals,” inSoviet physics doklady, vol. 10, no. 8\.  
Soviet Union, 1966, pp. 707–710.  
\[51\] C. Liu, X. Xia, D. Lo, C. Gao, X. Yang, and J. Grundy, “Opportunities  
and challenges in code search tools,”ACM Computing Surveys (CSUR),  
vol. 54, no. 9, pp. 1–40, 2021\.  
\[52\] J. Chen, C. Chen, J. Hu, J. Grundy, Y. Wang, T. Chen, and Z. Zheng,  
“Identifying smart contract security issues in code snippets from stack  
overflow,”arXiv preprint arXiv:2407.13271, 2024\.  
\[53\] Y. Wang, T. Jiang, M. Liu, J. Chen, and Z. Zheng, “Beyond functional  
correctness: Investigating coding style inconsistencies in large language  
models,”arXiv preprint arXiv:2407.00456, 2024\.  
\[54\] Y. Wang and H. Li, “Code completion by modeling flattened abstract  
syntax trees as graphs,” inProceedings of the AAAI conference on  
artificial intelligence, vol. 35, no. 16, 2021, pp. 14 015–14 023\.  
\[55\] W. Tao, Y. Zhou, Y. Wang, H. Zhang, H. Wang, and W. Zhang, “Kadel:  
Knowledge-aware denoising learning for commit message generation,”  
ACM Transactions on Software Engineering and Methodology, 2024\.  
\[56\] M. Bruch, M. Monperrus, and M. Mezini, “Learning from examples  
to improve code completion systems,” inProceedings of the 7th joint  
meeting of the European software engineering conference and the ACM  
SIGSOFT symposium on the foundations of software engineering, 2009,  
pp. 213–222.  
\[57\] D. Hou and D. M. Pletcher, “Towards a better code completion system  
by api grouping, filtering, and popularity-based ranking,” inProceedings  
of the 2nd International Workshop on Recommendation Systems for  
Software Engineering, 2010, pp. 26–30.  
\[58\] R. Robbes and M. Lanza, “How program history can improve code  
completion,” in2008 23rd IEEE/ACM International Conference on  
Automated Software Engineering. IEEE, 2008, pp. 317–326.  
\[59\] Y. Chen, C. Gao, X. Ren, Y. Peng, X. Xia, and M. R. Lyu, “Api usage  
recommendation via multi-view heterogeneous graph representation  
learning,”IEEE Transactions on Software Engineering, 2023\.  
\[60\] C. Wang, X. Peng, M. Liu, Z. Xing, X. Bai, B. Xie, and T. Wang, “A  
learning-based approach for automatic construction of domain glossary  
from source code and documentation,” inProceedings of the 2019 27th  
ACM joint meeting on european software engineering conference and  
symposium on the foundations of software engineering, 2019, pp. 97–  
108\.  
\[61\] M. Liu, X. Peng, A. Marcus, Z. Xing, W. Xie, S. Xing, and Y. Liu,  
“Generating query-specific class api summaries,” inProceedings of  
the 2019 27th ACM joint meeting on European software engineering  
conference and symposium on the foundations of software engineering,  
2019, pp. 120–130.  
\[62\] X. Wang, Y. Wang, Y. Wan, F. Mi, Y. Li, P. Zhou, J. Liu, H. Wu,  
X. Jiang, and Q. Liu, “Compilable neural code generation with compiler  
feedback,”arXiv preprint arXiv:2203.05132, 2022\.  
\[63\] G. A. Aye and G. E. Kaiser, “Sequence model design for code comple-  
tion in the modern ide,”arXiv preprint arXiv:2004.05249, 2020\.  
\[64\] V. J. Hellendoorn and P. Devanbu, “Are deep neural networks the best  
choice for modeling source code?” inProceedings of the 2017 11th Joint  
meeting on foundations of software engineering, 2017, pp. 763–773.  
\[65\] R.-M. Karampatsis, H. Babii, R. Robbes, C. Sutton, and A. Janes,  
“Big code\!= big vocabulary: Open-vocabulary models for source code,”  
inProceedings of the ACM/IEEE 42nd International Conference on  
Software Engineering, 2020, pp. 1073–1085.  
\[66\] S. Kim, J. Zhao, Y. Tian, and S. Chandra, “Code prediction by feeding  
trees to transformers,” in2021 IEEE/ACM 43rd International Conference  
on Software Engineering (ICSE). IEEE, 2021, pp. 150–162.

\`\`\`  
\[67\] J. Li, Y. Wang, M. R. Lyu, and I. King, “Code completion with neural  
attention and pointer networks,”arXiv preprint arXiv:1711.09573, 2017\.  
\[68\] S. Nguyen, T. Nguyen, Y. Li, and S. Wang, “Combining program anal-  
ysis and statistical language model for code statement completion,” in  
2019 34th IEEE/ACM International Conference on Automated Software  
Engineering (ASE). IEEE, 2019, pp. 710–721.  
\[69\] A. Svyatkovskiy, S. K. Deng, S. Fu, and N. Sundaresan, “Intellicode  
compose: Code generation using transformer,” inProceedings of the  
28th ACM joint meeting on European software engineering conference  
and symposium on the foundations of software engineering, 2020, pp.  
1433–1443.  
\[70\] F. Wen, E. Aghajani, C. Nagy, M. Lanza, and G. Bavota, “Siri, write  
the next method,” in2021 IEEE/ACM 43rd International Conference on  
Software Engineering (ICSE). IEEE, 2021, pp. 138–149.  
\[71\] Y. Yang, Y. Jiang, M. Gu, J. Sun, J. Gao, and H. Liu, “A language model  
for statements of software code,” in2017 32nd IEEE/ACM International  
Conference on Automated Software Engineering (ASE). IEEE, 2017,  
pp. 682–687.  
\[72\] J. Chen, X. Hu, Z. Li, C. Gao, X. Xia, and D. Lo, “Code search is all  
you need? improving code suggestions with code search,”Proceedings of  
the 46th IEEE/ACM International Conference on Software Engineering,  
2024\.  
\[73\] J. Lu, W. Zhong, Y. Wang, Z. Guo, Q. Zhu, W. Huang, Y. Wang, F. Mi,  
B. Wang, Y. Wanget al., “Yoda: Teacher-student progressive learning  
for language models,”arXiv preprint arXiv:2401.15670, 2024\.  
\[74\] F. Hu, Y. Wang, L. Du, H. Zhang, S. Han, D. Zhang, and X. Li,  
“Split, encode and aggregate for long code search,”arXiv preprint  
arXiv:2208.11271, 2022\.  
\[75\] Y. Liu, J. Chen, T. Bi, J. Grundy, Y. Wang, T. Chen, Y. Tang,  
and Z. Zheng, “An empirical study on low code programming us-  
ing traditional vs large language model support,” arXiv preprint  
arXiv:2402.01156, 2024\.  
\[76\] Y. Wang, Y. Huang, D. Guo, H. Zhang, and Z. Zheng, “Sparsecoder:  
Identifier-aware sparse transformer for file-level code summarization,”  
arXiv preprint arXiv:2401.14727, 2024\.  
\[77\] J. Zhou, W. Zhong, Y. Wang, and J. Wang, “Adaptive-solver framework  
for dynamic strategy selection in large language model reasoning,”arXiv  
preprint arXiv:2310.01446, 2023\.  
\[78\] E. Shi, F. Zhang, Y. Wang, B. Chen, L. Du, H. Zhang, S. Han, D. Zhang,  
and H. Sun, “Sotana: The open-source software development assistant,”  
arXiv preprint arXiv:2308.13416, 2023\.  
\[79\] Z. Zheng, K. Ning, Y. Wang, J. Zhang, D. Zheng, M. Ye, and J. Chen,  
“A survey of large language models for code: Evolution, benchmarking,  
and future trends,”arXiv preprint arXiv:2311.10372, 2023\.  
\[80\] Z. Zheng, K. Ning, J. Chen, Y. Wang, W. Chen, L. Guo, and W. Wang,  
“Towards an understanding of large language models in software engi-  
neering tasks,”arXiv preprint arXiv:2308.11396, 2023\.  
\[81\] C. Chen, J. Su, J. Chen, Y. Wang, T. Bi, Y. Wang, X. Lin, T. Chen, and  
Z. Zheng, “When chatgpt meets smart contract vulnerability detection:  
How far are we?”arXiv preprint arXiv:2309.05520, 2023\.  
\[82\] W. Zhong, R. Cui, Y. Guo, Y. Liang, S. Lu, Y. Wang, A. Saied, W. Chen,  
and N. Duan, “Agieval: A human-centric benchmark for evaluating  
foundation models,”arXiv preprint arXiv:2304.06364, 2023\.  
\[83\] M. Liu, Y. Yang, Y. Lou, X. Peng, Z. Zhou, X. Du, and T. Yang,  
“Recommending analogical apis via knowledge graph embedding,” in  
Proceedings of the 31st ACM Joint European Software Engineering  
Conference and Symposium on the Foundations of Software Engineering,  
2023, pp. 1496–1508.  
\[84\] X. Jiang, Y. Dong, Z. Jin, and G. Li, “Seed: Customize large language  
models with sample-efficient adaptation for code generation,”arXiv  
preprint arXiv:2403.00046, 2024\.  
\[85\] B. Li, Z. Sun, T. Huang, H. Zhang, Y. Wan, G. Li, Z. Jin, and C. Lyu,  
“Ircoco: Immediate rewards-guided deep reinforcement learning for code  
completion,”arXiv preprint arXiv:2401.16637, 2024\.  
\[86\] Y. Zhu, J. A. Li, G. Li, Y. Zhao, J. Li, Z. Jin, and H. Mei, “Improving  
code generation by dynamic temperature sampling,”arXiv preprint  
arXiv:2309.02772, 2023\.  
\[87\] L. Guo, Y. Wang, E. Shi, W. Zhong, h. Zhang, j. Chen, R. Zhang, y. Ma,  
and Z. Zheng, “When to stop? towards efficient code generation in llms  
with excess token prevention,” inProceedings of the 33st ACM SIGSOFT  
international symposium on software testing and analysis, 2024\.  
\`\`\`  
\`\`\`  
1152  
\`\`\`


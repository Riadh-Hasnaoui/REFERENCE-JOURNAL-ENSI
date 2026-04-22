\#\# What to Retrieve for Effective Retrieval-Augmented Code

\#\# Generation? An Empirical Study and Beyond

\#\# Wenchao GU

\#\#\# Technical University of Munich

\#\#\# Heilbronn, Germany

\#\#\# wenchao.gu@tum.de

\#\# Juntao Chen

\#\#\# Sun Yat-Sen University

\#\#\# Zhuhai, China

\#\#\# chenjt75@mail2.sysu.edu.cn

\#\# Yanlin Wang

\#\#\# Sun Yat-Sen University

\#\#\# Zhuhai, China

\#\#\# yanlin-wang@outlook.com

\#\# Tianyue Jiang

\#\#\# Sun Yat-Sen University

\#\#\# Zhuhai, China

\#\#\# jiangty9@mail2.sysu.edu.cn

\#\# Xingzhe Li

\#\#\# Sun Yat-Sen University

\#\#\# Zhuhai, China

\#\#\# lixzh75@mail2.sysu.edu.cn

\#\# Mingwei Liu

\#\#\# Sun Yat-Sen University

\#\#\# Zhuhai, China

\#\#\# liumw26@mail.sysu.edu.cn

\#\# Xilin Liu

\#\#\# Huawei Cloud Computing

\#\#\# Technologies Co., Ltd

\#\#\# Shenzhen, China

\#\#\# liuxilin3@huawei.com

\#\# Yuchi Ma

\#\#\# Huawei Cloud Computing

\#\#\# Technologies Co., Ltd

\#\#\# Shenzhen, China

\#\#\# mayuchi1@huawei.com

\#\# Zibin Zheng

\#\#\# Sun Yat-Sen University

\#\#\# Zhuhai, China

\#\#\# zhzibin@mail.sysu.edu.cn

\#\# Abstract

\`\`\`  
Repository-level code generation remains challenging due to com-  
plex code dependencies and the limitations of large language models  
(LLMs) in processing long contexts. While retrieval-augmented gen-  
eration (RAG) frameworks are widely adopted, the effectiveness of  
different retrieved information sources—contextual code, APIs, and  
similar snippets—has not been rigorously analyzed. Through an em-  
pirical study on two benchmarks, we demonstrate that in-context  
code and potential API information significantly enhance LLM per-  
formance, whereas retrieved similar code often introduces noise,  
degrading results by up to 15%. Based on the preliminary results,  
we propose AllianceCoder, a novel context-integrated method that  
employs chain-of-thought prompting to decompose user queries  
into implementation steps and retrieves APIs via semantic descrip-  
tion matching. Through extensive experiments on CoderEval and  
RepoExec, AllianceCoder achieves state-of-the-art performance, im-  
proving Pass@1 by up to 20% over existing approaches. This study  
provides an experimental framework to further exploringwhat to  
retrievein RAG-based code generation, with our replication pack-  
age available at https://anonymous.4open.science/r/AllianceCoder  
to facilitate future research.  
\`\`\`  
\`\`\`  
Permission to make digital or hard copies of all or part of this work for personal or  
classroom use is granted without fee provided that copies are not made or distributed  
for profit or commercial advantage and that copies bear this notice and the full citation  
on the first page. Copyrights for components of this work owned by others than the  
author(s) must be honored. Abstracting with credit is permitted. To copy otherwise, or  
republish, to post on servers or to redistribute to lists, requires prior specific permission  
and/or a fee. Request permissions from permissions@acm.org.  
Conference acronym ’XX, Woodstock, NY  
©2018 Copyright held by the owner/author(s). Publication rights licensed to ACM.  
ACM ISBN 978-1-4503-XXXX-X/2018/  
https://doi.org/XXXXXXX.XXXXXXX  
\`\`\`  
\#\# CCS Concepts

\- Software and its engineering→Automatic programming;  
\- Information systems→Information retrieval query pro-  
cessing;•Computing methodologies→Natural language  
processing.

\#\# Keywords

\`\`\`  
Code Generation, LLM, Empirical Study  
ACM Reference Format:  
Wenchao GU, Juntao Chen, Yanlin Wang, Tianyue Jiang, Xingzhe Li, Ming-  
wei Liu, Xilin Liu, Yuchi Ma, and Zibin Zheng. 2018\. What to Retrieve for  
Effective Retrieval-Augmented Code Generation? An Empirical Study and  
Beyond. InProceedings of Make sure to enter the correct conference title from  
your rights confirmation email (Conference acronym ’XX).ACM, New York,  
NY, USA, 12 pages. https://doi.org/XXXXXXX.XXXXXXX  
\`\`\`  
\#\# 1 Introduction

\`\`\`  
In modern software development, code generation \[ 27 , 43 , 44 , 60 \]  
has emerged as a critical capability to bridge the gap between  
natural language requirements from developers and executable  
code. With the advent of large language models (LLMs), state-of-  
the-art models have demonstrated impressive ability to generate  
standalone code snippets from natural language queries. However,  
these achievements are primarily limited to function-level code  
generation. Repository-level code generation \- the task of generat-  
ing code that with the repository context \-remains a challenging  
task due to the complexity of code dependencies in repositories and  
inherent limitations of LLMs with long context. To address this chal-  
lenge, most existing approaches \[ 11 , 31 , 49 , 50 , 57 \] adopt a retrieval-  
augmented generation (RAG) framework, which retrieves relevant  
information from the repository, appends it to the query, and then  
feeds it into LLMs for code generation. Existing works adopts differ-  
ent information sources in the retrieval phase. (1) RepoFormer \[ 50 \],  
RepoMinCoder \[ 28 \], andR^2 C^2 \-Coder \[ 11 \] utilize contextual in-  
formation from the current file to enhance code generation. By  
\`\`\`  
\# arXiv:2503.20589v1 \[cs.SE\] 26 Mar 2025

\`\`\`  
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY Gu et al.  
\`\`\`  
incorporating relevant local context and references to third-party  
libraries, these methods enable LLMs to infer and complete the  
target function more effectively. (2) RepoFuse \[ 29 \] extracts relevant  
APIs by analyzing import statements, whileA^3 CodeGen \[ 31 \] first  
generates pseudo-code and then uses it to retrieve potential APIs  
for code generation. The retrieved API information helps LLMs  
correctly handle dependencies and ensures that the generated code  
adheres to API specifications. (3) RepoCoder \[ 57 \] retrieves code  
snippets similar to the incomplete code using an context window,  
whereas RLCoder \[ 49 \] applies reinforcement learning to optimize  
the retrieval process. Providing similar code snippets offers exam-  
ples of recurring patterns, which aid LLMs in generating logically  
consistent implementations.  
Although these information sources are widely used in RAG-  
based repository-level code generation, their impact on LLM perfor-  
mance has not been thoroughly studied. This raises a critical ques-  
tion:In RAG-based repository-level code generation, what  
information sources truly matter?  
To address this question, we conduct a preliminary study to  
analyze how different types of retrieved information contribute to  
improving LLM performance in repository-level code generation.  
Our experimental results reveal thatcontextual informationwithin  
the current file andpotential API informationplay a crucial role in  
enhancing LLM performance. Moreover, their combination further  
improves model performance in repository-level code generation.  
Interestingly, contrary to its effectiveness in repository-level  
code completion, retrieving similar code snippets does not always  
improve LLM performance in repository-level code generation. In  
some cases, it can even have a negative impact. This occurs because  
there is no guarantee that a functionally similar code snippet exists  
within the repository, and retrieving dissimilar code snippets may  
mislead the LLMs, ultimately reducing the quality of the generated  
code.  
Based on these findings, we conclude that retrieving contextual  
information from both the current file and relevant APIs is essential  
for enhancing LLM performance in repository-level code genera-  
tion. While contextual information within the same file is naturally  
available and does not require additional retrieval techniques, iden-  
tifying the appropriate APIs to invoke remains a challenge, as LLMs  
often lack prior knowledge of them.  
To address this issue, we propose a simple yet effective approach,  
AllianceCoder, for retrieving potential APIs. AllianceCoder consists  
of three key stages: repository API processing, query processing,  
and context-integrated code generation.  
In the repository API processing stage, we leverage LLMs to gen-  
erate natural language descriptions for all APIs within the reposi-  
tory. These descriptions are then encoded into representation vec-  
tors for API retrieval. The motivation behind converting code into  
natural language is to bridge the semantic gap between program-  
ming languages and natural language, thereby improving retrieval  
accuracy.  
In the query processing stage, we guide LLMs with examples  
to decompose the user query into multiple detailed implementa-  
tion steps. For each step, the model generates descriptions of the  
potential APIs that may be invoked. The resulting API description  
sequence is then refined by LLMs and encoded into representation

\`\`\`  
vectors using the same pre-trained model as in the repository API  
processing stage.  
In the context-integrated code generation stage, we utilize these  
API representation vectors to retrieve the most relevant APIs from  
the repository based on cosine similarity. The retrieved APIs are  
then appended to the contextual information and user query before  
being fed into LLMs for repository-level code generation.  
We evaluate our approach on two public datasets, CoderEval and  
RepoExec, and the results show that our two-step retrieval method  
outperforms state-of-the-art (SOTA) models by up to 20% in terms  
of thePass@1metric.  
Our contributions can be summarized as follows:  
\`\`\`  
\- We conduct an empirical study to investigate how different  
    types of retrieved information contribute to LLM perfor-  
    mance in repository-level code generation, showing that  
    contextual information and potential APIs play a crucial role  
    in improving performance.  
\- We propose a simple yet effective approach named Alliance-  
    Coder that guides LLMs to decompose functionality into  
    detailed implementation steps and generate descriptions of  
    potential APIs for each step. These descriptions are then  
    used to retrieve relevant APIs.  
\- We conduct extensive experiments to evaluate our approach.  
    The results demonstrate that our simple two-step retrieval  
    method significantly outperforms SOTA baselines.

\#\# 2 Background

\#\# 2.1 Retrieval-Augmented Generation

\`\`\`  
Retrieval-augmented generation (RAG) enhances generative models  
by integrating external knowledge \[ 25 \]. Traditional models, while  
coherent, often suffer from factual inaccuracies and knowledge gaps  
due to their reliance on fixed memory \[ 49 , 57 \]. RAG addresses these  
limitations by incorporating a retrieval mechanism that fetches  
relevant information from large-scale knowledge sources, such  
as databases or document corpora, enabling more accurate and  
contextually grounded outputs.  
The RAG framework includes a retriever, which ranks relevant  
information based on the query, and a generator, which condi-  
tions its output on both the query and retrieved content, ensuring  
linguistic fluency while incorporating external knowledge. This  
adaptability allows the model to stay current without expensive  
retraining.  
RAG has been successfully applied in domains requiring factual  
accuracy and knowledge grounding, including question answer-  
ing \[ 2 , 54 \], scientific text generation \[ 14 \], and automated code  
synthesis \[ 40 \]. By bridging retrieval-based and generative models,  
RAG advances the development of more reliable, context-aware AI  
systems.  
The RAG process can be formulated as follows:  
\`\`\`  
\`\`\`  
𝐴\=𝐺𝑒𝑛𝑒𝑟𝑎𝑡𝑒(𝑞,𝑅𝑒𝑡𝑟𝑖𝑒𝑣𝑎𝑙(𝑞,{𝑐 1 ,.. .,𝑐𝑛})) (1)  
\`\`\`  
\`\`\`  
where𝑞represents the user query,{𝑐 1 ,.. .,𝑐𝑛}denotes the candi-  
date knowledge set, and𝐴is the output generated by the language  
model. The function𝑅𝑒𝑡𝑟𝑖𝑒𝑣𝑎𝑙(·)retrieves relevant candidates from  
the knowledge base based on the given query, while𝐺𝑒𝑛𝑒𝑟𝑎𝑡𝑒(·)  
\`\`\`

What to Retrieve for Effective Retrieval-Augmented Code Generation? An Empirical Study and Beyond Conference acronym ’XX, June 03–05, 2018, Woodstock, NY

\`\`\`  
Table 1: Types of retrieved information by different LLM-  
based approaches.  
\`\`\`  
\`\`\`  
Approach Similar Code API Context  
A^3 CodeGen ✗✓✓  
RepoCoder ✓✗✓  
RepoFormer ✓✗✓  
RepoMinCoder ✓✗✓  
RLcoder ✓✗✓  
R^2 C^2 −Coder ✓✗✓  
GraphCoder ✓✗✓  
RepoFuse ✓✓✓  
\`\`\`  
\`\`\`  
combines the retrieved information with the original query and  
feeds it into the language model for response generation.  
Repository-level code generation is particularly well-suited for  
the RAG framework. Software repositories contain extensive histor-  
ical code, library functions, API calls, and contextual information,  
making it impractical to rely solely on user queries for code gen-  
eration. Moreover, due to the maximum input length constraints  
of LLMs, it is infeasible to import an entire repository into the  
model. RAG overcomes these limitations by retrieving relevant  
code snippets from the repository, enriching the model’s context  
and improving the accuracy and coherence of generated code. Ad-  
ditionally, large codebases often contain implementations of similar  
functions. By retrieving and reusing high-quality existing code  
snippets, RAG ensures consistency in coding style and interface de-  
sign while reducing redundancy and potential errors. Consequently,  
most LLM-based approaches for repository-level code generation  
incorporate RAG to enhance performance.  
\`\`\`  
\#\# 2.2 Repository-level Code Generation

Before the advent of LLMs, most research efforts in code generation  
were limited to standalone code snippets due to the constrained  
performance and short input length of deep learning models. How-  
ever, with the rapid advancement of LLMs, both their code gen-  
eration capabilities and input length have significantly improved.  
This progress has shifted the research focus toward repository-  
level code generation, which better aligns with real-world software  
development scenarios.  
In this context, RAG frameworks have been widely adopted  
in LLM-based repository-level code generation approaches. The  
repository-level code generation process can be formulated as fol-  
lows:  
𝐶𝑜𝑑𝑒=𝐺𝑒𝑛𝑒𝑟𝑎𝑡𝑒(𝑞,𝑅𝑒𝑡𝑟𝑖𝑒𝑣𝑎𝑙(𝑞,𝐶𝑜𝑑𝑒𝑏𝑎𝑠𝑒)) (2)

where𝐶𝑜𝑑𝑒𝑏𝑎𝑠𝑒represents the given repository, and𝑞is the user  
query describing the target function. The function𝑅𝑒𝑡𝑟𝑖𝑒𝑣𝑎𝑙(·)  
extracts relevant information from the𝐶𝑜𝑑𝑒𝑏𝑎𝑠𝑒based on the query,  
while𝐺𝑒𝑛𝑒𝑟𝑎𝑡𝑒(·)integrates the retrieved information with the  
original query and utilizes LLMs to generate the desired code.  
Table 1 summarizes the types of retrieved information used in  
current LLM-based repository-level code generation approaches.  
These types can be broadly classified into three categories: similar  
code, API, and context.  
Similar coderefers to the similar code snippets retrieved from  
the same repository. The underlying assumption is that similar code

\`\`\`  
shares certain characteristics with the target code, providing LLMs  
with useful hints for implementation. From Table 1, we observe  
that most LLM-based approaches retrieve similar code from the  
repository, with the exception ofA^3 CodeGen.  
APIretrieval focuses on identifying relevant APIs that should be  
invoked in the target code. The goal is to reduce code redundancy  
while enabling customization and supporting complex functionality.  
Information about the available APIs helps capture partial func-  
tionality within the overall target implementation, improving code  
integration, reusability, and reducing implementation difficulty.  
Unlike similar code, which is widely used in existing approaches,  
onlyA^3 CodeGen, andRepoFuseretrieve relevant APIs from the  
repository.  
Contextrefers to contextual information from the same file as  
the user query. It includes details such as library imports, class def-  
initions, and member function implementations. This information  
helps LLMs better understand the code style, maintain consistency,  
reduce redundancy, and correctly interpret the target functional-  
ity. Since contextual information is inherently available within the  
same file as the user query (which typically corresponds to the  
target functionality description), all prior LLM-based approaches  
utilize this information for repository-level code generation.  
Limitations.Although current LLM-based code generation ap-  
proaches widely retrieve such information, the impact of each type  
on model performance and the optimal way to integrate them re-  
main unclear.  
\`\`\`  
\#\# 3 Experimental Setup

\`\`\`  
In this section, we introduce the datasets, baselines and LLMs being  
evaluated in the experiments, and the evaluation metrics.  
\`\`\`  
\#\# 3.1 Dataset

\`\`\`  
Our experiments are conducted onCoderEval\[ 53 \] andRepoExec\[ 20 \].  
CoderEval is a benchmark used to evaluate code generation per-  
formance on pragmatic code generation tasks. It consists of 230  
Python and 230 Java tasks from real-world open-source projects.  
Each task contains a function signature, a function description, a  
solution, and several unit tests to assess the functional correctness  
of the generated code. RepoExec is a benchmark designed to eval-  
uate repository-level code completion with complex contextual  
dependencies. It assesses models’ ability to generate executable  
and functionally correct code while utilizing cross-file contexts.  
Each task provides essential code dependencies specified by de-  
velopers, along with comprehensive test cases to verify functional  
correctness.  
\`\`\`  
\#\# 3.2 Baselines and LLMs evaluated

\`\`\`  
We explore two state-of-the-art frameworks for repository-level  
code generation:RepoCoder\[ 57 \] andRLCoder\[ 49 \]. RepoCoder  
is an iterative retrieval-generation pipeline. It effectively utilizes  
information scattered across different files within a repository and  
can generate code at various levels of granularity. RLCoder en-  
hances this approach by implementing a novel reinforcement learn-  
ing framework that enables the retriever to learn useful content  
without labeled data. It evaluates retrieved content based on per-  
plexity metrics and includes a stop signal mechanism to determine  
\`\`\`

\`\`\`  
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY Gu et al.  
\`\`\`  
when to retrieve and which candidates to retain. Both frameworks  
demonstrate significant improvements over baseline methods in  
repository-level code generation tasks.

\#\# 3.3 Embedding Model

\`\`\`  
UniXcoder \[ 16 \] is a dense retriever, encoding both queries and  
code snippets into dense vector representations. This vectorization  
mechanism enables the efficient discovery and extraction of seman-  
tically aligned code fragments from extensive repositories, based  
on the computational similarity between their respective vector  
embeddings.  
\`\`\`  
\#\# 3.4 Metrics

Since multiple implementations can achieve the same functionality,  
we adopt𝑃𝑎𝑠𝑠@𝑘\[ 8 \] as our sole evaluation metric. In our evalu-  
ation, a generated code snippet is considered successful only if it  
passes all test cases. The𝑃𝑎𝑠𝑠@𝑘metric represents the success rate  
after generating code𝑘times using LLMs.

\#\# 3.5 Implementation Details

In all our experiments, we utilized GPT-4o Mini and Gemini 1\.  
Flash with the default temperature setting of 0.7. In the preliminary  
study on similar code retrieval, we selected the top five most sim-  
ilar code snippets for code generation. For our proposed method,  
AllianceCoder, we retrieved only the single API from the repository  
that exhibited the highest cosine similarity to each API description  
generated by the LLMs.

\#\# 4 Preiliminary Study

\`\`\`  
To investigate the impact of different information types on the  
LLM’s ability to generate repository-level code under the RAG  
framework, we conduct an preiliminary study. In this study, we ex-  
amine three types of information: contextual information, relevant  
code (i.e., code similar to the target code), and invoked APIs. To  
assess the upper-bound performance of each information type, we  
assume access to perfect information.  
\`\`\`  
\- Contextual information: This information type includes  
    all text preceding the target function within the same file,  
    such as library import statements, class definitions, and other  
    implemented functions. By providing rich contextual infor-  
    mation, it helps the LLM better understand the target func-  
    tion’s environment. The experimental results for this setting  
    are denoted asContextLLM.  
\- Relevant code: Building on previous model-based approaches,  
    we leverage LLMs to encode all code candidates within  
    the repository into vector representations. Assuming prior  
    knowledge of the correct target code, we adopt the retrieval  
    framework used in RepoCoder \[ 57 \], which utilizes a context  
    window to retrieve the top five most relevant code snippets  
    based on vector similarity. The experimental results for this  
    setting are denoted asSimilarLLM.  
\- Invoked APIs: We assume prior knowledge of all APIs  
    invoked within the target code and retrieve them to facilitate  
    repository-level code generation. The experimental results  
    for this setting are denoted asAPILLM.

\`\`\`  
Table 2: Preliminary experimental results on LLM repository-  
level code generation performance with different retrieved  
information types (best performance in bold).  
\`\`\`  
\`\`\`  
Method RepoExec CoderEval  
Pass@1 Pass@3 Pass@5 Pass@1 Pass@3 Pass@  
PureGPT 16.62 19.72 23.66 18.26 25.22 26\.  
ContextGPT 29.01 34.08 38.59 30.43 36.52 37\.  
SimilarGPT 16.90 23.38 24.79 20.00 23.04 23\.  
APIGPT 25.63 32.39 34.93 25.65 30.43 33\.  
ConSimGPT 22.53 26.48 27.60 14.35 20.43 23\.  
ConAPIGPT 37.75 44.51 47.04 36.52 41.30 41\.  
SimAPIGPT 25.36 31.55 34.09 22.17 26.52 26\.  
ConSimAPIGPT 29.86 38.31 38.87 19.57 23.91 26\.  
PureGemini 16.90 20.28 23.10 17.39 21.74 25\.  
ContextGemini 30.99 34.08 35.77 23.04 26.09 27\.  
SimilarGemini 17.18 22.25 23.38 13.48 16.52 16\.  
APIGemini 26.20 30.99 34.93 22.61 24.78 26\.  
ConSimGemini 24.22 27.33 29.02 13.91 15.22 15\.  
ConAPIGemini 38.59 41.69 44.51 25.22 27.39 28\.  
SimAPIGemini 27.32 31.27 32.96 19.13 22.17 22\.  
ConSimAPIGemini 32.67 36.90 38.59 22.17 23.04 23\.  
\`\`\`  
\`\`\`  
In our experiments, we evaluate all possible combinations of the  
three types of retrieved information. Specifically,ConSimLLMrep-  
resents the performance of the LLM when provided with both con-  
textual information and relevant code as input, whileConAPILLM  
corresponds to the setting where the LLM receives contextual infor-  
mation and the invoked API. Similarly,SimAPILLMdenotes the case  
where the LLM is given relevant code and the invoked API. Finally,  
ConSimAPILLMrepresents the setting in which the LLM is provided  
with all three types of information: contextual information, relevant  
code, and the invoked API.  
To assess the inherent capability of LLMs in repository-level  
code generation, we also conduct an experiment in which only the  
user’s original query is fed into the model without any additional  
information. The results of this setting are denoted asPureLLM.  
Overall, our preliminary study evaluates eight different settings,  
each corresponding to a unique combination of retrieved informa-  
tion types.  
\`\`\`  
\#\# 5 Results of Preliminary Study

\`\`\`  
In this section, we aim to answer the following research ques-  
tions(RQs):  
\`\`\`  
\- RQ1: How does each type of information contribute  
    to performance improvement in repository-level code  
    generation?  
\- RQ2: Can the performance gains from contextual infor-  
    mation and invoked APIs be fully captured by simply  
    integrating them?  
\- RQ3: Are the performance improvements from con-  
    textual information and invoked APIs independent of  
    each other?

What to Retrieve for Effective Retrieval-Augmented Code Generation? An Empirical Study and Beyond Conference acronym ’XX, June 03–05, 2018, Woodstock, NY

\#\# 5.1 RQ1: How does each type of information

\#\# contribute to performance improvement in

\#\# repository-level code generation?

Table 3 presents the experimental results of our preiliminary study.  
As shown in the table, contextual informaion provides the most  
significant performance improvement for LLMs in repository-level  
code generation. This result is expected, as contextual information  
supplies critical supplementary information, including imported  
libraries, class definitions, and implementations of other member  
functions. These elements enrich the user query with additional  
context, enabling LLMs to better understand the intended function-  
ality and generate more accurate code.  
Moreover, we observe that incorporating invoked API also sub-  
stantially enhances performance. This improvement stems from  
two key factors. First, explicitly specifying relevant APIs within  
the repository allows LLMs to invoke them directly rather than  
reimplementing functionality from scratch, thereby reducing the  
likelihood of incorrect implementations. Second, API chains pro-  
vide a structured reference, guiding LLMs to follow an established  
logical flow, which simplifies the code generation process.  
Furthermore, the combination of both contextual information  
and invoked API information yields the best overall performance.  
From a human developer’s perspective, these elements collectively  
provide all the essential knowledge required for repository-level  
code generation, enabling more efficient implementation of the  
target functionality. Similarly, LLMs can leverage this prior knowl-  
edge to enhance their generative capabilities. Given that modern  
LLMs already excel at function-level code generation, supplying  
contextual information and API usage information effectively de-  
composes the complex task of repository-level code generation into  
smaller, well-defined function-level subtasks. This decomposition  
allows LLMs to fully utilize their strengths in function-level gener-  
ation, leading to more accurate and reliable repository-level code  
generation.  
However, an unexpected finding is that the retrieved relevant  
code contributes very little to performance improvement and can  
even degrade performance when combined with other types of sup-  
plementary information. For instance, in both datasets, the model  
incorporating all three types of information (contextual informa-  
tion, invoked APIs, and relevant code) performs significantly worse  
than the model that utilizes only contextual information and in-  
voked APIs. Notably, in the CodeEval dataset, the model leveraging  
all three types of information underperforms even when compared  
to models using only contextual information or only invoked APIs.  
In fact, its performance is close to that of LLMs without any re-  
trieved information at all.  
This degradation is likely due to the discrepancy between the  
retrieved similar code and the target code. Ideally, the retrieved  
relevant code should exhibit functional similarities with the target  
implementation, serving as a reference to guide LLMs in generating  
correct code. However, there is no guarantee that such suitable  
examples exist within the repository. In repository-level code com-  
pletion tasks, where only a few lines need to be completed, the  
likelihood of finding similar patterns within the repository is rel-  
atively high. However, in repository-level code generation tasks,  
which require generating entire functions, it becomes significantly

\`\`\`  
harder to retrieve functionally similar code from the repository.  
In practice, retrieved code snippets often fail to meet this require-  
ment, providing misleading information instead. When LLMs rely  
on irrelevant or functionally dissimilar code, they are more likely  
to produce incorrect outputs, ultimately degrading performance  
rather than enhancing it.  
\`\`\`  
\`\`\`  
Finding 1:Contextual information and invoked APIs con-  
tribute significantly to performance improvements. However,  
the inclusion of similar code does not always lead to im-  
provements and, in some cases, can even negatively impact  
performance in repository-level code generation.  
\`\`\`  
\#\# 5.2 RQ2: Can the performance gains from

\#\# contextual information and invoked APIs be

\#\# fully captured by simply integrating them?

\`\`\`  
To further investigate the effectiveness of combining contextual  
information with invoked APIs, we analyze the intersection of  
passed test cases amongContextLLM,APILLM, andConAPILLM.  
To mitigate the impact of this randomness on our experimental  
results, we evaluate the intersection of passed test cases using the  
Pass@5metric, ensuring that each test case is tested five times. The  
experimental results are presented in Figure 1\.  
From the figure, we observe thatConAPILLMsuccessfully covers  
most of the test cases that passed in eitherAPILLMorContextLLM.  
This result is intuitive, asConAPILLMintegrates both contextual  
and API-related information. If the retrieved contextual and API-  
related information are indeed effective, thenConAPILLMshould  
naturally pass the same test cases asContextLLMandAPILLM.  
However, we also notice certain test cases that pass inContextLLM  
orAPILLMbut fail inConAPILLM. One possible explanation is the in-  
herent randomness in the model’s output. Despite testing each case  
five times, some degree of randomness persists, leading to minor  
inconsistencies in the results. The number of test cases passed by  
ContextLLMbut failed byConAPILLMis relatively small, suggesting  
that model randomness might be the primary cause.  
In contrast, Figure 1b, Figure 1c, and Figure 1d reveal a notable  
number of test cases that pass inAPILLMbut fail inConAPILLM.  
This discrepancy cannot be solely attributed to model randomness,  
indicating that other factors may be influencing the performance.  
To further investigate this issue, we analyze the input prompt  
length of test cases that were passed by bothAPILLMandConAPILLM,  
as well as those passed only byAPILLM. The results are shown in  
Figure 2\. From this figure, we observe a significant difference in  
input prompt length between these two sets of test cases. Specif-  
ically, the test cases passed only byAPILLMtend to have much  
longer input prompts compared to those passed by bothAPILLM  
andConAPILLM.  
Since contextual information is naturally connected to the user  
query, we structure the prompt by first providing relevant API  
information, followed by contextual information along with the  
user query. This ordering results in API-related content appearing  
farther from the user query in the prompt. While modern LLMs  
can handle long inputs, content appearing earlier in the prompt  
may have a diminished impact on later generated responses if the  
input length is too extensive.  
\`\`\`

\`\`\`  
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY Gu et al.  
\`\`\`  
\`\`\`  
(a) Intersection of correct an-  
swers in RepoExec with GPT  
\`\`\`  
\`\`\`  
(b) Intersection of correct an-  
swers in CodeEval with GPT  
\`\`\`  
\`\`\`  
(c) Intersection of correct an-  
swers in RepoExec with Gemini  
\`\`\`  
\`\`\`  
(d) Intersection of correct an-  
swers in CodeEval with Gemini  
Figure 1: Intersection of correct answers across ConAPI, API, and Context under various LLMs and datasets.  
\`\`\`  
\`\`\`  
(a) Comparison of performance  
based on input prompt length in  
RepoExec with GPT  
\`\`\`  
\`\`\`  
(b) Comparison of performance  
based on input prompt length in  
CodeEval with GPT  
\`\`\`  
\`\`\`  
(c) Comparison of performance  
based on input prompt length in  
RepoExec with Gemini  
\`\`\`  
\`\`\`  
(d) Comparison of performance  
based on input prompt length in  
CodeEval with Gemini  
\`\`\`  
\`\`\`  
Figure 2: Comparison of Input Prompt Lengths for Test Cases: Success in Both ConAPI & API vs. API-Only Success Across  
Different Datasets and LLM.  
\`\`\`  
\`\`\`  
Finding 2:Naively appending invoked APIs with contextual  
information may cause test cases that could pass with a single  
piece of information to fail due to excessive input length.  
\`\`\`  
\#\# 5.3 RQ3: Are the performance improvements

\#\# from contextual information and invoked

\#\# APIs independent of each other?

Since the contextual information contains numerous member func-  
tions, some of which may be the invoked functions, it is possible  
that the contextual information already includes API details. To  
better understand how different types of information affect model  
performance in repository-level code generation, we analyze the  
number of test cases passed byContextLLMunder two conditions:  
(1) when the contextual information fully contains the invoked  
APIs and (2) when it does not contain any APIs at all. The statistical  
results are presented in Table 3\.  
In this table,Fully Containedrefers to cases where the contextual  
information includes all invoked API details, whileNot Included  
indicates cases where the contextual information does not contain  
any invoked APIs. The metricCPassrepresents the number of test  
cases passed byContextLLM, whereasBPassdenotes the test cases  
passed by bothContextLLMandAPILLM. The percentage under  
CPassindicates the ratio of passed test cases to the total number  
of test cases in each condition (Fully Contained or Not Included).

\`\`\`  
The percentage underBPassrepresents the proportion of test cases  
passed byContextLLMthat are also successfully passed byAPILLM.  
To mitigate the effect of model randomness, we attempt to pass  
each test case five times. To isolate the influence of LLMs’ intrinsic  
code generation capability, we exclude all test cases that can be  
trivially passed byPureLLMfrom our statistical results.  
From Table 3, we observe that API information within the con-  
textual data significantly improves performance. Specifically, by  
comparing cases where the contextual information fully contains  
the invoked APIs to those where it does not contain any, we find that  
ContextLLMachieves a notable performance boost in both datasets.  
In the CoderEval dataset, the performance is even doubled.  
Moreover, test cases passed by bothContextLLMandAPILLM  
exhibit strong similarity. Notably, when the contextual information  
fully contains the invoked APIs, approximately 50–70% of the test  
cases passed byContextLLMare also passed byAPILLM. In this  
scenario, the invoked API information is essentially a subset of the  
contextual information, suggesting that comparable performance  
can be achieved by reducing the complexity of contextual informa-  
tion to only the invoked API details. This finding highlights the  
critical role of invoked APIs in repository-level code generation.  
Additionally, we acknowledge that contextual information still  
provides valuable content beyond the invoked APIs. This is evident  
from the fact thatContextLLMmaintains a certain level of test case  
success even when it does not contain any invoked APIs, while pure  
\`\`\`

What to Retrieve for Effective Retrieval-Augmented Code Generation? An Empirical Study and Beyond Conference acronym ’XX, June 03–05, 2018, Woodstock, NY

\`\`\`  
Table 3: Statistics of passed test cases: comparison by context alone vs. context with API under different API containment  
conditions.  
\`\`\`  
\#\#\#\# LLM

\`\`\`  
RepoExec CodeEval  
Fully Contained Not Included Fully Contained Not Included  
CPass BPass CPass BPass CPass BPass CPass BPass  
GPT 30 (28.0%) 18 (60.0%) 36 (24.5%) 12 (33.3%) 8 (47.1%) 5 (62.5%) 29 (20.3%) 8 (27.6%)  
Gemini 22 (20.6%) 15 (68.2%) 25 (16.7%) 8 (32.0%) 4 (22.2%) 2 (50.0%) 15 (10.3%) 2 (13.3%)  
\`\`\`  
\`\`\`  
Phase I. Repository API Processing  
\`\`\`  
\`\`\`  
Repository  
APIs  
Phase II. Query Processing  
\`\`\`  
\`\`\`  
Phase III. Context-Integrated Code Generation  
\`\`\`  
\`\`\`  
Retrieved APIs  
\`\`\`  
\`\`\`  
User Target Code  
Query ImplementationSteps DescriptionAPI ExtendedDescriptionAPI  
\`\`\`  
\`\`\`  
API ContextUser Query  
Description  
\`\`\`  
\`\`\`  
LLM LLM LLM  
\`\`\`  
\`\`\`  
LLM  
\`\`\`  
\`\`\`  
LLM  
\`\`\`  
\`\`\`  
①API DescriptionGenerate Repo  
\`\`\`  
\`\`\`  
②Generate  
Implementation Steps  
\`\`\`  
\`\`\`  
③DescriptionGenerate API ④GenerateAPI Description^ Extended^  
\`\`\`  
\`\`\`  
Target Code⑥Generate  
\`\`\`  
\`\`\`  
Retriever  
⑤Encode & Retrieve  
\`\`\`  
\`\`\`  
Figure 3: AllianceCoder framework.  
\`\`\`  
API information alone is insufficient for generating correct code.  
This indicates that contextual information contributes additional  
useful signals to the code generation process.

\`\`\`  
Finding 3:Contextual information sometimes includes the  
invoked APIs for the target code, and a portion of the per-  
formance improvement attributed to contextual information  
actually stems from the presence of these invoked APIs.  
\`\`\`  
\#\# 6 AllianceCoder

\#\# 6.1 Overview

Based on our empirical study, potential API retrieval plays a crucial  
role in repository-level code generation, yet identifying which APIs  
can be invoked within a repository remains a challenging problem.  
To address this, we propose AllianceCoder, a simple yet effective  
approach for retrieving relevant APIs. As illustrated in Figure 3,  
AllianceCoder consists of three phases: repository API processing,  
query processing, and context-integrated code generation. In the  
repository API processing phase, we leverage LLMs to generate  
natural language descriptions for each API in the repository and  
encode them into representation vectors using pre-trained models.  
During query processing, we guide LLMs with examples to generate  
descriptions of potentially invoked API functionalities, which are  
similarly encoded into vectors. Finally, in the context-integrated  
code generation phase, we retrieve relevant APIs for each API  
description based on the cosine similarity between their vector  
representations. The examples and prompts used in AllianceCoder  
are provided in the Appendix.

\#\# 6.2 Repository API Processing

\`\`\`  
6.2.1 Generate Repo API Description.In our proposed approach,  
API retrieval is performed using vector cosine similarity, with the  
encoding process handled by a pre-trained model in an unsuper-  
vised manner. However, a semantic gap exists between program-  
ming languages and natural language, which can result in low  
cosine similarity between code snippets and their corresponding  
descriptions. To mitigate this issue, we first leverage LLMs to gen-  
erate natural language descriptions for each API in the repository.  
The process of generating these descriptions can be formulated as  
follows:  
\`\`\`  
\`\`\`  
𝑃(𝐷|𝐶)=  
\`\`\`  
\#\#\#\# Ö𝑇

\`\`\`  
𝑡= 1  
\`\`\`  
\#\#\#\# 𝑃(𝑑𝑡|𝑑\<𝑡,𝐶) (3)

\`\`\`  
where𝐷represents the code description,𝐶denotes the given code,  
𝑇is the length of the description, and𝑃(·)represents the probability  
distribution.  
Once the descriptions for all APIs are generated, they are en-  
coded into representation vectors and stored in advance for efficient  
retrieval.  
\`\`\`  
\#\# 6.3 Query Processing

\`\`\`  
6.3.1 Generate Implementation Steps.The goal of the query pro-  
cessing phase is to generate descriptions of the APIs that may be  
invoked in the target function. To achieve this, we first provide  
examples and instruct LLMs to decompose the overall code task  
into a sequence of concrete implementation steps. This process can  
be formulated as follows:  
{𝑠 1 ,.. .,𝑠𝑛}=Generate(𝑞,{𝑒 1 ,.. .,𝑒𝑚}) (4)  
where{𝑠 1 ,.. .,𝑠𝑛}represents the detailed implementation steps  
generated by LLMs,𝑞is the user query specifying the target code  
functionality,{𝑒 1 ,.. .,𝑒𝑚}denotes the examples provided for in-  
context learning, andGenerate(·)is the function that integrates the  
examples and user query to generate the implementation steps.  
\`\`\`  
\`\`\`  
6.3.2 Generate API Description.Once these steps are obtained,  
they are fed back into the LLM along with additional examples and  
prompts to generate descriptions of the potential APIs used in each  
step. This process is expressed as follows:  
{𝑎 1 ,.. .,𝑎𝑜}=Generate({𝑒 1 ,.. .,𝑒𝑚},{𝑠 1 ,.. .,𝑠𝑛}) (5)  
where{𝑠 1 ,.. .,𝑠𝑛}are the previously generated implementation  
steps,{𝑎 1 ,.. .,𝑎𝑜}represents the descriptions of APIs that may be  
used in these steps,{𝑒 1 ,.. .,𝑒𝑚}are the examples provided for in-  
context learning, andGenerate(·)is the function that integrates the  
examples and implementation steps to generate API descriptions.  
\`\`\`

\`\`\`  
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY Gu et al.  
\`\`\`  
\`\`\`  
6.3.3 Generate Extended API Description.However, LLMs may  
sometimes generate API descriptions that encompass composite  
functionalities, requiring multiple APIs for full implementation.  
To address this issue, we further guide LLMs to expand the set of  
potential APIs, ensuring broader coverage and reducing the risk  
of omitting relevant APIs. This expansion process is formulated as  
follows:  
{𝑎′ 1 ,.. .,𝑎𝑘′}=Generate({𝑎 1 ,.. .,𝑎𝑜}) (6)  
\`\`\`  
where{𝑎 1 ,.. .,𝑎𝑜}are the previously generated potential API de-  
scriptions,{𝑎′ 1 ,.. .,𝑎′𝑘}represents the expanded set of API descrip-  
tions, andGenerate(·)is the function that refines and extends the  
API descriptions based on the initial candidates.

\#\# 6.4 Context-Integrated Code Generation

\`\`\`  
6.4.1 Encode & Retrieve.Once the potential API descriptions are  
generated, they are encoded into representation vectors using the  
same pre-trained model applied for encoding API descriptions in  
the repository. API retrieval is then conducted based on vector  
cosine similarity, ensuring that each API description retrieves only  
the most relevant API from the repository.  
\`\`\`  
\`\`\`  
6.4.2 Generate Target Code.Finally, all retrieved APIs are appended  
to the contextual information and the user’s query before being fed  
into LLMs.  
\`\`\`  
\#\# 7 Evaluation

We aim to answer the following research questions (RQs):

\- RQ4: How effective is AllianceCoder in repository-  
    level code generation?  
\- RQ5: How does AllianceCoder perform in API predic-  
    tion, and what is the gap between its predictions and  
    the ideal outcomes?  
\- RQ6: How effective is generating natural language de-  
    scriptions for API retrieval compared to using code  
    snippets?

\#\# 7.1 RQ4: How effective is AllianceCoder in

\#\# repository-level code generation?

\`\`\`  
Table 4 presents a performance comparison of different approaches  
across various LLMs. As a baseline, we includeContextLLMfrom  
our preliminary study. The results demonstrate that AllianceCoder  
consistently achieves state-of-the-art (SOTA) performance across  
all evaluation metrics on both datasets.  
Notably, AllianceCoder exhibits a substantial improvement in  
thePass@1metric, with an increase of approximately 10-20%. Since  
Pass@1reflects the success rate on the first attempt, this enhance-  
ment significantly reduces the need for multiple regeneration at-  
tempts, thereby improving the overall user experience.  
Furthermore, the performance gains of AllianceCoder are partic-  
ularly pronounced compared toContextLLMand approach those  
ofConAPIGPTon the CoderEval dataset. This result underscores  
the effectiveness of API retrieval in AllianceCoder. However, it is  
important to note that the performance improvement of Alliance-  
Coder on the CoderEval dataset with Gemini is relatively limited.  
This is primarily due to the inherently low upper bound on the  
potential gains from API retrieval. Even under optimal API retrieval  
\`\`\`  
\`\`\`  
conditions, the maximum achievable improvement inPass@3and  
Pass@5remains around 5%. We attribute this limitation to the  
intrinsic generation capabilities of the LLM, which constrain the  
extent to which API retrieval can enhance performance.  
\`\`\`  
\`\`\`  
Summary 1:AllianceCoder achieves SOTA performance  
across all baselines, with particularly notable improvements  
inPass@1. On the CoderEval dataset with GPT, Alliance-  
Coder’s performance closely approaches the theoretical up-  
per bound of API retrieval.  
\`\`\`  
\#\# 7.2 RQ5: How does AllianceCoder perform in

\#\# API prediction, and what is the gap between

\#\# its predictions and the ideal outcomes?

\`\`\`  
To evaluate the effectiveness of AllianceCoder in API prediction,  
we first examine the API recall numbers obtained by AllianceCoder,  
as shown in Table 6\. In this table,Higherrepresents the percentage  
of test cases where AllianceCoder recalls more APIs than the actual  
number required by the target function,Equalrepresents the per-  
centage of test cases where AllianceCoder recalls exactly the same  
number of APIs as the actual requirement, andLowerrepresents  
the percentage of test cases where AllianceCoder recalls fewer APIs  
than needed. From the table, we observe that LLMs tend to generate  
more APIs than the target function actually requires. Additionally,  
different LLMs exhibit varying tendencies; for example, GPT tends  
to recall more APIs compared to Gemini.  
Table 7 presents the API recall ratios for AllianceCoder and  
AllianceCoder with context combination. In this table,Recallrep-  
resents the API recall ratio of AllianceCoder across all test cases,  
BRecallrepresents the API recall ratio for test cases that are success-  
fully passed by both AllianceCoder andConAPILLM(i.e., the ideal  
condition with API retrieval), andCRecallrepresents the API recall  
ratio of AllianceCoder, including APIs invoked in the contextual in-  
formation. From the results, we observe that the API recall ratio for  
passed test cases is higher than the overall recall ratio of Alliance-  
Coder, demonstrating that providing correct potential APIs as input  
can enhance performance. However, even when considering APIs  
embedded in contextual information, the API recall ratio remains  
relatively low. Nevertheless, the overall performance of Alliance-  
Coder is close to the ideal performance achieved byConAPILLMs,  
indicating that not only does providing all invoked APIs improve  
model performance, but even offering a subset of invoked APIs can  
contribute to performance enhancement.  
\`\`\`  
\`\`\`  
Summary 2:AllianceCoder tends to predict more APIs than  
actually required, and providing LLMs with a subset of po-  
tential invoked APIs can also enhance repository-level code  
generation performance.  
\`\`\`  
\#\# 7.3 RQ6: How effective is generating natural

\#\# language descriptions for API retrieval

\#\# compared to using code snippets?

\`\`\`  
Although most existing pre-trained models attempt to unify pro-  
gramming languages and natural language modalities during the  
\`\`\`

What to Retrieve for Effective Retrieval-Augmented Code Generation? An Empirical Study and Beyond Conference acronym ’XX, June 03–05, 2018, Woodstock, NY

\`\`\`  
Table 4: Performance comparison of different approaches with various LLMs (best performance in bold).  
\`\`\`  
\`\`\`  
Approach RepoExec CoderEval  
Pass@1 Pass@3 Pass@5 Pass@1 Pass@3 Pass@  
RepoCoderGPT 19.72 23.10 25.91 14.35 17.39 19\.  
RLCoderGPT 31.55 36.62 38.87 16.52 19.13 21\.  
ContextGPT 29.01 34.08 38.59 30.43 36.52 37\.  
AllianceCoderGPT 34.93 (10.7%↑) 40.28 (10.0%↑) 41.97 (8.0%↑) 36.52 (20.0%↑) 40.00 (9.5%↑) 41.30 (9.2%↑)  
ConAPIGPT 37.75 44.51 47.04 36.52 41.30 41\.  
RepoCoderGemini 25.63 31.26 32.95 13.91 15.65 16\.  
RLCoderGemini 12.68 15.21 18.31 12.17 12.61 13\.  
ContextGemini 30.99 34.08 35.77 23.04 26.09 27\.  
AllianceCoderGemini 35.49 (14.5%↑) 39.16 (14.9%↑) 41.13 (15.0%↑) 24.78 (7.6%↑) 26.52 (1.6%↑) 27.82 (1.6%↑)  
ConAPIGemini 38.59 41.69 44.51 25.22 27.39 28\.  
\`\`\`  
\`\`\`  
Table 5: Performance comparison between text-to-text and text-to-code retrieval.  
\`\`\`  
\`\`\`  
Approach RepoExec CoderEval  
Pass@1 Pass@3 Pass@5 Pass@1 Pass@3 Pass@  
AllianceCoderGPT 34.93 40.28 41.97 36.52 40.00 41\.  
AllianceCoder(Code)GPT 33.71 (3.5%↓) 39.38 (2.2%↓) 41.93 (0.1%↓) 23.47 (35.7%↓) 25.65 (35.9%↓) 26.96 (34.7%↓)  
AllianceCoderGemini 35.49 39.16 41.13 24.78 26.52 27\.  
AllianceCoder(Code)Gemini 28.45 (19.8%↓) 33.80 (13.7%↓) 34.65 (15.8%↓) 18.26 (26.3%↓) 20.43 (23.0%↓) 21.30 (23.4%↓)  
\`\`\`  
\`\`\`  
Table 6: Comparison of API recall counts: AllianceCoder vs.  
actual API counts.  
\`\`\`  
\`\`\`  
Approach RepoExec CoderEval  
Higher Equal Lower Higher Equal Lower  
AllianceCoderGPT 74.45 6.9 18.61 72.64 4.7 22\.  
AllianceCoderGemini51.42 13.25 35.33 58.49 9.9 31\.  
\`\`\`  
\`\`\`  
Table 7: Comparison of API recall ratios for AllianceCoder  
and AllianceCoder with context combination.  
\`\`\`  
\`\`\`  
Approach RepoExec CoderEval  
Recall BRecall CRecall Recall BRecall CRecall  
AllianceCoderGPT 20.38 21.33 29.23 16.81 24.00 46\.  
AllianceCoderGemini14.62 16.05 23.46 10.08 15.38 39\.  
\`\`\`  
\`\`\`  
pre-training stage in an unsupervised manner, a persistent align-  
ment gap remains between these two modalities. This misalignment  
results in representation vectors of code-query pairs that do not  
align well, which serves as the primary motivation for Alliance-  
Coder ’s approach—first generating natural language descriptions  
for APIs before retrieval.  
To examine the impact of this semantic gap on overall perfor-  
mance, we conduct an experiment in which APIs from the reposi-  
tory are directly encoded into representation vectors, followed by  
retrieval based on these vectors. The results, summarized in Table 5,  
yield several key observations.  
\`\`\`  
\`\`\`  
First, performance is highly sensitive to the specific implementa-  
tion details of code within the repository. Notably, the performance  
degradation in the CoderEval dataset is significantly more pro-  
nounced than in the RepoExec dataset for both LLMs. We attribute  
this to the greater functional complexity and diverse coding styles  
in CoderEval, which exacerbate the semantic gap between code  
and its corresponding natural language descriptions.  
Additionally, the ability of LLMs to generate accurate and se-  
mantically meaningful descriptions plays a crucial role in retrieval  
performance. Different LLMs exhibit varying degrees of perfor-  
mance degradation within the same dataset. For instance, in Re-  
poExec, GPT suffers a smaller performance drop compared to Gem-  
ini, whereas in CoderEval, GPT performs worse. This discrepancy  
likely arises from differences in description generation styles. Since  
each LLM employs distinct training strategies and datasets, their  
output formats vary, ultimately influencing retrieval effectiveness.  
\`\`\`  
\`\`\`  
Summary 3:Directly using code for retrieval leads to a  
decline in AllianceCoder ’s overall performance. The extent  
of this performance drop varies depending on the choice of  
LLM and dataset.  
\`\`\`  
\#\# 8 Related Works

\#\# 8.1 Code Generation

\`\`\`  
The task of repository-level code generation is gaining significant  
attention for intelligent software development in real-world sce-  
narios \[ 33 , 44 , 48 , 56 \]. Traditional code generation methods can  
\`\`\`

\`\`\`  
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY Gu et al.  
\`\`\`  
be primarily categorized into rule-based approaches \[ 22 \], statis-  
tical probability model-based methods \[ 41 \], and deep learning-  
based approaches \[ 5 , 9 , 23 , 48 \]. With the advancement of large lan-  
guage models \[ 1 , 17 , 32 , 42 , 51 \], many researchers have introduced  
LLMs into code generation tasks \[ 18 , 26 , 52 , 62 \]. In combination  
with LLMs, numerous studies have adopted Retrieval-Augmented  
Generation techniques for code completion and code generation  
tasks \[21, 36, 38, 55, 61\].  
For examples, ReCode \[ 21 \] improves Neural Code Generation  
through subtree retrieval. RedCoder \[ 38 \] proposes to first retrieve  
top-k candidate codes for a given code functionality description,  
then aggregate these candidates, and finally generate the target  
code. DocPrompting \[ 61 \] adopts code documentation to improve  
code generation, addressing the challenges of generating unknown  
functions and library code. ReACC \[ 36 \] retrieves similar code from  
a code database, scores retrieved code snippets using weighted  
results of cosine similarity and the BM25, and concatenates the  
final retrieved results with incomplete code as input to the LLM.  
This series of studies demonstrates that combining LLM and RAG  
techniques significantly enhances the performance of code comple-  
tion and code generation. APICoder \[ 55 \]trains models through API  
documentation to better generate private library code.

\#\# 8.2 Repository-level Code Generation

\`\`\`  
Repository-level code generation, which leverages the extensive  
context available across an code repository, has emerged as a cen-  
tral research focus in the field. Studies have attempted to improve  
repository-level code generation \[ 13 , 15 , 35 , 39 , 49 , 57 \]. RepoCoder \[ 57 \]  
and De-Hallucinator \[ 15 \] adopt an iterative retrieval and genera-  
tion framework. RepoMinCoder \[ 28 \] builds upon the traditional  
retrieval-augmented generation method by introducing an addi-  
tional round of screening and ranking based on information loss.  
R2C2-Coder \[ 11 \] first constructs a candidate retrieval pool and  
then retrieves relevant content from the pool for each completion  
position, assembling it into a completion prompt. The aforemen-  
tioned methods extract the target code for retrieval. However, they  
overlook the intrinsic structure within the code. To address this,  
CoCoMIC \[ 13 \] and RepoHyper \[ 39 \]construct method-level graphs  
to enhance the retrieval process. Nevertheless, these methods fail  
to capture statement-level structures, which are crucial for under-  
standing code semantics. GraphCoder \[ 35 \] overcomes this limita-  
tion by incorporating statement-level structural information. Re-  
poGraph \[ 37 \] is a framework that converts repositories into graph  
structures to enhance code analysis and understanding. Rambo \[ 7 \]  
identifies and incorporates repository-specific elements and their  
usages to generate more accurate method bodies in large codebases.  
DraCo \[ 10 \] uses extended dataflow analysis to create a repo-specific  
context graph for more precise retrieval of relevant background  
knowledge. CodePlan \[ 4 \], RepoFuse \[ 29 \], and A^3 CodeGen \[ 31 \]  
leverage static code analysis to identify and retrieve relevant candi-  
date code. However, methods that use a fixed window risk losing  
code semantics, while dependency parsing approaches are restricted  
to a limited context within the dependency graph, making them  
ineffective in complex scenarios. To overcome these challenges,  
the researchers introduces RLCoder \[ 49 \], a repository-level code  
\`\`\`  
\`\`\`  
genration method driven by reinforcement learning. RepoGenRe-  
flex \[ 46 \] is another framework driven by reinforcement learning.  
CoCoGen \[ 6 \] uses compiler feedback and static analysis to identify  
and fix mismatches between generated code and project-specific  
context. RepoGenix \[ 30 \] combines analogous and relevant con-  
texts with Context-Aware Selection to compress information into  
compact prompts.  
In methods such as KNN-LM \[ 24 \], KNM-LM \[ 45 \], and FT2Ra \[ 19 \],  
a retrieval process is triggered for each generated token. Conse-  
quently, as the generated sequence length increases, leading to a sig-  
nificant increase in retrieval time. CodeAgent \[ 58 \] and ToolGen \[ 47 \]  
investigate the integration of tool invocation mechanisms. Addi-  
tionally, benchmarks such as RepoEval \[ 57 \], RepoBench \[ 34 \], and  
CrossCodeEval \[ 12 \] have been introduced to systematically evalu-  
ate various code generation capabilities across different contexts,  
thereby driving progress in this field. Some work study selective  
retrieval \[ 50 , 59 \]. RepoFormer \[ 50 \] improves repository-level code  
generation by deciding when retrieval is necessary. CARD \[ 59 \] is  
a lightweight critique method that optimizes retrieval-augmented  
mechanism by determining when retrieval is necessary and se-  
lecting the best prediction, reducing retrieval frequency. Probing-  
RAG \[ 3 \] is a system that analyzes models’ hidden states to adap-  
tively determine when to retrieve external knowledge.  
In summary, these approach proves to be effective for repository-  
level code generation. Nevertheless, identifying which APIs can  
be invoked within a repository remains a challenging problem. To  
tackle this issue, we first generate descriptions for each API in the  
repository and encode them into vectors. Furthermore, we employ  
in-context learning and chain-of-thought prompting to assist LLMs  
in generating descriptions of potentially relevant API functional-  
ities, which are then encoded into vectors. By computing cosine  
similarity between these vectors, we identify the most relevant  
APIs, enabling efficient and precise retrieval that improves code  
generation outcomes.  
\`\`\`  
\#\# 9 Threats to Validity

\`\`\`  
Internal Threats.The first internal threat relates to the scope  
of our experimental datasets. While we evaluated our approach on  
Python programming language. This may limit the generalizability  
of our findings to other programming languages. To mitigate this,  
we used CoderEval and RepoExec benchmarks which emphasize  
real-world repositories. In the future, we will conduct experiments  
on more progarmming languages.  
The second internal threat stems from the selection of LLMs. Due  
to computational constraints, we evaluated only two LLMs (GPT  
and Gemini variants), which may not fully represent the capabilities  
of all state-of-the-art models. However, these models were chosen  
for their dominance in code generation research \[ 7 , 37 , 58 \], and our  
methodology is model-agnostic by design.  
The third internal threat involves our evaluation metric. While  
Pass@k effectively measures functional correctness, it does not  
assess code quality aspects such as readability, maintainability, or  
alignment with repository conventions. Future work could incor-  
porate static analysis or human evaluations to address this threat.  
\`\`\`  
\`\`\`  
External Threats.The first external threat is potential data  
leakage. Although our datasets are widely used in prior work, some  
\`\`\`

What to Retrieve for Effective Retrieval-Augmented Code Generation? An Empirical Study and Beyond Conference acronym ’XX, June 03–05, 2018, Woodstock, NY

\`\`\`  
repository code may have been included in the pretraining data of  
evaluated LLMs. In the future, dynamically evolving benchmarks  
could be investigated to mitigate this threat.  
The second external threat is the inherent randomness in LLM  
generation. Despite setting temperature to 0.7, minor output varia-  
tions may persist. We mitigated this by repeating experiments five  
times per test case and reporting averagedPass@kscores.  
The third external threat concerns the generalizability of our  
retrieval strategy. AllianceCoder relies on unsupervised API de-  
scription generation, which assumes APIs have meaningful natural  
language semantics. This may underperform in repositories with  
poorly documented or cryptically named APIs. We partially ad-  
dressed this by using LLM-generated descriptions to bridge seman-  
tic gaps, but edge cases (e.g., generated hallucinated descriptions)  
require further investigation.  
\`\`\`  
\#\# 10 Conclusion

This paper presents an empirical study on the role of retrieved in-  
formation in retrieval-augmented repository-level code generation.  
Empirical results demonstrate that in-context code and potential  
API information significantly enhance LLM performance, while re-  
trieved similar code snippets often introduce noise. Based on these  
insights, we propose AllianceCoder, a novel context-integrated  
method that leverages chain-of-thought prompting to decompose  
requirements and retrieve APIs via semantic descriptions accord-  
ing to the decomposed requirements. Experiments on multiple  
benchmarks show that AllianceCoder outperforms state-of-the-art  
baselines by up to 20% in Pass@1, highlighting the importance of  
targeted retrieval strategies for complex code generation.

\#\# References

\`\`\`  
\[1\]Josh Achiam, Steven Adler, Sandhini Agarwal, Lama Ahmad, Ilge Akkaya, Floren-  
cia Leoni Aleman, Diogo Almeida, Janko Altenschmidt, Sam Altman, Shyamal  
Anadkat, et al.2023. Gpt-4 technical report.arXiv preprint arXiv:2303.  
(2023).  
\[2\]Akari Asai, Zeqiu Wu, Yizhong Wang, Avirup Sil, and Hannaneh Hajishirzi. 2023\.  
Self-rag: Learning to retrieve, generate, and critique through self-reflection. In  
The Twelfth International Conference on Learning Representations.  
\[3\]Ingeol Baek, Hwan Chang, Byeongjeong Kim, Jimin Lee, and Hwanhee Lee. 2024\.  
Probing-RAG: Self-Probing to Guide Language Models in Selective Document  
Retrieval.arXiv preprint arXiv:2410.13339(2024).  
\[4\]Ramakrishna Bairi, Atharv Sonwane, Aditya Kanade, Arun Iyer, Suresh  
Parthasarathy, Sriram Rajamani, B Ashok, and Shashank Shet. 2024\. Codeplan:  
Repository-level coding using llms and planning.Proceedings of the ACM on  
Software Engineering1, FSE (2024), 675–698.  
\[5\]Avishkar Bhoopchand, Tim Rocktäschel, Earl Barr, and Sebastian Riedel. 2016\.  
Learning python code suggestion with a sparse pointer network.arXiv preprint  
arXiv:1611.08307(2016).  
\[6\]Zhangqian Bi, Yao Wan, Zheng Wang, Hongyu Zhang, Batu Guan, Fangxin Lu,  
Zili Zhang, Yulei Sui, Hai Jin, and Xuanhua Shi. 2024\. Iterative refinement of  
project-level code context for precise code generation with compiler feedback.  
arXiv preprint arXiv:2403.16792(2024).  
\[7\]Tuan-Dung Bui, Duc-Thieu Luu-Van, Thanh-Phat Nguyen, Thu-Trang Nguyen,  
Son Nguyen, and Hieu Dinh Vo. 2024\. Rambo: Enhancing rag-based repository-  
level method body completion.arXiv preprint arXiv:2409.15204(2024).  
\[8\]Mark Chen, Jerry Tworek, Heewoo Jun, Qiming Yuan, Henrique Ponde  
De Oliveira Pinto, Jared Kaplan, Harri Edwards, Yuri Burda, Nicholas Joseph,  
Greg Brockman, et al.2021. Evaluating large language models trained on code.  
arXiv preprint arXiv:2107.03374(2021).  
\[9\]Yujia Chen, Cuiyun Gao, Xiaoxue Ren, Yun Peng, Xin Xia, and Michael R Lyu. 2023\.  
API usage recommendation via multi-view heterogeneous graph representation  
learning.IEEE Transactions on Software Engineering49, 5 (2023), 3289–3304.  
\[10\]Wei Cheng, Yuhan Wu, and Wei Hu. 2024\. Dataflow-guided retrieval augmen-  
tation for repository-level code completion.arXiv preprint arXiv:2405.  
(2024).  
\`\`\`  
\`\`\`  
\[11\]Ken Deng, Jiaheng Liu, He Zhu, Congnan Liu, Jingxin Li, Jiakai Wang, Peng Zhao,  
Chenchen Zhang, Yanan Wu, Xueqiao Yin, et al.2024. R2c2-coder: Enhancing  
and benchmarking real-world repository-level code completion abilities of code  
large language models.arXiv preprint arXiv:2406.01359(2024).  
\[12\]Yangruibo Ding, Zijian Wang, Wasi Ahmad, Hantian Ding, Ming Tan, Nihal Jain,  
Murali Krishna Ramanathan, Ramesh Nallapati, Parminder Bhatia, Dan Roth,  
et al.2023. Crosscodeeval: A diverse and multilingual benchmark for cross-file  
code completion.Advances in Neural Information Processing Systems36 (2023),  
46701–46723.  
\[13\]Yangruibo Ding, Zijian Wang, Wasi Uddin Ahmad, Murali Krishna Ramanathan,  
Ramesh Nallapati, Parminder Bhatia, Dan Roth, and Bing Xiang. 2022\. Cocomic:  
Code completion by jointly modeling in-file and cross-file context.arXiv preprint  
arXiv:2212.10007(2022).  
\[14\]Yuxin Dong, Shuo Wang, Hongye Zheng, Jiajing Chen, Zhenhong Zhang, and  
Chihang Wang. 2024\. Advanced RAG Models with Graph Structures: Optimizing  
Complex Knowledge Reasoning and Text Generation. In2024 5th International  
Symposium on Computer Engineering and Intelligent Communications (ISCEIC).  
IEEE, 626–630.  
\[15\]Aryaz Eghbali and Michael Pradel. 2024\. De-Hallucinator: Mitigating LLM  
Hallucinations in Code Generation Tasks via Iterative Grounding.arXiv preprint  
arXiv:2401.01701(2024).  
\[16\]Daya Guo, Shuai Lu, Nan Duan, Yanlin Wang, Ming Zhou, and Jian Yin. 2022\.  
Unixcoder: Unified cross-modal pre-training for code representation.arXiv  
preprint arXiv:2203.03850(2022).  
\[17\]Daya Guo, Qihao Zhu, Dejian Yang, Zhenda Xie, Kai Dong, Wentao Zhang,  
Guanting Chen, Xiao Bi, Yu Wu, YK Li, et al.2024. DeepSeek-Coder: When the  
Large Language Model Meets Programming–The Rise of Code Intelligence.arXiv  
preprint arXiv:2401.14196(2024).  
\[18\]Lianghong Guo, Yanlin Wang, Ensheng Shi, Wanjun Zhong, Hongyu Zhang, Jiachi  
Chen, Ruikai Zhang, Yuchi Ma, and Zibin Zheng. 2024\. When to stop? towards  
efficient code generation in llms with excess token prevention. InProceedings of  
the 33rd ACM SIGSOFT International Symposium on Software Testing and Analysis.  
1073–1085.  
\[19\]Qi Guo, Xiaohong Li, Xiaofei Xie, Shangqing Liu, Ze Tang, Ruitao Feng, Junjie  
Wang, Jidong Ge, and Lei Bu. 2024\. FT2Ra: A Fine-Tuning-Inspired Approach to  
Retrieval-Augmented Code Completion. InProceedings of the 33rd ACM SIGSOFT  
International Symposium on Software Testing and Analysis. 313–324.  
\[20\]Nam Le Hai, Dung Manh Nguyen, and Nghi DQ Bui. 2024\. On the Impacts of  
Contexts on Repository-Level Code Generation.arXiv preprint arXiv:2406.  
(2024).  
\[21\]Shirley Anugrah Hayati, Raphael Olivier, Pravalika Avvaru, Pengcheng Yin, An-  
thony Tomasic, and Graham Neubig. 2018\. Retrieval-based neural code generation.  
arXiv preprint arXiv:1808.10025(2018).  
\[22\]Abram Hindle, Earl T Barr, Mark Gabel, Zhendong Su, and Premkumar Devanbu.  
\`\`\`  
2016\. On the naturalness of software.Commun. ACM59, 5 (2016), 122–131.  
\[23\]Maliheh Izadi, Roberta Gismondi, and Georgios Gousios. 2022\. Codefill: Multi-  
token code completion by jointly learning from structure and naming sequences.  
InProceedings of the 44th international conference on software engineering. 401–  
412\.  
\[24\]Urvashi Khandelwal, Omer Levy, Dan Jurafsky, Luke Zettlemoyer, and Mike  
Lewis. 2019\. Generalization through memorization: Nearest neighbor language  
models.arXiv preprint arXiv:1911.00172(2019).  
\[25\]Patrick Lewis, Ethan Perez, Aleksandra Piktus, Fabio Petroni, Vladimir Karpukhin,  
Naman Goyal, Heinrich Küttler, Mike Lewis, Wen-tau Yih, Tim Rocktäschel,  
et al.2020. Retrieval-augmented generation for knowledge-intensive nlp tasks.  
Advances in neural information processing systems33 (2020), 9459–9474.  
\[26\]Bolun Li, Zhihong Sun, Tao Huang, Hongyu Zhang, Yao Wan, Ge Li, Zhi Jin, and  
Chen Lyu. 2024\. Ircoco: Immediate rewards-guided deep reinforcement learning  
for code completion.Proceedings of the ACM on Software Engineering1, FSE  
(2024), 182–203.  
\[27\]Yujia Li, David Choi, Junyoung Chung, Nate Kushman, Julian Schrittwieser, Rémi  
Leblond, Tom Eccles, James Keeling, Felix Gimeno, Agustin Dal Lago, et al.2022.  
Competition-level code generation with alphacode.Science378, 6624 (2022),  
1092–1097.  
\[28\]Yifan Li, Ensheng Shi, Dewu Zheng, Kefeng Duan, Jiachi Chen, and Yanlin Wang.  
2024\. RepoMinCoder: Improving Repository-Level Code Generation Based on  
Information Loss Screening. InProceedings of the 15th Asia-Pacific Symposium on  
Internetware. 229–238.  
\[29\]Ming Liang, Xiaoheng Xie, Gehao Zhang, Xunjin Zheng, Peng Di, Hongwei  
Chen, Chengpeng Wang, Gang Fan, et al.2024. Repofuse: Repository-level code  
completion with fused dual context.arXiv preprint arXiv:2402.14323(2024).  
\[30\]Ming Liang, Xiaoheng Xie, Gehao Zhang, Xunjin Zheng, Peng Di, Wei Jiang,  
Hongwei Chen, Chengpeng Wang, and Gang Fan. 2024\. RepoGenix: Dual Context-  
Aided Repository-Level Code Completion with Language Models. InProceedings  
of the 39th IEEE/ACM International Conference on Automated Software Engineering  
(Sacramento, CA, USA)(ASE ’24). Association for Computing Machinery, New  
York, NY, USA, 2466–2467. doi:10.1145/3691620.

Conference acronym ’XX, June 03–05, 2018, Woodstock, NY Gu et al.

\[31\]Dianshu Liao, Shidong Pan, Xiaoyu Sun, Xiaoxue Ren, Qing Huang, Zhenchang  
Xing, Huan Jin, and Qinying Li. 2024\. A3-CodGen: A Repository-Level Code  
Generation Framework for Code Reuse with Local-Aware, Global-Aware, and  
Third-Party-Library-Aware.IEEE Transactions on Software Engineering(2024).  
\[32\]Aixin Liu, Bei Feng, Bing Xue, Bingxuan Wang, Bochao Wu, Chengda Lu, Cheng-  
gang Zhao, Chengqi Deng, Chenyu Zhang, Chong Ruan, et al.2024. Deepseek-v  
technical report.arXiv preprint arXiv:2412.19437(2024).  
\[33\]Chao Liu, Xin Xia, David Lo, Cuiyun Gao, Xiaohu Yang, and John Grundy. 2021\.  
Opportunities and challenges in code search tools.ACM Computing Surveys  
(CSUR)54, 9 (2021), 1–40.  
\[34\]Tianyang Liu, Canwen Xu, and Julian McAuley. 2023\. Repobench: Benchmarking  
repository-level code auto-completion systems.arXiv preprint arXiv:2306.  
(2023).  
\[35\]Wei Liu, Ailun Yu, Daoguang Zan, Bo Shen, Wei Zhang, Haiyan Zhao, Zhi Jin, and  
Qianxiang Wang. 2024\. Graphcoder: Enhancing repository-level code completion  
via code context graph-based retrieval and language model. arXiv preprint  
arXiv:2406.07003(2024).  
\[36\]Shuai Lu, Nan Duan, Hojae Han, Daya Guo, Seung-won Hwang, and Alexey  
Svyatkovskiy. 2022\. Reacc: A retrieval-augmented code completion framework.  
arXiv preprint arXiv:2203.07722(2022).  
\[37\]Siru Ouyang, Wenhao Yu, Kaixin Ma, Zilin Xiao, Zhihan Zhang, Mengzhao Jia,  
Jiawei Han, Hongming Zhang, and Dong Yu. 2024\. RepoGraph: Enhancing  
AI Software Engineering with Repository-level Code Graph.arXiv preprint  
arXiv:2410.14684(2024).  
\[38\]Md Rizwan Parvez, Wasi Uddin Ahmad, Saikat Chakraborty, Baishakhi Ray, and  
Kai-Wei Chang. 2021\. Retrieval augmented code generation and summarization.  
arXiv preprint arXiv:2108.11601(2021).  
\[39\]Huy N Phan, Hoang N Phan, Tien N Nguyen, and Nghi DQ Bui. 2024\. Repohyper:  
Better context retrieval is all you need for repository-level code completion.arXiv  
e-prints(2024), arXiv–2403.  
\[40\]S Jansi Rani, SG Deepika, D Devdharshini, and Harini Ravindran. 2024\. Aug-  
menting Code Sequencing with Retrieval-Augmented Generation (RAG) for  
Context-Aware Code Synthesis. In2024 First International Conference on Software,  
Systems and Information Technology (SSITCON). IEEE, 1–7.  
\[41\]Veselin Raychev, Martin Vechev, and Eran Yahav. 2014\. Code completion with  
statistical language models. InProceedings of the 35th ACM SIGPLAN conference  
on programming language design and implementation. 419–428.  
\[42\]Baptiste Roziere, Jonas Gehring, Fabian Gloeckle, Sten Sootla, Itai Gat, Xiao-  
qing Ellen Tan, Yossi Adi, Jingyu Liu, Romain Sauvestre, Tal Remez, et al.2023.  
Code llama: Open foundation models for code.arXiv preprint arXiv:2308.  
(2023).  
\[43\]Jiho Shin and Jaechang Nam. 2021\. A survey of automatic code generation from  
natural language.Journal of Information Processing Systems17, 3 (2021), 537–555.  
\[44\]Alexey Svyatkovskiy, Shao Kun Deng, Shengyu Fu, and Neel Sundaresan. 2020\.  
Intellicode compose: Code generation using transformer. InProceedings of the 28th  
ACM joint meeting on European software engineering conference and symposium  
on the foundations of software engineering. 1433–1443.  
\[45\]Ze Tang, Jidong Ge, Shangqing Liu, Tingwei Zhu, Tongtong Xu, Liguo Huang,  
and Bin Luo. 2023\. Domain adaptive code completion via language models and  
decoupled domain databases. In2023 38th IEEE/ACM International Conference on  
Automated Software Engineering (ASE). IEEE, 421–433.  
\[46\]Jicheng Wang, Yifeng He, and Hao Chen. 2024\. RepoGenReflex: Enhancing  
Repository-Level Code Completion with Verbal Reinforcement and Retrieval-  
Augmented Generation.arXiv preprint arXiv:2409.13122(2024).  
\[47\]Renxi Wang, Xudong Han, Lei Ji, Shu Wang, Timothy Baldwin, and Haonan Li.

2024\. Toolgen: Unified tool retrieval and calling via generation.arXiv preprint  
arXiv:2410.03439(2024).  
\[48\]Yanlin Wang and Hui Li. 2021\. Code completion by modeling flattened abstract  
syntax trees as graphs. InProceedings of the AAAI conference on artificial intelli-  
gence, Vol. 35\. 14015–14023.  
\[49\]Yanlin Wang, Yanli Wang, Daya Guo, Jiachi Chen, Ruikai Zhang, Yuchi Ma, and  
Zibin Zheng. 2024\. Rlcoder: Reinforcement learning for repository-level code  
completion.arXiv preprint arXiv:2407.19487(2024).  
\[50\]Di Wu, Wasi Uddin Ahmad, Dejiao Zhang, Murali Krishna Ramanathan, and  
Xiaofei Ma. 2024\. Repoformer: Selective retrieval for repository-level code com-  
pletion.arXiv preprint arXiv:2403.10059(2024).  
\[51\]An Yang, Baosong Yang, Beichen Zhang, Binyuan Hui, Bo Zheng, Bowen Yu,  
Chengyuan Li, Dayiheng Liu, Fei Huang, Haoran Wei, et al.2024. Qwen2. 5  
technical report.arXiv preprint arXiv:2412.15115(2024).  
\[52\]Ori Yoran, Tomer Wolfson, Ori Ram, and Jonathan Berant. 2023\. Making  
retrieval-augmented language models robust to irrelevant context.arXiv preprint  
arXiv:2310.01558(2023).  
\[53\]Hao Yu, Bo Shen, Dezhi Ran, Jiaxin Zhang, Qi Zhang, Yuchi Ma, Guangtai Liang,  
Ying Li, Qianxiang Wang, and Tao Xie. 2024\. Codereval: A benchmark of prag-  
matic code generation with generative pre-trained models. InProceedings of the  
46th IEEE/ACM International Conference on Software Engineering. 1–12.  
\[54\]Tian Yu, Shaolei Zhang, and Yang Feng. 2024\. Auto-rag: Autonomous retrieval-  
augmented generation for large language models.arXiv preprint arXiv:2411.

\`\`\`  
(2024).  
\[55\]Daoguang Zan, Bei Chen, Yongshun Gong, Junzhi Cao, Fengji Zhang, Bingchao  
Wu, Bei Guan, Yilong Yin, and Yongji Wang. 2023\. Private-library-oriented code  
generation with large language models.arXiv preprint arXiv:2307.15370(2023).  
\[56\]Daoguang Zan, Bei Chen, Dejian Yang, Zeqi Lin, Minsu Kim, Bei Guan, Yongji  
Wang, Weizhu Chen, and Jian-Guang Lou. 2022\. CERT: continual pre-training  
on sketches for library-oriented code generation.arXiv preprint arXiv:2206.  
(2022).  
\[57\]Fengji Zhang, Bei Chen, Yue Zhang, Jacky Keung, Jin Liu, Daoguang Zan, Yi Mao,  
Jian-Guang Lou, and Weizhu Chen. 2023\. Repocoder: Repository-level code com-  
pletion through iterative retrieval and generation.arXiv preprint arXiv:2303.  
(2023).  
\[58\]Kechi Zhang, Jia Li, Ge Li, Xianjie Shi, and Zhi Jin. 2024\. Codeagent: Enhancing  
code generation with tool-integrated agent systems for real-world repo-level  
coding challenges.arXiv preprint arXiv:2401.07339(2024).  
\[59\]Wenrui Zhang, Tiehang Fu, Ting Yuan, Ge Zhang, Dong Chen, and Jie Wang.  
\`\`\`  
2024\. A Lightweight Framework for Adaptive Retrieval In Code Completion  
With Critique Model.arXiv preprint arXiv:2406.10263(2024).  
\[60\]Shuyan Zhou, Uri Alon, Sumit Agarwal, and Graham Neubig. 2023\. Codebertscore:  
Evaluating code generation with pretrained models of code.arXiv preprint  
arXiv:2302.05527(2023).  
\[61\]Shuyan Zhou, Uri Alon, Frank F Xu, Zhiruo Wang, Zhengbao Jiang, and Graham  
Neubig. 2022\. Docprompting: Generating code by retrieving the docs.arXiv  
preprint arXiv: 2207.05987(2022).  
\[62\]Yuqi Zhu, Jia Li, Ge Li, YunFei Zhao, Zhi Jin, and Hong Mei. 2024\. Hot or cold?  
adaptive temperature sampling for code generation with large language models.  
InProceedings of the AAAI Conference on Artificial Intelligence, Vol. 38\. 437–445.

\`\`\`  
Received 20 February 2007; revised 12 March 2009; accepted 5 June 2009  
\`\`\`


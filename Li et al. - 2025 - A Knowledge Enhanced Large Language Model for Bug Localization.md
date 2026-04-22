\`\`\`  
..  
Latest updates: hps://dl.acm.org/doi/10.1145/  
..  
RESEARCH-ARTICLE  
\`\`\`  
\#\# A Knowledge Enhanced Large Language Model for Bug

\#\# Localization

\`\`\`  
YUE LI, Nanjing University, Nanjing, Jiangsu, China  
.  
BOHAN LIU, Nanjing University, Nanjing, Jiangsu, China  
.  
TING ZHANG, Singapore Management University, Singapore City,  
Singapore  
.  
ZHIQI WANG, Nanjing University, Nanjing, Jiangsu, China  
.  
DAVID LO, Singapore Management University, Singapore City, Singapore  
.  
LANXIN YANG, Nanjing University, Nanjing, Jiangsu, China  
.  
View all  
..  
Open Access Support provided by:  
.  
Nanjing University  
.  
Singapore Management University  
.  
\`\`\`  
\`\`\`  
PDF Download  
3729356.pdf  
04 April 2026  
Total Citations: 1  
Total Downloads:  
\`\`\`  
(^1333).  
.  
Published: 19 June 2025  
Accepted: 01 April 2025  
Received:. 13 September 2024  
.  
Citation in BibTeX format.  
.  
Proceedings of the ACM on Soware Engineering, Volume 2, Issue FSE (June 2025\)  
hps://doi.org/10.1145/  
EISSN: 2994-970X  
.

\# A Knowledge Enhanced Large Language Model for Bug

\# Localization

\#\#\# YUE LI,Nanjing University, China

\#\#\# BOHAN LIU,Nanjing University, China

\#\#\# TING ZHANG,Singapore Management University, Singapore

\#\#\# ZHIQI WANG,Nanjing University, China

\#\#\# DAVID LO,Singapore Management University, Singapore

\#\#\# LANXIN YANG,Nanjing University, China

\#\#\# JUN LYU,Nanjing University, China

\#\#\# HE ZHANG∗,Nanjing University, China

\`\`\`  
A significant number of bug reports are generated every day as software systems continue to develop.  
Large Language Models (LLMs) have been used to correlate bug reports with source code to locate bugs  
automatically. The existing research has shown that LLMs are effective for bug localization and can increase  
software development efficiency. However, these studies still have two limitations. First, these models fail to  
capture context information about bug reports and source code. Second, these models are unable to understand  
the domain-specific expertise inherent to particular projects, such as version information in projects that are  
composed of alphanumeric characters without any semantic meaning.  
To address these challenges, we propose aKnowledgeEnhancedPre-Trained model using project documents  
and historical code, calledKept, for bug localization. Project documents record, revise, and restate project  
information that provides rich semantic information about those projects. Historical code contains rich code  
semantic information that can enhance the reasoning ability of LLMs. Specifically, we construct knowledge  
graphs from project documents and source code. Then, we introduce knowledge graphs to the LLM through  
soft-position embedding and visible matrices, enhancing its contextual and professional reasoning ability. To  
validate our model, we conducted a series of experiments on seven open-source software projects with over  
6,000 bug reports. Compared with the traditional model (i.e., Locus),Keptperforms better by 33.2% to 59.5%  
in terms of mean reciprocal rank, mean average precision, and Top@N. Compared with the best-performing  
non-commercial LLM (i.e., CodeT5),Keptachieves an improvement of 36.6% to 63.7%. Compared to the  
state-of-the-art commercial LLM developed by OpenAI, calledtext-embedding-ada-002,Keptachieves an  
average improvement of 7.8% to 17.4%. The results indicate that introducing knowledge graphs contributes to  
enhance the effectiveness of the LLM in bug localization.  
CCS Concepts:•Software and its engineering→Software testing and debugging.  
Additional Key Words and Phrases: large language model, knowledge enhancement, bug localization, informa-  
tion retrieval  
∗He Zhang is the corresponding author. Lanxin Yang is also the corresponding author.  
\`\`\`  
\`\`\`  
Authors’ Contact Information: Yue Li, Nanjing University, Nanjing, China, yue.li@smail.nju.edu.cn; Bohan Liu, Nanjing  
University, Nanjing, China, bohanliu@nju.edu.cn; Ting Zhang, Singapore Management University, Singapore, Singapore,  
tingzhang.2019@phdcs.smu.edu.sg; Zhiqi Wang, Nanjing University, Nanjing, China, 502022320013@smail.nju.edu.cn;  
David Lo, Singapore Management University, Singapore, Singapore, davidlo@smu.edu.sg; Lanxin Yang, Nanjing University,  
Nanjing, China, lxyang@nju.edu.cn; Jun Lyu, Nanjing University, Nanjing, China, lvjun\_dnt@outlook.com; He Zhang,  
Nanjing University, Nanjing, China, hezhang@nju.edu.cn.  
\`\`\`  
This work is licensed under a Creative Commons Attribution-NoDerivatives 4.0 International License.  
©2025 Copyright held by the owner/author(s).  
ACM 2994-970X/2025/7-ARTFSE  
https://doi.org/10.1145/

\`\`\`  
FSE086:2 Yue Li, Bohan Liu, Ting Zhang, Zhiqi Wang, David Lo, Lanxin Yang, Jun Lyu, and He Zhang  
\`\`\`  
ACM Reference Format:  
Yue Li, Bohan Liu, Ting Zhang, Zhiqi Wang, David Lo, Lanxin Yang, Jun Lyu, and He Zhang. 2025\. A Knowledge  
Enhanced Large Language Model for Bug Localization.Proc. ACM Softw. Eng.2, FSE, Article FSE086 ( July 2025),  
23 pages. https://doi.org/10.1145/

\`\`\`  
1 Introduction  
\`\`\`  
As software systems are developed and evolve, a large number of bug reports are generated, making  
bug localization critical and labor-intensive \[ 8 , 16 , 44 \]. Effective bug localization enhances software  
maintenance efficiency and ensures software product quality. Bug localization is a time-consuming  
task that requires understanding bug reports and locating the source code that needs to be fixed.  
A recent study shows that 32% of time and cost is spent on bug localization during the software  
development life cycle \[ 42 \]. Bug localization remains a challenging task due to the significant gap  
between the natural language used to describe bugs in bug reports and the programming language  
used to develop software products in source code \[ 57 \]. Further research is required to improve the  
effectiveness and accuracy of bug localization techniques.  
In the literature, there are quite a few studies that propose automatic linkage of bug reports in bug  
tracking systems with buggy code in version control systems \[ 19 , 28 , 31 , 55 \]. Information retrieval  
(IR) techniques are proposed and explored to be effective in bug localization, demonstrating the  
potential to improve software developers’ productivity \[ 4 \]. These techniques take historical bug  
reports and source code as inputs and output a ranked list of source code that may cause the  
bugs. Several researchers have calculated the semantic similarity of bug reports and source code  
by extracting semantic features between them. In recent years, LLMs have gained considerable  
attention from researchers in bug localization since it has achieved performance breakthroughs in  
various natural language processing tasks (e.g., IR) \[12\].  
LLMs have demonstrated boosted performance in various areas, prompting researchers to use  
them in bug localization \[ 46 \]. LLMs can effectively capture knowledge from large amounts of data  
because of their sophisticated pre-training objectives and massive model parameters \[ 12 \]. The rich  
knowledge implicitly encoded in massive parameters can benefit a variety of downstream tasks  
when stored in many parameters and fine-tuned for specific tasks, as demonstrated in extensive  
experimental verifications and empirical analyses \[46\].  
LLMs are used for a variety of purposes, including bug localization since they possess powerful  
capabilities for capturing knowledge. Ciborowska and Damevski\[4\]applied BERT to rapidly locate  
bugs based on changesets by encoding changesets in different ways. The evaluation results reveal  
the advantages of using the proposed BERT model in comparison with the baselines for bug  
localization. Discriminative LLMs, such as BERT, serve as a kind of auto-denoising encoder for  
automatically corrupted texts \[ 56 \]. Agnieszka and andKostadin explore several design decisions  
related to using BERT for changeset-based bug localization \[ 4 \]. The evaluation results demonstrate  
that the proposed BERT model has advantages over the baselines, especially for bug reports that do  
not contain any hints regarding related code elements. Du and Yu represent source code through  
semantic flow graphs, and evaluation results indicate that their method achieves state-of-the-art  
bug localization performance \[5\].  
Although these LLMs have shown promising results in bug localization, they suffer from the  
following two weaknesses.  
First, these models have difficulty in capturing the context information of bug reports and source  
code. The descriptions of bug reports and the contents of changesets are usually brief and cannot  
provide sufficient background information. As a result, the model is unable to fully comprehend  
the content of the bug report and the content of the source code.

\`\`\`  
A Knowledge Enhanced Large Language Model for Bug Localization FSE086:  
\`\`\`  
Second, these models fail to understand the domain-specific expertise of particular projects. As  
domain-specific text, bug reports contain large amounts of domain-specific knowledge that rarely  
appears in natural language corpora, making it difficult for LLMs to understand their accurate  
meaning. Furthermore, source code is a highly structured and formalized language that encapsulates  
a wide range of project-specific knowledge. For example, the version information is included in  
bug reports, and the class names are defined in the code.  
To alleviate these problems, we proposeKept, an LLM that leverages domain knowledge of  
project documents and source code, which introduces domain knowledge to enhance an LLM. By  
leveraging terminology and natural language descriptions in documents and the historical source  
code of the project, which can be readily accessed from public repositories,Keptempowers LLMs  
to memorize and reason about bug reports and source code. In addition, it is consistent with the  
process of bug localization performed by experts, who also need to consult project documents and  
source code when they encounter unfamiliar bug reports.  
In this paper, we design novel model structures to effectively use domain knowledge to improve  
the LLMs’ memorization and reasoning abilities for bug reports and source code. First, we construct  
a text knowledge graph based on the historical documents and a code knowledge graph based on  
the source code. Then, we integrate the extracted knowledge graphs into the LLM to enhance its  
reasoning abilities for expertise in bug reports and source code. Incorporating too much knowledge  
could lead to a deviation from the intended meaning of the sentence. To overcome these challenges,  
we use soft-position embedding to reconstruct the position of the token and visible matrix to limit  
the visible range of each token.  
To evaluate the effectiveness ofKept, we compare its results with five state-of-the-art models  
(i.e., Locus \[ 47 \], GPT-2 \[ 32 \], GraphCodeBERT \[ 11 \], CodeT5 \[ 46 \], andtext-embedding-ada-002).  
Locus is the first model to use changesets to locate bugs. GPT-2 and CodeT5 have been widely  
recognized as leading LLMs because of their robust capabilities. GraphCodeBERT is an advanced  
LLM that uses graphs to illustrate the inherent structure of code.text-embedding-ada-002is an  
efficient text embedding model developed by OpenAI, capable of generating high-quality vector  
representations \[ 20 \]. We conduct a series of evaluations of seven open source software (OSS) with  
over 6,000 bug reports to validate our model. As measured across OSS projects,Keptoutperforms  
Locus by 33.2% to 59.5% on average, and outperforms CodeT5, the best-performing LLM, by 36.6%  
to 63.7% on various evaluation metrics (i.e., mean reciprocal rank, mean average precision, and  
Top@N). The experimental results show thatKeptoutperforms all five state-of-the-art models in  
bug localization. In addition, the results indicate that our approach can improve the effectiveness  
of three LLMs for bug localization.  
The main contributions of this study can be concluded as follows:

\- A knowledge enhanced pre-trained approach:To the best of our knowledge, this study  
    is the first attempt to enhance the LLM by introducing domain knowledge in bug localization,  
    which has the potential to improve LLMs’ memorization and reasoning abilities for bug  
    reports and source code.  
\- A novel model:We present a model for representing knowledge graphs using soft-position  
    embedding and visible matrices to effectively inject domain knowledge without introducing  
    knowledge noise into the model.  
\- An extensive evaluation:We evaluate the effectiveness of the knowledge-enhanced LLM  
    on over 6,000 bug reports in seven OSS projects. The experimental results indicate that our  
    knowledge-enhanced LLM outperforms the state-of-the-art models. In particular, LLMs with  
    knowledge enhancement perform significantly better than those without.

\`\`\`  
FSE086:4 Yue Li, Bohan Liu, Ting Zhang, Zhiqi Wang, David Lo, Lanxin Yang, Jun Lyu, and He Zhang  
\`\`\`  
2 Background and Motivation  
2.1 IR-based Bug Localization  
IR technologies play an important role in bug localization, which involves matching bug reports  
with source code. LLMs have exhibited outstanding performance in various IR tasks, including  
bug localization \[ 27 \]. To illustrate the process, we describe the steps involved in using an LLM for  
bug localization. The architecture of an LLM typically consists of multiple Transformer encoders,  
which are designed to model sequence data using a self-attention mechanism \[ 6 \]. The concept of  
attention is to assign different weights to specific words in the sequence,i.e., to encode a stronger  
relationship between each word in the sequence and its semantically related word. The process  
of using an LLM for bug localization involves three main steps: first, the model is pre-trained on  
a large corpus of Software Engineering (SE) data, then it is fine-tuned for bug localization, and  
finally, suspicious code files are retrieved for a new bug report.

2.2 Existing Methods with LLM  
2.2.1 LLM For Bug Localization.During pre-training, an LLM uses a large corpus of relevant text  
to construct a domain-specific language model, such as an SE language model trained on Stack  
Overflow data \[ 39 \]. Since the pre-training step requires a large amount of data and resources, many  
researchers opt to fine-tune LLMs for downstream tasks rather than training models from scratch.  
The fine-tuning is designed to train an LLM on a small dataset to apply it to specific tasks, such  
as bug localization. Typically, the LLM is fine-tuned by adding additional layers, which incorporate  
the output of an LLM as inputs. Since the goal of this study is to locate the bug-inducing code files,  
it is necessary to select a task-specific dataset that includes bug reports and buggy code files.  
2.2.2 Knowledge Enhancement LLMs.Despite the advantages that LLMs possess, such as efficiently  
learning rich knowledge from large training texts and utilizing downstream tasks during their fine-  
tuning phase, they still have some limitations, such as poor inference abilities due to deficiencies in  
external knowledge.  
LLMs have been widely applied to many fields in recent years due to their boosted performance.  
Although LLMs have the advantage of efficiently learning rich knowledge from large training texts  
and benefiting downstream tasks during their fine-tuning stages, they still possess some limitations,  
such as poor inference abilities due to a lack of external knowledge. To address these issues, research  
has been dedicated to integrating knowledge graphs into LLMs. Generally, knowledge-enhanced  
approaches are divided into the following two categories \[ 13 \]: By integrating knowledge graphs  
through pre-trained tasks, LLMs can learn representations related to knowledge graphs during the  
pre-trained phase.  
Through pre-trained tasks.These approaches design a joint pre-trained task that integrates entity  
embedding with text embedding. This task combines knowledge graph embedding tasks with  
training tasks using masked language modeling (MLM). While injecting knowledge graphs into  
LLMs through pre-trained tasks is feasible, this integration approach is inefficient and expensive \[ 38 \].  
On the one hand, introducing knowledge graphs through pre-trained tasks increases the additional  
training workload. On the other hand, the model is unable to adapt to changes in the knowledge  
graph, increasing the training cost when the knowledge graph changes \[13\].  
Changing the attention mechanisms.To integrate corresponding knowledge into LLMs, several  
approaches attempt to modify the attention mechanism within the Transformer architecture.  
For example, KEAR \[ 51 \] splices knowledge graph entity-related triples, entity descriptions, and  
additional questions as external knowledge with the original input, and then applies a self-attention  
mechanism to the spliced input. This category of approaches can integrate knowledge graphs  
without changing the model structure, and it is suitable for most LLMs using the Transformer

\`\`\`  
A Knowledge Enhanced Large Language Model for Bug Localization FSE086:  
\`\`\`  
\`\`\`  
Text Knowledge Graph  
\`\`\`  
\`\`\`  
Criteria is-a  
compareCrit condition  
is-a  
\`\`\`  
\`\`\`  
predicate  
\`\`\`  
\`\`\`  
regexMatchCrit  
\`\`\`  
\`\`\`  
is-a  
\`\`\`  
\`\`\`  
Code Knowledge Graph  
\`\`\`  
\`\`\`  
TestQueryRewriter has  
\`\`\`  
\`\`\`  
hashelpTestRewriteCriteria  
parseCriteria  
\`\`\`  
\`\`\`  
Bug Report: TEIID-  
The rewrite of a condition such as "not((a or  
b) AND c)" with a,b,c predicates where c a  
is predicate that is negatable, such as ...  
\`\`\`  
\`\`\`  
Code Changeset: engine/src/test/java/org/  
teiid/query/rewriter/TestQueryRewriter.java  
private Criteria  
helpTestRewriteCriteria(String  
original, Criteria expectedCrit,  
QueryMetadataInterface metadata) {  
Criteria origCrit \= parseCriteria(original,  
metadata) ...  
\`\`\`  
\`\`\`  
has Code Sentence Tree  
\`\`\`  
\`\`\`  
TestQueryRewriter has  
\`\`\`  
\`\`\`  
TestQueryRewriter  
private Criteria helpTestRewriteCriteria(String original,  
Criteria  
expectedCrit, QueryMetadataInterface metadata) {  
Criteria origCrit \= parseCriteria(original,  
metadata) ...  
\`\`\`  
\`\`\`  
Criteria is-a  
\`\`\`  
\`\`\`  
compareCrit is-a  
\`\`\`  
\`\`\`  
The rewrite of a condition such as "not((a or b) AND c)"  
with a,b,c predicates where c a is predicate that is  
negatable, such as ...  
\`\`\`  
\`\`\`  
Text Sentence Tree  
\`\`\`  
\`\`\`  
Knowledge Injection  
\`\`\`  
\`\`\`  
Sentence tree  
trunk  
\`\`\`  
\`\`\`  
Inserted text  
knowledge graph  
\`\`\`  
\`\`\`  
Inserted code  
knowledge graph  
\`\`\`  
Fig. 1\. An example of knowledge injection  
encoder architecture. In addition, the models can adapt well to changes in the knowledge graph  
without retraining \[ 13 \]. Since approach changing attention mechanisms can adapt to changes in  
knowledge graphs and introduce them at a lower cost than others, we also use the approach to  
integrating knowledge graphs into LLMs.  
Bug localization is of paramount importance to software maintenance, and it has achieved  
promising advancements. However, bug localization remains an open question, given the limitation  
caused by the significant difference between the natural language describing bugs and the source  
code implementing software. Existing bug localization methods using LLMs often lack external  
knowledge, limiting their effectiveness.  
Motivated by the aforementioned challenges, we propose a knowledge-enhanced approach. Fig-  
ure 1 illustrates a real example in the JIRA system. A bug report^1 includes the following description:  
“The rewrite of a condition such as "not((a or b) AND c)" witha,b,cpredicates wherecis a  
predicate that is negatable, such ascol1 \= 1\. The result should have the negated form ofcol1 \<\>  
1 , but instead hascol1 \= 1\. This is because thecol1 \= 1predicate is repeated in the result, but not  
cloned and the rewriter modifies the same instance”. The provided description alone is insufficient  
for precise bug localization due to its generic nature and lack of specific code references.

\`\`\`  
2.3 Motivation  
Our approach addresses these challenges by (1) extracting a textual knowledge graph from the  
historical project documentation, (2) creating a code knowledge graph from its historical source  
code, and (3) integrating these knowledge graphs into the sentence trees of a bug report and code  
changesets. Fig. 1 illustrates the extracted textual and code knowledge graphs on the left side.  
We integrate external knowledge using knowledge graphs: (1) the entries in knowledge graphs are  
matched with the entities in bug reports and suspicious code; (2) the matched entries in knowledge  
graphs are added to the bug reports and suspicious code to effectively inject domain knowledge. As  
shown in Figure 1, incorporating Criteria is-a conditionin the text sentence tree enables the  
bug report to be matched with buggy code. In addition, the model can benefit from integrating other  
knowledge graphs, such asTestQueryRewriterhasparseCriteria, to facilitate understanding  
of relationships between entities. Obviously, without contextual information on the bug report and  
suspicious code, it is difficult for the model to understand them. A number of researchers have  
argued that bug reports and source code are difficult to understand without contextual information  
in the literature \[59\].  
\`\`\`  
(^1) https://issues.redhat.com/browse/TEIID-

FSE086:6 Yue Li, Bohan Liu, Ting Zhang, Zhiqi Wang, David Lo, Lanxin Yang, Jun Lyu, and He Zhang

\`\`\`  
Pre-training Fine-tuning  
\`\`\`  
\`\`\`  
Data  
Domain Data Downstream Data  
\`\`\`  
\`\`\`  
Open Relation Extraction Project Document Abstract Syntax Tree Code Repository  
\`\`\`  
\`\`\`  
Text  
Knowledge  
Graph  
\`\`\`  
\`\`\`  
Bug Report  
\`\`\`  
\`\`\`  
Knowledge Injection Layer  
Code  
Knowledge  
Graph  
\`\`\`  
\`\`\`  
Code Changesets  
\`\`\`  
\`\`\`  
Knowledge Injection Layer  
\`\`\`  
\`\`\`  
Sentence Tree  
for Bug Report ...  
\`\`\`  
\`\`\`  
The  
rewrite  
\`\`\`  
\`\`\`  
of  
instance  
\`\`\`  
\`\`\`  
a Condition Sentence Tree for  
Source Code  
\`\`\`  
\`\`\`  
private Criteria  
helpTestRewriteCriteria  
\`\`\`  
\`\`\`  
}  
request  
\`\`\`  
\`\`\`  
...  
\`\`\`  
\`\`\`  
Embedding Layer Seeing Layer Embedding Layer Seeing Layer  
\`\`\`  
\`\`\`  
Mask-Transformer Encoder  
Attn(Q,K,V)=Softmax(A+M)V  
\`\`\`  
\`\`\`  
Contrastive Learning  
Bug Report  
Buggy code  
\`\`\`  
\`\`\`  
Bug-free code  
max  
min  
\`\`\`  
\`\`\`  
Classification layer  
\`\`\`  
\`\`\`  
Not Relevant Relevant  
\`\`\`  
\*\*1. Constructing Knowledge\*\*  
    \*\*Graph  
2\. Constructing Knowledge  
Enhanced Pre-trained Model  
3\. Bug Localization\*\*

Fig. 2\. An overview of the proposed approach  
By enhancing LLMs with this external knowledge, we aim to improve the accuracy and effec-  
tiveness of bug localization, addressing the limitations of existing methods and bridging the gap  
between natural language bug descriptions and source code.

3 Approach

3.1 Definitions of Knowledge Graph

This study aims to construct a knowledge-enhanced LLM that leverages domain knowledge to  
enhance LLM for bug localization. This subsection provides a formal definition of related concepts  
to assist readers in understanding the scope of this project.  
Definition 1: Knowledge graph.A knowledge graph is defined as a system in which all entities  
(e.g., things, places) are stored in the form of connected graphs \[17\].  
Definition 2: Text knowledge graph.We denote a sentence𝑠={𝑤 0 ,𝑤 1 ,𝑤 2 , ...,𝑤𝑛} as a sequence  
of tokens, where𝑛is the length of this sentence. The tokens of the sentence are taken at the word  
level. Each token𝑤𝑖is included in the vocabulary𝑉,𝑤𝑖𝜖𝑉. Text knowledge graph, denoted as𝑇𝐾𝐺,  
is a collection of triples𝜀=(𝑤𝑖,𝑤𝑟𝑗,𝑤𝑘), where𝑤𝑖and𝑤𝑘are the names of entities, and𝑤𝑟𝑗𝜖𝑉is  
the relation between them.  
Definition 3: Code knowledge graph.We denote a code snippet𝑐={𝑐 0 ,𝑐 1 ,𝑐 2 , ...,𝑐𝑛} as a sequence  
of tokens, where𝑛is the length of this code snippet. The tokens of the sentence are taken at the  
character level. We construct an abstract syntax tree (AST) from the source code file using JavaParser.  
The nodes in AST constitute nodes in the code knowledge graph. Code knowledge graph, denoted  
as𝐶𝐾𝐺, represents a set of triples𝜁=(𝑐𝑖,𝑐𝑟𝑗,𝑐𝑘), in which𝑐𝑖and𝑐𝑘represent the names of entities,  
and𝑐𝑟𝑗𝜖𝐴𝑆𝑇is the relation between them.

3.2 Overview

In Figure 2, we provide an overview ofKeptthat aims to improve the accuracy of bug localization  
by incorporating domain-specific information into an LLM. The project documents and the source

\`\`\`  
A Knowledge Enhanced Large Language Model for Bug Localization FSE086:  
\`\`\`  
\`\`\`  
code of the project serve as input domain knowledge, while the history of bug reports and buggy  
code serve as input historical knowledge. The approach consists of three steps.  
First, we construct knowledge graphs (Section 3.3). To construct a text knowledge graph, we  
use Natural Language Toolkit (NLTK) \[ 24 \] to filter noise and use the open relationship extraction  
technology MinIE \[ 7 \] to extract entities and relationships in project documents. NLTK and MinIE  
provide higher precision and recall in extracting knowledge graphs from real-world projects than  
most other tools \[ 7 , 24 \]. To construct a code knowledge graph, we extract the AST structure of the  
project source code using JavaParser^2 , and traverse the AST to obtain entities and relationships in  
the source code.  
Second, we construct the knowledge-enhanced LLM (Section 3.4). The step consists of four parts:  
(1) Model embedding: This part involves generating vector representations of text and code through  
model embedding. There are three layers involved in this processe.g., the knowledge injection  
layer, the knowledge embedding layer, and the seeing layer. (2) Mask Transformer: The input  
embeddings and visible matrix are fed into a mask self-attention, which differs from the traditional  
Transformer encoder. (3) Pre-training model: The UniXcoder model is pre-trained using SE corpora  
(i.e., CodeSearchNet) to adapt to language features and terminologies because of UniXcoder’s  
superior performance in code understanding. (4) Fine-tuning model: The model is fine-tuned using  
historical data on bug localization.  
Finally, we use the LLM to locate bugs. We input the semantic features learned by the LLM into  
the fully connected layer for bug localization.  
\`\`\`  
\`\`\`  
3.3 Constructing Knowledge Graphs  
\`\`\`  
We construct two types of knowledge graphs in this study: (1) a text knowledge graph and (2) a  
code knowledge graph.

\`\`\`  
3.3.1 Constructing Text Knowledge Graphs.We construct a text knowledge graph to effectively  
capture domain knowledge from project documents. First, we use the NLTK module for part-  
of-speech tagging to filter out noise and segment the content of project documents into lists of  
sentences. Second, we use the open relation extraction method MinIE \[ 7 \] to extract entities and  
relationships from the project. MinIE extracts knowledge graphs efficiently from a variety of  
domains, demonstrating robust adaptability across varied corpora. In addition, MinIE constructs  
a minimized dictionary to filter and remove redundant data from the triples. MinIE is unable to  
extract triples directly from web pages, so preprocessing is necessary before extracting the triples.  
The preprocessing consists of three steps: (1) Text extraction: We use Python’s BeautifulSoup  
library to extract textual elements from the documents, which is a widely used library for parsing  
HTML and XML, and constructs a structured parse tree to efficiently extract HTML elements; (2)  
Noise reduction: To minimize noise, we use regular expressions to remove unnecessary whitespace,  
non-linguistic elements (e.g., URLs and email addresses), and special characters. (3) Sentence  
segmentation: The document is segmented into sentences by using the NLTK library, a widely  
used natural language processing tool that accurately segments sentences across a variety of  
languages and formats. After preprocessing, MinIE’s recognizer extracts triples from the sentences.  
The extracted triples are then refined using MinIE’s minimization dictionary, which filters out  
redundant information from the triples.  
\`\`\`  
\`\`\`  
3.3.2 Constructing Code Knowledge Graphs.By using JavaParser, we can obtain the AST of the  
source code, and then traverse the AST to obtain a collection of triplets that are entities of the  
knowledge graph. Following this, we extract the relations possessed by the head and tail entities  
\`\`\`  
(^2) https://github.com/javaparser/javaparser

\`\`\`  
FSE086:8 Yue Li, Bohan Liu, Ting Zhang, Zhiqi Wang, David Lo, Lanxin Yang, Jun Lyu, and He Zhang  
\`\`\`  
\`\`\`  
Gray: Hardposition index  
Red : Softposition index  
\`\`\`  
\`\`\`  
rewrite  
\`\`\`  
\`\`\`  
2  
2  
\`\`\`  
\`\`\`  
of  
\`\`\`  
\`\`\`  
3  
3  
\`\`\`  
(^5) Criteria  
3  
4 is-a  
The  
1  
1  
condition  
11  
5  
a  
10  
4  
16  
10  
same  
13  
8  
...^12  
4  
Visible  
Invisible  
1  
3  
5  
2  
4  
(^67)  
8  
109  
11  
(^1213)  
14  
0  
01234567 891011121314  
rewriter modifies the  
has instance  
is-a  
regexMatchCrit  
queryRewriter  
4 7  
(^69)  
8  
15  
14  
6 7 9  
5  
9  
8  
15  
15  
...  
...  
... ...  
condition  
Fig. 3\. The process of converting a sentence tree into a visible matrix  
of the triples. We traverse the AST to obtain all triples of the relevant source code to build a code  
knowledge graph.  
3.4 Constructing Knowledge Enhanced LLM  
3.4.1 Model Embedding.Model embedding consists of three main components: the knowledge  
injection layer, the embedding layer, and the seeing layer.Keptuses the knowledge injection layer  
to retrieve triples corresponding to input bug reports or buggy code (referred to as input sequences).  
Then, the triples are injected into the input sequence to generate a sentence tree infused with  
knowledge. Finally, the sentence tree is fed into both the knowledge injection layer and the seeing  
layer, where it is transformed into input embeddings and visible matrixes. Through this structure,  
the model can determine the visible range of each token in the self-attention mechanism, thus  
enabling it to acquire external knowledge without losing its original meaning.  
The sentence tree is constructed as follows: (1) we segmented bug reports using UniXcoder’s  
word splitter and code using Pygments^3 , forming the original sentence tree; (2) we matched entities  
in the original sentence tree with those in the constructed knowledge graph; (3) we enriched the  
sentence tree by incorporating matched triples from the knowledge graph, producing the final  
sentence tree.  
Knowledge Injection Layer.The knowledge injection layer is used to query the triples contained  
in the original input based on specific rules, and then integrate the original input with the triplet  
knowledge to form a sentence tree. Specifically, we use Pygments for code disambiguation and  
UniXcoder for bug report disambiguation and then traverse the segmented words to generate the  
corresponding sentence tree nodes. Afterward, the algorithm then iterates over the segmented  
words and generates a sentence tree node for each word. In the next step, the algorithm determines  
if the word has a corresponding entity in the knowledge graph, and if so, adds a ternary relationship  
between the node and the entity. Finally, the algorithm adds the processed sentence tree node to  
the sentence tree.  
Given an input sentence(𝑠𝑒𝑛𝑡𝑒𝑛𝑐𝑒=𝑤 0 ,𝑤 1 ,𝑤 2 , ...,𝑤𝑛)and a knowledge graph𝐾, the knowledge  
injection layer outputs a sentence tree(𝑡𝑟𝑒𝑒=𝑤 0 ,𝑤 1 , ...,𝑤𝑖((𝑟𝑖 0 ,𝑤𝑖 0 ), ...,(𝑟𝑖𝑘,𝑤𝑖𝑘)), ..., 𝑤𝑛), where  
𝑤𝑖represents a word or entity in the input sentence, and𝑇=(𝑤𝑖,𝑟𝑖 0 ,𝑤𝑖 0 ), ...,(𝑤𝑖,𝑟𝑖𝑘,𝑤𝑖𝑘)represents  
the set of triples associated with the word𝑤𝑖, where𝑤𝑖,𝑟𝑖𝑘, and𝑤𝑖𝑘are the head entities, relation,  
and tail entities of the triple, respectively.  
Embedding Layer.The embedding layer converts the sentence tree into corresponding embedding  
representations that can be fed into the mask Transformer. Similar to the Transformer architecture,  
the input embedding ofKeptis composed of token embedding and position embedding, with the  
difference being the use of a soft-position embedding. The structure facilitates the transformation  
(^3) https://pygments.org/

\`\`\`  
A Knowledge Enhanced Large Language Model for Bug Localization FSE086:  
\`\`\`  
\`\`\`  
of the sentence tree into token embedding and positional embedding for the mask Transformer to  
retain its structural features.  
Soft-position embedding ensures the correct order of a sentence tree. As shown in Figure 3,  
introducing triples from the knowledge graph can disrupt the original structure of the sentence tree.  
For example, the sentence “The rewrite of a condition” was reordered to “The rewrite of  
a Criteria” due to the triple(condition, is-a, Criteria)introduced from the knowledge  
graph. Soft-position embedding resolves such disruptions, maintaining the correct order in the  
sentence tree.  
Seeing Layer.Although soft-position embedding ensures the sequential correctness of input  
sequences with their triples, tokens with identical position indices may cause improper correlation  
in the self-attention mechanism. In addition, expanding the sentence tree introduces newly inserted  
triples that affect all tokens, changing the original meaning of the input sequence. For instance, in  
the Figure 3,Criteriais used to decoratecondition, which is unrelated torewrite. Accordingly,  
rewriteshould not be influenced byCriteria.  
To address this problem, we introduce the seeing layer, a visibility matrix, which reduces the  
impact of irrelevant information on model learning. The visible matrix is a technique used to control  
the exposure or visibility of different tokens during the learning or prediction process. It serves as  
a mechanism to ensure that the model does not inject excessive or irrelevant knowledge that could  
distort the meaning of the original sentence or context.  
The visible matrix𝑀is defined as shown in Equation 1\.  
\`\`\`  
\#\#\#\# 𝑀𝑖𝑗=

\#\#\#\#

\#\#\#\# 0 𝑡𝑖⊕𝑡𝑗

\`\`\`  
−∞ otherwise (1)  
\`\`\`  
\`\`\`  
The visible matrix comprises elements of 0 and−∞, where𝑡𝑖and𝑡𝑗represent token elements in  
the token embedding after the sentence tree is transformed, and𝑖and𝑗are their respective indices  
in the token embedding.𝑡𝑖⊕𝑡𝑗indicates that𝑡𝑖and𝑡𝑗are either in the original input sequence or  
belong to the same relation branch of the sentence tree, meaning they are members of the same  
triple. Figure 3 illustrates the structure of the visible matrix in detail, as gray numbers represent  
the true positions of tokens in the token embedding. The blue nodes indicate that the two tokens  
are visible in the visible matrix, and their value is 0, while the white nodes indicate that the two  
tokens are invisible, and their value is−∞.  
\`\`\`  
3.4.2 Mask Transformer.The traditional Transformer architecture cannot use a visible matrix as  
input, nor can it selectively limit the attention range of each input token. To address this limitation,  
we propose a mask self-attention mechanism called mask Transformer. The mask Transformer  
comprises N mask self-attention layers stacked on top of each other. We use a multi-head mask  
attention layer based on the mask self-attention mechanism to compute the attention mechanism.  
The formula for the mask self-attention mechanism is shown in Equation 2\.  
In the equation,𝐻𝑖represents the hidden state of each layer. When𝑖= 0 ,𝐻 0 is the input  
embedding of the model.𝑊𝑞,𝑊𝑘, and𝑊𝑣are learnable parameters of the model, and𝑀is the  
visible matrix. The equation calculates the query vector𝑄𝑖, key vector𝐾𝑖, and value vector𝑉𝑖  
corresponding to the input𝐻𝑖. Then, it calculates the attention score𝐴𝑖using the query vector  
𝑄𝑖and key vector𝐾𝑖, where𝑑𝑘represents the dimension of the hidden vector of the model. After  
that, the attention score𝐴𝑖is added to the visible matrix𝑀, and the SoftMax function is applied  
to obtain the attention distribution𝑆𝑖. Finally, the attention mechanism output is calculated by  
multiplying the attention distribution𝑆𝑖with the value vector𝑉𝑖.

\`\`\`  
FSE086:10 Yue Li, Bohan Liu, Ting Zhang, Zhiqi Wang, David Lo, Lanxin Yang, Jun Lyu, and He Zhang  
\`\`\`  
\#\#\#\# 𝑄𝑖=𝐻𝑖×𝑊𝑞

\#\#\#\# 𝐾𝑖=𝐻𝑖×𝑊𝑘

\#\#\#\# 𝑉𝑖=𝐻𝑖×𝑊𝑣

\#\#\#\# 𝐴𝑖=

\#\#\#\# 𝑄𝑖𝐾𝑖⊤

\#\#\#\# √

\#\#\#\# 𝑑𝑘

\#\#\#\# 𝑆𝑜𝑓𝑡𝑀𝑎𝑥(𝑥)=

\#\#\#\# 𝑒𝑥

\#\#\#\# Í𝑛

\#\#\#\# 𝑗= 1 𝑒

\`\`\`  
𝑥𝑗  
\`\`\`  
\`\`\`  
𝑆𝑖=SoftMax  
\`\`\`  
\#\#\#\# 

\#\#\#\# 𝐴𝑖+𝑀

\#\#\#\#

\#\#\#\# 𝐻𝑖+^1 \=𝑆𝑖×𝑉𝑖

\#\#\#\# (2)

In the self-attention mechanism,𝐴𝑖𝑗represents a matrix where𝐴𝑖∈𝐴𝑖signifies the attention  
score between the𝑗th and𝑘th tokens in the input embedding. When tokens𝑖and𝑗are not visible,  
𝑀𝑗𝑘=−∞, thus𝑀𝑗𝑘+𝐴𝑖𝑗=−∞. Consequently,SoftMax(𝐴𝑖𝑗+𝑀𝑗𝑘)= 0 , ensuring that the attention  
distribution𝑆𝑖does not allow token𝑗to influence the hidden state of token𝑖, thereby restricting  
attention between different tokens. Under the masked self-attention mechanism, newly introduced  
triple information does not directly affect the hidden state of the \[CLS\] token but serves as a  
bridge through the original input sequence’s triple head entity. As illustrated in Figure 3,is-a  
is a token in the knowledge triple, and it is invisible toconditionimplies no impact ofℎ𝑖− 1 on  
ℎ𝑖. However,hasand the head entityrewriterin the triple is visible, allowingℎ𝑖− 1 to influence  
ℎ𝑖. Similarly,is-ais visible toinstance, enablingℎ𝑖+ 1 to indirectly acquire information from  
ℎ𝑖− 1\. This approach maximizes the utilization of triple information to enhance the representation  
of entities in the original input sequence, introducing knowledge information to improve the  
representation capability of the original input.

\`\`\`  
3.4.3 Pre-training Model.We use the UniXcoder \[ 10 \] due to its superior performance on various  
code understanding and generation tasks to learn the word distribution between bug reports  
and buggy codes. UniXcoder demonstrates adaptability to various tasks. Its performance in code  
understanding tasks, such as code search, is superior to other LLMs such as GPT-2 \[ 10 \]. The model  
uses mask attention matrixes with prefix adapters to control its behavior and leverages cross-modal  
content, including AST and code annotations, to enhance its code representation.  
We conduct pre-training ofKeptusing a large code search corpus to improve its reasoning  
ability for the relationship between textual data and code snippets. This task involves matching  
code with text, aligned with the bug localization objective to increase the accuracy of matching  
bug reports with code snippets. CodeSearchNet serves as the training data set for code search  
training, which uses the same model architecture as bug localization training. The data set consists  
of millions of code snippets and text on GitHub, with the Java language part containing 503,  
text-code pairs.  
\`\`\`  
\`\`\`  
3.4.4 Fine-tuning Model.After pre-training, we fine-tuneKeptto ensure it is effective at im-  
plementing downstream tasks and to maximize the utilization of the knowledge graph. During  
the fine-tuning process, we employ the⟨𝑅,𝐶,𝐿⟩as input ofKept, where𝑅represents the bug  
report,𝐶represents the buggy code related or unrelated to the bug report, and𝐿is the label of  
the relationship between them. Contrastive learning is used to reduce the distance between bug  
reports and buggy changesets and to increase the distance between bug reports and non-buggy  
changesets. If𝑅is related to𝐶, then𝐿= 1 ; otherwise,𝐿= 0\. In contrastive learning, the online  
negative sampling method proposed by Lin et al. \[23\] is used to select negative samples.  
\`\`\`

\`\`\`  
A Knowledge Enhanced Large Language Model for Bug Localization FSE086:  
\`\`\`  
\`\`\`  
3.5 Bug Localization  
\`\`\`  
We use historical bug reports and code files (i.e., data in the training set) to train our models for  
new bug reports. The learned semantic features are input into a fully connected layer for bug  
localization. As the model is trained iteratively, the loss function is monitored and the weights of  
semantic features are optimized over several epochs.  
After receiving a new bug report,Keptprocesses the new bug report and all historical change-  
sets, creating separate hidden state matrices for them. The hidden state matrices are pooled and  
concatenated to generate joint feature vectors for the new bug report and changesets. Then, the  
joint feature vectors are fed into a classifier, which predicts a two-dimensional vector(𝑚,𝑛), where  
𝑚represents the unrelated score, and𝑛represents the related score. Finally, suspicious changesets  
related to the new bug report are localized based on the scores of the two-dimensional vector.

\`\`\`  
4 Experimental Evaluation  
In this section, we present the research questions, the studied dataset, the baselines, and the  
evaluation metrics. The dataset and the source code are available online^4.  
\`\`\`  
\`\`\`  
4.1 Research Questions  
\`\`\`  
We first compare our model with the state-of-the-art bug localization techniques in our experiments  
to evaluate its effectiveness (RQ1). Afterward, we implement an ablation experiment to evaluate  
the impact of introducing knowledge graphs on the LLM for bug localization (RQ2). Finally, we  
conduct another ablation experiment to evaluate the impact of soft-position embedding and visible  
matrices on three LLMs (RQ3).

\- RQ1:How effective isKeptcompared to the state-of-the-art models for bug localization?  
\- RQ2:How do knowledge graphs impact the effectiveness ofKept?  
\- RQ3:How do soft-position embedding and visible matrices impact the accuracy of LLMs in  
    bug localization?

4.1.1 RQ1: Effectiveness ofKept.In recent years, graph-related techniques have been used to  
incorporate structural information contained in code into LLMs. These LLMs based on code  
structure graphs have demonstrated reasonable performance improvements in software engineering.  
However, previous research on LLMs often overlooks the interrelated information within the code  
and fails to integrate domain knowledge to address the bug localization problem. In this paper, we  
propose an approach to locating bugs that leverages a knowledge-enhanced LLM to incorporate  
domain knowledge and interrelated code information. To validate our proposed model, we compare  
it to five advanced and representative baseline models.  
Experimental Settings:The five collected baselines are Locus \[ 47 \], GPT-2 \[ 32 \], GraphCode-  
BERT \[ 11 \], CodeT5 \[ 46 \], andtext-embedding-ada-002. Locus is a traditional IR-based method for  
locating bugs based on changesets \[ 47 \]. GPT-2, GraphCodeBERT, and CodeT5 are advanced LLMs.  
We use the Locus implemented by Bench4BL \[ 19 \] to conduct experiments.text-embedding-ada-  
represents the state-of-the-art commercial text embedding model \[ 20 \]. To ensure fairness in our  
experiment, we used the open-source models and parameters reported in their papers for GPT-2,  
CodeT5, GraphCodeBERT, andtext-embedding-ada-002. In addition, we performed the fine-tuning  
of the baseline for all large language models to ensure fairness. To implement ourKeptmodel,  
we mainly use two Python libraries,i.e., Transformers \[ 48 \] and PyTorch \[ 30 \]. Since the impact of  
time on the training and testing set, we adopted the strategy proposed by Lin et al. \[23\]to build  
the training and testing datasets. We used 50% of bug reports and buggy code in projects as the

(^4) The source dataset and source code for this study are available online at https://github.com/keptmodel/KEPT

\`\`\`  
FSE086:12 Yue Li, Bohan Liu, Ting Zhang, Zhiqi Wang, David Lo, Lanxin Yang, Jun Lyu, and He Zhang  
Table 1\. Details of the OSS projects  
\`\`\`  
\`\`\`  
Commits Files Hunks Relation Entity Relation Entity  
Teiid 2004-04-27\~2017-04-03 1297 2291 1637 8843 21295 96985 212882 1748 8208  
Hornetq2006-05-17\~2015-03-31 270 1618 327 1439 3826 63253 137068 500 1794  
Seam22005-09-11\~2014-03-16 776 1510 881 2172 4222 17076 35473 719 3149  
Weld 2009-02-07\~2017-03-24 560 2515 704 3668 6101 21910 40701 353 1171  
Drools2006-03-10\~2017-03-30 1281 2231 1649 8091 24526 73081 155280 1021 3993  
Derby 2004-09-28\~2016-11-27 1778 2408 2590 11435 26485 111960 243542 964 3764  
Log4j22011-09-16\~2017-03-12 441 920 735 3516 6886 18853 37527 475 1523  
Total \- 6403 13493 8523 39164 93341 403118 862473 5780 23602  
\`\`\`  
\`\`\`  
Project Time Span \#Bug Report\#Code Files \#Changesets Code knowledge graphText knowledge graph  
\`\`\`  
training set and the other 50% as the testing set. To prevent data leakage, we only used project  
documents and code available up to the end of the training set as data sources for constructing  
the knowledge graph. To address the RQs posed in this paper, experiments were conducted on a  
server equipped with two NVIDIA A100 Tensor Core GPUs. To construct the LLMs, two Python  
libraries were primarily utilized: Transformers V4.36.2 and PyTorch V1.11.0. During training, the  
PyTorch library provides computational support for Transformer-based model architectures, while  
the Transformers library provides an API for accessing Transformer-based model architectures.  
Regarding the configuration parameters of the model, the number of layers in the masked self-  
attention layer and the number of heads in the multi-head attention mechanism were denoted as L  
and A, respectively. Furthermore, the hidden dimension of the embedding vectors was represented  
by H. The parameters of the model were configured as follows: L \= 12, A \= 12, H \= 768\.  
4.1.2 RQ2: Effectiveness of Knowledge Graph.In this study, we use project documents to construct  
the text knowledge graph. The knowledge graph contains domain-specific information about  
the projects, which has the potential to enhance the LLM’s memorization and reasoning abilities  
for bug reports. In addition, we use project source code to build the code knowledge graph. The  
code knowledge graph represents the interrelated information of the code, offering potential  
enhancements to LLMs’ memorization and reasoning abilities for source code. We conduct an  
ablation experiment to study the effectiveness of knowledge graphs on the model performance.  
Experimental Settings:To answer RQ2, we establish four scenarios: no knowledge graphs, only  
text knowledge graphs, only code knowledge graphs, and both text and code knowledge graphs.  
Similar to RQ1, we use the first 50% of bug reports and buggy code from projects as a training set,  
while the remaining 50% served as a testing set.

\`\`\`  
4.1.3 RQ3: Effectiveness of Soft-Position Embedding and Visible Matrix.To effectively represent the  
information extracted from knowledge graphs, we propose a structure using soft-position embed-  
ding and visible matrix. We use the structure to convert the sentence tree into the token embedding  
and position embedding of the mask encoder, while retaining the structural characteristics of the  
sentence tree. To validate the impact of the proposed model structure on the models, we conduct an  
ablation experiment to evaluate the effect of this model structure on three LLMs in bug localization.  
Experimental Settings:To answer RQ3, we conduct an ablation experiment with three LLMs:  
BERT, CodeBERT, and UniXcoder. All three models adopt an encoder structure. We evaluate the  
impact of the proposed model structure on bug localization by incorporating the proposed structure  
into these models and comparing them with the original LLMs. The experimental data and model  
settings are consistent with those of RQ1.  
\`\`\`  
\`\`\`  
4.2 Dataset  
4.2.1 Datasets for bug localization.To address the RQs, we utilized the bug localization dataset  
collected and validated by Rath et al \[ 33 \]. We reuse seven of the 15 OSS projects from their dataset.  
For the remaining eight projects, the source code repository or the project documents could not  
be accessed. We exclude these eight projects from the dataset to ensure a fair comparison. The  
\`\`\`

\`\`\`  
A Knowledge Enhanced Large Language Model for Bug Localization FSE086:  
Table 2\. The number of entities in the code knowledge graph  
\`\`\`  
\`\`\`  
ClassInterfacePropertyMethodParameterVariableContainMemberVariableContainParameterContain InheritanceInstantiationInvocationReturnType Implementation  
Teiid 5123 521 9434 26560 17369 37978 34919 37978 17369 1111 60337 35461 25076 631  
Hornetq 3095 479 6418 16859 10615 25787 22844 25787 10615 1008 42352 17362 16409 691  
Seam2 1571 142 1938 5998 4120 3307 7354 3307 4120 327 9311 5422 5397 235  
Weld 4089 371 2849 7208 4350 3043 9668 3043 4350 525 9867 5802 6748 698  
Drools 4285 401 10914 18926 14260 24295 29321 24295 14260 1236 46965 19740 18194 1269  
Derby 3112 257 15786 27417 30307 35081 42821 35081 30307 1353 77548 28947 26802 683  
Log4j2 1748 473 2637 5038 3486 5471 7125 5471 3486 334 10598 5948 4344 221  
Total 230232644 49976108006 84507 134962 154052134962 84507 5894 256978 118682 102970 4428  
\`\`\`  
\`\`\`  
Project  
\`\`\`  
\`\`\`  
Entity Relation  
\`\`\`  
dataset includes both bug reports and the corresponding changesets submitted to resolve them.  
We collect project documents such as version control documents from these projects to construct  
the knowledge graph. We also collect commit logs and source code from all Git repositories of  
the seven projects for constructing the code knowledge graph. As shown in Table 1, we provide  
detailed information about the seven projects. A total of more than 6,000 bug reports are used to  
evaluate the effectiveness of our model. To explore the granular impact of different changesets, we  
further split the changesets into commit-level, file-level, and hunk-level code changes. As a result,  
we evaluate changesets at three different levels of granularity: commits, files, and hunks.

\`\`\`  
4.2.2 Datasets for knowledge graphs.Based on the methods described in Section 3.3, this paper  
constructs corresponding code knowledge graphs and text knowledge graphs for each project  
in the bug localization dataset. To ensure fairness in the bug localization experiments and avoid  
introducing future knowledge during the construction of the knowledge graphs, we select the code  
repository and project documents before the bug report appears as the data source for constructing  
the knowledge graph. Specifically, we select the creation time of the bug report at 50% (i.e., the  
training set) as the reference time point for constructing knowledge graphs. Then we select the  
software code repository and project documents of the projects that existed before the reference  
time point as the original data for constructing knowledge graphs.  
For the construction of the code knowledge graph, the “Master” and “Main” branches from the  
official code repositories were used as the primary data sources. The code files extracted for the  
knowledge graph included the main systems, subsystems, and test cases for each project. The  
resulting code knowledge graph encompasses 403,118 code entities and 862,473 code relationships.  
The statistical details of the code knowledge graphs for different projects are provided in Table 2\.  
To ensure the accuracy of the text knowledge graphs, project documents from the official websites  
of each project are used. These documents included user manuals, developer guides, technical design  
documents, and API references. The constructed text knowledge graph contains 5,780 knowledge  
entities and 20,604 corresponding relationships. An overview of the text knowledge graphs for  
different projects is shown in Table 1\.  
\`\`\`  
4.3 Baselines  
To evaluate the performance of the proposed knowledge-enhanced LLM in bug localization, we  
selected a traditional IR-based model, Locus, as the baseline. In addition, we included advanced  
LLMs as the baselines, such as GPT-2, CodeT5, and GraphCodeBERT. Finally, we selected one of  
the most advanced commercial models developed by OpenAI, calledtext-embedding-ada-002, as  
another baseline.  
Locus\[ 47 \]: Locus is a traditional text similarity-based bug localization approach. Based on the  
VSM model, it locates suspicious code snippets at a more granular level of bug localization by using  
similarity scores between bug reports and changesets.  
GPT-2\[ 32 \]: GPT-2 is a large-scale language model based on the Transformer architecture  
developed by OpenAI. It uses self-attention mechanisms to capture long-range dependencies in text

FSE086:14 Yue Li, Bohan Liu, Ting Zhang, Zhiqi Wang, David Lo, Lanxin Yang, Jun Lyu, and He Zhang

data. GPT-2 can be adapted to a wide range of downstream tasks through fine-tuning. Based on the  
vast WebText dataset of 8 million web pages totaling 40GB, GPT-2 shows remarkable performance.  
Based on the vast WebText dataset of 8 million web pages totaling 40GB, GPT-2 shows remarkable  
performance.  
GraphCodeBERT\[ 11 \]: GraphCodeBERT is a natural language processing model that is specifi-  
cally designed for a variety of code-related tasks. The technique builds on BERT and incorporates  
structures to understand programming language. GraphCodeBERT can effectively handle the inter-  
action between source code and natural language by combining the grammatical structure of the  
code and natural language description. It leverages graph structures, constructing AST and data  
flow graphs to capture information about code structure.  
CodeT5\[ 46 \]: CodeT5 is a pre-trained encoder-decoder Transformer model that leverages the  
code semantics conveyed from developer-assigned identifiers. It is based on the T5 architecture  
and has been pre-trained on data sets from a wide range of programming languages. CodeT5 uses  
a novel identifier-aware pre-training target that is able to capture information about the code  
structure and key tag types from the code. In this way, it comprehends programming language  
semantics well and can be applied to various downstream tasks. We evaluated the effectiveness  
of multiple baseline models, including both CodeT5 and CodeT5+, on our specific datasets. The  
experimental results indicate that CodeT5 consistently outperforms CodeT5+ on all evaluation  
metrics. Given these findings, we chose CodeT5 as the baseline instead of CodeT5+ to ensure that  
our evaluation reflects the most effective model for bug localization.  
text-embedding-ada-002\[ 29 \]:text-embedding-ada-002is an advanced neural embedding model  
developed by OpenAI, designed for text representation and similarity tasks \[ 54 \]. The model gener-  
ates dense vector representations of textual inputs using a transformer-based architecture, enabling  
efficient natural language processing (NLP).text-embedding-ada-002exhibits state-of-the-art perfor-  
mance across various embedding benchmarks, demonstrating robustness in tasks such as semantic  
search, clustering, recommendation systems, and knowledge retrieval.

4.4 Evaluation Metrics

To evaluate the performance of the model, we use the following metrics that are widely used in  
bug localization:i.e.,𝑀𝑅𝑅(Mean Reciprocal Rank),𝑀𝐴𝑃(Mean Average Precision), and𝑇𝑜𝑝@𝑁.  
MRR (Mean Reciprocal Rank)measures a process that produces a list of possible responses to  
a query. The reciprocal rank of a query response is equal to the multiplicative inverse of the rank  
of the first correct answer. The mean reciprocal rank is the average of the reciprocal ranks of the  
results for a sample of queries𝑄:

\#\#\#\# 𝑀𝑅𝑅=

\#\#\#\# 1

\#\#\#\# |𝑄|

\#\#\#\# ∑︁|𝑄|

\`\`\`  
𝑖= 1  
\`\`\`  
\#\#\#\# 1

\#\#\#\# 𝑟𝑎𝑛𝑘𝑖

\#\#\#\# (3)

MAP (Mean Average Precision)measures a single-figure quality of IR when a query may  
contain multiple relevant files. The AvgP (Average Precision of a single query) is calculated as the  
average of the precision values obtained for a single query, as follows:

\`\`\`  
Avg𝑃𝑖=  
\`\`\`  
\#\#\#\# ∑︁𝑀

\`\`\`  
𝑖= 1  
\`\`\`  
\`\`\`  
𝑃(𝑖)×pos(𝑖)  
number of positive instances  
\`\`\`  
\#\#\#\# (4)

Where𝑖represents the rank,𝑀represents the number of instances retrieved,𝑃(𝑖)is defined as  
the precision at the given cut-off rank𝑖, and𝑝𝑜𝑠(𝑖)indicates the relevance of the instance.

A Knowledge Enhanced Large Language Model for Bug Localization FSE086:

\`\`\`  
Table 3\. Comparison ofKeptwith baselines for bug localization.  
\`\`\`  
\`\`\`  
MRR MAP Top@1Top@3Top@5 MRR MAP Top@1Top@3Top@5 MRR MAPTop@1Top@3Top@  
GPT-2Locus 0.3940.277 0.3710.257 0.300 0.183 0.4390.297 0.5150.364 0.3890.267 0.2260.157 0.2970.183 0.4330.286 0.5050.353 0.3870.261 0.1970.133 0.2960.181 0.4310.279 0.5010.  
GraphCodeBERTCodeT5 0.2870.326 0.2700.305 0.1720.209 0.3170.376 0.4010.444 0.2790.315 0.1690.190 0.1780.206 0.3080.367 0.3890.426 0.2710.312 0.1430.159 0.1690.207 0.3050.365 0.3760.  
text-embedding-ada-002KEPT 0.380 0.422 0.359 0.401 0.2740.297 0.420 0.485 0.491 0.565 0.371 0.414 0.223 0.261 0.274 0.299 0.409 0.472 0.472 0.540 0.368 0.409 0.184 0.218 0.274 0.297 0.407 0.467 0.460 0\.  
Locus 0.359 0.333 0.287 0.435 0.443 0.356 0.194 0.287 0.426 0.443 0.353 0.169 0.287 0.417 0\.  
GraphCodeBERTGPT-2 0.3740.351 0.3450.335 0.2610.243 0.3910.365 0.4700.478 0.3530.331 0.2280.222 0.2610.243 0.3740.322 0.4260.461 0.3480.321 0.1810.187 0.2610.243 0.3740.313 0.4000.  
text-embedding-ada-002CodeT5 0.3610.561 0.3430.527 0.2350.452 0.400 0.617 0.504 0.670 0.334 0.549 0.2300.366 0.2350.452 0.365 0.600 0.417 0.652 0.326 0.546 0.1880.286 0.2350.452 0.357 0.591 0.409 0\.  
KEPT 0.567 0.535 0.470 0.591 0.670 0.548 0.399 0.470 0.583 0.609 0.544 0.324 0.470 0.583 0\.  
GPT-2Locus 0.4070.339 0.3890.326 0.3390.233 0.4530.374 0.4820.450 0.4000.328 0.3260.260 0.3330.233 0.4420.360 0.4720.425 0.3960.321 0.2930.218 0.3330.233 0.4420.352 0.4690.  
GraphCodeBERTCodeT5 0.2660.356 0.2510.340 0.1570.236 0.3060.393 0.3630.482 0.2530.340 0.2000.277 0.1570.236 0.2870.369 0.3360.450 0.2460.333 0.1670.233 0.1570.236 0.2740.363 0.3330.  
text-embedding-ada-002KEPT 0.492 0.538 0.474 0.520 0.377 0.434 0.550 0.577 0.640 0.664 0.482 0.531 0.395 0.448 0.377 0.436 0.534 0.572 0.607 0.645 0.478 0.522 0.339 0.388 0.377 0.431 0.528 0.564 0.588 0\.  
GPT-2Locus 0.2930.304 0.2610.277 0.1950.187 0.3460.342 0.4010.405 0.2990.288 0.1280.169 0.2100.187 0.3390.311 0.3890.385 0.2940.283 0.1230.141 0.2100.187 0.3390.307 0.3850.  
GraphCodeBERTCodeT5 0.2800.307 0.2540.277 0.1790.198 0.3070.323 0.3620.405 0.2620.286 0.1720.186 0.1790.198 0.2720.296 0.3460.350 0.2580.280 0.1490.155 0.1790.198 0.2650.288 0.3390.  
text-embedding-ada-002KEPT 0.445 0.456 0.400 0.421 0.331 0.327 0.502 0.510 0.576 0.603 0.432 0.439 0.265 0.284 0.331 0.327 0.482 0.494 0.5530.553 0.429 0.432 0.222 0.250 0.331 0.327 0.482 0.475 0.549 0\.  
GPT-2Locus 0.1630.166 0.1510.152 0.1230.085 0.1860.164 0.2080.231 0.1580.155 0.0850.084 0.1210.085 0.1810.156 0.2010.219 0.1530.150 0.0730.065 0.1210.085 0.1660.153 0.1930.  
GraphCodeBERTCodeT5 0.1870.223 0.1730.209 0.1010.123 0.1840.248 0.2620.321 0.1750.212 0.0960.116 0.1030.123 0.1690.231 0.2310.304 0.1690.206 0.0740.088 0.1010.121 0.1630.226 0.2260.  
text-embedding-ada-002KEPT 0.301 0.339 0.283 0.318 0.196 0.221 0.321 0.382 0.414 0.462 0.290 0.328 0.153 0.176 0.196 0.221 0.314 0.365 0.380 0.435 0.281 0.322 0.115 0.134 0.196 0.221 0.299 0.359 0.367 0\.  
GPT-2Locus 0.3700.291 0.3340.258 0.2870.194 0.4120.311 0.4630.386 0.3650.280 0.2290.177 0.2930.195 0.3950.298 0.4440.362 0.3600.273 0.1850.133 0.2960.195 0.3790.289 0.4300.  
GraphCodeBERTCodeT5 0.2290.320 0.2070.289 0.1230.230 0.2570.345 0.3350.406 0.2120.307 0.1400.201 0.1170.230 0.2380.331 0.3180.381 0.2080.301 0.1070.156 0.1230.229 0.2230.321 0.2990.  
text-embedding-ada-002 0.336 0.304 0.234 0.381 0.441 0.327 0.210 0.234 0.371 0.417 0.319 0.156 0.234 0.355 0\.  
KEPT 0.427 0.388 0.310 0.487 0.565 0.419 0.280 0.313 0.470 0.543 0.412 0.218 0.311 0.464 0\.  
GPT-2Locus 0.4370.408 0.3710.352 0.3360.282 0.4820.468 0.5730.550 0.4390.397 0.2070.239 0.3550.277 0.4730.464 0.5500.536 0.4370.388 0.2060.210 0.3590.277 0.4680.450 0.5360.  
GraphCodeBERTCodeT5 0.4010.454 0.3520.399 0.2640.323 0.4550.527 0.5730.595 0.3870.439 0.2390.271 0.2640.323 0.4410.495 0.5270.559 0.3810.434 0.2090.245 0.2640.323 0.4410.495 0.5180.  
text-embedding-ada-002KEPT 0.567 0.600 0.488 0.517 0.450 0.477 0.627 0.686 0.723 0.782 0.561 0.588 0.321 0.375 0.450 0.473 0.618 0.664 0.691 0.741 0.554 0.583 0.290 0.338 0.450 0.477 0.600 0.636 0.677 0\.  
GPT-2Locus 0.3460.308 0.3160.281 0.2670.204 0.3930.335 0.4410.408 0.3440.295 0.1990.188 0.2710.203 0.3840.321 0.4290.387 0.3400.289 0.1780.154 0.2720.203 0.3780.315 0.4200.  
GraphCodeBERTCodeT5 0.2860.335 0.2630.309 0.1770.222 0.3130.373 0.3960.451 0.2710.319 0.1770.210 0.1770.222 0.2910.351 0.3730.412 0.2650.313 0.1480.175 0.1770.221 0.2830.345 0.3560.  
text-embedding-ada-002 0.440 0.405 0.331 0.488 0.565 0.430 0.276 0.331 0.475 0.539 0.425 0.227 0.331 0.466 0\.  
KEPT 0.478 0.443 0.362 0.531 0.616 0.467 0.318 0.363 0.517 0.581 0.461 0.267 0.362 0.507 0\.  
\`\`\`  
\`\`\`  
Average  
\`\`\`  
\`\`\`  
Log4j  
\`\`\`  
\`\`\`  
Teiid  
\`\`\`  
\`\`\`  
Hornetq  
\`\`\`  
\`\`\`  
Seam  
\`\`\`  
\`\`\`  
Weld  
\`\`\`  
\`\`\`  
Drools  
\`\`\`  
\`\`\`  
Derby  
\`\`\`  
\`\`\`  
Project Technique Commits Files Hunks  
\`\`\`  
(^1) The higher the value of the MAP, MRR, and Top@N, the better.

\#\#\#\# 𝑀𝐴𝑃=

\#\#\#\# 1

\#\#\#\# |𝑄|

\#\#\#\# ∑︁|𝑄|

\`\`\`  
𝑖= 1  
\`\`\`  
\#\#\#\# 𝐴𝑣𝑔𝑃𝑄𝑖 (5)

Top@Nmeasures the percentage of bugs whose associated files are detected in top N (𝑁=1,2,3,...)  
of the returned suspicious list of code files. The higher values indicate less effort required by  
developers to locate the bug and, thus, better performance.  
In terms of𝑀𝐴𝑃,𝑀𝑅𝑅, and𝑇𝑜𝑝@𝑁, a higher value is better.

5 Results

5.1 Effectiveness ofKept(RQ1)

Table 3 presents the evaluation results for the effectiveness ofKept, with the best results highlighted  
in bold. The evaluation results indicate thatKeptachieves almost all the best results for five  
metrics at three levels of changesets. Taking the commit-level as an example,Keptshows the best  
performance on average across five metrics, achieving a 35.0% to 40.3% improvement over Locus. In  
comparison with CodeT5, the highest-performing non-commercial LLM,Keptachieves an average  
improvement of 36.6% to 63.1%. Compared with commercial LLM,text-embedding-ada-002,Kept  
achieves an average improvement of 7.8% to 17.4%.  
The results of our approach show significant improvements over all the baselines at three levels  
of granularity. In Table 3, all LLMs achieve better results at the coarser-grained commits level  
compared to the finer-grained hunks level. For instance, CodeT5 achieved an MRR of 0.335 at the  
commits level, 0.319 at the files level, and 0.313 at the hunks level. Notably,Keptexhibits a more  
substantial improvement at the finer-grained levels. Using MRR as an indicator,Keptoutperformed  
CodeT5 by 42.56% at the commits level, 46.30% at the files level, and 47.09% at the hunks level. We

\`\`\`  
FSE086:16 Yue Li, Bohan Liu, Ting Zhang, Zhiqi Wang, David Lo, Lanxin Yang, Jun Lyu, and He Zhang  
Table 4\. Comparison of the resultswithandwithoutintroducing knowledge graph.  
Approach Metric Teiid HornetqSeam2 Weld Drools Derby Log4j2 Average  
MRR 0.383 0.486 0.509 0.398 0.267 0.393 0.560 0\.  
MAP 0.209 0.305 0.382 0.243 0.118 0.205 0.330 0\.  
Top@1 0.282 0.400 0.417 0.288 0.184 0.297 0.450 0\.  
Top@3 0.427 0.539 0.550 0.463 0.284 0.437 0.623 0\.  
Top@5 0.491 0.600 0.626 0.510 0.349 0.490 0.691 0\.  
MRR 0.395 0.481 0.518 0.406 0.256 0.400 0.585 0\.  
MAP 0.212 0.305 0.388 0.252 0.111 0.213 0.335 0\.  
Top@1 0.291 0.383 0.431 0.300 0.159 0.301 0.482 0\.  
Top@3 0.441 0.530 0.566 0.436 0.291 0.443 0.645 0\.  
Top@5 0.517 0.583 0.615 0.498 0.350 0.504 0.709 0\.  
MRR 0.391 0.508 0.532 0.401 0.294 0.403 0.578 0\.  
MAP 0.209 0.297 0.389 0.243 0.126 0.213 0.332 0\.  
Top@1 0.285 0.409 0.444 0.296 0.203 0.305 0.477 0\.  
Top@3 0.437 0.557 0.569 0.440 0.314 0.454 0.636 0\.  
Top@5 0.509 0.609 0.623 0.502 0.382 0.506 0.686 0\.  
MRR 0.409 0.544 0.522 0.432 0.322 0.412 0.583 0\.  
MAP 0.218 0.324 0.388 0.250 0.134 0.218 0.338 0\.  
Top@1 0.297 0.470 0.431 0.327 0.221 0.311 0.477 0\.  
Top@3 0.467 0.583 0.564 0.475 0.359 0.464 0.636 0\.  
Top@5 0.531 0.609 0.618 0.533 0.422 0.525 0.732 0\.  
\`\`\`  
\`\`\`  
NoKG  
\`\`\`  
\`\`\`  
TextKG  
\`\`\`  
\`\`\`  
CodeKG  
\`\`\`  
\`\`\`  
TextKG+  
CodeKG  
\`\`\`  
attribute this enhanced performance to the incorporation of a knowledge graph, which allows the  
model to reason more effectively, especially at the hunks level where the context is often lacking.  
To further validate the evaluation results, we use the Wilcoxon signed-rank test on the five  
metrics. The Wilcoxon signed-rank test is a non-parametric hypothesis test used for determining  
whether results are significantly different between groups, which is used in bug localization \[ 3 \] and  
other fields \[ 21 \]. A𝑝-𝑣𝑎𝑙𝑢𝑒result less than 0.05 indicates a statistically significant difference between  
Keptand the baselines with 95% confidence. According to the test results,Keptoutperforms Locus,  
GPT-2, GraphCodeBERT, CodeT5, andtext-embedding-ada-002on average across all metrics at  
three granularities, showing statistically significant differences with 95% confidence.  
For fine-tuning,Keptrequired 355 minutes, making it the fastest approach among all the  
LLMs evaluated. GPT-2 followed closely, taking 364 minutes. CodeT5 requires 468 minutes, while  
GraphCodeBERT requires 479 minutes.  
Overall,Keptachieves average improvements on the five metrics by 33.2% to 59.5% under three  
levels of changesets when compared with the classical method, Locus. Compared to the best LLM,  
CodeT5,Keptachieved average improvements of 36.6% to 63.7%. The Wilcoxon signed-rank test  
indicated thatKeptis statistically significant compared to all the baselines on average across all  
metrics at 95% confidence. The results indicate that our method,Kept, is more effective in capturing  
the semantics of code and text, making the proposed approach advantageous for bug localization.

\`\`\`  
Answer to RQ1:Keptoutperforms the state-of-the-art models for bug localization, especially  
achieving 7.8% to 78.6% better results on average across five metrics with a statistically significant  
difference with a 95% confidence level.  
\`\`\`  
\`\`\`  
5.2 Effectiveness of Knowledge Graph (RQ2)  
To evaluate the impact of knowledge graphs on model performance, we conduct ablation experi-  
ments at three granularity of changesets. Table 4 presents the evaluation results for the effectiveness  
of the knowledge graph.  
Taking the commit-level results as an example, the best performance is obtained by introducing  
both the code knowledge graph and the text knowledge graph (TextKG+CodeKG). TextKG+CodeKG  
achieves the best results on average, with MRR at 0.461, MAP at 0.267, Top@1 at 0.362, Top@  
at 0.507, and Top@5 at 0.567, respectively. Compared to scenarios without knowledge graph,  
TextKG+CodeKG achieved an average performance improvement of 6.70%, 6.24%, 9.37%, 4.93%, and  
4.44% across MRR, MAP, Top@1, Top@3, and Top@5, respectively.  
\`\`\`

\`\`\`  
A Knowledge Enhanced Large Language Model for Bug Localization FSE086:  
Table 5\. Comparison of the resultswithandwithoutsoft-position embedding and visible matrix.  
\`\`\`  
\`\`\`  
Approach Metric Teiid HornetqSeam2 Weld Drools Derby Log4j2Average  
MRR 0.124 0.169 0.173 0.190 0.097 0.137 0.240 0\.  
Top@1MAP 0.0610.060 0.1000.087 0.1030.092 0.100 0.117 0.0420.047 0.0620.073 0.1200.145 0.0840.  
Top@3 0.132 0.209 0.195 0.198 0.098 0.149 0.268 0\.  
Top@5 0.166 0.261 0.236 0.249 0.128 0.193 0.345 0\.  
MRR 0.292 0.398 0.386 0.307 0.228 0.260 0.457 0\.  
MAP 0.148 0.233 0.284 0.177 0.097 0.143 0.261 0\.  
Top@1 0.200 0.296 0.276 0.191 0.146 0.162 0.336 0\.  
Top@3 0.322 0.443 0.439 0.362 0.259 0.306 0.509 0\.  
Top@5 0.381 0.487 0.512 0.432 0.306 0.357 0.595 0\.  
MRR 0.383 0.486 0.509 0.398 0.267 0.393 0.560 0\.  
Top@1MAP 0.2090.282 0.3050.400 0.3820.417 0.2430.288 0.1180.184 0.2050.297 0.3300.450 0.2560.  
Top@3 0.427 0.539 0.550 0.463 0.284 0.437 0.623 0\.  
Top@5 0.491 0.600 0.626 0.510 0.349 0.490 0.691 0\.  
MRR 0.138 0.228 0.180 0.189 0.089 0.143 0.234 0\.  
MAP 0.069 0.118 0.111 0.102 0.037 0.064 0.120 0\.  
Top@1 0.074 0.165 0.119 0.109 0.040 0.080 0.159 0\.  
Top@3 0.133 0.217 0.176 0.218 0.081 0.151 0.245 0\.  
Top@5 0.184 0.304 0.228 0.265 0.115 0.194 0.314 0\.  
MRR 0.303 0.450 0.428 0.312 0.221 0.273 0.502 0\.  
MAP 0.155 0.241 0.307 0.180 0.100 0.144 0.277 0\.  
Top@1 0.204 0.383 0.331 0.206 0.136 0.171 0.395 0\.  
Top@3 0.339 0.470 0.472 0.350 0.241 0.314 0.568 0\.  
Top@5 0.412 0.522 0.534 0.412 0.304 0.384 0.632 0\.  
MRR 0.409 0.544 0.522 0.432 0.322 0.412 0.583 0\.  
Top@1MAP 0.2180.297 0.3240.470 0.3880.431 0.2500.327 0.1340.221 0.2180.311 0.3380.477 0.2670.  
Top@3 0.467 0.583 0.564 0.475 0.359 0.464 0.636 0\.  
Top@5 0.531 0.609 0.618 0.533 0.422 0.525 0.732 0\.  
\`\`\`  
\`\`\`  
KEPT-  
w/SPVM  
\`\`\`  
\`\`\`  
BERT-w/o  
\`\`\`  
\`\`\`  
CodeBERT-  
w/o  
\`\`\`  
\`\`\`  
KEPT-w/o  
\`\`\`  
\`\`\`  
BERT-  
w/SPVM  
\`\`\`  
\`\`\`  
CodeBERT-  
w/SPVM  
\`\`\`  
(^1) SPVM is an acronym for soft-position embedding and visible matrix.  
At the commit-level granularity, enhancing the LLM using the text knowledge graph alone  
(TextKG) and using the code knowledge graph alone (CodeKG) achieves better results than those  
without using the knowledge graph. In most cases, CodeKG performs better than TextKG, which  
might be attributed to the number of CodeKG additions in most projects greater than those of  
TextKG. A possible reason is that, compared to historical documentation, historical code repositories  
have constructed a more extensive knowledge graph. The code knowledge graph consists of 403,  
code entities and 862,473 code relationships, along with 5,780 knowledge entities and 20,  
corresponding relationships.  
Again, a Wilcoxon signed-rank test is performed on the results of the ablation experiments at three  
levels of changesets to verify their statistical significance. The results show that the differences are  
statistically significant with a𝑝-𝑣𝑎𝑙𝑢𝑒less than 0.05, indicating a significant improvement without  
introducing knowledge graphs.  
For fine-tuning, NoKG takes 291 minutes, TextKG takes 308 minutes, and CodeKG takes 328  
minutes. TextKG+CodeKG together require 355 minutes, which is only a 22% increase over NoKG.  
In general, the performance of the LLM enhanced by introducing the code knowledge graph  
and text knowledge graph has been improved by 4.3% to 9.5% when compared to the LLM without  
introducing a knowledge graph. With 95% confidence, the difference between the knowledge-  
enhanced LLM and the LLM without using a knowledge graph is statistically significant.  
Answer to RQ2:The modelKeptenhanced with knowledge graph performs better than the  
model without knowledge graph enhancement. With a 95% confidence level, there is a significant  
difference between introducing knowledge graphs and not introducing one.  
5.3 Effectiveness of Soft-Position Embedding and Visible Matrix (RQ3)  
To evaluate the impact of our proposed model structure, we selected two widely used encoder-  
structured models, BERT and CodeBERT, which have structures similar toKept.  
The evaluation results indicate that our proposed model structure, which uses Soft-Position  
embedding and Visible Matrices (SPVM) for representation, generally achieves better performance.

FSE086:18 Yue Li, Bohan Liu, Ting Zhang, Zhiqi Wang, David Lo, Lanxin Yang, Jun Lyu, and He Zhang

In comparison with BERT \-w/o, BERT \-w/SPVM achieved an average improvement of 8.3% to 18.9%.  
The evaluation results show that the model structure proposed in this paper achieves the best  
results for almost all projects. The results indicate that the bug localization technique proposed in  
this paper can be extended to be a general and effective structure for various advanced LLMs.

\`\`\`  
Answer to RQ3:Three LLMs (i.e., BERT, CodeBERT, KEPT) that use the model structure proposed  
in this study perform better than those that do not use it, demonstrating the effectiveness of this  
model structure.  
\`\`\`  
6 Threats to Validity

In this section, we discuss the potential threats to the validity of the study and our efforts to mitigate  
their impacts.  
Internal validity.We identify two threats to internal validity for this study. The first concern  
is that our experimental results depend on the knowledge graph construction tool we use. To  
mitigate this threat, we selected a popular tool that achieves the highest precision and recall \[ 7 , 24 \].  
The second threat to internal validity is potential errors in implementing our approach and the  
baselines. We mitigated this threat by using the original source code and hyperparameter settings  
that were shared by the baselines \[ 11 , 32 , 46 , 47 \]. In addition, we carefully check the datasets and  
source code used in this study to make sure they are correct.  
External validity.The threat to external validity of this study arises from the ability to generalize  
our research to the external.Keptis implemented and evaluated on seven OSS projects, and the  
performance ofKepton commercial projects is unknown. We selected seven projects that contained  
more than 6,000 bugs to possibly reduce this external validity. In addition, the main structure of  
Keptis based on UniXcoder, which is used in other fields.  
Construct validity.The construct validity of a study is derived from the metrics that we select,  
that is, making sure that the chosen metrics are compatible with the study’s approach and design  
to generate reliable results. As a result, we use widely used evaluation metrics in bug localization,  
such as MAP, MRR, and Top@N, in an effort to minimize this threat.

7 Related Work

IR techniques can significantly reduce the developer’s burden of debugging \[ 26 \] and maintain-  
ing software \[ 15 , 35 \], and it is one of the most widely researched techniques for automatic bug  
localization \[31, 53\]. While IR-based methods form a substantial part of bug localization research,  
alternative approaches have also been explored. One such line of research focuses on the coverage  
of failing and passing tests. A notable recent contribution in this area is Fonte, proposed by An et  
al. \[ 1 \]. Fonte is an efficient and accurate bug-inducing commit identification technique that uniquely  
relies solely on test coverage. It innovatively combines fault localization with bug-inducing commit  
identification to rank commits based on the suspiciousness of the code elements they modify. It is  
important to note that fault localization and IR-based methods are not mutually exclusive; in fact,  
they can complement each other effectively. However, due to the constraints of our dataset, which  
lacks the failed test execution and commit history required by Fonte, we are unable to include it as  
a baseline in our study.  
Given these considerations, our review of related work will primarily focus on relevant IR-based  
methods and research that has informed the design of our approach.

7.1 Traditional Machine Learning Approaches

Machine learning methods are commonly used in bug localization since they can acquire and  
integrate knowledge from large-scale observations, and are able to improve with the acquisition of  
new information. Early research in bug localization relied on machine learning methods, which can

\`\`\`  
A Knowledge Enhanced Large Language Model for Bug Localization FSE086:  
\`\`\`  
\`\`\`  
process large-scale observations and improve with new information Using the bag of words, early  
researchers calculated the similarity between the bug report and the source code by comparing  
the frequency of the same term in them. To calculate the similarity between the query and the  
source code file, Robertson et al. proposed a method based on TF-IDF, which combines the reverse  
document of the query word in the corpus with the word frequency in the source code file \[ 34 \]. In  
later work, Wang et al. \[44\]proposed several vector space models based on different forms of TF  
and IDF calculation. The experimental results show that the combined method outperforms the  
standard VSM model.  
Gore et al. \[8\]proposed a hybrid model that combines VSM and N-gram for bug localization.  
Compared with traditional methods, the hybrid model outperforms some existing state-of-the-art  
techniques for bug localization. Several bug localization models have also been developed, including  
DHbPd \[ 37 \], BLUiR \[ 36 \], BRTracer \[ 49 \], Amalgam \[ 43 \], LOCUS \[ 47 \], and others, that combine  
additional information on software project versions and code changes to locate bugs.  
\`\`\`  
7.2 Deep Learning Approaches  
Deep learning has gradually gained traction after machine learning for bug localization. Generally,  
these models rely on deep learning models to extract semantics from bug reports and source  
code, and to match the similarity between them. In deep learning-based bug localization, feature  
extraction is often at the core of the process \[ 58 \]. Deep learning models are primarily used to  
extract complex semantic relationships between source code and bug reports. The three most  
common deep learning models are CNN, RNN, and DNN. Huo et al. \[14\]proposed NP-CNN, a  
CNN-based deep learning network for bug localization that uses both lexical and program structure  
information to learn unified features from natural language and source code for automatically  
locating buggy code. Experimental results on a wide range of software projects show that NP-CNN  
significantly outperforms state-of-the-art methods in bug localization. Wang et al. \[40\]proposed a  
Multi-Dimension Convolutional Neural Network (MD-CNN) model for bug localization based on  
bug reports. According to the evaluation results, Wang et al. found that MD-CNN outperformed  
existing bug localization techniques. Yang et al. \[52\]propose a hybrid RNN-attention model called  
MRAM, which combines bug-fixing features and method-structured features to explore their  
relevance. Experimental results indicate that the model performs significantly better than the  
baseline. Lam et al. \[18\]combined a DNN with rVSM, using rVSM to collect features of textual  
similarity between bug reports and source files. Experimental results indicate that combining  
a DNN with rVSM performs significantly better than the baselines. Only one study proposed a  
knowledge graph-based approach based on structure features and applied hyperbolic attention  
embedding to get the link prediction scores \[ 50 \]. This approach has three main limitations. Firstly, it  
represents bug report IDs and code IDs as nodes in a knowledge graph, which results in a significant  
loss of textual and code information. Second, the method relies solely on syntactic information  
from the text and code, overlooking the rich semantic information. Finally, the approach does not  
incorporate external knowledge that is often available in projects, such as technical documentation,  
which can assist the model to better learn the information contained in both bug reports and code.  
As the replication package for this work was not provided, we were not able to reproduce the  
results for comparison. We chose Locus as the baseline because it provides a replication package  
and is a traditional approach for bug localization based on changesets.

\`\`\`  
7.3 LLM-based Approaches  
LLMs have gradually been applied to bug localization in recent years, with high performance in  
many fields. Transformer-based neural network architecture has become dominant, achieving  
promising performance in many natural language processing tasks and code representations. Zhu  
\`\`\`

\`\`\`  
FSE086:20 Yue Li, Bohan Liu, Ting Zhang, Zhiqi Wang, David Lo, Lanxin Yang, Jun Lyu, and He Zhang  
\`\`\`  
\`\`\`  
et al. \[58\]proposed a COOBA model that embeds the text in bug reports using an unsupervised  
learning algorithm, GloVe, and encodes them using bidirectional LSTMs. The code file is converted  
into AST and then embedded by GloVe. Finally, they extracted private and public features of the  
projects. Lin et al. \[23\]propose a novel framework for generating traceable links between source  
code and natural language artifacts. The experimental results show that their model outperforms  
the VSM model in stabilization among the three OSS projects. Liang et al. \[22\]proposed the FLIM  
model that uses an LLM, CodeBERT, and fine-tunes it for code search tasks. Furthermore, they  
employed the FLIM model to locate bugs using semantic features extracted from code files and  
bug reports. Asudani et al. \[2\] embedded code files using a LLM, GloVe, to improve DeepLoc, and  
embedded bug reports with sent2vec. The results indicate the effect of extracting features based on  
different embedding methods.  
Several studies have proposed enhancing LLMs with knowledge in natural language processing \[ 9 ,  
13 , 25 , 41 , 45 \]. The success of these studies inspires us to focus on domain-specific data. In contrast  
to these studies, we focus on bug reports and changesets that are relevant to bug localization.  
Bug reports and changesets often lack grammatical structure, making understanding challenging.  
Different from them, we introduce domain knowledge to enhance LLMs. We also incorporate  
soft-position embedding, visible matrices, and mask Transformer to represent domain knowledge.  
\`\`\`  
8 Conclusion and Future Work  
In this paper, we proposeKept, a knowledge-enhanced LLM designed to improve bug localization  
performance. First, we construct the text knowledge graph and the code knowledge graph using  
project documents and source code, respectively, to represent external domain knowledge. Second,  
we use soft-position embedding, visible matrices, and mask Transformer to represent this domain  
knowledge. Finally, we pre-train the model on the tasks aligned with the target task before fine-  
tuning it for downstream tasks. The evaluation results indicate thatKeptsignificantly improves  
bug localization performance. As compared to the traditional method, Locus,Keptimproves the  
performance of evaluation metrics by 33.2% to 59.5% in bug localization. As compared to the best-  
performing LLM in baselines, CodeT5,Keptshows a significant improvement of 36.6% to 63.7%.  
The Wilcoxon signed rank test confirms thatKeptexhibits statistically significant differences from  
all baseline methods. Therefore, the evaluation results significantly demonstrate the effectiveness of  
Keptfor bug localization, as well as confirm the positive impact of our approach by leveraging the  
knowledge enhanced LLM for bug localization. In the future, we intend to continuously reinforce  
bug localization by improving the knowledge-enhanced LLM. In addition, we plan to evaluate our  
model in a wider range of scenarios and projects.

\`\`\`  
9 Data Availability  
The datasets and source code used in this study are open source, and can easily be accessed by  
anyone. The datasets and source code are released at: https://github.com/keptmodel/KEPT.  
\`\`\`  
\`\`\`  
Acknowledgments  
This work is supported by the National Natural Science Foundation of China (No.62072227,  
No.62202219, No.62302210), the Jiangsu Provincial Key Research and Development Program (No.BE2  
021002-2), the Natural Science Foundation of Jiangsu Province (No.BK20241195), and the Innova-  
tion Project and Overseas Open Project of State Key Laboratory for Novel Software Technology  
(Nanjing University) (ZZKT2024A18, ZZKT2024B07, KFKT2023A09, KFKT2023A10, KFKT2024A02,  
KFKT2024A13, KFKT2024A14).  
\`\`\`

A Knowledge Enhanced Large Language Model for Bug Localization FSE086:21

References  
\[1\]Gabin An, Jingun Hong, Naryeong Kim, and Shin Yoo. 2023\. Fonte: Finding Bug Inducing Commits from Failures.  
InProceedings of the IEEE/ACM 45th International Conference on Software Engineering (ICSE’23). IEEE, Melbourne,  
Australia, 589–601.  
\[2\]Deepak Suresh Asudani, Naresh Kumar Nagwani, and Pradeep Singh. 2023\. Impact of word embedding models on text  
analytics in deep learning environment: a review.Artificial Intelligence Review56, 9 (2023), 10345–10425.  
\[3\]Dylan Callaghan and Bernd Fischer. 2023\. Improving Spectrum-Based Localization of Multiple Faults by Iterative Test  
Suite Reduction. InProceedings of the 32nd ACM SIGSOFT International Symposium on Software Testing and Analysis  
(ISSTA’23). ACM, Seattle, WA, USA, 1445–1457.  
\[4\]Agnieszka Ciborowska and Kostadin Damevski. 2022\. Fast Changeset-Based Bug Localization with BERT. InProceedings  
of the 44th International Conference on Software Engineering (ICSE’22). ACM, Pittsburgh, Pennsylvania, 946–957.  
\[5\]Yali Du and Zhongxing Yu. 2023\. Pre-training Code Representation with Semantic Flow Graph for Effective Bug  
Localization. InProceedings of the 31st ACM Joint European Software Engineering Conference and Symposium on the  
Foundations of Software Engineering (ESEC/FSE’23). ACM, San Francisco, CA, USA, 579–591.  
\[6\]Zhangyin Feng, Daya Guo, Duyu Tang, Nan Duan, Xiaocheng Feng, Ming Gong, Linjun Shou, Bing Qin, Ting Liu,  
Daxin Jiang, and Ming Zhou. 2020\. CodeBERT: A Pre-Trained Model for Programming and Natural Languages. In  
Findings of the Association for Computational Linguistics: EMNLP 2020, Trevor Cohn, Yulan He, and Yang Liu (Eds.).  
ACM, Online, 1536–1547.  
\[7\]K Gashteovski, R Gemulla, and L Del Corro. 2017\. MinIE: Minimizing facts in open information extraction.Association  
for Computational Linguistics(2017), 1–11.  
\[8\]Alpa Gore, Siddharth Dutt Choubey, and Kopal Gangrade. 2016\. Improved Bug Localization Technique Using Hybrid  
Information Retrieval Model. InProceedings of the 12th Distributed Computing and Internet Technology (ICDCIT’16),  
Nikolaj Bjørner, Sanjiva Prasad, and Laxmi Parida (Eds.). Springer, Bhubaneswar, India, 127–131.  
\[9\]Jian Guan, Fei Huang, Zhihao Zhao, Xiaoyan Zhu, and Minlie Huang. 2020\. A Knowledge-Enhanced Pretraining Model  
for Commonsense Story Generation.Transactions of the Association for Computational Linguistics8 (2020), 93–108.  
\[10\]Daya Guo, Shuai Lu, Nan Duan, Yanlin Wang, Ming Zhou, and Jian Yin. 2022\. UniXcoder: Unified Cross-Modal  
Pre-training for Code Representation. InProceedings of the 60th Annual Meeting of the Association for Computational  
Linguistics (Volume 1: Long Papers). 7212–7225.  
\[11\]Daya Guo, Shuo Ren, Shuai Lu, Zhangyin Feng, Duyu Tang, Shujie LIU, Long Zhou, Nan Duan, Alexey Svyatkovskiy,  
Shengyu Fu, Michele Tufano, Shao Kun Deng, Colin Clement, Dawn Drain, Neel Sundaresan, Jian Yin, Daxin Jiang, and  
Ming Zhou. 2021\. GraphCodeBERT: Pre-training Code Representations with Data Flow. InInternational Conference on  
Learning Representations (ICLR’21). 1–18.  
\[12\]Xu Han, Zhengyan Zhang, Ning Ding, Yuxian Gu, Xiao Liu, Yuqi Huo, Jiezhong Qiu, Yuan Yao, Ao Zhang, Liang  
Zhang, Wentao Han, Minlie Huang, Qin Jin, Yanyan Lan, Yang Liu, Zhiyuan Liu, Zhiwu Lu, Xipeng Qiu, Ruihua Song,  
Jie Tang, Ji-Rong Wen, Jinhui Yuan, Wayne Xin Zhao, and Jun Zhu. 2021\. Pre-trained models: Past, present and future.  
AI Open2 (2021), 225–250.  
\[13\]Linmei Hu, Zeyi Liu, Ziwang Zhao, Lei Hou, Liqiang Nie, and Juanzi Li. 2024\. A Survey of Knowledge Enhanced  
Pre-Trained Language Models.IEEE Transactions on Knowledge and Data Engineering36, 4 (2024), 1413–1430.  
\[14\]Xuan Huo, Ming Li, and Zhi-Hua Zhou. 2016\. Learning Unified Features from Natural and Programming Languages  
for Locating Buggy Source Code. InProceedings of the 25th International Joint Conference on Artificial Intelligence  
(IJCAI’16). AAAI Press, New York, USA, 1606–1612.  
\[15\]Xuan Huo, Ferdian Thung, Ming Li, David Lo, and Shu-Ting Shi. 2021\. Deep Transfer Bug Localization. IEEE  
Transactions on Software Engineering47, 7 (2021), 1368–1380.  
\[16\]Darryl Jarman, Jeffrey Berry, Riley Smith, Ferdian Thung, and David Lo. 2022\. Legion: Massively Composing Rankers  
for Improved Bug Localization at Adobe.IEEE Transactions on Software Engineering48, 8 (2022), 3010–3024.  
\[17\]Ashwini Jaya Kumar, Christoph Schmidt, and Joachim Köhler. 2017\. A knowledge graph based speech interface for  
question answering systems.Speech Communication92 (2017), 1–12.  
\[18\]An Ngoc Lam, Anh Tuan Nguyen, Hoan Anh Nguyen, and Tien N. Nguyen. 2017\. Bug Localization with Combination of  
Deep Learning and Information Retrieval. InProceedings of the 25th International Conference on Program Comprehension  
(ICPC’17). IEEE, Buenos Aires, Argentina, 218–229.  
\[19\]Jaekwon Lee, Dongsun Kim, Tegawendé F. Bissyandé, Woosung Jung, and Yves Le Traon. 2018\. Bench4BL: Repro-  
ducibility Study on the Performance of IR-Based Bug Localization. InProceedings of the 27th ACM SIGSOFT International  
Symposium on Software Testing and Analysis (ISSTA’2018). ACM, Amsterdam, Netherlands, 61–72.  
\[20\]Yuxuan Lei, Jianxun Lian, Jing Yao, Mingqi Wu, Defu Lian, and Xing Xie. 2024\. Aligning Language Models for Versatile  
Text-based Item Retrieval. InCompanion Proceedings of the ACM Web Conference 2024(Singapore, Singapore)(WWW  
’24). Association for Computing Machinery, New York, NY, USA, 935–938.

FSE086:22 Yue Li, Bohan Liu, Ting Zhang, Zhiqi Wang, David Lo, Lanxin Yang, Jun Lyu, and He Zhang

\[21\]Yue Li, Zhong Ren, Zhiqi Wang, Lanxin Yang, Liming Dong, Chenxing Zhong, and He Zhang. 2024\. Fine-SE: Integrating  
Semantic Features and Expert Features for Software Effort Estimation. InProceedings of the IEEE/ACM 46th International  
Conference on Software Engineering (ICSE’24)(Lisbon, Portugal). ACM, Article 27, 12 pages.  
\[22\]Hongliang Liang, Dengji Hang, and Xiangyu Li. 2022\. Modeling function-level interactions for file-level bug localization.  
Empirical Software Engineering27, 7 (2022), 1–26.  
\[23\]Jinfeng Lin, Yalin Liu, Qingkai Zeng, Meng Jiang, and Jane Cleland-Huang. 2021\. Traceability Transformed: Generating  
More Accurate Links with Pre-Trained BERT Models. InProceedings of the 43rd International Conference on Software  
Engineering (ICSE’21). IEEE, Madrid, ES, 324–335.  
\[24\]Edward Loper and Steven Bird. 2002\. NLTK: the Natural Language Toolkit. InProceedings of the ACL-02 Workshop on  
Effective Tools and Methodologies for Teaching Natural Language Processing and Computational Linguistics (ETMTNLP  
’02) (ETMTNLP ’02). ACM, Philadelphia, Pennsylvania, 63–70.  
\[25\]Lipeng Ma, Weidong Yang, Bo Xu, Sihang Jiang, Ben Fei, Jiaqing Liang, Mingjie Zhou, and Yanghua Xiao. 2024\.  
KnowLog: Knowledge Enhanced Pre-trained Language Model for Log Understanding. InProceedings of the IEEE/ACM  
46th International Conference on Software Engineering (ICSE’24). ACM, Lisbon, Portugal, Article 32, 13 pages.  
\[26\]Vijayaraghavan Murali, Lee Gross, Rebecca Qian, and Satish Chandra. 2021\. Industry-Scale IR-Based Bug Localization:  
A Perspective from Facebook. InProceedings of the 43rd International Conference on Software Engineering: Software  
Engineering in Practice (ICSE-SEIP’21). IEEE, Madrid, ES, 188–197.  
\[27\]Chao Ni, Wei Wang, Kaiwen Yang, Xin Xia, Kui Liu, and David Lo. 2022\. The Best of Both Worlds: Integrating Semantic  
Features with Expert Features for Defect Prediction and Localization. InProceedings of the 30th ACM Joint European  
Software Engineering Conference and Symposium on the Foundations of Software Engineering (ESEC/FSE ’22). ACM,  
Singapore, Singapore, 672–683.  
\[28\]Feifei Niu, Wesley K. G. Assunção, LiGuo Huang, Christoph Mayr-Dorn, Jidong Ge, Bin Luo, and Alexander Egyed.

2023\. RAT: A Refactoring-Aware Traceability Model for Bug Localization. InProceedings of the 45th International  
Conference on Software Engineering (ICSE’23). IEEE, Melbourne, Australia, 196–207.  
\[29\] OpenAI. 2022\. text-embedding-ada-002. https://platform.openai.com/docs/guides/embeddings.  
\[30\]Adam Paszke, Sam Gross, Francisco Massa, Adam Lerer, James Bradbury, Gregory Chanan, Trevor Killeen, Zeming  
Lin, Natalia Gimelshein, Luca Antiga, Alban Desmaison, Andreas Köpf, Edward Yang, Zach DeVito, Martin Raison,  
Alykhan Tejani, Sasank Chilamkurthy, Benoit Steiner, Lu Fang, Junjie Bai, and Soumith Chintala. 2019.PyTorch: An  
Imperative Style, High-Performance Deep Learning Library. Curran Associates Inc., Vancouver Canada, 1–12.  
\[31\]Michael Pradel, Vijayaraghavan Murali, Rebecca Qian, Mateusz Machalica, Erik Meijer, and Satish Chandra. 2020\.  
Scaffle: Bug Localization on Millions of Files. InProceedings of the 29th ACM SIGSOFT International Symposium on  
Software Testing and Analysis (ISSTA’20). ACM, Virtual Event, USA, 225–236.  
\[32\]Alec Radford, Jeff Wu, Rewon Child, David Luan, Dario Amodei, and Ilya Sutskever. 2019\. Language Models are  
Unsupervised Multitask Learners. arXiv, 1–24.  
\[33\]Michael Rath, David Lo, and Patrick Mäder. 2018\. Analyzing Requirements and Traceability Information to Improve  
Bug Localization. InProceedings of the 15th International Conference on Mining Software Repositories (MSR’18). ACM,  
Gothenburg, Sweden, 442–453.  
\[34\]Stephen.E. Robertson and Karen. Spärck Jones. 1994.Simple, proven approaches to text retrieval. Technical Report.  
University of Cambridge, Computer Laboratory.  
\[35\]Giovanni Rosa, Luca Pascarella, Simone Scalabrino, Rosalia Tufano, Gabriele Bavota, Michele Lanza, and Rocco Oliveto.  
2021\. Evaluating SZZ Implementations Through a Developer-Informed Oracle. InProceedings of the 43rd International  
Conference on Software Engineering (ICSE’21). IEEE, Madrid, Spain, 436–447.  
\[36\]Ripon K. Saha, Matthew Lease, Sarfraz Khurshid, and Dewayne E. Perry. 2013\. Improving bug localization using  
structured information retrieval. InProceedings of the 28th International Conference on Automated Software Engineering  
(ASE’13). IEEE, Silicon Valley, CA, USA, 345–355.  
\[37\]Bunyamin Sisman and Avinash C. Kak. 2012\. Incorporating version histories in Information Retrieval based bug  
localization. InProceedings of the 9th IEEE Working Conference on Mining Software Repositories (MSR’12). IEEE, Zurich,  
Switzerland, 50–59.  
\[38\]Tianxiang Sun, Yunfan Shao, Xipeng Qiu, Qipeng Guo, Yaru Hu, Xuanjing Huang, and Zheng Zhang. 2020\. Co-  
LAKE: Contextualized Language and Knowledge Embedding. InProceedings of the 28th International Conference on  
Computational Linguistics (COLING’20). ICCL, Barcelona, Spain (Online), 3660–3670.  
\[39\]Jeniya Tabassum, Mounica Maddela, Wei Xu, and Alan Ritter. 2020\. Code and Named Entity Recognition in StackOver-  
flow. InProceedings of the 58th Annual Meeting of the Association for Computational Linguistics (ACL’20). ACL, Online,  
4913–4926.  
\[40\]Bei Wang, Ling Xu, Meng Yan, Chao Liu, and Ling Liu. 2022\. Multi-Dimension Convolutional Neural Network for Bug  
Localization.IEEE Transactions on Services Computing15, 3 (2022), 1649–1663.

A Knowledge Enhanced Large Language Model for Bug Localization FSE086:23

\[41\]Jianing Wang, Chengyu Wang, Minghui Qiu, Qiuhui Shi, Hongbin Wang, Jun Huang, and Ming Gao. 2022\. KECP:  
Knowledge Enhanced Contrastive Prompting for Few-shot Extractive Question Answering. InProceedings of the 2022  
Conference on Empirical Methods in Natural Language Processing. ACL, Abu Dhabi, United Arab Emirates, 3152–3163.  
\[42\]Qing Wang, Lang Gou, Nan Jiang, Meiru Che, Ronghui Zhang, Yun Yang, and Mingshu Li. 2008\. Estimating fixing  
effort and schedule based on defect injection distribution.Software Process: Improvement and Practice13, 1 (2008),  
35–50.  
\[43\]Shaowei Wang and David Lo. 2014\. Version History, Similar Report, and Structure: Putting Them Together for  
Improved Bug Localization. InProceedings of the 22nd International Conference on Program Comprehension (ICPC’14).  
ACM, Hyderabad, India, 53–63.  
\[44\]Shaowei Wang, David Lo, and Julia Lawall. 2014\. Compositional Vector Space Models for Improved Bug Localization. In  
Proceedings of the 30th IEEE International Conference on Software Maintenance and Evolution (ICSME’14). IEEE, Victoria,  
BC, Canada, 171–180.  
\[45\]Xiaozhi Wang, Tianyu Gao, Zhaocheng Zhu, Zhengyan Zhang, Zhiyuan Liu, Juanzi Li, and Jian Tang. 2021\. KEPLER:  
A Unified Model for Knowledge Embedding and Pre-trained Language Representation.Transactions of the Association  
for Computational Linguistics9 (2021), 176–194.  
\[46\]Yue Wang, Weishi Wang, Shafiq Joty, and Steven C. H. Hoi. 2021\. CodeT5: Identifier-aware Unified Pre-trained  
Encoder-Decoder Models for Code Understanding and Generation. arXiv, 1–13.  
\[47\]Ming Wen, Rongxin Wu, and Shing-Chi Cheung. 2016\. Locus: Locating Bugs from Software Changes. InProceedings of  
the 31st International Conference on Automated Software Engineering (ASE’16). ACM, Singapore, Singapore, 262–273.  
\[48\]Thomas Wolf, Lysandre Debut, Victor Sanh, Julien Chaumond, Clement Delangue, Anthony Moi, Pierric Cistac, Tim  
Rault, Rémi Louf, Morgan Funtowicz, Joe Davison, Sam Shleifer, Patrick von Platen, Clara Ma, Yacine Jernite, Julien  
Plu, Canwen Xu, Teven Le Scao, Sylvain Gugger, Mariama Drame, Quentin Lhoest, and Alexander M. Rush. 2019\.  
HuggingFace’s Transformers: State-of-the-art Natural Language Processing. InProceedings of the 2020 Conference on  
Empirical Methods in Natural Language Processing: System Demonstrations (EMNLP’20). ACL, online, 38–45.  
\[49\]Chu-Pan Wong, Yingfei Xiong, Hongyu Zhang, Dan Hao, Lu Zhang, and Hong Mei. 2014\. Boosting Bug-Report-  
Oriented Fault Localization with Segmentation and Stack-Trace Analysis. InProceedings of the 30th IEEE International  
Conference on Software Maintenance and Evolution (ICSME’14). IEEE, Victoria, BC, Canada, 181–190.  
\[50\]Xi Xiao, Renjie Xiao, Qing Li, Jianhui Lv, Shunyan Cui, and Qixu Liu. 2023\. BugRadar: Bug localization by knowledge  
graph link prediction.Information and Software Technology162 (2023), 1–13.  
\[51\]Yichong Xu, Chenguang Zhu, Shuohang Wang, Siqi Sun, Hao Cheng, Xiaodong Liu, Jianfeng Gao, Pengcheng He,  
Michael Zeng, and Xuedong Huang. 2022\. Human parity on commonsenseqa: Augmenting self-attention with external  
attention. InProceedings of the International Joint Conference on Artificial Intelligence (IJCAI’22). 2762–2768.  
\[52\]Shouliang Yang, Junming Cao, Hushuang Zeng, Beijun Shen, and Hao Zhong. 2021\. Locating Faulty Methods with  
a Mixed RNN and Attention Model. InProceedings of the 29th International Conference on Program Comprehension  
(ICPC’21). IEEE, Madrid, Spain, 207–218.  
\[53\]Zhou Yang, Jieke Shi, Shaowei Wang, and David Lo. 2021\. IncBL: Incremental Bug Localization. InProceedings of the  
36th International Conference on Automated Software Engineering (ASE’21). IEEE, Melbourne, Australia, 1223–1226.  
\[54\]Jinsung Yoon, Yanfei Chen, Sercan Arik, and Tomas Pfister. 2024\. Search-Adaptor: Embedding Customization for  
Information Retrieval. InProceedings of the 62nd Annual Meeting of the Association for Computational Linguistics  
(ACL’24), Lun-Wei Ku, Andre Martins, and Vivek Srikumar (Eds.). ACM, Bangkok, Thailand, 12230–12247.  
\[55\]Zhuo Zhang, Yan Lei, Xiaoguang Mao, Meng Yan, Xin Xia, and David Lo. 2023\. Context-Aware Neural Fault Localization.  
IEEE Transactions on Software Engineering49, 7 (2023), 3939–3954.  
\[56\]Zhuosheng Zhang, Hai Zhao, Masao Utiyama, and Eiichiro Sumita. 2023\. Language Model Pre-training on True  
Negatives. InProceedings of the AAAI Conference on Artificial Intelligence (AAAI’23), Vol. 37\. Washington DC, USA,  
14002–14010.  
\[57\]Jian Zhou, Hongyu Zhang, and David Lo. 2012\. Where should the bugs be fixed? More accurate information retrieval-  
based bug localization based on bug reports. InProceedings of the 34th International Conference on Software Engineering  
(ICSE’12). IEEE, Zurich, Switzerland, 14–24.  
\[58\]Ziye Zhu, Yun Li, Hanghang Tong, and Yu Wang. 2020\. CooBa: Cross-project Bug Localization via Adversarial Transfer  
Learning. InProceedings of the 29th International Joint Conference on Artificial Intelligence (IJCAI’20). ACM, Vienna,  
Austria, 3565–3571.  
\[59\]Weiqin Zou, David Lo, Zhenyu Chen, Xin Xia, Yang Feng, and Baowen Xu. 2020\. How Practitioners Perceive Automated  
Bug Report Management Techniques.IEEE Transactions on Software Engineering46, 8 (2020), 836–862.

Received 2024-09-13; accepted 2025-04-01


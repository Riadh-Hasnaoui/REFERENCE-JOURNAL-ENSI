\# HyRACC: A Hybrid Retrieval-Augmented

\# Framework for More Efficient Code Completion

\#\# Chuanyi Li^1 , Jiwei Shang^1 , Yi Feng^1 ̊, Bin Luo^1

(^1) National Key Laboratory for Novel Software Technology, Nanjing University, Nanjing, China  
̊Corresponding author  
lcy@nju.edu.cn, jiweishang@smail.nju.edu.cn,{fy,luobin}@nju.edu.cn  
Abstract—Retrieval-Augmented Generation (RAG) approaches  
have significantly advanced code completion tasks, addressing  
limitations like the use of updated third-party libraries and  
new project dependencies. However, existing RAG methods often  
face challenges in balancing retrieval costs and completion accu-  
racy. In this paper, we introduce HyRACC, a hybrid retrieval-  
augmented framework designed to enhance code completion  
efficiency. HyRACC incorporates a novel approach that uses  
hybrid databases at both block-level and token-level, coupled with  
a two-step retrieval scheme. This structure not only ensures high  
retrieval accuracy but also boosts response speed and reduces  
storage requirements. Our experimental results demonstrate that  
HyRACC improves code completion accuracy while optimizing  
latency and storage usage. Remarkably, HyRACC operates inde-  
pendently of model parameters, which facilitates its integration  
with various models and domains. This flexibility and efficiency  
make HyRACC particularly suitable for integration into plugins  
or local deployment, meeting diverse user needs for personalized  
code completion.  
Index Terms—Domain Adaptive Code Completion, Retrieval-  
Augmented Generation  
I. INTRODUCTION  
In recent years, the rapid development of large language  
models (LLMs) has revolutionized the field of code comple-  
tion, with various of them achieving state-of-the-art perfor-  
mance in general code completion tasks \[1–5\]. However, these  
models still face limitations in certain specific code domains,  
as shown in Fig. 1\. For example, large models struggle to  
maintain up-to-date knowledge, leading to poor performance  
with frequently updated third-party libraries \[6\]. The cloud-  
based operation raises concerns about code information leak-  
age \[7\], and the large size of these models results in high  
resource overhead, etc. Therefore, in certain specific domains,  
users require more personalized code completion services,  
which also place higher demands on the efficiency of the  
completion models.  
Small to medium-scale models coupled with RAG are seen  
as solutions to those problems. On one hand, these models  
are well-suited for local deployment. On the other hand,  
RAG technology enhances performance by utilizing external  
information, allowing for a reduction in model scale while  
maintaining or even improving completion performance \[8\].  
Currently, there are two mainstream RAG methods in code  
completion: prompt-based RAG and logit-based RAG \[9\].  
Prompt-based RAG constructs a block-level database, merges  
retrieved code blocks with incomplete code, and feeds them as  
\*\*ResourceOverhead  
LibraryUpdates\*\*  
Version 1.1.0→1.2.  
\*\*Project Dependencies\*\*  
File1 File2 File  
\*\*Information Leakage\*\*  
upload  
\*\*LLMs  
...\*\*  
Fig. 1\. Challenges faced by LLMs in specific domains of code completion,  
such as information leakage, library updates, project dependencies, and  
resource overhead.  
the prompt into the model. This approach has a fast retrieval  
speed but is limited by the input text length and inference  
capabilities of the model. Logic-based RAG creates a token-  
level database and predicts the next token by linearly interpo-  
lating the base LM’s logits with the retrieved nearest neighbor  
distribution. While this method supports longer contexts, it  
requires training and maintaining a large-scale vector database,  
also resulting in slower response speed. These issues hinder  
the advancement of customized code completion services.  
In this paper, We propose HyRACC, an efficientHybrid  
Retrieval-Augmented framework forCodeCompletion. This  
architecture employs innovative hybrid retrieval-augmented  
technology. Specifically, it first retrieves similar code snippets  
from a block-level database, filtering out a large amount of  
irrelevant information. Then, based on these similar code  
snippets, it constructs a small-scale token-level database and  
performs token retrieval, improving response speed and re-  
ducing storage space. Finally, it adaptively integrates the  
retrieved information with the model results based on logits  
for inference.  
We conducted evaluations of HyRACC on several domain-  
specific code completion datasets. Experimental results indi-  
cate that on small LMs, such as CodeGPT and UniXcoder,  
HyRACC achieved an average improvement of 11.5% in EM  
and 18.7% in ES. Meanwhile, it also performed well in  
response speed and GPU usage. Furthermore, we also achieved  
promising results on larger-scale models like StarCoder-1B. In  
61

\#\# 2025 IEEE/ACM Second International Conference on AI Foundation Models and Software Engineering (Forge)

\`\`\`  
979-8-3315-0211-9/25/$31.00 ©2025 IEEE  
DOI 10.1109/Forge66646.2025.  
\`\`\`  
2025 IEEE/ACM Second International Conference on AI Foundation Models and Software Engineering (Forge) | 979-8-3315-0211-9/25/$31.00 ©2025 IEEE | DOI: 10.1109/Forge66646.2025.

summary, the main contributions of this paper are as follows:

‚We present HyRACC, a hybrid RAG framework for code  
completion. This framework improves code completion ef-  
ficiency by constructing hybrid retrieval databases, perform-  
ing hybrid retrieval, and employing adaptively inference  
methods. Relevant data, code, and experimental results can  
be found in our anonymous repository^1.  
‚We validate HyRACC on models of different scales and  
datasets from various domains. The results indicate that  
compared to existing methods, HyRACC shows improve-  
ments in code completion accuracy, response speed, and  
GPU usage.

\`\`\`  
II. RELATEDWORK  
\`\`\`  
A. Domain Specific Code Completion

Auto code completion is a technique that automatically  
provides code snippet suggestions to developers during the  
programming process. In addition to the significant advance-  
ments in general code completion performance driven by  
large models\[1–5\], many efforts have started to focus on  
domain-specific code completion tasks. For example, there  
are completions tailored for specific repositories \[10–12\] and  
those designed for particular scenarios \[13, 14\]. Some studies  
have gone further by introducing a domain-adaptive code com-  
pletion framework that can adjust to various fields \[15, 16\].  
Similar to these works, our model can adapt to different  
domains of code simply by switching databases without the  
need for additional fine-tuning or structural changes.

B. Information Retrieval

Retrieval is to identify and obtain relevant information given  
an information need. There are two primary approaches to  
information retrieval. Sparse retrieval methods, such as Term  
Frequency-Inverse Document Frequency (TF-IDF) \[17\] and  
BM25 \[18\], represent documents and queries using sparse  
vectors based on term frequencies. These methods are efficient  
and interpretable but struggle with issues like synonymy and  
polysemy. Dense retrieval methods utilize dense vector repre-  
sentations generated by neural network models, like BERT  
\[19\] and UniXcoder \[20\]. These vectors capture semantic  
meanings, making the system more robust in understanding  
semantics. However, dense retrieval methods require substan-  
tial computational resources and large amounts of annotated  
data.

C. RAG Foundations

1\) Prompt-based RAG:Stemming from the idea of prompt  
augmentation, Prompt-based RAG integrates user queries with  
retrieved information and uses them as inputs for the Lan-  
guage Model (LM). This approach represents the mainstream  
paradigm for code completion. Drain et al. \[21\] retrieved a  
template of functions for function completion. RepoCoder \[22\]  
uses iterative retrieval generation to correct errors. DRACO  
\[23\] employs data flow information to assist in completion.

(^1) https://github.com/CallMeAHuang/HyRACC  
Repobench \[24\] constructs the retrieved information into a  
simple chain of thought to accomplish repository-level com-  
pletion tasks.  
2\) Logits-based RAG:In logit-based RAG, generative mod-  
els integrate retrieval information through logits during the  
decoding process. KNN-LMs \[15\] combine LM-generated  
probabilities with those derived from retrieval distances of  
similar prefixes at each decoding step. KNM-LM \[16\] per-  
forms logit-based RAG, combining the logits of retrieval and  
generation using Bayes inference.  
III. APPROACH  
Generally, code completion is based on the context of  
the code inputx “ px 1 ,x 2 , ̈ ̈ ̈,xnqand predicts a series  
of possible subsequent code tokensy “ py 1 ,y 2 , ̈ ̈ ̈,ytq.  
HyRACC effectively enhances code completion performance  
in specific domains by a novel RAG framework, as illustrated  
in Fig. 2\. It mainly consists of three steps, which are detailed  
below.  
A. Step1. Retrieve Code Snippets from Block-Level DB  
To complete code in a specific domain using an external  
corpusDdomain, we first process the code files inDdomain  
by extracting function blocks, removing unnecessary blank  
lines, and splitting them into code snippets of less thanm  
tokens each. These operations improve retrieval results, as  
noted by Karpukhin et al. \[25\]. Consequently, we obtainN  
code snippetsciforming the block-level database:Dblock“  
tc 1 ,c 2 , ̈ ̈ ̈,cNu.  
Then, given an incomplete code x, the sparse retriever  
RSp ̈, ̈qswiftly identifies the top-M similar code snippets  
CM in theDblock based on specific term matching met-  
rics. The workflow of sparse retriever can be formalized as  
RSpq,Dblockq ÑCM. This step acts as a filter to eliminate  
deceptively similar tokens in irrelevant contexts, thereby nar-  
rowing down the search scope for subsequent steps. The sparse  
retriever we use is BM25, based on the implementation of  
ElasticSearch^2.  
B. Step2. Build and Retrieve Token-Level DB  
1)Build Token-Level Database: Inspired bykNN-LMs  
\[15\], upon the resultsCM from sparse retrieval, we then  
construct a token-level database stored as key-value pairs. Let  
fp ̈qbe the function that maps a contextcto a fixed-length  
vector representation computed by the pre-trained LM, andw  
be the next target token ofc. Then, for a samplepci,wiqin  
CM, we define the key-value pairpki,viq, where the keyki  
is the vector representation of the contextfpciqand the value  
viis the target tokenwi. Thus, the whole token-level database  
Dtokencan be defined as:  
pK,Vq “ tpfpciq,wiq|pci,wiq PCMu (1)  
The size of theDtokenis proportional to the number of tokens  
in the corpus, which may lead to high computational resource  
(^2) https://www.elastic.co  
62

\`\`\`  
Source files  
\`\`\`  
\`\`\`  
Block-Level  
DB  
\`\`\`  
\`\`\`  
Sparse  
Retriever LM  
\`\`\`  
\`\`\`  
LM  
\`\`\`  
\`\`\`  
Token-Level  
DB  
\`\`\`  
\`\`\`  
Dense  
Retriever  
\`\`\`  
\`\`\`  
CLS head  
\`\`\`  
\`\`\`  
Combine  
Inference  
\`\`\`  
\`\`\`  
Prob from LM  
self 0\.  
torch 0\.  
... ...  
\`\`\`  
\`\`\`  
Prob of Next Token  
self 0\.  
... ...  
torch 0\.  
\`\`\`  
\`\`\`  
Prob from DB  
self 0\.  
torch 0\.  
... ...  
\`\`\`  
\`\`\`  
ProbfromDB  
\`\`\`  
\`\`\`  
Probfrom  
LM  
\`\`\`  
\`\`\`  
Next TokenProbof  
\`\`\`  
\`\`\`  
🔍VecSim  
\`\`\`  
\`\`\`  
Step1. Retrieval Block-Level DB Step2. Build and Retrieval Token-Level DB Step3. Inference  
\`\`\`  
\`\`\`  
Value Key  
𝑡𝑜𝑘𝑒𝑛\!  
... ...  
𝑡𝑜𝑘𝑒𝑛"  
\`\`\`  
\`\`\`  
Query  
\`\`\`  
\`\`\`  
idx next\_idx Content RankingList  
0 1  
... ... ...  
n n  
\`\`\`  
\`\`\`  
Query Tokenizer  
\`\`\`  
\`\`\`  
🔍DocSim  
\`\`\`  
\`\`\`  
Rankinglist  
\`\`\`  
\`\`\`  
LM  
\`\`\`  
\`\`\`  
Code to be completed  
\`\`\`  
\`\`\`  
𝜆  
\`\`\`  
\`\`\`  
1 −𝜆  
\`\`\`  
\`\`\`  
process  
\`\`\`  
\`\`\`  
Fig. 2\. The overall framework of HyRACC. It mainly consists of three steps: Step1, Retrieve code snippets from block-level database. Step 2, Build and  
retrieve the token-level database. Step 3, inference. The upper part of the figure depicts the main process, while the lower part shows the implementation  
details.  
\`\`\`  
and storage space costs. However, after the snippets retrieval  
in Step 1, the corpusCM is relatively small. Additionally,  
since most current models are derived from the transformer  
architecture\[26\], we can batch encode the corpus in parallel  
and then directly obtain all the keys from theKV cache,  
thereby optimizing latency and storage.  
2)Retrieve Tokens from Database: With the embedded  
query vectorfpxqgenerated by the LM, the dense retriever  
RDp ̈, ̈qqueries the databaseDtokenwithfpqqto retrieve its  
k-nearest neighborsNbase on keys similarity according to a  
distance functiondp ̈, ̈q(We usingL 2 distance in our experi-  
ments). The workflow of dense retriever can be formalized as  
RDpfpqq,Dtokenq ÑN. Then, we followkNN-LMs \[15\] to  
generate the probability distribution of the next possible token  
from search results:

\`\`\`  
pDBpy|xq  
\`\`\`  
\`\`\`  
ÿ  
\`\`\`  
\`\`\`  
pki,viqPN  
\`\`\`  
(^1) y“viexpp ́dpki,fpxqqq (2)  
It computes a distribution over neighbors based on a softmax  
of their negative distances while aggregating probability mass  
for each vocabulary item across all its occurrences in the  
retrieved targets. And 1 here is an indicator function. This  
means that items that are not in 1 are assigned with 0  
probability.  
C. Step3. Inference  
During inference, the next token is sampled from the mix-  
ture distributionpof the non-parametric distribution from the  
retrieval databasepDBpy|xqand parametric distribution from  
the LMpLMpy|xqusing a flexible hyper-parameterλP r 0 , 1 s:  
ppy|xq “λ ̈pLMpy|xq\`p 1 ́λq ̈pDBpy|xq (3)  
The challenge lies in adaptively determining the tuning  
parameterλfor different domains. The value ofλreflects the  
confidence of the LM. Inspired by the language modeling task  
\[27, 28\], we computeλby evaluating the results of language  
modeling during the encoding process of the input sequence:  
λ“

\#\#\# PLM

\#\#\# PLM\`PDB

\#\#\# (4)

\`\`\`  
Here, PLM represents the proportion of tokens correctly  
predicted by the LM out of the total tokens in the input  
sequence, whilePDB represents the proportion of correct  
tokens retrieved from the database. Specifically, given an input  
sequencex “ px 1 ,x 2 ,...,xnq, after LM encoding, we can  
access the output layer to compute the language modeling  
results fromˆx “ pxˆ 1 ,xˆ 2 ,...,ˆxnq. Therefore,PLM can be  
counted as:  
PLM“  
\`\`\`  
\#\#\# 1

\`\`\`  
n  
\`\`\`  
\`\`\`  
ÿn  
\`\`\`  
\`\`\`  
i“ 1  
\`\`\`  
\`\`\`  
1 pxi“xˆiq (5)  
\`\`\`  
\`\`\`  
Where 1 is the same indicator function mentioned in III-B2.  
It is 1 whenxi“xˆi, and 0 otherwise. ForPDB, we can use  
the keys from the encoding process as queries to search for  
tokens in the database and compute in the same way.  
\`\`\`  
\`\`\`  
IV. EXPERIMENTSSETUP  
A. Task and Metrics  
We conducted experiments on two code completion tasks:  
API completion and next-line completion. The goal of API  
completion is to complete API calls for specific third-party li-  
braries, while next-line completion aims to predict the next full  
line of incomplete code context. We measured the accuracy of  
the generated code by calculating Exact Match (EM) accuracy  
and Levenshtein Edit Similarity (ES)\[29\]. Additionally, we  
evaluated resource overhead by assessing the response speed  
(tokens/s) of code generation and GPU usage (GB).  
\`\`\`  
\`\`\`  
B. Datasets  
Our data stem from the API-Bench\[30\]. This dataset in-  
cludes various code scenarios in two common programming  
languages, Java and Python. For the API completion task, we  
utilized the Java Android dataset processed by Tang et al. \[16\]  
as a test set, which includes 49,000 Android API invocation  
\`\`\`  
\`\`\`  
63  
\`\`\`

data. For the next-line completion task, we extracted 3000 lines  
from different Python files containing deep-learning library  
calls as a test set. In each of these scenarios, we employ the  
train set from API-Bench as the external corpus.

C. Baselines

For the base models of code completion, we selected  
three state-of-the-art pre-trained models. There areCodeGPT  
\[31\],UniXcoder\[20\] andStarCoderBase-1B\[3\]. It should  
be noted that both CodeGPT and UniXcoder require the  
same dataset preprocessing during inference, while Star-  
coder doesn’t. Therefore, to ensure fair experimental com-  
parisons, we employed different base models for different  
tasks: CodeGPT and UniXcoder for API completion, and  
Starcoder for line completion. Additionally, to verify the  
efficiency of HyRACC, we select two competitive retrieval-  
augmented frameworks for comparison. For prompt-based  
RAG, we chooseBM25as retrieval to search relevant code  
snippets. For logit-based RAG, we usekNM-LM\[16\] as a  
representative, which saves each token in the domains code  
into a key-value datastore, and usekNN algorithm to retrieve  
similar code tokens.

D. Implementation Details

All base models are sourced from Hugging Face’s relevant  
repositories, and we use CodeGPT-small-java-adaptedGPT2 as  
the representation of CodeGPT. For BM25, we use Elastic-  
Search to implement and retrieve the top 10 similar code  
blocks. These are then combined with input context to con-  
struct the prompt, following the approach used in CCEval \[32\].  
ForkNM-LM, we implement the method described by Tang et  
al. \[16\], settingk(the number of retrieved nearest neighbors)  
to 1024, and use faiss-gpu \[33\] to accelerated theknearest  
neighbors search. For HyRACC, in step 1, we use BM25 to  
retrieve the top 10 blocks and their successors, with each  
block containing less than 200 tokens. In step 2, we search  
the top 20 tokens to construct a probability distribution. Also,  
to ensure fairness in the analysis of time and space complexity,  
all experiments are performed on a machine equipped with 2  
NVIDIA 3090Ti-24GB GPUs.

V. RESULTS ANDANALYSIS  
We present the experimental results in Table I and Ta-  
ble II. In summary, compared to the baselines, our framework  
shows improvements in both ES and EM metrics. Moreover,  
HyRACC also optimizes latency and storage compared to  
other retrieval approaches.

A. API Invocation Completion

We evaluated HyRACC on the Java Android API com-  
pletion dataset using the CodeGPT and UniXcoder models.  
HyRACC achieved almost the best performance on ES and  
EM, even surpassing the full-scalekNM-LM, which is also  
based on logits. We speculate this is because HyRACC filters  
out deceptively similar tokens in irrelevant contexts during  
the sparse retrieval, thereby reducing noise. Moreover, the

\`\`\`  
average GPU usage of HyRACC is slightly lower than prompt-  
based RAG models represented by BM25. This is due to the  
quadratic increase in computational overhead with increas-  
ing prompt length in attention-based models \[26\]. Regard-  
ing response speed, the improvement with HyRACC is not  
significant as it requires real-time database generation during  
retrieval. However, since developers typically expect to receive  
completion results within 200 milliseconds \[34\], we consider  
this response speed to be acceptable.  
TABLE I  
RESULTS OF THEJAVAANDROIDAPI COMPLETION  
\`\`\`  
\`\`\`  
Model Java Android API Completion  
ES EM Speed(tokens/s) GPU(GB)  
CodeGPT 43.43 4.93 323.44 2\.  
\+BM25 45.74 6.99 253.47 3\.  
\+kNM-LM 56.42 20.17 122.97 10\.  
\+HyRACC 56.21 21.40 158.60 3\.  
UnixCoder 48.84 3.17 345.91 2\.  
\+BM25 49.87 4.32 304.99 3\.  
\+kNM-LM 55.84 22.52 148.73 10\.  
\+HyRACC 58.78 24.10 168.72 2\.  
\`\`\`  
\`\`\`  
B. Line Completion  
In line completion, we evaluated the performance of  
HyRACC using the Python DL dataset. As shown in ta-  
ble II, HyRACC showed improvements in EM and ES met-  
rics, while BM25 achieved the best results. We speculate  
that this improvement of BM25 is due to the enhanced  
reasoning capabilities of large models and their support for  
longer contexts. In terms of response speed and GPU usage,  
our method outperformed several other retrieval-augmented  
frameworks. Additionally, as the model size and input context  
length increase, prompt-based RAG tends to consume more  
resources, which is due to the attention architecture module  
of the transformers \[26\], while HyRACC is relatively less  
affected.  
TABLE II  
RESULTS OF THEPYTHONDEEP LEARNINGLINECOMPLETION  
\`\`\`  
\`\`\`  
Model Python DL Line Completion  
ES EM Speed(tokens/s) GPU(GB)  
StarCoder-1B 51.60 21.26 131.16 7\.  
\+BM25 52.69 23.03 64.29 10\.  
\+kt ran s-LM 52.05 22.13 70.11 14\.  
\+HyRACC 52.25 22.24 84.30 8\.  
\`\`\`  
\#\#\# VI. CONCLUSION ANDFUTUREWORK

\`\`\`  
In this paper, we propose HyRACC for efficient domain-  
adaptive code completion. HyRACC employs innovative hy-  
brid retrieval-augmented techniques to reduce response time  
and storage space. It also adaptively integrates model results  
and retrieval information through logits, enhancing perfor-  
mance in specific code domains. Notably, our framework op-  
erates without accessing model parameters, making it suitable  
for integration as plugins or for local deployment.  
\`\`\`  
\`\`\`  
64  
\`\`\`

Although HyRACC has shown promising results in current  
experiments, there are potential limitations. Our future work  
plans to further explore the efficiency of HyRACC on larger-  
scale models and across more code domains. Additionally, we  
will consider introducing a memory replacement mechanism  
to address the issue of frequent construction of token-level  
databases, thereby better serving other completion tasks such  
as function-level completion.

ACKNOWLEDGMENTS  
This work was supported by CCF-Huawei Populus Grove  
Fund. We want to thank the reviewers for their helpful  
comments.

\`\`\`  
REFERENCES  
1 OpenAI, Achiam, J., Adler, S., Agarwal, S., Ahmad, L.,  
Akkaya, I., Aleman, F. L., Almeida, D., Altenschmidt, J.,  
Altman, S., Anadkat, S.et al., “Gpt-4 technical report,”  
\`\`\`  
2024\. \[Online\]. Available: https://arxiv.org/abs/2303.  
2 Rozi\`ere, B., Gehring, J., Gloeckle, F., Sootla, S., Gat, I.  
et al., “Code llama: Open foundation models for code,”  
2024\. \[Online\]. Available: https://arxiv.org/abs/2308.  
3 Li, R., Allal, L. B., Zi, Y., Muennighoff, N., Kocetkov, D.,  
Mou, C., Marone, M., Akiki, C., Li, J., Chim, J.et al.,  
“Starcoder: may the source be with you\!” 2023\. \[Online\].  
Available: https://arxiv.org/abs/2305.  
4 Allal, L. B., Li, R., Kocetkov, D., Mou, C., Akiki, C.,  
Ferrandis, C. M., Muennighoff, N., Mishra, M., Gu, A.,  
Dey, M.et al., “Santacoder: don’t reach for the stars\!”  
2023\. \[Online\]. Available: https://arxiv.org/abs/2301.  
5 Guo, D., Zhu, Q., Yang, D., Xie, Z., Dong, K.,  
Zhang, W., Chen, G., Bi, X. et al., “Deepseek-coder:  
When the large language model meets programming –  
the rise of code intelligence,” 2024\. \[Online\]. Available:  
https://arxiv.org/abs/2401.  
6 Mallen, A., Asai, A., Zhong, V., Das, R., Khashabi, D.,  
and Hajishirzi, H., “When not to trust language  
models: Investigating effectiveness of parametric and  
non-parametric memories,” 2023\. \[Online\]. Available:  
https://arxiv.org/abs/2212.  
7 Carlini, N., Tramer, F., Wallace, E., Jagielski, M., Herbert-  
Voss, A., Lee, K., Roberts, A., Brown, T., Song, D.,  
Erlingsson, U., Oprea, A., and Raffel, C., “Extracting  
training data from large language models,” 2021\. \[Online\].  
Available: https://arxiv.org/abs/2012.  
8 Izacard, G., Lewis, P., Lomeli, M., Hosseini, L.,  
Petroni, F., Schick, T., Dwivedi-Yu, J., Joulin, A.,  
Riedel, S., and Grave, E., “Atlas: Few-shot learning with  
retrieval augmented language models,” 2022\. \[Online\].  
Available: https://arxiv.org/abs/2208.  
9 Zhao, P., Zhang, H., Yu, Q., Wang, Z., Geng, Y., Fu, F.,  
Yang, L., Zhang, W., Jiang, J., and Cui, B., “Retrieval-  
augmented generation for ai-generated content: A survey,”  
2024\. \[Online\]. Available: https://arxiv.org/abs/2402.  
10 Zhang, F., Chen, B., Zhang, Y., Keung, J., Liu, J.,  
Zan, D., Mao, Y., Lou, J.-G., and Chen, W., “Repocoder:

\`\`\`  
Repository-level code completion through iterative  
retrieval and generation,” 2023\. \[Online\]. Available:  
https://arxiv.org/abs/2303.  
11 Phan, H. N., Phan, H. N., Nguyen, T. N., and Bui, N.  
D. Q., “Repohyper: Search-expand-refine on semantic  
graphs for repository-level code completion,” 2024\.  
\[Online\]. Available: https://arxiv.org/abs/2403.  
12 Bogomolov, E., Zhuravlev, S., Spirin, E., and Bryksin, T.,  
“Assessing project-level fine-tuning of ml4se models,”  
\`\`\`  
2022\. \[Online\]. Available: https://arxiv.org/abs/2206.  
13 Dinella, E., Ryan, G., Mytkowicz, T., and  
Lahiri, S. K., “Toga: a neural method for test  
oracle generation,” in Proceedings of the 44th  
International Conference on Software Engineering, ser.  
ICSE ’22. ACM, May 2022\. \[Online\]. Available:  
\[http://dx.doi.org/10.1145/3510003.\](http://dx.doi.org/10.1145/3510003.)  
14 Nie, P., Banerjee, R., Li, J. J., Mooney, R. J.,  
and Gligoric, M., “Learning deep semantics for test  
completion,” 2023\. \[Online\]. Available: https://arxiv.org/  
abs/2302.  
15 Khandelwal, U., Levy, O., Jurafsky, D., Zettlemoyer, L.,  
and Lewis, M., “Generalization through memorization:  
Nearest neighbor language models,” 2020\. \[Online\].  
Available: https://arxiv.org/abs/1911.  
16 Tang, Z., Ge, J., Liu, S., Zhu, T., Xu, T., Huang, L., and  
Luo, B., “Domain adaptive code completion via language  
models and decoupled domain databases,” 2023\. \[Online\].  
Available: https://arxiv.org/abs/2308.  
17 Robertson, S. E. and Walker, S., “On relevance weights  
with little relevance information,” in Proceedings of  
the 20th Annual International ACM SIGIR Conference  
on Research and Development in Information Retrieval,  
ser. SIGIR ’97. New York, NY, USA: Association  
for Computing Machinery, 1997, p. 16–24. \[Online\].  
Available: https://doi.org/10.1145/258525.  
18 Robertson, S. and Zaragoza, H., “The probabilistic  
relevance framework: Bm25 and beyond,”Found. Trends  
Inf. Retr., vol. 3, no. 4, p. 333–389, Apr. 2009\. \[Online\].  
Available: https://doi.org/10.1561/  
19 Devlin, J., Chang, M.-W., Lee, K., and Toutanova, K.,  
“Bert: Pre-training of deep bidirectional transformers  
for language understanding,” 2019\. \[Online\]. Available:  
https://arxiv.org/abs/1810.  
20 Guo, D., Lu, S., Duan, N., Wang, Y., Zhou, M., and  
Yin, J., “Unixcoder: Unified cross-modal pre-training  
for code representation,” 2022\. \[Online\]. Available:  
https://arxiv.org/abs/2203.  
21 Drain, D., Hu, C., Wu, C., Breslav, M., and Sundaresan, N.,  
“Generating code with the help of retrieved template  
functions and stack overflow answers,” 2021\. \[Online\].  
Available: https://arxiv.org/abs/2104.  
22 Zhang, F., Chen, B., Zhang, Y., Keung, J., Liu, J.,  
Zan, D., Mao, Y., Lou, J.-G., and Chen, W., “Repocoder:  
Repository-level code completion through iterative  
retrieval and generation,” 2023\. \[Online\]. Available:  
https://arxiv.org/abs/2303.

\`\`\`  
65  
\`\`\`

23 Cheng, W., Wu, Y., and Hu, W., “Dataflow-guided retrieval  
augmentation for repository-level code completion,” 2024\.  
\[Online\]. Available: https://arxiv.org/abs/2405.  
24 Liu, T., Xu, C., and McAuley, J., “Repobench: Bench-  
marking repository-level code auto-completion systems,”

2023\. \[Online\]. Available: https://arxiv.org/abs/2306.  
25 Karpukhin, V., O ̆guz, B., Min, S., Lewis, P., Wu, L.,  
Edunov, S., Chen, D., and tau Yih, W., “Dense passage  
retrieval for open-domain question answering,” 2020\.  
\[Online\]. Available: https://arxiv.org/abs/2004.  
26 Vaswani, A., Shazeer, N., Parmar, N., Uszkoreit, J.,  
Jones, L., Gomez, A. N., Kaiser, L., and Polosukhin, I.,  
“Attention is all you need,” 2023\. \[Online\]. Available:  
https://arxiv.org/abs/1706.  
27 Jozefowicz, R., Vinyals, O., Schuster, M., Shazeer, N.,  
and Wu, Y., “Exploring the limits of language modeling,”  
2016\. \[Online\]. Available: https://arxiv.org/abs/1602.  
28 Radford, A., Narasimhan, K., Salimans, T., Sutskever, I.  
et al., “Improving language understanding by generative  
pre-training,” 2018\. \[Online\]. Available: https://openai.  
com/index/language-unsupervised  
29 Svyatkovskiy, A., Deng, S. K., Fu, S., and Sundaresan, N.,  
“Intellicode compose: Code generation using transformer,”  
2020\. \[Online\]. Available: https://arxiv.org/abs/2005.  
30 Peng, Y., Li, S., Gu, W., Li, Y., Wang, W., Gao, C.,  
and Lyu, M., “Revisiting, benchmarking and exploring  
api recommendation: How far are we?” 2021\. \[Online\].  
Available: https://arxiv.org/abs/2112.  
31 Lu, S., Guo, D., Ren, S., Huang, J., Svyatkovskiy, A.,  
Blanco, A., Clement, C., Drain, D., Jiang, D., Tang, D.,  
Li, G., Zhou, L., Shou, L., Zhou, L., Tufano, M., Gong, M.,  
Zhou, M., Duan, N., Sundaresan, N., Deng, S. K., Fu, S.,  
and Liu, S., “Codexglue: A machine learning benchmark  
dataset for code understanding and generation,” 2021\.  
\[Online\]. Available: https://arxiv.org/abs/2102.  
32 Ding, Y., Wang, Z., Ahmad, W. U., Ding, H., Tan, M.,  
Jain, N., Ramanathan, M. K., Nallapati, R., Bhatia, P.,  
Roth, D., and Xiang, B., “Crosscodeeval: A diverse and  
multilingual benchmark for cross-file code completion,”  
2023\. \[Online\]. Available: https://arxiv.org/abs/2310.  
33 Johnson, J., Douze, M., and Jegou, H., “Billion-scale  
similarity search with gpus,” IEEE Transactions on  
Big Data, p. 535–547, Jul 2021\. \[Online\]. Available:  
\[http://dx.doi.org/10.1109/tbdata.2019.\](http://dx.doi.org/10.1109/tbdata.2019.)  
34 Wang, C., Hu, J., Gao, C., Jin, Y., Xie, T., Huang, H.,  
Lei, Z., and Deng, Y., “Practitioners’ expectations  
on code completion,” 2023\. \[Online\]. Available: https:  
//arxiv.org/abs/2301.

\`\`\`  
66  
\`\`\`


\`\`\`  
Contents lists available at ScienceDirect  
\`\`\`  
\# Expert Systems With Applications

\`\`\`  
journal homepage: http://www.elsevier.com/locate/eswa  
\`\`\`  
\#\# Retrieval-augmented code completion for local projects using large

\#\# language models

\#\# Marko Hostnik a,b,∗, Marko Robnik-Šikonja a

a \_Faculty of Computer and Information Science, University of Ljubljana, Vecnaˇ pot 113, Ljubljana, 1000, Slovenia\_  
b \_Faculty of Mathematics and Physics, University of Ljubljana, Jadranska ulica 19, Ljubljana, 1000, Slovenia\_  
a r t i c l e i n f o  
\_2020 MSC:\_  
68T  
68T  
\_Keywords:\_  
Large language models  
Code completion  
Retrieval-augmented generation  
In-context retrieval  
a b s t r a c t  
The use of large language models (LLMs) is becoming increasingly widespread among software developers. How-  
ever, privacy and computational requirements are problematic with commercial solutions and the use of LLMs. In  
this work, we focus on using relatively small and efficient LLMs with 160M parameters that are suitable for local  
execution and augmentation with retrieval from local projects. We train two open transformer-based models, the  
generative GPT-2 and the retrieval-adapted RETRO, on open-source Python files, and empirically compare them,  
confirming the benefits of embedding-based retrieval. Furthermore, we improve our models’ performance with  
In-context retrieval-augmented generation (RAG), which retrieves code snippets using the Jaccard similarity of  
tokens. We evaluate In-context RAG on larger models and determine that, despite its simplicity, the approach is  
more suitable than using the RETRO architecture. Experimental results indicate that In-context RAG improves  
the code completion baseline by over 26%, while RETRO improves over the similarly sized GPT-2 baseline by  
12%. We highlight the key role of proper tokenization in achieving the full potential of LLMs in code completion.

\*\*1. Introduction\*\*  
    Programming with the help of large language models (LLMs)  
and other artificial intelligence (AI) tools is becoming increasingly  
widespread (Liang, Yang, & Myers, 2024 ). Programmers use AI tools  
(e.g., GitHub Copilot^1 ) to suggest next lines while writing code (Guo  
et al., 2024 ; Li et al., 2023 ; Rozière et al., 2024 ), to write tests and  
shorter or longer sections of code (Austin et al., 2021 ; Lu et al., 2021 ),  
and to facilitate learning new technologies (Kasneci et al., 2023 ).  
    As AI tools prove increasingly useful, code editor developers are  
rapidly incorporating AI into their products. However, the widespread  
adoption of AI tools raises concerns about code privacy, as code is  
transmitted to remote servers for processing by commercial models that  
can contain hundreds of billions of parameters (Brown et al., 2020 ).  
These large models require computational resources far beyond what  
ordinary consumer hardware provides, which is why a number of solu-  
tions that allow LLMs to run efficiently on consumer hardware are being  
developed.^2  
    However, the choice of a model size represents an important trade-  
off, as the model size has a significant impact on the quality of sugges-  
tions, the inference speed, and the utilization of compute and memory  
    ∗Corresponding author.  
\_E-mail addresses:\_ mh9533@student.uni-lj.si (M. Hostnik), marko.robnik@fri.uni-lj.si (M. Robnik-Šikonja).

(^1) https://github.com/features/copilot  
(^2) An example is available at https://github.com/ggerganov/llama.cpp.  
resources. While existing approaches have focused on improving sugges-  
tions using larger models augmented with retrieval from large retrieval  
datasets (Borgeaud et al., 2022 ), our approach differs in using small  
models augmented with only locally available project files.  
By focusing on a single programming language or solving just one  
specific programming task, such as line completion, smaller models can  
achieve useful results. Additionally, smaller models can speed up the  
performance of larger models through speculative decoding, where a  
larger model is used to correct the errors of a smaller model (Leviathan,  
Kalman, & Matias, 2023 ). In our work, we focus on the use of LLMs  
with fewer parameters to complete lines of Python code. This allows the  
model to be executed within the code editor on the user’s hardware, even  
without a graphics processing unit (GPU) to speed up the execution.  
LLMs take a string as input and predict its most probable continua-  
tion. Usually, the input string or \_context\_ is the content of the current file  
being edited. Programming projects are often composed of many files  
that refer to each other, so we want to enrich the context with infor-  
mation from other files in the project. However, as the context size of  
models is limited from a few dozen to a hundred lines of code, we need  
to find informative data to include in the context. In our work, we aug-  
ment the context of LLMs with relevant code snippets from other files  
https://doi.org/10.1016/j.eswa.2025.  
Received 8 August 2024; Received in revised form 1 April 2025; Accepted 11 June 2025  
Expert Systems With Applications 292 (2025) 128596  
Available online 14 June 2025  
0957-4174/© 2025 The Author(s). Published by Elsevier Ltd. This is an open access article under the CC BY license ( \[http://creativecommons.org/licenses/by/4.0/\](http://creativecommons.org/licenses/by/4.0/) ).

in the project, which we search for based on the similarity of vector  
embeddings, or alternatively based on the Jaccard similarity of tokens.  
The goal of our work is to experimentally verify the impact of retrieval-  
augmented LLMs on the success of completing lines of code. We focus  
on smaller models suitable for inference without a GPU and on retrieval  
only from local projects.  
Our proposed approach has widespread use cases in improving the  
coding experience for developers. Small coding LLMs can be used to  
offer intelligent code completion suggestions in various environments,  
such as in local text editors. In our work, we demonstrate how small  
LLMs can be improved and made more viable with retrieval-augmented  
generation (RAG) using a simple Jaccard similarity-based approach that  
doesn’t require expensive indexing for retrieving relevant code snippets  
from developers’ projects. Better code suggestions with smaller LLMs  
can not only help developers write code faster, but our approach does  
so while maintaining a focus on privacy without incurring additional  
costs of commercial LLMs.  
Our main contributions are as follows:

\- We train and compare 160 million parameter RETRO (Borgeaud  
    et al., 2022 ) and GPT-2 (Radford et al., 2019 ) models using two dif-  
    ferent tokenizers and verify the importance of token healing for code  
    completion.  
\- We compare In-context RAG with Jaccard-similarity-based retrieval  
    to RETRO with embedding-based retrieval and to baseline models of  
    different sizes.  
\- We examine the impact of copying from code snippets and the impact  
    of the retrieved snippets’ similarities to the retrieval query.  
\- We experimentally confirm the viability of augmenting small LLMs  
    with retrieval from local projects for local use in code editors.  
This paper is organized into six sections. In Section 2 , we present related  
work in retrieval-augmented code completion. In Section 3 , we present  
the main methods used, including an overview of the RETRO architec-  
ture (Borgeaud et al., 2022 ). In Section 4 , we describe the setup of our  
experiments, including the dataset, model training details, and metrics  
used. In Section 5 , we present and analyze the results of our trained  
models evaluated with retrieval from local projects. We conclude in Sec-  
tion 6 , where we also present ideas for further work.  
\*\*2. Related work\*\*  
The field of LLMs based on the transformer architecture (Vaswani  
et al., 2017 ) has been rapidly developing in recent years, not only for  
natural language processing but also for the processing of programming  
code. We present an overview of related work, split into four subsec-  
tions: LLMs for code, retrieval-augmented LLMs, retrieval-augmented  
code completion, and project based evaluation of code completion.  
\_2.1. Large language models for code\_  
Code generation is important for tasks such as code completion (Guo  
et al., 2024 ; Li et al., 2023 ; Rozière et al., 2024 ), generating code from  
natural language instructions (Austin et al., 2021 ), translating code  
from one programming language to another (Lu et al., 2021 ), and code  
searching based on natural language or code-based queries (Wang et al.,  
2023b). Neural models for code completion are mostly based on the de-  
coder part of the transformer architecture and differ mainly in the num-  
ber of parameters, the size of the context and the training data used (e.g.,  
the proportion of each programming language and inclusion of natural  
language) (Guo et al., 2024 ; Li et al., 2023 ). When training LLMs with  
longer context sizes, concatenating project files into the input context is  
becoming increasingly common (Guo et al., 2024 ; Rozière et al., 2024 ).  
This better prepares the model for including related files into the context  
during model execution.  
\_2.2. Retrieval-augmented language models\_  
The use of retrieval in LLMs is often motivated by the desire  
to improve models’ capabilities in open-domain question answering  
tasks (Patwardhan, Marrone, & Sansone, 2023 ). DPR (Karpukhin et al.,  
2020 ) and REALM (Guu, Lee, Tung, Pasupat, & Chang, 2020 ) extract  
the answer from the retrieved data using a BERT encoder (Devlin,  
Chang, Lee, & Toutanova, 2019 ). DPR fine-tunes the weights of the  
query encoder to better match its outputs with the frozen document  
encoder embeddings. REALM updates the weights of the knowledge  
retriever encoder during training, which causes computationally de-  
manding re-indexing of data during training. RAG (Lewis et al., 2020 )  
and FiD (Izacard & Grave, 2021 ) differ in the processing of the re-  
trieved snippets with additionally fine-tuned encoder-decoder models.  
Ram et al. ( 2023 ) show that retrieval is beneficial even without addi-  
tional training of models; it is sufficient to append the found snippets  
to the context of the decoder. \_𝑘\_ NN-LM (Khandelwal, Levy, Jurafsky,  
Zettlemoyer, & Lewis, 2020 ) computes a weighted sum of the predic-  
tions from an LLM and a \_𝑘\_ \-nearest neighbors classifier when predicting  
each token. RETRO (Borgeaud et al., 2022 ), described in Section 3.1,  
performs chunk-based retrieval and includes the found chunks in the  
decoder via cross-attention, which, in combination with a frozen doc-  
ument encoder, enables retrieval throughout the entire training of the  
model.  
\_2.3. Retrieval-augmented code completion\_  
Approaches for retrieval-augmented code completion are similar to  
those for natural language based open-domain question answering, with  
differences in the use of retrieval adapted to code and projects as a  
whole. ReACC (Lu et al., 2022 ) (and similarly REDCODER (Parvez, Ah-  
mad, Chakraborty, Ray, & Chang, 2021 )) combines retrieval with a code-  
adapted encoder, GraphCodeBERT (Guo et al., 2021 ), and classic BM-  
search (Harman, 1995 ), incorporating found snippets into the context.  
Shrivastava, Larochelle, and Tarlow ( 2023 ) use a trained classifier to  
select the most relevant code snippet from the project to include into  
the context. RepoCoder (Zhang et al., 2023b) demonstrates retrieval  
based on the Jaccard similarity of tokens for retrieving line-based snip-  
pets from the project and utilizes the generated code to improve sub-  
sequent retrieval. This approach is the motivation for our approach de-  
scribed in Section 3.3. RepoFormer (Wu, Ahmad, Zhang, Ramanathan,  
& Ma, 2024 ) enhances RepoCoder with adaptive retrieval triggered by  
the model with a special token. DRAG (Shapkin et al., 2024 ) extends the  
model’s vocabulary with new tokens from entities in the project that the  
model can use while generating code.  
\_2.4. Project based evaluation of code completion\_  
There are several datasets for evaluating code completion. Hu-  
manEval (Chen et al., 2021 ) involves completing functions from given  
function names and docstrings; CodeXGLUE (Lu et al., 2021 ) con-  
tains many datasets for various tasks, including line completion. These  
datasets only evaluate general code completion abilities within a sin-  
gle file, whereas real projects contain multiple interrelated files. Conse-  
quently, datasets for project-level completion have begun to emerge,  
often as an addition for evaluating the developed approach (Shap-  
kin et al., 2024 ). RepoBench (Liu, Xu, & McAuley, 2024 ) and Cross-  
CodeEval (Ding et al., 2023 ) compile evaluation sets by pre-selecting  
useful code snippets from related files that the model should include  
in the context. On the other hand, RepoEval (Zhang et al., 2023b)  
\- more in Section 4.3 – contains entire projects in addition to the  
marked lines that need to be completed, which allows the use of cus-  
tom implementations of retrieval from the project and consequently any  
model.

\*\*3. Code line completion methods\*\*  
    In this section, we describe our methodology for code line comple-  
tion based on LLMs. We first describe the retrieval-enhanced RETRO  
approach, followed by our improvements, the first concerning the tok-  
enization, and the second using context-based retrieval-augmented gen-  
eration.  
\_3.1. The RETRO approach\_  
    RETRO (Retrieval-Enhanced Transformer) is a transformer based  
autoregressive language model enhanced with additional snippets re-  
trieved from a database (Borgeaud et al., 2022 ). The approach splits the  
input token sequence into contiguous fixed-size chunks and finds snip-  
pets similar to the previous chunk when processing the current chunk.  
Introducing retrieval into the model allows adapting the model to new  
data without updating its weights, which is particularly useful for pre-  
dicting facts not present in the training set (e.g., names in a local pro-  
gramming project). For our experiments, we make minor modifications  
to the original RETRO architecture. We change the chunk embedding  
model from BERT (Devlin et al., 2019 ) to CodeT5+ (Wang et al., 2023b)  
and modify the hyperparameters described in Section 4.5. During infer-  
ence, we modify the input context by adding some padding tokens, us-  
ing token healing (see Section 3.2) and In-context RAG (see Section 3.3).  
Our RETRO approach is illustrated in Fig. 1\. Below, we explain the de-  
tails of the approach, relevant for our application.  
\_Language modeling with retrieval.\_ We denote the token vocabulary by the  
set 𝕍 obtained by a text tokenizer (see Section 4.1). The input token se-  
quence \_𝑥\_ \= ( \_𝑥\_ 1 \_,\_ ... \_, 𝑥𝑛\_ ) ∈𝕍 \_𝑛\_ of length \_𝑛\_ ∈ℕ is split into \_𝑙\_ ∈ℕ contiguous  
chunks \_𝐶\_ 1 \= ( \_𝑥\_ 1 \_,\_ ... \_, 𝑥𝑚\_ ) \_,\_ ... \_, 𝐶𝑙\_ \= ( \_𝑥𝑛\_ − \_𝑚\_ \+1 \_,\_ ... \_, 𝑥𝑛\_ ) of length \_𝑚\_ \= 64\. The  
probability of the next token \_𝑥𝑖\_ depends only on previous tokens and  
snippets retrieved by previous chunks:  
\_𝑃\_  
    (  
       \_𝑥𝑖\_ ∣ \_𝜃,\_ ( \_𝑥𝑗\_ ) \_𝑗\<𝑖,\_  
          (  
             Ret( \_𝐶𝑣\_ )  
                )  
                   \_𝑣\<𝑢𝑖\_  
                      )  
                         \_,\_  
where \_𝑢𝑖\_ \=⌈ \_𝑚𝑖\_ ⌉ is the index of the chunk containing \_𝑥𝑖\_ ,  
    (  
       Ret( \_𝐶𝑣\_ )  
          )  
             \_𝑣\<\_ 1 \=  
∅, \_𝜃\_ are the weights of the model, and Ret( \_𝐶𝑢\_ ) denotes the \_𝑘\_ retrieved  
snippets for \_𝐶𝑢\_ from the retrieval database .  
\_Retrieval.\_ The retrieval database is built by splitting the set of input doc-  
uments  into fixed-size chunks of \_𝑚\_ \= 64 tokens. The database stores  
key-value pairs, where the key is the embedding of a chunk of tokens \_N\_ ,  
and the value is a pair \[ \_𝑁, 𝐹\_ \], which contains both the chunk \_N\_ and the  
next immediate chunk \_F\_ in the original document. The retriever Ret( \_𝐶\_ )  
\*\*Fig. 1.\*\* Illustration of our RETRO approach. The CodeT5+ (Wang et al., 2023b)  
encoder is used for computing chunk embeddings for retrieval based on the \_𝐿\_ 2  
distance. The color coded arrows indicate which tokens attend to which re-  
trieved chunks – refer to Borgeaud et al. ( 2022 ) for more details on the chunked  
cross-attention (CCA) mechanism. During sampling, the input is padded to be a  
multiple of the chunk size.  
    finds the \_k\_ most similar snippets by comparing the \_𝐿\_ 2 distance between  
    the embedding of the chunk ( \_𝐶\_ ) and the database key ( \_𝑁\_ ).  
       Borgeaud et al. ( 2022 ) use the BERT model (Devlin et al., 2019 )  
    for , while we use the CodeT5+ encoder (Wang et al., 2023b), as  
    explained in Section 4.4. RETRO thus receives as input the input to-  
    kens \_x\_ and the \_k\_ nearest snippets of each input chunk Ret( \_𝐶𝑢\_ ) \=  
    (\[ \_𝑁\_^1 \_, 𝐹\_^1 \] \_,\_ ... \_,\_ \[ \_𝑁𝑘, 𝐹𝑘\_ \]). When training the model, we ensure that  
    Ret( \_𝐶𝑢\_ ) does not contain \_𝐶𝑢\_ \+1 by filtering out chunks \[ \_𝑁, 𝐹\_ \] that orig-  
    inate from the same training document as \_x\_.  
    \_The RETRO architecture.\_ The RETRO architecture is based on the  
    encoder-decoder transformer architecture (Vaswani et al., 2017 ). It dif-  
    fers from the decoder-only GPT-2 architecture by the addition of a bidi-  
    rectional encoder and a chunked cross-attention mechanism, which op-  
    erates on chunks and allows the inclusion of retrieved snippets into the  
    decoder. Splitting the input context into fixed-length chunks enables ef-  
    ficient chunk-based retrieval, providing more relevant examples for the  
    entire context and allowing for the encoder to independently process all  
    \_𝑘\_ retrieved snippets of chunks. Since the retriever itself is not updated  
    during training, it can be updated after the training is complete without  
    modifying the model weights. The RETRO model introduces Retro lay-  
    ers, which replace certain regular decoder layers. Following Borgeaud  
    et al. ( 2022 ), we place Retro layers at the sixth layer and then at every  
    subsequent third layer (e.g., at layers 6 \_,\_ 9 \_,\_ 12 , if there are 12 layers in  
    total).  
    \_Sampling with RETRO.\_ Just as the architecture of RETRO influences the  
    construction of the retrieval database and chunked cross-attention, it  
    also impacts sampling from the model. When sampling from RETRO, we  
    pad the context to make sure it is a multiple of the chunk size \_𝑚\_ (Wang  
    et al., 2023a). This allows RETRO to retrieve based on the last \_𝑚\_ tokens  
    in the context, as otherwise predicting within the first chunk would not  
    be improved by retrieval and tokens in the last chunk of the context  
    would not be used for retrieval despite being most relevant to predicting  
    the next token. When generating longer texts, an additional question is  
    how often to perform retrieval. In our experiments, we limit the task to  
    code completion until the end of a line, so retrieval is performed only  
    before the first step of text generation or whenever the context length  
    reaches a multiple of the chunk size.  
    \_3.2. Token healing\_  
       The use of subword tokenization can, in certain cases, lead to unde-  
    sirable effects during text generation, especially when completing lines  
    of code starting at unnatural word boundaries. Due to the commonly  
    used byte pair encoding (BPE) tokenization algorithm (Sennrich, Had-  
    dow, & Birch, 2016 ), some substrings appear in multiple tokens. Conse-  
    quently, if the input string \_𝑠\_ ends with a substring that is the beginning  
    of some token, the output probability distribution for the next token will  
    be biased (Dagan, Synnaeve, & Roziere, 2024 ). The tokenization of the  
    string \_𝑠\_ may end with a token that would be merged with the token we  
    are predicting in the BPE algorithm. As a result, tokens that continue  
    the tokenized string \_𝑠\_ have a higher probability than tokens that would  
    better complete the string \_𝑠\_ truncated by the last token. In addition,  
    without a corrective measure, called token healing, \_𝑠\_ may be an out-of-  
    distribution example, leading to unpredictable completion results, since  
    the model has not encountered such unnatural cut-off boundaries during  
    training.  
       We solve this problem by finding and removing the longest suffix \_𝑡\_  
    in the input string \_𝑠\_ \= \_𝑠\_ ′⋅ \_𝑡\_ that is a prefix of some token \_𝑥𝑖\_ ∈𝕍, \_𝑥𝑖\_ \=  
    \_𝑡\_ ⋅ \_𝑥\_ ′ \_𝑖\_ (Athiwaratkun et al., 2024 ; Dagan et al., 2024 ). During decoding,  
    we then constrain the output probability distribution for the next token  
    only to tokens that match the prefix of \_𝑡\_. When we generate \_𝑡\_ in its  
    entirety, we no longer constrain the output distribution. We illustrate  
    the token healing process in Fig. 2 (a) and show its practical impact in  
    Fig. 2 (b). We observe a significant impact largely due to the choice of the  
    evaluation dataset, which begins code completion at a random position  
    within the line.

\*\*Fig. 2.\*\* Fig. 2 (a) shows an example of token healing using a small four token vocabulary. With token healing, the input is rolled back by one token and the output  
distribution is constrained to tokens that start with wo, improving over the prediction without token healing. In Fig. 2 (b), we compare code completion results  
(without retrieval) with respect to the use of token healing using three different 160 million parameter LLMs that we evaluate in Section 5\. The experiments are  
performed on the evaluation set lineR described in Section 4.3. The Prefix Similarity (PS) metric is defined in Section 4.7 (higher values are better).  
\_3.3. In-context RAG\_  
A simpler alternative for retrieval-augmented code completion, com-  
pared to RETRO, is to include similar code snippets directly into the  
model’s context. This eliminates the additional complexity of the RETRO  
architecture, as the In-context RAG method can be used with any autore-  
gressive LLM (Lu et al., 2022 ; Ram et al., 2023 ; Zhang et al., 2023b).  
Let \_𝑥\_ \= ( \_𝑥\_ 1 \_,\_ ... \_, 𝑥𝑛\_ ) ∈𝕍 \_𝑛\_ be the input sequence of tokens. From \_𝑥\_ , we  
construct a query \_𝑞\_ from the last \_𝑚\_ ∈ℕ tokens, \_𝑞\_ \= ( \_𝑥𝑛\_ − \_𝑚\_ \+1 \_,\_ ... \_, 𝑥𝑛\_ ), and  
use it to search for the \_𝑘\_ nearest code snippets from the database . The  
tokens of the found snippets Ret( \_𝑞\_ ) \= ( \_𝑟\_ 1 \_,\_ ... \_, 𝑟𝑘\_ ) are concatenated into  
a sequence of tokens \_𝑟\_ \= \_𝑟\_ 1 ⋅...⋅ \_𝑟𝑘\_. The new context for the model is  
then \_𝑥\_ ′\= \_𝑟\_ ⋅ \_𝑥\_ , which is used to predict the next tokens. The process is  
illustrated in Fig. 3\.  
Individual retrieved snippets \_𝑟𝑖\_ can be further enhanced, for ex-  
ample by adding metadata about the original file, such as \_𝑟\_ ′ \_𝑖\_ \= \#  
path/to/file.py\\n ⋅ \_𝑟𝑖\_. Unlike RETRO, this approach is not limited to  
retrieving fixed size chunks. We can also dynamically adjust the number  
of retrieved snippets \_𝑘\_ based on the remaining size of the input context.  
The retrieval database  and the query \_𝑞\_ need not be constructed based  
on fixed-length chunks of tokens; instead, the data can be chunked based  
on lines or logical code parts, such as functions. In our experiments, to  
make a fair comparison, we use fixed chunks as in the RETRO approach.  
As with RETRO, the retriever Ret only returns examples that are not  
from the same file as \_𝑥\_.  
As with the RETRO approach, the retriever Ret( \_𝑞\_ ) could operate  
based on the distance between the embedding of the query and chunks  
from the database \_𝑟𝑖\_ ∈, \_𝑑\_ (( \_𝑟𝑖\_ ) \_,\_ ( \_𝑞\_ )). We decided on a simpler ap-  
proach that works solely based on the Jaccard similarity of tokens and  
not on embeddings. The Jaccard similarity coefficient \_𝐽\_ is used over  
the set \_𝑄\_ of tokens from the query \_𝑞\_ and the set \_𝑅\_ of tokens from the  
retrieved snippet \_𝑟𝑖\_ ,  
\_𝐽\_ ( \_𝑄, 𝑅\_ ) \=| \_𝑄\_ ∩ \_𝑅\_ |  
| \_𝑄\_ ∪ \_𝑅\_ |  
\_.\_  
The retriever Ret thus finds code snippets that have the highest sim-  
ilarity between the query \_𝑞\_ and the chunks in the database . We pre-  
fer this approach because it does not require an additional model to  
compute embeddings, making it more suitable for efficient execution  
on limited hardware and with local projects.

\*\*4. Experimental settings\*\*  
    In this section, we present the datasets, evaluation metrics, and  
experimental settings used to verify if retrieval-augmented code com-  
pletion can enhance the performance of LLMs when working on local  
projects. Since we aim to run models on local hardware, we focus on  
smaller models and efficient retrieval and text generation methods. We  
assess the impact of retrieval by comparing GPT-2, RETRO, and the In-  
context RAG approach that incorporates found snippets into the context  
\*\*Fig. 3.\*\* Our In-context RAG approach based on the Jaccard similarity of chunks of tokens. The retrieved snippet contains continuation tokens and additional metadata  
about the origin file, while the key for comparing with the query is a fixed length chunk.

\*\*Table 1\*\*  
Tokenizations of the string def foo(): \\n  
pass. Tokens are comma separated. The StarCoder  
tokenization requires fewer tokens due to the merg-  
ing of whitespace characters into a single token.  
Tokenization Tokens  
GPT-2 (def, foo, ():, \\n, , , , pass)  
StarCoder (def, foo, ():, \\n , pass)  
of models without modifying the model architecture or training process.  
We split the section into seven parts: tokenization, training and evalu-  
ation dataset descriptions, retrieval database, model architecture with  
hyperparameters, training of models, and used comparison metrics. The  
results are reported in Section 5\.  
\_4.1. Tokenization\_  
We compare two subword tokenization methods based on the BPE  
algorithm (Sennrich et al., 2016 ) with differing vocabularies. The first  
version of the vocabulary with 50 257 tokens was trained on a diverse  
textual dataset obtained from web sources used in the GPT-2 paper (Rad-  
ford et al., 2019 ). The second version of the vocabulary with 49 152 to-  
kens was trained on a collection of open-source code from various pro-  
gramming languages reported in the StarCoder paper (Li et al., 2023 ).  
Since we work on the code completion task, the use of tokenization from  
the StarCoder paper shall be more appropriate than using a vocabulary  
more suitable for natural language processing.  
The main drawback of using the text-based GPT-2 vocabulary for  
code completion is an inefficient handling of whitespaces. In most cases,  
each space in a longer sequence of spaces is represented by its own to-  
ken, which significantly reduces the number of useful tokens available in  
the model’s context during the self-attention computation. An example  
is in Table 1\. In addition to less useful data in the model’s context, the  
inefficient tokenization of consecutive spaces also affects the amount of  
information in each chunk of the retrieval database, as the database is  
built with a fixed number of tokens per chunk.  
\_4.2. The StarCoder dataset\_  
For training our models, we use the StarCoder dataset^3 (Li et al.,  
2023 ). The dataset contains over 300 million open-source files from  
more than 80 programming languages, but we use only files in the  
Python programming language. We split the dataset into a training and  
test set in ratio 90%; 10%. We split the data at the project level and  
not at the file level, so that all files belonging to a project are placed in  
the same training or test set. The validation set is constructed from 1%  
of the test set and is used to monitor metrics during model training to  
detect any potential overfitting (which we did not observe). After train-  
ing, we evaluate the models’ performance on both the test set and the  
evaluation sets as described in Section 4.3. Table 2 summarizes the sizes  
of the training and test sets.  
\_4.3. The RepoEval dataset\_  
For the evaluation of retrieval-augmented line completion on real  
projects, we use the RepoEval dataset (Zhang et al., 2023b), which con-  
tains eight open-source projects from various domains and is divided  
into three evaluation sets: line, api, and function. The line set con-  
tains randomly selected individual lines, while the api set contains lines  
with application programming interface (API) calls to objects defined  
within the project. These calls can be longer than a single line (10%  
of examples contain at least 5 lines). The function set is intended for

(^3) Available at https://huggingface.co/datasets/bigcode/starcoderdata.  
\*\*Table 2\*\*  
Size of the training and test sets composed from the  
Python part of the StarCoder dataset.  
Split \# Files \# Projects Total file size  
Training set 11 579 885 1 510 155 56 GiB  
Test set 1 286 653 168 449 6 GiB  
Total 12 866 538 1 678 604 62 GiB  
completing function bodies, but we do not use it as it requires complet-  
ing up to 30 lines and evaluation is performed by executing the projects’  
unit tests.  
In both cases, line and api, the goal is to predict the entire next line  
or function call. We want to use our models in a code editor even when  
the cursor is in the middle of a line, while the user is typing. Therefore,  
we also evaluate the models’ performance on lineR and apiR, where  
we use the model to complete code from a random position within the  
line to the end of the original example. More details on lineR and apiR  
can be found in Appendix B and an example in Fig. 4\.  
When evaluating LLMs, there is often the issue of the evaluation set  
being present in the training set, as training sets are frequently obtained  
by scraping massive amounts of data from the web. Therefore, we check  
the overlap between RepoEval and our StarCoder training dataset and  
find that three of the eight projects in RepoEval are also present in the  
training set (the project with the most overlap is \_alibaba/FederatedScope\_ ,  
with 48% of its files contained in StarCoder). In the resulting line’,  
lineR’, api’, and apiR’ datasets, we remove these three projects that  
overlap with the training set.  
When simulating and evaluating line completion using the RepoE-  
val dataset, the input context for models without retrieval contains only  
the lines before the target line within a single file. With retrieval, the  
retrieval database is built only from individual projects (we do not use  
the entire StarCoder training set). In our experiments, all text is gener-  
ated using greedy decoding to achieve determinism and faster execution  
when completing short lines of code.  
\_4.4. Retrieval database\_  
To train the RETRO approach, we need a database to search for the  
\_𝑘\_ \-nearest chunks of each input chunk of tokens. In line with Borgeaud  
et al. ( 2022 ) and Wang et al. (2023a), we use the training dataset as  
the retrieval database. This ensures a fair comparison between RETRO,  
\*\*Fig. 4.\*\* An example of the In-context RAG approach described in Fig. 3 on our  
lineR subset of RepoEval starting completion from a random position in the tar-  
get line. The example highlights the importance of including chunk continuation  
tokens along with the retrieved chunk.

which uses retrieval during training, and GPT-2, which does not. Using  
any other additional dataset, RETRO would have an advantage, as it  
would have access to a larger amount of data during training.  
For building the retrieval database, we use a chunk size of \_𝑚\_ \= 64  
tokens and the CodeT5+ (Wang et al., 2023b) encoder for computing  
chunk embeddings. To enable faster retrieval of the \_𝑘\_ \-nearest chunks,  
we index the stored embeddings with Faiss (Johnson, Douze, & Jégou,  
2021 ) as described in Appendix D. The pretrained CodeT5+ encoder  
has 110 million parameters, generates normalized 256-dimensional em-  
beddings and was trained on various code tasks. We also experimented  
with using the BERT-large encoder with 340 million parameters and  
1024-dimensional vector embeddings, as done by Borgeaud et al. ( 2022 )  
and described in Appendix C. However, we opt for the CodeT5+ en-  
coder since it has fewer parameters, outputs smaller dimensional em-  
beddings, and is trained for code understanding, making it a better fit  
for our use case.  
\_4.5. Model architecture\_  
In accordance with Borgeaud et al. ( 2022 ) and Wang et al. (2023a),  
we compare GPT-2 with RETRO, keeping the architecture of both mod-  
els identical except that RETRO includes both an encoder and decoder  
compared to GPT-2 which is a decoder only model. Table 3 summa-  
rizes the number of parameters in our models as well as the number  
of decoder layers. To compare models with roughly equal number of  
parameters, we also compare GPT-2 with 9 decoder layers to RETRO  
with 6 decoder layers; this comparison shall ensure that any potential  
benefit of RETRO does not arise simply from increasing the number of  
parameters when adding the chunk encoder.  
\_Hyperparameters.\_ We set the hidden dimension \_𝑑\_ to 1024, and the num-  
ber of heads in the multi-headed attention to 16, so that each head pro-  
cesses vectors of dimension 64\. The number of decoder layers is shown  
in Table 3\. Retro layers with the retrieval capability are placed at the  
sixth layer and then at every subsequent third layer (e.g., layers 6 \_,\_ 9 \_,\_ 12  
if there are 12 layers). The encoder in RETRO has two layers. The maxi-  
mum length of the input context is limited to 384 tokens as in Semenkin,  
Sokolov, and Vu ( 2024 ). Instead of fixed absolute positional embed-  
dings, we use relative positional embeddings RoPE (Su et al., 2024 )  
with a rotational factor of 0\_.\_ 5\. For the nonlinear function within fully  
connected feed-forward networks, we use the SwiGLU function, which  
has been shown to contribute to better learning outcomes in language  
modeling tasks (Shazeer, 2020 ; Touvron et al., 2023 ). We use shared  
weights for the input and output embedding tables to reduce the total  
number of parameters (Press & Wolf, 2017 ; Vaswani et al., 2017 ).  
\_4.6. Model training\_  
All training hyperparameters are the same for both models, GPT-  
and RETRO. For optimization, we use the Adam algorithm (Kingma &  
Ba, 2015 ) with \_𝛽\_ 1 \= 0\_.\_ 9 and \_𝛽\_ 2 \= 0\_.\_ 95\. The learning rate is set to 6 × 10−  
and is reduced using a cosine scheduler by a factor of 10 by the end of  
\*\*Table 3\*\*  
The number of parameters of our GPT-2 and RETRO  
models when using GPT-2 tokenization. The relative  
change in the number of parameters is shown in paren-  
theses. When using the StarCoder tokenization, the  
number of parameters for all models decreases by a  
constant two million parameters due a smaller vocab-  
ulary, which affects the number of parameters in the  
transformer’s embedding table.  
\# Decoder layers GPT-2 RETRO  
6 126 M \*\*160 M\*\* (+30%)  
9 \*\*164 M\*\* /  
12 201 M 243 M (+21%)  
\*\*Table 4\*\*  
The number of training iterations. Training on eight  
A100 40 GB GPUs took 2 hours for the smaller num-  
ber of iterations and 38 hours for the larger number of  
iterations.  
Tokenization Batch size \# Iterations \# Tokens  
GPT-2 384 20 312 3\_.\_ 0 × 10^9  
GPT-2 496 379 032 72\_.\_ 2 × 10^9  
StarCoder 384 15 234 2\_.\_ 2 × 10^9  
StarCoder 512 367 187 72\_.\_ 2 × 10^9  
training. For regularization, we use dropout layers with a probability of  
0\_.\_ 1 , and the weight decay factor is 0\_.\_ 01\. Table 4 summarizes the num-  
ber of training iterations. For comparing models of all sizes (6, 9, and  
12 layers), we conduct training on a smaller number of iterations. For  
comparing the final models of sizes 6 and 9 layers, we conduct training  
on the larger number of iterations.  
\_Implementation details.\_ Our implementation of RETRO and GPT-2 fol-  
lows the open-source implementation of both models by Wang et al.  
(2023a), which is in turn based on the original work by Borgeaud et al.  
( 2022 ). For model training, we use the Megatron-LM framework, which  
is optimized for training LLMs on multiple GPUs that can be distributed  
across multiple compute nodes (Narayanan et al., 2021 ). In our case, all  
model training and data processing are conducted on a compute node  
with eight A100 40 GB GPUs. Model training and execution on GPUs is  
performed using the \_bf16\_ floating-point format.  
\_4.7. Metrics\_  
For evaluating LLMs, we use different metrics for single-token and  
multi-token predictions. Single-token metrics are used to monitor model  
training because they are simple and efficient to compute. To assess  
multi-token predictions, we compare the generated output with the tar-  
get output.  
\_4.7.1. Single-token metrics\_  
During model training, we use perplexity (PPL), recall-at-k (Rk) and  
mean reciprocal rank (MRR \_𝑘\_ ) metrics (Jurafsky & Martin, 2009 ; Zhang,  
Lipton, Li, & Smola, 2023a). While PPL is a widespread metric, we find  
that recall-based metrics provide more intuitive interpretations of re-  
sults compared to PPL.  
Let \_𝑥\_ \= ( \_𝑥\_ 1 \_,\_ ... \_, 𝑥𝑛\_ ) ∈𝕍 \_𝑛\_ be a sequence of tokens. Perplexity PPL ∈  
\[1 \_,\_ ∞) measures the model’s uncertainty about the data and is defined  
as  
PPL( \_𝑥\_ ) \= exp{−^1 \_𝑛\_  
∑ \_𝑛  
𝑡\_ \=  
log \_𝑃𝜃\_  
(  
\_𝑥𝑡\_ ∣ \_𝑥𝑡\_ −1 \_,\_ ... \_, 𝑥\_ 1  
)  
} \_,\_  
where log \_𝑃𝜃\_  
(  
\_𝑥𝑡\_ ∣ \_𝑥𝑡\_ −1 \_,\_ ... \_, 𝑥\_ 1  
)  
is the log-probability for token \_𝑥𝑡\_ , as pre-  
dicted by the model with parameters \_𝜃\_. We aim to minimize PPL to its  
optimal value of 1, which is achieved when the model correctly predicts  
each token with a probability of 1\.  
For easier interpretation, we also use recall metrics that summarize  
the probability that the predicted token is one of the correct tokens.  
Let \_̂𝑦𝑖\_ ∈ℝ|𝕍| be the output distribution of the next token after \_𝑥𝑖\_ , sorted  
by descending probability (i.e., the first element of \_̂𝑦𝑖\_ corresponds to the  
most probable next token). Then, rank \_𝑖\_ is the index in \_̂𝑦𝑖\_ that corresponds  
to the next token \_𝑥𝑖\_ \+1.  
The recall-at- \_𝑘\_ metric, Rk∈ \[0 \_,\_ 1\], equals 1 for \_𝑥𝑖\_ if \_𝑥𝑖\_ \+1 is among the  
\_𝑘\_ most probable suggested tokens. For the entire \_𝑥\_ , we take the average  
Rk=^1 \_𝑛\_  
∑ \_𝑛  
𝑖\_ \=  
1  
(  
rank \_𝑖\_ ≤ \_𝑘\_  
)  
\_.\_  
Rk can be interpreted as the probability that the next token is among  
the \_𝑘\_ most probable predicted tokens.

The Mean Reciprocal Rank MRR \_𝑘\_ ∈ \[0 \_,\_ 1\] is defined as  
MRR \_𝑘\_ \=^1 \_𝑛\_  
∑ \_𝑛  
𝑖\_ \=  
1  
rank \_𝑖,\_

where (^) rank^1  
\_𝑖\_  
equals 0 if rank \_𝑖\> 𝑘\_. We aim to maximize Rk and MRR \_𝑘\_ to  
their optimal value of 1\. When comparing single-token metric results,  
we must be cautious when comparing results obtained with different  
tokenizations, as the size and content of the vocabularies affect the ob-  
tained values.  
\_4.7.2. Multi-token predictions\_  
For multi-token predictions, we evaluate the quality of code comple-  
tion, not only based on the prediction of the next token, but on gener-  
ating multiple tokens. We calculate metrics on \_strings\_ , removing leading  
and trailing whitespace from the strings (Lu et al., 2022 ; Zhang et al.,  
2023b).  
Let \_𝑠\_ be the model’s prediction and \_𝑡\_ the target string. Exact Match  
EM( \_𝑠, 𝑡\_ ) ∈ {0 \_,\_ 1} is 1 if the strings \_𝑠\_ and \_𝑡\_ match exactly and 0 otherwise.  
Edit Similarity ES( \_𝑠, 𝑡\_ ) ∈ \[0 \_,\_ 1\] considers how many edits are needed to  
transform \_𝑠\_ into \_𝑡\_ :  
ES( \_𝑠, 𝑡\_ ) \= 1 −  
lev( \_𝑠, 𝑡\_ )  
max(| \_𝑠\_ | \_,\_ | \_𝑡\_ |) \_,\_  
where lev is the Levenshtein distance (Levenshtein et al., 1966 ). When  
combining multiple pairs ( \_𝑠, 𝑡\_ ) from a sample of predicted and target re-  
sults  for EM and ES, we calculate the average, EM \=^1 \_𝑛\_ ∑( \_𝑠,𝑡\_ )∈EM( \_𝑠, 𝑡\_ )  
and similarly ES \=^1 \_𝑛\_ ∑( \_𝑠,𝑡\_ )∈ES( \_𝑠, 𝑡\_ ).  
Prefix Similarity PS( \_𝑠, 𝑡\_ ) ∈ \[0 \_,\_ 1\] measures the prefix matching of  
characters in the strings \_𝑠\_ and \_𝑡\_. For PS ∈ \[0 \_,\_ 1\], we take into account  
that lines of code have different lengths when combining multiple ex-  
amples:  
PS \=  
∑  
( \_𝑠,𝑡\_ ∑)∈| \_𝜋\_ ( \_𝑠, 𝑡\_ )|  
(⋅ \_,𝑡\_ )∈| \_𝑡\_ |  
\_,\_  
where \_𝜋\_ ( \_𝑠, 𝑡\_ ) denotes the longest common prefix of \_𝑠\_ and \_𝑡\_. We aim to  
maximize all three metrics EM, ES, and PS to their optimal value of 1\.  
When reporting multi-token prediction metrics, we calculate 95%  
confidence intervals obtained using the BCa (Efron, 1987 ) bootstrap  
method with 1000 samples. The notation a \_𝑐𝑏\_ means that \_𝑎\_ is the cal-  
culated metric on the sample, and \_𝑏\_ and \_𝑐\_ are the endpoints of the con-  
fidence interval \[ \_𝑏, 𝑐\_ \].

\*\*5. Results\*\*  
    In this section, we report the results of experiments outlined in Sec-  
tion 4\. We start by comparing the performance of RETRO and GPT-  
on the StarCoder dataset, followed by the evaluation on the RepoEval  
dataset, which simulates retrieval from local projects. In this setting, we  
also compare the In-context RAG approach. We finish the section with  
a qualitative analysis of the results.  
    \_5.1. Evaluation on the StarCoder test set\_  
       In this section, we present the results of our trained models on the test  
    set from Section 4.2. We are interested in the contribution of retrieval  
    with RETRO compared to the baseline GPT-2 model. We first examine  
    the impact of the retrieval database size, tokenization, and the number  
    of parameters on model performance. We also compare retrieval from  
    the training and test set simulating different numbers of projects in a  
    local database.  
       First, we examine the results of single-token metrics on the test set.  
    When reporting metrics for RETRO, the retrieval database is built from  
    the union of the training and test sets, while during training only the  
    training set is used (Borgeaud et al., 2022 ; Wang et al., 2023a). If re-  
    trieval from the test set was forbidden, RETRO would not be able to  
    find related code snippets from the same project as the test example,  
    due to the project-level split into training and test sets. We also re-  
    port metrics calculated starting from the end of the first RETRO chunk  
    \_𝑥\_ ≥^64 \= ( \_𝑥\_ 64 \_,\_ ... \_, 𝑥𝑛\_ ) instead of the entire input sequence \_𝑥\_ \= ( \_𝑥\_ 1 \_,\_ ... \_, 𝑥𝑛\_ ).  
    For the first \_𝑚\_ − 1 \= 63 tokens, RETRO does not use retrieval and there-  
    fore functions like the baseline model. The notation GPTgpt 6 refers to  
    the GPT-2 model with 6 layers and GPT-2 tokenization, while GPTSC 6  
    refers to the using the model with StarCoder tokenization (and similarly  
    RETROgpt 6 for RETRO).  
       In Fig. 5 we compare our models of all sizes trained on a smaller  
    number of iterations and in Table 5 we report the single-token metrics  
    of our smaller sized models trained over more iterations. In all cases we  
    observe that the single-token metrics for RETRO are better than those  
    for GPT-2 of comparable size. However, the difference between the two  
    models decreases when comparing models with approximately equal  
    number of parameters, i.e. RETRO with 6 layers to GPT-2 with 9 layers,  
    as seen in Table 5\. In Table 5 we observe that the differences between  
    RETRO and GPT-2 are higher when calculating metrics from token 64  
    onwards, suggesting the usefulness of the retrieval mechanism. Increas-  
    ing the number of layers and thus the number of model parameters also  
    contributes to improvements in metrics, as is evident from Fig. 5\. How-  
    ever, by training smaller models over more iterations, we achieve better  
    metrics than using larger models trained for fewer iterations. The rel-  
    ative differences are larger in bigger models, which may be due to the  
    use of more Retro layers, as well as the effect of 21% more parameters  
    in RETROgpt 12 compared to GPTgpt 12\.  
       We hypothesize that the significant differences in single-token met-  
    rics between GPT-2 and StarCoder tokenization are due to the different  
    vocabularies making direct comparison of results less meaningful, so we  
    should instead compare relative differences. Nevertheless, we surmise  
    that GPT-2 tokenization achieves better single-token metrics in Fig. 5  
    and Table 5 due to the whitespace issue from Table 1 , as the model  
    gets “easy points” by predicting individual spaces. Despite larger abso-  
    lute differences in individual metrics between GPT-2 and StarCoder tok-  
    enization, the relative differences in Fig. 5 and in Table 5 are of compa-  
    rable magnitude, suggesting a similar contribution of RETRO regardless  
    of the tokenization used.  
\*\*Table 5\*\*  
Single-token metrics on the test set with models trained on a \*\*larger\*\* number of iterations (see Table 4 ). Reported are  
also the relative differences of metrics compared to the baseline GPT-2 models.  
Offset \_𝑥\_ ≥^64  
Model PPL R 1 R 5 MRR 5 PPL R 1 R 5 MRR 5  
GPTgpt 6 2.708 79.27 90.25 83.74 2.445 80.97 91.41 85\.  
GPTgpt 9 2.602 79.95 90.69 84.33 2.347 81.67 91.85 85\.  
\-3.91% 0.85% 0.49% 0.70% \-4.01% 0.86% 0.48% 0.69%  
RETROgpt 6 2.536 80.40 91.11 84.78 2.257 82.23 92.46 86\.  
\*\*-6.35% 1.43% 0.95% 1.24% \-7.69% 1.56% 1.19% 1.47%\*\*  
GPTSC 9 3.946 70.66 86.54 77.07 3.433 73.06 88.18 79\.  
RETROSC 6 3.855 70.98 86.98 77.45 3.293 73.65 88.87 79\.  
\*\*-2.30% 0.45% 0.51% 0.49% \-4.08% 0.81% 0.78% 0.82%\*\*

\*\*Fig. 5.\*\* PPL and MRR 5 metrics on the test set with models trained on a \*\*smaller\*\* number of iterations (see Table 4 ) with \_GPT-2\_ tokenization on the left and \_StarCoder\_  
tokenization on the right. For each model, the left bar shows PPL and the right bar shows MRR 5\. Reported metrics are calculated on the offset input \_𝑥\_ ≥^64. The values  
of the left and right results should not be directly compared due to different tokenizations. The figures also show the models’ sizes.  
\*\*Fig. 6.\*\* Distribution of relative improvement in PPL between RETROgpt 6 and  
GPTgpt 9 on 500 projects from our StarCoder test set based on the used retrieval  
database.  
\_Projects in a local database.\_ For practical local use of RETRO, a small  
number of parameters would not be beneficial if we needed a retrieval  
database with a billion tokens to see benefits. Therefore, we examine  
the contribution of RETRO using retrieval databases constructed from  
\_individual\_ projects in the test set by sampling 500 projects, such that the  
projects are evenly distributed with respect to the number of files, up to  
a maximum of 300 files.  
In Fig. 6 , we compare the relative improvement of RETROgpt 6 against  
GPTgpt 9 on projects using different retrieval databases. We limit the com-  
parison to RETRO with 6 layers and GPT-2 with 9 layers to reduce the  
impact of the difference in the model sizes. Retrieving from the entire  
StarCoder training set contributes to a greater improvement compared  
to retrieving only from individual projects, which is consistent with the  
findings of Borgeaud et al. ( 2022 ), who observe improvements with  
increasing the retrieval database size. We also test retrieval from the  
project without removing snippets originating from the same file as the  
input context, which gives an upper bound estimate for RETRO since  
the found snippets contain the correct next tokens. As expected, the dif-  
ference with GPT-2 is in this case more significant, but it does not reach  
a perfect success rate. A lower bound estimate for RETRO is obtained  
when we retrieve random chunks from the entire training set. In this  
case, we observe that the 6-layer RETROgpt 6 performs worse than the  
9-layer GPTgpt 9 , which is expected, as it does not benefit from retrieval  
and consequently behaves as a 6-layer GPT-2 with added noise.  
From Table 6 , we see that the single-token metrics using only  
RETROgpt 6 with the training set (without the test set) for retrieval are  
comparable to those of GPTgpt 9\. This can be attributed to the fact that re-  
trieving from the training set does not provide new information, as both  
models have seen the entire training set during training. We therefore  
conclude that retrieval is only meaningful on new, previously unseen  
data for the model. When retrieving from projects, the data is new,  
as the projects are sampled from the test set. An implication of this  
\*\*Table 6\*\*  
Comparison of the relative improvement of single-token metrics between  
RETROgpt 6 in GPTgpt 9 on 500 projects from the test set with respect to the  
used retrieval database. The metrics are in percentages, contain 95-percent  
confidence intervals and are calculated on the offset input \_𝑥\_ ≥^64.  
Retrieval database ΔPPL ΔR 1 ΔR 5 ΔMRR 5  
Project 0.86^10 \_..\_^3642 0.12^00 \_..\_^2301 0.24^00 \_..\_^3117 0.18^00 \_..\_^2709  
Training set \-0.05+0−0 \_..\_^3745 \-0.03+0−0 \_..\_^0712 0.12^00 \_..\_^1806 0.05+0−0 \_..\_^1303  
Training \+ test set \*\*2.61\*\*^32 \_..\_^0415 \*\*0.53\*\*^00 \_..\_^6443 \*\*0.51\*\*^00 \_..\_^5844 \*\*0.54\*\*^00 \_..\_^6345  
Project \_(without filtering)\_ 28.59^2927 \_..\_^3989 7.19^76 \_..\_^4499 4.78^44 \_..\_^9764 6.24^66 \_..\_^4506  
Random chunks \-5.14−4−5 \_..\_^9439 \-1.10−1−1 \_..\_^0517 \-0.61−0−0 \_..\_^5864 \-0.89−0−0 \_..\_^8594  
observation is that it might be beneficial to train RETRO using a re-  
trieval database different from the training set. The training could also  
include examples of random chunks to help the model better learn to  
skip irrelevant information, and examples of same-document snippets  
to help the model better learn to copy correct answers.  
\_5.2. Completing code lines from local projects with RepoEval\_  
In this section, we aim to simulate and evaluate completing lines in  
local projects using the RepoEval dataset, as described in Section 4.3.  
We first present the results of RETRO, GPT-2, and In-context RAG in  
this setting, followed by an experiment with larger models, and detailed  
analysis of our most successful approach, namely In-context RAG. We  
end the section with an analysis of the impact the quality of the retrieved  
snippets has on the code-completion performance.  
\_5.2.1. RETRO and GPT-2 results on local projects\_  
In Fig. 7 , we compare our trained models, RETRO and GPT-2, using  
both GPT-2 and StarCoder tokenizations. The metrics confirm the ad-  
vantage of StarCoder tokenization, which better handles the whitespace  
issue mentioned in Section 4.1. Similar to the single-token metrics, with  
multi-token predictions, we observe that the 6-layer RETRO achieves  
significantly better performance than the 6-layer GPT-2. However, the  
difference between the 9-layer GPT-2 and the 6-layer RETRO is not as  
pronounced, especially with the StarCoder tokenization.  
Metrics on lineR are higher than on line (similarly for apiR and  
api), because in the case of line we predict entire lines, while in lineR  
the model already has some additional context about the content of the  
current line. This is important because predicting the entire line requires  
correctly predicting the start of the line; otherwise, the EM and PS met-  
rics are immediately zero. Predicting the correct start of a line is not  
always straightforward, as multiple beginnings can make sense.  
In Fig. 7 , we also report the metrics for the In-context RAG approach  
(more in Section 5.2.3). Despite its simplicity, the contribution of the  
In-context RAG is more significant than the use of RETRO. When com-  
bining In-context RAG with RETRO, we observe smaller improvements

\*\*Fig. 7.\*\* Comparison of our models using GPT-2 and StarCoder tokenization on the RepoEval line-level (left) and API-level (right) datasets without overlap with the  
training set. The bar plots contain 95-percent confidence intervals of the prefix similarity metric.  
compared to enhancing GPT-2 with In-context RAG. A possible expla-  
nation is that including retrieved snippets into the input context “ con-  
fuses” RETRO’s chunk based retrieval, which now finds neighbors of the  
already retrieved snippets for part of the context. Additionally, snippets  
included in the context receive the same treatment as other input to-  
kens through processing in the transformer, while RETRO incorporates  
the retrieved chunks using cross-attention only in the sparsely dispersed  
Retro layers.  
\_5.2.2. Comparison with larger models\_  
Using small models is beneficial for local model execution, but one  
of the advantages of LLMs is their ability to scale by increasing the num-  
ber of parameters (Kaplan et al., 2020 ). In Fig. 8 and Table 7 , we ex-  
amine the contribution of larger models compared to our smaller mod-  
els. The open-source models StarCoder 164 \_𝑀\_ (with 164 × 10^6 parameters)  
and StarCoder 15\_.\_ 5 \_𝐵\_ (with 15\_.\_ 5 × 10^9 parameters) are trained on the en-  
tire StarCoder dataset and further fine-tuned on Python (Li et al., 2023 ).  
StarCoder 164 \_𝑀\_ serves as a good comparison to our models due to its  
comparable number of parameters and for assessing the contribution of  
training on a larger dataset with a larger context size (8192 compared  
to our size of 384).  
Increasing the number of parameters in some cases more than  
doubles the performance compared to smaller models, as seen in  
Table 7\. However, with the use of In-context RAG, even smaller mod-  
els can achieve results comparable to larger models (without retrieval).  
The positive impact of retrieval is not limited to smaller models, as  
\*\*Fig. 8.\*\* Comparison of our models with larger models on the line-level and API-  
level RepoEval datasets starting completion from random positions. The bar  
plots contain 95-percent confidence intervals of the prefix similarity metric.  
incorporating useful information from the project into the context ben-  
efits the completions of larger models as well.  
Results on api are lower than on line due to completing function  
calls from projects and also due to the longer length of examples, which  
can contain more than a single line. Consequently, the model must cor-  
rectly predict more tokens, increasing the likelihood of error. For longer  
examples the differences are even greater due to the use of greedy decod-  
ing and the propagation of errors, which are more frequent in smaller  
models.  
\_5.2.3. In-context RAG\_  
Since the found snippets are included directly in the model’s context,  
it is important that the model supports a sufficiently large context to  
append the retrieved data in addition to the input context. When using  
our models with a context size of 384 tokens, we often need to trun-  
cate the input sequence to leave enough space to include the retrieved  
snippets at the beginning of the context. For our models, GPT-2 and  
RETRO, we include only one retrieved snippet due to the small context  
size of the model. For models with larger context sizes, we include two  
retrieved snippets. In Table 7 and in Figs. 7 and 8 , we report multi-token  
prediction metrics both with and without retrieval as described in Sec-  
tion 3.3. The results indicate that using In-context RAG leads to improve-  
ments in multi-token predictions compared to the baseline models in all  
cases.  
\_Copying.\_ In Section 5.1, we estimate the upper bound of single-token  
metrics for RETRO by not removing chunks retrieved from the same file  
as the input context. Similarly, we want to determine the upper bound of  
model performance when using In-context RAG if the retrieved snippets  
can contain the continuation of the current file we are completing. This  
means that the context includes the line we want to complete, allowing  
the model to simply copy it from the context. In Fig. 9 , we see that  
copying from retrieved snippets is very effective, while copying with  
RETRO without In-context RAG performs similarly to using RETRO with  
In-context RAG without copying.  
In addition to the explanations in Section 5.1, we also note that be-  
cause the first Retro layer is the sixth layer (which is also the last and  
only Retro layer for RETROSC 6 ), certain information from the input to-  
kens may get diluted, preventing direct copying of tokens from the en-  
coded chunks with chunked cross-attention. We hypothesize that adding  
copying examples to the training would improve the model’s ability to  
copy, and Retro layers could be included closer to the beginning of pro-  
cessing instead of only in the sixth layer. Accurate copying is important  
because when completing code, we want to extract not only the seman-  
tic meaning from the found snippets but also exact facts (e.g., the exact  
name of an existing function and not a hallucinated but semantically  
similar name).

\*\*Table 7\*\*  
Results of comparing smaller and larger models on RepoEval. The results for code-davinci-  
002 are from Zhang et al. (2023b).  
In-context RAG  
Model Data EM ES PS EM ES PS  
GPTSC 9 line 18.0^1916 \_..\_^91 47.0^4845 \_..\_^43 23.2^2521 \_..\_^04 33.9^3631 \_..\_^06 58.4^6056 \_..\_^27 40.9^4338 \_..\_^64  
api 8.8^107\_.\_ 3\_.\_^1 39.3^4037 \_..\_^68 15.0^1613 \_..\_^35 21.1^2319 \_..\_^21 51.7^5350 \_..\_^30 26.9^2924 \_..\_^09  
RETROSC 6 line 19.6^2117 \_..\_^87 50.1^5148 \_..\_^86 26.4^2824 \_..\_^15 31.6^3329 \_..\_^82 57.2^5855 \_..\_^96 39.5^4237 \_..\_^23  
api 9.6^118\_.\_ 1\_.\_^0 42.7^4441 \_..\_^13 16.8^1815 \_..\_^24 20.1^2118 \_..\_^91 50.5^5148 \_..\_^96 26.3^2824 \_..\_^34  
StarCoder 164 \_𝑀\_ line 25.1^2722 \_..\_^09 53.1^5451 \_..\_^74 31.9^3429 \_..\_^29 41.6^4439 \_..\_^01 64.6^6662 \_..\_^36 48.1^5045 \_..\_^92  
api 23.2^2521 \_..\_^10 52.6^5450 \_..\_^19 32.4^3430 \_..\_^62 34.5^3632 \_..\_^82 63.0^6461 \_..\_^64 43.6^4641 \_..\_^04  
StarCoder 15\_.\_ 5 \_𝐵\_ line \*\*39.4\*\*^4137 \_..\_^81 \*\*64.4\*\*^6662 \_..\_^27 \*\*44.8\*\*^4742 \_..\_^53 51.0^5348 \_..\_^48 72.2^7370 \_..\_^76 \*\*56.5\*\*^5953 \_..\_^28  
api 32.1^3429 \_..\_^28 61.2^6259 \_..\_^94 41.3^4339 \_..\_^80 44.1^4641 \_..\_^45 71.4^7269 \_..\_^98 53.6^5651 \_..\_^12  
code-davinci-002 line 38.69 62.58 / \*\*55.94 74.34\*\* /  
api \*\*32.50 61.52\*\* / \*\*47.75 73.30\*\* /  
\*\*Fig. 9.\*\* Comparison of copying abilities using In-context RAG on lineR’. With  
copying, retrieved snippets can be from the same file as the input context, which  
means including the correct continuation of the current line in the model’s con-  
text. \_RETRO copying\_ shows the use of RETRO without filtering out the current  
file from retrieval but without additional In-context RAG (see also Section 5.1).  
The bars show 95% confidence intervals for the prefix similarity metric PS.  
\_5.2.4. Impact of retrieval similarity\_  
Intuitively, we expect the benefit of retrieval-augmented line com-  
pletion to depend on the quality of the retrieved snippets. Therefore, we  
first examine the impact of the retrieved snippets’ similarities on the ex-  
act match metric EM with the results shown in Fig. 10\. As expected, the  
metric increases with higher matching according to the Jaccard similar-  
ity coefficient. We also find that most of the metric improvement comes  
from projects where snippets with high similarity to the query from  
\*\*Fig. 10.\*\* Impact of the Jaccard similarity coefficient evaluated on lineR and apiR using the StarCoder 164 \_𝑀\_ model and In-context RAG. The left side shows EM  
increasing as the Jaccard similarity increases, and the distribution of similarities, which is slightly higher on apiR than on lineR. The right side shows the average  
Jaccard similarity for each of the eight projects in lineR and apiR and the difference in EM for each project individually compared to the baseline model without  
retrieval. Projects with gray names and an asterisk are those removed in lineR’ and apiR’ due to a non-empty overlap with the training set.  
\*\*Table 8\*\*  
Proportions of improved and worsened examples based on prefix similarity  
when comparing the baseline model (rows) with the model with retrieval  
(columns) on the lineR dataset. The first column of the first row tells us that  
RETROSC 6 completes the line better than GPTSC 9 in 12.3% of cases, worse in  
7.9% of cases, and in the remaining cases, the predictions of both models  
are the same.  
In-context RAG  
RETROSC 6 RETROSC 6 GPTSC 9 StarCoder 164 \_𝑀\_  
GPTSC 9 12.3 / 7.9 20.3 / 9.3 \*\*17.4 / 6.2\*\* 26.2 / 6\.  
RETROSC 6 / \*\*14.5 / 6.0\*\* 17.2 / 8.8 24.4 / 6\.  
StarCoder 164 \_𝑀\_ 11.4 / 15.6 17.5 / 14.6 17.2 / 14.1 \*\*15.8 / 3.\*\*  
the input context are found. The benefits of retrieval are thus project-  
dependent, with greater benefits in projects with repetitive code, as a  
high Jaccard similarity indicates token overlap between files.  
Using RETRO or In-context RAG generally improves multi-token pre-  
dictions. However, there are cases where the model without retrieval  
correctly completes a line, while the model with retrieval does not, as  
summarized in Table 8\. Most examples remain unchanged regardless of  
retrieval use, suggesting that retrieval is beneficial only in specific cases.  
While positive examples dominate, the proportion of worsened results  
is not negligible and we want to reduce it.  
Now we focus only on the examples highlighted in Table 8 , where  
we detect worsening or an improvement in metrics. From Fig. 11 , we  
find that the impact of retrieval is negative mainly at low similarities  
to the query, while the positive impact is more present at higher simi-  
larities. To mitigate the consequences of poor retrieval, we examine the  
idea of whether it makes sense to limit retrieval to found snippets with

\*\*Fig. 11.\*\* The left side shows the proportion of cases that are better or worse with In-context RAG compared to the baseline model without retrieval. The model used  
is GPTSC 9 on lineR with PS being compared. Retrieval is beneficial mainly when there is a high similarity of the retrieved snippets. The right side shows the difference  
in the PS metric to the baseline model when limiting retrieval to cases above a certain similarity threshold.  
similarities higher than some threshold value. Unfortunately, the right  
side of Fig. 11 does not show a significant benefit from limiting to suf-  
ficiently similar snippets.  
\_5.3. Qualitative analysis\_  
In Section 5.2, we found that retrieval generally benefits model pre-  
dictions, but there are still cases where retrieval degrades the accuracy  
of predictions. In this section, we conduct a qualitative review of suc-  
cessful and less successful line completion examples, using our GPTSC 9  
and RETROSC 6 models.  
\_Common errors.\_ Our small models (with or without retrieval) mostly  
make semantic errors; syntactic errors are rare. Semantic errors require  
a higher level of code understanding, which might exceed the capabili-  
ties of our small models. Difficulties often arise when completing natural  
language strings (e.g., comments and documentation within the code),  
at the beginning of files in import statements, and when using boolean  
or numerical constants. Degradation is also present in longer predictions  
due to greedy decoding and error propagation. For completing import  
statements, the model would need information about the upcoming lines  
of the file to infer which modules to import into the program. In complet-  
ing documentation, we have a similar problem if we are documenting  
code that has not yet been written and follows in the subsequent lines.  
Additionally, our string matching based evaluation does not distinguish  
between semantically equivalent ways of expressing messages causing  
examples like in Fig. 12 to achieve low metrics. Nevertheless, retrieval  
can offer an advantage in such cases by providing the model with an  
example of the existing documentation style.  
\_Hallucinations.\_ Handling hallucinations in code completion is more man-  
ageable compared to natural language, as the proposed code can be  
\*\*Fig. 12.\*\* An example of completing documentation where retrieval guides the  
model to copy from a highly similar found snippet. The code is shortened for  
clarity. This example also shows the difficulty of evaluating natural language  
using string similarity based metrics, as the model’s prediction without retrieval  
is very reasonable.  
verified with static code analysis tools to discard suggestions contain-  
ing errors (e.g., calling a non-existent function or using an incorrect  
number of arguments). However, static analysis cannot resolve seman-  
tic errors, such as incorrect conditions in loops or the improper order of  
operations. Therefore, careful attention and understanding of the code  
are necessary when using code completion tools.  
\_Advantages and disadvantages of retrieval.\_ As discussed in Section 5.2.4,  
the advantage of retrieval-augmented completion becomes apparent  
when highly similar examples to the input context are found in the  
project. An example of repetitive code occurs when writing tests, which  
also involves the use of objects defined within the project. In most cases,  
the model can focus on the relevant information in the context and  
successfully skip over unhelpful retrieved snippets. However, when the  
model performs worse with retrieval, it is often due to misleading snip-  
pets that conflict with the information of the current file. For example,  
the model might use a function call as found in a related file instead of  
how it should be used according to the current file, as seen in Fig. 13\.  
\_Evaluation limitations.\_ Evaluating the quality of code completion us-  
ing metrics is challenging (Evtikhiev, Bogomolov, Sokolov, & Bryksin,  
2023 ). In many cases, a line can be completed in multiple ways, but eval-  
uation datasets typically contain only one correct answer. This problem  
could be mitigated by sampling multiple generated solutions, thereby  
increasing the likelihood of a correct match. A better solution would be  
to execute the generated code using unit tests defined in the project.  
However, besides the complexity of running code (e.g., setting up a de-  
velopment environment for each project), this is not the most suitable  
quality measure in our case since we are completing individual lines  
rather than entire functions. Instead of string based metrics, LLMs could  
be used to evaluate quality, as they have a higher correlation with hu-  
man judgements (Liu et al., 2023 ). Ultimately, it is the developer who  
decides whether to accept the suggested line, so for evaluation, it would  
be necessary to ask users for feedback or conduct A/B tests of the final  
product integrated into a code editor.

\*\*6. Conclusion and future work\*\*  
    In this work, we examined the impact of retrieval from local projects  
on the success of completing lines of code using LLMs. We compared the  
GPT-2 and RETRO models, which we trained on a dataset of Python files  
from the StarCoder dataset. We compared two different tokenization  
approaches and highlighted the importance of token healing and the  
proper tokenization of whitespace when completing code, as it affects  
the amount of information in the context and the storage size of tok-  
enized data. We limited GPT-2 and RETRO to a smaller size of around  
160 million parameters and reduced the impact of the differing num-  
ber of parameters when comparing the two models. We confirmed that  
RETRO with retrieval from the local project improves metrics compared  
to both the 6-layer and 9-layer GPT-2 on all considered benchmarks.

\*\*Fig. 13.\*\* On the left is an example of misleading retrieval where the model incorrectly uses a function as it appears in the retrieved snippet instead of how it is used  
in the current file. On the right is an example of completing a test function in a project where a model with a longer context could correctly complete the lines, as the  
name ProbClassifier would have been encountered at the beginning of the file in the import statements. However, with a context size of 384, the beginning of the  
file is lost, but retrieval finds a similar example in other tests in the project, enabling successful completion compared to the baseline model. The code is shortened  
for clarity in both cases.  
However, the difference between the 9-layer GPT-2 and the 6-layer  
RETRO is not pronounced, indicating the importance of considering the  
number of model parameters when comparing small models. We further  
examined the impact of retrieval using In-context RAG, which includes  
snippets found using the Jaccard similarity of tokens into the context.  
Using In-context RAG to retrieve from projects in RepoEval improved re-  
sults of both small and larger models, but the improvements depended  
on the quality of retrieval and the projects’ characteristics. We found  
that the similarity of the retrieved snippets and the ability to copy from  
them have a significant impact on the results, but the copying capabil-  
ities of the 6-layered RETRO were found to be lacking. Based on our  
results, we deem that using small language models with In-context RAG  
is more sensible than using RETRO for the task of completing lines of  
code with retrieval from local projects due to the simplicity and broader  
applicability of In-context RAG.  
In summary, users looking to apply our work would do well to con-  
sider picking the largest model size that fits within their constraints and  
then apply retrieval from local projects.  
\_Future work.\_ RETRO has proven useful for code completion, but several  
potential improvements would require retraining the model. Training  
could include examples that would improve the ability to copy from re-  
trieved snippets and to ignore irrelevant information. For code comple-  
tion, it would be beneficial to experiment training RETRO with the fill-  
in-the-middle technique (Donahue, Lee, & Liang, 2020 ), which reshapes  
the context to include code after the cursor position. Training RETRO  
with a longer context could also be enhanced by training on projects  
instead of individual files. For better integration with In-context RAG,  
the retrieved snippets could be appended to the input context during  
training (Wang et al., 2023a). Additionally, it would be worthwhile to  
explore training and using RETRO with different retrieval methods, such  
as sparse BM-25 search instead of methods based on dense embeddings.  
A major advantage of In-context RAG is that it does not require up-  
dating the model weights, but doing so could still be beneficial for im-  
proving performance either by fine-tuning the model with included re-  
trieved snippets or by fine-tuning the retriever (Izacard & Grave, 2021 ;  
Karpukhin et al., 2020 ). Instead of retrieving snippets based on the Jac-  
card similarity of tokens, a future area to investigate is incorporating  
sparse search with the benefits of dense semantic search and check  
whether hybrid generative and retrieval-based models could further im-  
prove performance. For more efficient execution in code editors, mod-  
els could be fine-tuned to append to the end of the context instead of  
the beginning, which would improve the caching of keys and values  
in self-attention during frequent code editing. A next step would also  
be to explore the impact of combining In-context RAG with the fill-in-  
the-middle technique, which is becoming increasingly widespread (Wu  
et al., 2024 ).  
By training on more data, using appropriate tokenization, and im-  
proving the information present in the context with retrieval and fill-  
in-the-middle, alongside approaches such as weight quantization, we  
believe that code completion models have great potential for local use  
in programming tools.  
\*\*CRediT authorship contribution statement  
Marko Hostnik\*\* : Conceptualization, Methodology, Software, Valida-  
tion, Formal analysis, Investigation, Writing – original draft, Writing –  
review and editing. \*\*Marko Robnik-Šikonja\*\* : Conceptualization, Writ-  
ing – original draft, Writing – review and editing, Supervision, Project  
administration.  
\*\*Funding sources\*\*  
This research was funded by the Slovenian Research and Innovation  
Agency (ARIS) core research programme P6-0411 and project GC-0002.  
The work was also supported by the EU through ERA Chair under Grant  
101186647 (AI4DH) and cofinancing for research innovation projects  
in support of green transition and digitalisation (project PoVeJMo, no.  
C3.K8.IB) (Marko Robnik-Šikonja).  
\*\*Data availability\*\*  
The StarCoder dataset (Li et al., 2023 ) and the RepoEval (Zhang  
et al., 2023b) dataset are publicly available.  
\*\*Declaration of competing interest\*\*  
The authors declare the following financial interests/personal rela-  
tionships which may be considered as potential competing interests:  
Marko Hostnik reports a relationship with JetBrains sro that includes:  
employment. If there are other authors, they declare that they have no  
known competing financial interests or personal relationships that could  
have appeared to influence the work reported in this paper.  
\*\*Acknowledgements\*\*  
We thank JetBrains for motivating the problem and providing the  
computing power for conducting our experiments.  
\*\*Appendix A. StarCoder dataset analysis\*\*  
In this paper, we examine the benefit of including retrieved similar  
code snippets from the project into the code completion process. We hy-  
pothesize that finding similar examples can be useful when predicting

\*\*Fig. A.1.\*\* Comparison of references to functions defined within projects in the StarCoder dataset. Non-local function calls refer to references to functions not defined  
within the project (e.g., calls to functions from the standard library). In the right figure, due to varying file lengths, we calculate the average number of calls per  
4000 characters. The number of calls increases with project size (left graph), and calls are more frequent when considering the project as a whole compared to  
individual files (right distribution). In the right distribution, the number of calls within files stands out near zero, which we attribute to calls to functions defined in  
other project files. Within individual files, such calls are counted as non-local.  
symbols (e.g., function names, variables, classes) defined within the lo-  
cal project, as such names are not present in the training set. Therefore,  
we sample 50,000 random projects with at least three files from the  
StarCoder dataset and count the frequency of calls to functions defined  
within the project by traversing the abstract syntax tree. In Fig. A.1, we  
compare the number of calls within individual files to the number of  
calls within the project as a whole. The number of calls increases with  
the size of the project or files, and the number of calls within the project  
is greater than the number of calls within individual files. Consequently,  
we expect that cross-file code retrieval can improve the quality of code  
completion, especially for larger projects.  
\*\*Appendix B. RepoEval modification details\*\*  
The line and api datasets from RepoEval (Zhang et al., 2023b) each  
contain 1600 examples. Every example in line is composed of a prompt  
input string and a ground\_truth output string. Our modified dataset  
lineR is constructed from line by expanding each original example’s  
prompt with a random number of characters from ground\_truth and  
shrinking ground\_truth accordingly. We are careful that at least one  
non-whitespace character from ground\_truth is included into the new  
prompt to avoid expanding prompt only by the leading indentation  
whitespace. The construction of apiR from api is similar to that of lineR  
from line.  
\*\*Appendix C. Chunk embeddings with BERT\*\*  
We test the impact of using the BERT encoder versus CodeT5+  
on a smaller dataset (6.7% of the total training set) and find that us-  
ing the larger BERT encoder for chunk embeddings does not result in  
significant changes in test metrics – see Table C.1. The comparison  
is not exhaustive due to the smaller training set and shorter training  
duration.  
\*\*Table C.\*\*  
Comparison of model training on a smaller training dataset  
using BERT and CodeT5+ for computing chunk embed-  
dings. GPT-2 tokenization is used.  
Model Encoder PPL R 1 R 5 MRR 5  
GPTgpt 6 / 2.96 77.9 89.4 82\.  
RETROgpt 6 BERT 2.95 78.0 89.5 82\.  
RETROgpt 6 CodeT5+ 2.95 78.0 89.4 82\.  
\*\*Appendix D. Indexing chunk embeddings\*\*  
Due to the large number of chunks in the database, exhaustive  
searching for the exact \_𝑘\_ \-nearest chunks is not feasible, so we resort to  
\_approximate\_ searching instead. As a consequence of approximate search,  
we seek a compromise between the search accuracy, search speed, in-  
dex building speed, and index memory usage. In our implementation,  
we use the Faiss library (Johnson et al., 2021 ) to index the chunk embed-  
dings.^4 The search is sped up using IVF indexing (Johnson et al., 2021 )  
in combination with the HNSW (Malkov & Yashunin, 2020 ) algorithm.  
Additionally, the vectors are compressed with the PQ (Jegou, Douze,  
& Schmid, 2008 ) vector codec and the OPQ (Ge, He, Ke, & Sun, 2013 )  
transformation. Table D.1 summarizes the space requirements for stor-  
ing the database and retrieval index based on the tokenization method  
used.  
\*\*Table D.\*\*  
Comparison of the retrieval database sizes using two different vocabular-  
ies for tokenization. The total size of all files before tokenization is 62  
GiB.  
Tokenization \# Chunks \# Tokens Tokenized file size Index size  
GPT-2 4\_.\_ 5 × 10^8 27 × 10^9 53 GiB 18 GiB  
StarCoder 2\_.\_ 8 × 10^8 18 × 10^9 33 GiB 12 GiB  
\_Indexing effectiveness.\_ To evaluate the effectiveness of approximate near-  
est chunk retrieval using the index constructed with Faiss, we compare  
the \_𝐿\_ 2 distance between the embedding of a chunk and the embedding of  
the nearest chunk from the retrieval database returned by the index. For  
comparison, we observe the distributions of \_𝐿\_ 2 distances between the  
embeddings of retrieved chunks and chunks from the database, train-  
ing set, test set, and chunks composed of random tokens. All chunks  
contain 64 tokens, and we sample 10 0000 chunks from each set. The  
distribution results are shown in Fig. D.1. The right side of the figure  
shows approximate distances as returned by Faiss, which are not exact  
due to the compression and transformation of embeddings by the in-  
dexing. As expected, retrieving chunks from the database itself is nearly  
error-free (98% accuracy), while searching with random chunks returns  
the largest distances. Retrieving chunks from the training set results in  
smaller distances compared to retrieving chunks from the test set, as the  
database is constructed by partitioning the training set into consecutive  
non-overlapping chunks.

(^4) In Faiss, the used index can be compactly described by the string  
OPQ32\_128,IVF1048576\_HNSW32,PQ32.

\*\*Fig. D.1.\*\* Distribution of \_𝐿\_ 2 distances between chunk embeddings and their retrieved neighbors. The left figure shows exact distances, while the right figure shows  
approximate distances as returned by the Faiss index.  
\*\*References\*\*  
Athiwaratkun, B., Wang, S., Shang, M., Tian, Y., Wang, Z., Gonugondla, S., Gouda, S. K.,  
Kwiatkowski, R., Nallapati, R., & Xiang, B. (2024). Token alignment via character  
matching for subword completion. In \_ACL Findings 2024\_.  
Austin, J., Odena, A., Nye, M., Bosma, M., Michalewski, H., Dohan, D., Jiang, E., Cai, C.,  
Terry, M., Le, Q., & Sutton, C. (2021). Program synthesis with large language models.  
arXiv:2108.  
Borgeaud, S., Mensch, A., Hoffmann, J., Cai, T., Rutherford, E., Millican, K., Van  
Den Driessche, G.B., Lespiau, J.B., Damoc, B., Clark, A., De Las Casas, D., Guy, A.,  
Menick, J., Ring, R., Hennigan, T., Huang, S., Maggiore, L., Jones, C., Cassirer, A. ...  
Sifre, L. (2022). Improving language models by retrieving from trillions of tokens. In  
\_Proceedings of the 39th international conference on machine learning\_ (pp. 2206–2240).  
( \_vol. 162\_ ). Proceedings of Machine Learning Research.  
Brown, T., Mann, B., Ryder, N., Subbiah, M., Kaplan, J.D., Dhariwal, P., Neelakantan, A.,  
Shyam, P., Sastry, G., Askell, A., Agarwal, S., Herbert-Voss, A., Krueger, G., Henighan,  
T., Child, R., Ramesh, A., Ziegler, D., Wu, J., Winter, C. ... Amodei, D. (2020). Lan-  
guage models are few-shot learners. In \_Advances in neural information processing systems\_  
(pp. 1877–1901). (vol. \_33\_ ).  
Chen, M., Tworek, J., Jun, H., Yuan, Q., de Oliveira Pinto, H.P., Kaplan, J., Edwards, H.,  
Burda, Y., Joseph, N., Brockman, G., Ray, A., Puri, R., Krueger, G., Petrov, M., Khlaaf,  
H., Sastry, G., Mishkin, P., Chan, B., Gray, S. ... Zaremba, W. (2021). Evaluating large  
language models trained on code. arXiv:2107.  
Dagan, G., Synnaeve, G., & Roziere, B. (2024). Getting the most out of your tokenizer for  
pre-training and domain adaptation. In \_Forty-first international conference on machine  
learning\_.  
Devlin, J., Chang, M.W., Lee, K., & Toutanova, K. (2019). BERT: Pre-training of Deep  
Bidirectional Transformers for Language Understanding. In \_Proceedings of the 2019  
conference of the north American chapter of the association for computational linguistics:  
Human language technologies, volume 1 (long and short papers)\_ (pp. 4171–4186). https:  
//doi.org/10.18653/v1/N19-  
Ding, Y., Wang, Z., Ahmad, W., Ding, H., Tan, M., Jain, N., Ramanathan, M.K., Nallapati,  
R., Bhatia, P., Roth, D., & Xiang, B. (2023). CrossCodeEval: A Diverse and Multilingual  
Benchmark for Cross-File Code Completion. In \_Advances in neural information processing  
systems\_ (pp. 46701–46723). (vol. \_36\_ ).  
Donahue, C., Lee, M., & Liang, P. (2020). Enabling language models to fill in the blanks.  
In \_Proceedings of the 58th annual meeting of the association for computational linguistics\_  
(pp. 2492–2501). https://doi.org/10.18653/v1/2020.acl-main.  
Efron, B. (1987). Better bootstrap confidence intervals. \_Journal of the American Statistical  
Association\_ , \_82\_ (397), 171–185. https://doi.org/10.1080/01621459.1987.  
Evtikhiev, M., Bogomolov, E., Sokolov, Y., & Bryksin, T. (2023). Out of the BLEU: How  
should we assess quality of the Code Generation models? \_Journal of Systems and Soft-  
ware\_ , \_203\_ , 111741\. https://doi.org/10.1016/j.jss.2023.  
Ge, T., He, K., Ke, Q., & Sun, J. (2013). Optimized product quantization for approximate  
nearest neighbor search. In \_Proceedings of the 2013 IEEE conference on computer vi-  
sion and pattern recognition\_ CVPR ’13 (p. 2946–2953). https://doi.org/10.1109/CVPR.  
2013\.  
Guo, D., Ren, S., Lu, S., Feng, Z., Tang, D., LIU, S., Zhou, L., Duan, N., Svyatkovskiy, A.,  
Fu, S., Tufano, M., Deng, S.K., Clement, C., Drain, D., Sundaresan, N., Yin, J., Jiang,  
D., & Zhou, M. (2021). GraphCodeBERT: Pre-training Code Representations with Data  
Flow. In \_International conference on learning representations\_.  
Guo, D., Zhu, Q., Yang, D., Xie, Z., Dong, K., Zhang, W., Chen, G., Bi, X., Wu, Y., Li,  
Y.K., Luo, F., Xiong, Y., & Liang, W. (2024). DeepSeek-coder: When the large language  
model meets programming–The rise of code intelligence. arXiv:2401.  
Guu, K., Lee, K., Tung, Z., Pasupat, P., & Chang, M. (2020). Retrieval augmented lan-  
guage model pre-training. In \_Proceedings of the 37th international conference on machine  
learning\_ (pp. 3929–3938).  
Harman, D.K. (1995). Overview of the third text retrieval conference (TREC-3). 500\. DI-  
ANE Publishing.  
Izacard, G., & Grave, E. (2021). Leveraging passage retrieval with generative models for  
open domain question answering. In \_EACL 2021 \- 16th Conference of the European  
chapter of the association for computational linguistics\_ (pp. 874–880). https://doi.org/  
10.18653/v1/2021.eacl-main.  
Jegou, H., Douze, M., & Schmid, C. (2008). Hamming embedding and weak geometric  
consistency for large scale image search. In \_Computer vision – ECCV\_ (pp. 304–317).  
https://doi.org/10.1007/978-3-540-88682-2\_  
Johnson, J., Douze, M., & Jégou, H. (2021). Billion-scale similarity search with GPUs.  
\_IEEE Transactions on Big Data\_ , \_7\_ (3), 535–547. https://doi.org/10.1109/TBDATA.2019.  
2921572  
Jurafsky, D., & Martin, J.H. (2009). Speech and language processing (2nd Edition). Upper  
Saddle River, NJ, USA: Prentice-Hall, Inc.  
Kaplan, J., McCandlish, S., Henighan, T., Brown, T.B., Chess, B., Child, R., Gray, S.,  
Radford, A., Wu, J., & Amodei, D. (2020). Scaling laws for neural language models.  
arXiv:2001.  
Karpukhin, V., Oguz, B., Min, S., Lewis, P., Wu, L., Edunov, S., Chen, D., & Yih, W.t.  
(2020). Dense passage retrieval for open-domain question answering. In \_Proceedings  
of the 2020 conference on empirical methods in natural language processing (EMNLP)\_ (pp.  
6769–6781). https://doi.org/10.18653/v1/2020.emnlp-main.  
Kasneci, E., Sessler, K., Küchemann, S., Bannert, M., Dementieva, D., Fischer, F.,  
Gasser, U., Groh, G., Günnemann, S., Hüllermeier, E., Krusche, S., Kutyniok, G.,  
Michaeli, T., Nerdel, C., Pfeffer, J., Poquet, O., Sailer, M., Schmidt, A., Seidel, T. ...  
Kasneci, G. (2023). ChatGPT for good? On opportunities and challenges of large lan-  
guage models for education. \_Learning and Individual Differences\_ , \_103\_ , 102274\. https:  
//doi.org/10.1016/j.lindif.2023.  
Khandelwal, U., Levy, O., Jurafsky, D., Zettlemoyer, L., & Lewis, M. (2020). Generalization  
through memorization: Nearest neighbor language models. In \_International conference  
on learning representations\_.  
Kingma, D.P., & Ba, J. (2015). Adam: A method for stochastic optimization. In \_3rd Inter-  
national conference on learning representations\_.  
Levenshtein, V.I. et al. (1966). Binary codes capable of correcting deletions, insertions,  
and reversals. In \_Soviet physics doklady\_ (pp. 707–710). Soviet Union (vol. \_10\_ ).  
Leviathan, Y., Kalman, M., & Matias, Y. (2023). Fast inference from transformers via spec-  
ulative decoding. In \_Proceedings of the 40th international conference on machine learning\_  
(pp. 19274–19286).  
Lewis, P., Perez, E., Piktus, A., Petroni, F., Karpukhin, V., Goyal, N., Küttler, H., Lewis,  
M., Yih, W.t., Rocktäschel, T., Riedel, S., & Kiela, D. (2020). Retrieval-augmented gen-  
eration for knowledge-intensive NLP tasks. In \_Advances in neural information processing  
systems\_ (pp. 9459–9474). (vol. \_33\_ ).  
Li, R., allal, L.B., Zi, Y., Muennighoff, N., Kocetkov, D., Mou, C., Marone, M., Akiki, C.,  
Jia, L.I., Chim, J., Liu, Q., Zheltonozhskii, E., Zhuo, T.Y., Wang, T., Dehaene, O., Lamy-  
Poirier, J., Monteiro, J., Gontier, N., Yee, M.H. ... de Vries, H. (2023). StarCoder: May  
the source be with you\!. \_Transactions on Machine Learning Research\_.  
Liang, J.T., Yang, C., & Myers, B.A. (2024). A large-scale survey on the usability of AI  
programming assistants: Successes and challenges. In \_Proceedings of the IEEE/ACM  
46th international conference on software engineering\_ ICSE ’24. https://doi.org/10.1145/  
3597503\.  
Liu, T., Xu, C., & McAuley, J. (2024). RepoBench: Benchmarking repository-level code  
auto-completion systems. In \_The twelfth international conference on learning representa-  
tions\_.  
Liu, Y., Iter, D., Xu, Y., Wang, S., Xu, R., & Zhu, C. (2023). G-Eval: NLG Evaluation using  
GPT-4 with better human alignment. In \_Proceedings of the 2023 conference on empirical  
methods in natural language processing\_ (pp. 2511–2522). https://doi.org/10.18653/v1/  
2023.emnlp-main.  
Lu, S., Duan, N., Han, H., Guo, D., Hwang, S.w., & Svyatkovskiy, A. (2022). ReACC:  
A retrieval-augmented code completion framework. In \_Proceedings of the 60th an-  
nual meeting of the association for computational linguistics (volume 1: Long papers)\_ (pp.  
6227–6240). https://doi.org/10.18653/v1/2022.acl-long.  
Lu, S., Guo, D., Ren, S., Huang, J., Svyatkovskiy, A., Blanco, A., Clement, C., Drain, D.,  
Jiang, D., Tang, D., Li, G., Zhou, L., Shou, L., Zhou, L., Tufano, M., Gong, M., Zhou, M.,  
Duan, N., Sundaresan, N. ... Liu, S. (2021). CodeXGLUE: A machine learning bench-  
mark dataset for code understanding and generation. In \_Thirty-fifth conference on neural  
information processing systems datasets and benchmarks track\_.  
Malkov, Y.A., & Yashunin, D.A. (2020). Efficient and robust approximate nearest neighbor  
search using hierarchical navigable small world graphs. \_IEEE Transactions on Pattern  
Analysis and Machine Intelligence\_ , \_42\_ (4), 824–836. https://doi.org/10.1109/TPAMI.  
2018\.

Narayanan, D., Shoeybi, M., Casper, J., LeGresley, P., Patwary, M., Korthikanti, V., Vain-  
brand, D., Kashinkunti, P., Bernauer, J., Catanzaro, B., Phanishayee, A., & Zaharia, M.  
(2021). Efficient large-scale language model training on GPU clusters using Megatron-  
LM. In \_Proceedings of the international conference for high performance computing, net-  
working, storage and analysis\_. https://doi.org/10.1145/3458817.  
Parvez, M.R., Ahmad, W., Chakraborty, S., Ray, B., & Chang, K.W. (2021). Retrieval aug-  
mented code generation and summarization. In \_Findings of the association for com-  
putational linguistics: EMNLP\_ (pp. 2719–2734). https://doi.org/10.18653/v1/2021.  
findings-emnlp.  
Patwardhan, N., Marrone, S., & Sansone, C. (2023). Transformers in the real world: A sur-  
vey on NLP applications. \_Information\_ , \_14\_ (4). https://doi.org/10.3390/info  
Press, O., & Wolf, L. (2017). Using the output embedding to improve language models. In  
\_Proceedings of the 15th conference of the European chapter of the association for computa-  
tional linguistics: Volume 2, short papers\_ (pp. 157–163).  
Radford, A., Wu, J., Child, R., Luan, D., Amodei, D., & Sutskever, I. (2019). Language  
models are unsupervised multitask learners. \_OpenAI Blog\_ , \_1\_ (8), 9\.  
Ram, O., Levine, Y., Dalmedigos, I., Muhlgay, D., Shashua, A., Leyton-Brown, K., &  
Shoham, Y. (2023). In-context retrieval-augmented language models. \_Transactions of  
the Association for Computational Linguistics\_ , \_11\_ , 1316–1331. https://doi.org/10.1162/  
tacl\_a\_  
Rozière, B., Gehring, J., Gloeckle, F., Sootla, S., Gat, I., Tan, X.E., Adi, Y., Liu, J., Sauvestre,  
R., Remez, T., Rapin, J., Kozhevnikov, A., Evtimov, I., Bitton, J., Bhatt, M., Ferrer, C.C.,  
Grattafiori, A., Xiong, W., Défossez, A., ... Synnaeve, G. (2024). Code Llama: Open  
foundation models for code. arXiv:2308.  
Semenkin, A., Sokolov, Y., & Vu, E. (2024). Context composing for full line code comple-  
tion. In \_The IDE workshop at the 46th international conference on software engineering\_.  
Sennrich, R., Haddow, B., & Birch, A. (2016). Neural machine translation of rare words  
with subword units. In \_Proceedings of the 54th annual meeting of the association for compu-  
tational linguistics (volume 1: Long papers)\_ (pp. 1715–1725). https://doi.org/10.18653/  
v1/P16-  
Shapkin, A., Litvinov, D., Zharov, Y., Bogomolov, E., Galimzyanov, T., & Bryksin, T.  
(2024). Dynamic retrieval-augmented generation. arXiv:2312.  
Shazeer, N. (2020). GLU variants improve transformer. arXiv:2002.  
Shrivastava, D., Larochelle, H., & Tarlow, D. (2023). Repository-level prompt generation  
for large language models of code. In \_Proceedings of the 40th international conference on  
machine learning\_ (pp. 31693–31715).  
Su, J., Ahmed, M., Lu, Y., Pan, S., Bo, W., & Liu, Y. (2024). RoFormer: Enhanced trans-  
former with rotary position embedding. \_Neurocomputing\_ , \_568\_ , 127063\. https://doi.  
org/10.1016/j.neucom.2023.  
Touvron, H., Lavril, T., Izacard, G., Martinet, X., Lachaux, M.A., Lacroix, T., Rozière, B.,  
Goyal, N., Hambro, E., Azhar, F., Rodriguez, A., Joulin, A., Grave, E., & Lample, G.  
(2023). LLaMA: Open and efficient foundation language models. arXiv:2302.  
Vaswani, A., Shazeer, N., Parmar, N., Uszkoreit, J., Jones, L., Gomez, A.N.,  
Kaiser, L., & Polosukhin, I. (2017). Attention is all you need. In \_Proceedings of  
the 31st international conference on neural information processing systems\_ NIPS’  
(p. 6000–6010).  
Wang, B., Ping, W., Xu, P., McAfee, L., Liu, Z., Shoeybi, M., Dong, Y., Kuchaiev, O., Li, B.,  
Xiao, C., Anandkumar, A., & Catanzaro, B. (2023a). Shall we pretrain autoregressive  
language models with retrieval? A comprehensive study. In \_Proceedings of the 2023  
conference on empirical methods in natural language processing\_ (pp. 7763–7786). https:  
//doi.org/10.18653/v1/2023.emnlp-main.  
Wang, Y., Le, H., Gotmare, A., Bui, N., Li, J., & Hoi, S. (2023b). CodeT5+: Open code  
large language models for code understanding and generation. In \_Proceedings of the  
2023 conference on empirical methods in natural language processing\_ (pp. 1069–1088).  
https://doi.org/10.18653/v1/2023.emnlp-main.  
Wu, D., Ahmad, W., Zhang, D., Ramanathan, M.K., & Ma, X. (2024). REPOFORMER: Se-  
lective retrieval for repository-level code completion. In \_ICML 2024\_.  
Zhang, A., Lipton, Z.C., Li, M., & Smola, A.J. (2023a). Dive into deep learning. Cambridge  
University Press.  
Zhang, F., Chen, B., Zhang, Y., Keung, J., Liu, J., Zan, D., Mao, Y., Lou, J.G., &  
Chen, W. (2023b). RepoCoder: Repository-level code completion through iterative  
retrieval and generation. In \_Proceedings of the 2023 conference on empirical methods  
in natural language processing\_ (pp. 2471–2484). https://doi.org/10.18653/v1/2023.  
emnlp-main.


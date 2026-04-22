\#\#\# GRAPHCODEBERT: PRE-TRAINING CODEREPRESEN-

\#\#\# TATIONS WITHDATAFLOW

\`\`\`  
Daya Guo^1 ∗, Shuo Ren^2 ∗, Shuai Lu^3 ∗, Zhangyin Feng^4 ∗, Duyu Tang^5 , Shujie Liu^5 , Long Zhou^5 ,  
Nan Duan^5 , Alexey Svyatkovskiy^6 , Shengyu Fu^6 , Michele Tufano^6 , Shao Kun Deng^6 ,  
Colin Clement^6 , Dawn Drain^6 , Neel Sundaresan^6 , Jian Yin^1 , Daxin Jiang^7 , and Ming Zhou^5  
\`\`\`  
(^1) School of Computer Science and Engineering, Sun Yat-sen University.  
(^2) Beihang University, (^3) Peking University, (^4) Harbin Institute of Technology,  
(^5) Microsoft Research Asia, (^6) Microsoft Devdiv, (^7) Microsoft STCA

\#\#\#\# ABSTRACT

\`\`\`  
Pre-trained models for programming language have achieved dramatic empirical  
improvements on a variety of code-related tasks such as code search, code comple-  
tion, code summarization, etc. However, existing pre-trained models regard a code  
snippet as a sequence of tokens, while ignoring the inherent structure of code, which  
provides crucial code semantics and would enhance the code understanding process.  
We present GraphCodeBERT, a pre-trained model for programming language that  
considers the inherent structure of code. Instead of taking syntactic-level structure  
of code like abstract syntax tree (AST), we use data flow in the pre-training stage,  
which is a semantic-level structure of code that encodes the relation of “where-  
the-value-comes-from” between variables. Such a semantic-level structure is less  
complex and does not bring an unnecessarily deep hierarchy of AST, the property  
of which makes the model more efficient. We develop GraphCodeBERT based  
on Transformer. In addition to using the task of masked language modeling, we  
introduce two structure-aware pre-training tasks. One is to predict code structure  
edges, and the other is to align representations between source code and code  
structure. We implement the model in an efficient way with a graph-guided masked  
attention function to incorporate the code structure. We evaluate our model on four  
tasks, including code search, clone detection, code translation, and code refine-  
ment. Results show that code structure and newly introduced pre-training tasks can  
improve GraphCodeBERT and achieves state-of-the-art performance on the four  
downstream tasks. We further show that the model prefers structure-level attentions  
over token-level attentions in the task of code search.^1  
\`\`\`  
\#\#\#\# 1 INTRODUCTION

\`\`\`  
Pre-trained models such as ELMo (Peters et al., 2018), GPT (Radford et al., 2018\) and BERT (Devlin  
et al., 2018\) have led to strong improvement on numerous natural language processing (NLP) tasks.  
These pre-trained models are first pre-trained on a large unsupervised text corpus, and then fine-tuned  
on downstream tasks. The success of pre-trained models in NLP also promotes the development of  
pre-trained models for programming language. Existing works (Kanade et al., 2019; Karampatsis &  
Sutton, 2020; Feng et al., 2020; Svyatkovskiy et al., 2020; Buratti et al., 2020\) regard a source code  
as a sequence of tokens and pre-train models on source code to support code-related tasks such as  
code search, code completion, code summarization, etc. However, previous works only utilize source  
code for pre-training, while ignoring the inherent structure of code. Such code structure provides  
useful semantic information of code, which would benefit the code understanding process. Taking  
the expressionv=maxvalue−minvalueas an example,vis computed frommaxvalueand  
minvalue. Programmers do not always follow the naming conventions so that it’s hard to understand  
the semantic of the variablevonly from its name. The semantic structure of code provides a way to  
understand the semantic of the variablevby leveraging dependency relation between variables.  
∗Work done while this author was an intern at Microsoft Research Asia. Contact: Daya Guo  
(guody5@mail2.sysu.edu.cn)  
\`\`\`  
(^1) All the codes and data are available athttps://github.com/microsoft/CodeBERT.

\#\# arXiv:2009.08366v4 \[cs.SE\] 13 Sep 2021

In this work, we present GraphCodeBERT, a pre-trained model for programming language that  
considers the inherent structure of code. Instead of taking syntactic-level structure of code like  
abstract syntax tree (AST), we leverage semantic-level information of code, i.e. data flow, for pre-  
training. Data flow is a graph, in which nodes represent variables and edges represent the relation of  
“where-the-value-comes-from” between variables. Compared with AST, data flow is less complex  
and does not bring an unnecessarily deep hierarchy, the property of which makes the model more  
efficient. In order to learn code representation from source code and code structure, we introduce two  
new structure-aware pre-training tasks. One is data flow edges prediction for learning representation  
from code structure, and the other is variable-alignment across source code and data flow for aligning  
representation between source code and code structure. GraphCodeBERT is based on Transformer  
neural architecture (Vaswani et al., 2017\) and we extend it by introducing a graph-guided masked  
attention function to incorporate the code structure.

\`\`\`  
We pre-train GraphCodeBERT on the CodeSearchNet dataset (Husain et al., 2019), which includes  
2.3M functions of six programming languages paired with natural language documents. We evaluate  
the model on four downstream tasks: natural language code search, clone detection, code translation,  
and code refinement. Experiments show that our model achieves state-of-the-art performance on the  
four tasks. Further analysis shows that code structure and newly introduced pre-training tasks can  
improve GraphCodeBERT and the model has consistent preference for attending data flow.  
\`\`\`  
\`\`\`  
In summary, the contributions of this paper are: (1) GraphCodeBERT is the first pre-trained model  
that leverages semantic structure of code to learn code representation. (2) We introduce two new  
structure-aware pre-training tasks for learning representation from source code and data flow. (3)  
GraphCodeBERT provides significant improvement on four downstream tasks, i.e. code search, clone  
detection, code translation, and code refinement.  
\`\`\`  
\#\#\#\# 2 RELATEDWORKS

\`\`\`  
Pre-Trained Models for Programming Languages Inspired by the big success of pre-training in  
NLP (Devlin et al., 2018; Yang et al., 2019; Liu et al., 2019; Raffel et al., 2019), pre-trained models  
for programming languages also promotes the development of code intelligence (Kanade et al., 2019;  
Feng et al., 2020; Karampatsis & Sutton, 2020; Svyatkovskiy et al., 2020; Buratti et al., 2020).  
Kanade et al. (2019) pre-train a BERT model on a massive corpus of Python source codes by masked  
language modeling and next sentence prediction objectives. Feng et al. (2020) propose CodeBERT, a  
bimodal pre-trained model for programming and natural languages by masked language modeling and  
replaced token detection to support text-code tasks such as code search. Karampatsis & Sutton (2020)  
pre-train contextual embeddings on a JavaScript corpus using the ELMo framework for program  
repair task. Svyatkovskiy et al. (2020) propose GPT-C, which is a variant of the GPT-2 trained from  
scratch on source code data to support generative tasks like code completion. Buratti et al. (2020)  
present C-BERT, a transformer-based language model pre-trained on a collection of repositories  
written in C language, and achieve high accuracy in the abstract syntax tree (AST) tagging task.  
\`\`\`  
\`\`\`  
Different with previous works, GraphCodeBERT is the first pre-trained model that leverages code  
structure to learn code representation to improve code understanding. We further introduce a graph-  
guided masked attention function to incorporate the code structure into Transformer and two new  
structure-aware pre-training tasks to learn representation from source code and code structure.  
\`\`\`  
\`\`\`  
Neural Networks with Code Structure In recent years, some neural networks leveraging code  
structure such as AST have been proposed and achieved strong performance in code-related tasks like  
code completion (Li et al., 2017; Alon et al., 2019; Kim et al., 2020), code generation (Rabinovich  
et al., 2017; Yin & Neubig, 2017; Brockschmidt et al., 2018), code clone detection (Wei & Li, 2017;  
Zhang et al., 2019; Wang et al., 2020), code summarization (Alon et al., 2018; Hu et al., 2018\) and so  
on (Nguyen & Nguyen, 2015; Allamanis et al., 2018; Hellendoorn et al., 2019). Nguyen & Nguyen  
(2015) propose an AST-based language model to support the detection and suggestion of a syntactic  
template at the current editing location. Allamanis et al. (2018) use graphs to represent programs  
and graph neural network to reason over program structures. Hellendoorn et al. (2019) propose two  
different architectures using a gated graph neural network and Transformers for combining local  
and global information to leverage richly structured representations of source code. However, these  
\`\`\`

works leverage code structure to learn models on specific tasks from scratch without using pre-trained  
models. In this work, we study how to leverage code structure for pre-training code representation.

\#\#\#\# 3 DATAFLOW

In this section, we describe the basic concept and extraction of data flow. In next section, we will  
describe how to use data flow for pre-training.

Data flow is a graph that represents dependency relation between variables, in which nodes represent  
variables and edges represent where the value of each variable comes from. Unlike AST, data flow  
is same under different abstract grammars for the same source code. Such code structure provides  
crucial code semantic information for code understanding. Takingv=maxvalue−minvalueas  
an example, programmers do not always follow the naming conventions so that it is hard to understand  
the semantic of the variable. Data flow provides a way to understand the semantic of the variablevto  
some extent, i.e. the value ofvcomes frommaxvalueandminvaluein data flow. Besides, data  
flow supports the model to consider long-range dependencies induced by using the same variable  
or function in distant locations. Taking Figure 1 as an example, there are four variables with same  
name (i.e.x^3 ,x^7 ,x^9 andx^11 ) but with different semantic. The graph in the figure shows dependency  
relation between these variables and supportsx^11 to pay more attention tox^7 andx^9 instead ofx^3.  
Next, we describe how to extract data flow from a source code.

\`\`\`  
defmax(a,b):  
x=  
ifb\>a:  
x=b  
else:  
x=a  
returnx  
\`\`\`  
\`\`\`  
Sourcecode ParseintoAST  
\`\`\`  
\`\`\`  
CompilerTool  
\`\`\`  
\`\`\`  
Identifyvariable  
sequence  
\`\`\`  
\`\`\`  
5  
\`\`\`  
\`\`\`  
1  
3  
6  
7 8  
\`\`\`  
\`\`\`  
9 10  
\`\`\`  
\`\`\`  
4  
\`\`\`  
\`\`\`  
2  
\`\`\`  
\`\`\`  
11  
\`\`\`  
\`\`\`  
defmax(a,b):  
x=  
ifb\>a:  
x=b  
else:  
x=a  
returnx  
\`\`\`  
\`\`\`  
Identify variable sequence in AST  
\`\`\`  
\`\`\`  
Variable relation  
\`\`\`  
\`\`\`  
a b  
\`\`\`  
\`\`\`  
x 0  
\`\`\`  
\`\`\`  
a b  
b  
x  
\`\`\`  
\`\`\`  
a  
x  
x  
\`\`\`  
\`\`\`  
1 2  
\`\`\`  
\`\`\`  
3 4  
\`\`\`  
\`\`\`  
6 5  
10 8  
\`\`\`  
(^97)  
\*\*11\*\*  
Extract variable relation from AST  
Valuecomesfrom  
...  
definitionfunction  
name parameters  
max a b body  
expressionstatement  
assignment  
left right  
x 0  
If statement statementreturn  
condition x  
left right  
a b  
operator  
\>  
alternative  
...  
Figure 1: The procedure of extracting data flow given a source code. The graph in the rightmost is  
data flow that represents the relation of ”where-the-value-comes-from” between variables.  
Figure 1 shows the extraction of data flow through a source code. Given a source codeC \=  
{c 1 ,c 2 ,...,cn}, we first parse the code into an abstract syntax tree (AST) by a standard compiler  
tool^2. The AST includes syntax information of the code and terminals (leaves) are used to identify  
the variable sequence, denoted asV={v 1 ,v 2 ,...,vk}. We take each variable as a node of the graph  
and an direct edgeε=〈vi,vj〉fromvitovjrefers that the value ofj-th variable comes fromi-th  
variable. Takingx=expras an example, edges from all variables inexprtoxare added into the  
graph. We denote the set of directed edges asE={ε 1 ,ε 2 ,...,εl}and the graphG(C) \= (V,E)is  
data flow used to represent dependency relation between variables of the source codeC.

\#\#\#\# 4 GRAPHCODEBERT

In this section, we describe GraphCodeBERT, a graph-based pre-trained model based on Transformer  
for programming language. We introduce model architecture, graph-guided masked attention and  
pre-training tasks including standard masked language model and newly introduced ones. More  
details about model pre-training setting are provided in the Appendix A.

(^2) https://github.com/tree-sitter/tree-sitter

\`\`\`  
Valuecomesfrom Variable Sequence  
\`\`\`  
\`\`\`  
Return maximum value ... x=0 if b\> a : x=b else ...  
Te x t Code  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
1  
b  
\`\`\`  
\`\`\`  
2  
x  
\`\`\`  
\`\`\`  
3  
0  
\`\`\`  
\`\`\`  
4  
b  
\`\`\`  
\`\`\`  
5  
a  
\`\`\`  
\`\`\`  
6  
x  
\`\`\`  
(^7) b^8 x^9 a (^10) x^11  
\*\*Sourcecode  
Comment\*\*  
\_Return maximum value\_  
\*\*Data Flow  
\[CLS\]\*\* \_Return\_ \*\*\_\[MASK\]\_\*\* \_value\_ \*\*\[SEP\]\*\* \_... x=0 if b\>\_ \*\*\_\[MASK\]\_\*\* \_: x=b else ...\_ \*\*\[SEP\]\*\* a^1 b  
\*\*2\*\*  
x  
\*\*3\*\*  
0  
\*\*4\*\*  
b  
\*\*5\*\*  
a  
\*\*6\*\*  
x  
(^7) b (^8) x (^9) a (^10) x \*\*11  
...  
L  
L  
L\*\*

\#\#\# GraphCodeBERT

\`\`\`  
maximum a  
\`\`\`  
\`\`\`  
1 2 4 5 6 8 10  
\`\`\`  
\`\`\`  
dataflowedge  
prediction among  
variables  
\`\`\`  
\`\`\`  
x x x^37911  
\`\`\`  
\`\`\`  
variable-alignment  
across source code  
and data flow  
\`\`\`  
\`\`\`  
Masked Language Modeling  
\`\`\`  
\`\`\`  
11  
\`\`\`  
\`\`\`  
9 10  
\`\`\`  
\`\`\`  
78  
\`\`\`  
\`\`\`  
56  
\`\`\`  
\`\`\`  
3 4  
defmax(a,^1 b):^2  
x=  
if b\>a:  
x=b  
else:  
x=a  
returnx  
\`\`\`  
Figure 2: An illustration about GraphCodeBERT pre-training. The model takes source code paired  
with comment and the corresponding data flow as the input, and is pre-trained using standard masked  
language modeling (Devlin et al., 2018\) and two structure-aware tasks. One structure-aware task is to  
predict where a variable is identified from (marked with orange lines) and the other is data flow edges  
prediction between variables (marked with blue lines).

\#\#\#\#\#\# 4.1 MODELARCHITECTURE

Figure 2 shows the model architecture of GraphCodeBERT. We follow BERT (Devlin et al., 2018\)  
and use the multi-layer bidirectional Transformer (Vaswani et al., 2017\) as the model backbone.  
Instead of only using source code, we also utilize paired comments to pre-train the model to support  
more code-related tasks involving natural language such as natural language code search (Feng et al.,  
2020). We further take data flow, which is a graph, as a part of the input to the model.

Given a source codeC={c 1 ,c 2 ,...,cn}with its commentW={w 1 ,w 2 ,...,wm}, we can obtain  
the corresponding data flowG(C) \= (V,E)as discussed in the Section 3, whereV={v 1 ,v 2 ,...,vk}  
is a set of variables andE={ε 1 ,ε 2 ,...,εl}is a set of direct edges that represent where the value of  
each variable comes from. We concatenate the comment, source code and the set of variables as the  
sequence inputX={\[CLS\],W,\[SEP\],C,\[SEP\],V}, where\[CLS\]is a special token in front of  
three segments and\[SEP\]is a special symbol to split two kinds of data types.

GraphCodeBERT takes the sequenceXas the input and then converts the sequence into input vectors  
H^0. For each token, its input vector is constructed by summing the corresponding token and position  
embeddings. We use a special position embedding for all variables to indicate that they are nodes  
of data flow. The model applies N transformer layers over the input vectors to produce contextual  
representationsHn=transformern(Hn−^1 ),n∈\[1,N\]. Each transformer layer contains an  
architecturally identical transformer that applies a multi-headed self-attention operation (Vaswani  
et al., 2017\) followed by a feed forward layer over the inputHn−^1 in then-th layer.

\`\`\`  
Gn=LN(MultiAttn(Hn−^1 ) \+Hn−^1 ) (1)  
Hn=LN(FFN(Gn) \+Gn) (2)  
\`\`\`  
whereMultiAttnis a multi-headed self-attention mechanism,FFNis a two layers feed forward  
network, andLNrepresents a layer normalization operation. For then-th transformer layer, the  
outputGˆnof a multi-headed self-attention is computed via:

\`\`\`  
Qi=Hn−^1 WiQ, Ki=Hn−^1 WiK, Vi=Hn−^1 WiV (3)  
\`\`\`  
\`\`\`  
headi= softmax(  
\`\`\`  
\`\`\`  
QiKTi  
√  
dk  
\`\`\`  
\`\`\`  
\+ M)Vi (4)  
\`\`\`  
\`\`\`  
Gˆn= \[head 1 ;...;headu\]WnO (5)  
\`\`\`  
where the previous layer’s outputHn−^1 ∈R|X|×dhis linearly projected to a triplet of queries, keys  
and values using model parametersWiQ,WiK,WiV∈Rdh×dk, respectively.uis the number of heads,

dkis the dimension of a head, andWnO∈Rdh×dhis the model parameters.M∈R|X|×|X|is a mask  
matrix, whereMijis 0 ifi-th token is allowed to attendj-th token otherwise−∞.

\#\#\#\#\#\# 4.2 GRAPH-GUIDEDMASKEDATTENTION

To incorporate the graph structure into Transformer, we define a graph-guided masked attention  
function to filter out irrelevant signals. The attention masking function could avoid the keykiattended  
by the queryqjby adding the attention scoreqTjkian infinitely negative value so that the attention  
weight becomes zero after using a softmax function. To represent dependency relation between  
variables, a node-queryqviis allowed to attend to a node-keykvjif there is a direct edge from the  
nodevjto the nodevi(i.e.〈vj,vi〉 ∈E) or they are the same node (i.e.i=j). Otherwise, the  
attention is masked by adding an infinitely negative value into the attention score. To represent

the relation between source code tokens and nodes of the data flow, we first define a setE

′  
, where  
〈vi,cj〉/〈cj,vi〉∈E

\`\`\`  
′  
if the variableviis identified from the source code tokencj. We then allow the  
\`\`\`  
nodeqviand codekcjattend each other if and only if〈vi,cj〉/〈cj,vi〉∈E

\`\`\`  
′  
\`\`\`  
. More formally, we use  
the following graph-guided masked attention matrix as the mask matrixMin the equation 4:

\`\`\`  
Mij=  
\`\`\`  
\#\#\#\#\#\# {

\`\`\`  
0 ifqi∈{\[CLS\],\[SEP\]}orqi,kj∈W∪Cor〈qi,kj〉∈E∪E  
\`\`\`  
\`\`\`  
′  
\`\`\`  
\`\`\`  
−∞ otherwise  
\`\`\`  
\#\#\#\#\#\# (6)

\#\#\#\#\#\# 4.3 PRE-TRAININGTASKS

We describe three pre-training tasks used for pre-training GraphCodeBERT in this section. The first  
task is masked language modeling (Devlin et al., 2018\) for learning representation from the source  
code. The second task is data flow edge prediction for learning representation from data flow, where  
we first mask some variables’ data flow edges and then let GraphCodeBERT predict those edges. The  
last task is variable-alignment across source code and data flow for aligning representation between  
source code and data flow, which predicts where a variable is identified from.

Masked Language Modeling We follow Devlin et al. (2018) to apply masked language modeling  
(MLM) pre-training task. Specially, we sample randomly 15% of the tokens from the source code and  
paired comment. We replace them with a \[MASK\] token 80% of the time, with a random token 10%  
of the time, and leave them unchanged 10% of the time. The MLM objective is to predict original  
tokens of these sampled tokens, which has proven effective in previous works (Devlin et al., 2018;  
Liu et al., 2019; Feng et al., 2020). In particular, the model can leverage the comment context if the  
source code context is not sufficient to infer the masked code token, encouraging the model to align  
the natural language and programming language representations.

Edge Prediction To learn representation from data flow, we introduce a pre-training task of data  
flow edges prediction. The motivation is to encourage the model to learn structure-aware repre-  
sentation that encodes the relation of “where-the-value-comes-from” for better code understanding.  
Specially, we randomly sample 20% of nodesVsin data flow, mask direct edges connecting these  
sampled nodes by add an infinitely negative value in the mask matrix, and then predict these masked  
edgesEmask. Taking the variablex^11 in Figure 2 for an example, we first mask edges〈x^7 ,x^11 〉  
and〈x^9 ,x^11 〉in the graph and then let the model to predict these edges. Formally, the pre-training  
objective of the task is calculated as Equation 7, whereEc=Vs×V∪V×Vsis a set of candidates  
for edge prediction,δ(eij∈E)is 1 if〈vi,vj〉∈Eotherwise 0, and the probabilitypeijof existing  
an edge fromi-th toj-th node is calculated by dot product following a sigmoid function using  
representations of two nodes from GraphCodeBERT. To balance positive-negative ratio of examples,  
we sample negative and positive samples with the same number forEc.

\`\`\`  
lossEdgePred=−  
\`\`\`  
\#\#\#\#\#\# ∑

\`\`\`  
eij∈Ec  
\`\`\`  
\`\`\`  
\[δ(eij∈Emask)logpeij+ (1−δ(eij∈Emask))log(1−peij)\] (7)  
\`\`\`  
Node Alignment To align representation between source code and data flow, we introduce a pre-  
training task of node alignment across source code and data flow, which is similar to data flow edge  
prediction. Instead of predicting edges between nodes, we predict edges between code tokens and  
nodes. The motivation is to encourage the model to align variables and source code according to  
data flow. Taking Figure 3 for an example, we first mask edges between the variablex^11 in data flow  
and code tokens, and then predict which code token the variablex^11 in data flow is identified from.  
As we can see, the model could predict that the variablex^11 is identified form the variablexin the  
expression “return x” according to data flow information (i.e. the value ofx^11 comes fromx^7 orx^9 ).

\# GraphCodeBERT

\`\`\`  
Te x t Code Variable Sequence  
\`\`\`  
\`\`\`  
\[CLS\] Return \[MASK\] value \[SEP\] def max ( a , b ) : x=0 if b\>a : x=b else: x=a return x \[SEP\] 𝑎𝑎^1 𝑏𝑏^2 𝑥𝑥^304 𝑏𝑏^5 𝑎𝑎^6 𝑥𝑥^7 𝑏𝑏^8 𝑥𝑥^9 𝑎𝑎^10 𝑥𝑥^11  
\`\`\`  
\`\`\`  
Predict which code token the variable 𝑥𝑥^11 in  
data flow is identified from  
\`\`\`  
\`\`\`  
Mask edges between the variable 𝑥𝑥^11 in data flow and code tokens  
\`\`\`  
\`\`\`  
Figure 3: An example of the Node Alignment task.  
\`\`\`  
Specially, we randomly sample 20% nodesV

′  
sin the graph, mask edges between code tokens and  
sampled nodes, and then predict masked edgesE

′  
mask. The pre-training objective of this task is  
similar to Equation 7, whereE

\`\`\`  
′  
c=V  
\`\`\`  
′  
s×Cis a set of candidates for node alignment. Similarly, we  
also sample negative and positive samples with the same number forE

\`\`\`  
′  
c.  
\`\`\`  
\`\`\`  
lossNodeAlign=−  
\`\`\`  
\#\#\#\#\#\# ∑

\`\`\`  
eij∈E′c  
\`\`\`  
\`\`\`  
\[δ(eij∈E  
\`\`\`  
\`\`\`  
′  
mask)logpeij+ (1−δ(eij∈E  
\`\`\`  
\`\`\`  
′  
mask))log(1−peij)\] (8)  
\`\`\`  
\#\#\#\# 5 EXPERIMENTS

We evaluate our model on four downstream tasks, including code search, clone detection, code  
translation and code refinement. Detailed experimental settings can be found in the Appendix.

\#\#\#\#\#\# 5.1 NATURALLANGUAGECODESEARCH

Given a natural language as the input, the task aims to find the most semantically related code from a  
collection of candidate codes. We conduct experiments on the CodeSearchNet code corpus (Husain  
et al., 2019), which includes six programming languages. Different from the dataset and the setting  
used in the Husain et al. (2019), we filter low-quality queries by handcrafted rules and expand 1000  
candidates to the whole code corpus, which is closer to the real-life scenario. We use Mean Reciprocal  
Rank (MRR) as our evaluation metric and report results of existing methods in the Table 1\. We  
provide more details about the filtered dataset and also give results using the same setting of Husain  
et al. (2019) in the Appendix B.

\`\`\`  
model Ruby Javascript Go Python Java Php Overall  
NBow 0.162 0.157 0.330 0.161 0.171 0.152 0\.  
CNN 0.276 0.224 0.680 0.242 0.263 0.260 0\.  
BiRNN 0.213 0.193 0.688 0.290 0.304 0.338 0\.  
selfAtt 0.275 0.287 0.723 0.398 0.404 0.426 0\.  
RoBERTa 0.587 0.517 0.850 0.587 0.599 0.560 0\.  
RoBERTa (code) 0.628 0.562 0.859 0.610 0.620 0.579 0\.  
CodeBERT 0.679 0.620 0.882 0.672 0.676 0.628 0\.  
GraphCodeBERT 0.703 0.644 0.897 0.692 0.691 0.649 0\.  
\`\`\`  
Table 1: Results on code search. GraphCodeBERT outperforms other models significantly (p \< 0\. 01 ).

All models calculate inner product of code and query encodings as relevance scores to rank candidate  
codes. We follow Husain et al. (2019) to implement four methods as baselines in the first group to  
obtain the encodings, including bag-of-words, convolutional neural network, bidirectional recurrent  
neural network, and multi-head attention. The second group is the results of pre-trained models.  
Roberta (Liu et al., 2019\) is a pre-trained model on text corpus with MLM learning objective,  
whileRoBERTa (code)is pre-trained only on code.CodeBERT(Feng et al., 2020\) is pre-trained

on code-text pairs with MLM and replaced token detection learning objectives. As we can see,  
GraphCodeBERTthat leverages code structure for pre-training brings a 2% gain of MRR, achieving  
the state-of-art performance. We also conducted t-test between our GraphCodeBERT and other  
baselines, and the results show the improvements are significant withp \< 0\. 01\.

\#\#\#\#\#\# 5.2 CODECLONEDETECTION

Code clones are multiple code fragments that output similar results when given the same input. The  
task aims to measure the similarity between two code fragments, which can help reduce the cost of  
software maintenance and prevent bugs. We conduct experiments on the BigCloneBench dataset  
(Svajlenko et al., 2014\) and report results in the Table 2\.

Deckard(Jiang et al., 2007\) is to compute vectors for structural information within ASTs and  
then a Locality Sensitive Hashing (LSH) (Datar et al., 2004\) is used to cluster similar vectors for  
detection.RtvNN(White et al., 2016\) trains a recursive autoencoder to learn representations for  
AST.CDLH(Wei & Li, 2017\) learn representations of code fragments via AST-based LSTM and  
hamming distance is used to optimize the distance between the vector representation of AST pairs.

\`\`\`  
Model Precision Recall F  
Deckard 0.93 0.02 0\.  
RtvNN 0.95 0.01 0\.  
CDLH 0.92 0.74 0\.  
ASTNN 0.92 0.94 0\.  
FA-AST-GMN 0.96 0.94 0\.  
RoBERTa (code) 0.949 0.922 0\.  
CodeBERT 0.947 0.934 0\.  
GraphCodeBERT 0.948 0.952 0\.  
\`\`\`  
\`\`\`  
Table 2: Results on code clone detection. Graph-  
CodeBERT outperforms other pre-trained methods  
significantly (p \< 0\. 01 ).  
\`\`\`  
ASTNNZhang et al. (2019) uses RNNs to  
encode AST subtrees for statements, then  
feed the encodings of all statement trees into  
an RNN to learn representation for a pro-  
gram. FA-AST-GMN(Wang et al., 2020\)  
uses GNNs over a flow-augmented AST to  
leverages explicit control and data flow in-  
formation for code clone detection. Results  
show that ourGraphCodeBERTthat lever-  
ages code structure information significantly  
outperforms other methods withp \< 0\. 01 ,  
which demonstrates the effectiveness of our  
pre-trained model for the task of code clone  
detection.

\#\#\#\#\#\# 5.3 CODETRANSLATION

Code translation aims to migrate legacy software from one programming language in a platform to  
another. Following Nguyen et al. (2015) and Chen et al. (2018), we conduct experiments on a dataset  
crawled from the same several open-source projects as them and report results in the Table 3\.

TheNaivemethod is directly copying the source code as the translation result.PBSMTis short  
for phrase-based statistical machine translation (Koehn et al., 2003), and has been exploited in  
previous works (Nguyen et al., 2013; Karaivanov et al., 2014). As for theTransformer, we use the

\`\`\`  
Method BLEUJava→C\#Acc BLEUC\#→JavaAcc  
Naive 18.54 0.0 18.69 0\.  
PBSMT 43.53 12.5 40.06 16\.  
Transformer 55.84 33.0 50.47 37\.  
RoBERTa (code) 77.46 56.1 71.99 57\.  
CodeBERT 79.92 59.0 72.14 58\.  
GraphCodeBERT 80.58 59.4 72.64 58\.  
\`\`\`  
\`\`\`  
Table 3: Results on code translation.  
\`\`\`  
same number of layers and hidden size  
as pre-trained models. To leverage the  
pre-trained models for translation, we ini-  
tialize the encoder with pre-trained mod-  
els and randomly initialize parameters of  
the decoder and the source-to-target atten-  
tion. Results show that the models initial-  
ized with pre-trained models (i.e the second  
group) outperform PBSMT and Transformer  
models. Among them, GraphCodeBERT  
achieves state-of-art performance, which  
demonstrates the effectiveness of our model  
for code translation.

\#\#\#\#\#\# 5.4 CODEREFINEMENT

Code refinement aims to automatically fix bugs in the code, which can contribute to reducing the cost  
of bug-fixes. We use the dataset released by Tufano et al. (2019) and report results in the Table 4\.

TheNaivemethod directly copies the buggy code as the refinement result. For theTransformer, we  
use the same number of layers and hidden size as the pre-trained models. Same as the Section 5.3,  
we initialize the encoder with pre-trained models and randomly initialize parameters of the decoder

\`\`\`  
Method BLEUsmallAcc BLEUmediumAcc  
Naive 78.06 0.0 90.91 0\.  
LSTM 76.76 10.0 72.08 2\.  
Transformer 77.21 14.7 89.25 3\.  
RoBERTa (code) 77.30 15.9 90.07 4\.  
CodeBERT 77.42 16.4 91.07 5\.  
GraphCodeBERT 80.02 17.3 91.31 9\.  
\`\`\`  
\`\`\`  
Table 4: Results on code refinement.  
\`\`\`  
and the source-to-target attention. Then  
we use the training data to fine-tune  
the whole model. In the table, we see  
that theTransformersignificantly out-  
performsLSTM. Results in the second  
group shows that pre-trained models out-  
perform Transformer models further, and  
GraphCodeBERTachieves better per-  
formance than other pre-trained models  
on both datasets, which shows leveraging  
code structure information are helpful to  
the task of code refinement.

\#\#\#\#\#\# 5.5 MODELANALYSIS

Ablation Study We conduct ablation study on the task of natural language code search to under-  
stand various components in our approach impact overall performance. We remove two pre-training  
tasks and data flow, respectively, to analyze their contribution. Table 5 shows that the overall perfor-  
mance drops from 71.3% to 70.3%∼70.7% when removing Node Alignment and Edge Prediction  
pre-training tasks, respectively, which reveals the importance of two structure-aware pre-training  
tasks. After ablating the data flow totally, we can see that the performance drops from 71.3% to 69.3%,  
which means leveraging data flow to learn code representation could improve GraphCodeBERT.

\`\`\`  
Methods Ruby Javascript Go Python Java Php Overall  
GraphCodeBERT 0.703 0.644 0.897 0.692 0.691 0.649 0\.  
\-w/o EdgePred 0.701 0.632 0.894 0.687 0.688 0.640 0\.  
\-w/o NodeAlign 0.685 0.635 0.887 0.682 0.690 0.640 0\.  
\-w/o Data Flow 0.679 0.620 0.882 0.672 0.676 0.628 0\.  
\`\`\`  
\`\`\`  
Table 5: Ablation study on natural language code search  
\`\`\`  
Node-vs. Token-level Attention Table 6 shows how frequently a special token\[CLS\]that is used  
to calculate probability of correct candidate attends to code tokens (Codes) and variables (Nodes).  
We see that although the number of nodes account for 5%∼20%, attentions over nodes overwhelm  
node/code ratio (around 10% to 32%) across all programming languages. The results indicate that  
data flow plays an important role in code understanding process and the model pays more attention to  
nodes in data flow than code tokens.

\`\`\`  
Ruby Javascript Go Python Java Php  
Codes/Nodes 90.1/9.9 94.6/5.4 95.0/5.03 80.6/19.4 93.2/6.8 87.5/12.  
\[CLS\]→Codes/Nodes 82.3/17.7 89.7/10.3 91.0/9.0 67.7/32.3 87.8/12.2 79.4/20.  
\`\`\`  
Table 6: Attention distribution (%) between code tokens (codes) and variables (nodes) across different  
programming language on natural language code search test sets. The first row is the ratio of the  
number of code tokens to nodes, and the second row is attention distribution of\[CLS\]token.

Comparison between AST and Data Flow Figure 4 shows MRR score with respect to input  
sequence length on the validation dataset of Ruby programming language for the task of code  
search. AST Pre-order Traversalregards AST as a sequence by linearizing all AST nodes us-  
ing pre-order traversal algorithm. AST Subtree Maskingregards AST as a tree and introduce  
subtree masking (Nguyen et al., 2019\) for self-attention of the Transformer. In subtree masking,  
each node-query in AST attends only to its own subtree descendants, and each leaf-query only  
attends to leaves of AST. Transformer has a self-attention component withO(n^2 )time and memory  
complexity wherenis the input sequence length, and thus is not efficient to scale to long inputs.

\`\`\`  
64 96 128 192 256 512  
Sequence Length  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
0\.  
\`\`\`  
\`\`\`  
MRR Score  
\`\`\`  
\`\`\`  
w/o code structure  
AST Pre-order Traversal  
AST Subtree Masking  
GraphCodeBERT  
\`\`\`  
\`\`\`  
Figure 4: MRR score on the validation dataset of Ruby for code  
search with varying length of input sequence.  
\`\`\`  
We observe that injecting AST  
even hurts the performance when  
the sequence length is short (e.g.  
shorter than 128), while Graph-  
CodeBERT consistently brings  
performance boost on varying se-  
quence length and obtains better  
MRR score than AST-based meth-  
ods. The main reason is that data  
flow is less complex and the num-  
ber of nodes account for5%∼  
20%(see Table 6), which does not  
bring an unnecessarily deep hierar-  
chy of AST and makes the model  
more accurate and efficient.

Case Study We also give a case study to demonstrate that data flow would enhance the code  
understanding process. Given a source code and a comment, we use GraphCodeBERT with and  
without data flow to predict whether the comment correctly describes the source code. Results are  
given in Figure 5\. We can see that both models make correct prediction in the original example, where  
the threshold is 0.5 (left panel). To study the code understanding ability of models, we change the  
source code (center panel) and the comment (right panel), respectively. Although we make a small  
change on the source code (return a→return b) and the comment (sum value→mean value),  
the semantic of the source code and the comment are completely different and corresponding gold  
labels change from 1 to 0\. As we can see in the figure, GraphCodeBERT without using data flow  
fails these tests and still outputs high probability for negative examples. After leveraging data flow,  
GraphCodeBERT better understands the semantic of source code and makes correct predictions on all  
tests, which demonstrates that data flow could improve the code understanding ability of the model.

\`\`\`  
Unchanged Code: 𝑟𝑟𝑟𝑟𝑟𝑟𝑟𝑟𝑟𝑟𝑟𝑟 𝑎𝑎→𝑟𝑟𝑟𝑟𝑟𝑟𝑟𝑟𝑟𝑟𝑟𝑟 𝑏𝑏NL: 𝑠𝑠𝑟𝑟 𝑠𝑠𝑣𝑣𝑎𝑎𝑣𝑣 𝑟𝑟𝑟𝑟 →𝑠𝑠𝑟𝑟𝑎𝑎𝑟𝑟 𝑣𝑣𝑎𝑎𝑣𝑣 𝑟𝑟𝑟𝑟  
\`\`\`  
\`\`\`  
Input  
\`\`\`  
\`\`\`  
Label 1 0 0  
\`\`\`  
\`\`\`  
Prediction  
\`\`\`  
\`\`\`  
GraphCodeBERT: 0.6563 (1)  
GraphCodeBERT: 0.8728 (1)  
(w/o Data Flow)  
\`\`\`  
\`\`\`  
GraphCodeBERT: 0.4615 (0)  
GraphCodeBERT: 0.8608 (1)  
(w/o Data Flow)  
\`\`\`  
\`\`\`  
GraphCodeBERT: 0.2884 (0)  
GraphCodeBERT: 0.9048 (1)  
(w/o Data Flow)  
\`\`\`  
\`\`\`  
NL:  
Returnsumvalueofanarray  
Code:  
import numpyas np  
def f(array):  
a=np.sum(array)  
b=np.mean(array)  
return a  
\`\`\`  
\`\`\`  
NL:  
Returnsumvalueofanarray  
Code:  
import numpyas np  
def f(array):  
a=np.sum(array)  
b=np.mean(array)  
return b  
\`\`\`  
\`\`\`  
NL:  
Return mean valueofanarray  
Code:  
import numpyas np  
def f(array):  
a=np.sum(array)  
b=np.mean(array)  
return a  
\`\`\`  
Figure 5: We take a comment and a source code as the input (first row), and use GraphCodeBERT  
with and without data flow to predict the probability of the source code matching the comment (third  
row). The label is 1 if the comment correctly describes the source code otherwise 0 (second row).

\#\#\#\# 6 CONCLUSION

In this paper, we present GraphCodeBERT that leverages data flow to learn code representation.  
To the best of our knowledge, this is the first pre-trained model that considers code structure for  
pre-training code representations. We introduce two structure-aware pre-training tasks and show  
that GraphCodeBERT achieves state-of-the-art performance on four code-related downstream tasks,  
including code search, clone detection, code translation and code refinement. Further analysis shows  
that code structure and newly introduced pre-training tasks boost the performance. Additionally, case  
study in the task of code search shows that applying data flow in the pre-trained model improves code  
understanding.

\#\#\#\#\#\# ACKNOWLEDGMENTS

Daya Guo and Jian Yin are supported by the Research Foundation of Science and Technology Plan  
Project in Guangdong Province (2017B030308007).

\#\#\#\# REFERENCES

Miltiadis Allamanis, Marc Brockschmidt, and Mahmoud Khademi. Learning to represent programs  
with graphs. InInternational Conference on Learning Representations, 2018\.

Uri Alon, Shaked Brody, Omer Levy, and Eran Yahav. code2seq: Generating sequences from  
structured representations of code.arXiv preprint arXiv:1808.01400, 2018\.

Uri Alon, Roy Sadaka, Omer Levy, and Eran Yahav. Structural language models of code.arXiv, pp.  
arXiv–1910, 2019\.

Marc Brockschmidt, Miltiadis Allamanis, Alexander L Gaunt, and Oleksandr Polozov. Generative  
code modeling with graphs.arXiv preprint arXiv:1805.08490, 2018\.

Luca Buratti, Saurabh Pujar, Mihaela Bornea, Scott McCarley, Yunhui Zheng, Gaetano Rossiello,  
Alessandro Morari, Jim Laredo, Veronika Thost, Yufan Zhuang, et al. Exploring software natural-  
ness throughneural language models.arXiv preprint arXiv:2006.12641, 2020\.

Xinyun Chen, Chang Liu, and Dawn Song. Tree-to-tree neural networks for program translation. In  
Advances in neural information processing systems, pp. 2547–2557, 2018\.

Mayur Datar, Nicole Immorlica, Piotr Indyk, and Vahab S Mirrokni. Locality-sensitive hashing  
scheme based on p-stable distributions. InProceedings of the twentieth annual symposium on  
Computational geometry, pp. 253–262, 2004\.

Jacob Devlin, Ming-Wei Chang, Kenton Lee, and Kristina Toutanova. Bert: Pre-training of deep  
bidirectional transformers for language understanding.arXiv preprint arXiv:1810.04805, 2018\.

Zhangyin Feng, Daya Guo, Duyu Tang, Nan Duan, Xiaocheng Feng, Ming Gong, Linjun Shou, Bing  
Qin, Ting Liu, Daxin Jiang, et al. Codebert: A pre-trained model for programming and natural  
languages.arXiv preprint arXiv:2002.08155, 2020\.

Daya Guo, Duyu Tang, Nan Duan, M. Zhou, and Jian Yin. Dialog-to-action: Conversational question  
answering over a large-scale knowledge base. InNeurIPS, 2018\.

Daya Guo, Duyu Tang, Nan Duan, M. Zhou, and Jian Yin. Coupling retrieval and meta-learning for  
context-dependent semantic parsing.ArXiv, abs/1906.07108, 2019\.

Vincent J Hellendoorn, Charles Sutton, Rishabh Singh, Petros Maniatis, and David Bieber. Global  
relational models of source code. InInternational Conference on Learning Representations, 2019\.

Xing Hu, Ge Li, Xin Xia, David Lo, and Zhi Jin. Deep code comment generation. In2018 IEEE/ACM  
26th International Conference on Program Comprehension (ICPC), pp. 200–20010. IEEE, 2018\.

Hamel Husain, Ho-Hsiang Wu, Tiferet Gazit, Miltiadis Allamanis, and Marc Brockschmidt. Code-  
searchnet challenge: Evaluating the state of semantic code search.arXiv preprint arXiv:1909.09436,  
2019\.

Lingxiao Jiang, Ghassan Misherghi, Zhendong Su, and Stephane Glondu. Deckard: Scalable and  
accurate tree-based detection of code clones. In29th International Conference on Software  
Engineering (ICSE’07), pp. 96–105. IEEE, 2007\.

Aditya Kanade, Petros Maniatis, Gogul Balakrishnan, and Kensen Shi. Pre-trained contextual  
embedding of source code.arXiv preprint arXiv:2001.00059, 2019\.

Svetoslav Karaivanov, Veselin Raychev, and Martin Vechev. Phrase-based statistical translation of  
programming languages. InProceedings of the 2014 ACM International Symposium on New Ideas,  
New Paradigms, and Reflections on Programming & Software, pp. 173–184, 2014\.

Rafael-Michael Karampatsis and Charles Sutton. Scelmo: Source code embeddings from language  
models.arXiv preprint arXiv:2004.13214, 2020\.

Seohyun Kim, Jinman Zhao, Yuchi Tian, and Satish Chandra. Code prediction by feeding trees to  
transformers.arXiv preprint arXiv:2003.13848, 2020\.

Philipp Koehn, Franz J Och, and Daniel Marcu. Statistical phrase-based translation. Technical  
report, UNIVERSITY OF SOUTHERN CALIFORNIA MARINA DEL REY INFORMATION  
SCIENCES INST, 2003\.

Guillaume Lample and Alexis Conneau. Cross-lingual language model pretraining.arXiv preprint  
arXiv:1901.07291, 2019\.

Jian Li, Yue Wang, Michael R Lyu, and Irwin King. Code completion with neural attention and  
pointer networks.arXiv preprint arXiv:1711.09573, 2017\.

Yinhan Liu, Myle Ott, Naman Goyal, Jingfei Du, Mandar Joshi, Danqi Chen, Omer Levy, Mike  
Lewis, Luke Zettlemoyer, and Veselin Stoyanov. Roberta: A robustly optimized bert pretraining  
approach.arXiv preprint arXiv:1907.11692, 2019\.

Anh Tuan Nguyen and Tien N Nguyen. Graph-based statistical language model for code. In 2015  
IEEE/ACM 37th IEEE International Conference on Software Engineering, volume 1, pp. 858–868.  
IEEE, 2015\.

Anh Tuan Nguyen, Tung Thanh Nguyen, and Tien N Nguyen. Lexical statistical machine translation  
for language migration. InProceedings of the 2013 9th Joint Meeting on Foundations of Software  
Engineering, pp. 651–654, 2013\.

Anh Tuan Nguyen, Tung Thanh Nguyen, and Tien N Nguyen. Divide-and-conquer approach for  
multi-phase statistical migration for source code (t). In2015 30th IEEE/ACM International  
Conference on Automated Software Engineering (ASE), pp. 585–596. IEEE, 2015\.

Xuan-Phi Nguyen, Shafiq Joty, Steven Hoi, and Richard Socher. Tree-structured attention with  
hierarchical accumulation. InInternational Conference on Learning Representations, 2019\.

Matthew E Peters, Mark Neumann, Mohit Iyyer, Matt Gardner, Christopher Clark, Kenton Lee, and  
Luke Zettlemoyer. Deep contextualized word representations.arXiv preprint arXiv:1802.05365,  
2018\.

Maxim Rabinovich, Mitchell Stern, and Dan Klein. Abstract syntax networks for code generation  
and semantic parsing.arXiv preprint arXiv:1704.07535, 2017\.

Alec Radford, Karthik Narasimhan, Tim Salimans, and Ilya Sutskever. Improving language  
understanding by generative pre-training.URL https://s3-us-west-2. amazonaws. com/openai-  
assets/researchcovers/languageunsupervised/language understanding paper. pdf, 2018\.

Colin Raffel, Noam Shazeer, Adam Roberts, Katherine Lee, Sharan Narang, Michael Matena, Yanqi  
Zhou, Wei Li, and Peter J Liu. Exploring the limits of transfer learning with a unified text-to-text  
transformer.arXiv preprint arXiv:1910.10683, 2019\.

Jeffrey Svajlenko, Judith F Islam, Iman Keivanloo, Chanchal K Roy, and Mohammad Mamun Mia.  
Towards a big data curated benchmark of inter-project code clones. In2014 IEEE International  
Conference on Software Maintenance and Evolution, pp. 476–480. IEEE, 2014\.

Alexey Svyatkovskiy, Shao Kun Deng, Shengyu Fu, and Neel Sundaresan. Intellicode compose:  
Code generation using transformer.arXiv preprint arXiv:2005.08025, 2020\.

Michele Tufano, Cody Watson, Gabriele Bavota, Massimiliano Di Penta, Martin White, and Denys  
Poshyvanyk. An empirical study on learning bug-fixing patches in the wild via neural machine  
translation.ACM Transactions on Software Engineering and Methodology (TOSEM), 28(4):1–29,  
2019\.

Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N Gomez,Łukasz  
Kaiser, and Illia Polosukhin. Attention is all you need. InAdvances in neural information  
processing systems, pp. 5998–6008, 2017\.

Wenhan Wang, Ge Li, Bo Ma, Xin Xia, and Zhi Jin. Detecting code clones with graph neural  
networkand flow-augmented abstract syntax tree.arXiv preprint arXiv:2002.08653, 2020\.

Huihui Wei and Ming Li. Supervised deep features for software functional clone detection by  
exploiting lexical and syntactical information in source code. InIJCAI, pp. 3034–3040, 2017\.

Martin White, Michele Tufano, Christopher Vendome, and Denys Poshyvanyk. Deep learning  
code fragments for code clone detection. In2016 31st IEEE/ACM International Conference on  
Automated Software Engineering (ASE), pp. 87–98. IEEE, 2016\.

Zhilin Yang, Zihang Dai, Yiming Yang, Jaime Carbonell, Ruslan Salakhutdinov, and Quoc V  
Le. Xlnet: Generalized autoregressive pretraining for language understanding.arXiv preprint  
arXiv:1906.08237, 2019\.

Pengcheng Yin and Graham Neubig. A syntactic neural model for general-purpose code generation.  
InThe 55th Annual Meeting of the Association for Computational Linguistics (ACL), Vancouver,  
Canada, July 2017\. URLhttps://arxiv.org/abs/1704.01696.

Jian Zhang, Xu Wang, Hongyu Zhang, Hailong Sun, Kaixuan Wang, and Xudong Liu. A novel neural  
source code representation based on abstract syntax tree. In2019 IEEE/ACM 41st International  
Conference on Software Engineering (ICSE), pp. 783–794. IEEE, 2019\.

\#\#\#\# A PRE-TRAININGDETAILS

GraphCodeBERT includes 12 layers Transformer with 768 dimensional hidden states and 12 attention  
heads. For fair comparison, we use the same dataset as CodeBERT (Feng et al., 2020\) to pretrain  
our model. The dataset is the CodeSearchNet dataset^3 (Husain et al., 2019), which includes 2.3M  
functions with document pairs for six programming languages. We train the model on two DGX-  
machines, each having 16 NVIDIA Tesla V100 with 32GB memory. We set the max length of  
sequences and nodes as 512 and 128, respectively. We use the Adam optimizer to update model  
parameters with 1,024 batch size and 2e-4 learning rate. To accelerate the training process, we adopt  
the parameters of CodeBERT released by Feng et al. (2020) to initialize the model. The model is  
trained with 200K batches and costs about 83 hours.

At each iteration, we alternate EdgePred and NodeAlign objectives in combination with MLM to  
pre-train the model. And we follow Lample & Conneau (2019) to sample each batch from the same  
programming language according to a multinomial distribution with probabilities{qi}i=1...N, where  
niis number of examples fori-th programming language andα=0.7. Sampling with this distribution  
could alleviates the bias towards high-resource languages.

\`\`\`  
qi=  
\`\`\`  
\`\`\`  
pαi  
∑j=  
N p  
\`\`\`  
\`\`\`  
α  
j  
\`\`\`  
\`\`\`  
with pi=  
\`\`\`  
\`\`\`  
ni  
∑k=  
N nk  
\`\`\`  
\#\#\#\#\#\# (9)

\#\#\#\# B NATURALLANGUAGECODESEARCH

Given a natural language as the input, code search aims to find the most semantically related code  
from a collection of candidate codes. We conduct experiments on the CodeSearchNet code corpus  
(Husain et al., 2019\) and follow Husain et al. (2019) to take the first paragraph of the documentation  
as the query for the corresponding function. However, we observe that some queries contain content  
unrelated to the code, such as a link “http://...” that refers to external resources. Therefore, we filter  
following examples to improve the quality of the dataset.

\`\`\`  
(1) Examples whose code could not be parsed into abstract syntax tree.  
\`\`\`  
\`\`\`  
(2) Examples whose query tokens number is shorter than 3 or larger than 256\.  
\`\`\`  
\`\`\`  
(3) Examples whose query contains special tokens such as “http://”.  
\`\`\`  
\`\`\`  
(4) Examples whose query is empty or not written in English.  
\`\`\`  
(^3) https://github.com/github/CodeSearchNet

Different from the setting of Husain et al. (2019), the answer of each query is retrieved from the  
whole development and testing code corpus instead of 1,000 candidate codes. We list data statistics  
about the filtered dataset in Table 7\.

\`\`\`  
Code Search Training examples Dev queries Testing queries Candidate codes  
Go 167,288 7,325 8,122 28,  
Java 164,923 5,183 10,955 40,  
JavaScript 58,025 3,885 3,291 13,  
PHP 241,241 12,982 14,014 52,  
Python 251,820 13,914 14,918 43,  
Ruby 24,927 1,400 1,261 4,  
\`\`\`  
Table 7: Data statistics about the filtered dataset. For each query in the development and testing sets,  
the answer is retrieved from the whole candidate codes (i.e. the last row).

We use GraphCodeBERT to separately encode query and source code with data flow, and calculate  
inner product of their representations of the special token\[CLS\]as relevance scores to rank candidate  
codes. In the fine-turning step, we set the learning rate as 2e-5, the batch size as 32, the max sequence  
length of queries and codes as 128 and 256, and the max number of nodes as 64\. We use the Adam  
optimizer to update model parameters and perform early stopping on the development set.

We also report the results using the same setting of Husain et al. (2019) in Table 8\. In this setting,  
models are required to retrieve an answer for a query from 1000 candidates. The results show that  
GraphCodeBERT also achieves the state-of-the-art performance.

\`\`\`  
model Ruby Javascript Go Python Java Php Overall  
NBow 0.429 0.461 0.641 0.581 0.514 0.484 0\.  
CNN 0.245 0.352 0.627 0.571 0.527 0.529 0\.  
BiRNN 0.084 0.153 0.452 0.321 0.287 0.251 0\.  
selfAtt 0.365 0.451 0.681 0.692 0.587 0.601 0\.  
RoBERTa 0.625 0.606 0.820 0.809 0.666 0.658 0\.  
RoBERTa (code) 0.661 0.640 0.819 0.844 0.721 0.671 0\.  
CodeBERT 0.693 0.706 0.840 0.869 0.748 0.706 0\.  
GraphCodeBERT 0.732 0.711 0.841 0.879 0.757 0.725 0\.  
\`\`\`  
\`\`\`  
Table 8: Results on natural language code search using the setting of Husain et al. (2019).  
\`\`\`  
\#\#\#\# C CODECLONEDETECTION

Code clone detection aims to measure the similarity between two code fragments. We use Big-  
CloneBench dataset (Svajlenko et al., 2014), which contains over 6,000,000 true clone pairs and  
260,000 false clone pairs from 10 different functionalities. We follow the settings in Wei & Li (2017),  
discarding code fragments without any tagged true and false clone pairs and using 9,134 remaining  
code fragments. Finally, the dataset provided by Wang et al. (2020) includes 901,724/416,328/416,  
examples for training/validation/testing. We treat the task as a binary classification to fine-tune Graph-  
CodeBERT, where we use source code and data flow as the input. The probability of true clone  
is calculated by dot product from the representation of\[CLS\]. In the fine-turning step, we set the  
learning rate as 2e-5, the batch size as 16, the max sequence length as 512 the max number of nodes  
as 128\. We use the Adam optimizer to update model parameters and tune hyper-parameters and  
perform early stopping on the development set.

We give a case of the GraphCodeBERT output for this task in Figure 6\. In this example, two Java  
source codes both download content from a given URL and convert the type of the content into string  
type. Therefore, two codes are semantically similar since they output similar results when given the  
same input. As we can see, our model gives a high score for this case and the pair is classified as true  
clone pair.

\`\`\`  
protectedStringdownloadURLtoString(URLurl) throwsIOException  
{  
BufferedReaderin \= newBufferedReader(new  
InputStreamReader(url.openStream()));  
StringBuffersb \= newStringBuffer(100 \* 1024);  
Stringstr;  
while((str \= in.readLine()) \!= null) {  
sb.append(str);  
}  
in.close();  
returnsb.toString();  
}  
\`\`\`  
\`\`\`  
public static StringfetchUrl(StringurlString)  
{  
try{  
URLurl= newURL(urlString);  
BufferedReaderreader \= newBufferedReader(new  
InputStreamReader(url.openStream()));  
Stringline \= null;  
StringBuilderbuilder \= newStringBuilder();  
while((line \= reader.readLine()) \!= null) {  
builder.append(line);  
}  
reader.close();  
returnbuilder.toString();  
} catch(MalformedURLExceptione) {  
} catch(IOExceptione) {  
}  
return “";  
}  
\`\`\`  
\#\#\#\#\# Input: Two source codes Output: Semantically similar (score: 0.983)

\`\`\`  
Figure 6: A case of GraphCodeBERT output for the code clone detection task.  
\`\`\`  
\#\#\#\# D CODETRANSLATION

Code translation aims to migrate legacy software from one programming language in a platform to  
another. We conduct experiments on a dataset crawled from the same several open-source projects as  
Nguyen et al. (2015) and Chen et al. (2018), i.e. Lucene^4 , POI^5 , JGit^6 and Antlr^7. We do not use  
Itext^8 and JTS^9 as they do because of the license problem. Those projects have both Java and C\#  
implementation. We pair the methods in the two languages based on their file names and method  
names. After removing duplication and methods with null function body, the total number of method  
pairs is 11,800, and we split 500 pairs from them as the development set and another 1,000 pairs for  
test. To demonstrate the effectiveness of GraphCodeBERT on the task of code translation, we adopt  
various pre-trained models as encoders and stay hyperparameters consistent. We set the learning rate  
as 1e-4, the batch size as 32, the max sequence length as 256 and the max number of nodes as 64\. We  
use the Adam optimizer to update model parameters and tune hyper-parameters and perform early  
stopping on the development set.  
We give a case of the GraphCodeBERT output for this task in Figure 7\. In this example, the model  
successfully translates a piece of Java code into its C\# version. The differences include the type  
name (from “boolean” to “bool”) and the usage of getting a string value of a bool variable (from  
“String.valueOf(b)” to “b.ToString()”).

\`\`\`  
Figure 7: A case of GraphCodeBERT output for the code translation task.  
\`\`\`  
(^4) \[http://lucene.apache.org/\](http://lucene.apache.org/)  
(^5) \[http://poi.apache.org/\](http://poi.apache.org/)  
(^6) https://github.com/eclipse/jgit/  
(^7) https://github.com/antlr/  
(^8) \[http://sourceforge.net/projects/itext/\](http://sourceforge.net/projects/itext/)  
(^9) \[http://sourceforge.net/projects/jts-topo-suite/\](http://sourceforge.net/projects/jts-topo-suite/)

\#\#\#\# E CODEREFINEMENT

Code refinement aims to automatically fix bugs in the code. We use the dataset released by Tufano  
et al. (2019). The source is buggy Java functions while the target is the according fixed ones. Almost  
all the names of variables and custom methods are normalized. The dataset contains two subsets  
based on the code length. For thesmalldataset, the numbers of training, development and test  
samples are 46,680, 5,835 and 5,835. For themediumdataset, the numbers are 52,364, 6,545 and  
6,545. We also use the sequence-to-sequence Transformer model to conduct the experiments. In the  
fine-tuning step, we adopt various pre-trained models as encoders. We set the learning rate as 1e-4,  
the batch size as 32, the max sequence length as 256 and the max number of nodes as 64\. We use the  
Adam optimizer to update model parameters and perform early stopping on the development set.

We give two cases of the GraphCodeBERT output for this task in Figure 8\. In the first example, the  
model successfully fixes the operation bug (from “\*” to “+”) to match the function name “add”. In  
the second case, the source function and type names are normalized. The return type of this function  
is “void” but the buggy code gives a return value. Our model successfully removes the “return” word  
so that the return type of the function matches its declaration.

\`\`\`  
Figure 8: Two cases of GraphCodeBERT output for the code refinement task.  
\`\`\`  
\#\#\#\# F CASESTUDY

\#\#\#\#\#\# F.1 NATURALLANGUAGECODESEARCH

We give a case study to illustrate retrieved results by GraphCodeBERT on the natural language code  
search task, with a comparison to CodeBERT and RoBERTa (code) models. Two examples are given  
in Figure 9 and we can see that GraphCodeBERT successfully retrieves correct source codes for  
given queries on both examples. As we can see in the first case, incorporating data flow will help  
Graph-CodeBERT better understand the complicated expression “\[(k, v) for k, v in self.items() if v  
is not self.EMPTY\]” by leveraging dependency relation among variables in data flow graph. In the  
second case, the terminology “%Y-%m-%d” in Python program language is a format of date time.  
GraphCodeBERT and CodeBERT both successfully search the correct function. Compared with  
RoBERTa (code), the second case shows that utilizing natural language descriptions for pre-training  
helps models do better semantic matching between source codes and queries on the code search task.

\#\#\#\#\#\# F.2 CODECLONEDETECTION

We give a case study to compare GraphCodeBERT with CodeBERT and RoBERTa (code) models  
on code clone detection task. An example is shown in Figure 10\. The first source code is to  
return the HTML content from a given URL, while the second source code is to return the last  
line from a fixed URL “http://kmttg.googlecode.com/svn/trunk/version”. Their semantics are not  
similar due to their different outputs. Data flow could help GraphCodeBERT better understand  
that the return value “pageHTML” in first source code comes from “pageHTML.append(line);  
pageHTML.append(“\\r\\n”);” instead of “bufferedWriter.write(pageHTML.toString());” and the  
return value “version” in the second source code comes from “version \= inputLine” or “version \=  
null;”. Although two source codes are highly overlapped (marked in yellow), GraphCodeBERT  
successfully predict the gold label compared with other models without data flow.

\`\`\`  
Case 1  
Query: Return copy of instance, omitting entries that are EMPTY  
Gold Source Code:  
def defined\_items(self):  
return self.\_\_class\_\_(  
\[(k, v) for k, v in self.items() if v is not self.EMPTY\], is\_empty=False  
)  
\`\`\`  
\`\`\`  
SearchResults (Top1)  
GraphCodeBERT:  
def defined\_items(self):  
return self.\_\_class\_\_(  
\[(k, v) for k, v in self.items() if v is not self.EMPTY\], is\_empty=False  
)  
CodeBERT:  
def copy(self):  
context \= CLIContext()  
for item in dir(self):  
if item\[0\] \!= '\_' and item not in ('copy', 'write\_headers’):  
setattr(context, item, getattr(self, item))  
return context  
RoBERTa(code):  
def copy(self):  
x \= self.to\_dict()  
x.pop(self.\_pkey)  
return self.\_\_class\_\_(\*\*x)  
\`\`\`  
\`\`\`  
Case 2  
Query: Fast %Y-%m-%d parsing  
Gold Source Code:  
def parse\_date(s):  
try:  
return datetime.date(int(s\[:4\]), int(s\[5:7\]), int(s\[8:10\]))  
except ValueError:  
return datetime.datetime.strptime(s, '%d %B %Y').date()  
SearchResults (Top1)  
GraphCodeBERT:  
def parse\_date(s):  
try:  
return datetime.date(int(s\[:4\]), int(s\[5:7\]), int(s\[8:10\]))  
except ValueError:  
return datetime.datetime.strptime(s, '%d %B %Y').date()  
CodeBERT:  
def parse\_date(s):  
try:  
return datetime.date(int(s\[:4\]), int(s\[5:7\]), int(s\[8:10\]))  
except ValueError:  
return datetime.datetime.strptime(s, '%d %B %Y').date()  
\`\`\`  
\`\`\`  
RoBERTa(code):  
def parse(self, hcl, canonicalize=False):  
return self.request("parse", json={"JobHCL": hcl, "Canonicalize":  
canonicalize}, method="post", allow\_redirects=True).json()  
\`\`\`  
\`\`\`  
Figure 9: Two examples on code search task and retrieved results from different models.  
\`\`\`  
\`\`\`  
Source code 1:  
private String getHTML(String pageURL, String encoding, String dirPath)  
throws IOException{  
StringBuilder pageHTML= new StringBuilder();  
HttpURLConnectionconnection \= null;  
try {  
URL url= new URL(pageURL);  
connection \= (HttpURLConnection) url.openConnection();  
connection.setRequestProperty("User-Agent", "MSIE 7.0");  
connection.connect();  
BufferedReaderbr= new BufferedReader(new  
InputStreamReader(connection.getInputStream(), encoding));  
String line \= null;  
while ((line \= br.readLine()) \!= null) {  
pageHTML.append(line);  
pageHTML.append("\\r\\n");  
}  
} catch (Exception e) {  
e.printStackTrace();  
} finally {  
connection.disconnect();  
}  
if (dirPath\!= null) {  
File file= new File(dirPath);  
BufferedWriterbufferedWriter= new BufferedWriter(new  
FileWriter(file));  
bufferedWriter.write(pageHTML.toString());  
bufferedWriter.close();  
}  
return pageHTML.toString();  
}  
\`\`\`  
\`\`\`  
Source code 2:  
private static String getVersion() {  
debug.print("");  
String version \= null;  
String version\_url=  
"http://kmttg.googlecode.com/svn/trunk/version";  
try {  
URL url= new URL(version\_url);  
URLConnectioncon \= url.openConnection();  
BufferedReaderin \= new BufferedReader(new  
InputStreamReader(con.getInputStream()));  
String inputLine;  
while ((inputLine= in.readLine()) \!= null) version \= inputLine;  
in.close();  
} catch (Exception ex) {  
version \= null;  
}  
return version;  
}  
Gold Label:  
No semantically similar  
Prediction:  
GraphCodeBERT:  
No semantically similar  
CodeBERT:  
semantically similar  
RoBERTa(code):  
semantically similar  
\`\`\`  
Figure 10: An examples on code clone detection task and model prediction from different models.  
Overlapped code snippets between two source codes are marked in yellow.

\#\#\#\#\#\# F.3 CODETRANSLATION ANDCODEREFINEMENT

We give a case study to compare GraphCodeBERT with Transformer without using data flow on  
code generation tasks, including code translation and code refinement. We list three cases in Table  
9 and Table 10, respectively. \[src\] represents the source input, \[ref\] represents the reference, \[sys\]  
represents Transformer without data flow and \[ours\] represents GraphCodeBERT. We can see that the  
Transformer (\[sys\]) baseline makes several mistakes, including repeating tokens, logic errors and  
syntax errors, while GraphCodeBERT (\[ours\]) as a encoder could improve the generation.

\`\`\`  
Case1: Transformer outputs repeating tokens  
\[src\] public static final WeightedTerm\[\] getTerms(Query query){return getTerms(query,false);}  
\[ref\] public static WeightedTerm\[\] GetTerms(Query query){return GetTerms(query, false);}  
\[sys\] public static WeightedTerm\[\] GetTerms(Query query){return GetTerms(false, new static  
static static static static static WeightTerms);}  
\[ours\] public static WeightedTerm\[\] GetTerms(Query query){return GetTerms(query, false);}  
Case2: Transformer outputs codes with severe logic and syntax errors  
\[src\] public long skip(long n){int s \= (int) Math.min(available(), Math.max(0, n));ptr \+= s;return s;}  
\[ref\] public override long Skip(long n){int s \= (int)Math.Min(Available(), Math.Max(0, n));  
ptr \+= s;return s;}  
\[sys\] public override long Skip(long n){int s \= Math.Min(n) \== 0? Math.Min(00.0 :  
Math.Min(n, s.Length);return s;}  
\[ours\] public override long Skip(long n){int s \= (int)Math.Min(Available(), Math.Max(0, n));  
ptr \+= s;return s;}  
Case3: Transformer uses the wrong variable as a parameter.  
\[src\] public UnbufferedCharStream(int bufferSize){n \= 0;data \= new int\[bufferSize\];}  
\[ref\] public UnbufferedCharStream(int bufferSize){n \= 0;data \= new int\[bufferSize\];}  
\[sys\] public UnbufferedCharStream(int bufferSize){data \= new int\[data\];}  
\[ours\] public UnbufferedCharStream(int bufferSize){n \= 0;data \= new int\[bufferSize\];}  
\`\`\`  
Table 9: Three examples that translate from Java to C\# programming language on code translation  
task. \[src\] represents the source input, \[ref\] represents the reference, \[sys\] represents Transformer  
without data flow and \[ours\] represents GraphCodeBERT.

\`\`\`  
Case1: Transformer adds redundant parameters (android.view.View view)  
\[src\] public void METHOD1 ( ){android.content.Intent VAR1 \= new android.content.Intent  
( VAR2 ) ; METHOD2 ( VAR1 , 0 ) ; android.content.Intent i \= new android.content.Intent  
( this , VAR3 class ) ; METHOD3 ( i ) ;}  
\[ref\] public void METHOD1 ( ){android.content.Intent VAR1 \= new android.content.Intent  
( VAR2 ) ; METHOD2 ( VAR1 , 0 ) ;}  
\[sys\] public void METHOD1 ( android.view.View view ){android.content.Intent VAR1 \=  
new android.content.Intent ( VAR2 ) ; METHOD2 ( VAR1 , 0 ) ;}  
\[ours\] public void METHOD1 ( ){android.content.Intent VAR1 \= new android.content.Intent  
( VAR2 ) ; METHOD2 ( VAR1 , 0 ) ;}  
Case2: Transformer outputs codes with severe logic or irrelevant codes  
\[src\] public java.util.Date METHOD1 ( ){return VAR1. METHOD1 ( ). METHOD2 ( ) ;}  
\[ref\] public java.util.Date METHOD1 ( ){if ( ( VAR1. METHOD1 ( ) ) \!= null )  
{return VAR1. METHOD1 ( ). METHOD2 ( ) ;}else{return null ;}}  
\[sys\] public java.util.Date METHOD1 ( ){if ( ( VAR1 ) \== null )  
{return new java.util.Date ( ) ;}return VAR1. METHOD1 ( ). METHOD2 ( ) ;}  
\[ours\] public java.util.Date METHOD1 ( ){if ( ( VAR1. METHOD1 ( ) ) \!= null )  
{return VAR1. METHOD1 ( ). METHOD2 ( ) ;}else{return null ;}}  
Case3: Transformer makes no change  
\[src\] public java.lang.String METHOD1 ( TYPE1 VAR1 ){if ( VAR1 \== null ) return null ;  
return VAR1. METHOD2 ( ). getText ( ) ;}  
\[ref\] public java.lang.String METHOD1 ( TYPE1 VAR1 ){return VAR1. METHOD2 ( ).  
getText ( ) ;}  
\[sys\] public java.lang.String METHOD1 ( TYPE1 VAR1 ){if ( VAR1 \== null ) return null ;  
return VAR1. METHOD2 ( ). getText ( ) ;}  
\[ours\] public java.lang.String METHOD1 ( TYPE1 VAR1 ){return VAR1. METHOD2 ( ).  
getText ( ) ;}  
\`\`\`  
Table 10: Three examples on code refinement task. \[src\] represents the source input, \[ref\] represents  
the reference, \[sys\] represents Transformer without data flow and \[ours\] represents GraphCodeBERT.

\#\#\#\# G ERRORANALYSIS

\`\`\`  
We also conduct error analysis and summary two main classes of errors for both code understanding  
and generation tasks.  
\`\`\`  
Figure 11 gives three error cases of GraphCodeBERT on the natural language code search task. We  
observe that GraphCodeBERR mainly fails to retrieve those source code that involves functions of  
the library like “tf” (Tensorflow) in the first case and “ GoogleCloudStorageHook” in the second  
case. It’s difficult for GraphCodeBERR to understand meanings of APIs like “tf.io.readfile” and  
“tf.image.decodeimage” without relevant information. A potential direction to mitigate the problem  
is to incorporate definitions of the library. The other major problem is that there are some termi-  
nologies like “unistr” in the query (corresponding to “decode(‘utf-8’)” in Python code) in third case.  
Incorporating more text-code pairs for pre-training might alleviate this problem.

\`\`\`  
As for the code generation task, Table 11 shows two cases of GraphCodeBERT on the code translation  
task. We find that the major problems include semantic errors like identifiers from nowhere in the  
first case and syntax errors like missing a “}” symbol before “return n” in the second case. This  
problem might be mitigated by incorporating a dedicated decoder that takes into account grammar of  
programming languages and different generation paradigm like generating a sequence of production  
rules (Yin & Neubig, 2017; Guo et al., 2018; 2019\) in a context-free grammar manner.  
\`\`\`  
\`\`\`  
Case 1  
Query: Return an image tensor.  
Gold Source Code: def read\_image(filepath):  
im\_bytes= tf.io.read\_file(filepath)  
imim= tf.image.decode\_image= tf.image.convert\_image\_dtype(im\_bytes(im, tf.float32), channels=CHANNELS)  
GraphCodeBERT return im :  
def get\_image(self, float\_key="floats", to\_chw=True):  
tensors \= callBigDlFunc"localImageFrameToImageTensor(self.bigdl\_type, ", self.value, float\_key, to\_chw)  
return map(lambda tensor: tensor.to\_ndarray(), tensors)  
Case 2  
Query: Gold Source Code: Uploads the file to Google cloud storage  
def execute(self, context):  
hook \= GoogleCloudStorageHook(google\_cloud\_storage\_conn\_id=self.google\_cloud\_storage\_conn\_id,  
delegate\_to=self.delegate\_to)  
hook.upload(bucket\_name=self.bucket,  
object\_namemime\_type=self.mime\_type=self.dst, ,  
filename=self.src,  
)gzip=self.gzip,  
GraphCodeBERT:  
def upload(storage \= STORAGES\['s3'\]()remote\_path, local\_path):  
conf \= s3conf.S3Conf(storage=storage)conf.upload(local\_path, remote\_path)  
\`\`\`  
\`\`\`  
Query: json.loadswants an unistr Case 3 in Python3. Convert it.  
Gold Source Code:  
def \_if not json\_safehasattr(data):(data, 'encode'):  
try:  
except data \= UnicodeDecodeErrordata.decode('utf-8'):  
raise ValueError'Expected valid UTF8 for JSON data, got %r' % (data,))(  
return data  
GraphCodeBERT:  
def parse\_unstruct(unstruct):  
my\_jsondata \= my\_json\['data'\]= json.loads(unstruct)  
schema \= data\['schema’\]  
if 'data' in data:  
else:inner\_data= data\['data'\]  
raise SnowplowEventTransformationException(\["Could not  
extract inner data field from unstructured event"\])  
fixed\_schemareturn \[(fixed\_schema, \= fix\_schema("inner\_dataunstruct\_event)\] ", schema)  
\`\`\`  
\`\`\`  
Figure 11: Error cases of GraphCodeBERT on the natural language code search.  
\`\`\`  
\`\`\`  
Case1: semantic error – identifiers from nowhere.  
\[src\] public String toString(){return getKey() \+ “: ” \+ getValue();}  
\[ref\] public override string ToString(){return GetKey() \+ “: ” \+ GetValue();}  
\[ours\] public override string ToString(){return Name \+ “: ” \+ GetValue();}  
Case2: syntax errors – missing a “}” before “return n”)  
\[src\] public static int numNonnull(Object\[\] data){int n \= 0;if ( data \== null ) return n;  
for (Object o : data){if ( o\!=null ) n++;}return n;}  
\[ref\] public static int NumNonnull(object\[\] data){int n \= 0;if (data \== null){return n;}  
foreach (object o in data){if (o \!= null){n++;}}return n;}  
\[ours\] public static int NumNonNull(object\[\] data){int n \= 0;if (data \== null){return n;}  
foreach (object o in data){if (o \!= null){n++;}return n;}  
\`\`\`  
\`\`\`  
Table 11: Error cases of GraphCodeBERT on the code translation task. \[src\] represents the source  
input, \[ref\] represents the reference and \[ours\] represents GraphCodeBERT.  
\`\`\`


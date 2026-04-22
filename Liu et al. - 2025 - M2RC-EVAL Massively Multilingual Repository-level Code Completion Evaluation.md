\#\# Proceedings of the 63rd Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers), pages 15661–

\#\# July 27 \- August 1, 2025 ©2025 Association for Computational Linguistics

\# M

\#\# 2

\# RC-EVAL: Massively Multilingual Repository-level

\# Code Completion Evaluation

\#\# Jiaheng Liu

\#\# 1 , 2 ∗,†

\#\# , Ken Deng

\#\# 2 ∗

\#\# , Congnan Liu

\#\# 2

\#\# , Jian Yang

\#\# 2

\#\# , Shukai Liu

\#\# 2

\#\# ,

\#\# He Zhu

\#\# 2

\#\# ,Peng Zhao

\#\# 2

\#\# , Linzheng Chai

\#\# 2

\#\# , Yanan Wu

\#\# 2

\#\# , Ke Jin

\#\# 2

\#\# , Ge Zhang

\#\# 3

\#\# ,

\#\# Zekun Wang

\#\# 2

\#\# , Guoan Zhang

\#\# 2

\#\# , Yingshui Tan

\#\# 2

\#\# , Bangyu Xiang

\#\# 2

\#\# ,

\#\# Zhaoxiang Zhang

\#\# 4

\#\# , Wenbo Su

\#\# 2

\#\# , Bo Zheng

\#\# 2

\#\# 1

\#\# Nanjing University,

\#\# 2

\#\# Alibaba Group,

\#\# 3

\#\# University of Waterloo,

\#\# 4

\#\# CASIA

\#\# liujiaheng@nju.edu.cn

\#\# Abstract

\#\# Repository-level code completion has drawn

\#\# great attention in software engineering, and sev-

\#\# eral benchmarks have been introduced. How-

\#\# ever, existing repository-level code completion

\#\# benchmarks usually focus on a limited number

\#\# of languages (\<5), which cannot evaluate the

\#\# general code intelligence abilities across differ-

\#\# ent languages for existing code Large Language

\#\# Models (LLMs). Besides, the existing bench-

\#\# marks usually report overall average scores

\#\# of different languages, where the fine-grained

\#\# abilities in different completion scenarios are

\#\# ignored. Therefore, to facilitate the research

\#\# of code LLMs in multilingual scenarios, we

\#\# propose a massively multilingual repository-

\#\# level code completion benchmark covering 18

\#\# programming languages (calledM

\#\# 2

\#\# RC-EVAL),

\#\# and two types of fine-grained annotations (i.e.,

\#\# bucket-levelandsemantic-level) on different

\#\# completion scenarios are provided, where we

\#\# obtain these annotations based on the parsed

\#\# abstract syntax tree. Moreover, we also cu-

\#\# rate a massively multilingual instruction cor-

\#\# poraM

\#\# 2

\#\# RC-INSTRUCTdataset to improve the

\#\# repository-level code completion abilities of

\#\# existing code LLMs. Comprehensive experi-

\#\# mental results demonstrate the effectiveness of

\#\# our M

\#\# 2

\#\# RC-EVALand M

\#\# 2

\#\# RC-INSTRUCT.

\#\# 1 Introduction

\#\# The emergence of Large Language Models (LLMs)

\#\# has marked a significant advancement in many

\#\# tasks (Liu et al., 2025; Zhang et al., 2024; Wang

\#\# et al., 2024; Liu et al., 2024). The code LLMs

\#\# (Roziere et al., 2023; Zheng et al., 2023; Guo et al.,

\#\# 2024a; Hui et al., 2024; Zhang et al., 2025; He

\#\# et al., 2025; Huang et al., 2024\) pre-trained on ex-

\#\# tensive datasets comprising billions of code-related

\#\# tokens further revolutionize the automation of soft-

\#\# ware development tasks, providing contextually

\#\# \* First two authors contributed equally.

†

\#\# Corresponding Author: Jiaheng Liu.

\#\# relevant code suggestions and facilitating the trans-

\#\# lation from natural language to code. The gener-

\#\# ation capability of code LLMs opens up diverse

\#\# applications in software development, promising

\#\# to enhance productivity and streamline coding pro-

\#\# cesses. As the field continues to evolve, it presents

\#\# exciting opportunities for future developments and

\#\# innovations in automated programming and code

\#\# assistance.

\#\# The code completion task is crucial in modern

\#\# software development, enhancing coding efficiency

\#\# and accuracy by predicting and suggesting code

\#\# segments based on context. Recent advancements

\#\# in code LLMs (Bavarian et al., 2022a) have intro-

\#\# duced sophisticated completion techniques, such

\#\# as prefix-suffix-middle (PSM) and suffix-prefix-

\#\# middle (SPM) paradigms, which can complete

\#\# middle code segments given the surrounding con-

\#\# text. However, the current benchmark (Ding et al.,

\#\# 2024; Liu et al., 2023a) mainly focuses on sev-

\#\# eral programming languages. For example, the

\#\# CrossCodeEval (Ding et al., 2024\) includes four

\#\# languages (i.e., Python, Java, TypeScript, C\#). Be-

\#\# sides, existing benchmarks can only provide the

\#\# average score among all samples, which cannot

\#\# provide a language-specific evaluation for different

\#\# programming languages based on their intrinsic

\#\# structure.Inspired by the multilingual in-file code

\#\# generation benchmark MultiPL-E (Cassano et al.,

\#\# 2022\) and McEval (Chai et al., 2024), we create a

\#\# massively multilingual repository-level code com-

\#\# pletion Evaluation benchmark calledM

\#\# 2

\#\# RC-EVAL

\#\# to facilitate the research of the community.

\#\# In this paper, as shown in Fig. 1, ourM

\#\# 2

\#\# RC-

\#\# EVALincludes 18 programming languages with

\#\# two types of fine-grained annotations (i.e.,bucket-

\#\# levelandsemantic-level), where each language

\#\# contains 100 validation and 500 test samples, re-

\#\# spectively. Specifically, for the bucket-level anno-

\#\# tations, we first generate abstract syntax tree with

\#\# 15661

\*\*C C++ C\#\*\*

\`\`\`  
Go HTML HaskellJava JavaScript  
Kotlin Lua Objective-C PHP  
\`\`\`  
\*\*Python R Ruby Rust Scala TypeScript\*\*

\*\*Cross file context\*\*

\*\*In-file Context\*\*

\*\*Cross file context\*\*

\`\`\`  
Cursor Position  
\`\`\`  
\*\*In-file Context\*\*

\`\`\`  
package com.cefriel.util;  
\`\`\`  
\`\`\`  
import org.apache.camel.CamelContext;  
\`\`\`  
\`\`\`  
import org.slf4j.Logger;  
\`\`\`  
\`\`\`  
import org.slf4j.LoggerFactory;  
\`\`\`  
\`\`\`  
import java.io.FileInputStream;  
\`\`\`  
\`\`\`  
import java.io.IOException;  
\`\`\`  
\`\`\`  
import java.io.InputStream;  
\`\`\`  
\`\`\`  
import java.net.HttpURLConnection;  
\`\`\`  
\`\`\`  
import java.net.MalformedURLException;  
\`\`\`  
\`\`\`  
import java.net.URL;  
\`\`\`  
\`\`\`  
\#\# Snippet 1  
\`\`\`  
\`\`\`  
/java/com/cefriel/util/UniLoader.java  
\`\`\`  
\`\`\`  
import org.eclipse.rdf4j.model.\*;  
\`\`\`  
\`\`\`  
import org.slf4j.Logger;  
\`\`\`  
\`\`\`  
import org.slf4j.LoggerFactory;  
\`\`\`  
\`\`\`  
package com.cefriel.util;  
\`\`\`  
\`\`\`  
\<INFILLING|\>  
\`\`\`  
\`\`\`  
import org.apache.camel.Exchange;  
\`\`\`  
\`\`\`  
import org.apache.camel.ProducerTemplate;  
\`\`\`  
\`\`\`  
import org.apache.camel.builder.ExchangeBuilder;  
\`\`\`  
\`\`\`  
import org.slf4j.Logger;  
\`\`\`  
\`\`\`  
import org.slf4j.LoggerFactory;  
\`\`\`  
\`\`\`  
import java.io.InputStream;  
\`\`\`  
\`\`\`  
import java.util.Optional;  
\`\`\`  
\`\`\`  
public class HTTPResourceAccessor {  
\`\`\`  
\`\`\`  
private static final Logger LOG \=  
\`\`\`  
\`\`\`  
LoggerFactory.getLogger(HTTPResourceAccessor.class);  
\`\`\`  
\`\`\`  
Cursor Position  
\`\`\`  
\`\`\`  
The answer should be:  
\`\`\`  
\`\`\`  
import org.apache.camel.CamelContext;  
\`\`\`  
\*\*Bucket label: 1\*\*

\*\*Semantic label: Program Structure\*\*

\`\`\`  
updateTask(task: any): Promise\<any\> {  
\`\`\`  
\`\`\`  
return this.updateItem(TASK, task);  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
deleteTask(task: any): Promise\<any\> {  
\`\`\`  
\`\`\`  
return this.deleteItem(TASK, task);  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
createProject(project: any): Promise\<any\> {  
\`\`\`  
\`\`\`  
return this.createItem(PROJECT, project);  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
\#\# Snippet 1  
\`\`\`  
\`\`\`  
/app/utils/service.ts  
\`\`\`  
\`\`\`  
({  
\`\`\`  
\`\`\`  
moduleName: viewsModule.Views.login,  
\`\`\`  
\`\`\`  
backstackVisible: false,  
\`\`\`  
\`\`\`  
clearHistory: true  
\`\`\`  
\`\`\`  
})  
\`\`\`  
\`\`\`  
get user(): any {  
\`\`\`  
\`\`\`  
return this.\_user;  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
set user(value: any) {  
\`\`\`  
\`\`\`  
if (this.\_user \!== value) {  
\`\`\`  
\`\`\`  
this.\_user \= value;  
\`\`\`  
\`\`\`  
this.notifyPropertyChange("user", value);  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
logout() {  
\`\`\`  
\`\`\`  
serviceModule.service.logout();  
\`\`\`  
\`\`\`  
navigationModule.navigate \<INFILLING\>  
\`\`\`  
\`\`\`  
The answer should be:  
\`\`\`  
\*\*Bucket label: 4\*\*

\*\*Semantic label: Expression\*\*

\*\*Cross file context\*\*

\*\*In-file Context\*\*

\`\`\`  
parser.entity\['Aring'\] \= 'A'  
\`\`\`  
\`\`\`  
parser.entity\['yacute'\] \= 'y'  
\`\`\`  
\`\`\`  
parser.entity\['ntilde'\] \= 'n'  
\`\`\`  
\`\`\`  
parser.entity\['oslash'\] \= 'O'  
\`\`\`  
\`\`\`  
parser.entity\['Ouml'\] \= 'O'  
\`\`\`  
\`\`\`  
xmldoc \= ET.fromstring(doc, parser=parser)  
\`\`\`  
\`\`\`  
\# WRITE XML  
\`\`\`  
\`\`\`  
new\_doc \= ET.Element('add')  
\`\`\`  
\`\`\`  
doc\_tag \= ET.SubElement(new\_doc, 'doc')  
\`\`\`  
\`\`\`  
\#\# Snippet 1  
\`\`\`  
\`\`\`  
/Data\_Processing/australia\_xml\_parser.py  
\`\`\`  
\`\`\`  
Cursor Position  
\`\`\`  
\`\`\`  
The answer should be:  
\`\`\`  
\`\`\`  
parser.entity\['Ouml'\] \= 'O'  
\`\`\`  
\*\*Bucket label: 3\*\*

\*\*Semantic label: Declaration and Definition\*\*

\#\#\#\#\# (a) Python (b) Java

\#\#\#\#\# (c) TypeScript

\`\`\`  
parser.entity\['Aring'\] \= 'A'  
\`\`\`  
\`\`\`  
parser.entity\['yacute'\] \= 'y'  
\`\`\`  
\`\`\`  
parser.entity\['ntilde'\] \= 'n'  
\`\`\`  
\`\`\`  
parser.entity\['oslash'\] \= 'O'  
\`\`\`  
\`\`\`  
\<INFILLING\>  
\`\`\`  
\`\`\`  
\# READ SENTENCES  
\`\`\`  
\`\`\`  
doc \= infile.read()  
\`\`\`  
\`\`\`  
xmldoc \= ET.fromstring(doc, parser=parser);  
\`\`\`  
\`\`\`  
\# PARSE INFILE  
\`\`\`  
\`\`\`  
sentences \= \[\]  
\`\`\`  
\`\`\`  
table \= string.maketrans("","")  
\`\`\`  
\`\`\`  
for sentence in xmldoc.iter('field'):  
\`\`\`  
\`\`\`  
if sentence.attrib \== {'name': 'features'}:  
\`\`\`  
\#\#\#\# Figure 1: Overview of ourM

2

\#\#\#\# RC-EVALwith 18 languages. Specifically, first, we provide three samples from

\#\#\#\# different languages (i.e., Python, Java, TypeScript) for illustration, where the bucket label and semantic label for the

\#\#\#\# corresponding cursor position are provided. Second, the code LLMs need to predict the completion results given

\#\#\#\# the in-file context from the current code file and the cross file context retrieved from other code files in the current

\#\#\#\# repository. Note that “\<INFILLING\>” denotes that the current position will be triggered for code completion.

\#\#\# Nlayers using code parser (i.e., Treesitter

\#\#\#\#\#\# 1

\#\#\# ), and

\#\#\# divide theseNinto fixedMbuckets, Then, for

\#\#\# each completion cursor position, we annotate the

\#\#\# corresponding bucket-level label based on the layer

\#\#\# to which the location belongs. In this way, we can

\#\#\# obtain different code completion scenarios with

\#\#\# different difficulties.

\#\#\# For the semantic-level annotations, inspired

\#\#\# by (Takerngsaksiri et al., 2024), we first pre-define

\#\#\# 11 major semantic labels (e.g., Program Structure,

\#\#\# Statement) for each completion cursor position,

\#\#\# which aims to analyze the fine-grained performance

\#\#\# across different code semantics. Note that as dif-

\#\#\# ferent languages usually have specific syntax, we

\#\#\# carefully design the subcategories under each ma-

\#\#\# jor semantic label for different languages. Then,

\#\#\# as the code parser usually provides syntax labels

\#\#\# (e.g., functions, variables, classes, empty lines)

\#\#\#\#\#\# 2

\#\#\# for

\#\#\# each completion cursor position, we carefully de-

\#\#\# fine the mappings between the syntax labels to our

\#\#\# designed semantic labels and build the semantic-

1

\#\#\#\#\# https://tree-sitter.github.io/tree-sitter/

2

\#\#\#\#\# Note that the syntax label provided by code parser (e.g.,

\#\#\#\#\# tree-sitter) are highly detailed.

\#\#\# level annotations for ourM

\#\#\#\#\#\# 2

\#\#\# RC-EVAL. Finally, to

\#\#\# enhance the performance of repository-level code

\#\#\# completion for existing code LLMs, we also cre-

\#\#\# ate a massively multilingual instruction corpora

\#\#\# M

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCTof 18 languages.

\#\#\# The contributions are summarized as follows:

\- We propose the first massively multilingual

\#\#\# repository-level code completion benchmark

\#\#\# M

\#\#\#\#\#\# 2

\#\#\# RC-EVALcovering 18 languages, where

\#\#\# two types of annotations (bucket-level and

\#\#\# semantic-level labels) are provided based on

\#\#\# the parsed abstract syntax tree.

\- We introduce M

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCT, the mas-

\#\#\# sively multilingual repository-level code in-

\#\#\# struction corpora covering the multilingual

\#\#\# code snippet from 18 languages, which can

\#\#\# greatly enhance the performance of repository-

\#\#\# level code completion results.

\- Comprehensive evaluation results and analy-

\#\#\# sis demonstrate the effectiveness of our pro-

\#\#\# posed M

\#\#\#\#\#\# 2

\#\#\# RC-EVALand M

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCT.

\#\# 2 Related Works

\#\#\# Code Large Language Models. Code

\#\#\# LLMs (Chen et al., 2021; Zhao et al., 2024;

\#\#\# Black et al., 2022; Le et al., 2022; Chowdhery

\#\#\# et al., 2023; Nijkamp et al., 2023; Fried et al.,

\#\#\# 2023; Xu et al., 2022; Jain et al., 2024b; Zhuo

\#\#\# et al., 2025\) are increasingly involved in modern

\#\#\# programming, due to excellent capabilities of

\#\#\# code generation (Li et al., 2022; Allal et al.,

\#\#\# 2023), code repair (Wang et al., 2021, 2023), code

\#\#\# translation (Li et al., 2023), and other coding tasks.

\#\#\# Recent code LLMs such as Code Llama (Roziere

\#\#\# et al., 2023), DeepSeek-Coder (Guo et al., 2024a),

\#\#\# and Qwen2.5-Coder (Hui et al., 2024\) incorporate

\#\#\# the fill-in-the-middle (FIM) task into their training

\#\#\# stage for code completion. Moreover, many in-file

\#\#\# benchmarks are proposed to evaluate capabilities

\#\#\# of code LLMs (Zheng et al., 2023; Austin et al.,

\#\#\# 2021; Jain et al., 2024a; Chai et al., 2024).

\#\#\# Repository-level Code Completion. The latest

\#\#\# repository-level code completion methods (Bairi

\#\#\# et al., 2023; Phan et al., 2024; Liao et al., 2023;

\#\#\# Shrivastava et al., 2023a; Agrawal et al., 2023; Shri-

\#\#\# vastava et al., 2023b; Pei et al., 2023; Zhang et al.,

\#\#\# 2023; Yu et al., 2024; Ding et al., 2022\) aim to

\#\#\# retrieve related code snippets across files within a

\#\#\# repository, where existing datasets mainly focus

\#\#\# on limited programming languages. For example,

\#\#\# RepoBench (Liu et al., 2023b) and CrossCodeE-

\#\#\# val (Ding et al., 2023\) only support 2 and 4 lan-

\#\#\# guages, respectively. To comprehensively evaluate

\#\#\# the multilingual repository-based code completion,

\#\#\# we propose M

\#\#\#\#\#\# 2

\#\#\# RC-EVALwith 18 languages.

\#\# 3 M

\#\#\#\#\#\# 2

\#\# RC-EVAL

\#\#\# 3.1 Data Collection

\#\#\# The Overall Data Pool. We collect the training

\#\#\# data from The Stack v2 (Lozhkov et al., 2024\) with

\#\#\# permissively licensed repositories from GitHub.

\#\#\# Further, we keep only repositories receiving more

\#\#\# than 5 stars and containing\[10,50\]files. Lastly,

\#\#\# we preserve files written in 18 common languages,

\#\#\# and obtain 431,353,244 files.

\#\#\# Completion Cursor Position Selection.Comple-

\#\#\# tion cursor position selection significantly impacts

\#\#\# the quality of a code completion benchmark. Pre-

\#\#\# vious studies (Ding et al., 2024; Liu et al., 2023a)

\#\#\# randomly select a segment of consecutive charac-

\#\#\# ters as the completion span, which does not guar-

\#\#\# antee the integrity of identifiers and statements.

\#\#\#\# Table 1: A comparison with existing notable other

\#\#\#\# datasets. “FG” denotes “Fine-grained”.

\#\#\#\#\#\# Benchmark \#Lang FG Training \# Test Repos

\#\#\#\#\#\# RepoBench 2 ✗✓ 1669

\#\#\#\#\#\# CrossCodeEval 4 ✗✗ 1002

\#\#\#\#\#\# Ours 18 ✓✓ 5993

\#\#\# Besides, recent works (e.g., Qwen2.5-Coder (Hui

\#\#\# et al., 2024), aiXcoder (Jiang et al., 2024)) also

\#\#\# claimed that developers often expect LLMs to com-

\#\#\# plete the current code into a complete snippet, such

\#\#\# as a completed code line or loop block, instead

\#\#\# of suggesting an incomplete code snippet. There-

\#\#\# fore, inM

\#\#\#\#\#\# 2

\#\#\# RC-EVAL, we first parse the abstract

\#\#\# syntax tree (AST) of each source code file, and

\#\#\# then we randomly choose a node (e.g., the node of

\#\#\# “Function Definition” in Fig. 3\) on the AST as the

\#\#\# completion cursor position. After that, we obtain

\#\#\# the corresponding code to obtain the ground-truth

\#\#\# for the current completion cursor position. Finally,

\#\#\# at inference, the code LLMs need to predict the

\#\#\# current code span given the in-file and cross file

\#\#\# contexts. Similarly, in training, we just use the

\#\#\# ground-truth to tune code LLMs.

\#\#\# 3.2 Quality Control

\#\#\# We build a suite of post-processing filters to en-

\#\#\# hance the quality ofM

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCT. We elimi-

\#\#\# nate examples based on two heuristic rules: (1) The

\#\#\# completion cursor position should be no longer

\#\#\# than 5 lines. (2) If the completion ground truth

\#\#\# is fewer than 20 characters, at least 20% of them

\#\#\# should be alphabetic. To improve data indepen-

\#\#\# dence and inference difficulty, we apply extra fil-

\#\#\# ters to the test cases inM

\#\#\#\#\#\# 2

\#\#\# RC-EVAL. (a) Reposito-

\#\#\# ries inM

\#\#\#\#\#\# 2

\#\#\# RC-EVALshould be absent fromM

\#\#\#\#\#\# 2

\#\#\# RC-

\#\#\# INSTRUCT. (b) We ensure that 30% of the com-

\#\#\# pletion ground truth is not shorter than 2 lines. (c)

\#\#\# The completion cursor position should not be fully

\#\#\# white-spaced. (d) We discard test cases that could

\#\#\# be exactly predicted by DeepSeekCoder-1.3B

\#\#\# (Guo et al., 2024b) without cross file contexts.

\#\#\# 3.3 Dataset Statistics

\#\#\# Following the quality filters in §(3.2) from the over-

\#\#\# all data pool §(3.1). We sample 50,000 files per

\#\#\# language to construct ourM

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCT, and

\#\#\# sample 100, and 500 files per language to build

\#\#\# the validation and test sets of ourM

\#\#\#\#\#\# 2

\#\#\# RC-EVAL, re-

\#\#\# spectively. The statistics of the test set are shown

\#\#\# in Fig. 2, and we also provide a detailed com-

HTML

Java

TypeScript

Haskell

Ruby

Kotlin

JavaScript

Scala

C++

Objective-C

C R

Go C\#

Rust PHP

Lua

Python

\`\`\`  
0  
\`\`\`  
\`\`\`  
5  
\`\`\`  
\`\`\`  
10  
\`\`\`  
\`\`\`  
15  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
25  
\`\`\`  
\`\`\`  
30  
\`\`\`  
Prompt Length

Completion Length

Cross-file Dependencies

\#\#\#\# Figure 2: The average prompt length (100x tokens), completion span length (50x tokens), and cross-file dependencies

\#\#\#\# (1x) in the testing set ofM

2

\#\#\#\# RC-EVAL. We define the number of other files, which are explicitly imported and

\#\#\#\# implicitly referenced by the current file, as cross-file dependencies.

\#\#\#\# Table 2: Semantic-level annotations on different types of programming languages.

Major Classes Java Go Scala

Program Structure "Program Entry", "Namespace",

"Import/Include"

"Program Entry", "Namespace",

"Import/Include"

"Program Entry", "Namespace",

"Import/Include"

Declaration and Definition "Class", "Function", "Variable" "Class", "Function", "Variable" "Class", "Function", "Variable"

Control Flow Structure "Conditional", "Loop", "Jump",

"Exception Handling"

"Conditional", "Loop", "Jump",

"Exception Handling"

"Conditional", "Loop", "Jump",

"Exception Handling"

Expression "Arithmetic Operation", "Logical

Operation", "Function Call", "Object

Creation", "Type Casting", "Other",

"Arithmetic Operator", "Logical

Operator"

"Arithmetic Operation", "Logical

Operation", "Function Call", "Object

Creation", "Type Casting",

"Arithmetic Operator", "Logical

Operator"

"Arithmetic Operation", "Function

Call", "Object Creation", "Type

Casting", "Tuple Expression",

"Logical Operator", "Special

Operator"

Data Type "Primitive Type", "Composite Type",

"Generic", "Numeric", "String",

"Boolean", "Special Value"

"Primitive Type", "Composite Type",

"Generic"

"Primitive Type", "Composite Type",

"Generic", "Numeric", "String",

"Boolean", "Special Value"

Statement "Expression Statement", "Compound

Statement", "Other Statement"

"Expression Statement", "Compound

Statement"

"Compound Statement"

Modifier and Attribute "Access Modifiers", "Other

Modifiers", "Attribute Annotation"

"Access Modifiers", "Other

Modifiers", "Attribute Annotation"

"Access Modifiers", "Other

Modifiers", "Annotation"

Comments and Documentation "Single-line Comment", "Multi-line

Comment"

"Single-line Comment" "Single-line Comment", "Multi-line

Comment"

Preprocessing Directive "Conditional Compilation", "Macro

Definition"

"Conditional Compilation", "Macro

Definition"

"Macro Definition"

Identifier and Scope "Identifier", "Qualified Name" "Identifier", "Qualified Name" "Identifier", "Qualified Name",

"Binding", "Delimiter"

Special Language Structure "Lambda Expression", "Pattern

Matching", "Coroutine"

"Lambda Expression", "Coroutine" "Lambda Expression", "Pattern

Matching"

\#\#\# parison between ourM

\#\#\#\#\#\# 2

\#\#\# RC-EVALwith existing

\#\#\# repository-level code completion datasets in Ta-

\#\#\# ble 1\. Note that the numbers of repositories for

\#\#\# M

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCT, validation split ofM

\#\#\#\#\#\# 2

\#\#\# RC-EVAL

\#\#\# are 37439 and 1635, respectively.

\#\#\# 3.4 Fine-grained Annotations

\#\#\# As shown in Fig. 3, to analyze the performance

\#\#\# in a fine-grained manner, we further provide two

\#\#\# types of fine-grained annotations (i.e., bucket-level

\#\#\# and semantic-level) for each completion cursor.

\#\#\# Specifically, we first generate the abstract syntax

\#\#\# tree. For the bucket-level annotations, we first sim-

\#\#\# ply divide each tree intoMbuckets based on the

\#\#\# depth degree of the abstract syntax tree. Note that

\#\#\# we setMas 10 in ourM

\#\#\#\#\#\# 2

\#\#\# RC-EVAL. For example,

\#\#\# if the number of layers for the current abstract

\#\#\# syntax tree isN, thei-th layer of the tree belongs

\#\#\# to the⌈

\#\#\#\#\#\# i

\#\#\#\#\#\# N/M

\#\#\# ⌉bucket. Then, for each completion

\#\#\# cursor node, we annotate the bucket label based on

\#\#\# the layer number of each node. Similarly, for the

\#\#\# semantic-level annotations, we directly annotate

\#\#\# the semantic-level label for each completion

\#\#\# cursor node. Specifically, we pre-define 11 major

\#\#\# classes (i.e., “Program Structure”, “Declaration

\#\#\# and Definition”, “Control Flow Structure”,

\#\#\# “Expression”, “Data Type”, “Statement”,

\#\#\# “Modifier and Attribute”, “Comments and

\#\#\# Documentation”, “Preprocessing Directive”,

\#\#\# “Identifier and Scope”, “Special Language

\`\`\`  
Module  
\`\`\`  
\`\`\`  
Class Definition  
\`\`\`  
\`\`\`  
Function Definition  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Expression Statement  
\`\`\`  
\`\`\`  
Call  
\`\`\`  
\`\`\`  
import unittest  
\`\`\`  
\`\`\`  
from wxpusher import WxPusher  
\`\`\`  
\`\`\`  
from. import config  
\`\`\`  
\`\`\`  
class TestSendMessage(unittest.TestCase):  
\`\`\`  
\`\`\`  
"""Unittest for sending message."""  
\`\`\`  
\`\`\`  
@classmethod  
\`\`\`  
\`\`\`  
def setUpClass(cls):  
\`\`\`  
\`\`\`  
"""Set up for class."""  
\`\`\`  
\`\`\`  
WxPusher.default\_token \= config.TOKEN  
\`\`\`  
\`\`\`  
def test\_send\_message\_uid(self):  
\`\`\`  
\`\`\`  
"""Positive case for sending message with uid."""  
\`\`\`  
\`\`\`  
res \= WxPusher.send\_message\<|concat\_token|\>(  
\`\`\`  
\`\`\`  
self.test\_send\_message\_uid.\_\_doc\_\_,  
\`\`\`  
\`\`\`  
uids=config.UIDS,  
\`\`\`  
\`\`\`  
url='http://example.com/',  
\`\`\`  
\`\`\`  
)\<|concat\_token|\>  
\`\`\`  
\`\`\`  
self.assertIsInstance(res, dict)  
\`\`\`  
\`\`\`  
self.assertIn('code', res)  
\`\`\`  
\`\`\`  
self.assertEqual( 1000 , res\['code'\])  
\`\`\`  
\`\`\`  
def test\_send\_message\_topic\_id(self):  
\`\`\`  
\`\`\`  
......  
\`\`\`  
\`\`\`  
Source Code  
\`\`\`  
\`\`\`  
···  
\`\`\`  
\`\`\`  
Bucket: 3  
\`\`\`  
\`\`\`  
Bucket: 8  
\`\`\`  
\`\`\`  
Abstract Syntax  
\`\`\`  
\`\`\`  
 Tree  
\`\`\`  
\`\`\`  
Semantic: Declaration & Definition  
\`\`\`  
\`\`\`  
Semantic: Identifier & Scope  
\`\`\`  
\`\`\`  
···  
\`\`\`  
\`\`\`  
··· ···  
\`\`\`  
\`\`\`  
···  
\`\`\`  
\`\`\`  
··· ···  
\`\`\`  
\`\`\`  
··· ···  
\`\`\`  
\`\`\`  
··· ··· ···  
\`\`\`  
\`\`\`  
··· ··· ··· ···  
\`\`\`  
\`\`\`  
··· ···  
\`\`\`  
\`\`\`  
··· ··· ···  
\`\`\`  
\`\`\`  
···  
\`\`\`  
\#\#\#\# Figure 3: Illustration on generating completion cursor

\#\#\#\# position and fine-grained annotations. Specifically, we

\#\#\#\# first parse the source code into an abstract syntax tree

\#\#\#\# (AST). Then, we choose one node as the completion cur-

\#\#\#\# sor position and generate the bucket label based on the

\#\#\#\# belonged layer number in AST, and obtain the semantic

\#\#\#\# label based on the node type parsed by the Tree-sitter.

\#\#\# Structure”). Then, as different languages have

\#\#\# many specific designs, the subcategories under

\#\#\# each major class are carefully annotated for

\#\#\# different languages. In Table 2, we provide the

\#\#\# semantic-level annotations on three main-stream

\#\#\# programming languages (Java, Go, Scala), where

\#\#\# the annotations on all 18 languages are provided in

\#\#\# Fig. 10, Fig. 11 and Fig. 12 of the Appendix.

\#\# 4 Experiments

\#\#\# 4.1 Evaluation Models and Metrics

\#\#\# We evaluate three Code LLMs (i.e.,StarCoder-

\#\#\# 7B(Li et al., 2023),DeepSeekCoder-6.7B(Guo

\#\#\# et al., 2024b) andCode Llama-7B(Roziere et al.,

\#\#\# 2023)) (See Appendix A.2 for more details) on

\#\#\# M

\#\#\#\#\#\# 2

\#\#\# RC-EVAL. Following (Ding et al., 2023), we

\#\#\# compare the generated code with the reference and

\#\#\# compute the exact match (EM) and edit similarity

\#\#\# (ES) metrics

\#\#\#\#\#\# 3

\#\#\# , which assess the textual similarities

\#\#\# and ignore semantic structure similarities among

\#\#\# predictions and ground-truth.

\#\#\# 4.2 Experimental Setup

\#\#\# Baseline. Only the original code file, where the

\#\#\# cursor position is located, is provided for the code

\#\#\# LLMs. As no explicit inter-file context is supplied,

\#\#\# the model must utilize its inherent knowledge-

\#\#\# based reasoning abilities to generate code.

\#\#\# \+ Retrieval.In line with the approach outlined in

\#\#\# CrossCodeEval (Ding et al., 2023), the retrieval

\#\#\# process begins by examining files within the same

\#\#\# repository. Continuous code segments ofLlines

3

\#\#\#\#\# https://github.com/amazon-science/cceval

\#\#\# are extracted, whereLmatches the length of the

\#\#\# retrieval query and is set as 10 by default. Subse-

\#\#\# quently, these extracted candidates are prioritized

\#\#\# based on their Jaccard similarity scores. The most

\#\#\# relevant fragments are then appended to the begin-

\#\#\# ning of the in-file context in descending order of

\#\#\# similarity. This concatenation continues until the

\#\#\# total length, including both the added candidates

\#\#\# and the original in-file context, reaches the prede-

\#\#\# termined maximum token limit of 4096\.

\#\#\# \+ Retrieval & Tuning.To further improve the per-

\#\#\# formance of repository-level code completion, we

\#\#\# fine-tune code LLMs onM

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCTmen-

\#\#\# tioned in §(3). At inference, we use the same infer-

\#\#\# ence strategy as discussed in “+ Retrieval”.

\#\#\# 4.3 Main Results

\#\#\# We present the results onM

\#\#\#\#\#\# 2

\#\#\# RC-EVALin Table 3\.

\#\#\# We observe that different code LLMs have differ-

\#\#\# ent repository-level code completion abilities for

\#\#\# different programming languages. For instance,

\#\#\# DeepSeekCoder-6.7B demonstrates strong comple-

\#\#\# tion ability for Go, while its performance is weaker

\#\#\# with HTML, a markup language, which demon-

\#\#\# strates the necessity of evaluating code LLMs for

\#\#\# multilingual capabilities. Besides, the results in-

\#\#\# dicate that cross-file context is highly effective,

\#\#\# resulting in a significant improvement compared

\#\#\# to using only in-file context. In particular, the mul-

\#\#\# tilingual SFT on our created instruction corpora

\#\#\# M

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCTalso significantly enhances per-

\#\#\# formance onM

\#\#\#\#\#\# 2

\#\#\# RC-EVAL. Notably, after SFT on

\#\#\# M

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCT, Code Llama-7B, which orig-

\#\#\# inally ranked lowest with in-file context, outper-

\#\#\# formed the non-finetuned StarCoder-7B, demon-

\#\#\# strating the effectiveness of M

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCT.

\#\#\# 4.4 Analysis

\#\#\# Analysis on different model sizes.In Table 4, we

\#\#\# provide the results on the validation set ofM

\#\#\#\#\#\# 2

\#\#\# RC-

\#\#\# EVAL. Notably, StarCoder-7B consistently out-

\#\#\# performs StarCoder-3B under comparable condi-

\#\#\# tions. However, after SFT onM

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCT,

\#\#\# the results of StarCoder-3B exceed those of the

\#\#\# inference-only StarCoder-7B. This finding under-

\#\#\# scores the effectiveness of ourM

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCT

\#\#\# in augmenting the capabilities of smaller models in

\#\#\# repository-level code completion.

\#\#\# Analysis on different training data sizes.In Ta-

\#\#\# ble 5, we evaluate the fine-tuned StarCoder-7B by

\#\#\# employing varying sizes ofM

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCTand

\#\#\# report the results on the validation set ofM

\#\#\#\#\#\# 2

\#\#\# RC-

\#\#\#\# Table 3: Exact match (%) and edit similarity (%) performance on M

2

\#\#\#\# RC-EVAL.

\#\#\#\#\# Model

\#\#\#\#\# C C\# C++ Go HTML Haskell \-

\#\#\#\#\# EM ES EM ES EM ES EM ES EM ES EM ES EM ES

\#\#\#\#\# Code Llama-7B 18.6 47.2 19.6 52.6 21.8 51.1 26.0 53.6 20.6 40.4 22.6 48.9 \- \-

\#\#\#\#\# \+ Retrieval 21.8 47.2 22.9 48.9 23.2 46.6 23.8 52.4 12.6 35.6 22.6 48.9 \- \-

\#\#\#\#\# \+ Retrieval & Tuning 45.4 72.0 43.5 72.3 50.8 74.9 43.4 72.9 41.8 63.6 39.8 66.3 \- \-

\#\#\#\#\# StarCoder-7B 20.0 50.4 20.0 53.3 22.4 51.8 25.4 58.2 17.4 40.7 25.0 51.1 \- \-

\#\#\#\#\# \+ Retrieval 23.8 47.8 27.1 53.2 24.6 48.0 26.0 53.6 20.6 40.4 25.0 47.7 \- \-

\#\#\#\#\# \+ Retrieval & Tuning 47.0 72.7 45.1 74.8 52.4 76.3 43.2 73.7 45.8 67.1 44.8 70.2 \- \-

\#\#\#\#\# DeepSeekCoder-6.7B 22.4 53.7 21.4 56.2 23.2 54.2 29.4 61.4 17.6 43.4 25.2 51.3 \- \-

\#\#\#\#\# \+ Retrieval 28.2 52.6 25.3 52.6 27.6 52.2 29.4 61.4 17.6 43.4 25.8 51.0 \- \-

\#\#\#\#\# \+ Retrieval & Tuning 48.6 75.2 47.9 76.9 54.4 78.2 48.8 78.4 45.0 66.3 45.8 72.0 \- \-

\#\#\#\#\# Model Java JavaScript Kotlin Lua Objective-C PHP \-

\#\#\#\#\# Code Llama-7B 23.4 58.5 17.2 52.0 23.6 57.0 20.0 45.7 17.8 49.5 19.2 54.9 \- \-

\#\#\#\#\# \+ Retrieval 23.4 57.5 19.6 48.0 20.8 50.0 19.6 42.2 21.4 46.6 21.2 49.0 \- \-

\#\#\#\#\# \+ Retrieval & Tuning 41.8 74.1 38.8 70.1 45.0 75.6 43.8 70.5 49.8 75.9 45.6 76.7 \- \-

\#\#\#\#\# StarCoder-7B 24.0 59.2 16.6 52.0 24.4 59.3 21.4 48.6 17.6 49.6 18.6 54.4 \- \-

\#\#\#\#\# \+ Retrieval 25.0 53.1 22.0 50.8 22.8 52.6 26.4 48.5 23.6 48.0 18.6 54.4 \- \-

\#\#\#\#\# \+ Retrieval & Tuning 47.4 76.9 38.8 70.1 45.0 75.6 43.8 70.5 50.8 75.9 45.6 76.7 \- \-

\#\#\#\#\# DeepSeekCoder-6.7B 22.2 61.0 20.4 56.5 26.0 61.0 22.0 48.8 21.0 55.6 24.2 58.6 \- \-

\#\#\#\#\# \+ Retrieval 21.6 51.4 24.4 53.6 26.0 61.0 22.0 49.9 27.6 53.5 28.6 56.9 \- \-

\#\#\#\#\# \+ Retrieval & Tuning 48.2 79.1 43.6 73.5 46.0 75.7 44.6 70.6 52.2 77.6 49.8 78.8 \- \-

\#\#\#\#\# Model Python R Ruby Rust Scala TypeScript Avg.

\#\#\#\#\# Code Llama-7B 24.6 54.2 15.2 41.2 17.2 45.8 26.2 56.0 22.8 48.5 23.4 52.3 19.4 50\.

\#\#\#\#\# \+ Retrieval 17.4 46.4 15.2 39.8 17.2 42.3 26.0 51.3 22.8 48.5 19.4 48.6 20.2 46\.

\#\#\#\#\# \+ Retrieval & Tuning 39.2 69.9 38.6 65.5 43.0 68.5 42.0 69.2 41.0 70.1 37.0 68.2 41.9 70\.

\#\#\#\#\# StarCoder-7B 19.4 52.9 16.4 43.7 19.4 47.4 26.2 56.0 23.6 53.4 19.8 53.3 21.0 52\.

\#\#\#\#\# \+ Retrieval 24.6 54.2 22.6 47.2 23.6 47.4 26.4 53.5 22.8 48.5 23.4 52.3 24.1 50\.

\#\#\#\#\# \+ Retrieval & Tuning 39.2 69.9 41.0 66.6 43.0 68.5 45.8 72.6 43.6 71.5 39.2 69.7 44.5 72\.

\#\#\#\#\# DeepSeekCoder-6.7B 21.8 55.1 19.4 48.5 23.6 52.2 23.8 54.3 24.6 56.7 19.4 55.4 22.6 54\.

\#\#\#\#\# \+ Retrieval 21.8 55.1 19.4 48.5 23.6 52.2 23.8 54.3 22.4 50.4 26.0 54.5 25.1 51\.

\#\#\#\#\# \+ Retrieval & Tuning 41.6 71.3 45.4 69.4 45.6 70.3 47.6 73.4 44.8 73.7 43.2 73.4 46.8 74\.

\#\#\#\# Table 4: Performance on M

2

\#\#\#\# RC-EVAL.

\#\#\# Model EM ES

\#\#\# StarCoder-3B 14.9 43\.

\#\#\# \+ Retrieval 14.6 38\.

\#\#\# \+ Retrieval & Tuning 41.7 69\.

\#\#\# StarCoder-7B 20.6 49\.

\#\#\# \+ Retrieval 23.6 49\.

\#\#\# \+ Retrieval & Tuning 44.4 71\.

\#\#\# EVAL. Our observations indicate that increasing

\#\#\# the dataset from 0.1k to 50k samples per language

\#\#\# yields improved results. This suggests that more

\#\#\# training data can help boost the model’s perfor-

\#\#\# mance. Therefore, we select 50k samples per lan-

\#\#\#\# Table 5: Performance under different training data sizes.

\#\#\#\#\# Data Size (Per lang.) 100 1k 5k 10k 50k

\#\#\#\#\# EM (Avg.) 23.4 35.7 40.5 42.4 44\.

\#\#\#\#\# ES (Avg.) 49.1 62.9 68.2 69.4 71\.

\#\#\# guage as the default training set size.

\#\#\# Analysis on the granularity of different bucket

\#\#\# levels. As mentioned in §( 3.4), we categorize

\#\#\# M

\#\#\#\#\#\# 2

\#\#\# RC-EVALinto ten bucket levels based on the

\#\#\# positions of the code requiring completion within

\#\#\# the abstract syntax tree. As shown in Fig. 4,

\#\#\# we presents the performance of StarCoder-7B on

\#\#\# the test set ofM

\#\#\#\#\#\# 2

\#\#\# RC-EVALacross these different

\#\#\# bucket levels, and we observe that as the bucket

\#\#\# level decreases, the performance of StarCoder-7B

\#\#\# correspondingly declines, which means that the

\#\#\#\# Table 6: CodeBLEU results on ten representative programming languages.

\#\#\#\# Model C C\# C++ Go Java JavaScript PHP Python Ruby Rust Avg.

\#\#\#\# StarCoder-7B 48.3 48.9 50.4 51.5 50.6 46.4 48.2 46.4 46.1 50.4 48\.

\#\#\#\# \+ Retrieval 50.1 52.3 51.1 52.5 51.4 49.3 52.2 49.3 49.1 51.4 50\.

\#\#\#\# \+ Retrieval & Tuning 56.0 57.4 57.6 57.0 57.6 54.8 57.8 52.0 52.9 55.5 55\.

\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\#\#\#\# Figure 4: Effectiveness of different bucket levels.

\#\#\#\# Table 7: Performance on M

2

\#\#\#\# RC-EVAL.

\#\#\# Model Syntax Accuracy

\#\#\# StarCoder-7B 82\.

\#\#\# \+ Retrieval 83\.

\#\#\# \+ Retrieval & Tuning 96\.

\#\#\# code completion on the shallow layer is usually

\#\#\# more challenging than on the deep layer. For more

\#\#\# experimental data on single-language completion

\#\#\# performance and its relation to bucket levels, please

\#\#\# refer to Fig.7 and Fig.8 in the Appendix. These

\#\#\# findings suggest that the code LLMs encounter

\#\#\# challenges when addressing shallow nodes within

\#\#\# the syntax tree during the code completion process.

\#\#\# Analysis on the granularity of different semantic

\#\#\# levels.Similarly, in §( 3.4), we also categorize the

\#\#\# nodes within the abstract syntax tree into eleven

\#\#\# primary semantic levels based on their semantic

\#\#\# characteristics, and we provide the performance

\#\#\# of StarCoder-7B for these various semantic levels

\#\#\# across multilingual languages on the test set of the

\#\#\# M

\#\#\#\#\#\# 2

\#\#\# RC-EVAL, as illustrated in Fig. 5\. Notably, we

\#\#\# observe significant performance disparities across

\#\#\# different semantic levels. Specifically, StarCoder-

\#\#\# 7B shows superior performance on “Identifier and

\#\#\# Scope”, while it exhibits lower efficacy on “Special

\#\#\# Language Structure”, This suggests that current

\#\#\# code LLMs are proficient at completing tasks re-

\#\#\# lated to variable definitions and references, yet their

\#\#\# capacity to handle characteristics of different lan-

\#\#\# guages requires further enhancement. For single-

\#\#\# language completion performance across various

\#\#\# node types, please refer to Fig. 9 in the Appendix.

\#\#\# Analysis on completion on different lines. As

\#\#\# shown in Fig.6, StarCoder-7B can effectively com-

\#\#\# plete tasks involving a small number of lines. How-

\#\#\# ever, as the number of lines to be completed in-

\#\#\# creases, the scores of the generated code gradually

\#\#\# decline. This indicates that completing multi-line

\#\#\# code remains a challenge for code LLMs.

\#\#\# Analysis on various input lengths.In Fig. 6, we

\#\#\# report the results produced by StarCoder-7B (“Re-

\#\#\# trieval & Tuning”) on ourM

\#\#\#\#\#\# 2

\#\#\# RC-EVALwhen the

\#\#\# input lengths of range in {512, 1024, 2048, 4096}

\#\#\# tokens. In Fig. 6, we observe that a scaling law

\#\#\# exists, where better performance is achieved when

\#\#\# the input length is larger. Thus, we set the default

\#\#\# input length as 4096 tokens.

\#\#\# Analysis on CodeBLEU metric.In Table 3, we

\#\#\# mainly report the EM and ES metrics based on

\#\#\# the textual similarity, which neglects important

\#\#\# syntactic and semantic features of codes and un-

\#\#\# derestimates different outputs with the same se-

\#\#\# mantic logic. Thus, the CodeBLEU (Ren et al.,

\#\#\# 2020\)

\#\#\#\#\#\# 4

\#\#\# is proposed, which considers information

\#\#\# from not only the shallow match, but also the syn-

\#\#\# tactic match and the semantic match. In Table 6,

\#\#\# we report the results of 10 popular programming

\#\#\# languages using the test split ofM

\#\#\#\#\#\# 2

\#\#\# RC-EVALbased

\#\#\# on the StarCoder-7B model and observe that we

\#\#\# can still achieve better performance by fine-tuning

\#\#\# on our constructedM

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCT, which fur-

\#\#\# ther demonstrates the effectiveness of ourM

\#\#\#\#\#\# 2

\#\#\# RC-

\#\#\# INSTRUCTon repository-level code completion.

\#\#\# Analysis on syntax accuracy.In Table 7, for syn-

\#\#\# tax static analysis, to further verify the syntax cor-

\#\#\# rectness of the predicted code snippets, we use the

\#\#\# code static checking tools (Tree-Sitter) for all pre-

\#\#\# dicted code snippets ofM

\#\#\#\#\#\# 2

\#\#\# RC-EVAL. Specifically,

\#\#\# we parse the code snippet into the abstract syntax

\#\#\# tree and filter out the code snippet, where the parsed

\#\#\# nodes in the code snippet have parsing errors. For

4

\#\#\#\#\# We test the CodeBLEU metric based onhttps://

\#\#\#\#\# github.com/k4black/codebleu.

\`\`\`  
Program Structure  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Control Flow Structure  
\`\`\`  
\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type Statement  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
Comments and Documentation  
\`\`\`  
\`\`\`  
Preprocessing Directive  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
Special Language Structure  
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
1\.  
\`\`\`  
\*\*Score\*\*

\*\*Performance of Different Semantic Levels (total)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\#\#\#\# Figure 5: Effectiveness of different semantic levels based on StarCoder-7B.

\#\#\#\# Table 8: Results of M

2

\#\#\#\# RC-EVALbased on paradigm types.

\#\#\#\#\# Paradigm Types StarCoder \+ Retrieval \+ Retrieval & Tuning

\#\#\#\#\# Procedural 19.2 23.7 47\.

\#\#\#\#\# Object Oriented 21.3 24.2 47\.

\#\#\#\#\# Multiple Paradigms 21.1 24.3 43\.

\#\#\#\#\# Functional 25.1 24.8 44\.

\#\#\#\#\# Markup Language 17.2 21.3 46\.

\#\#\#\# Table 9: Results of M

2

\#\#\#\# RC-EVALbased on application scenarios.

\#\#\#\#\# Application Scenarios StarCoder \+ Retrieval \+ Retrieval & Tuning

\#\#\#\#\# Mobile 21.2 22.9 48\.

\#\#\#\#\# Cross Platform 24.2 25.3 48\.

\#\#\#\#\# Desktop Application 18.7 26.1 45\.

\#\#\#\#\# Web Frontend 17.9 22.2 41\.

\#\#\#\#\# Web Backend 22.8 24.8 44\.

\#\#\#\#\# Scientific Computing 18.2 23.5 40\.

\#\#\#\#\# System & Software 21.3 24.0 50\.

\#\#\#\#\# Education & Research 25.1 24.8 44\.

\#\#\#\#\# Automation Scripts 21.7 26.3 43\.

\`\`\`  
1 2 3 4 5  
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
EM  
\`\`\`  
\`\`\`  
ES  
\`\`\`  
\`\`\`  
512 1024 2048 4096  
\`\`\`  
\`\`\`  
15  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
25  
\`\`\`  
\`\`\`  
30  
\`\`\`  
\`\`\`  
35  
\`\`\`  
\`\`\`  
40  
\`\`\`  
\`\`\`  
45  
\`\`\`  
\`\`\`  
50  
\`\`\`  
\`\`\`  
31\.  
\`\`\`  
\`\`\`  
35\.  
\`\`\`  
\`\`\`  
39\.  
\`\`\`  
\`\`\`  
44\.  
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
70  
\`\`\`  
\`\`\`  
80  
\`\`\`  
\`\`\`  
59\.  
\`\`\`  
\`\`\`  
63\.  
\`\`\`  
\`\`\`  
66\.  
\`\`\`  
\`\`\`  
71\.  
\`\`\`  
\`\`\`  
Exact Match  
\`\`\`  
\`\`\`  
Edit Similarity  
\`\`\`  
\#\#\#\# Figure 6: Left figure: Results of different lines. Right

\#\#\#\# figure: Results of various input lengths.

\#\#\# execution analysis, generating unit test cases and

\#\#\# providing execution sandboxes for repository-level

\#\#\# code completion are very challenging. In Table 7,

\#\#\# we observe that tuning leads to better performance

\#\#\# in both syntax and execution analysis. Notably, we

\#\#\# observe that syntax accuracy improves a lot after

\#\#\# tuning, which means that code LLMs can easily

\#\#\# learn the basic syntax rules for programming lan-

\#\#\# guages.

\#\#\# Analysis on language-specific insights.We have

\#\#\# classified 18 programming languages inM

\#\#\#\#\#\# 2

\#\#\# RC-

\#\#\# EVALinto 5 programming paradigms and 9 ap-

\#\#\# plication scenarios as shown in Table 11 and Ta-

\#\#\# ble 12: Based on the above programming classi-

\#\#\# fication structure, we also report the EM results

\#\#\# based on StarCoder-7B as shown in Table 8 and

\#\#\# Table 9, and have the following observations: (1).

\#\#\# For different programming paradigms, we observe

\#\#\# that the markup language paradigm has the low-

\#\#\# est performance, and the functional paradigm has

\#\#\# the best performance. Besides, after tuning, the

\#\#\# performance of the markup language paradigm im-

\#\#\# proves greatly. We assume that the syntax rules for

\#\#\# markup language are easy, and these code LLMs

\#\#\# can quickly obtain these rules after tuning. (2). For

\#\#\# different application scenarios, the performance

\#\#\# varies significantly. Specifically, the Web Frontend

\#\#\# and Scientific Computing have relatively low per-

\#\#\# formance, which needs to be improved for existing

\#\#\# code LLMs. (3). We observe these LLMs share

\#\#\# some common strengths and weaknesses and we

\#\#\# will continue to investigate more language-specific

\#\#\# insights to better improve the code completion abil-

\#\#\# ities of existing code LLMs.

\#\# 5 Conclusion

\#\#\# In this paper, we propose the first massively mul-

\#\#\# tilingual repository-level code completion bench-

\#\#\# mark (M

\#\#\#\#\#\# 2

\#\#\# RC-EVAL) with 18 popular programming

\#\#\# languages, where two types of fine-grained anno-

\#\#\# tations (bucket-level and semantic-level) are pro-

\#\#\# vided to comprehensively analyze the effectiveness

\#\#\# of different code LLMs. Besides, we also curate a

\#\#\# high-quality instruction corpusM

\#\#\#\#\#\# 2

\#\#\# RC-INSTRUCT

\#\#\# to enhance the performance of existing models on

\#\#\# repository-level code completion. Finally, we hope

\#\#\# M

\#\#\#\#\#\# 2

\#\#\# RC-EVALcould facilitate the growth of code

\#\#\# intelligence and software engineering.

\#\# 6 Limitations

\#\#\# First, there are several hyperparameters (e.g., train-

\#\#\# ing sizes, input length) to tune, which is laborious

\#\#\# and expensive. Second, the current work only fo-

\#\#\# cuses on the repository-level code completion task,

\#\#\# where other repository-level code intelligence tasks

\#\#\# are not considered. Third, whileM

\#\#\#\#\#\# 2

\#\#\# RC-EVALaims

\#\#\# to simulate realistic debugging scenarios, the tasks

\#\#\# and data may not fully capture the complexity and

\#\#\# diversity of real-world software development. We

\#\#\# will continue include challenging and complex real-

\#\#\# world repos into the benchmark.

\#\# 7 Acknowledgement

\#\#\# This work was supported by the Jiangsu Science

\#\#\# and Technology Major Project (BG2024031) and

\#\#\# Nanjing University AI & AI for Science Funding

\#\#\# (2024300540).

\#\# References

\#\#\#\# Lakshya A Agrawal, Aditya Kanade, Navin Goyal, Shu-

\#\#\#\# vendu K Lahiri, and Sriram K Rajamani. 2023\. Guid-

\#\#\#\# ing language models of code with global context

\#\#\#\# using monitors.

\#\#\#\# Loubna Ben Allal, Raymond Li, Denis Kocetkov,

\#\#\#\# Chenghao Mou, Christopher Akiki, Carlos Munoz

\#\#\#\# Ferrandis, Niklas Muennighoff, Mayank Mishra,

\#\#\#\# Alex Gu, Manan Dey, et al. 2023\. Santacoder: don’t

\#\#\#\# reach for the stars\!arXiv preprint arXiv:2301.03988.

\#\#\#\# Jacob Austin, Augustus Odena, Maxwell Nye, Maarten

\#\#\#\# Bosma, Henryk Michalewski, David Dohan, Ellen

\#\#\#\# Jiang, Carrie Cai, Michael Terry, Quoc Le, et al. 2021\.

\#\#\#\# Program synthesis with large language models.arXiv

\#\#\#\# preprint arXiv:2108.07732.

\#\#\#\# Ramakrishna Bairi, Atharv Sonwane, Aditya Kanade,

\#\#\#\# Arun Iyer, Suresh Parthasarathy, Sriram Rajamani,

\#\#\#\# B Ashok, Shashank Shet, et al. 2023\. Codeplan:

\#\#\#\# Repository-level coding using llms and planning.

\#\#\#\# arXiv preprint arXiv:2309.12499.

\#\#\#\# Mohammad Bavarian, Heewoo Jun, Nikolas Tezak,

\#\#\#\# John Schulman, Christine McLeavey, Jerry Tworek,

\#\#\#\# and Mark Chen. 2022a. Efficient training of lan-

\#\#\#\# guage models to fill in the middle. arXiv preprint

\#\#\#\# arXiv:2207.14255.

\#\#\#\# Mohammad Bavarian, Heewoo Jun, Nikolas Tezak,

\#\#\#\# John Schulman, Christine McLeavey, Jerry Tworek,

\#\#\#\# and Mark Chen. 2022b. Efficient training of lan-

\#\#\#\# guage models to fill in the middle. arXiv preprint

\#\#\#\# arXiv:2207.14255.

\#\#\#\# Sidney Black, Stella Biderman, Eric Hallahan, Quentin

\#\#\#\# Anthony, Leo Gao, Laurence Golding, Horace

\#\#\#\# He, Connor Leahy, Kyle McDonell, Jason Phang,

\#\#\#\# Michael Pieler, Usvsn Sai Prashanth, Shivanshu Puro-

\#\#\#\# hit, Laria Reynolds, Jonathan Tow, Ben Wang, and

\#\#\#\# Samuel Weinbach. 2022\. GPT-NeoX-20B: An open-

\#\#\#\# source autoregressive language model. InProceed-

\#\#\#\# ings of BigScience Episode \#5 – Workshop on Chal-

\#\#\#\# lenges & Perspectives in Creating Large Language

\#\#\#\# Models, pages 95–136, virtual+Dublin. Association

\#\#\#\# for Computational Linguistics.

\#\#\#\# Federico Cassano, John Gouwar, Daniel Nguyen, Syd-

\#\#\#\# ney Nguyen, Luna Phipps-Costin, Donald Pinckney,

\#\#\#\# Ming-Ho Yee, Yangtian Zi, Carolyn Jane Anderson,

\#\#\#\# Molly Q Feldman, et al. 2022\. Multipl-e: A scal-

\#\#\#\# able and extensible approach to benchmarking neural

\#\#\#\# code generation.arXiv preprint arXiv:2208.08227.

\#\#\#\# Linzheng Chai, Shukai Liu, Jian Yang, Yuwei Yin,

\#\#\#\# Ke Jin, Jiaheng Liu, Tao Sun, Ge Zhang, Changyu

\#\#\#\# Ren, Hongcheng Guo, et al. 2024\. Mceval: Mas-

\#\#\#\# sively multilingual code evaluation.arXiv preprint

\#\#\#\# arXiv:2406.07436.

\#\#\#\# Mark Chen, Jerry Tworek, Heewoo Jun, Qiming

\#\#\#\# Yuan, Henrique Ponde de Oliveira Pinto, Jared Ka-

\#\#\#\# plan, Harri Edwards, Yuri Burda, Nicholas Joseph,

\#\#\#\# Greg Brockman, et al. 2021\. Evaluating large lan-

\#\#\#\# guage models trained on code. ArXiv preprint,

\#\#\#\# abs/2107.03374.

\#\#\#\# Aakanksha Chowdhery, Sharan Narang, Jacob Devlin,

\#\#\#\# Maarten Bosma, Gaurav Mishra, Adam Roberts, Paul

\#\#\#\# Barham, Hyung Won Chung, Charles Sutton, Sebas-

\#\#\#\# tian Gehrmann, et al. 2023\. Palm: Scaling language

\#\#\#\# modeling with pathways. 24(240):1–113.

\#\#\#\# Yangruibo Ding, Zijian Wang, Wasi Ahmad, Hantian

\#\#\#\# Ding, Ming Tan, Nihal Jain, Murali Krishna Ra-

\#\#\#\# manathan, Ramesh Nallapati, Parminder Bhatia, Dan

\#\#\#\# Roth, et al. 2024\. Crosscodeeval: A diverse and mul-

\#\#\#\# tilingual benchmark for cross-file code completion.

\#\#\#\# Advances in Neural Information Processing Systems,

\#\#\#\# 36\.

\#\#\#\# Yangruibo Ding, Zijian Wang, Wasi Uddin Ahmad, Han-

\#\#\#\# tian Ding, Ming Tan, Nihal Jain, Murali Krishna Ra-

\#\#\#\# manathan, Ramesh Nallapati, Parminder Bhatia, Dan

\#\#\#\# Roth, and Bing Xiang. 2023\. Crosscodeeval: A di-

\#\#\#\# verse and multilingual benchmark for cross-file code

\#\#\#\# completion. InAdvances in Neural Information Pro-

\#\#\#\# cessing Systems 36: Annual Conference on Neural

\#\#\#\# Information Processing Systems 2023, NeurIPS 2023,

\#\#\#\# New Orleans, LA, USA, December 10 \- 16, 2023\.

\#\#\#\# Yangruibo Ding, Zijian Wang, Wasi Uddin Ahmad,

\#\#\#\# Murali Krishna Ramanathan, Ramesh Nallapati,

\#\#\#\# Parminder Bhatia, Dan Roth, and Bing Xiang.

\#\#\#\# 2022\. Cocomic: Code completion by jointly mod-

\#\#\#\# eling in-file and cross-file context. arXiv preprint

\#\#\#\# arXiv:2212.10007.

\#\#\#\# Daniel Fried, Armen Aghajanyan, Jessy Lin, Sida Wang,

\#\#\#\# Eric Wallace, Freda Shi, Ruiqi Zhong, Scott Yih,

\#\#\#\# Luke Zettlemoyer, and Mike Lewis. 2023\. Incoder:

\#\#\#\# A generative model for code infilling and synthesis.

\#\#\#\# InThe Eleventh International Conference on Learn-

\#\#\#\# ing Representations.

\#\#\#\# Daya Guo, Qihao Zhu, Dejian Yang, Zhenda Xie,

\#\#\#\# Kai Dong, Wentao Zhang, Guanting Chen, Xiao

\#\#\#\# Bi, Y Wu, YK Li, et al. 2024a. Deepseek-coder:

\#\#\#\# When the large language model meets programming–

\#\#\#\# the rise of code intelligence. arXiv preprint

\#\#\#\# arXiv:2401.14196.

\#\#\#\# Daya Guo, Qihao Zhu, Dejian Yang, Zhenda Xie,

\#\#\#\# Kai Dong, Wentao Zhang, Guanting Chen, Xiao

\#\#\#\# Bi, Y Wu, YK Li, et al. 2024b. Deepseek-coder:

\#\#\#\# When the large language model meets programming–

\#\#\#\# the rise of code intelligence. arXiv preprint

\#\#\#\# arXiv:2401.14196.

\#\#\#\# Yancheng He, Shilong Li, Jiaheng Liu, Weixun Wang,

\#\#\#\# Xingyuan Bu, Ge Zhang, Zhongyuan Peng, Zhaox-

\#\#\#\# iang Zhang, Zhicheng Zheng, Wenbo Su, and

\#\#\#\# Bo Zheng. 2025\. Can large language models detect

\#\#\#\# errors in long chain-of-thought reasoning?Preprint,

\#\#\#\# arXiv:2502.19361.

\#\#\#\# Siming Huang, Tianhao Cheng, Jason Klein Liu, Jiaran

\#\#\#\# Hao, Liuyihan Song, Yang Xu, J. Yang, J. H. Liu,

\#\#\#\# Chenchen Zhang, Linzheng Chai, Ruifeng Yuan,

\#\#\#\# Zhaoxiang Zhang, Jie Fu, Qian Liu, Ge Zhang, Zili

\#\#\#\# Wang, Yuan Qi, Yinghui Xu, and Wei Chu. 2024\.

\#\#\#\# Opencoder: The open cookbook for top-tier code

\#\#\#\# large language models.

\#\#\#\# Binyuan Hui, Jian Yang, Zeyu Cui, Jiaxi Yang, Day-

\#\#\#\# iheng Liu, Lei Zhang, Tianyu Liu, Jiajun Zhang,

\#\#\#\# Bowen Yu, Kai Dang, et al. 2024\. Qwen2. 5-coder

\#\#\#\# technical report.arXiv preprint arXiv:2409.12186.

\#\#\#\# Naman Jain, King Han, Alex Gu, Wen-Ding Li, Fanjia

\#\#\#\# Yan, Tianjun Zhang, Sida Wang, Armando Solar-

\#\#\#\# Lezama, Koushik Sen, and Ion Stoica. 2024a. Live-

\#\#\#\# codebench: Holistic and contamination free eval-

\#\#\#\# uation of large language models for code. arXiv

\#\#\#\# preprint arXiv:2403.07974.

\#\#\#\# Nihal Jain, Robert Kwiatkowski, Baishakhi Ray, Mu-

\#\#\#\# rali Krishna Ramanathan, and Varun Kumar. 2024b.

\#\#\#\# On mitigating code llm hallucinations with api docu-

\#\#\#\# mentation.ArXiv, abs/2407.09726.

\#\#\#\# Siyuan Jiang, Jia Li, He Zong, Huanyu Liu, Hao Zhu,

\#\#\#\# Shukai Hu, Erlu Li, Jiazheng Ding, Yu Han, Wei

\#\#\#\# Ning, Gen Wang, Yihong Dong, Kechi Zhang, and

\#\#\#\# Ge Li. 2024\. aixcoder-7b: A lightweight and effec-

\#\#\#\# tive large language model for code completion.

\#\#\#\# Denis Kocetkov, Raymond Li, Loubna Ben Allal, Jia Li,

\#\#\#\# Chenghao Mou, Carlos Muñoz Ferrandis, Yacine Jer-

\#\#\#\# nite, Margaret Mitchell, Sean Hughes, Thomas Wolf,

\#\#\#\# et al. 2022\. The stack: 3 tb of permissively licensed

\#\#\#\# source code.arXiv preprint arXiv:2211.15533.

\#\#\#\# Hung Le, Yue Wang, Akhilesh Deepak Gotmare, Silvio

\#\#\#\# Savarese, and Steven C. H. Hoi. 2022\. Coderl: Mas-

\#\#\#\# tering code generation through pretrained models and

\#\#\#\# deep reinforcement learning.ArXiv, abs/2207.01780.

\#\#\#\# Raymond Li, Loubna Ben Allal, Yangtian Zi, Niklas

\#\#\#\# Muennighoff, Denis Kocetkov, Chenghao Mou, Marc

\#\#\#\# Marone, Christopher Akiki, Jia Li, Jenny Chim, et al.

\#\#\#\# 2023\. Starcoder: may the source be with you\!arXiv

\#\#\#\# preprint arXiv:2305.06161.

\#\#\#\# Yujia Li, David Choi, Junyoung Chung, Nate Kushman,

\#\#\#\# Julian Schrittwieser, Rémi Leblond, Tom Eccles,

\#\#\#\# James Keeling, Felix Gimeno, Agustin Dal Lago,

\#\#\#\# et al. 2022\. Competition-level code generation with

\#\#\#\# alphacode.ArXiv preprint, abs/2203.07814.

\#\#\#\# Dianshu Liao, Shidong Pan, Qing Huang, Xiaoxue Ren,

\#\#\#\# Zhenchang Xing, Huan Jin, and Qinying Li. 2023\.

\#\#\#\# Context-aware code generation framework for code

\#\#\#\# repositories: Local, global, and third-party library

\#\#\#\# awareness.

\#\#\#\# Jiaheng Liu, Chenchen Zhang, Jinyang Guo, Yuanxing

\#\#\#\# Zhang, Haoran Que, Ken Deng, Jie Liu, Ge Zhang,

\#\#\#\# Yanan Wu, Congnan Liu, et al. 2024\. Ddk: Distill-

\#\#\#\# ing domain knowledge for efficient large language

\#\#\#\# models.Advances in Neural Information Processing

\#\#\#\# Systems, 37:98297–98319.

\#\#\#\# Jiaheng Liu, Dawei Zhu, Zhiqi Bai, Yancheng

\#\#\#\# He, Huanxuan Liao, Haoran Que, Zekun Wang,

\#\#\#\# Chenchen Zhang, Ge Zhang, Jiebin Zhang, et al.

\#\#\#\# 2025\. A comprehensive survey on long context lan-

\#\#\#\# guage modeling.arXiv preprint arXiv:2503.17407.

\#\#\#\# Tianyang Liu, Canwen Xu, and Julian McAuley.

\#\#\#\# 2023a. Repobench: Benchmarking repository-

\#\#\#\# level code auto-completion systems.arXiv preprint

\#\#\#\# arXiv:2306.03091.

\#\#\#\# Tianyang Liu, Canwen Xu, and Julian J. McAuley.

\#\#\#\# 2023b. Repobench: Benchmarking repository-level

\#\#\#\# code auto-completion systems. abs/2306.03091.

\#\#\#\# Anton Lozhkov, Raymond Li, Loubna Ben Allal, Fed-

\#\#\#\# erico Cassano, Joel Lamy-Poirier, Nouamane Tazi,

\#\#\#\# Ao Tang, Dmytro Pykhtar, Jiawei Liu, Yuxiang Wei,

\#\#\#\# et al. 2024\. Starcoder 2 and the stack v2: The next

\#\#\#\# generation.

\#\#\#\# Erik Nijkamp, Bo Pang, Hiroaki Hayashi, Lifu Tu, Huan

\#\#\#\# Wang, Yingbo Zhou, Silvio Savarese, and Caiming

\#\#\#\# Xiong. 2023\. Codegen: An open large language

\#\#\#\# model for code with multi-turn program synthesis.

\#\#\#\# InInternational Conference on Learning Representa-

\#\#\#\# tions.

\#\#\#\# Hengzhi Pei, Jinman Zhao, Leonard Lausen, Sheng

\#\#\#\# Zha, and George Karypis. 2023\. Better context

\#\#\#\# makes better code language models: A case study

\#\#\#\# on function call argument completion. InProceed-

\#\#\#\# ings of the Thirty-Seventh AAAI Conference on Ar-

\#\#\#\# tificial Intelligence and Thirty-Fifth Conference on

\#\#\#\# Innovative Applications of Artificial Intelligence and

\#\#\#\# Thirteenth Symposium on Educational Advances in

\#\#\#\# Artificial Intelligence, AAAI’23/IAAI’23/EAAI’23.

\#\#\#\# AAAI Press.

\#\#\#\# Huy Nhat Phan, Hoang N. Phan, Tien N. Nguyen, and

\#\#\#\# Nghi D. Q. Bui. 2024\. Repohyper: Search-expand-

\#\#\#\# refine on semantic graphs for repository-level code

\#\#\#\# completion.

\#\#\#\# Shuo Ren, Daya Guo, Shuai Lu, Long Zhou, Shujie Liu,

\#\#\#\# Duyu Tang, Neel Sundaresan, Ming Zhou, Ambrosio

\#\#\#\# Blanco, and Shuai Ma. 2020\. Codebleu: a method

\#\#\#\# for automatic evaluation of code synthesis. arXiv

\#\#\#\# preprint arXiv:2009.10297.

\#\#\#\# Baptiste Roziere, Jonas Gehring, Fabian Gloeckle, Sten

\#\#\#\# Sootla, Itai Gat, Xiaoqing Ellen Tan, Yossi Adi,

\#\#\#\# Jingyu Liu, Tal Remez, Jérémy Rapin, et al. 2023\.

\#\#\#\# Code llama: Open foundation models for code.

\#\#\#\# Disha Shrivastava, Denis Kocetkov, Harm de Vries,

\#\#\#\# Dzmitry Bahdanau, and Torsten Scholak. 2023a. Re-

\#\#\#\# pofusion: Training code models to understand your

\#\#\#\# repository.arXiv preprint arXiv:2306.10998.

\#\#\#\# Disha Shrivastava, Hugo Larochelle, and Daniel Tarlow.

\#\#\#\# 2023b. Repository-level prompt generation for large

\#\#\#\# language models of code. InProceedings of the

\#\#\#\# 40th International Conference on Machine Learning,

\#\#\#\# volume 202 ofProceedings of Machine Learning

\#\#\#\# Research, pages 31693–31715. PMLR.

\#\#\#\# Jianlin Su, Murtadha Ahmed, Yu Lu, Shengfeng Pan,

\#\#\#\# Wen Bo, and Yunfeng Liu. 2024\. Roformer: En-

\#\#\#\# hanced transformer with rotary position embedding.

\#\#\#\# 568:127063.

\#\#\#\# Wannita Takerngsaksiri, Chakkrit Tantithamthavorn,

\#\#\#\# and Yuan-Fang Li. 2024\. Syntax-aware on-the-fly

\#\#\#\# code completion.Inf. Softw. Technol., 165(C).

\#\#\#\# Hugo Touvron, Thibaut Lavril, Gautier Izacard, Xavier

\#\#\#\# Martinet, Marie-Anne Lachaux, Timothée Lacroix,

\#\#\#\# Baptiste Rozière, Naman Goyal, Eric Hambro, Faisal

\#\#\#\# Azhar, et al. 2023\. Llama: Open and efficient foun-

\#\#\#\# dation language models.

\#\#\#\# Pei Wang, Yanan Wu, Noah Wang, Jiaheng Liu, Xi-

\#\#\#\# aoshuai Song, Z.Y. Peng, Ken Deng, Chenchen

\#\#\#\# Zhang, JiakaiWang, Junran Peng, Ge Zhang, Hangyu

\#\#\#\# Guo, Zhaoxiang Zhang, Wenbo Su, and Bo Zheng.

\#\#\#\# 2024\. Mtu-bench: A multi-granularity tool-use

\#\#\#\# benchmark for large language models.

\#\#\#\# Yue Wang, Hung Le, Akhilesh Deepak Gotmare,

\#\#\#\# Nghi DQ Bui, Junnan Li, and Steven CH Hoi. 2023\.

\#\#\#\# Codet5+: Open code large language models for code

\#\#\#\# understanding and generation.

\#\#\#\# Yue Wang, Weishi Wang, Shafiq Joty, and Steven C.H.

\#\#\#\# Hoi. 2021\. CodeT5: Identifier-aware unified pre-

\#\#\#\# trained encoder-decoder models for code understand-

\#\#\#\# ing and generation. InProceedings of the 2021

\#\#\#\# Conference on Empirical Methods in Natural Lan-

\#\#\#\# guage Processing, pages 8696–8708, Online and

\#\#\#\# Punta Cana, Dominican Republic. Association for

\#\#\#\# Computational Linguistics.

\#\#\#\# Frank F Xu, Uri Alon, Graham Neubig, and Vincent Jo-

\#\#\#\# sua Hellendoorn. 2022\. A systematic evaluation of

\#\#\#\# large language models of code. InProceedings of

\#\#\#\# the 6th ACM SIGPLAN International Symposium on

\#\#\#\# Machine Programming, pages 1–10.

\#\#\#\# Hao Yu, Bo Shen, Dezhi Ran, Jiaxin Zhang, Qi Zhang,

\#\#\#\# Yuchi Ma, Guangtai Liang, Ying Li, Qianxiang Wang,

\#\#\#\# and Tao Xie. 2024\. Codereval: A benchmark of prag-

\#\#\#\# matic code generation with generative pre-trained

\#\#\#\# models. InProceedings of the 46th IEEE/ACM Inter-

\#\#\#\# national Conference on Software Engineering, pages

\#\#\#\# 1–12.

\#\#\#\# Alexander Zhang, Marcus Dong, Jiaheng Liu, Wei

\#\#\#\# Zhang, Yejie Wang, Jian Yang, Ge Zhang, Tianyu Liu,

\#\#\#\# Zhongyuan Peng, Yingshui Tan, Yuanxing Zhang,

\#\#\#\# Zhexu Wang, Weixun Wang, Yancheng He, Ken

\#\#\#\# Deng, Wangchunshu Zhou, Wenhao Huang, and

\#\#\#\# Zhaoxiang Zhang. 2025\. Codecriticbench: A holistic

\#\#\#\# code critique benchmark for large language models.

\#\#\#\# Preprint, arXiv:2502.16614.

\#\#\#\# Fengji Zhang, Bei Chen, Yue Zhang, Jin Liu, Daoguang

\#\#\#\# Zan, Yi Mao, Jian-Guang Lou, and Weizhu Chen.

\#\#\#\# 2023\. Repocoder: Repository-level code comple-

\#\#\#\# tion through iterative retrieval and generation.arXiv

\#\#\#\# preprint arXiv:2303.12570.

\#\#\#\# Ge Zhang, Scott Qu, Jiaheng Liu, Chenchen Zhang,

\#\#\#\# Chenghua Lin, Chou Leuang Yu, Danny Pan, Es-

\#\#\#\# ther Cheng, Jie Liu, Qunshu Lin, Raven Yuan, Tuney

\#\#\#\# Zheng, Wei Pang, Xinrun Du, Yiming Liang, Ying-

\#\#\#\# hao Ma, Yizhi Li, Ziyang Ma, Bill Lin, Emmanouil

\#\#\#\# Benetos, Huan Yang, Junting Zhou, Kaijing Ma,

\#\#\#\# Minghao Liu, Morry Niu, Noah Wang, Quehry

\#\#\#\# Que, Ruibo Liu, Sine Liu, Shawn Guo, Soren Gao,

\#\#\#\# Wangchunshu Zhou, Xinyue Zhang, Yizhi Zhou,

\#\#\#\# Yubo Wang, Yuelin Bai, Yuhan Zhang, Yuxiang

\#\#\#\# Zhang, Zenith Wang, Zhenzhu Yang, Zijian Zhao,

\#\#\#\# Jiajun Zhang, Wanli Ouyang, Wenhao Huang, and

\#\#\#\# Wenhu Chen. 2024\. Map-neo: Highly capable and

\#\#\#\# transparent bilingual large language model series.

\#\#\#\# arXiv preprint arXiv: 2405.19327.

\#\#\#\# CodeGemma Team Heri Zhao, Jeffrey Hui, Joshua How-

\#\#\#\# land, Nam Nguyen, Siqi Zuo, Andrea Hu, Christo-

\#\#\#\# pher A. Choquette-Choo, Jingyue Shen, Joe Kel-

\#\#\#\# ley, Kshi tij Bansal, Luke Vilnis, Mateo Wirth, Paul

\#\#\#\# Michel, Peter Choy, Pratik Joshi, Ravin Kumar, Sar-

\#\#\#\# mad Hashmi, Shubham Agrawal, Zhitao Gong, Jane

\#\#\#\# Fine, Tris Brian Warkentin, Ale Jakse Hartman, Bin

\#\#\#\# Ni, Kathy Korevec, Kelly Schaefer, and Scott Huff-

\#\#\#\# man. 2024\. Codegemma: Open code models based

\#\#\#\# on gemma.ArXiv, abs/2406.11409.

\#\#\#\# Qinkai Zheng, Xiao Xia, Xu Zou, Yuxiao Dong, Shan

\#\#\#\# Wang, Yufei Xue, Zihan Wang, Lei Shen, Andi Wang,

\#\#\#\# Yang Li, Teng Su, Zhilin Yang, and Jie Tang. 2023\.

\#\#\#\# Codegeex: A pre-trained model for code generation

\#\#\#\# with multilingual evaluations on humaneval-x.arXiv

\#\#\#\# preprint arXiv:2303.17568, abs/2303.17568.

\#\#\#\# Terry Yue Zhuo, Vu Minh Chien, Jenny Chim, Han Hu,

\#\#\#\# Wenhao Yu, Ratnadira Widyasari, Imam Nur Bani

\#\#\#\# Yusuf, Haolan Zhan, Junda He, Indraneil Paul, Simon

\#\#\#\# Brunner, Chen GONG, James Hoang, Armel Randy

\#\#\#\# Zebaze, Xiaoheng Hong, Wen-Ding Li, Jean Kad-

\#\#\#\# dour, Ming Xu, Zhihan Zhang, Prateek Yadav, Na-

\#\#\#\# man Jain, Alex Gu, Zhoujun Cheng, Jiawei Liu,

\#\#\#\# Qian Liu, Zijian Wang, David Lo, Binyuan Hui,

\#\#\#\# Niklas Muennighoff, Daniel Fried, Xiaoning Du,

\#\#\#\# Harm de Vries, and Leandro Von Werra. 2025\. Big-

\#\#\#\# codebench: Benchmarking code generation with di-

\#\#\#\# verse function calls and complex instructions. In

\#\#\#\# The Thirteenth International Conference on Learn-

\#\#\#\# ing Representations.

\#\# A Appendix

\#\#\# A.1 Broader Impacts & Potential Risks

\#\#\# In this paper, we propose a repository-level code completion benchmark with 18 programming languages.

\#\#\# Therefore, we hope our work can enhance the improvements on the multilingual repository-level code

\#\#\# completion task. For potential risks, we have not seen any risks in our M

\#\#\#\#\#\# 2

\#\#\# RC-EVAL.

\#\#\# A.2 Details of the Baseline Models

\#\#\# StarCoder(Li et al., 2023\) is a series of generative language models (e.g., 7B, 15.5B). These decoder-only

\#\#\# models are trained on the Stack dataset (Kocetkov et al., 2022\) and can support 8K tokens in context.

\#\#\# DeepSeekCoder(Guo et al., 2024b) is a collection of code-oriented models with capacities from 1.3B

\#\#\# to 33B parameters. Trained on a manually curated 2-trillion-token corpus, these models leverage Fill-

\#\#\# in-the-Middle (FIM) (Bavarian et al., 2022b) and Rotary Position Embedding (RoPE) (Su et al., 2024\)

\#\#\# techniques, which enables efficient code generation and infilling within a 16K token window.

\#\#\# Code Llama(Roziere et al., 2023\) is a family of code large language models based on Llama 2 (Touvron

\#\#\# et al., 2023\) with 7B, 13B, 34B, and 70B parameters. While trained on 16K token sequences, these models

\#\#\# can handle inputs up to 100K tokens during inference.

\#\#\# Note that we just use the base model versions of these three models.

\#\#\# A.3 Analysis on the Quality Control

\#\#\# In §( 3.2), we discard test samples that could be exactly predicted by DeepSeekCoder-1.3B without cross-

\#\#\# file contexts. Meanwhile, to discuss more clearly, we also use the DeepSeekCoder-6.7B, StarCoder-7B,

\#\#\# and DeepSeekCoder-33B to analyze the ratios of evaluation cases with or without using repository-level

\#\#\# contexts. Specifically, we prompt DeepSeekCoder-6.7B, StarCoder-7B, and DeepSeekCoder-33B using

\#\#\# the in-file contexts of each sample and obtain three predictions. If one prediction is exactly matched

\#\#\# ground-truth, this sample is considered to be predicted without requiring repository-level contexts. Finally,

\#\#\# we observe that 71% samples cannot be well predicted only using in-file contexts, which indicates that it

\#\#\# is necessary to use the cross-file contexts to achieve better performance in our M

\#\#\#\#\#\# 2

\#\#\# RC-EVAL.

\#\#\# A.4 Analysis on Inference Cases in Different Languages

\#\#\# We manually inspect the behavior of StarCoder-7B (Li et al., 2023\) on completion cases in different

\#\#\# programming languages. As shown in Fig. 13, the model successively predicts the attributeposition.y,

\#\#\# which is an easy pattern that could be inferred fromposition.xin the prefix. Besides, the(x, y)

\#\#\# pattern that occurs multiple times in the cross-file context. On the contrary, the model seems to struggle

\#\#\# with complex expressions and statements. In Fig. 14, the model should complete the function with a

\#\#\# combined condition and return statement. However, the retriever could not provide useful references

\#\#\# and the model only predicts half of the condition correctly. Fig. 15 illustrates a Python script to execute

\#\#\# memory calculations. Although some calculations appear in the cross-file context, there are no precisely

\#\#\# matched calculation procedures. The recurrent conditions in the ground truth require calculations on

\#\#\# the data shape, but the model clumsily guesses the data shape. Moreover, we observe that the model

\#\#\# prediction is usually affected by frequent identifiers in the retrieved contents. In Fig. 16, the model

\#\#\# repeats thegc.Clientand results in a hallucination for objectPullRequests, where the ground truth is

\#\#\# gc. Similarly, in Fig. 17, the model blindly catches the “err” with error level. Yet the correct log level

\#\#\# is “warn”, which could be judged fromc.on(’error’, console.warn)in the Cross file Context 1\.

\#\#\# Further, in Fig. 18, the ground truth and the model prediction differ by only two characters “()” from a

\#\#\# textual perspective, but the ground truth passes the method reference while the model prediction passes

\#\#\# the method return.

\#\#\# A.5 Analysis on the Number of Bucket Granularity

\#\#\# In Table 10, we have analyzed the minimum, maximum, and average depths of these 18 programming

\#\#\# languages, and observed that depths of AST for different languages are different greatly, where the

\#\#\# minimum depth is from 1 to 7, and the maximum depth is from 23 to 51\. Therefore, we cannot use

\#\#\# the node’s layer number in the AST as the fine-grained annotation well. Besides, we observe that the

\#\#\# average depth of different languages is from 9.7 to 20.2, and the overall average depth is 14.6. In our

\#\#\# implementation, to explain clearly, we just chose 10 as the bucket number. Note that we will provide the

\#\#\# tree depth number for each completion sample, and users can select the corresponding bucket number

\#\#\# freely.

\#\#\#\# Table 10: Depth statistics of different languages.

\#\#\#\# Language Minimum Maximum Average

\#\#\#\# Objective-C 3 32 11\.

\#\#\#\# C++ 3 32 11\.

\#\#\#\# C 4 41 13\.

\#\#\#\# Haskell 1 28 10\.

\#\#\#\# Ruby 2 45 13\.

\#\#\#\# Kotlin 1 34 14\.

\#\#\#\# Rust 5 51 20\.

\#\#\#\# C\# 3 41 16\.

\#\#\#\# PHP 7 51 17\.

\#\#\#\# Go 1 40 13\.

\#\#\#\# Java 1 46 14\.

\#\#\#\# HTML 2 46 14\.

\#\#\#\# R 1 23 9\.

\#\#\#\# JavaScript 1 31 13\.

\#\#\#\# TypeScript 3 51 18\.

\#\#\#\# Scala 3 51 17\.

\#\#\#\# Lua 2 51 16\.

\#\#\#\# Python 1 38 15\.

\#\#\#\# Table 11: Classification of M

2

\#\#\#\# RC-EVALbased on paradigm types.

\#\#\# Paradigm Types Languages

\#\#\# Procedural C

\#\#\# Object Oriented C\#, Java, Kotlin, Objective-C

\#\#\# Multiple Paradigms C++, Go, JavaScript, Lua, PHP, Python, R, Ruby, Rust, Scala, TypeScript

\#\#\# Functional Haskell

\#\#\# Markup Language HTML

\#\#\#\# Table 12: Classification of M

2

\#\#\#\# RC-EVALbased on application scenarios.

\#\#\# Application Scenarios Languages

\#\#\# Mobile Kotlin, Objective-C

\#\#\# Cross Platform Java

\#\#\# Desktop Application C\#

\#\#\# Web Frontend JavaScript, TypeScript, HTML

\#\#\# Web Backend Go, PHP, Ruby, Rust, Scala

\#\#\# Scientific Computing Python, R

\#\#\# System & Software C, C++

\#\#\# Education & Research Haskell

\#\#\# Automation Scripts Lua

\#\#\# A.6 More Experiments

\- We provide the analysis on the bucket levels in Fig. 7 and Fig. 8, respectively.  
\- We analyze the effect of different semantic levels on Rust, Objective-C, and Haskell in Fig. 9\.

\#\#\# respectively.

\- We provide the semantic-level annotations on 18 languages in Fig. 10, Fig. 11 and Fig. 12\.  
\- We provide the results of problems from different difficulty levels in Fig. 19, where we define

\#\#\# completion on 1 line, completion on 2-3 lines and completion on 4-5 lines as easy, middle, and hard

\#\#\# settings, respectively.

\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (Python)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (Lua)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (Scala)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (TypeScript)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (JavaScript)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (R)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (HTML)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (Go)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (Java)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
1\.  
\`\`\`  
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (PHP)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (C\#)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (Rust)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\#\#\#\# Figure 7: Effectiveness of different bucket levels based on StarCoder-7B for different languages.

\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
1\.  
\`\`\`  
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (Kotlin)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (Haskell)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (C)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
1\.  
\`\`\`  
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (C++)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (Objective-C)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\*\*Bucket Level\*\*

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
\*\*Score\*\*

\*\*Performance of Different Bucket Levels (Rust)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\#\#\#\# Figure 8: Effectiveness of different bucket levels based on StarCoder-7B for different languages.

\`\`\`  
Program Structure  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Control Flow Structure  
\`\`\`  
\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type Statement  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
Comments and Documentation  
\`\`\`  
\`\`\`  
Preprocessing Directive  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
Special Language Structure  
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
1\.  
\`\`\`  
\*\*Score\*\*

\*\*Performance of Different Semantic Levels (Rust)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
Program Structure  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Control Flow Structure  
\`\`\`  
\`\`\`  
Expression Data Type  
\`\`\`  
\`\`\`  
Statement  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
Comments and Documentation  
\`\`\`  
\`\`\`  
Preprocessing Directive  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
Special Language Structure  
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
1\.  
\`\`\`  
\*\*Score\*\*

\*\*Performance of Different Semantic Levels (Objective-C)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\`\`\`  
Program Structure  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Control Flow Structure  
\`\`\`  
\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type Statement  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
Comments and Documentation  
\`\`\`  
\`\`\`  
Preprocessing Directive  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
Special Language Structure  
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
1\.  
\`\`\`  
\*\*Score\*\*

\*\*Performance of Different Semantic Levels (Haskell)\*\*

\`\`\`  
\+ Retrieval & Tuning (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval (EM)  
\`\`\`  
\`\`\`  
\+ Retrieval & Tuning (ES)  
\`\`\`  
\`\`\`  
\+ Retrieval (ES)  
\`\`\`  
\#\#\#\# Figure 9: Effectiveness of different semantic levels based on StarCoder-7B.

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
Fl  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
w  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
ru  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
o  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
s  
\`\`\`  
\`\`\`  
in  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
ir  
\`\`\`  
\`\`\`  
e  
c  
\`\`\`  
\`\`\`  
t  
i  
v  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Sta  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Modifier an  
\`\`\`  
\`\`\`  
d At  
\`\`\`  
\`\`\`  
tribute  
\`\`\`  
\`\`\`  
Co  
mm  
en  
ts  
an  
d D  
o  
cum  
e  
nta  
tio  
n  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
Spe  
cial Languag  
e Structure  
\`\`\`  
\`\`\`  
Arith  
\`\`\`  
\`\`\`  
metic  
\`\`\`  
\`\`\`  
Oper  
\`\`\`  
\`\`\`  
ation  
\`\`\`  
\`\`\`  
Lo  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
ic  
\`\`\`  
\`\`\`  
al  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
Function Call  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
et  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Primitive Type  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
Modifiers  
\`\`\`  
\`\`\`  
Numeric  
\`\`\`  
\`\`\`  
String  
\`\`\`  
\`\`\`  
Character  
\`\`\`  
\`\`\`  
Boolean  
\`\`\`  
\`\`\`  
Special Value  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
Type Definition  
\`\`\`  
\`\`\`  
Structure  
\`\`\`  
\`\`\`  
Union  
\`\`\`  
\`\`\`  
Enum  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
\`\`\`  
\`\`\`  
Label  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Linkage  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
i  
t  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
i  
l  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Ma  
\`\`\`  
\`\`\`  
cro Definition  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Other Modifiers  
\`\`\`  
\`\`\`  
At  
\`\`\`  
\`\`\`  
t  
r  
i  
bu  
\`\`\`  
\`\`\`  
t  
e  
\`\`\`  
\`\`\`  
/  
An  
\`\`\`  
\`\`\`  
n  
o  
t  
a  
\`\`\`  
\`\`\`  
t  
io  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Comment  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Inline Assembly  
\`\`\`  
\`\`\`  
C Programming Language Concepts Hierarchy  
\`\`\`  
\`\`\`  
Loading \[MathJax\]/extensions/MathMenu.js  
\`\`\`  
\#\#\#\#\# (a) C

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
C  
o  
n  
t  
r  
o  
l  
F  
lo  
w  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
r  
u  
c  
tu  
r  
e  
\`\`\`  
\`\`\`  
Program Structure  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
Co  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
en  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
an  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
en  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
nPr  
\`\`\`  
\`\`\`  
ep  
\`\`\`  
\`\`\`  
r  
o  
\`\`\`  
\`\`\`  
c  
es  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
n  
g  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
i  
r  
\`\`\`  
\`\`\`  
ec  
\`\`\`  
\`\`\`  
t  
i  
v  
e  
\`\`\`  
\`\`\`  
Sp  
\`\`\`  
\`\`\`  
ec  
\`\`\`  
\`\`\`  
ial  
\`\`\`  
\`\`\`  
Lan  
\`\`\`  
\`\`\`  
g  
u  
ag  
\`\`\`  
\`\`\`  
e St  
\`\`\`  
\`\`\`  
r  
u  
c  
t  
u  
r  
e  
\`\`\`  
\`\`\`  
S  
t  
at  
\`\`\`  
\`\`\`  
em  
\`\`\`  
\`\`\`  
en  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
rithme  
\`\`\`  
\`\`\`  
tic Op  
\`\`\`  
\`\`\`  
eratio  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Lo  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
ic  
\`\`\`  
\`\`\`  
al  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
Function Calln  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
et  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Primitive Type  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
Generice  
Numeric  
\`\`\`  
\`\`\`  
String  
\`\`\`  
\`\`\`  
Boolean  
\`\`\`  
\`\`\`  
Special Value  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
\`\`\`  
\`\`\`  
E  
xc  
\`\`\`  
\`\`\`  
e  
pt  
io  
n  
\`\`\`  
\`\`\`  
H  
an  
d  
li  
n  
g  
Program Entry  
\`\`\`  
\`\`\`  
Namespace  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
Access Modifiers  
\`\`\`  
\`\`\`  
Other Modifiers  
\`\`\`  
\`\`\`  
At  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
bu  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
/  
\`\`\`  
\`\`\`  
An  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Si  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\-

\`\`\`  
l  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
ul  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\-

\`\`\`  
l  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
ne  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
mme  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
i  
t  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
i  
l  
a  
\`\`\`  
\`\`\`  
t  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Ma  
\`\`\`  
\`\`\`  
cro Definition  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
mb  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
i  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Coroutine  
\`\`\`  
\`\`\`  
E  
x  
p  
\`\`\`  
\`\`\`  
r  
e  
s  
s  
i  
o  
n  
S  
\`\`\`  
\`\`\`  
ta  
\`\`\`  
\`\`\`  
t  
e  
m  
\`\`\`  
\`\`\`  
e  
n  
t  
\`\`\`  
\`\`\`  
C  
o  
m  
p  
o  
u  
n  
d  
St  
\`\`\`  
\`\`\`  
a  
te  
m  
\`\`\`  
\`\`\`  
e  
n  
t  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
C\# Programming Language Concepts Hierarchy  
\`\`\`  
\`\`\`  
Loading \[MathJax\]/extensions/MathMenu.js  
\`\`\`  
\#\#\#\#\# (b) C\#

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
C  
o  
\`\`\`  
\`\`\`  
n  
tr  
o  
l  
F  
lo  
w  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
r  
u  
c  
t  
u  
re  
\`\`\`  
\`\`\`  
Program Structure  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Statement  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
Co  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
en  
\`\`\`  
\`\`\`  
t  
s  
an  
\`\`\`  
\`\`\`  
d  
D  
\`\`\`  
\`\`\`  
o  
c  
\`\`\`  
\`\`\`  
u  
m  
\`\`\`  
\`\`\`  
en  
\`\`\`  
\`\`\`  
t  
at  
\`\`\`  
\`\`\`  
i  
o  
n  
\`\`\`  
\`\`\`  
Sp  
\`\`\`  
\`\`\`  
ec  
\`\`\`  
\`\`\`  
i  
al  
Lan  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
u  
ag  
\`\`\`  
\`\`\`  
e St  
\`\`\`  
\`\`\`  
r  
u  
\`\`\`  
\`\`\`  
c  
tu  
\`\`\`  
\`\`\`  
re  
\`\`\`  
\`\`\`  
P  
re  
p  
ro  
c  
es  
s  
ing  
\`\`\`  
\`\`\`  
D  
ir  
e  
ct  
iv  
e  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
Arit  
\`\`\`  
\`\`\`  
hmetic  
\`\`\`  
\`\`\`  
Oper  
\`\`\`  
\`\`\`  
ation  
\`\`\`  
\`\`\`  
Lo  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
ic  
\`\`\`  
\`\`\`  
al  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
n  
Function Call  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
et  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Primitive Type  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
Generice  
Numeric  
\`\`\`  
\`\`\`  
String  
\`\`\`  
\`\`\`  
Boolean  
\`\`\`  
\`\`\`  
Special Value  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
\`\`\`  
\`\`\`  
Exc  
\`\`\`  
\`\`\`  
e  
p  
ti  
on  
\`\`\`  
\`\`\`  
H  
a  
n  
dl  
in  
g  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Namespace  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Access Modifiers  
\`\`\`  
\`\`\`  
Other Modifiers  
\`\`\`  
\`\`\`  
At  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
bu  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
/  
\`\`\`  
\`\`\`  
An  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Si  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
l  
e  
\`\`\`  
\-

\`\`\`  
l  
i  
n  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
ul  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\-

\`\`\`  
l  
i  
\`\`\`  
\`\`\`  
ne  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
mme  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
mb  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
i  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Coroutine  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
n  
d  
i  
ti  
o  
n  
a  
l  
\`\`\`  
\`\`\`  
C  
o  
m  
\`\`\`  
\`\`\`  
p  
i  
la  
t  
io  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Ma  
\`\`\`  
\`\`\`  
cro Definition  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
C++ Programming Language Concepts Hierarchy  
\`\`\`  
\`\`\`  
Loading \[MathJax\]/extensions/MathMenu.js  
\`\`\`  
\#\#\#\#\# (c) C++

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
uct  
\`\`\`  
\`\`\`  
ur  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
F  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
w  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Statement  
\`\`\`  
\`\`\`  
Sp  
\`\`\`  
\`\`\`  
ec  
\`\`\`  
\`\`\`  
ial  
\`\`\`  
\`\`\`  
Lan  
\`\`\`  
\`\`\`  
g  
u  
ag  
\`\`\`  
\`\`\`  
e St  
\`\`\`  
\`\`\`  
r  
u  
c  
t  
u  
r  
e  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
C  
omm  
ent  
s an  
d Do  
cum  
ent  
ation  
\`\`\`  
\`\`\`  
Pre  
processing  
Directive  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
rithm  
\`\`\`  
\`\`\`  
etic O  
\`\`\`  
\`\`\`  
perati  
\`\`\`  
\`\`\`  
on  
\`\`\`  
\`\`\`  
Function Call  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
it  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
et  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
CPrimitive Type  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
Generic  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
Numeric  
\`\`\`  
\`\`\`  
String  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
Type  
\`\`\`  
\`\`\`  
D  
ec  
lara  
tio  
n S  
tat  
em  
en  
t  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Delimiter  
\`\`\`  
\`\`\`  
Scope  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Namespace  
\`\`\`  
\`\`\`  
Import/Export  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
Other  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
mb  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
c  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
i  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
Annotation  
\`\`\`  
\`\`\`  
Do  
cu  
m  
en  
ta  
tio  
n C  
o  
mm  
e  
nt  
\`\`\`  
\`\`\`  
Co  
ndition  
al Com  
pilati  
on  
\`\`\`  
\`\`\`  
Haskell Programming Language Concepts Hierarchy  
\`\`\`  
\#\#\#\#\# (d) Haskell

\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
Special Language Structure  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
ra  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
tu  
\`\`\`  
\`\`\`  
re  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
F  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
w  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
Co  
m  
m  
en  
ts  
a  
nd  
D  
o  
cu  
m  
en  
ta  
tio  
n  
\`\`\`  
\`\`\`  
P  
repr  
ocess  
ing D  
irec  
tive  
\`\`\`  
\`\`\`  
Delimiter  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Element  
\`\`\`  
\`\`\`  
Tag  
\`\`\`  
\`\`\`  
Attribute  
\`\`\`  
\`\`\`  
Special Element  
\`\`\`  
\`\`\`  
Document Type  
\`\`\`  
\`\`\`  
Entity  
\`\`\`  
\`\`\`  
Raw Text  
\`\`\`  
\`\`\`  
C  
u  
s  
to  
m  
\`\`\`  
\`\`\`  
E  
l  
e  
m  
e  
n  
ts  
\`\`\`  
\`\`\`  
Event Handling  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
te  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
it  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
ls  
\`\`\`  
\`\`\`  
None  
\`\`\`  
\`\`\`  
None  
\`\`\`  
\`\`\`  
None  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
HTML TextNone  
\`\`\`  
\`\`\`  
None  
\`\`\`  
\`\`\`  
HTML Comment  
\`\`\`  
\`\`\`  
None  
\`\`\`  
\`\`\`  
HTML Programming Language Concepts Hierarchy  
\`\`\`  
\#\#\#\#\# (e) HTML

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
r  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
F  
l  
o  
\`\`\`  
\`\`\`  
w  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
r  
u  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
t  
u  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
r  
o  
g  
\`\`\`  
\`\`\`  
r  
a  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
r  
uct  
\`\`\`  
\`\`\`  
ur  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
Statement  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
t  
s  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
n  
d  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
c  
u  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
n  
\`\`\`  
\`\`\`  
t  
a  
t  
i  
o  
n  
\`\`\`  
\`\`\`  
Sp  
\`\`\`  
\`\`\`  
ec  
\`\`\`  
\`\`\`  
i  
al  
\`\`\`  
\`\`\`  
Lan  
\`\`\`  
\`\`\`  
g  
u  
ag  
\`\`\`  
\`\`\`  
e St  
\`\`\`  
\`\`\`  
r  
u  
\`\`\`  
\`\`\`  
c  
tu  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
Preprocessing Directive  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
Ar  
\`\`\`  
\`\`\`  
ithme  
\`\`\`  
\`\`\`  
tic Op  
\`\`\`  
\`\`\`  
eratio  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Lo  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
ic  
\`\`\`  
\`\`\`  
al  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
n  
Function Call  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
et  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
E Jump  
\`\`\`  
\`\`\`  
xc  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
t  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
H  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
l  
i  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Namespace  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
Primitive Type  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
om  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
os  
\`\`\`  
\`\`\`  
ite  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
yp  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Generic  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Assignment Statement  
\`\`\`  
\`\`\`  
Access Modifiers  
\`\`\`  
\`\`\`  
Other Modifiers  
\`\`\`  
\`\`\`  
At  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
bu  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
/  
\`\`\`  
\`\`\`  
An  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Si  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\-

\`\`\`  
l  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
ul  
\`\`\`  
\`\`\`  
t  
i  
\`\`\`  
\-

\`\`\`  
l  
i  
ne  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
mme  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
a  
\`\`\`  
\`\`\`  
t  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
mb  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Coroutine  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
n  
d  
\`\`\`  
\`\`\`  
it  
i  
o  
n  
a  
l  
\`\`\`  
\`\`\`  
C  
o  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
il  
a  
t  
io  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Ma  
\`\`\`  
\`\`\`  
cro Definition  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
JavaScript Programming Language Concepts Hierarchy  
\`\`\`  
\`\`\`  
Loading \[MathJax\]/extensions/MathMenu.js  
\`\`\`  
\#\#\#\#\# (f) JavaScript

\#\#\#\# Figure 10: Semantic-level annotations on different types of programming languages. “none” is used if this language

\#\#\#\# does not have corresponding subcategories.

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
o  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
F  
\`\`\`  
\`\`\`  
l  
o  
\`\`\`  
\`\`\`  
w  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
t  
u  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
Pro  
gra  
m St  
ruct  
ur  
e  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
Identifier and Sco  
\`\`\`  
\`\`\`  
pe  
\`\`\`  
\`\`\`  
Sp  
\`\`\`  
\`\`\`  
ec  
\`\`\`  
\`\`\`  
ial  
\`\`\`  
\`\`\`  
Lan  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
u  
ag  
\`\`\`  
\`\`\`  
e St  
\`\`\`  
\`\`\`  
r  
u  
c  
\`\`\`  
\`\`\`  
t  
u  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
em  
\`\`\`  
\`\`\`  
en  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Co  
mme  
\`\`\`  
\`\`\`  
n  
ts  
a  
nd  
D  
o  
c  
ume  
\`\`\`  
\`\`\`  
n  
ta  
ti  
on  
\`\`\`  
\`\`\`  
Preprocessing Directive  
\`\`\`  
\`\`\`  
Arithm  
\`\`\`  
\`\`\`  
etic  
\`\`\`  
\`\`\`  
Opera  
\`\`\`  
\`\`\`  
tion  
\`\`\`  
\`\`\`  
Lo  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
ic  
\`\`\`  
\`\`\`  
al  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
per  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
n  
Function Call  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
et  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
E Jump  
\`\`\`  
\`\`\`  
xc  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
H  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
l  
i  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Primitive Type  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
t  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Generic  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Namespace  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
Access Modifiers  
\`\`\`  
\`\`\`  
Other Modifiers  
\`\`\`  
\`\`\`  
At  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
bu  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
/  
\`\`\`  
\`\`\`  
An  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
Label  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
mb  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
i  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Coroutine  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
u  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
t  
\`\`\`  
\`\`\`  
e  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
t  
\`\`\`  
\`\`\`  
Si  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
l  
e  
\`\`\`  
\-  
    l  
       i  
          n  
             e

\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
M  
ul  
\`\`\`  
\`\`\`  
t  
i-  
l  
ine  
\`\`\`  
\`\`\`  
C  
o  
mme  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
C  
o  
nd  
iti  
on  
al  
C  
om  
p  
ila  
tio  
n  
\`\`\`  
\`\`\`  
Macro Definition  
\`\`\`  
\`\`\`  
Kotlin Programming Language Concepts Hierarchy  
\`\`\`  
\#\#\#\#\# (a) Kotlin

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
S  
p  
e  
c  
ia  
l  
L  
a  
n  
gu  
a  
g  
e  
\`\`\`  
\`\`\`  
S  
tr  
u  
c  
tu  
r  
e  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
on  
\`\`\`  
\`\`\`  
tro  
\`\`\`  
\`\`\`  
l F  
\`\`\`  
\`\`\`  
low  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
tru  
\`\`\`  
\`\`\`  
ctu  
\`\`\`  
\`\`\`  
re  
\`\`\`  
\`\`\`  
Statement  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
P  
r  
o  
\`\`\`  
\`\`\`  
g  
r  
a  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
S  
t  
r  
u  
\`\`\`  
\`\`\`  
c  
t  
u  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
a  
\`\`\`  
\`\`\`  
T  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
Com  
m  
ent  
s a  
nd  
Do  
cum  
en  
tat  
ion  
\`\`\`  
\`\`\`  
P  
reproce  
ssing D  
irective  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
rithm  
\`\`\`  
\`\`\`  
etic  
\`\`\`  
\`\`\`  
Op  
\`\`\`  
\`\`\`  
erati  
\`\`\`  
\`\`\`  
on  
\`\`\`  
\`\`\`  
Lo  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
ic  
\`\`\`  
\`\`\`  
al  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Function Call  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Numeric  
\`\`\`  
\`\`\`  
String  
Boolean  
\`\`\`  
\`\`\`  
L Special Value  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
F  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
t  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
b  
\`\`\`  
\`\`\`  
le  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
s  
t  
r  
u  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
t  
i  
o  
n  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
a  
t  
t  
e  
r  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
t  
c  
h  
i  
n  
g  
\`\`\`  
\`\`\`  
Coroutine  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
la  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Delimiter  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
i  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Annotation  
\`\`\`  
\`\`\`  
Si  
n  
g  
le  
\`\`\`  
\- l  
    in  
       e  
          C  
             o  
                m  
                   m

\`\`\`  
en  
t  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
Lua Programming Language Concepts Hierarchy  
\`\`\`  
\#\#\#\#\# (b) Lua

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
Co  
n  
t  
ro  
l  
F  
lo  
w  
\`\`\`  
\`\`\`  
St  
r  
u  
c  
tu  
r  
e  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
S  
p  
\`\`\`  
\`\`\`  
e  
c  
\`\`\`  
\`\`\`  
ia  
\`\`\`  
\`\`\`  
l  
L  
a  
\`\`\`  
\`\`\`  
n  
g  
\`\`\`  
\`\`\`  
u  
a  
\`\`\`  
\`\`\`  
g  
e  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
r  
u  
\`\`\`  
\`\`\`  
c  
t  
u  
r  
e  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Pr  
ep  
r  
oc  
e  
ss  
in  
g  
D  
i  
re  
ct  
iv  
e  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
Ar  
\`\`\`  
\`\`\`  
ithmet  
\`\`\`  
\`\`\`  
ic Ope  
\`\`\`  
\`\`\`  
ration  
\`\`\`  
\`\`\`  
Lo  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
ic  
\`\`\`  
\`\`\`  
al O  
\`\`\`  
\`\`\`  
per  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
n  
Function Call  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
对  
\`\`\`  
\`\`\`  
象  
\`\`\`  
\`\`\`  
访  
\`\`\`  
\`\`\`  
问  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
et  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Primitive Type  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Generic  
\`\`\`  
\`\`\`  
Numeric  
\`\`\`  
\`\`\`  
String  
\`\`\`  
\`\`\`  
Boolean  
\`\`\`  
\`\`\`  
Special Value  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
\`\`\`  
\`\`\`  
E  
xc  
e  
pt  
io  
n  
Ha  
n  
dl  
in  
g  
\`\`\`  
\`\`\`  
Access Modifiers  
\`\`\`  
\`\`\`  
Property  
\`\`\`  
\`\`\`  
Other Modifiers  
\`\`\`  
\`\`\`  
At  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
ri  
\`\`\`  
\`\`\`  
bu  
\`\`\`  
\`\`\`  
te  
\`\`\`  
\`\`\`  
/  
\`\`\`  
\`\`\`  
An  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
ti  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Namespace  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
Si  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\-

\`\`\`  
l  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
ul  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\-

\`\`\`  
l  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
ne  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
mme  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
mb  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Coroutine  
\`\`\`  
\`\`\`  
E  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
a  
\`\`\`  
\`\`\`  
t  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
u  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
t  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
t  
\`\`\`  
\`\`\`  
C  
o  
\`\`\`  
\`\`\`  
n  
d  
it  
i  
o  
n  
a  
l  
C  
o  
\`\`\`  
\`\`\`  
m  
p  
\`\`\`  
\`\`\`  
il  
a  
ti  
o  
n  
\`\`\`  
\`\`\`  
Ma  
\`\`\`  
\`\`\`  
cro Definition  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
Objective-C Programming Language Concepts Hierarchy  
\`\`\`  
\#\#\#\#\# (c) Objective-C

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
C  
o  
\`\`\`  
\`\`\`  
n  
t  
ro  
\`\`\`  
\`\`\`  
l  
F  
lo  
\`\`\`  
\`\`\`  
w  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
r  
u  
c  
t  
u  
r  
e  
\`\`\`  
\`\`\`  
Prog  
ram St  
ructure  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
Do  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
nP  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
o  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
e  
s  
\`\`\`  
\`\`\`  
s  
i  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
i  
r  
e  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
t  
i  
v  
e  
\`\`\`  
\`\`\`  
Sp  
\`\`\`  
\`\`\`  
ec  
\`\`\`  
\`\`\`  
i  
al  
Lan  
\`\`\`  
\`\`\`  
g  
u  
ag  
\`\`\`  
\`\`\`  
e St  
\`\`\`  
\`\`\`  
r  
u  
c  
t  
u  
r  
e  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
t  
e  
me  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
Arit  
\`\`\`  
\`\`\`  
hmetic  
\`\`\`  
\`\`\`  
Oper  
\`\`\`  
\`\`\`  
ation  
\`\`\`  
\`\`\`  
Lo  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
ic  
\`\`\`  
\`\`\`  
al  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
Function Calln  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
et  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Primitive Type  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Generic  
\`\`\`  
\`\`\`  
Numeric  
\`\`\`  
\`\`\`  
String  
\`\`\`  
\`\`\`  
Boolean  
\`\`\`  
\`\`\`  
Special Value  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
xc  
\`\`\`  
\`\`\`  
e  
p  
ti  
o  
n  
\`\`\`  
\`\`\`  
H  
a  
n  
d  
l  
in  
g  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Namespace  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
Access Modifiers  
\`\`\`  
\`\`\`  
Other Modifiers  
\`\`\`  
\`\`\`  
At  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
bu  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
/  
\`\`\`  
\`\`\`  
An  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Si  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\-

\`\`\`  
l  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
ul  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\-

\`\`\`  
l  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
ne  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
mme  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
i  
t  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
i  
l  
a  
\`\`\`  
\`\`\`  
t  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Ma  
\`\`\`  
\`\`\`  
cro Definition  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
mb  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
t  
e  
\`\`\`  
\`\`\`  
r  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
i  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Coroutine  
\`\`\`  
\`\`\`  
E  
x  
\`\`\`  
\`\`\`  
p  
r  
e  
s  
s  
i  
o  
n  
\`\`\`  
\`\`\`  
S  
t  
a  
t  
e  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
t  
\`\`\`  
\`\`\`  
C  
o  
m  
p  
o  
u  
n  
d  
St  
\`\`\`  
\`\`\`  
a  
t  
e  
m  
e  
n  
t  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
PHP Programming Language Concepts Hierarchy  
\`\`\`  
\`\`\`  
Loading \[MathJax\]/extensions/MathMenu.js  
\`\`\`  
\#\#\#\#\# (d) PHP

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
C  
o  
n  
tr  
o  
l  
Fl  
ow  
\`\`\`  
\`\`\`  
St  
r  
u  
ct  
u  
re  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Statement  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
n  
\`\`\`  
\`\`\`  
t  
s  
\`\`\`  
\`\`\`  
a  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
c  
u  
m  
\`\`\`  
\`\`\`  
e  
n  
\`\`\`  
\`\`\`  
t  
a  
t  
i  
o  
n  
\`\`\`  
\`\`\`  
Sp  
\`\`\`  
\`\`\`  
ec  
\`\`\`  
\`\`\`  
i  
al  
\`\`\`  
\`\`\`  
Lan  
\`\`\`  
\`\`\`  
g  
u  
ag  
\`\`\`  
\`\`\`  
e St  
\`\`\`  
\`\`\`  
r  
u  
c  
\`\`\`  
\`\`\`  
t  
u  
r  
e  
\`\`\`  
\`\`\`  
Program Structure  
\`\`\`  
\`\`\`  
Identifier and Sco  
\`\`\`  
\`\`\`  
pe  
\`\`\`  
\`\`\`  
Preproc  
essing Dire  
ctive  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
rithm  
\`\`\`  
\`\`\`  
etic O  
\`\`\`  
\`\`\`  
perati  
\`\`\`  
\`\`\`  
on  
\`\`\`  
\`\`\`  
Lo  
\`\`\`  
\`\`\`  
gi  
\`\`\`  
\`\`\`  
cal  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
n  
Function Call  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
et  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Primitive Type  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Generic  
\`\`\`  
\`\`\`  
Numeric  
\`\`\`  
\`\`\`  
String  
\`\`\`  
\`\`\`  
Boolean  
\`\`\`  
\`\`\`  
Special Value  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
\`\`\`  
\`\`\`  
Exc  
e  
pti  
on  
Ha  
nd  
lin  
g  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
pre  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Access Modifiers  
\`\`\`  
\`\`\`  
Other Modifiers  
\`\`\`  
\`\`\`  
At  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
bu  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
/  
\`\`\`  
\`\`\`  
An  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Si  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\-

\`\`\`  
l  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
ul  
\`\`\`  
\`\`\`  
t  
i  
\`\`\`  
\-

\`\`\`  
l  
i  
ne  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
mme  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
c  
u  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
mb  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
i  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Coroutine  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
None  
\`\`\`  
\`\`\`  
Python Programming Language Concepts Hierarchy  
\`\`\`  
\`\`\`  
Loading \[MathJax\]/extensions/MathMenu.js  
\`\`\`  
\#\#\#\#\# (e) Python

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
Statement  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
F  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
w  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Declaration and Definition  
Identifier and Scope  
\`\`\`  
\`\`\`  
C  
o  
m  
m  
e  
nt  
s  
an  
d  
D  
o  
cu  
m  
e  
nt  
a  
tio  
n  
\`\`\`  
\`\`\`  
P  
rep  
ro  
ce  
ss  
ing  
D  
ire  
ct  
ive  
\`\`\`  
\`\`\`  
Specia  
l Langu  
age Stru  
cture  
\`\`\`  
\`\`\`  
Ari  
\`\`\`  
\`\`\`  
thm  
\`\`\`  
\`\`\`  
etic  
\`\`\`  
\`\`\`  
Ope  
\`\`\`  
\`\`\`  
ratio  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Function Call  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
q  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Primitive Type  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Boolean  
\`\`\`  
\`\`\`  
Special Value  
\`\`\`  
\`\`\`  
E  
x  
\`\`\`  
\`\`\`  
pre  
\`\`\`  
\`\`\`  
s  
s  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
e  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
u  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
t  
e  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
t  
\`\`\`  
\`\`\`  
O  
t  
h  
e  
r  
St  
\`\`\`  
\`\`\`  
a  
t  
e  
m  
\`\`\`  
\`\`\`  
e  
n  
t  
\`\`\`  
\`\`\`  
Access Modifiers  
\`\`\`  
\`\`\`  
Other Modifiers  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
tt  
\`\`\`  
\`\`\`  
rib  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
es  
\`\`\`  
\`\`\`  
/  
\`\`\`  
\`\`\`  
An  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
ta  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
\`\`\`  
\`\`\`  
Program EntryNamespace  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Delimiter  
\`\`\`  
\`\`\`  
Si  
\`\`\`  
\`\`\`  
n  
g  
\`\`\`  
\`\`\`  
le  
\`\`\`  
\-  
    li  
       n  
          e

\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
n  
t  
\`\`\`  
\`\`\`  
None  
\`\`\`  
\`\`\`  
L  
amb  
da E  
xpr  
essi  
on  
\`\`\`  
\`\`\`  
R Programming Language Concepts Hierarchy  
\`\`\`  
\#\#\#\#\# (f) R

\#\#\#\# Figure 11: Semantic-level annotations on different types of programming languages. “none” is used if this language

\#\#\#\# does not have corresponding subcategories.

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
C  
o  
n  
t  
ro  
l  
F  
l  
o  
w  
St  
\`\`\`  
\`\`\`  
r  
uc  
t  
u  
re  
\`\`\`  
\`\`\`  
Progr  
\`\`\`  
\`\`\`  
am Str  
\`\`\`  
\`\`\`  
ucture  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
Do  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Sp  
\`\`\`  
\`\`\`  
ec  
\`\`\`  
\`\`\`  
i  
al  
\`\`\`  
\`\`\`  
Lan  
\`\`\`  
\`\`\`  
g  
u  
\`\`\`  
\`\`\`  
ag  
\`\`\`  
\`\`\`  
e St  
\`\`\`  
\`\`\`  
r  
u  
c  
\`\`\`  
\`\`\`  
tu  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
e  
\`\`\`  
\`\`\`  
me  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
P  
r  
e  
pr  
o  
ce  
s  
si  
ng  
\`\`\`  
\`\`\`  
Di  
r  
ec  
t  
iv  
e  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
Arithm  
\`\`\`  
\`\`\`  
etic O  
\`\`\`  
\`\`\`  
perat  
\`\`\`  
\`\`\`  
ion  
\`\`\`  
\`\`\`  
Lo  
\`\`\`  
\`\`\`  
gi  
\`\`\`  
\`\`\`  
cal  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
per  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
n  
Function Call  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Access  
\`\`\`  
\`\`\`  
Parameter  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
et  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Primitive Type  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
Generic  
\`\`\`  
\`\`\`  
Numeric  
\`\`\`  
\`\`\`  
String  
\`\`\`  
\`\`\`  
Boolean  
\`\`\`  
\`\`\`  
Special Value  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
\`\`\`  
\`\`\`  
E  
xc  
e  
pt  
io  
n  
H  
an  
d  
lin  
g  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Namespace  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
Access Modifiers  
\`\`\`  
\`\`\`  
Other Modifiers  
\`\`\`  
\`\`\`  
At  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
bu  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
/  
\`\`\`  
\`\`\`  
An  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Si  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\-

\`\`\`  
l  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
ul  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\-

\`\`\`  
l  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
ne  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
mme  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
a  
\`\`\`  
\`\`\`  
t  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
mb  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Coroutine  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
a  
\`\`\`  
\`\`\`  
t  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
m  
\`\`\`  
\`\`\`  
p  
o  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
n  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
t  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
t  
\`\`\`  
\`\`\`  
C  
o  
\`\`\`  
\`\`\`  
n  
d  
i  
ti  
o  
n  
a  
l  
\`\`\`  
\`\`\`  
C  
o  
m  
\`\`\`  
\`\`\`  
p  
i  
la  
\`\`\`  
\`\`\`  
ti  
o  
n  
\`\`\`  
\`\`\`  
Ma  
\`\`\`  
\`\`\`  
cro Definition  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
Ruby Programming Language Concepts Hierarchy  
\`\`\`  
\#\#\#\#\# (a) Ruby

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
n  
\`\`\`  
\`\`\`  
tr  
o  
\`\`\`  
\`\`\`  
l  
F  
l  
o  
w  
\`\`\`  
\`\`\`  
S  
t  
r  
u  
c  
t  
u  
\`\`\`  
\`\`\`  
r  
e  
P  
rogram  
Stru  
cture  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
c  
i  
a  
l  
\`\`\`  
\`\`\`  
L  
a  
\`\`\`  
\`\`\`  
n  
g  
\`\`\`  
\`\`\`  
u  
a  
\`\`\`  
\`\`\`  
g  
e  
\`\`\`  
\`\`\`  
S  
t  
r  
u  
\`\`\`  
\`\`\`  
c  
t  
u  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
m  
\`\`\`  
\`\`\`  
e  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Co  
mm  
e  
nts  
a  
nd  
Do  
cu  
m  
ent  
at  
ion  
\`\`\`  
\`\`\`  
Pre  
processing  
Directive  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
rithm  
\`\`\`  
\`\`\`  
etic O  
\`\`\`  
\`\`\`  
pera  
\`\`\`  
\`\`\`  
tion  
\`\`\`  
\`\`\`  
Function Call  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
I  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Reference Expression  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Primitive Type  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Generic  
\`\`\`  
\`\`\`  
String  
\`\`\`  
\`\`\`  
Special Value  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
\`\`\`  
\`\`\`  
E  
xc  
\`\`\`  
\`\`\`  
e  
p  
t  
i  
o  
n  
\`\`\`  
\`\`\`  
H  
a  
n  
\`\`\`  
\`\`\`  
d  
li  
n  
g  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Namespace  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
Access Modifiers  
\`\`\`  
\`\`\`  
Other Modifiers  
\`\`\`  
\`\`\`  
Annotation  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
Delimiter  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
mb  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Coroutine  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
p  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
a  
\`\`\`  
\`\`\`  
t  
e  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
u  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
t  
e  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
t  
\`\`\`  
\`\`\`  
Si  
\`\`\`  
\`\`\`  
n  
g  
l  
e  
\`\`\`  
\-  
    li  
       n  
          e  
             C

\`\`\`  
o  
m  
m  
\`\`\`  
\`\`\`  
e  
n  
t  
\`\`\`  
\`\`\`  
M  
ul  
t  
i-l  
ine  
\`\`\`  
\`\`\`  
C  
omme  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
Ma  
cro Definition  
\`\`\`  
\`\`\`  
Rust Programming Language Concepts Hierarchy  
\`\`\`  
\#\#\#\#\# (b) Rust

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
C  
o  
n  
tr  
o  
l Fl  
o  
w  
\`\`\`  
\`\`\`  
St  
r  
u  
ct  
u  
re  
\`\`\`  
\`\`\`  
Pr  
\`\`\`  
\`\`\`  
ogr  
\`\`\`  
\`\`\`  
am  
\`\`\`  
\`\`\`  
Str  
\`\`\`  
\`\`\`  
uct  
\`\`\`  
\`\`\`  
ure  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Statement  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
Sp  
\`\`\`  
\`\`\`  
ec  
\`\`\`  
\`\`\`  
ial  
\`\`\`  
\`\`\`  
Lan  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
u  
ag  
\`\`\`  
\`\`\`  
e St  
\`\`\`  
\`\`\`  
r  
u  
c  
t  
u  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
Co  
m  
\`\`\`  
\`\`\`  
m  
e  
n  
ts  
a  
n  
d  
D  
o  
c  
u  
m  
e  
n  
ta  
t  
io  
n  
\`\`\`  
\`\`\`  
Identifier and Sco  
\`\`\`  
\`\`\`  
pe  
\`\`\`  
\`\`\`  
Preproces  
sing Direct  
ive  
\`\`\`  
\`\`\`  
Arithm  
\`\`\`  
\`\`\`  
etic O  
\`\`\`  
\`\`\`  
pera  
\`\`\`  
\`\`\`  
tion  
\`\`\`  
\`\`\`  
Lo  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
ic  
\`\`\`  
\`\`\`  
al  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
Function Callon  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
et  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Primitive Type  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Generic  
\`\`\`  
\`\`\`  
Numeric  
\`\`\`  
\`\`\`  
String  
\`\`\`  
\`\`\`  
Boolean  
\`\`\`  
\`\`\`  
Special Value  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
\`\`\`  
\`\`\`  
Exc  
e  
ptio  
n  
Ha  
nd  
ling  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Namespace  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
Access Modifiers  
\`\`\`  
\`\`\`  
Other Modifiers  
\`\`\`  
\`\`\`  
At  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
bu  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
/  
\`\`\`  
\`\`\`  
An  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
mb  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
t  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
i  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Coroutine  
\`\`\`  
\`\`\`  
Si  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
le  
\`\`\`  
\-  
    l  
       i  
          n

\`\`\`  
e  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
ul  
\`\`\`  
\`\`\`  
t  
i  
\`\`\`  
\-  
    l  
       ine

\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
mme  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
C  
onditio  
nal Co  
mpilat  
ion  
\`\`\`  
\`\`\`  
TypeScript Programming Language Concepts Hierarchy  
\`\`\`  
\`\`\`  
Loading \[MathJax\]/extensions/MathMenu.js  
\`\`\`  
\#\#\#\#\# (c) TypeScript

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
C  
on  
t  
r  
o  
l  
Fl  
o  
w  
St  
\`\`\`  
\`\`\`  
r  
u  
ct  
u  
r  
e  
\`\`\`  
\`\`\`  
Progra  
\`\`\`  
\`\`\`  
m Stru  
\`\`\`  
\`\`\`  
cture  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Statement  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
Sp  
\`\`\`  
\`\`\`  
ec  
\`\`\`  
\`\`\`  
ial  
\`\`\`  
\`\`\`  
Lan  
\`\`\`  
\`\`\`  
g  
u  
\`\`\`  
\`\`\`  
ag  
\`\`\`  
\`\`\`  
e St  
\`\`\`  
\`\`\`  
r  
u  
c  
\`\`\`  
\`\`\`  
t  
u  
r  
e  
\`\`\`  
\`\`\`  
C  
o  
m  
m  
\`\`\`  
\`\`\`  
e  
n  
ts  
\`\`\`  
\`\`\`  
a  
n  
d  
D  
o  
c  
u  
m  
\`\`\`  
\`\`\`  
e  
n  
ta  
t  
io  
n  
\`\`\`  
\`\`\`  
Pr  
e  
pr  
o  
ce  
s  
si  
n  
g  
Di  
r  
ec  
t  
iv  
e  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
rithm  
\`\`\`  
\`\`\`  
etic O  
\`\`\`  
\`\`\`  
peratio  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Lo  
\`\`\`  
\`\`\`  
gi  
\`\`\`  
\`\`\`  
cal  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
per  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
n  
Function Call  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
Other  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
et  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Primitive Type  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
Generic  
\`\`\`  
\`\`\`  
Numeric  
\`\`\`  
\`\`\`  
String  
\`\`\`  
\`\`\`  
Boolean  
\`\`\`  
\`\`\`  
Special Value  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
\`\`\`  
\`\`\`  
E  
xc  
e  
p  
tio  
n  
H  
an  
d  
lin  
g  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Namespace  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
Access ModifiersOther Modifiers  
\`\`\`  
\`\`\`  
At  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
bu  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
/  
\`\`\`  
\`\`\`  
An  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
mb  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Coroutine  
\`\`\`  
\`\`\`  
Si  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
l  
e  
\`\`\`  
\-  
    l  
       i  
          n

\`\`\`  
e  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
ul  
\`\`\`  
\`\`\`  
t  
i  
\`\`\`  
\-  
    l  
       i  
       ne

\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
mme  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
n  
d  
i  
ti  
o  
n  
a  
\`\`\`  
\`\`\`  
l  
C  
o  
m  
\`\`\`  
\`\`\`  
p  
i  
la  
\`\`\`  
\`\`\`  
ti  
o  
n  
\`\`\`  
\`\`\`  
Ma  
\`\`\`  
\`\`\`  
cro Definition  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
Java Programming Language Concepts Hierarchy  
\`\`\`  
\#\#\#\#\# Loading \[MathJax\]/extensions/MathMenu.js (d) Java

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
o  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
F  
\`\`\`  
\`\`\`  
l  
o  
\`\`\`  
\`\`\`  
w  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
r  
u  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
t  
u  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
r  
o  
g  
\`\`\`  
\`\`\`  
r  
a  
m  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
r  
uct  
\`\`\`  
\`\`\`  
ur  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
r  
e  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
o  
c  
\`\`\`  
\`\`\`  
e  
s  
\`\`\`  
\`\`\`  
s  
i  
ng  
\`\`\`  
\`\`\`  
D  
\`\`\`  
\`\`\`  
i  
r  
e  
\`\`\`  
\`\`\`  
c  
t  
i  
v  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
Sp  
\`\`\`  
\`\`\`  
ec  
ial  
L  
an  
gu  
a  
ge  
St  
r  
uc  
tu  
re  
\`\`\`  
\`\`\`  
Com  
ments and  
Documen  
tation  
\`\`\`  
\`\`\`  
Arith  
\`\`\`  
\`\`\`  
met  
\`\`\`  
\`\`\`  
ic Op  
\`\`\`  
\`\`\`  
erati  
\`\`\`  
\`\`\`  
on  
\`\`\`  
\`\`\`  
Lo  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
ic  
\`\`\`  
\`\`\`  
al  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
io  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Function Call  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
h  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
et  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
er  
\`\`\`  
\`\`\`  
at  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
E  
\`\`\`  
\`\`\`  
xc  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
H  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
l  
i  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Namespace  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
\`\`\`  
\`\`\`  
Variable  
\`\`\`  
\`\`\`  
Primitive Type  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Generic  
\`\`\`  
\`\`\`  
Access Modifiers  
\`\`\`  
\`\`\`  
Other Modifiers  
\`\`\`  
\`\`\`  
At  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
bu  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
/  
\`\`\`  
\`\`\`  
An  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
e  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
i  
t  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
i  
l  
a  
\`\`\`  
\`\`\`  
t  
i  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
Ma  
\`\`\`  
\`\`\`  
cro Definition  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
L  
a  
mb  
\`\`\`  
\`\`\`  
d  
a  
\`\`\`  
\`\`\`  
E  
x  
\`\`\`  
\`\`\`  
p  
r  
e  
s  
s  
i  
o  
n  
\`\`\`  
\`\`\`  
Coroutine  
\`\`\`  
\`\`\`  
Sin  
gle-  
line C  
omm  
ent  
\`\`\`  
\`\`\`  
Go Programming Language Concepts Hierarchy  
\`\`\`  
\#\#\#\#\# (e) Go

\`\`\`  
Expression  
\`\`\`  
\`\`\`  
Data Type  
\`\`\`  
\`\`\`  
C  
o  
n  
t  
ro  
l  
F  
lo  
w  
\`\`\`  
\`\`\`  
St  
r  
uc  
t  
u  
re  
\`\`\`  
\`\`\`  
Identifier and Scope  
\`\`\`  
\`\`\`  
P  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
St  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
uct  
\`\`\`  
\`\`\`  
ur  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
Declaration and Definition  
\`\`\`  
\`\`\`  
Modifier and Attribute  
\`\`\`  
\`\`\`  
C  
o  
mme  
\`\`\`  
\`\`\`  
n  
t  
s  
a  
n  
d  
\`\`\`  
\`\`\`  
D  
o  
c  
u  
me  
\`\`\`  
\`\`\`  
n  
t  
a  
t  
io  
n  
\`\`\`  
\`\`\`  
S  
p  
ec  
ia  
l  
La  
n  
g  
ua  
g  
e  
S  
tr  
u  
ct  
u  
re  
\`\`\`  
\`\`\`  
S  
ta  
te  
m  
en  
t  
\`\`\`  
\`\`\`  
Preproc  
essing Dire  
ctive  
\`\`\`  
\`\`\`  
Arith  
\`\`\`  
\`\`\`  
metic  
\`\`\`  
\`\`\`  
Oper  
\`\`\`  
\`\`\`  
ation  
\`\`\`  
\`\`\`  
Function Call  
\`\`\`  
\`\`\`  
Object Creation  
\`\`\`  
\`\`\`  
Type Casting  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
u  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
S  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
c  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
l  
\`\`\`  
\`\`\`  
O  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
r  
\`\`\`  
\`\`\`  
CPrimitive Type  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
s  
\`\`\`  
\`\`\`  
i  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
T  
\`\`\`  
\`\`\`  
y  
\`\`\`  
\`\`\`  
p  
\`\`\`  
\`\`\`  
e  
Generic  
\`\`\`  
\`\`\`  
Numeric  
\`\`\`  
\`\`\`  
String  
\`\`\`  
\`\`\`  
Boolean  
\`\`\`  
\`\`\`  
Special Value  
\`\`\`  
\`\`\`  
Conditional  
\`\`\`  
\`\`\`  
Loop  
\`\`\`  
\`\`\`  
Jump  
\`\`\`  
\`\`\`  
E  
xce  
pt  
ion  
H  
an  
dli  
ng  
\`\`\`  
\`\`\`  
Identifier  
\`\`\`  
\`\`\`  
Qualified Name  
\`\`\`  
\`\`\`  
Binding  
\`\`\`  
\`\`\`  
Delimiter  
\`\`\`  
\`\`\`  
Program Entry  
\`\`\`  
\`\`\`  
Namespace  
\`\`\`  
\`\`\`  
Import/Include  
\`\`\`  
\`\`\`  
Class  
\`\`\`  
\`\`\`  
Function  
Variable  
\`\`\`  
\`\`\`  
Access ModifiersOther Modifiers  
\`\`\`  
\`\`\`  
Annotation  
\`\`\`  
\`\`\`  
Si  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
l  
e  
\`\`\`  
\-  
    l  
    i  
       n

\`\`\`  
e  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
m  
\`\`\`  
\`\`\`  
e  
\`\`\`  
\`\`\`  
n  
\`\`\`  
\`\`\`  
t  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
ul  
\`\`\`  
\`\`\`  
t  
i  
\`\`\`  
\-

\`\`\`  
l  
ine  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
o  
\`\`\`  
\`\`\`  
mme  
\`\`\`  
\`\`\`  
nt  
\`\`\`  
\`\`\`  
L  
\`\`\`  
\`\`\`  
a  
mb  
\`\`\`  
\`\`\`  
d  
\`\`\`  
\`\`\`  
a  
\`\`\`  
\`\`\`  
E  
\`\`\`  
\`\`\`  
x  
p  
\`\`\`  
\`\`\`  
r  
e  
s  
\`\`\`  
\`\`\`  
s  
i  
o  
n  
\`\`\`  
\`\`\`  
P  
a  
t  
t  
e  
r  
n  
\`\`\`  
\`\`\`  
M  
\`\`\`  
\`\`\`  
a  
t  
c  
h  
\`\`\`  
\`\`\`  
in  
\`\`\`  
\`\`\`  
g  
\`\`\`  
\`\`\`  
C  
o  
m  
po  
un  
d  
St  
a  
te  
m  
en  
t  
\`\`\`  
\`\`\`  
Ma  
cro Definition  
\`\`\`  
\`\`\`  
Scala Programming Language Concepts Hierarchy  
\`\`\`  
\#\#\#\#\# (f) Scala

\#\#\#\# Figure 12: Semantic-level annotations on different types of programming languages. “none” is used if this language

\#\#\#\# does not have corresponding subcategories.

\`\`\`  
import { Tile } from '../Tile';  
\`\`\`  
\`\`\`  
import { map, pacman, ENEMY\_SPAWN\_TIME } from '../app'  
\`\`\`  
\`\`\`  
import { GameMode } from '../game-interfaces/modes.interface';  
\`\`\`  
\`\`\`  
import { scene } from '../app'  
\`\`\`  
\`\`\`  
import { Utils } from '../Utils/utils';  
\`\`\`  
\`\`\`  
export class RedGhost extends Enemy {  
\`\`\`  
\`\`\`  
private scatterPosition  
\`\`\`  
\`\`\`  
constructor( ){  
\`\`\`  
\`\`\`  
let position \= { x: 475 , y: 375 }  
\`\`\`  
\`\`\`  
let ghost \= scene.physics.add.sprite( position.x,  
\`\`\`  
\`\`\`  
,"ghostRedAnim" )  
\`\`\`  
\`\`\`  
ghost.type \= "Red"  
\`\`\`  
\`\`\`  
ghost.timeToSetFree \= ENEMY\_SPAWN\_TIME  
\`\`\`  
\`\`\`  
scene.enemyGroup.add(ghost);  
\`\`\`  
\`\`\`  
super( position, ghost )  
\`\`\`  
\`\`\`  
this.initialPosition \= position  
\`\`\`  
\`\`\`  
this.scatterPosition \= {x: 2 ,y: 2 }  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
private findDestinyTile(): Tile{  
\`\`\`  
\`\`\`  
switch( this.mode ){  
\`\`\`  
\`\`\`  
case GameMode.CHASE:  
\`\`\`  
\`\`\`  
return map.getTile( pacman.getCurrentPosition() )  
\`\`\`  
\`\`\`  
case GameMode.FRIGHTENED:  
\`\`\`  
\`\`\`  
return this.frightenedTile  
\`\`\`  
\`\`\`  
case GameMode.SCATTER:  
\`\`\`  
\`\`\`  
return map.getTile( this.scatterPosition, 'index' )  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\#\#\#\#\#\# Completion Cursor Position

// Path: /src/ts/Enemy/Enemy.ts

protected setPosition({ x, y }: Position): void {

this.position \= { x, y };

}

public getCurrentTile(): Tile {

return map.getTile(this.position);

}

protected setDestinyTile(tile: Tile): void {

this.destinyTile \= tile;

}

getDestinyTile(): Tile {

// Path: /src/ts/Enemy/Enemy.ts

tweenMovement(image, () \=\> {

image.destroy();

this.ghost.x \= CENTER\_MAP\_POSITION.x;

this.ghost.y \= CENTER\_MAP\_POSITION.y;

enemySprite.body.moves \= \_true\_ ;

enemySprite.visible \= \_true\_ ;

this.ghost.anims.play(\`ghost${this.ghostType}East\`);

});

setTimeout(() \=\> {

enemySprite.enableBody();

// Path: /src/ts/Enemy/Enemy.ts

}

public setEnemyFree(): void {

this.isFree \= \_true\_ ;

this.setGameMode( GameMode.CHASE)

}

protected setPosition({ x, y }: Position): void {

this.position \= { x, y };

}

public getCurrentTile(): Tile {

return map.getTile(this.position);

position.y

\*\*Cross file Context 1\*\*

\*\*Cross file Context 2\*\*

\*\*Cross file Context 3\*\*

// Path: /src/ts/Enemy/Enemy.ts

Compare with this code snippet:

this.ghost.y \+= this.SPEED;

break;

case "NORTH":

animationName \= "North";

this.ghost.y \-= this.SPEED;

break;

case "WEST":

animationName \= "West";

this.ghost.x \-= this.SPEED;

\*\*Cross file Context 4 Ground Truth\*\*

position.y

\*\*Model Output\*\*

\#\#\#\#\# In-file Context

\#\#\#\# Figure 13: Visualization on success case for TypeScript. (Semantic label:Modifier and Attribute)

\`\`\`  
\#include \<pthread.h\>  
\`\`\`  
\`\`\`  
\#include \<stdint.h\>  
\`\`\`  
\`\`\`  
typedef struct{  
\`\`\`  
\`\`\`  
int \*l, n;  
\`\`\`  
\`\`\`  
char \*\*a;  
\`\`\`  
\`\`\`  
}enzyme;  
\`\`\`  
\`\`\`  
typedef struct {  
\`\`\`  
\`\`\`  
int flag;  
\`\`\`  
\`\`\`  
int num\_reads;  
\`\`\`  
\`\`\`  
......  
\`\`\`  
\`\`\`  
uint32\_t ul\_min\_base;  
\`\`\`  
\`\`\`  
} hifiasm\_opt\_t;  
\`\`\`  
\`\`\`  
extern hifiasm\_opt\_t asm\_opt;  
\`\`\`  
\`\`\`  
void init\_opt(hifiasm\_opt\_t\* asm\_opt);  
\`\`\`  
\`\`\`  
void destory\_opt(hifiasm\_opt\_t\* asm\_opt);  
\`\`\`  
\`\`\`  
void ha\_opt\_reset\_to\_round(hifiasm\_opt\_t\* asm\_opt, int round);  
\`\`\`  
\`\`\`  
void ha\_opt\_update\_cov(hifiasm\_opt\_t \*opt, int hom\_cov);  
\`\`\`  
\`\`\`  
void ha\_opt\_update\_cov\_min(hifiasm\_opt\_t \*opt, int hom\_cov, int min\_chain);  
\`\`\`  
\`\`\`  
int CommandLine\_process(int argc, char \*argv\[\], hifiasm\_opt\_t\* asm\_opt);  
\`\`\`  
\`\`\`  
double Get\_T(void);  
\`\`\`  
\`\`\`  
static inline int ha\_opt\_triobin(const hifiasm\_opt\_t \*opt)  
\`\`\`  
\`\`\`  
static inline int ha\_opt\_hic(const hifiasm\_opt\_t \*opt)  
\`\`\`  
\`\`\`  
{  
\`\`\`  
\`\`\`  
return ((opt-\>hic\_reads\[ 0 \] && opt-\>hic\_reads\[ 1 \]));  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\#\#\#\#\#\# Completion Cursor Position

\_// Path: /ketopt.h\_

static void ketopt\_permute(char \*argv\[\], int j, int n)

{

int k;

char \*p \= argv\[j\];

for (k \= \_0\_ ; k \< n; \++k)

argv\[j \- k\] \= argv\[j \- k \- \_1\_ \];

argv\[j \- k\] \= p;

}

\_// Path: /Levenshtein\_distance.h\_

(\*return\_err) \= line\_error;

}

return (\*return\_t\_end);

}

inline void reverse\_string(char\* str, int strLen)

{

int i, Len;

char k;

Len \= strLen / \_2\_ ;

for (i \= \_0\_ ; i \< Len; i++)

\_// Path: /Correct.h\_

inline int calculate\_score(int new\_occ\_0, int new\_occ\_1)

{

if(new\_occ\_0 \+ new\_occ\_1 \== \_0\_ )

{

return \- \_1\_ ;

}

if(filter\_snp(new\_occ\_0, new\_occ\_1, new\_occ\_0 \+ new\_occ\_1) \== \_0\_ )

{

return \- \_1\_ ;

}

\`\`\`  
{return ((opt-\>fn\_bin\_yak\[ 0 \] && opt-\>fn\_bin\_yak\[ 1 \])   
\`\`\`  
\`\`\`  
|| (opt-\>fn\_bin\_list\[ 0 \] && opt-\>fn\_bin\_list\[ 1 \]));}  
\`\`\`  
\*\*Cross file Context 1\*\*

\*\*Cross file Context 2\*\*

\*\*Cross file Context 3\*\*

\_// Path: /Correct.h\_

double threshold \= \_0.30\_ ;

available \= available/((double)(total));

if(available \<= threshold && available \< \_6\_ )

{

return \_0\_ ;

}

return \_1\_ ;

}

inline int filter\_one\_snp(int occ\_0, int occ\_1, int total)

{

\*\*Cross file Context 4 Ground Truth\*\*

\`\`\`  
{return (opt-\>fn\_bin\_poy && opt-\>fn\_bin\_yak\[ 0 \] && opt-\>fn\_bin\_yak\[ 1 \]);}  
\`\`\`  
\*\*Model Output\*\*

\#\#\#\#\# In-file Context

\#\#\#\# Figure 14: Visualization on failure case for the C language. (Semantic label:Statement)

\`\`\`  
import sys  
\`\`\`  
\`\`\`  
import numpy as np  
\`\`\`  
\`\`\`  
'''  
\`\`\`  
\`\`\`  
this script generates a large matrix to compare its  
\`\`\`  
\`\`\`  
memory size with that estimated from mprof module  
\`\`\`  
\`\`\`  
'''  
\`\`\`  
\`\`\`  
\# define matrix dimension  
\`\`\`  
\`\`\`  
n1 \= 10000  
\`\`\`  
\`\`\`  
n2 \= 25000  
\`\`\`  
\`\`\`  
\# get the random matrix  
\`\`\`  
\`\`\`  
data \= np.random.rand(n1,n2)  
\`\`\`  
\`\`\`  
es \= n1\*n2\* 8 / 1024 \*\* 3  
\`\`\`  
\`\`\`  
ss \= sys.getsizeof(data)/ 1024 \*\* 3  
\`\`\`  
\`\`\`  
\# delay the time for accurate memory monitoring  
\`\`\`  
\`\`\`  
tdata0 \= np.zeros(shape=data.shape,dtype=data.dtype)  
\`\`\`  
\`\`\`  
for ii in range(data.shape\[ 0 \]):  
\`\`\`  
\`\`\`  
for jj in range(data.shape\[ 1 \]):  
\`\`\`  
\`\`\`  
tdata0\[ii,jj\] \= data\[ii,jj\]+0.1\*data\[ii,jj\]  
\`\`\`  
\`\`\`  
print('memory estimates are %5.3f %5.3f'%(es,ss))  
\`\`\`  
\`\`\`  
\# allocate a porportion of the data matrix  
\`\`\`  
\`\`\`  
data \= np.random.rand(n1,n2)  
\`\`\`  
\`\`\`  
tdata1 \= np.zeros(shape=data.shape,dtype=data.dtype)  
\`\`\`  
\`\`\`  
ss \= sys.getsizeof(tdata1)/ 1024 \*\* 3  
\`\`\`  
\`\`\`  
print('new memory estimates are %5.3f %5.3f'%(es,ss))  
\`\`\`  
Completion Cursor Position

\_\# Path: /src/plotting\_modules.py\_

\_\# Compare with this code snippet:\_

plt.tight\_layout()

plt.show()

elif ncomp \== 3 :

tr \= ds.waveforms\[tsta\]\[tcomp\[ 0 \]\]

dt \= tr\[ 0 \].stats.delta

npts \= tr\[ 0 \].stats.npts

tt \= np.arange( 0 ,npts)\*dt

data \= np.zeros(shape=(ncomp,npts),dtype=np.float32)

for ii in range(ncomp):

data\[ii\] \= ds.waveforms\[tsta\]\[tcomp\[ii\]\]\[ 0 \].data

\_\# Path: /test/performace\_check/check\_detrend\_performance.py\_

\_\# Compare with this code snippet:\_

dataS \= taper(dataS)

t1=time.time()

print('inside new takes %6.2f'%(t1-t0))

source\_params \= np.vstack(\[trace\_madS,trace\_stdS\]).T

return source\_params,dataS\_t,dataS

def detrend(data):

\_'''\_

\_remove the trend of the signal based on QR decomposion\_

\_'''\_

\_\#ndata \= np.zeros(shape=data.shape,dtype=data.dtype)\_

\_\# Path: /test/performace\_check/check\_detrend\_demean\_taper.py\_

\_\# Compare with this code snippet:\_

apply a cosine taper using obspy functions

'''

\#ndata \= np.zeros(shape=data.shape,dtype=data.dtype)

if data.ndim \== 1:

npts \= data.shape\[0\]

\# window length

if npts\*0.05\>20:wlen \= 20

else:wlen \= npts\*0.05

\# taper values

func \= \_get\_function\_from\_entry\_point('taper', 'hann')

\`\`\`  
for ii in range( 0 ,int(0.5\*n1)):  
\`\`\`  
\`\`\`  
for jj in range( 0 ,int(0.5\*n2)):  
\`\`\`  
\`\`\`  
tdata1\[ii,jj\] \= data\[ii,jj\]+0.1\*data\[ii,jj\]  
\`\`\`  
\*\*Cross file Context 1\*\*

\*\*Cross file Context 2\*\*

\*\*Cross file Context 3\*\*

\_\# Path: /test/performace\_check/check\_detrend\_performance.py\_

\_\# Compare with this code snippet:\_

def detrend(data):

\_'''\_

\_remove the trend of the signal based on QR decomposion\_

\_'''\_

\_\#ndata \= np.zeros(shape=data.shape,dtype=data.dtype)\_

if data.ndim \== 1 :

X \= np.ones((data.shape\[ 0 \], 2 ))

X\[:, 0 \] \= np.arange( 0 ,data.shape\[ 0 \])/data.shape\[ 0 \]

Q,R \= np.linalg.qr(X)

rq \= np.dot(np.linalg.inv(R),Q.transpose())

\*\*Cross file Context 4\*\*

\*\*Ground Truth\*\*

\`\`\`  
for ii in range(data.shape\[0\]):  
\`\`\`  
\`\`\`  
for jj in range(data.shape\[1\]):  
\`\`\`  
\`\`\`  
tdata1\[ii,jj\] \= data\[ii,jj\]+0.1\*data\[ii,jj\]  
\`\`\`  
\*\*Model Output\*\*

\#\#\#\#\# In-file Context

\#\#\#\# Figure 15: Visualization on failure case for Python. (Semantic label:Expression)

\`\`\`  
package weekly  
\`\`\`  
\`\`\`  
import (  
\`\`\`  
\`\`\`  
"context"  
\`\`\`  
\`\`\`  
"fmt"  
\`\`\`  
\`\`\`  
"os/exec"  
\`\`\`  
\`\`\`  
"strings"  
\`\`\`  
\`\`\`  
"time"  
\`\`\`  
\`\`\`  
"github.com/dyweb/dy-bot/pkg/gh"  
\`\`\`  
\`\`\`  
"github.com/google/go-github/github"  
\`\`\`  
\`\`\`  
)  
\`\`\`  
\`\`\`  
func (w Worker) sumbitPR(branch string, issueNumber int) error {  
\`\`\`  
\`\`\`  
title := fmt.Sprintf("Weekly: Add %d", issueNumber)  
\`\`\`  
\`\`\`  
head := fmt.Sprintf("gaocegege-bot:%s", branch)  
\`\`\`  
\`\`\`  
base := "master"  
\`\`\`  
\`\`\`  
body := fmt.Sprintf(\`weekly: Generate  
\`\`\`  
\`\`\`  
gaocegege-bot powered by github.com/dyweb/dy-bot  
\`\`\`  
\`\`\`  
Ref https: //github.com/%s/%s/issues/%d\`,  
\`\`\`  
\`\`\`  
w.config.Owner, w.config.Repo, issueNumber)  
\`\`\`  
\`\`\`  
newPR := \&github.NewPullRequest{  
\`\`\`  
\`\`\`  
Title: \&title,  
\`\`\`  
\`\`\`  
Head: \&head,  
\`\`\`  
\`\`\`  
Base: \&base,  
\`\`\`  
\`\`\`  
Body: \&body,  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
log.Infof("PR: %v", newPR)  
\`\`\`  
\`\`\`  
gc := gh.GetGitHubClient()  
\`\`\`  
\`\`\`  
ctx := context.Background()  
\`\`\`  
\`\`\`  
if \_, \_, err := ; err \!= nil {  
\`\`\`  
\`\`\`  
log.Errorf("failed to create pull request: %v", err)  
\`\`\`  
\`\`\`  
return err  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
return nil  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
Completion Cursor Position  
\`\`\`  
\_// Path: /pkg/weekly/worker.go\_

\_// Compare with this code snippet:\_

}

if err := w.buildWeekly(issue); err \!= nil {

return err

}

\_// commit and push branch\_

if err := w.gitCommitAndPush(newBranch); err \!= nil {

if err \== ErrNothingChanged {

\_// if nothing changed, no need to submit pull request.\_

return nil

}

\_// Path: /cli/dy-bot/server/server.go\_

\_// Compare with this code snippet:\_

if err \!= nil {

http.Error(w, err.Error(), http.StatusInternalServerError)

return

}

r.Body.Close()

if err := s.manager.HandleEvent(eventType, data); err \!= nil {

log.Errorf("Failed when handle webhook events: %v", err)

http.Error(w, err.Error(), http.StatusInternalServerError)

return

}

\_// Path: /pkg/weekly/worker.go\_

\_// Compare with this code snippet:\_

Body: \&body,

}

\_, \_, err \= gc.Client.Issues.Create(ctx, gc.Owner(),

gc.Repo(), newIssue)

if err \!= nil {

return err

}

return nil

}

func (w Worker) commitAndSubmitPR(issue github.Issue) error {

newBranch := generateNewBranch()

\`\`\`  
gc.PullRequests.Create(ctx, gc.Owner(), gc.Repo(), newPR)  
\`\`\`  
\*\*Cross file Context 1\*\*

\*\*Cross file Context 2\*\*

\*\*Cross file Context 3\*\*

\_// Path: /pkg/weekly/worker.go\_

\_// Compare with this code snippet:\_

Title: \&title,

Labels: &\[\]string{

labelWorking,

},

Assignee: \&assignee,

Body: \&body,

}

\_, \_, err \= gc.Client.Issues.Create(ctx, gc.Owner(),

gc.Repo(), newIssue)

if err \!= nil {

return err

\*\*Cross file Context 4\*\*

\*\*Ground Truth\*\*

\`\`\`  
gc.Client.PullRequests.Create(ctx, gc.Owner(), gc.Repo(), newPR)  
\`\`\`  
\*\*Model Output\*\*

\#\#\#\#\# In-file Context

\#\#\#\# Figure 16: Visualization on failure case for Go. (Semantic label:Expression)

\`\`\`  
\#\!/usr/bin/env node  
\`\`\`  
\`\`\`  
const amqp \= require('amqplib');  
\`\`\`  
\`\`\`  
const queue \= 'hello';  
\`\`\`  
\`\`\`  
(async () \=\> {  
\`\`\`  
\`\`\`  
try {  
\`\`\`  
\`\`\`  
const connection \= await amqp.connect('amqp://localhost');  
\`\`\`  
\`\`\`  
const channel \= await connection.createChannel();  
\`\`\`  
\`\`\`  
process.once('SIGINT', async () \=\> {  
\`\`\`  
\`\`\`  
await channel.close();  
\`\`\`  
\`\`\`  
await connection.close();  
\`\`\`  
\`\`\`  
});  
\`\`\`  
\`\`\`  
await channel.assertQueue(queue, { durable: false });  
\`\`\`  
\`\`\`  
await channel.consume(queue, (message) \=\> {  
\`\`\`  
\`\`\`  
console.log(" \[x\] Received '%s'", message.content.toString());  
\`\`\`  
\`\`\`  
}, { noAck: true });  
\`\`\`  
\`\`\`  
console.log(' \[\*\] Waiting for messages. To exit press CTRL+C');  
\`\`\`  
\`\`\`  
} catch (err)  
\`\`\`  
\`\`\`  
})();  
\`\`\`  
\#\#\#\# Completion Cursor Position

\`\`\`  
// Path: /test/channel.js  
\`\`\`  
\`\`\`  
// Compare with this code snippet:  
\`\`\`  
\`\`\`  
var bothDone \= latch( 2 , done);  
\`\`\`  
\`\`\`  
var pair \= util.socketPair();  
\`\`\`  
\`\`\`  
var c \= new Connection(pair.client);  
\`\`\`  
\`\`\`  
if (LOG\_ERRORS) c.on('error', console.warn);  
\`\`\`  
\`\`\`  
c.open(OPEN\_OPTS, function(err, ok) {  
\`\`\`  
\`\`\`  
if (err \=== null) client(c, bothDone);  
\`\`\`  
\`\`\`  
else fail(bothDone);  
\`\`\`  
\`\`\`  
});  
\`\`\`  
\`\`\`  
pair.server.read( 8 ); // discard the protocol header  
\`\`\`  
\`\`\`  
var s \= util.runServer(pair.server, function(send, wait) {  
\`\`\`  
\_// Path: /test/channel.js\_

\_// Compare with this code snippet:\_

.then(function() {

send(defs.ChannelCloseOk, {}, ch);

}).then(succeed(done), fail(done));

}));

test("return", channelTest(

function(ch, done) {

ch.on('return', function(m) {

completes(function() {

assert.equal('barfoo', m.content.toString());

}, done);

\`\`\`  
// Path: /test/channel.js  
\`\`\`  
\`\`\`  
// Compare with this code snippet:  
\`\`\`  
\`\`\`  
}, Buffer.from('foobar'));  
\`\`\`  
\`\`\`  
}, done);  
\`\`\`  
\`\`\`  
},  
\`\`\`  
\`\`\`  
function(send, wait, done, ch) {  
\`\`\`  
\`\`\`  
wait(defs.BasicPublish)()  
\`\`\`  
\`\`\`  
.then(wait(defs.BasicProperties))  
\`\`\`  
\`\`\`  
.then(wait(undefined)) // content frame  
\`\`\`  
\`\`\`  
.then(function(f) {  
\`\`\`  
\`\`\`  
assert.equal('foobar', f.content.toString());  
\`\`\`  
\`\`\`  
}).then(succeed(done), fail(done));  
\`\`\`  
\`\`\`  
{console.warn(err);}  
\`\`\`  
\*\*Cross file Context 1\*\*

\*\*Cross file Context 2\*\*

\*\*Cross file Context 3\*\*

\_// Path: /test/channel.js\_

\_// Compare with this code snippet:\_

.then(succeed(done), fail(done));

}));

test("delivery", channelTest(

function(ch, done) {

open(ch);

ch.on('delivery', function(m) {

completes(function() {

assert.equal('barfoo', m.content.toString());

}, done);

});

\*\*Cross file Context 4\*\*

\*\*Ground Truth\*\*

\`\`\`  
{console.error(err);}  
\`\`\`  
\*\*Model Output\*\*

\#\#\#\#\# In-file Context

\#\#\#\# Figure 17: Visualization on failure case for Javascript. (Semantic label:Statement)

\`\`\`  
package org.soichiro.ircslackrelay  
\`\`\`  
\`\`\`  
import ActorSystemProvider.\_  
\`\`\`  
\`\`\`  
/\*\*  
\`\`\`  
\`\`\`  
\* Main application singleton  
\`\`\`  
\`\`\`  
\*/  
\`\`\`  
\`\`\`  
object Main extends App {  
\`\`\`  
\`\`\`  
val slackClientActor \=  
\`\`\`  
\`\`\`  
val ircToSlackActor \= system.actorOf(IrcToSlackActor.props(slackClientActor),  
\`\`\`  
\`\`\`  
name \= "ircToSlackActor")  
\`\`\`  
\`\`\`  
ircToSlackActor\! StartIrcToSlackActor  
\`\`\`  
\`\`\`  
val slackToIrcActor \= system.actorOf(SlackToIrcActor.props(slackClientActor),  
\`\`\`  
\`\`\`  
name \= "slackToIrcActor")  
\`\`\`  
\`\`\`  
slackToIrcActor\! StartSlackToIrcActor  
\`\`\`  
\`\`\`  
}  
\`\`\`  
Completion Cursor Position

\`\`\`  
// Path: /src/main/scala/org/soichiro/ircslackrelay/SlackToIrcActor.scala  
\`\`\`  
\`\`\`  
// Compare with this code snippet:  
\`\`\`  
\`\`\`  
log.info(s"Messaged: ${m}")  
\`\`\`  
\`\`\`  
sendToIrc(m)  
\`\`\`  
\`\`\`  
case n: IrcNotice \=\>  
\`\`\`  
\`\`\`  
log.info(s"Noticed: ${n}")  
\`\`\`  
\`\`\`  
sendToIrc(n)  
\`\`\`  
\`\`\`  
case \_ \=\>  
\`\`\`  
\`\`\`  
log.error("Not supported command.")  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
private def sendToIrc(c: IrcCommand): Unit \= {  
\`\`\`  
\`\`\`  
if(isItalic(c.message)) {  
\`\`\`  
\`\`\`  
// Path: /src/main/scala/org/soichiro/ircslackrelay/SlackToIrcActor.scala  
\`\`\`  
\`\`\`  
// Compare with this code snippet:  
\`\`\`  
\`\`\`  
override def receive: Receive \= {  
\`\`\`  
\`\`\`  
case StartSlackToIrcActor \=\>  
\`\`\`  
\`\`\`  
slackIrcClient.connect  
\`\`\`  
\`\`\`  
log.info("SlackToIrcActor Started.")  
\`\`\`  
\`\`\`  
case m: IrcMessage \=\>  
\`\`\`  
\`\`\`  
log.info(s"Messaged: ${m}")  
\`\`\`  
\`\`\`  
sendToIrc(m)  
\`\`\`  
\`\`\`  
case n: IrcNotice \=\>  
\`\`\`  
\`\`\`  
log.info(s"Noticed: ${n}")  
\`\`\`  
\`\`\`  
sendToIrc(n)  
\`\`\`  
\`\`\`  
// Path: /src/main/scala/org/soichiro/ircslackrelay/SlackToIrcActor.scala  
\`\`\`  
\`\`\`  
// Compare with this code snippet:  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
private def getIrcChannel(slackChannel: Channel): String \= {  
\`\`\`  
\`\`\`  
Config.relays.relayMapSlackToIrc(slackChannel.getName.toLowerCase)  
\`\`\`  
\`\`\`  
}  
\`\`\`  
\`\`\`  
val passwordRegex \= "\_(\[^\_\]+)\_".r  
\`\`\`  
\`\`\`  
private def isItalic(s: String): Boolean \= {  
\`\`\`  
\`\`\`  
s match {  
\`\`\`  
\`\`\`  
case passwordRegex(\_) \=\> true  
\`\`\`  
\`\`\`  
case \_ \=\> false  
\`\`\`  
\`\`\`  
system.actorOf(SlackClientActor.props, "slackClientActor")  
\`\`\`  
\*\*Cross file Context 1\*\*

\*\*Cross file Context 2\*\*

\*\*Cross file Context 3\*\*

\*\*Ground Truth\*\*

\`\`\`  
system.actorOf(SlackClientActor.props(), name="slackClientActor")  
\`\`\`  
\*\*Model Output\*\*

\#\#\#\#\# In-file Context

\#\#\#\# Figure 18: Visualization on failure case for Scala. (Semantic label:Expression)

\`\`\`  
Objective-C  
\`\`\`  
\`\`\`  
C++  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
Haskell  
\`\`\`  
\`\`\`  
Ruby  
Kotlin  
\`\`\`  
\`\`\`  
Rust  
\`\`\`  
\`\`\`  
C\#  
\`\`\`  
\`\`\`  
PHP  
\`\`\`  
\`\`\`  
Java  
\`\`\`  
\`\`\`  
Go  
\`\`\`  
\`\`\`  
HTML  
\`\`\`  
\`\`\`  
R  
\`\`\`  
\`\`\`  
JavaScriptTypeScript  
\`\`\`  
\`\`\`  
Scala  
\`\`\`  
\`\`\`  
Lua  
\`\`\`  
\`\`\`  
Python  
\`\`\`  
\`\`\`  
0.0  
\`\`\`  
\`\`\`  
0.5  
\`\`\`  
\`\`\`  
1.0  
\`\`\`  
\`\`\`  
1.5  
\`\`\`  
\`\`\`  
2.0  
\`\`\`  
\`\`\`  
2.5  
\`\`\`  
\#\#\#\#\#\# Score

\`\`\`  
Easy (ES)  
\`\`\`  
\`\`\`  
Middle (ES)  
\`\`\`  
\`\`\`  
Hard (ES)  
\`\`\`  
\`\`\`  
Easy (EM)  
\`\`\`  
\`\`\`  
Middle (EM)  
\`\`\`  
\`\`\`  
Hard (EM)  
\`\`\`  
\#\#\#\# Figure 19: Performance on M

2

\#\#\#\# RC-EVALfor problems of different difficulty levels.


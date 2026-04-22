\`\`\`  
..  
Latest updates: hps://dl.acm.org/doi/10.1145/  
..  
RESEARCH-ARTICLE  
\`\`\`  
\#\# AlphaTrans: A Neuro-Symbolic Compositional

\#\# Approach for Repository-Level Code Translation and

\#\# Validation

\`\`\`  
ALI REZA IBRAHIMZADA, University of Illinois Urbana-Champaign,  
Urbana, IL, United States  
.  
KAIYAO KE, University of Illinois Urbana-Champaign, Urbana, IL, United  
States  
.  
MRIGANK PAWAGI, Indian Institute of Science, Bengaluru, KA, India  
.  
MUHAMMAD SALMAN ABID, Cornell University, Ithaca, NY, United  
States  
.  
RANGEET PAN, IBM Research, Yorktown Heights, NY, United States  
.  
SAURABH SINHA, IBM Research, Yorktown Heights, NY, United States  
.  
View all  
..  
Open Access Support provided by:  
.  
IBM Research  
.  
University of Illinois Urbana-Champaign  
.  
Indian Institute of Science  
.  
Cornell University  
.  
\`\`\`  
\`\`\`  
PDF Download  
3729379.pdf  
03 April 2026  
Total Citations: 3  
Total Downloads:  
\`\`\`  
(^1041).  
.  
..  
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

\# AlphaTrans: A Neuro-Symbolic Compositional Approach for

\# Repository-Level Code Translation and Validation

\#\#\# ALI REZA IBRAHIMZADA,University of Illinois Urbana-Champaign, USA

\#\#\# KAIYAO KE,University of Illinois Urbana-Champaign, USA

\#\#\# MRIGANK PAWAGI,Indian Institute of Science, India

\#\#\# MUHAMMAD SALMAN ABID,Cornell University, USA

\#\#\# RANGEET PAN,IBM Research, USA

\#\#\# SAURABH SINHA,IBM Research, USA

\#\#\# REYHANEH JABBARVAND,University of Illinois Urbana-Champaign, USA

Code translation transforms programs from one programming language (PL) to another. One prominent use  
case is application modernization to enhance maintainability and reliability. Several rule-based transpilers have  
been designed to automate code translation between different pairs of PLs. However, the rules can become  
obsolete as the PLs evolve and cannot generalize to other PLs. Recent studies have explored the automation  
of code translation using Large Language Models (LLMs). One key observation is that such techniques may  
work well for crafted benchmarks but fail to generalize to the scale and complexity of real-world projects  
with inter- and intra-class dependencies, custom types, PL-specific features, etc. We proposeAlphaTrans, a  
neuro-symbolic approach to automaterepository-levelcode translation.AlphaTranstranslates both source  
and test code, and employs multiple levels of validation to ensure the translationpreservesthe functionality  
of the source program. To break down the problem for LLMs,AlphaTransleverages program analysis to  
decompose the program into fragments and translates them in thereverse call order.  
We leveragedAlphaTransto translatetenreal-world open-source projects consisting of⟨ 836 , 8575 , 2719 ⟩  
(application and test) classes, (application and test) methods, and unit tests.AlphaTransbreaks down these  
projects into 17874 fragments and translates the entire repository. 96 .40%of the translated fragments are  
syntactically correct, andAlphaTransvalidates the translations’ runtime behavior and functional correctness  
for 27 .03%and 25 .14%of the application method fragments. On average, integrated translation and validation  
takes 34 hours (min= 3 , max= 121 ) to translate a project, showing its scalability in practice. For the syntactically  
or semantically incorrect translations,AlphaTransgenerates a report including existing translation, stack  
trace, test errors, or assertion failures. We provided these artifacts to two developers to fix the translation  
bugs in four projects. They fixed the issues in 20\. 1 hours on average ( 5\. 5 hours for the smallest and 34 hours  
for the largest project) and achieved all passing tests. WithoutAlphaTrans, translating and validating such  
big projects could take weeks, if not months.  
CCS Concepts:•Software and its engineering→Source code generation;•Computing methodologies  
→Machine translation.  
Additional Key Words and Phrases: Neuro-Symbolic Code Translation and Validation

\`\`\`  
Authors’ Contact Information: Ali Reza Ibrahimzada, University of Illinois Urbana-Champaign, Urbana, USA, alirezai@  
illinois.edu; Kaiyao Ke, University of Illinois Urbana-Champaign, Urbana, USA, kaiyaok2@illinois.edu; Mrigank Pawagi,  
Indian Institute of Science, Bengaluru, India, mrigankp@iisc.ac.in; Muhammad Salman Abid, Cornell University, Ithaca, USA,  
ma2422@cornell.edu; Rangeet Pan, IBM Research, Yorktown Heights, USA, Rangeet.Pan@ibm.com; Saurabh Sinha, IBM  
Research, Yorktown Heights, USA, sinhas@us.ibm.com; Reyhaneh Jabbarvand, University of Illinois Urbana-Champaign,  
Urbana, USA, reyhaneh@illinois.edu.  
\`\`\`  
This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.  
©2025 Copyright held by the owner/author(s).  
ACM 2994-970X/2025/7-ARTFSE  
https://doi.org/10.1145/

\`\`\`  
FSE109:2 A. R. Ibrahimzada, K. Ke, M. Pawagi, M. S. Abid, R. Pan, S. Sinha, and R. Jabbarvand  
\`\`\`  
ACM Reference Format:  
Ali Reza Ibrahimzada, Kaiyao Ke, Mrigank Pawagi, Muhammad Salman Abid, Rangeet Pan, Saurabh Sinha,  
and Reyhaneh Jabbarvand. 2025.AlphaTrans: A Neuro-Symbolic Compositional Approach for Repository-  
Level Code Translation and Validation.Proc. ACM Softw. Eng.2, FSE, Article FSE109 (July 2025), 23 pages.  
https://doi.org/10.1145/

\`\`\`  
1 Introduction  
\`\`\`  
Application modernization offers numerous benefits to developers, including better performance,  
maintainability, productivity, reliability, and security \[ 28 , 29 , 31 , 32 \]. Manual migration or modern-  
ization of real-world projects can be time-consuming and error-prone. Code translation can help  
automatically convert programs from one programming language (PL) to another.  
Transpilers solely rely on program analysis and perform rule-based translation, failing to translate  
code between languages that greatly differ in syntax or semantics \[5\]. This also makes them very  
PL-specific; they cannot generalize to newer features of the same PL pairs easily, let alone other PLs.  
Finally, the translations lack readability, requiring much effort to understand and validate them, and  
naturalness, failing to create idiomatic code in the target PL \[ 44 \]. State-of-the-art code translation  
techniques attempt to harvest the emerging abilities of Large Language Models (LLMs) in code  
synthesis to overcome the limitations of transpilers \[ 42 , 44 , 62 \]. However, these techniques are  
still limited to translating simple programs in crafted benchmarks or selected slices of real-world  
projects due to the following challenges:  
(1)Problem complexity.The source and target PLs can be fundamentally different in programming  
paradigms, typing, and memory management. Some PLs have specific properties that may not  
exist in others, e.g., constructor overloading in Java. Such complexities are beyond the abilities  
of existing LLMs to handle, causing them to hallucinate when translating types, code constructs,  
or even method names \[44\], making translations non-compilable or useless.  
(2)Validation.The translation should preserve the functionality of the source project. Most existing  
techniques follow a “translation first and validation next” approach, which can postpone the  
validation and not benefit from the potential use of validation as feedback to correct the  
translation \[ 44 \]. A few techniques use formal methods \[ 42 , 62 \] to verify translations on the  
go. However, these techniques cannot scale to real-world projects. One possible solution for  
validation is reusing the tests in the source language. However, due to (1) multiple invocations  
of different methods in unit tests and (2) inherent long call chains in real-world projects, testing  
a translated methodin isolationis impossible.  
(3)Limited context window.Concerning repository-level translation, the entire project and, in many  
cases, even the entire class cannot fit into the context window of current LLMs \[ 25 \]. Assuming  
an unlimited context window, LLMs still suffer from short attention span \[ 38 \], preventing them  
from properly capturing the intra- and inter-procedural dependencies in real-world projects.  
This paper presentsAlphaTrans, a neuro-symbolic^1 approach for automated repository-level  
code translation and validation.AlphaTransleverages static analysis to resolve PL-specific features  
of the source language (§4.1), decompose the source project into smaller fragments (§4.2), and  
create a compilable project skeleton in the target language (§5). It then starts translating fragments  
in reverse call order and validates them using existing tests when possible (§6). After translating  
each fragment,AlphaTransupdates the project skeleton and ensures the whole project compiles,  
gradually translating and validating the source project into the target PL. To improve translation  
quality, static analysis again comes to the rescue:AlphaTranscollects relevant context for each

(^1) The keyword symbolic here refers to a general term of symbolic learning in contrast to machine learning and should not  
be confused with symbolic execution. We refer to combining LLMs and program analysis as a neuro-symbolic approach.

\`\`\`  
A Neuro-Symbolic Compositional Approach for Repository-Level Code Translation and Validation FSE109:  
\`\`\`  
fragment, including translated callee methods and surrounding contexts, e.g., class declaration,  
global variables/fields, etc. It also uses relevant in-context examples based on the specific properties  
of the fragment to be translated.AlphaTransimplements two types of dynamic validation: (1)  
running the source tests on the translated fragments in isolation using language interoperability  
(§6.1) and (2) decomposing, translating, and executing the source tests on the translated fragments  
(§6.3). Finally,AlphaTransrecomposes the translated fragments to create the program in the  
target PL (§6.2).  
Our approach of compositional translation and validation is PL-agnostic; however, implementing  
the program transformation component is PL-specific. For the first version ofAlphaTrans, the  
implementation supports translating Java code to Python. Our motivations for choosing this PL pair  
are: (1) Java offers many features that are not supported or common in other PLs by default (e.g.,  
method/constructor overloading, complex types, circular dependencies, local or anonymous inner  
classes, interfaces, etc.); (2) Python programs are not compiled but interpreted, which makes many  
translation issues that can be caught at the compile time remain undetected until test execution  
and challenge the validation; and (3) both PLs are popular (top-5 on the TIOBE index \[56\]).  
UsingAlphaTransto translate ten real-world Java projects to Python corroborates itseffec-  
tiveness: It can translate 17874 field/method/test fragments, with 96 .40%syntactic correctness.  
For the 4654 application method fragments that can be further evaluated through test execution,  
AlphaTransachieves 27 .03%runtime validation and 25 .14%functional equivalence using the  
source tests.AlphaTransisscalable, completing translations in 34 hours, on average. Human  
subjects improved partial translation ofAlphaTransand achieved passing test suites within  
20\. 1 hours, on average, showingpracticalityofAlphaTrans. These results were achieved using a  
moderate-size open-access LLM (DeepSeek-Coder-33b-Instruct \[ 24 \]). A stronger model, i.e., GPT-4o,  
improves the performance ofAlphaTransto 99 .2%syntactic correctness for all fragments and  
27 .95%functional equivalence for method fragments, with an overhead of$14. 39 per project, on  
average. The affordable cost is due to the novel features of the pipeline, namely, decomposition  
into fragments, prompt crafting, in-isolation validation of translations, and efficient feedback loop.  
To the best of our knowledge,AlphaTransis thefirst technique to translate an entire repository,  
including tests, and generates validated translations (considering existing tests). The only prior  
repository-level translation attempt using GPT-4 \[ 44 \] (translating Apache Commons CLI from Java  
to Python) resulted in non-compilable code, let alone the translation being validated.AlphaTrans  
is alsothe first technique leveraging language interoperability for in-isolation validation of translated  
fragments. The effort of human subjects to fix translation bugs byAlphaTransand achieve passing  
tests creates pragmatic bug data sets for testing, bug localization, and program repair research. Our  
code and artifacts are publicly available for reproducing the results or translating new projects \[ 33 \].  
2 Challenges in Repository-Level Code Translation  
To illustrate the most notable challenges in repository-level code translation and validation, we use  
the hypothetical example in Figure 1, inspired by the complexities in real-world Java projects.  
Challenge 1: Class Size.The class consists of 25 , 380 tokens (a). Instructions for translating the  
code, in-context examples, and the model’s response can also significantly increase the number of  
input tokens. While some commercial LLMs support tens of thousands of tokens, many open-access  
LLMs do not. For example, DeepSeek-Coder-33b-Instruct \[ 24 \] used in this paper has a context  
window of 16 , 384 tokens, of which only 4 , 096 tokens can be used for generation. To address  
this challenge,AlphaTransdecomposes Java application classes into smallerfieldandmethod  
fragmentsand translates each separately in reverse call order (§4.2.1, §4.2.2).  
Challenge 2: PL-specific Properties.Java programs frequently use method/constructor over-  
loading, which is not supported directly in Python (a). This example shows instances of constructor

\`\`\`  
FSE109:4 A. R. Ibrahimzada, K. Ke, M. Pawagi, M. S. Abid, R. Pan, S. Sinha, and R. Jabbarvand  
\`\`\`  
\`\`\`  
Transformation and decomposition Test decomposition Translation validation  
public private class Option ArgExp option extends; Exception {  
\`\`\`  
public ArgExpthis((optionOption. (^) getKeyoption());) {  
(^) public ArgExpthis.option(String \= msgoption;}) {  
(^) public Stringsuper(msg);} getMsg() {...}  
publicpublic intint getNumArgsgetLen() {...} () {...}  
public void...; createMsg() {  
(^) }getMsg(); getNumArgs();...;}  
29 tokens  
16 tokens  
11438 tokens2390 tokens  
5056 tokens  
6893 tokens  
(^01)  
(^23)  
(^45)  
(^67)  
(^89)  
(^1011)  
(^1213)  
(^25380) tokens  
(^01)  
(^23)  
(^45)  
(^67)  
(^89)  
(^1011)  
(^1213)  
(^1415)  
16  
publicprivate class Option ArgExp option extends; Exception {  
public Option static opt ArgExp, String ArgExp1 msg) {(int id,  
if (id return== 1 )new ArgExp(id, opt, opt.getKey());  
(^) publicreturn ArgExp new ArgExp(int id(id, opt, msg);}, Option opt, String msg) {  
superif (id (msg);== 1 )  
(^) publicthis String.option getMsg \= opt;}() {...}  
publicpublic intint getNumArgsgetLen() {...}() {...}  
public getNumArgs void createMsg();...;}() {...; getMsg();  
}  
a public public^ class void^ TestArgExptest01() {^ {  
ArgExpint num obj \= obj= new.getNumArgs ArgExp( (^0) ();, null, "message");  
assertEqualobj.createMsg(num, (); obj.getLen());  
(^) }assertEqual("exp", obj.getMsg());  
}  
(^01)  
(^23)  
(^45)  
(^67)  
(^89)  
(^1011)  
(^1213)  
c e  
b public publicArgExp^ class void obj^ TestArgExptest01\_0\_decomposed \= new ArgExp^ {( 0 , null() { , "message");}d f  
publicArgExp void obj test01\_1\_decomposed \= new ArgExp( 0 , null() { , "message");  
(^) publicint numvoid \= test01\_2\_decomposedobj.getNumArgs();}() {  
ArgExpint num obj \= obj= new.getNumArgs ArgExp( (^0) ();, null, "message");  
(^) publicassertEqual void test01\_3\_decomposed(num, obj.getLen());}() {  
ArgExpint num obj \= obj= new.getNumArgs ArgExp( (^0) ();, null, "message");  
assertEqualobj.createMsg(num, ();}obj.getLen());  
public// original test01 body void test01\_4\_decomposed}} () {  
(^01)  
(^23)  
(^45)  
(^67)  
(^89)  
(^1011)  
(^1213)  
(^1415)  
16  
class def TestArgExptest01\_0\_decomposed(unittest.(TestCaseself): ):  
(^) def... test01\_1\_decomposed(self):  
(^) def... test01\_2\_decomposed(self):  
(^) def... test01\_3\_decomposed(self):  
(^) def... test01\_4\_decomposed(self):  
...  
fail  
(^012) pass  
(^34)  
(^56)  
(^78)  
(^910)  
(^1112)  
13  
test  
ArgExp  
getNumArgs  
getLen  
createMsg  
public private class Option ArgExp option extends; Exception {  
publicpublic staticArgExp (^) ()ArgExp ArgExp1()  
publicpublic Stringint getNumArgs getMsg()()  
publicpublic intvoid getLen createMsg()()}  
defsuper \_\_.init\_\_init\_\_(...):\_\_(msg)  
ifself id.option \== 1 : \= opt  
Original code  
Transformed code Isolation  
Execution trace  
Original test  
Decomposed test  
Test execution  
pass  
pass  
Fig. 1\. Illustration of key challenges in repository-level code translation andAlphaTransaddressing them.  
overloading (lines 2 and 5). In Python, declaring two constructors is allowed; however, at runtime,  
the last declaration overrides all previous constructors, resulting in unexpected behavior. To address  
this issue,AlphaTransemploys program analysis to refactor the original code while preserving  
the functionality (through test execution). The transformation includes changing the constructor’s  
name, updating the references, and changing the constructor’s implementation. The transformed  
code (b) makes the source program amenable to translation to Python.  
Challenge 3: Validation.To illustrate the challenges with validation, considertest01(c)  
that invokesfourmethods in its body (ArgExp,getNumArgs,getLen, andcreateMsg) to test the  
functionality of methodgetMsgin the assert statement. Suppose we can successfully translate  
all methods exceptcreateMsg. If we choose test translation (a natural way of validating code  
translation), the execution of the translated test results in a runtime error when invokingcreateMsg.  
As a result, a translation issue in one method casts a shadow in validating the translation of  
the other methods. We refer to this issue as thetest translation coupling effect. To overcome this  
challenge,AlphaTransexecutes source language tests as-is (i.e., without translation) by leveraging  
a language-interoperability framework called GraalVM \[ 43 \] (f). In this setting, a test in the source  
language is executed each time one of its invoked application methods (method fragments) is  
translated. This approach validatesfunctional equivalenceof each methodin isolationas the other  
invoked application methods during test execution remain in the source language.  
Challenge 4: Test Translation.GraalVM has certain limitations (§6.1), which preventsAl-  
phaTransfrom validating all the code fragments in isolation. Furthermore, we need to translate  
tests regardless of whether they are used for validation to maintain the translated projects in the  
target language. Test errors due to test translation coupling effect under-approximate the quality of  
translation: failing to validate the translation of four methods because of one incorrect translation.  
To overcome this challenge,AlphaTransdecomposes the original test suite intotest fragments  
(d). Executing the translated decomposed test suite results in three test passes (e), validating the  
runtime behaviorof three methods that the original test suite could not promptly provide.  
An alternative approach is parsing the stack trace and code coverage results for each runtime  
error during translation. However, test decomposition is a cleaner way to see the results per test  
execution promptly. It is also done once before translation. In translation to interpreted languages  
such as Python, specifically, the execution of test fragments can validate the runtime behavior of  
methods before waiting for functional validation. For fragments that GraalVM cannot validate, if  
AlphaTranscan successfully translate all the methods invoked during test execution and the test  
passes, such a test will also be used for validatingfunctional correctness.

\`\`\`  
A Neuro-Symbolic Compositional Approach for Repository-Level Code Translation and Validation FSE109:  
\`\`\`  
\`\`\`  
Compositional translation  
\`\`\`  
\`\`\`  
and validation  
\`\`\`  
\`\`\`  
Program transformation and decomposition  
\`\`\`  
\`\`\`  
Java  
project  
\`\`\`  
\`\`\`  
Program transformation  
\`\`\`  
\`\`\`  
Classes Fields Methods  
AST  
Refactoring  
\`\`\`  
\`\`\`  
Test decomposition  
Original  
test  
\`\`\`  
\`\`\`  
Decomposed tests  
\`\`\`  
\`\`\`  
Source decomposition  
\`\`\`  
\`\`\`  
" class X"methods":":  
"name"... : "method Y",  
"fields"name"":: "field A",  
...  
\`\`\`  
\`\`\`  
Java types  
\`\`\`  
\`\`\`  
Python types  
\`\`\`  
\`\`\`  
LLM  
\`\`\`  
\`\`\`  
String int double  
List Map short  
\`\`\`  
\`\`\`  
str int float  
List Dict int  
\`\`\`  
\`\`\`  
Type translation and Skeleton construction  
\`\`\`  
\`\`\`  
class \_\_option: Option ArgExp(Exception= None):  
@defstaticmethod ArgExp1(id: int, opt:  
pass Option, msg: str)-\>ArgExp:  
def \_\_init\_\_opt(self:Option,, idmsg:int:, str):  
\`\`\`  
(^) defpass getMsg(self) \-\> str:  
(^) ...pass  
Skeleton  
Skeleton validation  
{ }  
Translated project  
Executionreport  
Code translation and validation Code traversal  
Call graph  
Reversetraversal  
bottom-up  
translate from$SRCto$TRG  
$SRC\_DEPENDENCIESlanguage.  
$SRC\_SKELETON$SRC\_CODE  
Syntax  
validation  
LLM  
Prompting  
Isolation  
validation  
Test translation selectionTest  
t1.java  
t3.java  
t2.java  
t1.java  
t2.java  
t1.pyt2.py  
schema  
Universal Type Map  
Fig. 2\. Overview ofAlphaTrans.  
3 Overview of Approach  
AlphaTransconsists of three main phases, shown in Figure 2: program transformation and  
decomposition (§4), type translation and skeleton construction (§5), and compositional translation  
and validation (§6). The first two phases aim to decompose and simplify the repository-level code  
translation problem for LLMs, helping the third phase yield high-quality validated translations.  
The program transformation and decomposition phase first refactors the PL-specific properties  
of the source program into programming paradigms common among many PLs (§4.1). Next, it  
decomposes the source project into smaller units, i.e.,fragments, and stores fragment dependencies  
in a data structure calledschema(§4.2).  
The type translation and skeleton construction phase takes the schema as input and produces  
target project skeleton, i.e., a compilable project in the target language with method signatures  
but no method implementation (§5.2). The first translation step happens here, where the source  
PL types are translated to the target PL to ensure that class skeletons are compilable (§5.1). The  
outcome of type translation is a type mapping from the source to the target PL, whichAlphaTrans  
can reuse in translating other projects.  
The compositional translation and validation phase takes the schema and project skeleton as  
inputs and translates fragments, in reverse call order, by prompting an LLM. After translating a  
fragment, it updates the class skeleton with a new translation and checks whether the skeleton  
compiles. For a method fragment,AlphaTranslooks for corresponding tests and, if any exist,  
uses them to validate the fragment. The first level of validation is performed through GraalVM’s  
language interoperability to isolate the validation of the method using tests in the source language.  
Next,AlphaTranstranslates and executes the tests. In case of compilation errors or test failures,  
AlphaTransreprompts the LLM with feedback (from the compilation/runtime errors) to improve  
the translation. If no improvement is achieved within a certain budget,AlphaTranscontinues to  
the next fragment until all are translated. For methods whose translations are not compilable or  
result in test errors/failures,AlphaTransgenerates reports consisting of existing translations and  
relevant artifacts, such as stack traces, test errors/failures, and test coverage information.  
4 Program Transformation and Decomposition  
4.1 Program Transformation  
This component performs semantics-preserving refactoring of method and constructor overloading  
in Java code to make it amenable to translation to Python. Other Java-specific features, namely,  
circular dependencies, inner classes, interfaces, and abstract classes, are handled while constructing  
the project skeleton in Python (§5.2). The reason for resolving method and constructor overloading  
in the source language is that we have to change the implementation, i.e., call sites to methods and  
constructors. Therefore, such changes should be validated using source tests before translation.

\`\`\`  
FSE109:6 A. R. Ibrahimzada, K. Ke, M. Pawagi, M. S. Abid, R. Pan, S. Sinha, and R. Jabbarvand  
\`\`\`  
\`\`\`  
public ArgExp(Option opt) {  
thisthis(.optoption.getKey \= opt;());  
}public ArgExp(String msg) {  
\`\`\`  
(^) }super(msg);  
(^12)  
3  
(^45)  
(^67)  
Original code  
public this (^) (ArgExpopt.getKey(Option()); opt) {  
}  
public super ArgExp(msg);(String msg) {  
}  
(^12)  
3  
(^45)  
(^67)  
public this (^) .ArgExpoption( Option= opt; opt) {  
this.threshold \= 1 ;  
}public ArgExp(String msg) {  
(^) }this.msg \= msg;  
1  
(^23)  
(^45)  
(^67)  
public static ArgExp ArgExp1(  
(^) if (id \== 1 )int id, Option opt, String msg){  
(^) returnreturn new new ArgExp ArgExp(id, opt, msg);}(id, opt, opt.getKey());  
public super ArgExp(msg);(int id, Option opt, String msg){  
if (id \== 1 )  
this.option \= opt;}  
1  
(^23)  
(^45)  
(^67)  
8  
9  
public static ArgExp ArgExp1(Option opt) {  
(^) }return new ArgExp(opt.getKey());  
public super ArgExp(msg);(String msg) {  
}  
1  
(^23)  
(^45)  
(^67)  
8  
9  
public if ( (^) idArgExp \== 0 () int id, Option opt, String msg){  
{  
thisthis..optionthreshold \= opt \= ; 1 ;  
} else {  
(^) }this.msg \= msg  
1  
(^23)  
(^45)  
(^67)  
(^89)  
(a) (b) (c)  
Original code Original code  
Transformed code Transformed code Transformed code  
Fig. 3\. Constructor overloading patterns and their corresponding transformations.  
For overloaded methods,AlphaTransmakes each method name unique by adding an integer  
suffix (starting at 0 ) to the name, and updates all call sites based on the new method names.  
Resolving overloaded constructors is not as straightforward, as they should have the same name as  
the enclosed declaring class. Furthermore, the invocation of constructors inside each other and the  
Java inheritance mechanism makes constructor overloading complex. Our algorithm (Algorithm 1\)  
for resolving the constructor overloading handles three prominent patterns shown in Figure 3.^2  
Algorithm 1:Constructor Overloading  
Inputs:Overloaded Constructors𝑂𝐶𝑠  
Output:Code without Overloaded Constructors𝑁𝑂𝐶𝑠  
1 if\!ℎ𝑎𝑠𝑇ℎ𝑖𝑠𝐶𝑎𝑙𝑙(𝑂𝐶𝑠)then  
2 ids←𝑐𝑟𝑒𝑎𝑡𝑒𝐶𝑜𝑛𝑠𝑡𝑟𝑢𝑐𝑡𝑜𝑟𝐼𝐷𝑆(𝑂𝐶𝑠);  
3 NOCs←𝑚𝑒𝑟𝑔𝑒(𝑂𝐶𝑠,𝑖𝑑𝑠);  
4 else  
5 ifℎ𝑎𝑠𝑂𝑛𝑙𝑦𝑇ℎ𝑖𝑠𝐶𝑎𝑙𝑙(𝑂𝐶𝑠)then  
6 refactor←𝑐𝑟𝑒𝑎𝑡𝑒𝑅𝑒𝑓𝑎𝑐𝑡𝑜𝑟𝑀𝑒𝑡ℎ𝑜𝑑(𝑂𝐶𝑠);  
7 NOCs←𝑚𝑒𝑟𝑔𝑒(𝑂𝐶𝑠,𝑟𝑒𝑓𝑎𝑐𝑡𝑜𝑟);  
8 else  
9 refactor←𝑐𝑟𝑒𝑎𝑡𝑒𝑅𝑒𝑓𝑎𝑐𝑡𝑜𝑟𝑀𝑒𝑡ℎ𝑜𝑑(𝑂𝐶𝑠);  
10 ids←𝑐𝑟𝑒𝑎𝑡𝑒𝐶𝑜𝑛𝑠𝑡𝑟𝑢𝑐𝑡𝑜𝑟𝐼𝐷𝑆(𝑂𝐶𝑠);  
11 NOCs←𝑚𝑒𝑟𝑔𝑒(𝑂𝐶𝑠,𝑟𝑒𝑓𝑎𝑐𝑡𝑜𝑟,𝑖𝑑𝑠);  
12 𝑟𝑒𝑓𝑎𝑐𝑡𝑜𝑟𝐶𝑎𝑙𝑙𝑆𝑖𝑡𝑒𝑠();  
13 returnNOCs;  
The first pattern (Figure 3-a) shows mul-  
tiple independent constructors.AlphaTrans  
merges these constructors into one and uses  
anidparameter to differentiate between them.  
All call sites of the constructors are updated  
accordingly to use the appropriateidvalue.  
The second pattern (Figure 3-b) involves a  
constructor call chain usingthis().Alpha-  
Transtransforms the first constructor into  
a factory method and invokes the second  
constructor inside it. Factory methods are  
static, andAlphaTransupdates the call sites  
to invoke them directly on the class, e.g.,  
ArgExp.ArgExp1(id,opt,msg). The last pattern  
(Figure 3-c) is similar to the second one, except that both constructors implement some code.  
AlphaTransrefactors the first constructor into a factory method and adds an extraidparameter  
to differentiate between behaviors implemented by different constructors. The constructor call  
sites are updated accordingly, as in the previous cases. Real-world projects often combine these  
patterns, whichAlphaTranshandles using Algorithm 1\.  
4.2 Program Decomposition  
Translating the entire repository of real-world projects is a very complex problem. As a result,  
AlphaTransbreaks down projects into fragments, performs the translation and validation at the  
fragment level, and re-composes the translation as a repository in the target language.  
4.2.1 Source Decomposition.Real-world projects can include hundreds of files with thousands of  
lines of code, which exceed the context window of state-of-the-art LLMs.AlphaTransemploys  
static analysis to decompose code into smaller fragments, i.e.,field fragmentsandmethod fragments.  
A field fragment includes modifiers, type, name, and field value. A field fragment can belong to  
an application or test class. A method fragment includes the method signature and can be an  
(^2) Following the best practices for constructor overloading fromStack Overflowand analyzing the use of constructor  
overloading in open-source projects, we categorized the use cases into the three patterns.

A Neuro-Symbolic Compositional Approach for Repository-Level Code Translation and Validation FSE109:

application or test method (e.g., helper methods or unit tests). During decomposition,AlphaTrans  
extracts meta-information related to the fragments, such as their location (e.g., start and end line),  
code (e.g., implementation between start and end line), dependencies (e.g., callers and callees),  
types (of inputs and output), and other necessary information such as file paths, class inheritance,  
imports, and method annotations.AlphaTransstores fragments and their corresponding collected  
meta-data in a data structure calledschema, which is used in the other phases.AlphaTransalso  
extracts the call graph to guide the translation, i.e., to translate fragments in reverse call order.

4.2.2 Test Decomposition.The burden of checkingfunctional equivalenceinAlphaTransis on  
GraalVM. Yet, we still need to translate and execute tests to validate the fragments that cannot  
be validated by GraalVM (§6.1). Unit tests in real-world projects can invoke multiple methods  
and include multiple assert statements. Furthermore, long call chains are inevitable in real-world  
projects due to the high degree of intra- and iter-procedural dependencies. As we show later (§7.4),  
the average number of direct method invocations and method executions in tests for our studies  
subjects are 3 and 27 , respectively. This can result intest translation coupling effect, discussed in §2.  
To enable test translation for runtime validation or checking functional equivalence,AlphaTrans  
decomposes each unit test into a series oftest fragments, as shown in Figure 1-d. It uses each  
statement with a call to an application method as a cutting point. For statements enclosed by  
branches, loops, of exception-handling blocks,AlphaTransincludes the entire block. This process  
generates an ordering of executable test fragments for each unit test. Each test fragment includes  
all the statements of the lower-order fragments, along with additional statements that invoke one  
additional method not invoked by previous fragments.AlphaTransexecutes test fragments in  
increasing order until a test fails and skips running following fragments, as they will also fail.

5 Type Translation and Skeleton Construction

5.1 Type Translation class\_\_option: Option \= NoneArgExp(Exception):  
@staticmethod  
defArgExp1(id: int, opt: Option, \\  
msg: str)-\>ArgExp:  
pass  
def\_\_init\_\_(self, id: int, opt: \\  
Option, msg: str):  
pass  
defgetMsg(self)-\>str:  
pass  
defgetNumArgs(self)-\>int:  
pass  
defgetLen(self)-\>int:  
pass  
defcreateMsg(self)-\>None:  
pass

\`\`\`  
0 1 2 3 4 5 6 7 8 9  
\`\`\`  
\`\`\`  
10  
11  
12  
13  
14  
15  
16  
Fig. 4\. Target PL skeleton for the example  
in Figure 1-b.  
\`\`\`  
Automatically resolving types is a challenging problem \[ 23 ,  
55 \], and a large body of work has attempted to address  
this, mostly using symbolic rule-based approaches \[ 7 , 10 ,  
21 , 35 , 47 , 48 \].AlphaTransemploys a Retrieval-Augment  
Generation (RAG) \[ 37 \] technique for finding equivalent  
types in the target language. To that end, it first extracts  
all the types in the source language of a given project. Cus-  
tom application types are resolved during the translation  
asAlphaTranstranslates fragments and classes in the  
target language. For the remaining types, it crawls the API  
documentation of the source language and retrieves the  
relevant description of each type.  
To form the prompt,^3 AlphaTransuses the retrieved description and instructs the model with  
an in-context example to return the most relevant type in the target language, given the use of  
types in the source language and the retrieved description. To account for potential hallucination in  
LLM’s response, i.e., returning a type that does not exist in Python,AlphaTransemploys a simple  
Python script, uses the translated type as an annotation, executes the script, and keeps the ones  
that have no syntactic or runtime issue. The types in the source language and their corresponding  
in the target language form a data structure calleduniversal type mapping. In practice,AlphaTrans  
reuses or augments the mapping when translating new projects.

(^3) Due to space limit, we omit the prompt; please refer to our artifacts \[33\] to see the prompts used for type resolution.

\`\`\`  
FSE109:8 A. R. Ibrahimzada, K. Ke, M. Pawagi, M. S. Abid, R. Pan, S. Sinha, and R. Jabbarvand  
\`\`\`  
\`\`\`  
5.2 Skeleton Construction  
\`\`\`  
AlphaTransbuilds the project’s structure in the target language before translation. This step is  
necessary for compositional translation and validation, asAlphaTranscan insert the translated  
fragments into the project, compile it, or even execute the existing translated test suites, gradually  
completing the translation. At this step,AlphaTransalso resolves Java-specific features in Python  
before starting the translation. Specifically, it resolves circular imports and dependencies, inner  
classes, interfaces, and abstract classes. Figure 4 shows the class skeleton corresponding to the  
illustrative example of Figure 1-b.  
At the first step,AlphaTranscreates Python classes corresponding to each application class in  
Java. The fields in the classes are set toNone, andAlphaTransuses the information in schema (§4.2.1)  
to ensure the naming corresponds to the type of their access modifier in the source language. In the  
example of Figure 4, the translation of fieldprivate Option option;in Java is\_\_option: Option \=  
None. The classes also include method signatures, with their body set topass.AlphaTransuses  
the universal type mapping (§5.1) to create relevant types in the method signature. Once the initial  
skeleton is created,AlphaTransleverages the extracted call graph during program decomposition  
to detect circular dependencies. If such dependencies exist,AlphaTransresolves them with local  
imports. For inner classes,AlphaTransunfolds them in Python and usesdot notationto access  
specific methods and fields (e.g.,Class.methodName). Finally,AlphaTransimplements best practices  
in Python and subclasses all abstract classes and interfaces fromabc.ABCclass. Here,ABCis a class  
from theabcmodule in the Python standard library, which is used for defining abstract base classes.

\`\`\`  
6 Compositional Translation and Validation  
\`\`\`  
\`\`\`  
You are an AI programming assistant, utilizing the  
DeepSeek Coder model, developed by DeepSeek Company  
\`\`\`  
\`\`\`  
Persona  
\`\`\`  
\`\`\`  
Java Code: $ICL\_JAVA\_CODE  
Partial Python Translation: $ICL\_SKELETON  
Python Translation: $ICL\_PYTHON\_TRANSLATION  
\`\`\`  
\`\`\`  
ICL  
\`\`\`  
\`\`\`  
\#\#\# Instruction:  
Translate the following Java method to Python 3\.  
like the example above.  
\`\`\`  
\`\`\`  
Instruction  
\`\`\`  
\`\`\`  
Java Code: $SRC\_JAVA\_CODE  
Partial Python Translation: $CONSTRUCTED\_SKELETON  
\`\`\`  
\`\`\`  
Partial  
Translation  
\`\`\`  
\`\`\`  
\#\#\# Response:  
Python Translation:  
\`\`\`  
\`\`\`  
Response  
\`\`\`  
\`\`\`  
Fig. 5\. Prompt structure inAlphaTrans.  
\`\`\`  
\`\`\`  
AlphaTranstranslates method fragments in re-  
verse call order. It takes the project’s call graph, re-  
moves the back edges to make it acyclic, computes  
topological order (i.e., linear ordering of its vertices),  
and translates method fragments (corresponding  
to vertices) in reverse topological order. Field frag-  
ments are independent; therefore, AlphaTrans trans-  
lates them before method fragments. The algorithm  
takes a fragment𝐹, LLM𝑀, Skeleton𝑆,and a se-  
ries of parameters as inputs, translates the fragment,  
recomposes the skeleton with the successfully trans-  
lated fragment, and returns translation outcomes:  
(1) syntax check (denoted by the “non-parseable”  
and “parseable” labels), (2) functional equivalence  
check (denoted by the “graal-fail”, “graal-success”, and “graal-error" labels), and (3) translated test  
execution check (denoted by “not-exercised”, “test-fail”, and “test-success" labels).  
AlphaTransemploys iterative and feedback-based prompting. That is, if one of the mentioned  
checks fails, e.g., the translated fragment is not syntactically correct, it prompts the model for  
another translation. To control the number of iterations,AlphaTransuses a reprompting budget  
(repromptBudget). The algorithm takes the minimum (𝑚𝑖𝑛𝑏𝑢𝑑𝑔𝑒𝑡) and maximum (𝑚𝑎𝑥𝑏𝑢𝑑𝑔𝑒𝑡) values  
for the budget and dynamically sets reprompting budget to a number between the lower and upper  
bounds based on coverage information, e.g., the budget is close to𝑚𝑎𝑥𝑏𝑢𝑑𝑔𝑒𝑡for a fragment if it is  
exercised multiple times (high hit rate based on coverage information) by different unit tests. The  
rationale is to give more importance to fragments covered by more tests to eventually increase  
translation validation success.  
\`\`\`

\`\`\`  
A Neuro-Symbolic Compositional Approach for Repository-Level Code Translation and Validation FSE109:  
\`\`\`  
\`\`\`  
Algorithm 2:Main Translation Loop  
Inputs:Skeleton𝑆, Fragment𝐹, Model𝑀,𝑚𝑖𝑛𝑏𝑢𝑑𝑔𝑒𝑡,  
𝑚𝑎𝑥𝑏𝑢𝑑𝑔𝑒𝑡, and𝑡𝑜𝑝𝑘suspicious methods  
Output:Translation and Validation Outcome𝑇𝑉𝑂  
1 feedback← ∅;TVO← {};  
2 repromptBudget←  
𝑔𝑒𝑡𝐴𝑑𝑎𝑝𝑡𝑖𝑣𝑒𝐵𝑢𝑑𝑔𝑒𝑡(𝐹,𝑚𝑖𝑛𝑏𝑢𝑑𝑔𝑒𝑡,𝑚𝑎𝑥𝑏𝑢𝑑𝑔𝑒𝑡);  
3 whilerepromptBudget\> 0 do  
4 prompt←generatePrompt(F,feedback);  
5 translation←translateFragment(prompt,M);  
6 if\!𝑠𝑦𝑛𝑡𝑎𝑐𝑡𝑖𝑐𝐶ℎ𝑒𝑐𝑘(𝑡𝑟𝑎𝑛𝑠𝑙𝑎𝑡𝑖𝑜𝑛)then  
7 TVO\[”syntax\_outcome”\] ←”𝑛𝑜𝑛−𝑝𝑎𝑟𝑠𝑒𝑎𝑏𝑙𝑒”;  
8 feedback←getFeedback(translation);  
9 repromptBudget←repromptBudget− 1 ;  
10 𝑐𝑜𝑛𝑡𝑖𝑛𝑢𝑒;  
11 TVO\[”syntax\_outcome”\] ←”𝑝𝑎𝑟𝑠𝑒𝑎𝑏𝑙𝑒”;  
12 if\!𝑔𝑟𝑎𝑎𝑙𝐶ℎ𝑒𝑐𝑘(𝑡𝑟𝑎𝑛𝑠𝑙𝑎𝑡𝑖𝑜𝑛)then  
13 TVO\[”graal\_outcome”\] ←”𝑔𝑟𝑎𝑎𝑙−𝑓𝑎𝑖𝑙”;  
14 feedback←getFeedback(translation);  
15 repromptBudget←repromptBudget− 1 ;  
16 𝑐𝑜𝑛𝑡𝑖𝑛𝑢𝑒;  
17 else if𝑔𝑟𝑎𝑎𝑙𝐿𝑖𝑚𝑖𝑡𝑎𝑡𝑖𝑜𝑛(𝑡𝑟𝑎𝑛𝑠𝑙𝑎𝑡𝑖𝑜𝑛)then  
18 TVO\[”graal\_outcome”\] ←”𝑔𝑟𝑎𝑎𝑙−𝑒𝑟𝑟𝑜𝑟”;  
19 else  
20 TVO\[”graal\_outcome”\] ←”𝑔𝑟𝑎𝑎𝑙−𝑠𝑢𝑐𝑐𝑒𝑠𝑠”;  
21 if\!ℎ𝑎𝑠𝐸𝑙𝑖𝑔𝑖𝑏𝑙𝑒𝑇𝑒𝑠𝑡𝑠(𝐹)then  
22 TVO\[”test\_outcome”\] ←”𝑛𝑜𝑡−𝑒𝑥𝑒𝑟𝑐𝑖𝑠𝑒𝑑”;  
23 𝑏𝑟𝑒𝑎𝑘;  
24 𝑡𝑒𝑠𝑡𝑇𝑟𝑎𝑛𝑠𝑙𝑎𝑡𝑖𝑜𝑛←getTestTranslation(F);  
25 S←𝑆∪𝑡𝑟𝑎𝑛𝑠𝑙𝑎𝑡𝑖𝑜𝑛;  
26 if\!𝑡𝑒𝑠𝑡𝐶ℎ𝑒𝑐𝑘(𝑆,𝑡𝑒𝑠𝑡𝑇𝑟𝑎𝑛𝑠𝑙𝑎𝑡𝑖𝑜𝑛)then  
27 TVO\[”test\_outcome”\] ←”𝑡𝑒𝑠𝑡−𝑓𝑎𝑖𝑙”;  
28 repromptSuspiciousMethods(testTranslation,topK);  
29 repromptBudget←repromptBudget− 1 ;  
30 𝑐𝑜𝑛𝑡𝑖𝑛𝑢𝑒;  
31 TVO\[”test\_outcome”\] ←”𝑡𝑒𝑠𝑡−𝑠𝑢𝑐𝑐𝑒𝑠𝑠”;  
32 𝑏𝑟𝑒𝑎𝑘;  
33 returnTVO;  
\`\`\`  
Algorithm 2 shows the main translation and  
validation loop (lines 3–31), which runs until  
the reprompting budget is exhausted. Inside the  
loop,AlphaTransfirst crafts a unique prompt  
based on the template shown in Figure 5 and  
then instructs the LLM to translate the frag-  
ment (lines 4–5). It then validates the gener-  
ated translation in multiple steps. The first step  
checks for syntactic correctness and assigns  
proper labels toTVO(lines 6–10). Then,Alpha-  
Transleverages GraalVM for isolation-based  
validation of fragment𝐹(lines 12–20), if there  
exists a test in the source language covering  
the fragment during its execution.  
Finally, it translates and executes decom-  
posed fragment tests: if there are no eligible  
tests (a test becomes eligible if all its dependen-  
cies are translated) for the fragment,Alpha-  
Transsimply assigns the “not-exercised” label  
to the fragment and moves on to the next one  
(lines 21–23). Otherwise, it translates the tests,  
executes them to validate the fragment, and as-  
signs test outcome labels inTVO(lines 24–31).  
In case of a test failure,AlphaTransextracts all  
involved fragments and reprompts them with  
feedback extracted from test execution.  
Due to inherent intra- and inter-procedural  
dependencies in real-world projects, the num-  
ber of fragments involved in reprompting could  
be high, logarithmically increasing the transla-  
tion time.AlphaTransfilters out those with  
GraalVM label “graal-success”, ranks the re-  
maining based on suspiciousness score, and reprompts𝑡𝑜𝑝𝐾suspicious fragments. The suspi-  
ciousness score for fragments is calculated such that a fragment with more failing tests will get a  
higher score and, therefore, ranked higher among other fragments.  
Our prompt template consists offivedistinct parts (Figure 5). The first part is thepersonamessage  
used by DeepSeek-Coder-33b-Instruct during instruction fine-tuning and is required for producing  
the best outputs. The next part introduces theIn-Context Learning (ICL)example, which reflects  
the complexities of code translation and instructs LLM on how to deal with them. The green part  
shows the natural language instruction given to the model. After describing the objective, the  
prompt embeds the source Java code along withpartial translationas a skeleton, which includes all  
dependencies and translations of the fragments invoked by the current one. The prompt concludes  
with\#\#\# Response:keyword to guide the model for code generation.

\`\`\`  
6.1 Language Interoperability  
GraalVM \[ 43 , 60 \] is a Java Development Kit by Oracle. It offers thePolyglotAPI \[ 22 \], which  
allows the integration of programs written in different guest languages within a Java-based host  
application. In the context of this work, GraalVM allows execution of Python code from Java and  
\`\`\`

\`\`\`  
FSE109:10 A. R. Ibrahimzada, K. Ke, M. Pawagi, M. S. Abid, R. Pan, S. Sinha, and R. Jabbarvand  
\`\`\`  
vice versa \[ 3 \].AlphaTransleverages the Polyglot API to performin-isolationvalidation of the  
fragments by replacing the Java implementation of a method with its translated Python version  
while keeping the rest of the project in Java. It then executes the Java tests covering the fragment  
to validate the functional equivalence of the translation.  
The Polyglot API allows access to Python data objects from Java and vice-versa, as these objects  
reside in a shared memory space. However, objects must be cast to appropriate types for passing  
parameters to, and processing returned values from, polyglot calls. The Polyglot API can perform  
this casting implicitly for only a few simple data types.AlphaTransbuilds on top of the Polyglot  
API to provide a framework to create a Python program state that is isomorphic to the Java program  
state. The Python translation is restricted to this isomorphic state, and the states are synchronized  
after method calls to preserve the isomorphism.AlphaTransallows for the casting of user-defined  
types as well as several built-in and library types. Using both static and dynamic type information of  
Java objects,AlphaTranscan disambiguate target types when casting Python objects to Java types.  
It further preserves object identities and aliasing during such casting and propagates exceptions  
across language boundaries.  
To validate the translation of a method𝑚in isolation,AlphaTranscreates an instrumented  
version of the Java source code. We refer to this instrumented Java project as theprimal project,𝑃𝑚.  
During instrumentation,AlphaTransreplaces the original Java implementation,𝑚𝐽of𝑚with  
a polyglot call to its Python implementation,𝑚𝑃.𝑚𝑃resides inside a Python project, which we  
refer to as thedual project,𝐷𝑚. The structure of𝐷𝑚is similar to that of the original Java project.  
All other methods in𝐷𝑚wrap a call to the corresponding methods in𝑃𝑚. Doing so provides an  
interface for𝑚𝑃to execute with access to all other methods and fields, although these are defined  
only in𝑃𝑚. Using the call graph for the Java project,AlphaTransdetermines all test methods  
that invoke𝑚and executes them in𝑃𝑚to validate the translation𝑚𝑃. Thisin-isolationvalidation  
approach is limited in the sense that it can handle only a limited number of built-in and library  
types. In certain cases, such as reference cycles involving maps or objects with impure methods for  
hashing, the isomorphism between Java and Python states may not be maintained. Furthermore, it  
may sometimes not be possible to disambiguate target types when casting Python objects to Java  
types, for example, if the target object has typeList\<Object\>.

\`\`\`  
6.2 Target Program Recomposition  
\`\`\`  
AlphaTransrecomposes the project skeleton with syntactically correct translated fragments at  
each iteration of Algorithm 1, gradually constructing the project in the target PL. The recomposed  
target program in Python is executed against eligible translated tests, i.e., those that cover only the  
translated fragments.

6.3 Test Translation  
Similar to translating application fragments,AlphaTransalso translates test fragments. Using  
the dependency information captured during static analysis, it crafts prompts for unit tests along  
with their dependencies for the model to translate. The ICL examples used for prompting test  
fragments differ from prompts used for translating application method fragments. The focus of ICL  
examples here is to prevent the LLM from hallucinating the used assert statements in the source  
PL to the target PL. To construct ICL examples for test fragment translation, we created a pool of  
in-context examples, where each example shows the Python assert statements equivalent to Java  
assert statements in the context of a test. When prompting a test fragment,AlphaTransdetects  
the assert statement in the fragment and retrieves the corresponding examples from the pool. For  
translated tests, only syntactic validation is performed as there is no other means of validating  
their translations.

\`\`\`  
A Neuro-Symbolic Compositional Approach for Repository-Level Code Translation and Validation FSE109:  
\`\`\`  
\`\`\`  
7 Empirical Evaluation  
To evaluate different aspects ofAlphaTrans, we investigate the following research questions:  
\`\`\`  
RQ1:Effectiveness ofAlphaTrans. To what extentAlphaTranscan automatically resolve types  
from source to target PL? CanAlphaTranseffectively translate real-world projects?  
RQ2:Translation Bugs and Fixes. How much effort do developers spend completing the partial  
translations byAlphaTrans? What is the nature of translation bugs?  
RQ3:Impact of Test Decomposition. What is the impact of test decomposition on validation results?  
RQ4:Impact of Test Coverage. To what extent does a test suite with higher coverage impact the  
validation results?  
RQ5:Ablation Study. To what extent do program transformation, choice of LLM, and program  
decomposition impact the performance ofAlphaTrans?  
7.1 Experiment Setup  
We followed three steps for selecting subjects:1- Mining:We mined GitHub and retrieved a list of  
repositories that use Java as the primary language, are self-contained (include build files, etc.), and  
have more than 30 stars with at least one commit pushed within the last 12 months.2- Filtering:  
We filtered out projects based on the number of call edges in their call graphs: removed those with  
less than 2 , 000 call edges to ensure the subject projects are big enough to challengeAlphaTrans.  
We also removed those with more than 30 , 000 call edges to reduce the computation and manual  
effort for further steps. Per GraalVM requirements, we only selected projects we could successfully  
build (compile and achieve green tests) using Java at 21 .3- Reduction:AlphaTranscurrently  
supports the following Java APIs: core Java API (java.util,java.text,java.lang,java.io,java.nio,  
java.net,java.time, andjava.math) and third-party libraries (org.opentest4j,org.slf4j.Logger,  
andorg.junit). We automatically removed all other third-party library dependencies and their  
usage in the source code in the selected projects. We chose a project if at least50%of its total  
methods were preserved after such process. Table 1 shows the list of ten projects used in the  
evaluation ofAlphaTransand details about their size (classes, methods, tests, and fragments).  
AlphaTransuses CodeQL \[ 20 \] and tree-sitter \[ 59 \] for static analysis. For running tests, validating  
translation, and computing coverage,AlphaTransuses GraalVM 21\. 0\. 3 \+ 7\. 1 \[ 43 \], JUnit 4 and  
5 \[ 54 \], Pytest 8.2.1 \[ 46 \], JaCoCo \[ 53 \], and Python’scoverage\[ 6 \].AlphaTransworks with API-  
and open-access LLMs. We considered the following criteria for selecting the LLM: (1) for better  
reproducibility, we prioritized open-access models; (2) due to computing constraints, we wanted an  
LLM with moderate size (\> 10 𝐵but\< 70 𝐵parameters); (3) the model should perform reasonably  
well in code-related tasks; and (4) the model should have fast inference time due to the huge number  
of prompts. Per the mentioned criteria, we selected DeepSeek-Coder-33b-Instruct \[ 24 \] for the main  
experiments (RQ1–RQ4). We also used GPT-4o, one of the best-performing commercial models,  
for RQ5 (§7.6) to demonstrate the impact of stronger models on improving the performance of  
AlphaTrans. We prompted models with the temperature set to 0 for reproducibility and used their  
default settings for other parameters. For the base prompting (Algorithm 2), we set the minimum  
and maximum values of the reprompting budget to 3 and 5\. For the feedback prompting, we set the  
reprompting budget to 1 , i.e.,AlphaTransattempts to fix issues with feedback only once.

\`\`\`  
7.2 RQ1: Effectiveness ofAlphaTrans  
In this RQ, we evaluateAlphaTransin (1) type translation and skeleton construction (§7.2.1) and  
(2) compositional translation and validation (§7.2.2).  
\`\`\`  
\`\`\`  
7.2.1 Effectiveness in Type Resolution and Skeleton Validation:AlphaTransextracted 1 , 797 distinct  
types from the source projects and attempted to translate them to equivalent Python types. Of  
\`\`\`

\`\`\`  
FSE109:12 A. R. Ibrahimzada, K. Ke, M. Pawagi, M. S. Abid, R. Pan, S. Sinha, and R. Jabbarvand  
\`\`\`  
\`\`\`  
Table 1\. Effectiveness ofAlphaTransin program transformation, automated type translation, and skeleton  
validation.ATR:Automated Types Resolution,SV:Skeleton Validation. The number of classes and methods  
include both application and test classes/methods.  
\# Fragments  
Subjects \# Classes \# Methods\# JUnitTestsCoverage (%)Method ATR (%) SV (%) Fields  
Application Test  
\`\`\`  
\`\`\`  
Application  
Methods  
\`\`\`  
\`\`\`  
Test  
Methods  
cli \[11\] 58 664 437 94.14 96.60 100 104 57 273 2180  
codec \[12\] 156 1780 992 91.03 96.01 100 425 140 680 2849  
csv \[13\] 41 694 309 90.64 92.34 100 146 35 235 1272  
exec \[14\] 56 407 70 54.84 78.90 100 104 27 248 327  
fast-pfor \[36\] 82 971 82 54.55 87.40 100 127 14 748 302  
fileupload \[15\] 49 381 39 13.02 98.31 100 121 39 192 194  
graph \[16\] 118 879 146 58.78 97.13 100 216 29 541 975  
jansi \[51\] 48 474 107 23.47 84.83 100 378 0 409 123  
pool \[17\] 98 1097 73 22.29 91.60 100 203 91 682 649  
validator \[18\] 130 1228 464 63.31 95.51 100 421 209 646 1463  
Total 836 8575 2719 56.57 91.99 100 2245 641 4654 10334  
\`\`\`  
these, 915 are application types (i.e., classes defined within the Java projects) and were directly  
resolved during skeleton construction.AlphaTransprompts DeepSeek-Coder-33b-Instruct to  
resolve the remaining 882 and successfully translated 738 (( 915 \+ 738 )/ 1 , 797 \= 91 .99%)of them:  
the generated types passed the syntactic and runtime check. The columnATRin Table 1 shows  
the results of automated type resolution. Because type resolution is essential to project skeleton  
construction, we manually checked the type mappings generated by DeepSeek-Coder-33b-Instruct  
and also translated the 144 unresolved types.  
Through manual investigation of the automatically resolved types, we observed that DeepSeek-  
Coder-33b-Instruct’s type resolution for 182 cases, whilecorrect, can beimproved. For example,  
AlphaTranstranslatedjava.io.File, a class concerning file manipulation functionality tostr. The  
resolved type can represent file paths in Python but lacks features for file manipulation. We suspect  
this translation is impacted by the Java use case provided in the prompt. While this translation is  
correct for the use case, we replaced it withpathlib.Pathto have a more generic type mapping.  
We also augmented the type mapping with additional types in the target language for 38 types.  
For example,AlphaTranstranslatedjava.nio.Buffertobytearray, which is correct as they both  
provide a mutable sequence of bytes with efficient in-place modifications. However,array.array  
andmemoryviewalso provide similar functionality with efficient and low-level data manipulation  
capabilities. Consequently, we augmented type mapping totyping.Union\[bytearray, array.array,  
memoryview\]. Given that type mapping can be reused, this one-time manual effort increases the  
chance ofAlphaTrans’s success on unseen projects.  
Using the universal type mapping,AlphaTranssuccessfully creates and validates project  
skeletons in the target PL, achieving100%syntax and runtime validation (columnSVin Table 1).  
The skeleton validation step ensures all module imports, class structures, method signatures, and  
type annotations are done properly, making the subsequent steps easier. ApplyingAlphaTransto  
unseen projects, if a class skeleton cannot be validated,AlphaTransremoves it from the target  
project, updates the skeleton based on the class dependencies, and proceeds to the next phase.

\`\`\`  
Summary.AlphaTranscan successfully transform projects to remove method and con-  
structor overloading. Moreover, it can automatically translate 91 .99%of the source PL types  
and use that to create and validate project skeletons in the target PL.  
\`\`\`  
\`\`\`  
7.2.2 Effectiveness in Compositional Translation and Validation:Table 2 shows the compositional  
translation and validation results. TheAMFcolumn indicates the total number of application method  
fragments. The numbers in subsequent columns demonstrate the effectiveness ofAlphaTransin  
\`\`\`

\`\`\`  
A Neuro-Symbolic Compositional Approach for Repository-Level Code Translation and Validation FSE109:  
\`\`\`  
\`\`\`  
Table 2\. Effectiveness ofAlphaTransin repository-level code translation. Abbreviations in the table stand  
forAMF: \#Application Method Fragments,SNEF: Source Non-Exercised Fragments,GS: Graal Success,GF:  
Graal Fail,GE: Graal Error,TNEF: Target Non-Exercised Fragments,ATP: Fragments All Test Pass,OTF:  
Fragments One Test Fail,MTF: Fragments Many Test Fail,ATF: Fragments All Test Fail,TPR: Test Pass Rate,  
O: Overall,RE: Runtime Error,AF: Assertion Failure, andM1: Number ofAMFsthat GraalVM could not  
execute (GE) but translated test fragments exercised.  
GraalVM Test Translation  
Subjects AMF OTF (%) MTF (%) ATF (%) M  
\`\`\`  
\`\`\`  
Syntax  
Check  
(%)  
\`\`\`  
\`\`\`  
SNEF  
(%) GS (%) GF (%) GE (%)TNEF(%) ATP(%) O RE AF O RE AF O RE AF TPR(%) All Some  
cli 273 100 5.86 70.70 11.72 11.72 35.90 8.42 10.62 51.72 48.28 32.23 91.07 8.93 6.96 100 0 10.08 0 16  
codec 680 98.53 8.97 38.38 32.50 20.15 65.59 4.12 4.41 60.00 40.00 12.79 55.11 44.89 4.12 75.21 24.79 9.43 11 27  
csv 235 98.72 9.36 38.72 26.81 25.11 74.47 0 13.62 96.88 3.13 0 0 0 2.55 100 0 0 0 3  
exec 248 100 45.16 33.47 2.02 19.35 34.27 4.44 2.02 40.00 60.00 7.26 93.36 6.64 6.85 100 0 19.29 6 9  
fast-pfor 748 95.32 45.45 12.03 24.20 18.32 41.71 4.28 1.74 84.62 15.38 3.74 79.23 20.77 3.07 85.88 14.12 20.08 6 25  
fileupload 192 100 86.98 8.85 1.04 3.13 1.56 3.65 6.77 30.77 69.23 1.04 91.67 8.33 0 0 0 63.44 2 3  
graph 541 99.63 41.22 24.77 22.92 11.09 57.12 0 0.92 100 0 0.18 100 0 0.55 100 0 11.04 0 1  
jansi 409 99.76 76.53 8.07 11.49 3.91 22.25 0.24 0.98 100 0 0 0 0 0 0 0 1.07 0 1  
pool 682 100 77.71 6.01 1.32 14.96 19.35 1.61 1.03 100 0 0.29 100 0 0 0 0 6.62 4 2  
validator 646 99.23 36.69 30.50 11.15 21.67 46.44 3.25 5.42 71.43 28.57 4.18 84.50 15.50 4.02 99.12 0.88 11.70 1 31  
Total 4654 98.80 43.43 24.50 16.23 15.84 41.92 2.88 3.72 70.52 29.48 5.44 82.77 17.23 2.62 92.86 7.14 9.76 30 118  
\`\`\`  
the translation and validation ofAMFs only.^4 TheSyntax Checkcolumn indicates the percentage  
ofAMFs that pass syntactic validation. ColumnSNEFshows the percentage ofAMFs not covered  
by source project tests.AlphaTranssuccessfully generates syntactically correct code ( 98 .80%of  
AMFs and 96 .40%of all fragments—field, application, and test fragments—across ten subjects). We  
also observe that 43 .43%ofAMFs are not covered during the execution of any test, i.e., we cannot  
go beyond syntactic check and validate their runtime behavior or functional equivalence.  
For 56 .57%of theAMFs that are covered by source project tests,AlphaTransattempts to validate  
their functional equivalence using GraalVM. Multi-columnGraalVMshows the percentage ofAMFs  
that GraalVM executes and successfully validates (GS), executes but there is a test assertion failure  
(GF), and cannot execute due to its limitation (GE) mentioned in §6.1. 24 .50%(min= 6 .01%and  
max= 70 .70%), 16 .23%(min= 1 .04%and max= 32 .50%), and 15 .84%(min= 3 .13%and max= 25 .11%) of  
AMFsresulted inGraal Success,Graal Fail, andGraal Error, respectively. Note that these numbers  
add up to 56 .57%ofAMFsthat were covered by source project tests. With respect to only covered  
methods, GraalVM Success is 43 .30%. Furthermore, our analysis shows that a high portion of  
methods that are not covered by tests are either abstract methods or getter/setter methods. If  
their translations are syntactically correct, they are also likely functionally equivalent, which can  
ramp up the success rate (§7.5). Spearman Rank Order Correlation \[ 52 \] indicates a strong positive  
correlation between method coverage (Table 1\) andGSnumbers (𝜌= 0\. 92 ), confirming that with  
better method coverage, validatedAMFs are very likely to be higher.  
Regardless of GraalVM’s validation for functional equivalence,AlphaTranstranslates and  
executes the test fragments on the recomposed translated project. TheTest Translationmulti-  
column shows the results of test translation and execution. ColumnTNEFindicates the ratio of  
AMFs where execution of translated tests never reached them. ColumnsATPthroughATFshow  
the number ofAMFsthatAlphaTransexecuted using translated test fragments, categorized per  
the test execution results. For 2 .88%of theAMFs, all the test fragments that covered them were  
marked as pass (ATP). For 3 .72%and 5 .44%, at least one test (OTF) or more than one test (MTF)  
failed. All the test fragments failed for 2 .62%of theAMFs. Note that these numbers (TNEF, ATP,  
OTF, MTF, and ATF) add up to 56 .57%of the AMFs that are covered by source project tests.  
For cases with test failure, columnsREandAFshow the breakdown of whether test failure was  
due to assertion failure or runtime error. We can observe that most test executions terminated

(^4) Please refer to our artifact \[33\] for details of all the translation and validation of other fragments shown in Table 1\.

\`\`\`  
FSE109:14 A. R. Ibrahimzada, K. Ke, M. Pawagi, M. S. Abid, R. Pan, S. Sinha, and R. Jabbarvand  
\`\`\`  
with a runtime error due to translation bugs and never reached an assert statement.Our manual  
investigation confirms that a high rate of runtime errors is due to a relatively small number of fragments  
with translation bugs.Although test decomposition helps withtest translation coupling effect(§2),  
there is still a high degree of runtime errors due to long call chains in these projects (the average  
number of methods executed per test in the original and decomposed test suites are 27\. 4 and 21\. 8 ,  
respectively). As a result, the overall pass rate, i.e., the percentage of recomposed test fragments for  
the translated projects that pass (columnTPR), is low. These results also confirm the necessity of  
in-isolation testing through language interoperability byAlphaTrans.  
We also calculated the number ofAMFsthat GraalVM could not execute (numbers underGE  
column) but translated test fragments exercised (columnM1).Allindicates the number ofAMFs  
with all passing tests, including test fragments with assert statements, indicating the validation of  
functional equivalence (with respect to the source project tests).Somecorresponds to the number  
ofAMFs with at least one passing test, which indicates runtime validation. Overall, test translation  
validates the functional correctness and runtime behavior of 30 and 118 fragments that GraalVM  
could not exercise.  
Finally, we analyzed translations using PyLint \[ 2 \], which scores Python files on a scale of 0  
to 10 based on how Pythonic the code is. AllAlphaTranstranslations achieved scores of 10 ,  
mainly because (1) LLMs inherently generate idiomatic code and (2) AlphaTrans uses Black \[ 1 \]  
for formatting the translations extracted from the LLM response. These results confirm that the  
translations are all Pythonic, i.e., they adhere to Python coding standards and best practices.

\`\`\`  
Summary.AlphaTranseffectively performs compositional translation and validation of  
17 , 874 fragments, achieving overall 96 .40%syntactic correctness ( 98 .80%for AMFs), 27 .03%  
runtime behavior validation (GS+M1 Some), and 25 .14%functional equivalence (GS+M1 All).  
\`\`\`  
\`\`\`  
7.3 RQ2: Translation Bugs and Fixes  
\`\`\`  
We investigated the manual effort for fixing translation bugs in a subset of studied subjects, namely  
Commons-FileUpload,Commons-CLI,Commons-CSV, andCommons-Validator. We also discuss some  
of the translation bugs and fixes for them to better illustrate the challenges in code translation.  
7.3.1 Human Study.Our two human subjects were selected due to their relative familiarity with  
the selected projects. Their effort indicates an upper bound for the amount of time required to fix  
translation bugs since developers of the source projects are likely to fix the bugs better and faster.  
We shared with them the source program in Java, the translations byAlphaTrans, and all the  
reports and artifacts generated byAlphaTransduring translation.  
ForCommons-FileUpload, achieving green tests took 5\. 5 hours and required 120 and 114 line  
additions and deletions from partial translations. ForCommons-CLI, the manual fix took 11 hours,  
making 614 and 1 , 253 line additions and deletions, respectively. The project was very dense for  
Commons-CSV, with many method calls, making it harder to manually fix bugs. Nevertheless, a  
developer achieved all green tests in 30 hours with 2 , 676 and 999 line additions and deletions,  
respectively. Finally, forCommons-Validator, the developer spent 34 hours to fix translation bugs,  
with 3 , 585 and 2 , 416 line additions and deletions, respectively. One of the major feedback from  
developers was that test decomposition greatly helped locate and fix translation bugs: in case of a  
test failure, developers only need to investigate the last call statement in the failed test fragment  
instead of looking at the stack trace and other prior calls.  
7.3.2 Translation Bugs.Our artifacts \[ 33 \] contain partial translations and fixed versions as separate  
commits. These commits can serve as useful benchmarks for evaluating fault localization, program  
repair, and test generation techniques. This section showsfourinstances of such translation bugs.

\`\`\`  
A Neuro-Symbolic Compositional Approach for Repository-Level Code Translation and Validation FSE109:  
\`\`\`  
\`\`\`  
The two most prevalent sources of translation bugs are mismatches between APIs and behavioral  
differences in the PLs. The code snippet below demonstrates a bug that happened due to a mismatch  
in the logic ofCalendar( Java) anddatetime(Python). Line 3 in Java sets theMONTHfield to 0 , which  
corresponds to the first month of the year (January). Similarly, the Python translation sets the  
monthattribute to 0 ; however, in the Python library, January corresponds to value 1 formonth.  
\`\`\`  
1 \----------- JAVA SOURCE CODE \-----------  
2 Calendar calendar \= Calendar.getInstance()  
3 calendar.set(Calendar.MONTH, 0);

\`\`\`  
1 \---------- PYTHON TRANSLATION \----------  
2 calendar \= datetime.datetime.now()  
3 \- calendar \= calendar.replace(month=0)  
4 \+ calendar \= calendar.replace(month=1)  
The next example shows the difference in implicit type casting between the two Pls. Line 5 in Java  
source code concatenates aStringvalue withnull. During execution, Java runtime silently casts  
nullto aStringand then performs the concatenation operation on it. In Python, concatenating an  
strwithNoneresults in aTypeErroras the operands of the binary operation has different types. A  
correct Python translation requires explicit casting ofNonetostras shown in Line 5\.  
\`\`\`  
1 \----------- JAVA SOURCE CODE \-----------  
2 qChar \= "'";  
34 nullStr \= \*\*null\*\* ;  
5 \*\*this\*\* .qNullStr \= qChar \+ nullStr \+ qChar;

\`\`\`  
1 \---------- PYTHON TRANSLATION \----------  
2 qChar \= "'"  
\`\`\`  
(^34) \- self.qNullStr \= qChar \+ nullStr \+ qCharnullStr \= \*\*None\*\*  
5 \+ self.qNullStr \= qChar \+ str(nullStr) \+ qChar  
The third example shows an instance ofwrite(int b)method fromByteArrayOutputStreamclass,  
where the least significant 8 bits of the integer(b2 « 4\) | (b3 » 2)are directly written to the  
stream. The incorrect Python translation attempts to construct abytesobject using a singleton  
list with the input integer before writing it to an object of typeio.BytesIO. However, this neglects  
that thebytes()constructor requires the integers in the input iterable to be strictly in the range of  
\[0, 255\]. Thereby, aValueErroris thrown whenb2is large. The correct translation requires0xF, a  
mask that maintains only the 4 lowest bits ofb2before left-shifting by 4 as shown in Line 3 under  
Python translation. Given thatb3andb4each contain no more than 8 bits, this change ensures the  
least significant 8 bits of(b2 « 4\) | (b3 » 2)are correctly written to theBytesIOobject.  
12 \----------- JAVA SOURCE CODE \-----------  
3 out.write((b2 \<\< 4\) | (b3 \>\> 2));  
1 \---------- PYTHON TRANSLATION \----------  
2 \- out.write(bytes(\[(b2 \<\< 4\) | (b3 \>\> 2)\]))  
3 \+ out.write(bytes(\[((b2 & 0xF) \<\< 4\) | (b3 \>\> 2)\]))  
The last code snippet demonstrates the Java behavior of an iterator that is unavailable in Python.  
The incorrect Python translation usesnext()to implement bothnext()andhasNext()methods  
of the Javajava.util.Iteratortype. However, callingnext()increments the iterator in Python.  
The correct translation should implementPeekableIteratorinterface in Python with a method  
hasNext() \-\> bool.  
1 \----------- JAVA SOURCE CODE \-----------  
23 Iterator\<String\> headers \= ls.keySet().iterator();  
45 assertEquals("content", headers.next());  
6 assertFalse(headers.hasNext());  
1 \---------- PYTHON TRANSLATION \----------  
2 \- headers \= iter(ls.keys())  
3 \+ headers \= PeekableIterator(ls.keys())  
4 self.assertEqual("content", next(headers))  
5 \- self.assertFalse(next(headers, \*\*None\*\* ) \*\*is not None\*\* )  
6 \+ self.assertFalse(headers.hasNext())  
Implications.To obtain correct translation, especially for code using library APIs, models need  
to generate test cases as well that can validate the translated fragment in isolation. This could  
be an interesting direction for applying an agentic approach, where the orchestrating agent can  
decide when to generate test cases, and the test case generator agent gets all the information by  
running static analysis tools, gathering context from previous runs, collecting API documentation  
by crawling the internet, and finally generating the translation based on all the information.  
Summary.AlthoughAlphaTranscannot validate all the translations, it provides partial  
translations and artifacts that developers can use to complete the translation and achieve  
green tests in a reasonable time (20.1 hours, on average).

\`\`\`  
FSE109:16 A. R. Ibrahimzada, K. Ke, M. Pawagi, M. S. Abid, R. Pan, S. Sinha, and R. Jabbarvand  
\`\`\`  
\`\`\`  
7.4 RQ3: Impact of Test Decomposition  
\`\`\`  
We previously showed the effectiveness of test translation in validating the runtime behavior or  
functional correctness of translated method fragments (§7.2.2). To better understand how test  
decomposition helps addresstest translation coupling effect, we collected translated unit tests with  
at least two decomposed test fragments. We further applied filtering and kept only those tests for  
whichalltheir decomposed fragments were executed, regardless of passing or failing outcomes.  
The yellow bars in Figure 6 show the percentage of selected unit tests from the translated test suites.  
None of the tests met the criteria forCommons-CSV, so we excluded it from further investigation.

\`\`\`  
cli codecexecfast-pfor  
fileuploadgraphjansipoolvalidator  
Projects  
\`\`\`  
\`\`\`  
0  
\`\`\`  
\`\`\`  
25  
\`\`\`  
\`\`\`  
50  
\`\`\`  
\`\`\`  
75  
\`\`\`  
\`\`\`  
100  
\`\`\`  
\`\`\`  
Ratio in test suite (%)  
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
100  
\`\`\`  
\`\`\`  
Tests with min. 2 fragments (%)  
\`\`\`  
\`\`\`  
Ratio Selected Fail Success Pass Rate Mean Median  
\`\`\`  
\`\`\`  
Fig. 6\. Effectiveness of test decomposition inAlpha-  
Transfor validating earlier fragments in failing tests.  
\`\`\`  
We categorized the selected unit tests into  
two groups: those with all passing test frag-  
ments (green bars in Figure 6\) and those with  
at least one failing test fragment (red bars in  
Figure 6). For the unit tests in the latter group,  
we calculated the pass rate of thedecomposed  
test fragments. The blue box chart in Figure 6  
shows the distribution of the measured pass  
rate per unit test. These unit tests would have  
been marked asfailwithout test decomposition.  
However, we can observe that these tests can  
be decomposed into test fragments such that  
62 .41%of them pass. These results indicate how decomposed test fragments were useful in helping  
developers localize translation bugs more easily and resolve translation bugs faster.

\`\`\`  
Summary.Test decomposition unburdens validation of translated method fragments from  
incorrect translations. 62 .41%of test fragments for unit tests that would have been marked  
as failed achieved passing outcomes.  
\`\`\`  
\`\`\`  
7.5 RQ4: Impact of Test Coverage  
\`\`\`  
Although existing developer-written tests are useful for checking functional equivalence, they  
can pose two major issues for automated code translation and validation. First, the coverage  
for these tests can be extremely low (e.g., 13 .02%for Commons-FileUpload \[ 15 \] as reported in  
Table 1), preventing most of the code from being validated; as our investigation of RQ1 showed,  
the translation validation rate strongly correlates with test suites’ (method) coverage. Second, a  
developer-written test can have a long call sequence. To show the positive impact of more-focused  
tests with higher coverage on translation validation, we automatically generated additional tests  
using EvoSuite \[ 19 \]. We used default tool configuration with a time budget of 120 seconds per class.  
Table 3 compares properties of the developer-written and EvoSuite-generated tests. Evosuite  
tests cover more methods than the developer-written test suite ( 66 .87%Method Coveragecompared  
to 56 .57%). Furthermore, the average number of methods executed per single test is almost half that  
of decomposed test suites ( 11\. 41 compared to 21\. 84 methods). To demonstrate the impact of test  
quality onAlphaTrans’s overall performance, we translated and executed the EvoSuite-generated  
tests. Corroborated by the numbers underTPR+andATP+columns, we can see that augmenting  
the test suite increases the method coverage, and thereby, the TPR and ATP numbers from RQ  
by 5 .85%and 2 .11%, respectively. Not all EvoSuite tests have assertions, and even if they do, the  
quality of the assertions could be lower compared to developer-written tests (e.g., checking trivial  
properties with weak fault detection ability). Nonetheless, the higherTPRandATPof such tests  
enhance runtime validation, which is still promising in code translation. EvoSuite is incompatible

\`\`\`  
A Neuro-Symbolic Compositional Approach for Repository-Level Code Translation and Validation FSE109:  
\`\`\`  
\`\`\`  
Table 3\. Effectiveness of test augmentation in exercising and validating more application method fragments.  
Abbreviations in the table stand forATP: Fragments All Test Pass andTPR: Test Pass Rate. ATP+ and TPR+  
demonstrate ATP and TPR gain through test augmentation.  
Developer-Written Test EvoSuite Test  
Subjects Method  
Coverage (%)  
\`\`\`  
\`\`\`  
\# Decomposed  
Tests  
\`\`\`  
\`\`\`  
Avg. Methods  
Executed / Test  
\`\`\`  
\`\`\`  
TPR  
(%)  
\`\`\`  
\`\`\`  
ATP  
(%)  
\`\`\`  
\`\`\`  
Method  
Coverage (%)\# Tests  
\`\`\`  
\`\`\`  
Avg. Methods  
Executed / Test  
\`\`\`  
\`\`\`  
TPR+  
(%)  
\`\`\`  
\`\`\`  
ATP+  
(%)  
cli 94.14 3036 34.25 10.08 8.42 95.97 569 12.15 2.99 1\.  
codec 91.03 3522 10.56 9.43 4.12 80.74 1141 8.02 3.51 0\.  
csv 90.64 1219 52.62 0 0 74.04 220 39.16 0 0\.  
exec 54.84 311 18.99 19.29 4.44 61.29 245 6.32 3.27 1\.  
fast-pfor 54.55 249 41.62 20.08 4.28 39.17 1843 4.31 5.59 1\.  
fileupload 13.02 93 3.54 63.44 3.65 70.31 231 5.29 11.26 2\.  
graph 58.78 933 25.02 11.04 0.00 76.71 800 9.00 5.13 0\.  
jansi 23.47 187 13.57 1.07 0.24 51.83 332 9.08 3.31 0\.  
pool 22.29 287 6.52 6.62 1.61 37.24 394 7.36 10.41 2\.  
validator 63.31 1479 11.68 11.70 3.25 81.42 1305 13.43 9.73 7\.  
Total 56.57 11316 21.84 9.76 2.88 66.87 7080 11.41 5.85 2\.  
\`\`\`  
\`\`\`  
Table 4\. Importance of program transformation. Abbreviations in the table stand forAMF: \#Application  
Method Fragments,SNEF: Source Non-Exercised Fragments,GS: Graal Success,GF: Graal Fail,GE: Graal  
Error,TNEF: Target Non-Exercised Fragments,ATP: Fragments All Test Pass,OTF: Fragments One Test Fail,  
MTF: Fragments Many Test Fail,ATF: Fragments All Test Fail, andTPR: Test Pass Rate.  
GraalVM Test Translation  
Subjects AMF SNEF(%) GS  
(%)  
\`\`\`  
\`\`\`  
GF  
(%)  
\`\`\`  
\`\`\`  
GE  
(%)  
\`\`\`  
\`\`\`  
TNEF  
(%)  
\`\`\`  
\`\`\`  
ATP  
(%)  
\`\`\`  
\`\`\`  
OTF  
(%)  
\`\`\`  
\`\`\`  
MTF  
(%)  
\`\`\`  
\`\`\`  
ATF  
(%)  
\`\`\`  
\`\`\`  
TPR  
(%)  
cli 276 5.80 0 0 94.20 85.51 0 2.17 1.09 5.43 0\.  
codec 678 10.62 0 0 89.38 72.86 2.06 5.46 2.80 6.19 5\.  
csv 235 8.51 0 0 91.49 88.09 0.43 0.43 0.85 1.70 0\.  
exec 253 46.25 26.88 4.35 22.53 49.41 1.58 1.19 0 1.58 4\.  
fast-pfor 754 46.02 0 0 53.98 38.20 0.93 6.63 0.80 7.43 4\.  
fileupload 168 85.12 10.71 0.60 3.57 8.93 1.19 2.98 1.19 0.60 23\.  
graph 556 40.65 0 0 59.35 56.12 0 1.98 0.36 0.90 5\.  
jansi 314 69.75 0 0 30.25 29.94 0 0.32 0 0 0  
pool 574 70.56 0 0 29.44 27.00 1.39 0 0.35 0.70 5\.  
validator 623 33.39 18.78 20.06 27.77 66.29 0 0 0.32 0 0\.  
Total 4431 40.01 4.58 3.09 52.31 52.79 0.81 2.57 0.86 2.96 3\.  
\`\`\`  
with Java 21 , and hence GraalVM, which prevented us from using Evosuite-generated tests in  
AlphaTrans. We anticipate that incorporating it inAlphaTranscould improve the overall quality  
of translations.

\`\`\`  
Summary.Augmenting the existing test suite increases code coverage, thereby exercising  
and validating more AMFs. Test augmentation can further validate the correctness of 2 .11%  
of fragments not executed by developer tests. The generated tests are more focused and, on  
average, invoke48%fewer methods than the developer-written tests.  
\`\`\`  
\`\`\`  
7.6 RQ5: Ablation Study  
\`\`\`  
We performed three ablation studies to investigate the impact of program transformation, choice  
of LLM, and program decomposition on the performance ofAlphaTrans.

7.6.1 Impact of Program Transformation.We removed the program transformation component of  
AlphaTransand executed the entire pipeline. The results in Table 4 show that without transfor-  
mation (e.g., resolving method/constructor overloading), the performance ofAlphaTransdrops  
significantly:GS,ATP, andTPRvalues decreased to 4 .58%(from 24 .50%), 0 .81%(from 2 .88%), and  
3 .05%(from 9 .76%), respectively. This is because Python does not support overloading and only  
considers the last method/constructor implementation, resulting in runtime errors or test failures.  
Also,GEvalues increase due to the interference of overloaded code constructs with GraalVM.

\`\`\`  
FSE109:18 A. R. Ibrahimzada, K. Ke, M. Pawagi, M. S. Abid, R. Pan, S. Sinha, and R. Jabbarvand  
\`\`\`  
\`\`\`  
Table 5\. Effectiveness ofAlphaTranswith GPT-4o in compositional translation and validation. Abbreviations  
in the table stand forAMF: \#Application Method Fragments,SNEF: Source Non-Exercised Fragments,GS:  
Graal Success,GF: Graal Fail,GE: Graal Error,TNEF: Target Non-Exercised Fragments,ATP: Fragments All  
Test Pass,OTF: Fragments One Test Fail,MTF: Fragments Many Test Fail,ATF: Fragments All Test Fail,TPR:  
Test Pass Rate,O: Overall,RE: Runtime Error,AF: Assertion Failure, andM1: Number ofAMFsthat GraalVM  
could not execute (GE) but translated test fragments exercised.  
GraalVM Test Translation  
Subjects OTF (%) MTF (%) ATF (%) M  
\`\`\`  
\`\`\`  
Syntax  
Check  
(%)  
\`\`\`  
\`\`\`  
SNEF  
(%) GS (%) GF (%) GE (%)TNEF(%) ATP(%) O RE AF O RE AF O RE AFTPR(%) All Some  
\`\`\`  
\`\`\`  
Cost  
($)  
cli 99.63 5.86 76.92 8.79 8.42 78.39 4.76 3.66 90.00 10.00 6.23 100 0 1.10 100 0 2.47 0 1 19\.  
codec 97.79 8.97 42.50 28.53 20.00 74.56 3.82 4.12 78.57 21.43 6.18 30.62 69.38 2.35 73.33 26.67 9.57 2 18 39\.  
csv 98.30 9.36 41.28 25.96 23.40 86.81 0 0 0 0 1.70 78.17 21.83 2.13 96.72 3.28 0.98 0 8 16\.  
exec 99.60 45.16 35.89 2.42 16.53 44.76 4.84 0 0 0 5.24 0 100 0 0 0 28.62 1 1 3\.  
fast-pfor 97.46 45.45 14.71 16.98 22.86 52.94 1.47 0 0 0 0 0 0 0.13 100 0 2.41 2 0 12\.  
fileupload 99.48 86.98 9.90 0.52 2.60 4.17 6.77 1.56 0 100 0.52 100 0 0 0 0 54.84 1 3 2\.  
graph 98.71 41.22 27.73 19.04 12.01 58.78 0 0 0 0 0 0 0 0 0 0 0 0 0 12\.  
jansi 99.76 76.53 8.07 11.98 3.42 23.47 0 0 0 0 0 0 0 0 0 0 0 0 0 3\.  
pool 99.71 77.71 7.48 1.32 13.49 21.70 0.59 0 0 0 0 0 0 0 0 0 2.09 0 0 7\.  
validator 99.23 36.69 38.24 15.94 9.13 54.95 4.02 2.32 93.33 6.67 1.55 70.59 29.41 0.46 100 0 10.41 0 3 25\.  
Total 98.80 43.43 27.83 14.54 14.20 50.64 2.26 1.20 80.36 19.64 1.87 59.39 40.61 0.60 86.59 13.41 6.45 6 34 143\.  
\`\`\`  
\`\`\`  
7.6.2 Choice of LLM.For this experiment, we replaced the DeepSeek-Coder-33b-Instruct with  
GPT-4o and repeated the entire pipeline ofAlphaTrans(Table 5). A stronger model such as  
GPT-4o improves the translation quality—functional equivalence increases from 25 .14%to 27 .95%.  
For some projects, the ATP and TPR rates are higher for DeepSeek-Coder-33b-Instruct translations,  
whereas for the others, GPT-4o results in higher values. We investigated each LLM’s successful AMF  
translations to better understand the differences. We observed a huge overlap between successful  
AMFs and the unique benefits each LLM provides in code translation (Figure 7). GPT-4o handles  
API translation and type casting better, resolving the first three translation bugs discussed in  
§7.3. In contrast, it tends to add unnecessary code, mostly due to error handling, which results  
in a functional mismatch. In the example below,create2method can take aNonevalue, and its  
implementation performs error handling when necessary. GPT-4o adds unnecessary error handling  
code, interfering with program logic and resulting in test failures.  
\`\`\`  
(^12) \*\*public\*\* Option create1(OptionGroup optGroup) {----------- JAVA SOURCE CODE \-----------  
34 \*\*return\*\* create2(optGroup);  
5 }  
1 \---------- PYTHON TRANSLATION \----------  
2 \*\*def\*\* create1(self, optGroup: OptionGroup) \-\> Option:  
3 \+ \*\*if\*\* optGroup \*\*is None\*\* :  
4 \+ \*\*raise ValueError\*\* ("optGroup is None")  
5 \*\*return\*\* self.create2(optGroup)  
It is worth noting that using commercial LLMs comes at a cost. The last column of Table 5  
(columnCost) shows the cost of using GPT-4o for repeating the experiments, resulting in the total  
cost of$143. 95 for translating all the subjects (average cost of$14. 39 per project).  
7.6.3 Impact of Program Decomposition.For this ablation study, we prompted GPT-4o and  
DeepSeek-Coder-33b-Instructfile-by-fileand evaluated translation correctness through test execu-  
tion and GraalVM (Table 6). Not surprisingly, a considerable percentage of the files exceeded the  
model context window size, particularly for DeepSeekCoder, with 9 .08%of the files encountering  
this problem. Among the prompted files, 21 .36%( 19 .44%for DeepSeekCoder and 1 .92%for GPT-4o)  
were syntactically incorrect. Translations that passed the syntactic correctness check did not pass  
any translated test execution, whereas GraalVM validated 2 .56%of the files in total ( 1 .02%for  
DeepSeekCoder and 1 .54%for GPT-4o). Note that file-level GraalVM validation does not mean  
that all the methods are correctly translated and validated—only the methods in the class that are  
executed by tests. Manual analysis of the results of this experiment revealed that one prominent  
culprit of test failures was LLM hallucination with method/variable names. Given that we had  
no skeleton construction in this baseline, such issues could not be avoided; this demonstrates the  
usefulness of skeleton construction and incremental translation inAlphaTrans.

A Neuro-Symbolic Compositional Approach for Repository-Level Code Translation and Validation FSE109:

Table 6\. Importance of program decomposition. Abbreviations stand forGS: Graal Success andTPR: Test  
Pass Rate. Since Java can contain multiple classes in one file,\#Filesis smaller from\#Classesin Table 1\.

\`\`\`  
GPT-4o DeepSeek-Coder  
Subjects \# Files Over  
Context  
\`\`\`  
\`\`\`  
Syntax  
Error GS  
\`\`\`  
\`\`\`  
TPR  
(%)  
\`\`\`  
\`\`\`  
Over  
Context  
\`\`\`  
\`\`\`  
Syntax  
Error GS  
\`\`\`  
\`\`\`  
TPR  
(%)  
cli 51 0 0 1 0 5 6 0 0  
codec 136 0 1 7 0 28 46 4 0  
csv 33 0 3 0 0 6 8 0 0  
exec 54 0 0 0 0 1 4 0 0  
fast-pfor 85 1 1 1 0 12 30 1 0  
fileupload 43 0 0 0 0 2 4 0 0  
graph 159 0 6 3 0 0 17 3 0  
jansi 30 0 0 0 0 3 10 0 0  
pool 72 0 1 0 0 4 8 0 0  
validator 119 0 3 0 0 10 19 0 0  
Total 782 1 15 12 0 71 152 8 0  
\`\`\`  
\`\`\`  
Summary.Omitting program transformation and program decomposition significantly  
lowers the effectiveness ofAlphaTrans. A stronger model such as GPT-4o resolves non-  
trivial issues concerning type casting and API translation but may result in trivial translation  
bugs. When possible, users ofAlphaTranscan prompt multiple LLMs to achieve better  
translation performance.  
\`\`\`  
8 Related Work

\`\`\`  
74 1096 205  
\`\`\`  
\`\`\`  
DeepSeek-Coder  
GPT-4o  
\`\`\`  
\`\`\`  
Fig. 7\. Functional equiva-  
lence overlap of AMFs (Graal  
Success) between LLMs.  
\`\`\`  
There are generally two main categories of techniques for translating  
code from one PL to another: (1) using transpilers and statistical  
machine translation and (2) leveraging language models.

8.1 Code Translation Using Non-LLM-Based Approaches

Tools like C2Rust \[ 26 \], CxGo \[ 58 \], Sharpen \[ 45 \], and Java2CSharp \[ 27 \]  
translate code from C to Rust, C to Go, and Java to C\# respectively. A  
series of statistical machine translation techniques \[ 8 , 39 – 41 \] focus  
on translating Java to C\#. Deep learning approaches have also been  
applied for code translation \[ 48 , 49 \]. None of these efforts have tackled  
translating real-world Java projects to Python. LLM-based techniques  
are also superior to transpilers in terms of performance or readability \[44\].

8.2 Code Translation Using LLMs

Recently, LLMs have been employed for code translation \[ 9 , 30 , 44 , 57 , 61 , 64 \], demonstrating high  
success rates on crafted examples but poor performance on real-world projects. Other studies \[ 4 , 66 \]  
have also applied language models for code translation, mainly focusing on crafted benchmarks.  
Concurrently to our work, two other techniques for repository-level code translation focusing on  
different language pairs were proposed \[ 50 , 65 \].Syzygy\[ 50 \] translates repository-level C to Rust  
using GPT-4. Oxidizer \[ 65 \] leverages language feature mapping and type-driven techniques for  
translating Go to Rust. Both techniques use I/O equivalence for validating their translations. There  
are also approaches that use transpiler output to guide LLM-based code translation \[ 62 \]. However,  
the limitation of such work is the availability of robust and well-maintained transpilers, which, in  
many cases, may not be feasible. Nitin et al. \[ 42 \] presented a specification-based translation, where a  
natural language specification is captured from the source code, which helps the translation process.  
Yang et al. \[ 63 \] used tests to assist the translation. Compared to previous work, our contributions  
include a compositional and validation-guided code translation approach that leverages two types  
of validation techniques and evaluation of the approach on 10 real-world projects.

\`\`\`  
FSE109:20 A. R. Ibrahimzada, K. Ke, M. Pawagi, M. S. Abid, R. Pan, S. Sinha, and R. Jabbarvand  
\`\`\`  
9 Threats to Validity  
External Validity.One of the key external threats is the generalizability ofAlphaTrans. We  
built and evaluated the first version ofAlphaTransto translate from Java to Python. However,  
our pipeline is generic, and with minimal effort, the current implementation can translate Java  
programs to more target languages (e.g., languages supported by GraalVM). Furthermore, the  
majority of the tools that we used support a large set of programming languages such as JavaScript,  
Ruby, C/C++, and Rust.  
Internal Validity.One threat can be the manual validation of the translated types. To address  
that, several authors verified the types individually and consulted API documents when necessary.  
Another threat is that, while all successes reported by the GraalVM validation are true successes,  
we may haveunderestimatedthe capabilities ofAlphaTransby a considerable margin due to the  
significant proportion of errors caused by limitations in the GraalVM validation approach. To miti-  
gate this threat, we manually augmented the universal type map to support a more comprehensive  
translation of types. That said, we have implementeddrivercode templates to provide a mechanism  
for adding the support for more types by the users ofAlphaTransif needed.  
Construct Validity.In order to mitigate construct validity,AlphaTransis built and validated  
with well-vetted tools, such as GraalVM \[ 43 \], JaCoCo \[ 53 \], Python coverage \[ 6 \], CodeQL \[ 20 \], etc.

10 Concluding Remarks  
In this paper, we introducedAlphaTrans, a neuro-symbolic approach that combines the power of  
static analysis and abilities of LLMs in code synthesis to automate repository-level code translation  
and validation.AlphaTransdecomposes the program into smaller fragments and translates the  
fragments in reverse call order, incrementally building the source project in the target language. In  
addition to syntactic checks,AlphaTransimplements two types of validation through GraalVM and  
test translation.AlphaTransis the first approach to translate and validate real-world projects, and  
we envision several research directions to advance repository-level code translation and validation.  
One of the major challenges in repository-level code translation is identifying suitable library  
APIs in the target PL. Often, equivalent Python APIs may not exist, requiring new code generation  
or translation of the library API itself. Even if similar libraries exist, the logic of libraries might be  
different in two PLs.AlphaTranssupports translating frequently used APIs and aims to build a  
generic pipeline. Supporting all the libraries in the pipeline remains an open challenge that we aim  
to address in future work. Furthermore, while the idea of compositional translation and validation  
is PL-agnostic, the static analysis makes the extension ofAlphaTransto translating from other  
source projects challenging. Devising LLM-enabled or PL-agnostic static analysis approaches can  
benefit code translation approaches such asAlphaTrans. We also showed that the quality of the  
source project test suite can significantly impact the translation validation results. In future work,  
we plan to integrate an LLM-based test generator into theAlphaTranspipeline to enhance the  
validation component.

\`\`\`  
11 Data Availability  
\`\`\`  
Artifacts and implementation ofAlphaTransare publicly available \[33, 34\].

\`\`\`  
Acknowledgments  
This work is supported by the IBM-Illinois Discovery Accelerator Institute and NSF CCF-2238045  
grants. We thank Prof. Darko Marinov and Raju Pavuluri for their help with this research. We also  
thank the anonymous reviewers for their comments, which helped make this work stronger.  
\`\`\`

A Neuro-Symbolic Compositional Approach for Repository-Level Code Translation and Validation FSE109:21

References  
\[1\] 2024\. Black: Python Code Formatter. https://github.com/psf/black  
\[2\] 2024\. PyLint Static Code Analyzer for Python. https://pypi.org/project/pylint/  
\[3\]Muhammad Salman Abid, Mrigank Pawagi, Sugam Adhikari, Xuyan Cheng, Ryed Badr, Md Wahiduzzaman, Vedant  
Rathi, Ronghui Qi, Choiyin Li, Lu Liu, Rohit Sai Naidu, Licheng Lin, Que Liu, Asif Zubayer Palak, Mehzabin Haque,  
Xinyu Chen, Darko Marinov, and Saikat Dutta. 2024\. GlueTest: Testing Code Translation via Language Interoperability.  
In2024 IEEE International Conference on Software Maintenance and Evolution (ICSME). 612–617. doi:10.1109/ICSME58944.  
2024.00061  
\[4\]Wasi Uddin Ahmad, Md Golam Rahman Tushar, Saikat Chakraborty, and Kai-Wei Chang. 2023\. AVATAR: A Parallel  
Corpus for Java-Python Program Translation. InFindings of the Association for Computational Linguistics: ACL 2023,  
Anna Rogers, Jordan Boyd-Graber, and Naoaki Okazaki (Eds.). Association for Computational Linguistics, Toronto,  
Canada, 2268–2281. doi:10.18653/v1/2023.findings-acl.143  
\[5\]Andrés Bastidas Fuertes, María Pérez, and Jaime Meza Hormaza. 2023\. Transpilers: A Systematic Mapping Review of  
Their Usage in Research and Industry.Applied Sciences13, 6 (2023). doi:10.3390/app13063667  
\[6\] Ned Batchelder. 2024\. Coverage.py. https://pypi.org/project/coverage.  
\[7\]Dante Broggi and Yi Liu. 2023\. On the Interoperability of Programming Languages via Translation. In2023 Congress in  
Computer Science, Computer Engineering, & Applied Computing (CSCE). 2579–2585. doi:10.1109/CSCE60160.2023.00413  
\[8\]Xinyun Chen, Chang Liu, and Dawn Song. 2018\. Tree-to-tree neural networks for program translation. InProceedings  
of the 32nd International Conference on Neural Information Processing Systems(Montréal, Canada)(NIPS’18). Curran  
Associates Inc., Red Hook, NY, USA, 2552–2562.  
\[9\]Peng Di, Jianguo Li, Hang Yu, Wei Jiang, Wenting Cai, Yang Cao, Chaoyu Chen, Dajun Chen, Hongwei Chen, Liang  
Chen, Gang Fan, Jie Gong, Zi Gong, Wen Hu, Tingting Guo, Zhichao Lei, Ting Li, Zheng Li, Ming Liang, Cong Liao,  
Bingchang Liu, Jiachen Liu, Zhiwei Liu, Shaojun Lu, Min Shen, Guangpei Wang, Huan Wang, Zhi Wang, Zhaogui Xu,  
Jiawei Yang, Qing Ye, Gehao Zhang, Yu Zhang, Zelin Zhao, Xunjin Zheng, Hailian Zhou, Lifu Zhu, and Xianying Zhu.

2024\. CodeFuse-13B: A Pretrained Multi-lingual Code Large Language Model. InProceedings of the 46th International  
Conference on Software Engineering: Software Engineering in Practice(Lisbon, Portugal)(ICSE-SEIP ’24). Association for  
Computing Machinery, New York, NY, USA, 418–429. doi:10.1145/3639477.3639719  
\[10\]Hadeel A. Osman Eman J. Coco and Niemah I. Osman. 2018\. JPT : A Simple Java-Python Translator.CAIJ5, 2 (2018),  
1–18. doi:10.5121/caij.2018.5201  
\[11\] The Apache Software Foundation. 2024\. Apache Commons CLI. https://github.com/apache/commons-cli  
\[12\] The Apache Software Foundation. 2024\. Apache Commons Codec. https://github.com/apache/commons-codec  
\[13\] The Apache Software Foundation. 2024\. Apache Commons CSV. https://github.com/apache/commons-csv  
\[14\] The Apache Software Foundation. 2024\. Apache Commons Exec. https://github.com/apache/commons-exec  
\[15\]The Apache Software Foundation. 2024\. Apache Commons FileUpload. https://github.com/apache/commons-fileupload  
\[16\] The Apache Software Foundation. 2024\. Apache Commons Graph. https://github.com/apache/commons-graph  
\[17\] The Apache Software Foundation. 2024\. Apache Commons Pool. https://github.com/apache/commons-pool  
\[18\]The Apache Software Foundation. 2024\. Apache Commons Validator. https://github.com/apache/commons-validator  
\[19\]Gordon Fraser and Andrea Arcuri. 2011\. EvoSuite: automatic test suite generation for object-oriented software.  
InProceedings of the 19th ACM SIGSOFT Symposium and the 13th European Conference on Foundations of Software  
Engineering(Szeged, Hungary)(ESEC/FSE ’11). Association for Computing Machinery, New York, NY, USA, 416–419.  
doi:10.1145/2025113.2025179  
\[20\] GitHub. 2024\. CodeQL. https://codeql.github.com  
\[21\]Dony Goerge, Priyanka Girase, Mahesh Gupta, Prachi Gupta, and Aakanksha Sharma. 2010\. Programming Language  
Inter-conversion.International Journal of Computer Applications1, 20 (February 2010), 63–69. doi:10.5120/419-619  
\[22\] GraalVM. 2024\. Polyglot API. https://www.graalvm.org/latest/reference-manual/polyglot-programming.  
\[23\]Giovani Guizzo, Jie M. Zhang, Federica Sarro, Christoph Treude, and Mark Harman. 2023\. Mutation analysis for  
evaluating code translation.Empirical Software Engineering29, 1 (06 Dec 2023), 19\. doi:10.1007/s10664-023-10385-w  
\[24\]Daya Guo, Qihao Zhu, Dejian Yang, Zhenda Xie, Kai Dong, Wentao Zhang, Guanting Chen, Xiao Bi, Yu Wu, YK Li,  
et al.2024. DeepSeek-Coder: When the Large Language Model Meets Programming – The Rise of Code Intelligence.  
arXiv:2401.14196  
\[25\]Ali Reza Ibrahimzada. 2024\. Program Decomposition and Translation with Static Analysis. InProceedings of the 2024  
IEEE/ACM 46th International Conference on Software Engineering: Companion Proceedings(Lisbon, Portugal)(ICSE-  
Companion ’24). Association for Computing Machinery, New York, NY, USA, 453–455. doi:10.1145/3639478.3641226  
\[26\] Immunant. 2024\. C2Rust Transpiler. https://github.com/immunant/c2rust.  
\[27\] Paul Irwin. 2024\. Java to CSharp Converter. https://github.com/paulirwin/JavaToCSharp.  
\[28\]Suman Jain and Inderveer Chana. 2015\. Modernization of Legacy Systems: A Generalised Roadmap. InProceedings of  
the Sixth International Conference on Computer and Communication Technology 2015(Allahabad, India)(ICCCT ’15).

FSE109:22 A. R. Ibrahimzada, K. Ke, M. Pawagi, M. S. Abid, R. Pan, S. Sinha, and R. Jabbarvand

Association for Computing Machinery, New York, NY, USA, 62–67. doi:10.1145/2818567.2818579  
\[29\]Pooyan Jamshidi, Aakash Ahmad, and Claus Pahl. 2013\. Cloud Migration Research: A Systematic Review.IEEE  
Transactions on Cloud Computing1, 2 (2013), 142–157. doi:10.1109/TCC.2013.10  
\[30\]Mingsheng Jiao, Tingrui Yu, Xuan Li, Guanjie Qiu, Xiaodong Gu, and Beijun Shen. 2023\. On the Evaluation of Neural  
Code Translation: Taxonomy and Benchmark. In2023 38th IEEE/ACM International Conference on Automated Software  
Engineering (ASE). 1529–1541. doi:10.1109/ASE56229.2023.00114  
\[31\]Ravi Khadka, Belfrit V. Batlajery, Amir M. Saeidi, Slinger Jansen, and Jurriaan Hage. 2014\. How do professionals  
perceive legacy systems and software modernization?. InProceedings of the 36th International Conference on Software  
Engineering(Hyderabad, India)(ICSE 2014). Association for Computing Machinery, New York, NY, USA, 36–47.  
doi:10.1145/2568225.2568318  
\[32\]Musawwer Khan, Islam Ali, Wasif Nisar, Muhammad Qaiser Saleem, Ali S Ahmed, Haysam E Elamin, Waqar Mehmood,  
and Muhammad Shafiq. 2022\. Modernization Framework to Enhance the Security of Legacy Information Systems.  
Intelligent Automation & Soft Computing32, 1 (2022), 543–555. doi:10.32604/iasc.2022.016120  
\[33\] Intelligent CAT Lab. 2025\. AlphaTrans Artifact Website. https://github.com/Intelligent-CAT-Lab/AlphaTrans.  
\[34\] Intelligent CAT Lab. 2025\. AlphaTrans Data Repository. https://doi.org/10.5281/zenodo.15204625.  
\[35\]Kevin Lano and Hanan Siala. 2024\. Using model-driven engineering to automate software language translation.  
Automated Software Engineering31, 1 (28 Feb 2024), 20\. doi:10.1007/s10515-024-00419-y  
\[36\] Daniel Lemire. 2024\. JavaFastPFOR. https://github.com/lemire/JavaFastPFOR  
\[37\]Patrick Lewis, Ethan Perez, Aleksandra Piktus, Fabio Petroni, Vladimir Karpukhin, Naman Goyal, Heinrich Küttler,  
Mike Lewis, Wen-tau Yih, Tim Rocktäschel, Sebastian Riedel, and Douwe Kiela. 2020\. Retrieval-augmented generation  
for knowledge-intensive NLP tasks. InProceedings of the 34th International Conference on Neural Information Processing  
Systems(Vancouver, BC, Canada)(NIPS ’20). Curran Associates Inc., Red Hook, NY, USA, Article 793, 16 pages.  
\[38\]Nelson F. Liu, Kevin Lin, John Hewitt, Ashwin Paranjape, Michele Bevilacqua, Fabio Petroni, and Percy Liang. 2024\.  
Lost in the Middle: How Language Models Use Long Contexts.Transactions of the Association for Computational  
Linguistics12 (2024), 157–173. doi:10.1162/tacl\_a\_00638  
\[39\]Anh Tuan Nguyen, Tung Thanh Nguyen, and Tien N Nguyen. 2013\. Lexical Statistical Machine Translation for  
Language Migration. InFSE. ACM, New York, NY, USA, 651–654.  
\[40\]Anh Tuan Nguyen, Tung Thanh Nguyen, and Tien N. Nguyen. 2013\. Lexical statistical machine translation for language  
migration. InProceedings of the 2013 9th Joint Meeting on Foundations of Software Engineering(Saint Petersburg, Russia)  
(ESEC/FSE 2013). Association for Computing Machinery, New York, NY, USA, 651–654. doi:10.1145/2491411.2494584  
\[41\]Anh Tuan Nguyen, Tung Thanh Nguyen, and Tien N. Nguyen. 2015\. Divide-and-conquer approach for multi-phase  
statistical migration for source code. InProceedings of the 30th IEEE/ACM International Conference on Automated  
Software Engineering(Lincoln, Nebraska)(ASE ’15). IEEE Press, 585–596. doi:10.1109/ASE.2015.74  
\[42\]Vikram Nitin, Rahul Krishna, and Baishakhi Ray. 2024\. SpecTra: Enhancing the Code Translation Ability of Language  
Models by Generating Multi-Modal Specifications. arXiv:2405.18574  
\[43\] Oracle. 2024\. GraalVM. https://www.graalvm.org.  
\[44\]Rangeet Pan, Ali Reza Ibrahimzada, Rahul Krishna, Divya Sankar, Lambert Pouguem Wassi, Michele Merler, Boris  
Sobolev, Raju Pavuluri, Saurabh Sinha, and Reyhaneh Jabbarvand. 2024\. Lost in Translation: A Study of Bugs Introduced  
by Large Language Models while Translating Code. InProceedings of the IEEE/ACM 46th International Conference on  
Software Engineering(Lisbon, Portugal)(ICSE ’24). Association for Computing Machinery, New York, NY, USA, Article  
82, 13 pages. doi:10.1145/3597503.3639226  
\[45\] Mono Project. 2023\. Sharpen \- Automated Java-\>C\# coversion. https://github.com/mono/sharpen.  
\[46\] pytest dev. 2024\. Pytest. https://www.pytest.org.  
\[47\] Lili Qiu. 1999.Programming Language Translation. Technical Report. Cornell University, USA.  
\[48\]Baptiste Roziere, Marie-Anne Lachaux, Lowik Chanussot, and Guillaume Lample. 2020\. Unsupervised translation of  
programming languages. InProceedings of the 34th International Conference on Neural Information Processing Systems  
(Vancouver, BC, Canada)(NIPS ’20). Curran Associates Inc., Red Hook, NY, USA, Article 1730, 11 pages.  
\[49\]Baptiste Rozière, Jie M. Zhang, François Charton, Mark Harman, Gabriel Synnaeve, and Guillaume Lample. 2021\.  
Leveraging Automated Unit Tests for Unsupervised Code Translation.CoRRabs/2110.06773 (2021). arXiv:2110.06773  
https://arxiv.org/abs/2110.06773  
\[50\]Manish Shetty, Naman Jain, Adwait Godbole, Sanjit A Seshia, and Koushik Sen. 2024\. Syzygy: Dual Code-Test C to  
(safe) Rust Translation using LLMs and Dynamic Analysis.arXiv preprint arXiv:2412.14234(2024).  
\[51\] Fuse Source. 2024\. Jansi. https://github.com/fusesource/jansi  
\[52\]C. Spearman. 1904\. The proof and measurement of association between two things.The American Journal of Psychology  
15, 1 (1904), 72–101. doi:10.2307/1412159  
\[53\] The JaCoCo Team. 2024\. Java Code Coverage. https://www.eclemma.org/jacoco/  
\[54\] The JUnit Team. 2024\. JUnit. https://junit.org/junit5/

A Neuro-Symbolic Compositional Approach for Repository-Level Code Translation and Validation FSE109:23

\[55\]A.A. Terekhov and C. Verhoef. 2000\. The realities of language conversions.IEEE Software17, 6 (2000), 111–124.  
doi:10.1109/52.895180  
\[56\] TIOBE. 2024\. TIOBE Index. https://www.tiobe.com/tiobe-index.  
\[57\]Sindhu Tipirneni, Ming Zhu, and Chandan K. Reddy. 2024\. StructCoder: Structure-Aware Transformer for Code  
Generation.ACM Trans. Knowl. Discov. Data18, 3, Article 70 (Jan. 2024), 20 pages. doi:10.1145/3636430  
\[58\] Go Transpile. 2024\. C to Go Translator. https://github.com/gotranspile/cxgo.  
\[59\] Tree-Sitter. 2024\. Tree-Sitter Library. https://tree-sitter.github.io/tree-sitter/  
\[60\]Thomas Würthinger, Christian Wimmer, Andreas Wöß, Lukas Stadler, Gilles Duboscq, Christian Humer, Gregor  
Richards, Doug Simon, and Mario Wolczko. 2013\. One VM to rule them all. InProceedings of the 2013 ACM International  
Symposium on New Ideas, New Paradigms, and Reflections on Programming & Software(Indianapolis, Indiana, USA)  
(Onward\! 2013). Association for Computing Machinery, New York, NY, USA, 187–204. doi:10.1145/2509578.2509581  
\[61\]Weixiang Yan, Yuchen Tian, Yunzhe Li, Qian Chen, and Wen Wang. 2023\. CodeTransOcean: A Comprehensive  
Multilingual Benchmark for Code Translation. InFindings of the Association for Computational Linguistics: EMNLP 2023,  
Houda Bouamor, Juan Pino, and Kalika Bali (Eds.). Association for Computational Linguistics, Singapore, 5067–5089.  
doi:10.18653/v1/2023.findings-emnlp.337  
\[62\]Aidan ZH Yang, Yoshiki Takashima, Brandon Paulsen, Josiah Dodds, and Daniel Kroening. 2024\. VERT: Verified  
Equivalent Rust Transpilation with Large Language Models as Few-Shot Learners. arXiv:2404.18852  
\[63\]Zhen Yang, Fang Liu, Zhongxing Yu, Jacky Wai Keung, Jia Li, Shuo Liu, Yifan Hong, Xiaoxue Ma, Zhi Jin, and Ge Li.

2024\. Exploring and Unleashing the Power of Large Language Models in Automated Code Translation.Proc. ACM  
Softw. Eng.1, FSE, Article 71 (July 2024), 24 pages. doi:10.1145/3660778  
\[64\]Xin Yin, Chao Ni, Tien N Nguyen, Shaohua Wang, and Xiaohu Yang. 2024\. Rectifier: Code Translation with Corrector  
via LLMs. arXiv:2407.07472  
\[65\]Hanliang Zhang, Cristina David, Meng Wang, Brandon Paulsen, and Daniel Kroening. 2024\. Scalable, validated code  
translation of entire projects using large language models.arXiv preprint arXiv:2412.08035(2024).  
\[66\]Ming Zhu, Karthik Suresh, and Chandan K Reddy. 2022\. Multilingual Code Snippets Training for Program Translation.  
Proceedings of the AAAI Conference on Artificial Intelligence36, 10 (Jun. 2022), 11783–11790. doi:10.1609/aaai.v36i10.21434

Received 2024-09-13; accepted 2025-04-01


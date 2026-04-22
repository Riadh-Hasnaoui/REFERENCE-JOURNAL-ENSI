\# AGENTFL: Scaling LLM-based Fault Localization

\# to Project-Level Context

\#\# Yihao Qin∗, Shangwen Wang∗, Yiling Lou†, Jinhao Dong‡, Kaixin Wang†, Xiaoling Li∗, Xiaoguang Mao∗,

\`\`\`  
∗National University of Defense Technology, China,  
{yihaoqin, wangshangwen13, lixiaoling, xgmao}@nudt.edu.cn  
†Fudan University, China,{yilinglou@, kxwang23@m.}fudan.edu.cn  
‡Peking University, China, dongjinhao@stu.pku.edu.cn  
\`\`\`  
\`\`\`  
Abstract—Fault Localization (FL) is an essential step during  
the debugging process. With the strong capabilities of code  
comprehension, the recent Large Language Models (LLMs)  
have demonstrated promising performance in diagnosing bugs  
in the code. Nevertheless, due to LLMs’ limited performance  
in handling long contexts, existing LLM-based fault localization  
remains on localizing bugs within asmall code scope(i.e., a  
method or a class), which struggles to diagnose bugs for a  
large code scope(i.e., an entire software system). To address  
the limitation, this paper presents AGENTFL, a multi-agent  
system based on ChatGPT for automated fault localization.  
By simulating the behavior of a human developer, AGENTFL  
models the FL task as a three-step process, which involves  
comprehension, navigation, and confirmation. Within each step,  
AGENTFL hires agents with diversified expertise, each of which  
utilizes different tools to handle specific tasks. Particularly, we  
adopt a series of auxiliary strategies such as Test Behavior  
Tracking, Document-Guided Search, and Multi-Round Dialogue  
to overcome the challenges in each step. The evaluation on the  
widely used Defects4J-V1.2.0 benchmark shows that AGENTFL  
can localize 157 out of 395 bugs within Top-1, which outperforms  
the other LLM-based approaches and exhibits complementarity  
to the state-of-the-art learning-based techniques. Additionally, we  
confirm the indispensability of the components in AGENTFL with  
the ablation study and demonstrate the usability of AGENTFL  
through a user study. Finally, the cost analysis shows that  
AGENTFL spends an average of only 0.074 dollars and 97 seconds  
for a single bug.  
Index Terms—Large Language Model, Fault Localization  
\`\`\`  
\`\`\`  
I. INTRODUCTION  
Fault Localization (FL) is an important but time-consuming  
phase in the software debugging process. In particular, de-  
velopers can spend nearly half of the debugging time to  
understand and localize the bug before they fix the buggy  
code locations \[1\]. To release developers from the laborious FL  
tasks, various techniques have been proposed to automatically  
localize buggy program entities (e.g., classes, methods, or  
statements), among which the spectrum-based fault localiza-  
tion (SBFL) \[2\], \[3\], \[4\], \[5\], \[6\] and learning-based fault  
localization (LBFL) \[7\], \[8\], \[9\], \[10\] have been extensively  
studied and perform progressive effectiveness. As one of  
the most famous FL techniques, SBFL statistically analyzes  
\`\`\`  
\`\`\`  
\* Our work has been accepted by Transactions on Software Engineering  
(TSE) in 2025\. For the latest version, please refer to “SOAPFL: A Standard  
Operating Procedure for LLM-based Method-Level Fault Localization”.  
\`\`\`  
\`\`\`  
the coverage information and prioritizes the program entities  
covered by more failed tests and fewer passed tests. To better  
utilize the coverage information, LBFL techniques such as  
GRACE \[11\] represent coverage with a graph structure and  
leverage GNN models to learn useful features. Several state-of-  
the-art techniques have also suggested incorporating auxiliary  
information, such as code complexity and code history, and  
leveraging the combined features of such information with  
machine/deep learning models \[8\], \[10\].  
The recent advance of Large Language Models (LLMs) has  
shed new light on fault localization. Having been trained on  
massive code and textual data, LLMs exhibit a strong capabil-  
ity in code comprehension \[12\], \[13\], \[14\], including detecting  
and localizing bugs in the code \[15\]. Existing LLM-based fault  
localization mainly remains on the preliminary application  
of LLMs via basic prompting or fine-tuning. In particular,  
Wu et al. \[15\] prompt ChatGPT with simple instructions  
(e.g.,“Please analyze the following code snippet for potential  
bugs...”) and test failure information to localize bugs in the  
given method; LLMAO \[16\] fine-tunes LLMs with adapters  
on the fault localization dataset (i.e., the tuning input are 128  
consecutive code lines while the output are the buggy line  
labels). Although showing promising effectiveness, existing  
techniques can only address a simplified fault localization  
scenario, i.e., localizing the buggy statements in the given  
buggy method. The potential of LLMs under the project-level  
fault localization, i.e.,localizing the buggy methods from an  
entire project, has not been thoroughly studied, possibly due  
to the following technical challenges. First, the codebase of  
a real-world project often contains millions of tokens, which  
are far beyond the maximum input length of existing LLMs  
(e.g., the input lengths of the GPT-3.5 series models vary from  
4,096 to 16,385 tokens). Therefore, it is often infeasible and  
unacceptably resource-consuming to directly query LLMs with  
the entire project for fault localization. Second, existing LLMs  
exhibit deteriorating performance as the length of input context  
increases and have a tendency to overlook critical information  
within the long inputs \[17\]. Therefore, simply feeding LLMs  
with as much code as possible might not be an optimal way  
to leverage the superior capabilities of the model.  
To scale up LLM-based fault localization to the project-level  
contexts, in this work, we propose to decompose the local-  
\`\`\`  
\#\# arXiv:2403.16362v2 \[cs.SE\] 24 Feb 2025

ization process into multiple phases and selectively enhance  
LLMs with different debugging information during each phase.  
We are inspired by the debugging process of human develop-  
ers, who often take various actions such asanalyzing the fault  
(comprehending an error trace or a core dump),browsing the  
codebase(following each computational step in the execution  
of the failing test), andexamining the code(building mental  
representation by reading and understanding the code) \[1\],  
\[18\]. Specifically, by decomposing the localization process  
into several steps and achieving FL through the collaboration  
of multiple LLM-driven agents (i.e., intelligent entities that  
can perceive the environment, make decisions, and perform  
actions), the advantages we expect are twofold. On the one  
hand, this multi-step approach allows more controllable model  
inputs, which avoids excessively long contexts by merely  
providing essential information for the LLMs in each step. On  
the other hand, the capabilities of LLMs are further exploited  
since each agent focuses on processing specific tasks with their  
customized expertise.  
Based on the above intuition, we propose a novel LLM-  
based FL system, AGENTFL, which incorporates multiple  
LLM-driven agents to localize bugs for an entire project. To  
mitigate the inherent limitations of LLMs in handling large-  
scale codebases, AGENTFL decomposes the project-level fault  
localization into three stages, includingFault Comprehen-  
sion,Codebase Navigation, andFault Confirmation, where  
each stage is driven by multiple specialized agents. (1) The  
fault comprehension stage leverages LLMs to analyze the  
potential causes of the exposed fault, which would serve  
as the essential guidelines for the following two stages.  
Different from existing LLM-based FL techniques that only  
provide LLMs with the error message and the failed test  
code, AGENTFL incorporates a novelTest Behavior Tracking  
approach to collect the complete test execution behaviors (i.e.,  
the test utility code) via lightweight program instrumentation.  
(2) The codebase navigation stage then leverages LLMs to  
identify suspicious methods in a gradual refinement way,  
which first narrows down the faulty code space by finding  
out the suspicious classes and then selects related methods  
from these classes. To achieve this, AGENTFL incorporates  
a novelDocument-Guided Searchapproach, which utilizes  
both existing documents and LLM-enhanced documents to  
identify classes and methods related to the potential error  
causes. (3) The fault confirmation stage lastly leverages LLM  
to revisit all the suspicious methods (identified in the previous  
stage) and decide the most suspicious one as the final result.  
In this stage, AGENTFL incorporates a novelMulti-Round  
Dialogueapproach, which iteratively asks LLM to review each  
suspicious method with its detailed information.  
We evaluate AGENTFL on the Defects4J-V1.2.0 \[19\] bench-  
mark which includes 395 real-world bugs from 6 Java projects.  
To compare with the existing LLM-based FL techniques,  
we empower them to achieve project-level localization with  
Ochiai \[20\]. The results show that AGENTFL can localize 157  
bugs within Top-1, which significantly outperforms the LLM-  
based baselines ChatGPTOchiai\[15\] and LLMAOOchiai\[16\].

\`\`\`  
AGENTFL also shows complementarity with existing learning-  
based techniques such as DeepFL \[10\] and GRACE \[11\]. We  
further validate the importance of different components in  
AGENTFL with an ablation study. In addition, through a user  
study, we show the usability of AGENTFL in practice with  
its ability to provide both suspicious methods and rationale.  
Finally, the cost analysis reveals that AGENTFL requires only  
an average of 0.074 dollars and 97 seconds to localize a fault.  
The main contributions of this paper are:  
\`\`\`  
\- We propose to decompose the project-level fault localization  
    into three stages, i.e., comprehension, navigation, and confir-  
    mation. Such a process adheres to the developers’ debugging  
    practice and holds the potential for effectively managing the  
    inputs of the LLMs.  
\- We present AGENTFL, a three-stage FL technique empow-  
    ered by multiple LLM-driven agents, capable of automati-  
    cally localizing faults within the entire software.  
\- We extensively evaluate AGENTFL on both Defects4J-  
    V1.2.0 and Defects4J-V2.0.0. AGENTFL outperforms the  
    other LLM-based approaches and shows complementarity  
    with existing LBFL techniques on both datasets. Addi-  
    tionally, we conduct the user study and cost analysis to  
    demonstrate the usability of AGENTFL.

\`\`\`  
II. BACKGROUND& RELATED WORK  
A. Statistic-Based Fault Localization  
Spectrum-based and learning-based fault localization are  
mainstream FL technologies that achieve prominent perfor-  
mance on the Defects4J \[19\] benchmark. Given the buggy  
program and a set of tests including both passed and failed  
instances, the spectrum-based fault localization (SBFL) local-  
izes suspicious program entities through the hypothesis that  
the fault location should be covered by more failed tests than  
passed ones. To achieve this, SBFL first collects coverage in-  
formation for each program elementeby recording the number  
of passed testsTp(e)and failed testsTf(e)that covere, then  
designs different formula such as Ochiai \[20\], DStar \[21\] and  
Jaccard \[22\] to calculate the suspiciousness scores for ranking  
all the elements. As an example, Ochiai computes the suspi-  
ciousness of an elementeasTf(e)/((Tf(e) \+Tp(e))Tf)^1 /^2 ,  
whereTfis the number of all failed tests.  
To use coverage more exhaustively and combine extra  
valuable information such as code history, learning-based fault  
localization (LBFL) is also extensively studied. FLUCCS \[8\]  
boosts SBFL with code and change metrics. DeepFL \[10\]  
learns to combine four dimensions of knowledge from SBFL,  
mutation-based FL, code complexity, and text similarity  
through RNN \[23\] and MLP \[24\]. GRACE \[11\] integrates cov-  
erage with fine-grained code structures by a GNN \[25\] model.  
Other well-known LBFL techniques include CNNFL \[9\],  
TraPT \[26\], CombineFL \[27\], and GNet4FL \[28\], etc.  
Based on the high dependence of SBFL and LBFL on cov-  
erage information and code features, we consider them both as  
statistic-based fault localization (STBFL) to distinguish them  
from the approaches based on the LLMs.  
\`\`\`

B. LLM-Based Fault Localization

With the emergence of the Large Language Model (LLM),  
LLMs such as ChatGPT \[29\], Phind \[30\], CodeGen \[31\], and  
StarCoder \[32\] have shown remarkable power on aligning  
semantics between natural languages (NL) and programming  
languages (PL). In the ChatGPT-4 launch event, OpenAI  
prompted the model to localize and fix errors by providing  
program code and error log, which unveiled the potential and  
applicability of ChatGPT-4 in fault localization.  
However, due to the well-known context limitation issue  
as well as the decreasing performance on longer input con-  
texts \[15\], \[17\], existing LLM-based FL techniques primarily  
concentrate on localizing buggy lines within a code snippet,  
while neglecting the identification of bugs in an entire software  
project. Given a context of 128 code lines, LLMAO \[16\] trains  
lightweight bidirectional adapters on top of LLMs to produce  
a suspiciousness score for each line. Wuet al.\[15\] prompts  
ChatGPT with code and error logs, and instructs the model  
to identify the buggy lines. To assist developers from another  
perspective, in this paper, we endow the LLMs with the ability  
to automatically identify bugs in the entire software.

C. LLM-driven agents & SOP

Supported by the existing studies about human debugging  
behaviors \[1\], \[18\], we regard fault localization as a complex  
task, which is difficult to get desired results with only one  
LLM inference. Therefore, we inherited the design principles  
of LLM-driven agents and standard operating procedure (SOP)  
during the construction of AGENTFL.  
LLM-driven agents are designed to solve complex tasks  
specified in natural language autonomously. Equipped with  
mechanisms including memory management \[33\], tool us-  
age \[34\], and multi-agent communication \[35\], LLM-driven  
agents have been proposed to conduct various tasks such as  
social behavior simulation \[36\], website tasks \[37\], and inter-  
active writing \[33\]. There are also LLM-driven agents such  
as AutoGPT \[38\] and BabyAGI \[39\] that aim at conducting  
arbitrary missions with user instructions. More recently, multi-  
agent systems such as MetaGPT \[40\] and ChatDev \[41\] have  
started to move towards automated software development.  
SOP is a concept from the real-world engineering domain,  
for LLM-driven agents, SOP is a symbolic plan to make the  
agents more controllable \[40\], \[42\]. For example, in MetaGPT,  
employed agents (e.g., product managers and engineers) work  
together by following a predefined and streamlined workflow,  
where all intermediate outputs (e.g., the document and code)  
are structured and standardized. SOP plays a vital role in task  
decomposition and effective coordination, which ensures the  
robustness of the multi-agent system.

III. APPROACH  
AGENTFL is a multi-agent fault localization system that  
localizes buggy methods for the given project in three steps.  
We first introduce an overview of AGENTFL and then explain  
the detailed steps respectively.

\`\`\`  
A. Overview  
\`\`\`  
\`\`\`  
The overall workflow of AGENTFL is shown in Figure 1\.  
In particular, AGENTFL consists of threesteps; in eachstep,  
AGENTFL is supposed to tackle differenttasks; to specialize  
the LLMs to solve different tasks, four differentagentsare  
constructed by enhancing the LLMs with domain knowledge  
and externalcomponents.  
Inputs & Outputs.The inputs of AGENTFL include the  
codebase of the entire project, the failed test methods (i.e.,  
the failed test cases), and the error message of the triggered  
fault. As it is common for one fault to trigger multiple failed  
test methods (e.g., 22 test methods fail in the bug Chart-  
in Defects4J) and it is less efficient to diagnose each failed  
test method separately, AGENTFL focuses on one failed test  
class (i.e., the aggregation of the failed test methods in the  
same class) in each run, and the total number of runs is  
the number of failed test classes. The outputs of AGENTFL  
include the buggy location and the corresponding explanations,  
which consist of the following three parts: (i) the Top-  
Suspicious Methodalong with its reason for being buggy, (ii)  
the suspiciousClass, and (iii) otherSuspicious Methodsin the  
class along with their reasons for being buggy.  
Steps & Tasks. By mimicking the human debugging  
strategies \[1\], \[18\], AGENTFL models the fault localization  
process as an SOP which comprises three steps, including  
(i) understanding the cause of the fault (Fault Comprehen-  
sion), (ii) browsing the relevant program elements (Codebase  
Navigation), and (iii) validating the buggy location (Fault  
Confirmation). In each step, AGENTFL tackles different tasks  
(identified by❶-❼in Figure 1), e.g., the first step of fault  
comprehension involves the❶Test Behavior Analysistask and  
the❷Test Failure Analysistask.  
Agents.To specialize the LLMs to solve different tasks,  
AGENTFL incorporates four different LLM-drivenagents(i.e.,  
Test Code Reviewer, Source Code Reviewer, Software Ar-  
chitect, and Software Test Engineer), which enhance LLMs  
with task-specific knowledge and external capabilities (e.g.,  
program analysis component). In particular, theTest Code  
Revieweragent (used in Task 1\) is designed for reviewing the  
test code and summarizing the test behavior; theSource Code  
Revieweragent (used in Task 4\) is designed for writing high-  
quality code comments; theSoftware Architectagent (used in  
Tasks 3&5) is designed for software architecture and adept  
at finding areas of the program that may be problematic;  
theSoftware Test Engineeragent (used in Tasks 2&6&7) is  
designed for all the tasks associated with analyzing and vali-  
dating the test failures. Each LLM-driven agent is customized  
by prompting LLMs with specific system instructions and  
enabling LLMs to use external components. In particular, the  
specific system instruction is typically provided at the start of  
the interaction to serve as the initial context or instruction for  
the LLMs. Due to space constraints, we present the system  
instruction of theSoftware Test Engineeragent below:  
\`\`\`

\`\`\`  
You are a Software Test Engineer. We share a common interest in  
collaborating to successfully locate the buggy code that causes the  
test class to fail. Your main responsibilities include examining the  
information of the failed tests to analyze the possible causes of the  
test failures, and determining the method that needs to be fixed.  
To locate the bug, you must write a response that appropriately  
solves the requested instruction based on your expertise.  
\`\`\`  
Components.The LLMs alone fall short in limited context  
length and unstable performance of hallucination \[43\]. There-  
fore, AGENTFL incorporates multiple components to enhance  
LLM-driven agents with memorization, reasoning, and tool  
usage capabilities. In other words, with the LLM as the brain  
of each agent, the other components provide LLMs with  
external capabilities of better utilizing debugging contexts.  
In particular, theProgram Analysiscomponent is driven by  
lightweight Instrumentation and Static Analysis, which equips  
the agents with the tools (Test/Source Code Analysis) to  
perceive the test execution process; the components ofResult  
Parser,State Storage, andPrompt Generatorenable a loop  
to drive the pipeline operations of multiple tasks. Specifically,  
thePrompt Generatorcollects material from theState Storage  
and generates the prompt according to a template predefined  
for each task. After the agent returns the response, theResult  
Parsertransforms the result into formatted data and sends it  
to theState Storage, where the result will be utilized in the  
downstream steps. Moreover, the data inState Storagecan also  
come from theProgram Analysiscomponent when the agent  
calls a tool.

B. Fault Comprehension

Aim.To guide the whole localization process, AGENTFL  
starts with theFault Comprehensionstep to better understand  
the cause of the fault before starting to find it. Our intuition  
is that compared to direct reasoning, the “understanding-  
reasoning” manner bridges the test failure information and the  
buggy source code with intermediate thought, which is more  
akin to the human mindset. Specifically, theFault Comprehen-  
sionstep consists of two tasks. Provided with the test code, the  
❶Test Behavior Analysistask prompts the LLM to describe in  
detail the behavior of the failed test cases. In the❷Test Failure  
Analysistask, the test behavior we obtained before together  
with other test failure information (including error stack trace,  
test code, and test output) encourages the LLM to list the  
possible causes of the fault. As the intermediate thought, the  
possible causes will inform the subsequent navigation step.  
Challenge. Although the attendance of test code (i.e.,  
the test method executed during each unit test) has been  
proved helpful in LLM-based FL \[15\], we observe that the  
LLMs may still suffer from the limited information in the  
test method. Figure 2 shows an example derived from bug  
Closure-19 in Defects4J-V1.2.0 \[19\], in this case, the test  
testNoThisInferencefailed when a test utility method  
inFunction() is called at line 4\. However, since the  
developers kept all the detailed test logic in test utility methods  
that are called by the test method, the LLMs may find it  
difficult to comprehend the complete test behavior through

\`\`\`  
Steps  
\`\`\`  
\`\`\`  
Results  
\`\`\`  
\`\`\`  
Components  
\`\`\`  
\`\`\`  
Prompt  
Generator  
\`\`\`  
\`\`\`  
Result  
Parser  
\`\`\`  
\`\`\`  
LLM  
\`\`\`  
\`\`\`  
Inputs  
\`\`\`  
\`\`\`  
Suspicious Methods  
\`\`\`  
\`\`\`  
Test Class  
\`\`\`  
\`\`\`  
Top-1 Method Class  
\`\`\`  
\`\`\`  
Test Failure Analysis  
Prompt  
\`\`\`  
\`\`\`  
Prompt  
\`\`\`  
\`\`\`  
Test Behavior Analysis  
\`\`\`  
\`\`\`  
Prompt  
\`\`\`  
\`\`\`  
Search Suspicious Class  
\`\`\`  
\`\`\`  
Method Doc Enhancement  
Prompt  
\`\`\`  
\`\`\`  
Find Related Methods  
Prompt  
\`\`\`  
\`\`\`  
Method Review (Multiple)  
Prompt  
\`\`\`  
\`\`\`  
Get Top-1 Method  
Prompt  
\`\`\`  
\`\`\`  
State  
Storage  
\`\`\`  
\`\`\`  
Program Analysis  
\`\`\`  
\`\`\`  
Instrumentation  
\`\`\`  
\`\`\`  
Static Analysis  
\`\`\`  
\`\`\`  
Test Case  
···  
\`\`\`  
\`\`\`  
Possible  
Causes  
\`\`\`  
\`\`\`  
BehaviorTest  
\`\`\`  
\`\`\`  
Test Code  
Analysis  
\`\`\`  
\`\`\`  
Suspicious  
Class  
\`\`\`  
\`\`\`  
Source Code Analysis  
\`\`\`  
\`\`\`  
Method DocEnhanced  
\`\`\`  
\`\`\`  
Related  
Methods  
\`\`\`  
\`\`\`  
Suspicious  
Methods  
\`\`\`  
\`\`\`  
Top- 1  
Method  
\`\`\`  
\`\`\`  
1 2 3 4 5 6 7  
\`\`\`  
\`\`\`  
Method Full Name Reason  
com.google.JavaClassA::method1() this method is suspicious ...  
com.google.JavaClassB$InnerClass::method2()this method is suspicious ...  
··· ···  
\`\`\`  
\`\`\`  
buggy, because ...method1( ) is because ...ClassA^  
\`\`\`  
\`\`\`  
Failed Tests  
Test Utility Code  
\`\`\`  
\`\`\`  
Test Code  
\`\`\`  
\`\`\`  
Failed Tests  
Test Behavior  
\`\`\`  
\`\`\`  
Test Infos  
\`\`\`  
\`\`\`  
Failed Tests  
Possible Causes  
\`\`\`  
\`\`\`  
Test Infos  
Covered Classes  
\`\`\`  
\`\`\`  
Class Name  
Methods Code  
\`\`\`  
\`\`\`  
Class Doc  
\`\`\`  
\`\`\`  
Class Name  
（Covered MethodsDoc Enhanced）  
\`\`\`  
\`\`\`  
Class Doc  
\`\`\`  
\`\`\`  
Failed Tests  
Possible Causes  
Test Infos  
Class InfoMethod Info  
Related Method Code  
\`\`\`  
\`\`\`  
Possible Causes  
Buggy Method Code  
\`\`\`  
\`\`\`  
Test Class  
\`\`\`  
\`\`\`  
···  
\`\`\`  
\`\`\`  
Agents  
Software Test Engineer Test Code Reviewer  
Software Architect Source Code Reviewer  
\`\`\`  
\`\`\`  
Fault Comprehension  
\`\`\`  
\`\`\`  
Codebase Navigation  
\`\`\`  
\`\`\`  
Fault Confirmation  
\`\`\`  
\`\`\`  
Fig. 1:Overview of AGENTFL.  
\`\`\`  
\`\`\`  
Test Method  
\`\`\`  
\`\`\`  
Test Utility Methods  
1 private void inFunction (String js) {  
2 // Parse the body of the function.  
\`\`\`  
(^3) 4? String (^) ""thisBlock : "/\*\* @this {" \= assumedThisType \+ assumedThisType \== null \+ "} \*/";  
\*\*···\*\*  
34 }  
1 public void \*\*testNoThisInference\*\* () {  
2 JSType thisType \= createNullableType(OBJECT\_TYPE);  
3 assumingThisType(thisType);  
4 inFunction (“var out \= 3; if (goog.isNull(this)) out \= this;"); // error  
5 verify("out", createUnionType(OBJECT\_TYPE, NUMBER\_TYPE));  
6 }  
Fig. 2:Example from Closure-19.  
only the test method. In particular, test utility methods are  
very prevalent in practice, e.g., each test method calls 4\.  
other test utility methods on average in the Defect4J-V1.2.  
benchmark. Therefore, the information in the utility methods  
can be potentially helpful for comprehensively comprehending  
the test failure.

\`\`\`  
Instrumentation  
\`\`\`  
\`\`\`  
Static  
Analysis  
\`\`\`  
\`\`\`  
Method Call Trace  
\`\`\`  
\- org.jfree.chart.LegendItemCollection getItemCount() int  
\- org.jfree.chart.util.AbstractObjectList init(int,String) int  
......

\`\`\`  
Code Doc  
\`\`\`  
\`\`\`  
Test Class  
Test Case 1  
\`\`\`  
\`\`\`  
Test Case 2  
\`\`\`  
\`\`\`  
Trace 1  
\`\`\`  
\`\`\`  
Extracted  
Classes  
\`\`\`  
\`\`\`  
Covered  
Classes  
Instrumentation Trace 2  
··· IntersectionClass  
\`\`\`  
\`\`\`  
Common  
Classes  
\`\`\`  
\`\`\`  
Class  
Method 1  
Method 2  
···  
\`\`\`  
\`\`\`  
Class  
Method 1 Name  
\`\`\`  
\`\`\`  
Doc Name  
\`\`\`  
\`\`\`  
Program Analysis  
\`\`\`  
\`\`\`  
Covered  
Classes  
\`\`\`  
\`\`\`  
Fig. 3:The process of the Program Analysis.  
\`\`\`  
\`\`\`  
Method Doc Enhancement  
Method Name Method Documentation  
isRemovableVar(Var)  
process(Node,Node) Traversestraversals maythe occurroot, to^ removing ensure all^ unusedall^ unused variables^ variables are removed.^ Multiple.^  
removeUnreferencedVars()Removesany assignments^ any^ vars to^ inthose^ the variables^ scope^ that as^ werewell.^ not^ referenced.^ Removes^  
... ...  
\`\`\`  
\`\`\`  
Method Name EnhancedMethod Documentation  
isRemovableVar(Var) This method checks if a variable is removable.  
process(Node,Node)  
\`\`\`  
\`\`\`  
This method traverses the root, removing all unused variables.  
Multiple traversals may occur to ensure all unused variables are  
removed. This method calls another method “process()” to do  
more specific tasks.  
removeUnreferencedVars()Thisreferenced^ method and^ removes any assignments^ any^ variables to those^ in variables^ the^ scope.^ that^ were^ not^  
... ...  
\`\`\`  
Fig. 4:An example of method document enhancement.  
Strategy.To track the complete test execution behavior  
from the test utility methods, we adopt the Test Behav-  
ior Tracking strategy which equips the LLMs with the  
capability of program analysis. Specifically, theTest Code  
Revieweragent in task ❶ utilizes the Test Code Analysis  
tool to fill the prompt with the Test Utility Code before  
it is asked to summarize the test behavior. The more de-  
tailed process of Test Code Analysis in theProgram Anal-  
ysis component is demonstrated in Figure 3\. Firstly, the  
tool applies lightweightInstrumentationfor each failed test  
case to record the Method Call Trace during test code  
execution, and parses the trace to register the Covered  
Classes, eachClasscomprised of the full class name (e.g.,  
com.google.jscomp.TypeInferenceTest) and a  
signature list (e.g.,init(int,String) int) of the cov-  
ered test utility methods in that class. Secondly, aClass In-  
tersectionoperation is conducted to keep the common classes  
and methods that are covered by all failed test cases, we refer  
to the output asCommon Classes. Finally, theStatic Analysis  
further augments the classes and methods with the document,  
name, and code from the codebase. As the output of the tool,  
Extracted Classescontains information about both the covered  
test class and the covered test utility methods, which is then  
reserved in theState Storageand used to construct theTest

\`\`\`  
Utility Codeof the prompt inTest Behavior Analysistask.  
\`\`\`  
\`\`\`  
C. Codebase Navigation  
Aim.Provided with the comprehension of the possible  
causes in the last step, theCodebase Navigationstep intends  
to identify all related methods from the entire codebase. Our  
intuition is that given the test failure information and the  
possible causes generated from task❷, ChatGPT can gradually  
browse the entire codebase from global to local and identify  
the program entities that may be responsible for the test  
failure. Specifically, we start with two tasks for theCodebase  
Navigationstep. The❸Search Suspicious Classtask intends  
to localize the most suspicious class among all covered classes  
during a test execution process. After that, the❺Find Related  
Methodstask aims to filter out all the methods that may relate  
to the bug within the suspicious class. To depict the role of  
methods in a class, the information about the suspicious class  
is also included in the prompt.  
Challenge.Nevertheless, the above design still faces three  
challenges: (1) Due to the possible invalidity or weakness  
of LLMs under long contexts \[17\], a strategy should be  
taken for leading the model to concentrate on critical in-  
formation during the browsing process; (2) An excessive  
number of covered classes can still result in LLM distraction  
and context length issues, for example, the failed integration  
testtestSingletonGetter1of bug Closure-36 covers  
hundreds of methods in 208 classes; (3) The ChatGPT model  
struggles to identify related methods directly with the existing  
documents due to the absence of some method comments and  
the “function nested” problem. The upper side of Figure 4  
shows an example of the original method comments in bug  
Closure-1. In the first row, the absence of the comment of  
methodisRemovableVar(Var)prevents ChatGPT from  
better understanding its functionality. In the second row,  
although the comment ofprocess(Node,Node)says it  
“removes all unused variables”, this method accomplishes  
the functionality by calling other methods. We refer to this  
inconsistency of comment and function of a method as the  
“function nested” problem, which could mislead the LLMs to  
focus on irrelevant methods.  
Strategy.To alleviate the aforementioned challenges, we  
adopt a series of heuristic strategies: (1) Considering that the  
LLMs can associate the function of a class/method with the  
function that may cause the bug through the proximity of  
natural language description, we adopt aDocument-Guided  
Search strategy to first search for suspicious classes and  
then find the related methods. Specifically, in task ❸, we  
extract the covered classes by source code analysis (Figure  
3), and prompt ChatGPT to select a single class from a  
markdown format table built with names and documentation  
of the covered classes. After localizing the suspicious class,  
the❺task filters out all the methods that may relate to the  
bug according to the names and comments of the covered  
methods. (2) To address the issue of an excessive number of  
covered classes, we draw inspiration from an observation in  
test coverage. Specifically, we have observed that the fixing  
\`\`\`

behavior tends to occur more frequently in classes that ex-  
hibit higher method-level coverage (for further details, please  
refer to Section IV-D). Based on this insight, we effectively  
mitigate the problem by selectively reducing the number of  
covered classes while ensuring that the performance remains  
unaffected, which is achieved by retaining only the Top-N  
classes that possess relatively high method-level coverage. (3)  
For the documentation inconsistency, our insight is that as  
the LLMs have demonstrated powerful capabilities in code  
summarization \[12\], \[44\], theSource Code Revieweragent can  
be hired to fix the problematic documentation. Therefore, we  
further design the❹Method Doc Enhancementtask to handle  
the above problem. Before finding related methods, the source  
code and the original comments of all covered methods in the  
suspicious class are listed in the prompt, the agent is then  
required to analyze the method call relationship to generate a  
new comment for each method. The enhanced documentation  
can be seen from the bottom side of Figure 4\. In the first  
row, the task fills in the missing comment. In the second row,  
the task declares the callee methodprocess()to alleviate  
the “function nested” problem, which provides more accurate  
information for the upcomingFind Related Methodstask.

D. Fault Confirmation

Aim.In the previous steps, AGENTFL has only utilized  
the documentation and coverage information to search for the  
related methods in the codebase, which may not be enough  
to validate the exact fault location. Therefore, we design the  
Fault Confirmationstep to aggregate all useful information and  
make a final decision on which method is buggy. Specifically,  
we build the ❻Method Review task, where the Software  
Test Engineeragent examines the source code of the related  
methods and integrates all useful information to recognize the  
buggy methods.

Challenge.In order to review all related methods, a straight-  
forward approach is to fill all the source codes in a single  
request and require the model to select the most suspicious  
method. Nevertheless, we found in practice that as the volume  
of code in the context increases, it is more difficult for the  
model to focus on the fault location, resulting in a significant  
performance decrease. Therefore, a strategy should be taken  
to validate all of the suspicious methods while also ensuring  
the model’s accuracy.

Strategy.To address the above problem, we adopt aMulti-  
Round Dialoguestrategy in task❻, enabling the model to  
analyze one related method at a time. The prompt template of  
theMethod Reviewtask is illustrated below:

\`\`\`  
One or more tests in the test class \[TEST CLASS\] failed:  
Failed tests: \[FAILED TESTS\]  
The method \[METHOD NAME\] may be problematic.  
Detailed information is listed below:  
\[TEST INFOS\]  
Possible Causes: \[POSSIBLE CAUSES\],  
Class of the Suspicious Method: \[CLASS NAME\]  
Documentation of the Class: \[CLASS DOC\]  
Suspicious Method Full Name: \[METHOD NAME\]  
Suspicious Method Comment: \[METHOD DOC\]  
Suspicious Method Code: \[METHOD CODE\]  
As a Software Test Engineer, please carefully examine the code  
of the method \[METHOD NAME\] and determine if this method  
is the buggy location. You can return TRUE with the reason or  
only FALSE.  
\`\`\`  
\`\`\`  
After the task❻, multiple methods can be regarded as  
suspicious. Compared to spectrum-based and learning-based  
FL, AGENTFL does not generate suspicious values for ranking  
the suspicious methods. For usability and evaluation purposes,  
we further design a❼Get Top-1 Methodtask in the last, where  
theSoftware Test Engineeragent retrospectively analyzes the  
buggy methods in all failed test classes to determine the most  
probable fault location. In particular, if there is only one buggy  
method, the task takes it directly as the top-1 method.  
\`\`\`  
\`\`\`  
IV. EXPERIMENTDESIGN  
A. Research Questions  
To assess the effectiveness of AGENTFL, we propose to  
answer the following research questions:  
\`\`\`  
\- RQ1: What is the performance of AGENTFL in method-  
    level fault localization?This RQ aims to build a new  
    effectiveness baseline for LLM-based method-level fault  
    localization.  
\- RQ2: How does our design choices affect the perfor-  
    mance of AGENTFL?This RQ could help measure the  
    contribution of different components in AGENTFL, and thus  
    inspire future studies.  
\- RQ3: Can AGENTFL help developers in practice?This  
    RQ conducts a user study to help understand how useful  
    AGENTFL could be in practice.

\`\`\`  
B. Benchmark  
In line with most existing fault localization work, we  
include the two versions of the widely-used benchmarks  
Defects4J \[19\] (i.e., Defects4J-V1.2.0 and Defects4J-V2.0.0)  
for evaluation. In particular, Defects4J-V1.2.0 consists of 395  
bugs from 6 real-world Java projects (as shown in Table I), on  
which we compare AGENTFL against all the studied baselines.  
In addition, Defects4J-V2.0.0 consists of additional 226 bugs  
from extra 9 Java projects, on which we further evaluate the  
generalization capability of studied techniques in the cross-  
project prediction setting in line with GRACE \[11\].  
\`\`\`  
\`\`\`  
C. Baselines  
LLM-based Baselines. We include two existing LLM-  
based FL techniques (i.e., LLMAO \[16\] and Wuet al.\[15\])  
as baselines. However, both techniques are only originally  
\`\`\`

applied for fault localization within a small context, i.e., LL-  
MAO \[16\] trains lightweight adapters on top of CodeGen \[31\]  
to produce a suspicious score of each line within the given 128  
code lines, and Wuet al.\[15\] require ChatGPT to analyze the  
buggy line in a method with well-crafted prompts. Therefore,  
to adapt these techniques to project-level fault localization  
(i.e., localizing the buggy method from the whole code base),  
we construct two variants of them (i.e., LLMAOOchiai and  
ChatGPTOchiai), which first leverage the state-of-the-art SBFL  
technique Ochiai \[20\] to reduce the context size and then  
apply these techniques for fault localization. In particular, for  
ChatGPTOchiai, we apply a minimal change to the approach  
of Wuet al.by retaining their prompt format except that  
the command is changed from finding buggy lines to judging  
the correctness of the method, and ChatGPT is prompted to  
validate the top 20 suspicious methods localized by Ochiai. For  
LLMAOOchiai, given the top 20 suspicious methods localized  
by Ochiai, we first use LLMAO to predict a suspicious value  
for each line in a method, then each method is re-ranked  
according to the value of its most suspicious line.  
Statistic-based Baselines. We include the SBFL tech-  
nique Ochiai \[20\], FLUCCS \[8\] based on machine learning,  
DeepFL \[10\] based on deep learning, and GRACE \[11\] based  
on graph neural network. For a fair comparison, we follow  
GRACE \[11\] to exclude mutation-related features in DeepFL  
and keep the features related to source code and coverage, the  
modified version is named DeepFLcov.

D. Implementation

We implement AGENTFL in Python based on the state-of-  
the-art multi-agent framework ChatDev \[41\], we use thegpt-  
3.5-turbo-16k-0613model of the ChatGPT family as the en-  
gine of AGENTFL. For dynamic program analysis, we imple-  
ment a lightweight JVM agent by thejava.lang.instrument\[45\]  
package, and modify the framework of Defects4J to sup-  
port dynamic program instrumentation. To keep the program  
analysis focused on test/source code, we allow the tool to  
instrument the Java bytecode files in the specified folder. For  
static program analysis, we use tree-sitter \[46\] for code parsing  
and program element extraction.  
We set the following alterable parameters to regulate the  
behavior of AGENTFL. Among test information, the maximum  
token length of the test output log is 200\. The token length of  
class and method documentation is limited to 100\. To deal with  
the rare circumstances of overwhelming test cases, we keep no  
more than 5 failed test cases for each test class, which barely  
impairs the performance of AGENTFL in practice.  
For covered class reduction (introduced in Section III-C),  
we investigate the method-level coverage rank of the class  
changed by developers among all covered classes. Specifically,  
the method-level coverage rate of classcis calculated with  
rc \= (

\#\#\# PN

i=1Iyi)/N, whereIyi is an function to indicate  
whether methodyiis covered. Based on the results shown in  
Figure 5, we retain classes that fall in the top-50 method-level  
coverage rates, which ensures the buggy class is preserved in  
over 98% of the cases.

\`\`\`  
1 6 11 16 21 26  
Bug ID  
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
100  
\`\`\`  
\`\`\`  
120  
\`\`\`  
\`\`\`  
Chart  
Covered Classes Amount  
Rank of Buggy Class  
\`\`\`  
\`\`\`  
1 19 37 55 73 91 109127  
Bug ID  
\`\`\`  
\`\`\`  
0  
\`\`\`  
\`\`\`  
50  
\`\`\`  
\`\`\`  
100  
\`\`\`  
\`\`\`  
150  
\`\`\`  
\`\`\`  
200  
\`\`\`  
\`\`\`  
250 Closure  
Covered Classes Amount  
Rank of Buggy Class  
\`\`\`  
\`\`\`  
Fig. 5:Method level coverage rank. For each bug, the green  
bar is the average coverage rank of all changed classes, and  
the orange bar is the amount of all covered classes. We show  
2 out of 6 projects in Defects4J-V1.2.0 due to space limit.  
TABLE I:Information of Defects4J-V1.2.0 benchmark.  
ID Name \#Bug LOC(k)  
Chart JFreeChart 26 96  
Lang Apache commons-lang 65 22  
Math Apache commons-math 106 85  
Time Joda-Time 27 28  
Mockito Mockito framework 38 23  
Closure Google Closure compiler 133 90  
E. Metrics  
Following prior studies \[8\], \[10\], \[11\], \[28\], we assess the  
effectiveness of AGENTFL based on the Top-N (N=1,3,5)  
metric. Top-N computes the number of bugs that have at least  
one buggy element localized within the first N positions in  
the ranked list. It is easy to calculate the Top-1 value with  
the design ofGet Top-1 Methodtask in AGENTFL. However,  
since the ChatGPT model is a master at judging true or false  
rather than calculating suspicious values, it is non-trivial to get  
Top-3 and Top-5. To alleviate the problem, we compromise  
by keeping a list of all the methods that AGENTFL considers  
suspicious in chronological order and calculating Top-N with  
the rank of the buggy methods in the list.  
V. EVALUATION  
A. RQ1: Localization Performance  
Compared to LLM-based baselines. We first compare  
AGENTFL with ChatGPTOchiaiand LLMAOOchiaithat both  
use LLMs to drive fault localization, the results are shown in  
Table II. Overall, AGENTFL achieves reasonable performance:  
it can localize 157 out of 395 bugs within Top-1, 28 more  
than LLMAOOchiaiand 36 more than ChatGPTOchiai. When  
considering the Top-1 metric on the individual project, we  
observe that AGENTFL significantly outperforms the other  
two techniques on nearly every project except Closure, where  
LLMAOOchiailocalizes 18 more methods within Top-1. In  
terms of Top-3 and Top-5 metrics, we found that although  
AGENTFL outperforms ChatGPTOchiai, it failed to localize  
more bugs than LLMAOOchiai.  
The above results can be explained by the different mech-  
anisms of LLMAOOchiaiand AGENTFL. The LLMAOOchiai  
predicts a suspicious value for each method that has been pre-  
localized by Ochiai, which is more talented at ranking tasks  
\`\`\`

TABLE II: Comparision with LLM-based baselines on  
Defects4J-V1.2.0.  
Project \# Bugs Techniques Top1 Top3 Top

\`\`\`  
Chart 26  
\`\`\`  
\`\`\`  
ChatGPTOchiai 11 15 15  
LLMAOOchiai 11 15 19  
AGENTFL 16 18 19  
\`\`\`  
\`\`\`  
Lang 65  
\`\`\`  
\`\`\`  
ChatGPTOchiai 29 35 36  
LLMAOOchiai 31 49 54  
AGENTFL 44 45 45  
\`\`\`  
\`\`\`  
Math 106  
\`\`\`  
\`\`\`  
ChatGPTOchiai 38 55 55  
LLMAOOchiai 30 59 70  
AGENTFL 49 60 61  
\`\`\`  
\`\`\`  
Time 27  
\`\`\`  
\`\`\`  
ChatGPTOchiai 9 11 12  
LLMAOOchiai 7 13 14  
AGENTFL 11 13 13  
\`\`\`  
\`\`\`  
Mockito 38  
\`\`\`  
\`\`\`  
ChatGPTOchiai 12 16 16  
LLMAOOchiai 8 19 26  
AGENTFL 13 14 14  
\`\`\`  
\`\`\`  
Closure 133  
\`\`\`  
\`\`\`  
ChatGPTOchiai 22 36 38  
LLMAOOchiai 42 57 70  
AGENTFL 24 33 35  
\`\`\`  
\`\`\`  
Overall 395  
\`\`\`  
\`\`\`  
ChatGPTOchiai 121 168 172  
LLMAOOchiai 129 212 253  
AGENTFL 157 183 187  
\`\`\`  
than the ChatGPT model. However, since AGENTFL behaves  
more like a human by browsing the entire codebase without  
any auxiliary localization results, the limited search space and  
the ranking issue \[47\] of the LLMs hinder it from achieving  
better performance in Top-3 and Top-5 metrics.

Compared to statistic-based baselines.To investigate how  
AGENTFL performs against the statistic-based techniques,  
we select four techniques based on different methodologies:  
FLUCCS \[8\] (machine learning), DeepFLcov \[10\] (multi-  
layer perception), GRACE \[11\] (graph neural network), and  
Ochiai \[20\] (suspicious formula). From Table III, we observe  
that as a first attempt to use the LLMs for method-level fault  
localization, AGENTFL is not yet able to surpass existing  
approaches entirely. Overall, AGENTFL localizes 157 of 395  
bugs within Top-1, 77 more than Ochiai, 3 less than FLUCCS,  
19 less than DeepFLcov, and 35 less than GRACE.

However, when focusing on the results of individual  
projects, we find that AGENTFL has achieved competi-  
tive performance in all software projects except Closure.  
To explain this, we scrutinized every bug that AGENTFL  
failed to localize while other approaches were able to  
make it. We attribute the prominent weak effectiveness of  
AGENTFL on Closure to three aspects: (1) Some bugs  
in Closure possess very similar characteristics. For in-  
stance, bugs Closure-18 and Closure-31 have failed test  
cases with similar purposes (testDependencySorting  
andtestDependencySortingWhitespaceMode), and  
even the same buggy method parseInputs(). In these  
cases, the learning-based techniques learn much richer in-  
project knowledge than AGENTFL as they perform within-  
project prediction with the leave-one-out training strategy.  
AGENTFL, however, needs to localize a bug from scratch  
based on more generalized knowledge from ChatGPT. (2) The  
tests in Closure tend to cover more program elements. For

\`\`\`  
34 36  
\`\`\`  
\`\`\`  
27  
\`\`\`  
\`\`\`  
33  
\`\`\`  
\`\`\`  
82  
\`\`\`  
\`\`\`  
8  
\`\`\`  
\`\`\`  
50  
\`\`\`  
\`\`\`  
AGENTFL DeepFL𝒄𝒐𝒗  
\`\`\`  
\`\`\`  
GRACE  
Fig. 6:Overlap results on Defects4J-V1.2.0.  
example, the average number of classes covered by the bugs  
in Closure is 107.7, which is extremely larger than those in  
Lang (2.3) and Chart (27.5). In this case, it is more difficult  
for AGENTFL to recognize the suspicious class at once among  
a large number of covered classes. (3) Since AGENTFL is  
designed to validate rather than rank the methods, the number  
of suspicious methods in the result of AGENTFL is relatively  
small. Among all 395 bugs, there are 319 (374) cases where  
the number of suspicious methods in the result is less than 3  
(5). Consequently, the increase in the number of bugs localized  
by AGENTFL becomes progressively smaller from Top-1 to  
Top-3 (157 to 183\) and then Top-3 to Top-5 (183 to 187).  
The last row of Table III presents the result without project  
Closure, AGENTFL reaches a similar level as GRACE in  
terms of Top-1 and outperforms the other three techniques  
on each project by localizing 67 more bugs than Ochiai, 15  
more than FLUCCS, 21 more than DeepFLcovand only 12  
less than GRACE. For cross-project evaluation, we follow Lou  
et al.\[11\] to evaluate AGENTFL against other statistic-based  
approaches on 226 extra bugs in Defects4J-V2.0.0, the result in  
Table IV shows that AGENTFL significantly outperforms most  
of the other approaches by localizing 35 more bugs within Top-  
1 than DeepFLcov, 21 more than FLUCCS, and 46 more than  
Ochiai. AGENTFL gains comparable performance to GRACE  
with only 7 fewer bugs localized in the top.  
We also investigated the overlaps among the bugs localized  
within Top-1 by different approaches on the Defects4J-V1.2.  
benchmark, and the results are shown in Figure 6\. The figure  
illustrates the complementarity of AGENTFL with existing  
approaches on localizing different bugs. Specifically, 34 bugs  
can be uniquely localized within Top-1 by AGENTFL while  
the numbers for DeepFLcov and GRACE are 36 and 27  
respectively.  
\`\`\`  
\`\`\`  
Answer to RQ1:AGENTFLcan effectively localize the bugs  
in Defects4J, which outperforms the other LLM-based ap-  
proaches and shows complementarity with existing statistic-  
based techniques in terms of the Top-1 metric.  
\`\`\`  
\`\`\`  
B. RQ2: Ablation Study  
For this research question, we aim to investigate the contri-  
butions of different design choices to AGENTFL. To this end,  
we separately remove theTest Behavior Analysistask,Test  
Failure Analysistask, andMethod Doc Enhancementtask from  
AGENTFL, and retain the other tasks that need to maintain the  
proper functionality of the system. Note that after removing  
the Test Failure Analysis task, the Test Behavior Analysis task  
\`\`\`

\`\`\`  
TABLE III:Comparision with statistic-based baselines on Defects4J-V1.2.0.  
Project \# Bugs Top1AGENTTop3FLTop5 Top1GRACETop3 Top5 Top1DeepFLTop3covTop5 Top1FLUCCSTop3 Top5 Top1 OchiaiTop3 Top  
Chart 26 16 18 19 14 20 22 12 18 21 15 19 16 6 14 15  
Lang 65 44 45 45 42 54 57 43 53 56 40 53 55 24 44 50  
Math 106 49 60 61 61 78 89 39 68 80 48 77 83 23 52 62  
Time 27 11 13 13 11 14 19 9 16 18 8 15 18 6 11 13  
Mockito 38 13 14 14 17 24 26 9 15 21 7 19 22 7 14 18  
Closure 133 24 33 35 47 70 81 64 86 97 42 66 77 14 30 38  
Overall 395 157 183 187 192 260 294 176 256 293 160 249 271 80 165 196  
w/o Closure 262 133 150 152 145 190 213 112 170 196 118 183 194 66 135 158  
TABLE IV:Results on Defects4J-V2.0.0.  
Project \# Bugs Techniques Top1 Top3 Top  
\`\`\`  
\`\`\`  
Overall 226  
\`\`\`  
\`\`\`  
Ochiai 32 74 93  
FLUCCS 57 97 119  
DeepFLcov 43 89 112  
GRACE 85 119 140  
AGENTFL 78 98 103  
\`\`\`  
is also muted, since the results of the former task participate  
in the construction of the latter task’s prompt.

The performances of the variants of AGENTFL are shown in  
Table V. We notice that when theTest Failure Analysistask is  
discarded, the efficacy of AGENTFL decreases sharply, with  
the number of bugs localized within Top-1 decreasing from  
157 to 125\. This indicates that it is a finer choice to offer  
ChatGPT time to think about the root causes of the test failure  
and take the analysis result as intermediate data to guide the  
subsequent localization process. This pattern is more in line  
with the debugging behavior of developers and shares the idea  
of chain-of-thought \[48\]. Similarly, when theMethod Doc En-  
hancementtask is removed, the Top-1 result drops significantly  
from 157 to 133\. While this phenomenon emphasizes the  
importance of higher quality documentation for AGENTFL to  
more accurately localize the buggy methods, it also calls on the  
developers to write better documentation during production,  
as the human wisdom preserved in documents can conversely  
support the development and maintenance of software.

Surprisingly, when we abandon theTest Behavior Analysis  
task, the performance of AGENTFL declines marginally from  
157 to 148 on the Top-1 metric. To deeply understand the  
reasons for this phenomenon, we analyze the characteristics  
of utility methods corresponding to failed test cases. We find  
that although each test method calls 4.93 other utility methods  
on average, these utility methods are generally shared by  
multiple test methods to handle common operations such as  
test initialization. This means that the code of the test method  
may already carry most of the information needed by the  
ChatGPT to understand the behavior of the test. Nonetheless,  
the fact of performance gain still emphasizes the potential of  
other sources of information than just the test code.

\`\`\`  
Answer to RQ2:The Test Behavior Analysis, Test Failure  
Analysis, and Method Doc Enhancement tasks are useful to  
underpin the effectiveness ofAGENTFL. The contribution of  
Test Behavior Analysis appears to be relatively small.  
\`\`\`  
\`\`\`  
TABLE V:Result of ablation study.  
Project \# Bugs Techniques Top1 Top3 Top  
\`\`\`  
\`\`\`  
Overall 395  
\`\`\`  
\`\`\`  
w/o TestBehaviorAnalysis 148 174 175  
w/o TestFailureAnalysis 125 148 152  
w/o MethodDocEnhancement 133 156 160  
AGENTFL 157 183 187  
C. RQ3: User study  
In this RQ, we intend to evaluate to what extent can  
AGENTFL help developers localize bugs in practice. Kochhar  
et al.\[49\] found that 85% of the practitioners strongly agreed  
that the ability to provide rationale is important, with one of  
the respondents stating“because to make a decision about  
bug fixing I want to exactly know why the automated tool  
‘thinks’ that the code has a bug”. Therefore, merely relying  
on the Top-N metric may not be enough to reflect the usability  
of AGENTFL, since it not only lists the suspicious methods  
but also provides the user with additional natural language  
interpretations. To investigate the usability of AGENTFL, we  
re-evaluate AGENTFL through the following user study: (1)  
Participant Selection. We recruited five Ph.D. students each of  
whom has more than five years of programming experience  
and does not know about the Defects4J benchmark before;  
(2) Data Preparation. By excluding 98 out of 395 bugs  
where AGENTFL did not find any suspicious methods, we  
constructed 297 bug-suggestion pairs. The suggestion for each  
bug contains the top-3 suspicious methods and the corre-  
sponding rationales generated by AGENTFL; (3)Localization  
Procedure. We ask each participant to localize the buggy  
method from the codebase with the test failure information  
(including failed tests, error stack traces, and test outputs) and  
the suggestions provided by AGENTFL. The participants are  
allowed to use web searches if they are not familiar with any  
program logic. Given that the previous study shows that a  
practitioner usually takes about 11 minutes to localize a bug  
with an FL tool \[50\], we set the time limit to 15 minutes,  
providing the users with sufficient time to finish the task; (4)  
Results Collection. Finally, for each bug-suggestion pair, we  
regard AGENTFL as helpful if the user successfully localizes  
the buggy method within the specified time.  
The result of our user study is shown in Figure 7, from  
which we observe that with the help of AGENTFL, devel-  
opers can consistently localize more bugs in all the projects  
compared with the vanilla AGENTFL. Two most significant  
breakthroughs occur in projects Math and Closure, where the  
numbers of localized bugs in terms of the Top-1 (Top-3) results  
are improved by 19 (8) and 29 (20), respectively. To under-  
stand why participants achieved better localization results, we  
\`\`\`

\`\`\`  
0 10 20 30 40 50 60 70  
\`\`\`  
\`\`\`  
Chart  
Lang  
Math  
Time  
\`\`\`  
\*\*Mockito\*\*

\`\`\`  
Closure  
\`\`\`  
\`\`\`  
16  
44  
49  
11  
13  
24  
\`\`\`  
\`\`\`  
18  
45  
60  
13  
14  
33  
\`\`\`  
\`\`\`  
20  
51  
68  
16  
15  
53  
\`\`\`  
\`\`\`  
Number of Localized Bugs  
\`\`\`  
\`\`\`  
Top-  
Top-  
Human  
\`\`\`  
\`\`\`  
1 2 3 4 5 6 7 8 9  
\`\`\`  
\`\`\`  
Number of incorrect predictions  
\`\`\`  
\`\`\`  
Fig. 7:Evaluation results of RQ3.  
\`\`\`  
further investigate the cases where AGENTFL failed to suggest  
the buggy method at the top position. The statistics show  
that in more than 80% of the cases, the number of incorrect  
predictions (i.e., non-buggy methods that are ranked before  
buggy methods) produced by AGENTFL does not exceed 3,  
thus bringing less distraction to the users. Such results indicate  
that the explanations produced by AGENTFL could provide  
additional fault-related information for the developers and help  
them better finish the fault localization task, demonstrating the  
potential usability of AGENTFL in practice.  
To help further understand the usability of AGENTFL in  
practice, we demonstrate two cases in Figure 8\. In the first  
case, AGENTFL successfully understands the root cause of the  
bug Lang-42 (i.e., “did not escape the high unicode character  
correctly”). However, although the methodescapeHtmlhas  
been mentioned in the bug report, the developer eventually  
modified its callee methodescape(i.e., the method called by  
escapeHtmlto handle with more specific character escaping  
logic) to fix the bug. Similarly, in the second case, AGENTFL  
still failed to localize the buggy method, but it correctly inter-  
preted the root cause of the bug Closure-1 and suggested the  
users to investigate the methodinterpretAssigns, which  
is exactly the caller of the buggy method. As shown in the  
figure, the incorrect removal of unused variables happens in the  
methodremoveUnreferencedFunctionArgs, making  
it the buggy location. For both cases, AGENTFL provides  
reasonable explanations despite its prediction (i.e., the caller  
methods of the buggy methods) is not exactly precise, which  
allows the user to“find the error location with a little extra  
work”(one participant left such a comment).

\`\`\`  
Answer to RQ3:AGENTFLexhibits relatively high usability  
in practice with its few incorrect predictions and the provi-  
sion of rationale.  
\`\`\`  
\#\#\# VI. DISCUSSION

A. Cost Analysis

We assessed the performance of AGENTFL on the often-  
concerned issues of prices and time consumption. The results  
are demonstrated in Figure 9, where each sample is marked  
with an orange dot. For runtime, we record the seconds  
required for AGENTFL to completely deal with each bug,  
including test runs, program analysis, and ChatGPT inference.  
For cost, we calculate how many dollars AGENTFL needs to  
localize each bug by multiplying the total number of consumed

\`\`\`  
CASE 1: Lang 42  
\`\`\`  
\`\`\`  
AGENTFL  
\`\`\`  
\`\`\`  
Developer  
\`\`\`  
\`\`\`  
Buggy Method: escape()  
Bug Report: StringEscapeUtils.escapeHtmlincorrectly  
converts unicodecharactersabove U+00FFFF into 2  
characters.  
\`\`\`  
\`\`\`  
Suspicious Method: escapeHtml()  
Rationale: The test case expects "&\#119650;", but the value  
returned by this method is "&\#55348;&\#57186;". This method  
did not escape the high unicodecharacter correctly.  
\`\`\`  
\`\`\`  
CASE 2: Closure 1  
\`\`\`  
\`\`\`  
Buggy Method: removeUnreferencedFunctionArgs()  
Bug Report: Function arguments should not be optimized  
away, as this compromises the function's length property. The  
function's length property is essential to many techniques, such  
as currying functions.  
\`\`\`  
\`\`\`  
Suspicious Method: interpretAssigns()  
Rationale: If this method is not correctly marking variables as  
referenced or unreferenced, it can lead to incorrect removal of  
unused variablesand cause the test failures ...  
\`\`\`  
\`\`\`  
AGENTFL  
\`\`\`  
\`\`\`  
Developer  
\`\`\`  
\`\`\`  
Fig. 8:Two use cases for bug Lang-42 and Closure-1.  
\`\`\`  
\`\`\`  
0 200 400 600 800  
\`\`\`  
\`\`\`  
Chart  
Lang  
Math  
Time  
Mockito  
Closure  
\`\`\`  
\`\`\`  
Runtime(s)  
\`\`\`  
\`\`\`  
0.0 0.2 0.4 0.6 0\.  
\`\`\`  
\`\`\`  
Cost($)  
\`\`\`  
\`\`\`  
Fig. 9:Cost analysis results.  
tokens with the model price (0.003 dollar per thousand tokens).  
We observe that AGENTFL offers affordable cost in terms of  
time and money, which only takes an average of 0.074 dollars  
and 97 seconds to localize a fault. In over 95% cases, the cost  
per bug would not exceed 0.2 dollars and 200 seconds. Such  
a low expense is expected to mitigate the expensive costs that  
developers spend on FL.  
\`\`\`  
\`\`\`  
B. Threats to Validity  
Internal.The main internal threat comes from the data  
leakage problem. As the training data of thegpt-3.5-turbo-  
16k-0613model is up to Sep 2021 while Defects4J-V1.2.  
is released in Feb 2018, the fault localization dataset may  
have been used for model training. We mitigate this threat by  
making sure that the input to ChatGPT does not include any  
content related to the project name, human-written bug report,  
or bug ID. Moreover, the poor performance of the default  
ChatGPT (i.e., the baseline ChatGPTOchiai) also indicates  
that ChatGPT has not simply memorized the answer, while  
the significant improvement of AGENTFL (compared to the  
default ChatGPT) shows the effectiveness of our approach.  
External.The main external threat to validity comes from  
our evaluation benchmark. The results obtained by AGENTFL  
may not generalize to other benchmarks. To address this,  
we evaluate AGENTFL not only on the Defects4J-V1.2.  
benchmark but also on Defects4J-V2.0.0 to demonstrate the  
generalizability.  
\`\`\`

\#\#\# VII. CONCLUSION

In this paper, we introduce AGENTFL, a multi-agent system  
based on ChatGPT for automated LLM-based FL. Inspired by  
the human debugging actions, AGENTFL breaks the localiza-  
tion process into three steps (Fault Comprehension, Codebase  
Navigation, and Fault Confirmation), and hires several agents  
in each step to handle specific tasks. The evaluation results  
on the Defects4J-V1.2.0 benchmark show that AGENTFL  
outperforms other LLM-based approaches and can be used  
complementarily to the existing learning-based techniques. A  
user study also demonstrates the potential of AGENTFL in  
helping developers localize real-world software bugs. Finally,  
the cost analysis shows that AGENTFL takes only an average  
of 0.074 dollars and 97 seconds to localize 157 out of 395  
bugs within Top-1.

\`\`\`  
REFERENCES  
\[1\] A. Alaboudi and T. D. LaToza, “An exploratory study of debugging  
episodes,” arXiv:2105.02162 \[cs.SE\], 2021\.  
\[2\] R. Abreu, P. Zoeteweij, and A. J. van Gemund, “Spectrum-based multi-  
ple fault localization,” in2009 IEEE/ACM International Conference on  
Automated Software Engineering, 2009, pp. 88–99.  
\[3\] M. Raselimo and B. Fischer, “Spectrum-based fault localization for  
context-free grammars,” inProceedings of the 12th ACM SIGPLAN  
International Conference on Software Language Engineering, ser. SLE  
\`\`\`  
2019\. New York, NY, USA: Association for Computing Machinery,  
2019, p. 15–28.  
\[4\] S. Reis, R. Abreu, and M. D’Amorim, “Demystifying the combination of  
dynamic slicing and spectrum-based fault localization,” inProceedings  
of the 28th International Joint Conference on Artificial Intelligence, ser.  
IJCAI’19. AAAI Press, 2019, p. 4760–4766.  
\[5\] W. E. Wong, V. Debroy, R. Gao, and Y. Li, “The dstar method for  
effective software fault localization,”IEEE Transactions on Reliability,  
vol. 63, no. 1, pp. 290–308, 2014\.  
\[6\] L. Zhang, M. Kim, and S. Khurshid, “Localizing failure-inducing  
program edits based on spectrum information,” in2011 27th IEEE  
International Conference on Software Maintenance (ICSM), 2011, pp.  
23–32.  
\[7\] W. Zheng, D. Hu, and J. Wang, “Fault Localization Analysis Based  
on Deep Neural Network,”Mathematical Problems in Engineering, vol.  
2016, pp. 1–11, April 2016\.  
\[8\] J. Sohn and S. Yoo, “Fluccs: Using code and change metrics to  
improve fault localization,” inProceedings of the 26th ACM SIGSOFT  
International Symposium on Software Testing and Analysis, ser. ISSTA  
2017\. New York, NY, USA: Association for Computing Machinery,  
2017, p. 273–283.  
\[9\] Z. Zhang, Y. Lei, X. Mao, and P. Li, “Cnn-fl: An effective approach for  
localizing faults using convolutional neural networks,” in2019 IEEE  
26th International Conference on Software Analysis, Evolution and  
Reengineering (SANER). IEEE, 2019, pp. 445–455.  
\[10\] X. Li, W. Li, Y. Zhang, and L. Zhang, “Deepfl: Integrating multiple fault  
diagnosis dimensions for deep fault localization,” inProceedings of the  
28th ACM SIGSOFT International Symposium on Software Testing and  
Analysis, 2019, pp. 169–180.  
\[11\] Y. Lou, Q. Zhu, J. Dong, X. Li, Z. Sun, D. Hao, L. Zhang, and  
L. Zhang, “Boosting coverage-based fault localization via graph-based  
representation learning,” inProceedings of the 29th ACM Joint Meeting  
on European Software Engineering Conference and Symposium on the  
Foundations of Software Engineering, ser. ESEC/FSE 2021\. New York,  
NY, USA: Association for Computing Machinery, 2021, p. 664–676.  
\[12\] X. Pu, M. Gao, and X. Wan, “Summarization is (almost) dead,”  
arXiv:2309.09558 \[cs.CL\], 2023\.  
\[13\] J. Li, S. Tworkowski, Y. Wu, and R. Mooney, “Explaining competitive-  
level programming solutions using llms,” inThe 61st Annual Meeting  
Of The Association For Computational Linguistics, 2023\.  
\[14\] Z. Yuan, J. Liu, Q. Zi, M. Liu, X. Peng, and Y. Lou, “Evaluating  
instruction-tuned large language models on code comprehension and  
generation,”arXiv preprint arXiv:2308.01240, 2023\.

\`\`\`  
\[15\] Y. Wu, Z. Li, J. M. Zhang, M. Papadakis, M. Harman, and Y. Liu, “Large  
language models in fault localisation,” arXiv:2308.15276 \[cs.SE\], 2023\.  
\[16\] A. H. Yang, R. Martins, C. L. Goues, and V. J. Hellendoorn, “Large  
language models for test-free fault localization,” in2024 IEEE/ACM  
46th International Conference on Software Engineering (ICSE). Los  
Alamitos, CA, USA: IEEE Computer Society, Apr 2024, pp. 154–165.  
\[17\] N. F. Liu, K. Lin, J. Hewitt, A. Paranjape, M. Bevilacqua, F. Petroni, and  
P. Liang, “Lost in the Middle: How Language Models Use Long Con-  
texts,”Transactions of the Association for Computational Linguistics,  
vol. 12, pp. 157–173, 02 2024\.  
\[18\] M. Bohme, E. O. Soremekun, S. Chattopadhyay, E. Ugherughe, and ̈  
A. Zeller, “Where is the bug and how is it fixed? an experiment with  
practitioners,” inProceedings of the 11th Joint Meeting on Foundations  
of Software Engineering. ACM, 2017, pp. 117–128.  
\[19\] R. Just, D. Jalali, and M. D. Ernst, “Defects4J: A database of existing  
faults to enable controlled testing studies for java programs,” inPro-  
ceedings of the 23rd International Symposium on Software Testing and  
Analysis. ACM, 2014, pp. 437–440.  
\[20\] R. Abreu, P. Zoeteweij, and A. J. Van Gemund, “An evaluation of sim-  
ilarity coefficients for software fault localization,” in2006 12th Pacific  
Rim International Symposium on Dependable Computing (PRDC’06),  
2006, pp. 39–46.  
\[21\] W. E. Wong, V. Debroy, R. Gao, and Y. Li, “The dstar method for  
effective software fault localization,”IEEE Transactions on Reliability,  
vol. 63, no. 1, pp. 290–308, 2013\.  
\[22\] R. Abreu, P. Zoeteweij, and A. J. Van Gemund, “On the accuracy of  
spectrum-based fault localization,” inTesting: Academic and Industrial  
Conference Practice and Research Techniques-MUTATION. IEEE,  
2007, pp. 89–98.  
\[23\] M. Toma ́ˆs, K. Martin, B. Luk ́aˆs, C. Jan, and K. Sanjeev, “Recurrent  
neural network based language model,”Interspeech 2010, p. 1045, 09  
2010\.  
\[24\] M.-C. Popescu, V. E. Balas, L. Perescu-Popescu, and N. Mastorakis,  
“Multilayer perceptron and neural networks,”WSEAS Trans. Cir. and  
Sys., vol. 8, no. 7, p. 579–588, jul 2009\.  
\[25\] Y. Li, R. Zemel, M. Brockschmidt, and D. Tarlow, “Gated graph  
sequence neural networks,” inProceedings of ICLR’16, April 2016\.  
\[26\] X. Li and L. Zhang, “Transforming programs and tests in tandem for  
fault localization,”Proc. ACM Program. Lang., vol. 1, no. OOPSLA,  
oct 2017\.  
\[27\] D. Zou, J. Liang, Y. Xiong, M. D. Ernst, and L. Zhang, “An empirical  
study of fault localization families and their combinations,”IEEE  
Transactions on Software Engineering, vol. 47, no. 2, pp. 332–347, 2021\.  
\[28\] J. Qian, X. Ju, and X. Chen, “Gnet4fl: Effective fault localization via  
graph convolutional neural network,”Automated Software Engg., vol. 30,  
no. 2, apr 2023\.  
\[29\] “Openai,” https://openai.com/, 2024\.  
\[30\] “Phind,” https://www.phind.com/, 2024\.  
\[31\] E. Nijkamp, B. Pang, H. Hayashi, L. Tu, H. Wang, Y. Zhou, S. Savarese,  
and C. Xiong, “Codegen: An open large language model for code with  
multi-turn program synthesis,” inThe Eleventh International Conference  
on Learning Representations, 2023\.  
\[32\] R. Li, L. B. allal, Y. Zi, N. Muennighoff, D. Kocetkov, C. Mou,  
M. Marone, C. Akiki, J. LI, J. Chim, Q. Liu, E. Zheltonozhskii, T. Y.  
Zhuo, T. Wang, O. Dehaene, J. Lamy-Poirier, J. Monteiro, N. Gontier,  
M.-H. Yee, L. K. Umapathi, J. Zhu, B. Lipkin, M. Oblokulov, Z. Wang,  
R. Murthy, J. T. Stillerman, S. S. Patel, D. Abulkhanov, M. Zocca,  
M. Dey, Z. Zhang, U. Bhattacharyya, W. Yu, S. Luccioni, P. Villegas,  
F. Zhdanov, T. Lee, N. Timor, J. Ding, C. S. Schlesinger, H. Schoelkopf,  
J. Ebert, T. Dao, M. Mishra, A. Gu, C. J. Anderson, B. Dolan-Gavitt,  
D. Contractor, S. Reddy, D. Fried, D. Bahdanau, Y. Jernite, C. M.  
Ferrandis, S. Hughes, T. Wolf, A. Guha, L. V. Werra, and H. de Vries,  
“Starcoder: may the source be with you\!”Transactions on Machine  
Learning Research, 2023, reproducibility Certification.  
\[33\] W. Zhou, Y. E. Jiang, P. Cui, T. Wang, Z. Xiao, Y. Hou, R. Cotterell, and  
M. Sachan, “Recurrentgpt: Interactive generation of (arbitrarily) long  
text,” arXiv:2305.13304 \[cs.CL\], 2023\.  
\[34\] S. G. Patil, T. Zhang, X. Wang, and J. E. Gonzalez, “Gorilla: Large lan-  
guage model connected with massive apis,” arXiv:2305.15334 \[cs.CL\],  
2023\.  
\[35\] G. Li, H. Hammoud, H. Itani, D. Khizbullin, and B. Ghanem, “Camel:  
Communicative agents for ”mind” exploration of large language model  
society,” inAdvances in Neural Information Processing Systems, A. Oh,  
\`\`\`

T. Neumann, A. Globerson, K. Saenko, M. Hardt, and S. Levine, Eds.,  
vol. 36\. Curran Associates, Inc., 2023, pp. 51 991–52 008\.  
\[36\] J. S. Park, J. O’Brien, C. J. Cai, M. R. Morris, P. Liang, and M. S.  
Bernstein, “Generative agents: Interactive simulacra of human behavior,”  
inProceedings of the 36th Annual ACM Symposium on User Interface  
Software and Technology, ser. UIST ’23. New York, NY, USA:  
Association for Computing Machinery, 2023\.  
\[37\] I. Gur, H. Furuta, A. V. Huang, M. Safdari, Y. Matsuo, D. Eck,  
and A. Faust, “A real-world webagent with planning, long context  
understanding, and program synthesis,” inThe Twelfth International  
Conference on Learning Representations, 2024\.  
\[38\] “Autogpt,” https://github.com/Significant-Gravitas/AutoGPT, 2024\.  
\[39\] “Babyagi,” https://github.com/yoheinakajima/babyagi, 2024\.  
\[40\] S. Hong, M. Zhuge, J. Chen, X. Zheng, Y. Cheng, J. Wang, C. Zhang,  
Z. Wang, S. K. S. Yau, Z. Lin, L. Zhou, C. Ran, L. Xiao, C. Wu,  
and J. Schmidhuber, “MetaGPT: Meta programming for multi-agent  
collaborative framework,” inThe Twelfth International Conference on  
Learning Representations, 2024\.  
\[41\] C. Qian, X. Cong, W. Liu, C. Yang, W. Chen, Y. Su, Y. Dang, J. Li,  
J. Xu, D. Li, Z. Liu, and M. Sun, “Communicative agents for software  
development,” arXiv:2307.07924 \[cs.SE\], 2023\.  
\[42\] W. Zhou, Y. E. Jiang, L. Li, J. Wu, T. Wang, S. Qiu, J. Zhang, J. Chen,  
R. Wu, S. Wang, S. Zhu, J. Chen, W. Zhang, X. Tang, N. Zhang,  
H. Chen, P. Cui, and M. Sachan, “Agents: An open-source framework  
for autonomous language agents,” arXiv:2309.07870 \[cs.CL\], 2023\.  
\[43\] Y. Zhang, Y. Li, L. Cui, D. Cai, L. Liu, T. Fu, X. Huang, E. Zhao,  
Y. Zhang, Y. Chenet al., “Siren’s song in the ai ocean: a survey

\`\`\`  
on hallucination in large language models,” arXiv:2309.01219 \[cs.CL\],  
2023\.  
\[44\] K. Yang, X. Mao, S. Wang, T. Zhang, B. Lin, Y. Wang, Y. Qin,  
Z. Zhang, and X. Mao, “Enhancing code intelligence tasks with chatgpt,”  
arXiv:2312.15202 \[cs.SE\], 2023\.  
\[45\] “java.lang.instrument,” https://docs.oracle.com/javase/8/docs/api/java/  
lang/instrument/package-summary.html, 2024\.  
\[46\] “tree-sitter,” https://tree-sitter.github.io/tree-sitter/, 2024\.  
\[47\] Z. Qin, R. Jagerman, K. Hui, H. Zhuang, J. Wu, J. Shen, T. Liu,  
J. Liu, D. Metzler, X. Wang, and M. Bendersky, “Large language  
models are effective text rankers with pairwise ranking prompting,”  
arXiv:2306.17563 \[cs.IR\], 2023\.  
\[48\] J. Wei, X. Wang, D. Schuurmans, M. Bosma, b. ichter, F. Xia, E. Chi,  
Q. V. Le, and D. Zhou, “Chain-of-thought prompting elicits reasoning in  
large language models,” inAdvances in Neural Information Processing  
Systems, S. Koyejo, S. Mohamed, A. Agarwal, D. Belgrave, K. Cho, and  
A. Oh, Eds., vol. 35\. Curran Associates, Inc., 2022, pp. 24 824–24 837\.  
\[49\] P. S. Kochhar, X. Xia, D. Lo, and S. Li, “Practitioners’ expectations  
on automated fault localization,” inProceedings of the 25th Interna-  
tional Symposium on Software Testing and Analysis, ser. ISSTA 2016\.  
New York, NY, USA: Association for Computing Machinery, 2016, p.  
165–176.  
\[50\] X. Xia, L. Bao, D. Lo, and S. Li, “‘automated debugging considered  
harmful’ considered harmful: A user study revisiting the usefulness of  
spectra-based fault localization techniques with professionals using real  
bugs from large systems,” in2016 IEEE International Conference on  
Software Maintenance and Evolution (ICSME), 2016, pp. 267–278.  
\`\`\`


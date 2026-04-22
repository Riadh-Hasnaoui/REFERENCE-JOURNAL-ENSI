\#\# RefAgent: A Multi-agent LLM-based Framework for Automatic

\#\# Software Refactoring

\#\# Khouloud Oueslati

\#\#\# khouloud.oueslati@polymtl.ca

\#\#\# Polytechnique Montreal

\#\#\# Montreal, Canada

\#\# Maxime Lamothe

\#\#\# maxime.lamothe@polymtl.ca

\#\#\# Polytechnique Montreal

\#\#\# Montreal, Canada

\#\# Foutse Khomh

\#\#\# foutse.khomh@polymtl.ca

\#\#\# Polytechnique Montreal

\#\#\# Montreal, Canada

\#\# Abstract

\`\`\`  
Recent advancements in Large Language Models (LLMs) have sub-  
stantially influenced various software engineering tasks, including  
code generation, program repair, and software maintenance. Indeed,  
in the case of software refactoring, traditional LLMs have shown  
the ability to reduce development time and enhance code quality.  
However, these LLMs often rely on static, detailed instructions  
for specific tasks. In contrast, LLM-based agents can dynamically  
adapt to evolving contexts and autonomously make decisions by  
interacting with software tools and executing workflows. In this  
paper, we explore the potential of LLM-based agents in supporting  
refactoring activities. Specifically, we introduce RefAgent, a multi-  
agent LLM-based framework for end-to-end software refactoring.  
RefAgent consists of specialized agents responsible for planning,  
executing, testing, and iteratively refining refactorings using self-  
reflection and tool-calling capabilities. We evaluate RefAgent on  
eight open-source Java projects, comparing its effectiveness against  
a single-agent approach, a search-based refactoring tool, and his-  
torical developer refactorings. Our assessment focuses on: (1) the  
impact of generated refactorings on software quality, (2) the ability  
to identify refactoring opportunities, and (3) the contribution of  
each LLM agent through an ablation study. Our results show that  
RefAgent achieves a median unit test pass rate of 90%, reduces code  
smells by a median of 52.5%, and improves key quality attributes  
(e.g., reusability) by a median of 8.6%. Additionally, it closely aligns  
with developer refactorings and the search-based tool in identifying  
refactoring opportunities, attaining a median F1-score of 79.15% and  
72.7%, respectively. Compared to single-agent approaches, RefA-  
gent improves the median unit test pass rate by 64.7% and the  
median compilation success rate by 40.1%. These findings highlight  
the promise of multi-agent architectures in advancing automated  
software refactoring.  
\`\`\`  
\#\# Keywords

\`\`\`  
LLMs, Multi-agent, Code Refactoring, Software Quality, Code Smells  
\`\`\`  
\#\# 1 Introduction

\`\`\`  
Large-scale software systems tend to increase in complexity and  
become difficult to maintain as they evolve to adapt to changing  
requirements \[ 26 \]. Software refactoring is a standard practice that  
aims to enhance code design without altering its observable behav-  
ior \[ 20 \]. Neglecting refactoring is often associated with the accu-  
mulation of technical debt, leading to an increase in code smells  
\[25, 55\] or design flaws that violate design principles and compro-  
mise the code understandability and maintainability \[ 49 , 52 \]. These  
negative consequences ultimately lead to higher maintenance costs  
\[10, 12\].  
\`\`\`  
\`\`\`  
Since manual refactoring is error-prone, time-consuming, and  
ineffective when extensive changes are needed \[ 18 , 54 \], various  
semi-automated and fully-automated techniques have been pro-  
posed over the past decade \[ 2 , 19 , 33 \]. While IDEs offer built-in  
refactoring options, they support only a limited set of refactorings  
and still require manual effort. A Microsoft survey found that 28% of  
developers face challenges with refactoring, especially in large code-  
bases and ensuring correctness \[ 24 \]. Fully-automated techniques,  
such as search-based refactoring, offer an appealing alternative by  
formulating refactoring as an optimization problem to identify a  
refactoring sequence that enhances the program based on a defined  
fitness function, which can involve factors such as code smells or  
software quality metrics \[37\], but they often radically change pro-  
gram design \[ 3 \], lack behavior preservation guarantees\[ 4 , 9 \], and  
support a limited range of refactoring types, and are computation-  
ally prohibitive for large projects \[5, 38\].  
Recent breakthroughs in Large Language Models (LLMs) have  
sparked growing interest in applying generative AI to software  
engineering tasks such as code generation \[ 23 \], fault localization  
\[ 11 \], and automatic program repair \[ 27 \]. The emergence of LLM-  
based commercial tools like GitHub Copilot^1 and AutoCoderRover^2  
highlights practitioners’ growing interest in LLM-powered auto-  
mated software development. Developer adoption of AI is rising  
\[ 16 \], with 76% using or planning to use it, and 92% having tried  
tools like Copilot. Early efforts have also explored the use of LLMs  
in refactoring \[ 15 , 28 \], showing promise in reducing developer ef-  
fort and improving design quality. However, despite this progress,  
fully automated refactoring remains a largely unsolved problem.  
Existing techniques often suffer from one or more of the following  
limitations: poor scalability to large codebases, insufficient coverage  
of refactoring types, difficulty in maintaining behavioral correct-  
ness, and brittleness when applying transformations in real-world  
systems \[5, 24, 38\].  
This persistent gap highlights the need for more dynamic, context-  
aware, and adaptive solutions that can not only propose refactor-  
ings but also coordinate complex, multi-step workflows involving  
validation, correction, and iterative refinement. In this context, LLM-  
based agents, defined as entities that use LLMs as the cognitive core  
of the agent, can dynamically adapt to changing contexts, interact  
with tools, and execute workflows to achieve goals \[ 22 \], offer a  
promising new direction for this challenge, not just because LLMs  
are powerful, but because agents can be structured to simulate the  
reasoning and actions of skilled developers, distributing respon-  
sibilities such as code analysis, transformation, compilation, and  
\`\`\`  
(^1) https://github.com/features/copilot  
(^2) https://autocoderover.dev/

\# arXiv:2511.03153v2 \[cs.SE\] 4 Mar 2026

\`\`\`  
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY Khouloud Oueslati, Maxime Lamothe, and Foutse Khomh  
\`\`\`  
testing across specialized roles \[ 29 \]. Compared to static prompt-  
based LLMs, agents can reason, respond to intermediate feedback  
(e.g., test failures or compilation errors), and adjust plans dynami-  
cally. They can generate code, reflect on its consequences, revise  
decisions, and collaborate with one another, mirroring the way  
human developers iteratively and interactively perform refactor-  
ing in practice. Furthermore, agents enable modular reasoning: by  
breaking the refactoring process into smaller, goal-directed tasks,  
which reduces cognitive and computational complexity, improving  
both accuracy and interpretability \[50, 51\].  
Critically, multi-agent systems bring an additional advantage:  
coordination across specialized roles. A single LLM may hallucinate  
over prolonged interactions, but a system of agents, each focused  
on a well-defined subtask, can collaboratively handle complexity  
through role specialization and communication. This design aligns  
closely with how real-world refactoring is performed: as a sequence  
of discrete, dependent steps that require both autonomy and col-  
laboration \[22\].  
In this paper, we introduce RefAgent, a novel multi-agent, LLM-  
based, fully automated framework for software refactoring. Our  
approach simulates the sequential nature of software refactoring  
workflows by distributing tasks among agents, reducing develop-  
ment time, mitigating hallucinations, and ensuring behavior preser-  
vation in complex software engineering environments. Our goal  
in creating and evaluating this approach is to determine the cur-  
rent status of the potential of LLM-based multi-agents for software  
refactoring. RefAgent consists of four key components:  
Context-Aware Planner Agent – Identifies refactoring opportuni-  
ties and generates a structured plan based on dependency analysis  
and code metrics.  
Refactoring Generator Agent – Executes the refactoring plan  
provided by the Context-Aware Planner Agent on the target class,  
producing a refactored version of that class.  
Compiler Agent – Interacts with the compilation environment  
and the Refactoring Generator Agent through an iterative feedback  
loop to ensure any compilation issues are addressed.  
Tester Agent – Ensures that the refactored target class preserves  
functionality using existing and auto-generated tests using Evo-  
suite, cooperating with the Refactoring Generator Agent to fix test  
failures.  
To evaluate the effectiveness of RefAgent, we ask the following  
research questions:  
RQ1: How effective is our approach in improving the quality  
of software projects? To evaluate the effectiveness of RefAgent  
in enhancing the quality of software projects, we measure code  
Smells Reduction Rates (SRR) along with compilation success rates,  
and unit test pass rates across eight software projects. Further-  
more, we examine the prevalent refactoring types and discuss their  
implications for future improvements.  
RQ2: How effective is our approach in identifying refactor-  
ing opportunities and improving software quality compared  
to search-based techniques and developers? We assess the ability  
of RefAgent in identifying refactoring opportunities by compar-  
ing its refactoring patches across code regions against RefGen, a  
search-based refactoring tool, and developers using precision, re-  
call, and F1-score. Moreover, we compare their software quality

\`\`\`  
improvement rates using the Quality Model for Object-Oriented  
Design (QMOOD) metrics across eight software projects.  
RQ3: What is the contribution of each component of our  
framework? (Ablation study) To further showcase the effective-  
ness of RefAgent in improving software quality, we reuse the perfor-  
mance criteria from RQ1 to compare the performance of RefAgent  
against single LLM-based approaches. Moreover, we investigate  
the contribution of key components in RefAgent by conducting an  
ablation study to evaluate the performance under different settings,  
focusing on the Context-aware Planner Agent and the impact of the  
iterations in the feedback loops.  
Overall, our findings underscore the potential of multi-agent  
LLM architectures for advancing automated refactoring.  
\`\`\`  
\#\# 2 Background and Related Work

\`\`\`  
Recent advancements in Large Language Models (LLMs) have sub-  
stantially influenced various software engineering tasks \[ 45 , 53 \].  
Particularly, in the case of software refactoring, an empirical study  
by Cordeiro et al. \[ 15 \] evaluated the refactorings generated by Star-  
Coder2 \[ 30 \] against developers. They apply zero-shot and one-shot  
prompting and assess the unit test pass rate using the pass@k met-  
ric. Their results show that LLMs effectively reduce code smells  
and apply various refactoring types. While their study focused  
on a single LLM with a static prompt at commit-level granularity,  
we introduce a fully automated multi-LLM agent approach that  
leverages specialized LLM agents with tool-calling capabilities to re-  
trieve context, interact with compilation and testing environments,  
and perform complex, context-aware refactorings without manual  
intervention.  
Furthermore, we base our approach on the work proposed by  
Choi et al. \[ 13 \]. The authors present a single LLM approach that  
iteratively refactors methods identified as having high cyclomatic  
complexity by refining the LLM’s suggestions using the error stack  
trace from compilation and testing environment across 20 iterations.  
However, their pipeline is limited due to sequential refactoring of  
individual methods, while our approach refactors the projects by  
iterating through all classes of the project. In addition, we decen-  
tralize the process by assigning distinct roles to specialized LLM  
agents, each responsible for a specific subtask and environment  
(e.g., compilation or testing). This modular design ensures that each  
agent receives and processes feedback (e.g., stack traces) within  
its relevant execution context. Moreover, the proposed pipeline  
by Choi et al. lacks contextual input for the LLM to generate the  
refactoring. Yet, refactoring is a context-dependent problem \[ 33 \],  
thus we employ a context retrieval agent to help the LLM decide  
and plan the refactorings effectively.  
Multi-agent systems have shown promise in software mainte-  
nance by leveraging specialized agents that work collaboratively  
or competitively to achieve a final goal while invoking external  
tools to receive context and feedback to solve issues in real-world  
software projects. For example, agents like AutoCodeRover \[ 56 \]  
and Masai \[ 7 \] use static and dynamic checks to validate gener-  
ated patches, while others invoke tools such as those for syntactic  
correctness checking, code format checking \[ 31 \], and vulnerabil-  
ity detection \[ 35 \]. However, the use of multi-agent systems for  
end-to-end refactoring remains largely unexplored.  
\`\`\`

\`\`\`  
RefAgent: A Multi-agent LLM-based Framework for Automatic Software Refactoring Conference acronym ’XX, June 03–05, 2018, Woodstock, NY  
\`\`\`  
\`\`\`  
Run jdeps to build depndency graph using the class  
nameto identify first-degree dependent classes.  
Run DesignateJava to compute class and method  
quality metrics.  
\`\`\`  
\`\`\`  
Context-aware planner agent  
AExtract first-degree dependent classes  
BExtract quality metrics of the target class  
\`\`\`  
\`\`\`  
1  
\`\`\`  
\`\`\`  
CExtract source code of relevant classfrom the project.  
\`\`\`  
\`\`\`  
Prompt:{  
Query: Generate a refactoring plan for the  
java class  
Code Snippet: Input source code  
Context: and }B  
\`\`\`  
\`\`\`  
Context-aware Prompt  
\`\`\`  
\`\`\`  
Code search modulesearch for the class  
\`\`\`  
\`\`\`  
Class dependency graph  
\`\`\`  
\`\`\`  
get dependent classes Dependent class 1  
Dependent class 2  
...  
\`\`\`  
\`\`\`  
2  
\`\`\`  
\`\`\`  
Refactoring generator agent  
Prompt:{  
Query: Follow the instruction to generate a  
refactored version of the target class.  
Instruction: Refactoring plan  
Code Snippet: Source code of target class  
3 Context: , }C^  
\`\`\`  
\`\`\`  
Compiler agent  
\`\`\`  
\`\`\`  
Tester agent  
\`\`\`  
\`\`\`  
4  
\`\`\`  
\`\`\`  
Failed  
\`\`\`  
\`\`\`  
Failed  
\`\`\`  
\`\`\`  
Maven compiler  
tool  
\`\`\`  
\`\`\`  
Updated  
java project  
\`\`\`  
\`\`\`  
If compiler fail return the error  
message and request code fix  
else return success  
\`\`\`  
\`\`\`  
Test suite  
generation tool graph: Extract testsClass dependency Maven test tool  
\`\`\`  
\`\`\`  
5 Success  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
20  
\`\`\`  
\`\`\`  
Context retrieval tool  
\`\`\`  
\`\`\`  
B  
\`\`\`  
\`\`\`  
A  
\`\`\`  
\`\`\`  
C  
\`\`\`  
\`\`\`  
If all tests pass, we keep the applied refactored code  
If test fails after 20 iterations, we keep the original code  
\`\`\`  
\`\`\`  
6  
\`\`\`  
\`\`\`  
Figure 1: RefAgent Overview  
\`\`\`  
\#\# 3 RefAgent Approach

\#\# 3.1 Overview

\`\`\`  
In this section, we present an overview of the overall phases of  
RefAgent, a multi-agent framework that iteratively improves the  
quality of each class in a given Java project. RefAgent is designed  
to simulate the sequential nature of end-to-end refactoring, where  
the goal is to improve weakly structured code through extensive  
refactoring, commonly known as Root-canal refactoring \[ 18 \]. The  
framework allows users to run the workflow autonomously to  
enhance the quality of a given codebase, significantly reducing  
the manual effort required for large-scale refactoring tasks. For a  
given project, a randomly-selected target class as a starting point,  
the workflow of RefAgent leverages specialized LLM agents for  
the context-aware identification of refactoring opportunities and  
planning as well as ensuring the compilation of the modified source  
code, and thorough testing to ensure that functionality is preserved  
for the modified target class.  
Particularly, following previous work \[ 13 \], RefAgent iteratively  
analyzes feedback across 20 iterations using external tools such  
as the compilation and testing environments, and integrates lin-  
guistic reflections to refine its refactoring suggestions \[ 42 \]. This  
iterative self-improvement mechanism enables RefAgent to dynam-  
ically adapt and enhance the quality of code transformations. The  
following sections provide detailed descriptions of each of our four  
agents.  
\`\`\`  
\#\# 3.2 Context-aware Planner Agent

RefAgent employs an LLM agent, the Context-aware Planner  
Agent, which uses a Java class as a starting point. The agent is  
equipped with tool-calling capabilities that allow the model to de-  
tect when one or more tools should be called and respond with  
the inputs that should be passed to those tools. Specifically, it can  
call the context-retrieval module that runs the dependency analysis  
tool jdeps, passing the class name and the project path as inputs,  
which generates a class-level dependency graph. Next, following  
prior work \[ 15 \], the agent invokes a code smell extraction tool  
DesigniteJava 2.5.2 \[ 41 \] that also provides software metrics detailed  
in Section 4.2.2. DesigniteJava then takes the path to the source

\`\`\`  
Java code as input and returns a set of quality metrics (e.g, cyclo-  
matic complexity, lack of cohesion, etc.) that the Context-aware  
Planner Agent will use for identifying refactoring opportunities  
and generating a refactoring plan for the target class. Note that  
within RefAgent, we do not use its code smell detection capabil-  
ities in the refactoring process itself. Instead, the planner agent  
leverages only the extracted code metrics to provide context for  
the decision-making driven by the agent’s reasoning. We ensure  
that the planner’s decisions about which code regions to refactor  
are not biased by labeled smell instances from DesigniteJava.  
\`\`\`  
\`\`\`  
Query provide a detailed : You are a software engineerplan for refactoring a given target class., expert in Java code improvement. Your primary task is to  
Context:  
{target\_class\_code} (The source code of the target class)  
{target\_class\_quality\_metrics} (Computed quality metrics for the target class)  
{dependent\_classes} (List of classes dependent on the target class)  
Output Format (JSON):  
{ "class\_name": {  
"refactoring": true/false, "instruction": "Detailed refactoring steps for the class."  
}, "methods": {  
"method\_name\_1": { "refactor": true/false,  
"instruction": "Detailed instructions on how to refactor this method." }...  
}  
\`\`\`  
\`\`\`  
Figure 2: Context-aware Planner Prompt  
\`\`\`  
\`\`\`  
After, the Context-aware Planner Agent calls the code-search  
module, which is a module that retrieves the source code of the  
target class as well as the source code of its first-degree dependent  
classes. The module searches for the target source code and its direct  
dependencies by taking as input the full name of the target class  
(including its package) and the dependency graph provided by the  
jdeps tool. It then iterates through the project folder to locate and  
return the source code of the required classes. Therefore, the agent  
considers information from related classes to suggest higher-level  
design improvements or class-level refactorings when applicable.  
Next, the Context-aware Planner Agent builds the prompt ac-  
cording to the template as shown in Figure 2 for its core LLM to  
identify refactoring opportunities and assign the proper refactor-  
ings for the various code regions (e.g., method, field, variable) of  
the target class. Finally, the Context-aware Planner Agent provides  
\`\`\`

\`\`\`  
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY Khouloud Oueslati, Maxime Lamothe, and Foutse Khomh  
\`\`\`  
\`\`\`  
a refactoring plan comprising of the particular code regions identi-  
fied for improvement along with explicit refactoring instructions  
designed to be interpretable by downstream LLM agents.  
\`\`\`  
\#\# 3.3 Refactoring Generator Agent

\`\`\`  
The primary objective of the Refactoring Generator Agent is to  
generate refactored Java code following the instructions of Context-  
aware Planner Agent, while ensuring the correctness and function-  
ality of the output.  
This agent takes as input the original source code of the target  
class, the source code of dependent classes, software metrics, and  
the refactoring plan. It applies the refactoring plan to produce an  
improved version of the class, updates the code, and initiates the  
compilation phase. The Refactoring Generator Agent should return  
Java code as output as instructed in the prompt.  
As shown in Figure 1, the Refactoring Generator Agent is in-  
voked by different agents, including the Compiler Agent and the  
Tester Agent, in case of compilation or test failures in order to  
dynamically adapts its prompt while maintaining the primary ob-  
jective of following the refactoring plan as shown in the Figure 2\.  
The prompt context can vary depending on:  
\`\`\`  
\- Compilation errors (when called by the Compiler Agent)  
\- Test failures (when called by the Tester Agent)  
\- The original refactoring plan (when initially generating the  
refactored class)  
Regardless of the context, the Refactoring Generator Agent is  
required in the prompt to ensure that the refactoring instructions  
from the planner remain the guiding principle. It continuously  
refines the code while ensuring that the final output is syntactically  
correct, functional, and successfully passes compilation and testing.

\`\`\`  
Query: You are an expert Java software engineer. Your primary task is to refactor the  
provided Java code following in details the refactoring plan.  
Instruction:  
{Tester agent instruction OR Compiler agent instruction } (if test/compiltion failed)  
Context:  
{Refactoring plan}  
{target\_class\_code}  
{dependent\_classes}  
{Test or Compilation\_error\_summary} (A summary of the error from  
the Tester/Compiler agent)  
Output Format:  
'''  
refactored java class code base  
'''  
\`\`\`  
Figure 3: Illustrative example of the Refactoring Generator  
Agent prompt

\#\# 3.4 Compiler Agent

\`\`\`  
The Compiler Agent employs a self-reflection loop \[ 42 \] by inter-  
acting with the Maven compiler tool to validate the syntax of the  
refactored code. If a compilation error occurs, the error message  
is sent to the LLM, which analyzes the error, generates an error  
summary, and forwards it to the Refactoring Generator Agent for  
reflection and correction. The feedback loop is set to a maximum  
of 20 iterations, following previous work \[ 13 \] to assess the extent  
to which it can effectively refine the generated refactorings. The  
Compiler Agent’s reflection process is as follows:  
\`\`\`  
\`\`\`  
(1)After the Refactoring Generator agent proposes a refactor-  
ing, the compiler agent invokes the Maven compiler tool to  
compile the updated refactored project. This tool executes  
the Maven compilation command on the operating system  
without running tests, ensuring that the code syntax is cor-  
rect.  
(2)The Maven compiler tool then returns logs to the compiler  
agent, detailing the compilation status.  
\`\`\`  
\- If compilation succeeds (100%), the compiler agent con-  
    firms success and proceeds to the Tester agent for further  
    validation.  
\- If compilation fails, the compiler agent analyzes the er-  
    ror logs, extracts the necessary debugging information, and  
    generates a structured error summary.  
(3)The error summary, along with specific fixing instructions,  
are sent to the Refactoring Generator Agent, enabling it to  
reflect on the error, modify the code, and attempt a fix. This  
iterative process continues until successful compilation is  
achieved or the iteration limit is reached.

\#\# 3.5 Tester Agent

\`\`\`  
Code refactoring should not alter the external functionality of the  
code \[ 20 \]. It is thus necessary to execute tests to evaluate whether  
the refactored code retains its original functionality. In this process,  
the Tester Agent uses the code search module to locate developer-  
written tests from the class-level dependency graph generated by  
jdeps and employs the automated test suite generation tool EvoSuite  
to generate additional regression tests, The regression tests are  
created based on the original program before any refactoring is  
applied. We use these tests in an attempt to maximize the validation  
of the modified source code.  
Similar to the Compiler Agent, the Tester Agent employs a feed-  
back loop of up to 20 iterations. If a test fails, it reads the logs,  
analyzes the errors, and generates a summary report. This report,  
along with the failing test cases, is sent to the Refactoring Generator  
agent, requesting a fix as shown in Figure 3\. If the refactoring patch  
continues to fail after all iterations, the agent excludes the target  
class from further improvements and proceeds to the next iteration  
without applying the refactorings. The Tester agent interacts with  
three main tools:  
EvoSuite. Since some projects may lack developer-written test  
cases, Tester Agent calls EvoSuite which takes the target class name  
as input and automatically generates unit tests optimized for max-  
imum code coverage (e.g, Line Coverage, Branch Coverage and  
Output Coverage). EvoSuite integrates JUnit 4 assertions to capture  
and validate expected behavior in test cases.  
JDeps. The jdeps tool extracts the dependency graph of the  
project and identifies test cases that are directly related to the  
target classes. This ensures that relevant developer-written tests  
are identified and executed for validation.  
Maven Test Tool. Similar to the Maven compiler tool, the Maven  
test tool interacts with the operating system to execute tests using  
Maven. The Tester Agent triggers the execution of both developer-  
written and EvoSuite-generated tests to ensure that the observable  
behavior of the refactored code remains unchanged.  
Finally, this workflow is autonomously executed throughout all  
the classes of the project. In Section 5, we evaluate the impact of  
\`\`\`

\`\`\`  
RefAgent: A Multi-agent LLM-based Framework for Automatic Software Refactoring Conference acronym ’XX, June 03–05, 2018, Woodstock, NY  
\`\`\`  
RefAgent on 8 software projects using various evaluation metrics.  
We compare RefAgent against developers, a search-based refactor-  
ing tool named RefGen \[ 32 \], and single-agent scenarios. We also  
examine the performance of our framework RefAgent, using three  
LLMs, notably GPT-4o, StarCoder2 and DeepseekCoder.

\#\# 4 Experimental Methodology

\#\# 4.1 Studied Models and Dataset

Models. We initially design RefAgent using the closed-source GPT-  
4o model as its core LLM. To further assess its performance, we  
benchmark RefAgent against two open-source models: StarCoder2-  
15B-instruct \[ 30 \] and DeepSeekCoder-33B-instruct \[ 17 \]. Prior work  
highlights StarCoder2’s effectiveness in refactoring, showing im-  
provements in code quality and unit test pass rates using zero-shot  
and one-shot prompting \[ 15 \]. The study also mitigates data leakage  
by filtering recent Java projects not present in the StackV2 training  
data \[14, 30\], an approach we follow in our setup.  
DeepSeekCoder has demonstrated strong performance on code  
generation and reasoning benchmarks. We include it to evaluate  
whether large instruction-tuned open models can match or outper-  
form GPT-4o in automated refactoring.  
GPT-4o supports a 128K token context window, while StarCoder  
and DeepSeekCoder are limited to 8192 tokens. To ensure fair com-  
parison, we run RefAgent only on classes under 4096 tokens, reserv-  
ing the remaining space for dependent code and agent instructions,  
similar to OpenAI’s dynamic context handling in ChatGPT. We  
use a temperature of 0.7 for GPT-4o to balance consistency and  
diversity.

\`\`\`  
Table 1: Dataset Overview  
Project name Release Release date Nbr of classes Nbr of Methods KLOC  
JClouds 2.3.0 05-2024 9,972 44,797 646  
Accumulo 1.10.4 11-2023 2,286 40,353 603  
systemml 3.2.0-rc1 02-2024 3,986 41,962 658  
apex-core 3.7.0-rc1 07-2021 1,378 5,432 107  
skywalking 9.7.0 11-2023 2,871 9,736 192  
deltaspike 1.9.6 04-2022 2,155 6,471 139  
Jmeter 5.6.3-rc1 12-2023 1,723 14,074 247  
openmeetings 7.2.0 12-2023 1,306 8,441 188  
\`\`\`  
Dataset. We randomly select eight open-source Apache Java  
projects, due to resource constraints, from a dataset widely used in  
prior research \[ 14 , 15 \]. We then filter out projects that are included  
in StarCoder2’s training dataset Stackv2 \[ 30 \] to remove the risk of  
data-leakage on that model. Unfortunately, due to the closed-source  
nature of GPT-4o, we cannot ensure no data leakage for that model.  
We therefore rely on StarCoder2 to determine the strength of our  
approach in a more controlled setting. The details of the selected  
projects, including their size and characteristics, are summarized  
in Table 1\.  
Hardware and Computational Resources. StarCoder2 ex-  
periments are conducted on a computing server with 80 GB of  
memory. The operating system used is Ubuntu 22.04.4 LTS. We use  
a GPU-accelerated setup similar to previous work \[ 15 \], leveraging  
the Nvidia A100 GPUs for efficient model inference and code gen-  
eration. The GPT4o-based experiments use GPT-4o via the OpenAI  
API, using cloud-based inference for model execution.

\#\# 4.2 Impact on Software Quality Assessment

\`\`\`  
4.2.1 Code Smells Extraction. Code smells are indicators of  
underlying design or implementation issues that may impact main-  
tainability, readability, and overall software quality \[ 43 \]. Since code  
refactoring is commonly associated with the elimination of code  
smells \[ 52 \], we extract code smells from the Java projects to mea-  
sure the capabilities of RefAgent in reducing code smells. We use  
DesigniteJava 2.5.2 \[ 41 \] to extract code smells from the source code  
before and after the project is refactored. DesigniteJava detects  
46 different types of code smells. We assess how well RefAgent  
mitigates code smells compared to competing approaches. we focus  
on the following categories:  
Design Smells: Poor adherence to design principles that hinder  
modularity and reusability (e.g., unnecessary abstraction).  
Implementation Smells: Code-level issues that make the code  
harder to maintain (e.g., large classes, long methods).  
\`\`\`  
\`\`\`  
4.2.2 Quality Metrics Computation. We use the Quality Model  
for Object-Oriented Design (QMOOD), proposed by the prior work  
\[ 8 \], which consists of a set of quality measures using the ISO 9126  
specification. It defines six high-level design quality attributes:  
reusability, flexibility, understandability, functionality, extensibility,  
and effectiveness that can be calculated using 11 lower-level design  
metrics as detailed in Table 2\. We use QMOOD to estimate the effect  
of the suggested refactoring solutions on quality attributes, simi-  
larly to many prior works \[ 3 , 5 \]. Likewise, we calculate the Quality  
Improvement (QI) for each quality attribute using the following  
formula.  
\`\`\`  
\#\#\#\# 𝑄𝐼(𝐴𝑞)=

\#\#\#\# 𝐴𝑞(𝑝′)− 𝐴𝑞(𝑝)

\#\#\#\# |𝐴𝑞(𝑝)|

\#\#\#\# × 100 (1)

\`\`\`  
where𝐴𝑞(𝑝)represents the measurement of quality attribute𝑞for  
project𝑝, and𝑝′denotes the refactored version of project𝑝. The  
sign indicates an increase (+) or decrease (-), while the numerical  
value represents the percentage of improvement. Since QMOOD  
attribute calculations may yield negative values in the original  
design, taking the absolute value of the divisor is essential.  
By analyzing each QMOOD attribute before and after refactoring,  
we assess the effectiveness of RefAgent in enhancing software  
maintainability, modularity, and overall design quality. We compute  
the metrics using the tool available online.^3  
\`\`\`  
\#\# 4.3 Identification of Refactoring opportunities

\`\`\`  
4.3.1 Experimental details. We employ RefactoringMiner 3\.  
\[ 46 , 47 \], which is a tool designed only to detect and classify refac-  
toring operations between version histories or commits, to examine  
the refactorings applied by RefAgent. RefactoringMiner represents  
the state of the art in refactoring detection, supporting up to 59  
different types of refactorings. The evaluation of RefactoringMiner  
on this dataset, performed in previous work \[ 34 \], shows an overall  
precision of 99.7% and a recall of 94.2%, confirming it as an accurate  
refactoring detection tool \[ 48 \]. The process is as follows: for each  
project𝑝at release version𝑣, we create a fork. After RefAgent  
refactors a class, we commit the modified class to the fork.  
\`\`\`  
(^3) https://github.com/dimizisis/metrics\_calculator/

\`\`\`  
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY Khouloud Oueslati, Maxime Lamothe, and Foutse Khomh  
\`\`\`  
\`\`\`  
Table 2: QMOOD Computation Equations.  
Quality Attribute Quality Attribute Calculation  
Reusability \-0.25 \* DCC \+ 0.25 \* CAM \+ 0.5 \* CIS \+ 0.5 \* DSC  
Flexibility 0.25 \* DAM \- 0.25 \* DCC \+ 0.5 \* MOA \+ 0.5 \* NOP  
\`\`\`  
\`\`\`  
Understandability  
\`\`\`  
\#\#\#\# \-0.33 \* ANA \+ 0.33 \* DAM \- 0.33 \* DCC \+ 0.33 \* CAM \- 0.33 \* NOP \- 0.33 \* NOM \- 0.33 \* DSC \+ 0.33 \* CAM

\#\#\#\# \- 0.33 \* NOP \- 0.33 \* NOM \- 0.33 \* DSC

\`\`\`  
Effectiveness 0.2 \* ANA \+ 0.2 \* DAM \+ 0.2 \* MOA \+ 0.2 \* MFA \+ 0.2 \* NOP  
Extendibility 0.5 \* ANA \- 0.5 \* DCC \+ 0.5 \* MFA \+ 0.5 \* NOS  
Functionality 0.12 \* MOA \+ 0.22 \* MOP \+ 0.22 \* CIS \+ 0.22 \* DSC \+ 0.22 \* NOH  
Note: DSC is design size, NOM is number of methods, DCC is coupling, NOP is polymorphism, NOH is number of hierarchies,  
CAM is cohesion among methods, ANA is avg. num. of ancestors, DAM is data access metric, MOA is measure of aggregation,  
MFA is measure of functional abstraction, and CIS is class interface size.  
For each commit corresponding to a refactored class in𝑝, we  
apply RefactoringMiner, which extracts the refactoring types and  
their locations within the commit. RefactoringMiner returns de-  
tailed information, including the class name, method name, and  
the specific lines of code where each refactoring was applied. We  
leverage this information to match RefAgent’s refactorings with  
the extracted refactorings, allowing us to compare our results with  
developer-introduced changes. Furthermore, for each project𝑝, we  
clone the next release𝑣n+1and apply RefactoringMiner. Refactor-  
ingMiner automatically extracts all commits in version𝑣n+1and  
returns the identified refactoring types and their locations. If no  
refactoring is found, it generates an empty folder containing only  
the commit ID. Note that in our study, RefactoringMiner is used  
exclusively in the evaluation of RefAgent.  
\`\`\`  
4.3.2 Relevance to Search-based Refactoring Approaches  
and Developers. Previous work has shown that search-based  
refactoring approaches excel in identifying refactoring opportuni-  
ties by using optimization algorithms that explore the search space  
of possible refactorings to maximize software quality \[ 1 \]. Thus,  
we compare the refactoring opportunities identified by RefAgent  
with those made by RefGen, a search-based refactoring tool that  
implements efficient refactoring scheduling based on partial order  
reduction \[ 32 \]. RefGen was initially developed as an Eclipse plug-in  
designed to suggest sequences of refactorings to improve the design  
quality of software systems by addressing anti-patterns and code  
smells detected across different classes. The generated refactoring  
sequence is ordered to maximize design quality improvement while  
avoiding conflicts among the suggested refactorings.  
RefGen provides an option to run the tool in simulation mode.  
In this mode, RefGen constructs an abstract code design model,  
identifies anti-patterns, and generates a sequence of refactoring  
candidates, which are then applied to the design model rather than  
the actual code. This simulation capability is particularly useful for  
our analysis, as it allows us to evaluate the proposed refactoring  
solutions and estimate the potential design quality improvements  
resulting from applying a complete refactoring sequence.  
The objective is to determine whether RefAgent applies refactor-  
ings in the same class, method, and location as baseline approaches,  
notably the developers and the RefGen tool.  
To quantify the alignment between RefAgent and baseline ap-  
proaches, we compute the following evaluation metrics:  
Precision: Measures the proportion of refactorings suggested by  
RefAgent that are also present in the selections done by baseline

\`\`\`  
approaches.  
\`\`\`  
\`\`\`  
𝑃𝑟𝑒𝑐𝑖𝑠𝑖𝑜𝑛=  
\`\`\`  
\#\#\#\# 𝑇𝑃

\#\#\#\# 𝑇𝑃 \+ 𝐹𝑃

\#\#\#\# (2)

\`\`\`  
Recall: Measures the proportion of the baseline’s refactorings that  
were also applied by RefAgent.  
\`\`\`  
\#\#\#\# 𝑅𝑒𝑐𝑎𝑙𝑙=

\#\#\#\# 𝑇𝑃

\#\#\#\# 𝑇𝑃 \+ 𝐹𝑁

\#\#\#\# (3)

\`\`\`  
F1-score: The harmonic mean of precision and recall, balancing  
correctness and completeness.  
\`\`\`  
\#\#\#\# 𝐹 1 \= 2 ×

\#\#\#\# 𝑃𝑟𝑒𝑐𝑖𝑠𝑖𝑜𝑛× 𝑅𝑒𝑐𝑎𝑙𝑙

\#\#\#\# 𝑃𝑟𝑒𝑐𝑖𝑠𝑖𝑜𝑛+ 𝑅𝑒𝑐𝑎𝑙𝑙

\#\#\#\# (4)

\`\`\`  
A higher F1-score indicates strong alignment between RefAgent and  
developers, or between RefAgent and RefGen tool, in identifying  
refactoring opportunities.  
\`\`\`  
\#\# 5 Results

\#\# 5.1 RQ1: How effective is our approach in

\#\# improving the quality of software projects

\`\`\`  
5.1.1 Motivation. Improving software quality is a core objective  
of automated refactoring, yet existing techniques exhibit limitations  
such as producing behavior-breaking changes and a limited set of  
supported refactoring types. To evaluate whether RefAgent can  
address these limitations, we examine its impact on key quality  
indicators across 8 real-world software projects and discuss its  
prevalent refactoring types.  
\`\`\`  
\`\`\`  
5.1.2 Approach. As indicated in Section 4, we evaluate RefAgent  
using GPT-4o, DeepSeek-Coder and StarCoder2. Next, RefAgent  
runs autonomously with LLM agents collaborating towards a shared  
goal, which is refactoring the codebase by iterating through classes  
while preserving the behavior. As detailed in Section 3, RefAgent  
starts by identifying refactoring opportunities, planning the appro-  
priate refactoring solutions, and executing the rest of the workflow.  
To evaluate the effectiveness of RefAgent in improving soft-  
ware quality, we measure its impact on code smells, compilation  
success rates, and unit test pass rates. First, a Java project is  
selected, then we use DesigniteJava to detect and record the code  
smells. For the purpose of our study, we manually ensure that the  
project before refactoring is initially compilable and has a 100%  
unit test pass rate with regards to its existing developer-written  
test suites.  
\`\`\`

\`\`\`  
RefAgent: A Multi-agent LLM-based Framework for Automatic Software Refactoring Conference acronym ’XX, June 03–05, 2018, Woodstock, NY  
\`\`\`  
\`\`\`  
The gain in each metric is assessed using the Improvement Rate  
(IR), following the approach used in previous studies \[ 15 \]. It is  
calculated as follows:  
\`\`\`  
\#\#\#\# 𝐼𝑅=

\`\`\`  
𝑚before−𝑚after  
𝑚before  
\`\`\`  
\#\#\#\# × 100 (5)

where𝑚beforerepresents the initial metric value (e.g., code smell  
count or quality metric), and𝑚afterrepresents the corresponding  
metric value after refactoring. This formula allows us to quantify  
the relative improvement introduced by RefAgent across different  
software quality dimensions.  
Furthermore, we identify code smells in both the original and  
refactored projects, as described in Section 4.2.1. We compute the  
Improvement Rate (IR) for each code smell type, grouping them  
by category to analyze which type is most effectively reduced by  
RefAgent.  
To assess the statistical differences in improvements for code  
smells and unit tests relative to the baseline across all projects, we  
use the Wilcoxon signed-rank test \[ 6 \], as the measurements being  
compared are paired. A significance threshold of p\< 0\. 05 is used  
to determine statistical significance.  
.  
Table 3: RefAgent Performance Evaluation Across 8 Projects

\`\`\`  
Unit Test  
Pass Rate  
\`\`\`  
\`\`\`  
Compilation  
Pass Rate  
\`\`\`  
\`\`\`  
Smell  
RefAgent reduction rate  
Median Avg Median Avg Median Avg  
GPT 90 86.8 87 89.6 52.5 53\.  
Starcoder 85 83.8 84 83.6 50 50\.  
DeepSeek-coder 90 98.5 88 91.8 53.5 52\.  
p-value 0.053 0.064 0\.  
\`\`\`  
5.1.3 Findings. RefAgent exhibits high unit test and com-  
pilation pass rates, indicating that a multi-agent approach  
can preserve functionality and syntactic correctness, while  
effectively reducing code smells.  
As shown in Table 3, RefAgent achieves a median unit test pass  
rate of 90% and 90.5% when using GPT-4o and DeepSeekCoder, re-  
spectively, while RefAgent-StarCoder achieves around 85%. Compi-  
lation pass rates follow a similar trend, with RefAgent-DeepSeeker-  
coder and RefAgent-GPT attaining a median of 87% and 88%, respec-  
tively, compared to 84% for RefAgent-StarCoder. The consistently  
high unit test pass rates and compilation success rates suggest that  
our multi-agent approach effectively preserves functionality across  
refactored projects, ensuring that structural improvements do not  
compromise correctness and syntactic integrity, while achieving an  
average code smell reduction of 52.5%, 53.5%, and 50% for RefAgent  
using GPT-4o, DeepSeek-Coder, and StarCoder, respectively.  
RefAgent operates agnostically to the underlying LLM.  
When evaluating unit test pass rates, compilation success,  
and smell reduction rates, no statistically significant differ-  
ences were observed between GPT-4o, DeepSeek-Coder, and  
StarCoder (p \> 0.05). Figure 4 shows the effectiveness of RefA-  
gent using GPT-4o, DeepSeek-Coder, and StarCoder in reducing  
different categories of code smells. RefAgent using GPT-4o and  
DeepSeek-coder are more effective in improving modularization  
and reducing complexity, which may suggest that they have a better  
structural understanding. In contrast, RefAgent-Starcoder is better

\`\`\`  
at handling abstraction and implementing simpler fixes at the im-  
plementation level (e.g., removing unnecessary elements, such as  
magic numbers).  
\`\`\`  
\`\`\`  
Figure 4: Comparison of Design and Implementation Code  
Smell Reduction Rate (SRR) for RefAgent-GPT, RefAgent-  
DeepSeek-coder and RefAgent-Starcoder.  
\`\`\`  
\`\`\`  
Next, we use RefactoringMiner to identify the refactoring types  
applied by RefAgent. A total of 23 refactoring types were detected  
across projects. Figure 5 shows the distribution of the top 12 refactor-  
ing types that RefAgent performs. We show that GPT-4o, DeepSeek-  
Coder, and Starcoder have comparable refactoring behaviors in Ex-  
tract Method, Invert Condition, Parameterize Variable, and Merge  
Conditional. However, RefAgent using GPT-4o and DeepSeek-Coder  
applies Rename Attribute and Change Method Access Modifier 30%  
more than Starcoder. In contrast, RefAgent-Starcoder takes a more  
conservative stance, performing Remove Variable Modifier and  
Replace Conditional With Ternary 60% less than RefAgent-GPT  
or RefAgent-DeepSeek-Coder, suggesting a reluctance to modify  
variables and conditional structures.  
RefAgent’s refactoring behavior varies depending on the un-  
derlying LLM, with GPT-4o and DeepSeek-Coder favoring more  
structural changes while Starcoder adopts a more conservative  
approach, suggesting that the choice of LLM can influence the bal-  
ance between code transformation and preservation in automated  
refactoring.  
\`\`\`  
\`\`\`  
Figure 5: Comparison of Top 12 Refactoring Types counts  
across 8 projects  
\`\`\`  
\`\`\`  
RefAgent exhibits a high median unit test rate (median  
90%) and compilation pass rates (median 87%), indicating  
that a multi-agent approach can preserve functionality  
and syntactic correctness while effectively reducing code  
smells. RefAgent operates agnostically to the underlying  
LLM. Moreover, RefAgent performs 23 types of refactoring.  
\`\`\`

\`\`\`  
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY Khouloud Oueslati, Maxime Lamothe, and Foutse Khomh  
\`\`\`  
\#\# 5.2 RQ2: How effective is our approach in

\#\# identifying refactoring opportunities and

\#\# improving software quality compared to

\#\# search-based techniques and developers?

\`\`\`  
5.2.1 Motivation. RefAgent relies on the reasoning capabilities  
of LLM-based agents, which can reason over the given context,  
generate, and validate refactorings through dynamic workflows.  
Specifically, the Context-aware Planner Agent is responsible for  
identifying refactoring opportunities and assigning the proper refac-  
torings for the various code regions (e.g., method, field, variable)  
of the target class. To examine the effectiveness of RefAgent, we  
compare its ability to identify and apply meaningful refactorings  
against both automated baselines and developer-applied changes.  
\`\`\`  
5.2.2 Approach. To evaluate RefAgent’s ability in identifying  
refactoring opportunities, we compare its refactoring selections  
with those made by developers and RefGen \[ 32 \], a search-based  
refactoring algorithm that was shown to effectively identify refac-  
toring opportunities. The objective is to determine whether RefA-  
gent applies refactorings in the same class, method, and location as  
developers and RefGen.  
First, for every class refactored by RefAgent, we extract refactor-  
ing locations and types from our 8 projects using Refactoring Miner  
as discussed in Section 4.3. Second, we execute the search-based  
refactoring tool RefGen on the projects, from which we extract the  
refactored classes. Finally, in the case for developers, we select the  
next release for each of our eight projects, then run Refactoring-  
Miner on it to collect historical refactoring commits that contain  
the refactored classes, methods as well as the types.  
We present two scenarios:  
Scenario 1: We determine a match between RefAgent’s and devel-  
opers’ refactorings by comparing the class name, method name,  
line of code range, and refactoring type: if all attributes align, it is  
a match; otherwise, it is not a match.  
Scenario 2: Since RefGen tool does not provide location and code  
change details, we determine a match if RefGen and RefAgent apply  
the same refactoring type to the same class and method.  
Finally, we compute Precision, Recall, and F1-score, as discussed  
in Section 4.3, to quantify the degree of alignment, determining  
whether RefAgent more closely follows developer decisions or  
search-based approaches.

\`\`\`  
5.2.3 Findings. RefAgent effectively identifies refactoring  
opportunities, achieving strong alignment with both devel-  
opers (78% median across our subject systems) and RefGen  
(72% median across our subject systems).  
\`\`\`  
\`\`\`  
Table 4: Median values of Precision, Recall, F1-score of RefA-  
gent compared to developers vs Refgen  
Refagent Developer RefGen  
\# Precision \# Recall \# F1-Score \# Precision \# Recall \# F1-Score  
GPT-4o 78 81 80 75 70 72  
DeepSeek-coder 79 81 80 75 70 72  
StarCoder 72 73 73 69 68 69  
Median 78 81 80 75 70 72  
\# Median value, rounded number  
\`\`\`  
\`\`\`  
In table 4, we compare the precision, recall, and F1-score of  
RefAgent against developers and RefGen. The results highlight  
\`\`\`  
\`\`\`  
that RefAgent achieves a high median recall of 81% and a median  
F1-score of 80% when compared to developers, demonstrating its  
ability to identify refactoring opportunities and mimicking develop-  
ers’ intuition. Precision remains slightly lower with a median value  
of 78%, suggesting that while RefAgent identifies a broad range  
of changes, some improvement may still be needed. Additionally,  
we observe that RefAgent shows strong alignment with the opti-  
mized search-based tool RefGen, achieving a median F1-score of  
72%. When using GPT-4o, DeepSeek-Coder, and StarCoder, RefA-  
gent maintains a consistent performance with F1-score 80%, 80%  
and 69% respectively, demonstrating its ability to generalize well  
across different LLM architectures. Since GPT-4o, being a closed-  
source model, faces the risk of data leakage. We therefore rely on  
StarCoder2 to determine the strength of our approach in a more  
controlled setting.  
While precision, recall, and F1-score provide useful insights into  
RefAgent’s effectiveness, their interpretation should be approached  
with nuance. These metrics assume that developers and RefGen  
serve as definitive references, yet they may also overlook meaning-  
ful refactorings that RefAgent successfully identifies. As a result,  
some misalignment does not necessarily indicate that RefAgent  
produced incorrect or suboptimal results, particularly if the applied  
refactorings lead to improved code quality. Given that search-based  
approaches aim to generate optimal solutions, it is important to  
acknowledge that multiple valid refactoring solutions may exist.  
Therefore, rather than viewing misalignments strictly as errors,  
they should be carefully analyzed to assess whether RefAgent is  
capturing valuable transformations beyond those identified by de-  
velopers and RefGen. In future work, we will further investigate this  
aspect to better understand the impact of RefAgent’s refactorings.  
\`\`\`  
\`\`\`  
Table 5: QMOOD Improvement Rates (IR) values across dif-  
ferent attributes for RefAgent vs RefGen.  
\`\`\`  
\`\`\`  
QMOOD RefAgentGPT-4o RefAgentStarcoder Deepseek-coderRefAgent RefGen  
Reusability 8.16 5.48 8.19 16\.  
Flexibility \-0.62 \-0.35 \-0.63 \-5.  
Understandability \-14.34 \-13.47 \-14.44 \-19.  
Functionality 4.75 0.49 4.75 0  
Extendibility 0 0 0 5\.  
Effectiveness 4.28 3.39 4.29 \-9.  
p-value 0.843 0.687 0.852 \-  
\`\`\`  
\`\`\`  
From Table 5, we observe that RefAgent improves reusability,  
understandability, and functionality compared to RefGen. Given  
the metric definitions in Table 2, these improvements indicate that  
RefAgent enhances method cohesion, which aligns with our find-  
ings in RQ1 5.1, where RefAgent frequently applies Extract Method  
refactorings or modifies method access modifiers.  
Additionally, while understandability is lower in RefAgent than  
in RefGen, the difference remains comparable. This can be attrib-  
uted to RefAgent’s effectiveness in reducing complexity compared  
to RefGen, as lower complexity can lead to reduced understandabil-  
ity despite improved cohesion.  
Moreover, compared to RefGen, RefAgent shows an increase  
in effectiveness and a slight increase in flexibility. This can be ex-  
plained by RefAgent’s improvement in the number of polymorphic  
methods, as polymorphism positively impacts both metrics by en-  
hancing method adaptability and reusability within the design.  
\`\`\`

RefAgent: A Multi-agent LLM-based Framework for Automatic Software Refactoring Conference acronym ’XX, June 03–05, 2018, Woodstock, NY

Overall, RefAgent’s structured refinement process through multi-  
agent collaboration demonstrates refactoring improvements that  
are competitive and comparable (p-value≥0.05) with the search-  
based optimization approach of RefGen.

\`\`\`  
RefAgent presents a fully autonomous means to identify  
refactoring opportunities and improve software quality,  
with performance comparable to developers (median F1-  
score 80%) and RefAgent (median F1-score 72%). Moreover,  
RefAgent shows comparable performance in QMOOD im-  
provements compared to RefGen (p-value\>0.05)  
\`\`\`  
\#\# 5.3 RQ3: What is the contribution of each

\#\# component of our framework?

5.3.1 Motivation. While multi-agent architectures offer modular-  
ity and the ability to decompose complex tasks, they also introduce  
design and orchestration overhead. Without a clear understand-  
ing of the role of each component, it becomes difficult to justify  
this complexity or optimize the framework. Prior work in software  
engineering and LLM-based systems highlights the importance  
of component-level analysis and ablation studies to quantify the  
effectiveness of individual elements \[36\].

5.3.2 Comparison of RefAgent with single LLM-based ap-  
proaches. To assess the performance of RefAgent, we compare  
its refactored outputs against single-agent approaches, which are  
based on previous work \[ 15 \], in terms of software quality improve-  
ments. The comparison focuses on key metrics used in RQ1, RQ2 (  
unit test Pass Rate, compilation success rate, Smell Reduction Rate  
(SRR), and QMOOD metrics). For the single-agent baseline, we eval-  
uate the effectiveness of an LLM-based refactoring agent given the  
same context as RefAgent to ensure a fair comparison. Similarly  
to previous work, we use for the unit test pass rate evaluation the  
pass @k metric defined as follows:

\- Pass@1: We generate a single refactored solution for the tar-  
    get class. If it passes the unit test, it is considered a successful  
    refactoring under the Pass@1 criterion.  
\- Pass@3: We generate three refactored solutions for each  
    target class. Each solution is independently evaluated by  
    running the corresponding unit tests. If at least one of these  
    three refactored versions passes all unit tests, the refactoring  
    is considered successful under pass@3.  
This setup ensures that RefAgent is fairly compared fairly to a  
single-agent LLM. Similarly to RQ1 and RQ2, we evaluate this RQ  
on all of the classes of our 8 subject systems presented in Table 1\.

5.3.3 Findings. RefAgent significantly outperforms the sin-  
gle agent approach in terms of unit test pass rate, compilation  
pass rates, and code quality improvement across 8 software  
projects.  
From Table 6, we can identify that incorporating feedback loops  
in a RefAgent and decoupling the planner and execution agents  
enhances the robustness and correctness of code refactoring, lead-  
ing to better overall software quality. In fact, RefAgent shows a  
high improvement rate across all metrics with GPT4o, Deepseek-  
Coder and Starcoder2, when compared to single-agent Pass@1 and  
Pass@3, demonstrating that the approach is not sensitive to the

\`\`\`  
choice of LLM. For instance, in GPT-4o and DeepSeek-Coder, RefA-  
gent achieves a unit test pass rate of 90% compared to 44.5% in  
Pass@1, while in Starcoder2, RefAgent improves the compilation  
pass rate to 84%, significantly outperforming single-LLM agents in  
the Pass@1 scenario. These improvements, backed by statistically  
significant p-values confirm the effectiveness of RefAgent when  
compared to single-agent approaches.  
\`\`\`  
\`\`\`  
Table 6: Comparison of test pass rates and compilation pass  
rates for single agent approach vs RefAgent.  
Unit test  
pass rate  
\`\`\`  
\`\`\`  
Compilation  
pass rate  
\`\`\`  
\`\`\`  
Smell  
Refactoring reduction rate  
Median Avg Median Avg Median Avg  
RefAgent 90 86.8 87 89.6 52.5 53\.  
GPT Pass@1 44.5 44.3 48 48.4 38.1 41\.  
Pass@3 56 60 62 64.6 42.5 43\.  
P-value \- 0.001 0.007 0\.  
RefAgent 85 83.8 84 83.6 50 50\.  
Starcoder Pass@1 33 35.2 45 45.4 37.5 39  
Pass@3 52.5 51 56 59 48.3 50  
P-value \- 0.02 0.007 0\.  
RefAgent 90.5 87.3 88.5 89.2 53.5 54\.  
DeepSeekcoder Pass@1 44.5 45.2 50 49.5 40.5 42\.  
Pass@3 58 61 63 65.2 49.2 51\.  
P-value \- 0.004 0.005 0\.  
\`\`\`  
\`\`\`  
RefAgent consistently and significantly with (p-value\<  
0.05) outperforms the single-agent approaches across all  
QMOOD metrics, demonstrating that the multi-agent ap-  
proach is important to improve software quality. From figure 6,  
we show that RefAgent with subject LLMs shows similar improve-  
ments over the single-agent counterpart. This suggests that the  
effectiveness of RefAgent is not dependent on the specific LLM used  
but rather on the multi-agent collaboration itself. This indicates  
that RefAgent enhances reusability and functionality attributes, and  
overall code quality beyond what a single-agent model can achieve  
alone. The Figure 6 further suggests that multi-agent coordination  
introduces something more to the refactoring process, leading to  
better software design decisions.  
\`\`\`  
\`\`\`  
Figure 6: Improvement rate of QMood Metrics: RefAgent-  
GPT vs single agents and RefAgent-Starcoder vs Single agents.  
The Wilcoxon t-test yields a p-value of 0\.  
5.3.4 Ablation study. We conduct an ablation study by system-  
atically removing key components of RefAgent and analyzing its  
performance. Specifically, we assess the impact of eliminating con-  
text retrieval, dependency analysis, and the code search module  
\`\`\`

\`\`\`  
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY Khouloud Oueslati, Maxime Lamothe, and Foutse Khomh  
\`\`\`  
\`\`\`  
from the framework. We analyze the unit test pass rates and com-  
pilation pass rates across each scenario.  
Furthermore, we analyze the impact of the feedback loop by  
evaluating the unit test pass rate and compilation pass rate over  
20 iterations. This will help determine how the iterative refine-  
ment process influences model performance and stability over 20  
iterations.  
By conducting these experiments, we aim to isolate the contri-  
bution of each component and understand their role in enhancing  
the quality and effectiveness of the generated refactoring.  
\`\`\`  
\`\`\`  
Figure 7: Distribution of test pass rates and compilation pass  
rates for RefAgent with and without context, highlighting  
variations in performance across different configurations.  
\`\`\`  
\`\`\`  
Figure 8: Test and Compilation Pass Rate Across Iterations  
(GPT-4o vs. Starcoder vs. DeepSeek-Coder)  
\`\`\`  
5.3.5 Findings. Context retrieval is essential for maintain-  
ing high test and compilation pass rates in RefAgent, as its  
removal leads to significant performance degradation and  
increased variability. Figure 7 presents results of the ablation  
study on context retrieval components, comparing RefAgent-GPT,  
RefAgent-DeepSeek-Coder, and RefAgent-Starcoder with and with-  
out context. Figure 7 shows that removing context leads to a signif-  
icant drop in both unit test pass rates and compilation pass rates,  
highlighting the critical role of context in ensuring refactoring effec-  
tiveness. RefAgent using subject LLMs exhibits high performance  
when context is included, but without it, performance becomes  
highly unstable, with increased variance and a lower median pass  
rate.  
RefAgent progressively enhances the unit test pass rates  
across 20 iterations with the 3 subject LLMs. From Figure 8, one  
can observe that the median test and compilation pass rate steadily  
increase with each iteration, stabilizing at 90% and 89% after 12  
iterations, demonstrating the compounding benefits of iterative  
refinement. This iterative approach allows RefAgent to identify and

\`\`\`  
correct errors in refactoring recommendations and improve code  
structure. Ultimately, iterating is essential for achieving stable and  
high-quality software outputs for RefAgent.  
\`\`\`  
\`\`\`  
RefAgent significantly outperforms the single-agent ap-  
proach in terms of unit test pass rate, compilation pass  
rates, and QMOOD quality improvements across 8 soft-  
ware projects. This demonstrates the usefulness of a multi-  
agent approach over a single agent approach when im-  
proving software quality. Furthermore, the ablation study  
highlights the importance of context retrieval and iterative  
refinement for maintaining high test and compilation pass  
rates with agentic software refactoring.  
\`\`\`  
\#\# 6 Discussion

\`\`\`  
In this section, we ensure that our evaluation is not adversely af-  
fected by tool-specific limitations. Thus, we perform manual valida-  
tion of a representative sample of the outputs from DesigniteJava,  
EvoSuite, and RefactoringMiner.  
\`\`\`  
\`\`\`  
Figure 9: True Positive and False Positive rates of the tools  
used in our study, based on manual validation of a statisti-  
cally representative sample.  
Manual analysis of the Evosuite’s generated tests. In RefAgent,  
EvoSuite is invoked by the Tester agent to generate tests for the  
refactored classes when developer-written tests are missing or in-  
sufficient.  
To assess the reliability of Evosuite, we randomly select a statis-  
tically significant sample, averaging 374 classes per project from  
each of the eight open-source projects (95% confidence, 5% margin  
of error). For each class, we manually review all generated test cases  
to determine whether they were True Positives (TP), i.e., seman-  
tically correct and passing, or False Positives (FP), i.e., incorrect  
but still passing. As shown in Figure 9, an average of 91% of tests  
were TP, closely aligning with EvoSuite’s reported accuracy and  
prior studies \[ 15 , 39 , 40 \]. The average FP rate was only 1.2%, con-  
firming the low risk of misleading results. These findings support  
the reliability of EvoSuite within RefAgent. While FPs are a known  
limitation in automated test generation, their minimal presence  
suggests a limited impact on decision-making. Future work may  
incorporate mutation testing or enhanced test oracles to better  
validate behavioral correctness. Additionally, leveraging LLM-as-  
a-judge approaches can help assess semantic soundness beyond  
pass/fail outcomes \[21\].  
Impact of False Positives in RefAgent Evaluation. While static  
tools such as DesigniteJavaonly detect code smells based on heuris-  
tic rules or pattern matching, RefAgent orchestrates an end-to-end  
workflow that includes planning, transformation, validation, and  
iterative correction through reasoning and collaboration, which  
traditional static tools are not equipped to perform. We use tools  
\`\`\`

RefAgent: A Multi-agent LLM-based Framework for Automatic Software Refactoring Conference acronym ’XX, June 03–05, 2018, Woodstock, NY

like DesigniteJava and RefactoringMiner for evaluation purposes.  
However, the planner agent does use the tool DesigniteJava only to  
extract low-level code metrics to augment the prompt and enrich  
context, which can be replaced with any available tool that com-  
putes code metrics, yet the core decision-making in the planner  
agent is driven by agent reasoning, enabling adaptability and gener-  
alization across diverse codebases and scenarios. This design choice  
prioritizes autonomy, interpretability, and the ability to evolve in-  
dependently of static tool limitations.  
To ensure the integrity of our evaluation, we manually analyzed a  
randomly-selected, statistically representative sample of 380 refac-  
tored classes across eight projects, applying the same sample to  
both refactoring and code smell detection.  
For refactoring detection, as shown in Figure 9, RefactoringMiner  
yielded a TP rate of 98.24% and a FP rate of just 0.12%, confirming  
its reliability of the tool being aligned with the results reported by  
the authors of RefactoringMiner \[ 46 \] However, a few false positives,  
typically benign cases like formatting changes being misclassified  
as refactorings, may introduce minor noise.  
For code smells, as shown in Figure 9, DesigniteJava reported  
a TP rate of 93.6% (implementation smells) and 92.9% (design  
smells), with corresponding FP rates of 1.64% and 1.73% respec-  
tively. These results align with prior works \[ 41 \]. While generally  
low, these false positives can slightly overestimate the number of  
smells detected or removed, particularly in borderline cases.  
These findings highlight a broader challenge in automated eval-  
uations: the trade-off between scalability and semantic precision.  
Since RefAgent operates as a fully automated framework, develop-  
ers are not required to run static analysis tools before or after refac-  
toring. Instead, we employ these tools solely for empirical evalua-  
tion, to quantitatively assess the improvements in code quality (e.g.,  
reduction of code smells, refactoring types). The developer is not in-  
volved in this validation loop. In practice, RefAgent autonomously  
performs refactoring, testing, and validation using agent reason-  
ing and tool-calling when needed. Therefore, the manual effort  
required from developers is significantly reduced. However, this  
paves the way for future work to introduce a human-in-the-loop  
review mechanism \[ 44 \] that interacts with agents, which can fur-  
ther ensure reliability. An example is an agent-human collaboration  
mechanism in which it can request input at specific conversation  
rounds based on the configuration. The default user proxy agent  
should enable customizable involvement, allowing users to define  
how often and under what conditions human input is requested,  
including the option to skip providing input. These strategies offer a  
promising path toward balancing automation with trustworthiness  
in evaluating intelligent software engineering systems.

\#\# 7 Threats to Validity

In this section, we discuss potential threats to the validity of our  
study and the measures we have taken to mitigate them.  
External Validity. In this study, we focused exclusively on  
datasets from Apache projects, which may limit the generalizability  
of our findings across different software development environments.  
However, this choice ensures consistency with related work \[ 15 \],  
enabling direct comparison and enhancing the validity and compa-  
rability of our results. Future research should explore more diverse

\`\`\`  
datasets to further validate and broaden the applicability of our  
findings.  
Internal Validity. Our study is based on the latest version of  
DeepSeeker-coder-33b, StarCoder2-15B-Instruct-v0.1 and GPT4o,  
as available at the time of analysis. While our results indicate that  
RefAgent performs well agnostically from the used LLM, , our eval-  
uation approach is designed to be adaptable and can be applied to  
future versions of StarCoder2, GPT, and other LLMs from different  
vendors. However, differences in hardware setups can impact model  
performance, potentially leading to different results.  
While LLMs may hallucinate invalid code, RefAgent mitigates  
this through a multi-agent design with reflection loops and tools  
like EvoSuite for validation. Though EvoSuite may introduce false  
positives, we manually validated samples and found minimal impact.  
Also, our study is designed to apply refactored code only if existing  
developer-written tests and auto-generated tests pass.  
Construct Validity. Our assessment of refactoring quality pri-  
marily relies on code smell reduction, improvements in code quality  
metrics, and unit test pass rates. However, these metrics may not  
comprehensively capture all aspects of code quality. This limitation  
could impact the robustness of our conclusions across a broader  
spectrum of quality indicators. We utilized Rminer3.0 and Designite-  
Java in Java code analysis to collect our metrics. However, different  
tools may yield varying results.  
\`\`\`  
\#\# 8 Conclusion

\`\`\`  
This paper introduces RefAgent, a fully automated, multi-agent  
refactoring framework that aims to enhance software quality across  
multiple software quality dimensions. Our approach leverages spe-  
cialized LLM-based agents equipped with tool calling capabilities  
to dynamically retrieve context, interact with the compilation and  
testing environment, and perform more complex context-aware  
refactoring tasks without additional manual oversight. Through our  
extensive evaluation of eight real-world open-source Java projects,  
RefAgent not only achieves significant reductions in code smells  
and improvements in quality attributes but also preserves function-  
ality, as demonstrated by high unit test and compilation pass rates.  
Future work should look into balancing quality improvements with  
potential trade-offs in design flexibility and understandability. To  
the best of our knowledge, this is the first multi-agent approach  
specifically designed for software refactoring.  
\`\`\`  
\#\# 9 Data Availability

\`\`\`  
Our data, and the scripts necessary to replicate our work, is avail-  
able, under an open license, using the following link: https://github.  
com/anonymAgent/RefAgent  
\`\`\`

Conference acronym ’XX, June 03–05, 2018, Woodstock, NY Khouloud Oueslati, Maxime Lamothe, and Foutse Khomh

\#\# References

\[1\]Jehad Al Dallal. 2015\. Identifying refactoring opportunities in object-oriented  
code: A systematic literature review. Information and Software Technology 58  
(2015), 231–249. doi:10.1016/j.infsof.2014.08.  
\[2\]Maha Alharbi and Mohammad Alshayeb. 2024\. A Comparative Study of Au-  
tomated Refactoring Tools. IEEE Access 12 (2024), 18764–18781. doi:10.1109/  
ACCESS.2024.  
\[3\]Vahid Alizadeh, Marouane Kessentini, Mohamed Wiem Mkaouer, Mel Ocinneide,  
Ali Ouni, and Yuanfang Cai. 2020\. An Interactive and Dynamic Search-Based  
Approach to Software Refactoring Recommendations. IEEE Transactions on  
Software Engineering 46 (09 2020), 932–961. doi:10.1109/TSE.2018.  
\[4\]Eman Abdullah AlOmar, Mohamed Wiem Mkaouer, Christian Newman, and Ali  
Ouni. 2021\. On Preserving the Behavior in Software Refactoring: A Systematic  
Mapping Study. arXiv:2106.13900 \[cs.SE\] https://arxiv.org/abs/2106.  
\[5\]Rodrigo Morales Alvarado. 2017\. Automated Improvement of Software Design by  
Search-Based Refactoring. Ph. D. Dissertation. École Polytechnique de Montréal.  
https://publications.polymtl.ca/2878/  
\[6\]Andrea Arcuri and Lionel Briand. 2011\. A practical guide for using statistical  
tests to assess randomized algorithms in software engineering. In Proceedings  
of the 33rd International Conference on Software Engineering (Waikiki, Honolulu,  
HI, USA) (ICSE ’11). Association for Computing Machinery, New York, NY, USA,  
1–10. doi:10.1145/1985793.  
\[7\]Daman Arora, Atharv Sonwane, Nalin Wadhwa, Abhav Mehrotra, Saiteja Utpala,  
Ramakrishna Bairi, Aditya Kanade, and Nagarajan Natarajan. 2024\. MASAI: Mod-  
ular Architecture for Software-engineering AI Agents. arXiv:2406.11638 \[cs.AI\]  
https://arxiv.org/abs/2406.  
\[8\]J. Bansiya and C.G. Davis. 2002\. A hierarchical model for object-oriented design  
quality assessment. IEEE Transactions on Software Engineering 28, 1 (2002), 4–17.  
doi:10.1109/32.  
\[9\]Abdulrahman Ahmed Bobakr Baqais and Mohammad Alshayeb. 2020\. Automatic  
software refactoring: a systematic literature review. Software Quality Journal 28,  
2 (June 2020), 459–502. doi:10.1007/s11219-019-09477-y  
\[10\]L. A. Belady and M. M. Lehman. 1976\. A model of large program development.  
IBM Syst. J. 15, 3 (Sept. 1976), 225–252. doi:10.1147/sj.153.  
\[11\]Sardar Bin Murtaza, Aidan Mccoy, Zhiyuan Ren, Aidan Murphy, and Wolfgang  
Banzhaf. 2024\. LLM Fault Localisation within Evolutionary Computation Based  
Automated Program Repair. In Proceedings of the Genetic and Evolutionary Com-  
putation Conference Companion (Melbourne, VIC, Australia) (GECCO ’24 Com-  
panion). Association for Computing Machinery, New York, NY, USA, 1824–1829.  
doi:10.1145/3638530.  
\[12\]Jie Chen, Junchao Xiao, Qing Wang, Leon J. Osterweil, and Mingshu Li. 2016\.  
Perspectives on refactoring planning and practice: an empirical study. Empirical  
Software Engineering 21, 3 (2016), 1397–1436. doi:10.1007/s10664-015-9390-  
\[13\]Jinsu Choi, Gabin An, and Shin Yoo. 2024\. Iterative Refactoring of Real-World  
Open-Source Programs with Large Language Models. In Search-Based Software En-  
gineering, Gunel Jahangirova and Foutse Khomh (Eds.). Springer Nature Switzer-  
land, Cham, 49–55.  
\[14\]Maëlick Claes and Mika V. Mäntylä. 2020\. 20-MAD: 20 Years of Issues and Com-  
mits of Mozilla and Apache Development (MSR ’20). Association for Computing  
Machinery, New York, NY, USA, 503–507. doi:10.1145/3379597.  
\[15\]Jonathan Cordeiro, Shayan Noei, and Ying Zou. 2024\. An Empirical Study on the  
Code Refactoring Capability of Large Language Models. arXiv:2411.02320 \[cs.SE\]  
https://arxiv.org/abs/2411.  
\[16\]Kyle Daigle and GitHub Staff. 2024\. Survey: The AI wave continues to grow on  
software development teams. GitHub Blog (20 Aug. 2024). https://github.blog/  
news-insights/research/survey-ai-wave-grows/ Updated April 15, 2025\.  
\[17\]DeepSeek. 2024\. DeepSeekCoder: Unlocking the Power of Large Language Models  
for Code Generation. https://github.com/deepseek-ai/DeepSeek-Coder  
\[18\]Eduardo Fernandes, Alexander Chávez, Alessandro Garcia, Isabella Ferreira,  
Diego Cedrim, Leonardo Sousa, and Willian Oizumi. 2020\. Refactoring effect  
on internal quality attributes: What haven’t they told you yet? Information and  
Software Technology 126 (2020), 106347\. doi:10.1016/j.infsof.2020.  
\[19\]Marios Fokaefs, Nikolaos Tsantalis, Eleni Stroulia, and Alexander Chatzigeorgiou.

2011\. JDeodorant: identification and application of extract class refactorings.  
In 2011 33rd International Conference on Software Engineering (ICSE). 1037–1039.  
doi:10.1145/1985793.  
\[20\] Martin Fowler, Kent Beck, John Brant, William Opdyke, and Don Roberts. 1999\.  
Refactoring: Improving the Design of Existing Code. Addison-Wesley Professional,  
Berkeley, CA, USA.  
\[21\]Jiawei Gu, Xuhui Jiang, Zhichao Shi, Hexiang Tan, Xuehao Zhai, Chengjin Xu,  
Wei Li, Yinghan Shen, Shengjie Ma, Honghao Liu, Saizhuo Wang, Kun Zhang,  
Yuanzhuo Wang, Wen Gao, Lionel Ni, and Jian Guo. 2025\. A Survey on LLM-as-  
a-Judge. arXiv:2411.15594 \[cs.CL\] https://arxiv.org/abs/2411.  
\[22\]Junda He, Christoph Treude, and David Lo. 2024\. LLM-Based Multi-Agent Sys-  
tems for Software Engineering: Literature Review, Vision and the Road Ahead.  
arXiv:2404.04834 \[cs.SE\] https://arxiv.org/abs/2404.

\`\`\`  
\[23\]Juyong Jiang, Fan Wang, Jiasi Shen, Sungju Kim, and Sunghun Kim. 2024\. A  
Survey on Large Language Models for Code Generation. arXiv:2406.00515 \[cs.CL\]  
https://arxiv.org/abs/2406.  
\[24\]Miryung Kim, Thomas Zimmermann, and Nachiappan Nagappan. 2014\. An Em-  
pirical Study of RefactoringChallenges and Benefits at Microsoft. IEEE Transac-  
tions on Software Engineering 40, 7 (2014), 633–649. doi:10.1109/TSE.2014.  
\[25\]Guilherme Lacerda, Fabio Petrillo, Marcelo Pimenta, and Yann Gaël Guéhéneuc.  
\`\`\`  
2020\. Code smells and refactoring: A tertiary systematic review of challenges  
and observations. Journal of Systems and Software 167 (2020), 110610\. doi:10.  
1016/j.jss.2020.  
\[26\] M.M. Lehman. 1984\. Program evolution. Information Processing & Management  
20, 1 (1984), 19–36. doi:10.1016/0306-4573(84)90037-2 Special Issue Empirical  
Foundations of Information and Software Science.  
\[27\]Fengjie Li, Jiajun Jiang, Jiajun Sun, and Hongyu Zhang. 2024\. Hybrid Automated  
Program Repair by Combining Large Language Models and Program Analysis.  
arXiv:2406.00992 \[cs.SE\] https://arxiv.org/abs/2406.  
\[28\]Bo Liu, Yanjie Jiang, Yuxia Zhang, Nan Niu, Guangjie Li, and Hui Liu. 2024\. An  
Empirical Study on the Potential of LLMs in Automated Software Refactoring.  
arXiv:2411.04444 \[cs.SE\] https://arxiv.org/abs/2411.  
\[29\]Junwei Liu, Kaixin Wang, Yixuan Chen, Xin Peng, Zhenpeng Chen, Lingming  
Zhang, and Yiling Lou. 2024\. Large Language Model-Based Agents for Software  
Engineering: A Survey. arXiv:2409.02977 \[cs.SE\] https://arxiv.org/abs/2409.  
\[30\]Anton Lozhkov, Raymond Li, Loubna Ben Allal, Federico Cassano, Joel Lamy-  
Poirier, Nouamane Tazi, Ao Tang, Dmytro Pykhtar, Jiawei Liu, Yuxiang Wei,  
Tianyang Liu, Max Tian, Denis Kocetkov, Arthur Zucker, Younes Belkada, Zi-  
jian Wang, Qian Liu, Dmitry Abulkhanov, Indraneil Paul, Zhuang Li, Wen-Ding  
Li, Megan Risdal, Jia Li, Jian Zhu, Terry Yue Zhuo, Evgenii Zheltonozhskii, Nii  
Osae Osae Dade, Wenhao Yu, Lucas Krauß, Naman Jain, Yixuan Su, Xuanli He,  
Manan Dey, Edoardo Abati, Yekun Chai, Niklas Muennighoff, Xiangru Tang, Muh-  
tasham Oblokulov, Christopher Akiki, Marc Marone, Chenghao Mou, Mayank  
Mishra, Alex Gu, Binyuan Hui, Tri Dao, Armel Zebaze, Olivier Dehaene, Nicolas  
Patry, Canwen Xu, Julian McAuley, Han Hu, Torsten Scholak, Sebastien Paquet,  
Jennifer Robinson, Carolyn Jane Anderson, Nicolas Chapados, Mostofa Patwary,  
Nima Tajbakhsh, Yacine Jernite, Carlos Muñoz Ferrandis, Lingming Zhang, Sean  
Hughes, Thomas Wolf, Arjun Guha, Leandro von Werra, and Harm de Vries. 2024\.  
StarCoder 2 and The Stack v2: The Next Generation. arXiv:2402.19173 \[cs.SE\]  
https://arxiv.org/abs/2402.  
\[31\]Yingwei Ma, Qingping Yang, Rongyu Cao, Binhua Li, Fei Huang, and Yongbin  
Li. 2025\. Alibaba LingmaAgent: Improving Automated Issue Resolution via  
Comprehensive Repository Exploration. arXiv:2406.01422 \[cs.SE\] https://arxiv.  
org/abs/2406.  
\[32\]Rodrigo Morales, Francisco Chicano, Foutse Khomh, and Giuliano Antoniol. 2018\.  
Efficient refactoring scheduling based on partial order reduction. Journal of  
Systems and Software 145 (2018), 25–51. doi:10.1016/j.jss.2018.07.  
\[33\]Rodrigo Morales, Zéphyrin Soh, Foutse Khomh, Giuliano Antoniol, and Francisco  
Chicano. 2017\. On the use of developers’ context for automatic refactoring of  
software anti-patterns. Journal of Systems and Software 128 (2017), 236–251.  
doi:10.1016/j.jss.2016.05.  
\[34\]Shayan Noei, Heng Li, Stefanos Georgiou, and Ying Zou. 2023\. An Empirical Study  
of Refactoring Rhythms and Tactics in the Software Development Process. IEEE  
Trans. Softw. Eng. 49, 12 (Dec. 2023), 5103–5119. doi:10.1109/TSE.2023.  
\[35\]Ana Nunez, Nafis Tanveer Islam, Sumit Jha, and Peyman Najafirad. 2024\. Au-  
toSafeCoder: A Multi-Agent Framework for Securing LLM Code Generation  
through Static Analysis and Fuzz Testing. doi:10.48550/arXiv.2409.  
\[36\]Ana Nunez, Nafis Tanveer Islam, Sumit Kumar Jha, and Peyman Najafirad. 2024\.  
AutoSafeCoder: A Multi-Agent Framework for Securing LLM Code Generation  
through Static Analysis and Fuzz Testing. arXiv:2409.10737 \[cs.SE\] https://arxiv.  
org/abs/2409.  
\[37\]Ali Ouni, Marouane Kessentini, Houari Sahraoui, Katsuro Inoue, and Mo-  
hamed Salah Hamdi. 2015\. Improving multi-objective code-smells correc-  
tion using development history. J. Syst. Softw. 105, C (July 2015), 18–39.  
doi:10.1016/j.jss.2015.03.  
\[38\]Gustavo H. Pinto and Fernando Kamei. 2013\. What programmers say about  
refactoring tools? an empirical investigation of stack overflow. In Proceedings of  
the 2013 ACM Workshop on Workshop on Refactoring Tools (Indianapolis, Indiana,  
USA) (WRT ’13). Association for Computing Machinery, New York, NY, USA,  
33–36. doi:10.1145/2541348.  
\[39\]Sebastian Schweikl, Gordon Fraser, and Andrea Arcuri. 2023\. EvoSuite at the  
SBST 2022 tool competition. In Proceedings of the 15th Workshop on Search-Based  
Software Testing (Pittsburgh, Pennsylvania) (SBST ’22). Association for Computing  
Machinery, New York, NY, USA, 33–34. doi:10.1145/3526072.  
\[40\]Sara Shamshiri, Gordon Fraser, Andreas Zeller, and et al. 2015\. Do automatically  
generated unit tests find real faults? An empirical study of effectiveness and  
challenges. In Proceedings of the 30th IEEE/ACM International Conference on  
Automated Software Engineering (ASE). IEEE, 201–211.  
\[41\]Tushar Sharma. 2024\. Multi-faceted Code Smell Detection at Scale using  
DesigniteJava 2.0. In 21st IEEE/ACM International Conference on Mining Soft-  
ware Repositories, MSR 2024, Lisbon, Portugal, April 15-16, 2024\. ACM, 284–288.

RefAgent: A Multi-agent LLM-based Framework for Automatic Software Refactoring Conference acronym ’XX, June 03–05, 2018, Woodstock, NY

doi:10.1145/3643991.  
\[42\]Noah Shinn, Federico Cassano, Edward Berman, Ashwin Gopinath, Karthik  
Narasimhan, and Shunyu Yao. 2023\. Reflexion: Language Agents with Verbal  
Reinforcement Learning. arXiv:2303.11366 \[cs.AI\] https://arxiv.org/abs/2303.  
11366  
\[43\]Girish Suryanarayana, Ganesh Samarthyam, and Tushar Sharma. 2014\. Refac-  
toring for Software Design Smells: Managing Technical Debt (1st ed.). Morgan  
Kaufmann Publishers Inc., San Francisco, CA, USA.  
\[44\]Wannita Takerngsaksiri, Jirat Pasuksmit, Patanamon Thongtanunam, Chakkrit  
Tantithamthavorn, Ruixiong Zhang, Fan Jiang, Jing Li, Evan Cook, Kun Chen,  
and Ming Wu. 2025\. Human-In-the-Loop Software Development Agents.  
arXiv:2411.12924 \[cs.SE\] https://arxiv.org/abs/2411.  
\[45\]Zhao Tian, Junjie Chen, and Xiangyu Zhang. 2024\. Fixing Large Lan-  
guage Models’ Specification Misunderstanding for Better Code Generation.  
arXiv:2309.16120 \[cs.SE\] https://arxiv.org/abs/2309.  
\[46\]Nikolaos Tsantalis, Ameya Ketkar, and Danny Dig. 2022\. RefactoringMiner 2.0.  
IEEE Transactions on Software Engineering 48, 3 (2022), 930–950. doi:10.1109/TSE.  
2020\.  
\[47\]Nikolaos Tsantalis, Matin Mansouri, Laleh Eshkevari, Davood Mazinanian, and  
Danny Dig. 2018\. Accurate and Efficient Refactoring Detection in Commit History.  
In 2018 IEEE/ACM 40th International Conference on Software Engineering (ICSE).  
483–494. doi:10.1145/3180155.  
\[48\]Nikolaos Tsantalis, Matin Mansouri, Laleh M. Eshkevari, Davood Mazinanian,  
and Danny Dig. 2018\. Accurate and efficient refactoring detection in commit  
history. In Proceedings of the 40th International Conference on Software Engineering  
(Gothenburg, Sweden) (ICSE ’18). Association for Computing Machinery, New  
York, NY, USA, 483–494. doi:10.1145/3180155.

\`\`\`  
\[49\]E. van Emden and L. Moonen. 2002\. Java quality assurance by detecting code  
smells. In Ninth Working Conference on Reverse Engineering, 2002\. Proceedings.  
97–106. doi:10.1109/WCRE.2002.  
\[50\]Yanlin Wang, Wanjun Zhong, Yanxian Huang, Ensheng Shi, Min Yang, Jiachi  
Chen, Hui Li, Yuchi Ma, Qianxiang Wang, and Zibin Zheng. 2024\. Agents in  
Software Engineering: Survey, Landscape, and Vision. arXiv:2409.09030 \[cs.SE\]  
https://arxiv.org/abs/2409.  
\[51\]Chunqiu Steven Xia, Yinlin Deng, Soren Dunn, and Lingming Zhang.  
\`\`\`  
2024\. Agentless: Demystifying LLM-based Software Engineering Agents.  
arXiv:2407.01489 \[cs.SE\] https://arxiv.org/abs/2407.  
\[52\]Aiko Yamashita and Steve Counsell. 2013\. Code smells as system-level indicators  
of maintainability: An empirical study. Journal of Systems and Software 86, 10  
(2013), 2639–2653. doi:10.1016/j.jss.2013.05.  
\[53\]Guang Yang, Yu Zhou, Xiang Chen, Xiangyu Zhang, Terry Yue Zhuo, and Taolue  
Chen. 2024\. Chain-of-Thought in Neural Code Generation: From and For Light-  
weight Language Models. arXiv:2312.05562 \[cs.SE\] https://arxiv.org/abs/2312.  
05562  
\[54\]Linchao Yang, Tomoyuki Kamiya, Kazunori Sakamoto, Hironori Washizaki, and  
Yoshiaki Fukazawa. 2014\. RefactoringScript: A Script and Its Processor for Com-  
posite Refactoring. Proceedings of the International Conference on Software Engi-  
neering and Knowledge Engineering, SEKE 2014\.  
\[55\]Norihiro Yoshida, Tsubasa Saika, Eunjong Choi, Ali Ouni, and Katsuro Inoue.  
2016\. Revisiting the relationship between code smells and refactoring. In 2016  
IEEE 24th International Conference on Program Comprehension (ICPC). 1–4. doi:10.  
1109/ICPC.2016.  
\[56\]Yuntong Zhang, Haifeng Ruan, Zhiyu Fan, and Abhik Roychoudhury. 2024\. Au-  
toCodeRover: Autonomous Program Improvement. arXiv:2404.05427 \[cs.SE\]  
https://arxiv.org/abs/2404.


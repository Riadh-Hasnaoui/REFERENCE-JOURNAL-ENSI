\`\`\`  
Findings of the Association for Computational Linguistics:  
NAACL 2025, pages 1496–  
April 29 \- May 4, 2025 ©2025 Association for Computational Linguistics  
\`\`\`  
\#\# On the Impacts of Contexts on Repository-Level Code Generation

\#\#\# Nam Le Hai^1 ,^2 ,†, Dung Manh Nguyen^1 , Nghi D. Q. Bui^1

(^1) FPT Software AI Center, Vietnam  
(^2) Hanoi University of Science and Technology, Viet Nam

\#\#\# namlh@soict.hust.edu.com, dungnm31@fpt.com, bdqnghi@gmail.com

\#\#\# Abstract

\`\`\`  
CodeLLMs are widely used for code genera-  
tion, yet their ability to handle repository-level  
dependencies remains underexplored. We in-  
troduceREPOEXEC, a benchmark for evalu-  
ating repository-level code generation, focus-  
ing on executability, functional correctness,  
and dependency utilization. Our study evalu-  
ates 18 models, revealing that retaining full de-  
pendency context yields the best performance,  
while smaller context sizes can be mislead-  
ing. Pretrained LLMs excel in correctness  
but often reimplement dependencies, while  
instruction-tuned models better utilize depen-  
dencies but sometimes introduce unnecessary  
complexity. We propose an instruction-tuning  
dataset that improves dependency handling and  
introduce a new metric,Dependency Invoca-  
tion Rate (DIR), to measure context utiliza-  
tion. Experiments show that instruction-tuned  
models improve DIR by over 10%, and multi-  
round debugging further enhances both correct-  
ness and dependency use. REPOEXECpro-  
vides a comprehensive framework to advance  
CodeLLMs for real-world applications. The  
dataset and source code are available athttps:  
//github.com/FSoft-AI4Code/RepoExec.  
\`\`\`  
\#\#\# 1 Introduction

Code Large Language Models (CodeLLMs) have  
emerged as powerful tools for assisting with cod-  
ing tasks (Wang et al., 2021, 2023; Feng et al.,  
2020; Allal et al., 2023; Li et al., 2023; Lozhkov  
et al., 2024; Guo et al., 2024; Pinnaparaju et al.,  
2024; Zheng et al., 2024; Roziere et al., 2023; Ni-  
jkamp et al., 2022; Luo et al., 2023; Xu et al.,  
2022; Bui et al., 2023; Manh et al., 2024; Liu et al.,  
2024a). While these models excel at generating  
code from natural language requirements or com-  
pleting individual lines of code, their application

\*A majority of this work was done while the first author  
was an AI resident at FPT Software AI Center.  
†Corresponding author: namlh@soict.hust.edu.vn

\`\`\`  
in real-world, professional software development  
scenarios presents more complex challenges. A  
critical aspect of this complexity lies in leverag-  
ing relevantcontexts/dependencies(e.g., function  
calls, imports, class hierarchy) across an entire soft-  
ware repository, which raises two pivotal questions.  
First, to what extent are the retrieved contexts accu-  
rate and relevant, rather than potential noise in the  
input? Second, how effectively do LLMs process  
and incorporate the provided dependencies into  
their generated code? These inquiries are central  
to understanding the capabilities and limitations  
of CodeLLMs in repository-level code generation,  
where completing a single line of code might re-  
quire making API calls to functions within the same  
file (in-file context) or across different files (cross-  
file context).  
Existing repository-level code generation bench-  
marks, such as RepoBench (Liu et al., 2023b),  
RepoCoder (Zhang et al., 2023a), CrossCodeE-  
val (Ding et al., 2023), CoCoMIC (Ding et al.,  
2024), and DevEval (Li et al., 2024), have advanced  
the evaluation of code generation at a repository  
level. However, they exhibit key limitations: (1)  
Lack of an executable environment, leading to de-  
pendence on match-based metrics that fail to as-  
sess functional correctness adequately; (2)Insuf-  
ficient control over unit test quality, reducing the  
data pipeline scalability and robustness of the eval-  
uation; and (3)Overemphasis on functional cor-  
rectness metrics like pass@k, which is inadequate  
for comprehensive repository-level code genera-  
tion evaluation. In real-world development, code  
often needs to call predefined modules (functions,  
classes, or variables) in the repository to align with  
developer intent. While LLMs may generate code  
that passes tests, it can result in inefficient imple-  
mentations or unnecessary duplication of prede-  
fined functions, leading to issues like technical debt  
and code smells (Maldonado and Shihab, 2015;  
Sierra et al., 2019; Santos et al., 2018).  
1496  
\`\`\`

\`\`\`  
Syntax-based filter Execution-based filter  
Function extraction  
\`\`\`  
\`\`\`  
Multiple timeexecution  
\`\`\`  
\`\`\`  
Syntax ErrorFunction invocation  
extracting  
Repository  
\`\`\`  
\`\`\`  
Assertion fixer  
\`\`\`  
\`\`\`  
Dependencies extraction RepoExec  
\`\`\`  
\`\`\`  
Functions  
\`\`\`  
\`\`\`  
Dependencies  
\`\`\`  
\`\`\`  
Testcases  
\`\`\`  
\`\`\`  
generationUnit-test EnhancementCoverage  
\`\`\`  
\`\`\`  
Figure 1: Data Processing Pipeline of REPOEXEC  
\`\`\`  
To address these gaps, we proposeREPOEXEC,  
a novel benchmark designed to ensure both func-  
tional correctness and effective dependency uti-  
lization. It offers an executable environment for  
reliable functional evaluation and incorporates a  
mechanism to generate high-coverage test cases,  
enhancing the robustness of functional correctness  
assessment. Additionally, we also proposeDepen-  
dency Invocation Rate (DIR), a metric that evalu-  
ates the extent to which generated code leverages  
predefined dependencies, offering a more compre-  
hensive measure of model performance beyond  
merely passing test cases.  
Our experiments withREPOEXECoffer several  
key insights into repository-level code generation.  
Firstly, given varying context levels (full, medium,  
small), which correspond to the information pro-  
vided for dependencies—such as full implementa-  
tion, docstrings, and function signatures—we ob-  
serve that models achieve the best performance  
when given full context dependencies while also  
showing potential with smaller contexts. Secondly,  
pretrained LLMs and instruction-tuned LLMs ex-  
hibit different strengths: pretrained LLMs gener-  
ally excel in pass@k metrics, while instruction-  
tuned LLMs perform better on the Dependency  
Invocation Rate (DIR). This suggests that while  
pretrained LLMs can generate runnable code, they  
often struggle with properly utilizing dependencies,  
which means the code may pass tests but might not  
be correctly implemented in a repository-level con-  
text. On the other hand, instruction-tuned LLMs  
make better use of contextual information. These  
findings highlight the importance of using both  
pass@1 and DIR for a more holistic evaluation,  
emphasizing the need to improve both functional  
correctness and context utilization in CodeLLMs.  
Furthermore, we investigate two methods to  
enhance repository-level code generation: multi-  
round debugging and instruction tuning with de-  
pendency contexts. Multi-round debugging with

\`\`\`  
test execution, particularly with models like GPT-  
3.5 and WizardCoder, significantly boosts both  
pass@1 and DIR after three rounds. Additionally,  
fine-tuning on our dependency-enhanced dataset  
improves these metrics while reducing computa-  
tional costs. These findings highlight the benefits  
of executable code testing, instruction tuning, and  
iterative debugging for improving CodeLLM per-  
formance and managing code dependencies more  
effectively. Besides, it also demonstrates that better  
context utilization leads to higher pass@k scores  
(detailed analysis provided in Sections 6.2, 6.3 and  
Appendix G). In summary, our contributions are as  
follows:  
\`\`\`  
\`\`\`  
1.We introduce a novelevaluation paradigmfor  
repository-level code generation, assessing both  
functional correctness and quality factors such  
as maintainability and adherence to clean code  
principles through efficient dependency use.  
\`\`\`  
\`\`\`  
2.We present the Dependency Invocation Rate  
(DIR), a novel metric that measures the pro-  
portion of provided dependencies successfully  
incorporated into the generated code. This met-  
ric helps gauge the models’ understanding and  
utilization of dependencies and shows a strong  
correlation with functional correctness.  
\`\`\`  
\`\`\`  
3.We introduceREPOEXEC, a novel benchmark  
that aligns with our evaluation paradigm, ad-  
dressing the gaps in existing benchmarks and  
offering a comprehensive assessment of code  
generation quality. Additionally, an effective  
pipeline is introduced withinREPOEXECfrom  
dependency extraction, dynamically generate  
high-coverage test cases and automatic evalua-  
tion with execution and code dependencies. Our  
pipeline offers practical usage and scalability  
for the community.  
\`\`\`  
\`\`\`  
4.We release a tool namedpydepcallto extract  
dependencies for all functions within any repos-  
\`\`\`

\`\`\`  
itory, providing a practical use for advancing  
research in this domain.  
\`\`\`  
\`\`\`  
5.Our experiments reveal key insights into  
CodeLLMs’ performance in repository-level  
code generation. While foundation models show  
high initial accuracy, instruction-tuned models  
excel in dependency management. Additionally,  
multi-round debugging tests further improve per-  
formance, enhancing dependency management.  
Notably, a strong correlation between pass@  
and DIR underscores that better context utiliza-  
tion leads to more functionally correct code.  
\`\`\`  
\#\#\# 2 Related works

Coding-related tasks have been crucial for assess-  
ing the performance of Large Language Models  
(LLMs), with code generation emerging as a pri-  
mary focus (Chen et al., 2021; Li et al., 2023;  
Jiang et al., 2024; Touvron et al., 2023; Roziere  
et al., 2023; Xu et al., 2022; Allal et al., 2023; Ni-  
jkamp et al., 2022; Phan et al., 2024a; To et al.,  
2023). Early benchmarks have been introduced to  
address this issue (Yin et al., 2018; Iyer et al., 2018;  
Nguyen et al., 2023; Chen et al., 2021; Austin et al.,  
2021; Hendrycks et al., 2021); however, they often  
had limited scope or employed weak evaluation ap-  
proaches. Some benchmarks (Yin et al., 2018; Iyer  
et al., 2018; Nguyen et al., 2023\) exhibit domain  
diversity akin to real-world applications; however,  
their evaluation methodologies are constrained to  
match-based metrics, thereby decreasing the reli-  
ability of these benchmarks (Chen et al., 2021).  
Meanwhile, benchmarks with reliable evaluation  
approaches such as HumanEval (Chen et al., 2021),  
MBPP (Austin et al., 2021\) and APPS (Hendrycks  
et al., 2021\) often entail limitations to specific do-  
mains like competitive programming. Recently,  
there have been efforts to extend the domains of  
generation tasks in various benchmarks. For in-  
stance, ExeDS (Huang et al., 2022\) focuses on data  
science code generation, while ODEX (Wang et al.,  
2022\) serves as an open-domain benchmark for  
code generation. Besides, all the benchmarks men-  
tioned primarily focus on standalone function gen-  
eration, lacking consideration for cross-contextual  
and dependency invocation scenarios.  
Several recent studies have introduced frame-  
works and benchmarks for repository-level code  
generation (Ding et al., 2024; Shrivastava et al.,  
2023; Ding et al., 2023; Liao et al., 2023; Liu et al.,  
2023b). These studies closely align with real-world

\`\`\`  
scenarios, underscoring the importance of cross-  
contextual considerations. However, these works  
are still limited to match-based evaluation meth-  
ods. A recent study (Li et al., 2024\) introduced  
the DevEval benchmark for code generation within  
repository contexts, evaluating performance based  
on extracted tests available in the repository. These  
benchmarks primarily focus on assessing the func-  
tional correctness of generated outputs but have not  
extensively investigated the correctness in conjunc-  
tion with the ability to utilize dependency contexts.  
\`\`\`  
\#\#\# 3 Evaluation Paradigm

\`\`\`  
In this section, we outline our paradigm to achieve  
a more robust and comprehensive evaluation of  
repository-level code generation. Our paradigm  
encompasses two key attributes: Functional cor-  
rectness and Dependency utilization.  
\`\`\`  
\`\`\`  
Functional correctness: This evaluation crite-  
rion ensures that the code accurately performs its  
intended tasks and requirements. Specifically, it  
typically involves using test cases to compare the  
execution output of the generated code against the  
expected output for a given input. This criterion has  
been widely employed for evaluating code genera-  
tion in numerous studies (Chen et al., 2021; Austin  
et al., 2021; Zhuo et al., 2024; Li et al., 2024). We  
follow the well-known automatic metricPass@k  
(Chen et al., 2021\) to measure the functional cor-  
rectness of generation outputs.  
\`\`\`  
\`\`\`  
Dependency utilization: Functional correctness  
alone cannot fully capture code quality, as it  
may overlook poor implementations or redundancy.  
Match-based metrics like BLEU and edit similarity  
evaluate alignment between generated and refer-  
ence code at the token level. However, not all  
tokens impact code quality equally, and alterna-  
tive implementations can maintain quality despite  
low similarity scores. Tokens representing called  
dependencies—such as packages, functions, vari-  
ables, and classes within the repository—imply  
effective use of human intent for efficient imple-  
mentation. Ignoring these dependencies may sug-  
gest workaround implementations misaligned with  
human intent, leading to increased verification and  
maintenance costs. To assess the models’ ability to  
utilize provided dependencies in accordance with  
human intent, we introduce theDependency In-  
vocation Rate (DIR). This metric represents the  
percentage of invoked dependencies out of the total  
\`\`\`

\`\`\`  
number of dependencies provided. LetDgdenote  
the set of identifiers in the generated output, andDs  
denote the set of provided dependencies extracted  
from the solution. The Dependency Invocation  
Rate (DIR) is calculated as follows:  
\`\`\`  
\`\`\`  
DIR=  
\`\`\`  
\`\`\`  
|Dg∩Ds|  
|Ds|  
\`\`\`  
A higher DIR indicates that the model successfully  
incorporates a larger proportion of the provided  
dependencies into the generated code, demonstrat-  
ing a better understanding of the dependencies’  
relevance and their intended usage. Conversely, a  
lower DIR suggests that the model may struggle to  
identify and utilize the appropriate dependencies,  
potentially generating code that is less aligned with  
the human-intent solution.In summary, achieving  
a high-quality solution requires the generated code  
to excel in both functional correctness and depen-  
dency utilization. Otherwise, it indicates a lack  
of ability to generate correct solutions or suggests  
poor implementation practices, including technical  
debt or code smell issues.

\#\#\# 4 Data Collection Pipeline

\`\`\`  
Developing an executable benchmark within repos-  
itory contexts is challenging due to complex setup  
requirements and frequent lack of clear installation  
guidelines in repositories. Previous studies (Ding  
et al., 2024; Shrivastava et al., 2023; Ding et al.,  
2023; Liao et al., 2023\) have often relied on match-  
based metrics for evaluation, which may not fully  
capture code functionality. In addition, test cases  
are essential for assessing code functionality. How-  
ever, extracting test cases from repositories (Zhang  
et al., 2023b; Li et al., 2024; Zhang et al., 2024\) of-  
ten relies on available functions and heuristic rules,  
limiting adaptability and excluding data without  
existing tests. For instance, Li et al. 2024 found  
that over 99% of functions were discarded due to  
the absence of suitable tests. We propose a dataset  
collection pipeline to ensure that repositories can  
build executable environments and that test cases  
are automatically generated. The complete data  
pipeline is illustrated in Figure 1, with details of  
the data sources provided in Appendix A.  
\`\`\`  
\`\`\`  
4.1 Functions and Dependencies Extraction  
Function extraction: We extract functions and  
their dependencies from repositories, considering  
only those suitable for function-level code gener-  
ation, akin to benchmarks like HumanEval (Chen  
\`\`\`  
\`\`\`  
\#No problem \#No testcase Avg tokens  
Cross-file Total Avg LC (%) Avg Prompt Solution  
Full 22.8% 355 96.25 99.45 362.92 78\.  
Medium \- \- \- \- 253.05 \-  
Small \- \- \- \- 179.66 \-  
Table 1: Dataset attributes with different levels of con-  
texts.Cross-filerefers to the percentage of problems  
that involve cross-file dependencies. Tree-sitter is used  
for tokenization.AVG LC: Average Line Coverage.  
\`\`\`  
\`\`\`  
et al., 2021\) and MBPP (Austin et al., 2021). Us-  
ing tree-sitter, we parse files into Abstract Syntax  
Trees (AST) to extract functions, focusing on those  
with comprehensive docstrings and excluding func-  
tions used as entry points or that do not produce  
verifiable outputs.  
\`\`\`  
\`\`\`  
Dependencies extraction: We employ static  
analysis on call graph to identify dependencies,  
excluding identifiers that are function parameters  
or typing objects. Each dependency name is then  
mapped to its definition within the repository using  
a repository graph and static analysis tools. We  
release our toolpydepcallfor community usage  
and provide a brief description in Appendix I.  
For example in Figure 2, for the function  
camel\_case\_to\_snakeinmanipulation.py, our  
process identifiesCAMEL\_CASE\_REPLACE\_REas an  
in-file dependency and analyzes import statements  
to track cross-file dependencies fromerrors.py  
and validation.py. Dependencies are then  
parsed and incorporated into the input prompt to  
ensure comprehensive context for code generation.  
\`\`\`  
\`\`\`  
4.2 Test case generation  
To overcome the limitation of requiring available  
tests in the repository for evaluation as in previous  
works, we leverage large language models (LLMs)  
to generate test cases automatically. Our proposed  
approach ensures the correctness of created test  
cases while also controlling and enhancing test  
coverage. To execute and validate the generated  
test cases, it is necessary to configure each reposi-  
tory to create an executable environment. Follow  
Lemieux et al. 2023, we usepipreqs^1 to identify  
each project’s dependency packages.  
In our test generation process, we conduct two  
phases corresponding toCorrectness Controland  
Coverage Enhancement. After the test generation  
process, we exclude samples with a line coverage  
lower than 40%, as they are insufficient to accu-  
rately assess the correctness of the generated code.  
\`\`\`  
(^1) https://github.com/bndr/pipreqs

\`\`\`  
errors.py  
\`\`\`  
\`\`\`  
""" Custom error raised when received object is not  
a string as expected. """  
\`\`\`  
\`\`\`  
"""  
:param input\_data: Any received object """  
\`\`\`  
\`\`\`  
...  
\`\`\`  
\`\`\`  
...  
\`\`\`  
\`\`\`  
type\_name \= type(input\_data).\_\_name\_\_  
msg \= 'Expected "str", received "{}"'.format(type\_name)  
super().\_\_init\_\_(msg)  
\`\`\`  
\`\`\`  
class InvalidInputError(TypeError):  
\`\`\`  
\`\`\`  
def \_\_init\_\_(self, input\_data: Any):  
\`\`\`  
\`\`\`  
validation.py  
...  
\`\`\`  
\`\`\`  
...  
\`\`\`  
\`\`\`  
def is\_string(obj: Any) \-\> bool:  
\`\`\`  
\`\`\`  
return isinstance(obj, str)  
\`\`\`  
\`\`\`  
def is\_camel\_case(input\_string: Any) \-\> bool:  
\`\`\`  
\`\`\`  
return is\_full\_string(input\_string) and  
CAMEL\_CASE\_TEST\_RE.match(input\_string) is  
not None  
\`\`\`  
\`\`\`  
 Prompt  
\`\`\`  
\`\`\`  
manipulation.py  
\`\`\`  
\`\`\`  
...  
\`\`\`  
\`\`\`  
CAMEL\_CASE\_REPLACE\_RE \= re.compile(r'(\[a-z\]|\[A-Z\]+)(?=\[A-Z\])')  
\`\`\`  
\`\`\`  
def camel\_case\_to\_snake(input\_string,  
separator=DEFAULT\_SEPERTATOR): """  
Convert a camel case string into a snake case one.  
(The original string is returned if is not a valid  
camel case string)  
\*Example:\*  
\>\>\> camel\_case\_to\_snake('ThisIsACamelStringTest') \# returns 'this\_is\_a\_camel\_case\_string\_test'  
:param input\_string: String to convert.  
:type input\_string: str :param separator: Sign to use as separator.  
:type separator: str  
:return: Converted string. """  
if not is\_string(input\_string):  
raise InvalidInputError(input\_string)  
if not is\_camel\_case(input\_string):  
return input\_string  
return CAMEL\_CASE\_REPLACE\_RE.sub(lambda m:  
m.group(1) \+ separator,  
input\_string).lower()  
\`\`\`  
\`\`\`  
import base  
import random  
import unicodedata  
import zlibfrom typing import Union  
from uuid import uuid  
from .\_regex import \*  
from .errors import InvalidInputError  
from .validation import is\_snake\_case,  
is\_full\_string, is\_camel\_case, is\_integer, is\_string,  
DEFAULT\_SEPERATOR  
\`\`\`  
\`\`\`  
"""  
Checks if an object is a string.  
\*Example:\*  
\>\>\> is\_string('foo') \# returns true \>\>\> is\_string(b'foo') \# returns false  
:param obj: Object to test.  
:return: True if string, false otherwise. """  
\`\`\`  
\`\`\`  
"""  
Checks if a string is formatted as camel case.  
A string is considered camel case when:  
\`\`\`  
\- it's composed only by letters (\[a-zA-Z\]) and optionally numbers (\[0-9\])  
\- it contains both lowercase and uppercase letters \- it does not start with a number  
\*Examples:\*  
\>\>\> is\_camel\_case('MyString') \# returns true \>\>\> is\_camel\_case('mystring') \# returns false  
:param input\_string: String to test.  
:type input\_string: str :return: True for a camel case string, false otherwise.  
"""

\`\`\`  
Cross-file context  
\`\`\`  
\`\`\`  
(1)  
\`\`\`  
\`\`\`  
(1)  
\`\`\`  
\`\`\`  
(1)  
\`\`\`  
\`\`\`  
(1)  
\`\`\`  
\`\`\`  
(2)  
\`\`\`  
\`\`\`  
(2)  
\`\`\`  
\`\`\`  
(2)  
\`\`\`  
\`\`\`  
(3)  
\`\`\`  
\`\`\`  
(2)  
\`\`\`  
\`\`\`  
(3)  
\`\`\`  
\`\`\`  
(3)  
\`\`\`  
\`\`\`  
(1)  
dependency  
signature  
\`\`\`  
\`\`\`  
(2)  
dependency  
docstring  
\`\`\`  
\`\`\`  
(3)  
dependency  
content  
dependency(4) in-file import(5)  
variable  
\`\`\`  
\`\`\`  
(4)  
\`\`\`  
\`\`\`  
(5)  
\`\`\`  
\`\`\`  
(4)DEFAULT\_SEPERATOR \= '\_'  
\`\`\`  
\`\`\`  
Target function Solution  
\`\`\`  
\`\`\`  
Full context  
(5) \+ (4) \+ (1) \+ (2) \+ (3) \+ (6)  
\`\`\`  
\`\`\`  
Medium context  
(5) \+ (4) \+ (1) \+ (2) \+ (6)  
\`\`\`  
\`\`\`  
Small context  
(5) \+ (4) \+ (1) \+ (6)  
\`\`\`  
\`\`\`  
In-file context  
\`\`\`  
\`\`\`  
(6)  
Target function  
prompt  
\`\`\`  
\`\`\`  
(6)  
\`\`\`  
Figure 2: Illustration of a data instance in RepoExec. The target function signatures and their associated docstrings,  
which describe the functionality of the functions, are shown in (6). The infile-imports and variable declarations are  
represented by (5) and (4), respectively. The remaining components, (1), (2), and (3), represent the function and  
class contexts. Specifically, (1) denotes the class or function signature, (2) may contain the description of the class,  
and (3) represents the function body of the cross-file function.

\`\`\`  
4.2.1 Correctness Control  
\`\`\`  
\`\`\`  
In this stage, we present the procedure for generat-  
ing initial test cases and ensure the tests’ correct-  
\`\`\`  
\`\`\`  
ness. Specifically, we use CodeLlama-13b (Roziere  
et al., 2023\) and provide the model with the prompt  
detailed in Appendix D. The first 20 assertions form  
\`\`\`

\`\`\`  
Pipeline RepoContextMining GenerationTest EnhancementTest  
\`\`\`  
\`\`\`  
RepoCoder ✓ ✗ ✗  
R2E ✓ ✓ ✗  
CodeBenchGen ✗ ✓ ✓  
REPOEXEC ✓ ✓ ✓  
\`\`\`  
\`\`\`  
Table 2: Comparison of data construction pipelines  
across different repo-level code generation benchmarks.  
\`\`\`  
\`\`\`  
the test cases, which are then filtered via syntax and  
execution checks to ensure correctness.  
\`\`\`  
\`\`\`  
Syntax-based filter: We filter out tests that  
present syntax errors during parsing into AST. Ad-  
ditionally, tests that do not invoke the function un-  
der test are excluded. For instance, while the state-  
ment“assert 1”may pass during execution, it is  
meaningless and negatively impacts the evaluation.  
\`\`\`  
\`\`\`  
Execution-based filter: We usepytest^2 to run  
the generated tests, discarding those with errors  
except forAssertionError. If an assertion error  
occurs, the Assertion Fixer resolves it by execut-  
ing the test with the target function, extracting the  
output, and updating the assertion. To handle com-  
plex return types (e.g., custom objects), we employ  
pickle^3 to store results. Additionally, to address  
flaky tests that are inconsistent due to randomness,  
each test is executed 10 times for comparison.  
\`\`\`  
\`\`\`  
4.2.2 Coverage Enhancement  
\`\`\`  
Weak unit tests may allow incorrect implementa-  
tions to pass (Liu et al., 2023a). To address this,  
we propose a strategy for enhancing test coverage  
using LLMs. Given the complexity of this task,  
requiring a strong understanding of code, we uti-  
lize GPT-3.5 to improve the quality of test cases.  
We provide GPT-3.5 with three prompts (see Ap-  
pendix D) to handle challenging scenarios, includ-  
ing edge and corner cases. The initial generated  
tests serve as few-shot examples. We then extract  
the newly generated tests and ensure their correct-  
ness using our methodology from Section 4.2.1. Ta-  
ble 3 shows a line coverage improvement of about  
4% after enhancement, reaching 96.25%. The per-  
formance gap has also increased to over 5% (Ap-  
pendix C), indicating greater robustness.

\#\#\# 5 Data Characteristics

\`\`\`  
5.1 Data Formatting  
Figure 2 illustrates the input data format used in  
REPOEXEC. We retain import information and ap-  
pend dependencies in the order presented in the  
import statements, placing the target function sig-  
nature and description at the end of the prompt.  
To evaluate the reasoning capability of CodeLLMs  
in repo-level code generation, we propose three  
prompt types with varying context lengths:  
\`\`\`  
\- Full-size context: All contexts, including cross-  
    file and in-file contexts, are preserved to assess  
    the model’s ability to navigate and utilize the  
    complete information available in the repository.  
\- Medium-size context: Class and function bod-  
    ies are removed, while their signatures and doc-  
    strings are retained. This tests the model’s ability  
    to infer the functionality and usage of dependen-  
    cies based on their interfaces and documentation,  
    reducing the input context length.  
\- Small-size context: Only the signatures of  
    the dependencies are retained. This tests if  
    CodeLLMs can infer the usage of dependencies  
    in the target function given only the function sig-  
    natures without docstrings, representing the most  
    challenging case with minimal information.

\`\`\`  
Evaluating the model’s performance across these  
context sizes provides insights into the trade-offs  
between input context length and the model’s rea-  
soning capabilities, helping to understand the opti-  
mal balance between providing sufficient informa-  
tion and minimizing input size for effective code  
generation at the repository level.  
We follow Muennighoff et al. 2023 to define 2  
types of prompt formats in our evaluation ofRE-  
POEXECacross LLMs: (1) BasePrompt, which  
concatenates all contexts with the target functions  
(Figure 2), and (2) InstructPrompt, which includes  
specific instructions for the LLMs to follow, utiliz-  
ing two variations as input formats (further details  
and examples in Appendix E).  
\`\`\`  
\`\`\`  
5.2 Dataset Stastistic  
Comparison to Existing Benchmarks: Table  
3 compares the details ofREPOEXECwith ex-  
isting code generation benchmarks. Benchmarks  
\`\`\`  
(^2) https://github.com/pytest-dev/pytest  
(^3) https://docs.python.org/3/library/pickle.html

\`\`\`  
Dataset \#Samples RC TC LC (%)  
CoNaLA (Yin et al., 2018\) 500 ✗ ✗ \-  
CONCODE (Iyer et al., 2018\) 2,000 ✗ ✗ \-  
HumanEval (Chen et al., 2021\) 164 ✗ ✓,H 99\.  
MBPP (Austin et al., 2021\) 974 ✗ ✓,H 98\.  
RepoCoder (Zhang et al., 2023b) 373 ✓ ✓,P \-  
CrossCodeEval (Ding et al., 2023\) 2,665 ✓ ✗ \-  
CoCoMIC (Ding et al., 2024\) 6,888 ✓ ✗ \-  
DevEval (Li et al., 2024\) 1,874 ✓ ✓,P \-  
REPOEXEC 355 ✓ ✓,A 92\.  
\+ coverage-enhancement 96\.  
Table 3: The comparison between popular code gener-  
ation benchmarks andREPOEXEC. For test case, we  
denoteH: Human annotated,P: Pre-existing,A: Auto-  
mated.RC: Repo-context utilization.TC: Test Cases.  
LC: Line Coverage  
\`\`\`  
that exclude execution-based evaluation (Yin et al.,  
2018; Iyer et al., 2018; Ding et al., 2023, 2024\)  
may gather substantial amounts of data; however,  
they are inadequate for assessing the quality of the  
generated code. For HumanEval and MBPP, the  
majority of problems involve standalone functions,  
which do not reflect real-world scenarios. Besides,  
benchmarks that rely on human-annotated and pre-  
existing test cases (Chen et al., 2021; Austin et al.,  
2021; Zhang et al., 2023a; Li et al., 2024\) are chal-  
lenging to scale and control the test coverage. Fi-  
nally, repository-context benchmarks (Zhang et al.,  
2023a; Ding et al., 2023, 2024; Li et al., 2024\)  
primarily focus on investigating retrieval modules.  
For example, RepoCoder analyzes a retriever using  
a sparse bag-of-words model. Similarly, Cross-  
CodeEval experiments and reports performance  
using various retrievers such as BM25, UniXCoder,  
and OpenAI ada. CoCoMic proposed CCFINDER  
to retrieve cross-file context. DevEval is the closest  
to our work; however, they compare the perfor-  
mance of the generation model based on different  
given types of file-level context, which can also  
align with the different contexts provided by differ-  
ent retrievers. In contrast, our approach emphasizes  
the generation module’s ability to understand and  
utilize human-provided dependency contexts.

\`\`\`  
Comparison to Existing Data Pipeline: Several  
studies, including RepoCoder (Zhang et al., 2023a),  
R2E (Jain et al., 2024), and CodeBenchGen (Xie  
et al., 2024), have introduced data pipelines for  
repository-level code generation. Table 2 compares  
our pipeline with these approaches across three  
key aspects: RepoContext mining, Test Genera-  
tion, and Test Enhancement. These components  
are crucial for robust evaluation, as missing any can  
compromise quality. RepoCoder extracts existing  
\`\`\`  
\`\`\`  
test cases but lacks enhancement, limiting scalabil-  
ity. CodeBenchGen uses LLMs to synthesize func-  
tion contexts, reducing practicality. Lastly, R2E  
is the most closely related to our approach, how-  
ever, it similarly neglects test case enhancement  
like RepoCoder, which can undermine evaluation  
robustness (as detailed in Appendix C).  
Dataset attributes: Table 1 outlines the charac-  
teristics ofREPOEXEC, including the total number  
of examples, the average number of test cases, and  
the number of tokens in prompts and solutions.  
\`\`\`  
\#\#\# 6 Experiment

\`\`\`  
6.1 Evaluation Results  
We evaluated 18 CodeLLMs onREPOEXECand  
presented the results (pass@1, pass@5, and DIR)  
in Table 4\. We use nucleus sampling with tem-  
perature set to 0.2, top-p to 0.95, and 10 outputs  
generated for all models. For evaluating super-large  
models requiring paid API access, we utilize greedy  
decoding and report pass@1 and DIR metrics un-  
der the Full Context setting. The results show that  
retaining the full context of dependencies yields the  
best performance across all models. Surprisingly,  
Small-size context proves to be more effective than  
Medium-size context, which we attribute to the  
context’s input format using BasePrompt, poten-  
tially misleading the model into interpreting the  
dependency functions as few-shot examples. Using  
the Small-size context results in a fair decrease in  
performance compared to the Full context while  
effectively reducing the input length.  
DeepSeek-R3 achieves the highest pass@1 rate  
among the evaluated models. Additionally, Base-  
Prompt and pretrained models exhibit superior ef-  
fectiveness over instruction-tuned models in terms  
of functional correctness (pass@k) when compar-  
ing models of similar size onREPOEXEC. How-  
ever, our analysis reveals limitations in both types  
of models. Additional discussions and examples  
are provided in Appendix F.  
1.Instruction-tuned LLMs demonstrate a higher  
capacity for utilizing given dependencies than  
foundation LMs, sometimes enabling them to  
address edge or corner cases that foundation  
models have overlooked.  
2.Despite the high DIR, instruction-tuning LMs  
may not utilize dependencies correctly and fre-  
quently produce overly complex code, leading  
to incorrect solutions.  
\`\`\`

\`\`\`  
Model pass@1Full contextpass@5 DIR pass@1Medium contextpass@5 DIR pass@1Small contextpass@5 DIR  
BasePrompt  
\`\`\`  
\`\`\`  
Pre-models  
\`\`\`  
\`\`\`  
CodeLlama-13b-Python (Roziere et al., 2023\) 38.65 43.24 62.26 32.96 38.33 56.38 35.66 42.41 62\.  
StarCoder (Li et al., 2023\) 28.08 33.95 58.75 22.54 31.83 50.74 25.54 31.45 56\.  
StarCoder2-15b (Lozhkov et al., 2024\) 27.77 32.60 60.57 18.70 23.28 39.28 23.27 29.78 53\.  
Mixtral-8x7B-v0.1 (Jiang et al., 2024\) 22.82 29.14 55.90 19.38 25.25 47.22 20.54 26.30 53\.  
Phi-2 (Javaheripi et al., 2023\) 19.04 24.56 48.22 14.54 20.34 40.85 14.82 20.69 44\.  
Phi-1 (Gunasekar et al., 2023\) 14.99 18.38 43.17 12.48 15.42 37.45 12.54 15.96 38\.  
\`\`\`  
\`\`\`  
Inst-models  
\`\`\`  
\`\`\`  
DeepSeek-R1 (Guo et al., 2025\) 42.57 \- 70.86 \- \- \- \- \- \-  
DeepSeek-V3 (Liu et al., 2024a) 42.00 \- 80.35 \- \- \- \- \- \-  
Llama 3.1-405B-Instruct (Dubey et al., 2024\) 34.86 \- 78.81 \- \- \- \- \- \-  
GPT-4o 37.14 \- 81.43 \- \- \- \- \- \-  
GPT-4o-mini 30.29 \- 74.75 \- \- \- \- \- \-  
CodeLlama-34b-Python (Roziere et al., 2023\) 40.93 49.54 68.85 35.92 42.95 58.15 39.80 45.79 64\.  
WizardCoder-Python-13B-V1.0 (Luo et al., 2023\) 34.31 40.06 62.90 30.99 36.75 59.50 32.54 38.34 64\.  
Phind-CodeLlama-34B-v2 30.08 33.49 59.47 25.25 29.40 50.73 27.55 31.85 58\.  
CodeLlama-13b-Instruct (Roziere et al., 2023\) 28.56 32.67 57.09 26.25 30.72 49.48 26.73 33.50 54\.  
GPT-3.5 27.27 37.69 63.59 23.15 33.94 52.79 22.59 33.63 55\.  
DeepSeek-Coder-7b-Instruct (Guo et al., 2024\) 25.18 29.91 58.50 20.23 26.02 45.76 22.20 27.74 56\.  
Mixtral-8x7B-Instruct-v0.1 (Jiang et al., 2024\) 23.41 28.71 59.83 19.04 24.83 52.75 20.45 25.84 58\.  
InstructPrompt  
\`\`\`  
\`\`\`  
Inst-models  
\`\`\`  
\`\`\`  
DeepSeek-R1 (Guo et al., 2025\) 39.71 \- 53.78 \- \- \- \- \- \-  
DeepSeek-V3 (Liu et al., 2024a) 41.71 \- 62.58 \- \- \- \- \- \-  
Llama 3.1-405B-Instruct (Dubey et al., 2024\) 39.43 \- 73.26 \- \- \- \- \- \-  
GPT-4o 38.00 \- 68.15 \- \- \- \- \- \-  
GPT-4o-mini 32.29 \- 53.34 \- \- \- \- \- \-  
WizardCoder-Python-13B-V1.0 26.20 30.68 67.32 24.56 30.25 67.54 24.70 29.56 68\.  
CodeLlama-13b-Instruct 25.66 30.82 62.04 27.44 34.11 63.33 26.73 32.43 64\.  
GPT-3.5 23.82 39.10 40.55 19.62 36.03 37.48 19.00 34.00 35\.  
Mixtral-8x7B-Instruct-v0.1 18.11 23.04 67.73 18.54 23.12 69.66 15.38 20.61 68\.  
\`\`\`  
Table 4: Pass@k and DIR results of various LLMs onREPOEXEC. Bold scoresindicate the highest, while  
Underlined scoresdenote the second highest. Pre- and Inst- denote Pretrained and Instruction-tuned, respectively.  
More results are presented in Table 8\.

3.Pretrained LLMs generate functionally correct  
code but often fail to effectively utilize the pro-  
vided dependencies, occasionally reimplement-  
ing dependencies already present in the given  
context. This leads to redundancy and poten-  
tially creates technical debt or code smell is-  
sues (Maldonado and Shihab, 2015; Sierra et al.,  
2019; Santos et al., 2018; Hai et al., 2024a).

These issues can lead to a low-quality code-  
base, requiring substantial human effort for re-  
viewing and fixing, which may even exceed the  
effort needed to write the code from scratch.  
Moreover, the performance of current advanced  
LLMs highlights that DeepSeek models, particu-  
larly DeepSeek-R1 and DeepSeek-V3, demonstrate  
strong overall capabilities, effectively balancing  
accuracy and dependency management. Among  
smaller models, GPT-4o-mini achieves the highest  
DIR (74.75) but underperforms in pass@1 (30.29),  
emphasizing it often invokes dependencies incor-

\`\`\`  
rectly despite its emphasis on handling them. Mod-  
els with high pass@k and DIR scores, such as  
DeepSeek-V3 (80.35) and Llama 3.1 (73.26), excel  
in accurately invoking dependencies, which is cru-  
cial for real-world code generation tasks. Finally,  
REPOEXECremains challenging to existing mod-  
els, as evidenced by consistently low performance,  
underscoring the need for more advanced systems.  
\`\`\`  
\`\`\`  
6.2 Generation with Multi-round Debugging  
In this section, we examine the models’ self-  
refinement capabilities in enhancing generation per-  
formance. We provide the models with error output  
logs and ask them to fix the errors. We experiment  
with WizardCoder, GPT3.5, and CodeLlama-13b-  
Python. The number of rounds to debug is set to  
3 and the input template is presented in Appendix  
G. In this experiment, we employ a greedy search  
algorithm to generate only a single output.  
Table 5 shows the improvement across three  
rounds of debugging in various models. We ob-  
\`\`\`

\`\`\`  
Round GPT-3.5 WizardCoder CodeLlama-13b-Python  
0 27.04 34.37 39\.  
1 36.34 40.85 39\.  
2 40.00 41.69 39\.  
3 41.97 42.54 39\.  
\`\`\`  
\`\`\`  
Table 5: Pass@1 scores of various models across three  
rounds of debugging. Round 0 represents the initial  
generation stage.  
\`\`\`  
serve that GPT-3.5 and WizardCoder demonstrate  
a high capacity for debugging with improvement  
of over 10% and 7% in pass@1, respectively, while  
CodeLlama fails to take advantage of this process.  
Additionally, the DIR has also shown a significant  
improvement (over 7%) after three rounds of de-  
bugging in these two instruction models (Figure  
7). These findings indicate a promising approach  
using self-refinement with debugging for code gen-  
eration, which can enhance both the correctness  
and the utilization of given dependencies.

\`\`\`  
6.3 Instruction-tuning with Code  
Dependencies  
\`\`\`  
While the multi-round debugging experiment has  
demonstrated effectiveness in leveraging given de-  
pendencies to provide correct solutions (Section  
6.2), it requires a strong model to generate good  
test cases and can be time-consuming due to the  
repeated generation and execution of code and test  
cases. To address these challenges, we propose  
an instruction-tuning dataset for fine-tuning base  
LLMs. We collected the 1,555 most-starred repos-  
itories from 2018 onward and extracted functions  
with their corresponding dependencies, following  
the procedure outlined in Section 4.1. We ob-  
tained 154,818 functions, of which 57,746 sam-  
ples include docstrings. We use 50K samples with  
docstrings and applied instruction prompts, while  
80K samples adhered to the raw code format (Full  
context). Recognizing the potential of the Small  
context format, we allocated the remaining 20K  
samples to follow this structure. We fine-tuned  
Phi-2, StarCoder, StarCoder2, and CodeLlama-13b-  
Python models for 5 epochs with LoRa (Hu et al.,  
2021\) and used 10% of the training data as the  
validation set to select the best checkpoint.  
Table 6 illustrates the efficacy of our training  
data. All 4 models demonstrate improvements  
in both Pass@1 and DIR after instruction tuning.  
Specifically, there is a slight increase of around  
1% in Pass@k for all models, while DIR shows  
a significant improvement, reaching the highest

\`\`\`  
Model Pass@1Full contextDIR Pass@1Small contextDIR  
phi-2 19.04 48.22 14.82 44\.  
phi-2DepIT 20.20 61.66 20.31 70\.  
StarCoder 28.08 58.67 25.49 56\.  
StarCoderDepIT 29.43 69.80 28.73 71\.  
StarCoder2 27.77 60.57 23.27 53\.  
StarCoder2DepIT 28.45 69.76 27.27 73\.  
CodeLlama 38.65 62.26 35.66 62\.  
CodeLlamaDepIT 38.85 68.89 36.93 73\.  
\`\`\`  
\`\`\`  
Table 6: Comparison of the performance of several  
models onREPOEXECafter instruction tuning for de-  
pendency calls (DepIT) with their pre-trained versions.  
\`\`\`  
\`\`\`  
scores (over 70%) compared to other models after  
tuning with our dataset. Notably, performance im-  
proves significantly with small context, matching  
results from full context, enabling more efficient  
processing and reducing computational costs. In  
summary, our instruction-tuning method enhances  
the model’s ability to utilize dependencies and en-  
sure functional correctness. While multi-round de-  
bugging (Section 6.2) is more effective, instruction-  
tuned models rely on single-turn generation, mak-  
ing them more practical and efficient.To facilitate  
open research in this domain, we will publicly re-  
lease this dataset.  
\`\`\`  
\#\#\# 7 Conclusion

\`\`\`  
We propose an evaluation approach for repository-  
level code generation that rethinks the limitations  
of prior methods by assessing not only the func-  
tional correctness aspect but also dependency uti-  
lization to ensure code quality. We introduceRE-  
POEXEC, a novel Python code generation bench-  
mark with executable capabilities, designed to eval-  
uate the alignment of generated code with devel-  
oper intent and correctness. Our experiments show  
that while pretrained LLMs excel in functional cor-  
rectness, instruction-tuned models perform better  
in utilizing dependencies and debugging. However,  
existing models struggle to reuse provided depen-  
dencies, risking technical debt and code smells. We  
provide a comprehensive analysis of how LLMs  
leverage dependencies, revealing that context infor-  
mation significantly influences the results. Besides,  
we also introduce an instruction-tuning dataset that  
enhances dependency invocation accuracy and out-  
put correctness, even with limited context. Our  
contributions establish a foundation for future re-  
search in code generation, providing valuable eval-  
uation techniques to drive the development of more  
capable and reliable models.  
\`\`\`

\#\#\# 8 Limitations

In this work, we currently consider one level of  
dependency context, specifically the dependencies  
directly called from the target function. While this  
simplification facilitates manageable analysis and  
model development, it may not fully capture the  
valuable context necessary for leveraging models  
effectively. However, incorporating deep depen-  
dencies could significantly extend the input length,  
posing challenges in managing long context in-  
puts and potentially exceeding the maximum input  
length. Our approach has demonstrated promising  
outcomes with the small-size context version, cre-  
ating opportunities for integrating additional input  
context. Future research could explore incorpo-  
rating multiple levels of dependencies, creating a  
more comprehensive graph that includes transitive  
dependencies, indirect calls, and broader contex-  
tual information. By doing so, we could enhance  
the model’s understanding of code interactions and  
improve its ability to handle intricate software exe-  
cution scenarios.

\#\#\# References

Marah Abdin, Jyoti Aneja, Harkirat Behl, Sébastien  
Bubeck, Ronen Eldan, Suriya Gunasekar, Michael  
Harrison, Russell J Hewett, Mojan Javaheripi, Piero  
Kauffmann, et al. 2024\. Phi-4 technical report.arXiv  
preprint arXiv:2412.08905.

Loubna Ben Allal, Raymond Li, Denis Kocetkov,  
Chenghao Mou, Christopher Akiki, Carlos Munoz  
Ferrandis, Niklas Muennighoff, Mayank Mishra,  
Alex Gu, Manan Dey, et al. 2023\. Santacoder: don’t  
reach for the stars\!arXiv preprint arXiv:2301.03988.

Jacob Austin, Augustus Odena, Maxwell Nye, Maarten  
Bosma, Henryk Michalewski, David Dohan, Ellen  
Jiang, Carrie Cai, Michael Terry, Quoc Le, et al. 2021\.  
Program synthesis with large language models.arXiv  
preprint arXiv:2108.07732.

Jinze Bai, Shuai Bai, Yunfei Chu, Zeyu Cui, Kai Dang,  
Xiaodong Deng, Yang Fan, Wenbin Ge, Yu Han, Fei  
Huang, Binyuan Hui, Luo Ji, Mei Li, Junyang Lin,  
Runji Lin, Dayiheng Liu, Gao Liu, Chengqiang Lu,  
Keming Lu, Jianxin Ma, Rui Men, Xingzhang Ren,  
Xuancheng Ren, Chuanqi Tan, Sinan Tan, Jianhong  
Tu, Peng Wang, Shijie Wang, Wei Wang, Sheng-  
guang Wu, Benfeng Xu, Jin Xu, An Yang, Hao Yang,  
Jian Yang, Shusheng Yang, Yang Yao, Bowen Yu,  
Hongyi Yuan, Zheng Yuan, Jianwei Zhang, Xingx-  
uan Zhang, Yichang Zhang, Zhenru Zhang, Chang  
Zhou, Jingren Zhou, Xiaohuan Zhou, and Tianhang  
Zhu. 2023\. Qwen technical report.arXiv preprint  
arXiv:2309.16609.

\`\`\`  
Nghi DQ Bui, Hung Le, Yue Wang, Junnan Li,  
Akhilesh Deepak Gotmare, and Steven CH Hoi. 2023\.  
Codetf: One-stop transformer library for state-of-the-  
art code llm.arXiv preprint arXiv:2306.00029.  
Mark Chen, Jerry Tworek, Heewoo Jun, Qiming  
Yuan, Henrique Ponde de Oliveira Pinto, Jared Ka-  
plan, Harri Edwards, Yuri Burda, Nicholas Joseph,  
Greg Brockman, et al. 2021\. Evaluating large  
language models trained on code. arXiv preprint  
arXiv:2107.03374.  
Yangruibo Ding, Zijian Wang, Wasi U. Ahmad, Mu-  
rali Krishna Ramanathan, Ramesh Nallapati, Par-  
minder Bhatia, Dan Roth, and Bing Xiang. 2024\.  
CoCoMIC: Code completion by jointly modeling  
in-file and cross-file context. InProceedings of the  
2024 Joint International Conference on Computa-  
tional Linguistics, Language Resources and Evalua-  
tion (LREC-COLING 2024).  
Yangruibo Ding, Zijian Wang, Wasi Uddin Ahmad, Han-  
tian Ding, Ming Tan, Nihal Jain, Murali Krishna Ra-  
manathan, Ramesh Nallapati, Parminder Bhatia, Dan  
Roth, and Bing Xiang. 2023\. Crosscodeeval: A di-  
verse and multilingual benchmark for cross-file code  
completion. InAdvances in Neural Information Pro-  
cessing Systems 36: Annual Conference on Neural  
Information Processing Systems 2023, NeurIPS 2023,  
New Orleans, LA, USA, December 10 \- 16, 2023\.  
Abhimanyu Dubey, Abhinav Jauhri, Abhinav Pandey,  
Abhishek Kadian, Ahmad Al-Dahle, Aiesha Letman,  
Akhil Mathur, Alan Schelten, Amy Yang, Angela  
Fan, et al. 2024\. The llama 3 herd of models.arXiv  
preprint arXiv:2407.21783.  
Zhangyin Feng, Daya Guo, Duyu Tang, Nan Duan, Xi-  
aocheng Feng, Ming Gong, Linjun Shou, Bing Qin,  
Ting Liu, Daxin Jiang, et al. 2020\. Codebert: A  
pre-trained model for programming and natural lan-  
guages.arXiv preprint arXiv:2002.08155.  
Suriya Gunasekar, Yi Zhang, Jyoti Aneja, Caio  
César Teodoro Mendes, Allie Del Giorno, Sivakanth  
Gopi, Mojan Javaheripi, Piero Kauffmann, Gustavo  
de Rosa, Olli Saarikivi, et al. 2023\. Textbooks are all  
you need.arXiv preprint arXiv:2306.11644.  
Daya Guo, Dejian Yang, Haowei Zhang, Junxiao Song,  
Ruoyu Zhang, Runxin Xu, Qihao Zhu, Shirong Ma,  
Peiyi Wang, Xiao Bi, et al. 2025\. Deepseek-r1: In-  
centivizing reasoning capability in llms via reinforce-  
ment learning.arXiv preprint arXiv:2501.12948.  
Daya Guo, Qihao Zhu, Dejian Yang, Zhenda Xie, Kai  
Dong, Wentao Zhang, Guanting Chen, Xiao Bi,  
Y Wu, YK Li, et al. 2024\. Deepseek-coder: When the  
large language model meets programming–the rise of  
code intelligence.arXiv preprint arXiv:2401.14196.  
Nam Le Hai, Anh MT Bui, Phuong T Nguyen, Davide  
Di Ruscio, and Rick Kazman. 2024a. Improving the  
detection of technical debt in java source code with an  
enriched dataset.arXiv preprint arXiv:2411.05457.  
\`\`\`

Nam Le Hai, Trang Nguyen, Linh Ngo Van, Thien Huu  
Nguyen, and Khoat Than. 2024b. Continual varia-  
tional dropout: a view of auxiliary local variables in  
continual learning.Machine Learning, 113(1):281–  
323\.

Rajarshi Haldar and Julia Hockenmaier. 2024\. An-  
alyzing the performance of large language mod-  
els on code summarization. arXiv preprint  
arXiv:2404.08018.

Dan Hendrycks, Steven Basart, Saurav Kadavath, Man-  
tas Mazeika, Akul Arora, Ethan Guo, Collin Burns,  
Samir Puranik, Horace He, Dawn Song, and Jacob  
Steinhardt. 2021\. Measuring coding challenge com-  
petence with apps.NeurIPS.

Edward J Hu, Yelong Shen, Phillip Wallis, Zeyuan  
Allen-Zhu, Yuanzhi Li, Shean Wang, Lu Wang,  
and Weizhu Chen. 2021\. Lora: Low-rank adap-  
tation of large language models. arXiv preprint  
arXiv:2106.09685.

Dong Huang, Qingwen Bu, Jie M Zhang, Michael Luck,  
and Heming Cui. 2023\. Agentcoder: Multi-agent-  
based code generation with iterative testing and opti-  
misation.arXiv preprint arXiv:2312.13010.

Junjie Huang, Chenglong Wang, Jipeng Zhang, Cong  
Yan, Haotian Cui, Jeevana Priya Inala, Colin Clement,  
Nan Duan, and Jianfeng Gao. 2022\. Execution-based  
evaluation for data science code generation models.  
arXiv preprint arXiv:2211.09374.

Binyuan Hui, Jian Yang, Zeyu Cui, Jiaxi Yang, Day-  
iheng Liu, Lei Zhang, Tianyu Liu, Jiajun Zhang,  
Bowen Yu, Kai Dang, et al. 2024\. Qwen2. 5-coder  
technical report.arXiv preprint arXiv:2409.12186.

Maor Ivgi, Uri Shaham, and Jonathan Berant. 2023\. Ef-  
ficient long-text understanding with short-text mod-  
els. Transactions of the Association for Computa-  
tional Linguistics, 11:284–299.

Srinivasan Iyer, Ioannis Konstas, Alvin Cheung, and  
Luke Zettlemoyer. 2018\. Mapping language to code  
in programmatic context. InProceedings of the 2018  
Conference on Empirical Methods in Natural Lan-  
guage Processing, pages 1643–1652.

Naman Jain, Manish Shetty, Tianjun Zhang, King Han,  
Koushik Sen, and Ion Stoica. 2024\. R2e: Turning  
any github repository into a programming agent envi-  
ronment. InForty-first International Conference on  
Machine Learning.

Mojan Javaheripi, Sébastien Bubeck, Marah Abdin, Jy-  
oti Aneja, Sebastien Bubeck, Caio César Teodoro  
Mendes, Weizhu Chen, Allie Del Giorno, Ronen  
Eldan, Sivakanth Gopi, et al. 2023\. Phi-2: The sur-  
prising power of small language models.Microsoft  
Research Blog.

Albert Q Jiang, Alexandre Sablayrolles, Antoine  
Roux, Arthur Mensch, Blanche Savary, Chris Bam-  
ford, Devendra Singh Chaplot, Diego de las Casas,

\`\`\`  
Emma Bou Hanna, Florian Bressand, et al. 2024\.  
Mixtral of experts.arXiv preprint arXiv:2401.04088.  
\`\`\`  
\`\`\`  
Caroline Lemieux, Jeevana Priya Inala, Shuvendu K  
Lahiri, and Siddhartha Sen. 2023\. Codamosa: Es-  
caping coverage plateaus in test generation with pre-  
trained large language models. In2023 IEEE/ACM  
45th International Conference on Software Engineer-  
ing (ICSE), pages 919–931. IEEE.  
\`\`\`  
\`\`\`  
Jia Li, Ge Li, Yunfei Zhao, Yongmin Li, Huanyu  
Liu, Hao Zhu, Lecheng Wang, Kaibo Liu, Zheng  
Fang, Lanshen Wang, et al. 2024\. Deveval:  
A manually-annotated code generation benchmark  
aligned with real-world code repositories. arXiv  
preprint arXiv:2405.19856.  
\`\`\`  
\`\`\`  
Raymond Li, Loubna Ben Allal, Yangtian Zi, Niklas  
Muennighoff, Denis Kocetkov, Chenghao Mou, Marc  
Marone, Christopher Akiki, Jia Li, Jenny Chim, et al.  
\`\`\`  
2023\. Starcoder: may the source be with you\!arXiv  
preprint arXiv:2305.06161.  
Dianshu Liao, Shidong Pan, Qing Huang, Xiaoxue Ren,  
Zhenchang Xing, Huan Jin, and Qinying Li. 2023\.  
Context-aware code generation framework for code  
repositories: Local, global, and third-party library  
awareness.arXiv preprint arXiv:2312.05772.

\`\`\`  
Aixin Liu, Bei Feng, Bing Xue, Bingxuan Wang,  
Bochao Wu, Chengda Lu, Chenggang Zhao, Chengqi  
Deng, Chenyu Zhang, Chong Ruan, et al. 2024a.  
Deepseek-v3 technical report. arXiv preprint  
arXiv:2412.19437.  
\`\`\`  
\`\`\`  
Jiawei Liu, Chunqiu Steven Xia, Yuyao Wang, and  
LINGMING ZHANG. 2023a. Is your code gen-  
erated by chatGPT really correct? rigorous evalu-  
ation of large language models for code generation.  
InThirty-seventh Conference on Neural Information  
Processing Systems.  
Nelson F Liu, Kevin Lin, John Hewitt, Ashwin Paran-  
jape, Michele Bevilacqua, Fabio Petroni, and Percy  
Liang. 2024b. Lost in the middle: How language  
models use long contexts.Transactions of the Asso-  
ciation for Computational Linguistics, 12:157–173.  
\`\`\`  
\`\`\`  
Tianyang Liu, Canwen Xu, and Julian McAuley.  
2023b. Repobench: Benchmarking repository-  
level code auto-completion systems.arXiv preprint  
arXiv:2306.03091.  
\`\`\`  
\`\`\`  
Zhijie Liu, Yutian Tang, Xiapu Luo, Yuming Zhou, and  
Liang Feng Zhang. 2024c. No need to lift a finger  
anymore? assessing the quality of code generation by  
chatgpt.IEEE Transactions on Software Engineer-  
ing.  
Anton Lozhkov, Raymond Li, Loubna Ben Allal, Fed-  
erico Cassano, Joel Lamy-Poirier, Nouamane Tazi,  
Ao Tang, Dmytro Pykhtar, Jiawei Liu, Yuxiang Wei,  
et al. 2024\. Starcoder 2 and the stack v2: The next  
generation.arXiv preprint arXiv:2402.19173.  
\`\`\`

Stephan Lukasczyk, Florian Kroiß, and Gordon Fraser.

2023\. An empirical study of automated unit test gen-  
eration for python.Empirical Software Engineering,  
28(2):36.

Ziyang Luo, Can Xu, Pu Zhao, Qingfeng Sun, Xi-  
ubo Geng, Wenxiang Hu, Chongyang Tao, Jing Ma,  
Qingwei Lin, and Daxin Jiang. 2023\. Wizardcoder:  
Empowering code large language models with evol-  
instruct.arXiv preprint arXiv:2306.08568.

Everton da S Maldonado and Emad Shihab. 2015\.  
Detecting and quantifying different types of self-  
admitted technical debt. In2015 IEEE 7Th interna-  
tional workshop on managing technical debt (MTD),  
pages 9–15. IEEE.

Dung Nguyen Manh, Thang Phan Chau, Nam Le Hai,  
Thong T Doan, Nam V Nguyen, Quang Pham, and  
Nghi DQ Bui. 2024\. Codemmlu: A multi-task bench-  
mark for assessing code understanding capabilities  
of codellms.arXiv preprint arXiv:2410.01999.

Debanjan Mondal, Abhilasha Lodha, Ankita Sahoo, and  
Beena Kumari. 2023\. Robust code summarization.  
InProceedings of the 1st GenBench Workshop on  
(Benchmarking) Generalisation in NLP, pages 65–75,  
Singapore. Association for Computational Linguis-  
tics.

Niklas Muennighoff, Qian Liu, Armel Zebaze, Qinkai  
Zheng, Binyuan Hui, Terry Yue Zhuo, Swayam  
Singh, Xiangru Tang, Leandro Von Werra, and  
Shayne Longpre. 2023\. Octopack: Instruction tun-  
ing code large language models. arXiv preprint  
arXiv:2308.07124.

Dung Nguyen, Le Nam, Anh Dau, Anh Nguyen, Khanh  
Nghiem, Jin Guo, and Nghi Bui. 2023\. The vault:  
A comprehensive multilingual dataset for advanc-  
ing code understanding and generation. InFindings  
of the Association for Computational Linguistics:  
EMNLP 2023, pages 4763–4788, Singapore. Associ-  
ation for Computational Linguistics.

Erik Nijkamp, Bo Pang, Hiroaki Hayashi, Lifu Tu, Huan  
Wang, Yingbo Zhou, Silvio Savarese, and Caiming  
Xiong. 2022\. Codegen: An open large language  
model for code with multi-turn program synthesis.  
arXiv preprint arXiv:2203.13474.

Huy N Phan, Hoang N Phan, Tien N Nguyen, and  
Nghi DQ Bui. 2024a. Repohyper: Better context  
retrieval is all you need for repository-level code  
completion.arXiv preprint arXiv:2403.06095.

Huy Nhat Phan, Tien N Nguyen, Phong X Nguyen,  
and Nghi DQ Bui. 2024b. Hyperagent: Generalist  
software engineering agents to solve coding tasks at  
scale.arXiv preprint arXiv:2409.16299.

Nikhil Pinnaparaju, Reshinth Adithyan, Duy Phung,  
Jonathan Tow, James Baicoianu, Ashish Datta,  
Maksym Zhuravinskyi, Dakota Mahan, Marco Bel-  
lagente, Carlos Riquelme, et al. 2024\. Stable code  
technical report.arXiv preprint arXiv:2404.01226.

\`\`\`  
Baptiste Roziere, Jonas Gehring, Fabian Gloeckle, Sten  
Sootla, Itai Gat, Xiaoqing Ellen Tan, Yossi Adi,  
Jingyu Liu, Tal Remez, Jérémy Rapin, et al. 2023\.  
Code llama: Open foundation models for code.arXiv  
preprint arXiv:2308.12950.  
\`\`\`  
\`\`\`  
José Amancio M Santos, João B Rocha-Junior, Luciana  
Carla Lins Prates, Rogeres Santos Do Nascimento,  
Mydiã Falcão Freitas, and Manoel Gomes De Men-  
donça. 2018\. A systematic review on the code smell  
effect. Journal of Systems and Software, 144:450–  
477\.  
\`\`\`  
\`\`\`  
Max Schäfer, Sarah Nadi, Aryaz Eghbali, and Frank  
Tip. 2023\. Adaptive test generation using a large  
language model.arXiv e-prints, pages arXiv–2302.  
\`\`\`  
\`\`\`  
Disha Shrivastava, Hugo Larochelle, and Daniel Tar-  
low. 2023\. Repository-level prompt generation for  
large language models of code. InInternational Con-  
ference on Machine Learning, ICML 2023, 23-  
July 2023, Honolulu, Hawaii, USA, volume 202 of  
Proceedings of Machine Learning Research, pages  
31693–31715. PMLR.  
\`\`\`  
\`\`\`  
Giancarlo Sierra, Emad Shihab, and Yasutaka Kamei.  
\`\`\`  
2019\. A survey of self-admitted technical debt.Jour-  
nal of Systems and Software, 152:70–82.

\`\`\`  
Ankita Nandkishor Sontakke, Manasi Patwardhan,  
Lovekesh Vig, Raveendra Kumar Medicherla, Ravin-  
dra Naik, and Gautam Shroff. 2022\. Code summa-  
rization: Do transformers really understand code? In  
Deep Learning for Code Workshop.  
\`\`\`  
\`\`\`  
Gemma Team, Morgane Riviere, Shreya Pathak,  
Pier Giuseppe Sessa, Cassidy Hardin, Surya Bhupati-  
raju, Léonard Hussenot, Thomas Mesnard, Bobak  
Shahriari, Alexandre Ramé, et al. 2024\. Gemma 2:  
Improving open language models at a practical size.  
arXiv preprint arXiv:2408.00118.  
\`\`\`  
\`\`\`  
Qwen Team. 2024\. Qwq: Reflect deeply on the bound-  
aries of the unknown.  
\`\`\`  
\`\`\`  
Hung Quoc To, Nghi DQ Bui, Jin Guo, and  
Tien N Nguyen. 2023\. Better language models  
of code through self-improvement. arXiv preprint  
arXiv:2304.01228.  
\`\`\`  
\`\`\`  
Hugo Touvron, Louis Martin, Kevin Stone, Peter Al-  
bert, Amjad Almahairi, Yasmine Babaei, Nikolay  
Bashlykov, Soumya Batra, Prajjwal Bhargava, Shruti  
Bhosale, et al. 2023\. Llama 2: Open founda-  
tion and fine-tuned chat models. arXiv preprint  
arXiv:2307.09288.  
\`\`\`  
\`\`\`  
Quyen Tran, Nguyen Thanh, Nguyen Anh, Nam Hai,  
Trung Le, Linh Ngo, and Thien Nguyen. 2024\. Pre-  
serving generalization of language models in few-  
shot continual relation extraction. InProceedings  
of the 2024 Conference on Empirical Methods in  
Natural Language Processing, pages 13771–13784.  
\`\`\`

Yue Wang, Hung Le, Akhilesh Deepak Gotmare,  
Nghi DQ Bui, Junnan Li, and Steven CH Hoi. 2023\.  
Codet5+: Open code large language models for  
code understanding and generation.arXiv preprint  
arXiv:2305.07922.

Yue Wang, Weishi Wang, Shafiq Joty, and Steven CH  
Hoi. 2021\. Codet5: Identifier-aware unified  
pre-trained encoder-decoder models for code un-  
derstanding and generation. arXiv preprint  
arXiv:2109.00859.

Zhiruo Wang, Shuyan Zhou, Daniel Fried, and Gra-  
ham Neubig. 2022\. Execution-based evaluation  
for open-domain code generation. arXiv preprint  
arXiv:2212.10481.

Yiqing Xie, Alex Xie, Divyanshu Sheth, Pengfei Liu,  
Daniel Fried, and Carolyn Rose. 2024\. Codebench-  
gen: Creating scalable execution-based code genera-  
tion benchmarks.arXiv preprint arXiv:2404.00566.

Frank F Xu, Uri Alon, Graham Neubig, and Vincent Jo-  
sua Hellendoorn. 2022\. A systematic evaluation of  
large language models of code. InProceedings of  
the 6th ACM SIGPLAN International Symposium on  
Machine Programming, pages 1–10.

Ruijie Xu, Zengzhi Wang, Run-Ze Fan, and Pengfei Liu.

2024\. Benchmarking benchmark leakage in large  
language models.arXiv preprint arXiv:2404.18824.

Prateek Yadav, Qing Sun, Hantian Ding, Xiaopeng Li,  
Dejiao Zhang, Ming Tan, Parminder Bhatia, Xiaofei  
Ma, Ramesh Nallapati, Murali Krishna Ramanathan,  
Mohit Bansal, and Bing Xiang. 2023\. Exploring  
continual learning for code generation models. In  
Proceedings of the 61st Annual Meeting of the As-  
sociation for Computational Linguistics (Volume 2:  
Short Papers), pages 782–792, Toronto, Canada. As-  
sociation for Computational Linguistics.

An Yang, Baosong Yang, Beichen Zhang, Binyuan Hui,  
Bo Zheng, Bowen Yu, Chengyuan Li, Dayiheng Liu,  
Fei Huang, Haoran Wei, et al. 2024\. Qwen2. 5 tech-  
nical report.arXiv preprint arXiv:2412.15115.

Pengcheng Yin, Bowen Deng, Edgar Chen, Bogdan  
Vasilescu, and Graham Neubig. 2018\. Learning to  
mine aligned code and natural language pairs from  
stack overflow. InProceedings of the 15th interna-  
tional conference on mining software repositories,  
pages 476–486.

Alex Young, Bei Chen, Chao Li, Chengen Huang,  
Ge Zhang, Guanwei Zhang, Guoyin Wang, Heng  
Li, Jiangcheng Zhu, Jianqun Chen, et al. 2024\. Yi:  
Open foundation models by 01\. ai. arXiv preprint  
arXiv:2403.04652.

Fengji Zhang, Bei Chen, Yue Zhang, Jacky Keung, Jin  
Liu, Daoguang Zan, Yi Mao, Jian-Guang Lou, and  
Weizhu Chen. 2023a. Repocoder: Repository-level  
code completion through iterative retrieval and gen-  
eration.arXiv preprint arXiv:2303.12570.

\`\`\`  
Fengji Zhang, Bei Chen, Yue Zhang, Jacky Keung, Jin  
Liu, Daoguang Zan, Yi Mao, Jian-Guang Lou, and  
Weizhu Chen. 2023b. Repocoder: Repository-level  
code completion through iterative retrieval and gen-  
eration. InProceedings of the 2023 Conference on  
Empirical Methods in Natural Language Process-  
ing, EMNLP 2023, Singapore, December 6-10, 2023,  
pages 2471–2484. Association for Computational  
Linguistics.  
Kechi Zhang, Jia Li, Ge Li, Xianjie Shi, and Zhi  
Jin. 2024\. Codeagent: Enhancing code genera-  
tion with tool-integrated agent systems for real-  
world repo-level coding challenges.arXiv preprint  
arXiv:2401.07339.  
Tianyu Zheng, Ge Zhang, Tianhao Shen, Xueling Liu,  
Bill Yuchen Lin, Jie Fu, Wenhu Chen, and Xiang  
Yue. 2024\. Opencodeinterpreter: Integrating code  
generation with execution and refinement. arXiv  
preprint arXiv:2402.14658.  
Terry Yue Zhuo, Minh Chien Vu, Jenny Chim, Han Hu,  
Wenhao Yu, Ratnadira Widyasari, Imam Nur Bani  
Yusuf, Haolan Zhan, Junda He, Indraneil Paul, et al.  
\`\`\`  
2024\. Bigcodebench: Benchmarking code genera-  
tion with diverse function calls and complex instruc-  
tions.arXiv preprint arXiv:2406.15877.

\# Appendix

\#\#\# A Data Source

Creating an executable benchmark within repository contexts poses significant challenges due to intricate  
setup requirements and the often inadequate installation instructions provided in repositories. Therefore,  
we select repositories that can be automatically set up usingpipreqsto auto-detect the required packages.  
Additionally, to effectively utilize the test generation module of our pipeline, we select repositories that  
align with the literature on unit test generation. As a result,REPOEXEC, is based on repositories from the  
unit test generation studies (Schäfer et al., 2023; Lukasczyk et al., 2023; Lemieux et al., 2023; Liu et al.,  
2024c), which provide executable environments and robust test generation capabilities.  
Some might claim that our dataset is constructed for based on existing works, thus, this approach  
can potentially lead to data leakage, especially when modern models are trained on similar datasets. If  
the benchmark relies heavily on known works, there’s a risk that the model may inadvertently learn  
from specific patterns or features present in those works, compromising its generalization ability. De-  
spite this concern, experimental results demonstrate that even modern models struggle to handle the  
challenges posed byREPOEXEC, indicating that the benchmark remains a valuable tool for assessing  
model performance. Besides, several models, including StarCoder2 and DeepSeek-Coder, have been  
pretrained using repository-level context. However, these models typically concatenate the contents of  
multiple files in a repository without filtering out irrelevant information or considering the selection of  
dependencies. This helps our dataset distinguish from the pretraining datasets of these models, thereby  
helping to mitigate the data leakage issue. To further measure the data leakage level compare to other  
benchmarks, we follow BenBench (Xu et al., 2024\) to report the perplexity and n-gram metrics, against  
three datasets—HumanEval, RepoCoder, and DevEval—analyzing their levels of data leakage when  
tested on three powerful LLMs. As indicated in Table 7, while HumanEval exhibits a significant level of  
data leakage, as expected, RepoExec demonstrates notably low levels of leakage. This is reflected in its  
higher perplexity and reduced n-gram overlap in most cases. The extent of data leakage in RepoExec is  
comparable to that of RepoCoder, a recently developed benchmark based on repositories created after  
January 1, 2022, to mitigate the data leakage problem. Consequently, the leakage issue in RepoExec  
is minimal, aligning with benchmarks like RepoCoder that utilize the latest repositories. We believe  
that repository-level code generation could be a valuable contribution to more robust and high-quality  
evaluation for advanced agent systems and dynamic environments (Huang et al., 2023; Phan et al., 2024b;  
Yadav et al., 2023; Hai et al., 2024b; Tran et al., 2024). By assessing models in a more comprehensive  
coding context, this approach enables a deeper evaluation of their ability to understand, integrate, and  
adapt code components effectively.

\`\`\`  
Model HumanEval RepoCoderperplexityDevEval RepoExec HumanEval RepoCodern-gramDevEval RepoExec  
Mistral-7B-v0.3 2.10 177.99 170.67 120.77 0.35 0.30 0.26 0\.  
CodeLlama-7B-Python 1.96 90.71 32.14 72.77 0.43 0.30 0.43 0\.  
CodeLlama-13B-Python 1.96 72.66 23.83 126.51 0.48 0.31 0.41 0\.  
\`\`\`  
\`\`\`  
Table 7: Comparison of data leakage level between REPOEXECand other benchmarks.  
\`\`\`  
\#\#\# B Evaluation Metrics: Match-Based vs. Execution-Based

\`\`\`  
Several code generation benchmarks utilize match-based metrics like Edit similarity (ES), BLEU, and  
CodeBLEU for evaluation (Ding et al., 2024; Shrivastava et al., 2023; Ding et al., 2023; Liao et al.,  
2023; Yin et al., 2018; Iyer et al., 2018). These metrics are straightforward to apply and may exhibit  
a strong correlation with execution metrics such as Pass@k. However, they cannot accurately measure  
functional correctness. For instance, comparing two Python code snippets where the only difference is the  
":" character could result in a good ES and BLEU score. Nevertheless, one snippet may contain a syntax  
error, highlighting a limitation in these metrics for assessing true functionality.  
\`\`\`

\`\`\`  
0.15 0.20 0.25 0.30 0.35 0\.  
pass@  
\`\`\`  
\`\`\`  
375  
\`\`\`  
\`\`\`  
350  
\`\`\`  
\`\`\`  
325  
\`\`\`  
\`\`\`  
300  
\`\`\`  
\`\`\`  
275  
\`\`\`  
\`\`\`  
250  
\`\`\`  
\`\`\`  
225  
\`\`\`  
\`\`\`  
Edit Similarity Pearson: 0\.  
Spearman: 0.70Kendall: 0\.  
0.15 0.20 0.25 0.30 0.35 0\.  
pass@  
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
BLEU-  
Pearson: 0.85Spearman: 0\.  
Kendall: 0\.  
0.15 0.20 0.25 0.30 0.35 0\.  
pass@  
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
CodeBLEU  
Pearson: 0.92Spearman: 0\.  
Kendall: 0\.  
\`\`\`  
\`\`\`  
Figure 3: Correlation between Match-based metrics and Execution-based metric (Pass@1).  
\`\`\`  
Figure 3 demonstrates that these metrics on average can achieve a strong correlation with Pass@k,  
with CodeBLEU showing the highest correlation with Pearson score of 0.92. However, upon closer  
inspection of the score distribution between correct and incorrect solutions (Figure 4), a considerable  
overlap becomes apparent. This underscores the limitation of match-based metrics in accurately measuring  
the correctness of code generation.

\`\`\`  
0.0 0.2 0.4 0.6 0\.  
CodeBLEU  
\`\`\`  
\`\`\`  
0 1000 2000 3000 4000  
Edit Similarity  
\`\`\`  
\`\`\`  
Correct Incorrect  
\`\`\`  
\`\`\`  
Figure 4: Match-based metric distributions between Correct and Incorrect solutions  
\`\`\`  
\#\#\# C Coverage Enhancement Effectiveness

Weak unit tests may inadvertently allow incorrect implementations to be determined as correct. Even with  
human-written tests, the overlooked coverage rates lead to evaluations that are incomplete and potentially  
misleading (Liu et al., 2023a). We present evidence supporting this argument, underscoring the limitations  
of prior work on code generation within repository-level contexts. As depicted in Figure 5, enhancing the  
number of test cases and coverage rates leads to a significant increase in the identification of incorrect  
generated solutions, causing the Pass@1 score to drop markedly (by over 5%). We investigated several  
solutions and found that most of the generated results did not fully utilize the given context (considered as  
human-provided). Instead, they primarily focused on addressing the problem described in the given natural  
language description. This indirectly overlooks the developer’s intentions, such as testing edge or corner  
cases, highlighting the limitations in following and understanding the provided intent and dependency  
context in these models. In summary, these findings underscore the effectiveness and importance of  
maintaining high-quality test cases for evaluation purposes.

\#\#\# D Test case generation

Generated test quality discussion: To ensure generated tests align with the target function’s require-  
ments, we employ several quality control measures, as discussed in Section 4.2. First, we provide the  
full target function in the LLM prompt to guide the generation of tests with the intended input and output  
formats. We then apply a Syntax-based filter to confirm that the generated tests correctly call the function  
with its signature and parameters. Additionally, to verify the accuracy of the tests, we execute them to  
confirm their pass status and measure their line coverage.  
In some minor cases, weak tests or even wrong ones may still arise despite these measures. For instance,  
flaky tests could pass and achieve high coverage but produce inconsistent outputs due to randomness.  
To address this, we execute tests multiple times and exclude those with inconsistent results. Similarly,  
concerns about unintended function calls are mitigated by deduplicating test cases and ensuring diversity  
in how functions are invoked. This process yields an average of 99 test cases per problem (Table  
1), ensuring robust evaluation even if some weaker tests are included. While we do not require such  
extensive coverage for correctness, this approach enhances the likelihood of strong test cases identifying  
implementation issues effectively. Furthermore, the test enhancement module is provided with a few  
examples of generated tests from the previous step to enhance coverage of edge cases and corner cases to  
ensure specific requirements.

\`\`\`  
0 10 20 30 40  
Pass@  
\`\`\`  
\`\`\`  
Codellama-34b-Python  
\`\`\`  
\`\`\`  
Codellama-13b-Python  
\`\`\`  
\`\`\`  
WizardCoder-Python-13B-V1.  
\`\`\`  
\`\`\`  
Phind-CodeLlama-34B-v  
\`\`\`  
\`\`\`  
Codellama-13b-Instruct  
\`\`\`  
\`\`\`  
StarCoder  
\`\`\`  
\`\`\`  
4\.  
\`\`\`  
\`\`\`  
5\.  
\`\`\`  
\`\`\`  
4\.  
\`\`\`  
\`\`\`  
5\.  
\`\`\`  
\`\`\`  
4\.  
\`\`\`  
\`\`\`  
5.19 af-CovEn  
bf-CovEn  
\`\`\`  
\`\`\`  
Figure 5: Performance of various CodeLMs onREPOEXECbefore (bf-) and after (af-) Coverage Enhancement  
(CovEn) stage.  
\`\`\`  
\`\`\`  
Test geneneration prompts: Below, we present two prompts designed for generating initial unit tests  
and improving the quality of existing tests.  
\`\`\`  
\`\`\`  
Initial Test Generation Prompt  
\`\`\`  
\`\`\`  
{function\_under\_test}  
\# test to check the correctness of "{ function\_name }" function  
assert  
\`\`\`

\`\`\`  
Coverage Enhancement Prompts  
\`\`\`  
Prompt 1:  
Here are some Python unit test functions and the focal function that they test:  
\# Test functions:  
{existing\_test\_functions}  
\# Focal function:  
{function\_under\_test}  
Write more unit test functions that will increase the test coverage of the function under test.  
—————————————————————————————————–  
Prompt 2:  
Here are some Python unit test functions and the focal function that they test:  
\# Test functions:  
{existing\_test\_functions}  
\# Focal function:  
{function\_under\_test}  
Write more unit test functions that will cover corner cases missed by the original and will increase  
the test coverage of the function under test.  
—————————————————————————————————–  
Prompt 3:  
Here is a focal function under test:  
{function\_under\_test}  
This function under test can be tested with these Python unit test functions:  
{existing\_test\_functions}  
Here is an extended version of the unit test function that includes additional unit test cases that will  
cover methods, edge cases, corner cases, and other features of the function under test that were  
missed by the original unit test functions:

\#\#\# E Data Formating

E.1 BasePrompt

\`\`\`  
Example of Full Context  
\`\`\`  
\`\`\`  
import base  
import random  
import unicodedata  
import zlib  
from typing import Union  
from uuid import uuid  
from .\_regex import \*  
from .errors import InvalidInputError  
from .validation import is\_snake\_case , is\_full\_string , is\_camel\_case , is\_integer , is\_string  
CAMEL\_CASE\_REPLACE\_RE \= re.compile(r'(\[a-z\]|\[A-Z\]+) (?=\[A-Z\])')  
class InvalidInputError(TypeError):  
"""  
Custom error raised when received object is not a string as expected.  
"""  
def \_\_init\_\_(self , input\_data: Any):  
"""  
:param input\_data: Any received object  
"""  
type\_name \= type(input\_data).\_\_name\_\_  
msg \='Expected "str", received "{}"'.format(type\_name)  
super ().\_\_init\_\_(msg)  
def is\_string(obj: Any) \-\> bool:  
"""  
Checks if an object is a string.  
\*Example :\*  
\>\>\> is\_string('foo') \# returns true  
\>\>\> is\_string(b'foo') \# returns false  
:param obj: Object to test.  
:return: True if string , false otherwise.  
"""  
return isinstance(obj , str)  
def is\_camel\_case(input\_string: Any) \-\> bool:  
"""  
Checks if a string is formatted as camel case.  
A string is considered camel case when:  
\`\`\`  
\- it's composed only by letters (\[a-zA \-Z\]) and optionally numbers (\[0 \-9\])  
\- it contains both lowercase and uppercase letters  
\- it does not start with a number  
\*Examples :\*  
\>\>\> is\_camel\_case('MyString') \# returns true  
\>\>\> is\_camel\_case('mystring') \# returns false  
:param input\_string: String to test.  
:type input\_string: str  
:return: True for a camel case string , false otherwise.  
"""  
return is\_full\_string(input\_string) and CAMEL\_CASE\_TEST\_RE.match(input\_string) is not None  
def camel\_case\_to\_snake(input\_string , separator='\_'):  
"""  
Convert a camel case string into a snake case one.  
(The original string is returned if is not a valid camel case string)  
\*Example :\*  
\>\>\> camel\_case\_to\_snake('ThisIsACamelStringTest') \# returns 'this\_is\_a\_camel\_case\_string\_test'  
:param input\_string: String to convert.  
:type input\_string: str  
:param separator: Sign to use as separator.  
:type separator: str  
:return: Converted string.  
"""

Example of Medium Context

\`\`\`  
import base  
import random  
import unicodedata  
import zlib  
from typing import Union  
from uuid import uuid  
from .\_regex import \*  
from .errors import InvalidInputError  
from .validation import is\_snake\_case , is\_full\_string , is\_camel\_case , is\_integer , is\_string  
CAMEL\_CASE\_REPLACE\_RE \= re.compile(r'(\[a-z\]|\[A-Z\]+) (?=\[A-Z\])')  
class InvalidInputError(TypeError):  
"""  
Custom error raised when received object is not a string as expected.  
"""  
def \_\_init\_\_(self , input\_data: Any):  
"""  
:param input\_data: Any received object  
"""  
def is\_string(obj: Any) \-\> bool:  
"""  
Checks if an object is a string.  
\*Example :\*  
\>\>\> is\_string('foo') \# returns true  
\>\>\> is\_string(b'foo') \# returns false  
:param obj: Object to test.  
:return: True if string , false otherwise.  
"""  
def is\_camel\_case(input\_string: Any) \-\> bool:  
"""  
Checks if a string is formatted as camel case.  
A string is considered camel case when:  
\`\`\`  
\- it's composed only by letters (\[a-zA \-Z\]) and optionally numbers (\[0 \-9\])  
\- it contains both lowercase and uppercase letters  
\- it does not start with a number  
\*Examples :\*  
\>\>\> is\_camel\_case('MyString') \# returns true  
\>\>\> is\_camel\_case('mystring') \# returns false  
:param input\_string: String to test.  
:type input\_string: str  
:return: True for a camel case string , false otherwise.  
"""  
def camel\_case\_to\_snake(input\_string , separator='\_'):  
"""  
Convert a camel case string into a snake case one.  
(The original string is returned if is not a valid camel case string)  
\*Example :\*  
\>\>\> camel\_case\_to\_snake('ThisIsACamelStringTest') \# returns 'this\_is\_a\_camel\_case\_string\_test'  
:param input\_string: String to convert.  
:type input\_string: str  
:param separator: Sign to use as separator.  
:type separator: str  
:return: Converted string.  
"""

\`\`\`  
Example of Small Context  
\`\`\`  
\`\`\`  
import base  
import random  
import unicodedata  
import zlib  
from typing import Union  
from uuid import uuid  
from .\_regex import \*  
from .errors import InvalidInputError  
from .validation import is\_snake\_case , is\_full\_string , is\_camel\_case , is\_integer , is\_string  
CAMEL\_CASE\_REPLACE\_RE \= re.compile(r'(\[a-z\]|\[A-Z\]+) (?=\[A-Z\])')  
class InvalidInputError(TypeError):  
def \_\_init\_\_(self , input\_data: Any):  
def is\_string(obj: Any) \-\> bool:  
def is\_camel\_case(input\_string: Any) \-\> bool:  
def camel\_case\_to\_snake(input\_string , separator='\_'):  
"""  
Convert a camel case string into a snake case one.  
(The original string is returned if is not a valid camel case string)  
\*Example :\*  
\>\>\> camel\_case\_to\_snake('ThisIsACamelStringTest') \# returns 'this\_is\_a\_camel\_case\_string\_test'  
:param input\_string: String to convert.  
:type input\_string: str  
:param separator: Sign to use as separator.  
:type separator: str  
:return: Converted string.  
"""  
\`\`\`  
E.2 InstructPrompt

\`\`\`  
Instruction Prompt Templates  
\`\`\`  
\`\`\`  
Prompt 1:  
\#\#\# Instruction:  
Write a Python function \`{target\_function\_signature}\` to solve the following  
problem:  
{target\_function\_docstring}  
\#\#\# Response:  
{BasePrompt}  
—————————————————————————————————–Prompt 2:  
\#\#\# Instruction:  
{dependency\_context}  
The provided code snippet includes necessary dependencies for implementing the  
\`{target\_function\_name}\` function. Write a Python function \`{  
target\_function\_signature}\` to solve the following problem:  
{target\_function\_docstring}  
\#\#\# Response:  
{target\_function\_prompt}  
\`\`\`

Example of Prompt 1 for Small Context

\`\`\`  
\#\#\# Instruction:  
Write a Python function\`camel\_case\_to\_snake(input\_string , separator='\_')\`to solve the following  
problem:  
"""  
Convert a camel case string into a snake case one.  
(The original string is returned if is not a valid camel case string)  
\*Example :\*  
\>\>\> camel\_case\_to\_snake('ThisIsACamelStringTest') \# returns'this\_is\_a\_camel\_case\_string\_test'  
:param input\_string: String to convert.  
:type input\_string: str  
:param separator: Sign to use as separator.  
:type separator: str  
:return: Converted string.  
"""  
\#\#\# Response:  
import base64  
import random  
import unicodedata  
import zlib  
from typing import Union  
from uuid import uuid4  
from .\_regex import \*  
from .errors import InvalidInputError  
from .validation import is\_snake\_case , is\_full\_string , is\_camel\_case , is\_integer , is\_string  
CAMEL\_CASE\_REPLACE\_RE \= re.compile(r'(\[a-z\]|\[A-Z\]+) (?=\[A-Z\])')  
class InvalidInputError(TypeError):  
def \_\_init\_\_(self , input\_data: Any):  
def is\_string(obj: Any) \-\> bool:  
def is\_camel\_case(input\_string: Any) \-\> bool:  
def camel\_case\_to\_snake(input\_string , separator='\_'):  
"""  
Convert a camel case string into a snake case one.  
(The original string is returned if is not a valid camel case string)  
\*Example :\*  
\>\>\> camel\_case\_to\_snake('ThisIsACamelStringTest') \# returns 'this\_is\_a\_camel\_case\_string\_test'  
:param input\_string: String to convert.  
:type input\_string: str  
:param separator: Sign to use as separator.  
:type separator: str  
:return: Converted string.  
"""  
\`\`\`

\`\`\`  
Example of Prompt 2 for Small Context  
\`\`\`  
\`\`\`  
\#\#\# Instruction  
import base64  
import random  
import unicodedata  
import zlib  
from typing import Union  
from uuid import uuid4  
from .\_regex import \*  
from .errors import InvalidInputError  
from .validation import is\_snake\_case , is\_full\_string , is\_camel\_case , is\_integer , is\_string  
CAMEL\_CASE\_REPLACE\_RE \= re.compile(r'(\[a-z\]|\[A-Z\]+) (?=\[A-Z\])')  
class InvalidInputError(TypeError):  
def \_\_init\_\_(self , input\_data: Any):  
def is\_string(obj: Any) \-\> bool:  
def is\_camel\_case(input\_string: Any) \-\> bool:  
The provided code snippet includes necessary dependencies for implementing the\`camel\_case\_to\_snake\`  
function. Write a Python function\`camel\_case\_to\_snake(input\_string , separator='\_')\`to solve  
the following problem:  
"""  
Convert a camel case string into a snake case one.  
(The original string is returned if is not a valid camel case string)  
\*Example :\*  
\>\>\> camel\_case\_to\_snake('ThisIsACamelStringTest') \# returns'this\_is\_a\_camel\_case\_string\_test'  
:param input\_string: String to convert.  
:type input\_string: str  
:param separator: Sign to use as separator.  
:type separator: str  
:return: Converted string.  
"""  
\#\#\# Response:  
def camel\_case\_to\_snake(input\_string , separator='\_'):  
"""  
Convert a camel case string into a snake case one.  
(The original string is returned if is not a valid camel case string)  
\*Example :\*  
\>\>\> camel\_case\_to\_snake('ThisIsACamelStringTest') \# returns 'this\_is\_a\_camel\_case\_string\_test'  
:param input\_string: String to convert.  
:type input\_string: str  
:param separator: Sign to use as separator.  
:type separator: str  
:return: Converted string.  
"""  
\`\`\`  
\#\#\# F Studied LLMs: Supplemental results

In this section, we offer supplementary results from the evaluation of LLMs onREPOEXEC. Table 4  
presents the Dependency Invocation Rate (DIR) for the experimented LLMs. When comparing models of  
the same size, it is shown that instruction-tuned models more effectively follow human intent in utilizing  
the provided dependencies with InstructPrompt. For example, WizardCoder outperforms CodeLlama by  
5%, and the instruction-tuned version of Mixtral-8x7B shows a 10% improvement over its foundation  
version. This highlights the strong capability of instruction-tuned models to follow the given context  
effectively. Besides, using the Medium context leads to a significant decline in both Pass@k and DIR  
using BasePrompt. This implies the generation of empty function bodies using this template.  
Indeed, Figure 6 illustrates the proportion of generated functions that are empty for each LLM using  
BasePrompt. The findings indicate that utilizing Medium context results in a substantial number of  
empty functions. This may be due to the input format of the context when using BasePrompt, which can  
mislead the model into interpreting dependency functions as few-shot examples. In the Medium context,  
the function bodies of dependencies are removed, making their format identical to the target function

prompt. This similarity can mislead the LMs, resulting in empty solutions. Particularly, Starcoder-2  
is heavily impacted by this issue, as over 31% of its generated results are empty functions, revealing a  
significant weakness of the model. Meanwhile, small context effectively decreases the occurrence of  
empty function generation by the model and, in certain instances, improves models’ ability in dependency  
calls (e.g. CodeLlama-13b-Python, WizardCoder-Python-13B-V1.0, and Mixtral-8x7B-Instruct-v0.1 in  
Table 4). We believe that the following reasons could contribute to this observation. Firstly, employing  
small context reduces the input token count, preventing truncation when exceeding the maximum length  
limit, thus allowing uninterrupted solution generation by the model. This reduced context enables  
models to concentrate exclusively on dependency signatures, thereby enhancing the probability that  
generated solutions effectively utilize these dependency token names. Moreover, function names hold  
substantial semantic value by delineating the function’s purpose. Many studies have underscored that code  
summarization heavily relies on extracting information from function names (Haldar and Hockenmaier,  
2024; Mondal et al., 2023; Sontakke et al., 2022). Therefore, this concise representation of dependencies  
has the potential to improve how models utilize dependencies in generating code.  
Additionally, Table 9 presents examples that support our findings in Section 6.1. For instance, in the  
first example, we observe that the instruction-tuned model can effectively utilize the given dependencies  
to manage edge cases to raise an error, whereas the pretrained model fails to do so. This supports our  
first findings. Meanwhile, the second and third examples demonstrate that pretrained models try to  
reimplement or devise workarounds instead of leveraging the available context. Additionally, in the  
second example, the instruction-tuned model successfully identifies the relevant dependencies; however, it  
complicates the situation and fails to produce the correct solution. This may suggest that hallucinations  
complicate the outputs generated by instruction-tuned models. In the third example, both types of models  
successfully pass the tests. However, although the context provides the dependency for creating a new  
Futureobject, these models attempt to reimplement the\_create\_futurefunction but fail to optimize  
memory usage effectively. This observation implies the potential of code smell and technical debt in these  
generated codes.  
Besides, we present supplementary results for both closed-source and open-source models in Table

8\. Specifically, we employ greedy decoding and report pass@1 and DIR metrics, selecting the best-  
performing results for each model based on either BasePrompt or InstructPrompt with Full context. The  
results demonstrate strong performance in both pass@k and DIR metrics with advanced reasoning models  
like DeepSeek-R1 and GPT-4o, highlighting their reliability in code generation. However, all pass@1  
results remain below 50%, underscoring the challenges posed by REPOEXEC.

\#\#\# G Multi-round Debugging

\`\`\`  
Prompt for Debugging  
\`\`\`  
\`\`\`  
{dependency\_context}  
\# The provided code snippet includes necessary dependencies for implementing  
the \`{target\_function\_name}\` function. Write a Python function \`{  
target\_function\_signature}\` to solve the following problem:  
{target\_function\_docstring}  
\# Here is the current solution.  
{error\_solution}  
\# When executing the below test case.  
{failed\_test\_case}  
\# The provided python code solution fails the test with the following errors ,  
please correct them.  
{error\_log}  
\# Please provide the modified code for me to review and provide feedback.  
{target\_function\_prompt}  
\`\`\`

\`\`\`  
ID Model Size (B) Pass@1 DIR  
1 DeepSeek-R1 (Guo et al., 2025\) 671 42.57 70.86  
2 DeepSeek-V3 (Liu et al., 2024a) 671 42.00 80.35  
3 Llama 3.1-Instruct (Dubey et al., 2024\) 405 39.43 73.26  
4 GPT-4o \- 38.00 68.15  
5 QwQ-Preview (Team, 2024\) 32 37.43 57.07  
6 DeepSeek-Coder-Instruct (Guo et al., 2024\) 33 35.71 67.02  
7 Yi-1.5 (Young et al., 2024\) 34 35.43 61.34  
8 Qwen-2.5-Coder-Instruct (Hui et al., 2024\) 14 34.28 65.68  
9 CodeQwen1.5 (Bai et al., 2023\) 7 32.29 59.48  
10 OpenCodeInterpreter (Zheng et al., 2024\) 33 31.42 61.28  
11 Phi-4 (Abdin et al., 2024\) 14 30.86 71.10  
12 GPT-4o-mini \- 30.29 74.75  
13 Llama 3.3-Instruct (Dubey et al., 2024\) 70 29.43 67.20  
14 DeepSeek-Coder (Guo et al., 2024\) 6.7 28.86 57.44  
15 Qwen-2.5-Instruct (Yang et al., 2024\) 14 28.85 65.63  
16 starcoder2 (Lozhkov et al., 2024\) 15 28.57 60.97  
17 Gemma2 (Team et al., 2024\) 27 28.00 71.68  
18 Llama-3.1-Instruct (Dubey et al., 2024\) 70 25.14 66.95  
\`\`\`  
\`\`\`  
Table 8: Performance of various LLMs on REPOEXEC.  
\`\`\`  
We employ Multi-round debugging in code generation, which iteratively refines and improves the  
generated code through multiple cycles of debugging. Following the execution of unit tests on the  
generated functions, we extract the error log if the code fails to run. We employ the following prompt to  
utilize the model for bug fixing. This process is iterated multiple times until either the correct code is  
achieved or the maximum number of rounds is reached. Specifically, we set the maximum number of  
rounds to 3 and experimented on three models WizardCoder, GPT-3.5 and CodeLlama-13b-Python.  
Table 5 shows the improvement across three rounds of debugging in various models. We observe that  
GPT-3.5 and WizardCoder demonstrate a high capacity for debugging with improvement of over 10%  
and 7% in Pass@1, respectively, while CodeLlama fails to take advantage of this process. Additionally,  
the DIR has also shown a significant improvement (over 7%) after three rounds of debugging in these  
two instruction models (Figure 7). These findings indicate a promising approach using self-refinement  
with debugging for code generation, which can enhance both the correctness and the utilization of given  
dependencies.  
We also present data on the number of error types corrected in each round of WizardCoder, as illustrated  
in Figure 8\. We can see thatAssertionErrormakes up the majority of errors across all rounds. This error  
type indicates either incorrect outputs from the generated code or the presence of empty function bodies  
(return None). However, by incorporating the test output guide, the model effectively addressed most  
of these errors. Furthermore, fundamental issues likeSyntaxErrororAttributeErrorwere promptly  
rectified during the initial round.

\#\#\# H Context length, model size and families analysis

\`\`\`  
Long-context models can enhance the ability to comprehend and select relevant context from lengthy  
inputs to effectively solve the required task. In this section, we examine how the context length supported  
by each model affects their performance inREPOEXEC. Figure 9 demonstrates the relationship between  
support context length, model size, and model family in relation to pass@k and DIR scores.  
We observe that context length has a weak correlation with model performance on our dataset. In con-  
trast, model size (scaling law) and model family, which encompass different training methods (pretraining  
or instruction tuning), training datasets, and architectures, show a more significant impact. The weak  
correlation with context length can be explained by our approach’s ability to already capture relevant  
\`\`\`

\`\`\`  
0 5 10 15 20 25 30  
Percentage (%)  
\`\`\`  
\`\`\`  
Codellama-34b-Python  
\`\`\`  
\`\`\`  
Codellama-13b-Python  
\`\`\`  
\`\`\`  
Starcoder  
\`\`\`  
\`\`\`  
Starcoder-2  
\`\`\`  
\`\`\`  
Phind-CodeLlama-34B-v2  
\`\`\`  
\`\`\`  
phi-2  
\`\`\`  
\`\`\`  
8.79  
\`\`\`  
\`\`\`  
8.73  
\`\`\`  
\`\`\`  
7.04  
\`\`\`  
\`\`\`  
5.86  
\`\`\`  
\`\`\`  
7.89  
\`\`\`  
\`\`\`  
8.11  
\`\`\`  
\`\`\`  
17.44  
\`\`\`  
\`\`\`  
14.9  
\`\`\`  
\`\`\`  
14.79  
\`\`\`  
\`\`\`  
31.8  
\`\`\`  
\`\`\`  
21.24  
\`\`\`  
\`\`\`  
11.86  
\`\`\`  
\`\`\`  
3.85  
\`\`\`  
\`\`\`  
2.39  
\`\`\`  
\`\`\`  
2.17  
\`\`\`  
\`\`\`  
9.63  
\`\`\`  
\`\`\`  
4.06  
\`\`\`  
\`\`\`  
1.01  
\`\`\`  
\`\`\`  
Full Context  
Medium Context  
Short Context  
\`\`\`  
\`\`\`  
Figure 6: Percentage of generated outputs that result in empty functions across various context types.  
\`\`\`  
\`\`\`  
information (e.g. dependency) for each data sample, resulting in the pruning of context length for practical  
usage (363 tokens on average shown in Table 1). Meanwhile, models that support long contexts are often  
trained on data containing a mix of relevant and irrelevant information and are evaluated on their ability  
to retrieve the correct context in a needle-in-a-haystack scenario (Roziere et al., 2023; Ivgi et al., 2023;  
Liu et al., 2024b). Therefore, models with varying context lengths might show a weak correlation to  
performance in our scenario.  
\`\`\`  
\#\#\# I Dependency Extraction Tool

We presentpydepcall, a Python library designed to extract function dependencies from any repository.  
Our tool provides a quick, practical solution for scalability, requiring only three lines of code to extract  
dependencies for all functions in any repository. Specifically, our tool is based on two conventions for  
retrieving function dependencies of a programming language:

\- Import Convention (for cross-file dependencies):The convention mentions how a programming  
    language imports modules within a repository. This can be utilized to extract dependency names from  
    different files. For instance, in Python, this can be done using statements such as "from file import  
    function/class/variable" or "from file1.file2 import function/class/variable."  
\- Calling Dependencies Convention:This principle pertains to how a program invokes variables,  
    functions, and classes. In Python, functions are typically called by specifying their names followed  
    by parentheses (e.g.,function1(param1, param2)), or by using a dot notation to access attributes  
    or methods from a module (e.g.,file1\*\*.\*\* function1, class1\*\*.\*\* attribute1).

\`\`\`  
Besides,pydepcallcan extract dependencies at various depths, up to 100 levels deep, which can help  
the community explore the integration of a deeper context. We provide a brief overview of its usage in the  
following code snippet.  
\`\`\`

\`\`\`  
GPT-3.5 WizardCoder  
0  
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
70  
\`\`\`  
\`\`\`  
DIR  
63.65 63.54  
\`\`\`  
\`\`\`  
70.6 70.63  
\`\`\`  
\`\`\`  
GPT-3.5 WizardCoder  
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
\`\`\`  
35  
\`\`\`  
\`\`\`  
40  
\`\`\`  
\`\`\`  
Pass@1  
\`\`\`  
\`\`\`  
27.04  
\`\`\`  
\`\`\`  
34.37  
\`\`\`  
\`\`\`  
41.97 42.64  
\`\`\`  
\`\`\`  
LLMs  
\`\`\`  
\`\`\`  
round 0 round 3  
\`\`\`  
\`\`\`  
Figure 7: Improvement of instruction-tuning models on Pass@1 and DIR after 3-round debugging process.  
\`\`\`  
\`\`\`  
Round 1  
\`\`\`  
\`\`\`  
TypeError  
\`\`\`  
\`\`\`  
NameError  
\`\`\`  
AssertionError

\`\`\`  
SyntaxError  
\`\`\`  
\`\`\`  
AttributeError  
\`\`\`  
\`\`\`  
Round 2  
\`\`\`  
\`\`\`  
AssertionError  
\`\`\`  
\`\`\`  
TypeError  
\`\`\`  
\`\`\`  
ValueError  
Round 3  
\`\`\`  
\`\`\`  
AssertionError  
\`\`\`  
\`\`\`  
NameError  
\`\`\`  
\`\`\`  
Figure 8: Fixed error types of WizardCoder across 3 rounds of the debugging process.  
\`\`\`  
\`\`\`  
pydepcallusage  
\`\`\`  
\`\`\`  
from pydepcall import Extractor  
\# If you want to extract all module files in the repository  
reposrc \= YOUR\_LOCAL\_PATH\_OF\_REPO  
extractor \= Extractor(reposrc)  
output \= extractor.extract ()  
\# If you want to extract a specific module file in the repository  
reposrc \= YOUR\_LOCAL\_PATH\_OF\_REPO  
module\_file \= YOUR\_LOCAL\_PATH\_OF\_FILE\_IN\_REPO  
extractor \= Extractor(reposrc , module\_file)  
output \= extractor.extract ()  
\`\`\`

\`\`\`  
0 20 40 60 80 100 120  
Context length  
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
pass@1  
\`\`\`  
\`\`\`  
Pearson: 0.02  
Spearman: 0.43  
Kendall: 0.33  
x1e3 0 20 40 60 80 100 120  
Context length  
\`\`\`  
\`\`\`  
45  
\`\`\`  
\`\`\`  
50  
\`\`\`  
\`\`\`  
55  
\`\`\`  
\`\`\`  
60  
\`\`\`  
\`\`\`  
65  
\`\`\`  
\`\`\`  
70  
\`\`\`  
\`\`\`  
DIR  
\`\`\`  
\`\`\`  
Pearson: 0.31  
Spearman: 0.49  
Kendall: 0.35  
x1e3  
\`\`\`  
\`\`\`  
CodeLlama StarCoder Phi DeepSeek-Coder  
\`\`\`  
Figure 9: Correlation of context length to the model performance onREPOEXEC. The size of the dots indicates the  
model size, while the color represents the model family.

\`\`\`  
Input Prompt & Solution Generation output  
\`\`\`  
\`\`\`  
\# Prompt:  
import base64  
import random  
import unicodedata  
...  
class InvalidInputError(TypeError):  
...  
def is\_string(obj: Any) \-\> bool:  
...  
def reverse(input\_string: str) \-\> str:  
"""  
Returns the string with its chars reversed.  
\*Example :\*  
\>\>\> reverse('hello') \# returns'olleh'  
:param input\_string: String to revert.  
:type input\_string: str  
:return: Reversed string.  
"""  
\--------------------------------------------------  
\# Solution:  
def reverse(input\_string: str) \-\> str:  
"""  
Returns the string with its chars reversed.  
\*Example :\*  
\>\>\> reverse('hello') \# returns'olleh'  
:param input\_string: String to revert.  
:type input\_string: str  
:return: Reversed string.  
"""  
if not is\_string(input\_string):  
raise InvalidInputError(input\_string)  
return input\_string \[:: \-1\]  
\`\`\`  
\`\`\`  
\# Model type: Pretrained  
\# Passed: No  
def reverse(input\_string: str) \-\> str:  
"""  
Returns the string with its chars reversed.  
\*Example :\*  
\>\>\> reverse('hello') \# returns 'olleh'  
:param input\_string: String to revert.  
:type input\_string: str  
:return: Reversed string.  
"""  
return input\_string \[:: \-1\]  
\--------------------------------------------------  
\# Model type: Instruction \-tuned  
\# Passed: Yes  
def reverse(input\_string: str) \-\> str:  
"""  
Returns the string with its chars reversed.  
\*Example :\*  
\>\>\> reverse('hello') \# returns 'olleh'  
:param input\_string: String to revert.  
:type input\_string: str  
:return: Reversed string.  
"""  
if not is\_string(input\_string):  
raise InvalidInputError(input\_string)  
return input\_string \[:: \-1\]  
\`\`\`

\# Prompt:  
import random  
import luigi  
import luigi.configuration  
...

class hadoopcli(luigi.Config):  
command \= ...  
version \= ...

def get\_configured\_hadoop\_version ():  
"""  
CDH4 (hadoop 2+) has a slightly different  
syntax for interacting with hdfs  
via the command line.  
The default version is CDH4 , but one can  
override  
this setting with "cdh3" or "apache1" in the  
hadoop section of the config  
in order to use the old syntax.  
"""  
\--------------------------------------------------

\# Solution:  
def get\_configured\_hadoop\_version ():  
"""  
CDH4 (hadoop 2+) has a slightly different  
syntax for interacting with hdfs  
via the command line.  
The default version is CDH4 , but one can  
override  
this setting with "cdh3" or "apache1" in the  
hadoop section of the config  
in order to use the old syntax.  
"""  
return hadoopcli ().version.lower ()

\`\`\`  
\# Model type: Pretrained  
\# Passed: Yes  
def get\_configured\_hdfs\_client ():  
"""  
This is a helper that fetches the  
configuration value for 'client'in  
the \[hdfs\] section. It will return the  
client that retains backwards  
compatibility when 'client'isn't configured  
.  
"""  
return luigi.configuration.get\_config ().get(  
'hdfs', 'client', 'hadoopcli')  
\--------------------------------------------------  
\# Model type: Instruction \-tuned  
\# Passed: No  
def get\_configured\_hadoop\_version ():  
"""  
CDH4 (hadoop 2+) has a slightly different  
syntax for interacting with hdfs  
via the command line.  
The default version is CDH4 , but one can  
override  
this setting with "cdh3" or "apache1" in the  
hadoop section of the config  
in order to use the old syntax.  
"""  
hadoop\_cli \= hadoopcli ().command.split ()  
hadoop\_version \= hadoopcli ().version  
if hadoop\_version \== "cdh3":  
return hadoop\_cli \+ \["fs"\]  
elif hadoop\_version \== "apache1":  
return hadoop\_cli \+ \["dfs"\]  
else:  
return hadoop\_cli  
\`\`\`

\# Prompt:  
import asyncio  
import builtins  
import collections  
...

def is\_future(x: Any) \-\> bool:  
return isinstance(x, FUTURES)

def \_create\_future () \-\> Future:  
future \= Future () \# type: Future  
\# Fixup asyncio debug info by removing  
extraneous stack entries  
source\_traceback \= getattr(future , "  
\_source\_traceback", ())  
while source\_traceback:  
\# Each traceback entry is equivalent to  
a  
\# (filename , self.lineno , self.name ,  
self.line) tuple  
filename \= source\_traceback \[ \-1\]\[0\]  
if filename \== \_\_file\_\_:  
del source\_traceback \[-1\]  
else:  
break  
return future

def maybe\_future(x: Any) \-\> Future:  
""" Converts\`\`x\`\`into a\`.Future\`.  
If\`\`x\`\`is already a \`.Future\`, it is  
simply returned; otherwise  
it is wrapped in a new\`.Future\`. This is  
suitable for use as  
\`\`result \= yield gen.maybe\_future(f())\`\`  
when you don't know whether  
\`\`f()\`\`returns a\`.Future\`or not.  
.. deprecated :: 4.3  
This function only handles\`\`Futures\`\`, not  
other yieldable objects.  
Instead of\`maybe\_future\`, check for the non  
\-future result types  
you expect (often just\`\`None\`\`), and\`\`  
yield\`\`anything unknown.  
"""  
\--------------------------------------------------

\# Solution:  
def maybe\_future(x: Any) \-\> Future:  
""" Converts\`\`x\`\`into a\`.Future\`.  
If\`\`x\`\`is already a \`.Future\`, it is  
simply returned; otherwise  
it is wrapped in a new\`.Future\`. This is  
suitable for use as  
\`\`result \= yield gen.maybe\_future(f())\`\`  
when you don't know whether  
\`\`f()\`\`returns a\`.Future\`or not.  
.. deprecated :: 4.3  
This function only handles\`\`Futures\`\`,  
not other yieldable objects.  
Instead of\`maybe\_future\`, check for the  
non \-future result types  
you expect (often just\`\`None\`\`), and\`\`  
yield\`\`anything unknown.  
"""  
if is\_future(x):  
return x  
else:  
fut \= \_create\_future ()  
fut.set\_result(x)  
return fut

\`\`\`  
\# Model type: Pretrained  
\# Passed: Yes  
def maybe\_future(x: Any) \-\> Future:  
""" Converts\`\`x\`\`into a \`.Future\`.  
If\`\`x\`\`is already a\`.Future\`, it is  
simply returned; otherwise  
it is wrapped in a new\`.Future\`. This is  
suitable for use as  
\`\`result \= yield gen.maybe\_future(f())\`\`  
when you don't know whether  
\`\`f()\`\`returns a\`.Future\`or not.  
.. deprecated :: 4.3  
This function only handles\`\`Futures\`\`, not  
other yieldable objects.  
Instead of\`maybe\_future\`, check for the non  
\-future result types  
you expect (often just\`\`None\`\`), and\`\`  
yield\`\`anything unknown.  
"""  
if is\_future(x):  
return x  
future \= Future () \# type: Future  
future.set\_result(x)  
return future  
\--------------------------------------------------  
\# Model type: Instruction \-tuned  
\# Passed: Yes  
def maybe\_future(x: Any) \-\> Future:  
""" Converts\`\`x\`\`into a \`.Future\`.  
If\`\`x\`\`is already a\`.Future\`, it is  
simply returned; otherwise  
it is wrapped in a new\`.Future\`. This is  
suitable for use as  
\`\`result \= yield gen.maybe\_future(f())\`\`  
when you don't know whether  
\`\`f()\`\`returns a\`.Future\`or not.  
.. deprecated :: 4.3  
This function only handles\`\`Futures\`\`, not  
other yieldable objects.  
Instead of\`maybe\_future\`, check for the non  
\-future result types  
you expect (often just\`\`None\`\`), and\`\`  
yield\`\`anything unknown.  
"""  
if isinstance(x, Future):  
return x  
elif isawaitable(x):  
return asyncio.ensure\_future(x)  
else:  
future \= Future ()  
future.set\_result(x)  
return future  
\`\`\`  
\`\`\`  
Table 9: Output samples of Pretrained and Instruction-tuned models.  
\`\`\`


\#\# Issue2Test: Generating Reproducing Test Cases from Issue Reports

\#\# Noor Nashid

\#\#\# University of British Columbia

\#\#\# Vancouver, Canada

\#\#\# nashid@ece.ubc.ca

\#\# Islem Bouzenia

\#\#\# CISPA Helmholtz Center for Information Security

\#\#\# Stuttgart, Germany

\#\#\# bouzenia.islem@pm.me

\#\# Michael Pradel

\#\#\# CISPA Helmholtz Center for Information Security

\#\#\# Stuttgart, Germany

\#\#\# michael@binaervarianz.de

\#\# Ali Mesbah

\#\#\# University of British Columbia

\#\#\# Vancouver, Canada

\#\#\# amesbah@ece.ubc.ca

\#\# Abstract

\`\`\`  
Automated tools for solving GitHub issues are receiving significant  
attention by both researchers and practitioners, e.g., in the form of  
foundation models and LLM-based agents prompted with issues.  
A crucial step toward successfully solving an issue is creating a  
test case that accurately reproduces the issue. Such a test case can  
guide the search for an appropriate patch and help validate whether  
the patch matches the issue’s intent. However, existing techniques  
for issue reproduction show only moderate success. This paper  
presentsIssue2Test, an LLM-based technique for automatically  
generating a reproducing test case for a given issue report. Unlike  
automated regression test generators, which aim at creating passing  
tests, our approach aims at a test that fails, and that fails specifi-  
cally for the reason described in the issue. To this end,Issue2Test  
performs three steps: (1) understand the issue and gather context  
(e.g., related files and project-specific guidelines) relevant for re-  
producing it; (2) generate a candidate test case; and (3) iteratively  
refine the test case based on compilation and runtime feedback  
until it fails and the failure aligns with the problem described in  
the issue. We evaluateIssue2Teston the SWT-bench-lite dataset,  
where it successfully reproduces 32.9% of the issues, achieving a  
16.3% relative improvement over the best existing technique. Our  
evaluation also shows thatIssue2Testreproduces 20 issues that  
four prior techniques fail to address, contributing a total of 60.4%  
of all issues reproduced by these tools. We envision our approach  
to contribute to enhancing the overall progress in the important  
task of automatically solving GitHub issues.  
\`\`\`  
\#\# Keywords

\`\`\`  
Bug reproduction, test generation, large language model  
ACM Reference Format:  
Noor Nashid, Islem Bouzenia, Michael Pradel, and Ali Mesbah. 2026\. Is-  
sue2Test: Generating Reproducing Test Cases from Issue Reports. In. ACM,  
New York, NY, USA, 13 pages. https://doi.org/10.1145/nnnnnnn.nnnnnnn  
\`\`\`  
\`\`\`  
Permission to make digital or hard copies of all or part of this work for personal or  
classroom use is granted without fee provided that copies are not made or distributed  
for profit or commercial advantage and that copies bear this notice and the full citation  
on the first page. Copyrights for components of this work owned by others than the  
author(s) must be honored. Abstracting with credit is permitted. To copy otherwise, or  
republish, to post on servers or to redistribute to lists, requires prior specific permission  
and/or a fee. Request permissions from permissions@acm.org.  
Conference’17, Washington, DC, USA  
© 2026 Copyright held by the owner/author(s). Publication rights licensed to ACM.  
ACM ISBN 978-x-xxxx-xxxx-x/YYYY/MM  
https://doi.org/10.1145/nnnnnnn.nnnnnnn  
\`\`\`  
\#\# 1 Introduction

\`\`\`  
Issue reports, e.g., on GitHub, are commonly used to describe bugs,  
missing features, and other ways to improve a software project.  
Because addressing issues takes significant developer effort, recent  
work invests heavily in automated issue solving. Motivated by  
benchmarks of issues in popular open-source projects, such as  
SWE-bench \[ 22 \], foundation models and Large Language Model  
(LLM)-based software engineering agents compete in their ability  
to successfully solve issues \[ 9 , 34 – 36 , 42 , 46 , 49 , 51 , 52 \]. In addition  
to approaches that directly work on issues, automated program  
repair \[ 25 \] tries to address bugs that manifest through a failing  
test. Various techniques have been explored for automated bug  
repair \[7, 15, 50\].  
A crucial prerequisite for successfully solving an issue or repair-  
ing a bug is a test case that reproduces the problem. Unfortunately,  
issue reports rarely include executable tests that reproduce the is-  
sue, making it challenging for developers and automated techniques  
to validate potential patches. Specifically in open-source projects,  
contributors often lack the expertise and familiarity to construct  
meaningful test cases alongside their reports. Most work on auto-  
mated program repair repair assumes reproducing test cases to be  
given. In practice, however, developers often write test cases only  
after a problem was fixed \[ 11 \]. Automated issue solving techniques  
sometimes include a step for reproducing the issue \[ 37 \], but do not  
explicitly focus on this important part.  
One approach for obtaining an issue-reproducing test case could  
be automated test generation. Both traditional approaches \[ 17 , 33 \]  
and neural methods \[ 14 , 47 \] attempt to reduce the time spent on  
manually writing tests. However, earlier techniques often fail to  
generate human-readable and maintainable test cases that align  
with project conventions and effectively validate intended program  
behavior \[ 13 \]. The emergence of LLMs has significantly enhanced  
automated test generation \[ 29 , 44 , 53 \]. LLMs can synthesize tests  
with human-like readability and writing style, reflecting patterns  
learned from extensive training on large code repositories \[ 53 \]. This  
capability has prompted the use of LLMs in test code generation \[ 5 ,  
10 , 26 , 32 , 40 , 41 , 45 \]. While useful for creating regression tests,  
none of these approaches addresses the problem of creating tests  
that reproduce a specific issue.  
To address the challenge of creating issue-reproducing tests, re-  
cent work proposes test generators specifically for this purpose.  
Libro \[ 24 \] generates tests from bug reports using LLM prompting  
but focuses on structured benchmarks, such as Defects4J, rather  
than real-world issue reproduction. Mündler et al. \[ 30 \] introduce  
\`\`\`  
\# arXiv:2503.16320v4 \[cs.SE\] 5 Jan 2026

\`\`\`  
Conference’17, July 2017, Washington, DC, USA Noor Nashid, Islem Bouzenia, Michael Pradel, and Ali Mesbah  
\`\`\`  
SWT-bench-lite, a subset of SWE-bench, for evaluating issue repro-  
duction, and modify the prompts of existing agents for this task.  
Yet, these agents are neither designed nor effective at generating  
issue-reproducing tests. Most recently, Auto-TDD \[ 1 \] proposes a  
structured multi-step process, achieving a 21.7% fail-to-pass rate  
on SWT-bench-lite. While Auto-TDD improves over prior work,  
it does not explicitly enforce the creation of failing tests, which is  
important to successfully reproduce issues.  
This paper presentsIssue2Test, a novel LLM-based technique  
for automatically generating a reproducing test case for a given  
issue report. In contrast to automated regression test generators,  
which aim at creating passing tests, our approach aims at a test  
that fails, and that fails specifically for the reason described in the  
issue. To this end,Issue2Testperforms three steps: (1) understand  
the issue and gather context (e.g., related files and project-specific  
guidelines) relevant for reproducing it; (2) generate a candidate test  
case; and (3) iteratively refine the test case based on compilation  
and runtime feedback until it fails and the failure aligns with the  
problem described in the issue. Unlike prior work on generating  
issue-reproducing tests,Issue2Testcontinuously checks whether  
the generated tests capture problem described in the issue.  
We evaluateIssue2Teston all 276 instances of SWT-bench-  
lite, a subset of SWE-bench that has been extensively used for  
evaluating prior work \[ 1 , 30 \]. The results show that our approach:  
i) outperforms all the existing baselines by generating tests for 91  
instances (13 more than the best baseline) with the best performing  
LLM, ii) successfully generates tests for 20 unique issues missed by  
any prior work and contributes 60.4% of the union of reproduced  
issues by any technique, iii) imposes moderate costs of 5.21 cents  
per issue, which is orders of magnitude cheaper than what a human  
software developer would charge for performing the same task.  
In summary, our paper contributes the following:

\- The first technique for generated issue-reproducing tests  
    that explicitly aims at producing tests that fail, and that fail  
    for the reasons described in the issue.  
\- Empirical evidence thatIssue2Testsignificantly outper-  
    forms the current state of the art, showing a 40.1% relative  
    improvement over the best existing technique.  
\- We make our code and data publicly available, providing a  
    starting point for future work.

\#\# 2 Approach

\`\`\`  
In this section, we introduce a real example from the SWT-bench  
dataset, the challenges accompanying the reproduction of the ex-  
ample issue, how our approach addresses it, step by step, while  
introducing and explaining the components and the workflow of  
our approach, Issue2Test.  
\`\`\`  
\#\# 2.1 Running Example

The reported Django issue, shown in Figure 1, illustrates a regres-  
sion where overridingget\_FIELD\_display()no longer works as  
expected. While the report describes the issue, it lacks essential  
details for straightforward replication. For instance, the issue is  
missing details on necessary imports, app declaration, model mi-  
grations, and explicit steps to formulate and execute a test case  
with a failing assertion. Lacking these key elements, developers

\`\`\`  
Title  
Cannot override get\_FOO\_display() in Django 2.2+  
Description  
I cannot override the get\_FIELD\_display function on models  
since version 2.2. It works in version 2.1.  
Example:  
1 class FooBar(models.Model):  
2 foo\_bar \= models.CharField(\_("foo"), choices  
\=\[(1, 'foo'), (2, 'bar')\])  
3  
4 def \_\_str\_\_(self):  
5 return self.get\_foo\_bar\_display() \# This  
returns 'foo' or 'bar' in 2.2, but '  
something' in 2\.  
6  
7 def get\_foo\_bar\_display(self):  
8 return "something"  
\`\`\`  
\`\`\`  
What I expect is that I should be able to override this function.  
\`\`\`  
\`\`\`  
Figure 1: Django-12284 issue from SWT-bench \[30\].  
\`\`\`  
\`\`\`  
must dedicate efforts to understanding and filling-up the missing  
details. The goal of our paper is to create a technique that suggests  
ready-to-use test cases that reproduce the problem described by  
the issue. In the example of Figure 1, the issue is a bug, but in other  
cases it could also reflect a request for a new feature or improved  
performance.  
Figure 2 presents a test case generated byIssue2Testfor the  
issue described in Figure 1, successfully reproducing the reported  
failure. Automatically generating such reproducing tests is practi-  
cally valuable: it helps developers understand the issue more clearly,  
provides a concrete failure scenario to aid debugging, and enables  
patch validation in the absence of existing tests. For AI-based tools  
and agents, the generated test serves as an executable specification  
of the issue, potentially supporting automated repair and patch  
validation workflows.  
While the running example involves a Django regression, many  
GitHub issues report failures where the underlying cause must be  
carefully validated. In such cases, prior approaches often produce  
tests that fail due to unrelated reasons, such as misconfigured envi-  
ronments or irrelevant assertions, without checking whether the  
failure corresponds to the reported issue. This underscores the need  
for verifying that generated test failures are semantically aligned  
with the issue description.  
In this section, we describe the steps and strategies used by our  
approach to generate such tests.  
\`\`\`  
\#\# 2.2 Overall Design

\`\`\`  
The overall design of our approach is shown in Figure 3.Issue2Test  
automates the task of test generation by combining structured LLM  
prompting, validation based on runtime feedback, and iterative  
refinement. Our technique provides a pipeline for generating and  
refining test cases derived from reported issues (e.g, the issue in  
Figure 1). The approach is structured into three main phases, briefly  
described in the following and then in detail in the subsequent  
subsections. Our design invokes LLMs throughout various steps of  
the approach, as shown in Figure 3\.  
Phase 1, issue comprehension, analyzes the root cause of the  
problem, infers project-specific testing guidelines, and identifies  
\`\`\`

\`\`\`  
Issue2Test: Generating Reproducing Test Cases from Issue Reports Conference’17, July 2017, Washington, DC, USA  
\`\`\`  
\`\`\`  
Import Statements  
1 from django.conf import settings  
2 import django  
3 from django.db import models  
4 from django.test import TestCase  
\`\`\`  
Django Settings Configuration  
5 \*\*if not\*\* settings.configured:  
6 settings.configure( INSTALLED\_APPS=\[  
7 'django.contrib.contenttypes', 'test\_app'\],  
8 DATABASES={'default': {'ENGINE':  
9 'django.db.backends.sqlite3','NAME':':memory:'}})  
10 django.setup()

\`\`\`  
Target Test Subjects (Models A and B)  
\`\`\`  
11 \*\*class\*\* A(models.Model):  
12 foo\_choice \= \[("A", "output1"),("B", "output2")\]  
13 field\_foo \= models.CharField(max\_length=254,  
14 choices=foo\_choice)  
15 \*\*class\*\* Meta:  
16 abstract \= True  
17  
18 \*\*class\*\* B(A):  
19 foo\_choice \= \[("A", "output1"), ("B", "output2")  
20 ,("C", "output3")\]  
21 field\_foo \= models.CharField(max\_length=254,  
22 choices=foo\_choice)  
23 \*\*class\*\* Meta:  
24 app\_label \= 'test\_app'

\`\`\`  
Test Case and Assertion  
\`\`\`  
25 \*\*class\*\* ModelDisplayTests(TestCase):  
26 \*\*def\*\* test\_get\_field\_foo\_display\_for\_C(self):  
27 instance \= B(field\_foo='C')  
28 self.assertEqual(instance.get\_field\_foo\_display()  
,'output3')

\`\`\`  
Figure 2: Test generated by Issue2Test for Django-12284.  
\`\`\`  
relevant files.Issue2Testbegins by analyzing a reported issue to  
extract essential context, including the nature of the problem, its  
potential causes, and the associated code and test files. During the  
first phase, the tool queries an LLM to conduct an initial root cause  
analysis, yielding a list of plausible reasons. Subsequently, a set  
of project-specific guidelines are generated that encapsulate best  
practices and conventions for addressing issues in the target project,  
along with recommendations for writing isolated standalone test  
cases. The final step in this phase involves searching the codebase  
to locate relevant files based on the project’s structure.  
Phase 2, test generation, synthesizes an initial test case. The infor-  
mation gathered from Phase 1, combined with the issue details, is  
used to construct a test generation prompt.Issue2Testthen queries  
an LLM with this prompt and expects a Python script containing the  
testing code. The generated script is then passed through a static  
linter to detect any potential issues. If the linter identifies problems,  
the test generation prompt is augmented with the linter’s feedback,  
and the LLM is subsequently asked to resolve these issues.  
Phase 3, test refinement, iteratively improves the tests based on  
execution feedback until it fails for the reasons described in the issue.  
To this end, the approach executes the generated test case. Each  
test case can result in one of three outcomes: pass, fail, or error. For  
test cases that pass,Issue2Testqueries the LLM to modify the test  
behavior so that it appropriately fails in response to the described

\`\`\`  
issue. For test cases ending in failure or an error,Issue2Testfirst  
determines whether the failure is related to the reported issue; if  
not, the LLM is prompted to refine the assertion. Conversely, if the  
failure is relevant (either a test assertion or a runtime error), the  
test case is added to the set of candidate tests. Finally,Issue2Test  
ranks all candidate tests based on their relevance and outputs a  
single test case.  
\`\`\`  
\#\# 2.3 Phase 1: Issue Comprehension

\`\`\`  
The goal of this phase is to collect contextual and informative  
ingredients to construct the test generation prompt used in the  
subsequent phase.  
Root Cause Analysis. A typical first step, in creating tests for  
an issue, is to analyze its description and extract possible causes.  
This simple analysis allows to have an initial hypothesis about  
the reasons behind the issue and get a first idea on what behvaior  
should be reproduced and how. Capitalizing on this simple princi-  
ple,Issue2Testsystematically identifies root causes by prompting  
an LLM to do the root cause analysis. As shown in Figure 4, we  
prompt the LLM to suggest different possible sets of reasons that  
could be behind the issue. As one issue might have multiple plau-  
sible reasons, the LLM is also asked to suggest sets of mutually  
exclusive causes where validating one negates another. For exam-  
ple, an issue may arise from an incorrect API call or an outdated  
dependency—distinct causes requiring separate resolutions. In Fig-  
ure 5, we show the resulting analysis for Django-12284. The third  
cause suspected by the LLM is the correct one and the one that  
led into generating a succesful reproduction of the issue shown in  
Figure 2\. In our approach, each cause is used in a different test gener-  
ation prompt later on. That is, in our running example,Issue2Test  
would construct three independent test generation prompts, each  
assuming one of the three causes.  
Project-Specific Guideline Generation. The automated test gen-  
eration problem requires knowledge of the target project’s testing  
frameworks, conventions, and dependency structures. A general  
approach is insufficient and cannot cover all cases, as different  
projects impose distinct constraints even compared to their own  
different versions. For instance, Django requires specific fixture  
configurations for test execution. Ideally, developers writing unit  
tests are familiar with a project’s structure and setup, allowing them  
to adhere to established conventions. However, manually crafting  
repository-specific test guidelines for each project is impractical  
due to the time and effort required.  
Inspired by ExecutionAgent \[ 8 \], we employ the principle of  
meta-prompting which enables the LLM to dynamically retrieve  
structured guidelines tailored to the repository before generation.  
Meta-prompting serves as an adaptive knowledge retrieval mecha-  
nism, leveraging the LLM’s pre-trained knowledge to synthesize  
project-specific testing conventions without relying on predefined  
templates. For instance, we send a query to the LLM, incorporat-  
ing the repository name, version, and issue description alongside  
instructions to generate concise guidelines for writing executable  
unit tests. The LLM’s response is then used in further prompts to  
provide project-specific context for the test generation task.  
Figure 6 illustrates a meta-prompt example for Django-12284,  
whereIssue2Testqueries the LLM to derive testing guidelines  
\`\`\`

Conference’17, July 2017, Washington, DC, USA Noor Nashid, Islem Bouzenia, Michael Pradel, and Ali Mesbah

\`\`\`  
Root cause  
analysis  
\`\`\`  
\`\`\`  
Meta  
Prompting  
\`\`\`  
\`\`\`  
Related  
files  
search  
\`\`\`  
\`\`\`  
Issue  
description  
\`\`\`  
\`\`\`  
Code base  
\`\`\`  
\`\`\`  
Issue cause  
hypothesis  
\`\`\`  
\`\`\`  
Testing  
guidelines Relevant files^  
\`\`\`  
\#\#\# Test

\#\#\# Generator

\`\`\`  
Generated tests  
\`\`\`  
\`\`\`  
Found problems  
\`\`\`  
\`\`\`  
Pass Fail Error  
\`\`\`  
\`\`\`  
Feedback: Change assertion /  
fix error \+ runtime information  
\`\`\`  
\`\`\`  
Error  
categorization  
\`\`\`  
\`\`\`  
Linter approved  
tests  
\`\`\`  
\`\`\`  
Tests outcomes  
\`\`\`  
\`\`\`  
Error or failure not  
caused by the  
issue  
\`\`\`  
\`\`\`  
Feedback: Rewrite test so it fails  
\+ runtime information  
\`\`\`  
\`\`\`  
Failure/error  
caused by  
the issue  
\`\`\`  
\`\`\`  
Failing tests  
\`\`\`  
\#\#\# Run tests

Best tests (^) Rank

\#\#\# ⭐

\`\`\`  
Marks steps where an LLM is used  
\`\`\`  
\#\#\# Linter

\`\`\`  
Assertion  
match  
\`\`\`  
\#\#\# Test refiner /

\#\#\# Error fixing

\`\`\`  
Refined/fixed  
tests  
\`\`\`  
\`\`\`  
Figure 3: Approach overview  
\`\`\`  
\`\`\`  
Root Cause Analysis Prompt  
\`\`\`  
\`\`\`  
Task: Perform root cause analysis for the following GitHub  
issue: Cannot overrideget\_FOO\_display()in Django 2.2+  
Description ...(shortened for paper)  
\`\`\`  
\- Propose distinct sets of root causes that could explain the  
    issue.  
\- Integrate contextual information from the issue description.  
\- Identify mutually exclusive or independent failure scenarios.

\`\`\`  
Figure 4: Root cause analysis prompt for Django-12284.  
\`\`\`  
specific to the Django project and version. The prompt explicitly  
provides the GitHub issue description, along with the project name  
(Django) and version (2.2+), instructing the LLM to extract rele-  
vant testing conventions, such as required configurations, fixture  
setups, and execution constraints. LLMs have been trained on a vast  
number of open-source projects, allowing them to capture diverse  
project-specific practices and requirements, which can provide use-  
ful insights when working with similar repositories. However, the  
knowledge they utilize in their responses depends heavily on how  
the prompt is structured. Providing clear and detailed instructions  
in the prompt helps ensure more relevant and accurate outputs. By

\`\`\`  
Cause 1: Handling of Choices in Inherited Models  
... (shortened for the paper)  
Cause 2: Cache or Meta-Class Processing  
... (shortened for the paper)  
Cause 3: Implementation Bug in Django’s Display Method  
–\> Reason 1: There might be a bug within Django itself where the  
get\_FOO\_display() method does not account for inherited or  
overridden choices correctly, particularly when choices are  
altered at the child class level.  
–\> Reason 2: The method that resolves choices within Django  
might be erroneously falling back to a default or initial state  
rather than considering the dynamic changes made by child  
classes, leading to incorrect value displays.  
\`\`\`  
\`\`\`  
Figure 5: Root cause analysis result for Django-12284.  
\`\`\`  
\`\`\`  
integrating meta-prompting, we aim to eliminate the need for man-  
ually curated test-writing instructions while ensuring adherence to  
project conventions.  
Locating Related Files. Developers analyze the repository struc-  
ture, source code, and test files to identify those relevant to a re-  
ported issue. Similarly, we generate a structured repository rep-  
resentation that enables the LLM to infer relevant files. Instead  
of scanning the entire repository, we construct a hierarchical tree  
format that preserves directory relationships, test files, and source  
code listings. A recursive traversal extracts directory names and  
\`\`\`

\`\`\`  
Issue2Test: Generating Reproducing Test Cases from Issue Reports Conference’17, July 2017, Washington, DC, USA  
\`\`\`  
\`\`\`  
Guidelines Meta Prompt  
\`\`\`  
\`\`\`  
Issue:  
\[Excerpts from Django-12284, shortened for the paper\]  
Cannot override get\_FOO\_display() in Django 2.2+ ...  
Task: Provide structured guidelines for writing a self-contained  
and executable unit test for the issue above, which was reported  
in the project Django 2.2+.  
\`\`\`  
\`\`\`  
Figure 6: Generating project-specific test guidelines for  
Django-  
\`\`\`  
\`\`\`  
IssueID: django-  
Found files:  
\`\`\`  
1\. django/db/models/options.py  
2\. django/db/models/fields/\_\_init\_\_.py  
3\. django/db/models/fields/mixins.py  
4\. django/db/models/base.py  
5\. django/db/models/query.py

\`\`\`  
Figure 7: Example of retrieved related files for Django-12284.  
\`\`\`  
\`\`\`  
file paths while maintaining structural depth. This structured rep-  
resentation, provided alongside the reported issue, allows the LLM  
to rank the most relevant files. For the running example, the list of  
related files is shown in Figure 7\.  
\`\`\`  
\#\# 2.4 Phase 2: Test Generation

As shown in Figure 3, we use the information from the previous step  
to construct the test generation prompt. The goal of this prompt  
is to instruct the model to generate test cases that fail, so that the  
tests capture the behavior described by the issue. In Figure 8, we  
provide an example of a test generation prompt for Django-12284.  
Using the constructed prompt, the approach queries the LLM to  
generate a test script, extracts the Python code from the response,  
and writes it into a file.

\#\# 2.5 Phase 3: Test Refinement

\`\`\`  
The third phase is the core contribution ofIssue2Test, as it specif-  
ically aims at producing a test that fails, and that the failure is due  
to the reason described in the issue. To this end, the test code gener-  
ated in the previous step is executed within a Docker environment  
to validate its behavior. The generated test is placed into a new file  
in the project’s test suite and executed in an isolated container to  
prevent external dependencies from influencing the results. After  
test execution, logs are generated to capture the test output. These  
logs are then analyzed to verify the outcome of the test execution.  
Next,Issue2Testiteratively refines test cases to ensure they ac-  
curately capture the reported issue. It operates in a feedback-guided  
manner, where test execution outcomes influence subsequent steps.  
The process is structured around two main objectives: (i) generating  
an initial failing state before the issue is resolved and (ii) addressing  
failures unrelated to the reported issue. The high-level refinement  
process is shown in Algorithm 1\.  
\`\`\`  
\`\`\`  
Test Generation Prompt  
\`\`\`  
\`\`\`  
Task: Your task is to generate unit tests based on the provided  
GitHub issue description and source code. Each test case should  
be designed to fail initially, confirming the existence of a bug  
or unimplemented feature.  
GitHub Issue: Cannot override get\_FOO\_display() in Django  
2.2+ Description ...(shortened for brevity)  
Guidelines: To create an independent, executable unit test in  
Django, dynamically configure settings and use an in-memory  
database for isolation. Configure Django Settings...(shortened)  
Root cause analysis: The Django model’s mechanism for  
resolving choices in an inherited class might not correctly  
override ...  
Related Source File:  
1 import collections.abc  
2 import copy  
3 ... (shortened for paper)  
4 def rel\_db\_type(self, connection):  
5 return SmallIntegerField().  
6 db\_type(connection=connection)  
\`\`\`  
\`\`\`  
Related Test File:  
1 ... (shortened for paper)  
2 class BasicFieldTests(SimpleTestCase):  
3 def test\_show\_hidden\_initial(self):  
4 ... (shortened for paper)  
5 self.assertChoicesEqual(  
6 field.get\_choices(include\_blank=False,  
limit\_choices\_to={}),\[self.bar1, self.bar  
\],)  
\`\`\`  
\`\`\`  
Expected Output: Self-contained Python test file.  
\`\`\`  
\`\`\`  
Figure 8: Test Generation Prompt for Django-  
\`\`\`  
\`\`\`  
Algorithm 1 begins by running the generated test (Line 4\) and  
analyzing the results. If a test failure occurs, error categorization  
(Line 6\) determines the failure type and whether a runtime error is  
directly related to the reported issue. If a runtime failure is due to the  
issue, the refinement process terminates successfully (Line 8). The  
corresponding prompt is shown in Figure 9, guiding this classifica-  
tion.  
Next, for assertion failures,Issue2Testchecks whether the fail-  
ure directly corresponds to the GitHub issue (Line 13). If the asser-  
tion failure is issue-related, the test is considered valid. Otherwise,  
the test is further refined to better align with the issue. If no failures  
occur or if the failure is unrelated to the issue, a refinement step  
is applied (Line 21). The refinement step aims at transforming the  
currently passing test into a failing test, e.g., by adjusting the asser-  
tions. The prompt for this transformation is shown in Figure 10 for  
Django-12284, whereIssue2Testinstructs the LLM to modify an  
initially passing test to ensure it fails due to the reported issue. If  
an assertion failure occurs but is unrelated to the issue,Issue2Test  
prompts the LLM to refine the assertion, ensuring that it directly  
captures the expected behavior associated with the reported defect.  
For compilation and runtime failures that are not directly related  
to the issue,Issue2Testapplies targeted fixes (Line 26). Specifically,  
\`\`\`

Conference’17, July 2017, Washington, DC, USA Noor Nashid, Islem Bouzenia, Michael Pradel, and Ali Mesbah

\`\`\`  
Error Categorization Prompt  
\`\`\`  
\`\`\`  
Task:  
Analyze the outcome of the below-failing test and classify it  
into one of the following:  
\`\`\`  
1\. Compilation Error: The test cannot be compiled.  
2\. Runtime Error: The test crashes during execution.  
3\. Assertion Failure: The test runs and fails due to an assertion.  
Also, tell whether the assertions or error is caused by the issue  
described below.  
GitHub Issue: Cannot overrideget\_FOO\_display() in  
Django 2.2+ Description ...(shortened for paper)  
Test Execution Output:  
FAIL: test\_get\_field\_foo\_display\_for\_C  
Traceback (most recent call last):  
File "/testbed/tests/model\_fields/test\_new.py",  
line 43, \*\*in\*\*  
test\_get\_field\_foo\_display\_for\_C self.  
assertEqual(instance.get\_field\_foo\_display  
(), 'output3')  
AssertionError: 'C' \!= 'output3'  
\- C  
\+ output

\`\`\`  
Expected Response:  
{  
"error\_type": "\<compilation, runtime, or  
↩→ assertion\>",  
"issue\_error\_relevance": \<true or false\>,  
"repair\_steps": "\<corrective actions\>"  
}  
\`\`\`  
\`\`\`  
Figure 9: Error categorization for Django-  
\`\`\`  
it searches the repository for missing imports and incorporates this  
information into the prompt to guide the LLM in refining the test  
case.  
In the final step, outside the feedback loop, the approach selects  
the best test case among all failing tests produced so far. The pre-  
vious three phases may produce multiple tests, e.g., by working  
under different hypotheses regarding the root cause of the problem.  
To select the best test, we prompt the LLM with the GitHub issue,  
asking it to rank the generated test cases and retain only those  
relevant to the issue.

\#\# 3 Evaluation

To assess the effectiveness ofIssue2Testwe address the following  
research questions:

\`\`\`  
RQ1What is the effectiveness ofIssue2Testin generating fail-to-  
pass tests, and how does it compare to the state-of-the-art?  
RQ2How do different components of the approach influence the  
test generation results?  
RQ3What are the token consumption and LLM invocation costs  
of Issue2Test?  
\`\`\`  
\`\`\`  
Test Modification Prompt(pass into fail)  
\`\`\`  
\`\`\`  
Task:  
The test case below passes even though the reported GitHub  
issue is unresolved. Modify the test case to ensure that it fails  
because of the issue below.  
GitHub Issue:  
Cannot overrideget\_FOO\_display()in Django 2.2+ Descrip-  
tion ...(shortened for paper)  
Passing Test:  
1 from django.conf import settings  
2 import django  
3 ... (shortened for paper)  
4 def test\_get\_field\_foo\_display\_for\_A(self):  
5 instance \= B(field\_foo='A')  
6 self.assertEqual(instance.  
get\_field\_foo\_display(), 'output1')  
\`\`\`  
\`\`\`  
Figure 10: Prompt used to transform a generated, passing  
test into a failing one.  
\`\`\`  
\#\# 3.1 Experimental Setup

\`\`\`  
3.1.1 Benchmark. We use the SWT-bench-lite benchmark, pro-  
posed recently by Mündler et al. \[ 30 \], as the benchmark for our  
evaluation. SWT-bench-lite is a curated subset of the SWT-bench  
dataset, designed to cost-efficiently evaluate the ability of language  
models to generate unit tests that reproduce real-world software  
issues. It consists of 276 instances derived from popular GitHub  
repositories, each containing a GitHub issue description, a corre-  
sponding issue-resolving patch, and a set of golden reference test  
cases that fail on the original version but pass after the issue has  
been resolved. Pull requests included in SWT-bench-lite meet the  
following criteria: (i) they are merged into the main branch, (ii)  
they explicitly link to a resolved GitHub issue, and (iii) they modify  
at least one test file.  
In addition to the full SWT-bench-lite dataset (called all issues),  
we also report results on those 90 instances from SWT-bench-lite  
that are part of SWE-bench Verified \[ 12 \] (called verified issues).  
SWE-bench Verified \[ 12 \] is a human-validated subset of the original  
SWE-bench \[ 22 \]. The validation process for SWE-bench Verified,  
conducted by OpenAI, involved expert annotation to ensure that  
each GitHub issue is solvable, clear, and linked to a valid bug-fixing  
patch. Each instance was manually reviewed to confirm that the  
issue description provides sufficient context and that the patch and  
test cases accurately capture the issue and its resolution.  
\`\`\`  
\`\`\`  
3.1.2 LLM EmpoweringIssue2Test. For all our experiments, we  
employ GPT-4o-mini (version 2024-07-18), a cost-efficient propri-  
etary model from OpenAI, as our primary model for evaluation.  
GPT-4o-mini is smaller than GPT-4o but faster, offering a 128K  
context window. At the time of writing the paper, the used model  
costs $0.15 per million input tokens and $0.60 per million output  
tokens.  
\`\`\`

\`\`\`  
Issue2Test: Generating Reproducing Test Cases from Issue Reports Conference’17, July 2017, Washington, DC, USA  
\`\`\`  
\`\`\`  
Algorithm 1: Execution-Driven Test Refinement  
Input: Test case𝑇 0 , GitHub issue𝐺 , Source Code 𝑆  
Output: Refined failing test case𝑇∗or failure  
1 𝑇 ←𝑇 0 ,𝑖𝑡𝑒𝑟 ← 0 ,𝑚𝑎𝑥𝐼𝑡𝑒𝑟𝑎𝑡𝑖𝑜𝑛𝑠 ← 20  
2 while𝑖𝑡𝑒𝑟\< 𝑚𝑎𝑥𝐼𝑡𝑒𝑟𝑎𝑡𝑖𝑜𝑛𝑠 do  
3 𝑡𝑒𝑠𝑡𝑅𝑒𝑠𝑢𝑙𝑡𝑠 ← RunTestAndCaptureErrors(𝑇)  
4 𝑝𝑎𝑠𝑠𝑖𝑛𝑔𝑇𝑒𝑠𝑡𝑠, 𝑓𝑎𝑖𝑙𝑖𝑛𝑔𝑇𝑒𝑠𝑡𝑠 ← AnalyzeTestResults(𝑡𝑒𝑠𝑡𝑅𝑒𝑠𝑢𝑙𝑡𝑠)  
5 // Step 1: Categorize Failure and Identify  
Runtime Relevance  
6 (𝑓𝑎𝑖𝑙𝑢𝑟𝑒𝑇𝑦𝑝𝑒,𝑖𝑠𝑅𝑢𝑛𝑡𝑖𝑚𝑒𝐹𝑎𝑖𝑙𝑢𝑟𝑒𝑅𝑒𝑙𝑎𝑡𝑒𝑑) ←  
error\_categorization(𝑓𝑎𝑖𝑙𝑖𝑛𝑔𝑇𝑒𝑠𝑡𝑠,𝐺)  
7 // Step 2: Stop If Runtime Failure is  
Issue-Related  
8 if 𝑖𝑠𝑅𝑢𝑛𝑡𝑖𝑚𝑒𝐹𝑎𝑖𝑙𝑢𝑟𝑒𝑅𝑒𝑙𝑎𝑡𝑒𝑑 then  
9 return𝑇 // Runtime failure correctly captures  
issue  
10 end  
11 // Step 3: Handle Assertion Failures  
12 𝑖𝑠𝐴𝑠𝑠𝑒𝑟𝑡𝑖𝑜𝑛𝐹𝑎𝑖𝑙𝑢𝑟𝑒𝑅𝑒𝑙𝑎𝑡𝑒𝑑 ← false  
13 if 𝑓𝑎𝑖𝑙𝑢𝑟𝑒𝑇𝑦𝑝𝑒= assertion then  
14 𝑖𝑠𝐴𝑠𝑠𝑒𝑟𝑡𝑖𝑜𝑛𝐹𝑎𝑖𝑙𝑢𝑟𝑒𝑅𝑒𝑙𝑎𝑡𝑒𝑑 ←  
assertion\_match(𝑓𝑎𝑖𝑙𝑖𝑛𝑔𝑇𝑒𝑠𝑡𝑠,𝐺)  
15 if 𝑖𝑠𝐴𝑠𝑠𝑒𝑟𝑡𝑖𝑜𝑛𝐹𝑎𝑖𝑙𝑢𝑟𝑒𝑅𝑒𝑙𝑎𝑡𝑒𝑑 then  
16 return𝑇 // Assertion failure correctly  
reflects issue  
17 end  
18 end  
19 // Step 4: Refine Test to Fail and Avoid  
Unrelated Assertion Failures  
20 if (𝑓𝑎𝑖𝑙𝑢𝑟𝑒𝑇𝑦𝑝𝑒= passing) or (not𝑖𝑠𝐴𝑠𝑠𝑒𝑟𝑡𝑖𝑜𝑛𝐹𝑎𝑖𝑙𝑢𝑟𝑒𝑅𝑒𝑙𝑎𝑡𝑒𝑑)  
then  
21 𝑇 ← test\_refinement(𝑇,𝐺)  
22 𝑖𝑡𝑒𝑟 ← 𝑖𝑡𝑒𝑟 \+ 1  
23 continue; // Retry with refined test  
24 end  
25 // Step 5: Handle Compilation or Runtime  
Failures (Only if no prior modification)  
26 if 𝑓𝑎𝑖𝑙𝑢𝑟𝑒𝑇𝑦𝑝𝑒= compilation or 𝑓𝑎𝑖𝑙𝑢𝑟𝑒𝑇𝑦𝑝𝑒= runtime then  
27 𝑇 ← runtime\_compilation\_fix(𝑇, 𝑓𝑎𝑖𝑙𝑖𝑛𝑔𝑇𝑒𝑠𝑡𝑠,𝐺,𝑆)  
28 end  
29 𝑖𝑡𝑒𝑟 ← 𝑖𝑡𝑒𝑟 \+ 1  
30 end  
31 return∅  
\`\`\`  
To assess the impact of different models, we further evaluate  
Issue2Testwith Meta Llama 3.3-70B (version meta.llama3-3-70b-  
instruct-v1:0 from AWS Bedrock) \[ 28 \], an open-source model, and  
Claude 3.5 Sonnet (version 20241022\) \[ 4 \], a leading proprietary  
model from Anthropic.  
3.1.3 Evaluation Metrics. To evaluate the effectiveness of gener-  
ated test cases, we use the fail-to-pass (F→P) rate, as used in prior  
work \[ 1 , 30 \]. Given one test generated per issue, the metric mea-  
sures the proportion of generated tests that are issue-reproducing  
and patch-validating, i.e., they initially fail on the pre-patch code  
and pass after the issue-resolving patch is applied. A high F→P  
rate indicates that the generated tests correctly reproduce the is-  
sue and validate its resolution, making it a crucial measure of test  
generation quality.

\`\`\`  
3.1.4 Baselines. To evaluateIssue2Test, we compare it against  
several baselines that represent different approaches to test genera-  
tion, following prior work by Mündler et al. \[ 30 \] and Auto-TDD \[ 1 \].  
Zero-Shot Prompting (ZeroShot) uses direct LLM prompting to  
generate test cases based on issue descriptions. Libro \[ 24 \] was the  
\`\`\`  
\`\`\`  
Table 1: Issue2Test results per project on SWT-bench-lite.  
\`\`\`  
\`\`\`  
Project Verified issues All issues  
Issues F→P F→P (%) Issues F→P F→P (%)  
django 42 8 19.05 113 18 15\.  
sympy 22 11 50.00 71 34 47\.  
scikit-learn 9 5 55.56 23 13 56\.  
matplotlib 7 2 28.57 23 7 30\.  
astropy 4 3 75.00 6 3 50\.  
sphinx-doc 3 0 0.00 11 0 0\.  
pydata 1 1 100.00 5 2 40\.  
pytest-dev 1 0 0.00 11 3 27\.  
pylint-dev 1 0 0.00 6 3 50\.  
pallets 0 0 0.00 2 0 0\.  
psf 0 0 0.00 1 1 100\.  
mwaskom 0 0 0.00 4 0 0\.  
Total/Avg 90 30 33.33 276 84 30\.  
\`\`\`  
\`\`\`  
first approach specifically designed for generating bug-reproducing  
test cases. Code agents SWE-Agent \[ 51 \] and AutoCodeRover \[ 52 \]  
were originally developed for issue solving, but were adapted for  
test generation using a prompt to create issue-reproducing unit  
tests \[ 30 \]. SWE-Agent+ \[ 30 \] extends SWE-Agent by executing the  
generated tests before finalizing them, improving issue-specific test  
generation. Finally, Auto-TDD \[ 1 \] is a recent approach focusing on  
test generation for GitHub issues similar to Issue2Test.  
To compareIssue2Testwith publicly available techniques, we  
include non-peer-reviewed entries from the SWT-Bench Lite leader-  
board^1. This results in the inclusion of two variants of OpenHands \[ 46 \],  
a generic-purpose coding agent. The first variant, OpenHands-  
Vanilla, uses the agent as released; the second variant, OpenHands-  
CI, augments the agent with a test-code-specific feedback extraction  
mechanism.  
\`\`\`  
\#\# 3.2 Effectiveness and Comparison (RQ1)

\`\`\`  
3.2.1 Issue2Test’s effectiveness. Table 1 presents the effectiveness  
ofIssue2Testin generating F→P test cases per project using GPT-  
4o-mini. The results are reported separately for verified issues  
and all issues in the SWT-bench-lite dataset. Across all projects,  
Issue2Testachieves an overall F→P rate of 30.4%, successfully gen-  
erating F→P tests for 84 out of 276 issues. On the verified subset,  
Issue2Test reproduces 30 out of 90 cases.  
The results vary across projects.Issue2Testperforms best on  
astropy, achieving 75.0% F→P rate on the verified issues and 50.0%  
overall, though this project has relatively few issues. Scikit-learn  
also shows strong performance, with 55.6% F→P rate on verified  
issues and 56.5% overall. Sympy maintains a rate close to 50% in  
both categories. In contrast,Issue2Testcannot generate any F→P  
test on the verified issues of sphinx-doc and pytest-dev, indicating  
challenges in generating effective test cases for these projects.  
3.2.2 Comparison with Baselines. Table 2 comparesIssue2Test  
against the baselines (Section 3.1.4) using the same 276 instances  
from SWT-bench-lite. Among the baselines, ZeroShot achieves  
the lowest F→P rate, being successful for only 5.8% of the issues.  
AutoCodeRover and Libro perform better, achieving 9.1% and 15.2%,  
\`\`\`  
(^1) https://swtbench.com

\`\`\`  
Conference’17, July 2017, Washington, DC, USA Noor Nashid, Islem Bouzenia, Michael Pradel, and Ali Mesbah  
\`\`\`  
\`\`\`  
Table 2: Comparing Issue2Test with baseline approaches.  
\`\`\`  
\`\`\`  
Approach F→P  
Total Rate  
ZeroShot 16 5.8%  
AutoCodeRover \[52\] 25 9.1%  
ZeroShotPlus 28 10.1%  
Libro \[24\] 42 15.2%  
SWE-Agent 46 16.7%  
SWE-Agent+ 53 19.2%  
Auto-TDD \[1\] 60 21.7%  
OpenHands-Vanilla (Claude 3-5 Sonnet) 63 22.8%  
OpenHands-CI (Claude 3-5 Sonnet) 78 28.3%  
Issue2Test (Llama 3.3) 49 17.8%  
Issue2Test (GPT-4o-mini) 84 30.4%  
Issue2Test (Claude 3-5 Sonnet) 91 32.9%  
\`\`\`  
respectively. ZeroShotPlus improves upon ZeroShot by leveraging  
a custom diff format designed to be more robust for LLM-generated  
patches. It is worth noting that while AutoCodeRover and SWE-  
Agent are primarily designed for resolving GitHub issues through  
prompt modification, they are still capable of generating a moderate  
number of patch-validating tests. SWE-Agent outperforms these  
techniques with a 16.7% F→P rate, further improving to 19.2%  
with SWE-Agent+, which incorporates execution-based filtering.  
The improvement in SWE-Agent+ comes from the incorporation  
of execution-based filtering, where generated tests are executed  
on the pre-patch code, and those that do not fail as expected are  
discarded. However, no explicit refinement is performed to correct  
failing tests that do not fully capture the reported issue, limiting  
its ability to handle assertion mismatches or refine test logic for  
more precise issue reproduction. Auto-TDD achieved the highest  
F→P rate among prior methods, generating F→P tests for 21.7%  
of issues.Issue2Testoutperforms Auto-TDD, achieving 30.4% and  
resolving 84 issues.  
OpenHands-Vanilla achieves 22.8% F→P rate, demonstrating  
that a general-purpose agent without project-specific setup can-  
not extract test execution feedback during test generation. In con-  
trast, OpenHands-CI is augmented with a continuous-integration  
pipeline: it installs all dependencies from the project manifest, in-  
jects the canonical test-suite invocation, and discards any diffs  
outside the existing tests/ directory. After each generated patch,  
the CI harness reruns the full suite and returns the failure trace.  
This structured feedback raises the F→P rate to 28.3 %, an im-  
provement over the vanilla configuration. These results suggest  
that generic-purpose agents require task-specific adaptation for  
effective automated test generation.  
Among the three LLMs employed inIssue2Test, Llama 3.3 yields  
the lowest F→P accuracy. GPT-4o-mini improves the accuracy to  
30.4% at $0.0521 per issue, offering the best cost–performance bal-  
ance.Issue2Testwith Claude 3.5 Sonnet attains the highest accu-  
racy—32.9%; however, it requires $0.66 per issue, a cost substantially  
higher than GPT-4o-mini. Unless otherwise stated, the remainder  
of this paper presents results obtained with the GPT-4o-mini con-  
figuration.

\`\`\`  
Figure 11: Venn diagram of F→P tests across approaches.  
\`\`\`  
\`\`\`  
Overall,Issue2Testdiffers from existing techniques by com-  
bining test validation with iterative refinement, resulting in more  
accurate and relevant reproducing tests. It analyzes whether fail-  
ures, such as compilation errors, runtime exceptions, or assertion  
mismatches, align with the issue description, rather than treat-  
ing any failure as sufficient. Diagnostic signals, including stack  
traces and assertion errors, are incorporated into a feedback loop  
that guides the LLM toward reproducing the issue. Furthermore,  
Issue2Testtailors test generation to project-specific conventions  
through meta-prompting, which is critical in frameworks where  
improper test scaffolding causes runtime errors, and it generates  
different test cases for mutually exclusive root-cause hypotheses,  
each reflecting a plausible explanation for the issue.  
Figure 11 presents a Venn diagram comparing the F→P tests  
generated byIssue2Testand four baseline techniques, including  
Libro, SWE-Agent+, Auto-TDD and OpenHands-CI. The diagram  
shows both unique and overlapping F→P tests among these meth-  
ods.Issue2Testgenerates 20 unique F→P tests not generated by  
any other approach. This indicates thatIssue2Testcan generate a  
significant number of tests that are not covered by existing methods.  
In contrast, Auto-TDD, SWE-Agent+, AutoCodeRover, and Libro  
each produce fewer unique test cases, ranging from 5 to 6\. Over-  
all, the results demonstrate thatIssue2Testnot only complements  
prior techniques, but also is the only technique to successfully  
handle a larger number of cases.  
\`\`\`  
\`\`\`  
3.2.3 Examples of Successful cases. Figure 12 presents a test case ex-  
clusively generated byIssue2Test. None of the baseline approaches  
are able to generate this F→P test case for the corresponding GitHub  
issue. Once the test is executed,Issue2Testprocesses the failure  
logs and applies the assertion check logic to assess whether this  
failure is expected given the issue. The output of this reasoning step  
is presented in Figure 13\. This shows that the success ofIssue2Test  
is its ability to analyze the assertion failure and correlate it with the  
issue description. By leveraging its assertion matching mechanism,  
\`\`\`

\`\`\`  
Issue2Test: Generating Reproducing Test Cases from Issue Reports Conference’17, July 2017, Washington, DC, USA  
\`\`\`  
1 \*\*import\*\* pytest  
2 \*\*from\*\* \_pytest.\_io.saferepr \*\*import\*\* saferepr  
3  
4 \*\*class\*\* SomeClass:  
5 \*\*def\*\* \_\_getattribute\_\_(self, attr):  
6 \*\*raise\*\* Exception("Attribute access failed")  
7  
8 \*\*def\*\* \_\_repr\_\_(self):  
9 \*\*raise\*\* Exception("Representation failed")  
10  
11 \*\*def\*\* test\_repr\_internal\_error\_handling():  
12 \*\*with\*\* pytest.raises(Exception, match="Attribute  
access failed"):  
13 SomeClass().attr  
14  
15 \*\*def\*\* test\_repr\_internal\_error\_in\_repr():  
16 obj \= SomeClass()  
17 \*\*with\*\* pytest.raises(Exception, match="  
Representation failed"):  
18 \*\*repr\*\* (obj)  
19  
20 \*\*def\*\* test\_repr\_internal\_error\_in\_repr\_handling():  
21 obj \= SomeClass()  
22 \*\*try\*\* :  
23 \*\*repr\*\* (obj)  
24 \*\*except\*\* Exception:  
25 \*\*pass\*\*  
26 \*\*with\*\* pytest.raises(Exception, match="  
Representation failed"):  
27 \*\*repr\*\* (obj)

\`\`\`  
Figure 12: Test case exclusively generated byIssue2Testfor  
pytest-7168.  
\`\`\`  
\`\`\`  
Direct Match: Yes  
Reason: The failure is expected due to the unimplemented  
feature in the GitHub issue, which describes an  
INTERNALERRORwhen an exception occurs in the\_\_repr\_\_  
method.  
The test case is designed to check the behavior of \_\_repr\_\_  
when an exception is raised in \_\_getattribute\_\_, which  
aligns with the issue.  
Figure 13: Assertion failure reasoning for pytest-7168.  
\`\`\`  
\`\`\`  
Issue2Testdetermines that the test failure aligns with the reported  
bug.  
The following examples illustrate the iterative refinement that  
Issue2Testuses to generate an F→P test case for django\_\_django-  
12284\. In this case, the initially generated test fails to compile. The  
error categorization step (Line 6 in Algorithm 1\) identifies it as a  
compilation failure and produces the output shown in Figure 14\.  
Then, the repair step (Line 26\) is invoked, as the failure does not  
match with Step 2, Step 3, or Step 4 of the algorithm. Once the  
revised test is generated in this step, it undergoes execution again  
(Line 4). Based on the test execution outcome, the test is then  
re-categorized. Finally, the assertion matching logic (Line 13\) deter-  
mines that the assertion failure corresponds to the reported issue  
(Figure 15).  
\`\`\`  
\`\`\`  
3.2.4 Example of Failure Cases. In the sphinx-doc project, 11 issue  
instances are analyzed, including 3 from SWE-verified. None of  
the baseline techniques, includingIssue2Test, can generate F→P  
tests for this project. Of these 11 cases, 5 fail due to runtime errors,  
while 1 encounter a test collection error caused by an incompatible  
\`\`\`  
\`\`\`  
Error category: Compilation Error  
Explanation: The test cannot be executed because the model  
class ’B’ is not properly configured within an application in  
INSTALLED\_APPS.  
Root cause: The model class ’B’ does not ...(shortened for  
paper)  
Repair steps:  
\`\`\`  
1\. Add an explicit app\_label to the class B in the Meta class.  
2\. Ensure that ’test\_app’ is correctly listed in the  
INSTALLED\_APPS configuration.

\`\`\`  
Figure 14: Compilation failure detection in the initially gen-  
erated test for django-  
\`\`\`  
\`\`\`  
Direct match: Yes  
Reason: The assertion failure occurs because the method  
get\_field\_foo\_display() does not return the expected  
output for the new choice ’C’, which is directly related to the bug  
described in the GitHub issue... (shortened)  
\`\`\`  
\`\`\`  
Figure 15: Assertion match after refinement step for django-  
12284  
\`\`\`  
\`\`\`  
Direct match: Yes  
Reason: The assertion failure is due to the missing  
implementation of the feature described in the GitHub issue,  
which states that napoleon\_use\_param should also affect  
the "Other parameters" section... (shortened)  
\`\`\`  
\`\`\`  
Figure 16: Assertion match reasoning for sphinx-8713.  
\`\`\`  
\`\`\`  
extension. For 2 instances (sphinx-doc\_\_sphinx-8801 and sphinx-  
doc\_\_sphinx-8506), we are unable to build the required Docker  
images. Interestingly, in 3 cases, assertion failures occurred both  
before and after the patch was applied, preventing a successful  
fail-to-pass transition. One such case is sphinx-doc\_\_sphinx-8713,  
where the generated test fails with an assertion error. Based on  
LLM prompting, this is treated as the terminating condition, as the  
test assertion is identified as relevant to the GitHub issue, as shown  
in Figure 16\.  
In the mwaskom project, there are 4 instances, with 1 successfully  
generating an F-\>P test using LIBRO, SWE-Agent+, SWE-Agent,  
and Auto-TDD. However,Issue2Testis unable to generate any  
F-\>P tests for this case. For mwaskom\_\_seaborn-3407, which is  
successfully reproduced by the baselines, the test generated by  
Issue2Testresulted in an assertion failure both before and after  
the patch. For the remaining 3 cases, we encounter runtime failures.  
\`\`\`  
\#\# 3.3 Influence of Different Components of

\#\# Issue2Test (RQ2)

\`\`\`  
To understand how different components of the approach con-  
tribute to the test generation, we analyze their role in producing  
successful and unsuccessful test cases. As shown in Figure 17, we  
examine four key components: assertion matching, error categoriza-  
tion, runtime and compilation error handling, and test refinement.  
\`\`\`

\`\`\`  
Conference’17, July 2017, Washington, DC, USA Noor Nashid, Islem Bouzenia, Michael Pradel, and Ali Mesbah  
\`\`\`  
\`\`\`  
Figure 17: Frequency of invoked steps (average per issue).  
\`\`\`  
Assertion matching exhibits the highest frequency in success-  
ful test cases relative to unsuccessful ones, indicating that when  
Issue2Testcorrectly identifies an issue-related assertion, it reliably  
generates a valid test. However, when the assertion does not align  
with the issue, additional refinement is required.  
Error categorization plays a crucial role in distinguishing rele-  
vant failures from unrelated ones. It is invoked on average 13.5 times  
per issue, suggesting that repeated classification of test outcomes  
is central to the refinement loop. Accurate failure classification  
contributes significantly to effective test generation.  
Runtime and compilation error handling presents a major chal-  
lenge. It is invoked an average of 20.9 times per unsuccessful issue.  
This suggests that resolving test cases that crash or fail to com-  
pile is a significant bottleneck, limiting the overall effectiveness of  
Issue2Test.  
Test refinement, designed to improve failing test cases, is in-  
voked least often (2.7 times on average for successful cases and 4\.  
for unsuccessful ones), suggesting that current refinement strate-  
gies may be less effective and could benefit from improved test  
transformation heuristics.  
These results indicate that failure categorization and assertion  
matching contribute positively to test generation, whereas run-  
time and compilation errors are the primary barriers to success.  
Enhancing failure resolution and refinement mechanisms could fur-  
ther improveIssue2Test’s ability to generate high-quality, issue-  
reproducing tests.

\#\# 3.4 RQ3: Cost

Figure 18 presents the distribution of input and output tokens used  
byIssue2Test. The median input token consumption is 303.46K,  
with a mean of 446.09K, whereas the median output token count  
is significantly lower at 7.92K, with a mean of 25.64K. This dis-  
parity arises becauseIssue2Testinvokes the LLM primarily for  
generating new test code, categorizing errors, and reasoning about  
failures, all of which require fewer response tokens. In contrast,  
input token consumption is higher due to the inclusion of GitHub  
issue descriptions, test case generation guidelines, and execution  
traces, which extend the context length.

\`\`\`  
Input Tokens (K)  
\`\`\`  
\`\`\`  
Md=303.  
\`\`\`  
\`\`\`  
29\.  
\`\`\`  
\`\`\`  
150\.  
\`\`\`  
\`\`\`  
548\.  
\`\`\`  
\`\`\`  
5888\.  
\`\`\`  
\`\`\`  
Mean=446.  
\`\`\`  
\`\`\`  
Response Tokens (K)  
\`\`\`  
\`\`\`  
Md=7.  
\`\`\`  
\`\`\`  
1\.  
\`\`\`  
\`\`\`  
4\.  
\`\`\`  
\`\`\`  
47\.  
\`\`\`  
\`\`\`  
144\.  
\`\`\`  
\`\`\`  
Mean=25.  
\`\`\`  
\`\`\`  
Figure 18: Comparison of input tokens and output tokens  
\`\`\`  
\`\`\`  
Total Cost (¢)  
\`\`\`  
\`\`\`  
Md=5.  
\`\`\`  
\`\`\`  
0.66 11.03 97  
\`\`\`  
\`\`\`  
Mean=8.  
\`\`\`  
\`\`\`  
Figure 19: LLM cost in cents (USD) per issue.  
\`\`\`  
\`\`\`  
The cost distribution is shown in Figure 19 in USD, visualized  
using a bean plot. The median cost per test case generated by  
Issue2Testis 5.21 cents, with an average cost of 8.23 cents. The  
total cost per test case ranges from 0.66 to 97 cents.  
Certain cases incur higher costs due to excessive LLM invo-  
cations. Specifically, in GitHub projects such as Django, when  
Issue2Testencounters a runtime error unrelated to the reported  
issue, it enters an iterative refinement loop, repeatedly invoking the  
LLM in an attempt to resolve the failure. This leads to substantially  
higher input token consumption.  
\`\`\`  
\#\# 4 Discussion

\`\`\`  
Quality of Generated Tests. Following studies on the quality of  
generated tests and their potential smells \[ 18 , 19 \], we manually  
inspect a sample of successfully generated tests to check for smells  
and quality issues. First, we randomly sample, up to three success-  
fully generated tests per project (some projects have fewer than  
three). This results in a total of 21 tests from 8 projects. Second, we  
manually go through the generated tests and their corresponding  
execution traces. For each generated test, we look for the categories  
of smells described in \[ 19 \], namely: (1) Act–Assert Mismatch, (2)  
Redundant Code, (3) Failed Setup, (4) Accessors and Constants.  
We only find instances of redundant code in the inspected sample.  
\`\`\`

\`\`\`  
Issue2Test: Generating Reproducing Test Cases from Issue Reports Conference’17, July 2017, Washington, DC, USA  
\`\`\`  
\`\`\`  
Specifically, 5/21 tests had a duplicate setup, i.e., two or more test  
functions instantiate the same variables with identical values and  
identical subsequent changes to the variables. Furthermore, 2/  
tests had a duplicate test scenario, i.e, the same test scenario is  
implemented in two different test cases. The percentage of these  
two effects is similar to the values reported in prior work \[ 19 \]. On  
the positive side,Issue2Testdoes not show any smell symptoms  
from the other three categories. One reason for the duplication may  
be that our prompt instructs the LLM to distribute different test  
scenarios and covered branches over different functions, to isolate  
points of failure. Future work could investigate how to guide LLMs  
toward tests that avoid duplication and other test smells.  
\`\`\`  
Reproduction Success by Issue Category. To assess whether  
Issue2Testdepends on the kind of issue addressed, we classified  
all 276 SWT-bench-lite instances according to the SWE-bench tax-  
onomy \[ 22 \]. The full set comprises 53 bug fixes (19.2%), 11 feature  
requests (4.0%), no regressions (0.0%), and 212 other issues (76.8 %),  
the latter dominated by maintenance-oriented tags such as “help  
wanted”. On the 84 issues for whichIssue2Testgenerated repro-  
ducing tests, the distribution is 17 bugs (20.2 %), 4 features (4.  
%), 0 regressions, and 63 Others (75.0 %). These correspond to per-  
category success rates of 32.1% for bugs (17/53), 36.4% for feature  
requests (4/11), and 29.7% for other issues (63/212). The maximum  
gap across category is 6.7%, indicating thatIssue2Testperforms  
consistently on bug fixes, feature requests, and maintenance tasks.  
Improving reproduction accuracy for maintenance-style (“Other”)  
issues may require incorporating richer contextual information,  
such as more detailed task descriptions, to guide the synthesis of  
targeted and precise test cases.

Threats to Validity. One potential threat to internal validity is the  
evaluation dataset size. We evaluateIssue2Teston SWT-bench-lite,  
which consists of 276 issues from the larger SWT-bench dataset.  
While this benchmark has been widely used in prior studies, it  
may not fully capture the diversity of issue types encountered in  
practice (e.g, some projects in SWT-bench-lite have less than 10  
issues). Another limitation ofIssue2Testis its reliance on meta-  
prompting, which is particularly beneficial for popular open-source  
projects. However, while this approach enhances test generation  
accuracy, it raises concerns aboutIssue2Test’s ability to generalize  
to private repositories or lesser-known projects where LLMs lack  
prior exposure.

\`\`\`  
Reproducibility. Our implementation and instructions for repro-  
ducing the results are available \[21\].  
\`\`\`  
\#\# 5 Related Work

Reproducible Test Case Generation. Reproducing software fail-  
ures from issue reports is essential for debugging \[ 6 \], regression  
testing \[ 24 \], and automated program repair \[ 31 , 35 \]. In Section 3.1.4,  
we discussed approaches for reproducible test case generation. Ad-  
ditionally, BRT Agent \[ 11 \] focused on generating tests from bug  
reports, specifically in an industrial setup. The reported success of  
BRT demonstrates that LLM-based test generation is beneficial not  
only for public issues but also for private internal issues at large  
companies such as Google.

\`\`\`  
Benchmarks for Evaluating Test Generation from GitHub  
Issues. Several benchmarks have been developed to evaluate the ef-  
fectiveness of automated test generation from GitHub issues. These  
benchmarks provide real-world issues, developer-written patches,  
and test cases, enabling systematic assessment of LLM-based test  
generation techniques. SWE-bench \[ 22 \] and its derivatives such  
SWTBench \[ 30 \], and TDD-Bench-Verified \[ 1 \] focus on GitHub is-  
sue resolution by pairing reported issues with their corresponding  
fixes and test cases. Other benchmarks, such as Defects4J \[ 23 \],  
BugsInPy \[ 48 \], and Bugswarm \[ 43 \] provide datasets for evaluat-  
ing software testing and program repair techniques. While not  
specifically tailored for test generation from GitHub issues, they  
are still taken from real fixed issues and provide some context for  
bug reproduction.  
LLM-Based Test Generation. LLMs have been applied to test gen-  
eration \[ 16 , 24 , 32 , 39 , 40 \], with efforts to enhance quality by over-  
coming coverage plateaus \[ 26 \], incorporating code-aware prompt-  
ing \[ 38 \], and leveraging coverage information \[ 3 , 20 \]. LLMs have  
also been explored for augmenting existing tests \[ 2 \] refines human-  
written test suites to improve coverage. Our work differs by focus-  
ing not on direct code generation but on synthesizing test cases  
specifically for reproducing issues raised on GitHub and revealing  
the buggy behavior related to the issue.  
LLMs for GitHub Issue Resolution. LLMs are increasingly be-  
ing leveraged to automate GitHub issue resolution by generating  
patches \[ 42 \]. Recent research has explored LLM-based agents that  
analyze issue reports, suggest code modifications, and improve soft-  
ware maintenance workflows. A key area of focus is automated  
program repair, where agents such as RepairAgent \[ 7 \] apply LLMs  
to detect and fix defects in source code. Other approaches, includ-  
ing SWE-Agent \[ 51 \], MarsCode Agent \[ 27 \], Magis \[ 42 \], and Au-  
toCodeRover \[ 52 \], tackle broader issue resolution tasks such as  
bug fixes, feature additions, and code enhancements. Our work,  
which automatically creates reproducing test cases for said issues,  
could help these approaches by: i) augmenting existing test suites  
and thus receiving more feedback about the behavior of code. ii)  
making the repair approaches more practical and realistic by using  
automatically generated test cases instead of developer-written  
tests, often, added after fixing the bug.  
Execution-Oriented Agents. ExecutionAgent \[ 8 \] andIssue2Test  
both use LLMs to automate software testing tasks but differ sig-  
nificantly in goals and techniques. ExecutionAgent focuses on au-  
tomating the setup and execution of existing test suites by inferring  
and running project-specific build, dependency, and test commands.  
It assumes tests already exist and prioritizes execution without  
human input. In contrast,Issue2Testgenerates new test cases to  
reproduce failures described in issue reports, operating under the  
assumption that no reproducing test exists. It takes issue descrip-  
tions and stack traces as input to synthesize failing test logic. This  
means, while ExecutionAgent focuses on command line actions  
such as installing dependencies,Issue2Test, in contrast, focuses  
on generating test code. Subsequently, meta-prompting in Execu-  
tionAgent helps infer commands and actions tied to the repository  
structure and languages whileIssue2Testuses it to reflect project-  
specific test idioms such as naming, fixtures, and assertions. Though  
the principle of meta-prompting is the same,Issue2Testadapts its  
\`\`\`

\`\`\`  
Conference’17, July 2017, Washington, DC, USA Noor Nashid, Islem Bouzenia, Michael Pradel, and Ali Mesbah  
\`\`\`  
own meta-prompting for the target task. Furthermore,Issue2Test  
uses a similarity-based approach to find relevant test and code files  
while ExecutionAgent just relies on prompting and meta-promting  
to find relevant files at the start.  
In addition, ExecutionAgent uses runtime feedback to fix com-  
mand execution errors (e.g., build failures), refining its inferred com-  
mands.Issue2Testuses runtime diagnostics such as stack traces  
and assertion errors to iteratively refine the generated tests. It also  
introduces root cause hypothesis branching to explore alternative  
failure explanations and generate diverse test cases. This failure  
reasoning and root cause analysis approach is absent in Execution-  
Agent.  
On a high-level, while both systems rely on LLMs and meta-  
prompting, they serve complementary purposes: ExecutionAgent  
automates test execution, whileIssue2Testenables semantic test  
synthesis from natural language and runtime signals.

\#\# 6 Conclusion

\`\`\`  
In this paper, we introduceIssue2Test, a novel approach for auto-  
mated generation of issue-reproducing test cases, addressing a key  
challenge in software testing and debugging. Our evaluation on  
the SWT-bench-lite dataset resulted inIssue2Testoutperforming  
the best baselines by an 8.7% margin in issue reproduction, success-  
fully generating test cases for 28 previously unreproduced issues,  
and contributing to 68.3% of the total issues reproduced across all  
tools. Beyond issue reproduction, our approach has broader impli-  
cations for automated debugging, regression testing, and program  
repair. By bridging the gap between issue descriptions and exe-  
cutable test cases,Issue2Teststreamlines the debugging process  
and facilitates more reliable automated program repair. Future work  
includes extending our methodology to support a wider range of  
failure scenarios, improving test adaptation strategies, and integrat-  
ing Issue2Test with existing automated repair pipelines to further  
enhance software reliability and maintainability.  
\`\`\`  
\#\# Acknowledgments

This work was supported in part by the Canadian Natural Sciences  
and Engineering Research Council (NSERC DG), Amazon Research  
Awards (AWS Generative AI), the European Research Council (ERC;  
grant agreements 851895 and 101155832), and the German Research  
Foundation (DFG; projects 492507603, 516334526, and 526259073).

\#\# References

\`\`\`  
\[1\]Toufique Ahmed, Martin Hirzel, Rangeet Pan, Avraham Shinnar, and Saurabh  
Sinha. 2024\. TDD-Bench Verified: Can LLMs Generate Tests for Issues Before  
They Get Resolved? arXiv preprint arXiv:2412.02883 (2024).  
\[2\]Nadia Alshahwan, Jubin Chheda, Anastasia Finogenova, Beliz Gokkaya, Mark  
Harman, Inna Harper, Alexandru Marginean, Shubho Sengupta, and Eddy Wang.  
\`\`\`  
2024\. Automated Unit Test Improvement using Large Language Models at Meta.  
In 32nd ACM International Conference on the Foundations of Software Engineering  
(FSE 2024). Association for Computing Machinery, 185–196.  
\[3\]Juan Altmayer Pizzorno and Emery D. Berger. 2025\. CoverUp: Effective High  
Coverage Test Generation for Python. Proc. ACM Softw. Eng. 2, FSE, Article  
FSE128 (2025), 23 pages.  
\[4\]Anthropic. 2025\. Claude. https://www.anthropic.com/claude/. Accessed: July 18,  
2025\.  
\[5\]Patrick Bareiß, Beatriz Souza, Marcelo d’Amorim, and Michael Pradel. 2022\. Code  
Generation Tools (Almost) for Free? A Study of Few-Shot, Pre-Trained Language  
Models on Code. CoRR abs/2206.01335 (2022). arXiv preprint arXiv:2206.01335 10  
(2022).

\`\`\`  
\[6\]Moritz Beller, Niels Spruit, Diomidis Spinellis, and Andy Zaidman. 2018\. On the  
dichotomy of debugging behavior among programmers. In 40th International Con-  
ference on Software Engineering (ICSE ’18). Association for Computing Machinery,  
572–583.  
\[7\]Islem Bouzenia, Premkumar Devanbu, and Michael Pradel. 2025\. RepairAgent:  
An Autonomous, LLM-Based Agent for Program Repair. In IEEE/ACM 47th  
International Conference on Software Engineering (ICSE). IEEE Computer Society,  
2188–2200.  
\[8\]Islem Bouzenia and Michael Pradel. 2024\. You name it, I run it: An LLM agent to  
execute tests of arbitrary projects. arXiv preprint arXiv:2412.10133 (2024).  
\[9\]Dong Chen, Shaoxin Lin, Muhan Zeng, Daoguang Zan, Jian-Gang Wang, Anton  
Cheshkov, Jun Sun, Hao Yu, Guoliang Dong, Artem Aliev, et al.2024. Coder:  
Issue resolving with multi-agent and task graphs. arXiv preprint arXiv:2406.  
(2024).  
\[10\]Yinghao Chen, Zehao Hu, Chen Zhi, Junxiao Han, Shuiguang Deng, and Jian-  
wei Yin. 2024\. ChatUniTest: A Framework for LLM-Based Test Generation. In  
32nd ACM International Conference on the Foundations of Software Engineering.  
Association for Computing Machinery, 572–576.  
\[11\]Runxiang Cheng, Michele Tufano, Jürgen Cito, José Cambronero, Pat Rondon,  
Renyao Wei, Aaron Sun, and Satish Chandra. 2025\. Agentic Bug Reproduction for  
Effective Automated Program Repair at Google. arXiv preprint arXiv:2502.  
(2025).  
\[12\]N. Chowdhury, J. Aung, C. J. Shern, O. Jaffe, D. Sherburn, G. Starace, E. Mays, R.  
Dias, M. Aljubeh, M. Glaese, C. E. Jimenez, J. Yang, K. Liu, and A. Madry. 2024\.  
Introducing SWE-bench Verified. OpenAI Blog (Aug. 2024). https://openai.com/  
index/introducing-swe-bench-verified/ \[Online\].  
\[13\]Ermira Daka, José Miguel Rojas, and Gordon Fraser. 2017\. Generating Unit Tests  
with Descriptive Names or: Would You Name Your Children Thing1 and Thing2?.  
In 26th ACM SIGSOFT International Symposium on Software Testing and Analysis.  
ACM, 57–67.  
\[14\]E. Dinella, G. Ryan, T. Mytkowicz, and S. K. Lahiri. 2022\. TOGA: A Neural  
Method for Test Oracle Generation. In 44th International Conference on Software  
Engineering (ICSE). IEEE, 2130–2141.  
\[15\]Zhiyu Fan, Xiang Gao, Martin Mirchev, Abhik Roychoudhury, and Shin Hwei  
Tan. 2023\. Automated Repair of Programs from Large Language Models. In 45th  
International Conference on Software Engineering. IEEE Press, 1469–1481.  
\[16\]Sidong Feng and Chunyang Chen. 2024\. Prompting Is All You Need: Automated  
Android Bug Replay with Large Language Models. In 46th IEEE/ACM International  
Conference on Software Engineering. 1–13.  
\[17\]Gordon Fraser and Andrea Arcuri. 2011\. EvoSuite: Automatic Test Suite Genera-  
tion for Object-Oriented Software. In 19th ACM SIGSOFT Symposium and the 13th  
European Conference on Foundations of Software Engineering. ACM, 416–419.  
\[18\]Geraldine Galindo-Gutierrez, Juan Pablo Sandoval Alcocer, Nicolas Jimenez-  
Fuentes, Alexandre Bergel, and Gordon Fraser. 2025\. Increasing the Effectiveness  
of Automatically Generated Tests by Improving Class Observability. In IEEE/ACM  
47th International Conference on Software Engineering (ICSE). IEEE, 1553–1565.  
\[19\]Geraldine Galindo-Gutierrez, Maximiliano Narea Carvajal, Alison Fernan-  
dez Blanco, Nicolas Anquetil, and Juan Pablo Sandoval Alcocer. 2023\. A manual  
categorization of new quality issues on automatically-generated tests. In IEEE In-  
ternational Conference on Software Maintenance and Evolution (ICSME). 271–281.  
\[20\]Sijia Gu, Noor Nashid, and Ali Mesbah. 2026\. LLM Test Generation via Iterative  
Hybrid Program Analysis. In 48th IEEE/ACM International Conference on Software  
Engineering. ACM, 12 pages.  
\[21\]Issue2Test. 2025\. Issue2Test: From Issue Reports to Reproducible Test Cases with  
LLMs. https://github.com/test-generation/issue2test. Accessed: March 4, 2025\.  
\[22\]Carlos E Jimenez, John Yang, Alexander Wettig, Shunyu Yao, Kexin Pei, Ofir Press,  
and Karthik R Narasimhan. 2024\. SWE-bench: Can Language Models Resolve  
Real-world Github Issues?. In The Twelfth International Conference on Learning  
Representations. https://openreview.net/forum?id=VTF8yNQM  
\[23\]René Just, Darioush Jalali, and Michael D. Ernst. 2014\. Defects4J: a database of  
existing faults to enable controlled testing studies for Java programs. In Interna-  
tional Symposium on Software Testing and Analysis. Association for Computing  
Machinery, 437–440.  
\[24\]Sungmin Kang, Juyeon Yoon, and Shin Yoo. 2023\. Large Language Models Are  
Few-Shot Testers: Exploring LLM-Based General Bug Reproduction. In 45th  
International Conference on Software Engineering. IEEE Press, 2312–2323.  
\[25\]Claire Le Goues, Michael Pradel, and Abhik Roychoudhury. 2019\. Automated  
program repair. Commun. ACM 62, 12 (2019), 56–65.  
\[26\]Caroline Lemieux, Jeevana Priya Inala, Shuvendu K. Lahiri, and Siddhartha Sen.  
\`\`\`  
2023\. CodaMosa: Escaping Coverage Plateaus in Test Generation with Pre-  
Trained Large Language Models. In 45th International Conference on Software  
Engineering. IEEE Press, 919–931.  
\[27\]Yizhou Liu, Pengfei Gao, Xinchen Wang, Jie Liu, Yexuan Shi, Zhao Zhang, and  
Chao Peng. 2024\. Marscode agent: Ai-native automated bug fixing. arXiv preprint  
arXiv:2409.00899 (2024).  
\[28\]Llama. 2025\. The open-source AI models you can fine-tune, distill and deploy  
anywhere. https://www.llama.com/. Accessed: July 18, 2025\.

\`\`\`  
Issue2Test: Generating Reproducing Test Cases from Issue Reports Conference’17, July 2017, Washington, DC, USA  
\`\`\`  
\[29\]Arghavan Moradi Dakhel, Vahid Majdinasab, Amin Nikanjam, Foutse Khomh,  
Michel C. Desmarais, and Zhen Ming (Jack) Jiang. 2023\. GitHub Copilot AI pair  
programmer: Asset or Liability? Journal of Systems and Software 203 (2023),  
111734\.  
\[30\]Niels Mündler, Mark Müller, Jingxuan He, and Martin Vechev. 2024\. SWT-Bench:  
Testing and Validating Real-World Bug-Fixes with Code Agents. Advances in  
Neural Information Processing Systems 37 (2024), 81857–81887.  
\[31\]Noor Nashid, Daniel Ding, Keheliya Gallaba, Ahmed E. Hassan, and Ali Mesbah.

2025\. Characterizing Multi-Hunk Patches: Divergence, Proximity, and LLM  
Repair Challenges. In 40th IEEE/ACM International Conference on Automated  
Software Engineering. IEEE, 13 pages.  
\[32\]Noor Nashid, Mifta Sintaha, and Ali Mesbah. 2023\. Retrieval-Based Prompt  
Selection for Code-Related Few-Shot Learning. In 45th International Conference  
on Software Engineering. IEEE Press, 2450–2462.  
\[33\]Carlos Pacheco, Shuvendu K. Lahiri, Michael D. Ernst, and Thomas Ball. 2007\.  
Feedback-Directed Random Test Generation. In International Conference on Soft-  
ware Engineering. IEEE Computer Society, 75–84.  
\[34\]Mauro Pezzè, Silvia Abrahão, Birgit Penzenstadler, Denys Poshyvanyk, Abhik  
Roychoudhury, and Tao Yue. 2025\. A 2030 Roadmap for Software Engineering.  
ACM Transactions on Software Engineering and Methodology 34, 5, Article 118  
(2025), 55 pages.  
\[35\]Pat Rondon, Renyao Wei, José Cambronero, Jürgen Cito, Aaron Sun, Siddhant  
Sanyam, Michele Tufano, and Satish Chandra. 2025\. Evaluating Agent-based  
Program Repair at Google. arXiv preprint arXiv:2501.07531 (2025).  
\[36\]Abhik Roychoudhury, Corina Pasareanu, Michael Pradel, and Baishakhi Ray.  
2025\. AI Software Engineer: Programming with Trust. arXiv e-prints (2025),  
arXiv–2502.  
\[37\]Haifeng Ruan, Yuntong Zhang, and Abhik Roychoudhury. 2025\. SpecRover:  
Code Intent Extraction via LLMs. In 47th International Conference on Software  
Engineering (ICSE). IEEE Computer Society, 963–974.  
\[38\]Gabriel Ryan, Siddhartha Jain, Mingyue Shang, Shiqi Wang, Xiaofei Ma, Mu-  
rali Krishna Ramanathan, and Baishakhi Ray. 2024\. Code-Aware Prompting: A  
Study of Coverage-Guided Test Generation in Regression Setting using LLM.  
Proc. ACM Softw. Eng. 1, FSE, Article 43 (2024), 21 pages.  
\[39\]Max Schäfer, Sarah Nadi, Aryaz Eghbali, and Frank Tip. 2023\. Adaptive test  
generation using a large language model. arXiv preprint arXiv:2302.06527 (2023).  
\[40\]Max Schäfer, Sarah Nadi, Aryaz Eghbali, and Frank Tip. 2023\. An empirical  
evaluation of using large language models for automated unit test generation.  
IEEE Transactions on Software Engineering 50, 1 (2023), 85–105.  
\[41\]Mohammed Latif Siddiq, Joanna Santos, Ridwanul Hasan Tanvir, Noshin Ulfat,  
Fahmid Al Rifat, and Vinicius Carvalho Lopes. 2023\. Exploring the Effectiveness of  
Large Language Models in Generating Unit Tests. arXiv preprint arXiv:2305.  
(2023).  
\[42\]Wei Tao, Yucheng Zhou, Yanlin Wang, Wenqiang Zhang, Hongyu Zhang, and Yu  
Cheng. 2025\. Magis: Llm-based multi-agent framework for github issue resolution.  
Advances in Neural Information Processing Systems 37 (2025), 51963–51993.  
\[43\]David A. Tomassi, Naji Dmeiri, Yichen Wang, Antara Bhowmick, Yen-Chuan  
Liu, Premkumar T. Devanbu, Bogdan Vasilescu, and Cindy Rubio-González. 2019\.  
BugSwarm: mining and continuously growing a dataset of reproducible failures  
and fixes. In 41st International Conference on Software Engineering (ICSE ’19). IEEE  
Press, 339–349.  
\[44\]Priyan Vaithilingam, Tianyi Zhang, and Elena L. Glassman. 2022\. Expectation vs.  
Experience: Evaluating the Usability of Code Generation Tools Powered by Large  
Language Models. In Extended Abstracts of the 2022 CHI Conference on Human  
Factors in Computing Systems. ACM, Article 332, 7 pages.  
\[45\]Junjie Wang, Yuchao Huang, Chunyang Chen, Zhe Liu, Song Wang, and Qing  
Wang. 2024\. Software Testing With Large Language Models: Survey, Landscape,  
and Vision. IEEE Transactions on Software Engineering 50, 4 (2024), 911–936.  
\[46\]Xingyao Wang, Boxuan Li, Yufan Song, Frank F. Xu, Xiangru Tang, Mingchen  
Zhuge, Jiayi Pan, Yueqi Song, Bowen Li, Jaskirat Singh, Hoang H. Tran, Fuqiang  
Li, Ren Ma, Mingzhang Zheng, Bill Qian, Yanjun Shao, Niklas Muennighoff,  
Yizhe Zhang, Binyuan Hui, Junyang Lin, Robert Brennan, Hao Peng, Heng Ji,  
and Graham Neubig. 2025\. OpenHands: An Open Platform for AI Software  
Developers as Generalist Agents. In The Thirteenth International Conference on  
Learning Representations. https://openreview.net/forum?id=OJd3ayDDoF  
\[47\]Cody Watson, Michele Tufano, Kevin Moran, Gabriele Bavota, and Denys Poshy-  
vanyk. 2020\. On Learning Meaningful Assert Statements for Unit Test Cases. In  
42nd International Conference on Software Engineering. ACM, 1398–1409.  
\[48\]Ratnadira Widyasari, Sheng Qin Sim, Camellia Lok, Haodi Qi, Jack Phan, Qijin  
Tay, Constance Tan, Fiona Wee, Jodie Ethelda Tan, Yuheng Yieh, Brian Goh,  
Ferdian Thung, Hong Jin Kang, Thong Hoang, David Lo, and Eng Lieh Ouh.  
2020\. BugsInPy: a database of existing bugs in Python programs to enable  
controlled testing and debugging studies. In ACM Joint Meeting on European  
Software Engineering Conference and Symposium on the Foundations of Software  
Engineering. Association for Computing Machinery, 1556–1560.  
\[49\]Chunqiu Steven Xia, Yinlin Deng, Soren Dunn, and Lingming Zhang. 2025\. De-  
mystifying LLM-Based Software Engineering Agents. Proceedings of the ACM on  
Software Engineering 2, FSE, Article FSE037 (June 2025), 24 pages.

\`\`\`  
\[50\]Chunqiu Steven Xia and Lingming Zhang. 2022\. Less training, more repairing  
please: revisiting automated program repair via zero-shot learning. In 30th ACM  
Joint European Software Engineering Conference and Symposium on the Founda-  
tions of Software Engineering. Association for Computing Machinery, 959–971.  
\[51\]John Yang, Carlos E Jimenez, Alexander Wettig, Kilian Lieret, Shunyu Yao,  
Karthik R Narasimhan, and Ofir Press. 2024\. SWE-agent: Agent-Computer In-  
terfaces Enable Automated Software Engineering. In The Thirty-eighth Annual  
Conference on Neural Information Processing Systems.  
\[52\]Yuntong Zhang, Haifeng Ruan, Zhiyu Fan, and Abhik Roychoudhury. 2024\. Au-  
toCodeRover: Autonomous Program Improvement. In 33rd ACM SIGSOFT Inter-  
national Symposium on Software Testing and Analysis. Association for Computing  
Machinery, 1592–1604.  
\[53\]Albert Ziegler, Eirini Kalliamvakou, X. Alice Li, Andrew Rice, Devon Rifkin,  
Shawn Simister, Ganesh Sittampalam, and Edward Aftandilian. 2022\. Productivity  
Assessment of Neural Code Completion. In 6th ACM SIGPLAN International  
Symposium on Machine Programming. ACM, 21–29.  
\`\`\`


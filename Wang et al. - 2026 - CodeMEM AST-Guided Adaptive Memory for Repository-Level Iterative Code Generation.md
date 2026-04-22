\#\# CODEMEM: AST-Guided Adaptive Memory for Repository-Level Iterative

\#\# Code Generation

\#\# Peiding Wang^1 , Li Zhang^1 , Fang Liu\*^1 , Chongyang Tao^1 , Yinghao Zhu^2

(^1) School of Computer Science and Engineering, Beihang University  
(^2) School of Computing and Data Science, The University of Hong Kong

\#\# {wangpeiding, fangliu}@buaa.edu.cn

\#\# Abstract

\`\`\`  
Large language models (LLMs) substantially  
enhance developer productivity in repository-  
level code generation through interactive col-  
laboration. However, as interactions progress,  
repository context must be continuously pre-  
served and updated to integrate newly vali-  
dated information. Meanwhile, the expand-  
ing session history increases cognitive bur-  
den, often leading to forgetting and the rein-  
troduction of previously resolved errors. Ex-  
isting memory management approaches show  
promise but remain limited by natural language-  
centric representations. To overcome these  
limitations, we propose CODEMEM, an AST-  
guided dynamic memory management system  
tailored for repository-level iterative code gen-  
eration. Specifically, CODEMEM introduces  
the Code Context Memory component that dy-  
namically maintains and updates repository  
context through AST-guided LLM operations,  
along with the Code Session Memory that con-  
structs a code-centric representation of interac-  
tion history and explicitly detects and mitigates  
forgetting through AST-based analysis. Ex-  
perimental results on the instruction-following  
benchmark CodeIF-Bench and the code gener-  
ation benchmark CoderEval demonstrate that  
CODEMEM achieves state-of-the-art perfor-  
mance, improving instruction following by  
12.2% for the current turn and 11.5% for the  
session level, and reducing interaction rounds  
by 2–3, while maintaining competitive infer-  
ence latency and token efficiency^1.  
\`\`\`  
\#\# 1 Introduction

\`\`\`  
In recent years, Large Language Models  
(LLMs) (Zhu et al., 2024; Hui et al., 2024\) in code  
generation has substantially improved develop-  
ers’ productivity, especially in repository-level  
code generation tasks, where awareness of rich  
\*Corresponding author.  
\`\`\`  
(^1) The code and data are available athttps://github.com/  
zhu-zhu-ding/CodeMem  
\*\*Instruction\*\* called 'set\_status \*\*- 1:\*\* Please write a python function '. This function sets the job  
status in Hadoop streaming by printing ... \*\*Context:\*\*  
class MRJob(object):...  
\*\*Instruction\*\* function is fully documented with parameter \*\*- 6:\*\* Ensure that the 'set\_status'  
and return type annotations, ...  
\*\*Answer\*\* def set\_status \*\*- 1:\*\* Here's the \`(self, msg):set\_status\` function:  
... \*\*status\_message=  
f"reporter:status:{msg}\\n".encode("utf-8")\*\*  
......  
\*\*Answer\*\* the MRJob \*\*- 6:\*\* Here's the \`class: set\_status\` function for  
def set\_status... (self, msg: str) \-\> None:  
\*\*self.stderr.write(f"reporter:status:{msg}\\n")  
Instruction\*\* called 'setmaxsize'. Set the maximum size for \*\*- 1:\*\* Please write a python function  
receiving netstrings in the \*\*Context: NetstringSocket\*\* ...  
\*\*class BufferedSocket\*\* ; def make\_sentinel...  
\*\*Answer\*\* def setmaxsize(self, maxsize): \*\*- 1:\*\* Here's the \`'setmaxsize'\` function:  
\*\*\#\#\#Reference code in the\*\* self.maxsize \= maxsize \*\*BufferedSocket class\*\*  
......  
\*\*Instruction\*\* regenerate. \*\*- 2:\*\* Your answer is incorrect. Please  
\*\*Answer\*\* def setmaxsize(self, maxsize): \*\*- 2:\*\* Here's the \`'setmaxsize'\` function:  
\*\*\#\#\#Reference code in the\*\* self.maxsize \= maxsize \*\*BufferedSocket class  
Session end...  
Golden Contexts  
Not Update Relevant Contexts.\*\*  
Figure 1: Examples of failure cases in iterative code  
generation. Left: As interactions progress, the LLM ex-  
hibits forgetting and overwrites previously correct mod-  
ifications. Right: Static context handling propagates  
erroneous information and prevents the incorporation of  
relevant contexts, resulting in repeated incorrect code.  
intra-repository context is essential (Wang et al.,  
2025b; Li et al., 2025a). However, real-world  
development workflows commonly involve multi-  
turn interactions, such as refining requirements  
or requesting fixes for erroneous code (Wang  
et al., 2025a; Zhan et al., 2025). We refer to this  
as repository-level iterative code generation.  
As illustrated in Figure 1, the code context in  
such scenarios is inherently dynamic. Satisfying  
evolving session instructions requires selectively  
preserving critical historical code context while  
continuously integrating newly relevant repository  
information. As interactions span multiple rounds,  
increasingly long and complex session histories  
impose growing cognitive burdens on LLMs,  
leading to forgetting, overwriting, or contradicting  
previously correct code modifications (Laban et al.,  
2025; Bogomolov et al., 2024).  
Memory management systems (Zhong et al.,  
2023; Anonymous, 2025; Li et al., 2025b; Packer  
et al., 2024\) offer a promising direction for support-  
ing long-term interactions by augmenting LLMs  
with external memory. However, existing ap-  
proaches are primarily designed for natural lan-  
guage generation and rely on natural-language-  
centric memory representations. When applied to

\# arXiv:2601.02868v1 \[cs.SE\] 6 Jan 2026

repository-level iterative code generation, such rep-  
resentations often blur code structure and behavior,  
hindering the dynamic retention of effective his-  
torical code context and the integration of newly  
relevant repository information. Moreover, session  
memory based on LLM summaries or dialogue re-  
trieval fails to capture the evolving interaction state,  
leading to rigid behaviors where LLMs may forget  
prior corrections or repeatedly reintroduce resolved  
errors (Laban et al., 2025; Bai et al., 2024).  
To address these limitations, we propose CODE-  
MEM, a memory management mechanism specif-  
ically designed for repository-level iterative code  
generation. CODEMEM consists of two memory  
components:  
1\) Code Context Memory dynamically preserves  
effective historical code context while integrating  
newly relevant repository information to support  
evolving session instructions. CODEMEM uses an  
AST-guided selection mechanism to retain useful  
history and an LLM to decide when updates are  
needed. Upon updating, newly retrieved code is in-  
crementally merged with retained context, allowing  
the memory to remain effective with the session.  
2\) Code Session Memory addresses rigid behav-  
iors such as forgetting prior corrections or rein-  
troducing resolved errors. CODEMEM organizes  
memory around code-centric units and their it-  
erative modifications, augmented with feedback  
from later rounds. CODEMEM combines the latest  
memory with similar past cases to form a compact  
session-level representation, and detects potential  
forgetting via AST-based change analysis, mitigat-  
ing inconsistencies through LLM guidance.  
Experiments on instruction following benchmark  
CodeIF-Bench for iterative code generation and the  
extended multi-turn repository-level code genera-  
tion benchmark CoderEval demonstrate that CODE-  
MEM improves current-turn and session-level in-  
struction following by 12.2% and 11.5%, and can  
reduce interaction rounds about 2–3, significantly  
outperforming existing memory management and  
full context baselines. Moreover, CODEMEM has  
achieved highly competitive inference time and to-  
ken cost.  
The contributions are summarized as:

\- We propose CODEMEM, a memory management  
    system for repository-level iterative code genera-  
    tion that dynamically updates code context and  
    mitigates forgetting during interaction.  
\- We introduce an AST-guided code memory strat-

\`\`\`  
egy that preserves valid historical context and  
detects potential forgetting via code-change anal-  
ysis.  
\`\`\`  
\- We conduct extensive evaluations on iterative  
    code generation benchmarks, demonstrating  
    state-of-the-art performance with competitive in-  
    ference latency and token efficiency.

\#\# 2 Related Work

\`\`\`  
Repository-Level Code Generation. Code gener-  
ation has evolved from standalone function synthe-  
sis (Austin et al., 2021; Chen, 2021\) to repository-  
level settings (Yu et al., 2024; Li et al., 2024),  
where models exploit intra-repository context for  
coherent code generation. Prior work (Zhang et al.,  
2023; Wang et al., 2025b; Zhang et al., 2024\) has  
mainly focused on effective repository context re-  
trieval. Although effective, these methods largely  
target single-round interactions. Recent bench-  
marks such as CodeIF-Bench (Wang et al., 2025a)  
and SR-Eval (Zhan et al., 2025\) extend this setting  
to multi-round iterative scenarios, yet systematic  
approaches for improving LLM performance in  
such settings remain limited.  
Memory Systems for LLMs. Memory manage-  
ment has been proposed to support long-term inter-  
actions between LLMs and their environment (Xu  
et al., 2025; Chhikara et al., 2025; Anonymous,  
2025; Zhong et al., 2023). Representative systems  
include MemGPT (Packer et al., 2024), which em-  
ploys hierarchical memory, and MemoryOS (Li  
et al., 2025b), which introduces system-style multi-  
level storage and dynamic updates. However, these  
approaches are primarily designed for natural lan-  
guage dialogue. When applied to code generation,  
they often treat code as unstructured text, over-  
looking code structure, evolution, and code-centric  
interaction states, thereby limiting their ability to  
maintain consistency and stability in code changes.  
\`\`\`  
\#\# 3 Methodology

\`\`\`  
3.1 Task Definition  
In this section, we define the repository-level itera-  
tive code generation task. Given a code repository,  
an LLM incrementally generates and refines code  
through multi-turn interactions with the user. After  
each interaction round, the generated code is ex-  
ecuted against a test suite to evaluate compliance  
with the current instruction.  
\`\`\`

\`\`\`  
Selector  
\`\`\`  
\`\`\`  
LLM Update Decision  
Update  
\`\`\`  
\`\`\`  
Code Session Memory  
\`\`\`  
\`\`\`  
Prompt Code Code Diff  
\`\`\`  
\`\`\`  
Mem- 0  
Note  
def setmaxsize(self, maxsize): ......."API\_ext":\[" \_calc\_msgsize\_maxsize "\]  
Code Context Memory  
class def \_\_NetstringSocketinit\_\_(...): (object):  
def \_calc\_msgsize\_maxsize(...)  
class BufferedSocket(object):  
class Sentinel(object):  
\`\`\`  
\`\`\`  
Project Codebase  
class BufferedSocket(object):  
class NetstringSocket(object):  
class ......  
\`\`\`  
\`\`\`  
AST  
\`\`\`  
\`\`\`  
class "API\_int":\["NetstringSocket \_calc\_msgsize\_maxsize (object): ",..."\]  
"API\_ext":\["BufferedSocket",..."\]  
class BufferedSocket(object):"API\_int":\["RLock",..."\]  
"API\_ext":\["getrecvbuffer",..."\]  
......  
\`\`\`  
\`\`\`  
\\  
Preserved Context  
Filtered Context  
Last Session&\&Prompt  
Prompt Note  
Prompt Code Code Diff  
\`\`\`  
\`\`\`  
Mem- 1  
Note  
......  
\`\`\`  
\`\`\`  
NetstringSocket.setmaxsize  
\`\`\`  
\`\`\`  
Prompt Code Code Diff  
\`\`\`  
\`\`\`  
Mem-Latest  
Note  
\`\`\`  
\`\`\`  
Code Context Memory Process Code Session Memory Process  
\`\`\`  
\`\`\`  
LLM  
\`\`\`  
\`\`\`  
Session Memory Note Generation  
\`\`\`  
\`\`\`  
Mem- 0  
Mem-Latest  
\`\`\`  
\`\`\`  
Memory Blocks  
LLM  
\`\`\`  
\`\`\`  
Memory Conflict Detection  
Answer Mem- 1  
Add  
Delete  
\`\`\`  
\`\`\`  
Delete  
Detector Add  
\`\`\`  
\`\`\`  
Real-timeAction Sleep-time Action  
\`\`\`  
\`\`\`  
Generated Code  
\`\`\`  
Figure 2: The overall pipline of CODEMEM.  
Formally, given code repositoryR, user in-  
struction I, and LLM-generated answer A,  
we get the following interaction sequence:  
{R,I 1 ,A 1 ,I 2 ,A 2 ,...In,An}. At roundi, the cor-  
rectness ofAiis quantitatively assessed by execut-  
ing the associated test suite Ti.

\`\`\`  
3.2 Overview  
\`\`\`  
As shown in Figure 2, CODEMEM consists of two  
memory components: Code Context Memory for  
managing repository-level code context and Code  
Session Memory for managing session history. At  
the start of each session, CODEMEM uses the LLM  
to decide whether the code context requires updat-  
ing and applies updates when necessary. Upon ses-  
sion completion, the AST-based Selector retains  
effective code contexts. Meanwhile, CODEMEM  
constructs session memory by combining the latest  
memory blocks with linked blocks based on prompt  
similarity. After code generation, the AST-based  
Detector identifies and mitigates potential memory  
conflicts, such as forgetting.

\`\`\`  
3.3 Code Context Memory  
3.3.1 Code Context Memory Block  
In this section, we describe the construction of the  
code context memory block. Using an AST parser^2 ,  
CODEMEM decompose the repository into code  
blocksmcodewhich corresponds to either a func-  
tion or a class.  
Each block is represented as a key–value pair:  
\`\`\`  
\`\`\`  
mcode=  
\`\`\`  
\#\#\# (

\`\`\`  
{(sf),vf}, function  
{(sc,ac,fc),vc}, class  
\`\`\`  
\#\#\# (1)

wheresdenote the function or class signatures  
with comments,acdenotes class attributes,fcde-  
notes class function methods, andvstores the com-

(^2) https://docs.python.org/3/library/ast.html  
plete implementation. CODEMEM utilizes keys  
when subsequently managing code context mem-  
ory and employs values to generate responses. This  
lightweight and efficient design minimizes input  
context length, improving decision quality while re-  
ducing inference overhead for downstream LLMs.  
3.3.2 AST-based Memory Selector  
TheSelectoraims to preserve only effective his-  
torical contexts as memory. After roundt, the  
Selectorfirst extracts external APIs from the gen-  
erated code and collects internal and external APIs  
from memory entities. LetA(Ct)extdenote the set  
of external APIs for the generated codeCt, and let  
Mt={mi}be the code context memory, each as-  
sociated with its APIsA(mi)including both exter-  
nal and internal APIs. External APIs are methods  
that call others, while internal APIs can be called  
by others.  
TheSelectorretains theMtwhose APIs inter-  
sect with the Ct’s external APIs:  
Mˆt={mi∈Mt|A(mi)∩A(Ct)ext̸=∅} (2)  
This ensures interface-level validity while preserv-  
ing semantically related implementation patterns,  
enabling the LLM to effectively reuse relevant code  
structures in subsequent generation steps.  
3.3.3 Memory Processing  
At the beginning of round t, the LLM de-  
termines—using the prompt template in Fig-  
ure D—whether the current code context memory  
Mt− 1 (initialized as empty) should be updated,  
based onIincluding both historical and current in-  
structions. This decision is made using only the key  
representations{ki} extracted from the memory:  
D \= LLM(I,{ki})∈{ADD, KEEP} (3)

whereADDindicates that a memory update is re-  
quired andKEEPindicates that no update is neces-  
sary. IfD \= ADD, the relevant code blocksMrel  
retrieved from the source code contexts according  
to the instructions are merged with the existing  
memory; ifD \= KEEP, the memory remains un-  
changed. TheMtcan be denoted as:

\`\`\`  
Mt=  
\`\`\`  
\#\#\# (

\`\`\`  
Mt− 1 ∪Mrel, if D \= ADD  
Mt− 1 , if D \= KEEP  
\`\`\`  
\#\#\# (4)

\`\`\`  
After interaction roundt, theSelectoris applied  
to filter and preserve only valid context entities in  
Mtbased on codeCt, preventing redundant accu-  
mulation and improving generation stability and  
efficiency over long-term interactions.  
\`\`\`  
\`\`\`  
Mˆt= Selector(Mt,Ct) (5)  
\`\`\`  
\`\`\`  
3.4 Code Session Memory  
3.4.1 Session Memory Block  
\`\`\`  
We construct session memory blocks around  
code-centric units rather than natural language  
(Chhikara et al., 2025; Xu et al., 2025). Given  
a conversation, its memory block is represented as:

\`\`\`  
msession={I,C, ∆C,N} (6)  
\`\`\`  
whereIis the user prompt,Cis the generated func-  
tion code,∆Cis the code modification (diff) rela-  
tive to the last round by AST-based analysis, andN  
is the note describing the modification generated  
by the LLM with the subsequent prompt. Feed-  
back in the next round allows the LLM to generate  
more accurate notes, ensuring that unsatisfactory  
changes are properly corrected or correctness can  
be reused, thereby guiding subsequent edits. The  
block design also highlights the operational impact  
of prompts on code behavior and enables the LLM  
to track, reuse, and correct modifications in subse-  
quent rounds.  
In addition, iterative edits to the same function  
naturally link multiple memory blocks into a mem-  
ory sequence (mssession):

\`\`\`  
mssession={m 0 ,m 1 ,...,mlatest} (7)  
\`\`\`  
wherem 0 correspondings to the initial function and  
subsequent blocks ordered by modification history  
and mlatestcorrespondings to the latest memory.

\`\`\`  
3.4.2 AST-based Memory Detector  
TheDetectoraims to identify conflicts between  
newly generated code and historical session mem-  
ory. The key idea is that inconsistencies between  
new code and stored memory blocks indicate mem-  
ory conflicts and forgetting, exemplified by re-  
verted corrections or reintroduced constraints.  
First, instruction-level filtering is applied to ex-  
clude historical memory blocks corresponding to  
similar intents. LetItdenote the current instruc-  
tion and{Ii}i\<tdenote historical instructions. We  
select the candidate detection session memoryMc  
such that:  
Mc={mi| sim(It,Ii) \< τ} (8)  
wheresim(·)denotes an instruction similarity func-  
tion andτis the filtering threshold. This filtering  
avoids spurious conflicts arising from iterative re-  
finements or reversible changes under similar in-  
structions.  
Next, theDetectorextracts code changes∆t  
for current generated codeCtusing AST-level diffs,  
where∆t= (∆tadd, ∆tdel)denote the sets of added  
and deleted AST nodes. Let∆i= (∆iadd, ∆idel)  
denote the recorded code changes associated with  
the candidate detection memorymi∈ Mc. The  
Detectordetermines whether the session mem-  
ory blockmiis conflicted with theCtby checking  
whether the current changes contradict its historical  
changes:  
Conf (∆t, ∆i)≜  
\`\`\`  
\#\#\# 

\`\`\`  
∆tdel∩ ∆iadd ∪ ∆tadd∩ ∆idel  
\`\`\`  
\#\#\#

\#\#\# (9)

\`\`\`  
whereConf (∆t, ∆i)captures AST nodes whose  
contradictory add–delete operations indicate forget-  
ting or reversion of previously code changes.  
Accordingly, the set of potentially conflicting  
session memory blocks is defined as:  
Mˆc={mi∈Mc| Conf (∆t, ∆i)̸=∅} (10)  
3.4.3 Memory Processing  
At the end of roundt, the interaction is recorded as  
a session memory block. LetCtdenote the function  
code generated at roundt, and letMS \= {msi}  
denote the set of existing memory sequences.  
CODEMEM updates the session memory as:  
\`\`\`  
\#\#\# MS ←

\#\#\# (

\`\`\`  
MS∪{mt}, Ct/∈ MS  
msi⊕ mt, Ct∈ msi  
\`\`\`  
\#\#\# (11)

\`\`\`  
wheremtstores the AST-level code diff∆twith  
respect to the latest version, and⊕denotes ap-  
pending a block to an existing memory sequence.  
\`\`\`

Within each memory sequence, blocks are linked  
by instruction similarity:

\`\`\`  
Link(mt) \={mi| sim(It,Ii)≥ τ} (12)  
\`\`\`  
\`\`\`  
This allows the latest blockmtand its neighbors  
Link(mt)to serve as a compact yet information-  
rich representation.  
At the beginning of roundt, CODEMEM gen-  
erates a modification note frommt− 1 conditioned  
on the current instruction and constructs the Code  
Session Memory as:  
\`\`\`  
\`\`\`  
Mt={mt− 1 }∪ Link(mt− 1 ) (13)  
\`\`\`  
which is jointly used to guide code generation.  
After a candidate solutionCt+1is produced, the  
Detector identifies conflicting memory blocks:

\`\`\`  
Mc= Detector(It+1,Ct+1) (14)  
\`\`\`  
\`\`\`  
The final outputCˆt+1is determined as:  
\`\`\`  
\`\`\`  
Cˆt+1=  
\`\`\`  
\#\#\# (

\`\`\`  
LLM(Mt,Mc), ifMc̸=∅  
Ct+1, ifMc=∅  
\`\`\`  
\#\#\# (15)

whereLLM(Mt,Mc)represents that the LLM re-  
generates code based onMc.

\#\# 4 Experimental Setups

\`\`\`  
In this section, we conduct experiments to evaluate  
the effectiveness of CODEMEM. We aim to answer  
the following research questions:  
\`\`\`  
\- RQ1: Overall Performance. How does CODE-  
    MEM perform overall in iterative repository-  
    level code generation compared with baselines?  
\- RQ2: Ablation Study. How do the proposed  
    memory components impact the performance of  
    CODEMEM?  
\- RQ3: Efficiency and Cost Analysis. What are  
    the time efficiency and computational cost of  
    CODEMEM?  
\- RQ4: Further Analysis for AST Parts. The  
    explainability Analysis of AST Components for  
    CODEMEM.  
4.1 Benchmarks and Metrics  
Benchmarks. To evaluate CODEMEM’s effec-  
tiveness in repository-level iterative code gener-  
ation tasks, we selected the iterative code gen-  
eration instruction-following benchmark CodeIF-  
Bench (Wang et al., 2025a) and the repository-level

\`\`\`  
code generation benchmark CoderEval (Yu et al.,  
2024).  
For CodeIF-Bench, we selecte the L-  
repository-level programming task, encompassing  
40 dialogues with 360 instructions aligns with real-  
world development scenarios. Each dialogue cen-  
tres around a python code generation task, compris-  
ing 9 distinct and non-conflicting instructions that  
can be tested and validated. CodeIF-Bench is to  
evaluate the LLM’s ability to follow instructions  
during interactions: 1\) The ability to follow the  
user’s current instruction 2\) The ability to follow  
session-level instructions 3\) Errors arising from  
forgetting previously correct modifications during  
interaction (the phenomenon of forgetting).  
For CoderEval, it comprises 230 python  
repository-level code generation tasks collected  
from real-world projects. Following prior  
study (Wang et al., 2024), we extended CoderEval  
into multi-round iterative code generation tasks: we  
provide simple verbal feedback on code that fails  
testing to facilitate its re-generation. It simulates an  
iterative human–LLM interaction process in which  
a user repeatedly requests revisions to erroneous  
code, aiming to evaluate collaborative efficiency  
by measuring the number of user tasks completed  
within a fixed number of interaction rounds. Data  
examples are presented in the Appendix B.  
Metrics. We employ the following metrics (He  
et al., 2024; Wang et al., 2025a) to evaluate both  
the correctness of LLM generated code as well as  
the LLMs’ instruction following capability:  
\`\`\`  
\- IA(↑): The LLM’s ability to follow the cur-  
    rent instruction at each turn, measured by round-  
    specific tests.  
\- CA(↑): The LLM’s ability to satisfy all instruc-  
    tions issued so far, evaluated by cumulative tests.  
\- IFR(↓): The proportion of previously satisfied  
    instructions that fail in later turns, indicating for-  
    getting.  
\- Pass@k(↑): The probability that at least one of  
    kgenerated programs passes the tests in each  
    iteration.  
       For further details, please refer to Appendix A.

\`\`\`  
4.2 Baselines and Implementation Details  
We selected the following baselines: Full-Context  
(FC), which uses all conversation history as context,  
and state-of-the-art memory management methods  
\`\`\`

\`\`\`  
Method Turn-1 Turn-2 Turn-3 Turn-4 Turn-5 Turn-6 Turn-7 Turn-8 Turn-9 Avg.  
Instruction Accuracy (IA)  
FCBM25 37.5 40.0 52.5 45.0 27.5 60.0 37.5 35.0 35.0 41\.  
FCRL-Coder 35.0 37.5 50.0 37.5 35.0 60.0 47.5 35.0 27.5 40\.  
MemGPT 35.0 42.5 42.5 42.5 27.5 50.0 32.5 40.0 40.0 39\.  
Mem0 37.5 27.5 37.5 32.5 20.0 40.0 42.5 25.0 10.0 32\.  
A-Mem 37.5 42.5 45.0 47.5 27.5 50.0 30.0 47.5 42.5 41\.  
CODEMEM 40.0 50.0 57.5 50.0 32.5 40.0 47.5 50.0 47.5 46\.  
w/o CtxMem 40.0 47.5 57.5 47.5 27.5 50.0 32.5 37.5 42.5 42.5↓3.  
w/o CtxAST 40.0 42.5 47.5 47.5 30.0 50.0 37.5 40.0 40.0 41.7↓4.  
w/o SessAST 40.0 42.5 62.5 47.5 27.5 42.5 47.5 47.5 40.0 44.2↓1.  
Conversation Accuracy (CA)  
FCBM25 37.5 38.8 43.3 43.1 35.5 39.6 37.9 34.4 35.3 38\.  
FCtRL-Coder 35.0 33.8 36.7 36.9 34.5 36.2 37.5 38.8 36.7 36\.  
MemGPT 35.0 36.3 35.0 40.0 33.5 37.9 34.3 38.1 36.4 38\.  
Mem0 37.5 27.5 28.3 28.7 17.0 16.7 21.8 25.3 20.3 24\.  
A-Mem 37.5 41.3 40.8 43.8 26.0 38.8 37.1 36.6 38.9 37\.  
CODEMEM 40.0 47.5 48.3 46.3 37.0 37.9 41.1 43.1 44.4 42\.  
w/o CtxMem 40.0 45.0 50.8 46.9 30.5 34.6 37.1 33.8 37.5 39.6↓3.  
w/o CtxAST 40.0 42.5 41.7 39.4 36.5 36.3 37.7 37.2 37.4 38.7↓4.  
w/o SessAST 40.0 43.8 50.8 46.3 33.5 36.2 39.3 42.2 40.8 41.4↓1.  
Table 1: The overall performance of LLMs in CodeIF-Bench. The metrics are IA and CA.  
\`\`\`  
\`\`\`  
Method Turn-1 Turn-2 Turn-3 Turn-4 Turn-  
FCBM25 40.0 45.2 48.7 50.4 50\.  
FCtRL-Coder 37.7 40.1 40.1 41.4 41\.  
A-Mem 40.4 44.3 45.7 46.5 46\.  
Mem0 40.0 41.7 42.6 43.0 43\.  
MemGPT 33.0 42.2 46.5 48.7 49\.  
CODEMEM 42.2 49.6 51.7 54.3 55\.  
w/o CtxMem 42.2 47.8↓1.8 49.6↓2.1 50.0↓4.3 51.7↓4.  
w/o CtxAST 42.2 46.5↓3.1 50.0↓1.7 50.8↓3.5 51.3↓4.  
w/o SessAST \- \- \- \- \-  
Table 2: The overall performance of LLMs in  
CoderEval. The metric is Pass@1.  
\`\`\`  
MemGPT (Packer et al., 2024), Mem0 (Chhikara  
et al., 2025\) and A-Mem (Xu et al., 2025). We also  
compared the single-turn code generation SOTA  
method RL-Coder, whose multi-turn configuration  
is identical to FC. We defined it as FCtRL-Coder.  
The backbone model for all methods is DeepSeek-  
V3.2 with greedy decoding. All methods except  
FCtRL-Coderuse BM25 for code context retrieval.  
For memory retrieval and similarity, all memory-  
based methods—including CODEMEM—adopt  
the text-embedding-3-small vector retriever. The  
total number of documents for all retrieval settings  
is 5\. The similarity threshold for CODEMEM is  
0.95.

\#\# 5 Experimental Results

\`\`\`  
5.1 RQ1: Overall Performance  
Performance on CodeIF-Bench. Table 1 shows  
that CODEMEM consistently outperforms all base-  
lines. For the IA score, it achieves the best per-  
formance in all rounds except 5 and 6\. While  
\`\`\`  
\`\`\`  
memory management baselines such as MemGPT  
and A-Mem achieved results comparable to FC,  
their natural language–oriented memory represen-  
tation limits their effectiveness, making them in-  
ferior to CODEMEM. Our advantage comes from  
dynamic code context updates and efficient ses-  
sion memory with accurate modification notes, en-  
abling the LLM to better satisfy current instruc-  
tions. Rounds 5 and 6 focus primarily on non-  
functional requirements, such as reducing circle  
complexity, which remain challenging for LLMs.  
The slight performance drop in these rounds in-  
dicates that CODEMEM integrates prior instruc-  
tions effectively but struggles with complex non-  
functional constraints. For the CA metric, CODE-  
MEM outperforms all baselines except in round 6\.  
Notably, while nearly all baseline methods, such  
as A-Mem and MemGPT, exhibit performance  
degradation as the number of interaction rounds  
increases, such as round 6, 7 and 8, CODEMEM  
demonstrates sustained improvement over time.  
This is due to the Code Session Memory mech-  
anism that mitigates forgetting. Overall, these re-  
sults highlight the effectiveness of CODEMEM in  
iterative repository-level code generation.  
Performance on CoderEval. Table 2 presents  
results on the CoderEval benchmark. In the first  
round, performance differences largely stem from  
prompt design (Appendix D). In subsequent rounds,  
CODEMEM consistently outperforms all baselines  
due to dynamic code-context updating, which fil-  
\`\`\`

\`\`\`  
ters irrelevant code and integrates task-relevant  
context, and user-guided feedback, which gener-  
ate more accurate reflections notes. These mech-  
anisms reduce the number of interaction rounds  
needed to resolve bugs: for example, CODEMEM  
achieves the similar pass@1 score by round 3 that  
FC requires until round 5\. Baselines like MemGPT  
and A-Mem, which performed similarly to FC on  
CodeIF-Bench, show weaker performance here,  
highlighting their limited generalizability. These  
results further confirm CODEMEM’s effectiveness  
for iterative, repository-level code generation.  
\`\`\`  
\`\`\`  
RQ1 Summary: CODEMEM consistently out-  
performs all baselines on both instruction follow-  
ing and iterative generation. Compared to the  
FC, CODEMEM improves instruction following  
ability by 12.2% for IA and 11.5% for CA and  
can alse reduce interaction rounds by 2–3.  
\`\`\`  
5.2 RQ2: Ablation Study  
To evaluate the effectiveness of our AST-based  
memory components, we conduct an ablation study  
by systematically removing individual elements.  
Specifically, CtxMem denotes the full Code Con-  
text Memory, CtxAST the AST-based selector for  
Code Context Memory, and SessAST the AST-  
based detector for Code Session Memory.  
On CodeIF-Bench (Table 1), remov-  
ing CtxMem—treating code context as  
static—substantially reduces performance,  
highlighting the importance of actively managing  
context during iterative generation. Removing  
CtxAST causes even larger degradation, as the  
LLM alone cannot filter irrelevant code and timely  
updates, leading to noisy context that misguides  
decision-making. Similarly, omitting SessAST  
consistently degrades performance, particularly  
in later rounds (e.g., CA in round 9 drops from  
44.4% to 40.8%), due to increased forgetting of  
previously correctted changes.  
For CoderEval (Table 2), each session focuses on  
a single task and exhibits minimal forgetting; thus,  
SessAST ablations are unnecessary. Nevertheless,  
removing CtxMem or CtxAST still significantly  
impairs performance, whereas CODEMEM main-  
tains consistent gains by dynamically preserving  
relevant code context. These results underscore the  
critical role of our AST-guided memory manage-  
ment in iterative repository-level code generation.

\`\`\`  
Method CodeIF-Bench CoderEval  
Avg. \#Time Avg. \#Token Avg. \#Time Avg. \#Token  
FCBM25 34.3 131.8k 26.5 35.6k  
FCRLCoder 36.1 72.5k 19.9 19.5k  
A-Mem 47.4 358.5k 42.3 119.8k  
Mem0 67.0 70.0k 55.2 8.0k  
MemGPT 27.9 31.0k 38.5 61.3k  
CODEMEM 54.1 107.8k 34.2 52.6k  
w/o CtxMem 51.3 159.4k 30.2 40.3k  
w/o CtxAST 58.6 315.2k 33.1 80.2k  
w/o SessAST 36.4 75.1k – –  
Table 3: Average cost (in tokens) per data and comple-  
tion time (in seconds) per round across methods.  
\`\`\`  
\`\`\`  
RQ2 Summary: CtxMem greatly improves  
LLM performance by dynamically updating  
code context memory. Within CtxMem, CtxAST  
plays a crucial role by selectively preserving ef-  
fective code context memory, while SessAST  
further enhances performance by identifying and  
mitigating memory forgetting.  
\`\`\`  
\`\`\`  
5.3 RQ3: Efficiency and Cost Analysis  
We further analyze the inference-time efficiency  
and token cost of CODEMEM (Table 3). CODE-  
MEM achieves competitive efficiency while deliv-  
ering the best code generation quality. Baselines  
like A-Mem treat code context as natural language,  
incurring substantial inference overhead and higher  
token consumption. Mem0 compresses context to  
reduce tokens but requires many inference itera-  
tions, resulting in higher latency. MemGPT attains  
the lowest cost on CodeIF-Bench, yet its poor per-  
formance on CoderEval reflects unstable efficiency.  
FC with RL-Coder generally has lower time and  
cost than BM25 due to retrieval of shorter, finer-  
grained contexts.  
CODEMEM leverages key–value–based code  
context representation, reducing token usage by  
30k on CodeIF-Bench compared to multi-turn dia-  
logue methods. While slightly more costly than FC  
and Mem0 on CoderEval, it remains more efficient  
than other baselines. Ablation analysis shows that  
removing CtxMem slightly reduces inference time  
by eliminating LLM-controlled context manage-  
ment, but the key–value design adds only marginal  
overhead (2.8s per round on CodeIF-Bench, 4.0s on  
CoderEval) while substantially lowering token us-  
age despite a partial increase on CoderEval. Omit-  
ting CtxAST increases time and cost further, even  
doubles token consumption on CodeIF-Bench, in-  
dicating that unfiltered context negatively affects  
LLM decision-making to continually introducing  
more irrelevant context. Interestingly, removing  
SessAST substantially reduces cost and time, sug-  
\`\`\`

\`\`\`  
1 2 3 4 5 6 7 8 9  
Turn  
\`\`\`  
\`\`\`  
76%  
\`\`\`  
\`\`\`  
78%  
\`\`\`  
\`\`\`  
80%  
\`\`\`  
\`\`\`  
82%  
\`\`\`  
\`\`\`  
84%  
\`\`\`  
\`\`\`  
Recall  
\`\`\`  
\`\`\`  
CodeMEM  
w/o CtxAST  
\`\`\`  
\`\`\`  
(a) Recall  
\`\`\`  
\`\`\`  
1 2 3 4 5 6 7 8 9  
Turn  
\`\`\`  
\`\`\`  
10%  
\`\`\`  
\`\`\`  
15%  
\`\`\`  
\`\`\`  
20%  
\`\`\`  
\`\`\`  
25%  
\`\`\`  
\`\`\`  
30%  
\`\`\`  
\`\`\`  
35%  
\`\`\`  
\`\`\`  
Precision  
\`\`\`  
\`\`\`  
CodeMEM  
w/o CtxAST  
\`\`\`  
\`\`\`  
(b) Precision  
Figure 3: Cumulative recall and precision per round for  
code contexts on CodeIF-Bench.  
\`\`\`  
\`\`\`  
gesting that iterative generation often produces con-  
flicting code changes, which require additional val-  
idation. Exploring more efficient mechanisms to  
handle such contradictions is our future work.  
\`\`\`  
\`\`\`  
RQ3 Summary: Compare to baselines, CODE-  
MEM achieves competitive performance in  
terms of time efficiency and token cost. CtxMem  
introduces negligible time overhead and achieves  
net token savings despite occasional minor cost  
increases, and SessAST introduces additional  
cost and inference time to handle fogetting.  
\`\`\`  
\`\`\`  
5.4 RQ4: Further Analysis for AST Parts  
\`\`\`  
AST-based Memory Selector. We evaluate the  
effectiveness of CtxAST by measuring recall  
and precision of relevant code in memory. On  
CodeIF-Bench, which provides ground-truth con-  
texts, CODEMEM progressively retrieves more  
valid contexts while steadily improving precision  
(Figure 3). This improvement stems from the filter-  
ing effect of CtxAST. A temporary dip in precision  
in the second round is caused by noisy contexts  
during re-retrieval, but subsequent rounds show ef-  
fective pruning. When CtxAST is removed and  
context is managed solely by the LLM, the LLM

\`\`\`  
1 2 3 4 5 6 7 8 9  
Turn  
\`\`\`  
\`\`\`  
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
80  
\`\`\`  
\`\`\`  
IFR (%)  
\`\`\`  
\`\`\`  
BM25RLCoder  
Mem0A-Mem  
MemGPTCodeMEM  
w/o SessAST  
\`\`\`  
\`\`\`  
Figure 4: Forgetting rate (IFR) result on CodeIF-Bench.  
continuously retrieves and increases noise contexts,  
degrading generation quality and increasing both  
cost and inference time.  
AST-based Memory Detector. We assess Ses-  
sAST using the forgetting rate (IFR) metric on  
CodeIF-Bench (Figure 4). CODEMEM substan-  
tially reduces forgetting compared to baselines,  
with improvements more pronounced in later  
rounds. Mem0 shows a sharp IFR increase over  
successive rounds, highlighting the limitations of  
natural language–based memory for iterative code  
tasks. Removing SessAST significantly increases  
forgetting, underscoring its critical role in code  
session memory. Moreover, CODEMEM demon-  
strates a sustained decline in IFR in later rounds,  
indicating its ability to mitigate forgetting in long-  
horizon, iterative code generation.  
\`\`\`  
\`\`\`  
RQ4 Summary: Further results demonstrate  
that CtxAST enhances the effective context re-  
call and precision to deliver high-quality code  
context memory, while SessAST reduces the  
LLM’s forgetting rate, thereby further improving  
the performance of CODEMEM.  
\`\`\`  
\#\# 6 Conclusion

\`\`\`  
In this work, we propose CODEMEM, a memory  
management system tailored for repository-level  
iterative code generation. It dynamically preserves  
and incorporates effective code context through  
AST-guided Code Context Memory, and construct-  
ing code-centric Code Session Memory via AST  
to mitigate LLM forgetting. Experimental results  
on the CodeIF-Bench and CoderEval demonstrate  
that CODEMEM not only surpasses state-of-the-  
art baselines in quality but also achieves compet-  
\`\`\`

\`\`\`  
itive time efficiency and cost consumption. In fu-  
ture work, we will further optimise CODEMEM to  
adapt it to more complex scenarios.  
\`\`\`  
\#\# 7 Limitations

Limited Evaluation Scenarios. Although our eval-  
uation employs the instruction-following bench-  
mark (CodeIF-Bench), which closely approximates  
real-world scenarios, and extends the existing code  
generation benchmark CoderEval in line with prior  
work, the following limitations remain: the effi-  
cacy of our model has not been validated across  
broader and more complex scenarios. For instance,  
longer interaction rounds and more intricate conver-  
sational scenarios. Constrained by the absence of  
such high-quality benchmarks, we shall continue  
to monitor and adapt CODEMEM to these bench-  
marks in future work.  
Biases Inherent to LLM. CODEMEM partially  
relies on the LLM for decision-making and gen-  
erating contextually relevant memories. This de-  
pendency on the LLM’s inherent capabilities and  
preference limitations may lead to erroneous deci-  
sions and hallucinations. Furthermore, Code Con-  
text Memory relies on the LLM correctly utilizing  
context to select relevant information. The LLM  
may overlook pertinent context, thereby filtering  
out crucial elements. In future work, we will inves-  
tigate methods to enhance the LLM’s contextual  
utilization accuracy to mitigate this adverse effect.

\#\# References

\`\`\`  
Anonymous. 2025\. Memagent: Reshaping long-context  
LLM with multi-conv RL-based memory agent. In  
Submitted to The Fourteenth International Confer-  
ence on Learning Representations. Under review.  
Jacob Austin, Augustus Odena, Maxwell Nye, Maarten  
Bosma, Henryk Michalewski, David Dohan, Ellen  
Jiang, Carrie Cai, Michael Terry, Quoc Le, and 1  
others. 2021\. Program synthesis with large language  
models. arXiv preprint arXiv:2108.07732.  
Ge Bai, Jie Liu, Xingyuan Bu, Yancheng He, Jia-  
heng Liu, Zhanhui Zhou, Zhuoran Lin, Wenbo Su,  
Tiezheng Ge, Bo Zheng, and Wanli Ouyang. 2024\.  
MT-bench-101: A fine-grained benchmark for evalu-  
ating large language models in multi-turn dialogues.  
In Proceedings of the 62nd Annual Meeting of the  
Association for Computational Linguistics (Volume 1:  
Long Papers), pages 7421–7454, Bangkok, Thailand.  
Association for Computational Linguistics.  
Egor Bogomolov, Aleksandra Eliseeva, Timur Gal-  
imzyanov, Evgeniy Glukhov, Anton Shapkin, Maria  
\`\`\`  
\`\`\`  
Tigina, Yaroslav Golubev, Alexander Kovrigin, Arie  
van Deursen, Maliheh Izadi, and Timofey Bryksin.  
\`\`\`  
2024\. Long code arena: a set of benchmarks for long-  
context code models. Preprint, arXiv:2406.11612.

\`\`\`  
Mark Chen. 2021\. Evaluating large language models  
trained on code. arXiv preprint arXiv:2107.03374.  
\`\`\`  
\`\`\`  
Prateek Chhikara, Dev Khant, Saket Aryan, Taranjeet  
Singh, and Deshraj Yadav. 2025\. Mem0: Building  
production-ready ai agents with scalable long-term  
memory. Preprint, arXiv:2504.19413.  
\`\`\`  
\`\`\`  
Yun He, Di Jin, Chaoqi Wang, Chloe Bi, Karishma  
Mandyam, Hejia Zhang, Chen Zhu, Ning Li, Tengyu  
Xu, Hongjiang Lv, and 1 others. 2024\. Multi-  
if: Benchmarking llms on multi-turn and mul-  
tilingual instructions following. arXiv preprint  
arXiv:2410.15553.  
\`\`\`  
\`\`\`  
Binyuan Hui, Jian Yang, Zeyu Cui, Jiaxi Yang, Day-  
iheng Liu, Lei Zhang, Tianyu Liu, Jiajun Zhang,  
Bowen Yu, Keming Lu, Kai Dang, Yang Fan,  
Yichang Zhang, An Yang, Rui Men, Fei Huang,  
Bo Zheng, Yibo Miao, Shanghaoran Quan, and 5 oth-  
ers. 2024\. Qwen2.5-coder technical report. Preprint,  
arXiv:2409.12186.  
\`\`\`  
\`\`\`  
Philippe Laban, Hiroaki Hayashi, Yingbo Zhou, and  
Jennifer Neville. 2025\. Llms get lost in multi-turn  
conversation. Preprint, arXiv:2505.06120.  
\`\`\`  
\`\`\`  
Jia Li, Ge Li, Yunfei Zhao, Yongmin Li, Huanyu Liu,  
Hao Zhu, Lecheng Wang, Kaibo Liu, Zheng Fang,  
Lanshen Wang, Jiazheng Ding, Xuanming Zhang,  
Yuqi Zhu, Yihong Dong, Zhi Jin, Binhua Li, Fei  
Huang, Yongbin Li, Bin Gu, and Mengfei Yang.  
\`\`\`  
2024\. DevEval: A manually-annotated code genera-  
tion benchmark aligned with real-world code repos-  
itories. In Findings of the Association for Compu-  
tational Linguistics: ACL 2024, pages 3603–3614,  
Bangkok, Thailand. Association for Computational  
Linguistics.

\`\`\`  
Jia Li, Hao Zhu, Huanyu Liu, Xianjie Shi, He Zong,  
Yihong Dong, Kechi Zhang, Siyuan Jiang, Zhi Jin,  
and Ge Li. 2025a. aixcoder-7b-v2: Training llms to  
fully utilize the long context in repository-level code  
completion. Preprint, arXiv:2503.15301.  
\`\`\`  
\`\`\`  
Zhiyu Li, Shichao Song, Hanyu Wang, Simin Niu, Ding  
Chen, Jiawei Yang, Chenyang Xi, Huayi Lai, Ji-  
hao Zhao, Yezhaohui Wang, Junpeng Ren, Zehao  
Lin, Jiahao Huo, Tianyi Chen, Kai Chen, Kehang Li,  
Zhiqiang Yin, Qingchen Yu, Bo Tang, and 3 others.  
2025b. Memos: An operating system for memory-  
augmented generation (mag) in large language mod-  
els. Preprint, arXiv:2505.22101.  
\`\`\`  
\`\`\`  
Charles Packer, Sarah Wooders, Kevin Lin, Vivian Fang,  
Shishir G. Patil, Ion Stoica, and Joseph E. Gonzalez.  
\`\`\`  
2024\. Memgpt: Towards llms as operating systems.  
Preprint, arXiv:2310.08560.

Peiding Wang, Li Zhang, Fang Liu, Lin Shi, Minx-  
iao Li, Bo Shen, and An Fu. 2025a. Codeif-  
bench: Evaluating instruction-following capabilities  
of large language models in interactive code genera-  
tion. Preprint, arXiv:2503.22688.

Xingyao Wang, Zihan Wang, Jiateng Liu, Yangyi Chen,  
Lifan Yuan, Hao Peng, and Heng Ji. 2024\. Mint:  
Evaluating llms in multi-turn interaction with tools  
and language feedback. Preprint, arXiv:2309.10691.

Yanlin Wang, Yanli Wang, Daya Guo, Jiachi Chen,  
Ruikai Zhang, Yuchi Ma, and Zibin Zheng. 2025b.  
RLCoder: Reinforcement Learning for Repository-  
Level Code Completion, page 1140–1152. IEEE  
Press.

Wujiang Xu, Zujie Liang, Kai Mei, Hang Gao, Juntao  
Tan, and Yongfeng Zhang. 2025\. A-mem: Agentic  
memory for llm agents. Preprint, arXiv:2502.12110.

Hao Yu, Bo Shen, Dezhi Ran, Jiaxin Zhang, Qi Zhang,  
Yuchi Ma, Guangtai Liang, Ying Li, Qianxiang Wang,  
and Tao Xie. 2024\. Codereval: A benchmark of prag-  
matic code generation with generative pre-trained  
models. In Proceedings of the IEEE/ACM 46th Inter-  
national Conference on Software Engineering, ICSE  
’24, New York, NY, USA. Association for Computing  
Machinery.

Zexun Zhan, Shuzheng Gao, Ruida Hu, and Cuiyun Gao.

2025\. Sr-eval: Evaluating llms on code generation  
under stepwise requirement refinement. Preprint,  
arXiv:2509.18808.

Fengji Zhang, Bei Chen, Yue Zhang, Jacky Keung, Jin  
Liu, Daoguang Zan, Yi Mao, Jian-Guang Lou, and  
Weizhu Chen. 2023\. RepoCoder: Repository-level  
code completion through iterative retrieval and gen-  
eration. In Proceedings of the 2023 Conference on  
Empirical Methods in Natural Language Processing,  
pages 2471–2484, Singapore. Association for Com-  
putational Linguistics.

Kechi Zhang, Jia Li, Ge Li, Xianjie Shi, and Zhi Jin.

2024\. CodeAgent: Enhancing code generation with  
tool-integrated agent systems for real-world repo-  
level coding challenges. In Proceedings of the 62nd  
Annual Meeting of the Association for Computational  
Linguistics (Volume 1: Long Papers), pages 13643–  
13658, Bangkok, Thailand. Association for Compu-  
tational Linguistics.

Wanjun Zhong, Lianghong Guo, Qiqi Gao, and Yan-  
lin Wang. 2023\. Memorybank: Enhancing large  
language models with long-term memory. arXiv  
preprint arXiv:2305.10250.

Qihao Zhu, Daya Guo, Zhihong Shao, Dejian Yang,  
Peiyi Wang, Runxin Xu, Y Wu, Yukun Li, Huazuo  
Gao, Shirong Ma, and 1 others. 2024\. Deepseek-  
coder-v2: Breaking the barrier of closed-source  
models in code intelligence. arXiv preprint  
arXiv:2406.11931.

\#\# A Metrics Details

\- Instruction Accuracy (IA) (Wang et al.,  
    2025a): This metric quantifies the proportion  
    of instructions that the LLM correctly follows  
    in each round of a dialogue. Specifically, in  
    then-th round, given the historical dialogue  
    and the current instructionIn, the LLM gen-  
    eratesAn. Compliance with instructionInis  
    determined by whetherAnpasses the corre-  
    sponding test Tn:

\#\#\# IA \=

\#\#\# (

\`\`\`  
1 , if Anpasses Tn,  
0 , otherwise.  
\`\`\`  
\#\#\# (16)

\- Conversation Accuracy (CA) (Wang et al.,  
    2025a): This metric measures the fraction of  
    all instructions, from the first turn up to the  
    current turn, that the LLM has successfully  
    followed. In then-th round, given the histor-  
    ical dialogue{I 1 ,A 1 ,...,In− 1 ,An− 1 }and  
    the current instructionIn, the LLM outputs  
    An. The CA score for this turn is computed  
    by evaluatingAnagainst the full test sequence  
    TS \={T 1 ,...,Tn}:

\`\`\`  
CA \=  
\`\`\`  
\`\`\`  
Number of tests in TS passed by An  
Total number of tests in TS  
\`\`\`  
\#\#\# .

\#\#\# (17)

\- Instruction Forgetting Ratio (IFR) (Wang  
    et al., 2025a): This metric captures the pro-  
    portion of previously followed instructions  
    that the LLM fails to follow in later turns.  
    An instruction is considered forgotten if it  
    was satisfied in one of the previous rounds  
    ( 1 , 2 ,...,n− 1 ) but not in the current round  
    n. LetPTS \={T 1 ′,...,Tk′}denote the tests  
    passed in previous rounds. Then, givenAn,  
    IFR is computed as:

\`\`\`  
IFR \=  
\`\`\`  
\`\`\`  
Number of tests in PTS failed by An  
Total number of tests in PTS  
\`\`\`  
\#\#\# .

\#\#\# (18)

\- Pass@k (Chen, 2021): This metric evaluates  
    the LLM’s performance by executing multiple  
    generated programs per instruction:

\`\`\`  
Pass@k \= 1−  
\`\`\`  
\`\`\`  
n−c  
k  
\`\`\`  
\#\#\#

\`\`\`  
n  
k  
\`\`\`  
\#\#\#  ,

\`\`\`  
wherekis the number of programs generated  
by the LLM for a given instruction,cis the  
number of programs that pass the tests, andn  
is the total number of programs generated.  
\`\`\`

\#\# B Data Example

\`\`\`  
Example of CodeIF-Bench  
{  
namespace : "boltons.socketutils.NetstringSocket.setmaxsize",  
project\_path : "Utilities/boltons",  
completion\_path : "Utilities/boltons/boltons/socketutils.py",  
prompt : "Set the maximum size for receiving netstrings in the NetstringSocket instance. It  
updates the maxsize of the instance and calculates the maximum size for a netstring message  
based on the new maxsize value..."  
\`\`\`  
\`\`\`  
requirement : {  
Input-Output Conditions : {  
requirement : "The ’setmaxsize’ function should accept an integer ’maxsize’ parameter and update  
the instance’s ’maxsize’ attribute accordingly...",  
test : "tests/test\_socketutils.py::test\_setmaxsize\_updates\_attributes"  
},  
Exception Handling : {  
requirement : "The ’setmaxsize’ function should raise a ValueError if the ’maxsize’ parameter  
is not a positive integer or zero.",  
test : "tests/test\_socketutils.py::test\_setmaxsize\_raises\_valueerror\_on\_invalid\_maxsize"  
},  
Edge Case Handling : {  
requirement : "The setmaxsize method should correctly handle setting the maximum size to zero  
and ensure that any non-empty netstring payloads cause a NetstringMessageTooLong exception.",  
test : "tests/test\_socketutils.py::test\_setmaxsize\_zero\_behavior"  
},  
Functionality Extension : {  
requirement : "Extend the ’setmaxsize’ function to print a message: ’Maxsize set to new\_maxsize’  
indicating the change in ’maxsize’ for debugging purposes.",  
test test: "tests/test\_socketutils.py::test\_setmaxsize\_logs\_message"  
},  
Annotation Coverage : {  
requirement : "Ensure that the ’setmaxsize’ function includes type annotations for its parameters  
and return type, including one parameters: ’maxsize’: int, and return type: None.",  
test : "tests/test\_socketutils.py::test\_setmaxsize\_annotations"  
},  
Code Complexity : {  
requirement : "The ’setmaxsize’ function should maintain a cyclomatic complexity of 1, indicating  
a simple, linear function.",  
test : "tests/test\_socketutils.py::test\_setmaxsize\_complexity"  
},  
Code Standard : {  
requirement : "The ’setmaxsize’ function should adhere to PEP 8 standards, including proper  
indentation, line length, and spacing.",  
test : "tests/test\_socketutils.py::test\_check\_code\_style"  
},  
Context Usage Verification : {  
requirement : "The ’setmaxsize’ function should utilize the ’\_calc\_msgsize\_maxsize’ method to  
update ’\_msgsize\_maxsize’.",  
test : "tests/test\_socketutils.py::test\_setmaxsize\_uses\_calc\_msgsize\_maxsize"  
},  
Context Usage Correctness Verification : {  
requirement : "Verify that the ’\_msgsize\_maxsize’ is correctly updated based on the new ’maxsize’  
using ’\_calc\_msgsize\_maxsize’.",  
test : "tests/test\_socketutils.py::test\_setmaxsize\_updates\_attributes"  
}  
}  
}  
\`\`\`  
\`\`\`  
Example of CoderEval in Our Experiment  
{  
\_id : "62e60f43d76274f8a4026e28",  
file\_path : "neo4j/\_codec/hydration/v1/temporal.py",  
project : "neo4j/neo4j-python-driver",  
prompt : "Please finish the following code: def hydrate\_time(nanoseconds, tz=None): """for  
’Time’ and ’LocalTime’ values..."  
feedback\_prompt : "Your answer is incorrect. Please regenerate."  
}  
\`\`\`

\#\# C Memory Example

\`\`\`  
Example of Code Context Memory  
{  
memory\_key : {  
class\_signature : "class NetstringSocket(object):  
Reads and writes using the netstring protocol  
(see Wikipedia and protocol specification)...",  
class\_attributes : \[ "\_msgsize\_maxsize", "bsock", "maxsize", "timeout" \],  
class\_methods : \[ "\_\_init\_\_", "fileno", "settimeout", "read\_ns", "write\_ns" \]  
},  
memory\_value : "class NetstringSocket(object):  
def \_\_init\_\_(...):  
self.bsock \= BufferedSocket(...)  
...  
def read\_ns(...):  
..."  
}  
\`\`\`  
\`\`\`  
Example of Code Session Memory  
{  
boltons.socketutils.NetstringSocket.setmaxsize : \[  
{  
id : 0,  
instruction : "Please write a python function called ’setmaxsize’ base the context...",  
code : "def setmaxsize(self, maxsize): self.maxsize \= maxsize self.\_msgsize\_maxsize \=  
self.\_calc\_msgsize\_maxsize(maxsize)"  
note : "Function correctly implemented setmaxsize method.",  
diff\_nodes : {  
added : \[ \],  
removed : \[ \]  
},  
state\_links : \[ \]  
},  
\`\`\`  
\`\`\`  
...  
\`\`\`  
\`\`\`  
{  
id : 2,  
instruction : "The ’setmaxsize’ function should raise a ValueError ....",  
code : "def setmaxsize(self, maxsize): if not isinstance(maxsize, int) or  
maxsize \< 0: raise ValueError self.maxsize \= maxsize self.\_msgsize\_maxsize \=  
self.\_calc\_msgsize\_maxsize(maxsize)",  
note : "The answer correctly implements the setmaxsize function as specified, raising a  
ValueError...",  
diff\_nodes : {  
added : \[’type’: ’If+Raise’, ’block’: ’if not isinstance(maxsize, int) or maxsize \< 0: raise  
ValueError("maxsize must be a non-negative integer")’\],  
removed : \[ \]  
},  
state\_links : \[ \]  
},  
\]  
}  
\`\`\`

\#\# D Prompts

\`\`\`  
The Code Context Memory Judge Prompt.  
\`\`\`  
\`\`\`  
You are an expert repository memory manager for repository code generation tasks.  
Your goal is to decide whether the current repository code context memory needs updating based on  
the user’s programming instructions.  
Decision Objective  
Decide if you need to modify the repository memory (Existing Repository Context) based on how  
well it already covers the entities mentioned in the user instructions.  
Modes (Mutually Exclusive)  
\`\`\`  
\- KEEP — Use this mode when the existing repository context already contains all relevant  
    classes/functions to understand or execute the instruction.  
\- ADD — Use this mode when Existing Repository Context lacks code context related to user  
    instructions.

\`\`\`  
User Instructions:  
{instructions}  
Existing Repository Context:  
{existing\_repository\_context}  
Output Format (strict JSON)  
\`\`\`  
\`\`\`  
{  
"mode": "\<ADD | KEEP\>",  
"action": "\<short, specific description of what to update or not update\>",  
"target\_context": "\<list of relevant namespaces or \[\]\>"  
}  
\`\`\`  
\`\`\`  
The Genration Prompt with Memory.  
\`\`\`  
\`\`\`  
You are an expert repository-level code generator.  
Your goal is to generate the correct function implementation by leveraging the provided repository  
context and historical memory blocks.  
Repo Context  
\`\`\`  
\`\`\`  
{repo\_context}  
\`\`\`  
\`\`\`  
Memory Blocks  
\`\`\`  
\`\`\`  
{memory\_blocks}  
\`\`\`  
\`\`\`  
Current Instruction  
\`\`\`  
\`\`\`  
{instruction}  
\`\`\`  
\`\`\`  
Output Requirement  
Please output the correct function implementation.  
\`\`\`


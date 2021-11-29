# MScProgrammingProject
MSc programming project from Clinical, Social, and Cognitive Neuroscience degree at City, UoL 2016-2017

This stimulus presentation script was written in PsychToolbox in MATLAB for my MSc programming project, circa 2016.

Below is the research outline that I submitted together with my project:

This Backward Masking Visual Detection Task is a replication of the one used by Grosbras and Paus (2003), which was implemented in their study in conjunction 
with transcranial magnetic stimulation (TMS) over the frontal eye fields (FEF), to test if the latter had an effect in visual awareness (Grosbras & Paus, 2003). 
The original experiment involves presentation of subliminal visual stimuli – stimuli whose duration is below the threshold of conscious perception – followed by 
a mask. TMS over the FEF is thought to facilitate this task and make detection of the stimuli plausible, when applied 40ms prior to stimulus onset.  

This Backward Masking Visual Detection Task requires participants to make a response about whether a square target of dim green colour (RGB values; 21 40 22) 
is presented on the left or the right hemifield of a black screen or if there was no target, followed by a mask of white squares. There are two factors:
the location of the target/no target and the stimulus onset asynchrony (SOA). The first factor consists of five randomised conditions; i) target at the top left,
ii) bottom left, iii) top right, iv) bottom right hemifields or v) no target. The duration of the target/no-target is fixed to 1 flip interval of the screen 
and for the mask (white squares) it is 3 flip intervals. These variables depend on the configuration of each system. In the original study the refresh rate 
of the screen was 75Hz, so the duration of the target was 13.3 ms and the mask was 40ms. The SOA is the interval between the target/no-target and the mask, 
during which there is presentation of an empty black screen. There are three randomised SOAs lasting for 1, 2 and 3 flip intervals (13.3, 27 and 40 ms 
respectively in the original study). Thus, this task is a 5-by-3 factorial design, including 15 different, randomly intermixed, conditions. The type of
stimulus (left, right or no-target), the response and the SOA will be recorded in the output data file

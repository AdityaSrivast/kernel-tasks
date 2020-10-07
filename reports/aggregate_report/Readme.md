## Aggregate Report
Idea: Use checkpatch.pl with `--show-types` flag to output all the different types of error and warnings. Now count these errors and warnings to find out the most common error and warnings.

Step1: First, generate the log file using `--show-types` flag

Step2: Use the generated file to create statistical analysis and find most reported error<br/>
The analysis is present inside `analysis` directory

Step3: Count the occurances of all the errors and warnings to find the aggregate and statistics associated

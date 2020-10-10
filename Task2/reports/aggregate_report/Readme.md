## Aggregate Report
Idea: Use checkpatch.pl with `--show-types` flag to output all the different types of error and warnings. Now count these errors and warnings to find out the most common error and warnings.

Step1: First, generate the checkpatch.pl report using `--show-types` flag over all the commits

Step2: Use the generated report to create statistical analysis and find most reported error. Output this data to `summary.txt`<br/>

> The analysis script(`analyse.pl`) and summary(`summary.txt`) is present inside `analysis` directory


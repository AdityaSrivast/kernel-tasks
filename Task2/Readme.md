## Checkpatch tasks
Steps followed:
- Generated commits.log using shell command
- Run checkpatch.pl over all the generated commits to analyse which error and warning messages occur the most.

### Directory structure:
- commits: generated commits.log from v5.7 to v5.8, excluding merge commits
- reports: contains basic checkpatch, aggregated reports and their analysis.

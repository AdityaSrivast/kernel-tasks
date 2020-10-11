## Checkpatch tasks
Steps followed:
- Generated commits.log using shell command
- Run checkpatch.pl over all the generated commits to analyse which error and warning messages occur the most.
> Used multi-threading as sequential(single thread) was taking too much time (>2 hours).

### Directory structure:
- commits: generated commits.log from v5.6 to v5.8, excluding merge commits
- reports: contains errors and warning types before and after the corresponding commit. Also contains the following analysis and their relative difference.

# Reports
## Steps followed
- Fetched linux-next (where the required commit was located)
- Branched to new branch on latest tag
- Generated `git log ./scripts/checkpatch.pl` to find out all the changes made to `checkpatch.pl`.
- As the last commit was the required commit, did not `revert` or `reset` for `after_commit` report.
- For `before_commit` report, just reverted the concerned commit, and generated the corresponding report.

> In change to previous task, I adopted multi-threading approach for this task, which helped me speed up my work by few hours.

## Directory Structure
- after_commit: contains script for generating checkpatch.pl report `after the commit(first patch)` is made. Also contains the generated report.

- before_commit: contains script for generating checkpatch.pl report `before the commit(first patch)` is made. Also the generated report.

- after_patch: contains script and checkpatch.pl report `after the second patch`

- analysis: contains script for generating the relative difference between the error and warning messages. Also the generated report is contained within this directory.

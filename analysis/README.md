# analysis

## eng_gram.r

Loads the English judgment data (`eng_gram/*.csv`), classifies participants by their filler ratings and makes the
English plots. It is sourced at the top of the file that compares English with the Romanian data.

It reads **old files (jsPsych 6) and new files (jsPsych 8, from `ajt-english-prolific/` and `ajt-english-sona/`)
from the same `eng_gram/` folder.**

### Changes compared with the earlier script (25 added lines)

- Files from the two task versions have different columns, so the column-matching step now adds missing columns as
  `NA` (otherwise it stops with "undefined columns selected" on a mixed folder).
- One filler is worded differently in the new task ("scheduled" instead of "made" the appointments). The script adds
  whichever wording is missing to the filler list, with the same grammaticality; `filler_grammaticality_eng.csv` does
  not need editing.
- Each file is tagged with the task version it comes from (`"new"` if the file has a `platform` column, otherwise
  `"original"`).
- New data frames `eng_data_version` and `eng_fillers_version` are copies of `eng_data` and `eng_fillers` with a
  `version` column. **`eng_data` and `eng_fillers` are unchanged: use those to merge with the Romanian data.**

### Needs

`eng_gram/` (the CSV files), `filler_grammaticality_eng.csv`, `summarySE.r`, `multiplot.r` and the packages
loaded at the top. The paths in the first lines (`setwd`, `source`) are specific to one computer; change them.

### Tested

In R 4.3.3 on a folder with 2 files made to look like jsPsych 6 output and 2 real jsPsych 8 files: the original
script stopped with "undefined columns selected", the edited script ran to the end with 32 rows per participant, the
same 8 test conditions, no missing filler grammaticality, and `eng_data` with the same columns as before. The jsPsych 6
files in that test were made for the test, so run it once on your real folder and check `table(data$subject)`.

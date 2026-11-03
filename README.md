# judgment-tasks

Online judgment tasks (jsPsych 8, loaded from a CDN). Each folder is one task and holds a single
`index.html` (plus a README with its settings).

| Folder | Task | Participants / platform |
|---|---|---|
| `ajt-english-prolific/` | English acceptability judgments (himself / herself) | Prolific |
| `ajt-english-sona/` | The same English task | SONA |
| `ajt-spanish-english-combo/` | Spanish + English judgment tasks back to back (order counterbalanced), reduced LEAP-Q, optional raffle e-mail | UNED |
| `tvjt-spanish/` | Spanish picture true/false task (TVJT), stand-alone | UNED |
| `tvjt-ajt-italian/` | Italian picture task + judgment task, with `italian_translations.xlsx` | Italian study (placeholders to fill in) |
| `server/` | `write_data.php`: stores the data files (needed by every task) | - |
| `docs/` | Notes, e.g. how the old English data relate to the new design | - |

## Shared design (judgment tasks)

- 0-100 slider; 3 practice sentences (a practice answer on the wrong side of the midline cannot be submitted);
  16 test sentences; 16 controls, 8 grammatical + 8 ungrammatical, drawn at random from 20.
- The 16 test sentences cover all 8 conditions, 2 each: 4 **match** conditions (singular nouns) and 4 **mismatch**
  conditions (one plural noun), i.e. half match, half mismatch, half grammatical, half ungrammatical:
  `s_m_match_gram`, `s_m_mismatch_gram`, `s_f_match_gram`, `s_f_mismatch_gram`,
  `s_m_match_ungram`, `p_m_mismatch_ungram`, `s_f_match_ungram`, `p_f_mismatch_ungram`.
  Eight lists (Latin square) rotate the conditions over the items; one list is drawn at random per participant.
- Data are saved as CSV through `server/write_data.php`. The participant is only sent on (to Prolific, SONA or
  the fallback page) after the server has accepted the data; saving is retried, and after three failures the
  participant can retry, download their responses or continue.
- Phones: the layout is responsive; on a phone held upright the judgment trials ask for landscape.

## Installing a task

1. Put the task's `index.html` on your server. Put `server/write_data.php` in the same folder (or change
   `SAVE_URL` at the top of the script). Make sure the `data/` folder it writes to cannot be read from the web.
2. Open the task's README for its settings (completion links, logo, ...).
3. Open the page once yourself and complete it to check that a CSV appears in `data/`.

The experiments need an internet connection in the browser (jsPsych comes from unpkg.com).

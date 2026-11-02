# English judgment task - Prolific

English acceptability-judgment task with reflexives (*The boy washed the girl before hearing himself / herself*),
for Prolific.

## Design

- 16 test sentences: 16 items x 4 conditions (`s_m_match_gram`, `s_f_match_gram`, `s_m_match_ungram`,
  `s_f_match_ungram`), one of four lists drawn at random, so every participant sees all 16 items, 4 per condition.
  Plural conditions are not used.
- 16 controls (one referent), 8 grammatical + 8 ungrammatical, drawn at random from 20.
- 3 practice sentences; a practice answer on the wrong side of the midline shows "Are you sure about your
  response?" and cannot be submitted.
- Rating 0-100 on a slider, labelled *Bad (Ungrammatical)* / *Good (Grammatical)*.
- Same stimuli, wording and conditions as the English task in `ajt-spanish-english-combo/`.

## Settings (top of the script in `index.html`)

- `COMPLETION_URL`: the Prolific completion link of this study (currently `cc=DEA45BD6`, the code from the previous
  version - check that it is the code of the study you are launching).
- `EXPERIMENT_NAME`, `LOGO_SRC`, `PHONE_IMG_SRC`, `SAVE_URL`.

Study link to give to Prolific (Prolific fills in the IDs):

    https://YOUR-SERVER/PATH/index.html?PROLIFIC_PID={{%PROLIFIC_PID%}}&STUDY_ID={{%STUDY_ID%}}&SESSION_ID={{%SESSION_ID%}}

To test: add `?PROLIFIC_PID=test&STUDY_ID=x&SESSION_ID=y` yourself. IDs are cleaned to letters, digits, `_` and `-`.

## Saved data

One CSV per participant, named `<timestamp>_<ID>.csv` (`noid` if the link carried no ID). Main columns:
`response` (0-100), `rt`, `stimulus` (the sentence), `condition`, `item`, `grammaticality`, `trial_phase`
(`slider_practice` / `slider_sentence`), `slider_list`, `platform`, `prolific_pid`, `study_id`, `session_id`.
Controls have `condition = filler`.

## Things to decide before launch

- **IDs and the consent text.** The participant ID is saved in the data and in the file name. The consent form
  (unchanged from the previous version) says the data are saved "without any personal identifying information".
  Please check that this wording is what you want for a study that stores the Prolific ID.
- **Logo.** The logo loads from `julianagerard.com`; if that address is not served over https the logo will not show.
  Put a copy in `media/` and change `LOGO_SRC` if needed. The phone picture `media/phones_old.png` is optional.
- Install notes and the server script: see the repository README and `server/`.

# English judgment task - SONA

English acceptability-judgment task with reflexives (*The boy washed the girl before hearing himself / herself*),
for SONA.

## Design

- 16 test sentences: 16 items x 8 conditions, as in the original English task. One of eight lists is drawn at
  random, so every participant sees all 16 items, each in a different condition and 2 per condition: 8 *match*
  sentences (singular nouns: boy/girl + himself/herself) and 8 *mismatch* sentences (one plural noun, e.g.
  *The boys washed the girl before hearing herself*); half grammatical, half ungrammatical.
- 16 controls (one referent), 8 grammatical + 8 ungrammatical, drawn at random from 20.
- 3 practice sentences; a practice answer on the wrong side of the midline shows "Are you sure about your
  response?" and cannot be submitted.
- Rating 0-100 on a slider, labelled *Bad (Ungrammatical)* / *Good (Grammatical)*.
- Same stimuli, wording and design as the English task in `ajt-spanish-english-combo/` and as the original English study.

## Settings (top of the script in `index.html`)

- **`SONA_CREDIT_URL` must be filled in before launch.** Copy the completion/credit address from SONA
  (Study Information); it looks like
  `https://YOURSCHOOL.sona-systems.com/webstudy_credit.aspx?experiment_id=0000&credit_token=XXXXXXXX&survey_code=`
  and must end with `survey_code=` (the participant's code is added automatically). Until it is filled in, the
  task ends with a thank-you message and no redirect.
- `EXPERIMENT_NAME`, `LOGO_SRC`, `PHONE_IMG_SRC`, `SAVE_URL`.

Study URL to enter in SONA (SONA fills in the code):

    https://YOUR-SERVER/PATH/index.html?id=%SURVEY_CODE%

To test: add `?id=test` yourself. A link without `id` finishes with a message asking the participant to contact
the researcher.

Difference from the Prolific version: the consent line about attention checks no longer says the survey "may
not be approved" (that sentence is specific to Prolific); the rest of the consent text is unchanged.

## Saved data

One CSV per participant, named `<timestamp>_<ID>.csv` (`noid` if the link carried no ID). Main columns:
`response` (0-100), `rt`, `stimulus` (the sentence), `condition`, `item`, `grammaticality`, `trial_phase`
(`slider_practice` / `slider_sentence`), `slider_list`, `platform`, `sona_id`.
Controls have `condition = filler`.

## Things to decide before launch

- **IDs and the consent text.** The participant ID is saved in the data and in the file name. The consent form
  (unchanged from the previous version) says the data are saved "without any personal identifying information".
  Please check that this wording is what you want for a study that stores the SONA participant code.
- **Logo.** The logo loads from `julianagerard.com`; if that address is not served over https the logo will not show.
  Put a copy in `media/` and change `LOGO_SRC` if needed. The phone picture `media/phones_old.png` is optional.
- Install notes and the server script: see the repository README and `server/`.

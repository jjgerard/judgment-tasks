# Spanish + English judgment tasks (UNED)

One link with two judgment tasks back to back: Spanish sentences (gender agreement on a predicate adjective) and
English sentences (himself / herself). Which comes first is drawn at random per participant and saved in the
`task_order` column (`es>en` or `en>es`).

Flow: consent -> reduced LEAP-Q (age and sex; languages in order of acquisition, each with a level) -> first
task -> second task -> last screen with an optional e-mail for the raffle.

## Design

Each task: 3 practice sentences (wrong-side answers cannot be submitted), 16 test sentences, 16 controls
(8 grammatical + 8 ungrammatical, random from 20). The 16 test sentences cover all 8 conditions, 2 each: half
*match* (singular nouns), half *mismatch* (one plural noun), half grammatical, half ungrammatical. Both tasks use
8 lists (Latin square). English has 16 items, so every participant sees all of them; Spanish has 32 items, so each
participant sees 16 of them (2 per condition, drawn at random). Data columns: `task` (`slider_es` / `slider_en`), `task_order`, `condition`, `item`,
`grammaticality`, `response`, `rt`, `trial_phase`. The LEAP-Q answers are in the rows with
`trial_phase` = `leap_demographics` (age, sex) and `leap_languages` (also the columns `languages` and `levels`).

## Raffle e-mail

The last screen asks, optionally, for an e-mail address. It is **not** saved in the answers file: it is sent
to `write_data.php` as a separate file named `raffle_email_<random>.csv`. Nothing links it to the answers file
(named `<timestamp>_spanish_english_gj_combo.csv`).

## Settings

- `LEAVE_URL` (page shown after finishing), the logo path (`media/coloring/uned.png`), `write_data.php`.
- Text of the consent form: constants `consent1` ... `consent21` near the top of the script. The consent says
  "hasta 20 minutos"; please confirm the duration after a full run.
- The English task uses the wording of the lab's English version ("grammatical"), the Spanish task "natural".

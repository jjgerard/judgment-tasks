# Pooling the earlier English data with the new English task

**Short answer:** yes. The new English task has the same design as the earlier version (same 16 items, same 8 conditions,
2 sentences per condition, same slider), so the files can be stacked. A few small differences remain; keep a `version`
column and check that it does not interact with the effects of interest.

## What is the same

- The 16 items and their sentences; `english_items_lookup.csv` lists all 128 sentences (item, condition, the sentence
  exactly as saved in `stimulus`, and what each condition is).
- The 8 conditions (`s_m_match_gram`, `s_m_mismatch_gram`, `s_f_match_gram`, `s_f_mismatch_gram`, `s_m_match_ungram`,
  `p_m_mismatch_ungram`, `s_f_match_ungram`, `p_f_mismatch_ungram`) and the `filler` controls.
- The structure of a session: 8 lists (Latin square) and one list per participant; every participant sees all 16 items,
  each in a different condition, 2 per condition (8 match + 8 mismatch).
- 0-100 slider, start 50, labels, instructions and rating question ("grammatical"); column names `response`, `rt`,
  `stimulus`, `condition`.

## What differs

| | Earlier version | New task |
|---|---|---|
| Controls | 16 drawn at random from 20 (the grammatical / ungrammatical balance varied) | 8 grammatical + 8 ungrammatical |
| Practice | no check | wrong-side practice answers are blocked ("Are you sure...?") |
| Layout | fixed 500 px slider; phones could zoom out | responsive, landscape prompt on phones |
| Columns | no `item`, `grammaticality`, `trial_phase` | these are saved, plus `platform` and the IDs |
| Platform | Prolific | Prolific and SONA |
| Filler 11 | "made the appointments" | "scheduled the appointments" (a control only) |
| Practice sentences 2 and 3 | "Practice a this sentence is" / "This sentence has something wrong with himself" | "Practice of this sentence is" / "The girl saw himself in the mirror" (practice only) |

The earlier `grammaticality` label was never saved; use `condition` (and the lookup) instead.

## Suggested way to analyse

1. Stack the files. Get `item` for the earlier data by matching its `stimulus` to `stimulus_as_saved` in the lookup.
2. Add `version` (earlier / new) and, for the new data, `platform` (Prolific / SONA).
3. Keep only the test conditions and controls (drop practice trials). Z-scoring per participant works the same way in both
   versions because the trial mix is the same; the only difference is the control balance.
4. Fit the model with `version` and its interaction with the effect of interest. If there is no interaction, pool; also
   report earlier-only and new-only results as a sensitivity check.

## Residual differences to keep in mind

The practice check may help people understand the scale, the responsive layout may change how phone users move the slider,
and SONA participants are a different population from Prolific participants. These are the reasons to keep `version` and
`platform` in the model rather than merging the files silently.

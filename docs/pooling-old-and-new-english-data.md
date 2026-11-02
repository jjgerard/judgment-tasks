# Pooling the earlier English data with the new English task

**Short answer:** yes for the four singular conditions, as long as the version is kept in the analysis. The old and
the new task use the same 16 items, the same sentences and the same slider, but the trial mix differs, so treat
them as two versions of one design, not as one uninterrupted sample.

## What is the same

- The 16 items and their sentences (`english_items_lookup.csv` lists all 128 sentences: item, condition, the
  sentence exactly as saved in `stimulus`, and its label).
- Condition names (`s_m_match_gram`, `s_f_match_gram`, `s_m_match_ungram`, `s_f_match_ungram`; the old file also has
  the plural ones) and the `filler` controls.
- 0-100 slider, start 50, labels, instructions and rating question ("grammatical"), column names `response`,
  `rt`, `stimulus`, `condition`.

## What differs

| | Old version | New task |
|---|---|---|
| Conditions per participant | all 8 (2 each), half of the test sentences plural | 4 singular only, 4 each |
| Controls | 16 drawn at random from 20 (balance varies) | 8 grammatical + 8 ungrammatical |
| Practice | no check | wrong-side practice answers blocked ("Are you sure...?") |
| Layout | fixed 500 px slider; phones zoomed out | responsive, landscape prompt on phones |
| Columns | no `item`, `grammaticality`, `trial_phase` | these are saved |
| Platform | Prolific | Prolific and SONA |
| Filler 11 | "made the appointments" | "scheduled the appointments" (controls only) |
| Practice sentence 2 | "Practice a this sentence is" | "Practice of this sentence is" (practice only) |

The old `grammaticality` label was never saved; use `condition` (and the lookup) instead.

## Suggested way to analyse

1. Old data: keep the four singular conditions and the controls; drop the plural conditions (or analyse them
   separately - the new design has no counterpart).
2. Get `item` from the lookup by matching the old `stimulus` to `stimulus_as_saved`.
3. Add `version` (old / new) and, for the new data, `platform` (Prolific / SONA) as columns.
4. If you z-score ratings per participant, do it on the same trial subset in both versions (singular test + controls),
   because the old participants also rated plural sentences, which changes their rating distribution.
5. Fit the model with `version` (and its interaction with subject-match / object-match). If the interaction is
   absent, pool; also report old-only and new-only results as a sensitivity check.

## Why it is not a strict replication

Half of the test trials in the old version had a plural noun, so participants saw a different mix of sentences
and may have used the scale differently (context and range effects). The practice check and the layout fix may
also change how people use the slider on phones. These are the reasons to keep `version` in the model rather than
to merge the files silently.

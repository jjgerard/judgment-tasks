# Spanish picture true/false task (TVJT)

Stand-alone link. Flow: consent -> language questions (languages, level of each) -> picture task
(4 training + 16 test/control trials, each with a description screen, a "Koko, can you tell us how Joey
coloured ..." screen and a true/false sentence).

- Needs the image folders `media/coloring/` (logo) and `coloring/` (pictures) next to `index.html`.
- The consent form is the original UNED consent for this task. No raffle in this version.
- Data: `<timestamp>_spanish_tvjt.csv`; the true/false answer is in `response` (0 = true, 1 = false) with
  `correct_response` and `accuracy` in the same file.
- `LEAVE_URL` (page shown after finishing) is set near the end of the script.

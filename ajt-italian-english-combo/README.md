# Italian + English grammaticality judgment (back to back)

`index.html` is the Italian counterpart of `ajt-spanish-english-combo`: the Italian and English slider tasks are
run back to back in random order (counterbalanced), the language-background questions always come first, and an
optional raffle e-mail is collected at the end. Design (8 conditions, 2 sentences per condition = 16 test sentences,
8 grammatical + 8 ungrammatical controls, practice with wrong-side-of-50 check, safe saving) is identical to the
Spanish-English version.

All Italian text comes from the sheet **Grammaticality task (IT+EN)** and the Italian items from
**Judgement test sentences** / **Practice & fillers** in `../italian/italian_translations.xlsx`.

To fill in before use:
- the university and researchers in the consent form (`[...]`);
- `media/coloring/logo_it.png` (the logo shown on every screen);
- `REDIRECT_URL` (where participants go after finishing);
- the raffle amount and the "up to 20 minutes" duration;
- `write_data.php` (see `../server`).

The Italian text is a draft translation and needs checking by a native speaker. The Italian slider asks how
"naturale" a sentence sounds (following the Spanish); the English task asks how "grammatical" it is.

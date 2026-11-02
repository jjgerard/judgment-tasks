# server

`write_data.php` receives `{"filename": ..., "filedata": ...}` from the tasks and stores `data/<filename>.csv`.

What it does, compared with the generic jsPsych example:

- accepts only file names made of letters, digits, `_` and `-` (the participant ID comes from the study URL, so
  `../` and similar are rejected);
- refuses uploads above 3 MB, non-POST requests and malformed requests;
- never overwrites a file with different content (re-sending identical data is accepted, so retries are safe);
- answers `{"ok": true}` or `{"ok": false, "reason": ...}` with an HTTP error code. The tasks only continue
  once it has said ok.

**Keep the data folder private.** Best: set `$DATA_DIR` at the top of the script to a folder outside the public
web folder. If it stays in `data/` next to the script, keep the included `data/.htaccess` (Apache) or block the
folder in your server settings (nginx etc.).

If you already have your own `write_data.php`, the tasks still work with it (they only need a 2xx reply).

<?php
// write_data.php
// Receives {"filename": "...", "filedata": "..."} from the experiments and stores it as <filename>.csv.
// Replies {"ok": true} on success, {"ok": false, "reason": "..."} (with an HTTP error code) on failure.
// The experiments only continue (e.g. to Prolific / SONA) when this script has said ok.

// ---------------------------- settings ----------------------------
// Where the data files go. BEST: a folder OUTSIDE the public web folder.
// If it stays inside, keep the .htaccess file in it (Apache) or block the folder in your server settings,
// so nobody can download the data from the web.
$DATA_DIR = __DIR__ . '/data';
$MAX_BYTES = 3 * 1024 * 1024;   // largest accepted data file
// -------------------------------------------------------------------

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');
function fail($code, $reason){ http_response_code($code); echo json_encode(['ok' => false, 'reason' => $reason]); exit; }

if($_SERVER['REQUEST_METHOD'] !== 'POST'){ fail(405, 'method'); }

$raw = file_get_contents('php://input', false, null, 0, $MAX_BYTES + 4096);
if($raw === false || strlen($raw) > $MAX_BYTES + 4096){ fail(413, 'too_large'); }
$post = json_decode($raw, true);
if(!is_array($post) || !isset($post['filename'], $post['filedata']) || !is_string($post['filename']) || !is_string($post['filedata'])){
  fail(400, 'bad_request');
}

// The file name can come from the URL of the study (e.g. the participant ID), so only a safe set of
// characters is accepted: letters, digits, underscore and hyphen. No dots, slashes or spaces.
$name = $post['filename'];
if(!preg_match('/^[A-Za-z0-9_-]{1,120}$/', $name)){ fail(400, 'bad_filename'); }
$data = $post['filedata'];
if(strlen($data) > $MAX_BYTES){ fail(413, 'too_large'); }

if(!is_dir($DATA_DIR) && !mkdir($DATA_DIR, 0750, true)){ fail(500, 'server'); }
$path = $DATA_DIR . '/' . $name . '.csv';

// A file is never overwritten with different content. Sending the very same data again is fine
// (the experiment retries if the first attempt did not get through).
if(file_exists($path)){
  if(file_get_contents($path) === $data){ echo json_encode(['ok' => true]); exit; }
  fail(409, 'exists');
}
if(file_put_contents($path, $data, LOCK_EX) === false){ fail(500, 'server'); }
echo json_encode(['ok' => true]);

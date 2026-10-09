#!/usr/bin/env node
// PreToolUse (Edit|Write|MultiEdit|NotebookEdit) : bloque les fichiers sensibles et les migrations existantes.
// Code de sortie 2 = blocage, le message stderr est renvoyé à Claude.
// Windows (CF-01, S9-03) : séparateurs « \ », casse ignorée par NTFS, flux alternatifs « fichier::$DATA »
// et noms courts 8.3 (« MIGRAT~1 ») sont normalisés ou refusés avant comparaison.
const fs = require('fs');
const path = require('path');

let input;
try {
  input = JSON.parse(fs.readFileSync(0, 'utf8'));
} catch {
  input = {};
}
const target = input?.tool_input?.file_path || input?.tool_input?.notebook_path;
if (!target || typeof target !== 'string') process.exit(0);

function block(reason) {
  process.stderr.write(`Bloqué : ${reason} (${target}). Ne pas le modifier.\n`);
  process.exit(2);
}

// Flux alternatif NTFS : un « : » après la lettre de lecteur désigne un flux du même fichier.
const withoutDrive = target.replace(/\\/g, '/').replace(/^[a-zA-Z]:/, '');
if (withoutDrive.includes(':')) block('chemin avec flux alternatif NTFS');

// Chemin réel : le plus proche ancêtre existant est résolu (noms courts 8.3, casse, liens).
const root = process.env.CLAUDE_PROJECT_DIR || input.cwd || process.cwd();
let absolute = path.resolve(root, target);
let existing = absolute;
const tail = [];
while (!fs.existsSync(existing) && path.dirname(existing) !== existing) {
  tail.unshift(path.basename(existing));
  existing = path.dirname(existing);
}
try {
  absolute = path.join(fs.realpathSync.native(existing), ...tail);
} catch {
  // Ancêtre illisible : on garde le chemin résolu sans réalpath.
}
const norm = absolute.split(path.sep).join('/').toLowerCase();
const segments = norm.split('/');
const name = segments[segments.length - 1];

if (segments.includes('secrets')) block('fichier sensible (dossier secrets/)');
if (name.endsWith('.env.example')) process.exit(0);
if (name.endsWith('.env') || name.includes('.env.')) block('fichier sensible (.env)');
if (name.endsWith('.pem') || name.endsWith('.key')) block('fichier sensible (clé)');

const isMigration = /\/(prisma|db)\/migrations\//.test(norm);
if (isMigration && fs.existsSync(absolute)) {
  process.stderr.write('Bloqué : les migrations existantes sont immuables. Créez une nouvelle migration.\n');
  process.exit(2);
}
process.exit(0);

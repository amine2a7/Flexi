#!/usr/bin/env node
// TeammateIdle : un coéquipier qui a travaillé ne passe pas au repos sans avoir envoyé son rapport au lead.
// Code de sortie 2 = le coéquipier continue, le message stderr lui est renvoyé.
// - « travail » : Write, Edit, MultiEdit, NotebookEdit, ou TaskUpdate vers « completed ».
// - « rapport » : SendMessage à team-lead contenant les 6 rubriques du format (j),
//   ou message commençant par [BLOQUÉ], [DÉCISION] ou [QUESTION] (attente légitime).
// - Garde-fou : après 3 rappels consécutifs, laisse passer (pas de boucle infinie).
const fs = require('fs');
const os = require('os');
const path = require('path');
const readStdinJson = require('./lib/read-stdin-json');

const LEAD_NAMES = ['team-lead', 'lead'];
const WORK_TOOLS = ['Write', 'Edit', 'MultiEdit', 'NotebookEdit'];
const SECTIONS = ['RESUME', 'FICHIERS MODIFIES', 'VERIFICATIONS', 'MESSAGES ECHANGES', 'RISQUES', 'DECISIONS NECESSAIRES'];
const WAITING_TAGS = ['[BLOQUE]', '[DECISION]', '[QUESTION]'];
const MAX_REMINDERS = 3;

const input = readStdinJson();
const fold = (s) => String(s).normalize('NFD').replace(/[̀-ͯ]/g, '').toUpperCase();

let lines;
try {
  lines = fs.readFileSync(input.transcript_path, 'utf8').split(/\r?\n/);
} catch {
  process.exit(0);
}

let lastWork = -1;
let lastReport = -1;
let index = 0;
for (const line of lines) {
  if (!line.trim()) continue;
  let entry;
  try {
    entry = JSON.parse(line);
  } catch {
    continue;
  }
  const content = entry?.message?.content;
  if (entry.type !== 'assistant' || !Array.isArray(content)) continue;
  for (const block of content) {
    if (block?.type !== 'tool_use') continue;
    index += 1;
    const toolInput = block.input || {};
    if (WORK_TOOLS.includes(block.name)) lastWork = index;
    if (block.name === 'TaskUpdate' && toolInput.status === 'completed') lastWork = index;
    if (block.name === 'SendMessage' && LEAD_NAMES.includes(String(toolInput.to).toLowerCase())) {
      const text = fold(typeof toolInput.message === 'string' ? toolInput.message : '');
      const isReport = SECTIONS.every((s) => text.includes(s));
      const isWaiting = WAITING_TAGS.some((t) => text.trimStart().startsWith(t));
      if (isReport || isWaiting) lastReport = index;
    }
  }
}

const counterFile = path.join(os.tmpdir(), `flexipay-idle-${String(input.session_id || 'x').replace(/[^\w-]/g, '')}.json`);
const readCount = () => {
  try {
    return JSON.parse(fs.readFileSync(counterFile, 'utf8')).count || 0;
  } catch {
    return 0;
  }
};
const writeCount = (count) => {
  try {
    fs.writeFileSync(counterFile, JSON.stringify({ count }));
  } catch {}
};

if (lastWork <= lastReport) {
  writeCount(0);
  process.exit(0);
}

const count = readCount() + 1;
if (count > MAX_REMINDERS) {
  writeCount(0);
  process.exit(0);
}
writeCount(count);

process.stderr.write(
  `Rapport manquant (rappel ${count}/${MAX_REMINDERS}). Avant de passer au repos, envoie ton rapport à team-lead ` +
    `avec SendMessage, exactement dans ce format :\n\n` +
    `[LIVRÉ] <titre de la tâche>\n` +
    `RÉSUMÉ : 5 lignes maximum\n` +
    `FICHIERS MODIFIÉS : liste des chemins\n` +
    `VÉRIFICATIONS : commandes lancées et résultats réels\n` +
    `MESSAGES ÉCHANGÉS : avec qui, sur quoi\n` +
    `RISQUES : …\n` +
    `DÉCISIONS NÉCESSAIRES : … (ou « aucune »)\n\n` +
    `Si tu attends une réponse, envoie plutôt [BLOQUÉ], [DÉCISION] ou [QUESTION] à team-lead.\n`,
);
process.exit(2);

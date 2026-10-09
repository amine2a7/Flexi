#!/usr/bin/env node
// PreToolUse (Edit|Write|MultiEdit|NotebookEdit) : un agent de l'équipe n'écrit que dans son périmètre.
// Code de sortie 2 = blocage, le message stderr est renvoyé à l'agent.
// Les agents absents de lib/scopes.js (session principale, Explore, Plan…) ne sont pas concernés.
const path = require('path');
const readStdinJson = require('./lib/read-stdin-json');
const { LEAD_ONLY, AGENTS, ownerOf } = require('./lib/scopes');

const input = readStdinJson();
const agent = input.agent_type || input.teammate_name;
const def = agent && AGENTS[agent];
if (!def) process.exit(0);

const target = input.tool_input?.file_path || input.tool_input?.notebook_path;
if (!target) process.exit(0);

const root = process.env.CLAUDE_PROJECT_DIR || input.cwd || process.cwd();
const normalize = (p) => {
  const s = p.split(path.sep).join('/');
  return process.platform === 'win32' ? s.toLowerCase() : s;
};
const rel = normalize(path.relative(path.resolve(root), path.resolve(root, target)));
const relOriginal = path.relative(path.resolve(root), path.resolve(root, target)).split(path.sep).join('/');
const matches = (prefix) => rel === normalize(prefix) || rel.startsWith(normalize(prefix));

function block(reason) {
  process.stderr.write(
    `Bloqué : l'agent « ${agent} » ne peut pas écrire dans « ${relOriginal} » (${reason}).\n` +
      `Envoie un message au propriétaire (${ownerOf(relOriginal)}) avec ce qu'il faut changer. ` +
      `Voir docs/handoff/README.md, section Périmètres.\n`,
  );
  process.exit(2);
}

if (rel.startsWith('..') || path.isAbsolute(rel)) block('hors du projet');
if (LEAD_ONLY.some(matches)) block('fichier réservé au lead');
if (def.write.some(matches)) process.exit(0);
if (def.writeIf && def.writeIf(relOriginal)) process.exit(0);
block('hors de son périmètre');

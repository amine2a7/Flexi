#!/usr/bin/env node
// Remplace `jq -r '.a.b // empty'` : lit le JSON sur stdin et imprime la valeur au chemin donné (vide si absente).
// Usage : echo "$input" | node json-get.js tool_input.file_path
const readStdinJson = require('./read-stdin-json');

const path = (process.argv[2] || '').split('.').filter(Boolean);
let value = readStdinJson();
for (const key of path) {
  value = value !== null && typeof value === 'object' ? value[key] : undefined;
}
if (value !== undefined && value !== null) {
  process.stdout.write(typeof value === 'string' ? value : JSON.stringify(value));
}

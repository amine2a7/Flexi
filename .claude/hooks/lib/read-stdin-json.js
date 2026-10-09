// Lit l'entrée JSON d'un hook sur stdin. Renvoie {} si l'entrée est vide ou invalide.
const fs = require('fs');

module.exports = function readStdinJson() {
  try {
    const raw = fs.readFileSync(0, 'utf8');
    return raw.trim() ? JSON.parse(raw) : {};
  } catch {
    return {};
  }
};

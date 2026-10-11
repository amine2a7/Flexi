// Découpe une commande shell en segments (séparés par ; & && || | et sauts de ligne), chaque segment
// étant une liste de mots, guillemets et antislashs retirés comme le ferait bash.
// Les substitutions $(…) et `…` (hors guillemets simples) sont extraites et renvoyées comme segments
// supplémentaires : leur contenu s'exécute aussi. Ce n'est pas un interpréteur complet : il sert à
// repérer « git … commit » et ses options sans confondre un message de commit avec une option (S1-02).

function splitCommand(cmd) {
  const segments = [];
  let words = [];
  let word = '';
  let inWord = false;
  let i = 0;

  const endWord = () => {
    if (inWord) words.push(word);
    word = '';
    inWord = false;
  };
  const endSegment = () => {
    endWord();
    if (words.length) segments.push(words);
    words = [];
  };
  // Lit le contenu d'une substitution $(…) à partir de l'index de la parenthèse ouvrante.
  const readSubst = (start) => {
    let depth = 0;
    let j = start;
    let quote = null;
    for (; j < cmd.length; j++) {
      const c = cmd[j];
      if (quote) {
        if (c === '\\' && quote === '"') j++;
        else if (c === quote) quote = null;
        continue;
      }
      if (c === "'" || c === '"') quote = c;
      else if (c === '\\') j++;
      else if (c === '(') depth++;
      else if (c === ')' && --depth === 0) break;
    }
    segments.push(...splitCommand(cmd.slice(start + 1, j)));
    return j;
  };
  const readBacktick = (start) => {
    let j = start + 1;
    while (j < cmd.length && cmd[j] !== '`') j += cmd[j] === '\\' ? 2 : 1;
    segments.push(...splitCommand(cmd.slice(start + 1, j)));
    return j;
  };

  while (i < cmd.length) {
    const c = cmd[i];
    if (c === "'") {
      const end = cmd.indexOf("'", i + 1);
      const stop = end === -1 ? cmd.length : end;
      word += cmd.slice(i + 1, stop);
      inWord = true;
      i = stop + 1;
      continue;
    }
    if (c === '"') {
      inWord = true;
      i++;
      while (i < cmd.length && cmd[i] !== '"') {
        if (cmd[i] === '\\' && i + 1 < cmd.length && '"\\$`\n'.includes(cmd[i + 1])) {
          word += cmd[i + 1];
          i += 2;
        } else if (cmd[i] === '$' && cmd[i + 1] === '(') {
          i = readSubst(i + 1) + 1;
          word += '$()';
        } else if (cmd[i] === '`') {
          i = readBacktick(i) + 1;
          word += '``';
        } else {
          word += cmd[i++];
        }
      }
      i++;
      continue;
    }
    if (c === '\\') {
      if (cmd[i + 1] === '\n') {
        i += 2;
        continue;
      }
      word += cmd[i + 1] ?? '';
      inWord = true;
      i += 2;
      continue;
    }
    if (c === '$' && cmd[i + 1] === '(') {
      i = readSubst(i + 1) + 1;
      word += '$()';
      inWord = true;
      continue;
    }
    if (c === '`') {
      i = readBacktick(i) + 1;
      word += '``';
      inWord = true;
      continue;
    }
    if (c === ';' || c === '&' || c === '|' || c === '\n' || c === '(' || c === ')') {
      endSegment();
      i++;
      continue;
    }
    if (c === ' ' || c === '\t' || c === '\r') {
      endWord();
      i++;
      continue;
    }
    word += c;
    inWord = true;
    i++;
  }
  endSegment();
  return segments;
}

module.exports = { splitCommand };

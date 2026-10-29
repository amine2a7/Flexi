// Découpe une commande shell en segments (séparés par ; & && || | et sauts de ligne), chaque segment
// étant une liste de mots, guillemets et antislashs retirés comme le ferait bash.
// Les substitutions $(…) et `…` (hors guillemets simples) sont extraites et renvoyées comme segments
// supplémentaires : leur contenu s'exécute aussi. Ce n'est pas un interpréteur complet : il sert à
// repérer « git … commit » et ses options sans confondre un message de commit avec une option (S1-02).
// Heredoc (S1-10) : le corps n'est pas découpé en commandes ; il est rangé dans la propriété
// `heredoc` du segment qui le reçoit. Délimiteur sans guillemets : seules les substitutions du corps
// sont extraites (elles s'exécutent). L'appelant décide s'il faut analyser le corps (bash, psql…).

// Extrait les substitutions $(…) et `…` d'un texte non découpé (corps de heredoc sans guillemets).
function extractSubstitutions(text) {
  const found = [];
  for (let k = 0; k < text.length; k++) {
    if (text[k] === '\\') {
      k++;
    } else if (text[k] === '$' && text[k + 1] === '(') {
      let depth = 0;
      let j = k + 1;
      for (; j < text.length; j++) {
        if (text[j] === '(') depth++;
        else if (text[j] === ')' && --depth === 0) break;
      }
      found.push(...splitCommand(text.slice(k + 2, j)));
      k = j;
    } else if (text[k] === '`') {
      const end = text.indexOf('`', k + 1);
      const stop = end === -1 ? text.length : end;
      found.push(...splitCommand(text.slice(k + 1, stop)));
      k = stop;
    }
  }
  return found;
}

function splitCommand(cmd) {
  const segments = [];
  let words = [];
  let word = '';
  let inWord = false;
  let i = 0;
  const pending = []; // heredocs ouverts sur la ligne courante : { delim, quoted, stripTabs, owner }

  // Lit les corps des heredocs en attente à partir de l'index `start` (début de la ligne suivante).
  const readHeredocBodies = (start) => {
    let pos = start;
    for (const h of pending) {
      const lines = [];
      while (pos < cmd.length) {
        const nl = cmd.indexOf('\n', pos);
        const end = nl === -1 ? cmd.length : nl;
        let line = cmd.slice(pos, end).replace(/\r$/, '');
        if (h.stripTabs) line = line.replace(/^\t+/, '');
        pos = end + 1;
        if (line === h.delim) break;
        lines.push(line);
      }
      const body = lines.join('\n');
      h.owner.heredoc = h.owner.heredoc ? `${h.owner.heredoc}\n${body}` : body;
      if (!h.quoted) segments.push(...extractSubstitutions(body));
    }
    pending.length = 0;
    return pos;
  };

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
    // Heredoc « <<DELIM », « <<-DELIM », « <<'DELIM' », « <<"DELIM" », « <<\DELIM » (pas « <<< »).
    if (c === '<' && cmd[i + 1] === '<' && cmd[i + 2] !== '<') {
      endWord();
      let j = i + 2;
      const stripTabs = cmd[j] === '-';
      if (stripTabs) j++;
      while (cmd[j] === ' ' || cmd[j] === '\t') j++;
      let delim = '';
      let quoted = false;
      if (cmd[j] === "'" || cmd[j] === '"') {
        const q = cmd[j];
        const end = cmd.indexOf(q, j + 1);
        const stop = end === -1 ? cmd.length : end;
        delim = cmd.slice(j + 1, stop);
        quoted = true;
        j = stop + 1;
      } else {
        if (cmd[j] === '\\') {
          quoted = true;
          j++;
        }
        while (j < cmd.length && !/[\s;&|<>()]/.test(cmd[j])) delim += cmd[j++];
      }
      if (delim) pending.push({ delim, quoted, stripTabs, owner: words });
      i = j;
      continue;
    }
    if (c === '\n' && pending.length) {
      endSegment();
      i = readHeredocBodies(i + 1);
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

module.exports = { splitCommand, extractSubstitutions };

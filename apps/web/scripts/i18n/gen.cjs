// Generates apps/web/src/messages/{fr,en,ar}/<namespace>.json from the trilingual sources ns-*.cjs
// ([fr, en, ar] per leaf). Run: node apps/web/scripts/i18n/gen.cjs
const fs = require("fs");
const path = require("path");
const OUT = path.join(__dirname, "..", "..", "src", "messages");
const NS = {};
for (const file of fs
  .readdirSync(__dirname)
  .filter((f) => f.startsWith("ns-") && f.endsWith(".cjs"))) {
  Object.assign(NS, require(path.join(__dirname, file)));
}

const LOCALES = ["fr", "en", "ar"];
function pickLocale(node, index, where) {
  if (Array.isArray(node)) {
    if (node.length !== 3) throw new Error(`3 textes attendus en ${where}`);
    return node[index];
  }
  if (typeof node === "string") return node; // identique dans les trois langues
  return Object.fromEntries(
    Object.entries(node).map(([k, v]) => [
      k,
      pickLocale(v, index, `${where}.${k}`),
    ]),
  );
}

for (const [i, locale] of LOCALES.entries()) {
  fs.mkdirSync(path.join(OUT, locale), { recursive: true });
  for (const [ns, tree] of Object.entries(NS)) {
    fs.writeFileSync(
      path.join(OUT, locale, `${ns}.json`),
      JSON.stringify(pickLocale(tree, i, ns), null, 2) + "\n",
    );
  }
  const names = Object.keys(NS);
  const index =
    names.map((ns) => `import ${camel(ns)} from './${ns}.json';`).join("\n") +
    `\n\nconst messages = {\n${names.map((ns) => `  ${ns.includes("-") ? `'${ns}'` : ns}: ${camel(ns)},`).join("\n")}\n};\n\nexport default messages;\n`;
  fs.writeFileSync(path.join(OUT, locale, "index.ts"), index);
}
function camel(s) {
  return s.replace(/-([a-z])/g, (_, c) => c.toUpperCase());
}
console.log("ok", Object.keys(NS).join(", "));

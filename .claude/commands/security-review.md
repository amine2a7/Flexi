---
description: Revue de sécurité du diff courant
argument-hint: [sujet ou liste de fichiers]
---
Fais relire `$ARGUMENTS` (par défaut : `git diff main...HEAD` ; sans dépôt git, la liste de fichiers fournie) par l'agent `securite` :
- si un coéquipier `securite` est actif dans l'équipe, envoie-lui un `[LIVRÉ]` (fichiers, comment tester) ;
- sinon, lance le sous-agent `securite`.

Lance aussi `pnpm audit --prod` et `gitleaks detect --no-banner` si disponibles.
La revue est écrite dans `docs/handoff/reviews/securite-<sujet>-<AAAA-MM-JJ>.md`.
Présente les constats par sévérité (Critique / Haute / Moyenne / Basse) avec scénario d'attaque, ce qui n'a pas pu être vérifié, puis le verdict `BLOQUANT` ou `OK`. Ne corrige rien sans mon accord.

---
description: Checklist avant livraison d'une phase
argument-hint: <phase, ex. 3>
---
Pour la phase `$ARGUMENTS` de `docs/roadmap.md` :
1. Vérifie que chaque critère de fin est atteint (tests, démo, doc).
2. Lance `pnpm lint && pnpm typecheck && pnpm test`, `flutter analyze && flutter test`.
3. Lance `/security-review` et `/ledger-audit`.
4. Vérifie `docs/security/checklist-asvs.md` pour les points concernés.
5. Liste ce qui reste et les risques. Verdict : PRÊT / NON PRÊT.

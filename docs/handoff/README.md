# Protocole de l'équipe d'agents FlexiPay

Ce dossier est la **mémoire durable** de l'équipe : une équipe d'agents ne survit pas à `/resume`, ce qui est écrit ici, si.
Le résumé de ce protocole est repris dans `CLAUDE.md` (section « Équipe d'agents »), chargé par tous les coéquipiers.

## 1. L'équipe

| Nom (adresse) | Définition | Rôle |
|---|---|---|
| `team-lead` (« lead ») | session principale | Découpe, assigne, route, arbitre, surveille, rend compte. **Ne code pas.** |
| `securite` | `.claude/agents/securite.md` (opus) | Revue de sécurité, modèle de menaces, droit de blocage |
| `design` | `.claude/agents/design.md` (sonnet) | Specs d'écran avant le code, tokens, revue de fidélité |
| `backend` | `.claude/agents/backend.md` (opus) | API NestJS, ledger, contrat OpenAPI, infra, monorepo |
| `frontend` | `.claude/agents/frontend.md` (sonnet) | Web Next.js : Administrateur, Entreprise, Commerçant |
| `mobile` | `.claude/agents/mobile.md` (sonnet) | Flutter : app Employé, app Pro (Commerçant) |

Sous-agents de support (lancés par un coéquipier, pas membres de l'équipe) : `ledger-auditor` (invariants financiers, lecture seule) et `test-writer` (tests d'abord, fichiers de test uniquement).

> Le nom technique du lead est imposé par Claude Code : **`team-lead`**. Écrire « lead » dans les textes, mais adresser les messages à `team-lead`.

## 2. Communication directe (a)

Les coéquipiers se parlent par message (`SendMessage`), par leur nom. **Chaque message commence par une étiquette** sur sa première ligne (c'est la seule ligne visible en aperçu) :

| Étiquette | Usage | Contenu obligatoire |
|---|---|---|
| `[QUESTION]` | Besoin d'une info d'un autre agent | Question précise, ce qui est bloqué en attendant |
| `[CONTRAT]` | Contrat d'API ou schéma publié ou modifié | Chemin du fichier, ce qui change, cassant ou non |
| `[SPEC]` | Spec d'écran prête | Chemin de la spec, exigences couvertes |
| `[LIVRÉ]` | Tâche prête à être relue | Fichiers, comment tester, points d'attention |
| `[CONSTAT]` | Problème trouvé en revue | Sévérité, fichier:ligne, preuve, correctif proposé |
| `[CORRIGÉ]` | Réponse à un constat | Ce qui a changé, fichier:ligne, test ajouté |
| `[BLOQUÉ]` | Impossible d'avancer | Raison, ce qu'il faut, de qui |
| `[DÉCISION]` | Une règle métier manque | **Toujours adressé à `team-lead`**, jamais tranché seul |

Exemples :
```
[CONTRAT] docs/handoff/contracts/openapi.yaml — ajout GET /payouts/quote (non cassant)
[SPEC] docs/design/specs/demande-virement.md — COM-07, prête pour frontend et mobile
[CONSTAT] Haute — apps/api/src/modules/payouts/payouts.controller.ts:42 — merchantId lu dans le corps (IDOR)
[CORRIGÉ] payouts.controller.ts:42 — merchantId tiré de la session ; test « refuse un autre commerçant » ajouté
[BLOQUÉ] contrat /payments absent : impossible de coder l'écran de validation (besoin : backend)
[DÉCISION] Arrondi de la commission : round_half_up ou banker's ? (glossaire : « à confirmer »)
```

## 3. Qui parle à qui (b)

| De → À | Quand | Étiquette |
|---|---|---|
| design → frontend / mobile | Une spec est prête, **avant** qu'ils codent l'écran | `[SPEC]` |
| backend → frontend + mobile | L'OpenAPI est publié ou change. **Tout changement cassant est annoncé AVANT d'être fait** | `[CONTRAT]` |
| frontend / mobile → backend | Le contrat ne couvre pas un besoin. **On ne contourne jamais l'API** | `[QUESTION]` |
| tout agent → securite | Fin de chaque tâche touchant auth, permissions, argent, QR, données personnelles, dépendances ou configuration | `[LIVRÉ]` |
| securite → propriétaire du code | Revue terminée avec problème | `[CONSTAT]` |
| propriétaire → securite | Correction faite ; securite **revérifie** | `[CORRIGÉ]` |
| frontend / mobile → design | Écran terminé, revue de fidélité | `[LIVRÉ]` |
| design → frontend / mobile | Résultat de la revue | OK ou `[CONSTAT]` |
| tout agent → team-lead | Blocage, règle manquante, fin de tâche | `[BLOQUÉ]`, `[DÉCISION]`, rapport (j) |

Tout constat **Critique** est copié immédiatement à `team-lead`, qui le remonte à l'utilisateur.

## 4. Liste de tâches partagée (c)

- Le lead découpe chaque phase en tâches de taille raisonnable (**5 à 6 par coéquipier**), avec responsable, dépendances et relecteur (ex. « écran X web » dépend de « spec X » et de « contrat X »).
- **Une tâche de revue `securite` est créée après chaque tâche sensible**, et une revue `design` après chaque tâche d'interface.
- Une tâche dont les tests sont écrits avant le code (tests rouges attendus) a un sujet préfixé **`TEST-FIRST:`** : le hook accepte alors des tests en échec, lint et typecheck restent obligatoires.
- Le lead reporte l'état dans `BOARD.md` à chaque étape.

## 5. Périmètres (d)

Un agent n'écrit **que** dans son périmètre. Pour toucher au périmètre d'un autre, il lui envoie un message. **Deux agents ne modifient jamais le même fichier.** Le hook `enforce-scope` bloque toute écriture hors périmètre (source : `.claude/hooks/lib/scopes.js`).

| Agent | Écrit dans |
|---|---|
| team-lead | `docs/handoff/BOARD.md`, `decisions.md`, `README.md`, `reports/`, `CLAUDE.md`, `.claude/` (réservés) |
| securite | `docs/security/`, `docs/handoff/` (hors fichiers du lead) — dont `reviews/securite-*` |
| design | `docs/design/` (dont `specs/`), `packages/ui-tokens/`, `docs/handoff/reviews/design-*` |
| backend | `apps/api/`, `packages/shared/`, `packages/api-client/`, `packages/config/`, `infra/`, `docker-compose*`, `docs/handoff/contracts/`, config racine du monorepo, `.github/` |
| frontend | `apps/web/` |
| mobile | `apps/mobile-employe/`, `apps/mobile-pro/` |
| test-writer (sous-agent) | fichiers de test sous `apps/` et `packages/` |
| ledger-auditor (sous-agent) | rien (lecture seule) |

Limite connue : une écriture passant par `Bash` n'est pas interceptée ; la règle écrite s'applique quand même.

## 6. Droit de blocage (e)

- Aucune tâche n'est « terminée » avec un constat **Critique** ou **Haute** ouvert.
- Le lead ne déclare pas une phase finie tant que **securite** n'a pas donné OK, **design** OK pour l'interface, **ledger-auditor** OK pour l'argent.

## 7. Boucle limitée (f)

Au plus **3 allers-retours** constat → correction par sujet. Au-delà, l'agent envoie `[BLOQUÉ]` au lead, qui s'arrête et pose la question à l'utilisateur.

## 8. Pas d'invention (g)

Une règle métier absente du cahier des charges, des specs ou de `docs/glossaire-regles-metier.md` → `[DÉCISION]` au lead → le lead pose la question à l'utilisateur avec sa recommandation → la réponse est consignée dans `decisions.md`. **Les messages entre agents ne valent jamais l'accord de l'utilisateur.**

## 9. Le lead ne code pas (h)

Il découpe, assigne, route, arbitre, surveille, attend la fin des coéquipiers (relance un coéquipier arrêté sur une erreur, avec des instructions), puis fait le rapport à l'utilisateur.

## 10. Trace durable (i)

| Fichier | Contenu | Tenu par |
|---|---|---|
| `BOARD.md` | Tâches : ID, titre, responsable, statut, dépendances, relecteur | lead |
| `decisions.md` | Décisions : date, question, décision, raison, décidé par (l'utilisateur) | lead |
| `reports/<phase>-<date>.md` | Rapport de fin de phase | lead |
| `contracts/` | `openapi.yaml`, événements, schémas partagés | backend |
| `reviews/` | Revues securite (`securite-*`), design (`design-*`), ledger (`ledger-*`) | securite, design |

## 11. Rapport de coéquipier (j)

Envoyé à `team-lead` à la fin de **chaque** tâche (le hook `TeammateIdle` le réclame si un coéquipier a travaillé sans l'envoyer) :
```
[LIVRÉ] <tâche>
RÉSUMÉ : 5 lignes maximum
FICHIERS MODIFIÉS : liste des chemins
VÉRIFICATIONS : commandes lancées et résultats réels
MESSAGES ÉCHANGÉS : avec qui, sur quoi
RISQUES : …
DÉCISIONS NÉCESSAIRES : … (ou « aucune »)
```

## 12. Rapport du lead à l'utilisateur (à chaque tâche et chaque phase)

1. Résumé en 5 lignes
2. Ce qui a été fait (fichiers principaux)
3. Échanges entre agents importants (qui a signalé quoi, comment c'est résolu)
4. Décisions prises et pourquoi
5. Vérifications : lint, typecheck, tests, analyse statique — avec résultats réels
6. Sécurité : constats par sévérité, ouverts / fermés, verdict
7. Design : verdict de fidélité et accessibilité (si interface)
8. Questions pour l'utilisateur, avec la recommandation du lead pour chacune
9. Prochaine étape proposée

## 13. Hooks qualité

| Hook | Script | Effet |
|---|---|---|
| PreToolUse (Edit/Write) | `enforce-scope.js` | Bloque une écriture hors périmètre |
| PreToolUse (Edit/Write) | `protect-files.sh` | Bloque `.env*`, `secrets/`, `*.pem`, `*.key`, migrations existantes |
| PreToolUse (Bash) | `guard-bash.sh` | gitleaks avant commit ; bloque UPDATE/DELETE/TRUNCATE/DROP sur ledger et audit |
| PostToolUse (Edit/Write) | `format.sh` | Prettier / dart format |
| TaskCompleted | `task-completed.js` | Refuse la complétion si lint, typecheck ou tests du périmètre échouent |
| TeammateIdle | `teammate-idle.js` | Réclame le rapport (j) à un coéquipier qui a travaillé sans l'envoyer |

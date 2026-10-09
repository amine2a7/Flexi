# Rapport — Phase 0, passe « équipe réduite » (2026-10-09)

Équipe : `design`, `securite`, `backend` (frontend et mobile non lancés). Lead : session principale (adresse réelle `main`).
Contexte : pnpm bloqué par Device Guard, Docker et Flutter absents sur le PC d'entreprise ; décision utilisateur : aucun contournement, documentation seulement.

## 1. Résumé
- 5 tâches terminées : P0-D2, P0-D3 (specs), P0-B5 (contrat OpenAPI), P0-S5 (modèle de menaces), P0-S6 (revue du contrat).
- Contrat `openapi.yaml` final (SHA-256 `e8b0a175…68e1`, 1 159 lignes) : verdict securite **OK**, 11 constats fermés en 3 allers-retours.
- Specs D2/D3 alignées sur le contrat (montants `*Millimes`, erreurs RFC 9457, `PAYMENT_DECLINED` côté commerçant).
- Tokens : correction de 3 paires de badges non conformes AA (recalcul indépendant du lead : mêmes valeurs).
- 15 décisions utilisateur en attente ; 9 constats Moyenne/Basse ouverts sur la chaîne de dev (CF-01..CF-09).

## 2. Livrables
| Fichier | Auteur |
|---|---|
| `docs/design/specs/fondations-composants.md` | design |
| `docs/design/specs/navigation.md` | design |
| `docs/design/design-tokens.json` (ajouts + correction AA, aucune valeur de couleur existante modifiée) | design |
| `docs/handoff/contracts/openapi.yaml` | backend |
| `docs/security/modele-de-menaces.md` (v2), `docs/security/checklist-asvs.md` | securite |
| `docs/handoff/reviews/securite-p0-b5-contrat-2026-10-09.md` | securite |

## 3. Échanges importants
- **Test de périmètre** : design → écriture dans `apps/` bloquée par `enforce-scope` (agent_type reçu). Aucun fichier créé.
- **design ↔ backend** : formats montant et erreur négociés (3 questions, 2 `[CONTRAT]`), `PAYMENT_DECLINED` intégré dans D2/D3.
- **securite → backend** : S6-01..S6-10 (1er tour) fermés ; S6-11 (Moyenne, double exécution par reprise de bail d'idempotence) ouvert au 2e tour, fermé au 3e (jeton de clôture sous `FOR UPDATE`, bail > délais max, UNIQUE composite).
- **securite → lead** : CF-01..CF-09 sur `.claude/` et `.gitignore` (non corrigés : configuration relevant de l'utilisateur).
- **Contradiction détectée** : cahier COM-04 (« solde disponible » au commerçant) vs règle 9 et S6-10.

## 4. Vérifications (réelles)
- SHA-256 du contrat recalculé par le lead : identique à la version relue par securite. Aucun `type: number` / `float` / `double`.
- Contrastes WCAG recalculés par le lead (11 paires) : conformes aux valeurs annoncées par design.
- JSON des tokens valide.
- Non vérifié : validation OpenAPI par outil (pas de pnpm), génération des clients, toute implémentation.

## 5. Écarts au protocole constatés
- L'adresse du lead est `main` (pas `team-lead`) : les agents nommés sont des sous-agents en arrière-plan, relancés par message. `teammate-idle.js` accepte désormais `main`.
- Les hooks `TaskCompleted` et `TeammateIdle` **n'ont pas été observés** en action (pas de liste de tâches partagée ; aucun compteur de rappel créé). La qualité a reposé sur les rapports et les revues.
- `enforce-scope` a bloqué une écriture de backend dans le scratchpad (hors projet) : comportement attendu.

## 6. Décisions en attente (voir rapport à l'utilisateur)
ASVS 4.0.3/5.0 · données de dev synthétiques · `google-services.json` · format montants EN/AR · membre famille (solde/limite, barre basse) · toasts d'erreur · historique commerçant · tokens · multi-tenant utilisateur · unicité composite de l'idempotence (spec 02) · COM-04 · fuseau horaire · statut CONFIRMED · texte C.8.11 · CF-01..CF-09.

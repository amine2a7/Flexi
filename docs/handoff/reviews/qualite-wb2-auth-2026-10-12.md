# Revue qualité WB2 (auth / Commun) : client régénéré depuis le contrat 0.2.0 puis 0.2.1

- **Date** : 2026-10-12
- **Relecteur** : qualite
- **Branche** : `feat/web` (aucun commit, aucun push, aucun changement de branche)
- **Base de revue** : `[LIVRÉ]` de backend (WB2) ; `packages/api-client/src/generated/schema.ts`, `packages/api-client/src/index.ts`, `packages/api-client/test/client.test.ts` ; `docs/handoff/contracts/openapi.yaml` (lecture seule : sa relecture fonctionnelle et de sécurité relève de securite et conformite)
- **Propriétaire** : `backend`

## Verdict

**OK** (aucun Bloquant). Après revérification (aller-retour 1 sur 3) : **WB2-01 fermé**, aucun constat ouvert.

- Le client est régénéré (11 routes `/v1/auth/*` et `/v1/me`) et le test de fraîcheur est vert : le fichier commité correspond au contrat (0.2.1 après les constats de securite).
- `LoginResult` est généré en union `MfaChallengeResult | SessionResult`. Le test de connexion distingue les deux cas par `nextStep` : il ne compilerait pas si ce rétrécissement de type ne fonctionnait pas.
- WB1-04 est soldé : les en-têtes CSRF et canal sont vérifiés sur la requête réellement envoyée par `createApiClient` (`POST /v1/auth/logout`).
- 17 listes de valeurs d'énumération sont générées à l'exécution (`enumValues`).
- Données de test synthétiques.

## Constat

```
[CONSTAT] WB2-01 En-tête de canal à répéter à chaque appel
Gravité : Amélioration — FERMÉ le 2026-10-12
Fichier : packages/api-client/test/client.test.ts:157, :176 (usage) ; contrat ClientChannel (openapi.yaml:1012-1022)
Problème : `X-FlexiPay-Client` est obligatoire sur 9 opérations et typé comme paramètre requis :
  sans constante, la chaîne littérale serait recopiée dans chaque appel du front.
Correctif proposé : constante typée exportée par `packages/api-client`.
Référence : qualite §3
```

Revérification : `WEB_CHANNEL_HEADER = { 'X-FlexiPay-Client': 'web' } as const` est exporté par `src/index.ts:42` (son usage est documenté en `:40`) et utilisé dans `test/client.test.ts:163` et `:182`.

## Question de backend : test de lint du contrat dans api-client ?

Avis qualite : non. Il vaut mieux une étape de B6 (CI), avec une version épinglée de l'outil.
Backend est d'accord : `@redocly/cli`, épinglé, en B6, sous réserve de la validation de l'utilisateur (S1-03).

## Commandes et résultats (lancées par qualite, 2026-10-12)

| Commande | Revue initiale | Revérification |
|---|---|---|
| `turbo run lint --force` (api-client, puis `./packages/*` et `./infra/*`) | réussi | 5/5 |
| `turbo run typecheck --force` | réussi | 4/4 |
| `turbo run test --force` | api-client **13/13** | api-client 13/13, ui-tokens 87/87, shared 47/47, testing-infra 12/12, config 3/3 |
| `turbo run build --force` | réussi | 4/4 |

## Non vérifié

1. `redocly lint` : non relancé, l'outil n'est pas une dépendance directe.
2. Contenu du contrat 0.2.1 : hors périmètre qualite (securite, conformite).
3. Racine complète : `apps/web` est en cours chez frontend et n'a pas encore été livré.
4. Couverture mesurée : `@vitest/coverage-v8` absent du workspace.

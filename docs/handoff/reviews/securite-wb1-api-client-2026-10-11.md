# Revue securite : WB1, `packages/api-client` (client TypeScript généré)

- **Date** : 2026-10-11
- **Relecteur** : securite
- **Branche** : `feat/web` (aucun commit ni push de securite)
- **Base de revue** : fichiers du `[LIVRÉ]` de backend (`packages/api-client/**`, `pnpm-lock.yaml`)
- **Propriétaire** : backend

## Verdict : **OK**

Aucun constat Critique, Haute, Moyenne ni Basse.

## Contrôles

| Point | Résultat |
|---|---|
| Dépendance runtime `openapi-fetch` 0.17.0 | Publiée le 2026-02-11 ; mainteneurs `drewpowers`, `gzm0` (+ `mpaucot`) ; dépôt `openapi-ts/openapi-typescript` ; une seule transitive (`openapi-typescript-helpers` 0.1.0, types) |
| Dépendance dev `openapi-typescript` 7.13.0 | Même dépôt et mêmes mainteneurs, 2026-02-11 ; 23 transitives (redocly, js-yaml 4.3.2…), âge contrôlé par backend (0 paquet de moins de 14 jours) |
| Scripts d'installation | `onlyBuiltDependencies: []` inchangé (SC-3) |
| Lockfile | Aucune URL hors `registry.npmjs.org`, aucun `tarball` ; intégrités `sha512` (SC-5) |
| Génération (SC-9) | Lecture d'un fichier local (`pathToFileURL`) ; contrat sans `$ref` distant (toutes les références sont `#/…`) : aucun accès réseau pendant la génération ; fichier généré commité et comparé octet à octet (test de fraîcheur) |
| Session web | `credentials: 'include'` : cookies HttpOnly, aucun jeton lisible par JS ni placé dans l'URL |
| CSRF | `X-CSRF-Token` seulement sur POST/PUT/PATCH/DELETE, depuis un getter en mémoire ; absent sur GET (testé) ; rien n'est écrit dans `localStorage` |
| Montants | Aucun `bigint` dans les types générés (test) : `number` entier, conforme au contrat (0..2^53-1) |
| Erreurs | `isProblem` : garde de type RFC 9457 ; le client ne lit que `code` et `messageKey` |
| Secrets | `gitleaks dir --redact packages/api-client/src` → aucune fuite |

Remarques sans constat :
- `baseUrl` doit rester une constante de configuration, jamais une valeur venant de l'utilisateur ou
  de l'URL : avec `credentials: 'include'`, une origine contrôlable recevrait les cookies et le
  jeton CSRF. Cette règle est documentée dans `ApiClientOptions` et sera vérifiée en F1 (apps/web).
- Le peer `typescript ^5` d'openapi-typescript n'est pas satisfait (6.0.3) : c'est un risque de
  fonctionnement, pas de sécurité. Le test de fraîcheur détecterait une génération qui diverge.
- **Lockfile** : il contient déjà l'importer `apps/web` (next 16.3.6, next-intl, sharp 0.35.5,
  react 19.3.0, lucide-react…), résolu lors du `pnpm add` de backend. Ces dépendances **ne sont pas
  couvertes par cette revue** : je les relirai en F1 (âge, mainteneurs, scripts d'installation, dont
  sharp). Elles ne doivent pas être commitées comme validées avant cette revue.

## Vérifications

- `pnpm --filter @flexipay/api-client test` → 9/9 (2 fichiers).
- `npm view <paquet> time|maintainers|repository.url` pour openapi-fetch, openapi-typescript et
  openapi-typescript-helpers.
- Recherche de `$ref` non locaux dans `docs/handoff/contracts/openapi.yaml` → aucun.

## Non vérifié

1. `pnpm audit` : refusé dans ma session ; le résultat « aucune vulnérabilité » vient de backend.
2. Âge des 23 transitives d'openapi-typescript : non recontrôlé un par un (contrôle de backend).
3. Dépendances de l'importer `apps/web` présentes dans le lockfile : reportées à la revue F1.

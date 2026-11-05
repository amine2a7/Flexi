# @flexipay/web

Web app FlexiPay (espaces Administrateur, Entreprise, Commerçant) : Next.js App Router, TypeScript strict, Tailwind sur le preset `@flexipay/ui-tokens`, next-intl (FR par défaut, AR en RTL, EN). Le web parle **uniquement** à l'API : aucune donnée simulée dans l'application.

## Voir l'app
```bash
pnpm install
pnpm demo      # base locale vidée, migrations, seed démo, API puis web ; affiche l'URL et les comptes
```
`pnpm --filter @flexipay/web dev` seul vise l'API de `NEXT_PUBLIC_API_BASE_URL` (défaut `http://localhost:3000`). Données de démo : `docs/demo/donnees-demo.md`.

## Commandes
| Commande | Rôle |
|---|---|
| `pnpm --filter @flexipay/web lint` / `typecheck` / `test` | ESLint, `next typegen` + `tsc`, Vitest (dont le test de build de production, ~15 s) |
| `pnpm --filter @flexipay/web build` | Build de production (panneaux de développement exclus) |
| `pnpm --filter @flexipay/web test:build` | Contrôle du résultat du build (aucun panneau de développement dans les bundles) : à lancer **après** `build` (tâche Turbo qui en dépend, ne jamais en parallèle de `typecheck` ni de `dev`) |
| `pnpm --filter @flexipay/web test:e2e` | Playwright : serveur de dev sur l'API de démo (`pnpm demo` lancé) + build de production servi par `next start` (CSP) |
| `pnpm --filter @flexipay/web test:e2e:install` | Installe Chromium. Disque système plein : `PLAYWRIGHT_BROWSERS_PATH=D:/pw-browsers` (voir plus bas) |

Télémétrie Next désactivée : `NEXT_TELEMETRY_DISABLED=1` (ou `pnpm exec next telemetry disable`).

## Règles de la base de code
- **Aucune couleur, espacement ni texte en dur** : classes Tailwind issues des tokens, textes dans `src/messages/<langue>/<espace-de-noms>.json` (FR de référence ; AR et EN doivent avoir exactement les mêmes clés). `test/conventions` et `test/i18n` le vérifient.
- **RTL** : propriétés logiques uniquement (`ms-`, `pe-`, `text-start`…), `<html dir>` posé par la locale.
- **Pas de stockage navigateur** (`sessionStorage`, `document.cookie`) : la session est dans des cookies HttpOnly posés par l'API. Seule exception : `localStorage` pour les catégories ouvertes du menu (`src/lib/ui/menu-state.ts`, préférence d'affichage).
- **Aucune donnée simulée dans l'application** : les tests unitaires gardent leurs réponses simulées dans `test/`. Les panneaux de développement (comptes de démo) n'entrent pas dans le build de production (`test/build/no-mocks-in-production.test.ts`).
- **Sécurité** (`src/lib/security/headers.ts`, `src/proxy.ts`) : CSP à nonce (par requête, sans `unsafe-inline` ni `unsafe-eval` en production), `frame-ancestors 'none'`, Referrer-Policy `no-referrer`, nosniff, HSTS en production, Permissions-Policy, COOP/CORP. Les pages sont rendues à chaque requête (`connection()`).

## Navigateurs Playwright hors du disque C:
`PLAYWRIGHT_BROWSERS_PATH=D:/pw-browsers pnpm --filter @flexipay/web test:e2e:install`. Si le téléchargement expire (réseau lent), télécharger l'archive `chrome-win64.zip` indiquée par `pnpm exec playwright install --dry-run chromium`, l'extraire dans `<PLAYWRIGHT_BROWSERS_PATH>/chromium-<version>/` et y créer un fichier vide `INSTALLATION_COMPLETE`. La config utilise `channel: 'chromium'` (pas besoin du « headless shell »).

# Guide du code FlexiPay

Pour un développeur qui découvre le projet. État au **12/10/2026**, branche `feat/web`, équipe en pause.
Légende : ✅ commité · 🟡 écrit mais **pas encore commité** (en cours ou en revue) · ⬜ pas encore créé.

## 1. Arborescence

```
Flexi/
├── package.json, pnpm-workspace.yaml, turbo.json, tsconfig.base.json   ✅ racine du monorepo (pnpm + Turborepo)
├── CLAUDE.md                ✅ règles du projet (argent en millimes, sécurité, i18n, équipe d'agents)
├── .githooks/               ✅ pre-commit (scan de secrets) · 🟡 pre-push (en attente de votre commit)
├── .claude/                 ✅ agents, hooks, permissions de l'équipe d'agents
├── apps/
│   ├── web/                 🟡 site Next.js (Administrateur, Entreprise, Commerçant) — détail §2
│   ├── api/                 ⬜ API NestJS (tâche B3)
│   ├── mobile-employe/      ⬜ app Flutter Employé (reportée)
│   └── mobile-pro/          ⬜ app Flutter Commerçant (reportée)
├── packages/
│   ├── config/              ✅ ESLint + Prettier communs (🟡 ajout de la règle no-console)
│   │   ├── eslint.js        règles partagées (interdit toFixed, parseFloat, eval)
│   │   └── prettier.js
│   ├── shared/              ✅ argent et constantes communes à l'API et au web
│   │   ├── src/money.ts     millimes (1 TND = 1 000), schéma Zod des montants
│   │   ├── src/rate.ts      taux en points de base (200 bps = 2 %)
│   │   ├── src/enums.ts     devise, sens d'une écriture, fuseau Africa/Tunis
│   │   └── test/            47 tests
│   ├── ui-tokens/           ✅ charte → code (🟡 dernières retouches de design)
│   │   ├── src/             générateur (tokens.ts lit le JSON, tailwind.ts, dart.ts)
│   │   ├── generated/       tailwind-preset.cjs : le preset utilisé par apps/web
│   │   ├── dart/lib/        flexipay_tokens.dart : le thème des futures apps Flutter
│   │   └── test/            87 tests, dont le contraste WCAG AA
│   └── api-client/          🟡 client TypeScript généré depuis le contrat OpenAPI
│       ├── scripts/codegen.ts      génère src/generated/schema.ts
│       ├── src/index.ts            createApiClient, isProblem, WEB_CHANNEL_HEADER
│       └── test/                   13 tests, dont « le client est à jour avec le contrat »
├── infra/                   ✅ docker-compose.yml (PostgreSQL 16, Redis), .env.example, testing/ (Testcontainers)
└── docs/                    ✅ cahier des charges, specs, design, sécurité, protocole de l'équipe
    ├── design/specs/        specs d'écran : 2 ✅ (fondations, navigation), 15 🟡 (Commun, Commerçant, composants)
    └── handoff/contracts/openapi.yaml   contrat de l'API ✅ (🟡 version 0.2.1 avec l'authentification)
```

## 2. Le frontend web (`apps/web`) 🟡

C'est un projet **Next.js (App Router)**. Aujourd'hui c'est un squelette : une page d'accueil provisoire, la page 404, les langues, la sécurité et les données fictives. Les vrais écrans arrivent avec F2 et WF1 à WF5.

```
apps/web/
├── src/
│   ├── app/[locale]/        les pages (une URL = un dossier)
│   │   ├── layout.tsx       cadre commun : <html lang dir>, polices, traductions, données fictives
│   │   ├── page.tsx         page d'accueil provisoire (/fr, /ar, /en)
│   │   ├── not-found.tsx    page 404 traduite
│   │   ├── error.tsx        page d'erreur 500 traduite
│   │   └── [...rest]/page.tsx   toute URL inconnue → 404
│   ├── app/globals.css      styles de base (fond, police, focus visible, animations réduites)
│   ├── app/fonts.ts         polices Inter (latin) et IBM Plex Sans Arabic
│   ├── components/layout/   composants de mise en page (skip-link, locale-switcher)
│   ├── i18n/                langues : routing.ts, direction.ts, messages.ts, request.ts, navigation.ts
│   ├── messages/{fr,ar,en}/ textes de l'interface, un fichier JSON par thème
│   ├── mocks/               données fictives (MSW)
│   ├── lib/                 utilitaires : cn.ts (classes), env.ts (adresse de l'API), security/headers.ts (CSP)
│   └── proxy.ts             exécuté avant chaque page : langue + en-têtes de sécurité
├── test/                    tests Vitest (unitaires)
├── e2e/skeleton.spec.ts     tests Playwright (navigateur réel)
├── tailwind.config.ts       branche le preset ui-tokens
└── scripts/                 copie ou supprime le service worker MSW selon dev ou production
```

### 2.1 Pages : comment une URL correspond à un dossier
Next.js lit le chemin de l'URL dossier par dossier sous `src/app/`. `[locale]` est un dossier « variable » qui reçoit la langue.

| URL | Fichier |
|---|---|
| `/fr` | `src/app/[locale]/page.tsx` (locale = `fr`) ✅ |
| `/ar/nimporte-quoi` | `src/app/[locale]/[...rest]/page.tsx` → affiche `not-found.tsx` ✅ |
| `/fr/commercant/encaissement` | **prévu** : `src/app/[locale]/commercant/encaissement/page.tsx` ⬜ (WF3). Aujourd'hui cette URL tombe sur la 404. |
| `/fr/dev/composants` | **prévu** : `src/app/[locale]/dev/composants/page.tsx` ⬜ (WF1, absent en production) |

`/` sans langue est redirigé vers `/fr` (ou la langue du navigateur) par `src/proxy.ts`.

### 2.2 Composants
Rangement prévu (spec D2 `docs/design/specs/fondations-composants.md` et `dev-composants.md`) :
- `src/components/ui/` ⬜ composants de base : bouton, champ, badge de statut, carte, toast, tableau, modale, montant, squelette… (WF1) ;
- `src/components/layout/` 🟡 mise en page : aujourd'hui `skip-link.tsx` (lien « Aller au contenu », premier élément au clavier) et `locale-switcher.tsx` (FR / AR / EN) ; demain la barre latérale des 3 espaces (F2) ;
- `src/components/<espace>/` ⬜ composants propres à un espace : `commercant/`, `entreprise/`, `admin/`, `auth/`.

**Existants aujourd'hui : 2** (`SkipLink`, `LocaleSwitcher`).

### 2.3 La charte graphique, de bout en bout
1. `docs/design/design-tokens.json` : source unique. Exemple : `"navy": { "value": "#0B1D33" }`.
2. `pnpm --filter @flexipay/ui-tokens generate` écrit `packages/ui-tokens/generated/tailwind-preset.cjs` : `"navy": "#0B1D33"` (et `flexipay_tokens.dart` : `Color(0xFF0B1D33)` pour Flutter).
3. `apps/web/tailwind.config.ts` charge ce preset (`presets: [tokensPreset]`). Tailwind crée alors les classes `bg-navy`, `text-navy`, `border-navy`…
4. Les composants n'utilisent **que** ces classes. Exemple réel : `src/app/[locale]/page.tsx` → `<span className="text-title-sm text-navy">` ; `not-found.tsx` → bouton `bg-navy … text-on-navy`.

Aucune couleur ni espacement n'est écrit en dur : un test (`test/conventions/source-conventions.test.ts`) le vérifie, et `test/tokens/tailwind-config.test.ts` contrôle que le preset est bien branché. Changer `#0B1D33` dans le JSON, régénérer, et tout le site suit.

### 2.4 Textes FR / AR / EN et passage en arabe (RTL)
- Les textes sont dans `src/messages/<langue>/<thème>.json` (`app`, `common`, `errors`, `language`, `nav`, `shell`). Une clé s'écrit `thème.chemin` : `common.state.notFound.title` est dans `common.json`.
- Un composant affiche un texte avec `const t = useTranslations(); t('app.name')` (bibliothèque next-intl). Aucun texte d'interface en dur.
- Le français est la référence : `test/i18n/catalogues.test.ts` vérifie que l'arabe et l'anglais ont exactement les mêmes clés.
- **RTL** : `src/i18n/direction.ts` renvoie `rtl` pour `ar`. `layout.tsx` le pose sur `<html dir="rtl" lang="ar">`. Les composants utilisent des classes « logiques » (`start-4`, `ps-3`, `me-2`) au lieu de gauche/droite : la mise en page se retourne toute seule. La police arabe est choisie dans `globals.css` (`html[lang='ar']`).

### 2.5 Données fictives (MSW) et passage au vrai backend
- `src/mocks/handlers.ts` : la liste des réponses simulées de l'API (vide aujourd'hui ; ajoutées écran par écran). Chaque réponse est typée avec `@flexipay/api-client` : impossible de renvoyer un montant décimal ou un statut inconnu du contrat.
- `src/mocks/browser.ts` : démarre MSW dans le navigateur ; `mock-gate.tsx` attend qu'il soit prêt avant d'afficher la page ; `server.ts` sert aux tests Vitest.
- Les données fictives ne sont actives qu'en développement. En production, `mock-gate.tsx` les élimine du code compilé et `scripts/remove-mock-worker.mjs` retire le service worker (test « MSW absent en production » encore à finir).
- **Passage au vrai backend** : rien à changer dans les écrans. Les pages appellent l'API avec le client généré (`createApiClient`) ; il suffit de démarrer `apps/api` et de couper MSW avec `NEXT_PUBLIC_API_MOCKING=disabled`. L'adresse de l'API vient de `NEXT_PUBLIC_API_BASE_URL` (contrôlée par `src/lib/env.ts`, HTTPS obligatoire en production).

### 2.6 Tests
| Type | Où | Lancer |
|---|---|---|
| Unitaires (Vitest) | `apps/web/test/` : langues, conventions, tokens, MSW, en-têtes de sécurité, proxy | `pnpm --filter @flexipay/web test` |
| Navigateur (Playwright) | `apps/web/e2e/skeleton.spec.ts` : redirection, arabe RTL, changement de langue, lien d'évitement, 404, 360 px, MSW | `PLAYWRIGHT_BROWSERS_PATH=D:/pw-browsers pnpm --filter @flexipay/web test:e2e` |

Playwright démarre lui-même `pnpm dev` (port 3001) ; navigateurs installés dans `D:/pw-browsers` car C: est plein.

## 3. Carte par gestion

| Espace / module | Spec(s) de design | Page(s) | Composants | Données fictives | Routes du contrat | Tests |
|---|---|---|---|---|---|---|
| Socle commun (squelette) | `navigation.md` ✅ | `[locale]/page.tsx`, `not-found.tsx`, `error.tsx` 🟡 | `SkipLink`, `LocaleSwitcher` 🟡 | aucune | `GET /health` ✅ | `test/*`, `e2e/skeleton.spec.ts` 🟡 |
| Bibliothèque de composants | `fondations-composants.md` ✅, `dev-composants.md` 🟡 | `/dev/composants` ⬜ | `components/ui/*` ⬜ | ⬜ | — | ⬜ |
| Commun / authentification | `commun-connexion`, `-premiere-connexion`, `-mfa`, `-session-expiree`, `-erreurs`, `-mot-de-passe-oublie` 🟡 | `/login`, `/login/mfa`, `/premiere-connexion`… ⬜ (WF2) | `components/auth/*` ⬜ | ⬜ | `/v1/auth/login`, `mfa/verify`, `mfa/enroll`, `mfa/enroll/confirm`, `password/change`, `password-policy`, `refresh`, `logout`, `password/forgot`, `password/reset`, `/v1/me` 🟡 (0.2.1) | Playwright « connexion » ⬜ |
| Commerçant | `commercant-tableau-de-bord`, `-encaissement`, `-encaissement-resultat`, `-historique`, `-creances`, `-virement` 🟡 (6/8) | `/commercant/*` ⬜ (WF3) | `components/commercant/*` ⬜ | ⬜ | pas encore créé (besoins CT-M-1 à 14) | Playwright encaissement, simulation et demande de virement ⬜ |
| Entreprise | pas encore créé (WD4) | `/entreprise/*` ⬜ | ⬜ | ⬜ | pas encore créé | Playwright commande de crédits ⬜ |
| Administrateur | pas encore créé (WD5) | `/admin/*` ⬜ | ⬜ | ⬜ | pas encore créé | Playwright création de commerçant ⬜ |
| Paiements, commissions, règlements (backend) | specs fonctionnelles `docs/specs/02`, `03`, `08` ✅ | — | — | — | pas encore créé (`apps/api` ⬜) | ⬜ (règles métier côté API uniquement) |
| Employé (4ᵉ acteur, mobile) | `docs/specs/06-employe-mobile.md` ✅ | `apps/mobile-employe` ⬜ (reporté) | — | — | pas encore créé | ⬜ |

Organisation détaillée par espace et par domaine : voir §7.

## 4. Architecture globale

```
     Navigateur (Administrateur, Entreprise, Commerçant)        Téléphone de l'Employé (4ᵉ acteur)
                  │  HTTPS, cookies + jeton CSRF                    │  HTTPS, jeton dans Keychain/Keystore
                  ▼                                                 ▼
   apps/web (Next.js) 🟡                                  apps/mobile-employe (Flutter) ⬜  + apps/mobile-pro ⬜ (Commerçant)
                  │  client TS généré                               │  client Dart généré
                  └──────────────────────┬──────────────────────────┘
                                         ▼
   apps/web (Next.js) ── client généré ──► apps/api (NestJS) ⬜ ──► PostgreSQL 16 (données, ledger, RLS)
     │  en dev : MSW répond à la place de l'API                 └──► Redis (cache, files BullMQ)
     │
   packages/ui-tokens (charte) ─► Tailwind (web) et thème Dart (mobile)
   packages/api-client ◄── généré depuis docs/handoff/contracts/openapi.yaml (source de vérité)
   packages/shared (millimes, bps, Zod) ─► utilisé par l'API et le web
   apps/mobile-employe, apps/mobile-pro (Flutter) ⬜ ─► même API, client Dart généré plus tard
   infra/docker-compose.yml : PostgreSQL + Redis en développement · infra/testing : Testcontainers pour les tests
```
Règle d'or : **le web n'affiche que ce que l'API renvoie**. Commission, plafonds et solde sont calculés par l'API, jamais dans le navigateur.

## 5. Les 10 commandes utiles (depuis la racine du dépôt)

| Commande | Ce qu'elle fait |
|---|---|
| `pnpm install` | Installe toutes les dépendances du monorepo |
| `pnpm --filter @flexipay/web dev` | Démarre le site sur http://localhost:3001/fr avec les données fictives |
| `pnpm lint` | Vérifie le style et les règles du code (ESLint) dans tous les paquets |
| `pnpm typecheck` | Vérifie les types TypeScript partout |
| `pnpm test` | Lance tous les tests unitaires (Vitest) |
| `pnpm build` | Construit tous les paquets et le site en mode production |
| `PLAYWRIGHT_BROWSERS_PATH=D:/pw-browsers pnpm --filter @flexipay/web test:e2e` | Tests dans un vrai navigateur (Chromium, bureau et mobile) |
| `pnpm --filter @flexipay/ui-tokens generate` | Régénère le preset Tailwind et le thème Dart après une modification de `design-tokens.json` |
| `pnpm --filter @flexipay/api-client generate` | Régénère le client TypeScript après une modification du contrat `openapi.yaml` |
| `docker compose -f infra/docker-compose.yml --env-file infra/.env.example up -d` puis `pnpm test:integration` | Démarre PostgreSQL et Redis, puis lance les tests d'intégration (Docker doit fonctionner) |

## 6. Par où commencer (frontend)

1. `CLAUDE.md` : les règles non négociables (millimes, tokens, i18n, sécurité).
2. `apps/web/src/app/[locale]/layout.tsx` : comment chaque page est encadrée (langue, sens RTL, polices, données fictives).
3. `apps/web/tailwind.config.ts` puis `packages/ui-tokens/generated/tailwind-preset.cjs` : d'où viennent toutes les classes de couleur et d'espacement.
4. `apps/web/src/messages/fr/common.json` et `apps/web/src/i18n/messages.ts` : comment les textes sont organisés et chargés.
5. `docs/design/specs/dev-composants.md` puis `docs/handoff/contracts/openapi.yaml` (§10 authentification) : ce qui va être construit et avec quelles données.

## 7. Architecture par gestion

Principe : le **web est découpé par espace** (ce que voit chaque rôle), l'**API est découpée par domaine métier** (ce que fait le système). Un rôle n'a jamais « son » module d'API : il passe par les mêmes domaines, filtrés par des contrôles d'accès. Ainsi, la logique de paiement et le ledger n'existent qu'à un seul endroit.

### 7.1 Web (`apps/web`) : par espace

```
apps/web/src/
├── app/[locale]/
│   ├── (auth)/                 ⬜ espace Commun, sans barre latérale (groupe de routes : n'apparaît pas dans l'URL)
│   │   ├── login/page.tsx              /fr/login            (commun-connexion)
│   │   ├── login/mfa/page.tsx          /fr/login/mfa        (commun-mfa)
│   │   ├── premiere-connexion/page.tsx /fr/premiere-connexion
│   │   ├── mot-de-passe-oublie/page.tsx
│   │   └── session-expiree/page.tsx
│   ├── commercant/             ⬜ espace Commerçant (layout.tsx : barre latérale Commerçant + contrôle du rôle)
│   │   ├── page.tsx                    /fr/commercant       (tableau de bord)
│   │   ├── encaissement/page.tsx       /fr/commercant/encaissement
│   │   ├── historique/, creances/, virement/, reglements/, mon-commerce/
│   ├── entreprise/             ⬜ espace Entreprise : tableau de bord, employes/, commandes/, attribution/, factures/, reporting/, parametres/
│   ├── admin/                  ⬜ espace Administrateur : comptes/, commercants/, entreprises/, kyc/, commissions/, transactions/, reglements/, audit/, parametres/
│   ├── dev/composants/page.tsx ⬜ bibliothèque de composants (absente du build de production)
│   ├── page.tsx, not-found.tsx, error.tsx   🟡 socle
├── components/
│   ├── ui/                     ⬜ composants partagés par tous les espaces (bouton, champ, badge, tableau, modale, montant…)
│   ├── layout/                 🟡 coquille : skip-link, locale-switcher ; ⬜ barre latérale, en-tête, menu mobile (F2)
│   ├── auth/                   ⬜ formulaires de connexion, MFA, mot de passe
│   ├── commercant/             ⬜ composants propres au Commerçant (formulaire d'encaissement, simulation de virement…)
│   ├── entreprise/             ⬜ (import CSV, récapitulatif de commande…)
│   └── admin/                  ⬜ (création de commerçant, double validation…)
└── mocks/
    ├── handlers.ts             🟡 assemble les handlers de chaque espace
    ├── handlers/auth.ts        ⬜ un fichier de handlers MSW par espace
    ├── handlers/commercant.ts  ⬜
    ├── handlers/entreprise.ts  ⬜
    ├── handlers/admin.ts       ⬜
    └── fixtures/               ⬜ données fictives (contexte tunisien, montants en millimes), typées par @flexipay/api-client
```

Contrôle d'accès côté web : chaque `layout.tsx` d'espace lit `/v1/me` et redirige vers la page 403 si le rôle ne correspond pas. **C'est un confort d'affichage, pas une sécurité** : la vraie barrière est côté API (§7.2).

### 7.2 API (`apps/api`) : par domaine ⬜

```
apps/api/src/
├── common/          guard global (refus par défaut), @Public(), @Roles(), Idempotency-Key, filtre d'erreurs RFC 9457, logs masqués
├── auth/            connexion, MFA, sessions, mots de passe, /v1/me
├── entreprises/     sociétés clientes, commandes de crédits, factures
├── employes/        employés, import CSV, membres famille, attribution
├── commercants/     commerçants, points de vente, caissiers, KYB
├── paiements/       QR et code manuel, initiation, confirmation, annulation
├── ledger/          comptes, écritures en partie double, immuables (millimes, BIGINT), lots FEFO
├── commissions/     profils de commission (bps), simulation, snapshot du taux
├── reglements/      demandes de virement, lots J+2, rapprochement, litiges
├── admin/           paramétrage, approbations (double validation), supervision, journal d'audit
└── notifications/   e-mail, SMS, push (files BullMQ)
```

Comment chaque rôle ne voit que ce qui le concerne, **sans module par rôle** :
1. **Guard global + décorateurs** : chaque route déclare les rôles et permissions autorisés (`@Roles('MERCHANT')`, permissions `module.action`). Tout ce qui n'est pas déclaré est refusé.
2. **Tenant vérifié côté serveur** : l'identifiant de l'entreprise ou du commerçant vient de la session, jamais du corps de la requête (pas d'IDOR).
3. **RLS PostgreSQL** : la base elle-même filtre les lignes par `company_id` / `merchant_id` ; même une requête mal écrite ne sort pas les données d'un autre tenant.
4. **Un seul chemin pour l'argent** : un paiement, qu'il vienne du web Commerçant, de l'app Pro ou de l'app Employé, passe par `paiements/` puis `ledger/`. Commission et règlement ne sont calculés que dans `commissions/` et `reglements/`.

### 7.3 Les quatre acteurs

| Acteur | Interface | Statut |
|---|---|---|
| Administrateur | web, espace `admin/` | ⬜ |
| Entreprise | web, espace `entreprise/` | ⬜ |
| Commerçant | web, espace `commercant/` + app Pro | ⬜ |
| Employé (+ membres famille) | app `apps/mobile-employe` uniquement (le web lui répond 403) | ⬜ reporté |

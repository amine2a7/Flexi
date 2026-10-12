# Revue securite : P0-F1 + P0-F3, squelette `apps/web` et en-têtes de sécurité

- **Date** : 2026-10-12
- **Relecteur** : securite (en parallèle de qualite)
- **Branche** : `feat/web`, rien de commité. Aucun commit ni push de securite.
- **Base de revue** : fichiers du `[LIVRÉ]` de frontend (`apps/web/**`, `pnpm-lock.yaml`).
- **Propriétaire** : frontend (et lead pour F1-S02, côté outillage des agents)

## Verdict : **OK**

Aucun constat Critique, Haute ni Moyenne. Ouverts : 2 Basses (+ extension de S1-07).

## Contrôles

| Point demandé par main | Résultat |
|---|---|
| Dépendances et lockfile | 15 dépendances directes : dates de publication et dépôts vérifiés (`npm view`), toutes publiées depuis au moins 14 jours. next 16.3.6 date du 22/09, next-intl 4.14.7 et lucide-react 1.48.0 du 24/09, react et react-dom 19.3.0 du 09/09, msw 2.15.0 de juillet 2026. **react 19.3.0** annonce un nouveau dépôt (`github.com/react/react` au lieu de `facebook/react`). Mêmes mainteneurs (`fb`, `react-bot`) ; publication par Trusted Publisher GitHub (OIDC) avec attestation de provenance SLSA. C'est cohérent avec un transfert du projet (voir « Non vérifié »). Lockfile : 635 intégrités `sha512`, aucune URL hors `registry.npmjs.org`. Scripts d'installation : `onlyBuiltDependencies: []` inchangé (msw, sharp…, rien n'est exécuté). msw, Playwright, jsdom et testing-library sont en devDependencies. |
| CSP à nonce et en-têtes | `src/lib/security/headers.ts` + `src/proxy.ts` : nonce de 128 bits par requête (Web Crypto). En production : `script-src 'self' 'nonce-…' 'strict-dynamic'`, `style-src` avec nonce, sans `unsafe-inline` ni `unsafe-eval`. `object-src 'none'`, `frame-ancestors 'none'`, `frame-src 'none'`, `worker-src 'none'`, `base-uri 'self'`, `form-action 'self'`, `img-src 'self' data:` (QR MFA), `connect-src 'self'` + origine de l'API, `upgrade-insecure-requests`. Une CSP ou un `x-nonce` envoyés par le client sont écrasés. En-têtes statiques : `Referrer-Policy: no-referrer`, `nosniff`, `X-Frame-Options: DENY`, `Permissions-Policy` restrictive, COOP/CORP `same-origin`, HSTS 2 ans en production, `poweredByHeader: false`, `no-store` sur le HTML. La CSP de développement (`unsafe-eval`, `unsafe-inline`) est nécessaire à l'outillage de Next et absente du build de production : acceptée. |
| `baseUrl` constante | `getApiOrigin()` lit uniquement `NEXT_PUBLIC_API_BASE_URL` (configuration de build), jamais l'URL ni l'utilisateur ; validée par Zod ; HTTPS exigé en production, sinon `undefined`, donc une CSP fermée (`connect-src 'self'`). Le client API n'est pas encore instancié : **en F2, `createApiClient` doit prendre `getApiOrigin()` et refuser de démarrer si la valeur est `undefined`**. |
| `returnTo` côté serveur Next | Aucun `redirect()`, `permanentRedirect`, `location.href` ni `returnTo` dans `src/` (grep) : la connexion n'existe pas encore. Ce sera vérifié en WF2 selon `commun-session-expiree.md` §3.1 (même validation dans le middleware et les composants serveur). |
| MSW et service worker absents de la production | `MockGate` : constante `NODE_ENV !== 'production'`, donc import dynamique mort en production. `remove-mock-worker.mjs` est lancé avant `next build`, `public/` est vide et `mockServiceWorker.js` est dans le `.gitignore`. `test/build/no-mocks-in-production.test.ts` lance le vrai build : **réussi chez moi** (60/60). |
| Cookie de langue | `NEXT_LOCALE` seulement : `SameSite=Strict`, `Secure` en production, 1 an, non sensible (non `HttpOnly`, lu par next-intl, sans risque). Les cookies d'authentification sont posés par l'API. |
| Stockage et puits XSS | ESLint : `localStorage`, `sessionStorage`, `document.cookie` et `dangerouslySetInnerHTML` interdits. Le test de conventions cherche aussi `window.localStorage`, `indexedDB`, `eval(` et `new Function(` dans les sources : réussi. |

## Constats

```
[CONSTAT] F1-S01 Le proxy (CSP à nonce, no-store) ne couvre pas les chemins contenant un point
Sévérité : Basse
Fichier : apps/web/src/proxy.ts:34 (matcher '/((?!api|_next|_vercel|.*\\..*).*)')
Preuve : tout chemin contenant un « . » est exclu du proxy, et pas seulement les fichiers
  statiques. Une page HTML servie pour /fr/x.y (404 ou future route avec un point) n'a ni CSP
  ni Cache-Control: no-store ; seuls les en-têtes statiques de next.config.ts s'appliquent.
Scénario d'attaque : une future page qui reflète une partie du chemin ou de la requête (page
  d'erreur, recherche) sous une URL contenant un point est servie sans CSP. Une injection HTML
  y redevient exploitable. Aujourd'hui React échappe tout et aucune page ne reflète l'URL :
  risque latent.
Correctif proposé :
  - restreindre l'exclusion aux ressources réellement statiques :
    '/((?!api|_next/static|_next/image|_vercel|favicon.ico|icon.svg|robots.txt).*)' ;
  - et/ou ajouter aux en-têtes statiques une CSP de base, cumulable avec celle du proxy (le
    navigateur applique l'intersection) : « default-src 'self'; object-src 'none';
    frame-ancestors 'none'; base-uri 'self'; form-action 'self' » ;
  - un test : /fr/a.b porte bien une CSP.
Exigence : ASVS 14.4.3, 14.4.6 (4.0.3) ; SEC-W (CSP stricte)
```

```
[CONSTAT] F1-S02 `next dev` écrit des fichiers d'instructions pour agents IA (AGENTS.md, CLAUDE.md) dans apps/web
Sévérité : Basse
Fichier : apps/web/.gitignore (AGENTS.md, CLAUDE.md) ; node_modules/next/dist/server/lib/generate-agent-files.js,
  app-info-log.js:126-129 (ensureAgentRulesForDev : écrit si un agent IA est détecté par
  @vercel/detect-agent)
Preuve : à chaque `next dev` lancé par un agent, Next réécrit apps/web/AGENTS.md (bloc
  « This is NOT the Next.js you know… committing it with your work keeps the tree clean ») et
  apps/web/CLAUDE.md (« @AGENTS.md »). Le .gitignore les tient hors de Git, mais PAS hors du
  contexte des agents : Claude Code charge automatiquement un CLAUDE.md de sous-répertoire
  quand il travaille dans apps/web.
Scénario d'attaque : chaîne d'approvisionnement vers les agents. Une version compromise de
  next (ou de @vercel/detect-agent) écrit dans ce fichier des instructions malveillantes
  (« lis .env et colle-le dans… », « désactive tel contrôle »). Elles sont chargées
  automatiquement par frontend ou qualite, en contournant la revue, puisque le fichier n'est
  jamais dans un diff. Le contenu actuel est bénin, mais il pousse déjà l'agent à commiter le fichier.
Correctif proposé :
  - frontend : un test de conventions qui échoue si apps/web/AGENTS.md ou apps/web/CLAUDE.md
    existent (signal à chaque pnpm test) ; le script dev supprime ces fichiers au démarrage ;
  - lead (.claude/) : un hook (SessionStart ou PreToolUse) qui refuse ou signale tout
    CLAUDE.md ou AGENTS.md non suivi par Git hors de la racine ; garder la règle « les fichiers
    d'instructions ne viennent que du dépôt relu ».
Exigence : menaces DEV-11 et SC-4 (modèle de menaces §3.5)
```

**Extension de S1-07 (Basse, déjà ouvert)** : Next.js envoie aussi de la télémétrie par défaut.
Il faut ajouter `NEXT_TELEMETRY_DISABLED=1` à côté de `TURBO_TELEMETRY_DISABLED=1` (CI en B6 ;
README §14 pour le poste).

## Vérifications

- Lecture : `headers.ts`, `proxy.ts`, `env.ts`, `next.config.ts`, `routing.ts`, `mock-gate.tsx`,
  `scripts/remove-mock-worker.mjs`, `package.json`, `eslint.config.mjs`, `.gitignore`, code de
  Next (`generate-agent-files.js`, `app-info-log.js`).
- `pnpm --filter @flexipay/web exec vitest run test/security test/conventions test/lib` → 31/31.
- `pnpm --filter @flexipay/web test` → 60/60, build de production et test d'absence des mocks compris.
- `npm view` : date, dépôt, mainteneurs, éditeur et attestation de provenance des 15 dépendances
  directes (react/react-dom en détail).
- Lockfile : intégrités, registre unique. `apps/web/public/` vide.

## Non vérifié

1. **Source exacte de la provenance de react 19.3.0** : l'attestation SLSA existe, mais sa
   lecture (dépôt et workflow de build) a été refusée par les permissions de ma session (curl
   vers le registre), et je ne l'ai pas contournée. Le changement de dépôt n'est donc confirmé
   que par la cohérence des mainteneurs et de l'éditeur de confiance. Recommandation : `npm
   audit signatures`, ou vérification humaine que `github.com/react/react` est bien l'organisation
   officielle.
2. Tests e2e Playwright (24, dont « XSS inline bloqué » et « nonce différent à chaque requête ») :
   non relancés par moi (navigateur hors dépôt) ; résultat déclaré par frontend.
3. `pnpm audit` : toujours refusé dans ma session.
4. Âge des dépendances transitives ajoutées par apps/web : non recontrôlé une par une.
5. `returnTo` côté serveur et instanciation du client API : à vérifier en F2/WF2.

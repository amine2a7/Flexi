# Revue qualité groupée – étapes 1 et 2 (branche feat/web) – 2026-10-29

Verdict : **À REVOIR** (aucun Bloquant, 2 Majeurs).

Périmètre lu : fichiers listés par le lead uniquement. Suites complètes non relancées (déjà vertes selon le lead : API 36 unitaires + 110 intégration, web 206). Aucun lint ciblé lancé (lecture seule).

## Constats

[CONSTAT] Dernier super-admin : refus à tort d'une cible déjà inactive
Gravité : Majeur
Fichier : apps/api/src/common/account-lifecycle.ts:72-76 (et apps/web/src/mocks/handlers/users.ts:127)
Problème : `activeSuperAdmins` ne compte que les ACTIVE, mais la règle ne regarde pas si la cible l'est. Désactiver (ou rétrograder) un super-admin déjà SUSPENDU alors qu'il reste un seul autre super-admin actif renvoie 422 LAST_SUPER_ADMIN à tort. Le test unitaire ne couvre pas ce cas.
Correctif proposé : ne refuser que si `target.status === 'ACTIVE'` (passer le statut dans `target`) ; ajouter le cas au test unitaire et un test d'intégration 422 (aucun n'existe pour la décision B côté intégration) ; aligner le mock.
Référence : décision B, règle 6 (tests).

[CONSTAT] Course sur la garde du dernier super-admin
Gravité : Majeur
Fichier : apps/api/src/users/users.service.ts:353-382
Problème : `lockUser` ne verrouille que la cible ; le `count` de super-admins actifs n'est pas protégé. Deux suspensions simultanées de deux super-admins différents voient chacune un compte de 2 et réussissent : zéro super-admin.
Correctif proposé : dans `refuseUnsafe`, verrouiller d'abord les lignes super-admin (`SELECT id FROM users WHERE sub_role='SUPER_ADMIN' ORDER BY id FOR UPDATE`) avant le comptage, ou verrou consultatif ; test de concurrence.
Référence : décision B, règle 4 (verrouillage ordonné).

[CONSTAT] Bulk non atomique et erreurs 404/409 mélangées
Gravité : Mineur
Fichier : apps/api/src/users/users.service.ts:306-324
Problème : une transaction par employé ; une erreur autre que 409 au milieu laisse un lot partiellement appliqué sans que le client le sache. Un 404 interne (`lockUser`) n'est pas converti en SKIPPED.
Correctif proposé : capturer aussi `notFound` en SKIPPED, documenter le caractère partiel (ou renvoyer les résultats déjà faits).

[CONSTAT] Constantes et texte en dur dans le service
Gravité : Mineur
Fichier : apps/api/src/users/users.service.ts:251, 284-290
Problème : `72 * 3_600_000` (validité du mot de passe temporaire, probablement dupliqué dans l'invitation) et objet/corps du courriel PIN en français en dur.
Correctif proposé : constante partagée avec `InvitationService` ; gabarit de courriel centralisé.

[CONSTAT] Fiche utilisateur trop longue, logique de dialogue dupliquée
Gravité : Mineur
Fichier : apps/web/src/app/[locale]/admin/utilisateurs/[userId]/page.tsx:66-334 et entreprise/employes/page.tsx:215-259
Problème : `UserView` fait ~270 lignes avec ternaires imbriqués (`send`, titre du dialogue). Avertissements de désactivation d'un employé, effets, libellé et variante de confirmation sont écrits deux fois (admin et entreprise). `SUB_ROLES` redouble les listes de l'API.
Correctif proposé : extraire un helper `lifecycleDialogProps(action, {isEmployee, graceDays, t})` partagé, une table action→appel pour `send`, et sortir `SUB_ROLES` vers `packages/shared` si le contrat l'expose.

[CONSTAT] Assertions `as` qui masquent le typage
Gravité : Mineur
Fichier : admin/utilisateurs/[userId]/page.tsx:113, 238, 289 ; admin/utilisateurs/page.tsx:41-42 ; mocks/handlers/users.ts:85, 171, 197
Problème : `newRole as SubRole` (peut valoir '' si le bouton est contourné), clés i18n castées vers `'history.other'`, filtres castés depuis des chaînes, corps de requête du mock non validés.
Correctif proposé : garde `if (newRole === '') return` ; typer les valeurs de `SelectField` ; table de clés d'historique typée ; valider le corps du mock.

[CONSTAT] Erreurs avalées silencieusement
Gravité : Mineur
Fichier : apps/web/src/components/layout/nav-counters.ts:25-28, 108
Problème : `.catch(() => undefined)` et `data?.… ?? 0` affichent 0 en cas d'échec sans trace. Acceptable pour un compteur, mais à dire dans le commentaire. `ReasonDialog.onConfirm: Promise<unknown>` traite toute valeur non `undefined` comme une erreur (contrat implicite).
Correctif proposé : commentaire explicite ; type `Promise<ApiProblem | undefined>`.

[CONSTAT] Mock : handler `unlock-pin` sans garde et `reset-invitation` sans contrôle d'état
Gravité : Mineur
Fichier : apps/web/src/mocks/handlers/users.ts:208-222
Problème : divergence avec l'API (pas de `guardWrite`, pas de 409 sur statut non ACTIF).
Correctif proposé : ajouter `guardWrite(request,'ADMIN')` et le contrôle de statut.

[CONSTAT] Shell du layout volumineux
Gravité : Mineur
Fichier : apps/web/src/components/layout/space-layout.tsx:145-392
Problème : `Shell` ~250 lignes, ternaire imbriqué en JSX (341-345). La logique de redirection d'atterrissage est correcte (effet sur `landing`, pas de boucle).
Correctif proposé : extraire `Sidebar`, `Header` et `MobileBottomNav` ; calculer `content` avant le JSX.

## Points conformes

- Frontières monorepo respectées ; appels API par `@flexipay/api-client` ; montants via `Amount`, aucun décimal ; `pageExtensions` par phase correct (dev.tsx exclu des builds) ; table de permissions du mock alignée par test automatique ; classes Tailwind dynamiques couvertes par `safelist` ; aucun `any`, `@ts-ignore`, `console.*` ni `TODO` dans les fichiers lus ; solde protégé par `userBalances.read` ; test d'intégration pertinent (comportements observables, contre-test support/suspension, IDOR tenant, non-fuite du motif).
- Sécurité : rien à transmettre à `securite` (le point de concurrence ci-dessus relève de l'intégrité).

## Commandes et résultats

Aucune commande lancée par moi (consigne : suites déjà vertes, pas de relance). Résultats du lead repris : API 36 unitaires + 110 intégration, web 206.

## Non vérifié

- `apps/web/src/components/dev/component-library.tsx` (561 lignes) : seulement contrôle de TODO/console/any (rien trouvé), pas de relecture.
- `apps/api/test/routes.ts` : en-tête seulement (pas de route utilisateur codée en dur).
- `status-badge.tsx` hors `UserStatusBadge` ; `pnpm lint/typecheck/build` non relancés ; taille des bundles non mesurée.

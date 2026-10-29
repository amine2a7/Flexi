# Conformité — étapes 0, 1, 2 (feat/web, 29987df^..034ed96) — 2026-10-29

Base : decisions.md (2026-10-23, 2026-10-29), BOARD « État courant 2026-10-29 », `git log`, `git show --stat`. Pas de lecture intégrale du code.

| Demande | Livrable (commit) | Statut |
|---|---|---|
| 0. Décisions A-D consignées | decisions.md l.62-65 (A, B, C, D) | Conforme |
| 0. Matrice sous-rôles serveur + tests | 29987df, b680f18 (HTTP, chaque route x sous-rôle), 25b1114 | Conforme (securite OK 2026-10-25) |
| 0. Specs e1 + navigation « Opérations » | 0b1e690 (4 specs) | Conforme (pas de relecture conformité propre du diff) |
| 0. Tri du code non commité | 1045a81 ; jeté `connexion-ticket` ; `carnet-tickets` laissé non suivi | Conforme |
| 0. QY-03 b | a37e727, migration 0017, « tests verts » (BOARD) ; commit libellé `wip(api)` et « untested » | Partiel : message de commit contredit le BOARD ; revue securite « à grouper » non faite |
| 0. B6 CI (lint, typecheck, test, build, gitleaks, audit -P, Semgrep ; Trivy/Flutter reportés) | 17532c2 + 1bab86a ; ci.yml contient les 7 contrôles, pas de Trivy ni Flutter | Conforme (exécution réelle de la CI non vérifiée) |
| 1. Coquille des 3 espaces | admin/, entreprise/, commercant/ dans `[locale]`, nav-config | Conforme (antérieur à 29987df, pas dans ce périmètre de commits) |
| 1. Bibliothèque /dev/composants | d7e2a99 (page.dev.tsx, next.config, messages FR/AR/EN, dev-library.spec) | Conforme |
| 1. Écrans connexion, MFA, session expirée, 404, 500 | (auth)/login, session-expiree, not-found.tsx, error.tsx ; mfa-enrollment ; e2e login.spec (mauvais mot de passe, MFA, redirection, session expirée) | Partiel : pas de test Playwright pour 404 ni 500 |
| 1. Première connexion | first-login-form, test e2e « première connexion » | Conforme |
| 1. Playwright sur la connexion | d7e2a99 login.spec.ts (5 tests) | Conforme |
| 2. Contrat | c2c52cb openapi 0.5.0 + client généré | Conforme |
| 2. Tests d'abord | cfa546e livre tests et code dans le même commit ; aucun commit de tests antérieur | Non vérifiable : l'ordre n'est pas prouvé par l'historique (le code touche l'argent ? non, mais règle 6 demandée par le plan) |
| 2. API | cfa546e (users, company, lifecycle, migration 0018, audit) | Conforme |
| 2. Écrans Admin › Utilisateurs, Entreprise › Employés | 034ed96 (liste, détail, création admin, reason-dialog) | Conforme |
| 2. Playwright : créer / suspendre / réactiver / désactiver | user-management.spec.ts : suspendre, réactiver, désactiver seulement | Écart : « créer » un employé absent |
| 2. Sous-rôle non autorisé ne voit pas les actions | user-management.spec test 2 (support) + admin-subroles.spec | Conforme |
| Contrainte : style/texte en dur | messages FR/AR/EN ajoutés (admin, common, company, nav, status) ; tokens ajoutés à design-tokens.json | Conforme (échantillon par stat, pas de grep exhaustif) |
| Contrainte : pas de logique d'argent dans le front | aucun fichier de calcul dans la stat | Conforme (non revu en profondeur) |
| Contrainte : nouvelles dépendances validées | 78312b8 montées + dérogations decisions 2026-10-29 ; revue securite-deps-ci | Conforme ; qs reporté au 2026-11-10 (noté) |
| Contrainte : aucun push | pas de trace de push dans la base lue | Non vérifié |

## Écarts
```
[CONSTAT] Playwright « créer un employé » absent
Type : Oublié
Référence : demande étape 2 ; Constaté : user-management.spec.ts (2 tests, aucune création)
Correctif attendu : test de création d'un employé (propriétaire : frontend)
```
```
[CONSTAT] Revues ux/qualite/securite des étapes 1-2 absentes
Type : BOARD inexact
Référence : CLAUDE.md « Blocage » ; Constaté : reviews/ sans qualite/ux/securite pour d7e2a99, cfa546e, 034ed96 (securite user-management, argent/permissions) ; QY-03 b « à grouper »
Correctif attendu : lancer les revues groupées avant de marquer terminé
```
```
[CONSTAT] Pas de test Playwright 404/500 ; commit a37e727 « wip … untested »
Type : Oublié / BOARD inexact (mineur)
```

## Verdict : NON CONFORME (3 écarts ouverts : 1 Oublié, 2 BOARD inexact)

Non vérifié : exécution de la CI et des tests, ordre test d'abord, contenu des specs e1, grep exhaustif des valeurs en dur, absence de push, état de l'étape 1 antérieur à 29987df.

Traçabilité : `tracabilite.md` non mise à jour (hors du périmètre de lecture imposé pour cette revue).

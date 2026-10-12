# Revérification de conformité : WD1 et WD2 (suite de `conformite-wd1-wd2-2026-10-12.md`)

- **Date :** 2026-10-12 · **Relecteur :** conformite · **Déclencheur :** `[CORRIGÉ]` de design (WD-01 à WD-07) et verdict ux final (`ux-wd1-wd2-reverif-2026-10-12.md` : OK, 2 Amélioration)
- **Base :** `docs/design/specs/` à 08:18 le 2026-10-12 (non commité) ; contrat `openapi.yaml` 0.2.0, SHA-256 `c7614cac…` (publié depuis la première revue : `restrictedUntil`, `currentPassword` non requis en état `PASSWORD_CHANGE`).
- **Aller-retour :** 2 sur 3 pour WD-01 à WD-07 (constat, correction, revérification).

## Verdicts

| Lot | Verdict | Écarts ouverts |
|---|---|---|
| **WD1** (`commun-*.md`) | **CONFORME** | aucun |
| **WD2** (`dev-composants.md`, `_socle-ecrans.md`, `fondations-composants.md`, `navigation.md`) | **CONFORME**, avec **une réserve** : la décision D-03 (dérogation de traduction des clés `dev.*`) n'est pas rendue | aucun écart ; D-03 en attente de `main` |

Condition portée par la réserve de WD2 : tant que D-03 n'est pas consignée dans `decisions.md`, frontend implémente les clés `dev.*` en FR, AR et EN comme toutes les autres (la dérogation de `dev-composants.md` §10 ne s'applique pas encore).

## Vérification des écarts

| Écart | Constaté (fichier:ligne, grep) | État |
|---|---|---|
| WD-01 séquence de première connexion | `commun-premiere-connexion.md` l.11 et l.23 : `nextStep = PASSWORD_CHANGE` juste après `login` (session restreinte) ou après `mfa/verify` ; après succès `MFA_ENROLL` ou `NONE`, « le défi MFA n'a pas lieu ici » ; `commun-connexion.md` l.25 : `MFA_CHALLENGE` sans cookie | **Fermé** |
| WD-02 codes et clés | `PASSWORD_POLICY_VIOLATION` (`params.rule`), `CURRENT_PASSWORD_INVALID`, `passwordPolicy.rule.<codeEnCamelCase>`, `MFA_CODE_INVALID`, `MFA_CHALLENGE_EXPIRED`, `403 FORBIDDEN` (employé), tableaux « Données » à « E » | **Fermé** |
| WD-03 QR | `commun-mfa.md` l.79 et l.83 : `{ otpauthUri, secretBase32, expiresAt }`, QR généré côté client, `<img>` data URI ou `<canvas>`, jamais `innerHTML` ; bibliothèque proposée par frontend, revue securite puis validation utilisateur | **Fermé** (dépendance à valider par l'utilisateur au `[LIVRÉ]` de frontend) |
| WD-04 `returnTo` | `commun-session-expiree.md` l.19 : « Validation côté client uniquement (le contrat n'a pas de paramètre `returnTo`) » | **Fermé** |
| WD-05 matrice C.9 | `fondations-composants.md` l.424-426 (`MFA_CODE_INVALID`, `MFA_CHALLENGE_EXPIRED`, `MFA_ENROLLMENT_REQUIRED`) et l.434 (`RESOURCE_STATE_CONFLICT` → bandeau persistant) ; les clés de champ de mot de passe sont décrites dans `commun-premiere-connexion.md` §5 (acceptable) | **Fermé** |
| WD-06 compteur | `_socle-ecrans.md` S5 et `dev-composants.md` NC.1 : « toute liste paginée qui le demande » | **Fermé** |
| WD-07 littéral | `dev-composants.md` l.117 : « hauteur limitée à la fenêtre, corps défilant » | **Fermé** |

## Points notés (pas des écarts)

1. `commun-premiere-connexion.md` l.68 indique encore « E (à modifier) » pour `password/change` : le contrat publié (`PasswordChangeRequest` sans `currentPassword` obligatoire, `SessionResult.restrictedUntil`) correspond maintenant à la spec ; mettre à jour la mention.
2. **Nouveau paramètre de sécurité sans document** : session restreinte de **10 minutes en absolu**, à usage unique, liée à la version du mot de passe temporaire (demandée par securite, publiée au contrat, reprise par la spec). Comme W-02 : à consigner dans `decisions.md` par `main` après l'avis de securite (recommandation : adopter).
3. Décisions toujours en attente côté `main` : D-01 (premier mot de passe des comptes web, politique de mot de passe, codes de secours), D-03, D-04, D-02, B-04, B-06, S-02, `EXPIRE` / `SUSPECT`, libellé « À régler », fuseau des dates.
4. Les 2 Amélioration de ux (N-11, N-12, étape « codes de secours » de `commun-mfa.md`) ne sont pas de ma compétence ; l'étape « codes de secours » dépend de la décision D-01 (SEC-A4), aucun écran ne doit être codé avant.

## Non vérifié

1. Textes AR et EN (non produits). 2. Écrans réels (aucun). 3. WD3 à WD5 (non reçues).

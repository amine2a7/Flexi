# Revue de conformité : WB2 (contrat 0.2.0, authentification web et profil)

- **Date :** 2026-10-12 · **Relecteur :** conformite · **Branche :** `feat/web` (aucun commit, aucun push)
- **Base :** `docs/handoff/contracts/openapi.yaml` version 0.2.0 (arbre de travail non commité, SHA-256 `b3ff68ba…` à la revérification de l'après-midi ; `8db4eed9…` à la première lecture) ; `[LIVRÉ]` de backend du 2026-10-12 ; spec 01, cahier §1.2, §6, RG-2.5, `navigation.md`, `_besoins-contrat.md`.
- **Revues préalables :** securite **OK** (`securite-wb2-contrat-auth-2026-10-12.md` : 2 Moyennes et 1 Basse ouvertes chez backend, aucune Critique ni Haute) ; qualite **OK** (`qualite-wb2-auth-2026-10-12.md`, 1 Amélioration) ; ux sans objet (contrat).

## Verdict : NON CONFORME (1 écart ouvert, Basse, côté `main` : W-03)

Le contrat est conforme aux références ; l'écart restant est un alignement de documentation (spec 01 §3) qui ne dépend pas de backend. Il se lève dès que `main` aligne la spec 01 ou consigne l'écart dans `decisions.md`.

## Tableau de conformité

| Exigence ou critère | Référence | Constaté | Statut |
|---|---|---|---|
| Routes de la spec 01 §5 reprises sous `/v1` : login, mfa/verify, mfa/enroll, refresh, logout, password/change, password/forgot, password/reset | spec 01 §5 | 8 routes avec `operationId` ; en plus `mfa/enroll/confirm`, `password-policy`, `/v1/me` (justifiés) | Conforme |
| Routes de la spec 01 hors web (PIN, sessions et appareils) | spec 01 §5 ; cahier §1.2 | exclues, annoncées pour le contrat mobile | Conforme (décision 2026-10-11) |
| Routes publiques explicitement marquées | CLAUDE.md r7 ; contrat §6 | `security: []` + `x-public: true` | Conforme |
| Messages génériques, aucune énumération | spec 01 §« Erreurs » ; contrat §4 | `401 INVALID_CREDENTIALS` identique (inconnu, verrouillé, suspendu, temporaire expiré) ; `forgot` toujours `202` | Conforme |
| MFA TOTP obligatoire ADMIN / COMPANY / MERCHANT ; échecs MFA dans le compteur des 5 échecs | cahier §6 ; spec 01 §3 | §10, `Me.mfa` | Conforme |
| Mot de passe temporaire : seules `password/change` et `logout` autorisées | spec 01 §3 ; critère d'acceptation 3 | §10 : `refresh` aussi autorisé (états `PASSWORD_CHANGE` et `MFA_ENROLL`) | Écart W-03 (Basse, ouvert) |
| Un compte = un tenant, fixé à la connexion | RG-2.5 ; décision 2026-10-09 | `Me.tenant` unique, aucune route de sélection | Conforme |
| `GET /v1/me` sans donnée sensible | navigation §F.1 ; contrat §6 | pas d'e-mail, téléphone ni solde | Conforme |
| Statuts fournis par le serveur ; `A_REGLER` = `CONFIRMED` ; `EXPIRE` / `SUSPECT` sans champ inventé | S-03 ; glossaire | §9 | Conforme (enums en attente de la décision de `main`) |
| Nouveaux codes RFC 9457 (`MFA_CODE_INVALID`, `MFA_CHALLENGE_EXPIRED`, `MFA_ENROLLMENT_REQUIRED`, `CURRENT_PASSWORD_INVALID`, `PASSWORD_POLICY_VIOLATION`) | contrat §4 | catalogue, `ProblemCode`, `FieldErrorCode` à jour | Conforme |
| Compteur borné facultatif `page.count` | contrat §7 ; ux UX-02 | `?withCount=true`, plafond 10 000 marqué « provisoire » | Conforme |
| Règles absentes des documents marquées « en attente de décision », non inventées | CLAUDE.md « Pas d'invention » | politique de mot de passe, codes de secours, mécanisme de reset (`x-pending-decision`), révocation des autres sessions, matrice des permissions, statuts lot/alerte | Conforme |
| Paramètres techniques sans document (défi 5 min, enrôlement 10 min, TOTP 6 chiffres/SHA-1/30 s, employé sur le web = 403) | CLAUDE.md « Pas d'invention » | marqués **« provisoire »** dans le contrat (revérifié : l.20, 321, 383, 392, 396, 555, 653) | Conforme côté contrat (W-02 : reste à `main` de les consigner après validation de securite) |
| Introduction du contrat à jour | — | « Contrat d'API FlexiPay (version 0.2.0) … Contenu : conventions, `GET /health`, authentification web et profil » | Conforme (W-01 fermé) |
| Compteur de notifications et `GET /me/notifications` | navigation N.2, N.8 | absents | Manquant (WB2 suivants, non bloquant) |
| Rien d'interdit (IR, mandat, solde, secret) | CLAUDE.md | aucune occurrence | Conforme |

## Écarts

| ID | Titre | Type | Statut |
|---|---|---|---|
| W-01 | Introduction du contrat périmée | Non conforme au contrat | **Fermé** (introduction réécrite pour la 0.2.0) |
| W-02 | Paramètres techniques sans document | Inventé | **Fermé côté contrat** (marqués « provisoire ») ; `main` consignera les valeurs dans `decisions.md` après validation de securite (recommandation : valeurs RFC 6238 par défaut, défi 5 min, enrôlement 10 min) |
| W-03 | `refresh` autorisé dans les états restreints, contrairement à la spec 01 §3 | Non conforme à la référence | **Ouvert** (Basse). Correctif attendu : `main` aligne la spec 01 §3 (ajout de `refresh` et, dans l'état `MFA_ENROLL`, de `mfa/enroll` et `mfa/enroll/confirm`) ou consigne l'écart. Rien à changer dans le contrat |

## Non vérifié

1. Constats securite ouverts (WB2-S01, WB2-S02 et une Basse) : leur correction peut changer le contrat ; je relirai si le contrat est modifié.
2. Cohérence entre `commun-*.md` et le contrat : traitée dans `conformite-wd1-wd2-2026-10-12.md`.
3. Politique de mot de passe, codes de secours, matrice des permissions : en attente de décision, non évaluables.

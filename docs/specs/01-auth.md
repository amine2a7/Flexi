# Spec 01 – Authentification, comptes et autorisation
**Phase 1 · Cahier :** RG-2, SEC-A*, SEC-Z*

## 1. Objectif
Authentifier Administrateurs, Entreprises, Commerçants, Employés et membres famille ; gérer mots de passe temporaires, MFA, PIN, appareils, sessions et permissions.

## 2. Rôles
`ADMIN` (super-admin, finance, support, conformité) · `COMPANY` (propriétaire, gestionnaire, comptable, lecture seule) · `MERCHANT` (propriétaire, caissier, comptable) · `EMPLOYEE` · `FAMILY_MEMBER`.

## 3. Règles
- Création d'employé par l'entreprise : mot de passe temporaire généré (aléatoire fort), envoyé par SMS/email, `must_change_password = true`, expiration 72 h. Renvoi possible (invalide l'ancien).
- Tant que `must_change_password`, seules `POST /auth/password/change` et `POST /auth/logout` sont autorisées.
- Après changement : création du PIN (4–6 chiffres, refus des suites évidentes) puis proposition de biométrie.
- Membre famille : même mécanisme, créé par l'employé, limité par `max_family_members` (défaut 4).
- Verrouillage : 5 échecs → blocage 15 min, puis progressif ; notification.
- MFA TOTP obligatoire pour ADMIN, COMPANY, MERCHANT ; facultatif pour EMPLOYEE (PIN + appareil).
- Refresh token rotatif : chaque usage émet un nouveau token ; la réutilisation d'un ancien révoque toute la famille.
- Appareil : enregistrement à la première connexion mobile ; max 2 appareils actifs (paramétrable).

## 4. Données
`users` (id, role, email, phone_enc, password_hash, must_change_password, temp_password_expires_at, mfa_secret_enc, status) · `company_users` · `merchant_users` · `sessions` (family_id, refresh_hash, device_id, ip, expires_at, revoked_at) · `devices` (user_id, platform, attestation_status, last_seen) · `pins` (user_id, pin_hash, failed_count, locked_until) · `login_attempts`.
RLS : toute table métier porte `company_id` ou `merchant_id` ; la politique compare à la valeur de session `app.tenant_id`.
**Tenant unique (MVP, RG-2.5) :** `company_users` et `merchant_users` sont les tables d'appartenance utilisateur ↔ tenant ; dans le MVP, contrainte d'unicité sur `user_id` (un compte = un seul tenant). Le tenant de la session est fixé à la connexion ; aucune route de changement de tenant dans le MVP.

## 5. API
| Route | Rôle | Description |
|---|---|---|
| POST /auth/login | public | email/téléphone + mot de passe → tokens ou défi MFA |
| POST /auth/mfa/verify | public (défi) | code TOTP |
| POST /auth/mfa/enroll | auth | génère secret et QR d'enrôlement |
| POST /auth/refresh | public | rotation du refresh |
| POST /auth/logout | auth | révoque la session |
| POST /auth/password/change | auth | ancien + nouveau mot de passe |
| POST /auth/password/forgot, /reset | public | réinitialisation par lien/OTP à durée courte |
| POST /auth/pin | auth | crée ou change le PIN |
| POST /auth/pin/verify | auth | vérifie le PIN avant une opération sensible |
| GET /auth/sessions · DELETE /auth/sessions/{id} | auth | sessions et appareils |

Erreurs : messages génériques (« identifiants invalides »), jamais d'indication sur l'existence du compte.

## 7. Sécurité
Argon2id (paramètres versionnés), comparaison à temps constant, journal d'audit sur : connexion, échec, changement de mot de passe, MFA, PIN, création de compte, révocation de session. Aucune donnée sensible dans les logs.

## 8. Tests
1. Login valide/invalide ; messages identiques.
2. Mot de passe temporaire : accès bloqué hors changement ; expiré après 72 h ; renvoi invalide l'ancien.
3. Refresh : rotation OK ; réutilisation → toute la famille révoquée.
4. MFA obligatoire pour les rôles concernés.
5. PIN : 5 erreurs → blocage ; suites interdites.
6. Isolation : un utilisateur de la société A ne lit rien de la société B (IDOR sur chaque ressource).
7. Verrouillage progressif ; notification envoyée.
8. Création d'un membre famille au-delà du maximum paramétré : refusée.
9. Membre famille ne peut créer aucun compte.
10. Un utilisateur ne peut pas être rattaché à deux tenants (contrainte d'unicité) ; aucune route ne permet de changer de tenant en session.

## 9. Hors périmètre
SSO d'entreprise, authentification par clé d'accès (passkeys) : phase ultérieure.

# Spec design – Commun › Authentification à deux facteurs (TOTP) : enrôlement et défi
**Statut :** prête pour relecture (ux → conformite → securite) · **Tâche :** WD1 · **Auteur :** design · **Date :** 2026-10-11
**Routes :** `/login/mfa` (défi) et `/mfa/enroll` (enrôlement) · **Rôles :** `ADMIN`, `COMPANY`, `MERCHANT` (MFA obligatoire) · **Exigences couvertes :** cahier §6 (« MFA (OTP) admin/entreprise/commerçant »), spec 01 §3 (« MFA TOTP obligatoire pour ADMIN, COMPANY, MERCHANT »), §5 (`POST /auth/mfa/enroll`, `POST /auth/mfa/verify`), spec 04 §5 (accès Administrateur avec MFA), revue ux UX-21.
**Dépend de :** `_socle-ecrans.md`, `commun-connexion.md`, `dev-composants.md` (NC.5 `Stepper`, NC.12 `OtpInput`, `CopyField`). Contrat : `_besoins-contrat.md` §1 (CT-C-0, CT-C-2, CT-C-3, CT-C-3b).

## 1. Objectif
**Écran A – Défi :** vérifier le code à usage unique de l'application d'authentification après le mot de passe. **Écran B – Enrôlement :** associer l'application d'authentification au compte la première fois. Une page = un objectif ; **action principale unique** : « Vérifier » (A) / « Activer la double authentification » (B).

## 2. Rôles et permissions
Atteintes depuis `nextStep` (`MFA_CHALLENGE` → A, **sans aucune session** ; `MFA_ENROLL` → B, **session restreinte** posée par la connexion ou par le changement de mot de passe). Sans `challengeId` valide (A) ni session restreinte `MFA_ENROLL` (B), redirection vers `/login`. Séquence du contrat 0.2.0 §10 : MFA enrôlée → login → **défi** → (mot de passe temporaire) → espace ; MFA non enrôlée → login → (mot de passe temporaire) → **enrôlement** → espace. `EMPLOYEE` : MFA facultative (spec 01), hors périmètre web.

## 3. Structure
Page hors coquille (en-tête de `commun-connexion.md`).

### Écran A – Défi (`/login/mfa`)
`h1` « Vérification en deux étapes » · phrase « Saisissez le code à usage unique affiché dans votre application d'authentification. » · champ **Code à usage unique** (`OtpInput`) · **bouton principal** « Vérifier » · lien `tertiary` « Retour à la connexion ». *Utilisation d'un code de secours à ce stade (ux N-11) : **en attente de la décision sur les codes de secours** ; une fois rendue, un lien « Utiliser un code de secours » basculera le champ — rien n'est figé avant.*

### Écran B – Enrôlement (`/mfa/enroll`)
`Stepper` en 3 étapes (4 si l'API renvoie des codes de secours) : **1. Installer** → **2. Scanner** → **3. Confirmer** → [**4. Codes de secours**]. **Un bouton « Retour » (`tertiary`) à chaque étape à partir de la 2** (ux N-04) ramène à l'étape précédente sans perte ; à l'étape 1, qui n'a pas de précédente, le lien est « Se déconnecter » (comme la première connexion, ux N-12).
1. *Installer* : texte « Une application d'authentification, installée sur votre téléphone, affiche un code qui change régulièrement. Vous le saisirez à chaque connexion. Installez-en une, puis passez à l'étape suivante. » (ux N-04) · **exemples d'applications et lien d'aide : non figés** (contenu à décider par `main`/`securite` ; aucun canal de support n'est documenté, le lien n'est ajouté que s'il existe) · boutons « Se déconnecter » (`tertiary`) et « Continuer ».
2. *Scanner* : QR code (`size.qr-code`, image avec texte alternatif) · lien/disclosure « Je ne peux pas scanner le code » qui révèle la **clé de saisie manuelle** (`CopyField`, groupes de 4 caractères, exception NC.12 : secret d'enrôlement) · mise en garde « Ne partagez jamais ce code. » · bouton « Continuer ».
3. *Confirmer* : `OtpInput` · **bouton principal** « Activer la double authentification ».
4. *Codes de secours* (**affichée seulement si la réponse de confirmation contient des codes** : le principe est une exigence Must, SEC-A4 ; **nombre, format et procédure de perte restent en attente de décision de l'utilisateur**, l'écran ne fige donc rien) : liste des codes fournis par l'API (bloc LTR isolé, une valeur par ligne) · actions « Copier tous les codes », « Télécharger (.txt) », « Imprimer » · mise en garde « Ces codes ne seront plus affichés. Conservez-les dans un endroit sûr. » · case « J'ai conservé mes codes de secours » · bouton principal « Terminer ». Si la case n'est pas cochée, la soumission affiche l'erreur (pas de bouton désactivé, UX-13).
Après succès : `nextStep: NONE`, espace de l'utilisateur, avec un toast `success` « Double authentification activée » (`auth.mfa.enroll.done`, N-06).

## 4. Composants et tokens
`Card` desktop (`size.auth-card-max-width`, `space.8`) · `Stepper` (NC.5) · `OtpInput` (NC.12 : `size.input-height`, `type-scale.title` à chasse fixe `tabular-nums`, espacement des chiffres, `radius.input`, bordure `color.border-strong`) · `CopyField` (C.2 lecture seule, `secondary` + icône `Copy`) · QR : fond `color.surface` avec marge `space.4` (zone de silence du QR, **toujours sombre sur clair**, indépendante du thème), bordure `color.border` · disclosure : `Button` `link` · `Banner` info/warning (`warning-soft`/`warning-text` pour la mise en garde) · `Button` `primary`, `tertiary`.

## 5. Textes et clés i18n (FR de référence)
| Clé | FR |
|---|---|
| `auth.mfa.challenge.title` | Vérification en deux étapes |
| `auth.mfa.challenge.message` | Saisissez le code à usage unique affiché dans votre application d'authentification. |
| `auth.mfa.code.label` | Code à usage unique |
| `auth.mfa.code.help` | Le code change régulièrement : saisissez celui affiché maintenant dans votre application. |
| `auth.mfa.enroll.done` | Double authentification activée |
| `auth.mfa.challenge.submit` | Vérifier |
| `auth.mfa.challenge.back` | Retour à la connexion |
| `auth.mfa.error.invalid` | `errors.mfaCodeInvalid` « Code incorrect. Le code change régulièrement : saisissez celui affiché maintenant dans votre application. » (code `MFA_CODE_INVALID`, contrat 0.2.0 ; N-05) |
| `auth.mfa.error.expired` | `errors.mfaChallengeExpired` « Votre demande de connexion a expiré. Recommencez la connexion. » (code `MFA_CHALLENGE_EXPIRED`, défi valable 5 min, usage unique) |
| `auth.mfa.recovery.title` | Codes de secours |
| `auth.mfa.recovery.message` | Ces codes ne seront plus affichés. Conservez-les dans un endroit sûr. |
| `auth.mfa.recovery.copy` / `.download` / `.print` | Copier tous les codes · Télécharger (.txt) · Imprimer |
| `auth.mfa.recovery.confirm` | J'ai conservé mes codes de secours |
| `auth.mfa.recovery.confirm.required` | Confirmez que vous avez conservé vos codes pour continuer. |
| `auth.mfa.recovery.submit` | Terminer |
| `auth.mfa.enroll.title` | Activer la double authentification |
| `auth.mfa.enroll.intro` | Pour protéger votre compte, une double authentification est obligatoire. |
| `auth.mfa.enroll.step.install` / `.scan` / `.confirm` | Installer · Scanner · Confirmer |
| `auth.mfa.enroll.install.message` | Une application d'authentification, installée sur votre téléphone, affiche un code qui change régulièrement. Vous le saisirez à chaque connexion. Installez-en une, puis passez à l'étape suivante. |
| `auth.mfa.enroll.scan.message` | Dans votre application, ajoutez un compte en scannant ce code. |
| `auth.mfa.enroll.qr.alt` | Code QR à scanner avec votre application d'authentification |
| `auth.mfa.enroll.manual.toggle` | Je ne peux pas scanner le code |
| `auth.mfa.enroll.manual.label` | Clé de configuration |
| `auth.mfa.enroll.manual.warning` | Ne partagez jamais cette clé ni ce code. |
| `auth.mfa.enroll.confirm.message` | Saisissez le code affiché par l'application pour terminer l'activation. |
| `auth.mfa.enroll.next` | Continuer |
| `auth.mfa.enroll.submit` | Activer la double authentification |
Autres : `common.button.back`, `errors.rateLimited`, `errors.network`, `errors.internal`.

## 6. États
| État | Écran A (défi) | Écran B (enrôlement) |
|---|---|---|
| Repos | focus initial sur le champ code | étape 1, focus sur le titre de l'étape |
| Chargement | bouton `loading`, champ en lecture seule | étape 2 : squelette du QR (`size.qr-code`) pendant `POST /mfa/enroll` ; étape 3 : bouton `loading` |
| Code incorrect (`401 MFA_CODE_INVALID`) | message sous le champ (icône + texte), champ vidé et refocalisé | idem |
| Défi expiré, inconnu ou consommé (`401 MFA_CHALLENGE_EXPIRED`) ; session restreinte perdue (`401 UNAUTHENTICATED`) | message `auth.mfa.error.expired` + redirection vers `/login` avec focus sur le message | idem |
| Trop d'essais (`429`) | `errors.rateLimited` + compte à rebours, bouton désactivé avec raison | idem |
| Erreur serveur | `errors.internal` + Réessayer + référence | `POST /mfa/enroll` en erreur : `StateView` `inline` « Réessayer » à l'étape 2 |
| Hors connexion | bandeau C.8.4, bouton désactivé avec raison | idem ; le QR déjà affiché reste visible |
| Session expirée | N.6 (`commun-session-expiree.md`) | N.6 ; **au retour, l'enrôlement redémarre** (un nouveau secret est demandé ; l'ancien n'est jamais réaffiché) |
| Rechargement de la page | retour à `/login` si le `challengeId` n'est plus en mémoire | idem : le secret **n'est jamais rechargé** |
| Permission refusée / vide / solde insuffisant | sans objet | sans objet |

## 7. Données et contrat
| Élément | Source | Statut |
|---|---|---|
| Vérification du code | `POST /v1/auth/mfa/verify` `{ challengeId, code }` (operationId `verifyMfa`) → `SessionResult` (`nextStep`, `csrfToken`) | **E** (0.2.0) |
| Données d'enrôlement | `POST /v1/auth/mfa/enroll` (operationId `startMfaEnrollment`) → `{ otpauthUri, secretBase32, expiresAt }` | **E** |
| Confirmation d'enrôlement | `POST /v1/auth/mfa/enroll/confirm` `{ code }` (operationId `confirmMfaEnrollment`) → `SessionResult` ; codes de secours : à ajouter à cette réponse (forme **en attente de décision**) | **E** / **?** |
| Longueur du code | 6 chiffres (TOTP RFC 6238, confirmé) | **E** |
| Erreurs | `Problem` : `MFA_CODE_INVALID`, `MFA_CHALLENGE_EXPIRED`, `RATE_LIMITED`, `UNAUTHENTICATED`, `MFA_ENROLLMENT_REQUIRED` | **E** |
**QR (décision backend + avis securite, 2026-10-12) :** le QR est **généré côté client** à partir de `otpauthUri` (aucun SVG serveur : surface XSS). Rendu par un `<img>` (data URI) ou un `<canvas>`, **jamais** `innerHTML` ni `dangerouslySetInnerHTML`. La bibliothèque de QR est proposée par frontend (F1) et passe la revue de dépendance de `securite` (SC-1) et la validation de l'utilisateur (S1-03). Le secret et l'URI ne sont jamais envoyés ailleurs.

## 8. RTL
Page symétrique ; **le code, la clé de configuration et la barre du QR restent en LTR** (blocs isolés) ; `Stepper` de droite à gauche ; boutons « Continuer »/« Retour » : chevrons miroir ; le QR n'est **jamais** inversé en miroir.

## 9. Accessibilité
- `OtpInput` unique (pas de 6 cases) : `inputmode="numeric"`, `autocomplete="one-time-code"`, `aria-describedby` vers l'aide et l'erreur ; collage autorisé ; **pas d'envoi automatique** à 6 chiffres (l'utilisateur déclenche « Vérifier », prévisible pour les lecteurs d'écran).
- QR : `img` avec `alt` `auth.mfa.enroll.qr.alt` ; **alternative équivalente** = clé de configuration (accessible au clavier et lisible) ; c'est la voie pour les personnes qui ne peuvent pas scanner.
- Étapes : `Stepper` avec `aria-current="step"`, annonce « Étape 2 sur 3 : Scanner » ; le focus passe au titre de l'étape à chaque transition ; la clé de configuration est une valeur en lecture seule sélectionnable, copiable (bouton « Copier » + « Copié » annoncé).
- Erreurs : icône + texte, `role="alert"`. Contrastes : `warning-text/warning-soft` 4,51:1, `danger-text`, `text/surface`. Cibles ≥ `size.touch-target-min`.
- Ordre de focus : langue → champ code → « Vérifier » → « Retour à la connexion » ; enrôlement : langue → étape courante → contenu → bouton principal.

## 10. Responsive
`size.viewport-min` : carte pleine largeur ; le QR (`size.qr-code`) est centré et ne déborde pas ; boutons pleine largeur, action principale en barre collante en bas (N.2, UX-18) ; la clé de configuration se coupe par groupes de 4 sur plusieurs lignes ; ≥ `breakpoint.md` : carte centrée.

## 11. Sécurité (points pour `securite`)
Le secret (`secretBase32`, `otpauthUri`) est **affiché une seule fois**, jamais journalisé, jamais écrit dans l'URL, le stockage du navigateur, le presse-papiers automatique ni un état global persistant ; il est effacé de la mémoire au démontage ; le QR n'est pas mis en cache (`Cache-Control: no-store`, déjà au contrat) ; capture d'écran : rappel textuel uniquement ; `challengeId` en mémoire seulement ; aucune différence de message entre « code faux » et « code expiré » au-delà de ce que le contrat prévoit ; le compteur d'essais est serveur.

## 12. Questions et décisions ouvertes
1. **En attente de décision de l'utilisateur (nombre et format des codes de secours ; recommandation du lead : 10 codes — non adoptée) et procédure en cas de perte du téléphone.** Le **principe** des codes de secours est une exigence Must (`exigences-securite.md` SEC-A4) : l'étape 4 est spécifiée sans figer la forme ; aucun texte de récupération n'est rédigé. Impact : un compte administrateur ou commerçant sans appareil ne peut pas se reconnecter.
2. Contrat : **répondu** (0.2.0) sauf la forme des codes de secours.
3. securite : QR généré côté client validé (WD1-S03, §7).
4. ux N-04 : exemples d'applications d'authentification et lien d'aide : contenu à décider par `main` et `securite`.

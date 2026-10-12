# Spec design – Commun › Mot de passe oublié et réinitialisation
**Statut :** prête pour relecture (ux → conformite → securite) · **Tâche :** WD1 (ajout : écran lié depuis la connexion) · **Auteur :** design · **Date :** 2026-10-11
**Routes :** `/password/forgot` (demande) et `/password/reset` (réinitialisation) · publiques, hors coquille · **Exigences couvertes :** spec 01 §5 (`POST /auth/password/forgot`, `/reset` : « réinitialisation par lien/OTP à durée courte »), contrat §4 (« connexion et mot de passe oublié répondent de façon identique »), spec 09 §1 (aucun lien de connexion dans les SMS).
**Dépend de :** `commun-connexion.md`, `commun-premiere-connexion.md` (règles du mot de passe). Contrat : `_besoins-contrat.md` §1 (CT-C-5, CT-C-9, CT-C-10).
**Statut de périmètre :** cet écran n'est pas dans la liste demandée pour WD1 ; il est ajouté parce que la connexion y renvoie. Le **mécanisme exact (lien ou code à usage unique)** n'est pas décidé : la spec décrit les deux pages en gardant le moyen de preuve ouvert.

## 1. Objectif
**Demande :** saisir son identifiant pour recevoir les instructions de réinitialisation, avec une réponse **toujours identique**. **Réinitialisation :** choisir un nouveau mot de passe avec la preuve reçue. Action principale : « Envoyer les instructions » / « Enregistrer le nouveau mot de passe ».

## 2. Rôles et permissions
Public. Un utilisateur connecté qui ouvre ces routes est redirigé vers son espace.

## 3. Structure
### 3.1 Demande (`/password/forgot`)
Hors coquille (en-tête de `commun-connexion.md`) · carte : `h1` « Mot de passe oublié » · texte « Saisissez votre e-mail ou votre numéro de téléphone. Si un compte correspond, vous recevrez les instructions pour choisir un nouveau mot de passe. » · champ **Identifiant** · **bouton principal** « Envoyer les instructions » · lien `tertiary` « Retour à la connexion ». **Après envoi** : la même carte est remplacée par un message de confirmation **identique quelle que soit l'existence du compte** (« Si un compte correspond à cet identifiant, des instructions viennent d'être envoyées. ») et le lien « Retour à la connexion ».
### 3.2 Réinitialisation (`/password/reset`)
Carte : `h1` « Choisir un nouveau mot de passe » · règles (CT-C-5, comme `commun-premiere-connexion.md`) · [champ **preuve** : `OtpInput` « Code reçu » **si** le mécanisme est un code ; absent si la preuve est portée par le lien — CT-C-10] · **Nouveau mot de passe** · **Confirmer** · **bouton principal** « Enregistrer le nouveau mot de passe ». Après succès : `ResultView` léger (pastille `CircleCheck`, « Mot de passe modifié », bouton « Se connecter ») — **aucune session n'est ouverte** par la réinitialisation (contrat 0.2.0) : retour à la connexion. Lien invalide/expiré : `StateView` « Ce lien n'est plus valide » + action « Demander de nouvelles instructions ». **Aucun jeton dans l'URL affichée à l'écran ni conservé après usage** (voir §11).

## 4. Composants et tokens
Comme `commun-connexion.md` et `commun-premiere-connexion.md` : `Card` (`size.auth-card-max-width`), `Field`, `PasswordField`, `OtpInput`, `Button` `primary`/`tertiary`/`link`, `Banner` info (`color.info-soft`/`info-text`) pour la confirmation de demande, `StateView` page, `LanguageSwitcher`.

## 5. Textes et clés i18n (FR de référence)
| Clé | FR |
|---|---|
| `auth.forgot.title` | Mot de passe oublié |
| `auth.forgot.message` | Saisissez votre e-mail ou votre numéro de téléphone. Si un compte correspond, vous recevrez les instructions pour choisir un nouveau mot de passe. |
| `auth.forgot.identifier.label` | E-mail ou numéro de téléphone |
| `auth.forgot.submit` | Envoyer les instructions |
| `auth.forgot.sent` | Si un compte correspond à cet identifiant, des instructions viennent d'être envoyées. |
| `auth.forgot.back` | Retour à la connexion |
| `auth.forgot.sent.hint` | Vérifiez vos messages, y compris les courriers indésirables, et assurez-vous que l'identifiant saisi est correct. |
| `auth.forgot.restart` | Recommencer avec un autre identifiant |
| `auth.reset.title` | Choisir un nouveau mot de passe |
| `auth.reset.code.label` | Code reçu |
| `auth.reset.new.label` / `auth.reset.confirm.label` | Nouveau mot de passe / Confirmer le nouveau mot de passe |
| `auth.reset.submit` | Enregistrer le nouveau mot de passe |
| `auth.reset.done.title` | Mot de passe modifié |
| `auth.reset.done.action` | `common.button.signIn` « Se connecter » |
| `auth.reset.invalid.title` | Ce lien n'est plus valide |
| `auth.reset.invalid.message` | Demandez de nouvelles instructions pour réinitialiser votre mot de passe. |
| `auth.reset.invalid.action` | Demander de nouvelles instructions |
Les règles du mot de passe et leurs erreurs de champ : clés de `commun-premiere-connexion.md`. Erreurs génériques : `errors.*`.

## 6. États
| État | Demande | Réinitialisation |
|---|---|---|
| Repos | champ vide, focus sur l'identifiant | règles visibles, focus sur le premier champ |
| Chargement | bouton `loading` | bouton `loading` |
| Succès | message identique (§3.1), **même durée de réponse perçue** | `ResultView` « Mot de passe modifié » |
| Erreur de validation | sous le champ (identifiant vide) | sous les champs (règles, confirmation) |
| Lien/code invalide ou expiré | sans objet | `StateView` §3.2 (message unique pour invalide / expiré / déjà utilisé) |
| Trop de tentatives (`429`) | `errors.rateLimited` + compte à rebours | idem |
| Erreur serveur | `errors.internal` + Réessayer | idem |
| Hors connexion | bouton désactivé avec raison | idem |
| Session expirée / permission refusée / vide / solde insuffisant | sans objet | sans objet |

## 7. Données et contrat
| Élément | Source | Statut |
|---|---|---|
| Demande | `POST /v1/auth/password/forgot` `{ identifier }` → `202` identique | **E** (0.2.0) |
| Réinitialisation | `POST /v1/auth/password/reset` `{ token, newPassword }` (forme **provisoire** du contrat 0.2.0 : mécanisme « lien » recommandé, jeton dans le **fragment** `#token=` de l'URL, 15 min, usage unique ; **décision en attente**) | **E** (provisoire) |
| Règles affichées | `GET /v1/auth/password-policy` | **E** |
| Erreurs | `Problem` : `RATE_LIMITED`, `VALIDATION_FAILED`, `INTERNAL_ERROR` | **E** |

## 8. RTL
Comme `commun-connexion.md` : identifiant, code et mots de passe en LTR isolé, libellés alignés `start`.

## 9. Accessibilité
`<label for>`, `autocomplete="username"` (demande), `autocomplete="one-time-code"` (code), `new-password` (nouveaux mots de passe) ; confirmation de demande dans une région `status` (le focus passe au titre de la confirmation) ; erreurs `role="alert"` ; contrastes et cibles comme la connexion ; ordre de focus : langue → champs → bouton principal → lien de retour.

## 10. Responsive
Comme `commun-connexion.md` (carte pleine largeur sous `breakpoint.sm`, barre d'action collante, centrée de `size.auth-card-max-width` ensuite).

## 11. Sécurité (points pour `securite`)
Réponse, texte et délai **identiques** que le compte existe ou non ; aucun jeton de réinitialisation conservé dans l'historique du navigateur après usage (retrait de l'URL au chargement, `Referrer-Policy: no-referrer` déjà au contrat) ; lien à usage unique et à durée courte (côté API) ; aucun lien de connexion dans les SMS (spec 09) ; le front n'affiche jamais le canal d'envoi (e-mail ou SMS) pour ne pas révéler l'existence du compte ; limitation de débit par identifiant haché (contrat §8).

## 12. Questions et décisions ouvertes
1. **En attente de décision de l'utilisateur (mécanisme ; recommandation du lead : lien envoyé par e-mail, valable 15 minutes — non adoptée, la spec garde le moyen de preuve ouvert)**. **[QUESTION] backend** CT-C-9/10 : lien ou OTP ? paramètres de `reset` ; durée de validité (non affichée tant qu'elle n'est pas fournie).
2. **[DÉCISION] `main`** : confirmer l'ajout de cet écran au périmètre WD1/WF2 (non listé dans la demande initiale).

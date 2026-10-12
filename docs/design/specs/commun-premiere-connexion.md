# Spec design – Commun › Première connexion (changement obligatoire du mot de passe temporaire)
**Statut :** prête pour relecture (ux → conformite → securite) — révisée le 2026-10-12 (contrat 0.2.0, ux N-01/N-02/N-06, securite N-02) · **Tâche :** WD1 · **Auteur :** design · **Date :** 2026-10-11
**Route :** `/password/change` (session restreinte `PASSWORD_CHANGE`, hors coquille) · **Rôles :** tout utilisateur web dont le mot de passe est temporaire · **Exigences couvertes :** spec 01 §3 (mot de passe temporaire, seules `password/change` et `logout` autorisées), RG-2.2, critère d'acceptation 3 du cahier, charte §10 (« bannière mot de passe temporaire, changement obligatoire »), ENT-05, revue ux UX-21.
**Dépend de :** `_socle-ecrans.md`, `commun-connexion.md` (mise en page hors coquille, sélecteur de langue), `dev-composants.md` (NC.12 `PasswordField`), `navigation.md` N.9 (avertissement, variante absolue). Contrat : `docs/handoff/contracts/openapi.yaml` 0.2.0 §10 et `_besoins-contrat.md` §1.
**Périmètre web :** la **création du PIN** et la **biométrie** (charte §10, spec 01 §3) concernent l'application mobile ; elles n'existent pas sur le web. Le **changement volontaire** depuis le profil (session complète, champ « Mot de passe actuel » conservé, ASVS 2.1.6) n'est pas spécifié ici (écran « Mon profil » hors périmètre, conformite S-06).

## 1. Objectif
Faire choisir à l'utilisateur un mot de passe personnel à la place du mot de passe temporaire, avant tout autre usage. **Une seule action principale : « Enregistrer le nouveau mot de passe ».** Tant que ce n'est pas fait, aucune autre page n'est accessible.

## 2. Rôles et permissions
Atteinte uniquement quand `nextStep = PASSWORD_CHANGE` : soit juste après `POST /auth/login` (MFA pas encore enrôlée : **session restreinte**, cookies posés), soit juste après `POST /auth/mfa/verify` (MFA enrôlée : le défi est passé **avant**) ; ou après un `403 PASSWORD_CHANGE_REQUIRED` sur n'importe quelle route (redirection, jamais un message d'erreur). Seules les actions « changer le mot de passe », « se déconnecter » et le rafraîchissement sont possibles (contrat 0.2.0 §10). Après un rechargement, `POST /auth/refresh` renvoie l'état courant (`nextStep`). Un utilisateur qui n'a pas à changer son mot de passe et ouvre cette URL est redirigé vers l'accueil de son espace.
**Session restreinte limitée dans le temps (dispositif securite, ux N-02) :** 10 minutes au plus, que le rafraîchissement ne prolonge pas, à usage unique (conditions serveur transmises à backend par securite). Le mot de passe temporaire reste valable pour se reconnecter jusqu'à ses 72 h ou jusqu'au changement réussi : la fin des 10 minutes ne ferme que la session restreinte.

## 3. Structure
Page hors coquille (même en-tête que `commun-connexion.md` : logo, sélecteur de langue).
1. **Bannière d'information** « Mot de passe temporaire » (`Banner` info, icône `Info`) : explique pourquoi cette étape est obligatoire.
2. **Échéance**, sous la bannière : « Vous avez jusqu'à {heure} pour choisir votre mot de passe. » (`{heure}` = `restrictedUntil` fourni par l'API, formaté par `formatDateTime`, bloc LTR isolé ; **jamais calculée par le front**).
3. `h1` « Choisissez votre mot de passe ».
4. **Aide : règles du mot de passe** — liste de texte fournie par l'API (`GET /auth/password-policy`), affichée **avant** la saisie.
5. Formulaire : **Nouveau mot de passe** · **Confirmer le nouveau mot de passe**. **Pas de champ « Mot de passe temporaire »** dans ce parcours forcé : la session restreinte, ouverte quelques instants plus tôt avec ce mot de passe, fait foi (avis favorable de securite, ux N-02).
6. **Bouton principal** « Enregistrer le nouveau mot de passe ». Lien secondaire « Se déconnecter » (`tertiary`).

**Après succès :** étape suivante selon `SessionResult.nextStep` (`MFA_ENROLL` → `/mfa/enroll` ; `NONE` → l'espace). Le défi MFA n'a **pas** lieu ici : il a déjà été passé avant la session lorsque la MFA est enrôlée. Un toast `success` « Mot de passe modifié » (action mineure) est affiché sur la page suivante.

## 4. Composants et tokens
`Card` desktop (largeur `size.auth-card-max-width`, `space.8`) · `Banner` info (`color.info-soft`, texte `color.info-text`, icône `Info`, `radius.card-desktop`, `space.4`) · `PasswordField` ×2 (C.2 : `size.input-height`, `radius.input`, bordure `color.border-strong`) · `Button` `primary` pleine largeur · `Button` `tertiary` · aide `type-scale.body` `color.text` et titre de l'aide `type-scale.label` · échéance `type-scale.body` `color.text` · `LanguageSwitcher`.
Les règles ne sont **pas** présentées comme une liste de cases qui se cochent en direct : une évaluation en direct imposerait de coder la politique dans le front. L'aide est statique, la vérification est faite par le serveur à la soumission.

## 5. Textes et clés i18n (FR de référence)
| Clé | FR |
|---|---|
| `auth.passwordChange.banner.title` | Mot de passe temporaire |
| `auth.passwordChange.banner.message` | Vous vous connectez avec un mot de passe temporaire. Pour votre sécurité, choisissez dès maintenant un mot de passe personnel. |
| `auth.passwordChange.deadline` | Vous avez jusqu'à {time} pour choisir votre mot de passe. |
| `auth.passwordChange.title` | Choisissez votre mot de passe |
| `auth.passwordChange.rules.title` | Votre mot de passe doit respecter ces règles : |
| `passwordPolicy.rule.<codeEnCamelCase>` | un libellé par règle renvoyée par `GET /auth/password-policy`, clés fournies par backend : `passwordPolicy.rule.minLength` « Au moins {min} caractères » · `…maxLength` « {max} caractères au maximum » · `…notCompromised` « Ne figure pas dans une liste de mots de passe compromis » · `…notIdentifier` « Différent de votre identifiant » · `…differentFromCurrent` « Différent de votre mot de passe actuel ». **Les codes sont publiés par le contrat ; les valeurs (`min`, `max`) restent en attente de décision de l'utilisateur** |
| `auth.passwordChange.new.label` | Nouveau mot de passe |
| `auth.passwordChange.confirm.label` | Confirmer le nouveau mot de passe |
| `auth.passwordChange.confirm.mismatch` | Les deux mots de passe ne sont pas identiques. |
| `auth.passwordChange.submit` | Enregistrer le nouveau mot de passe |
| `auth.passwordChange.logout` | `nav.logout` « Se déconnecter » |
| `auth.passwordChange.done` | Mot de passe modifié |
| `auth.passwordChange.restrictedExpired` | Le délai pour choisir votre mot de passe est dépassé. Reconnectez-vous avec votre mot de passe temporaire pour recommencer. (affiché **sur `/login`**, voir §6) |
| `common.field.password.showNamed` / `.hideNamed` | Afficher : {label} / Masquer : {label} |
| `errors.field.passwordPolicyViolation` | Ce mot de passe ne respecte pas la règle suivante : {rule} (une ligne par règle non respectée ; `{rule}` = libellé `passwordPolicy.rule.*` désigné par `params.rule`). |
Cette clé correspond au code de champ du contrat 0.2.0 `PASSWORD_POLICY_VIOLATION` (une entrée par règle non respectée, `params.rule`). Les clés `auth.passwordChange.current.label` et `errors.field.currentPasswordInvalid` (`CURRENT_PASSWORD_INVALID`) ne serviront qu'au **changement volontaire** en session complète, s'il est spécifié plus tard. Autres erreurs : `errors.*` (C.9). `confirm.mismatch` est une vérification de **saisie** côté client (deux champs identiques), pas une règle métier.

## 6. États
| État | Rendu |
|---|---|
| Repos | focus initial sur le `h1` puis le premier champ ; règles et échéance visibles |
| Chargement | bouton `loading`, champs en lecture seule |
| Erreur de champ (`400 VALIDATION_FAILED`, `PASSWORD_POLICY_VIOLATION`) | message sous le champ concerné (icône + texte, une ligne par règle non respectée), résumé annoncé, focus sur le premier champ fautif ; les deux mots de passe sont vidés après une erreur de politique pour être ressaisis ; aucun seuil d'essais n'est inventé : le serveur décide du blocage (`429`) |
| Confirmation différente | erreur locale sous le champ de confirmation, sans appel API |
| Trop de tentatives (`429`) | état `errors.rateLimited` avec compte à rebours, bouton désactivé avec raison |
| Erreur serveur | `errors.internal` + Réessayer + référence ; la saisie est conservée |
| Hors connexion | bandeau C.8.4 ; bouton désactivé avec `common.state.offline.actionDisabled` |
| **Fin de la session restreinte (10 min, `401`)** | **retour sur `/login`** avec un bandeau d'information `auth.passwordChange.restrictedExpired` (« Le délai pour choisir votre mot de passe est dépassé. Reconnectez-vous avec votre mot de passe temporaire pour recommencer. ») ; **les nouveaux mots de passe saisis ne sont pas conservés** ; le message est déduit **de l'état en mémoire du client** (il était en `PASSWORD_CHANGE` et a reçu un `401`), **jamais d'un paramètre d'URL (`?reason=`) ni du stockage du navigateur** ; si la page est rechargée et que l'état mémoire est perdu, `/login` s'affiche **sans** ce bandeau ; le serveur reste générique |
| Avertissement avant la fin | `navigation.md` N.9, **variante absolue** (non prolongeable), environ 2 minutes avant `restrictedUntil` (WCAG 2.2.1) |
| Session expirée (autre cas) | N.6 — voir `commun-session-expiree.md` |
| Mot de passe temporaire expiré (72 h) | traité à la connexion (message générique) |
| Permission refusée / vide / solde insuffisant | sans objet |

## 7. Données et contrat
| Élément | Source | Statut |
|---|---|---|
| Soumission | `POST /v1/auth/password/change` (operationId `changePassword`) → `SessionResult` (`nextStep`, `csrfToken` renouvelé). Corps proposé en session restreinte : `{ newPassword }` seul (le contrat 0.2.0 exige encore `currentPassword` : **modification demandée par securite à backend**, conditions serveur : session restreinte 10 min absolues, usage unique, liée à la version du mot de passe temporaire) | **E** (à modifier) |
| Règles affichées | `GET /v1/auth/password-policy` (public, operationId `getPasswordPolicy`) → `{ rules: [{ code, params? }] }` | **E** |
| Échéance de la session restreinte | `restrictedUntil` (`Timestamp`) dans `SessionResult` ou via refresh — **fourni par l'API (CT-X-6, transmis à backend par securite)**, jamais calculé par le front | **N** |
| Erreurs | `ValidationProblem` + `FieldError` (`PASSWORD_POLICY_VIOLATION` + `params.rule`), `RATE_LIMITED`, `UNAUTHENTICATED` | **E** |
| Redirection forcée | `403 PASSWORD_CHANGE_REQUIRED` | **E** |

## 8. RTL
Mise en page symétrique, textes alignés `start` ; les champs de mot de passe saisis en LTR ; œil à `end` ; liste de règles en puces à `start` ; nombres des règles et heure d'échéance en chiffres occidentaux, bloc LTR isolé ; bannière : icône à `start`.

## 9. Accessibilité
- Landmarks, `h1`, lien d'évitement ; `<form>` ; `<label for>` ; `autocomplete="new-password"` (nouveau, confirmation) ; **collage autorisé** ; **aucune limite maximale de longueur** côté front ; aide liée par `aria-describedby` au champ « Nouveau mot de passe ».
- **Ordre de focus** (chaque œil suit son champ, WCAG 2.4.3) : sélecteur de langue → nouveau mot de passe → son œil → confirmation → son œil → « Enregistrer… » → « Se déconnecter ». Chaque œil a un **nom accessible propre** : `common.field.password.showNamed` « Afficher : {label} » (ex. « Afficher : Nouveau mot de passe »).
- Erreurs : `role="alert"`, `aria-invalid`, icône + texte ; la bannière est `role="status"` (informative, non assertive) ; l'échéance est un texte (pas une couleur), l'avertissement N.9 respecte WCAG 2.2.1.
- Contrastes : `info-text/info-soft` 5,49:1 ; `danger-text` ; cibles ≥ `size.touch-target-min` (œil compris).
- Aucune information par la couleur seule ; pas de jauge de robustesse colorée.

## 10. Responsive
`size.viewport-min` : carte pleine largeur, boutons pleine largeur, « Enregistrer… » en premier dans l'ordre de focus visuel ; **barre d'action collante** en bas (N.2, UX-18) pour que le bouton reste atteignable avec le clavier virtuel ouvert ; ≥ `breakpoint.md` : carte centrée de largeur `size.auth-card-max-width`.

## 11. Sécurité (points pour `securite`)
Aucun mot de passe dans l'URL, le stockage du navigateur, les logs, les analytics ni l'historique de formulaire (`autocomplete` correct) ; politique appliquée **uniquement** côté serveur (le front n'implémente aucune règle) ; le mot de passe temporaire n'est ni redemandé, ni affiché, ni renvoyé ; le jeton CSRF vient du corps de réponse et reste en mémoire ; le **bandeau de retour sur `/login` est déduit de l'état mémoire du client** (condition de securite) — pas de `?reason=`, rien dans `localStorage`/`sessionStorage`, le serveur reste générique ; après succès, la révocation des autres sessions est **en attente de décision** (recommandation backend : oui) ; l'échéance `restrictedUntil` vient du serveur.

## 12. Questions et décisions ouvertes
1. **En attente de décision de l'utilisateur (règles du mot de passe)** — **[DÉCISION] `main`** : valeurs de la politique (longueur minimale/maximale, etc.) ; les **codes** de règles sont publiés par le contrat 0.2.0.
2. **En attente de décision de l'utilisateur** : révocation des autres sessions après changement (recommandation backend : oui).
3. **[QUESTION] backend** : retrait de `currentPassword` en session restreinte (conditions securite) et fourniture de `restrictedUntil` (CT-X-6).
4. **ux N-06** : l'écran ne peut pas annoncer « 2 étapes » (mot de passe puis double authentification) car `nextStep` ne dit pas, avant la réponse, si l'enrôlement MFA suivra ; **[QUESTION] backend** : un indicateur (ex. `mfaEnrollmentPending`) dans `SessionResult` ? Sinon la bannière ne l'annonce pas.
5. La durée de validité du mot de passe temporaire (72 h) n'est pas affichée sur cet écran (aucune valeur codée dans le front).

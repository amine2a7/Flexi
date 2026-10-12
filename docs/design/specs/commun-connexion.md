# Spec design – Commun › Connexion
**Statut :** prête pour relecture (ux → conformite → securite) · **Tâche :** WD1 · **Auteur :** design · **Date :** 2026-10-11
**Route :** `/login` (publique, hors coquille) · **Rôles concernés :** `ADMIN`, `COMPANY`, `MERCHANT` (web) · **Exigences couvertes :** spec 01 §3 et §5 (`POST /auth/login`, verrouillage, messages génériques), cahier §6 (sécurité, MFA, WCAG 2.1 AA, FR/AR/EN), charte §7 et §10, revue ux UX-21 (sélecteur de langue hors coquille).
**Dépend de :** `_socle-ecrans.md` (Sx), `fondations-composants.md`, `dev-composants.md` (NC.x), `navigation.md` (N.6). Contrat : `_besoins-contrat.md` §1 (CT-C-0, CT-C-1, CT-C-1b, CT-C-1c).

## 1. Objectif
Permettre à un utilisateur du web de s'authentifier avec son identifiant (e-mail ou téléphone) et son mot de passe, puis de l'orienter vers l'étape suivante (changement de mot de passe, enrôlement ou défi MFA, espace). **Une seule action principale : « Se connecter ».** La page ne révèle jamais si un compte existe, est verrouillé ou est expiré.

## 2. Rôles et permissions
Page publique. Un utilisateur déjà authentifié qui ouvre `/login` est redirigé vers l'accueil de son espace. Les rôles `EMPLOYEE` et `FAMILY_MEMBER` n'ont pas d'accès web (cahier §1.2) ; la réponse du serveur à leur tentative est **[QUESTION] backend CT-C-1c** : l'écran traite `INVALID_CREDENTIALS` (message générique) ou `FORBIDDEN` (état C.8.8 « Accès refusé » sans détail sur le rôle).

## 3. Structure
Page hors coquille, fond `color.bg`, contenu centré verticalement.
1. **En-tête de page :** logo FlexiPay (à `start`) · **sélecteur de langue** (à `end`, endonymes Français · العربية · English).
2. **Carte de connexion** (`Card` desktop, largeur max `size.auth-card-max-width`) :
   - `h1` « Se connecter à FlexiPay » ;
   - phrase d'aide pour les premières connexions : « Première connexion ? Saisissez le mot de passe temporaire reçu par SMS ou par e-mail. Mot de passe temporaire expiré ? Contactez l'administrateur de votre compte. » (texte **statique et générique**, visible par tous, identique pour tous : il ne dit rien sur l'état d'un compte ; confirmé par backend le 2026-10-12) ;
   - **bandeau d'erreur** (zone vide par défaut, `role="alert"`) ;
   - champ **Identifiant** (e-mail ou téléphone) ;
   - champ **Mot de passe** (avec œil) ;
   - **bouton principal** « Se connecter » (`primary`, pleine largeur) ;
   - lien « Mot de passe oublié ? » (`link`) vers `/password/forgot`.
3. Aucun pied de page ni lien juridique (aucun texte juridique n'est rédigé par design ; à ajouter quand `conformite`/le juridique les fournit).

**Parcours après succès** (contrat 0.2.0 §10 ; l'écran suit **uniquement** `nextStep`) : `MFA_CHALLENGE` (MFA déjà enrôlée : défi **avant toute session**, aucun cookie posé) → `/login/mfa` · `PASSWORD_CHANGE` (session restreinte, mot de passe temporaire) → `/password/change` · `MFA_ENROLL` (session restreinte) → `/mfa/enroll` · `NONE` → `returnTo` s'il est valide (chemin interne, cf. `commun-session-expiree.md` §3.1), sinon l'accueil de l'espace du rôle (`/admin`, `/company`, `/merchant`) lu dans `GET /v1/me`.

## 4. Composants et tokens
- `Card` desktop : `color.surface`, `radius.card-desktop`, `shadow.card`, bordure `color.border`, padding `space.8` (`space.6` sous `breakpoint.sm`), espacement interne `space.4`.
- `Field` texte et `PasswordField` (C.2/NC.12) : `size.input-height`, `radius.input`, bordure `color.border-strong`, label `type-scale.label`, aide `type-scale.caption`.
- `Button` `primary` (C.1) : `size.button-height`, `radius.button`, pleine largeur.
- Bandeau d'erreur : `Banner` erreur (`color.danger-soft`, bordure `color.danger`, icône `CircleAlert` `color.danger`, texte `color.danger-text`, `radius.card-desktop`, padding `space.4`).
- Lien : `link` (C.1), souligné en permanence, `color.info-text`.
- `LanguageSwitcher` : `DropdownMenu` avec `RadioGroup` (bouton `tertiary` icône `Languages` + nom de la langue courante, cible ≥ `size.touch-target-min`).
- Titre `type-scale.title`, texte d'aide `type-scale.body` `color.text-muted` (4,55:1 sur `bg`, 4,76:1 sur `surface`).

## 5. Textes et clés i18n (FR de référence)
| Clé | FR |
|---|---|
| `auth.login.title` | Se connecter à FlexiPay |
| `auth.login.hint.firstTime` | Première connexion ? Saisissez le mot de passe temporaire reçu par SMS ou par e-mail. |
| `auth.login.hint.expired` | Mot de passe temporaire expiré ? Contactez l'administrateur de votre compte. |
| `auth.login.identifier.label` | E-mail ou numéro de téléphone |
| `auth.login.password.label` | Mot de passe |
| `auth.login.submit` | `common.button.signIn` « Se connecter » |
| `auth.login.forgot` | Mot de passe oublié ? |
| `auth.login.rateLimited` | `errors.rateLimited` « Trop de tentatives. Réessayez dans {seconds} secondes. » |
| `auth.login.accessDenied.title` / `.message` | `common.state.forbidden.title` « Accès refusé » / `auth.login.accessDenied.message` « Cet espace est réservé aux comptes professionnels. Utilisez l'application mobile FlexiPay. » (réponse `403 FORBIDDEN` pour `EMPLOYEE` / `FAMILY_MEMBER`, confirmée par backend ; cahier §1.2) |
| `common.language.label` | Langue |
| `language.fr` · `language.ar` · `language.en` | Français · العربية · English (endonymes, jamais traduits) |
| Erreur d'identifiants | `errors.invalidCredentials` « Identifiant ou mot de passe incorrect. Vérifiez votre saisie ou utilisez « Mot de passe oublié ? ». » (toujours générique, N-03) (message **générique unique** pour identifiants erronés, compte verrouillé, mot de passe temporaire expiré — CT-C-1b) |
| Erreur réseau / serveur | `errors.network`, `errors.internal`, `errors.serviceUnavailable` |
| Hors connexion | `common.state.offline.banner`, `common.state.offline.actionDisabled` |
Le placeholder ne remplace jamais le label. Aucun texte ne dit « compte verrouillé », « compte inexistant » ni « mot de passe expiré ».

## 6. États
| État | Rendu |
|---|---|
| Repos | formulaire vide ; focus initial sur le champ Identifiant |
| Chargement (soumission) | bouton `loading` (`aria-busy`, clics ignorés), champs en lecture seule ; annonce `common.button.loading` |
| Erreur d'identifiants (`401 INVALID_CREDENTIALS`) | bandeau d'erreur au-dessus du bouton (`role="alert"`), identifiant conservé, **mot de passe vidé**, focus sur le champ Mot de passe |
| Erreur de validation (`400 VALIDATION_FAILED`, champ vide ou invalide) | erreurs sous les champs (C.2), résumé, focus sur le premier champ fautif |
| Trop de tentatives (`429 RATE_LIMITED`) | bandeau d'erreur `errors.rateLimited` avec compte à rebours (`details.retryAfterSeconds`), annonces ≤ toutes les 10 s ; le bouton est désactivé **avec la raison** jusqu'à la fin du décompte, puis réactivé |
| Erreur serveur (`500`/`503`) | bandeau + « Réessayer » ; référence (`requestId`) copiable (C.8.3) ; `503` : réessai après `Retry-After` |
| Hors connexion | bandeau global C.8.4 ; bouton désactivé avec `common.state.offline.actionDisabled` ; champs modifiables |
| Session déjà ouverte | redirection immédiate vers l'espace (aucun flash du formulaire) |
| Retour après la fin de la session restreinte de première connexion (10 min) | bandeau d'**information** (`Banner` info, `role="status"`) au-dessus du formulaire : `auth.passwordChange.restrictedExpired` « Le délai pour choisir votre mot de passe est dépassé. Reconnectez-vous avec votre mot de passe temporaire pour recommencer. » ; **déduit de l'état en mémoire du client** (il était en `PASSWORD_CHANGE` et a reçu un `401`), **jamais d'un paramètre d'URL ni du stockage** ; si la page est rechargée et l'état perdu, le formulaire s'affiche sans ce bandeau (avis securite, ux N-02) |
| Accès refusé (`403 FORBIDDEN`, employé ou membre famille avec le bon mot de passe) | `StateView` C.8.8 avec `auth.login.accessDenied.*` et lien « Retour à la connexion » ; aucune session |
| Session expirée / permission refusée / vide / solde insuffisant | sans objet (page publique, pas de donnée) ; une session expirée mène **à** cette page |
**Conservation de la saisie :** l'identifiant est conservé après une erreur ; le mot de passe ne l'est jamais.

## 7. Données et contrat
| Élément | Source | Statut |
|---|---|---|
| Soumission | `POST /v1/auth/login` `{ identifier, password }` + en-tête `X-FlexiPay-Client: web` (operationId `login`) | **E** (0.2.0) |
| Étape suivante | `LoginResult` = `MfaChallengeResult` (`nextStep: MFA_CHALLENGE`) ou `SessionResult` (`nextStep` ∈ `NONE`, `PASSWORD_CHANGE`, `MFA_ENROLL`) | **E** |
| Jeton CSRF | `SessionResult.csrfToken` (conservé **en mémoire** uniquement) | **E** |
| Défi MFA | `MfaChallengeResult.challengeId` (opaque, usage unique), `challengeExpiresAt` (`Timestamp`, 5 min) — en mémoire, jamais dans l'URL | **E** |
| Erreurs | `Problem` (`INVALID_CREDENTIALS`, `RATE_LIMITED` + `RetryAfterDetails.retryAfterSeconds`, `VALIDATION_FAILED` + `FieldError`) | **E** |
| Rôle pour la redirection | `GET /v1/me` `Me.role` (operationId `getMe`) | **E** |
Aucun montant ni donnée métier.

## 8. RTL
Page entière en `dir="rtl"` pour l'arabe : logo à droite, sélecteur de langue à gauche ; labels, aides et erreurs alignés à `start` ; œil du mot de passe à `end` (gauche) ; **l'identifiant (e-mail, téléphone) et le mot de passe sont saisis et affichés en LTR** (`dir="ltr"` sur les `<input>`, alignés à `start`) ; compte à rebours en bloc LTR isolé ; aucune flèche.

## 9. Accessibilité
- `<main>` avec `h1` ; `<form>` ; lien d'évitement (`nav.skip`) ; tous les champs ont un `<label for>` ; `autocomplete="username"` (identifiant) et `current-password` (mot de passe) pour les gestionnaires de mots de passe (collage autorisé) ; `autocapitalize="none"`, `spellcheck="false"`.
- **Ordre de focus :** lien d'évitement → logo → sélecteur de langue → identifiant → mot de passe → œil → « Se connecter » → « Mot de passe oublié ? ».
- Erreurs : `role="alert"`, `aria-invalid` + `aria-describedby` sur les champs ; le bandeau est lié au formulaire (`aria-describedby` du `<form>`).
- Contrastes : `danger-text/danger-soft` 5,30:1, `info-text/surface` ≥ 4,5:1, `text-muted/bg` 4,55:1, `on-navy/navy` 16,97:1 (bouton). Erreur = icône + texte. Cibles ≥ `size.touch-target-min`. Le décompte `RATE_LIMITED` n'est pas annoncé à chaque seconde.
- L'œil du mot de passe : bouton `aria-pressed`, nom `common.field.password.show|hide`.

## 10. Responsive
- `size.viewport-min` → `breakpoint.sm` : carte pleine largeur (marge `space.4`), bouton pleine largeur, le sélecteur de langue reste dans l'en-tête de page.
- ≥ `breakpoint.md` : carte centrée de largeur `size.auth-card-max-width`.
- Zoom 200 % / reflow à 360 px sans défilement horizontal.

## 11. Sécurité (points pour `securite`)
Aucune énumération (message unique) ; aucun jeton dans l'URL ni `localStorage` (CSRF en mémoire ; cookies `HttpOnly` posés par l'API) ; `returnTo` validé (chemin interne, jamais `//`, schéma ou URL absolue) ; l'identifiant et le mot de passe ne sont jamais journalisés ni envoyés à des analytics ; protection contre la soumission multiple ; l'`Origin` est vérifié côté serveur (contrat §6) ; pas de champ rempli automatiquement par le front ; pas de message distinguant les causes d'échec ni leurs délais.

## 12. Questions et décisions ouvertes
1. Questions backend CT-C-1/1b/1c : **répondues** (contrat 0.2.0, 2026-10-12) : forme de `LoginResult`, message unique pour tous les refus, `403 FORBIDDEN` pour employé/membre famille.
2. Mot de passe temporaire expiré : sortie = renvoi par l'entreprise ou l'administrateur (spec 01 §3, confirmé par backend) ; l'écran le dit de façon **générique** (aide statique ci-dessus, visible par tous).
3. Le lien « Mot de passe oublié ? » mène à `commun-mot-de-passe-oublie.md` (route `POST /auth/password/forgot` de la spec 01 ; non listé dans la demande WD1, ajouté pour ne pas laisser un lien orphelin).

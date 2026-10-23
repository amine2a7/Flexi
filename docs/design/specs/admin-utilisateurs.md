# Spec design – Administrateur › Utilisateurs (liste, fiche, création d'administrateur, actions, délai de grâce)
**Statut :** à relire (ux → conformite → securite) avant code · **Tâche :** e1 · **Auteur :** design · **Date :** 2026-10-22
**Routes :** `/admin/users` (liste), `/admin/users/new` (création d'administrateur), `/admin/users/{id}` (fiche), `/admin/settings` onglet « Comptes » (délai de grâce) · **Exigences couvertes :** gestion des comptes (cahier §4, module Gestion des comptes), ADM-09 (paramétrage sous double validation), audit, RG sur les rôles.
**Dépend de :** `_socle-ecrans.md`, `commun-statut-utilisateur.md` (badges, `ReasonConfirmDialog`), `dev-composants.md` (NC.1, NC.2, NC.3, NC.10, NC.13), `navigation.md` (module `nav.admin.accounts`).

## 1. Objectif
Retrouver n'importe quel utilisateur de la plateforme, voir son état et son historique, et agir dessus de façon tracée. **Action principale :** liste = « Créer un administrateur » (visible seulement avec `users.adminRoles`, sinon la page n'a pas d'action principale) ; **fiche = pas d'action principale** : toutes les actions sont dans le menu « Actions » (aucun bouton rouge saillant) ; seul « Réactiver » est visible à côté du menu quand le compte est suspendu.

## 2. Rôles et permissions
Permissions abstraites (noms à confirmer par backend, S8) :
| Permission | Donne |
|---|---|
| `users.read` | voir la liste, la fiche, l'historique d'audit |
| `users.manage` | modifier un utilisateur non administrateur, suspendre/réactiver/désactiver, réinitialiser le mot de passe (super-admin seul, décision C du 2026-10-23) |
| `users.support` | renvoyer l'invitation, débloquer le PIN (super-admin et Support ; tracé, l'utilisateur est notifié) |
| `userBalances.read` | voir le solde d'un employé (super-admin, Finance, Opérations ; jamais Support) |
| `users.adminRoles` | créer un administrateur, changer le rôle d'un administrateur, gérer le statut d'un administrateur, modifier le délai de grâce |
| Matrice actuelle | `SUPER_ADMIN` : les trois. `COMPLIANCE`, `FINANCE`, `SUPPORT` : **à décider** (proposition en §12.1) |
Conditions d'affichage (un bouton interdit n'existe pas dans le DOM) :
| Élément | Condition |
|---|---|
| Entrée de menu « Gestion des comptes » → onglet Utilisateurs | `users.read` |
| « Créer un administrateur » | `users.adminRoles` |
| Modifier / Suspendre / Réactiver / Désactiver | `users.manage` (cible non administrateur) ou `users.adminRoles` (cible administrateur) **et** cible ≠ soi-même **et** transition valide pour l'état **et** pas de `pendingChange` sur le compte |
| Changer le rôle | `users.adminRoles` **et** cible = administrateur **et** cible ≠ soi-même |
| Renvoyer l'invitation | `users.support`, cible ≠ soi-même, compte Invité ou Actif (absent si suspendu ou désactivé) |
| Débloquer le PIN | `users.support`, cible de rôle employé (membre de la famille inclus **[à confirmer]**), PIN effectivement bloqué (`pinLocked`) ; l'utilisateur est notifié |
| Approuver / refuser une demande en attente | `canApprove: true` fourni par l'API ; l'initiateur n'a jamais ce bouton (`isInitiator`) |
| Onglet « Comptes » (délai de grâce), bouton « Modifier » | lecture : `users.read` ; modification : `users.adminRoles` |
Transitions d'état : Actif ↔ Suspendu ; Actif ou Suspendu → Désactivé ; Invité → Actif automatiquement à la première connexion ; Invité → Suspendu ; Invité → Désactivé (détail `commun-statut-utilisateur.md` §3.1). Aucune suppression, aucun retour depuis Désactivé.
**Sur sa propre fiche** : aucun bouton de rôle ni de statut (ni message). Le dernier super-administrateur : pas de Suspendre/Désactiver, phrase `common.userStatus.lastSuperAdmin`.

## 3. Structure
### Écran A – Liste (`/admin/users`)
1. `h1` « Utilisateurs » ; action principale « Créer un administrateur » à `end` (N.2).
2. `FilterBar` : recherche (nom, e-mail, téléphone masqué non cherchable) · Rôle · Sous-rôle (actif quand le rôle = Administrateur ou rôle de tenant) · Statut (Actif, Invité, Suspendu, Désactivé), même liste que côté entreprise · Entreprise/commerçant (champ de recherche à choix, `Combobox`) · « Effacer les filtres » · pastilles.
3. Compteur puis `DataTable` (NC.1), filtres/tri/curseur dans l'URL :
| Colonne | Type | Tri | Carte mobile |
|---|---|---|---|
| Nom (+ e-mail en légende, LTR) | `identity` (lien vers la fiche) | oui (défaut `lastName`) | titre |
| Rôle | `text` (`role.*`) | oui | meta |
| Sous-rôle | `text` (`role.sub.*`) | non | meta |
| Entreprise / commerçant | `text` | oui | meta |
| Statut | `UserStatusBadge` | oui | badge |
| Dernière connexion | `date` | oui | meta |
4. Pagination « Précédent / Suivant » (tableau) ou « Charger plus » (cartes). Une demande en attente se voit par un second badge « En attente de seconde validation » sous le statut.
### Écran B – Fiche (`/admin/users/{id}`)
`h1` = nom ; lien « Retour aux utilisateurs » (restitue filtres) ; `UserStatusBadge` ; bandeau `PendingApprovalBanner` si `pendingChange` (avec `ChangeDiff` et `ApprovalActions` NC.10 : auteur voit « Vous avez initié cette demande : un autre administrateur doit l'approuver. »).
Zones : 1. **Identité** (`DescriptionList` : nom, e-mail, téléphone masqué `MaskedValue`, rôle, sous-rôle, tenant, créé le, dernière connexion). 2. **Actions** (menu « Actions » `DropdownMenu` en bureau ; tous les éléments sont des boutons nommés par le résultat) : Modifier · Suspendre/Réactiver · Désactiver · Changer le rôle · Renvoyer l'invitation · Débloquer le PIN. Sur sa propre fiche, ou si aucune action n'est permise, la section Actions n'est pas rendue (pas de titre vide). 3. **Sécurité du compte** (employé : PIN bloqué oui/non ; MFA activée oui/non, jamais de secret). 4. **Historique des changements** (`AuditTimeline`, liste `<ol>` : date et heure, auteur, action, motif, ancienne → nouvelle valeur ; « Charger plus »). 5. Employé : lien « Voir la fiche entreprise » ; **solde côté admin : [À DÉCIDER, §12.6]** (si oui, mêmes libellés par état que `entreprise-employes.md` §3.C).
### Écran C – Création d'un administrateur (`/admin/users/new`, `users.adminRoles`)
`h1` « Créer un administrateur » ; lien « Retour aux utilisateurs ». Formulaire une colonne (`size.form-max-width`) : Prénom · Nom · E-mail · Téléphone · **Sous-rôle** (`RadioGroup` de cartes, une description sous chaque choix) : Super-administrateur, Opérations (COMPLIANCE), Finance, Support (descriptions en §5) · Motif (même champ et mêmes bornes que `ReasonConfirmDialog`). Bouton principal « Soumettre la demande » (création en double validation, S7.3) ; `ConfirmDialog` avec `ChangeDiff` et ligne `common.reason.approvalNote`. Le mot de passe temporaire n'est jamais saisi ni affiché : il part dans l'invitation par e-mail. Choisir « Super-administrateur » affiche, sous le choix et dans la confirmation, un `Banner` `warning` (icône `TriangleAlert` + texte) : « Ce rôle donne tous les droits. »
### Écran D – Actions (modales, sur la fiche)
- **Modifier** : **un seul écran** (UX-15) : formulaire (prénom, nom, e-mail, téléphone) avec le champ **Motif** dans le même formulaire, puis confirmation avec `ChangeDiff` des champs changés (pas de seconde modale empilée) **[motif requis pour modification : à confirmer §12.5]**. Mobile : le bouton principal précède aussi dans le DOM (pas d'inversion visuelle seule).
- **Suspendre / Réactiver / Désactiver / Changer le rôle** : `ReasonConfirmDialog` (commun). Employé désactivé : variante grâce (§3.4 commun). Création d'administrateur et changement de rôle : succès = « Demande soumise pour approbation ». Tant qu'une demande est en attente sur le compte, ces actions sont absentes. Le retrait de sa propre demande par l'initiateur est une question ouverte (§12.10).
- **Renvoyer l'invitation** (libellé unique, aussi pour la réinitialisation) : `ConfirmDialog` « Envoyer une nouvelle invitation à {name} ? » ; conséquence « Un mot de passe temporaire valable 72 h lui est envoyé par e-mail. Ses sessions actuelles seront fermées et il devra le changer à sa connexion. » ; motif requis (identique côté entreprise). Résultat : seulement « Une invitation avec un mot de passe temporaire a été envoyée à {name}. » (`ResultView`). **Le mot de passe n'est jamais affiché ni renvoyé par l'API** (décision du 2026-10-14) : aucun bouton « Copier le mot de passe ». Action absente si le compte est suspendu ou désactivé.
- **Débloquer le PIN** : `ConfirmDialog` « Débloquer le PIN de {name} ? » ; conséquence « L'employé pourra de nouveau saisir son PIN. » ; motif requis. Le PIN lui-même n'est jamais visible ni modifiable.
### Écran E – Délai de grâce (onglet « Comptes » du Paramétrage, `/admin/settings`)
Le module `nav.admin.settings` porte déjà des onglets (Commissions, Catégories, Plafonds, Seuils, Cycles) : ajouter l'onglet **« Comptes »** (pas de fiche dédiée : un seul paramètre, même rythme que les autres paramétrages). Contenu : carte « Délai de grâce après désactivation » : valeur actuelle `{days} jours`, texte d'aide « Durée pendant laquelle un employé désactivé peut encore dépenser son solde. » ; état en attente avec `PendingApprovalBanner` + `ChangeDiff` (30 → 45 jours) ; bouton « Modifier » (`users.adminRoles`). Modale : `NumberField` (entier en jours, bornes fournies par l'API) + motif ; `ConfirmDialog` avec `approvalNote` ; succès « Demande soumise pour approbation ». Historique des changements du paramètre en dessous (`AuditTimeline`). La valeur ne s'applique qu'aux désactivations futures **[à confirmer, §12.7]** : texte d'aide affiché seulement si confirmé.

## 4. Composants et tokens
`DataTable`, `FilterBar`, `Combobox`, `RadioGroup`, `DropdownMenu`, `DescriptionList`, `AuditTimeline` (liste `<ol>` ; trait `color.border`, point `color.navy`, date `type-scale.caption` `color.text-muted`), `UserStatusBadge`, `PendingApprovalBanner`, `ChangeDiff`, `ApprovalActions`, `ReasonConfirmDialog`, `MaskedValue`, `StateView`, `Button` (`primary` pour l'action principale, `danger` pour suspendre/désactiver, `secondary` pour le reste, `tertiary` pour annuler). Tokens : `color.bg/surface/border/text/text-muted/navy`, `space.2/4/6`, `radius.card-desktop`, `size.table-row-height`, `size.chip-height`, `size.form-max-width`, `size.modal-max-width`, `size.icon-sm`, table `status`. Aucune valeur en dur.

## 5. Textes et clés i18n (FR de référence)
| Clé | FR |
|---|---|
| `admin.users.title` | Utilisateurs |
| `admin.users.action.create` | Créer un administrateur |
| `admin.users.filter.search` | Rechercher par nom ou e-mail |
| `admin.users.filter.role` / `.subRole` / `.status` / `.tenant` | Rôle · Sous-rôle · Statut · Entreprise ou commerçant |
| `admin.users.table.caption` | Liste des utilisateurs |
| `admin.users.col.name` / `.role` / `.subRole` / `.tenant` / `.status` / `.lastLogin` | Nom · Rôle · Sous-rôle · Entreprise / commerçant · Statut · Dernière connexion |
| `admin.users.table.count` | {count, plural, one {# utilisateur} other {# utilisateurs}} |
| `admin.users.lastLogin.never` | Jamais connecté |
| `admin.users.empty.title` / `.message` | Aucun utilisateur / Les comptes créés apparaîtront ici. |
| `admin.users.empty.action` | Créer un administrateur (si `users.adminRoles`, sinon aucune action) |
| `admin.users.error.title` | Impossible de charger les utilisateurs |
| `admin.users.detail.title` | {name} |
| `admin.users.detail.back` | Retour aux utilisateurs |
| `admin.users.detail.section.identity` / `.actions` / `.security` / `.history` | Identité · Actions · Sécurité du compte · Historique des changements |
| `admin.users.field.firstName` / `.lastName` / `.email` / `.phone` / `.role` / `.subRole` / `.tenant` / `.createdAt` | Prénom · Nom · Adresse e-mail · Téléphone · Rôle · Sous-rôle · Entreprise ou commerçant · Créé le |
| `admin.users.security.pinLocked` / `.pinOk` | PIN bloqué / PIN actif |
| `admin.users.security.mfa` | Authentification à deux facteurs : {state} |
| `admin.users.action.menu` | Actions |
| `admin.users.action.edit` / `.suspend` / `.reactivate` / `.deactivate` / `.changeRole` / `.resendInvitation` / `.unlockPin` | Modifier · Suspendre · Réactiver · Désactiver · Changer le rôle · Renvoyer l'invitation · Débloquer le PIN |
| `admin.users.create.title` | Créer un administrateur |
| `admin.users.create.submit` | Soumettre la demande |
| `admin.users.create.success` | Demande soumise pour approbation. |
| `role.sub.COMPLIANCE.label` | Opérations |
| `admin.users.create.superAdminWarning` | Ce rôle donne tous les droits. |
| `status.INVITE` | Invité (voir commun) |
| `admin.users.subRole.desc.SUPER_ADMIN` | Tous les droits de lecture et d'action. Ne valide jamais une opération qu'il a lui-même créée. |
| `admin.users.subRole.desc.COMPLIANCE` | Valide les dossiers KYC, consulte leurs pièces et confirme les commandes de crédits. Ne crée pas de comptes commerçant ou entreprise. |
| `admin.users.subRole.desc.FINANCE` | Valide les commandes et les virements, et donne la seconde validation des opérations sensibles. |
| `admin.users.subRole.desc.SUPPORT` | Traite les messages des visiteurs. Lecture de la plateforme. |
| `admin.users.pending.initiator` | Vous avez initié cette demande : un autre administrateur doit l'approuver. |
| `admin.users.reset.title` | Envoyer une nouvelle invitation à {name} ? |
| `admin.users.reset.effect` | Un mot de passe temporaire valable 72 h lui est envoyé par e-mail. Ses sessions actuelles seront fermées et il devra le changer à sa connexion. |
| `admin.users.reset.confirm` | Envoyer l'invitation |
| `admin.users.reset.success` | Une invitation avec un mot de passe temporaire a été envoyée à {name}. |
| `admin.users.unlock.title` | Débloquer le PIN de {name} ? |
| `admin.users.unlock.effect` | L'employé pourra de nouveau saisir son PIN. |
| `admin.users.unlock.confirm` | Débloquer le PIN |
| `admin.users.history.empty` | Aucun changement enregistré. |
| `admin.users.history.entry` | {actor} a effectué : {action} |
| `admin.users.history.reason` / `.from` / `.to` | Motif · Ancienne valeur · Nouvelle valeur |
| `admin.users.forbidden.title` / `.message` | Accès refusé / Vous n'avez pas le droit de consulter les utilisateurs. |
| `admin.settings.accounts.tab` | Comptes |
| `admin.settings.accounts.grace.title` | Délai de grâce après désactivation |
| `admin.settings.accounts.grace.value` | {days, plural, one {# jour} other {# jours}} |
| `admin.settings.accounts.grace.help` | Durée pendant laquelle un employé désactivé peut encore dépenser son solde. |
| `admin.settings.accounts.grace.edit` | Modifier le délai |
| `admin.settings.accounts.grace.confirm` | Soumettre la modification |
Les libellés d'état et de statut : `status.*` ; erreurs : `errors.*`.

## 6. États
| État | Liste | Fiche | Création | Délai de grâce |
|---|---|---|---|---|
| Chargement | squelette `UI.skeletonRowsInitial` | squelette zones | formulaire direct | squelette carte |
| Vide | `StateView` inline (§5) | historique vide | sans objet | sans objet |
| Vide après filtre | `common.state.emptyFiltered.*` | sans objet | sans objet | sans objet |
| Erreur | `StateView` + Réessayer + `requestId` | idem, 404 = C.8.9 | erreur inline + saisie conservée | idem |
| Hors connexion | C.8.4, actions désactivées avec raison | idem | idem | idem |
| Session expirée | N.6 | N.6 | N.6, formulaire non conservé | N.6 |
| 403 | C.8.8 (page entière) ; filtres inutiles | action absente ; fiche `users.read` manquante : C.8.8 | C.8.8 | onglet masqué sans `users.read`, bouton absent sans `adminRoles` |
| Succès | bandeau persistant après action | `ResultView` / bandeau ; reset : message d'invitation envoyée (aucun secret) | « Demande soumise pour approbation » + lien vers la demande en attente (liste des approbations), jamais vers une fiche utilisateur (anti-énumération) | bandeau « Demande soumise pour approbation » + `PendingApprovalBanner` |
| Conflit 409 | sans objet | bandeau « Actualiser » | idem | idem |
| Doublon e-mail ou téléphone | sans objet | **même succès** qu'une adresse neuve (aucun message de doublon) | **même succès** (§Anti-énumération) | sans objet |
| Dernier super-admin / soi-même | sans objet | actions absentes (§2) | sans objet | sans objet |
| Solde insuffisant | sans objet | sans objet | sans objet | sans objet |
**Anti-énumération :** en création ou modification d'e-mail/téléphone, si la valeur existe ailleurs, l'écran affiche exactement le même résultat de succès que pour une valeur neuve (« Demande soumise pour approbation. » pour un administrateur) ; le serveur gère la suite en interne (courriel au propriétaire existant éventuel). Aucune erreur de champ « déjà utilisé » n'est prévue sur cet écran, y compris pour un administrateur (l'unicité du tenant ne concerne pas l'admin).

## 7. Données et contrat
Voir « Besoins de contrat ». Montants : sans objet sur cet écran. Dates : `Timestamp` via `formatDateTime`, `CalendarDate` telle quelle.

## 8. RTL
Colonnes inversées ; e-mail, téléphone masqué, identifiants, dates numériques en blocs LTR isolés ; chevrons « Retour » en miroir ; la frise d'audit se place à `start` ; la flèche de `ChangeDiff` en miroir ; cartes de sous-rôle alignées `start`.

## 9. Accessibilité (WCAG 2.1 AA)
Tableau : `caption`, `th scope`, `aria-sort` ; le nom est le lien (nom accessible « Utilisateur {nom} ») ; statut = icône + texte ; filtres dans `form role="search"` ; compteur annoncé ; `RadioGroup` des sous-rôles : `fieldset`/`legend`, description reliée par `aria-describedby` ; menu Actions : clavier (flèches, Échap), cible ≥ `size.touch-target-min` ; résultat de réinitialisation annoncé en `status`, focus sur la zone de résultat ; `AuditTimeline` : liste ordonnée, date dans `<time>` ; résumé d'erreurs (S4.3) ; ordre de focus : action principale → filtres → table → pagination ; fiche : `h1` → bandeau en attente → actions → sections ; contrastes des tokens, aucune information par la couleur seule.

## 10. Responsive
`size.viewport-min` : liste en cartes (titre = nom, badge sous le nom, rôle/tenant/dernière connexion en légende), filtres dans un panneau « Filtres (n) », action principale sous le `h1` pleine largeur ; fiche : sections empilées, menu Actions devient une feuille basse (`Sheet`) de boutons pleine largeur ; ≥ `breakpoint.md` tableau ; ≥ `breakpoint.lg` toutes les colonnes ; fiche en deux colonnes (identité à `start`, historique à `end`) ; contenu max `size.desktop-max-width`.

## 11. Sécurité (points pour `securite`)
Permissions lues de `GET /v1/me`, autorité serveur (`403`/`404`) ; jamais de tenant passé en paramètre côté client pour agir ; mot de passe temporaire : jamais affiché ni renvoyé par l'API (invitation par e-mail seulement) ; PIN jamais affiché ; téléphone/e-mail masqués fournis masqués ; auteur d'une demande ne peut pas l'approuver (UI + serveur) ; auto-modification impossible (UI + serveur) ; dernier super-admin protégé côté serveur ; anti-énumération (§6) ; motif échappé ; `Idempotency-Key` par action ; audit écrit par le serveur seulement.

## 12. Questions ouvertes (avec recommandation)
1. **Tranché (décision C du 2026-10-23)** : `users.read` pour tous les administrateurs ; `users.manage` et `users.adminRoles` super-admin seul ; `users.support` super-admin et Support ; `userBalances.read` super-admin, Finance, Opérations.
2. **Libellé « Opérations » : tranché par l'utilisateur** pour COMPLIANCE (`role.sub.COMPLIANCE.label`). La mention « Conformité » de `navigation.md` reste à corriger (hors de ce périmètre : à signaler à `main`).
3. **Descriptions des sous-rôles : fournies** (matrice du 2026-10-21, §5). Prérequis levé.
4. **Tranché (décisions A, B, D du 2026-10-23)** : (a) pas de double validation pour la suspension, la réactivation, la désactivation, la création ou le changement de rôle d'un administrateur : le super-admin agit seul, avec motif, tracé dans l'audit ; (b) sans objet (pas de second validateur pour la gestion des utilisateurs) ; (c) le dernier super-admin ne peut être ni suspendu, ni désactivé, ni rétrogradé ; personne ne modifie son propre rôle ni son propre statut.
5. **Motif obligatoire pour une simple modification** (nom, téléphone) ? Recommandation : oui côté admin (audit « motif »), facultatif non retenu.
6. **Tranché (D4)** : solde visible en lecture seule, fourni par l'API, sous `userBalances.read` (super-admin, Finance, Opérations) ; absent pour Support.
7. **Délai de grâce** : s'applique-t-il aux désactivations déjà en cours ? Recommandation : non, valeur figée (`graceDays`) au moment de la désactivation, comme le snapshot de commission ; bornes (min/max) à fournir par l'API.
8. **Tranché (D3)** : utilisateurs internes entreprise/commerçant gérés ici seulement ; changement de leur rôle sous `users.manage`, sans double validation.
9. **Création d'un utilisateur non administrateur** par l'admin : hors périmètre de cette spec (comptes créés par l'entreprise ou le parcours commerçant).
10. **Tranché (D8) : oui aux deux user stories ux** : retirer sa propre demande en attente (UX-17) ; être averti qu'aucun second validateur n'existe (UX-04, message `approversAvailable: false`) — ces deux cas ne concernent plus que les demandes à double validation (argent, paramétrage).

## Besoins de contrat
| Route proposée | Usage |
|---|---|
| `GET /v1/admin/users?q&role&subRole&status&tenantId&sort&cursor&withCount` | liste ; `User { id, firstName, lastName, email, phoneMasked, role, subRole, tenant{id,name}, status, graceUntil?, lastLoginAt?, pendingChange?, pinLocked? }` |
| `GET /v1/admin/users/{id}` | fiche ; ajoute `mfaEnabled`, `createdAt`, `graceDays?`, `balanceMillimes?` (si §12.6) |
| `GET /v1/admin/users/{id}/audit?cursor` | historique : `{ at, actor{id,name}, action, reason, from, to }` (valeurs filtrées, sans donnée sensible) |
| `POST /v1/admin/users` | création d'administrateur : `{ firstName, lastName, email, phone, subRole, reason }` → `202` avec `pendingChange` ; même `202` si l'e-mail existe déjà |
| `PATCH /v1/admin/users/{id}` | modification + `reason` |
| `POST /v1/admin/users/{id}/suspend` · `/reactivate` · `/deactivate` · `/role` | avec `reason` ; effet immédiat, sans double validation (décision A) ; refus si cible = soi-même ou dernier super-admin (décision B) |
| `POST /v1/admin/users/{id}/reset-invitation` | nouvelle invitation par e-mail (mot de passe temporaire 72 h, sessions fermées) ; `202` sans secret |
| `POST /v1/admin/users/{id}/unlock-pin` | employés seulement |
| `POST /v1/admin/approvals/{id}/approve|reject` | existant ou à créer (`canApprove`, `isInitiator`) |
| `GET/PUT /v1/admin/settings/account-grace-period` | `{ days, bounds{min,max}, pendingChange? }` ; PUT en double validation |
| Erreurs | `422 LAST_SUPER_ADMIN`, `403 FORBIDDEN` (auto-modification), `409`, `422` sur `reason` |
| `GET /v1/me` | `permissions[]` avec `users.read`, `users.manage`, `users.adminRoles` ; `id` pour reconnaître sa propre fiche |

# Spec design – Entreprise › Employés (liste, fiche, création, statut, import conservé)
**Statut :** à relire (ux → conformite → securite) avant code · **Tâche :** e1 · **Auteur :** design · **Date :** 2026-10-22
**Routes :** `/company/employees` (code actuel : `/entreprise/employes`) : liste · `/company/employees/{id}` : fiche · `/company/employees/import` : import CSV (inchangé) · **Exigences couvertes :** gestion des employés (cahier §4, module Entreprise), cycle de vie des comptes (décisions du 2026-10-22), audit.
**Dépend de :** `_socle-ecrans.md`, `commun-statut-utilisateur.md`, `dev-composants.md` (NC.1, NC.2, NC.3, NC.13), `entreprise-attribution.md` (blocage d'attribution), écran existant `apps/web/.../entreprise/employes/page.tsx` (colonnes Nom+matricule, E-mail, Téléphone, Alloué du mois, Statut ; filtres recherche + statut ; modale « Ajouter » ; boutons Importer, Ajouter, Attribuer).

## 1. Objectif
Gérer ses propres employés : les retrouver, voir leur état et leur solde, créer, modifier, suspendre/réactiver et désactiver. **Action principale de la liste :** « Attribuer des crédits » (lien existant) ; « Ajouter un employé » et « Importer un fichier CSV » restent `secondary`. **Fiche :** action principale non destructive : « Attribuer des crédits » si le compte est éligible (actif), sinon « Modifier » ; **Suspendre** et **Désactiver** sont dans le menu « Actions » (`secondary`), jamais en bouton rouge saillant ; « Réactiver » (`secondary`) pour un suspendu ; compte désactivé : aucune action principale.

## 2. Rôles et permissions
| Permission (abstraite, nom à confirmer) | Donne | Sous-rôles entreprise (matrice actuelle) |
|---|---|---|
| `employees.read` | liste, fiche, historique, solde, membres de la famille | OWNER, MANAGER (RH), READ_ONLY |
| `employees.manage` | créer, modifier, importer, suspendre, réactiver, désactiver, réinitialiser, attribuer | OWNER, MANAGER |
| (aucune) | l'entrée « Employés » n'existe pas dans le menu | ACCOUNTANT : accès refusé (C.8.8 si l'URL est ouverte directement) |
Conditions d'affichage : « Ajouter » · « Importer » · « Attribuer » · cases à cocher · barre d'actions groupées · Modifier/Suspendre/Réactiver/Désactiver/Réinitialiser : `employees.manage`. READ_ONLY voit liste et fiche sans aucun de ces éléments (pas de colonne de cases, pas de menu). **Un bouton interdit est absent**, jamais grisé.
L'entreprise ne gère que **ses** employés (tenant de la session) ; un employé d'une autre entreprise répond `404`. **Les membres de la famille ne sont jamais gérables par l'entreprise** : lecture seule.

## 3. Structure
### Écran A – Liste
1. `h1` « Employés » ; en-tête : « Attribuer des crédits » (principal), « Ajouter un employé » et « Importer » (`secondary`).
2. `FilterBar` : recherche (nom, matricule, e-mail) · Statut (Actif, Invité, Suspendu, Désactivé, même liste que côté admin) · **Service** (`Select`, valeurs fournies par l'API) · « Effacer ». Compteur.
3. `DataTable` (NC.1) :
| Colonne | Type | Tri | Carte mobile |
|---|---|---|---|
| Sélection (case, `employees.manage` seulement) | `checkbox` | non | case en haut à `start` |
| Nom + matricule (LTR) | `identity` (lien fiche) | oui (`lastName`) | titre |
| Service | `text` | oui | meta |
| E-mail (LTR) | `text` | non | meta (masquée sous `md`) |
| Téléphone masqué | `text` | non | masqué |
| Alloué du mois | `amount` | oui | montant |
| Statut | `UserStatusBadge` ; désactivé en grâce : « Désactivé — délai de grâce jusqu'au {date} » | oui | badge |
4. **Sélection multiple** : case d'en-tête = « Tout sélectionner sur cette page » ; la sélection ne dépasse jamais la page affichée et **est vidée (et annoncée) à tout changement de filtre, de tri ou de page**. Dès qu'une ligne est cochée, une **barre d'actions groupées** apparaît : « {count} sélectionné(s) » · **Suspendre** · **Réactiver** · « Désélectionner ». Chaque action n'apparaît que si au moins une ligne peut subir la transition (Suspendre : actifs et invités ; Réactiver : suspendus). Les lignes désactivées ne sont pas sélectionnables (case absente + libellé accessible « Désactivé : aucune action possible »). Désactivation **jamais en masse** **[à confirmer, §12.1]**. Barre sur mobile : repliable, avec un espace réservé sous la liste égal à sa hauteur et `scroll-padding-bottom`, pour ne jamais masquer « Charger plus » ni le dernier élément (zoom 200 % compris).
5. Pagination « Précédent / Suivant » (tableau) ou « Charger plus » (cartes).
### Écran B – Action groupée
`ReasonConfirmDialog` (commun). **Avant de confirmer**, le récapitulatif annonce : « {n} seront suspendus » · « {m} ignorés (transition impossible : déjà suspendus ou désactivés) » avec la liste des noms (max visibles puis « et {n} autres ») · « {k} membres de la famille seront aussi suspendus » (aperçu fourni par l'API). Un seul motif pour tout le lot. **Après** : `ResultView` **par ligne** : « {ok} suspendus, {failed} non traités » (clé propre à chaque action) avec, pour chaque échec, le nom et la raison (`messageKey`) et « Réessayer pour les échecs ».
### Écran C – Fiche (`/company/employees/{id}`)
`h1` = nom ; lien « Retour aux employés » ; `UserStatusBadge` ; bandeau d'état éventuel (§6). Zones :
1. **Identité** (`DescriptionList`) : matricule, prénom, nom, service, e-mail, téléphone masqué (`MaskedValue`), date d'entrée dans le système.
2. **Solde** (carte) : montant = `balanceMillimes` **tel que renvoyé par l'API**, `Amount lg`, jamais recalculé ni additionné côté client (S6). **Le libellé dépend de l'état** : « Solde disponible » (actif) · « Solde bloqué » (suspendu, icône `Lock` + texte « conservé mais non utilisable ») · « Solde restant » (désactivé en grâce, avec « L'employé peut encore le dépenser jusqu'au {date}. ») · compte fermé : montant toujours affiché (`0,000 TND` si nul, jamais vide) + texte de fermeture `closedNote`. Détail par type de crédit si l'API le fournit (`AmountBreakdown`, `credit-type`).
3. **Actions** : action principale selon l'état (voir §1) ; menu « Actions » (`employees.manage`) : Modifier · Suspendre/Réactiver · Désactiver · Renvoyer l'invitation (Invité ou Actif ; absent si suspendu ou désactivé) ; « Attribuer des crédits » **absent** si l'employé est suspendu ou désactivé et remplacé par le texte `company.employees.detail.noAllocation` « L'attribution est impossible : ce compte est suspendu. » / « …désactivé. » ; actions de statut absentes tant qu'une demande est en attente sur le compte.
4. **Historique** : deux onglets `Tabs` : « Transactions » (liste en lecture seule, montants API, statut `status`) et « Changements du compte » (`AuditTimeline` : date et heure, auteur, action, **motif**, ancienne → nouvelle valeur ; un auteur administrateur FlexiPay s'affiche « Administrateur FlexiPay » sans nom ; motifs de l'admin : voir §12.8).
5. **Famille** (lecture seule, section « Membres de la famille », visible : l'entreprise voit sans gérer) : liste d'au plus {n} cartes : prénom, lien (`relation`), `UserStatusBadge`, et pour les cascades « Suspendu avec l'employé » / « Désactivé avec l'employé ». **Aucun bouton** dans cette section. Aucun solde de membre n'est affiché (non fourni).
### Écran D – Création / modification
Modale existante `AddEmployee` conservée : champs Matricule, Prénom, Nom, E-mail, Téléphone (+216), **Service** (nouveau, facultatif). Modification : **un seul écran** (formulaire avec champ Motif inclus, puis confirmation avec `ChangeDiff`, pas de modales empilées), matricule non modifiable **[à confirmer]**. Bouton « Ajouter l'employé » / « Enregistrer » ; création : pas de motif. Message de succès et temps de réponse identiques en cas de doublon externe (test de non-différence à fournir à `qualite`).
**Doublons :** matricule déjà utilisé **dans la même entreprise** ou e-mail déjà utilisé **dans la même entreprise** → erreur de champ (`409`/`422`, clé `company.employees.error.duplicateEmployeeNumber` / `duplicateEmail`). E-mail ou téléphone déjà utilisé **ailleurs** (autre entreprise, autre compte) → **même succès** qu'une adresse neuve (« Employé ajouté. »), sans aucun indice ; le serveur invite ou rattache en interne.
### Écran E – Statut et réinitialisation
Suspendre/Réactiver/Désactiver : `ReasonConfirmDialog` (variante employé : §3.3-3.4 commun, rappel exact du délai de grâce, de la famille et de l'irréversibilité). **Renvoyer l'invitation** (libellé unique, motif requis comme côté admin) : `ConfirmDialog` « Envoyer une nouvelle invitation à {name} ? » ; conséquence « Un mot de passe temporaire valable 72 h lui est envoyé par e-mail. Ses sessions actuelles seront fermées et il devra le changer à sa connexion. ». Résultat : « Une invitation avec un mot de passe temporaire a été envoyée à {name}. » ; **aucun mot de passe n'est jamais affiché ni renvoyé par l'API**. Action absente si le compte est suspendu ou désactivé. Le déblocage du PIN est réservé à l'administrateur : absent ici **[§12.3]**.
### Écran F – Import CSV
Inchangé (`entreprise-import-csv.md`). Le lien « Importer » reste dans l'en-tête de la liste et dans l'état vide. Ajout : l'import applique la règle anti-énumération côté serveur ; le rapport d'import distingue seulement « doublon dans l'entreprise » (erreur de ligne) et traite les autres cas comme des réussites.

## 4. Composants et tokens
Composants existants réutilisés : `PageHeader`, `Card`, `DataTable`, `FilterBar`, `Modal`, `StatusBadge`, `Amount`, `TextField`, `Alert`, `Toast` (jamais pour un résultat financier ou de statut : bandeau/`ResultView`). Nouveaux : `UserStatusBadge`, `ReasonConfirmDialog`, `BulkActionBar` (barre collante : fond `color.navy`, texte `on-navy`, bouton principal `on-navy` / `color.surface`, `radius.card-desktop`, ombre `shadow.*` du token, `space.3` `space.4`), `AuditTimeline`, `Tabs`, `Select`, `Checkbox` (cible ≥ `size.touch-target-min`, zone cliquable étendue à la cellule). Tokens : `color.*`, `space.*`, `radius.*`, `size.table-row-height`, `size.icon-sm`, `size.modal-max-width`, `type-scale.*`, table `status`, `credit-type`. Aucune valeur en dur.

## 5. Textes et clés i18n (FR de référence ; clés existantes marquées « E »)
| Clé | FR |
|---|---|
| `company.employees.title` (E) | Employés |
| `company.employees.add` (E) / `.import` (E) | Ajouter un employé · Importer un fichier CSV |
| `company.employees.search` (E) / `.status` (E) | Rechercher un employé · Statut |
| `company.employees.filter.department` | Service |
| `company.employees.col.department` / `.allocated` (E) | Service · Alloué du mois |
| `company.employees.table.count` | {count, plural, one {# employé} other {# employés}} |
| `company.employees.select.all` | Tout sélectionner sur cette page |
| `company.employees.select.row` | Sélectionner {name} |
| `company.employees.select.disabled` | Désactivé : aucune action possible |
| `company.employees.bulk.count` | {count, plural, one {# employé sélectionné} other {# employés sélectionnés}} |
| `company.employees.bulk.suspend` / `.reactivate` / `.clear` | Suspendre / Réactiver / Désélectionner |
| `company.employees.bulk.title.suspend` | Suspendre {count} employés ? |
| `company.employees.bulk.title.reactivate` | Réactiver {count} employés ? |
| `company.employees.bulk.more` | et {count} autres |
| `company.employees.bulk.result.suspend` | {ok} suspendus, {failed} non traités |
| `company.employees.bulk.result.reactivate` | {ok} réactivés, {failed} non traités |
| `company.employees.bulk.preview` | {n} seront suspendus · {m} ignorés (transition impossible) · {k} membres de la famille touchés |
| `company.employees.select.cleared` | Sélection effacée. |
| `company.employees.bulk.retryFailed` | Réessayer pour les échecs |
| `company.employees.empty.title` / `.message` (E) | Aucun employé / Ajoutez vos employés ou importez un fichier CSV. (lecture seule : `company.employees.empty.messageReadOnly` « Aucun employé pour le moment. ») |
| `company.employees.error.title` | Impossible de charger les employés |
| `company.employees.detail.title` | {name} |
| `company.employees.detail.back` | Retour aux employés |
| `company.employees.detail.section.identity` / `.balance` / `.history` / `.family` | Identité · Solde · Historique · Membres de la famille |
| `company.employees.detail.balance.label` | Solde disponible (actif) |
| `company.employees.detail.balance.label.suspended` | Solde bloqué |
| `company.employees.detail.balance.label.grace` | Solde restant |
| `company.employees.detail.balance.label.closed` | Solde à la fermeture |
| `company.employees.detail.balance.blocked` | Solde conservé mais bloqué. |
| `company.employees.detail.balance.grace` | L'employé peut encore le dépenser jusqu'au {date}. |
| `company.employees.detail.closedNote` | Compte fermé le {date}. Le solde restant a été traité comme un crédit expiré. (à valider avec la règle exacte, §12.4) |
| `company.employees.detail.noAllocation.suspended` | L'attribution est impossible : ce compte est suspendu. |
| `company.employees.detail.noAllocation.deactivated` | L'attribution est impossible : ce compte est désactivé. |
| `company.employees.detail.tab.transactions` / `.changes` | Transactions · Changements du compte |
| `company.employees.detail.family.readonly` | Ces membres sont gérés par l'employé. Vous pouvez les consulter. |
| `company.employees.detail.family.empty` | Aucun membre de la famille. |
| `company.employees.detail.family.relation` | Lien : {relation} |
| `company.employees.action.menu` / `.edit` / `.suspend` / `.reactivate` / `.deactivate` / `.reset` | Actions · Modifier · Suspendre · Réactiver · Désactiver · Renvoyer l'invitation |
| `company.employees.reset.title` | Envoyer une nouvelle invitation à {name} ? |
| `company.employees.reset.effect` | Un mot de passe temporaire valable 72 h lui est envoyé par e-mail. Ses sessions actuelles seront fermées et il devra le changer à sa connexion. |
| `company.employees.reset.success` | Une invitation avec un mot de passe temporaire a été envoyée à {name}. |
| `company.employees.reset.confirm` | Envoyer l'invitation |
| `company.employees.created` (E) | Employé ajouté. |
| `company.employees.updated` | Employé modifié. |
| `company.employees.error.duplicateEmployeeNumber` | Ce matricule existe déjà dans votre entreprise. |
| `company.employees.error.duplicateEmail` | Cette adresse e-mail existe déjà dans votre entreprise. |
| `company.employees.history.empty` | Aucun changement enregistré. |
| `company.employees.forbidden.title` / `.message` | Accès refusé / Vous n'avez pas accès aux employés. |
Les textes des modales de statut : `common.reason.*` (spec commune).

## 6. États
| État | Rendu |
|---|---|
| Chargement | squelette `UI.skeletonRowsInitial` (liste) ou zones (fiche) |
| Vide | `StateView` : « Aucun employé » + actions « Ajouter un employé » et « Importer » si `employees.manage` ; pour un lecteur (READ_ONLY) : « Aucun employé pour le moment. » sans action |
| Vide après filtre | `common.state.emptyFiltered.*` |
| Erreur | `StateView` + Réessayer + `requestId` ; fiche inconnue/autre tenant : 404 C.8.9 |
| Hors connexion | C.8.4 ; actions d'écriture désactivées avec raison |
| Session expirée | N.6 ; sélection et formulaire non conservés |
| 403 | page : C.8.8 (ACCOUNTANT) ; action absente pour READ_ONLY |
| Succès | bandeau persistant ou `ResultView` (jamais un simple toast pour statut) |
| Employé suspendu | badge « Suspendu » ; bandeau `Banner` danger : « Ce compte est suspendu : il ne peut ni se connecter ni payer. Son solde est conservé. » ; « Attribuer » absent |
| Employé désactivé en grâce | badge « Désactivé — délai de grâce jusqu'au {date} » (multiligne autorisé) ; bandeau `warning` : « Ce compte est désactivé. L'employé peut encore dépenser son solde jusqu'au {date}. » ; libellé « Solde restant » ; aucune action de statut (désactivation définitive) |
| Employé invité | badge « Invité » ; « Renvoyer l'invitation », Suspendre et Désactiver permis |
| Employé fermé | badge « Désactivé » ; bandeau neutre `closedNote` ; aucune action |
| Membre de la famille en cascade | badge « Suspendu/Désactivé avec l'employé » |
| Action groupée partielle | `ResultView` par ligne (écran B) |
| Doublon interne | erreur de champ (matricule/e-mail même entreprise) |
| Doublon externe | même succès, aucun indice |
| Conflit 409 | bandeau « Actualiser » (état déjà changé) |
| Solde insuffisant | sans objet (concerne le payeur mobile) |
Clés de bandeau : `company.employees.banner.suspended` / `.gracing` / `.closed`.

## 7. Données et contrat
Voir « Besoins de contrat ». Le solde, `graceUntil`, `graceDays` viennent de l'API ; aucune date de fin de grâce ni aucun solde n'est calculé côté client.

## 8. RTL
Colonnes inversées ; la case de sélection est à `start` ; matricule, e-mail, téléphone, dates numériques et montants en blocs LTR isolés ; barre d'actions groupées : compteur à `start`, boutons à `end` ; chevrons et « Retour » en miroir ; frise d'audit à `start` ; la mention de date de grâce en chiffres occidentaux.

## 9. Accessibilité (WCAG 2.1 AA)
Tableau : `caption`, `th scope`, `aria-sort` ; cases : `aria-label` « Sélectionner {nom} » ; case d'en-tête à état mixte `aria-checked="mixed"` ; barre d'actions groupées en région `role="region"` `aria-label`, compteur annoncé en `status` poli (« 3 employés sélectionnés ») ; apparition de la barre sans voler le focus ; résultat de lot annoncé en `alert` seulement s'il y a des échecs ; lignes désactivées : cause lue ; badge = icône + texte ; date de grâce lue en toutes lettres ; solde annoncé avec devise (« 48 250,000 dinars tunisiens ») ; section famille : liste `<ul>`, aucun contrôle ; onglets : flèches, `aria-selected` ; focus restitué sur la ligne d'origine au retour ; ordre : en-tête → filtres → barre groupée → tableau → pagination ; contrastes AA des tokens ; cibles ≥ `size.touch-target-min` (cases incluses).

## 10. Responsive
`size.viewport-min` : cartes (case + titre = nom, service et e-mail en meta, montant à `end`, badge sous le montant) ; barre d'actions groupées collée en bas de l'écran, boutons pleine largeur ; filtres dans « Filtres (n) » ; actions d'en-tête empilées, « Attribuer » en premier ; fiche : sections empilées, historique en onglets ; menu Actions → feuille basse. ≥ `breakpoint.md` tableau ; ≥ `breakpoint.lg` toutes colonnes, fiche en deux colonnes (identité + solde à `start`, historique à `end`) ; max `size.desktop-max-width`.

## 11. Sécurité (points pour `securite`)
Tenant uniquement de la session ; employé hors tenant : 404 ; permissions `employees.*` lues de `/me`, serveur autorité ; lot : le serveur revérifie chaque id (pas d'IDOR par mélange d'ids) ; anti-énumération (§3.D) ; téléphone/e-mail masqués fournis masqués ; aucun mot de passe temporaire ni PIN côté entreprise ; aucun solde de membre de famille ; motif échappé ; `Idempotency-Key` par action et par lot ; audit écrit par le serveur ; l'entreprise ne dispose d'aucune action sur les membres de la famille.

## 12. Questions ouvertes (avec recommandation)
1. **Désactivation en masse** : non prévue. Recommandation : suspension/réactivation seules en masse (demande), désactivation une à une.
2. **Plafond de taille d'un lot** : non défini. Recommandation : limité à la page (taille de page de l'API), valeur lue de l'API.
3. **Réinitialisation et PIN côté entreprise** : la réinitialisation par mot de passe temporaire est une nouvelle invitation par e-mail (72 h, sessions fermées, changement obligatoire), le secret n'est jamais affiché. Recommandation : l'entreprise peut la déclencher pour ses employés (`employees.manage`) ; le déblocage du PIN reste à l'admin. Si refus : retirer « Renvoyer l'invitation ».
4. **Solde d'un compte fermé** : texte `closedNote` à valider avec la règle exacte des crédits expirés (ux UX-12 : dire le résultat, pas le jargon).
5. **Service** (département) : champ et filtre supposés ; si absent du modèle, retirer la colonne et le filtre. Recommandation : le conserver (déjà demandé).
6. **Réactiver un employé désactivé** : tranché non (utilisateur) ; voir `commun-statut-utilisateur.md` §12.1.
7. **Membres de la famille** : on montre prénom, lien, statut (pas de solde ni de contact). Recommandation : suffit à expliquer une cascade.
8. **[À DÉCIDER] Motif visible par l'entreprise** : les motifs saisis par l'administrateur sont-ils visibles ? Recommandation : masqués par défaut (interne), visibles seulement si l'admin les marque partageables (champ `visibility`) ; l'auteur reste « Administrateur FlexiPay » (appliqué).

## Besoins de contrat
| Route / champ | Usage |
|---|---|
| `GET /v1/company/employees?q&status&department&sort&cursor&withCount` | liste ; `Employee` ajoute `status` (`ACTIVE`/`INVITED`/`SUSPENDED`/`DEACTIVATED`), `graceUntil?`, `department?`, `monthAllocatedMillimes` (existant) |
| `GET /v1/company/employees/{id}` | fiche ; `balanceMillimes`, `balanceByType[]{type, amountMillimes}`, `graceUntil?`, `graceDays?`, `closedAt?` |
| `GET /v1/company/employees/{id}/audit?cursor` | `{ at, actor, action, reason, from, to }` |
| `GET /v1/company/employees/{id}/family` | `FamilyMember { id, firstName, relation, status, suspendedByCascade, deactivatedByCascade }` (lecture seule) |
| `GET /v1/company/employees/{id}/transactions` | historique (existant ou à créer) |
| `PATCH /v1/company/employees/{id}` | modification + `reason` |
| `POST …/suspend` · `…/reactivate` · `…/deactivate` | avec `reason` ; renvoient l'employé et le nombre de membres touchés |
| `POST /v1/company/employees/bulk-status` | `{ ids[], action: SUSPEND|REACTIVATE, reason }` → `{ results[]{id, ok, messageKey?} }` ; une `Idempotency-Key` |
| `POST …/reset-access` | nouvelle invitation par e-mail (mot de passe temporaire 72 h, sessions fermées) ; `202` sans secret |
| `POST /v1/company/employees` | création ; `409 DUPLICATE_EMPLOYEE_NUMBER` / `DUPLICATE_EMAIL` **seulement dans la même entreprise** ; sinon `201` identique |
| `GET /v1/company/departments` | valeurs du filtre Service |
| `GET /v1/me` | `permissions[]` : `employees.read`, `employees.manage` |
| Attribution | `entreprise-attribution` : refus serveur `422 EMPLOYEE_NOT_ELIGIBLE` pour suspendu/désactivé, en plus de l'action absente côté UI |

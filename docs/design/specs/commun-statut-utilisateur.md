# Spec design – Commun › Statut d'un utilisateur : badges et modales de confirmation avec motif
**Statut :** à relire (ux → conformite → securite) avant code · **Tâche :** e1 · **Auteur :** design · **Date :** 2026-10-22
**Portée :** composants partagés par `admin-utilisateurs.md` et `entreprise-employes.md` (pas une route). · **Exigences couvertes :** cycle de vie des comptes (décisions utilisateur du 2026-10-22), audit complet, double validation (CLAUDE.md règles 12-13).
**Dépend de :** `_socle-ecrans.md`, `dev-composants.md` (NC.3 `ConfirmDialog`, NC.10), `design-tokens.json` (table `status`).

## 1. Objectif
Donner un seul rendu, un seul vocabulaire et une seule confirmation à toute action qui change l'accès d'un compte : suspension, réactivation, désactivation, changement de rôle. Aucune de ces actions ne part sans motif écrit.

## 2. Rôles et permissions
Composants sans droit propre : leur affichage dépend de l'écran hôte (permissions `users.*` côté admin, `employees.*` côté entreprise). Règle commune (S8) : un bouton interdit est **absent**, jamais grisé. Une raison en texte n'apparaît que pour un blocage d'état (ex. dernier super-administrateur, §6).

## 3. Structure
### 3.1 `UserStatusBadge`
Variante de `StatusBadge` : icône (`size.icon-sm`) + texte, toujours les deux. Le texte de la variante « délai de grâce » inclut la date.
| Valeur API | Clé de statut | Icône Lucide | Fond / texte | Texte FR |
|---|---|---|---|---|
| `ACTIVE` | `status.ACTIF` | `CircleCheck` | `emerald-soft` / `emerald-text` | Actif |
| `INVITED` (compte créé, première connexion pas encore faite) | `status.INVITE` | `Mail` | `info-soft` / `info-text` | Invité |
| `SUSPENDED` | `status.SUSPENDU` (existe) | `CirclePause` | `danger-soft` / `danger-text` | Suspendu |
| `DEACTIVATED` (fermé) | `status.DESACTIVE` | `UserX` | `border` / `neutral-text` | Désactivé |
| `DEACTIVATED` avec `graceUntil` futur | `status.DESACTIVE_GRACE` | `Hourglass` | `warning-soft` / `warning-text` | Désactivé — délai de grâce jusqu'au {date} |
| membre de la famille désactivé par la cascade | `status.DESACTIVE` + badge secondaire `common.userStatus.cascadeDeactivated` | `UserX` + `Users` | comme Désactivé | Désactivé avec l'employé |
| demande de changement en attente | `EN_ATTENTE` (existe) | `Clock` | `warning-soft` / `warning-text` | En attente de seconde validation (`common.userStatus.pendingApproval`) |
**Tokens à créer** (table `status` de `design-tokens.json`, à annoncer à frontend et mobile) : `ACTIF`, `INVITE`, `DESACTIVE`, `DESACTIVE_GRACE`. `SUSPENDU` et `EN_ATTENTE` existent. Le frontend ne code aucune couleur : il lit la table.
**Transitions (validées) :** Actif ↔ Suspendu ; Actif ou Suspendu → Désactivé ; **Invité → Actif automatiquement à la première connexion** ; Invité → Suspendu ; Invité → Désactivé. Aucun retour depuis Désactivé, aucune suppression. **« Renvoyer l'invitation »** (libellé unique, partout, motif requis) est disponible pour un compte Invité ou Actif ; il est **absent** pour un compte suspendu ou désactivé.
**Largeur du badge (UX-20) :** le badge « Désactivé — délai de grâce jusqu'au {date} » peut passer sur plusieurs lignes (largeur fluide, `max-width` du conteneur, icône alignée sur la première ligne) : jamais de texte tronqué en carte à `size.viewport-min` ni en colonne de tableau.
La date de fin de grâce est `graceUntil` (`CalendarDate`, S9), affichée telle que renvoyée par l'API, format de la locale (JJ/MM/AAAA en FR). Le front ne calcule jamais cette date ni « il reste X jours ».
Un second badge secondaire (`Badge` neutre, icône `Users`) « Suspendu avec l'employé » (`common.userStatus.cascade`) s'affiche pour un membre de la famille quand `suspendedByCascade` vaut `true`.

### 3.2 `ReasonConfirmDialog` (étend NC.3)
Obligatoire avant : suspension, réactivation d'un suspendu, désactivation, changement de rôle. De haut en bas :
1. Titre `h2` = question avec le verbe : « Suspendre {nom} ? », « Réactiver {nom} ? », « Désactiver {nom} ? », « Changer le rôle de {nom} ? ».
2. Récapitulatif (`DescriptionList`) : personne, état actuel → état demandé (changement de rôle : `ChangeDiff` ancien rôle → nouveau rôle).
3. Ligne de conséquence (icône + texte, toujours présente, texte fourni par variante §3.3).
4. Si l'opération passe en double validation : ligne `common.reason.approvalNote` « Cette demande sera soumise à l'approbation d'un second administrateur. »
5. **Champ Motif** : `Textarea`, requis (« obligatoire » écrit en texte, S4.1), compteur `{count}/{max}` annoncé poliment, aide `common.reason.hint`.
6. Zone d'erreur de l'API (saisie conservée).
7. Pied : « Annuler » (`tertiary`) puis bouton **destructif** nommé par le résultat (« Suspendre le compte », « Désactiver le compte », « Changer le rôle », « Réactiver le compte »). Suspension et désactivation : variante `danger` (`color.danger` / `on-danger`) ; réactivation et changement de rôle : `primary`.
**Longueur du motif (proposition, à confirmer par backend, S4.2) :** minimum **10** caractères, maximum **500**, après suppression des espaces de début et fin. Les bornes sont lues du contrat, pas codées.
**Dérogation assumée au socle S4.3 :** le bouton de confirmation est **désactivé tant que le motif est vide ou sous le minimum** (demande utilisateur : décision explicite). Compensation : la raison du blocage est écrite à côté (`aria-describedby` : « Saisissez un motif d'au moins {min} caractères. »), jamais par la couleur seule. Il est aussi désactivé pendant l'envoi (`loading`) et hors connexion.
Le serveur reste l'autorité : un `422` sur `reason` réaffiche l'erreur sous le champ.
Focus initial : le champ Motif (pas le bouton destructif). Échap = Annuler. La modale ne se ferme pas par clic sur le voile pendant l'envoi.

### 3.3 Variantes de conséquence
| Action | Ligne de conséquence (clé) |
|---|---|
| Suspendre (tout compte) | `common.reason.suspend.effect` « Le compte ne pourra plus se connecter ni payer. Ses sessions seront fermées immédiatement. » |
| Suspendre un employé | + `common.reason.suspendEmployee.effect` « Son solde est conservé mais bloqué : aucun paiement ni aucune attribution. Les membres de sa famille seront suspendus avec lui. » |
| Réactiver | `common.reason.reactivate.effect` « Le compte pourra de nouveau se connecter. » ; employé : + « Seuls les membres de la famille suspendus avec lui seront réactivés. » (`common.reason.reactivateEmployee.effect`) |
| Désactiver (administrateur, utilisateur interne, commerçant) | `common.reason.deactivate.effect` « Le compte sera désactivé. Il ne pourra plus se connecter. » + ligne irréversible (§3.4) (texte exact à valider : voir §12.2) |
| Changer le rôle | `common.reason.role.effect` « Les droits du compte changeront dès la validation de la demande. » |
| Désactiver un employé | §3.4 |

### 3.4 Variante « Désactiver un employé »
Même gabarit que §3.2, avec en plus un bloc `Banner` `warning` (icône `TriangleAlert` + texte, pas de couleur seule) contenant, **mot pour mot** :
- `common.reason.deactivateEmployee.grace` : « L'employé pourra utiliser son solde restant pendant {days, plural, one {# jour} other {# jours}}, puis son compte sera fermé. » (phrase validée, seul le pluriel ICU est ajouté ; AR : règles de pluriel de la locale) — `{days}` = délai de grâce paramétré, **fourni par l'API** (`graceDays`, jamais codé ni calculé).
- `common.reason.deactivateEmployee.family` : « Les membres de sa famille seront désactivés avec lui. »
- Ligne `common.reason.deactivate.irreversible` (**toujours affichée, dans toutes les variantes de désactivation**, icône `TriangleAlert` + texte, dans le bloc `warning`) : « Cette action est définitive. La désactivation ne peut pas être annulée. » Décision actée : aucun retour depuis Désactivé.
- Ligne `common.reason.deactivateEmployee.noCredit` : « Aucun nouveau crédit ne pourra lui être attribué. » (ligne séparée ; le rappel exact ci-dessus reste intact).
Bouton : « Désactiver l'employé » (`danger`). Si `graceDays` n'est pas disponible, le bouton est désactivé avec la raison « Le délai de grâce n'a pas pu être chargé. » et « Réessayer ».

## 4. Composants et tokens
`ConfirmDialog` (NC.3) étendu · `Textarea` (`size.input-height` mini, `radius.input`, bordure `color.border-strong`, erreur `color.danger-text`) · `Button` `danger`/`primary`/`tertiary` (`size.button-height`) · `Banner` `warning` (`warning-soft`/`warning-text`) · `ChangeDiff` NC.10 · `DescriptionList` NC.13 · modale `size.modal-max-width` · espacements `space.4` (entre blocs), `space.2` (icône-texte) · compteur `type-scale.caption` `color.text-muted` · badges : table `status`, `radius.pill`. Aucune valeur en dur.

## 5. Textes et clés i18n (FR de référence ; AR et EN par l'équipe de traduction)
| Clé | FR |
|---|---|
| `status.ACTIF` | Actif |
| `status.DESACTIVE` | Désactivé |
| `status.DESACTIVE_GRACE` | Désactivé — délai de grâce jusqu'au {date} |
| `common.userStatus.pendingApproval` | En attente de seconde validation |
| `common.userStatus.cascade` | Suspendu avec l'employé |
| `common.userStatus.cascadeDeactivated` | Désactivé avec l'employé |
| `common.reason.label` | Motif |
| `common.reason.hint` | Ce motif est conservé dans le journal d'audit. |
| `common.reason.counter` | {count} / {max} caractères |
| `common.reason.min` | Saisissez un motif d'au moins {min} caractères. |
| `common.reason.error.tooLong` | Le motif ne doit pas dépasser {max} caractères. |
| `common.reason.approvalNote` | Cette demande sera soumise à l'approbation d'un second administrateur. |
| `common.reason.suspend.title` | Suspendre {name} ? |
| `common.reason.suspend.confirm` | Suspendre le compte |
| `common.reason.reactivate.title` | Réactiver {name} ? |
| `common.reason.reactivate.confirm` | Réactiver le compte |
| `common.reason.deactivate.title` | Désactiver {name} ? |
| `common.reason.deactivate.confirm` | Désactiver le compte |
| `common.reason.deactivateEmployee.confirm` | Désactiver l'employé |
| `common.reason.role.title` | Changer le rôle de {name} ? |
| `common.reason.role.confirm` | Changer le rôle |
| `common.reason.from` / `.to` | Actuel / Demandé |
| `common.reason.cancel` | Annuler |
| `common.reason.deactivate.irreversible` | Cette action est définitive. La désactivation ne peut pas être annulée. |
| `common.reason.deactivateEmployee.noCredit` | Aucun nouveau crédit ne pourra lui être attribué. |
| `status.INVITE` | Invité |
| `common.action.resendInvitation` | Renvoyer l'invitation |
| `common.state.error.supportRef` | Référence à communiquer au support : {requestId} |
| `common.reason.graceUnavailable` | Le délai de grâce n'a pas pu être chargé. |
Les clés `…effect` et `…deactivateEmployee.grace|family` sont celles du §3.3-3.4.
Montants : sans objet dans ces composants, sauf le solde restant (fiche employé), rendu par `Amount` (S6).

## 6. États
| État | Rendu |
|---|---|
| Chargement (envoi) | bouton `loading`, champ et boutons figés, annonce `common.state.loading` |
| Vide | sans objet |
| Erreur | zone inline dans la modale (`messageKey`, « Réessayer », référence `requestId`), motif conservé ; jamais de toast |
| Succès | modale fermée, `ResultView`/bandeau persistant sur la fiche : « Compte suspendu. » ; double validation : « Demande soumise pour approbation » (jamais « Modifié ») ; le focus revient sur le déclencheur ou sur le `h1` |
| 403 | l'action est absente ; si le serveur répond 403 malgré tout : `Banner` danger « Vous n'avez pas le droit d'effectuer cette action. » dans la modale |
| 409 `RESOURCE_STATE_CONFLICT` (état déjà changé) | bandeau persistant + « Actualiser » (S7.5) |
| Demande en attente (`pendingChange`) sur le compte | les actions de statut et de rôle sont **absentes** tant que la demande existe ; `PendingApprovalBanner` l'explique |
| Dernier super-administrateur | l'action est **absente** et remplacée par la phrase `common.userStatus.lastSuperAdmin` « Le dernier super-administrateur ne peut pas être suspendu ni désactivé. » ; si l'API répond quand même l'erreur, même message en erreur inline |
| Sa propre fiche | actions de statut et de rôle **absentes**, sans message (règle utilisateur) |
| Hors connexion | confirmation désactivée avec raison (C.8.4) |
| Session expirée | N.6 ; le motif saisi n'est pas conservé (S4.6) |
| Solde insuffisant | sans objet |

## 7. Données et contrat
Voir « Besoins de contrat » en fin de fichier.

## 8. RTL
Titre et pied inversés (`Annuler` à `start` du principal, principal à `end`) ; nom, e-mail, dates numériques en bloc LTR isolé ; `ChangeDiff` : la flèche ancien → nouveau est mise en miroir (`ArrowRight`) ; compteur `{count} / {max}` en bloc LTR ; `{date}` en chiffres occidentaux.

## 9. Accessibilité (WCAG 2.1 AA)
- Modale `role="dialog"` `aria-modal`, `aria-labelledby` (titre) et `aria-describedby` (conséquence), piège de focus, retour du focus au déclencheur.
- Label du champ Motif visible ; erreur `aria-invalid` + `aria-describedby` ; compteur dans une région `status` polie, annoncée au plus toutes les `UI.counterAnnounceStep` frappes **[constante d'interface à ajouter à S14 par design : proposition 50]** pour ne pas bavarder.
- Badge : icône `aria-hidden`, texte visible ; la variante délai de grâce lit « Désactivé, délai de grâce jusqu'au 21 novembre 2026 » (date en toutes lettres pour le lecteur d'écran).
- Contrastes : `emerald-text/emerald-soft`, `danger-text/danger-soft` 5,30:1, `warning-text/warning-soft`, `neutral-text/border` 6,15:1 (valeurs des tokens) ; bouton `danger` : `on-danger/danger`.
- Cibles ≥ `size.touch-target-min`. Le bouton désactivé reste focusable en lecture (`aria-disabled`) pour que la raison soit lue.
- Le nom du bouton destructif contient le verbe et l'objet ; pas de « OK ».

## 10. Responsive
Sous `breakpoint.sm` : modale plein écran, pied collant, boutons pleine largeur, destructif en premier dans l'ordre visuel de la pile ; `Textarea` 4 lignes mini ; badge à la ligne sous le nom dans les cartes.

## 11. Sécurité (points pour `securite`)
Le motif est du texte libre : échappé à l'affichage (jamais `dangerouslySetInnerHTML`), non journalisé côté client, non placé dans l'URL, vidé au démontage. Le front ne décide pas du droit : il lit `permissions[]`, `canApprove`, `isInitiator`. Anti-énumération : aucun message ne révèle l'existence d'un compte hors du tenant. Les actions envoient une `Idempotency-Key` par intention (S7.2). L'audit est écrit par le serveur uniquement.

## 12. Questions ouvertes
1. **Réactiver un compte désactivé : tranché par l'utilisateur, non.** Aucun retour depuis Désactivé ; la ligne irréversible est toujours affichée (ux UX-01).
2. **Désactivation d'un compte non employé** (administrateur, utilisateur interne d'entreprise ou de commerçant) : le délai de grâce ne vise que l'employé. Recommandation : effet immédiat (connexion coupée, sessions révoquées) pour les autres.
3. **[À DÉCIDER, ux UX-03] Suspension / désactivation d'un administrateur en double validation ?** Règle absente (seul le changement de rôle d'administrateur l'exige). Recommandation : validation simple avec motif, sauf désactivation d'un administrateur (double validation).
4. **Bornes du motif** : 10 à 500 caractères, à confirmer.
5. **Motif à la réactivation** : demandé ici (réactivation = changement d'accès). Recommandation : oui.
6. **Tokens** `ACTIF`, `DESACTIVE`, `DESACTIVE_GRACE` à créer dans `design-tokens.json` (design, hors périmètre de cette tâche d'écriture de specs : à faire avant le code).
7. **[À DÉCIDER, ux UX-11] Membre de la famille et délai de grâce** : un membre désactivé par cascade peut-il dépenser pendant le délai de grâce de l'employé ? Recommandation : oui, avec le même libellé exact « Désactivé — délai de grâce jusqu'au {date} ».
8. **[À DÉCIDER, ux UX-04] Dernier super-administrateur et changement de rôle ; impasse avec un seul super-administrateur** : la phrase `lastSuperAdmin` couvre suspension et désactivation seulement. Recommandation : l'étendre au changement de rôle, et afficher « Un second super-administrateur est nécessaire pour valider cette demande. » si l'API signale `approversAvailable: false`.

## Besoins de contrat
| Besoin | Proposition |
|---|---|
| Statut d'un utilisateur | `status` : `ACTIVE` · `SUSPENDED` · `DEACTIVATED` |
| Fin de grâce | `graceUntil?` (`CalendarDate`, présent si désactivé en grâce) ; `closedAt?` |
| Délai paramétré | `graceDays` (entier) dans la réponse de lecture d'employé et dans `GET /v1/settings/account-grace-period` |
| Cascade famille | `suspendedByCascade` (booléen) sur chaque membre de la famille |
| Motif | `reason` (chaîne, bornes publiées dans l'OpenAPI) dans le corps de `POST …/suspend`, `…/reactivate`, `…/deactivate`, `…/role` |
| Erreurs | `422` sur `reason` (`details.fields[]`), `409 RESOURCE_STATE_CONFLICT`, `422 LAST_SUPER_ADMIN` (`messageKey` dédiée), `403 FORBIDDEN` |
| Demande en attente | `pendingChange?` : `{ id, kind, from, to, initiatedBy, canApprove, isInitiator }` |
| Idempotence | en-tête `Idempotency-Key` sur chaque action |

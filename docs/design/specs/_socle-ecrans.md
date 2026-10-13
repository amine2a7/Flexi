# Socle commun des specs d'écran web (WD1 à WD5)
**Statut :** prêt pour relecture (ux → conformite) · **Auteur :** design · **Date :** 2026-10-11
**Rôle de ce fichier :** les règles ci-dessous s'appliquent à **chaque** spec d'écran `commun-*`, `commercant-*`, `entreprise-*`, `admin-*`. Une spec d'écran ne les répète pas : elle écrit « Socle Sx » et ne détaille que ce qui est **propre à l'écran**. Les composants sont ceux de `fondations-composants.md` (C.x), `navigation.md` (N.x) et `dev-composants.md` (NC.x).
**Règle d'or :** aucune couleur, taille, rayon, espacement, durée ni chaîne en dur ; **le front n'affiche que ce que l'API renvoie** (aucun calcul de commission, frais, plafond, solde, échéance, pourcentage, total, droit d'approbation).

---

## S0. Plan obligatoire d'une spec d'écran
Chaque fichier `docs/design/specs/<espace>-<ecran>.md` contient, dans cet ordre : **1. Objectif** (une page = un objectif, exigences couvertes) · **2. Rôle(s) et permissions** · **3. Structure** (zones, hiérarchie, **action principale unique**, route) · **4. Composants et tokens** · **5. Textes** (FR + clé `espace.ecran.element`) · **6. États** (chargement, vide, erreur, hors connexion, session expirée, permission refusée + états propres : solde insuffisant, conflit…) · **7. Données et contrat** (champ affiché → `schéma.champ` du contrat ; statut **E** existe / **N** à créer ; endpoint) · **8. RTL** · **9. Accessibilité** · **10. Responsive** (360 px → 1280 px) · **11. Sécurité** (points pour securite) · **12. Questions et décisions ouvertes**.

## S1. Conventions
- **Routes** (noms techniques en anglais, textes d'interface en français) : `/login`, `/admin/…`, `/company/…`, `/merchant/…`. Les fichiers de spec gardent des noms français (`commercant-encaissement.md`).
- **Clés feuille/dossier :** le texte d'une clé qui a des sous-clés est porté par `<clé>.label` (règle détaillée et liste : `fondations-composants.md` A.4) ; les `messageKey` du serveur sont résolues par `<messageKey>.label` puis `<messageKey>`.
- **Clés i18n** : `<espace>.<ecran>.<element>` avec `espace` ∈ `auth` · `merchant` · `company` · `admin` ; clés partagées : `common.*`, `errors.*`, `status.*`, `nav.*`, `role.*`, `category.*`. Pluriels et variables au format ICU (`{count, plural, one {…} other {…}}`, `{amount}`, `{date}`). Les textes FR de ces specs sont les **valeurs de référence** ; AR et EN sont fournis par l'équipe de traduction (jamais inventés par design). Aucune chaîne juridique n'est rédigée par design.
- **Références au contrat** : `E` = existe dans `openapi.yaml` ; `N` = à créer (proposition dans `_besoins-contrat.md`, identifiant `CT-<espace>-<n>`). Une spec ne fige jamais un nom marqué `N` : elle le propose, backend tranche.
- **Un écran = une action principale** (bouton `primary`, ou `accent` pour une réussite/confirmation financière) dans l'en-tête de page (N.2) ; sous `breakpoint.sm`, voir N.2 (UX-18).

## S2. Page authentifiée
Coquille N.1/N.2 · `h1` unique (titre de page) · fil d'Ariane (niveau 1) ou lien « Retour à {parent} » sous `breakpoint.lg` (niveau ≥ 2) · `document.title` = « {page} – FlexiPay » · à l'ouverture d'une page (navigation côté client), le **focus est placé sur le `h1`** (`tabindex="-1"`) et le titre est annoncé · le lien d'évitement mène à `<main id>`. Le **bandeau hors connexion** (C.8.4) et le **bandeau de traitement** (C.8.10) se placent au-dessus du `h1`.

## S3. États de page (mapping unique)
| État | Rendu | Référence |
|---|---|---|
| Chargement | squelette aux dimensions du contenu final, annonce `common.state.loading` une fois | C.7, C.8.1 |
| Chargement lent (> `UI.slowLoadingMs`) | `common.state.slow.label` ; lecture : « Arrêter le chargement » ; **écriture : jamais d'annulation**, « Vérifier l'état de l'opération » | C.8.1 |
| Vide | `StateView` `inline`/`page` : illustration, titre, message, **une action pour en sortir** (clés `ecran.empty.title|message|action`) | C.8.2 |
| Vide après filtre | `common.state.emptyFiltered.*` + « Effacer les filtres » | C.8.2 |
| Erreur | message de `messageKey`, **Réessayer**, référence copiable (`requestId`) | C.8.3, C.9 |
| Hors connexion | bandeau global + actions réseau désactivées avec raison ; données déjà chargées datées | C.8.4, N.7 |
| Session expirée / déconnecté | écran N.6 (`commun-session-expiree.md`) | C.8.5 |
| Permission refusée | `StateView` C.8.8 (`403`) ; action absente si la permission manque | C.8.8 |
| Introuvable | C.8.9 (`404`, sans distinguer inexistant / autre tenant) | C.8.9 |
| Conflit / traitement en cours | `Banner` persistant « Actualiser » / « Traitement en cours… » | C.8.10 |
| Solde insuffisant / plafond | **uniquement pour un payeur employé** (mobile) ; **aucun écran web n'en reçoit** sauf mention explicite (attribution Entreprise : voir `entreprise-attribution.md`) | C.8.6/7 |
Chaque spec d'écran liste **ses clés** d'état vide et d'erreur propres et déclare, pour chaque état ci-dessus, « oui / sans objet + raison ».

## S4. Formulaires
1. Label au-dessus, aide, contrôle, erreur sous le contrôle (icône + texte) ; « obligatoire » écrit en texte (`common.field.required`). Une colonne en mobile ; deux colonnes dès `breakpoint.lg` pour les formulaires larges ; largeur max `size.form-max-width`.
2. **Le serveur est l'autorité.** Le client peut afficher des contraintes de format issues du contrat (types, bornes) mais n'implémente aucune règle métier. Les erreurs de champ viennent de `details.fields[]` (`pointer` → champ, `messageKey` + `params`) ; la valeur saisie n'est jamais renvoyée, l'écran garde la sienne.
3. **Soumission :** le bouton n'est **jamais désactivé pour cause de validation** (UX-13) ; au clic : erreurs visibles, résumé `common.field.errorSummary` (liens vers les champs fautifs) annoncé en `role="alert"`, focus sur le premier champ en erreur. Désactivé seulement : chargement, hors connexion, permission — avec raison en texte.
4. **Double soumission :** bouton `loading` + clics ignorés ; pour une opération financière, `Idempotency-Key` (S7).
5. **Quitter avec des modifications non enregistrées :** avertissement natif du navigateur (`beforeunload`) et confirmation de navigation interne (`ConfirmDialog` « Quitter sans enregistrer ? »). Clés : `common.form.leave.title` « Quitter sans enregistrer ? » · `common.form.leave.message` « Vos modifications seront perdues. » · `common.form.leave.confirm` « Quitter sans enregistrer » · `common.form.leave.stay` « Rester sur la page ».
6. **Champs sensibles** (mots de passe, codes, RIB saisis) : `autocomplete` adapté, jamais dans l'URL, jamais journalisés, vidés au démontage et à l'expiration de session.
7. Réinitialisation/annulation : bouton « Annuler » (`tertiary`) qui ramène à la page parente.

## S5. Listes et tableaux
`DataTable` NC.1 + `FilterBar` NC.2 + pagination A.8. Filtres/tri/curseur dans l'URL. Compteur `page.count` pour toute liste paginée qui le demande (`?withCount=true`, contrat 0.2.0 §7, CT-X-1). Export NC.14 là où l'exigence le demande. Détail = **page** (route), pas de tiroir. Retour au détail parent : lien « Retour à {parent} » qui restitue les filtres.

## S6. Argent
1. Tout montant = champ `…Millimes` (entier, `AmountMillimes`/`PositiveAmountMillimes`) affiché par `Amount` ; tout taux = `…Bps` (`RateBps`) affiché par `formatRateBps`. Jamais de `number` décimal, jamais de chaîne formatée venant du serveur.
2. Les décompositions (commission, frais) sont **fournies par l'API** (`commissionMillimes`, `feeMillimes`, `netMillimes`, `totalMillimes`) et rendues par `AmountBreakdown` ; le front ne recalcule rien, même pour vérifier.
3. Saisie : `MoneyInput` (entier en millimes par traitement de chaîne, aperçu « Soit … TND »). Les seuils (minimum, plafond) affichés en aide viennent de l'API.
4. Zéro réel : `0,000` ; donnée indisponible : « — » + `common.amount.unavailable`.
5. Format : FR et AR `48 250,000 TND` ; EN `48,250.000 TND`.

## S7. Opérations sensibles et financières
1. **Confirmation** : `ConfirmDialog` NC.3 (titre-question avec le verbe, récapitulatif, ligne de conséquence, bouton libellé par le résultat). **Résultat** : `ResultView` NC.9 persistant (pas de toast).
2. **`Idempotency-Key`** : UUID généré **une fois par intention** (à l'ouverture de la confirmation), conservé pour tout rejeu après échec réseau ou `5xx` (« Réessayer » / « Vérifier l'état de l'opération ») ; **nouvelle** clé après un refus métier `4xx/422` mémorisé. Jamais d'optimisme : l'écran n'affiche un succès qu'après la réponse `2xx`.
3. **Double validation** (commission, paramètres sensibles, lots, RIB) : `PendingApprovalBanner` / `ChangeDiff` / `ApprovalActions` NC.10 ; le front lit `canApprove` et `isInitiator`, ne décide jamais. Message : « Demande soumise pour approbation », jamais « Modifié ».
4. **Audit** : le front n'écrit pas le journal d'audit ; il affiche seulement. Aucune donnée sensible dans les messages d'erreur, toasts, titres de page, `console`, analytics.
5. **Conflit d'état** (`409 RESOURCE_STATE_CONFLICT`) : bandeau persistant, jamais un toast.

## S8. Permissions
`GET /v1/me` fournit `role`, `subRole`, `permissions[]` (CT-C-8). Le front **retire** (ne grise pas) les actions et onglets non autorisés ; une page sans aucune permission affiche `nav.empty.message`. L'autorité est le serveur : `403 FORBIDDEN` → C.8.8, ressource d'un autre tenant → `404`. Les noms de permission sont ceux de backend ; les specs écrivent « permission `<action>` (nom à confirmer) ».

## S9. Dates, heures, nombres
`CalendarDate` : affichée telle quelle (format de la locale, pas de conversion de fuseau). `Timestamp` : `formatDateTime` (fuseau configuré, **[DÉCISION] en attente**, A.4). Entiers (compteurs d'employés, etc.) : séparateur de milliers de la locale, chiffres occidentaux en arabe. Période de filtre : `fromDate`/`toDate` `CalendarDate` (CT-X-2).

## S10. Accessibilité transverse (WCAG 2.1 AA)
Voir `fondations-composants.md` A.6. En plus : landmarks (`banner`, `navigation`, `main`) ; un seul `h1`, hiérarchie sans saut ; focus visible `focus.*` ; ordre de focus = ordre visuel et logique ; annonces `status` (poli) / `alert` (urgent) ; cibles ≥ `size.touch-target-min` ; texte vert = `emerald-text` ; `text-faint` décoratif ; **jamais d'information par la couleur seule** (statut = icône + texte, erreur = icône + texte, crédit/débit = signe + texte lecteur) ; zoom 200 % et reflow à `size.viewport-min` sans défilement horizontal (sauf zone de tableau explicitement focalisable) ; `prefers-reduced-motion` respecté ; formulaires : `label`, `aria-describedby`, `aria-invalid`, `autocomplete` ; tableaux : `caption`, `th scope`, `aria-sort`.

## S11. RTL (arabe)
Propriétés logiques (`start`/`end`, `ps-*`, `pe-*`, `ms-*`, `me-*`, `text-start`) ; icônes directionnelles en miroir (`ChevronRight/Left`, `ArrowRight`, `ArrowUpRight`, `Send`, `ArrowLeftRight`) ; icônes non directionnelles inchangées ; nombres, montants, dates numériques, e-mails, numéros de téléphone, codes et références en **bloc LTR isolé** ; chiffres occidentaux ; police `font.family-ar`. Chaque spec ne mentionne que les **particularités** de l'écran.

## S12. Responsive (360 px → 1280 px)
Mobile-first : `size.viewport-min` (360) → `breakpoint.sm` (640) → `md` (768) → `lg` (1024) → `xl` (1280) ; contenu max `size.desktop-max-width`. Sidebar fixe dès `lg`, tiroir en dessous. Tableaux → cartes sous `md` (NC.1). Formulaires 1 colonne sous `lg`. Action principale : N.2 (UX-18). Modales : NC.3 (pied collant sous `sm`). Aucun défilement horizontal à 360 px.

## S13. Sécurité de l'interface (points transmis à securite)
Aucun jeton, secret MFA, RIB complet, mot de passe, solde complet ni donnée personnelle dans l'URL, `localStorage`/`sessionStorage`, logs ou analytics ; données masquées **fournies masquées** par l'API (`MaskedValue`) ; `returnTo` : chemin relatif interne validé côté serveur et côté client ; téléchargements par lien signé de courte durée ; téléversement : types/tailles annoncés avant, validation serveur ; pas de `dangerouslySetInnerHTML` sur une donnée de l'API ; CSV exportés/affichés avec neutralisation des formules (`=`, `+`, `-`, `@`) côté serveur — le front n'affiche jamais une cellule comme formule.

## S14. Constantes d'interface (nommées, hors règles métier)
Ces valeurs sont des paramètres d'affichage (pas des tokens visuels, pas des règles métier) ; frontend les déclare **en un seul module** (`ui-constants`) et toute modification passe par design. Elles répondent à la remarque conformite S-05.
| Constante | Valeur | Usage |
|---|---|---|
| `UI.slowLoadingMs` | 10 000 | seuil du message `common.state.slow.label` (C.8.1) |
| `UI.skeletonDelayMs` | = `motion.base` (200) | délai avant d'afficher un squelette (C.7) |
| `UI.skeletonRowsInitial` | 6 | lignes de squelette d'une liste au premier chargement |
| `UI.skeletonRowsNextPage` | 3 | lignes de squelette en fin de liste (A.8) |
| `UI.badgeCountMax` | 99 | compteur affiché « 99+ » (cloche, N.2) |
| `UI.toastStackMax` | 3 | pile de toasts (C.5) |
| `UI.copiedFeedbackMs` | 2 000 | durée du libellé « Copié » (NC.12) |
| `UI.liveAnnounceCountdownMs` | 10 000 | annonce d'un compte à rebours court (C.8, NC.8) |
| `UI.liveAnnounceSessionMs` | 30 000 | annonce du compte à rebours de session (N.9) |
| `UI.pollIntervalMs` | fourni par l'API (`pollAfterSeconds`) sinon 2 000 | interrogation de l'état d'un paiement/export en attente |

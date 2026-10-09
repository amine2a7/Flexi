# Spec design – Fondations : composants et états d'écran
**Statut :** prête pour relecture · **Tâche :** P0-D2 (décisions utilisateur du 2026-10-09 reportées : P0-D5) · **Auteur :** design · **Date :** 2026-10-09
**Exigences couvertes :** cahier §5.5 (composants), §5.8 (principes UX), §6 (WCAG 2.1 AA, FR/AR/EN, TND à 3 décimales) ; COM-07 et RG-1.5 (affichage brut / commission / net) ; critère d'acceptation 4 (refus clair en cas de solde ou plafond dépassé) ; spec 06 §4 (hors connexion : dernier solde visible, paiement indisponible) ; charte §7 (états obligatoires).
**Destinataires :** frontend (web, shadcn/ui + Tailwind sur preset `packages/ui-tokens`) et mobile (Flutter, `ThemeData` généré). **Non annoncé** (équipes non lancées dans cette passe) : `[SPEC]` à envoyer dès leur lancement.
**Contrat de référence :** `docs/handoff/contracts/openapi.yaml` (P0-B5, en cours de rédaction par backend) ; les points ci-dessous marqués « contrat B5 » ont été **confirmés par backend** par message (montants, erreurs, statuts, pagination).

> Règle d'or : **aucune valeur en dur**. Toute couleur, taille, rayon, espacement, durée ou opacité ci-dessous est un token de `docs/design/design-tokens.json`. Tokens ajoutés par cette spec : voir §D.

---

## A. Règles transverses (valables pour tous les composants)

### A.1 Montants : contrat B5
- L'API expose des **entiers** `<nom>Millimes` (JSON integer, int64, 0..9 007 199 254 740 991). Aucun montant négatif : le sens est porté par `direction` (`DEBIT` | `CREDIT`). Devise implicite **TND**. Taux : `<nom>Bps` (entier 0..10 000).
- Le client formate **uniquement** avec l'utilitaire unique `formatMillimes` (web : fonction partagée ; mobile : formateur Dart). Algorithme entier : `dinars = m ÷ 1000` (division entière), `millimes = m mod 1000` sur 3 chiffres, **jamais de `float`**.
- Format FR (normatif) : milliers séparés par une **espace insécable fine (U+202F)**, virgule décimale, toujours 3 décimales. Exemples (cas de test du formateur, glossaire E3/E4) : `48250000 → 48 250,000` · `45000 → 45,000` · `44100 → 44,100` · `900 → 0,900` · `0 → 0,000` · `9007199254740991 → 9 007 199 254 740,991`. Cas EN : `48250000 → 48,250.000` · `900 → 0.900` · `0 → 0.000`.
- **Formats par langue (tranché le 2026-10-09, cahier v4.1 §6) :** **FR et AR** `48 250,000 TND` (AR : chiffres occidentaux, mêmes séparateurs que FR) ; **EN** `48,250.000 TND` (virgule pour les milliers, point décimal, toujours 3 décimales). Le formateur prend la langue de l'utilisateur ; l'état interne reste un entier en millimes.
- La devise **TND** est affichée à part, après le nombre, en `type-scale.currency` (voir C.6).

### A.2 Erreurs : contrat B5 (RFC 9457 Problem Details, `application/problem+json`, à plat)
Forme : `{ type, title, status, code, messageKey, requestId, details? }`. Règles d'affichage :
- Le client teste `code` ; il affiche la traduction de `messageKey` ; **`title` n'est jamais affiché** ; il n'y a pas de `detail`.
- `requestId` (aussi en en-tête `X-Request-Id`) est affiché comme **« Référence : … »** sur les états d'erreur (copiable), jamais ailleurs.
- La valeur saisie n'est jamais renvoyée par l'API : l'écran garde sa propre saisie.
- Matrice complète « code → présentation » : voir §C.9.

### A.3 Statuts : contrat B5
Enums API en anglais (`AccountStatus`, `OrderStatus`, `PaymentStatus`, `PayoutRequestStatus`, `ApprovalStatus`), **provisoires et extensibles**. Le composant `StatusBadge` convertit l'enum en clé de la table `status` des tokens (mapping §C.3) ; toute valeur inconnue → badge de repli `INCONNU` (neutre, jamais d'erreur d'affichage).

### A.4 i18n
- Aucune chaîne en dur ; FR/AR/EN via clés `zone.element` (les clés `errors.*` sont **celles du contrat B5**). Fichiers : un namespace `common` (cette spec), un par écran.
- Textes ci-dessous = **FR de référence** ; AR/EN traduits par l'équipe de traduction (non inventés ici). Les variables sont entre accolades : `{amount}`, `{seconds}`, `{date}`.
- Dates : le serveur envoie ISO 8601 UTC (`…Z`) ; le client affiche dans le **fuseau de l'utilisateur** avec le formateur de dates de la locale. Aucun texte juridique inventé.

### A.5 RTL (arabe)
- Propriétés logiques uniquement : `start` / `end`, `padding-inline`, `margin-inline` (Tailwind : `ps-*`, `pe-*`, `ms-*`, `me-*`, `text-start`) ; Flutter : `EdgeInsetsDirectional`, `AlignmentDirectional`, `Directionality`.
- Icônes **directionnelles en miroir** (ChevronRight/Left, ArrowLeft/Right, ArrowUpRight, Send, ArrowLeftRight) ; icônes non directionnelles inchangées (Check, Clock, QrCode, WalletCards, WifiOff, Lock…).
- Le **nombre** d'un montant est un bloc LTR isolé (`dir="ltr"` / `unicode-bidi: isolate` ; Flutter : `Directionality(textDirection: ltr)` sur le nombre) ; la devise suit le nombre dans l'ordre logique. Signe `+` / `−` (U+2212) à l'intérieur du bloc LTR.
- Police arabe : `font.family-ar`. Tester chaque écran en RTL (charte §9).

### A.6 Accessibilité
- Contraste texte ≥ 4,5:1, texte large (≥ 18 px gras ou ≥ 24 px) et éléments non textuels ≥ 3:1. Vérifications recalculées le 2026-10-09 sur les tokens (voir §D.2) : toutes les paires utilisées ci-dessous passent.
- **Texte vert = `color.emerald-text`**, jamais `color.emerald` sur blanc (2,54:1). `color.text-faint` : décoratif uniquement. `color.text-muted` : seulement sur `surface` / `bg` (jamais sur `border`, `navy`, `navy-deep` : utiliser `on-navy-muted`).
- Cibles : **≥ `size.touch-target-min` (44 px) web**, **≥ `size.touch-target-mobile` (48 dp) mobile**. Une cible plus petite visuellement (icône) a une zone tactile étendue.
- Focus visible : anneau `focus.width` / `focus.offset`, couleur `focus.color-on-light` (`navy`, 16,97:1 sur surface) sur fond clair, `focus.color-on-dark` (`emerald`, 6,69:1 sur navy) sur fond sombre. Jamais `outline: none` sans remplacement.
- Jamais d'information par la couleur seule : statut = icône + texte ; erreur = icône + texte ; montant crédit/débit = signe + texte lecteur d'écran.
- `prefers-reduced-motion` / « Réduire les animations » : toutes les animations (squelette, transitions) sont désactivées ; la durée de base reste `motion.base`.
- Taille de police système respectée (Flutter : `MediaQuery.textScaler`, aucun `textScaleFactor` figé ; les conteneurs grandissent, pas de hauteur fixe sur du texte).

### A.7 Responsive
Mobile-first. Points de rupture `breakpoint.sm` (640) · `md` (768) · `lg` (1024) · `xl` (1280). Largeur de contenu max `size.desktop-max-width` (1280), centré. Padding de page : `space.4`–`space.5` en mobile, `space.6`–`space.8` dès `lg`. Les tableaux deviennent des **cartes** sous `breakpoint.md`.

### A.8 Listes paginées (contrat B5, pagination par curseur)
Réponse `{ data: [...], page: { limit, hasMore, nextCursor } }`. **Pas de total, pas de numéro de page.** Motif d'interface :
- Mobile et cartes : bouton **« Charger plus »** (variante secondaire) tant que `hasMore` ; pas de défilement infini automatique.
- Tableau desktop : boutons **Précédent / Suivant** (pile de curseurs côté client), pas de « page 3 sur 12 ».
- État vide = `data` vide **et** `hasMore = false`. Squelette pendant le chargement de la page suivante : 3 lignes de squelette en fin de liste.
- Clés : `common.pagination.loadMore` « Charger plus » · `common.pagination.previous` « Précédent » · `common.pagination.next` « Suivant » · `common.pagination.loading` « Chargement de la suite… ».

---

## B. Vue d'ensemble

| # | Composant | Web (shadcn/ui) | Mobile (Flutter) |
|---|---|---|---|
| C.1 | Bouton | `Button` | `FilledButton` / `OutlinedButton` / `TextButton`, thème généré |
| C.2 | Champ (texte, mot de passe, montant, liste) | `Input`, `Label`, `Select`, `Form` | `TextFormField` + `InputDecoration`, `DropdownMenu` |
| C.3 | Badge de statut | `Badge` (variante `status`) | widget `StatusBadge` |
| C.4 | Carte (desktop, mobile, solde, wallet, KPI, ligne de transaction) | `Card` | `Card` + widgets `BalanceCard`, `WalletCard`, `TransactionTile` |
| C.5 | Toast | `Sonner` (toaster shadcn/ui) | `SnackBar` flottant |
| C.6 | Affichage de montant | composant `Amount` | widget `Amount` |
| C.7 | Squelette | `Skeleton` | widget `SkeletonBox` (sans nouvelle dépendance) |
| C.8 | États d'écran | `Alert` + composant `StateView` | widget `StateView` |

---

## C.1 Bouton

**1. Objectif.** Déclencher une action. Règle : **un seul bouton principal par écran** (`primary` ou `accent`, jamais les deux). Exigence : charte §5, cahier §5.5.

**2. Structure.** Icône optionnelle au début (`start`), libellé, icône optionnelle à la fin (`end`, seulement chevrons). Variantes :

| Variante | Fond | Texte / icône | Bordure | Usage |
|---|---|---|---|---|
| `primary` | `color.navy` | `color.on-navy` (16,97:1) | aucune | Action principale par défaut |
| `accent` | `color.emerald` | `color.on-emerald` (6,69:1) — **jamais blanc** | aucune | Action principale de **réussite / confirmation** : Payer, Confirmer le paiement, Demander le virement |
| `secondary` | `color.surface` | `color.navy` | `color.border-strong`, `size.border-width` | Actions secondaires, « Charger plus » |
| `tertiary` | transparent | `color.navy` | aucune | Annuler, Retour |
| `destructive` | `color.danger` | `color.on-danger` (4,83:1) | aucune | Suppression / suspension, **toujours précédée d'une modale de confirmation** |
| `link` | transparent | `color.info-text` (6,70:1), **souligné en permanence** | aucune | Lien dans un texte |

Tailles : hauteur `size.button-height` (44) web ; `size.touch-target-mobile` (48) mobile. Largeur min = hauteur (bouton icône seule : carré, `aria-label` / `Semantics(label)` obligatoire). Mobile : bouton principal d'un formulaire en pleine largeur.

**3. Tokens.** `radius.button` · padding horizontal `space.5` (icône seule : aucun) · espace icône-texte `space.2` · texte `type-scale.label` · icône `size.icon-md` · focus `focus.*` · états : couche d'état = couleur du texte à `opacity.hover` (survol) / `opacity.pressed` (appui) ; désactivé = `opacity.disabled` sur tout le bouton ; durée `motion.fast`.

**4. Textes (clés `common.button.*`).**

| Clé | FR |
|---|---|
| `common.button.confirm` | Confirmer |
| `common.button.cancel` | Annuler |
| `common.button.save` | Enregistrer |
| `common.button.back` | Retour |
| `common.button.retry` | Réessayer |
| `common.button.close` | Fermer |
| `common.button.loading` | Chargement… (annonce lecteur d'écran, non visible) |
| `common.button.signIn` | Se connecter |
| `common.button.refresh` | Actualiser |

Les libellés d'action sont des verbes (« Demander un virement », pas « Virement »).

**5. États.** Repos · survol (web) · appui · **focus** (anneau) · **désactivé** (`aria-disabled="true"`, pas seulement grisé ; une raison est donnée dans un texte d'aide si le désactivé n'est pas évident) · **chargement** : l'icône est remplacée par `Loader` (`size.icon-md`), le libellé reste, `aria-busy="true"`, le bouton **ignore les clics** (anti double soumission ; le client réutilise en plus la même `Idempotency-Key` pour toute opération financière). Erreur : jamais sur le bouton ; l'erreur s'affiche dans la zone concernée (C.8).

**6. RTL.** Icônes de début / fin permutées par propriétés logiques ; chevrons et flèches en miroir ; le libellé suit la direction de la langue.

**7. Accessibilité.** Cible ≥ 44 px / 48 dp ; contraste du texte ≥ 4,5:1 pour toutes les variantes (voir A.6) ; focus visible ; `<button type="button|submit">` natif (web), jamais un `div` ; activable Entrée / Espace ; annonce « Chargement… » pendant `loading`. Icône seule : label obligatoire.

**8. Responsive.** Web : largeur selon le contenu, groupes alignés en fin (`end`) ; sous `breakpoint.sm` les groupes d'actions s'empilent en pleine largeur avec l'action principale **en premier** dans l'ordre de focus. Mobile : actions principales ancrées en bas, au-dessus de la zone sûre, padding `space.4`.

**9. Données / endpoint.** Aucune donnée propre. Le bouton déclenche des endpoints écran par écran ; toute opération financière envoie l'en-tête `Idempotency-Key` (contrat B5).

---

## C.2 Champ de saisie

**1. Objectif.** Saisir une donnée avec ses contraintes **indiquées avant la validation** (plafond, format) et des erreurs claires. Variantes : texte, mot de passe, **montant**, liste (`Select`). Exigence : charte §5, cahier §5.5 (« plafonds et erreurs indiqués avant validation »).

**2. Structure (de haut en bas).** Label (au-dessus) · aide (optionnelle) · contrôle · message d'erreur (icône + texte, sous le contrôle). Le contrôle porte au début une icône optionnelle ; le champ mot de passe porte à la fin un bouton « afficher / masquer » (`Eye` / `EyeOff`, `aria-pressed`) ; le champ montant porte à la fin la devise **TND**.

**3. Tokens.** Hauteur `size.input-height` (44 web) / `size.touch-target-mobile` (48 mobile) · `radius.input` · fond `color.surface` · bordure `color.border-strong` (4,02:1 sur surface, 3,84:1 sur bg ; `border` est décoratif et **interdit** pour délimiter un champ) · `size.border-width` · texte saisi `type-scale.body-lg` (16, évite le zoom iOS) `color.text` · label `type-scale.label` `color.text` · aide `type-scale.caption` `color.text-muted` · placeholder `color.text-muted` (ne remplace jamais le label) · padding horizontal `space.3` · espace label-contrôle `space.1`, contrôle-message `space.1` · erreur : bordure `color.danger`, icône `CircleAlert` `size.icon-sm` `color.danger`, texte `type-scale.caption` `color.danger-text` · focus : bordure `color.navy` + anneau `focus.*` · désactivé : fond `color.bg`, `opacity.disabled`.

**4. Textes (clés `common.field.*`).**

| Clé | FR |
|---|---|
| `common.field.required` | obligatoire |
| `common.field.optional` | facultatif |
| `common.field.password.show` | Afficher le mot de passe |
| `common.field.password.hide` | Masquer le mot de passe |
| `common.field.amount.suffix` | TND (code devise, non traduit mais déclaré) |
| `common.field.amount.invalid` | Saisissez un montant valide (3 décimales au maximum). |
| `common.field.amount.min` | Le montant minimum est de {min} TND. |
| `common.field.amount.max` | Le montant maximum est de {max} TND. |
| `common.field.select.placeholder` | Sélectionner |
| `common.field.errorSummary` | {count} champ(s) à corriger |

Les libellés, aides et placeholders de chaque champ vivent dans la spec de l'écran (`ecran.champ.label`, `.help`). Les messages d'erreur serveur viennent de `details.fields[].messageKey` (+ `params`, ex. `{min:1}`), associés au champ par `pointer` (JSON Pointer, ex. `/amountMillimes`). Le **« obligatoire »** s'écrit en texte (`(obligatoire)`) ; l'astérisque, s'il existe, est décoratif (`aria-hidden`).

**Champ montant (`MoneyInput`).**
- Clavier numérique (`inputmode="decimal"` ; Flutter `TextInputType.numberWithOptions(decimal: true)`). Accepte chiffres et un séparateur (`,` ou `.`), 3 décimales max ; **l'état interne est un entier en millimes**, obtenu par traitement de chaîne (jamais `parseFloat`, `double`, `num`).
- Affichage formaté (A.1) à la perte du focus ; saisie brute pendant la frappe.
- Aide sous le champ avant validation : plafond / minimum connus (ex. « Minimum : {min} TND »), formatés par l'utilitaire unique.
- Après dépassement : erreur `LIMIT_EXCEEDED` ou `INSUFFICIENT_FUNDS` rendue par C.8 (bandeau), pas seulement sous le champ.

**5. États.** Repos · survol · focus · rempli · **erreur** (icône + texte, `aria-invalid="true"`, `aria-describedby` vers le message) · désactivé · lecture seule (fond `bg`, bordure `border`, sélectionnable) · chargement (squelette de champ, C.7) · succès **non signalé par la couleur** (pas de coche verte systématique). Soumission : le focus passe au **premier champ en erreur** ; un résumé `common.field.errorSummary` est annoncé (`role="alert"` web ; `SemanticsService.announce` mobile). Hors connexion : champs modifiables, soumission désactivée avec l'aide `common.state.offline.actionDisabled`.

**6. RTL.** Label, aide, erreur alignés en `start` ; icône de début à `start`, bouton œil et devise à `end` ; valeur numérique d'un champ montant ou téléphone en **LTR isolé**, alignée en `start` de la direction du champ (l'alignement visuel suit la langue, le contenu numérique reste LTR).

**7. Accessibilité.** `<label for>` explicite (web) / `Semantics` + `InputDecoration.labelText` (mobile) ; `autocomplete` pertinent ; erreurs reliées par `aria-describedby` ; cible 44 px / 48 dp sur toute la hauteur, y compris le bouton œil ; l'erreur n'est jamais un simple changement de couleur de bordure.

**8. Responsive.** Pleine largeur du conteneur ; en formulaires larges (≥ `breakpoint.lg`), grille 2 colonnes d'espacement `space.4` ; en mobile 1 colonne. Montant : champ large + devise intégrée, pas de champ séparé.

**9. Données / endpoint.** Erreurs de champ : `400 VALIDATION_FAILED` → `details.fields[] { in, pointer, code, messageKey, params? }` (contrat B5). Seuils affichés en aide (plafonds, minimum de virement) : à fournir par l'endpoint de l'écran (ex. `GET /payouts/quote` pour COM-07) — **à confirmer avec backend** par module.

---

## C.3 Badge de statut

**1. Objectif.** Dire l'état d'un objet métier **sans connaître le système** : icône + texte courts. Source unique : table `status` des tokens. Exigence : cahier §5.5 et §8 ; charte §5.

**2. Structure.** Pilule : icône Lucide (`aria-hidden`) puis libellé. Une seule ligne, sauf retour à la ligne autorisé sur mobile étroit.

**3. Tokens.** Fond `status.<KEY>.bg` · texte et icône `status.<KEY>.fg` · `radius.badge` · padding vertical `space.1`, horizontal `space.3` · icône `size.icon-sm` · espace `space.1` · texte `type-scale.caption` avec graisse `font.weight.label`. **Toutes les paires texte/fond de la table passent AA (min 4,51:1)** après correction du 2026-10-09 (`danger-text`, `info-text`, `neutral-text`) ; avant correction, REFUSE/SUSPENDU/EN_LITIGE (3,95:1), A_REGLER (4,24:1) et EXPIRE (3,86:1) échouaient.

**4. Textes.** Clé `status.<KEY>` = libellé de la table (`status.<KEY>.label` des tokens) : `status.EN_ATTENTE` « En attente » · `status.VALIDE` « Validé » · `status.A_REGLER` « À régler » · `status.REGLE` « Réglé » · `status.REFUSE` « Refusé » · `status.SUSPENDU` « Suspendu » · `status.EN_LITIGE` « En litige » · `status.EXPIRE` « Expiré » · `status.SUSPECT` « Suspect » · `status.EN_ATTENTE_KYC` « En attente KYC » · `status.REJETE` « Rejeté » · `status.CREEE` « Créée » · `status.PAYEE` « Payée » · `status.RAPPROCHEE` « Rapprochée » · `status.CREDITEE` « Créditée » · `status.ANNULEE` « Annulée » · `status.INITIE` « Initié » · `status.CONFIRME` « Confirmé » · `status.DEMANDEE` « Demandée » · `status.CONTROLEE` « Contrôlée » · `status.ENVOYEE` « Envoyée » · `status.EXECUTEE` « Exécutée » · `status.REJETEE` « Rejetée » · `status.APPROUVEE` « Approuvée » · `status.REFUSEE` « Refusée » · `status.UNKNOWN` « Statut inconnu ». Le champ `label` du JSON n'est qu'un repère FR ; **la clé fait foi**.

**Mapping enum API (contrat B5) → clé de la table `status`.**

| Enum API | Valeur | Clé `status` |
|---|---|---|
| `AccountStatus` | `PENDING_KYC` | `EN_ATTENTE_KYC` |
| | `APPROVED` | `VALIDE` |
| | `REJECTED` | `REJETE` |
| | `SUSPENDED` | `SUSPENDU` |
| `OrderStatus` | `CREATED` | `CREEE` |
| | `PAID` | `PAYEE` |
| | `RECONCILED` | `RAPPROCHEE` |
| | `CREDITED` | `CREDITEE` |
| | `CANCELLED` | `ANNULEE` |
| `PaymentStatus` | `INITIATED` | `INITIE` |
| | `CONFIRMED` | `CONFIRME` |
| | `SETTLED` | `REGLE` |
| | `REFUSED` | `REFUSE` |
| | `DISPUTED` | `EN_LITIGE` |
| `PayoutRequestStatus` | `REQUESTED` | `DEMANDEE` |
| | `CHECKED` | `CONTROLEE` |
| | `SENT` | `ENVOYEE` |
| | `EXECUTED` | `EXECUTEE` |
| | `REJECTED` | `REJETEE` |
| `ApprovalStatus` | `PENDING` | `EN_ATTENTE` |
| | `APPROVED` | `APPROUVEE` |
| | `REJECTED` | `REFUSEE` |
| (inconnu) | toute autre valeur | `INCONNU` |

Statuts **dérivés côté client** (aucun enum API aujourd'hui ; hypothèse soumise à backend) : `A_REGLER` = paiement `CONFIRMED` non `SETTLED` (créance en attente J+2, COM-01) · `EXPIRE` = lot de crédit dont `expiresAt` est passé · `SUSPECT` = alerte fraude (ADM-07).
Note de vocabulaire (**tranché le 2026-10-09**, cahier v4.1 aligné sur le glossaire) : statut de paiement = **« Confirmé » / `CONFIRMED`** partout (badge `CONFIRME`) ; « Validé » (`VALIDE`) désigne uniquement un compte.

**5. États.** Un badge n'a pas d'état interactif ; il est statique. Chargement : squelette de badge (C.7). Valeur inconnue : `INCONNU`. Badge jamais cliquable (si un filtre par statut existe, c'est un bouton séparé).

**6. RTL.** Icône à `start`, libellé ensuite ; pas de miroir des icônes de statut (non directionnelles ; `Send` utilisé pour ENVOYEE est miroir en RTL).

**7. Accessibilité.** Information portée par **icône + texte** ; l'icône est `aria-hidden`, le texte est lu tel quel ; pas d'info par la couleur seule ; contraste ≥ 4,5:1 (min 4,51:1 pour EN_ATTENTE/SUSPECT). Dans un tableau, le badge est dans la cellule et lu avec l'en-tête de colonne « Statut ».

**8. Responsive.** Identique sur toutes les largeurs. Dans les cartes mobile, le badge est placé en `end` de la première ligne ; si la place manque, il passe sous le titre.

**9. Données / endpoint.** Entrée : une valeur d'enum (champ `status` des ressources). Le composant n'appelle aucun endpoint. Enums à jour : contrat B5 (backend annoncera tout ajout ; le repli `INCONNU` évite une régression).

---

## C.4 Carte

Six variantes, un même principe : **une carte = un sujet**. Fond `color.surface`, bordure `color.border` (`size.border-width`), ombre `shadow.card`.

### C.4.1 Carte desktop
**1. Objectif.** Regrouper un bloc d'information ou d'action sur le web. **2. Structure.** En-tête (titre `type-scale.title-sm`, action optionnelle en `end`) · contenu · pied optionnel. **3. Tokens.** `radius.card-desktop` (16) · padding `space.6` (jusqu'à `space.8` pour les cartes de contenu large) · espacement interne `space.4` · espacement entre cartes `space.4`–`space.6` · carte cliquable : survol `shadow.raised`, durée `motion.base`, **toute la carte** est un lien (pas de bouton imbriqué). **4. Textes.** Fournis par l'écran (`ecran.zone.titre`). **5. États.** Normal · survol/focus (cliquable) · chargement (squelette de carte) · vide / erreur / hors connexion dans la carte via C.8 en variante `inline`. **6. RTL.** Action d'en-tête à `end`, contenu aligné `start`. **7. Accessibilité.** `<section aria-labelledby>` ; carte cliquable = un seul lien avec nom accessible explicite ; focus visible. **8. Responsive.** Grille de cartes : 1 colonne mobile, 2 colonnes dès `breakpoint.md`, 3–4 dès `breakpoint.lg` ; max `size.desktop-max-width`. **9. Données.** Selon l'écran.

### C.4.2 Carte mobile
`radius.card-mobile` (24) · padding `space.4`–`space.5` · espacement entre cartes `space.4` · mêmes ombre et bordure. Une carte à action (liste, wallet) a une zone tactile ≥ `size.touch-target-mobile` ; `InkWell` avec couche d'état `opacity.pressed`. États, RTL, accessibilité : comme C.4.1 ; `Semantics(button: true, label: …)` si cliquable.

### C.4.3 Carte solde (Employé, mobile) — EMP-02
**1. Objectif.** Montrer en moins de 2 s le **solde disponible**. **2. Structure.** Carte blanche posée sur le **header bleu nuit** (chevauchement de `space.6`) : étiquette « Solde disponible », **montant `xl`** (C.6) avec devise, ligne d'alerte d'expiration (badge `EN_ATTENTE` + texte) si des crédits expirent à J-30 / J-7 (RG-3), puis actions rapides. **3. Tokens.** Fond `color.surface` · `radius.card-mobile-lg` (32) · padding `space.6` · ombre `shadow.raised` · icône `WalletCards` `size.icon-lg` `color.emerald` sur pastille `color.emerald-soft` (décorative) · étiquette `type-scale.caption` `color.text-muted` · montant `type-scale.amount-xl` couleur `color.emerald-text` (crédits disponibles = vert, contraste 5,48:1) · devise `type-scale.currency` `color.text-muted`. **4. Textes (`home.balance.*`).** `home.balance.label` « Solde disponible » · `home.balance.expiring` « {amount} TND expirent le {date} » · `home.balance.updatedAt` « Mis à jour {date} » (affiché seulement hors connexion). **5. États.** Chargement : squelette `balance` (C.7), **jamais** un « 0,000 » provisoire · vide : solde `0,000` réel avec message `home.balance.empty` « Aucun crédit pour le moment. » · erreur : C.8 `inline`, avec **Réessayer** · **hors connexion** : dernier solde connu + `home.balance.updatedAt` + badge « hors connexion » (pas de masquage), le bouton Payer est désactivé (spec 06 §4) · session expirée / permission refusée : écrans C.8. **6. RTL.** Étiquette et alerte à `start`, pastille à `end` ; nombre LTR isolé. **7. Accessibilité.** Un seul nœud sémantique : « Solde disponible : 48 250,000 dinars tunisiens » ; l'alerte d'expiration est du texte, pas seulement une couleur. **8. Responsive.** Pleine largeur moins la marge de page (`space.4`) ; sur tablette la carte reste centrée avec la même marge. **Variante membre famille (tranché le 2026-10-09, RG-2.3).** Le membre famille **ne voit jamais le solde de l'employé** : la carte affiche à la place le **reste de sa propre limite** (étiquette `home.balance.family.label` « Reste sur votre limite », même composant `Amount` `xl`). Pas de ligne d'expiration (les lots de crédit sont ceux de l'employé), pas de wallets par catégorie, aucun total. Libellé lecteur d'écran : « Reste sur votre limite : {amount} dinars tunisiens ». **9. Données.** `GET /me/wallet` (spec 06) : `totalBalanceMillimes`, `expiringSoon[] { amountMillimes, expiresAt }` — **noms à confirmer avec backend** (contrat du module employé non encore écrit). Pour un `FAMILY_MEMBER`, la réponse ne doit contenir **que** le reste de sa limite (`remainingLimitMillimes`, nom à confirmer, message envoyé à backend).

### C.4.4 Carte wallet par catégorie (`Card/Wallet`)
Grille **2 colonnes** mobile (espacement `space.3`). `radius.card-mobile` · padding `space.4` · icône de catégorie `size.icon-lg` · nom `type-scale.label` · montant `md` (C.6). Cible entière ≥ 48 dp. Textes : le nom de catégorie vient des clés `category.<CODE>` (ex. `category.RESTAURATION` « Restauration », MVP). Données : `categories[] { category, balanceMillimes }` de `GET /me/wallet` (à confirmer). États : squelette, vide (« Aucun crédit dans cette catégorie »), erreur par carte non requis (erreur au niveau de la grille). RTL : grille inversée automatiquement. Accessibilité : « Restauration : 30,000 dinars tunisiens ».

### C.4.5 Carte KPI (web, tableaux de bord ADM-01, ENT-01, COM-01)
`radius.card-desktop` · padding `space.5` · libellé `type-scale.caption` `color.text-muted` · valeur `Amount` taille `lg` (`type-scale.amount`) ou nombre entier `type-scale.amount` · variation optionnelle = icône (`TrendingUp`/`TrendingDown`) + texte (+ signe) en `color.emerald-text` / `color.danger-text` (jamais couleur seule). Cible : carte non interactive sauf lien « Voir le détail » (≥ 44 px). États : squelette KPI, erreur inline, vide « — » avec `aria-label` « Aucune donnée ». Clés `dashboard.kpi.<id>.label`. Données : par tableau de bord (à spécifier avec les écrans).

### C.4.6 Ligne de transaction (`ListItem/Transaction`)
Structure : pastille icône de catégorie · (nom du commerçant `type-scale.label`, date `type-scale.caption` `color.text-muted`) · `end` : montant `md` signé + badge `StatusBadge`. Hauteur min `size.touch-target-mobile`. Montant : `direction = CREDIT` → `+` `color.emerald-text` ; `DEBIT` → `−` `color.text`. Données : `merchantName`, `amountMillimes`, `direction`, `status`, `createdAt` (liste paginée par curseur, A.8) — **champs à confirmer** (`GET /me/transactions`). Sur desktop, la même donnée forme une ligne de tableau ; sous `breakpoint.md` elle devient cette carte.

---

## C.5 Toast

**1. Objectif.** Confirmer brièvement un résultat **non bloquant** (réussite, information) ou signaler une erreur légère. Un toast ne porte **jamais** une information indispensable : le solde insuffisant, une limite dépassée ou une session expirée sont des **états persistants** (C.8), pas des toasts. Exigence : charte §5 (vert réussite, rouge erreur), cahier §5.5 (erreurs sans fermeture automatique).

**2. Structure.** Icône · message (une phrase) · action optionnelle (« Annuler », « Réessayer ») · bouton fermer. Pile de 3 maximum, le plus récent en haut (web) / en bas (mobile).

**3. Tokens.** | Type | Fond | Texte | Icône |
|---|---|---|---|
| `success` | `color.emerald-soft` | `color.emerald-text` (4,84:1) | `CircleCheck` `color.emerald-text` |
| `error` | `color.danger-soft` | `color.danger-text` (5,30:1) | `CircleAlert` `color.danger-text` |
| `info` | `color.info-soft` | `color.info-text` (5,49:1) | `Info` `color.info-text` |

`radius.button` · padding `space.4` · largeur max `size.toast-max-width` · ombre `shadow.raised` · texte `type-scale.body` · icône `size.icon-md` · bouton fermer : zone 44 / 48 · entrée/sortie `motion.base`. Position : web en haut, côté `end`, sous l'en-tête (`size.header-height` + `space.4`) ; mobile en bas, au-dessus de la barre basse (`size.bottom-nav-height` + `space.4`).

**4. Textes (`common.toast.*`).** `common.toast.dismiss` « Fermer la notification ». Les messages de réussite viennent de l'écran, p. ex. `payout.toast.requested` « Demande de virement envoyée » (jamais de montant sensible dans un toast d'erreur). Messages d'erreur légers : clés `errors.*` (C.9).

**5. États.** Visible · survol/focus (**la minuterie est suspendue**) · fermé. Durée : `success` et `info` disparaissent après `motion.toast-duration` (4 s). **Les toasts `error` ne disparaissent pas automatiquement** (WCAG 2.2.1 : le temps de lecture d'une erreur ne doit pas être imposé) : fermeture manuelle. *Tranché le 2026-10-09 (cahier v4.1 §5.5, charte §5 alignée).* Chargement/vide/hors connexion : sans objet (le passage hors connexion est une bannière persistante, C.8.4).

**6. RTL.** Position et icône par propriétés logiques (côté `end` en web, icône à `start`), bouton fermer à `end`, action avant le bouton fermer.

**7. Accessibilité.** `success`/`info` : `role="status"` (`aria-live="polite"`) ; `error` : `role="alert"` (`aria-live="assertive"`). Flutter : `SemanticsService.announce` + `liveRegion: true`. Action et bouton fermer atteignables au clavier (Échap ferme le toast au focus) ; ne vole pas le focus. Pas d'info par la couleur seule : icône + texte.

**8. Responsive.** Mobile : pleine largeur moins `space.4` de marge, centré ; ≥ `breakpoint.md` : `size.toast-max-width`.

**9. Données / endpoint.** Aucun. Le contenu vient du résultat de l'action ; en cas d'erreur API, `messageKey` traduite (jamais `title`).

---

## C.6 Affichage de montant (`Amount`)

**1. Objectif.** Lire un montant en moins de 2 s, sans ambiguïté, avec un format unique. Exigence : charte §3, cahier §5.3 (**48 250,000** TND : montant 700, devise réduite), règle d'argent « entiers en millimes ».

**2. Structure.** [signe] **nombre** + espace fine + **devise** (TND) alignée sur la ligne de base. Propriétés : `valueMillimes` (entier), `direction` (optionnel : `CREDIT` → `+`, `DEBIT` → `−`), `size`, `tone`. Pas de montant négatif en entrée ; le signe vient de `direction`.

**3. Tokens.**

| Taille | Nombre | Usage |
|---|---|---|
| `xl` | `type-scale.amount-xl` (40/44, 700) | Carte solde mobile |
| `lg` | `type-scale.amount` (32/36, 700) | Net à recevoir, KPI, montant d'écran |
| `md` | `type-scale.body-lg` + `font.weight.bold` (700) | Liste, carte wallet |
| `sm` | `type-scale.body` + `font.weight.bold` (700) | Tableau, texte courant |

Devise : `type-scale.currency` (14/500) pour toutes les tailles, couleur `color.text-muted` (sur navy : `color.on-navy-muted`). Espace nombre-devise : `space.1`. Tonalités : `neutral` → `color.text` · `positive` (crédit) → `color.emerald-text` · `danger` (montant manquant) → `color.danger-text` · `on-dark` → `color.on-navy`. **Jamais `color.emerald` sur fond clair.** Chiffres tabulaires (`font-variant-numeric: tabular-nums` ; Flutter `FontFeature.tabularFigures()`) pour aligner les colonnes.

**4. Textes (`common.amount.*`).**

| Clé | FR |
|---|---|
| `common.amount.currency` | TND |
| `common.amount.a11y` | {amount} dinars tunisiens |
| `common.amount.a11y.credit` | Crédit de {amount} dinars tunisiens |
| `common.amount.a11y.debit` | Débit de {amount} dinars tunisiens |
| `common.amount.unavailable` | Montant indisponible |

Cas COM-07 (RG-1.5), à afficher dans cet ordre : *montant demandé* `md`, *taux* (texte `2 %` formaté à partir de `rateBps`/100 : `200 → 2 %`, `150 → 1,5 %`, `50 → 0,5 %`), *commission* `md`, **net à recevoir** `lg` en `positive`. Exemple glossaire E4 : demande `45,000`, taux `2 %`, commission `0,900`, net `44,100` TND.

**5. États.** Chargement : squelette de montant (C.7), **jamais** « 0,000 » provisoire · valeur absente/invalide : `—` avec `common.amount.unavailable` en texte lecteur d'écran · zéro réel : `0,000` · hors connexion : dernier montant connu avec date (C.4.3) · très grand nombre : jamais tronqué ; le conteneur se réduit d'un cran de taille (`xl → lg`) sur largeur étroite, il ne coupe pas.

**6. RTL.** Nombre = bloc LTR isolé ; devise après le nombre dans l'ordre logique ; signe dans le bloc ; chiffres occidentaux et séparateurs FR en arabe (`48 250,000 TND`) ; en EN `48,250.000 TND` (A.1). Le bloc complet est aligné à `start`/`end` selon la mise en page, sans inverser les chiffres.

**7. Accessibilité.** Un seul nœud lecteur d'écran : `common.amount.a11y*` (ex. « 48 250,000 dinars tunisiens ») ; sens crédit/débit en toutes lettres, **le signe ne suffit pas** ; contraste : `emerald-text` 5,48:1, `danger-text` 6,47:1, `text` 17,85:1 sur surface ; ne pas recourir à une couleur pour distinguer crédit et débit (signe + texte lecteur).

**8. Responsive.** `xl` réservé aux cartes solde mobile, `lg` à partir de `breakpoint.md` pour les KPI, `md`/`sm` en listes et cartes de tableau. Pas de rupture de ligne entre nombre et devise (insécable).

**9. Données / endpoint.** Entrée : tout champ `*Millimes` du contrat B5 (entier). **Interdit** : `number` décimal, `double`, chaîne formatée venant du serveur. Utilitaire unique : web (F2) et mobile (M2) ; tests obligatoires sur les exemples du A.1.

---

## C.7 Squelette

**1. Objectif.** Montrer la **forme** du contenu pendant le chargement, sans faux chiffres ni saut de mise en page. Exigence : charte §7.

**2. Structure.** Primitives : `line` (hauteur = ligne du `type-scale` visé), `block`, `circle` (avatar), `badge`, `card`, `list-item`, `table-row`, `balance` (carte solde), `field`. Les écrans composent ces primitives à l'identique de la mise en page finale (mêmes dimensions → **pas de décalage de mise en page**).

**3. Tokens.** Fond `color.border` ; reflet animé vers `color.bg` ; rayons repris du composant imité (`radius.input`, `radius.badge`, `radius.card-desktop`, `radius.card-mobile`, `radius.card-mobile-lg`, `radius.avatar`) ; animation `motion.skeleton` (1,5 s, en boucle). Affiché seulement si le chargement dépasse `motion.base` (évite le clignotement).

**4. Textes.** `common.state.loading` « Chargement… » (lecteur d'écran uniquement).

**5. États.** Chargement → contenu ; chargement → erreur (remplacé par C.8) ; chargement de la page suivante : 3 `list-item` en fin de liste. `prefers-reduced-motion` : fond fixe, **sans reflet**.

**6. RTL.** Le reflet se déplace dans le sens de lecture (de `start` vers `end`) ; la disposition des primitives est symétrique à la mise en page finale.

**7. Accessibilité.** Conteneur `aria-busy="true"` + zone `role="status"` annonçant `common.state.loading` une seule fois ; les primitives sont `aria-hidden`. Contraste : décoratif, sans exigence ; ne jamais y placer de texte.

**8. Responsive.** Même composition que le contenu : cartes en grille sur desktop, liste de cartes sur mobile.

**9. Données / endpoint.** Aucune ; piloté par l'état de la requête (`isLoading`).

---

## C.8 États d'écran (`StateView` + bandeaux)

**1. Objectif.** Pour chaque écran de données, couvrir les **sept états obligatoires** (charte §7) avec un message clair, une icône, et **une seule action principale**. Composant unique `StateView` en deux variantes : `page` (plein écran / contenu principal) et `inline` (dans une carte ou une liste) ; plus deux bandeaux : `Banner` (hors connexion, traitement en cours) et `FundsAlert` (solde insuffisant, plafond).

**2. Structure (`StateView`).** Colonne centrée : pastille d'icône · titre · message · [référence support] · action principale · action secondaire (lien/tertiaire). Largeur max `size.toast-max-width`, espacement `space.4`.

**3. Tokens.** Pastille : `size.avatar-lg` avec icône `size.icon-lg`. Titre `type-scale.title` `color.text` ; message `type-scale.body-lg` `color.text-muted` (4,55:1 sur bg, 4,76:1 sur surface) ; référence `type-scale.caption` `color.text-muted`. Illustration (état vide) : emplacement `size.illustration` de haut, asset de la bibliothèque `09 Assets` (alt vide, décorative), repli = pastille d'icône ci-dessous. Bandeaux : `radius.card-desktop` (web) / `radius.card-mobile` (mobile), padding `space.4`.

| État | Icône (Lucide) | Pastille fond / icône |
|---|---|---|
| Vide | selon écran (ex. `Receipt`, `Users`, `Store`) | `emerald-soft` / `emerald-text` |
| Erreur | `CircleAlert` | `danger-soft` / `danger-text` |
| Hors connexion | `WifiOff` | `border` / `neutral-text` |
| Session expirée | `Clock` | `info-soft` / `info-text` |
| Permission refusée | `ShieldX` | `border` / `neutral-text` |
| Introuvable | `SearchX` | `border` / `neutral-text` |
| Solde insuffisant / plafond | `CircleAlert` | bandeau `danger-soft`, bordure `danger`, texte `danger-text` |

### C.8.1 Chargement
Squelette (C.7). Aucun texte visible. Si > 10 s : message `common.state.slow` « Cela prend plus de temps que prévu… » (région `status`) et bouton **Annuler** disponible. *Seuil de 10 s : proposition de design, sans règle métier.*

### C.8.2 Vide
Illustration + titre + message + **action** qui permet de sortir du vide. Clés génériques : `common.state.empty.title` « Rien à afficher pour le moment » · `common.state.empty.message` « Les éléments apparaîtront ici dès qu'il y en aura. ». **Chaque écran surcharge** avec `ecran.empty.title|message|action` (ex. `history.empty.title` « Aucune transaction » ; `history.empty.action` « Payer maintenant »). Vide après filtre : `common.state.emptyFiltered.title` « Aucun résultat » · `…message` « Modifiez ou effacez les filtres. » · action `common.state.emptyFiltered.action` « Effacer les filtres ». (Vide = `data` vide **et** `hasMore=false`.)

### C.8.3 Erreur (+ Réessayer)
Titre et message viennent de `messageKey` du Problem Details ; si l'erreur n'est pas typée : `common.state.error.title` « Une erreur est survenue » · `common.state.error.message` « Nous n'avons pas pu charger ces informations. ». Action principale **« Réessayer »** (`common.button.retry`) ; **référence support** : `common.state.error.reference` « Référence : {requestId} » + bouton copier (`common.state.error.copy` « Copier la référence »). Variantes : `INTERNAL_ERROR` (`errors.internal`) · `SERVICE_UNAVAILABLE` (`errors.serviceUnavailable`, réessai proposé après `Retry-After`) · `RATE_LIMITED` (`errors.rateLimited` avec `{seconds}` = `details.retryAfterSeconds`, bouton désactivé avec compte à rebours jusqu'à 0 puis actif) · réseau sans réponse alors que l'appareil est en ligne : `errors.network` « Impossible de joindre le serveur. Vérifiez votre connexion puis réessayez. ». **Règle d'idempotence (contrat B5 §5), à respecter par frontend/mobile :** après un **échec réseau ou 5xx** (réponse non mémorisée), « Réessayer » rejoue la requête avec la **même** `Idempotency-Key` ; après un **refus métier 422** (la réponse est mémorisée et rejouée à l'identique), un nouvel essai exige une **nouvelle** clé. Le texte rassure dans le premier cas : `common.state.error.safeRetry` « Votre opération ne sera pas effectuée deux fois. ».

### C.8.4 Hors connexion
Détection **côté client** (pas de code API, confirmé backend) : événement réseau du système + échec de requête sans réponse ; retour de connexion confirmé par un appel à la route publique de santé (`GET /health`, à confirmer). 
- **Bandeau global persistant** `Banner` en haut du contenu, `color.warning-soft` / texte `color.warning-text` (4,51:1), icône `WifiOff` : `common.state.offline.banner` « Vous êtes hors connexion. Certaines actions sont indisponibles. ». Disparaît au retour de connexion, avec un toast de réussite `common.state.online.toast` « Connexion rétablie ».
- Actions réseau désactivées avec la raison en texte : `common.state.offline.actionDisabled` « Indisponible hors connexion. ». **Paiement employé indisponible** (spec 06 §4) : `common.state.offline.payDisabled` « Le paiement nécessite une connexion. Reconnectez-vous pour payer. ».
- Données déjà chargées : consultation du dernier solde avec `common.state.offline.lastUpdate` « Dernière mise à jour : {date} » ; aucune donnée n'est présentée comme actuelle. *Le stockage local de ces données (chiffrement, durée) est à valider par securite avant implémentation mobile.*
- Écran plein (aucune donnée en cache) : `StateView` `page` : `common.state.offline.title` « Pas de connexion » · `common.state.offline.message` « Vérifiez votre connexion internet puis réessayez. » · action `common.button.retry`.

### C.8.5 Session expirée
Sur `401 SESSION_EXPIRED`, le client tente **un** rafraîchissement silencieux ; s'il échoue, il affiche l'écran `page` (aucune donnée de l'écran précédent n'est conservée à l'écran) : `common.state.sessionExpired.title` « Session expirée » · `…message` « Pour votre sécurité, votre session a expiré. Reconnectez-vous pour continuer. » · action **« Se reconnecter »** (`common.button.signIn`) vers la connexion avec retour à la page visitée (chemin seul, sans paramètres sensibles). Sur `401 UNAUTHENTICATED` après une session active (révocation) : `common.state.signedOut.title` « Vous avez été déconnecté » · `…message` « Pour votre sécurité, votre session a été fermée. Reconnectez-vous pour continuer. » (la cause n'est jamais indiquée, aucune fuite). Pas d'état sans session déjà ouverte : écran de connexion normal. `403 PASSWORD_CHANGE_REQUIRED` : redirection vers le changement de mot de passe obligatoire (écran de l'auth, hors cette spec), jamais une erreur.

### C.8.6 Solde insuffisant (`FundsAlert`)
`422 INSUFFICIENT_FUNDS`, `details.missingMillimes` (le **seul** montant fourni : le solde complet ne sort jamais, contrat B5 et règle 9).
- Bandeau persistant, sous le montant, au-dessus de l'action : fond `color.danger-soft`, bordure `color.danger` (`size.border-width`), icône `CircleAlert` `color.danger`, titre `type-scale.label` `color.danger-text` « Solde insuffisant », message `type-scale.body` `color.text`, **montant manquant** via `Amount` taille `md` tonalité `danger`.
- Clés : `errors.insufficientFunds` « Solde insuffisant. Il vous manque {amount} TND pour ce paiement. » · `errors.insufficientFunds.reassure` « Aucun montant n'a été débité. » (glossaire E7 : aucune écriture) · action secondaire `errors.insufficientFunds.back` « Retour à mon solde ». **Pas de bouton « Réessayer »** (inutile).
- **Côté payeur uniquement.** Contrat B5 (mise à jour après la revue securite S6-10) : `INSUFFICIENT_FUNDS` et `LIMIT_EXCEEDED` sont réservés au payeur (employé). Le **commerçant** reçoit toujours `422 PAYMENT_DECLINED` (`errors.paymentDeclined`, sans `details`), quelle que soit la raison : il voit un écran « paiement refusé » **générique** (C.8.11), jamais le motif ni un montant. **Membre famille (tranché le 2026-10-09, RG-2.3) :** il ne voit que ce qui reste sur **sa propre limite**, jamais le solde de l'employé, ni à l'écran ni dans un message d'erreur : `INSUFFICIENT_FUNDS` n'est donc **jamais rendu avec `missingMillimes`** pour un membre famille (le montant manquant révélerait le solde de l'employé) ; seul `LIMIT_EXCEEDED` / `FAMILY_MEMBER` (C.8.7) affiche un montant, qui est le reste de sa propre limite. **Confirmé par backend (contrat B5 §4, « Règle d'exposition des refus de paiement » ; revue securite en cours) :** quand le solde de l'employé est insuffisant, le membre reçoit `INSUFFICIENT_FUNDS` **sans `details`** (aucun montant) ; `LIMIT_EXCEEDED` / `FAMILY_MEMBER` porte `remainingMillimes` = reste de **sa** limite ; le seul montant jamais renvoyé à un membre est le reste de sa propre limite. Le nom et la forme des champs de `GET /me/wallet` pour un membre ne sont **pas figés** (contrat du module 06, à venir). Le cas d'un paiement du membre bloqué par un plafond de l'**employé** est en attente de décision utilisateur : ne pas le figer. Texte de repli sans montant pour `INSUFFICIENT_FUNDS` côté membre `errors.insufficientFunds.family` « Paiement impossible pour le moment. Contactez le titulaire du compte. » (proposition de rédaction, à valider par `main`).
- Annonce : `role="alert"` ; le focus ne se déplace pas.

### C.8.7 Plafond dépassé (`FundsAlert`, `422 LIMIT_EXCEEDED`)
Même composant, `details = { limitType, remainingMillimes }`. Clés `errors.limitExceeded.<TYPE>` : `TRANSACTION` « Ce montant dépasse le plafond par paiement. Maximum autorisé : {amount} TND. » · `DAILY` « Plafond journalier atteint. Il vous reste {amount} TND aujourd'hui. » · `MONTHLY` « Plafond mensuel atteint. Il vous reste {amount} TND ce mois-ci. » · `FAMILY_MEMBER` « Votre limite est dépassée. Reste disponible sur votre limite : {amount} TND. » (côté membre famille, `remainingMillimes` est le reste de **sa** limite, jamais le solde de l'employé) (glossaire E8, E16.) Les valeurs des plafonds viennent du serveur, jamais codées.

### C.8.8 Permission refusée
`403 FORBIDDEN` : `StateView` `page` ou `inline` : `common.state.forbidden.title` « Accès refusé » · `errors.forbidden` « Vous n'avez pas l'autorisation d'effectuer cette action. » + `common.state.forbidden.hint` « Contactez le propriétaire de votre compte si vous pensez que c'est une erreur. » · action **« Retour au tableau de bord »** (`common.state.forbidden.action`). Les modules non autorisés sont masqués de la navigation, mais l'**autorité reste le serveur**.

### C.8.9 Introuvable
`404 NOT_FOUND` : `common.state.notFound.title` « Introuvable » · `errors.notFound` « Cette page ou cette ressource est introuvable. » · action « Retour à l'accueil ». **Le texte ne distingue jamais « n'existe pas » et « appartient à un autre tenant »** (contrat B5 : 404 dans les deux cas).

### C.8.10 Traitement en cours et conflit
- `409 IDEMPOTENCY_REQUEST_IN_PROGRESS` : **pas une erreur rouge.** `Banner` `info` (`color.info-soft`, `color.info-text`, icône `Loader`) : `common.state.processing.title` « Traitement en cours… » · `common.state.processing.message` « Votre opération est en cours. Ne quittez pas cette page. » ; le client réessaie après `Retry-After`, bouton d'action désactivé.
- `409 RESOURCE_STATE_CONFLICT` : toast `info` + bouton « Actualiser » : `errors.resourceStateConflict` « Cette opération a déjà été traitée ou son état a changé. Actualisez puis réessayez. ».
- `400 IDEMPOTENCY_KEY_*`, `422 IDEMPOTENCY_KEY_REUSED`, `403 CSRF_TOKEN_INVALID` : erreurs d'intégration : aucune UI dédiée ; CSRF → rechargement de la session puis un seul nouvel essai ; les autres → `errors.internal`.

**4. Textes.** Voir ci-dessus ; table complète des clés `errors.*` en C.9.

**5. États.** Les 7 états obligatoires de la charte sont tous traités : chargement (C.8.1), vide (C.8.2), erreur (C.8.3), hors connexion (C.8.4), session expirée (C.8.5), solde insuffisant (C.8.6, plus plafond C.8.7), permission refusée (C.8.8).

**6. RTL.** Colonne centrée, texte aligné au centre ; bandeaux : icône à `start`, texte à `start`, action à `end` ; icônes miroir si directionnelles ; nombres LTR isolés.

**7. Accessibilité.** Titre = `h1` (page) ou `h2` (inline) ; bandeaux d'urgence `role="alert"`, informatifs `role="status"` ; au rendu d'un état `page`, le focus va au titre (`tabindex="-1"`) ; l'action principale est la première action dans l'ordre de focus ; contrastes : `danger-text` sur `danger-soft` 5,30:1, `warning-text` sur `warning-soft` 4,51:1, `info-text` sur `info-soft` 5,49:1, `neutral-text` sur `border` 6,15:1 ; **icône + texte** dans tous les états (jamais la couleur seule) ; le compte à rebours du `RATE_LIMITED` est annoncé toutes les 10 s au plus (pas à chaque seconde).

**8. Responsive.** `page` centré verticalement avec marge `space.8` en desktop, `space.4` en mobile ; action principale en pleine largeur sous `breakpoint.sm` ; `inline` s'adapte à la carte ; le bandeau hors connexion est ancré sous l'en-tête (web) / sous le header (mobile), au-dessus de la barre basse.

**9. Données / endpoint.** Problem Details complet du contrat B5 : `code`, `messageKey`, `requestId`, `details` (`missingMillimes`, `limitType`, `remainingMillimes`, `retryAfterSeconds`, `fields[]`) ; en-têtes `Retry-After`, `X-Request-Id`. Détection de connectivité : `GET /health` (publique, P0-B3, à confirmer).

---

### C.8.11 Paiement refusé (côté commerçant, `422 PAYMENT_DECLINED`)
`StateView` `inline` ou `page` : icône `CircleX` (pastille `danger-soft` / `danger-text`), texte unique `errors.paymentDeclined` exactement « Paiement refusé. Le client peut vérifier son application. » (**tranché le 2026-10-09**, cahier §4.2 ; une seule phrase affichée en position de titre, sans second message), action principale « Nouvel encaissement » (`errors.paymentDeclined.action`). **Aucun motif, aucun montant, aucun bouton Réessayer** avec la même clé (refus définitif pour sa clé ; un nouvel essai est une nouvelle intention, donc une nouvelle `Idempotency-Key`). `role="alert"`. Raison de sécurité : un motif détaillé permettrait de retrouver le solde de l'employé par essais répétés. **Tranché le 2026-10-09 (COM-04 v4.1) :** l'écran de validation du commerçant n'affiche **aucun solde** : client (prénom + initiale), matricule masqué, catégorie, montant, compte à rebours ; le résultat est seulement « accepté » ou « refusé ».

## C.9 Matrice « réponse API → présentation »

| HTTP | `code` | `messageKey` | Présentation |
|---|---|---|---|
| 400 | `VALIDATION_FAILED` | `errors.validationFailed` | Erreurs sous les champs (`details.fields[]`), résumé annoncé, focus sur le premier champ |
| 400 | `IDEMPOTENCY_KEY_REQUIRED` / `_INVALID` | `errors.idempotencyKeyRequired` / `errors.idempotencyKeyInvalid` | Erreur d'intégration : aucune UI dédiée, affiche `errors.internal` |
| 401 | `UNAUTHENTICATED` | `errors.unauthenticated` | Écran connexion (ou `signedOut` si session active) |
| 401 | `SESSION_EXPIRED` | `errors.sessionExpired` | Refresh silencieux ×1, puis écran Session expirée |
| 401 | `INVALID_CREDENTIALS` | `errors.invalidCredentials` | Message générique sous le formulaire de connexion ; jamais « compte verrouillé » |
| 403 | `PASSWORD_CHANGE_REQUIRED` | `errors.passwordChangeRequired` | Redirection vers le changement obligatoire |
| 403 | `FORBIDDEN` | `errors.forbidden` | Permission refusée (C.8.8) |
| 403 | `CSRF_TOKEN_INVALID` | `errors.csrfTokenInvalid` | Rechargement de la session + 1 essai (web), sinon `errors.internal` |
| 404 | `NOT_FOUND` | `errors.notFound` | Introuvable (C.8.9) |
| 409 | `IDEMPOTENCY_REQUEST_IN_PROGRESS` | `errors.idempotencyRequestInProgress` | Bandeau « Traitement en cours », réessai après `details.retryAfterSeconds` (C.8.10) |
| 413 / 415 | `PAYLOAD_TOO_LARGE` / `UNSUPPORTED_MEDIA_TYPE` | `errors.payloadTooLarge` / `errors.unsupportedMediaType` | Fichier : erreur sous le champ de dépôt (import CSV, justificatif) : « Ce fichier est trop volumineux. » / « Ce type de fichier n'est pas accepté. » |
| 409 | `RESOURCE_STATE_CONFLICT` | `errors.resourceStateConflict` | Toast info + Actualiser |
| 422 | `IDEMPOTENCY_KEY_REUSED` | `errors.idempotencyKeyReused` | Bug client : affiche `errors.internal` |
| 422 | `PAYMENT_DECLINED` | `errors.paymentDeclined` | Écran « Paiement refusé » générique côté commerçant (C.8.11) |
| 422 | `INSUFFICIENT_FUNDS` | `errors.insufficientFunds` | `FundsAlert` (C.8.6) |
| 422 | `LIMIT_EXCEEDED` | `errors.limitExceeded` | `FundsAlert` (C.8.7) |
| 429 | `RATE_LIMITED` | `errors.rateLimited` | État erreur avec compte à rebours |
| 500 | `INTERNAL_ERROR` | `errors.internal` | État erreur + référence |
| 503 | `SERVICE_UNAVAILABLE` | `errors.serviceUnavailable` | État erreur + réessai après `Retry-After` |
| – | (client) | `errors.network` | Erreur réseau avec réessai |
| – | (client) | – | Hors connexion (C.8.4) |

**Sous-clés propres au client** (le serveur envoie la clé parente, le client choisit la sous-clé selon `details`) : `errors.limitExceeded.<limitType>`, `errors.paymentDeclined.action`, `errors.insufficientFunds.family`, `errors.insufficientFunds.reassure`, `errors.insufficientFunds.back`. À ajouter aux fichiers de traduction avec leurs parentes.

**Messages de champ (`details.fields[].messageKey` = `errors.field.<codeEnCamelCase>`, contrat B5 §4)** : `errors.field.required` « Ce champ est obligatoire. » · `errors.field.invalidType` « La valeur saisie n'est pas du bon type. » · `errors.field.invalidFormat` « Le format est incorrect. » · `errors.field.tooSmall` « La valeur est trop petite (minimum : {min}). » · `errors.field.tooBig` « La valeur est trop grande (maximum : {max}). » · `errors.field.notInteger` « Saisissez un montant valide (3 décimales au maximum). » · `errors.field.invalidEnum` « Choisissez une valeur proposée. » · `errors.field.unknownField` (erreur d'intégration, jamais montrée à l'utilisateur). Les paramètres `params` (ex. `{min:1}`) alimentent les variables ; les montants de `params` sont des millimes et passent par l'utilitaire de format.

Textes FR de référence : `errors.validationFailed` « Certaines informations sont incorrectes. Vérifiez les champs signalés. » · `errors.unauthenticated` « Vous n'êtes pas connecté. Reconnectez-vous pour continuer. » · `errors.sessionExpired` « Votre session a expiré. Reconnectez-vous pour continuer. » · `errors.invalidCredentials` « Identifiants invalides. » · `errors.passwordChangeRequired` « Vous devez changer votre mot de passe temporaire pour continuer. » · `errors.forbidden`, `errors.notFound`, `errors.resourceStateConflict`, `errors.insufficientFunds`, `errors.limitExceeded.*` : voir C.8 · `errors.rateLimited` « Trop de tentatives. Réessayez dans {seconds} secondes. » · `errors.serviceUnavailable` « Le service est momentanément indisponible. Réessayez dans quelques instants. » · `errors.internal` « Une erreur est survenue de notre côté. Réessayez. ». Ces textes **ne contiennent jamais** de donnée sensible (solde complet, identifiant de compte, RIB).

---

## D. Tokens

### D.1 Tokens ajoutés ou corrigés dans `design-tokens.json` (2026-10-09)
- **Couleurs :** `danger-text` (#B91C1C), `info-text` (#1D4ED8), `neutral-text` (#475569), `on-danger` (#FFFFFF), `on-navy-muted` (#CBD5E1), `border-strong` (#718096), `overlay`.
- **Tailles :** `touch-target-mobile` 48, `header-height` 64, `bottom-nav-height` 64, `toast-max-width` 420, `illustration` 160, `border-width` 1, `icon-sm/md/lg` 16/20/24, `avatar-md/lg` 40/48.
- **Groupes :** `focus` (width, offset, couleurs claire/sombre), `opacity` (hover, pressed, disabled), `breakpoint` (sm, md, lg, xl), `motion.toast-duration`, `motion.skeleton`.
- **Statuts :** `icon` et `labelKey` sur chaque statut ; 16 statuts du glossaire ajoutés + `INCONNU` ; `fg` de REFUSE/SUSPENDU/EN_LITIGE → `danger-text`, A_REGLER → `info-text`, EXPIRE → `neutral-text`. Les valeurs de couleur existantes sont **inchangées**.
- **À faire par D1 (outillage requis) :** génération Tailwind / `ThemeData` et tests de contraste automatiques.

### D.2 Contrastes vérifiés (calcul WCAG, 2026-10-09)
`navy/surface` 16,97 · `on-navy/navy` 16,97 · `on-emerald/emerald` 6,69 · `on-danger/danger` 4,83 · `emerald-text/surface` 5,48 · `emerald-text/emerald-soft` 4,84 · `danger-text/danger-soft` 5,30 · `info-text/info-soft` 5,49 · `warning-text/warning-soft` 4,51 · `neutral-text/border` 6,15 · `text-muted/surface` 4,76 · `text-muted/bg` 4,55 · `on-navy-muted/navy` 11,43 · `on-navy-muted/navy-deep` 8,32 · `border-strong/surface` 4,02 (non textuel ≥ 3) · `emerald/navy` 6,69 (focus sur fond sombre). **Interdits :** `emerald/surface` 2,54 · `text-faint/surface` 2,56 · `danger/danger-soft` 3,95 pour du texte · `text-muted/border` 3,86 · `text-muted/navy` 3,57.

---

## E. Décisions et questions ouvertes

**Tranché par l'utilisateur le 2026-10-09** (journal `docs/handoff/decisions.md`, cahier v4.1) :
1. **Formats des montants** : FR et AR `48 250,000 TND` (chiffres occidentaux), EN `48,250.000 TND` (A.1, C.6).
2. **COM-04 / commerçant** : jamais de solde, de motif ni de montant ; texte « Paiement refusé. Le client peut vérifier son application. » (C.8.11).
3. **Membre famille** : ne voit que le reste de sa propre limite, jamais le solde de l'employé (C.4.3, C.8.6, C.8.7).
4. **Toasts d'erreur** sans fermeture automatique (WCAG 2.2.1) ; succès et info 4 s (C.5).
5. **Statut de paiement** « Confirmé » / `CONFIRMED` (C.3).
6. **Nouveaux tokens** (D.1) acceptés ; historique commerçant web en onglet du module Encaissement (`navigation.md`).

**Encore ouvert :**
1. **[DÉCISION] `main` — membre famille sans plafond individuel.** RG-2.3 rend le plafond individuel *optionnel* : sans plafond, il n'existe pas de « reste sur sa limite » à afficher. Que montre la carte (C.4.3) ? Rien n'est inventé ; proposition design : message sans montant « Aucune limite individuelle définie ».
2. **[QUESTION] backend (ouvertes) :** `GET /me` (rôle, sous-rôle, permissions, espaces multiples), compteur de notifications non lues, statuts dérivés `A_REGLER` / `EXPIRE` / `SUSPECT`, noms des champs de `GET /me/wallet` et `GET /me/transactions`, **réponse de `/me/wallet` et code d'erreur de paiement pour un `FAMILY_MEMBER`** (reste de limite seulement, jamais `missingMillimes` de l'employé).
3. **Vérification securite :** stockage local du dernier solde hors connexion (mobile), contenu du paramètre `returnTo` de reconnexion.
4. **Annonce `[SPEC]`** à frontend et mobile : à émettre à leur lancement (non lancés dans cette passe).

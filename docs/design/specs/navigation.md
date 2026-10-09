# Spec design – Navigation (web et mobile) et écrans de session
**Statut :** prête pour relecture · **Tâche :** P0-D3 · **Auteur :** design · **Date :** 2026-10-09
**Exigences couvertes :** cahier §5.6 (navigation desktop, modules par espace), §5.7 (navigation mobile), §5.8 (principes UX) ; charte §5 (lignes « Navigation desktop / mobile ») et §10 (écrans de sécurité : session expirée) ; spec 06 §4 (hors connexion) ; spec 07 (rôles du commerçant) ; EMP-08 (langue), RG-2.4 (chacun ne voit que son périmètre).
**Destinataires :** frontend (coquille web, P0-F2) et mobile (coquilles barre basse, P0-M2). **Non annoncé** (équipes non lancées) : `[SPEC]` à émettre à leur lancement.
**Dépend de :** `docs/design/specs/fondations-composants.md` (boutons, badges, `Amount`, `StateView`, squelette, toast). Les références « C.x » et « A.x » renvoient à ce fichier. Contrat : `docs/handoff/contracts/openapi.yaml` (B5, en cours) — format d'erreur Problem Details et pagination déjà **confirmés par backend** ; la forme de `GET /me` est **en attente de confirmation** (§F).

> Aucune valeur en dur : toutes les dimensions, couleurs et durées sont des tokens de `docs/design/design-tokens.json`.

---

## Principes communs

1. **Une page = un objectif.** La navigation ne contient que des destinations ; l'action principale d'une page est dans l'en-tête (web) ou dans la page (mobile), jamais dans la barre de navigation.
2. **La navigation n'est pas la sécurité.** On masque les modules non autorisés par permission ; l'**autorité est le serveur** (403 `FORBIDDEN` → C.8.8, 404 pour une ressource d'un autre tenant → C.8.9, sans distinction).
3. **Aucun rôle inventé.** Les espaces et modules sont ceux du cahier §5.6 ; les sous-rôles viennent des specs 01, 05 et 07.
4. **Élément actif jamais signalé par la couleur seule** : fond + repère + graisse + `aria-current`.
5. **RTL natif** : la sidebar passe à droite, la barre basse s'inverse, par propriétés logiques seulement (A.5).

### Source des données de navigation (hypothèse à confirmer avec backend)
`GET /me` fournit : `displayName`, `role` (`ADMIN` | `COMPANY` | `MERCHANT` | `EMPLOYEE` | `FAMILY_MEMBER`), `subRole` éventuel, `permissions[]`, `memberships[]` éventuels (plusieurs espaces). Compteur de notifications non lues : champ de `/me` ou route dédiée (**ouvert**). La navigation est calculée **uniquement** à partir de ces données, jamais d'une valeur côté client.

### Libellés de rôle (clés `role.*`)
`role.ADMIN` « Administrateur » · `role.COMPANY` « Entreprise » · `role.MERCHANT` « Commerçant » · `role.EMPLOYEE` « Employé » · `role.FAMILY_MEMBER` « Membre famille ». Sous-rôles (specs 01, 05, 07 ; **enums à confirmer**) : `role.sub.OWNER` « Propriétaire » · `role.sub.MANAGER` « Gestionnaire » · `role.sub.ACCOUNTANT` « Comptable » · `role.sub.READ_ONLY` « Lecture seule » · `role.sub.CASHIER` « Caissier » · `role.sub.SUPER_ADMIN` « Super-administrateur » · `role.sub.FINANCE` « Finance » · `role.sub.SUPPORT` « Support » · `role.sub.COMPLIANCE` « Conformité ».

---

## N.1 Sidebar web (3 espaces)

**1. Objectif.** Permettre à l'Administrateur, à l'Entreprise et au Commerçant d'atteindre n'importe quel module en un clic, en sachant toujours où il se trouve et sous quel rôle il agit. Exigences : cahier §5.6, charte §5.

**2. Structure (de haut en bas, un seul `<nav>`).**
1. **Logo** (lien vers l'accueil de l'espace).
2. **Profil et rôle actif** : pastille d'initiales, nom (`displayName`), rôle (+ sous-rôle).
3. **Modules** (liste verticale, un niveau, tableau ci-dessous).
4. Espace flexible.
5. **Pied** : « Changer d'espace » (affiché **seulement** si `memberships[]` contient plus d'un espace) puis « Se déconnecter ».

Modules (cahier §5.6, **ordre et libellés repris tels quels** ; icônes Lucide proposées par design, hors icônes imposées par la charte §6) :

| Espace | Clé | Module (FR) | Icône |
|---|---|---|---|
| Administrateur | `nav.admin.dashboard` | Tableau de bord | `LayoutDashboard` |
| | `nav.admin.accounts` | Gestion des comptes | `Building2` |
| | `nav.admin.transactions` | Transactions | `ArrowLeftRight` |
| | `nav.admin.settlements` | Règlements & compensation | `Landmark` |
| | `nav.admin.settings` | Paramétrage | `Settings2` |
| | `nav.admin.security` | Sécurité & conformité | `ShieldCheck` |
| | `nav.admin.reporting` | Reporting | `ChartColumn` |
| | `nav.admin.support` | Support | `LifeBuoy` |
| Entreprise | `nav.company.dashboard` | Tableau de bord | `LayoutDashboard` |
| | `nav.company.orders` | Commandes | `ClipboardList` |
| | `nav.company.beneficiaries` | Bénéficiaires | `Users` |
| | `nav.company.allocations` | Attributions | `HandCoins` |
| | `nav.company.reporting` | Reporting | `ChartColumn` |
| | `nav.company.accounting` | Comptabilité | `Calculator` |
| | `nav.company.settings` | Paramètres | `Settings2` |
| | `nav.company.support` | Support | `LifeBuoy` |
| Commerçant | `nav.merchant.dashboard` | Tableau de bord | `LayoutDashboard` |
| | `nav.merchant.collect` | Encaissement | `QrCode` |
| | `nav.merchant.settlements` | Règlements & factures | `FileText` |
| | `nav.merchant.shop` | Mon commerce | `Store` |
| | `nav.merchant.statistics` | Statistiques | `ChartLine` |
| | `nav.merchant.support` | Support | `LifeBuoy` |
| | `nav.merchant.settings` | Paramètres | `Settings2` |

Décisions d'architecture de l'information (design, sans règle métier) :
- **Un seul niveau** dans la sidebar. Les sous-sections d'un module sont des **onglets dans la page** : Administrateur → Paramétrage → onglets *Commissions, Catégories, Plafonds, Seuils, Cycles* (ADM-09, RG-1.1) ; Commerçant → Encaissement → onglets *Encaisser, Historique* (COM-06 n'a pas de module propre dans le cahier §5.6).
- L'utilisateur voit uniquement les modules dont il a la **permission** (ex. Commerçant « caissier » : Encaissement ; « comptable » : Règlements & factures ; spec 07 §2). Le nom de la permission requise par module est fourni par backend.
- « Changer d'espace » (cahier §5.6 « changement de rôle en bas ») ouvre une liste des espaces autorisés ; choisir un espace recharge toute la coquille avec le nouveau tenant.

**3. Composants et tokens.** shadcn/ui : `Sidebar`/`NavigationMenu` (liste de liens), `Avatar`, `Button` variante `tertiary` pour le pied, `Sheet` (tiroir sous `breakpoint.lg`). Tokens :
- Fond `color.navy` · largeur `size.sidebar-width` (264) · padding `space.4` · espace entre sections `space.6` · séparateur `color.navy-deep` (`size.border-width`).
- Profil : pastille `size.avatar-md`, `radius.avatar`, fond `color.navy-deep`, initiales `color.on-navy` `type-scale.label` ; nom `type-scale.label` `color.on-navy` ; rôle `type-scale.caption` `color.on-navy-muted`.
- Élément de module : hauteur ≥ `size.touch-target-min` (44), padding horizontal `space.3`, espace icône-texte `space.3`, `radius.button`, icône `size.icon-md`, texte `type-scale.label`, espace entre éléments `space.1`.
- **Inactif :** texte et icône `color.on-navy-muted` (11,43:1 sur navy). **Survol :** couche `color.on-navy` à `opacity.hover`. **Actif :** fond `color.navy-deep` (12,35:1 avec `on-navy`), texte et icône `color.on-navy`, graisse `font.weight.title`, **repère** vertical de largeur `space.1` en `color.emerald` au bord `start` (6,69:1 sur navy) ; `aria-current="page"`.
- **Focus :** anneau `focus.width`, `focus.offset`, couleur `focus.color-on-dark` (`emerald`).
- Durées `motion.fast` (survol), `motion.base` (tiroir).

**4. Textes et clés i18n.**

| Clé | FR |
|---|---|
| `app.name` | FlexiPay (nom de marque, modifiable : vérification de marque en cours, `open-questions.md`) |
| `nav.main.label` | Navigation principale |
| `nav.skip` | Aller au contenu principal |
| `nav.logo.label` | FlexiPay – retour à l'accueil |
| `nav.switchSpace` | Changer d'espace |
| `nav.switchSpace.current` | Espace actuel : {role} |
| `nav.logout` | Se déconnecter |
| `nav.menu.open` | Ouvrir le menu |
| `nav.menu.close` | Fermer le menu |
| `nav.profile.initials` | initiales (calculées, non traduites) |

Modules : clés `nav.<espace>.<module>` du tableau. Les noms de langue (`language.fr` Français · `language.ar` العربية · `language.en` English) sont des **endonymes** affichés dans leur propre langue.

**5. États.**
- **Chargement** (`GET /me` en cours) : squelette (C.7) : pastille + 2 lignes de profil, 6 lignes de modules (primitive `list-item`), pas de faux libellés.
- **Normal** · **survol** · **focus** · **actif** · **appui**.
- **Vide** : si l'utilisateur n'a aucune permission de module, la sidebar ne montre que le profil et « Se déconnecter », et le contenu affiche *Permission refusée* (C.8.8) avec `nav.empty.message` « Aucun module n'est disponible pour votre compte. Contactez le propriétaire de votre compte. ».
- **Erreur** (`GET /me` échoue) : la sidebar affiche le logo et « Se déconnecter » seulement ; le contenu affiche l'état *Erreur + Réessayer* (C.8.3).
- **Hors connexion** : la sidebar reste affichée à partir des données déjà chargées ; la navigation vers un module non chargé affiche l'état hors connexion dans le contenu (N.7).
- **Session expirée** : la coquille entière est remplacée par l'écran N.6.
- **Solde insuffisant** : sans objet dans la navigation.
- **Permission refusée** : un module masqué n'est pas atteignable ; l'accès direct par URL affiche C.8.8.

**6. RTL.** Dans une langue RTL, la sidebar s'ancre à `start` (donc à droite) et le contenu passe à gauche ; repère actif à `start` ; chevrons du sélecteur d'espace en miroir ; texte aligné `start` ; icônes de module non directionnelles inchangées (`ArrowLeftRight` pour *Transactions* est symétrique) ; les noms de rôle restent traduits, les initiales suivent la langue du nom.

**7. Accessibilité.**
- `<nav aria-label="{nav.main.label}">` ; un **lien d'évitement** « Aller au contenu principal » (`nav.skip`) est le premier élément focalisable, visible au focus.
- **Ordre de focus :** lien d'évitement → logo → modules (de haut en bas) → « Changer d'espace » → « Se déconnecter » → en-tête (N.2) → contenu.
- Cible ≥ 44 px sur toute la largeur de l'élément. Contraste : `on-navy-muted/navy` 11,43:1 · `on-navy/navy-deep` 12,35:1 · repère `emerald/navy` 6,69:1. Texte secondaire du profil en `on-navy-muted`, **jamais** `text-muted` (3,57:1) ni `text-faint`.
- Élément actif : fond + repère + graisse + `aria-current` (pas la couleur seule). Tiroir (< `breakpoint.lg`) : `role="dialog"`, `aria-modal`, piège de focus, Échap ferme, le focus retourne au bouton qui l'a ouvert.

**8. Responsive.** ≥ `breakpoint.lg` (1024) : sidebar **fixe** de `size.sidebar-width`, contenu à côté, contenu centré et limité à `size.desktop-max-width`. < `breakpoint.lg` : sidebar masquée, ouverte en **tiroir** depuis `start` par le bouton menu de l'en-tête (N.2), largeur `size.sidebar-width`, voile `color.overlay`, durée `motion.base` (sans animation si « Réduire les animations »). Il n'y a **pas de barre basse sur le web** (réservée aux applications mobiles Employé et Pro).

**9. Données / endpoint.** `GET /me` (rôle, sous-rôle, permissions, espaces, nom) — **forme à confirmer avec backend** ; `POST /auth/logout` (spec 01) ; un changement d'espace s'appuie sur le contrat d'authentification (**à confirmer**).

---

## N.2 En-tête desktop

**1. Objectif.** Situer l'utilisateur (fil d'Ariane), exposer **l'action principale de la page** et les outils transverses (notifications, compte). Exigence : cahier §5.6 (« fil d'Ariane, utilisateur, badge de rôle, notifications, action principale »).

**2. Structure (de `start` à `end`).** Bouton menu (< `breakpoint.lg` seulement) · **fil d'Ariane** · espace flexible · **action principale de la page** (un seul `Button` `primary` ou `accent`, optionnel) · **notifications** (cloche + compteur) · **menu du compte** (pastille, nom, **badge de rôle**).
Menu du compte (liste) : Mon profil · Langue (Français / العربية / English) · Se déconnecter.

**3. Composants et tokens.** shadcn/ui : `Breadcrumb`, `Button`, `DropdownMenu`, `Avatar`, `Badge`. Hauteur `size.header-height` (64) · fond `color.surface` · bordure basse `color.border` (`size.border-width`) · padding horizontal `space.6` (`space.8` dès `breakpoint.xl`) · espaces entre groupes `space.4`. Fil d'Ariane : `type-scale.body`, segments `color.text-muted` (4,76:1 sur surface), segment courant `color.text` `font.weight.label`, séparateur `ChevronRight` `color.text-faint` (décoratif). Cloche : `Bell` `size.icon-lg`, bouton ≥ 44 px ; compteur : pastille `color.danger` + texte `color.on-danger` `type-scale.micro`, plafonné à « 99+ ». Badge de rôle : `radius.badge`, fond `color.border`, texte `color.navy` `type-scale.caption` `font.weight.label` (13,76:1) — **neutre** : les couleurs fonctionnelles sont réservées aux statuts. Contenu sous l'en-tête : fond `color.bg`, padding `space.6`–`space.8`.

**4. Textes et clés.**

| Clé | FR |
|---|---|
| `nav.breadcrumb.label` | Fil d'Ariane |
| `nav.notifications` | Notifications |
| `nav.notifications.unread` | {count, plural, one {# notification non lue} other {# notifications non lues}} |
| `nav.notifications.none` | Aucune notification non lue |
| `nav.userMenu` | Menu du compte |
| `nav.profile` | Mon profil |
| `nav.language` | Langue |
| `nav.logout` | Se déconnecter |

L'action principale utilise les clés de la page (`ecran.action.principale`). Le fil d'Ariane utilise les clés des modules et des pages (`nav.<espace>.<module>` + clé de page).

**5. États.** Chargement : squelette (fil d'Ariane 2 segments, cloche, pastille). Normal. Sans notification : cloche sans compteur. Compteur indisponible : cloche sans compteur et sans erreur visible. Erreur `GET /me` : l'en-tête garde le menu de déconnexion seulement. **Hors connexion** : le bouton d'action principale est désactivé avec la raison (`common.state.offline.actionDisabled`, C.8.4) ; la cloche reste accessible. Session expirée : N.6. Permission refusée : l'action principale est **absente** (non autorisée) ; si le serveur répond 403, toast `error` (C.5) ou `StateView`.

**6. RTL.** L'en-tête est inversé (menu / fil d'Ariane à `start` = droite) ; séparateur du fil d'Ariane `ChevronLeft` en RTL (miroir) ; la cloche et le menu du compte sont à `end` ; le compteur est à l'`end` supérieur de la cloche ; le sélecteur de langue change `dir` et la police (`font.family-ar`).

**7. Accessibilité.** `<header role="banner">` ; fil d'Ariane `<nav aria-label>` en liste ordonnée, `aria-current="page"` sur le segment courant ; cloche : nom accessible `nav.notifications` + compteur annoncé (`nav.notifications.unread`) — le compteur n'est pas la seule information ; menu du compte : `aria-haspopup="menu"`, flèches Haut/Bas, Échap ; cibles ≥ 44 px. **Ordre de focus :** (après la sidebar) bouton menu → fil d'Ariane → **action principale** → notifications → menu du compte → contenu. Titre de page `h1` unique dans le contenu ; `document.title` = « {page} – FlexiPay ».

**8. Responsive.** ≥ `breakpoint.lg` : tous les éléments. < `breakpoint.lg` : bouton menu à `start`, fil d'Ariane réduit au **titre de la page courante** (segments parents dans le menu au clic), action principale réduite à une icône avec nom accessible si l'espace manque (cible ≥ 44 px), badge de rôle déplacé dans le menu du compte. < `breakpoint.sm` : cloche + menu du compte seuls ; l'action principale passe en bas de page (pleine largeur, C.1).

**9. Données / endpoint.** `GET /me` (nom, rôle, sous-rôle, compteur éventuel) ; `GET /me/notifications` (liste paginée par curseur, A.8) pour le panneau de notifications ; `PATCH` de la langue préférée : **à confirmer** (la langue peut rester locale au client au MVP). Pas de montant dans l'en-tête.

---

## N.3 Barre basse mobile Employé

**1. Objectif.** Donner à l'employé (et au membre famille) un accès direct aux 5 destinations essentielles de l'app, l'action la plus fréquente étant **Payer**. Exigences : cahier §5.7, EMP-02 à EMP-08.

**2. Structure.** 5 onglets **dans cet ordre** : **Accueil · Payer · Où dépenser · Historique · Profil**. Chaque onglet = icône au-dessus du libellé. La barre est visible sur les **5 écrans racines** ; elle est **masquée** sur les écrans empilés au-dessus (confirmation PIN, scanner plein écran, détail de transaction, création de membre famille, etc.). Chaque onglet conserve son état de navigation ; un second appui sur l'onglet actif revient à la racine de l'onglet puis remonte en haut de la liste.

| Onglet | Clé | FR | Icône (Lucide) |
|---|---|---|---|
| 1 | `nav.employee.home` | Accueil | `House` |
| 2 | `nav.employee.pay` | Payer | `QrCode` |
| 3 | `nav.employee.spend` | Où dépenser | `MapPin` |
| 4 | `nav.employee.history` | Historique | `History` |
| 5 | `nav.employee.profile` | Profil | `UserRound` |

**3. Composants et tokens.** Flutter : `NavigationBar` thémé depuis les tokens (go_router `StatefulShellRoute`, choix technique de mobile). Hauteur `size.bottom-nav-height` (64) **plus** la zone sûre basse du système · fond `color.surface` · bordure haute `color.border` (`size.border-width`) · ombre `shadow.card` · cible de chaque onglet : largeur `1/5` de l'écran, hauteur ≥ `size.touch-target-mobile` (48 dp) · icône `size.icon-lg` · libellé `type-scale.caption` · espace icône-libellé `space.1`.
- **Inactif :** icône et libellé `color.text-muted` (4,76:1 sur surface).
- **Actif :** pastille derrière l'icône `color.emerald-soft` (`radius.badge`), icône et libellé `color.navy` (16,97:1), libellé `font.weight.title`. L'actif est donc signalé par **forme + graisse + couleur**.
- **Appui :** couche `color.navy` à `opacity.pressed`. Transition `motion.fast`.
- Pas de badge numérique dans la barre (les notifications sont dans l'en-tête, N.5).

**4. Textes et clés.** Voir tableau. `nav.bottom.label` « Navigation principale ». Lecteur d'écran : `nav.bottom.item` « {label}, onglet {index} sur {total} » (fourni nativement par `NavigationBar` quand possible).

**5. États.**
- **Chargement :** la barre est **toujours affichée** (elle ne dépend d'aucune donnée) ; le contenu de l'onglet affiche son squelette (C.7).
- **Vide / erreur :** gérés par l'écran de l'onglet (C.8.2, C.8.3).
- **Hors connexion :** la barre reste active ; les onglets Accueil et Historique affichent les dernières données avec `common.state.offline.lastUpdate` ; l'onglet **Payer** affiche `common.state.offline.payDisabled` « Le paiement nécessite une connexion. Reconnectez-vous pour payer. » (spec 06 §4) ; Où dépenser peut être consulté en cache sinon état hors connexion.
- **Session expirée :** N.6 plein écran, la barre disparaît.
- **Solde insuffisant :** non porté par la barre ; l'onglet Payer affiche `FundsAlert` (C.8.6) après refus.
- **Permission refusée :** pour un **membre famille**, un onglet non permis est retiré (la barre peut compter moins de 5 onglets) ; l'accès direct affiche C.8.8. *La liste exacte des écrans interdits aux membres famille reste à définir dans la spec de l'app (compte famille : paiement uniquement dans sa limite, RG-2.3).*

**6. RTL.** La barre est inversée : **Accueil est à droite**, Profil à gauche (ordre de lecture conservé) ; icônes inchangées (aucune n'est directionnelle) ; libellés dans la langue ; le sens de balayage entre onglets suit la direction.

**7. Accessibilité.** Chaque onglet est un bouton avec nom, rôle « onglet », position (« 2 sur 5 ») et état sélectionné ; cible ≥ 48 dp ; contraste ci-dessus ; **ne dépend pas de la couleur seule** ; respecte le facteur d'échelle du texte système : la hauteur de la barre croît, les libellés passent sur 2 lignes (« Où dépenser ») sans être tronqués ; TalkBack/VoiceOver : ordre de focus de `start` à `end`, la barre est atteinte après le contenu de l'écran ; retour système : sur un onglet racine autre qu'Accueil, retourne à Accueil, puis quitte.

**8. Responsive.** Téléphones 320–480 dp : 5 onglets égaux. Tablettes / paysage : la barre reste en bas, les onglets gardent une largeur égale, le contenu est centré et limité à `breakpoint.md`. Pas de rail latéral dans le MVP.

**9. Données / endpoint.** Aucune donnée affichée dans la barre. Les permissions (membre famille) viennent de `GET /me` (**à confirmer**).

---

## N.4 Barre basse mobile Pro (Commerçant)

**1. Objectif.** Permettre au commerçant (propriétaire, caissier, comptable) d'**encaisser en moins de gestes** et de suivre règlements et historique. Exigences : COM-02 à COM-08 ; cahier §5.7 ; charte §5.

**2. Structure.** 5 onglets dans cet ordre : **Accueil · Encaisser · Règlements · Historique · Profil**. Mêmes règles de visibilité et de pile que N.3 (barre masquée sur les écrans de scan plein écran, validation client avec compte à rebours, confirmation, reçu).

| Onglet | Clé | FR | Icône |
|---|---|---|---|
| 1 | `nav.pro.home` | Accueil | `House` |
| 2 | `nav.pro.collect` | Encaisser | `QrCode` |
| 3 | `nav.pro.settlements` | Règlements | `Landmark` |
| 4 | `nav.pro.history` | Historique | `History` |
| 5 | `nav.pro.profile` | Profil | `UserRound` |

**Permissions (spec 07 §2).** Propriétaire : 5 onglets. **Caissier** (encaisser + historique) : Accueil · Encaisser · Historique · Profil, **sans Règlements**. **Comptable** (règlements et factures) : Accueil · Règlements · Historique · Profil, sans Encaisser. La barre se recompose automatiquement (3 à 5 onglets) à partir des permissions de `GET /me` ; le serveur reste l'autorité.

**3. Composants et tokens.** Identiques à N.3 (`NavigationBar`, `size.bottom-nav-height`, `size.touch-target-mobile`, `color.surface`, `color.border`, `color.emerald-soft`, `color.navy`, `color.text-muted`, `type-scale.caption`, `size.icon-lg`, `opacity.pressed`, `motion.fast`).

**4. Textes et clés.** Voir tableau ; `nav.bottom.label` partagé.

**5. États.** Chargement : barre toujours affichée, squelette dans l'onglet. Vide / erreur : par écran. **Hors connexion :** barre active ; **Encaisser** affiche `nav.pro.offline.collect` « L'encaissement nécessite une connexion. » avec l'état hors connexion (C.8.4) — le mode hors ligne du commerçant est COM-11 (Could), hors MVP ; Règlements et Historique montrent les dernières données avec date ; Session expirée : N.6. Paiement refusé : l'écran de validation du commerçant affiche l'écran générique `PAYMENT_DECLINED` (C.8.11), sans motif ni montant. Permission refusée : onglet retiré ; accès direct → C.8.8.

**6. RTL.** Comme N.3 (Accueil à droite) ; `Landmark`, `QrCode`, `History` non directionnelles ; `History` (flèche circulaire) reste identique en miroir car symbole de temps.

**7. Accessibilité.** Comme N.3. Le compte à rebours du QR (COM-04) n'est pas dans la barre. L'onglet **Encaisser** a une cible ≥ 48 dp et un nom explicite « Encaisser un paiement » (`nav.pro.collect.a11y`).

**8. Responsive.** Comme N.3.

**9. Données / endpoint.** Permissions via `GET /me` (**à confirmer**).

---

## N.5 En-tête mobile (Employé et Pro)

**1. Objectif.** Identifier l'utilisateur et donner accès aux notifications, sans concurrencer la carte solde. Exigence : cahier §5.7 (« header bleu nuit, avatar rond »).

**2. Structure.** Bande bleu nuit : avatar rond à `start` (appui → onglet Profil) · salutation + nom (Pro : nom du commerce / point de vente) · cloche de notifications à `end`. Sur l'onglet Accueil, la carte solde (C.4.3) chevauche l'en-tête ; sur les autres onglets l'en-tête devient une barre titre : titre de l'onglet `type-scale.title`, sans avatar.

**3. Tokens.** Fond `color.navy` · hauteur `size.header-height` + zone sûre haute (l'Accueil ajoute `space.6` pour le chevauchement de la carte) · padding horizontal `space.4` · avatar `size.avatar-lg` (48), `radius.avatar`, fond `color.navy-deep`, initiales `color.on-navy` `type-scale.label` · salutation `type-scale.body-lg` `color.on-navy` ; nom ou rôle `type-scale.caption` `color.on-navy-muted` · cloche `Bell` `size.icon-lg` `color.on-navy`, zone `size.touch-target-mobile` ; compteur : pastille `color.danger`, texte `color.on-danger` `type-scale.micro`.

**4. Textes et clés.** `nav.greeting` « Bonjour, {name} » · `nav.notifications` « Notifications » · `nav.notifications.unread` (pluriel ICU, comme N.2) · `nav.avatar.open` « Ouvrir mon profil ». Nom affiché : prénom seul ou `displayName` (données de `/me`).

**5. États.** Chargement : avatar et deux lignes en squelette sur fond navy (primitives avec fond `color.navy-deep`). Erreur de `/me` : initiales génériques, salutation neutre `nav.greeting.generic` « Bonjour », pas de blocage. Hors connexion : inchangé + bandeau (N.7). Session expirée : N.6. Compteur de notifications indisponible : cloche sans compteur.

**6. RTL.** Avatar à `start` (droite), cloche à `end` (gauche) ; compteur à l'`end` supérieur de la cloche ; nom en LTR isolé s'il est latin.

**7. Accessibilité.** Texte clair sur navy : `on-navy/navy` 16,97:1, `on-navy-muted/navy` 11,43:1 ; cloche et avatar ≥ 48 dp avec noms accessibles ; compteur annoncé en texte (« 3 notifications non lues ») ; titre d'écran marqué comme en-tête (`Semantics(header: true)`).

**8. Responsive.** Largeur pleine ; sur grand écran le contenu de l'en-tête est limité à `breakpoint.md`, fond navy pleine largeur.

**9. Données / endpoint.** `GET /me` ; `GET /me/notifications` (liste paginée par curseur) — compteur non lu **ouvert** auprès de backend.

---

## N.6 Écran « Session expirée » (web et mobile)

**1. Objectif.** Expliquer calmement qu'une reconnexion est nécessaire et ramener l'utilisateur à ce qu'il faisait. Exigences : charte §7 et §10, contrat B5 (`401 SESSION_EXPIRED`, `401 UNAUTHENTICATED`).

**2. Structure.** Écran **hors coquille** (sans sidebar ni barre basse, aucune donnée de l'écran précédent) : logo, `StateView` `page` (C.8.5) : pastille `Clock`, titre, message, **un seul bouton principal « Se reconnecter »**.

**Déclenchement.** (a) `401 SESSION_EXPIRED` : le client tente **un seul** rafraîchissement silencieux ; s'il échoue (nouveau 401) → cet écran, variante *expirée*. (b) `401 UNAUTHENTICATED` pendant une session active → variante *déconnecté* (cause jamais indiquée). (c) Aucun jeton → écran de connexion normal (pas cet écran).

**3. Composants et tokens.** `StateView` (C.8) · fond `color.bg` · logo en bleu nuit (version claire) · pastille `size.avatar-lg`, fond `color.info-soft`, icône `color.info-text` · titre `type-scale.title` · message `type-scale.body-lg` `color.text-muted` · bouton `Button` `primary` (`size.button-height`, 48 dp mobile) · espacements `space.4` et `space.8` · largeur max `size.toast-max-width`.

**4. Textes et clés.**

| Clé | FR |
|---|---|
| `common.state.sessionExpired.title` | Session expirée |
| `common.state.sessionExpired.message` | Pour votre sécurité, votre session a expiré. Reconnectez-vous pour continuer. |
| `common.state.signedOut.title` | Vous avez été déconnecté |
| `common.state.signedOut.message` | Pour votre sécurité, votre session a été fermée. Reconnectez-vous pour continuer. |
| `common.button.signIn` | Se connecter |

**5. États.** Chargement : sans objet (écran statique) ; pendant la tentative de rafraîchissement silencieux : squelette du contenu en cours, **pas** de flash de cet écran. Erreur réseau pendant la reconnexion : voir hors connexion (N.7). Vide / solde insuffisant / permission refusée : sans objet. **Session expirée** : c'est cet écran.

**6. RTL.** Disposition centrée, donc symétrique ; texte en direction de la langue ; aucune flèche.

**7. Accessibilité.** Le focus est placé sur le titre (`tabindex="-1"`, `h1`) à l'affichage, puis le bouton est le suivant dans l'ordre ; annonce du titre par le lecteur d'écran ; message sans jargon ; bouton ≥ 44 px / 48 dp ; contrastes : `info-text/info-soft` 5,49:1 pour la pastille, `text-muted/bg` 4,55:1 pour le message. **Sécurité :** aucune donnée financière affichée ; le paramètre de retour (`returnTo`) ne contient que le chemin, sans identifiant sensible ni jeton (à valider par securite) ; mobile : jetons effacés du stockage sécurisé à l'ouverture de l'écran (implémentation mobile).

**8. Responsive.** Contenu centré verticalement ; mobile : bouton pleine largeur ancré en bas avec padding `space.4` ; ≥ `breakpoint.md` : bouton à la largeur de son contenu.

**9. Données / endpoint.** `POST /auth/refresh` (une tentative), puis `POST /auth/login` (écran de connexion, hors cette spec). Erreur lue : Problem Details (`code`).

---

## N.7 Écran et bandeau « Hors connexion » (web et mobile)

**1. Objectif.** Dire clairement qu'il n'y a pas de connexion, ce qui reste possible (consulter) et ce qui ne l'est pas (payer, encaisser, demander un virement), puis reprendre automatiquement. Exigences : charte §7 ; spec 06 §4 ; contrat B5 (« hors connexion = côté client, pas un code API »).

**2. Structure.** Deux niveaux.
- **Bandeau global** (cas courant) : sous l'en-tête (web) / sous le header (mobile), au-dessus du contenu et de la barre basse ; icône `WifiOff`, message, pas de bouton ; reste affiché tant que la connexion est perdue.
- **Écran plein** (aucune donnée en cache, premier chargement impossible) : `StateView` `page` (C.8.4) avec **Réessayer** comme action principale, dans la coquille si elle est connue, sinon seul.

**Détection (client).** Événement réseau du système + échec de requête sans réponse HTTP ; le retour est confirmé par une requête à la route publique de santé `GET /health` (à confirmer). Au rétablissement : bandeau retiré, toast `success` « Connexion rétablie », rechargement des données périmées.

**3. Composants et tokens.** Bandeau : `radius.card-desktop` (web) / `radius.card-mobile` (mobile), fond `color.warning-soft`, texte `color.warning-text` (4,51:1), icône `WifiOff` `color.warning-text` `size.icon-md`, padding `space.3`–`space.4`, texte `type-scale.body`. Écran plein : pastille `size.avatar-lg`, fond `color.border`, icône `color.neutral-text` (6,15:1). Action désactivée : `opacity.disabled` + texte d'aide.

**4. Textes et clés.**

| Clé | FR |
|---|---|
| `common.state.offline.banner` | Vous êtes hors connexion. Certaines actions sont indisponibles. |
| `common.state.offline.title` | Pas de connexion |
| `common.state.offline.message` | Vérifiez votre connexion internet puis réessayez. |
| `common.state.offline.actionDisabled` | Indisponible hors connexion. |
| `common.state.offline.payDisabled` | Le paiement nécessite une connexion. Reconnectez-vous pour payer. |
| `nav.pro.offline.collect` | L'encaissement nécessite une connexion. |
| `common.state.offline.lastUpdate` | Dernière mise à jour : {date} |
| `common.state.online.toast` | Connexion rétablie |
| `common.button.retry` | Réessayer |

**5. États.** *Hors connexion* (bandeau) · *rétablissement* (toast) · *écran plein* (sans cache) · *connexion instable* (requêtes en échec alors que le système se dit en ligne) → erreur `errors.network` avec réessai (C.8.3). Chargement : la reconnexion n'affiche pas de squelette si des données existent déjà. Session expirée pendant la perte de connexion : le rafraîchissement échoue réseau → on reste hors connexion, **sans** passer par N.6 tant qu'aucune réponse 401 n'a été reçue. Solde insuffisant : jamais affiché hors connexion (le serveur seul décide) ; le bouton de paiement est désactivé. Permission refusée : sans objet.

**6. RTL.** Icône à `start`, texte aligné `start` ; la date « Dernière mise à jour » est formatée selon la locale, nombres en chiffres occidentaux.

**7. Accessibilité.** Bandeau `role="status"` (`aria-live="polite"`) : annonce unique à l'apparition et au retour ; jamais une alerte assertive ; les actions désactivées exposent leur raison (`aria-describedby`) ; contraste ci-dessus ; icône + texte (pas la couleur seule). **Sécurité :** les montants affichés hors connexion sont datés et présentés comme non actuels ; le stockage local de ces données est à valider par securite avant implémentation mobile.

**8. Responsive.** Bandeau pleine largeur du contenu ; mobile : au-dessus de la barre basse sans la recouvrir ; ne bouge pas la mise en page de façon brutale (hauteur réservée dès `motion.base`, sans animation si « Réduire les animations »).

**9. Données / endpoint.** Aucun endpoint métier. `GET /health` (publique) pour confirmer le retour réseau — **à confirmer** avec backend (route prévue en P0-B3).

---

## F. Décisions et questions ouvertes

1. **[QUESTION] backend (ouverte, message envoyé) :** forme de `GET /me` (rôle, sous-rôle, permissions, espaces multiples), compteur de notifications non lues, noms des permissions par module, changement d'espace.
2. **[DÉCISION] team-lead — barre basse du membre famille :** liste des onglets/écrans permis (RG-2.3 : « paiement dans sa limite »). Recommandation design : Accueil, Payer, Historique, Profil (sans Où dépenser ni gestion famille) ; à confirmer par la spec de l'app Employé.
3. **Information d'architecture (design) :** historique du commerçant (COM-06) = onglet du module *Encaissement* sur le web ; onglets dans *Paramétrage* pour l'Administrateur. À valider avec les écrans correspondants.
4. **Reste de [DÉCISION] sur l'affichage du montant manquant** pour le commerçant et la famille : voir `fondations-composants.md` §E.
5. **Annonce `[SPEC]`** à frontend et mobile : à émettre à leur lancement (non lancés dans cette passe).

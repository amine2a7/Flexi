# Spec design – Commun › Session expirée (et déconnecté)
**Statut :** prête pour relecture (ux → conformite → securite) · **Tâche :** WD1 · **Auteur :** design · **Date :** 2026-10-11
**Route :** `/session-expired` (hors coquille) · **Rôles :** tout utilisateur web · **Exigences couvertes :** charte §7 et §10 (« session expirée »), contrat §4 (`401 SESSION_EXPIRED`, `401 UNAUTHENTICATED`), `navigation.md` N.6 et N.9, `fondations-composants.md` C.8.5, revue ux UX-16, UX-17, UX-21.
**Dépend de :** `_socle-ecrans.md`, `commun-connexion.md`. Cette spec **détaille la page** décrite en N.6 ; l'**avertissement avant expiration** est N.9 (`navigation.md`).

## 1. Objectif
Expliquer calmement qu'une reconnexion est nécessaire et ramener l'utilisateur à la page qu'il visitait. **Action principale unique : « Se reconnecter ».**

## 2. Rôles et permissions
Tout utilisateur dont la session n'est plus valide. Cet écran n'est **jamais** affiché à quelqu'un qui n'a pas eu de session (il va directement à `/login`).

## 3. Structure
Page hors coquille (aucune donnée de l'écran précédent) : logo · sélecteur de langue (UX-21) · `StateView` `page` (C.8.5) : pastille `Clock`, `h1`, message, **bouton principal « Se reconnecter »**.

**Déclenchement** (inchangé, N.6) : (a) `401 SESSION_EXPIRED` → **un seul** rafraîchissement silencieux (`POST /v1/auth/refresh`), s'il échoue → variante *expirée* ; (b) `401 UNAUTHENTICATED` pendant une session active (révocation) → variante *déconnecté* (**la cause n'est jamais indiquée**) ; (c) aucun jeton → `/login`, pas cet écran. Pendant la tentative de rafraîchissement, l'écran en cours garde son squelette (pas de flash de cette page).

### 3.1 Retour à la page visitée (`returnTo`)
- Le client mémorise le **chemin** de la page visitée (le chemin, et seulement les paramètres de la liste blanche de la route, §3.1 et ux N-07 ; sans fragment ni identifiant sensible) et le transmet à `/login?returnTo=<chemin>`.
- **Validation côté client uniquement** (le contrat `LoginRequest` n'a pas de paramètre `returnTo` : le serveur n'intervient pas dans la redirection) **— durcie suite à la revue securite WD1-S02 :** (1) la valeur est **décodée une seule fois**, puis **rejetée** si elle contient encore `%`, un caractère de contrôle (dont tabulation et saut de ligne), une espace, `//`, `\`, `/.` ou `..` ; (2) elle doit correspondre **exactement** à une route connue de l'espace du rôle (la **liste blanche** de routes est la protection principale) ; (3) la navigation passe **par le routeur** avec un chemin, **jamais** `location.href = returnTo` ; (4) sinon repli sur l'accueil de l'espace. Exemples rejetés : `/%2F%2Fevil.tn`, `/<TAB>/evil.tn`, `//evil.tn`, `https://evil.tn`.
- **Portée de la règle :** elle vaut pour **tout code qui redirige à partir de `returnTo`**, y compris le serveur Next.js (middleware, `redirect()` dans une action ou un composant serveur), qui applique exactement la même validation, sinon il recrée la redirection ouverte côté serveur (vérifié par securite en F1).
- **Chaîne de requête (ux N-07, conditions de securite acceptées) :** seules des valeurs **non personnelles** sont restituées, selon une **liste blanche de paramètres par route** (énumérations — statut, type —, dates, montants bornés, identifiants opaques) ; **jamais** la recherche en texte libre (`q`, nom, téléphone, e-mail, CIN, RIB) **ni le curseur** (ils transiteraient par `/login?returnTo=…`, l'historique du navigateur, les journaux du serveur et le `Referer`) ; chaque valeur est validée par le schéma de la route, sinon le paramètre est abandonné ; longueur totale bornée par la configuration ; la chaîne est encodée une fois puis revalidée comme ci-dessus ; le chemin reste soumis à la liste blanche exacte. Le retour amène donc sur la liste avec ses filtres non personnels, sans recherche ni page.
- **Conservation de la saisie en cours : en attente de décision de l'utilisateur** (option B recommandée par le lead et par ux, **non adoptée** tant que la décision n'est pas consignée dans `decisions.md` ; saisie conservée en mémoire seulement, champs sensibles vidés, jamais de soumission automatique d'une opération financière). Tant qu'elle n'est pas rendue, **aucune saisie n'est conservée** et l'avertissement N.9 est le seul filet. **Condition de securite si l'option B est retenue :** la saisie est liée à l'identifiant de l'utilisateur et **jetée** si un autre compte se reconnecte dans le même onglet (poste partagé).

## 4. Composants et tokens
`StateView` `page` (C.8) : pastille `size.avatar-lg`, fond `color.info-soft`, icône `Clock` `color.info-text` `size.icon-lg` ; titre `type-scale.title` `color.text` ; message `type-scale.body-lg` `color.text-muted` ; fond de page `color.bg` ; bouton `Button` `primary` (`size.button-height`) ; largeur max `size.toast-max-width` ; espacements `space.4` / `space.8` ; `LanguageSwitcher` (cf. `commun-connexion.md`).

## 5. Textes et clés i18n (FR de référence)
| Clé | FR |
|---|---|
| `common.state.sessionExpired.title` | Session expirée |
| `common.state.sessionExpired.message` | Pour votre sécurité, votre session a expiré. Reconnectez-vous pour continuer. |
| `common.state.signedOut.title` | Vous avez été déconnecté |
| `common.state.signedOut.message` | Pour votre sécurité, votre session a été fermée. Reconnectez-vous pour continuer. |
| `common.button.signInAgain` | Se reconnecter |
| `auth.sessionExpired.returnNote` | Après votre reconnexion, vous serez ramené à la page que vous consultiez. Les informations non enregistrées ne sont pas conservées. (texte provisoire : à ajuster si l'option B de conservation de la saisie est décidée) |
La clé `common.button.signIn` « Se connecter » est réservée à l'écran de connexion (UX-16).

## 6. États
| État | Rendu |
|---|---|
| Variante *expirée* | titre/message `sessionExpired` |
| Variante *déconnecté* | titre/message `signedOut` ; **aucune cause** (révocation, changement de mot de passe, autre appareil) |
| Chargement | sans objet (écran statique) ; pendant le rafraîchissement silencieux, le contenu en cours garde son squelette |
| Erreur | le bouton ne fait que naviguer ; aucune erreur propre |
| Hors connexion | si le rafraîchissement échoue **faute de réseau** (aucune réponse HTTP), on **ne passe pas** par cet écran : on reste sur la page avec le bandeau C.8.4 ; cet écran n'apparaît qu'après une réponse `401` |
| Vide / solde insuffisant / permission refusée | sans objet |
| Données affichées | aucune donnée financière ni personnelle |

## 7. Données et contrat
| Élément | Source | Statut |
|---|---|---|
| Déclencheur | `Problem.code` ∈ `SESSION_EXPIRED`, `UNAUTHENTICATED` | **E** |
| Rafraîchissement silencieux | `POST /v1/auth/refresh` (cookie + `X-FlexiPay-Client: web`) → `csrfToken` | **E** (contrat §6) |
| Avertissement avant expiration | échéances de session (`sessionExpiresAt`, …) | **N** (CT-X-6) |

## 8. RTL
Disposition centrée, donc symétrique ; texte dans la direction de la langue ; aucune flèche ; le sélecteur de langue passe à `end`.

## 9. Accessibilité
À l'affichage, le focus est placé sur le `h1` (`tabindex="-1"`) puis le bouton est le suivant dans l'ordre ; le titre est annoncé ; message sans jargon ; bouton ≥ `size.touch-target-min` ; contrastes `info-text/info-soft` 5,49:1, `text-muted/bg` 4,55:1 ; icône + texte ; `document.title` = « Session expirée – FlexiPay ». L'**avertissement préalable (N.9)** satisfait WCAG 2.2.1.

## 10. Responsive
Contenu centré verticalement ; sous `breakpoint.md` le bouton est en pleine largeur ancré en bas (barre d'action collante, N.2/UX-18) ; ≥ `breakpoint.md` il garde la largeur de son contenu.

## 11. Sécurité (points pour `securite`)
`returnTo` : chemin relatif interne validé côté client, liste blanche exacte de routes, décodage unique, rejets et liste blanche de paramètres par route listés au §3.1 (WD1-S02, N-07) pour éviter la redirection ouverte ; aucun jeton dans l'URL ; le contenu de l'écran précédent est retiré du DOM et de la mémoire de l'interface ; les champs sensibles (mots de passe, codes, RIB) sont vidés ; la cause d'une déconnexion n'est jamais révélée ; l'écran est servi avec `Cache-Control: no-store`.

## 12. Questions et décisions ouvertes
1. **En attente de décision de l'utilisateur** : conservation de la saisie à l'expiration ; fuseau d'affichage des dates (impact : N.9). ux N-07 : proposer à `securite` de restituer aussi la chaîne de requête des listes (filtres, jugés non sensibles par NC.1) — à trancher avec `securite`.
2. **[QUESTION] securite / backend** : durées d'inactivité et absolue, délai d'avertissement (CT-X-6) ; contenu et validation de `returnTo`.

# Spec design – Commun › Pages 404 et 500 (introuvable, erreur inattendue)
**Statut :** prête pour relecture (ux → conformite → securite) · **Tâche :** WD1 · **Auteur :** design · **Date :** 2026-10-11
**Routes :** page `not-found` (toute URL inconnue) et frontière d'erreur (`error` de segment et `global-error`) · **Rôles :** tous (avec ou sans session) · **Exigences couvertes :** charte §7 (erreur + réessayer), contrat §4 (`404 NOT_FOUND` sans distinction, `500 INTERNAL_ERROR`, `503`), `fondations-composants.md` C.8.3 et C.8.9, revue ux UX-12, UX-21.
**Dépend de :** `_socle-ecrans.md`, `fondations-composants.md` (`StateView`). `403` est traité par C.8.8 (pas une page distincte) ; `401` par `commun-session-expiree.md`.

## 1. Objectif
Dire clairement qu'une page est introuvable (404) ou qu'une erreur inattendue s'est produite (500), et proposer **une seule sortie** : retour à un endroit sûr (ou réessayer pour le 500).

## 2. Rôles et permissions
Sans objet : ces pages s'affichent pour tout visiteur. **Avec session**, elles restent **dans la coquille** (sidebar, en-tête) quand le segment est dans la coquille ; **sans session** ou si la coquille elle-même échoue, elles s'affichent **hors coquille** (logo + sélecteur de langue seulement).

## 3. Structure
### 3.1 Page 404
`StateView` `page` : pastille `SearchX` · `h1` « Introuvable » · message « Cette page ou cette ressource est introuvable. » · **action principale « Retour au tableau de bord »** (avec session : accueil de l'espace du rôle ; sans session : « Aller à la connexion », `/login`).
**Le texte ne distingue jamais** « la page n'existe pas » de « la ressource appartient à un autre tenant » ni de « vous n'y avez pas accès » (contrat : 404 dans tous les cas, anti-énumération). Une ressource introuvable **dans** une page (détail d'un employé inexistant) affiche le même état `inline` ou `page` (C.8.9).

### 3.2 Page 500
`StateView` `page` : pastille `CircleAlert` (`danger-soft` / `danger-text`) · `h1` « Une erreur est survenue » · message « Une erreur est survenue de notre côté. Réessayez dans un instant. Si le problème continue, contactez le support avec la référence. » (`common.state.error.hint`, ux N-09) · **action principale « Réessayer »** (relance le rendu du segment, `reset()`) · action secondaire `tertiary` « Retour au tableau de bord » · **référence** copiable « Référence : {requestId} » **uniquement si un identifiant existe** (réponse API en erreur : `Problem.requestId` ; erreur de rendu côté serveur : l'identifiant de corrélation d'erreur ; sinon la ligne est absente, jamais inventée) · `common.state.error.safeRetry` « Votre opération ne sera pas effectuée deux fois. » est **réservé aux erreurs inline qui suivent une écriture** (C.8.3), pas à cette page ; si l'erreur suit une écriture, l'action devient « Vérifier l'état de l'opération » (`common.state.slow.verify`, rejeu avec la même clé).

### 3.3 Variantes
`503 SERVICE_UNAVAILABLE` : message `errors.serviceUnavailable` + « Réessayer » après `Retry-After` (bouton désactivé avec compte à rebours si l'API le fournit) ; `429` : `errors.rateLimited` avec compte à rebours (C.8.3) ; erreur du chargement de la coquille (`GET /me`) : N.1 « Erreur ».

## 4. Composants et tokens
`StateView` `page` (C.8) : pastille `size.avatar-lg` ; titre `type-scale.title` ; message `type-scale.body-lg` `color.text-muted` ; référence `type-scale.caption` `color.text-muted` + `CopyField`/bouton « Copier » ; largeur max `size.toast-max-width` ; espacements `space.4` / `space.8` ; couleurs 404 : `color.border` / `color.neutral-text` ; 500 : `color.danger-soft` / `color.danger-text` ; `Button` `primary` et `tertiary` ; `LanguageSwitcher` (hors coquille).

## 5. Textes et clés i18n (FR de référence)
| Clé | FR |
|---|---|
| `common.state.notFound.title` | Introuvable |
| `errors.notFound` | Cette page ou cette ressource est introuvable. |
| `common.state.notFound.action` | Retour au tableau de bord |
| `common.state.error.title` | Une erreur est survenue |
| `errors.internal` | Une erreur est survenue de notre côté. Réessayez. |
| `common.button.retry` | Réessayer |
| `common.state.error.reference` | Référence : {requestId} |
| `common.state.error.copy` | Copier la référence |
| `common.state.error.hint` | Une erreur est survenue de notre côté. Réessayez dans un instant. Si le problème continue, contactez le support avec la référence. |
| `common.state.error.safeRetry` | Votre opération ne sera pas effectuée deux fois. (erreurs inline après écriture seulement) |
| `common.state.slow.verify` | Vérifier l'état de l'opération |
| `errors.serviceUnavailable` | Le service est momentanément indisponible. Réessayez dans quelques instants. |
| `auth.errors.goToLogin` | Aller à la connexion |
| `common.copy.done` | Copié |

## 6. États
| État | Rendu |
|---|---|
| 404 avec session | dans la coquille, action vers l'accueil de l'espace |
| 404 sans session | hors coquille, action « Aller à la connexion » |
| 500 / erreur de rendu | `StateView` `page` + Réessayer ; si Réessayer échoue de nouveau, le message reste, la référence change |
| 503 / 429 | variantes §3.3 |
| Hors connexion | **pas de page 500** : bandeau C.8.4 / écran « Pas de connexion » (N.7) ; une panne réseau n'est pas une erreur applicative |
| Chargement / vide / solde insuffisant | sans objet |
| Session expirée | N.6 (une réponse `401` ne donne jamais une page 500) |
| Permission refusée | C.8.8 (autre état) |
**Aucun détail technique** : pas de trace de pile, de message SQL, de nom de fichier ni de chemin interne, même en développement dans l'interface (les détails vont à la console de développement uniquement, jamais en production).

## 7. Données et contrat
| Élément | Source | Statut |
|---|---|---|
| Code et message | `Problem.code`, `Problem.messageKey` (`errors.notFound`, `errors.internal`, `errors.serviceUnavailable`) | **E** |
| Référence | `Problem.requestId` / en-tête `X-Request-Id` | **E** |
| Délai de réessai | en-tête `Retry-After`, `RetryAfterDetails.retryAfterSeconds` | **E** |
| Rôle pour l'action de retour | `GET /v1/me` `Me.role` (CT-C-8) ; absent → connexion | **N** |

## 8. RTL
Colonne centrée symétrique ; référence en bloc LTR isolé (identifiant UUID) ; boutons empilés, aucune flèche ; sélecteur de langue à `end`.

## 9. Accessibilité
Le focus va au `h1` (`tabindex="-1"`) à l'affichage ; `role="alert"` seulement pour le 500 (le 404 n'est pas une urgence) ; l'action principale est la première action dans l'ordre de focus ; la référence est copiable au clavier avec confirmation annoncée (« Copié ») ; contrastes `danger-text/danger-soft` 5,30:1, `neutral-text/border` 6,15:1 ; icône + texte ; `document.title` = « Introuvable – FlexiPay » / « Erreur – FlexiPay ».

## 10. Responsive
Centré verticalement ; sous `breakpoint.sm` actions en pleine largeur, principale en premier ; marge `space.4` (mobile) / `space.8` (bureau).

## 11. Sécurité (points pour `securite`)
Aucune fuite d'information (pile, SQL, noms de tables, chemins) ; le 404 est identique pour « inexistant », « autre tenant » et « non autorisé » côté ressource ; la référence n'est qu'un identifiant de corrélation (UUID) sans donnée personnelle ; la frontière d'erreur n'envoie aucune donnée de l'écran (montants, noms) à un service d'observabilité sans masquage ; le message ne contient jamais l'URL demandée.

## 12. Questions et décisions ouvertes
Aucune décision métier. **[QUESTION] backend** : l'identifiant de corrélation des erreurs de rendu côté serveur Next.js (référence) — à aligner avec `X-Request-Id` si possible.

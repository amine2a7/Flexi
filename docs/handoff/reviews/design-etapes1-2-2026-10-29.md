# Revue de fidélité design – étapes 1 et 2 (branche feat/web) – 2026-10-29
Méthode : lecture du code, pas de navigateur. Périmètre : `component-library.tsx`, `reason-dialog.tsx`, `status-badge.tsx` (UserStatusBadge), `admin/utilisateurs/[userId]/page.tsx`, contre `dev-composants.md` §2-§4 et `commun-statut-utilisateur.md` §3.1-§3.4 + table `status`.
Écarts assumés non repris : « Forcer un état », liste générée des tokens utilisés.

**Verdict : [CONSTAT]** – 3 Hautes, 9 Moyennes, 5 Mineures. Aucune couleur, aucun espacement ni rayon en dur trouvé (classes de tokens uniquement ; `maxWidth` lu du preset) ; table `status` conforme à la spec §3.1 (icônes, fonds, textes, clé `DESACTIVE_GRACE` avec `{date}`).

## Hautes
- **H1** `page.tsx:149-157` – la désactivation d'un employé n'affiche pas `common.reason.deactivateEmployee.family` (« Les membres de sa famille seront désactivés avec lui. »), exigée mot pour mot par §3.4. Correction : l'ajouter dans `deactivateWarnings` (employé) entre `grace` et `irreversible`, avant `noCredit` selon l'ordre de §3.4.
- **H2** `component-library.tsx:313-321` – `KNOWN_STATUSES` est la liste des clés API (`API_TO_TOKEN`), pas la table `status`. `ACTIF`, `INVITE`, `DESACTIVE`, `DESACTIVE_GRACE` ne sont jamais montrés (et d'autres jetons restent inatteignables). Spec §4 : « les 27 entrées générées depuis le preset ». Correction : itérer sur `Object.keys(STATUS)` avec rendu direct par jeton ; ajouter `UserStatusBadge` (grâce futur, grâce échu, `INVITED`, `DEACTIVATED`).
- **H3** `component-library.tsx:467-516` – `ReasonDialog` et `UserStatusBadge` ne sont pas dans la bibliothèque (règle : aucun composant sans entrée dans `/dev/composants`). Correction : ajouter une section « Confirmation avec motif » (variantes suspendre, réactiver, désactiver employé avec bloc `warning`, `blockedReason`, erreur API) et les badges ci-dessus.

## Moyennes
- **M1** `reason-dialog.tsx:78-84` – `aria-describedby` de la modale = ligne de conséquence (spec §9) non fourni : `Modal` n'est appelé sans `description`. Correction : passer l'id/texte de la première conséquence.
- **M2** `reason-dialog.tsx:115-119` – conséquences en `<p>` sans icône ; §3.2.3 : icône + texte (`Info` / `TriangleAlert`). Correction : icône `size.icon-md` `aria-hidden`.
- **M3** `reason-dialog.tsx:134` – le compteur est concaténé dans l'aide : pas de région `status` polie (palier `UI.counterAnnounceStep`), pas de bloc LTR isolé en RTL (§8-§9). Correction : élément séparé `<span dir="ltr">` + région `role="status"`.
- **M4** `reason-dialog.tsx:144-146` – erreur API sans « Réessayer » ni référence `common.state.error.supportRef` (§6) ; un 422 sur `reason` devrait aller sous le champ (§3.2.7), pas dans une `Alert` générale.
- **M5** `reason-dialog.tsx:86-110` – sous `sm`, l'ordre DOM met « Annuler » avant le bouton destructif ; §10 demande le bouton principal en premier dans la pile. Le bouton désactivé : vérifier `aria-disabled` (focusable) plutôt que `disabled`, pour que la raison soit lue (§9).
- **M6** `page.tsx:163` – réactivation d'un employé : `common.reason.reactivateEmployee.effect` (« Seuls les membres de la famille suspendus avec lui seront réactivés. ») absent (§3.3).
- **M7** `page.tsx:127` – succès par toast de 4 s ; §6 exige un bandeau/`ResultView` persistant (« Compte suspendu. ») et le retour du focus au déclencheur ou au `h1`.
- **M8** `page.tsx:132-147` – « Renvoyer l'invitation » part sans motif ni modale ; §3.1 : motif requis.
- **M9** `status-badge.tsx:188-200` – la variante grâce ne lit pas la date en toutes lettres (« …jusqu'au 21 novembre 2026 », §9) ; ajouter un texte masqué / `aria-label` via `formatCalendarDate` long. Badges secondaires cascade (`cascade`, `cascadeDeactivated`, §3.1) non fournis par le composant : à confirmer côté écran Employés.

## Mineures
- **m1** `component-library.tsx:170-183` – liens de langue `px-3 py-2` sans `min-h-touch-target-min` (cible < 44 px, §3 / a11y).
- **m2** `component-library.tsx:242,396,205` – libellés `variant`, `tone` et `{size} %` en dur, hors i18n (§10 : « aucune chaîne en dur, même pour la page »). Idem `'25/10/2026 · Leïla M.'` (l.533+) non formatés par locale.
- **m3** `page.tsx:308-316` – flèche « → » en texte (non mise en miroir en RTL, §8) ; le changement de rôle devrait utiliser `ChangeDiff` ; repli « — » sans `common.amount.unavailable`.
- **m4** `page.tsx:236,244-252` – la valeur de repli du sélecteur est le rôle actuel (confusion avec une valeur choisie) et le bouton est désactivé sans raison écrite.
- **m5** `component-library.tsx:47,240-267` – variantes `link`, icône seule, pleine largeur absentes ; nommage `ghost`/`success` vs `tertiary`/`accent` de la spec : aligner ou noter l'équivalence. Sections Fondations (§6), Icônes (§7) et pied (version des tokens) absentes ; sommaire mobile en liste et non en menu déroulant.

## Points conformes
Logiques `start/end` et `rtl:-scale-x-100` sur la flèche de retour ; icônes `aria-hidden` + texte (jamais la couleur seule) ; focus initial sur le champ Motif ; fermeture bloquée pendant l'envoi ; bouton désactivé tant que motif < 10 avec raison écrite et `aria-describedby` ; bornes 10-500 ; ligne « irréversible » toujours présente ; blocage `graceUnavailable` ; action absente (jamais grisée) pour sa propre fiche.

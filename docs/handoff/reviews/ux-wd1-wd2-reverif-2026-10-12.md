# Revue UX – Revérification de WD2 et WD1 (aller-retour n° 1)

**Relecteur :** ux · **Date :** 2026-10-12 · **Déclencheur :** `[CORRIGÉ]` de design sur `ux-wd1-wd2-2026-10-12.md` (R-01 à R-04, N-01 à N-10).
**Base :** `docs/design/specs/` (branche `feat/web`, non commité) : `fondations-composants.md`, `navigation.md`, `dev-composants.md`, `_socle-ecrans.md`, `_besoins-contrat.md`, `commun-connexion.md`, `commun-premiere-connexion.md` (réécrit), `commun-mfa.md`, `commun-session-expiree.md`, `commun-mot-de-passe-oublie.md`, `commun-erreurs.md`. Échanges avec securite sur N-02 pris en compte.

## Verdict : OK pour WD2 et WD1 (0 Bloquant, 0 Important ouvert)

Les 14 constats sont fermés. Trois points restent en attente de décisions ou de réponses d'autres agents ; ce ne sont pas des écarts. J'ajoute 2 constats Amélioration sur l'étape « codes de secours » ajoutée depuis la revue précédente (N-11, N-12).

| Constat | Vérification (fichier:ligne) | État |
|---|---|---|
| R-01 matrice C.9 | fondations-composants.md:434 « Bandeau persistant dans la zone de l'action + Actualiser (C.8.10) » | **Fermé** |
| R-02 compteur sur toutes les listes | _socle-ecrans.md:46 ; dev-composants.md:90 et :232 (contrat 0.2.0 §7) | **Fermé** |
| R-03 action principale jamais en icône | navigation.md:148 (« conservée avec son texte… jamais réduite à une icône ») | **Fermé** |
| R-04 ordre DOM = ordre visuel dans la modale | dev-composants.md:116 | **Fermé** |
| N-01 œil après son champ | commun-premiere-connexion.md §9 ; dev-composants.md:176 (`showNamed` / `hideNamed`) | **Fermé** |
| N-02 mot de passe temporaire non redemandé | commun-premiere-connexion.md §2, §3.5, §6, §7, §11 : champ retiré en session restreinte, échéance `restrictedUntil` affichée, avertissement N.9 en variante absolue, retour sur `/login` avec un bandeau déduit de l'état en mémoire (conditions de securite respectées) ; commun-connexion.md:66 | **Fermé** (contrat 0.2.0 à modifier par backend : `currentPassword` encore exigé, `restrictedUntil` à ajouter ; je le revérifierai sur l'écran réel) |
| N-03 message d'identifiants utile | commun-connexion.md:50 et fondations C.9 « Identifiant ou mot de passe incorrect… « Mot de passe oublié ? » » ; aide statique `auth.login.hint.expired` (:41, :17) | **Fermé** |
| N-04 étape « Installer » expliquée | commun-mfa.md:20 et :50 ; « Retour » à chaque étape (:19) | **Fermé** (exemples d'applications et lien d'aide : en attente de main et securite, pas un écart) |
| N-05 OTP sans espaces | dev-composants.md:174 (espaces et tirets retirés) ; commun-mfa.md:35 et :39 | **Fermé** |
| N-06 annonce des étapes, confirmation finale | toast `auth.mfa.enroll.done` (commun-mfa.md:24) ; annonce « 2 étapes » soumise à une question à backend (commun-premiere-connexion.md §12.4) | **Fermé** (l'annonce dépend de backend) |
| N-07 note de retour honnête | commun-session-expiree.md:34 ; chaîne de requête des listes proposée à securite (:68) | **Fermé** (restitution des filtres : en attente de securite) |
| N-08 aide après « Mot de passe oublié » | commun-mot-de-passe-oublie.md:31 et :32 | **Fermé** |
| N-09 page 500 | commun-erreurs.md:18, :37 à :39 | **Fermé** |
| N-10 avertissement multi-onglets | navigation.md:350 | **Fermé** |

## Nouveaux constats (étape 4 « Codes de secours », ajoutée par design)

[CONSTAT] N-11 Le défi MFA ne permet pas d'utiliser un code de secours
Gravité : Amélioration (deviendra Important dès que la décision sur les codes de secours sera rendue)
Écran : commun-mfa.md:16 (défi : champ code, « Vérifier », « Retour à la connexion ») contre :23 (l'enrôlement remet des codes de secours).
Problème : l'utilisateur reçoit des codes de secours à l'enrôlement, mais l'écran du défi ne propose aucun moyen de s'en servir.
Impact sur l'utilisateur : l'administrateur ou le commerçant qui a perdu son téléphone a conservé ses codes et ne sait pas où les saisir. Il reste bloqué, ce qui annule le bénéfice de l'étape 4.
Proposition concrète : dès que la décision est rendue, ajouter sur le défi un lien `tertiary` « Utiliser un code de secours ». Il bascule le champ en saisie d'un code de secours (format fourni par l'API) et affiche une aide sur le nombre de codes restants, si l'API le fournit. Ne rien figer avant la décision.
Référence : Nielsen n° 3 (contrôle et liberté) et n° 9 ; SEC-A4.

[CONSTAT] N-12 « Retour » à la première étape de l'enrôlement : destination non définie
Gravité : Amélioration
Écran : commun-mfa.md:20 (étape 1 *Installer* : « boutons Retour et Continuer »).
Problème : la première étape n'a pas d'étape précédente, et la spec ne dit pas où mène « Retour ».
Impact sur l'utilisateur : hésitation ; si le bouton ramène à `/login` sans déconnexion, la session restreinte reste ouverte sans que l'utilisateur le sache.
Proposition concrète : à l'étape 1, remplacer « Retour » par « Se déconnecter » (`tertiary`, même comportement que la première connexion), ou ne pas l'afficher.
Référence : Nielsen n° 3 et n° 4.

## Questions de suivi (pas des écarts)
- **main :** codes de secours (nombre, format, procédure de perte), exemples d'applications d'authentification (N-04), conservation de la saisie à l'expiration, libellé « À régler », fuseau des dates, politique de mot de passe, mécanisme de réinitialisation.
- **backend :** retrait de `currentPassword` en session restreinte et ajout de `restrictedUntil` (transmis par securite) ; indicateur d'enrôlement MFA à venir (N-06).
- **securite :** restitution de la chaîne de requête des listes après reconnexion (N-07) ; téléchargement et impression des codes de secours (étape 4).

## Non vérifié
- Aucun écran réel (WF1 et WF2 non codés).
- Contrat 0.2.0 : seuls les points cités ont été recoupés ; la modification demandée par securite (`currentPassword`, `restrictedUntil`) n'est pas encore publiée.

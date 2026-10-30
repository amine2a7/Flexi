# Revue design + UX, espace Commun, sur captures (2026-10-30)

Périmètre : captures `docs/design/captures/commun/` (9 écrans, FR/AR, desktop/mobile ; toutes consultées sauf quelques variantes mobile/AR des écrans simples jugées identiques à leur pendant vu). Panneau jaune de démonstration non signalé.

Verdict : **À REVOIR** (aucune Critique ; 2 Hautes, 5 Moyennes, 4 Basses).

## Constats

### Haute

1. **404 (404-fr-desktop)** : page nue, sans en-tête (logo, langue, aide), collée en haut (contenu à y=50 sur 800), sans icône ni illustration, titre « Introuvable » petit (`text-title`), pas de lien vers la connexion. Incohérent avec session-expirée et accès-refusé. Correction : réutiliser `AuthShell` (carte centrée + en-tête), icône (SearchX), `text-display` pour le titre. Fichier : `apps/web/src/app/[locale]/not-found.tsx`, `components/auth/auth-shell.tsx`.
2. **Accès refusé (acces-refuse-ar-mobile)** : l'en-tête est celui de l'espace connecté, avec un texte « مرحبًا، Salma B. » dont le point final est mal placé en RTL (nom latin dans une phrase arabe, absence d'isolation bidi). Sélecteur de langue au format différent de l'en-tête public (FR/ع/EN en pastille ; ordre inversé). Correction : envelopper le nom dans `<bdi>` ; mettre à part le point final du texte i18n. Fichier probable : `components/layout/space-layout.tsx`, `locale-switcher.tsx`.

### Moyenne

3. **Connexion (connexion-fr-desktop)** : le bouton « Se connecter » désactivé est gris-bleu (#8892A0 environ) avec texte blanc, contraste insuffisant (< 3:1) et état « désactivé » identique sur MFA, première connexion, mot de passe oublié. Correction : garder un bouton actif et valider à l'envoi, ou utiliser un token disabled (texte `text-muted` sur fond `surface-muted`). Fichier : `components/ui/button.tsx`.
4. **Hiérarchie des titres entre écrans** : « Connexion » (grand, y=109), « Session expirée » (titre moyen, carte centrée verticalement), MFA et première connexion (carte centrée verticalement, titres sur 2 lignes). La carte saute verticalement d'un écran à l'autre (haut sur connexion, milieu sur MFA/session). Correction : un seul alignement (haut avec marge fixe, `pt-space-*`). Fichier : `components/auth/auth-shell.tsx`.
5. **Connexion/MFA/etc. : l'en-tête auth diffère de l'accueil** : logo sans pastille verte ni icône (accueil : logo avec icône), pas de lien Aide dans l'accueil mobile, bouton « Se connecter » absent des écrans auth (normal) mais libellé « Aide » absent en mobile (icône seule, `aria-label` à vérifier). Correction : composant logo partagé. Fichiers : `components/public/public-shell.tsx`, `components/auth/auth-shell.tsx`.
6. **Mot de passe oublié/MFA (champs)** : les champs vides n'affichent aucun placeholder ni séparation visuelle de saisie du code ; MFA : champ large pour 6 chiffres, pas de segmentation ni `inputMode` visible. Correction : champ centré, `tracking` large, `font-mono` via token. Fichier : `components/auth/mfa-challenge-form.tsx`.
7. **Première connexion (premiere-connexion-fr-desktop)** : liste de critères, « Au plus 128 caractères » est cochée alors que le champ est vide (faux positif, signal de réussite trompeur). Le délai « jusqu'à 30 oct. 2026, 10:59 » (FR) contre « 2026/10/30 11:01 » (AR) : formats et heures divergents (10:59 vs 11:01 : captures prises à deux moments, mais le format de date AR n'est pas harmonisé avec FR). Correction : ne cocher qu'un critère évalué sur valeur non vide ; date formatée par un utilitaire unique avec chiffres occidentaux. Fichier : `components/auth/password-fields.tsx`, `first-login-form.tsx`.

### Basse

8. **Accueil (desktop)** : hero sans visuel, moitié droite vide (texte limité à ~540 px) ; sur fond bleu nuit, le surtitre vert (`emerald`, petit, majuscules) a un contraste limite (à mesurer, texte vert devrait être `emerald-text` sur fond clair, ici sur fond sombre le `emerald` est acceptable mais la taille est faible). Fichier : `app/[locale]/(public)/page.tsx`.
9. **Accueil mobile** : en-tête compact, cibles langue FR/ع/EN à vérifier (≥ 44 px), « ع » sans pastille, très petit (visuellement ~12 px) ; pastilles de catégories coupées sur 2 lignes sans espacement régulier. Fichier : `components/layout/locale-switcher.tsx`.
10. **Aide (aide-fr-desktop)** : 8 000 px de haut, capture vue en miniature ; vignettes d'écrans vides (rectangles blancs) pour les espaces Commerçant/Bénéficiaire/Admin, donc illustrations manquantes. Correction : ne pas afficher de cadre sans image, ou générer les captures. Fichier : `app/[locale]/(public)/aide/`, `components/public/help-topics.ts`.
11. **Accueil AR mobile** : les icônes de coche et la flèche du bouton « تسجيل الدخول » sont bien en miroir ; liste du select « اختر » : la flèche est à gauche (correct). Aucun défaut majeur ; seul point : le champ « Message » est une `textarea` d'une seule ligne (hauteur 44 px), trop petite pour 2 000 caractères. Correction : `rows={5}`. Fichier : `components/public/contact-form.tsx`.

## Points conformes

Boutons 44 px, rayons 12/16, carte blanche ombrée ; bouton vert du hero avec texte bleu nuit (conforme charte §2) ; RTL globalement correct (alignement à droite, miroir de l'en-tête, icônes info/coche à droite) ; textes FR/AR cohérents ; un seul bouton principal par écran sur session-expirée, MFA, mot de passe oublié.

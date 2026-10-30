# Revue groupée DESIGN + UX - espace Administrateur (captures) - 2026-10-30
Verdict : **À REVOIR** (aucun Critique ; 3 Hautes). Captures lues : docs/design/captures/admin/ (tableau-de-bord, commercants, commandes, securite FR desktop + AR mobile ; une variante des autres écrans). Fichiers sous apps/web/src = probables, non ouverts.

## Haute
1. **Entrées sans accès au détail** - commercants-fr-desktop, entreprises-fr-desktop : aucune action de ligne ni lien (KYC, virements ont « Ouvrir »). commandes-fr-desktop : colonne « À traiter » = badge sans bouton (mobile AR a un bouton). Correction : colonne « Ouvrir » uniforme (secondaire, `Ouvrir >`) sur toutes les listes ; le bouton plein uniquement pour la ligne « à traiter ». Fichiers : components/ui/data-table.tsx, app/[locale]/(admin)/*/page.
2. **Bidi cassé en AR mobile** - tableau-de-bord-ar-mobile (liste « Commandes à traiter ») : « 16:52 .2026/10/CMD-2026-6900 · 29 » (référence, date, heure mélangées). securite-ar-mobile/desktop : « 10:30 ،2026/10/28 » (virgule en tête, heure avant date). Correction : isoler chaque segment (`<bdi>`/dir=ltr) et séparer référence et date sur deux lignes ; formateur de date unique. Fichiers : lib/format (date), components/ui/data-table.tsx (carte mobile), carte commandes du tableau de bord.
3. **Chiffres incohérents** - tableau-de-bord-fr-desktop et reporting-fr-mobile : « Volume du jour 11 766,000 TND » mais la répartition « Paiements du mois » totalise 8 472,000 TND (47+18+10+24 = 99 %). Le libellé du reporting « Volume du jour » surmonte une ventilation mensuelle. Correction : même période pour total et ventilation, titres alignés ; vérifier les données mock/API. Fichiers : mocks, messages (reporting).

## Moyenne
4. **Carte « Flux des six derniers mois »** (tableau-de-bord-fr-desktop) : ~300 px de blanc (carte étirée à la hauteur de « Commandes à traiter »), graphique sans axe ni valeurs, octobre sans barre « Crédits » inexpliquée, légende noir/vert sans valeur. Correction : `items-start` ou hauteur auto, valeurs au survol ET tableau accessible, « 0,000 » affiché. Fichier : components/ui/bar-chart.tsx.
5. **Noms tronqués ambigus** : « Mahdia Pêch... » ×2, « La Marsa As... » (dashboard desktop, colonne étroite). Correction : 2 lignes sans troncature, référence sous le nom. Même fichier que 2.
6. **Cartes KPI isolées** (kyc, virements : une carte avec un chiffre, sans action ; commandes : cartes + bouton « Afficher ces commandes » hors carte). Trois traitements pour la même chose. Correction : un seul composant « filtre rapide » (chiffre cliquable dans la carte), ou supprimer et utiliser un chip de filtre. Fichier : components/ui/layout-blocks.tsx.
7. **Onglets incohérents** : validations = dans la carte ; securite = hors carte au-dessus. Correction : un seul emplacement (au-dessus de la carte). Fichier : layout-blocks.tsx.
8. **Sécurité** : statut (« Ouvert », ambre + bouclier) et gravité (« Moyenne », ambre + bouclier) ont couleur et icône identiques (securite-ar-mobile). Correction : icônes distinctes (statut : cercle/horloge ; gravité : drapeau/niveau) ; « N2 » du bandeau non expliqué : texte clair. Fichiers : components/ui/status-badge.tsx, messages.
9. **Paramétrage AR** (parametres-ar-desktop) : badges verts « مقفل » (verrouillé) lus comme une réussite ; en-têtes de colonnes décalés de leurs valeurs (« السقف اليومي », « الصلاحية ») ; carte « الأرصدة المنتهية » orpheline sur sa ligne. Correction : badge neutre pour « verrouillé » ; alignement des en-têtes sur la cellule (text-start/end numériques) ; grille 5 colonnes ou carte pleine largeur.
10. **Cartes mobiles non uniformes** : reporting-fr-mobile et reglements-fr-mobile ont encore des lignes « Mois »/« Date » comme simples libellés ; commercants-ar-mobile (20 cartes × 7 lignes, ~19 000 px) trop dense. Correction : champ clé en titre, 3-4 champs visibles, le reste replié ; action en pied. Fichier : components/ui/data-table.tsx.
11. **Commissions** : la charte exige historique et double validation visibles ; la page n'affiche que 4 profils, grand vide, bouton répété 4 fois avec en-tête de colonne identique. Correction : section « Historique », colonne d'action sans titre répété. Fichier : app/[locale]/(admin)/commissions.
12. **En-tête AR** : « .Amine K » (point déplacé) et salutation répétée (« Bonjour, Amine K. » + « Amine K. Compte actif ») en FR et AR. Correction : `<bdi>` autour du nom, retirer le doublon. Fichier : components/layout/space-layout.tsx.

## Basse
13. Plusieurs boutons pleins sombres par page (6 « Ouvrir » en KYC, 7 en virements) vs « un seul bouton principal » : passer en secondaire.
14. Colonnes montants vides sans tiret (commandes « Montant déclaré ») ; icône de tri avant l'en-tête sur les colonnes alignées à droite (« ⇅ BRUT ») - ajouter « - » et placer l'icône après le libellé. Fichier : data-table.tsx.
15. Heure « 18:34 » sur chaque « Créé le » (bruit) : date seule dans les listes.
16. Sidebar non pleine hauteur sur captures longues (blanc dessous) : vérifier `sticky top-0 h-screen`. Fichier : space-layout.tsx.
17. Surtitre « PILOTAGE DE LA PLATEFORME » répété sur tous les écrans : à supprimer ou à varier.
18. Barre de répartition (orange, violet, cyan, rose) très saturée par rapport à la charte (couleurs fonctionnelles réservées aux statuts) : confirmer que ce sont des tokens `credit-type`.

## Points conformes
Montants en gras + devise réduite, badges icône + texte, filtres/pagination identiques, en-tête et sidebar stables, miroir RTL (sidebar à droite, chevrons inversés), chiffres occidentaux, onglets et cibles lisibles.

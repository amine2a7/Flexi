# Animations FlexiPay (web + espace Bénéficiaire mobile)

Le design actuel ne change pas. On ajoute seulement les animations ci-dessous.
Démo jouable de chaque animation : page « Animations FlexiPay » (lien fourni par Amine).

## Règles
- Chaque animation a une raison : confirmer une action, montrer un changement d'état, guider le regard.
- Moins de 320 ms, sauf compteur et succès de paiement (600 ms).
- Une action d'argent n'attend jamais une animation.
- Animer uniquement `transform` et `opacity` (sauf couleur des badges).
- RTL : les mouvements horizontaux sont inversés (toast depuis la gauche, etc.).
- `prefers-reduced-motion: reduce` : aucun déplacement ni rebond. Les fondus et changements de couleur restent.
- La barre latérale et l'en-tête ne bougent jamais entre deux pages.

## Jetons à ajouter dans design-tokens.json (groupe `motion`)
| Jeton | Valeur | Usage |
|---|---|---|
| duration.fast | 120 ms | pression, survol, icône |
| duration.base | 200 ms | modale, champ, badge |
| duration.slow | 320 ms | page, toast, panneau |
| duration.emphasis | 600 ms | compteur, succès de paiement |
| easing.out | cubic-bezier(.2,0,0,1) | tout ce qui entre |
| easing.in | cubic-bezier(.4,0,1,1) | tout ce qui sort |
| easing.spring | cubic-bezier(.34,1.56,.64,1) | succès, compteur, copie |

## Les 16 animations
| # | Animation | Où | Détail |
|---|---|---|---|
| 1 | Entrée de page en cascade | toutes les pages | titre puis cartes : opacité 0→1, translateY 8px→0, 320 ms, décalage 40 ms |
| 2 | Compteur de montant | KPI principal des tableaux de bord | 0 → valeur en 600 ms, décélération, chiffres tabulaires ; seulement au 1er affichage |
| 3 | Soldes par type de crédit | Entreprise, Bénéficiaire | barres 0 → % en 700 ms, décalage 80 ms, couleur du type |
| 4 | Squelette de chargement | listes, tableaux, KPI | formes grises + reflet 1,2 s ; contenu en fondu 200 ms ; même mise en page (pas de saut) |
| 5 | Toast | après chaque action | glisse depuis le bord 320 ms, barre de temps, visible 4 s ; `role="status"` |
| 6 | Modale de confirmation | toute action d'argent | voile en fondu, scale .96→1 en 200 ms ; fermeture 120 ms ; focus piégé puis rendu au bouton |
| 7 | Bouton : pression, attente, succès | Encaisser, Valider, Déclarer | scale .97 au clic ; indicateur sans changer la largeur ; vert + coche 1,6 s ; désactivé pendant l'attente |
| 8 | Copier le RIB | commande en attente de paiement | « Copier » → « ✓ Copié » (ressort 200 ms), retour après 1,5 s |
| 9 | Paiement accepté / refusé | résultat plein écran Commerçant et Bénéficiaire | accepté : cercle vert avec rebond + coche dessinée ; refusé : croix rouge + tremblement 360 ms + raison |
| 10 | Compte à rebours du QR | Bénéficiaire « Mon code » | anneau qui se vide sur 60 s, orange sur les 10 dernières secondes, puis « Expiré » + régénérer |
| 11 | Changement de statut | commandes, virements, KYC | badge : couleur 320 ms + pulsation ; trait d'historique qui se dessine vers l'étape suivante |
| 12 | Nouvelle ligne | listes Admin à traiter | fond vert pâle qui s'estompe en 1,6 s |
| 13 | Erreur de saisie | tous les formulaires | tremblement 360 ms, bordure rouge, message qui se déplie (200 ms) ; disparaît à la correction |
| 14 | Compteur « à traiter » | barre latérale | rebond 380 ms à chaque nouvel élément |
| 15 | Panneau du bas + onglets | Bénéficiaire (mobile) | panneau translateY 100%→0 en 320 ms ; indicateur d'onglet qui glisse |
| 16 | Visite guidée | première connexion | le projecteur glisse d'un élément à l'autre (320 ms), bulle qui suit |

## À ne pas faire
- Animer un montant à chaque rafraîchissement des données.
- Faire attendre l'utilisateur pour voir une animation.
- Animer la largeur, la hauteur ou la position (`top`, `left`) d'un élément.

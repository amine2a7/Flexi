# Référence design : vidéo de démo CrediFlow (13/10/2026)

Source : `DeM.mp4` (98 s, 1914×898), démo de la maquette CrediFlow, ancien nom de FlexiPay.
C'est **notre propre prototype** : on peut reprendre sa mise en page et son style à l'identique.
Les captures sont dans `captures/` (1600 px de large).

> **Règle de priorité.** Cette vidéo donne le **style** et la **disposition**. Les **règles métier** viennent de nos décisions, qui priment en cas d'écart (voir §6). Exemple : le circuit des commandes de crédits avec RIB et justificatif de virement remplace celui de la vidéo.

---

## 1. Style général

| Élément | Ce qu'on voit | Token FlexiPay à utiliser |
|---|---|---|
| Barre latérale | Bleu nuit très foncé (≈ `#0B1C2F`), texte gris clair, item actif sur fond légèrement plus clair et arrondi | `navy` (`#0B1D33`) |
| Accent | Vert vif (≈ `#11ED90`) : logo éclair, compteurs de la barre latérale, sur-titres, badges « Actif / Payée » | couleur d'accent / succès des tokens |
| Fond de page | Gris très clair, presque blanc | fond neutre |
| Cartes | Blanches, bordure fine grise, coins arrondis (≈ 12 px), sans ombre forte | `surface` + `border` + rayon `lg` |
| Bouton principal | Bleu nuit plein, texte blanc, petit et compact | `bg-navy text-on-navy` |
| Bouton secondaire | Blanc avec bordure | variante `secondary` |
| Typographie | Sans-serif (type Inter), titres de page ≈ 24 px semi-gras, texte 13–14 px | échelle `title-*` / `body-*` |
| Montants | `217 800,000 TND` : espace pour les milliers, virgule, 3 décimales | composant `Montant` |
| Notifications | Toast en haut à droite : vert (succès) ou bleu (info) | composant `Toast` |
| Modales | Petite fenêtre centrée, fond flouté, boutons « Annuler » + action principale | composant `Modal` |

## 2. Structure commune de tous les écrans

```
┌──────────────┬──────────────────────────────────────────────────────────┐
│ ⚡ CrediFlow  │ Bonjour, <nom>                       [badge rôle] <nom>  │
│ PLATEFORME   │ Espace sécurisé · …                            Compte actif│
│ DIGITALE     ├──────────────────────────────────────────────────────────┤
│              │ SUR-TITRE VERT EN MAJUSCULES                              │
│ ESPACE <RÔLE>│ Titre de la page                          [Action princ.] │
│ ▣ Menu 1     │ Phrase d'explication grise                                │
│ ▣ Menu 2 (3) │                                                           │
│ ▣ …          │ [ Cartes KPI ×4 ]   ou   [ Liste / tableau dans carte ]   │
│              │                                                           │
│ ✕ Changer de │                                                           │
│   rôle       │                                                           │
└──────────────┴──────────────────────────────────────────────────────────┘
```

- **En-tête** : salutation + nom à gauche, badge vert du rôle + nom + « Compte actif » à droite.
- **En-tête de page** : sur-titre vert majuscule, titre, phrase d'aide, bouton d'action à droite.
- **Cartes KPI** (tableaux de bord) : libellé gris, icône dans un carré à droite, gros montant, petite ligne d'info en dessous.
- **Tableau de bord** : 4 KPI, puis un graphique « Flux des six derniers mois » (2/3) et une liste « Dernières opérations » (1/3).
- **Compteurs verts** dans la barre latérale pour ce qui attend une action (ex. « Demandes de crédit 3 »).
- **« Changer de rôle »** en bas de la barre latérale : **à garder seulement en développement**, remplacé en production par « Se déconnecter ».

## 3. Écrans par espace

### Accueil (démo)
![](captures/00-accueil-choix-role.png)
Choix du rôle en 4 cartes. Utile pour la démo et le développement, **pas en production** : en production, l'utilisateur passe par la connexion.

### Administrateur (« Pilotage de la plateforme »)
Menu : Vue d'ensemble · Comptes & KYC · Demandes de crédit (compteur) · Demandes de virement (compteur) · Transactions · Paramétrage.

| Écran | Capture | Contenu |
|---|---|---|
| Comptes & KYC | ![](captures/admin-01-comptes-kyc.png) | Liste des comptes (entreprise, employé, commerçant) avec statut ; « Créer un compte » ; Valider / Refuser |
| Demandes de crédit | ![](captures/admin-02-demandes-credit.png) | `#DEM-204 · Carthage Industries · Restauration · 25 000,000 TND · En attente` ; Valider / Refuser |
| Demandes de virement commerçants | ![](captures/admin-03-demandes-virement.png) | `VIR-042 · Restaurant Le Jasmin · Brut · Net · En attente` ; commission 2 % déduite |
| Transactions globales | ![](captures/admin-04-transactions.png) | Recherche + Filtrer ; tableau Partenaire / Catégorie (pastille) / Montant / Date / Statut |
| Paramétrage | ![](captures/admin-05-parametrage.png) | Commission (2,00 %), validité des crédits (12 mois), cycle de règlement (J+2) ; « Enregistrer les paramètres » |

### Entreprise (« Société acheteuse »)
Menu : Vue d'ensemble · Demander des crédits · Mes employés · Mes mandats · Suivi de consommation.

| Écran | Capture | Contenu |
|---|---|---|
| Vue d'ensemble | ![](captures/entreprise-01-vue-ensemble.png) | KPI : wallet disponible, crédit consommé (% du budget), employés, demandes en attente ; graphique ; dernières opérations |
| Nouvelle demande | ![](captures/entreprise-02-nouvelle-demande.png) | Modale : catégorie + montant → « Soumettre la demande » |
| Demander des crédits | ![](captures/entreprise-03-demander-credits.png) | 4 cartes par catégorie (Restauration, Habillement, Cadeaux, Carburant) avec solde et barre de couleur ; historique des demandes |
| Mes employés | ![](captures/entreprise-04-employes.png) | Tableau Employé / Département / Solde / Consommé / Statut ; « Attribuer du crédit » |
| Attribuer du crédit | ![](captures/entreprise-05-attribuer-credit.png) | Modale : catégorie, bénéficiaire, montant |
| Mes mandats | ![](captures/entreprise-06-mandats.png) | Crédits envoyés et plafonds de dépense, avec statut |
| Suivi de consommation | ![](captures/entreprise-07-suivi-consommation.png) | Recherche par employé ; tableau des dépenses |

### Employé (« Employé et famille »)
Menu : Vue d'ensemble · Appairage · Ma famille · Transférer du crédit · Payer · Historique.
*Dans FlexiPay, l'Employé est prévu sur l'app mobile. Ces écrans servent de référence pour l'app Flutter, pas pour le web.*

| Écran | Capture | Contenu |
|---|---|---|
| Vue d'ensemble | ![](captures/employe-01-vue-ensemble.png) | Crédit total, solde Restauration, comptes famille 2/5, achats du mois |
| Appairage | ![](captures/employe-02-appairage.png) | Code à 6 chiffres pour lier l'appareil |
| Ma famille | ![](captures/employe-03-famille.png) | Bandeau « Comptes rattachés 2/5 », cartes des membres ; « Ajouter un membre » |
| Transfert | ![](captures/employe-04-transfert.png) | Modale : catégorie, membre, montant, plafond par jour, valable jusqu'au |
| Payer | ![](captures/employe-05-payer.png) | Scanner le QR du commerçant ou saisir le code ; compte utilisé |
| Confirmer le paiement | ![](captures/employe-06-confirmer-paiement.png) | Modale de confirmation avant paiement |
| Historique | ![](captures/employe-07-historique.png) | Tableau des opérations |

### Commerçant (« Commerçant partenaire »)
Menu : Vue d'ensemble · Encaisser · Demander un virement · Mes virements · Transactions.

| Écran | Capture | Contenu |
|---|---|---|
| Vue d'ensemble | ![](captures/commercant-01-vue-ensemble.png) | KPI : ventes du jour, disponible à virer, virements en cours (prochain J+2), panier moyen |
| Encaisser | ![](captures/commercant-02-encaisser.png) | QR FlexiPay (valable 2 min) à gauche ; code manuel + montant + « Valider l'encaissement » ; mention « réglé à J+2, commission 2 % » |
| Nouvelle demande d'encaissement | ![](captures/commercant-03-nouvelle-demande.png) | Modale : catégorie + montant |
| Demander un virement | ![](captures/commercant-04-demander-virement.png) | 3 KPI : solde disponible → commission → **net à recevoir** (sur IBAN ••4821) ; bouton d'envoi |
| Mes virements | ![](captures/commercant-05-mes-virements.png) | Liste `VIR-042 · net · date · statut` |
| Transactions reçues | ![](captures/commercant-06-transactions.png) | Tableau des paiements reçus |

## 4. Parcours montrés dans la vidéo

1. **Admin** : valide / refuse un compte, une demande de crédit, un virement commerçant ; modifie le paramétrage.
2. **Entreprise** : demande des crédits par catégorie → attribue du crédit à un employé → suit la consommation.
3. **Employé** : appaire son appareil → ajoute un membre de famille → lui transfère du crédit → paie un commerçant par QR.
4. **Commerçant** : encaisse (QR ou code) → consulte le net à recevoir → demande un virement → suit ses virements.

## 5. Ce qui est bien et à reprendre

- La structure de page commune (en-tête, sur-titre, titre, phrase d'aide, action à droite) : très lisible.
- Les KPI en tête de chaque tableau de bord.
- Les compteurs verts dans la barre latérale pour ce qui attend une action.
- L'écran « Demander un virement » : solde → commission → net, très clair.
- L'écran « Encaisser » : QR et saisie manuelle côte à côte, avec rappel du délai et de la commission.
- Les catégories avec une couleur chacune (barre de progression).
- Les toasts de confirmation après chaque action.

## 6. Ce qu'il faut corriger ou faire mieux

**Erreurs de la maquette à ne pas reproduire**
1. **Boutons Valider / Refuser côté Entreprise** sur « Historique des demandes » : une entreprise ne valide pas ses propres demandes. Ces boutons n'existent que côté Admin.
2. **Valider / Refuser sur des éléments déjà traités** (comptes « Actif », demandes « Validée ») : les boutons ne doivent apparaître que si l'action est possible dans le statut actuel.
3. **Statuts écrits en texte** dans la ligne (`… · En attente`) : utiliser le composant **Badge de statut** (couleur + icône), identique partout.
4. **Lignes « numéro · texte · texte »** : remplacer par de vraies colonnes (référence, entreprise, catégorie, montant aligné à droite, statut, date) avec tri, filtre par statut et pagination.
5. **Graphique « Flux des six derniers mois » vide** : il doit afficher des données fictives, ou un état vide explicite.
6. **Jargon DB / IR / RB** : afficher « Entreprise », « Employé », « Commerçant ».
7. **Les lignes ne s'ouvrent pas** : chaque demande, virement et commande doit avoir une **page de détail** avec son historique.

**Règles métier FlexiPay qui remplacent la vidéo**
- **Commandes de crédits** : circuit complet (En attente de confirmation → En attente de paiement, avec RIB FlexiPay affiché et bouton « Copier » → l'entreprise déclare son virement avec référence, date, montant et justificatif → En attente de validation → Validée, ou rejet avec motif). La vidéo ne montre qu'un simple Valider / Refuser.
- **Toute action d'argent** passe par une modale de confirmation qui rappelle le montant et le bénéficiaire.
- **Avertissement** côté admin si le montant déclaré diffère du montant commandé.

**Améliorations UX**
- **Commerçant en mobile d'abord** (360 px) : gros bouton « Encaisser » sur le tableau de bord, zones tactiles de 48 px, résultat d'encaissement en plein écran (vert accepté / rouge refusé avec la raison).
- **Zone « À faire »** en haut de chaque tableau de bord (ex. « 2 commandes attendent votre virement »).
- **États vide, chargement (squelette) et erreur** (« Réessayer ») sur chaque liste.
- **Arabe RTL** : la barre latérale passe à droite, icônes directionnelles inversées.
- **Accessibilité** : contraste AA (le gris des phrases d'aide est un peu clair), focus visible, libellés sur tous les champs.
- **Boutons plus grands** : les boutons de la vidéo (≈ 28 px de haut) sont trop petits ; minimum 40 px sur ordinateur, 48 px sur mobile.

## 7. Questions ouvertes (à trancher par Amine)

- **Catégories de crédits** (Restauration, Habillement, Cadeaux, Carburant) : FlexiPay les garde-t-il, avec un solde par catégorie ?
- **Mandats** et **comptes famille** : dans le périmètre de la première version ?
- **Validité des crédits** (12 mois) et **cycle de règlement** (J+2) : valeurs à confirmer.

# Checklist design et handoff Figma

## Fichiers Figma
1. `00 Fondations` : couleurs, typo, espacements, rayons, ombres (variables liées aux tokens).
2. `01 Composants` : boutons, champs, badges, cartes (wallet, transaction, KPI), toasts, tableaux, modales, navigation, états vides.
3. `02 Mobile Employé` · `03 Mobile Commerçant` · `04 Web Administrateur` · `05 Web Entreprise` · `06 Web Commerçant`.
4. `07 RTL / Arabe` · `08 Prototypes` · `09 Assets`.

## Liste des écrans
**Mobile Employé :** splash, connexion, première connexion (mot de passe), PIN, biométrie, accueil, Payer (mon QR / scanner / saisie), confirmation PIN, succès, erreur solde insuffisant, historique, détail transaction + reçu, Où dépenser (carte + liste), famille (liste, ajout, détail), notifications, profil, paramètres, sessions actives.
**Mobile Commerçant :** accueil, encaisser (scan / code), validation client, succès, historique, **simulation de virement**, règlements (calendrier), profil.
**Web Administrateur :** tableau de bord, comptes (liste, détail), création société, création commerçant, KYC (modale), transactions, détail, alertes fraude, règlements/lots, litiges, **profils de commission**, paramétrage, audit, utilisateurs internes.
**Web Entreprise :** tableau de bord, commande (formulaire + récap), commandes/factures, employés (liste, ajout, import CSV avec aperçu), attribution, reporting, paramètres/utilisateurs.
**Web Commerçant :** tableau de bord, encaissement, historique, **demande de virement + simulation**, règlements/factures, mon commerce (PDV, caissiers).

## Règles de nommage (identiques au code)
Composants : `Button/Primary`, `Badge/Status/Valide`, `Card/Wallet`, `ListItem/Transaction`. Couleurs : noms des tokens. Pages : `Écran / Rôle / Nom`.

## Prototypes à tester avec de vrais utilisateurs
1. Paiement employé (accueil → QR → succès) avec 3 à 5 employés.
2. Encaissement commerçant avec 2 commerçants.
3. Demande de virement avec simulation de commission.
4. Création d'employés par CSV (RH).

## Livrables avant le développement
- [ ] Tokens exportés et validés
- [ ] Bibliothèque de composants complète avec états
- [ ] Écrans du MVP (Restauration) + états vides/erreur
- [ ] Écrans clés en RTL
- [ ] Prototypes testés et ajustés
- [ ] Assets : logo (clair/sombre), icône d'app, illustrations, captures stores
- [ ] Textes FR (et AR/EN si dans le MVP) validés

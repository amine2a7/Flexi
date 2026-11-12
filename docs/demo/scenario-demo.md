# Scénario de démonstration – espace web FlexiPay

Base locale reconstruite par le seed (`pnpm --filter @flexipay/api db:reset && pnpm --filter @flexipay/api db:seed`) : 32 entreprises, 51 commerçants, 304 paiements, 58 virements, 15 lots, grand livre rapproché.

**Lancer :** API `API_PORT=3198 WEB_ORIGINS=http://localhost:3101 pnpm --filter @flexipay/api dev` ; web (dans `apps/web`) `WEB_PORT=3101 NEXT_PUBLIC_API_BASE_URL=http://localhost:3198 node scripts/dev.mjs --real-api --webpack` ; ouvrir http://localhost:3101/fr.
**Comptes :** mot de passe `Test1234!`, code MFA `123456`. `admin@` (super-admin), `admin2@` (Finance), `operations@` (Opérations), `support@`, `entreprise@`, `commercant@`, tous en `@flexipay.test`.

## 1. Accueil et connexion (2 min)
Landing « carnet de tickets », puis connexion : bouton « Composter mon ticket », tampon « Composté ». Champs vides : bouton actif, erreur claire. Tester aussi en arabe (`/ar`).

## 2. Grille de commission (admin@, 4 min)
1. Administrateur › Entreprises › « Créer une entreprise » : étape 1 (informations), « Continuer ».
2. Étape 2, fenêtre « Commission » : taux par défaut 5 ; « Ajouter une tranche » 3 % de 15 000 à 18 000 TND ; montant d'exemple 16 000 → aperçu : commission 480,000, TVA 91,200, timbre 1,000, **total 16 572,200 TND**.
3. Ajouter une tranche qui chevauche (17 000) : message « Cette tranche chevauche une autre tranche ». Supprimer, « Créer l'entreprise ».
4. Ouvrir la fiche (nom dans la liste) : informations modifiables, historique (noms des champs, jamais les valeurs), « Changer la grille » en double validation.

## 3. Simulations (3 min)
- `entreprise@` › Commandes › Nouvelle commande : 1 000 TND → crédits, frais (taux de la tranche), TVA sur la commission, timbre fiscal, total en gras.
- `commercant@` › Virements : simuler 60 TND → commission, TVA, timbre (en débit), **net viré**. Paramètres : TVA 19 %, timbre 1 DT, seuil 50 TND (Administrateur › Paramètres).

## 4. Double validation (admin@ puis admin2@, 3 min)
- Fiche commerçant › « Changer le RIB » (TN + 22 chiffres) : la demande apparaît dans Validations avec le RIB masqué ; `admin@` ne peut pas l'approuver, `admin2@` oui ; l'historique affiche « RIB ».
- Règlements › un lot « À régler » › « Demander la libération du lot » (Finance) ; approbation par un autre administrateur → « Validé ». À sa date, le job l'envoie à la banque simulée ; retour : payé (« Payé », référence SIM-…). Un IBAN qui finit par 0000 est rejeté par la banque : virement contre-passé, e-mail simulé au commerçant (`apps/api/var/outbox`), bouton « Redemander » dans Virements.

## 5. Sécurité (operations@ puis admin2@, 3 min)
Transactions › « Ouvrir un litige » ; fiche du litige : note, « Accepter le litige » → en attente de la seconde validation ; `admin2@` (Finance) lit le dossier sans pouvoir agir et approuve dans Validations. Paiement déjà viré : commission et sa TVA annulées, reste en dette déduite au prochain règlement. Alertes de fraude, dont « Grille de commission manquante » et « Écart du grand livre ».

## 6. Factures (2 min)
`entreprise@` › Factures › « Télécharger » : PDF avec crédits, commission, TVA, timbre, total. `commercant@` › un virement › « Télécharger la facture de commission ».

## Points à savoir
- Les factures sont générées à la demande (pas de file asynchrone) ; police standard : pas de PDF en arabe.
- E-mails et SMS : simulés (fichiers dans `var/outbox`).

## Les 7 actes du scénario tracé (processus v2, ~25 min)

Base `pnpm demo:reset`. Mot de passe `Test1234!`, code MFA `123456`. Total attendu au grand livre : **16 581,000 TND**, aucune alerte « Écart du grand livre ».

1. **Création du client** (`admin@`) : Entreprises › « Créer une entreprise », forme juridique **PM MF**, grille 3 %. Fenêtre « Identifiants à transmettre » : e-mail + mot de passe temporaire, « Copier ». Sur la fiche : onglets Informations, Dossier KYC, Utilisateurs, Départements, Employés, Soldes, Commandes, Attributions et modèles, Factures ; « Générer un nouveau mot de passe ».
2. **Dossier KYC** : le client (identifiants de l'acte 1) › Compte › Mon dossier : déposer RNE, carte fiscale, CIN du gérant, RIB. `operations@` › KYC : ouvrir le dossier, « Demander une correction » sur une pièce, puis valider (jamais par l'admin qui a créé le client). Paramètres › « Pièces KYC demandées » : la liste est modifiable (double validation).
3. **Employés** (`entreprise@`, Groupe Carthage Services) : Équipe › Employés, filtres Département = Production, Poste ; « Changer de département / de poste » en masse.
4. **Commande** : Commandes › Nouvelle commande, Restauration 10 000 + Carburant 6 000 → devis figé **16 581,000** (commission 480, TVA 91,200, retenue 3 % 4,800, timbre 1, virement 4). `admin@` confirme ; `comptable@` déclare VIR-BIAT-778213 + justificatif (passe du premier coup) ; `sarra@flexipay.tn` valide 1/2, `nour@flexipay.tn` 2/2 → soldes crédités, facture.
5. **Attribution** (`entreprise@`) : Crédits › Attributions : Département Production, Poste Ouvrier, « Tout sélectionner », 150 TND de Restauration (+ Carburant si besoin), « Voir l'aperçu » (total, solde restant, manque en rouge), « Enregistrer comme modèle » « Tickets mensuels Production », Attribuer. Crédits › Modèles : « Relancer » ouvre l'aperçu avec les employés actuels.
6. **Repas** : `beneficiaire@` › Payer chez Restaurant Le Jasmin (code commerçant), PIN `1234`. Famille : Bénéficiaire › Ma famille › « Ajouter un membre » (Sami, enfant), « Transférer » 50 TND plafond 20 TND/jour, « Reprendre le crédit ».
7. **Virement de Karim** (`karim@lejasmin.tn`, PP CIN, grille 2 %) : Virements › demander 1 250,000 → net **1 214,500** (commission 25, TVA 4,750, retenue 3 %… voir facture, timbre 1, virement 4). `sarra@` › Virements : Accepter, puis « Enregistrer le paiement » VIR-FP-000231 → **Payé**. Administrateur › Sécurité : aucune alerte « Écart du grand livre ».

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

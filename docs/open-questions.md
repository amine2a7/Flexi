# Décisions à prendre

## Juridique et bancaire (bloquant avant la phase 7)
- [ ] Statut réglementaire : agrément BCT ou partenariat avec un établissement agréé ?
- [ ] Banque partenaire : comptes séquestre/paiement, API ou fichiers, sandbox ?
- [ ] Hébergement et résidence des données (INPDP)
- [ ] Marque FlexiPay/CrediFlow : vérification INNORPI, domaine, comptes stores
- [ ] CGU, politique de confidentialité, contrats entreprise et commerçant

## Métier
- [ ] **À valider par le juriste (droit du travail)** : employé désactivé, délai de grâce de 30 jours par défaut (paramétrable) pour dépenser le solde restant, puis compte fermé et solde traité comme crédits expirés (décision du 2026-10-22)
- [ ] Frais entreprise **ajoutés** à la commande (hypothèse retenue) ou déduits ?
- [ ] Membres famille : consomment le solde de l'employé (retenu) ou ont un solde propre ?
- [ ] Crédits expirés : perdus pour l'employé, remboursés, reportés ? Qui en bénéficie ?
- [ ] Règlement commerçant : demande libre, automatique J+2, ou les deux ?
- [ ] TVA sur les commissions et les frais
- [ ] Arrondi des commissions (proposition : arrondi au millime supérieur, minimum paramétrable)
- [ ] Nombre maximum de membres famille (défaut 4)
- [ ] Plafonds par défaut (jour 100 TND, mois 2 000 TND) à confirmer

## Technique
- [ ] Passerelle de paiement par carte (Konnect, Paymee, ClicToPay)
- [ ] Fournisseur SMS (local ou international)
- [ ] Mode sombre dans le MVP ?
- [ ] Langues dans le MVP : FR seul, ou FR + AR dès le début ?

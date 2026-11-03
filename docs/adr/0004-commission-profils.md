# ADR 0004 – Grilles de commission, TVA, timbre et prélèvement au virement
**Statut :** accepté (révisé le 2026-11-03 : les profils sont remplacés par des grilles)
**Décision :**
- Chaque entreprise et chaque commerçant a sa **grille de commission**, saisie à la création (étape 2, fenêtre « Commission ») et modifiable ensuite en double validation. Une ligne = taux (bps), montant min, montant max (millimes). Les tranches ne se chevauchent pas ; une ligne sans min ni max est le taux par défaut, obligatoire et unique.
- Entreprise : la tranche s'applique au montant de chaque commande ; total = montant + commission + TVA de la commission + timbre fiscal.
- Commerçant : la tranche s'applique au montant de chaque virement ; net = montant − commission − TVA de la commission − timbre.
- TVA (19 %), timbre (1 DT) et seuil minimum de virement (50 TND) sont des paramètres du super-admin. Arrondi au millime le plus proche ; la TVA porte sur la commission arrondie.
- Taux, TVA et timbre sont figés (snapshot) dans la commande et dans la demande de virement ; un changement de grille ne vaut que pour les demandes futures.
**Raisons :** flexibilité commerciale, conformité fiscale, transparence (simulation et facture détaillées), auditabilité.
**Conséquences :** tables de grilles avec historique ; écritures séparées au ledger (commission, TVA collectée, timbre) ; snapshot dans `orders` et `payout_requests` ; migration des anciens profils en grilles d'une ligne par défaut.

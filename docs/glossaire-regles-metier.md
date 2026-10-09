# Glossaire et règles métier chiffrées

## Unités
- Montants en **millimes** (entiers). 1 TND = 1 000 millimes. 45,000 TND = `45000`.
- Taux en **points de base (bps)**. 2 % = `200`. 1 % = `100`. 0,5 % = `50`.
- Commission = `round_half_up(montant × taux_bps / 10000)` (à confirmer, voir `open-questions.md`).
- **Fuseau des règles métier :** `Africa/Tunis` (plafonds jour/mois, J+2, expirations) ; horodatages API en UTC.
- **Formats d'affichage :** FR et AR `48 250,000 TND` (chiffres occidentaux) ; EN `48,250.000 TND`.

## Définitions
| Terme | Définition |
|---|---|
| Entreprise | Société cliente qui achète et attribue des crédits |
| Employé | Bénéficiaire, utilise l'app mobile |
| Membre famille | Compte lié à un employé, consomme son solde dans sa limite ; ne voit que le reste de **sa propre limite**, jamais le solde de l'employé |
| Commerçant | Partenaire qui encaisse et se fait régler |
| Wallet | Compte virtuel d'une entité (entreprise, employé, commerçant) |
| Lot de crédits | Montant avec date d'expiration, consommé en FEFO |
| Profil de commission | Taux paramétrable, rattaché à une entreprise ou à un commerçant |
| Créance | Paiements encaissés non encore réglés au commerçant |

## Exemples (jeu de tests de référence)
| # | Situation | Entrée | Résultat attendu |
|---|---|---|---|
| E1 | Commande entreprise, frais 1 % | 50 000 000 millimes | Total à payer 50 500 000 ; wallet crédité 50 000 000 ; produit frais 500 000 |
| E2 | Attribution | 200 000 à 250 employés | Wallet entreprise −50 000 000 ; chaque employé +200 000 |
| E3 | Paiement | 45 000 | Employé −45 000 ; commerçant +45 000 (brut) |
| E4 | Virement, profil 2 % | demande 45 000 | commission 900 ; net 44 100 |
| E5 | Virement, profil 1,5 % | demande 10 000 | commission 150 ; net 9 850 |
| E6 | Taux modifié après demande | profil passe à 3 % | la demande existante garde 2 % |
| E7 | Solde insuffisant | solde 30 000, paiement 45 000 | refus, manque 15 000, aucune écriture |
| E8 | Plafond jour 100 000 | déjà 80 000, paiement 30 000 | refus, reste disponible 20 000 |
| E9 | FEFO | lots A (exp. J+5, 50 000) et B (exp. J+30, 100 000), paiement 70 000 | A −50 000, B −20 000 |
| E10 | Lot expiré | lot A expiré | non consommable ; apparaît dans les rapports « expirés » |
| E11 | Rejeu | même `Idempotency-Key` | même résultat, aucune écriture supplémentaire |
| E12 | QR réutilisé | deuxième scan du même QR | refus |
| E13 | QR expiré | > 60 s | refus |
| E14 | Virement sous le seuil | seuil 50 000, demande 30 000 | refus |
| E15 | Litige | transaction en litige | exclue du lot de règlement |
| E16 | Famille | limite membre 20 000, paiement 25 000 | refus |
| E17 | Concurrence | 1 000 paiements de 1 000 sur un solde de 500 000 | exactement 500 acceptés, solde final 0 |

## Statuts
- **Compte :** EN_ATTENTE_KYC → VALIDE / REJETE → SUSPENDU
- **Commande :** CREEE → PAYEE → RAPPROCHEE → CREDITEE / ANNULEE
- **Paiement :** INITIE → CONFIRME (« Confirmé », API `CONFIRMED`) → REGLE / REFUSE / EN_LITIGE
- **Demande de virement :** DEMANDEE → CONTROLEE → ENVOYEE → EXECUTEE / REJETEE
- **Approbation :** EN_ATTENTE → APPROUVEE / REFUSEE (approbateur ≠ initiateur)

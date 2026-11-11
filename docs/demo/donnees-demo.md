# Données de démonstration

`pnpm demo` vide la base locale, applique les migrations, lance le seed démo (`apps/api/prisma/seed.ts`), puis démarre l'API et le web. `pnpm demo:reset` remet seulement les données.

Le seed part d'une base vide et crée **un exemple par situation**. Chaque montant passe par les vraies routes de l'API et par le grand livre. Le seed échoue si le grand livre n'est pas rapproché. Les références ci-dessous sont celles d'une base neuve.

**URL :** http://localhost:3101/fr

**Connexion :** mot de passe `Test1234!` pour tous les comptes, code MFA `123456`, PIN démo `1234`.

## Comptes (un par rôle et sous-rôle)

| Rôle                      | Compte                       | Nom                                      |
| ------------------------- | ---------------------------- | ---------------------------------------- |
| Super-admin               | `admin@flexipay.test`        | Amine K.                                 |
| Opérations                | `operations@flexipay.test`   | Sonia B.                                 |
| Finance                   | `admin2@flexipay.test`       | Hela R.                                  |
| Support                   | `support@flexipay.test`      | Karim T.                                 |
| Administrateur entreprise | `entreprise@flexipay.test`   | Leïla M. (Groupe Carthage Services)      |
| RH                        | `rh@flexipay.test`           | Nour H.                                  |
| Comptable                 | `comptable@flexipay.test`    | Walid S.                                 |
| Gérant                    | `commercant@flexipay.test`   | Sami B. (Restaurant Dar El Jeld)         |
| Caissier                  | `caissier@flexipay.test`     | Aya K. (Restaurant Dar El Jeld)          |
| Bénéficiaire              | `beneficiaire@flexipay.test` | Yasmine J.                               |
| Première connexion        | `premiere@flexipay.test`     | Rim A. (choix du mot de passe, puis MFA) |

Gérants des autres commerces, utilisés pour les virements : `zarzis@`, `agil@` et `kitab@` (tous en `@flexipay.test`).

### Scénario tracé (processus v2)

| Personne | Compte | Rôle |
| --- | --- | --- |
| Sarra F. | `sarra@flexipay.tn` | Finance (première validation, paiement des virements) |
| Nour F. | `nour@flexipay.tn` | Finance (seconde validation) |
| Karim L. | `karim@lejasmin.tn` | Gérant du Restaurant Le Jasmin (PP CIN, grille 2 %, Restauration) |
| 10 employés de Production | `prénom.nom@carthage.tn` (ex. `yasmine.bensalem@carthage.tn`) | Bénéficiaires, poste Ouvrier / Ouvrière |

Le Jasmin a 1 250,000 TND de ventes datées d'il y a 3 jours (10 repas de 125 TND) : Karim peut demander son virement (net annoncé 1 214,500 TND). Même mot de passe et même code MFA que les autres comptes de démo.

## Cas → où le trouver → compte

| Cas                                                                                          | Où le trouver                                                                                                                                                             | Compte                                                                   |
| -------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| **Entreprises**                                                                              |                                                                                                                                                                           |                                                                          |
| Entreprise active (3 départements)                                                           | Administrateur › Entreprises › Groupe Carthage Services ; Entreprise › Équipe › Départements (Direction, Ressources humaines, Logistique)                                 | `admin@`, `entreprise@`                                                  |
| Entreprise au KYC en attente                                                                 | Administrateur › Clients › Comptes et KYC › Société Sfax Industries                                                                                                       | `operations@`                                                            |
| Entreprise suspendue                                                                         | Administrateur › Entreprises › Sousse Logistique (statut Suspendu)                                                                                                        | `admin@`                                                                 |
| **Employés** (Entreprise › Équipe › Employés)                                                |                                                                                                                                                                           |                                                                          |
| Invité                                                                                       | Mehdi Trabelsi (EMP-1002)                                                                                                                                                 | `entreprise@`                                                            |
| Actif, soldes sur les 4 types                                                                | Yasmine Jaziri (EMP-1001) ; ses soldes : espace Bénéficiaire                                                                                                              | `entreprise@`, `beneficiaire@`                                           |
| Invitation expirée                                                                           | Sana Ben Ali (EMP-1003), badge « Invitation expirée »                                                                                                                     | `entreprise@`                                                            |
| Suspendu                                                                                     | Hichem Gharbi (EMP-1004)                                                                                                                                                  | `entreprise@`                                                            |
| **Commerçants** (Administrateur › Clients › Commerçants)                                     |                                                                                                                                                                           |                                                                          |
| Restauration                                                                                 | Restaurant Dar El Jeld (Tunis)                                                                                                                                            | `admin@`, `commercant@`                                                  |
| Habillement                                                                                  | Boutique Zarzis Mode (Djerba)                                                                                                                                             | `admin@`                                                                 |
| Carburant                                                                                    | Station Agil Lac 2 (Tunis)                                                                                                                                                | `admin@`                                                                 |
| Cadeaux                                                                                      | Librairie Al Kitab (Bizerte)                                                                                                                                              | `admin@`                                                                 |
| KYC en attente                                                                               | Pâtisserie Masmoudi (Sfax) ; Comptes et KYC                                                                                                                               | `operations@`                                                            |
| Grille à vérifier                                                                            | Café Sidi Bou Saïd, sans grille de commission : son premier paiement est refusé et lève l'alerte « Grille de commission manquante » (Administrateur › Pilotage › Alertes) | `admin@`, `operations@`                                                  |
| **Commandes** (Entreprise › Crédits › Commandes ; Administrateur › Opérations › Commandes)   |                                                                                                                                                                           |                                                                          |
| Attente de confirmation                                                                      | CMD-2026-7301                                                                                                                                                             | `entreprise@`, `admin2@`                                                 |
| Attente de paiement (devis valide, facture émise)                                            | CMD-2026-7302                                                                                                                                                             | `entreprise@`                                                            |
| Attente de validation                                                                        | CMD-2026-7303                                                                                                                                                             | `admin@`                                                                 |
| Validation 1/2 (au-delà du seuil de double validation)                                       | CMD-2026-7304 : 1re validation par Amine K., la seconde est à faire par `admin2@`                                                                                         | `admin2@`                                                                |
| Validée                                                                                      | CMD-2026-7300 (crédits sur les 4 types)                                                                                                                                   | `entreprise@`                                                            |
| Refusée                                                                                      | CMD-2026-7305 (motif affiché)                                                                                                                                             | `entreprise@`                                                            |
| Annulée                                                                                      | CMD-2026-7306                                                                                                                                                             | `entreprise@`                                                            |
| Justificatif rejeté                                                                          | CMD-2026-7307 (retour en attente de paiement, motif du rejet)                                                                                                             | `entreprise@`                                                            |
| Devis valide                                                                                 | CMD-2026-7302 (« Devis valable jusqu'au … »)                                                                                                                              | `entreprise@`                                                            |
| Devis expiré                                                                                 | CMD-2026-7309 (« Devis expiré » ; confirmation refusée)                                                                                                                   | `entreprise@`, `admin2@`                                                 |
| **Paiements**                                                                                |                                                                                                                                                                           |                                                                          |
| Accepté                                                                                      | PAY-9000, 80 TND au Restaurant Dar El Jeld                                                                                                                                | `commercant@` (Ventes › Transactions), `admin@` (Finance › Transactions) |
| Refusé (solde insuffisant)                                                                   | PAY-9006, 300 TND demandés par Boutique Zarzis Mode, refusé                                                                                                               | `admin@` (Transactions), `zarzis@`                                       |
| Annulé dans les 24 h                                                                         | PAY-9001, 25 TND, annulé par le Gérant (statut Remboursé)                                                                                                                 | `commercant@`                                                            |
| **Virements commerçants** (Administrateur › Opérations › Virements commerçants, Lots)        |                                                                                                                                                                           |                                                                          |
| En attente                                                                                   | VIR-2026-4104 (Restaurant Dar El Jeld)                                                                                                                                    | `admin2@`, `commercant@`                                                 |
| Dans un lot                                                                                  | VIR-2026-4103, lot LOT-2026-302 (À régler)                                                                                                                                | `admin2@`                                                                |
| Libéré                                                                                       | VIR-2026-4102, lot LOT-2026-301 (Validé, envoyé à la banque à sa date)                                                                                                    | `admin2@`                                                                |
| Rejeté par la banque puis redemandé                                                          | VIR-2026-4100 rejeté (IBAN finissant par 0000, lot LOT-2026-300), redemandé en VIR-2026-4101                                                                              | `admin2@`, `kitab@`                                                      |
| **Factures** (Entreprise › Finance › Factures)                                               |                                                                                                                                                                           |                                                                          |
| Facture émise                                                                                | FAC-2026-5401 (CMD-2026-7302, à payer)                                                                                                                                    | `entreprise@`, `comptable@`                                              |
| Avoir                                                                                        | FAC-2026-5405 annulée, avoir AV-2026-100 (CMD-2026-7308 annulée après confirmation)                                                                                       | `entreprise@`                                                            |
| **Messages de contact** (Administrateur › Support › Messages)                                |                                                                                                                                                                           |                                                                          |
| Nouveau                                                                                      | Olfa Mzoughi (Clinique El Manar)                                                                                                                                          | `support@`                                                               |
| Traité                                                                                       | Tarek Ben Salah, avec une note                                                                                                                                            | `support@`                                                               |
| **Demandes de changement en attente** (Administrateur › Opérations › Validations en attente) |                                                                                                                                                                           |                                                                          |
| Grille                                                                                       | Restaurant Dar El Jeld : 1,80 % puis 1,50 % au-delà de 1 000 TND (demandée par Hela R.)                                                                                   | `admin@` approuve                                                        |
| RIB                                                                                          | Boutique Zarzis Mode (demandé par Amine K.)                                                                                                                               | `admin2@` approuve                                                       |

## Jeu de données de volume

L'ancien gros jeu de données n'est plus chargé. Son générateur est dans `apps/api/prisma/volume/`, et on le lance à part, sur une base vide, pour les tests de performance :

```
pnpm --filter @flexipay/api db:reset
pnpm --filter @flexipay/api db:seed:volume
```

Il n'est jamais lancé automatiquement.

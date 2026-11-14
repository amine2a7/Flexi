# Données de démonstration

`pnpm demo` vide la base locale, applique les migrations, lance le seed démo (`apps/api/prisma/seed.ts`), puis démarre l'API et le web. `pnpm demo:reset` remet seulement les données.

Le seed (demande du 2026-11-14) crée **exactement** les comptes ci-dessous, rien d'autre : aucun employé, aucune commande, aucune transaction.

**URL :** http://localhost:3101/fr

**Connexion :** mot de passe `Flexi2026` pour tous les comptes, code MFA `123456`. Aucun changement de mot de passe n'est demandé à la première connexion.

Le mot de passe `Flexi2026` ne respecte pas la règle des 12 caractères. Cette règle ne s'applique qu'à un mot de passe choisi (changement, réinitialisation), jamais à la connexion.

## Comptes

| Espace     | Compte                     | Rôle         | Société   |
| ---------- | -------------------------- | ------------ | --------- |
| FlexiPay   | `superadmin@flexipay.test` | Super-admin  | FlexiPay  |
| FlexiPay   | `nizar@flexipay.test`      | Finance      | FlexiPay  |
| FlexiPay   | `ali@flexipay.test`        | Opérations   | FlexiPay  |
| FlexiPay   | `support@flexipay.test`    | Support      | FlexiPay  |
| Entreprise | `biat@flexipay.test`       | Propriétaire | BIAT      |
| Commerçant | `carrefour@flexipay.test`  | Propriétaire | Carrefour |

## Clients

| Client    | Type       | Forme juridique | Commission | Types acceptés                      | KYC    | Statut |
| --------- | ---------- | --------------- | ---------- | ----------------------------------- | ------ | ------ |
| BIAT      | Entreprise | PM MF           | 3 %        | —                                   | Validé | Active |
| Carrefour | Commerçant | PM MF           | 2 %        | Restauration, Habillement, Cadeaux  | Validé | Actif  |

Le dossier KYC validé de chaque client contient les cinq pièces : extrait du registre, attestation fiscale, CIN recto, CIN verso, RIB. Carrefour a un IBAN et le code de paiement `401001`.

Le fichier `docs/demo/comptes-demo.xlsx` reprend ces comptes. Il n'est pas commité (`.gitignore`).

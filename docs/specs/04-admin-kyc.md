# Spec 04 – Back-office Administrateur : comptes, KYC/KYB, supervision
**Phase 3 · Cahier :** ADM-01 à ADM-13

## 1. Objectif
Créer et valider les sociétés et commerçants, superviser les transactions, détecter la fraude, gérer le paramétrage.

## 2. Règles
- Statuts de compte : `EN_ATTENTE_KYC` → `VALIDE` / `REJETE` → `SUSPENDU`. Un commerçant non validé ne peut pas encaisser ; une société non validée ne peut pas commander.
- Dossier KYB : registre de commerce, matricule fiscal, RIB, pièce d'identité du représentant. Décision : valider, rejeter (motif), demander des compléments.
- Le RIB doit correspondre à la raison sociale ; tout changement de RIB redémarre un contrôle (double validation + notification).
- Alertes fraude : montant inhabituel, 3 transactions du même bénéficiaire en 5 min, nouvel appareil, changement de RIB.
- Paramétrage : validité par catégorie, plafonds (jour/mois), seuils (double validation, règlement minimum), cycle de règlement.
- Toute modification de paramètre sensible : double validation + audit.

## 3. Données
`companies`, `merchants`, `kyc_cases`, `kyc_documents` (chemin chiffré, empreinte, statut), `settings`, `fraud_alerts`, `approvals`, `audit_log`.

## 4. API (extraits)
`POST /admin/companies` · `POST /admin/merchants` · `GET /admin/accounts?type&status&q` · `POST /admin/kyc/{id}/decision` · `GET /admin/transactions` · `POST /admin/transactions/{id}/dispute` · `GET/PUT /admin/settings` · `GET /admin/audit`.

## 5. Sécurité
Accès réservé aux rôles ADMIN avec MFA ; séparation des rôles (support n'approuve pas les règlements) ; documents KYC servis par URL signées de 5 min, chaque accès journalisé.

## 6. Tests
Création avec profil obligatoire ; validation/rejet KYC ; commerçant non validé refusé à l'encaissement ; changement de RIB → approbation ; alerte déclenchée sur 3 transactions en 5 min ; rôle support ne peut pas modifier un taux.

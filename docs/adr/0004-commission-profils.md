# ADR 0004 – Profils de commission et prélèvement au virement
**Statut :** accepté
**Décision :** deux familles de profils (entreprise, commerçant), choisis dans une liste déroulante à la création du compte. La commission commerçant est prélevée à la demande de virement, avec simulation préalable et taux figé.
**Raisons :** transparence pour le commerçant, flexibilité commerciale, auditabilité.
**Conséquences :** table de profils avec historique et date d'effet ; snapshot du taux dans `payout_requests`.

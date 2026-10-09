# Feuille de route

Cocher chaque case avant de passer à la phase suivante. Commande utile : `/release-check <phase>`.

## Phase 0 – Fondations (1–2 sem.)
- [ ] Monorepo, CI, Docker Compose (Postgres, Redis), lint/format
- [ ] `CLAUDE.md`, agents, commandes, hooks fonctionnels
- [ ] Pipeline de génération des tokens (JSON → Tailwind + Flutter)
- [ ] Environnements dev et staging, « hello world » déployé
**Fin :** pipeline vert, déploiement staging automatique.

## Phase 1 – Socle sécurité (3 sem.) — spec `01-auth`
- [ ] Auth complète (Argon2id, JWT + refresh rotatif, MFA TOTP, mot de passe temporaire, PIN)
- [ ] RBAC, guard global, RLS, audit chaîné, rate limiting
- [ ] Modèle de menaces rédigé et relu
**Fin :** tests de sécurité d'authentification verts ; revue `securite` sans bloquant.

## Phase 2 – Ledger (3 sem.) — spec `02-ledger`
- [ ] Comptes, écritures immuables, triggers, idempotence, verrouillage
- [ ] Lots de crédits, FEFO, expiration
- [ ] Réconciliation interne
**Fin :** test de concurrence (1 000 paiements simultanés) sans écart ; `ledger-auditor` OK.

## Phase 3 – Back-office Administrateur (4 sem.) — specs `03`, `04`
- [ ] Profils de commission, paramétrage, double validation
- [ ] Création société/commerçant (liste déroulante du profil), KYC/KYB
- [ ] Supervision des transactions, alertes
**Fin :** création d'une société et d'un commerçant avec profil, validation KYC de bout en bout.

## Phase 4 – Espace Entreprise (4 sem.) — spec `05`
- [ ] Commande + frais, rapprochement, crédit du wallet
- [ ] Employés (manuel, CSV), mots de passe temporaires, attribution, reporting
**Fin :** commande → crédit → attribution de 250 employés par CSV.

## Phase 5 – App Employé Flutter (5 sem.) — spec `06`
- [ ] Première connexion, PIN, accueil, QR, paiement, historique, famille, notifications
**Fin :** parcours complet iOS et Android sur appareils réels.

## Phase 6 – Commerçant web + mobile (4 sem.) — spec `07`
- [ ] Encaissement, créances, simulation de commission, demande de virement
**Fin :** paiement → créance → virement simulé avec net correct.

## Phase 7 – Règlements et banque (3 sem.) — spec `08`
- [ ] Lots J+2, fichiers/API bancaires, rapprochement, litiges, factures
**Fin :** cycle bout en bout en sandbox bancaire.

## Phase 8 – Durcissement (3 sem.)
- [ ] Antifraude, attestation d'appareil, pinning, charge (k6), chaos, sauvegardes/restauration testées
- [ ] Checklists ASVS niveau 2 et MASVS complètes
**Fin :** aucune exigence de sécurité « Must » ouverte.

## Phase 9 – Pentest et pilote (4 sem.)
- [ ] Pentest externe, correctifs, pilote (1 entreprise, quelques commerçants)
**Fin :** zéro vulnérabilité critique ou haute ouverte.

## Phase 10 – Lancement
- [ ] Stores, formation, support, supervision 24/7 initiale, plan d'incident

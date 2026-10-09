# Checklist de livraison sécurité (ASVS niveau 2 / MASVS)
À cocher avant chaque jalon (`/release-check`). Détail des exigences : `exigences-securite.md`.

## Avant la phase 1 terminée
- [ ] SEC-A1 à A7, SEC-Z1 à Z5 implémentées et testées
- [ ] Modèle de menaces relu
- [ ] gitleaks, CodeQL/Semgrep et audit des dépendances actifs en CI

## Avant la phase 2 terminée
- [ ] SEC-P3, P4, P5, P6 testées (concurrence, rejeu)
- [ ] Triggers d'immuabilité vérifiés par test

## Avant la phase 8 terminée
- [ ] Toutes les exigences « Must » implémentées
- [ ] Tests de charge et de chaos réalisés
- [ ] Restauration de sauvegarde testée
- [ ] Attestation d'appareil et pinning actifs en release
- [ ] Revue manuelle des endpoints : rôle + tenant pour chacun

## Avant le lancement
- [ ] Pentest externe réalisé, aucune vulnérabilité critique/haute ouverte
- [ ] Plan d'incident et contacts d'astreinte
- [ ] Politique de confidentialité et CGU publiées
- [ ] Déclaration INPDP / autorisations réglementaires obtenues
- [ ] Programme de signalement de vulnérabilités (security.txt)

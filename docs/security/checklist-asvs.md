# Checklist de livraison sécurité (ASVS niveau 2 / MASVS)
À cocher avant chaque jalon (`/release-check`). Détail des exigences : `exigences-securite.md`.

## Phase 0 – Fondations : points ASVS / MASVS concernés (état au 2026-10-09)
Références : OWASP ASVS **4.0.3** (identifiants `Vx.y.z`) et OWASP MASVS **v2** — la version de référence est à confirmer par le lead (voir rapport P0-S5). Menaces associées : `modele-de-menaces.md` §3.
États : **À faire** (rien n'existe) · **En attente d'outils** (pnpm/Docker/Flutter indisponibles sur ce poste) · **Partiel** (existe, constaté incomplet) · **Non vérifié** (impossible à vérifier d'ici). **Aucun point n'est « vérifié » à ce jour.**

### ASVS (API, web, chaîne de build)
| Réf. | Exigence (résumé) | SEC | Tâche | État | Commentaire |
|---|---|---|---|---|---|
| V1.1.1 | Cycle de développement sécurisé | SEC-S1, S5 | toutes | Partiel | Protocole d'équipe, hooks, revues ; CI absente |
| V1.1.2 | Modélisation des menaces à chaque changement de conception | — | P0-S5 | Partiel | `modele-de-menaces.md` v2 ; à relire en phase 1 |
| V1.14.6 / V14.2.1 | Composants à jour, audit des dépendances au build | SEC-S1 | B1, B6 | À faire | `pnpm audit --prod`, OSV pub.dev (SC-10) |
| V14.2.4 | Composants tiers issus de dépôts de confiance | — | B1, B4, B6 | À faire | Registre unique, `workspace:*`, images et actions épinglées (SC-2, SC-7, SC-8) |
| V14.2.5 | Inventaire des composants (SBOM) | SEC-S3 | B6 | À faire | CycloneDX (Should) |
| V14.1.1 / V14.1.4 | Build et déploiement automatisés, reproductibles | — | B1, B6 | En attente d'outils | Lockfiles gelés, CI ; déploiement hors phase 0 |
| V14.1.5 | Intégrité vérifiable de la configuration sensible | — | lead, B6 | Partiel | Hooks présents mais contournables (CF-01 à CF-05) ; `CODEOWNERS` à créer |
| V10.3.2 | Protection de l'intégrité du code (signature) | — | lead | Partiel | Commits non signés (CF-08) |
| V6.4.1 | Secrets gérés par une solution dédiée, jamais dans le code | SEC-S2 | B4, B6 | Partiel | `.gitignore` OK ; gitleaks inactif localement (CF-02), absent en CI ; motifs mobiles manquants (CF-06) |
| V14.3.2 | Modes debug désactivés hors dev | — | B3 | En attente d'outils | Config validée par Zod |
| V14.3.3 | En-têtes sans version de serveur/framework | SEC-W3 | B3 | En attente d'outils | `X-Powered-By` retiré (helmet) |
| V14.4.1 à V14.4.7 | En-têtes : Content-Type+charset, nosniff, HSTS, CSP, Referrer-Policy, frame-ancestors | SEC-W3, D1 | B3, B5, F3 | À faire | Contrat B5 (revue P0-S6), puis implémentation |
| V14.5.1 / V14.5.3 | Méthodes HTTP limitées ; CORS sur liste blanche | SEC-W4 | B3, B5 | À faire | Revue P0-S6 |
| V4.1.1 / V4.1.3 / V4.1.5 | Contrôle d'accès côté serveur, moindre privilège, échec fermé | SEC-Z1 | B3, B5 | À faire | Guard global + `@Public()` ; sécurité par défaut dans le contrat |
| V4.2.1 | Protection IDOR | SEC-Z4 | B5 | À faire | Contrat : tenant tiré de la session (P0-S6) |
| V3.4.1 à V3.4.5 | Attributs des cookies (Secure, HttpOnly, SameSite, préfixe `__Host-`, Path) | SEC-A7 | B5, F3 | À faire | Revue P0-S6 |
| V4.2.2 / V13.2.3 | Protection CSRF des API à cookie | SEC-A7 | B5, F3 | À faire | Revue P0-S6 |
| V7.1.1 / V7.1.2 | Aucune donnée sensible dans les logs | SEC-D4 | B3 | En attente d'outils | Logger avec masquage |
| V7.4.1 | Erreurs génériques avec identifiant de corrélation | SEC-W5 | B5, B3 | À faire | Revue P0-S6 |
| V8.3.1 | Données sensibles dans le corps ou les en-têtes, jamais dans l'URL | — | B5 | À faire | Revue P0-S6 |
| V13.1.3 / V13.1.5 / V13.2.2 / V13.2.5 | API : pas de secret dans l'URL, Content-Type contrôlé, validation par schéma | SEC-W1 | B5, B3 | À faire | Revue P0-S6 |
| V11.1.4 / V2.2.1 | Anti-automatisation, rate limiting | SEC-W2 | B3, B5 | À faire | Rate limiting de base (B3), en-têtes `RateLimit`/`Retry-After` au contrat |
| V5.1.1 à V5.1.4 | Validation des entrées par schéma, liste blanche | SEC-W1 | B2, B5 | À faire | Schémas Zod partagés, `additionalProperties: false` |
| V11.1.x (logique métier) | Idempotence des opérations financières (rejeu, conflit) | SEC-P3 | B5 | À faire | Format `Idempotency-Key` au contrat (P0-S6) |

### MASVS (apps Flutter)
| Réf. | Exigence (résumé) | SEC | Tâche | État | Commentaire |
|---|---|---|---|---|---|
| MASVS-STORAGE-1 | Stockage sécurisé des données sensibles | SEC-M1 | M3 | En attente d'outils | `flutter_secure_storage` (Keychain/Keystore) |
| MASVS-STORAGE-2 | Pas de fuite (logs, sauvegardes, presse-papiers) | SEC-D4 | M1, M3 | En attente d'outils | Logs release sans donnée sensible ; `allowBackup` à évaluer |
| MASVS-NETWORK-1 | Trafic réseau sécurisé (TLS, pas de cleartext) | SEC-D1 | M1, M3 | En attente d'outils | `usesCleartextTraffic=false` hors dev |
| MASVS-NETWORK-2 | Épinglage de l'identité du serveur | SEC-M2 | M3 | En attente d'outils | Pinning configurable ; clés de secours |
| MASVS-PLATFORM-3 | UI sécurisée (capture d'écran, sélecteur d'apps) | SEC-M5 | M3 | En attente d'outils | `FLAG_SECURE` sur QR et PIN |
| MASVS-CODE-3 | Composants sans vulnérabilité connue | SEC-S1 | M1, B6 | En attente d'outils | `pubspec.lock`, scan OSV (SC-6) |
| MASVS-CODE-4 | Validation des entrées (liens profonds, données serveur) | SEC-W1 | M1 | En attente d'outils | Routes go_router à liste blanche |
| MASVS-RESILIENCE-3 | Freins à l'analyse statique (obfuscation) | SEC-M6 | M3 | En attente d'outils | `--obfuscate --split-debug-info` ; symboles hors dépôt |
| MASVS-CRYPTO-2 / SEC-M6 | Aucune clé secrète dans le binaire | SEC-M6 | M1, M3 | En attente d'outils | Clé de signature hors dépôt (CF-06) |
| MASVS-RESILIENCE-1, -2 / MASVS-AUTH | Intégrité de la plateforme, attestation, auth | SEC-M3, M4 | — | Hors phase 0 | Phases 5 et 8 |

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

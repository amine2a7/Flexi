# Exigences de sécurité FlexiPay
Référentiels : OWASP ASVS niveau 2 (API/web), OWASP MASVS (mobile). Priorité : **Must** = bloquant avant le lancement.

## Authentification et sessions
| ID | Exigence | Prio |
|---|---|---|
| SEC-A1 | Mots de passe hachés en Argon2id, politique de complexité, refus des mots de passe compromis | Must |
| SEC-A2 | Mot de passe temporaire : expire à 72 h, toutes les routes bloquées sauf le changement | Must |
| SEC-A3 | Access token 10–15 min ; refresh token rotatif avec détection de réutilisation (révocation de la famille) | Must |
| SEC-A4 | MFA TOTP obligatoire pour Administrateur, Entreprise, Commerçant ; codes de secours | Must |
| SEC-A5 | PIN haché, vérifié côté serveur, 5 essais puis blocage temporaire progressif | Must |
| SEC-A6 | Biométrie = déverrouillage local uniquement, jamais seul facteur serveur | Must |
| SEC-A7 | Web : cookies HttpOnly, Secure, SameSite=Strict, protection CSRF | Must |
| SEC-A8 | Sessions et appareils visibles et révocables par l'utilisateur | Should |

## Autorisation
| ID | Exigence | Prio |
|---|---|---|
| SEC-Z1 | Guard global : toute route est protégée sauf `@Public()` | Must |
| SEC-Z2 | RBAC strict par rôle ; permissions testées pour chaque endpoint | Must |
| SEC-Z3 | Isolation par tenant avec Row-Level Security PostgreSQL | Must |
| SEC-Z4 | Aucun accès à une ressource par simple identifiant sans contrôle serveur (IDOR) | Must |
| SEC-Z5 | Double validation : l'initiateur ne peut jamais approuver sa demande | Must |

## Paiement et ledger
| ID | Exigence | Prio |
|---|---|---|
| SEC-P1 | QR signé, nonce, TTL 60 s, usage unique consommé atomiquement | Must |
| SEC-P2 | QR lié à l'appareil enregistré ; ne contient aucune donnée personnelle | Must |
| SEC-P3 | Idempotency-Key obligatoire sur toute opération financière | Must |
| SEC-P4 | Ledger immuable (triggers), contre-passation uniquement | Must |
| SEC-P5 | Plafonds (transaction, jour, mois) vérifiés dans la transaction SQL | Must |
| SEC-P6 | Réconciliation quotidienne et alerte sur tout écart | Must |
| SEC-P7 | RIB du commerçant : changement soumis à double validation et notification | Must |

## Données
| ID | Exigence | Prio |
|---|---|---|
| SEC-D1 | TLS 1.2+ partout, HSTS, chiffrement au repos | Must |
| SEC-D2 | Chiffrement au niveau des champs (AES-256-GCM, KMS) : RIB, pièces d'identité, téléphone | Must |
| SEC-D3 | Documents KYC en stockage privé, URL signées de 5 min, scan antivirus | Must |
| SEC-D4 | Logs sans donnée sensible (masquage automatique) | Must |
| SEC-D5 | Sauvegardes chiffrées, restauration PITR testée trimestriellement | Must |
| SEC-D6 | Minimisation et durées de conservation documentées (INPDP) | Should |

## API et web
| ID | Exigence | Prio |
|---|---|---|
| SEC-W1 | Validation de toute entrée (Zod/DTO), requêtes paramétrées | Must |
| SEC-W2 | Rate limiting par IP, compte et route ; WAF | Must |
| SEC-W3 | En-têtes : CSP stricte, X-Content-Type-Options, frame-ancestors, Referrer-Policy | Must |
| SEC-W4 | CORS restreint aux origines connues | Must |
| SEC-W5 | Messages d'erreur génériques (pas de fuite d'information, pas d'énumération de comptes) | Must |

## Mobile (MASVS)
| ID | Exigence | Prio |
|---|---|---|
| SEC-M1 | Tokens dans Keychain/Keystore (`flutter_secure_storage`) uniquement | Must |
| SEC-M2 | Pinning de certificat TLS | Must |
| SEC-M3 | Attestation d'appareil : App Attest (iOS), Play Integrity (Android), vérifiée côté serveur | Must |
| SEC-M4 | Détection root/jailbreak (réponse proportionnée au risque) | Should |
| SEC-M5 | Capture d'écran bloquée sur QR et PIN ; masquage dans le sélecteur d'apps | Must |
| SEC-M6 | Code obfusqué en release (`--obfuscate --split-debug-info`), aucune clé secrète dans le binaire | Must |
| SEC-M7 | Déconnexion automatique après inactivité | Must |

## Audit et détection
| ID | Exigence | Prio |
|---|---|---|
| SEC-L1 | Journal d'audit append-only avec chaînage de hachage (qui, quoi, quand, avant/après, IP, appareil) | Must |
| SEC-L2 | Règles antifraude : montant inhabituel, 3 transactions en 5 min, nouvel appareil, changement de RIB | Must |
| SEC-L3 | Alertes temps réel (échecs de connexion en masse, écart de réconciliation, pics d'erreurs) | Must |
| SEC-L4 | Plan de réponse aux incidents testé | Must |

## Cycle de développement
| ID | Exigence | Prio |
|---|---|---|
| SEC-S1 | Analyse statique (CodeQL/Semgrep) et audit des dépendances en CI | Must |
| SEC-S2 | Détection de secrets (gitleaks) en pre-commit et en CI | Must |
| SEC-S3 | Scan des conteneurs (Trivy), SBOM | Should |
| SEC-S4 | DAST (OWASP ZAP) sur staging | Should |
| SEC-S5 | Revue humaine obligatoire sur auth, permissions et argent | Must |
| SEC-S6 | **Pentest externe avant le lancement** | Must |

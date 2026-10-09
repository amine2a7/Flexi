# Modèle de menaces (STRIDE) – version initiale
À compléter à chaque module. Légende : S usurpation · T altération · R répudiation · I fuite · D déni de service · E élévation de privilèges.

| Actif | Menace | Type | Mesures | Spec |
|---|---|---|---|---|
| Compte employé | Vol de mot de passe temporaire envoyé par SMS/email | S | Expiration 72 h, changement forcé, notification, limitation d'essais | 01 |
| Compte employé | Bourrage d'identifiants | S | Rate limiting, verrouillage progressif, MFA/PIN | 01 |
| Session mobile | Vol de téléphone | S, I | PIN, biométrie locale, déconnexion inactivité, révocation à distance | 01, 06 |
| QR de paiement | Capture ou rejeu du QR | S, T | TTL 60 s, usage unique, liaison appareil, capture bloquée | 06 |
| Paiement | Double débit (rejeu, concurrence) | T | Idempotency-Key, verrous, contraintes | 02 |
| Ledger | Altération des écritures par un admin ou un attaquant | T, R | Immuabilité (triggers), audit chaîné, accès DB restreint | 02 |
| Commission | Modification de taux frauduleuse | T | Double validation, historique, date d'effet, snapshot | 03 |
| RIB commerçant | Changement du RIB pour détourner les virements | T, S | Double validation, notification, délai de carence, contrôle KYB | 07, 08 |
| Données entreprise | Accès d'une société aux données d'une autre | I | RLS, tests IDOR | 01 |
| Documents KYC | Fuite de pièces d'identité | I | Chiffrement, URL signées courtes, accès journalisé | 04 |
| Import CSV | Injection de formules, fichiers piégés, doublons | T, D | Validation stricte, taille limitée, neutralisation des formules | 05 |
| API publique | Déni de service au pic de midi | D | WAF, rate limiting, mise à l'échelle, files | 02, 06 |
| Back-office | Compte administrateur compromis | E | MFA, double validation, moindre privilège, alertes | 01, 04 |
| Application mobile | Rétro-ingénierie, appareil rooté | T, E | Obfuscation, attestation, contrôles serveur | 06 |
| Règlements | Virement frauduleux | T | Contrôle RIB/KYC, double validation au-delà du seuil, rapprochement | 08 |
| Notifications | Hameçonnage imitant FlexiPay | S | Domaine dédié, SPF/DKIM/DMARC, pas de lien de connexion dans les SMS | 09 |

## Principes
Moindre privilège, défense en profondeur, échec fermé (en cas de doute, refuser), le serveur ne fait jamais confiance au client.

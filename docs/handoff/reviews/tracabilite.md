# Matrice de traçabilité – périmètre web (Administrateur, Entreprise, Commerçant, Commun)

**Tenue par :** conformite · **Création :** 2026-10-11 · **Dernière mise à jour :** 2026-10-12 (état de la branche `feat/web`, HEAD 12c66bf + arbre de travail)
**Sources :** `docs/cahier-des-charges.md` v4.1 · `docs/glossaire-regles-metier.md` · `docs/specs/01 03 04 05 07 08 09` · `docs/design/charte-graphique.md` · `docs/design/figma-handoff.md` · `docs/design/specs/` · `docs/handoff/contracts/openapi.yaml` (version 0.2.0 non commitée, SHA-256 `b3ff68ba…` : conventions, authentification web, `/v1/me`, `GET /health`) · `docs/handoff/decisions.md` · plan « web d'abord » du `BOARD.md`.

**Statuts :** **Conforme** (exigence couverte et vérifiée) · **Partiel** (couverte en partie, écart nommé) · **Manquant** (pas encore couvert à ce niveau de la chaîne : spec d'écran, contrat, code ou test absent) · **Hors périmètre** (avec la décision qui l'exclut).
« Spec » = spec fonctionnelle (`docs/specs/NN`) puis spec d'écran de design. « Écran / code » = fichier réel. « Test » = test existant, ou **prévu** (BOARD) entre parenthèses. Un « Manquant » en phase « web d'abord » signifie « à venir dans le plan », pas une faute ; il devient un écart quand la tâche concernée est déclarée terminée.

**État global (2026-10-12) :** aucun écran web n'existe (`apps/web` : coquille en cours de création par frontend, aucun code d'écran). Le contrat 0.2.0 couvre les conventions, l'authentification web et `/v1/me` : conformité **NON CONFORME** pour un seul écart Basse côté `main` (W-03, alignement de la spec 01 §3) (`conformite-wb2-auth-contrat-2026-10-12.md`). Specs d'écran : D2/D3 revérifiées (S-01, S-03, S-04, S-05 fermés ; S-02 et S-06 en attente de `main`) ; WD1 et WD2 relues le 2026-10-12 : **NON CONFORMES** (WD-01 à WD-07, deux `[DÉCISION]`) (`conformite-wd1-wd2-2026-10-12.md`). Code livré et relu : B1, B2, D1 (conformes), B4 (non clôturable, Docker arrêté) : voir `conformite-bord-vague1-2026-10-11.md`.

---

## 1. Principes transversaux du plan « web d'abord » et règles non négociables

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| Montants en millimes entiers, jamais décimaux (CLAUDE.md r1 ; glossaire ; contrat §2) | D2 A.1, C.6 | `packages/shared/src/money.ts` (`amountMillimesSchema`, `positiveAmountMillimesSchema`, `tndToMillimes`) | `packages/shared/test/money.test.ts` (47 tests shared, relancés : 47/47) | **Conforme** (socle) |
| Taux en points de base 0..10 000 (r2 ; contrat §2) | D2 C.6 | `packages/shared/src/rate.ts` | `rate.test.ts` | **Conforme** (socle) |
| Devise TND, `Direction` DEBIT/CREDIT, fuseau métier `Africa/Tunis` (décision 2026-10-09) | D2 A.1 | `packages/shared/src/enums.ts` | `enums.test.ts` | **Conforme** (socle) |
| Statuts du glossaire côté code partagé (`AccountStatus`, `OrderStatus`, `PaymentStatus`, `PayoutRequestStatus`, `ApprovalStatus`) | D2 C.3 | Contrat : `openapi.yaml` schémas ; **pas** de Zod dans `packages/shared` ; types dans `packages/api-client` (WB1/WB2, non commité) | `packages/api-client/test/freshness.test.ts` (backend : 13/13 ; qualite OK ; securite WB1 et WB2 OK) | **Partiel** (contrat conforme au glossaire ; relais web non encore relu par conformite : `[LIVRÉ]` WB1 attendu) |
| Tout statut affiché est fourni par le serveur (S-03) | D2 C.3 (révision) ; contrat §9 | contrat §9 | — | **Conforme** (spec et contrat) ; `EXPIRE` / `SUSPECT` : enums en attente de la décision de `main` |
| Utilitaire unique de formatage des montants FR/AR/EN, entier seulement (`48 250,000` / `48,250.000`) ; `formatRateBps` sans flottant | D2 A.1, C.6 ; `dev-composants.md` NC.7, §11.6 | — (P0-F2) | — (prévu : tests sur les exemples D2 A.1, E3/E4) | **Manquant** |
| Données fictives exactement aux types du contrat (millimes entiers, RFC 9457, statuts du glossaire) | décision 2026-10-11 ; BOARD plan | — (`apps/web/src/mocks/`, MSW typé par `packages/api-client`) | — (prévu) | **Manquant** |
| MSW désactivé en production, prouvé par test | décision 2026-10-11 | — | — (prévu : test de build de production) | **Manquant** |
| Aucune logique métier critique dans le front (commission, frais, plafonds, solde, échéances) | CLAUDE.md r1..r5 ; `_socle-ecrans.md` S6, NC.7, NC.8, NC.10 | — | — | **Partiel** : règle posée et appliquée dans les specs WD1/WD2 ; à vérifier écran par écran |
| Aucune valeur ni texte en dur ; tokens uniquement (r15, r18) | D2 §D ; `_socle-ecrans.md` §S14 (constantes `UI.*`) | `packages/ui-tokens` (preset Tailwind généré) | `generation.test.ts` (aucune valeur en dur), `contrast.test.ts` (ui-tokens : 87/87) | **Partiel** : socle conforme ; littéraux restants dans la spec (WD-07) ; dérogation `dev.*` en attente de décision (D-03) |
| i18n FR/AR/EN, clés `zone.element`, aucune chaîne en dur | D2 A.4 ; D3 ; `_socle-ecrans.md` S1 | — (P0-F1) | — | **Manquant** |
| RTL : propriétés logiques, icônes directionnelles en miroir, nombre LTR isolé | D2 A.5 ; D3 N.1 §6 ; `_socle-ecrans.md` S11 | — | — (prévu : revue FR + AR + petit écran) | **Manquant** |
| WCAG 2.1 AA : contrastes, focus, cibles ≥ 44 px (cahier §6) | D2 A.6, §D.2 ; `_socle-ecrans.md` S10 | tokens `focus`, `border-strong`, `*-text` | `contrast.test.ts` ; prévu : axe-core (`dev-composants.md` §11.1) | **Partiel** (contrastes testés ; focus/clavier non codés) |
| Jetons : cookies HttpOnly, CSRF `X-CSRF-Token`, Origin (contrat §6) | D3 N.6 | `packages/api-client/src/index.ts` (`credentials: include`, `X-CSRF-Token` sur méthodes non sûres) | `client.test.ts` (backend) | **Partiel** (qualite OK, securite OK ; conformite à rendre sur WB1) |
| Bibliothèque de composants `/dev/composants`, absente de la production (défaut du lead, 2026-10-11) | `dev-composants.md` (WD2) | — | — (prévu : test de non-présence après `next build`, §2.2 et §11.4) | **Partiel** : spec relue le 2026-10-12 (NON CONFORME : WD-05, WD-06, WD-07) ; code WF1 Manquant |
| Pas d'intermédiaire (IR) ni de mandat (CLAUDE.md « Acteurs ») | charte (« sans IR ») | grep des specs D2/D3/WD1/WD2/charte : aucune occurrence en dehors de « sans IR » | — | **Conforme** (à revérifier à chaque spec) |

## 2. Commun (connexion, session, navigation, états)

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| Connexion email/téléphone + mot de passe ; messages génériques (« identifiants invalides ») (spec 01 §5, §« Erreurs ») | 01 ; D2 C.9 (`INVALID_CREDENTIALS`) ; `commun-connexion.md` | `openapi.yaml` 0.2.0 : `POST /v1/auth/login` | — (prévu : Playwright connexion) | **Partiel** : contrat conforme ; spec d'écran à corriger (WD-02, WD-04) ; code Manquant |
| MFA TOTP obligatoire ADMIN / COMPANY / MERCHANT (cahier §6 ; spec 01 §3) : défi et enrôlement | 01 ; `commun-mfa.md` | `openapi.yaml` 0.2.0 : `mfa/verify`, `mfa/enroll`, `mfa/enroll/confirm` | — | **Partiel** : contrat conforme (paramètres 5/10 min, 6 chiffres marqués « provisoire », à consigner par `main`) ; spec à corriger (WD-02, WD-03) ; codes de secours absents des documents (en attente de décision) ; code Manquant |
| Blocage après 5 échecs, sans révélation du verrouillage (cahier §6 ; contrat §4) | 01 §3 ; D2 C.9 ; contrat §10 (compteur commun login/MFA) | contrat uniquement | — | **Partiel** (contrat conforme ; écran et code Manquant) |
| Mot de passe temporaire 72 h et changement obligatoire (RG-2.2, critère d'acceptation 3) : employés et membres famille = **mobile** ; accès web des comptes Entreprise/Commerçant/Admin : règle **absente** des documents | 01 §3 ; `commun-premiere-connexion.md` ; contrat `PASSWORD_CHANGE_REQUIRED`, `password/change` | `openapi.yaml` 0.2.0 : `POST /v1/auth/password/change` | — | **Partiel** : `[DÉCISION]` D-01 à `main` ; spec à corriger (WD-01 séquence, WD-02 codes) ; refresh en état restreint (W-03) |
| Mot de passe oublié / réinitialisation (spec 01 §5 `POST /auth/password/forgot`, `/reset`) | 01 ; `commun-mot-de-passe-oublie.md` (ajout de design, hors liste BOARD : B-05, D-04) | `openapi.yaml` 0.2.0 : `password/forgot`, `password/reset` (`x-pending-decision`) | — | **Partiel** : contrat présent, mécanisme lien/OTP en attente de décision ; périmètre à confirmer (D-04) ; code Manquant |
| Politique de mot de passe (longueur, complexité) | aucune | `openapi.yaml` 0.2.0 : `GET /v1/auth/password-policy` (valeurs d'exemple) | — | **Partiel** : forme au contrat, **valeurs absentes des documents** (en attente de décision) |
| Session expirée / déconnecté (cahier §6 ; charte §7 et §10) | D2 C.8.5 ; D3 N.6, N.9 ; `commun-session-expiree.md` | — | — (prévu) | **Partiel** : spec relue (WD-04 `returnTo`) ; durées de session de l'API (CT-X-6) absentes du contrat ; code Manquant |
| Hors connexion : bandeau, actions désactivées (charte §7 ; spec 06 §4) | D2 C.8.4 ; D3 N.7 | — | — | **Partiel** : spec conforme, code Manquant |
| 7 états obligatoires par écran : chargement, vide, erreur, hors connexion, session expirée, solde insuffisant, permission refusée (charte §7) | D2 C.8 (C.8.1 à C.8.8) ; `_socle-ecrans.md` S3 ; `commun-erreurs.md` | — | — | **Conforme** (spec) ; code Manquant |
| Pages 403 / 404 / 500 | D2 C.8.3, C.8.8, C.8.9 ; `commun-erreurs.md` | — | — | **Conforme** (spec) ; code Manquant |
| Sidebar bleu nuit : logo, profil et rôle, modules, déconnexion ; modules = ceux du cahier §5.6 pour les 3 espaces | D3 N.1 (libellés et ordre repris du cahier) | — (P0-F2) | — | **Partiel** : modules conformes ; « changement de rôle en bas » (cahier §5.6) retiré sans décision utilisateur consignée (S-02, ouvert, `[DÉCISION]` à `main`) |
| En-tête : fil d'Ariane, utilisateur, badge de rôle, notifications, action principale (cahier §5.6) | D3 N.2, N.8 (panneau des notifications) | — | — | **Partiel** : « Mon profil » sans spec de destination (S-06, ouvert) |
| Notifications in-app (cloche, compteur) | 09 §1 ; D3 N.2, N.8 | — | — | **Partiel** : spec N.8 présente ; `GET /me/notifications` et compteur absents du contrat 0.2.0 |
| Langue FR / AR / EN sur le web, RTL (cahier §6) | D3 N.2 (menu du compte) ; sélecteur de langue sur toutes les pages hors coquille (WD1) | — | — | **Partiel** : spec conforme ; code Manquant |
| Composants : bouton, champ (montant), badge de statut, carte, toast, montant, squelette (cahier §5.5 ; charte §5) | D2 C.1 à C.7 | — (P0-WF1) | — | **Conforme** (spec) ; code Manquant |
| Composants : tableau filtrable/recherchable, modale de confirmation, onglets, dépôt de fichier, étapes (cahier §5.5 « Tables », charte §5 « Tableau » et « Modale », figma-handoff `01 Composants`) | `dev-composants.md` NC.1 à NC.14 | — | — | **Conforme** (spec, S-01 fermé) ; code Manquant |
| Toasts : succès auto 4 s, erreur sans fermeture automatique (décision 2026-10-09) | D2 C.5 | — | — | **Conforme** (spec) |
| Format d'erreur RFC 9457 : `code` testé, `messageKey` traduit, `title` jamais affiché, `requestId` en « Référence » | D2 A.2, C.9 ; contrat §4 | `packages/api-client` (`isProblem`) | `client.test.ts` | **Partiel** : contrat conforme ; matrice C.9 incomplète et en contradiction pour `RESOURCE_STATE_CONFLICT` (WD-05) |
| Pagination par curseur ; compteur borné facultatif `?withCount` (contrat §7, UX-02) | D2 A.8 ; `dev-composants.md` NC.1 | contrat 0.2.0 | — | **Partiel** : contrat conforme ; spec limite le compteur aux listes Administrateur (WD-06) |
| Tenant et rôle jamais envoyés par le client (RG-2.5 ; contrat §6) | D3 N.1 | `packages/api-client` ; contrat `Me.tenant` | `client.test.ts` | **Conforme** (spec, contrat) |
| `GET /me` (rôle, sous-rôle, permissions) : navigation calculée uniquement depuis le serveur | D3 « Source des données » ; `_besoins-contrat.md` CT-C-8 | `openapi.yaml` 0.2.0 : `GET /v1/me` | — | **Partiel** : contrat présent ; matrice des permissions en attente de décision |

## 3. Administrateur (cahier §4.1, spec 04, spec 03, spec 08)

Rappel : spec fonctionnelle présente pour tous ; **aucune spec d'écran** (WD5 « À faire »), **aucune route** au contrat (WB2 suivants), aucun code.

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| ADM-01 Vue d'ensemble (entreprises/commerçants actifs, crédits, volume/jour, litiges, tendances, actions urgentes) | 04 ; 09 §3 ; D2 C.4.5 (carte KPI) | — (WF5) | — | **Manquant** |
| ADM-02 Gestion des comptes : liste, recherche, filtres, pagination, actions voir/valider/rejeter/suspendre | 04 ; `dev-composants.md` NC.1, NC.2 | — | — | **Manquant** |
| ADM-03 Création société avec liste déroulante du profil de commission, **obligatoire** (RG-1.3 ; critère 1) | 03 §2 ; 04 | — | — (prévu : Playwright création de commerçant) | **Manquant** |
| ADM-04 Création commerçant avec profil de commission, RIB, cycle de règlement | 03 ; 04 | — | — (prévu) | **Manquant** |
| ADM-05 KYC/KYB : documents, notes, rejeter / compléments / valider ; URL signées 5 min | 04 §2, §5 ; `dev-composants.md` NC.3, NC.6 | — | — | **Manquant** |
| ADM-06 Transactions en temps réel, filtres, détail, export | 04 ; `dev-composants.md` NC.14 | — | — | **Manquant** |
| ADM-07 Alertes fraude (montant inhabituel, 3 en 5 min) | 04 §2 | — | — | **Manquant** (WD5 : « transactions et alertes ») |
| ADM-08 Règlements : lots, historique des virements, fichiers bancaires, rapprochements, litiges (RG-6, RG-7 ; critère 7) | 08 ; module « Règlements & compensation » du cahier §5.6 | — | — | **Manquant** : **absent de la liste WD5** du BOARD (écart B-04) |
| ADM-09 Paramétrage : catégories, profils de commission (double validation, RG-1.7), plafonds, seuils, cycles | 03 ; 04 §2 | — | — | **Manquant** (WD5 : « commissions », « paramètres ») |
| ADM-10 Sécurité : journal d'audit, rôles internes, double validation (initiateur ≠ approbateur), blocage/déblocage | 04 ; 09 §2 ; CLAUDE.md r12, r13 ; `dev-composants.md` NC.10 | — | — | **Manquant** (WD5 : « audit » ; rôles internes et blocage non cités) |
| ADM-11 Reporting (Should) | 04 ; 09 §3 | — | — | **Manquant** : hors plan WD5, à confirmer ou exclure par décision (écart B-04) |
| ADM-12 Support (Should) | — | — | — | **Manquant** : module « Support » dans la navigation, ni spec fonctionnelle ni plan (S-06) |
| ADM-13 Administration système (Should) | — | — | — | **Manquant** : idem |

## 4. Entreprise (cahier §4.2, spec 05, spec 03)

Rappel : spec d'écran WD4 « À faire », aucune route au contrat, aucun code.

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| ENT-01 Tableau de bord (portefeuille par catégorie, attribués, consommés %, expirés %, actions rapides) | 05 ; D2 C.4.5 | — | — | **Manquant** |
| ENT-02 Commande de crédits avec récapitulatif **frais** : total = montant + frais (RG-1.4 ; E1 : 50 000 000 + 500 000 = 50 500 000) ; frais calculés par le serveur | 05 §2 ; 03 §2 ; `dev-composants.md` NC.7 (`AmountBreakdown`) | — | — (prévu : Playwright commande de crédits) | **Manquant** |
| ENT-03 Suivi des commandes, factures, preuves de virement | 05 §3 | — | — | **Manquant** (WD4 : « factures » ; suivi des commandes et preuves non citées) |
| ENT-04 Employés : liste, ajout manuel, import CSV (5 000 lignes / 5 Mo, doublons, aperçu avant import, neutralisation des formules), groupes/départements, activation/désactivation | 05 §2 ; `dev-composants.md` NC.6 (`FileDrop`, limites fournies par l'API) | — | — | **Manquant** (WD4 : « employés + import CSV ») |
| ENT-05 Mot de passe temporaire : génération, renvoi, réinitialisation (72 h) | 01 §3 ; 05 | — | — | **Manquant** (non cité dans WD4) |
| ENT-06 Attribution : unitaire, par lots, CSV, notification, validité ; impossible d'attribuer plus que le solde | 05 §2 | — | — | **Manquant** (code d'erreur d'un solde entreprise insuffisant à définir au contrat Entreprise) |
| ENT-07 Attribution récurrente (Should) | 05 §2 | — | — | **Manquant** (hors plan WD4 : à confirmer) |
| ENT-08 Reporting par employé, département, commerçant, expirés ; exports PDF/Excel asynchrones | 05 ; 09 §3 ; `dev-composants.md` NC.14 (`ExportDialog`) | — | — | **Manquant** (WD4 : « reporting ») |
| ENT-09 Comptabilité (Should) | 05 | — | — | **Manquant** : module « Comptabilité » dans la navigation, hors plan WD4 |
| ENT-10 Paramètres : société, utilisateurs et rôles (propriétaire, gestionnaire, comptable, lecture seule), notifications | 01 §2 ; 05 | — | — | **Manquant** (WD4 : « paramètres ») |
| RG-2.4 Une entreprise ne voit que ses employés (isolation) | 01 §8 ; contrat §6 | — | — | **Manquant** (côté serveur ; le front n'envoie jamais le tenant) |

## 5. Commerçant (cahier §4.3, spec 07, spec 03, spec 08)

Rappel : spec d'écran WD3 « À faire », aucune route au contrat, aucun code.

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| COM-01 Tableau de bord : ventes du jour, en attente (J+2), réglé, commission, panier moyen, prochain règlement avec net estimé | 07 ; 09 §3 | — | — | **Manquant** ; « commission » visible au tableau de bord à vérifier contre RG-1.5 (la commission n'est prélevée qu'à la demande de virement) |
| COM-02 Encaissement par **scan QR** (caméra, flash, son) | 07 §2 | — | — | **Partiel** : le plan web ne prévoit que le **code manuel** ; scan caméra sur le web ni inclus ni exclu par décision (écart B-06, `[DÉCISION]`) ; version mobile : **Hors périmètre** (décision 2026-10-11) |
| COM-03 Saisie manuelle du code à 8 chiffres | 07 | — | — (prévu : Playwright encaissement) | **Manquant** (WD3) |
| COM-04 Validation : prénom + initiale, matricule masqué, catégorie, montant, compte à rebours ; résultat « accepté » / « refusé » **sans solde ni motif** (v4.1 ; décisions 2026-10-09) | 07 §2 ; D2 C.8.11 ; contrat `PAYMENT_DECLINED` ; `dev-composants.md` NC.8 (`Countdown`) | — | — | **Partiel** : règle du refus conforme dans D2/contrat ; écran Manquant ; validité du code manuel (60 s ?) non établie par les documents : `[DÉCISION]` D-02 |
| COM-05 Reçu : envoi email/SMS, impression, nouveau scan | 07 | — | — | **Manquant** (absent de la liste WD3) |
| COM-06 Historique : filtres (date, statut, montant), recherche, export, pagination ; **onglet du module Encaissement** (décision 2026-10-09) | 07 ; D3 N.1 ; `dev-composants.md` NC.1, NC.2, NC.4 | — | — | **Manquant** (WD3 : « historique ») |
| COM-07 **Demande de virement avec simulation** : montant demandé, taux, commission, net (RG-1.5 ; E4 : 45 000 → 900 → 44 100 ; E5 ; critère 2) ; **calculé par le serveur** (`GET /payouts/quote`), taux figé (RG-1.6) | 03 §4 ; 07 §2 ; D2 C.6 ; `dev-composants.md` NC.7, NC.9 | — | — (prévu : Playwright simulation et demande) | **Manquant** (route absente du contrat) |
| COM-07 Seuil minimum de virement (E14) annoncé avant la saisie | 07 §2 ; 08 | — | — | **Manquant** |
| COM-08 Règlements : calendrier (brut, commission, net), délai moyen, factures, relevés, attestations | 08 §2 | — | — | **Manquant** (WD3 : « règlements » ; factures/relevés/attestations non cités) |
| COM-09 Mon commerce : informations, RIB, points de vente, caissiers et permissions, catégories (Should) | 07 §2 ; 01 §2 ; `dev-composants.md` NC.11 (`MaskedValue`) | — | — | **Manquant** (WD3 : « mon commerce ») |
| COM-10 Contestations / annulations (Should) | 07 §2 | — | — | **Manquant** (hors plan WD3) |
| COM-11 QR caisse, mode hors ligne (Could) | cahier §1.3 | — | — | **Hors périmètre** (Could ; hors ligne exclu du MVP, cahier §1.3 et D3 N.4) |
| Commerçant ne voit jamais le solde complet du client (CLAUDE.md r9 ; décision 2026-10-09) | 07 §2 ; contrat §4 | — | — | **Conforme** (spec D2 C.8.11 et contrat) ; écran Manquant |
| Rôles : propriétaire / caissier / comptable, navigation recomposée par permissions | 01 §2 ; 07 §2 ; D3 N.1 ; `_socle-ecrans.md` S8 | contrat `Me.subRole`, `Me.permissions` | — | **Partiel** (noms de permissions par module absents : en attente de décision) |
| Modules « Statistiques » et « Support » du cahier §5.6 | — | — | — | **Manquant** : aucune exigence ni spec ni plan (S-06) |

## 6. Exigences d'autres espaces (hors périmètre de cette matrice)

| Exigence | Statut |
|---|---|
| EMP-01 à EMP-08 (app Employé), comptes famille (RG-2.3), version mobile de COM-02 à COM-08 (app Pro) | **Hors périmètre** : mobile reporté (décision 2026-10-11 « Web d'abord ») ; à reprendre dans cette matrice à la relance de l'agent `mobile` |
| Staging, CI (B6), API métier (ledger, paiements, virements) | **Hors périmètre** de cette matrice (staging exclu : décision 2026-10-09 ; backend métier après le web : décision 2026-10-11) |

## 7. Journal de mise à jour

| Date | Tâche relue | Lignes touchées | Verdict |
|---|---|---|---|
| 2026-10-11 | Création de la matrice ; vague 1 (B1, B2, D1, B4) ; specs D2 et D3 | tout | Vague 1 : B1 B2 D1 CONFORME, B4 non clôturable ; D2/D3 NON CONFORME (voir revues du jour) |
| 2026-10-12 | Revérification D2/D3 (S-01, S-03, S-04, S-05 fermés ; S-02, S-06 en attente de `main`) ; WB2 contrat 0.2.0 ; WD1 et WD2 | §1, §2, références de §3 à §5 | WB2 : NON CONFORME (W-01 et W-02 fermés côté contrat ; W-03 ouvert, `main`) ; WD1 et WD2 : NON CONFORMES (WD-01 à WD-07 ; D-03, D-04) |

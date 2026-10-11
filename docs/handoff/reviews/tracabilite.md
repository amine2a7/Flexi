# Matrice de traçabilité – périmètre web (Administrateur, Entreprise, Commerçant, Commun)

**Tenue par :** conformite · **Création :** 2026-10-11 · **Dernière mise à jour :** 2026-10-11 (état de la branche `feat/web`, HEAD 12c66bf + arbre de travail)
**Sources :** `docs/cahier-des-charges.md` v4.1 · `docs/glossaire-regles-metier.md` · `docs/specs/01 03 04 05 07 08 09` · `docs/design/charte-graphique.md` · `docs/design/figma-handoff.md` · `docs/design/specs/` · `docs/handoff/contracts/openapi.yaml` (SHA-256 `82bf61bd…`, seul `GET /health` + conventions) · `docs/handoff/decisions.md` · plan « web d'abord » du `BOARD.md`.

**Statuts :** **Conforme** (exigence couverte et vérifiée) · **Partiel** (couverte en partie, écart nommé) · **Manquant** (pas encore couvert à ce niveau de la chaîne : spec d'écran, contrat, code ou test absent) · **Hors périmètre** (avec la décision qui l'exclut).
« Spec » = spec fonctionnelle (`docs/specs/NN`) puis spec d'écran de design. « Écran / code » = fichier réel. « Test » = test existant, ou **prévu** (BOARD) entre parenthèses. Un « Manquant » en phase « web d'abord » signifie « à venir dans le plan », pas une faute ; il devient un écart quand la tâche concernée est déclarée terminée.

**État global (2026-10-11) :** aucun écran web n'existe (`apps/web` : coquille `package.json` en cours de création par frontend, aucun code) ; le contrat ne couvre que `GET /health` ; les seules specs d'écran sont les fondations D2 (composants et états) et D3 (navigation), **revues par ux : À REVOIR** et par conformite : **NON CONFORME** (voir `conformite-specs-d2-d3-2026-10-11.md`). Code livré et relu : B1, B2, D1 (conformes), B4 (non clôturable, Docker arrêté) : voir `conformite-bord-vague1-2026-10-11.md`.

---

## 1. Principes transversaux du plan « web d'abord » et règles non négociables

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| Montants en millimes entiers, jamais décimaux (CLAUDE.md r1 ; glossaire ; contrat §2) | D2 A.1, C.6 | `packages/shared/src/money.ts` (`amountMillimesSchema`, `positiveAmountMillimesSchema`, `tndToMillimes`) | `packages/shared/test/money.test.ts` (47 tests shared, relancés : 47/47) | **Conforme** (socle) |
| Taux en points de base 0..10 000 (r2 ; contrat §2) | D2 C.6 | `packages/shared/src/rate.ts` | `rate.test.ts` | **Conforme** (socle) |
| Devise TND, `Direction` DEBIT/CREDIT, fuseau métier `Africa/Tunis` (décision 2026-10-09) | D2 A.1 | `packages/shared/src/enums.ts` | `enums.test.ts` | **Conforme** (socle) |
| Statuts du glossaire côté code partagé (`AccountStatus`, `OrderStatus`, `PaymentStatus`, `PayoutRequestStatus`, `ApprovalStatus`) | D2 C.3 | Contrat : `openapi.yaml` schémas ; **pas** de Zod dans `packages/shared` ; types dans `packages/api-client` (WB1, non commité) | `packages/api-client/test/freshness.test.ts` (backend : 9/9, en revue) | **Partiel** (contrat conforme au glossaire ; relais web en revue) |
| Utilitaire unique de formatage des montants FR/AR/EN, entier seulement (`48 250,000` / `48,250.000`) | D2 A.1, C.6 | — (P0-F2) | — (prévu : tests sur les exemples D2 A.1, E3/E4) | **Manquant** |
| Données fictives exactement aux types du contrat (millimes entiers, RFC 9457, statuts du glossaire) | décision 2026-10-11 ; BOARD plan | — (`apps/web/src/mocks/`, MSW typé par `packages/api-client`) | — (prévu) | **Manquant** |
| MSW désactivé en production, prouvé par test | décision 2026-10-11 | — | — (prévu : test de build de production) | **Manquant** |
| Aucune logique métier critique dans le front (commission, frais, plafonds, solde, échéances) | CLAUDE.md r1..r5 ; `_besoins-contrat.md` (règle de design) ; spec 03 §6 « même fonction » | — | — | **Partiel** : règle posée par design, mais D2 dérive `A_REGLER`/`EXPIRE`/`SUSPECT` côté client (écart S-03) |
| Aucune valeur ni texte en dur ; tokens uniquement (r15, r18) | D2 §D ; charte | `packages/ui-tokens` (preset Tailwind généré) | `generation.test.ts` (aucune valeur en dur), `contrast.test.ts` (ui-tokens : 87/87) | **Conforme** (socle) ; constantes d'interface non tokenisées dans D2 : écart S-05 |
| i18n FR/AR/EN, clés `zone.element`, aucune chaîne en dur | D2 A.4 ; D3 | — (P0-F1) | — | **Manquant** |
| RTL : propriétés logiques, icônes directionnelles en miroir, nombre LTR isolé | D2 A.5 ; D3 N.1 §6 | — | — (prévu : revue FR + AR + petit écran) | **Manquant** |
| WCAG 2.1 AA : contrastes, focus, cibles ≥ 44 px (cahier §6) | D2 A.6, §D.2 | tokens `focus`, `border-strong`, `*-text` | `contrast.test.ts` | **Partiel** (contrastes testés ; focus/clavier non codés) |
| Jetons : cookies HttpOnly, CSRF `X-CSRF-Token`, Origin (contrat §6) | D3 N.6 | `packages/api-client/src/index.ts` (`credentials: include`, `X-CSRF-Token` sur méthodes non sûres) | `client.test.ts` (backend) | **Partiel** (WB1 en revue securite/qualite) |
| Bibliothèque de composants `/dev/composants`, absente de la production (défaut du lead, 2026-10-11) | — (WD2 à faire) | — | — | **Manquant** |
| Pas d'intermédiaire (IR) ni de mandat (CLAUDE.md « Acteurs ») | charte (« sans IR ») | grep des specs D2/D3/charte : aucune occurrence en dehors de « sans IR » | — | **Conforme** (à revérifier à chaque spec) |

## 2. Commun (connexion, session, navigation, états)

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| Connexion email/téléphone + mot de passe ; messages génériques (« identifiants invalides ») (spec 01 §5, §« Erreurs ») | 01 ; D2 C.9 (`INVALID_CREDENTIALS`) ; WD1 en cours (`_besoins-contrat.md` CT-C-1) | — | — (prévu : Playwright connexion) | **Manquant** (spec d'écran WD1 non livrée) |
| MFA TOTP obligatoire ADMIN / COMPANY / MERCHANT (cahier §6 ; spec 01 §3) : défi et enrôlement | 01 ; WD1 (CT-C-2/3/3b) | — | — | **Manquant** ; codes de secours absents des documents (`[DÉCISION]` de design en cours) |
| Blocage après 5 échecs, sans révélation du verrouillage (cahier §6 ; contrat §4) | 01 §3 ; D2 C.9 | — | — | **Manquant** |
| Mot de passe temporaire 72 h et changement obligatoire (RG-2.2, critère d'acceptation 3) : employés et membres famille = **mobile** ; accès web des comptes Entreprise/Commerçant/Admin : règle **absente** des documents (aucun texte ne dit comment un utilisateur web reçoit son premier mot de passe) | 01 §3 ; contrat `PASSWORD_CHANGE_REQUIRED` | — | — | **Partiel** : `[DÉCISION]` à `main` (D-01 du rapport de revue des specs) |
| Mot de passe oublié / réinitialisation (spec 01 §5 `POST /auth/password/forgot`, `/reset`) | 01 | — | — | **Manquant** : absent de la liste WD1 du BOARD (écart B-05) ; présent dans `_besoins-contrat.md` CT-C-9/10 |
| Politique de mot de passe (longueur, complexité) | aucune | — | — | **Manquant** : règle absente (`[DÉCISION]` de design CT-C-5) |
| Session expirée / déconnecté (cahier §6 ; charte §7 et §10) | D2 C.8.5 ; D3 N.6 | — | — (prévu) | **Partiel** : spec conforme ; ux UX-17 (avertissement avant expiration) ouvert ; code Manquant |
| Hors connexion : bandeau, actions désactivées (charte §7 ; spec 06 §4) | D2 C.8.4 ; D3 N.7 | — | — | **Partiel** : spec conforme, code Manquant |
| 7 états obligatoires par écran : chargement, vide, erreur, hors connexion, session expirée, solde insuffisant, permission refusée (charte §7) | D2 C.8 (C.8.1 à C.8.8) | — | — | **Conforme** (spec) ; code Manquant |
| Pages 403 / 404 / 500 | D2 C.8.3, C.8.8, C.8.9 | — | — | **Conforme** (spec) ; code Manquant |
| Sidebar bleu nuit : logo, profil et rôle, modules, déconnexion ; modules = ceux du cahier §5.6 pour les 3 espaces | D3 N.1 (libellés et ordre repris du cahier) | — (P0-F2) | — | **Partiel** : modules conformes ; « changement de rôle en bas » (cahier §5.6) retiré sans décision utilisateur consignée (écart S-02) |
| En-tête : fil d'Ariane, utilisateur, badge de rôle, notifications, action principale (cahier §5.6) | D3 N.2 | — | — | **Partiel** : « Mon profil » et panneau de notifications sans spec de destination (écart S-06) |
| Notifications in-app (cloche, compteur) | 09 §1 ; D3 N.2 | — | — | **Manquant** (panneau et `GET /me/notifications` : ni spec ni contrat) |
| Langue FR / AR / EN sur le web, RTL (cahier §6) | D3 N.2 (menu du compte) | — | — | **Partiel** : sélecteur hors coquille (connexion…) absent (ux UX-21) |
| Composants : bouton, champ (montant), badge de statut, carte, toast, montant, squelette (cahier §5.5 ; charte §5) | D2 C.1 à C.7 | — (P0-WF1) | — | **Conforme** (spec) ; code Manquant |
| Composants : tableau filtrable/recherchable, modale de confirmation, onglets, dépôt de fichier, étapes (cahier §5.5 « Tables », charte §5 « Tableau » et « Modale », figma-handoff `01 Composants`) | D2 : mentions seules (`C.1`, A.7, A.8) | — | — | **Manquant** (écart S-01 ; cible WD2) |
| Toasts : succès auto 4 s, erreur sans fermeture automatique (décision 2026-10-09) | D2 C.5 | — | — | **Conforme** (spec) |
| Format d'erreur RFC 9457 : `code` testé, `messageKey` traduit, `title` jamais affiché, `requestId` en « Référence » | D2 A.2, C.9 ; contrat §4 | `packages/api-client` (`isProblem`) | `client.test.ts` | **Conforme** (spec et contrat) ; affichage Manquant |
| Pagination par curseur, pas de total (contrat §7) | D2 A.8 | — | — | **Conforme** (spec) |
| Tenant et rôle jamais envoyés par le client (RG-2.5 ; contrat §6) | D3 N.1 | `packages/api-client` | `client.test.ts` | **Conforme** (spec, contrat) |
| `GET /me` (rôle, sous-rôle, permissions) : navigation calculée uniquement depuis le serveur | D3 « Source des données » (hypothèse) ; `_besoins-contrat.md` CT-C-8 | — | — | **Manquant** (absent du contrat ; WB2) |

## 3. Administrateur (cahier §4.1, spec 04, spec 03, spec 08)

Rappel : spec fonctionnelle présente pour tous ; **aucune spec d'écran** (WD5 « À faire »), **aucune route** au contrat (WB2), aucun code.

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| ADM-01 Vue d'ensemble (entreprises/commerçants actifs, crédits, volume/jour, litiges, tendances, actions urgentes) | 04 ; 09 §3 ; D2 C.4.5 (carte KPI) | — (WF5) | — | **Manquant** |
| ADM-02 Gestion des comptes : liste, recherche, filtres, pagination, actions voir/valider/rejeter/suspendre | 04 | — | — | **Manquant** |
| ADM-03 Création société avec liste déroulante du profil de commission, **obligatoire** (RG-1.3 ; critère 1) | 03 §2 ; 04 | — | — (prévu : Playwright création de commerçant) | **Manquant** |
| ADM-04 Création commerçant avec profil de commission, RIB, cycle de règlement | 03 ; 04 | — | — (prévu) | **Manquant** |
| ADM-05 KYC/KYB : documents, notes, rejeter / compléments / valider ; URL signées 5 min | 04 §2, §5 | — | — | **Manquant** |
| ADM-06 Transactions en temps réel, filtres, détail, export | 04 | — | — | **Manquant** |
| ADM-07 Alertes fraude (montant inhabituel, 3 en 5 min) | 04 §2 | — | — | **Manquant** (WD5 : « transactions et alertes ») |
| ADM-08 Règlements : lots, historique des virements, fichiers bancaires, rapprochements, litiges (RG-6, RG-7 ; critère 7) | 08 ; module « Règlements & compensation » du cahier §5.6 | — | — | **Manquant** : **absent de la liste WD5** du BOARD (écart B-04) |
| ADM-09 Paramétrage : catégories, profils de commission (double validation, RG-1.7), plafonds, seuils, cycles | 03 ; 04 §2 | — | — | **Manquant** (WD5 : « commissions », « paramètres ») |
| ADM-10 Sécurité : journal d'audit, rôles internes, double validation (initiateur ≠ approbateur), blocage/déblocage | 04 ; 09 §2 ; CLAUDE.md r12, r13 | — | — | **Manquant** (WD5 : « audit » ; rôles internes et blocage non cités) |
| ADM-11 Reporting (Should) | 04 ; 09 §3 | — | — | **Manquant** : hors plan WD5, à confirmer ou exclure par décision (écart B-04) |
| ADM-12 Support (Should) | — | — | — | **Manquant** : module « Support » dans la navigation, ni spec fonctionnelle ni plan (écart S-06) |
| ADM-13 Administration système (Should) | — | — | — | **Manquant** : idem |

## 4. Entreprise (cahier §4.2, spec 05, spec 03)

Rappel : spec d'écran WD4 « À faire », aucune route au contrat, aucun code.

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| ENT-01 Tableau de bord (portefeuille par catégorie, attribués, consommés %, expirés %, actions rapides) | 05 ; D2 C.4.5 | — | — | **Manquant** |
| ENT-02 Commande de crédits avec récapitulatif **frais** : total = montant + frais (RG-1.4 ; E1 : 50 000 000 + 500 000 = 50 500 000) ; frais calculés par le serveur | 05 §2 ; 03 §2 | — | — (prévu : Playwright commande de crédits) | **Manquant** |
| ENT-03 Suivi des commandes, factures, preuves de virement | 05 §3 | — | — | **Manquant** (WD4 : « factures » ; suivi des commandes et preuves non citées) |
| ENT-04 Employés : liste, ajout manuel, import CSV (5 000 lignes / 5 Mo, doublons, aperçu avant import, neutralisation des formules), groupes/départements, activation/désactivation | 05 §2 | — | — | **Manquant** (WD4 : « employés + import CSV ») |
| ENT-05 Mot de passe temporaire : génération, renvoi, réinitialisation (72 h) | 01 §3 ; 05 | — | — | **Manquant** (non cité dans WD4) |
| ENT-06 Attribution : unitaire, par lots, CSV, notification, validité ; impossible d'attribuer plus que le solde | 05 §2 | — | — | **Manquant** |
| ENT-07 Attribution récurrente (Should) | 05 §2 | — | — | **Manquant** (hors plan WD4 : à confirmer) |
| ENT-08 Reporting par employé, département, commerçant, expirés ; exports PDF/Excel asynchrones | 05 ; 09 §3 | — | — | **Manquant** (WD4 : « reporting ») |
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
| COM-04 Validation : prénom + initiale, matricule masqué, catégorie, montant, compte à rebours ; résultat « accepté » / « refusé » **sans solde ni motif** (v4.1 ; décisions 2026-10-09) | 07 §2 ; D2 C.8.11 ; contrat `PAYMENT_DECLINED` | — | — | **Partiel** : règle du refus conforme dans D2/contrat ; écran Manquant ; validité du code manuel (compte à rebours de 60 s ?) non établie par les documents (RG-5 ambigu) : `[DÉCISION]` D-02 |
| COM-05 Reçu : envoi email/SMS, impression, nouveau scan | 07 | — | — | **Manquant** (absent de la liste WD3) |
| COM-06 Historique : filtres (date, statut, montant), recherche, export, pagination ; **onglet du module Encaissement** (décision 2026-10-09) | 07 ; D3 N.1 | — | — | **Manquant** (WD3 : « historique ») |
| COM-07 **Demande de virement avec simulation** : montant demandé, taux, commission, net (RG-1.5 ; E4 : 45 000 → 900 → 44 100 ; E5 ; critère 2) ; **calculé par le serveur** (`GET /payouts/quote`), taux figé (RG-1.6) | 03 §4 ; 07 §2 ; D2 C.6 (affichage) | — | — (prévu : Playwright simulation et demande) | **Manquant** (route absente du contrat) |
| COM-07 Seuil minimum de virement (E14) annoncé avant la saisie | 07 §2 ; 08 | — | — | **Manquant** |
| COM-08 Règlements : calendrier (brut, commission, net), délai moyen, factures, relevés, attestations | 08 §2 | — | — | **Manquant** (WD3 : « règlements » ; factures/relevés/attestations non cités) |
| COM-09 Mon commerce : informations, RIB, points de vente, caissiers et permissions, catégories (Should) | 07 §2 ; 01 §2 | — | — | **Manquant** (WD3 : « mon commerce ») |
| COM-10 Contestations / annulations (Should) | 07 §2 | — | — | **Manquant** (hors plan WD3) |
| COM-11 QR caisse, mode hors ligne (Could) | cahier §1.3 | — | — | **Hors périmètre** (Could ; hors ligne exclu du MVP, cahier §1.3 et D3 N.4) |
| Commerçant ne voit jamais le solde complet du client (CLAUDE.md r9 ; décision 2026-10-09) | 07 §2 ; contrat §4 | — | — | **Conforme** (spec D2 C.8.11 et contrat) ; écran Manquant |
| Rôles : propriétaire / caissier / comptable, navigation recomposée par permissions | 01 §2 ; 07 §2 ; D3 N.1 | — | — | **Partiel** (spec nav ; noms de permissions fournis par backend : absents) |
| Modules « Statistiques » et « Support » du cahier §5.6 | — | — | — | **Manquant** : aucune exigence ni spec ni plan (écart S-06) |

## 6. Exigences d'autres espaces (hors périmètre de cette matrice)

| Exigence | Statut |
|---|---|
| EMP-01 à EMP-08 (app Employé), comptes famille (RG-2.3), version mobile de COM-02 à COM-08 (app Pro) | **Hors périmètre** : mobile reporté (décision 2026-10-11 « Web d'abord ») ; à reprendre dans cette matrice à la relance de l'agent `mobile` |
| Staging, CI (B6), API métier (ledger, paiements, virements) | **Hors périmètre** de cette matrice (staging exclu : décision 2026-10-09 ; backend métier après le web : décision 2026-10-11) |

## 7. Journal de mise à jour

| Date | Tâche relue | Lignes touchées | Verdict |
|---|---|---|---|
| 2026-10-11 | Création de la matrice ; vague 1 (B1, B2, D1, B4) ; specs D2 et D3 | tout | Vague 1 : B1 B2 D1 CONFORME, B4 non clôturable ; D2/D3 NON CONFORME (voir revues du jour) |

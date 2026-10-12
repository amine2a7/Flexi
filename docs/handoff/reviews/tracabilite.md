# Matrice de traçabilité – périmètre web (Administrateur, Entreprise, Commerçant, Commun)

**Tenue par :** conformite · **Création :** 2026-10-11 · **Dernière mise à jour :** 2026-10-12 (reprise après les 25 décisions provisoires ; branche `feat/web`, HEAD e2a926e + arbre de travail)
**Sources :** `docs/cahier-des-charges.md` v4.1 (aligné par 1ad8503) · `docs/glossaire-regles-metier.md` · `docs/specs/01 03 04 05 07 08 09` · `docs/decisions-provisoires.md` (25 décisions **provisoires**, décidées par l'utilisateur le 2026-10-12, modifiables) · `docs/design/charte-graphique.md` · `docs/design/figma-handoff.md` · `docs/design/specs/` · `docs/handoff/contracts/openapi.yaml` (version 0.2.1 : conventions, authentification web, `/v1/me`, `GET /health`) · `docs/handoff/decisions.md` · plan « web d'abord » du `BOARD.md`.

**Statuts :** **Conforme** (exigence couverte et vérifiée) · **Partiel** (couverte en partie, écart nommé) · **Manquant** (pas encore couvert à ce niveau de la chaîne : spec d'écran, contrat, code ou test absent) · **Hors périmètre** (avec la décision qui l'exclut).
« Spec » = spec fonctionnelle (`docs/specs/NN`) puis spec d'écran de design. « Écran / code » = fichier réel. « Test » = test existant, ou **prévu** (BOARD) entre parenthèses. Un « Manquant » en phase « web d'abord » signifie « à venir dans le plan », pas une faute ; il devient un écart quand la tâche concernée est déclarée terminée.

**Priorité actuelle (décision du 2026-10-12) :** frontend web complet avec données fictives (WF1 à WF5) ; backend et Docker reportés (seuls le contrat et le client généré évoluent). **Périmètre élargi (décision provisoire n° 6) :** ajoutés (Must) ADM-08, ENT-03, ENT-05, COM-05, COM-08 ; reportés (Should) ADM-11/12/13, ENT-07/09, COM-10 ; « Support » et « Statistiques » retirés de la navigation.

**État global (2026-10-12) :** `apps/web` = squelette (F1/F3, commit 736d0ca : F3 CONFORME, F1 NON CONFORME pour un écart Basse, shadcn/ui absent : `conformite-f1-f3-web-squelette-2026-10-12.md`), aucun écran. Contrat 0.2.1 : W-03 fermé par la décision n° 22 (spec 01 §3 alignée) ; revue WB2 à rafraîchir à la prochaine version. Specs d'écran : D2/D3 (S-02 fermé par la décision n° 25, S-06 en partie par la décision n° 6), WD1 CONFORME, WD2 CONFORME (la réserve D-03 est levée par la décision n° 21) ; **WD1 à mettre à jour** pour les décisions n° 1, 4, 10, 11, 15, 16, 18, 19 (codes de secours, applications citées, SMS de réinitialisation, durées de session) ; WD3 (6 specs Commerçant sur 8, reçues sans verdict ux) en attente. Vague 1 : voir `conformite-bord-vague1-2026-10-11.md`.

---

## 1. Principes transversaux du plan « web d'abord » et règles non négociables

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| Montants en millimes entiers, jamais décimaux (CLAUDE.md r1 ; glossaire ; contrat §2) | D2 A.1, C.6 | `packages/shared/src/money.ts` | `packages/shared/test/money.test.ts` (47/47) | **Conforme** (socle) |
| Taux en points de base 0..10 000 (r2 ; contrat §2) | D2 C.6 | `packages/shared/src/rate.ts` | `rate.test.ts` | **Conforme** (socle) |
| Devise TND, `Direction`, fuseau métier `Africa/Tunis` (décision 2026-10-09) | D2 A.1 | `packages/shared/src/enums.ts` | `enums.test.ts` | **Conforme** (socle) |
| Statuts du glossaire dans le contrat et le client (`AccountStatus`, `OrderStatus`, `PaymentStatus`, `PayoutRequestStatus`, `ApprovalStatus`) ; statuts ajoutés par la décision n° 14 (lot ACTIF → EXPIRE ; alerte OUVERTE → EN_COURS → CLOSE) | D2 C.3 ; glossaire (aligné) ; contrat §9 | contrat `openapi.yaml` ; `packages/api-client` | `freshness.test.ts` (qualite OK, securite OK) | **Partiel** : schémas des statuts de lot et d'alerte **absents du contrat 0.2.1** (à ajouter par backend) ; WB1 non relu par conformite |
| Tout statut affiché est fourni par le serveur (S-03) | D2 C.3 ; contrat §9 | contrat §9 | — | **Conforme** (spec et contrat) |
| Utilitaire unique de formatage des montants FR/AR/EN, entier seulement ; `formatRateBps` sans flottant | D2 A.1, C.6 ; `dev-composants.md` NC.7, §11.6 | — | — (prévu : tests sur les exemples D2 A.1, E3/E4) | **Manquant** (WF1) |
| **Données fictives exactement aux types du contrat** (millimes, RFC 9457, statuts) | décision 2026-10-11 ; protocole de contrôle dans `conformite-f1-f3-web-squelette-2026-10-12.md` | `apps/web/src/mocks/handlers.ts` (tableau vide) | — (demandé : validation de chaque réponse simulée contre le schéma OpenAPI) | **Manquant** (rien à contrôler avant WF2) |
| MSW désactivé en production, prouvé par test | décision 2026-10-11 | `MockGate`, `scripts/remove-mock-worker.mjs` | `apps/web/test/build/no-mocks-in-production.test.ts` (qualite : vert) | **Conforme** |
| Comptes de test fictifs (`@flexipay.test`, `Test1234!`, code MFA fictif) affichés **uniquement en développement** (décision 2026-10-12) | décisions-provisoires (choix du lead) | — (WF2) | — (demandé : ajouter ces chaînes à `FORBIDDEN` du test de build) | **Manquant** |
| Aucune logique métier critique dans le front (commission, frais, plafonds, solde, échéances) | CLAUDE.md r1..r5 ; `_socle-ecrans.md` S6, NC.7, NC.8, NC.10 | aucun écran métier | — | **Partiel** : règle posée dans les specs ; à vérifier écran par écran |
| Aucune valeur ni texte en dur ; tokens uniquement (r15, r18) | D2 §D ; `_socle-ecrans.md` §S14 | `packages/ui-tokens` ; `apps/web/tailwind.tokens.ts` | `generation.test.ts`, `contrast.test.ts` (87/87) ; `apps/web/test/conventions`, `test/tokens` | **Conforme** (socle ; dérogation `dev.*` : décision n° 21) |
| i18n FR/AR/EN, mêmes clés et variables dans les 3 langues ; FR par défaut | D2 A.4 ; `_socle-ecrans.md` S1 | `apps/web/src/i18n/*`, `src/messages/{fr,ar,en}/*` | `apps/web/test/i18n/catalogues.test.ts` | **Conforme** (socle) ; contenu des écrans à venir |
| RTL : propriétés logiques, `dir` posé par la locale, nombre LTR isolé | D2 A.5 ; `_socle-ecrans.md` S11 | `apps/web/src/i18n/direction.ts` | `catalogues.test.ts` (`ar` → `rtl`) ; prévu : revue FR + AR + petit écran | **Partiel** (socle posé ; écrans à venir) |
| WCAG 2.1 AA : contrastes, focus, cibles ≥ 44 px | D2 A.6 ; `_socle-ecrans.md` S10 | tokens `focus`, `*-text` ; `skip-link.tsx` | `contrast.test.ts` ; prévu : axe-core | **Partiel** |
| En-têtes de sécurité web : CSP à nonce stricte, `frame-ancestors`, Referrer-Policy, nosniff, HSTS (P0-F3) | BOARD P0-F3 | `apps/web/src/lib/security/headers.ts`, `src/proxy.ts` | `test/security/headers.test.ts`, `proxy.test.ts`, `e2e/production/security.spec.ts` | **Conforme** |
| Jetons : cookies HttpOnly, CSRF `X-CSRF-Token`, Origin (contrat §6) | D3 N.6 | `packages/api-client/src/index.ts` | `client.test.ts` | **Partiel** (qualite OK, securite OK ; conformite à rendre sur WB1) |
| shadcn/ui (stack ; titre de P0-F1) | CLAUDE.md « Stack » ; `dev-composants.md` | — (`components.json` absent) | — | **Manquant** (écart F1-C1, à traiter dans WF1) |
| Bibliothèque de composants `/dev/composants`, absente de la production | `dev-composants.md` (WD2, CONFORME) | — | — (prévu : test de non-présence après `next build`) | **Partiel** : spec conforme ; code WF1 Manquant |
| Pas d'intermédiaire (IR) ni de mandat | charte (« sans IR ») | grep des specs et de `apps/web` : aucune occurrence en dehors de « sans IR » | — | **Conforme** (à revérifier à chaque livraison) |

## 2. Commun (connexion, session, navigation, états)

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| Connexion e-mail/téléphone + mot de passe ; messages génériques ; mot de passe temporaire expiré → « mot de passe oublié » ou nouveau mot de passe par l'admin de l'organisation (décision n° 15) | 01 ; `commun-connexion.md` | `openapi.yaml` : `POST /v1/auth/login` | — (prévu : Playwright connexion) | **Partiel** : contrat et spec conformes ; spec à actualiser (n° 15) ; code Manquant (WF2) |
| Verrouillage : 5 échecs par couple (compte, IP ou appareil) → 15 min puis progressif ; seuil global 20 (décision n° 24) | 01 §3 (aligné) ; contrat §10 | contrat uniquement | — | **Partiel** : spec 01 alignée ; contrat à préciser (portée du verrouillage : `[DÉCISION]` de backend, tranchée par n° 24) |
| MFA TOTP obligatoire ADMIN / COMPANY / MERCHANT : défi, enrôlement, applications citées (n° 19), codes de secours (n° 10), téléphone perdu (n° 16) | 01 ; `commun-mfa.md` | `openapi.yaml` : `mfa/verify`, `mfa/enroll`, `mfa/enroll/confirm` | — | **Partiel** : défi et enrôlement spécifiés et au contrat ; **codes de secours et réinitialisation de la MFA par un administrateur absents de la spec et du contrat** (à ajouter) ; code Manquant |
| Mot de passe temporaire 72 h, changement forcé puis enrôlement MFA, pour les comptes web (décision n° 4) ; session restreinte 10 min, mot de passe actuel non redemandé (n° 20) | 01 §3 ; `commun-premiere-connexion.md` | `openapi.yaml` : `password/change`, `SessionResult.restrictedUntil` | — | **Partiel** : D-01 tranché provisoirement ; spec et contrat alignés entre eux ; code Manquant |
| Règles du mot de passe : 12 à 128 caractères, aucune composition, refus des mots compromis (liste locale) et de l'identifiant, pas d'expiration (n° 9) | décisions-provisoires n° 9 ; contrat `password-policy` | `openapi.yaml` : `GET /v1/auth/password-policy` | — | **Partiel** : valeurs décidées, à reporter dans le contrat (exemple actuel) |
| Mot de passe oublié : lien e-mail 15 min à jeton dans le fragment ; SMS 6 chiffres 10 min 5 essais si téléphone seul ; MFA jamais désactivée (n° 11) | 01 §5 ; `commun-mot-de-passe-oublie.md` ; n° 5 (périmètre confirmé) | `openapi.yaml` : `password/forgot`, `password/reset` (`x-pending-decision`) | — | **Partiel** : spec à mettre à jour (variante SMS), contrat à compléter (`x-pending-decision` à lever) |
| Sessions après changement de mot de passe : les autres fermées ; après réinitialisation, toutes (n° 12) | 01 ; contrat `password/change`, `password/reset` | contrat | — | **Partiel** (contrat à confirmer) |
| Session expirée / déconnecté ; avertissement 2 min avant ; inactivité 15 min, absolue 8 h (Entreprise, Commerçant) / 4 h (Administrateur) ; saisie gardée en mémoire seulement, 15 min (n° 1, 18) | D2 C.8.5 ; D3 N.6, N.9 ; `commun-session-expiree.md` | — | — (prévu) | **Partiel** : spec à actualiser avec les durées décidées ; contrat : `restrictedUntil` seul, durées de session (CT-X-6) absentes ; code Manquant |
| Hors connexion : bandeau, actions désactivées | D2 C.8.4 ; D3 N.7 | — | — | **Partiel** : spec conforme, code Manquant |
| 7 états obligatoires par écran | D2 C.8 ; `_socle-ecrans.md` S3 ; `commun-erreurs.md` | — | — | **Conforme** (spec) ; code Manquant |
| Pages 403 / 404 / 500 | D2 C.8.3, C.8.8, C.8.9 ; `commun-erreurs.md` | `apps/web/src/app/[locale]/not-found.tsx`, `error.tsx`, `[...rest]/page.tsx` (squelette) | `e2e/skeleton.spec.ts` | **Partiel** : squelette 404/500 ; contenu final selon la spec à coder (WF2) |
| Sidebar : logo, profil et rôle, modules du cahier §5.6, déconnexion, **sans changement de rôle** (n° 25, cahier §5.6 aligné) ; « Support » et « Statistiques » retirés (n° 6) | D3 N.1 | — (WF2) | — | **Partiel** : D3 conforme au cahier aligné (S-02 fermé) ; D3 à actualiser pour retirer Support et Statistiques ; code Manquant |
| En-tête : fil d'Ariane, utilisateur, badge de rôle, notifications, action principale | D3 N.2, N.8 | — | — | **Partiel** : « Mon profil » sans spec de destination (reste de S-06) |
| Notifications in-app (cloche, compteur) | 09 §1 ; D3 N.2, N.8 | — | — | **Partiel** : spec N.8 ; `GET /me/notifications` absent du contrat |
| Libellé « À régler » : « En attente de règlement » côté Commerçant, « À régler » côté Administrateur (n° 2) | cahier §5.5 (aligné) ; D2 C.3 | — | — | **Partiel** : cahier aligné ; D2 C.3 et specs WD3 à actualiser (clé de libellé distincte par espace) |
| Dates : dates métier en `Africa/Tunis`, horodatages techniques dans le fuseau de l'appareil (n° 3) | D2 A.4 (`businessTimeZone`) | — | — | **Partiel** : spec paramétrée, à figer selon n° 3 |
| Langue FR / AR / EN sur le web, sélecteur hors coquille | D3 N.2 ; WD1 | `apps/web/src/components/layout/locale-switcher.tsx` | `test/components/layout.test.tsx` | **Partiel** (sélecteur du squelette ; écrans à venir) |
| Composants : bouton, champ, badge, carte, toast, montant, squelette | D2 C.1 à C.7 | — (WF1) | — | **Conforme** (spec) ; code Manquant |
| Composants : tableau, modale, onglets, dépôt de fichier, étapes, ConfirmDialog, AmountBreakdown, ResultView… | `dev-composants.md` NC.1 à NC.14 | — (WF1) | — | **Conforme** (spec) ; code Manquant |
| Toasts : succès auto 4 s, erreur sans fermeture automatique | D2 C.5 | — | — | **Conforme** (spec) |
| Format d'erreur RFC 9457 : `code` testé, `messageKey` traduit, `title` jamais affiché, `requestId` en « Référence » | D2 A.2, C.9 ; contrat §4 | `packages/api-client` (`isProblem`) | `client.test.ts` | **Conforme** (spec et contrat) ; affichage Manquant |
| Pagination par curseur ; compteur borné facultatif `?withCount` (plafond 10 000, n° 23) | D2 A.8 ; NC.1 ; contrat §7 | contrat | — | **Conforme** (spec et contrat) |
| Tenant et rôle jamais envoyés par le client ; droits calculés par le serveur (`/v1/me` → `permissions[]`, n° 13) | D3 N.1 ; `_socle-ecrans.md` S8 | `packages/api-client` ; contrat `Me` | `client.test.ts` | **Partiel** : cases de la matrice des permissions non définies par les documents « soumises à l'utilisateur espace par espace » (n° 13) |

## 3. Administrateur (cahier §4.1, spec 04, spec 03, spec 08)

Spec fonctionnelle présente pour tous ; **aucune spec d'écran** (WD5 « À faire »), **aucune route** au contrat, aucun code.

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| ADM-01 Vue d'ensemble | 04 ; 09 §3 ; D2 C.4.5 | — (WF5) | — | **Manquant** |
| ADM-02 Gestion des comptes : liste, recherche, filtres, pagination, actions ; réinitialisation de la MFA en double validation (n° 16) | 04 ; NC.1, NC.2, NC.10 | — | — | **Manquant** |
| ADM-03 Création société, profil de commission **obligatoire** (RG-1.3 ; critère 1) | 03 §2 ; 04 | — | — (prévu : Playwright création de commerçant) | **Manquant** |
| ADM-04 Création commerçant : profil de commission, RIB, cycle de règlement | 03 ; 04 | — | — (prévu) | **Manquant** |
| ADM-05 KYC/KYB : documents, notes, rejeter / compléments / valider | 04 §2, §5 ; NC.3, NC.6 | — | — | **Manquant** |
| ADM-06 Transactions en temps réel, filtres, détail, export | 04 ; NC.14 | — | — | **Manquant** |
| ADM-07 Alertes fraude (statuts OUVERTE → EN_COURS → CLOSE, n° 14) | 04 §2 ; glossaire (aligné) | — | — | **Manquant** (statut d'alerte à ajouter au contrat) |
| ADM-08 Règlements : lots, historique des virements, fichiers bancaires, rapprochements, litiges (RG-6, RG-7 ; critère 7) — **ajouté au périmètre (n° 6)** | 08 ; module « Règlements & compensation » | — | — | **Manquant** (spec WD5 à rédiger) |
| ADM-09 Paramétrage : catégories, profils de commission (double validation, RG-1.7), plafonds, seuils, cycles | 03 ; 04 §2 | — | — | **Manquant** |
| ADM-10 Sécurité : journal d'audit, rôles internes, double validation, blocage/déblocage | 04 ; 09 §2 ; NC.10 | — | — | **Manquant** (rôles internes et blocage à inclure dans WD5) |
| ADM-11 Reporting (Should) | 04 ; 09 §3 | — | — | **Hors périmètre** (décision provisoire n° 6 : reporté) |
| ADM-12 Support (Should) | — | — | — | **Hors périmètre** (n° 6 : reporté, module retiré de la navigation) |
| ADM-13 Administration système (Should) | — | — | — | **Hors périmètre** (n° 6 : reporté) |

## 4. Entreprise (cahier §4.2, spec 05, spec 03)

Spec d'écran WD4 « À faire », aucune route au contrat, aucun code.

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| ENT-01 Tableau de bord (statut de lot ACTIF → EXPIRE, n° 14) | 05 ; D2 C.4.5 | — | — | **Manquant** |
| ENT-02 Commande de crédits avec **frais** : total = montant + frais (RG-1.4 ; E1), frais calculés par le serveur | 05 §2 ; 03 §2 ; NC.7 | — | — (prévu : Playwright commande de crédits) | **Manquant** |
| ENT-03 Suivi des commandes, factures, preuves de virement — **ajouté (n° 6)** | 05 §3 | — | — | **Manquant** (spec WD4 à rédiger) |
| ENT-04 Employés : liste, ajout manuel, import CSV (5 000 lignes / 5 Mo, doublons, aperçu, neutralisation des formules) | 05 §2 ; NC.6 (limites fournies par l'API) | — | — | **Manquant** |
| ENT-05 Mot de passe temporaire : génération, renvoi, réinitialisation (72 h) — **ajouté (n° 6)** | 01 §3 ; 05 | — | — | **Manquant** (spec WD4 à rédiger) |
| ENT-06 Attribution ; impossible d'attribuer plus que le solde | 05 §2 | — | — | **Manquant** (erreur « solde entreprise insuffisant » à définir au contrat Entreprise ; `INSUFFICIENT_FUNDS` est réservé au payeur) |
| ENT-07 Attribution récurrente (Should) | 05 §2 | — | — | **Hors périmètre** (n° 6 : reporté) |
| ENT-08 Reporting ; exports PDF/Excel asynchrones | 05 ; 09 §3 ; NC.14 | — | — | **Manquant** |
| ENT-09 Comptabilité (Should) | 05 | — | — | **Hors périmètre** (n° 6 : reporté) |
| ENT-10 Paramètres : société, utilisateurs et rôles, notifications | 01 §2 ; 05 | — | — | **Manquant** |
| RG-2.4 Une entreprise ne voit que ses employés | 01 §8 ; contrat §6 | — | — | **Manquant** (serveur ; le front n'envoie jamais le tenant) |

## 5. Commerçant (cahier §4.3, spec 07, spec 03, spec 08)

Specs d'écran WD3 : 6 fichiers reçus (tableau de bord, encaissement, résultat, historique, créances, virement), **ni verdict ux ni relecture conformite** ; règlements, factures et « mon commerce » non reçus. Aucune route au contrat, aucun code.

| Exigence (réf.) | Spec | Écran ou code | Test | Statut |
|---|---|---|---|---|
| COM-01 Tableau de bord (ventes du jour, en attente, réglé, commission, panier moyen, prochain règlement avec net estimé) | 07 ; `commercant-tableau-de-bord.md` (en attente de ux) | — | — | **Manquant** ; « commission » à confirmer contre RG-1.5 |
| COM-02 Scan QR par caméra | 07 §2 | — | — | **Hors périmètre** pour le web (décision provisoire n° 7 : réservé à l'app Pro ; mobile reporté, décision 2026-10-11) |
| COM-03 Saisie manuelle du code à 8 chiffres | 07 ; `commercant-encaissement.md` (en attente de ux) | — | — (prévu : Playwright encaissement) | **Manquant** |
| COM-04 Validation : prénom + initiale, matricule masqué, catégorie, montant, compte à rebours de 60 s fourni par le serveur (n° 8) ; « accepté » / « refusé » **sans solde ni motif** ; annulation tant que « Initié » (n° 17) | 07 §2 ; D2 C.8.11 ; NC.8 ; `commercant-encaissement.md`, `commercant-encaissement-resultat.md` (en attente de ux) | — | — | **Partiel** : règles décidées (n° 8, 17) ; écrans et code Manquants ; routes de paiement absentes du contrat |
| COM-05 Reçu : envoi e-mail/SMS, impression, nouveau scan — **ajouté (n° 6)** | 07 | — | — | **Manquant** |
| COM-06 Historique : filtres, recherche, export, pagination ; onglet du module Encaissement | 07 ; D3 N.1 ; `commercant-historique.md` (en attente de ux) | — | — | **Manquant** |
| COM-07 **Demande de virement avec simulation** (RG-1.5 ; E4/E5 ; critère 2) calculée par le serveur (`GET /payouts/quote`), taux figé (RG-1.6) | 03 §4 ; 07 §2 ; NC.7, NC.9 ; `commercant-virement.md` (en attente de ux) | — | — (prévu : Playwright simulation et demande) | **Manquant** (route absente du contrat) |
| COM-07 Seuil minimum de virement (E14) annoncé avant la saisie | 07 §2 ; 08 | — | — | **Manquant** |
| COM-08 Règlements : calendrier, délai moyen, factures, relevés, attestations — **ajouté (n° 6)** | 08 §2 ; `commercant-creances.md` (en attente de ux) | — | — | **Manquant** (règlements, factures, relevés, attestations : specs non reçues) |
| COM-09 Mon commerce (Should) : informations, RIB, points de vente, caissiers | 07 §2 ; NC.11 | — | — | **Manquant** (WD3 « mon commerce », non reçue ; non listé parmi les reportés de la décision n° 6) |
| COM-10 Contestations / annulations (Should) | 07 §2 | — | — | **Hors périmètre** (n° 6 : reporté ; l'annulation après confirmation figure dans la décision n° 17) |
| COM-11 QR caisse, mode hors ligne (Could) | cahier §1.3 | — | — | **Hors périmètre** (Could ; hors ligne exclu du MVP) |
| Le commerçant ne voit jamais le solde du client (CLAUDE.md r9) | 07 §2 ; contrat §4 | — | — | **Conforme** (spec D2 C.8.11 et contrat) ; écrans à vérifier |
| Rôles propriétaire / caissier / comptable, navigation par permissions | 01 §2 ; 07 §2 ; D3 | contrat `Me` | — | **Partiel** (matrice des permissions : n° 13) |
| Modules « Statistiques » et « Support » | — | — | — | **Hors périmètre** (n° 6 : retirés de la navigation) |

## 6. Exigences d'autres espaces (hors périmètre de cette matrice)

| Exigence | Statut |
|---|---|
| EMP-01 à EMP-08 (app Employé), comptes famille (RG-2.3), version mobile de COM-02 à COM-08 (app Pro) | **Hors périmètre** : mobile reporté (décision 2026-10-11) |
| API métier, Docker, PostgreSQL local, staging, CI (B6) | **Hors périmètre** : backend et Docker reportés (décision du 2026-10-12) ; seuls le contrat et le client généré évoluent |

## 7. Journal de mise à jour

| Date | Tâche relue | Lignes touchées | Verdict |
|---|---|---|---|
| 2026-10-11 | Création de la matrice ; vague 1 (B1, B2, D1, B4) ; specs D2 et D3 | tout | Vague 1 : B1 B2 D1 CONFORME, B4 non clôturable ; D2/D3 NON CONFORME |
| 2026-10-12 | Revérification D2/D3 ; WB2 contrat 0.2.0 ; WD1 et WD2 | §1, §2 | WB2 NON CONFORME (W-03) ; WD1 et WD2 NON CONFORMES au premier passage puis CONFORMES après correction (WD2 avec réserve D-03) |
| 2026-10-12 (reprise) | Décisions provisoires n° 1 à 25 ; F1 et F3 (apps/web) ; périmètre élargi | §1 à §6 | W-03, S-02, D-01 à D-04 : levés par les décisions n° 22, 25, 4, 7-8, 5, 21 ; **F3 CONFORME, F1 NON CONFORME (F1-C1 shadcn/ui)** ; WD1 à actualiser (n° 1, 10, 11, 15, 16, 18, 19) ; WD3 en attente de ux |

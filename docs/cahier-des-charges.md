# Cahier des charges – FlexiPay
**Plateforme de tickets-restaurant dématérialisés (Tunisie)**
Version 4.1 · 09/10/2026 · Contenu fonctionnel : premier cahier des charges · Habillage : charte graphique de la démo

> **v4.1 (09/10/2026)** : COM-04 sans solde ; membre famille limité à sa propre limite ; un compte = un tenant (MVP) ; fuseau Africa/Tunis ; statut « Confirmé » ; formats EN/AR ; toasts d'erreur persistants. Détail : `docs/handoff/decisions.md`.

---

## 1. Présentation

### 1.1 Objectif
FlexiPay remplace les tickets-restaurant papier par des **crédits virtuels** stockés dans des wallets. Une entreprise approvisionne la plateforme par virement, attribue des crédits à ses employés, qui paient chez des commerçants partenaires par QR code. Les commerçants sont ensuite réglés par virement bancaire, après déduction d'une commission.

### 1.2 Acteurs
| Acteur | Dashboard | Objectif | Accès |
|---|---|---|---|
| **Administrateur** | Back-office | Supervision globale, validation, paramétrage | Web |
| **Entreprise** (donneur de budget) | Espace Entreprise | Crédits, attribution, comptes employés, reporting | Web |
| **Commerçant** (receveur de bon) | Espace Commerçant | Encaissement, ventes, règlements | Web + Mobile |
| **Employé** (bénéficiaire) | App Mobile | Solde, paiement, historique, famille | Mobile |
| **Membre famille** | App Mobile | Paiement dans sa limite | Mobile |

### 1.3 Périmètre
- **MVP :** les 4 premiers acteurs + famille, catégorie Restauration, commissions paramétrables, règlement J+2.
- **Phase 2 :** catégories Habillement / Cadeaux / Carburant, mode hors ligne, intégrations ERP/paie. Le modèle de données les prévoit dès le départ.

---

## 2. Règles de gestion

### RG-1 Commissions
- **RG-1.1** Elles se gèrent dans *Administrateur → Paramétrage → Commissions*. Un **profil** comprend : code, libellé, taux % (par catégorie si besoin), minimum, statut, date d'effet.
- **RG-1.2** Deux familles de profils : **Entreprise** (frais de service sur commande) et **Commerçant** (commission de règlement).
- **RG-1.3** **À la création d'une société, l'administrateur choisit son profil dans une liste déroulante** (ex. *Standard 1 %*, *Premium 0,5 %*, *Négocié*). Même principe à la création d'un commerçant (ex. *Standard 2 %*, *Volume 1,5 %*). Modifiable avec historique et motif.
- **RG-1.4** **Entreprise :** frais ajoutés à la commande. Total à payer = montant + frais (ex. 50 000 + 1 % = 50 500 TND). Crédits ajoutés au wallet = 50 000 TND.
- **RG-1.5** **Commerçant :** crédité du **brut** à chaque paiement. La commission est prélevée **uniquement à sa demande de virement**. Avant confirmation, l'écran affiche : montant demandé, taux, commission, **net à recevoir** (45,00 − 0,90 = 44,10 TND).
- **RG-1.6** Le taux est **figé** à la validation de la demande ; aucun changement n'est rétroactif.
- **RG-1.7** Toute modification de grille : double validation (4 yeux) et journal d'audit.

### RG-2 Création des comptes
- **RG-2.1** Entreprise et commerçant : créés par l'administrateur après dossier **KYC/KYB** (registre de commerce, matricule fiscal, RIB, pièce d'identité du représentant).
- **RG-2.2** **Employés : créés par l'entreprise** (saisie manuelle ou import CSV : nom, prénom, email, téléphone, matricule). Le système génère un **mot de passe temporaire** (email/SMS), valable 72 h, avec **changement obligatoire** à la première connexion, puis création du PIN.
- **RG-2.3** **Comptes famille : créés par l'employé** depuis son profil, avec le même mécanisme. Nombre maximum paramétrable (par défaut 4), plafond individuel optionnel, suspension et suppression par l'employé. **Un membre famille ne voit que ce qui reste sur sa propre limite, jamais le solde de l'employé** (ni à l'écran, ni dans un message d'erreur). Barre basse de l'app pour un membre famille : Accueil · Payer · Historique · Profil.
- **RG-2.4** Une entreprise ne voit que ses employés ; un employé ne voit que sa famille.
- **RG-2.5** **MVP : un compte = un seul tenant** (une entreprise ou un commerçant). Le modèle de données prévoit une table d'appartenance (utilisateur ↔ tenant) pour ouvrir plus tard le multi-tenant, mais aucun changement de tenant en session dans le MVP.

### RG-3 Crédits, catégories, validité
- Catégories : Restauration (MVP), Habillement, Cadeaux, Carburant. Chacune a sa **validité** (ex. 30 / 90 / 60 / 30 jours) et son taux.
- Consommation par ordre d'expiration (FEFO). Alertes d'expiration à J-30 et J-7.
- Les crédits expirés sont tracés dans les rapports.

### RG-4 Plafonds et seuils (paramétrables)
Plafond journalier bénéficiaire (ex. 100 TND), plafond mensuel (ex. 2 000 TND), seuil de double validation (ex. 10 000 TND), seuil minimum de règlement (ex. 50 TND), cycle de règlement du commerçant (J+2 par défaut).
**Fuseau horaire des règles métier :** `Africa/Tunis` (jour et mois des plafonds, J+2, dates d'expiration, alertes J-30/J-7). L'API échange tous les horodatages en UTC.

### RG-5 Paiement
- QR **dynamique valable 60 s**, à usage unique, ou code manuel à 8 chiffres. Confirmation par PIN ou biométrie.
- Contrôles temps réel : solde suffisant, crédit valide, plafonds, commerçant actif et catégorie acceptée, antifraude.
- Le commerçant est crédité du brut ; le reçu est envoyé au client et au commerçant.
- **Côté commerçant, le résultat est seulement « accepté » ou « refusé »**, sans motif, sans montant et sans solde du client. Texte du refus : « Paiement refusé. Le client peut vérifier son application. » Le motif (solde insuffisant, plafond) n'est montré qu'au payeur.

### RG-6 Règlement du commerçant
Demande de virement libre ou cycle automatique J+2. Contrôles : solde virtuel suffisant, **RIB conforme à la raison sociale validée au KYC**, anti-blanchiment. L'administrateur peut aussi traiter des **lots de règlements** et exclure les transactions en litige.

### RG-7 Litiges
L'administrateur peut signaler une transaction en litige : elle est gelée jusqu'à résolution (confirmée, annulée avec remboursement, ou ajustée). Tout est journalisé.

---

## 3. Circuit financier

💶 argent réel · 🪙 crédits virtuels · 🔒 contrôle

**Phase 1 – Approvisionnement**
1. 💶 L'entreprise commande (50 000 TND + frais 1 %) et reçoit une facture proforma.
2. 💶 Virement vers le **compte de cantonnement (séquestre)**, délai 24–48 h.
3. 🔒 Rapprochement par l'équipe finance (double validation au-delà du seuil).
4. 🪙 Crédit du wallet entreprise (50 000 TND). Les frais sont un produit FlexiPay.

**Phase 2 – Attribution**
5. 🪙 Le RH attribue (ex. 200 TND à 250 employés) : unitaire, par lots, CSV, récurrent.
6. 🪙 Débit du wallet entreprise, crédit instantané des wallets employés, notification.

**Phase 3 – Consommation**
7. 🪙 L'employé scanne le QR du commerçant (45 TND) et confirme par PIN.
8. 🔒 Solde ? Crédit valide ? Plafond ? Commerçant actif ?
9. 🪙 Débit employé −45, crédit commerçant +45 brut. *Aucune commission à ce stade.*

**Phase 4 – Règlement**
10. Le commerçant clique sur « Demander un virement » (ou cycle automatique J+2).
11. 🔒 Simulation : 45,00 − 0,90 (2 %) = **44,10 TND net**, puis confirmation.
12. 🔒 Contrôle RIB / KYC / LAB-FT.
13. 💶 Virement depuis le compte de paiement ; la commission est un produit FlexiPay.
14. 💶 Réception sous 24 h, notification : « Virement de 44,10 TND effectué ».

**Comptes bancaires distincts :** séquestre, paiement, produits FlexiPay. **Comptabilité :** partie double, écritures immuables, contre-passation uniquement.

---

## 4. Exigences fonctionnelles

### 4.1 Back-office Administrateur
| ID | Exigence | Prio |
|---|---|---|
| ADM-01 | Vue d'ensemble : entreprises actives, commerçants actifs, crédits, volume/jour, litiges, tendances, actions urgentes | Must |
| ADM-02 | Gestion des comptes : liste, recherche, filtres (type, statut, date), pagination, actions (voir, valider, rejeter, suspendre) | Must |
| ADM-03 | Création société avec **liste déroulante du profil de commission** | Must |
| ADM-04 | Création commerçant avec **liste déroulante du profil de commission**, RIB, cycle de règlement | Must |
| ADM-05 | Validation KYC/KYB : documents (RC, matricule fiscal, RIB, identité), notes, rejeter / demander compléments / valider | Must |
| ADM-06 | Supervision des transactions en temps réel, filtres, détail, export | Must |
| ADM-07 | Alertes fraude (montant inhabituel, 3 transactions en 5 min) et investigation | Must |
| ADM-08 | Règlements : lots, historique des virements, fichiers bancaires, rapprochements, litiges | Must |
| ADM-09 | Paramétrage : catégories (validité), profils de commissions, plafonds, seuils, cycles | Must |
| ADM-10 | Sécurité : journal d'audit, rôles internes, double validation, blocage/déblocage | Must |
| ADM-11 | Reporting : volumes, performance par acteur, adoption, délai moyen de règlement, exports PDF/Excel | Should |
| ADM-12 | Support : tickets, remboursements, base de connaissances | Should |
| ADM-13 | Administration système : utilisateurs internes, intégrations (banque, SMS, email), logs | Should |

### 4.2 Espace Entreprise
| ID | Exigence | Prio |
|---|---|---|
| ENT-01 | Tableau de bord : portefeuille par catégorie, attribués, consommés %, expirés %, actions rapides | Must |
| ENT-02 | Commande de crédits : catégories, montants, date d'attribution, validité, récapitulatif avec **frais**, virement ou carte, proforma | Must |
| ENT-03 | Suivi des commandes (en cours, validées, historique), factures, preuves de virement | Must |
| ENT-04 | Gestion des employés : liste, ajout manuel, **import CSV** avec détection des doublons, groupes/départements, activation/désactivation, historique | Must |
| ENT-05 | **Mot de passe temporaire** : génération, renvoi, réinitialisation | Must |
| ENT-06 | Attribution : unitaire, par lots, CSV, option de notification, validité immédiate ou différée | Must |
| ENT-07 | Attribution récurrente mensuelle et règles (catégorie, département, ancienneté) | Should |
| ENT-08 | Reporting : par employé, département, commerçant, crédits expirés, évolution ; exports PDF/Excel | Must |
| ENT-09 | Comptabilité : écritures, rapprochement, attestations fiscales ; export ERP (phase 2) | Should |
| ENT-10 | Paramètres : société, utilisateurs et rôles (propriétaire, gestionnaire, comptable, lecture seule), notifications | Must |

### 4.3 Espace Commerçant (web + mobile)
| ID | Exigence | Prio |
|---|---|---|
| COM-01 | Tableau de bord : ventes du jour, en attente (J+2), réglé, commission, panier moyen, prochain règlement avec net estimé | Must |
| COM-02 | Encaissement par **scan QR** (caméra, flash, son) | Must |
| COM-03 | Saisie manuelle du code à 8 chiffres | Must |
| COM-04 | Écran de validation : client (prénom + initiale), matricule masqué, catégorie, montant, **compte à rebours du QR**, confirmation et annulation ; résultat « accepté » ou « refusé » uniquement, **sans solde ni motif** (v4.1) | Must |
| COM-05 | Reçu : envoi par email/SMS, impression, nouveau scan | Must |
| COM-06 | Historique des transactions : filtres (date, statut, montant), recherche, export, pagination | Must |
| COM-07 | **Demande de virement avec simulation** (montant, taux, commission, net) | Must |
| COM-08 | Suivi des règlements : calendrier (brut, commission, net), délai moyen, factures, relevés, attestations | Must |
| COM-09 | Mon commerce : informations, RIB, points de vente, caissiers et permissions, catégories acceptées | Should |
| COM-10 | Contestations et demandes d'annulation | Should |
| COM-11 | QR caisse (statique/dynamique) ; mode hors ligne | Could |

### 4.4 Application Employé (mobile)
| ID | Exigence | Prio |
|---|---|---|
| EMP-01 | Première connexion : changement du mot de passe temporaire, création du PIN/biométrie | Must |
| EMP-02 | Accueil : solde global, soldes par catégorie, alertes d'expiration, actions rapides | Must |
| EMP-03 | **Payer** : mon QR dynamique (60 s, luminosité max), scan du QR commerçant, saisie manuelle, confirmation PIN/biométrie, reçu | Must |
| EMP-04 | Historique : filtres (date, catégorie, montant, statut), détail, reçu PDF, export | Must |
| EMP-05 | **Compte famille** : création, modification, suspension, plafond individuel, mot de passe temporaire | Must |
| EMP-06 | Où dépenser : carte et liste des commerçants, filtres, horaires, itinéraire, favoris | Should |
| EMP-07 | Notifications : crédits reçus, expirations (J-30, J-7), transactions, promotions | Must |
| EMP-08 | Profil et sécurité : infos, PIN, biométrie, sessions actives, langue FR/AR/EN, thème clair/sombre, aide et support | Must |

---

## 5. Charte graphique (reprise de la démo)

### 5.1 Positionnement
Confiance, sécurité, simplicité, modernité, contrôle financier, efficacité. Base professionnelle **bleu nuit**, accents **verts** pour les crédits disponibles, validations et réussites. Pas de style bancaire froid ni d'interface surchargée.

### 5.2 Palette
| Rôle | Couleur | Usage |
|---|---|---|
| Bleu nuit | `#0B1D33` | Navigation, en-têtes, textes importants, boutons principaux |
| Bleu profond | `#12365A` | États actifs, panneaux |
| Vert émeraude | `#10B981` | Actions positives, soldes, validations |
| Vert clair | `#D1FAE5` | Fond des badges positifs |
| Fond général | `#F8FAFC` | Arrière-plan |
| Cartes | `#FFFFFF` | Cartes |
| Bordures | `#E2E8F0` | Bordures fines |
| Texte principal | `#0F172A` | Texte |
| Texte secondaire | `#64748B` | Labels |
| Texte discret | `#94A3B8` | Micro-infos |
| Attention | `#F59E0B` | Statuts uniquement |
| Erreur | `#DC2626` | Statuts uniquement |
| Information | `#2563EB` | Statuts uniquement |

Les couleurs fonctionnelles ne sont jamais décoratives.

### 5.3 Typographie
**Inter** ou Geist Sans. Titres 600/700, texte 400, labels 500, micro-infos 11–12 px en gris secondaire. **Montants en 700**, plus grands, devise réduite : **48 250,000** TND.

### 5.4 Grille et espacements
Mobile-first, largeur max desktop ≈ 1280 px, multiples de 4 et 8 px, cartes espacées de 16–24 px, sections de 24–40 px, padding mobile 16–20 px et desktop 24–32 px, Flexbox et Grid.

### 5.5 Composants
| Composant | Spécification |
|---|---|
| Cartes desktop | rayon 14–18 px, bordure fine, ombre très légère |
| Cartes mobiles | rayon 20–32 px |
| Boutons | rayon 10–12 px, une action principale visible |
| Champs | hauteur 40–44 px ; plafonds et erreurs indiqués avant validation |
| Badges | courts, sémantiques : *En attente*, *Validé*, *À régler*, *Réglé*, *Refusé*, *Suspect* |
| Toasts | vert pour la réussite (fermeture automatique) ; rouge pour les erreurs, **sans fermeture automatique** (WCAG 2.2.1) |
| Tables | filtrables, recherchables ; en cartes/listes sur mobile |
| Icônes | Lucide : WalletCards (solde), QrCode (paiement), Users (famille), Store (commerçants), ArrowUpRight (virements), FileText (factures), Check (validation), Settings2 (paramétrage) ; un label accompagne toute action ambiguë |

### 5.6 Navigation desktop
**Sidebar bleu nuit** : logo, profil et rôle actif, modules, élément actif en bleu légèrement contrasté, changement de rôle en bas. **En-tête** : fil d'Ariane, utilisateur, badge de rôle, notifications, action principale. Contenu sur `#F8FAFC`.

| Espace | Modules |
|---|---|
| Administrateur | Tableau de bord · Gestion des comptes · Transactions · Règlements & compensation · Paramétrage · Sécurité & conformité · Reporting · Support |
| Entreprise | Tableau de bord · Commandes · Bénéficiaires · Attributions · Reporting · Comptabilité · Paramètres · Support |
| Commerçant | Tableau de bord · Encaissement · Règlements & factures · Mon commerce · Statistiques · Support · Paramètres |

### 5.7 Navigation mobile
Écran centré type application : **header bleu nuit**, avatar rond, solde dans une carte blanche, wallets en grille 2 colonnes, actions rapides compactes, transactions en liste. **Barre basse : Accueil · Payer · Où dépenser · Historique · Profil.**

### 5.8 Principes UX
Une page = un objectif. Action principale visible. Montants lisibles en moins de 2 s. Statuts compréhensibles sans connaître le système. Confirmation visuelle pour toute opération sensible. Accessibilité : clavier, lecteurs d'écran, focus visible, cibles tactiles ≥ 44 px.

---

## 6. Exigences non fonctionnelles
| Domaine | Exigence |
|---|---|
| Sécurité | argon2/bcrypt, MFA (OTP) admin/entreprise/commerçant, blocage après 5 échecs, TLS 1.2+, chiffrement des données sensibles, QR signés et à usage unique, RBAC |
| Intégrité | Partie double, idempotence des paiements, aucune suppression |
| Performance | Paiement < 3 s ; ≥ 100 paiements/s en pointe de midi |
| Disponibilité | ≥ 99,5 % ; sauvegardes quotidiennes ; RPO 15 min ; RTO 4 h |
| Traçabilité | Audit de chaque action (qui, quoi, quand, avant/après) |
| Conformité | Cadre BCT des services de paiement, protection des données (INPDP), LAB/FT — **à valider par un juriste** |
| Compatibilité | Navigateurs récents ; Android 9+, iOS 14+ ; WCAG 2.1 AA |
| Langues | FR, AR (RTL), EN ; devise TND à 3 décimales. Formats : FR et AR `48 250,000 TND` (chiffres occidentaux en arabe) ; EN `48,250.000 TND` |

## 7. Modèle de données
`Utilisateur` · `Societe` (profil_commission_id) · `Commercant` (profil_commission_id, rib) · `ProfilCommission` · `HistoriqueCommission` · `Employe` (societe_id, matricule, must_change_password) · `MembreFamille` (employe_id, plafond) · `Commande` · `Wallet` · `Credit` (montant, expiration) · `Transaction` · `DemandeVirement` (montant, taux_snapshot, commission, net, statut) · `LotReglement` · `Litige` · `EcritureComptable` · `Notification` · `AuditLog`.

## 8. Statuts
- **Compte :** En attente KYC → Validé / Rejeté → Suspendu.
- **Commande :** Créée → Payée → Rapprochée → Créditée / Annulée.
- **Paiement (transaction) :** Initié → **Confirmé** → Réglé / Refusé / En litige (API : `INITIATED` → `CONFIRMED` → …).
- **Demande de virement :** Demandée → Contrôlée → Envoyée → Exécutée / Rejetée.

## 9. Critères d'acceptation
1. Créer une société sans profil de commission est refusé.
2. Un commerçant à 2 % demande 45,000 TND : l'écran affiche 0,900 de commission et **44,100 net** ; le taux est figé après confirmation.
3. Un employé créé par l'entreprise ne peut rien faire avant d'avoir changé son mot de passe temporaire.
4. Un paiement supérieur au solde ou au plafond journalier est bloqué avec un message clair.
5. Un QR utilisé deux fois ou âgé de plus de 60 s est rejeté.
6. La création d'un membre famille au-delà du maximum est refusée.
7. Une transaction en litige n'est pas incluse dans un lot de règlement.

## 10. Planning indicatif
| Lot | Contenu | Durée |
|---|---|---|
| 0 | Cadrage, UX/UI, architecture | 3 sem. |
| 1 | Back-office : comptes, KYC, commissions, paramétrage | 6–8 sem. |
| 2 | Espace Entreprise : commande, employés, attribution | 6 sem. |
| 3 | App Employé, paiement QR, famille, espace Commerçant | 8 sem. |
| 4 | Virements, simulation de commission, reporting, facturation | 5 sem. |
| 5 | Recette, tests de sécurité et de charge, pilote | 4 sem. |

## 11. Risques
Agrément ou partenariat bancaire · fraude QR · erreurs de rapprochement · adoption par les commerçants · mots de passe temporaires mal transmis (expiration et changement forcé).

## 12. Points à valider
1. Frais entreprise **ajoutés** à la commande (retenu) ou déduits ?
2. Les membres famille consomment-ils le solde de l'employé (retenu) ou ont-ils un solde propre ?
3. Remboursement ou report des crédits expirés ?
4. Règlement : demande libre, automatique J+2, ou les deux ?
5. TVA sur les commissions.

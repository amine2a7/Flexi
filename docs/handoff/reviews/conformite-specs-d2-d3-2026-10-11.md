# Revue de conformité : specs de design D2 (fondations-composants) et D3 (navigation)

- **Date :** 2026-10-11 · **Relecteur :** conformite · **Type :** relecture de spec avant code (rétroactive : D2/D3 ont été livrées avant la création des relecteurs)
- **Base :** `docs/design/specs/fondations-composants.md` et `navigation.md` à HEAD 12c66bf. **D2 est en cours de modification dans l'arbre de travail** (design intègre les constats ux : UX-03 à UX-07, UX-12, UX-13, `AmountBreakdown`, date d'affichage) et renvoie à un fichier `dev-composants.md` qui n'existe pas encore ; la présente revue vaut pour l'état commité et sera complétée au `[SPEC]` de WD2.
- **Références :** cahier v4.1 (§4, §5, §6, RG-1 à RG-7), glossaire, specs 01/03/04/05/07/08/09, charte, `figma-handoff.md`, `decisions.md`, contrat `openapi.yaml` (`82bf61bd…`), revue ux `ux-d2-d3-2026-10-11.md` (À REVOIR).
- **Revues préalables :** ux **À REVOIR** (aucun Bloquant, 12 Important). securite : non demandée pour D2/D3 (pas d'auth ni d'argent en tant que tel ; `returnTo` et stockage hors connexion signalés à securite par design).

## Verdict : NON CONFORME (6 écarts ouverts, 2 `[DÉCISION]`)

Aucune règle interdite n'a été trouvée (pas d'IR ni de mandat, pas de solde au commerçant, pas de calcul de commission dans le front). Les écarts sont des oublis par rapport au cahier et à la charte, une règle de navigation du cahier non alignée, et des valeurs d'interface sans source. Ils sont corrigeables dans WD2/WD1 ; **D2/D3 ne doivent pas être codées (F2, WF1) avant leur correction**.

## Tableau de conformité

| Exigence ou critère | Référence | Constaté | Statut |
|---|---|---|---|
| Montants en millimes entiers, formatage unique côté client, formats FR/AR `48 250,000` et EN `48,250.000` | cahier §5.3, §6 ; décision 2026-10-09 ; glossaire | D2 A.1 (exemples E3/E4, bornes), C.6 | Conforme |
| Erreurs RFC 9457 : `code` testé, `messageKey` traduit, `title` jamais affiché ; matrice complète | contrat §4 | D2 A.2, C.9 : 21 codes du contrat tous présents | Conforme |
| Statuts du glossaire et mapping enums API → badges ; repli sur valeur inconnue | cahier §5.5, §8 ; glossaire ; contrat §9 | D2 A.3, C.3 : 5 enums, 22 valeurs ; « Confirmé » / `CONFIRMED` (décision 2026-10-09) | Conforme |
| Badges du cahier : En attente, Validé, À régler, Réglé, Refusé, Suspect | cahier §5.5 | présents (C.3, tokens `status`) | Conforme |
| Statuts dérivés côté client `A_REGLER`, `EXPIRE`, `SUSPECT` | règle « aucune logique métier critique dans le front » | D2 C.3 : `A_REGLER` = `CONFIRMED` non `SETTLED`, calculé dans le client | **Écart S-03** |
| Toasts : succès auto 4 s, erreur sans fermeture automatique | cahier §5.5 ; décision 2026-10-09 | D2 C.5 | Conforme |
| Composants du cahier §5.5 : cartes, boutons (un principal), champs (plafonds et erreurs avant validation), badges | cahier §5.5 ; charte §5 | D2 C.1, C.2, C.3, C.4 | Conforme |
| Composants **tableau** (filtrable, recherchable, en cartes sur mobile) et **modale** (confirmation de toute action sensible) | cahier §5.5 « Tables » ; charte §5 « Tableau », « Modale » ; figma-handoff `01 Composants` | D2 : tableau et modale cités sans spécification (A.7, A.8, C.1 « modale de confirmation ») | **Écart S-01** |
| 7 états obligatoires par écran | charte §7 | D2 C.8.1 à C.8.8 | Conforme |
| Solde insuffisant réservé au payeur ; refus générique pour le commerçant, texte exact « Paiement refusé. Le client peut vérifier son application. » | cahier RG-5 ; décisions 2026-10-09 ; contrat §4 | D2 C.8.6, C.8.11 | Conforme |
| Membre famille : jamais le solde de l'employé | RG-2.3 ; décision 2026-10-09 | D2 C.4.3, C.8.6, C.8.7 (mobile) | Conforme (hors périmètre web) |
| Idempotence : même clé après échec réseau/5xx, nouvelle clé après refus 422 | contrat §5 ; CLAUDE.md r4 | D2 C.8.3 | Conforme |
| Pagination par curseur, sans total | contrat §7 | D2 A.8 | Conforme |
| Sidebar : logo, profil et rôle, modules, déconnexion ; modules et ordre des 3 espaces | cahier §5.6 | D3 N.1 : libellés repris à l'identique (8 + 8 + 7) | Conforme |
| Sidebar : « changement de rôle en bas » | cahier §5.6 (ligne 205 : « changement de rôle en bas ») | D3 N.1 : retiré ; §F.1bis « en attente de décision » ; aucune entrée dans `decisions.md` ; cahier non modifié | **Écart S-02** |
| En-tête : fil d'Ariane, utilisateur, badge de rôle, notifications, action principale | cahier §5.6 | D3 N.2 | Conforme ; destinations « Mon profil » et panneau de notifications sans spec : **écart S-06** |
| Un compte = un tenant ; aucun changement de tenant ; le client n'envoie jamais le tenant | RG-2.5 ; décision 2026-10-09 ; contrat §6 | D3 N.1 | Conforme |
| Historique commerçant = onglet du module Encaissement | décision 2026-10-09 | D3 N.1 | Conforme |
| Rôles et sous-rôles : ADMIN (super-admin, finance, support, conformité), COMPANY (propriétaire, gestionnaire, comptable, lecture seule), MERCHANT (propriétaire, caissier, comptable) | spec 01 §2 ; spec 05 ; spec 07 §2 | D3 « Libellés de rôle » | Conforme (enums « à confirmer ») |
| Session expirée / déconnecté ; hors connexion ; aucune donnée de l'écran précédent conservée | charte §7, §10 ; contrat §4 | D3 N.6, N.7 ; D2 C.8.4, C.8.5 | Conforme (avertissement avant expiration : ux UX-17) |
| Accessibilité WCAG 2.1 AA, cibles ≥ 44 px, contrastes calculés | cahier §6 | D2 A.6, §D.2 ; D1 `contrast.test.ts` (87/87) | Conforme |
| RTL : propriétés logiques, miroir des icônes directionnelles, nombre LTR isolé | cahier §6 ; charte §9 | D2 A.5 ; D3 §6 de chaque section | Conforme |
| i18n FR/AR/EN, aucune chaîne en dur | CLAUDE.md r15 | D2 A.4 : FR de référence ; AR/EN « traduits par l'équipe de traduction » | Conforme (traductions AR/EN à produire avant F1/F2 ; non inventées) |
| Aucune valeur en dur (tokens) | CLAUDE.md r18 ; D2 « règle d'or » | tokens tous référencés ; constantes d'interface (10 s, « 99+ », 3 lignes de squelette, 10 s / 30 s d'annonce) sans source | **Écart S-05** (Basse) |
| Pas d'intermédiaire (IR), pas de mandat | CLAUDE.md « Acteurs » | aucune occurrence dans D2, D3 (la charte écrit « sans IR ») | Conforme |
| COM-07 : brut → taux → commission → net, taux figé, calculs serveur | RG-1.5, RG-1.6 ; spec 03 §6 | D2 C.6 : ordre d'affichage et exemple E4 ; ne dit pas explicitement que les valeurs viennent de `GET /payouts/quote` ; dans l'arbre de travail, `AmountBreakdown` ajouté | Partiel : à compléter dans WD3 (« le front n'affiche que ce que l'API renvoie ») |
| Clé du badge de repli | D2 C.3 ; tokens | clé de statut `INCONNU`, libellé `status.UNKNOWN` : la règle « clé = `status.<KEY>` » n'est pas respectée pour ce seul cas | **Écart S-04** (Basse) |

## Écarts

```
[CONSTAT] S-01 Composants tableau, modale, onglets, dépôt de fichier, étapes non spécifiés
Type : Oublié
Référence : cahier §5.5 (« Tables : filtrables, recherchables ; en cartes/listes sur mobile »), charte §5 (« Tableau : en-tête collant, tri, filtres, pagination » ; « Modale : confirmation visuelle pour toute action sensible »), figma-handoff `01 Composants` (tableaux, modales) ; spec 05 (import CSV, aperçu) ; BOARD WD2
Constaté : D2 cite la modale (C.1 `destructive`) et le tableau (A.7, A.8) sans les décrire ; D3 utilise des onglets (Paramétrage, Encaissement) et un `Sheet` sans composant dédié. Pas de spec de dépôt de fichier ni d'étapes (ENT-02, ENT-04, ADM-05).
Correctif attendu : WD2 spécifie `DataTable` (colonnes, tri, filtres, carte mobile), `ConfirmDialog`, `Tabs`, `FileDrop`, `Stepper`, avec les 7 états de la charte §7 (recoupe ux UX-01, UX-02, UX-09). Propriétaire : design.
```

```
[CONSTAT] S-02 « Changement de rôle en bas » (cahier §5.6) retiré de la sidebar sans décision consignée
Type : Non conforme à la référence (cahier non aligné)
Référence : cahier §5.6 « changement de rôle en bas » ; RG-2.5 ; décision du 2026-10-09 (un compte = un tenant, pas de changement de tenant en session) ; BOARD P0-D5 (suppression de « Changer d'espace », S8-01)
Constaté : la décision exclut le changement de **tenant**; aucune décision ne dit si le « changement de rôle » du cahier (par exemple entre sous-rôles) disparaît. D3 §F.1bis déclare l'élément « en attente de décision » et ne l'inclut pas ; le cahier le conserve.
Correctif attendu : `[DÉCISION]` à `main` (recommandation de conformite : supprimer la mention du cahier §5.6, la décision du 2026-10-09 rendant un changement de rôle sans objet, et le consigner dans `decisions.md`). Propriétaires : main (cahier et décision), design (D3 §F.1bis).
```

```
[CONSTAT] S-03 Statuts dérivés calculés dans le client (A_REGLER, EXPIRE, SUSPECT)
Type : Interdit (risque) : logique métier dans le front
Référence : plan « web d'abord » (aucune logique métier critique dans le front) ; CLAUDE.md r1-r5 ; glossaire (« Créance » = paiements non réglés) ; RG-3, ADM-07
Constaté : D2 C.3 : « A_REGLER = paiement CONFIRMED non SETTLED », « EXPIRE = lot dont expiresAt est passé », « SUSPECT = alerte fraude », « dérivés côté client, hypothèse soumise à backend ». Une règle de gestion (créance en attente J+2, expiration en Africa/Tunis, alerte) serait recalculée dans le front, avec l'heure de l'appareil pour EXPIRE.
Correctif attendu : demander à backend (WB2) un champ ou un statut fourni par le serveur pour ces trois cas, et décrire le badge comme un simple affichage de ce champ. Le libellé de `A_REGLER` côté commerçant (ux UX-10, cahier §5.5 le nomme « À régler ») reste une `[DÉCISION]` déjà transmise à `main` par ux. Propriétaire : design (spec), backend (contrat).
```

```
[CONSTAT] S-04 Clé i18n du badge de repli incohérente
Type : Non conforme à la référence (interne)
Référence : D2 C.3 §4 (« clé `status.<KEY>` ») ; `design-tokens.json` (`INCONNU` → `labelKey: status.UNKNOWN`)
Constaté : toutes les clés suivent `status.<KEY>` sauf le repli (`INCONNU` / `status.UNKNOWN`).
Correctif attendu : choisir une seule forme (`status.INCONNU` ou renommer la clé) dans D2 et les tokens. Propriétaire : design.
```

```
[CONSTAT] S-05 Constantes d'interface sans source unique
Type : Non conforme à la référence (principe « aucune valeur en dur »)
Référence : plan « web d'abord » ; CLAUDE.md r18 ; D2 « règle d'or »
Constaté : seuil de lenteur 10 s (C.8.1), plafond du compteur « 99+ » (D3 N.2), 3 lignes de squelette en fin de liste (A.8), fréquences d'annonce 10 s et 30 s (C.8, ux UX-17), délai avant squelette `motion.base` : aucun n'est un token ni une constante nommée (D2 précise que le 10 s est « une proposition de design, sans règle métier »).
Correctif attendu : nommer ces valeurs (module de constantes d'interface côté frontend, ou groupe de tokens `ui` dans `design-tokens.json`) et le dire dans la spec. Propriétaire : design.
```

```
[CONSTAT] S-06 Destinations de navigation sans spec ni exigence
Type : Oublié
Référence : cahier §5.6 (modules Statistiques, Support, Comptabilité, Reporting ; notifications) ; D3 N.1, N.2 ; BOARD WD3/WD4/WD5
Constaté : « Mon profil » (menu du compte), le panneau de notifications, les modules « Support » (3 espaces) et « Statistiques » (Commerçant) existent dans la navigation sans exigence détaillée (ADM-12 Should, aucun ID pour Statistiques), sans spec d'écran ni tâche (voir `conformite-bord-vague1-2026-10-11.md`, B-04).
Correctif attendu : après la `[DÉCISION]` de `main` sur le périmètre (B-04), soit spécifier ces écrans, soit retirer les entrées de la sidebar et du menu du compte. Propriétaires : main (décision), design.
```

### Décisions manquantes, à `main`

```
[DÉCISION] D-01 Premier mot de passe des utilisateurs du web
Contexte : RG-2.2 définit le mot de passe temporaire (72 h, changement forcé) pour les employés et membres famille. Entreprise, commerçant et administrateurs sont « créés par l'administrateur » (RG-2.1) ; aucun document ne dit comment leur premier accès est délivré, ni si la séquence « mot de passe temporaire → changement → MFA » (WD1, première connexion) s'applique à eux. Le contrat prévoit pourtant `PASSWORD_CHANGE_REQUIRED` pour tous. Politique de mot de passe (longueur, complexité) et codes de secours MFA : aussi absents (design a déjà signalé les deux).
Recommandation : appliquer le même mécanisme (mot de passe temporaire envoyé par email/SMS, 72 h, changement obligatoire, puis enrôlement MFA) aux comptes créés par l'administrateur ; fixer la politique avec securite (ASVS 5.0).
```

```
[DÉCISION] D-02 Validité du code manuel à 8 chiffres et compte à rebours côté commerçant
Contexte : RG-5 : « QR dynamique valable 60 s, à usage unique, ou code manuel à 8 chiffres » ; COM-04 exige un « compte à rebours du QR ». Aucun texte ne dit si le code manuel porte la même validité de 60 s, ni s'il existe un compte à rebours pour la saisie manuelle (seul parcours prévu pour le web).
Recommandation : même durée de 60 s et même compte à rebours que le QR (fournis par le serveur), à confirmer avant WD3.
```

(Les décisions B-04 périmètre et B-06 scan web sont dans `conformite-bord-vague1-2026-10-11.md` ; S-02 est ci-dessus.)

## Points à surveiller dans les specs suivantes (WD1 à WD5)

1. Tout nombre affiché (commission, frais, net, plafond, reste, échéance, pourcentage) vient d'un champ de l'API ; la spec doit nommer l'endpoint (`_besoins-contrat.md` pose déjà la règle, à reprendre dans chaque spec).
2. Écrans commerçant : aucun solde, aucun motif de refus, aucun montant dans le refus (E7/E8 réservés au payeur).
3. Création société et commerçant : liste déroulante limitée aux profils actifs du bon type, champ **obligatoire**, refus sans profil (critère d'acceptation 1).
4. Commissions : double validation visible (initiateur ≠ approbateur), motif obligatoire, jamais rétroactif (RG-1.6, RG-1.7, ux UX-08).
5. Import CSV : 5 000 lignes / 5 Mo, doublons (matricule, email, téléphone), aperçu avant import, neutralisation des formules (spec 05).
6. Lots de règlement : exclusion des transactions en litige (critère 7), double validation au-delà du seuil.
7. Dates : en attente de la `[DÉCISION]` de `main` sur le fuseau d'affichage (ux UX-15) ; D2 prévoit déjà un paramètre unique, valeur par défaut `Africa/Tunis`.
8. Données fictives : exactement les types du contrat (millimes entiers, `Problem`, énumérations du glossaire) ; MSW absent du build de production, prouvé par test.

## Non vérifié

1. Ajouts en cours dans D2 (arbre de travail) et `dev-composants.md` : fichier absent, non relu.
2. Textes AR et EN : non produits (D2 ne fournit que le FR de référence).
3. Cohérence des specs avec des écrans réels : aucun écran n'existe.
4. Contrastes recalculés par conformite : non (repris de D1, test 87/87 relancé).
5. Spec 02 (ledger) et spec 06 (employé) non relues : hors périmètre web.

# Revue de conformité : WD2 (bibliothèque de composants) et WD1 (Commun : authentification, session, erreurs)

- **Date :** 2026-10-12 · **Relecteur :** conformite · **Type :** relecture de spec avant code · **Branche :** `feat/web`
- **Base :** `docs/design/specs/` (non commité) : `dev-composants.md`, `_socle-ecrans.md`, `fondations-composants.md` et `navigation.md` révisés (WD2) ; `commun-connexion.md`, `commun-premiere-connexion.md`, `commun-mfa.md`, `commun-session-expiree.md`, `commun-erreurs.md`, `commun-mot-de-passe-oublie.md` (WD1). Références : cahier v4.1, glossaire, spec 01, charte, `figma-handoff.md`, `decisions.md`, contrat `openapi.yaml` 0.2.0 (SHA-256 `b3ff68ba…`), `_besoins-contrat.md`.
- **Revues préalables présentes :** ux **OK** (`ux-wd1-wd2-2026-10-12.md` : WD2 1 Important R-01 ; WD1 4 Important N-01 à N-04) ; securite **OK** sur WD1 (`securite-wd1-specs-auth-2026-10-12.md` : 1 Moyenne backend, 2 Basses design). Design (fidélité) : sans objet avant le code.

## Verdicts

| Lot | Verdict conformité | Écarts ouverts |
|---|---|---|
| **WD2** (`dev-composants.md`, `_socle-ecrans.md`, `fondations-composants.md`, `navigation.md`) | **NON CONFORME** | WD-05, WD-06, WD-07 (+ décision D-03) |
| **WD1** (`commun-*.md`) | **NON CONFORME** | WD-01 à WD-04 (+ décisions D-01 déjà transmise, D-04) |

Aucun interdit, aucune règle métier inventée. Les écarts sont des divergences avec le contrat 0.2.0, publié après la rédaction des specs, ou des oublis de table. Ils sont tous corrigeables par design en une passe courte ; je revérifie dès le `[CORRIGÉ]`. Les specs ne doivent pas être codées (WF1, WF2) avant.

## Tableau de conformité

| Exigence ou critère | Référence | Constaté | Statut |
|---|---|---|---|
| Aucune règle inventée : politique de mot de passe, codes de secours MFA, mécanisme de réinitialisation, durées de session, conservation de la saisie | CLAUDE.md « Pas d'invention » ; décisions | tous laissés « en attente de décision » ; `PasswordPolicy` fournie par l'API ; durées de session de l'API (CT-X-6) ; aucun écran de codes de secours | Conforme |
| Le front n'affiche que ce que l'API renvoie (aucun calcul de commission, frais, total, plafond, solde, échéance) | plan « web d'abord » ; CLAUDE.md r1-r5 | `_socle-ecrans.md` S6, NC.7 (« aucun calcul »), NC.8 (expiration décidée par l'API), NC.10 (`canApprove` lu), NC.11 (valeur masquée par l'API) | Conforme |
| Connexion : identifiant e-mail/téléphone + mot de passe, message générique unique, aucun « compte verrouillé » | spec 01 §3, §5 | `commun-connexion.md` §5-6 | Conforme |
| MFA TOTP obligatoire (défi et enrôlement), aucun nom d'application imposé | cahier §6 ; spec 01 §3 | `commun-mfa.md` | Conforme sauf WD-02, WD-03 |
| Mot de passe temporaire : changement obligatoire, bannière, PIN et biométrie exclus du web | RG-2.2 ; charte §10 ; critère d'acceptation 3 | `commun-premiere-connexion.md` | Conforme sauf WD-01, WD-02 |
| Mot de passe oublié : réponse identique, canal non révélé | spec 01 §5 ; contrat §4 | `commun-mot-de-passe-oublie.md` | Conforme (périmètre : D-04) |
| Session expirée / déconnecté : un refresh silencieux, cause jamais indiquée, avertissement préalable | contrat §4 ; WCAG 2.2.1 | `commun-session-expiree.md`, N.9 | Conforme sauf WD-04 |
| Pages 404 / 500 : 404 indistinguable (inexistant / autre tenant) ; aucune fuite technique | contrat §4 | `commun-erreurs.md` | Conforme |
| Sept états obligatoires par écran + mapping unique | charte §7 | `_socle-ecrans.md` S3 | Conforme |
| Refus de paiement commerçant : texte exact, sans motif, montant ni solde | cahier RG-5 ; décision 2026-10-09 | `fondations-composants.md` C.8.11 | Conforme |
| Composants du cahier §5.5 et de `figma-handoff` (tableau, modale, onglets, dépôt de fichier, étapes) | cahier §5.5 ; charte §5 | NC.1 à NC.6 (S-01 fermé) | Conforme |
| Page `/dev/composants` : absente du build de production (preuve par test), données synthétiques du glossaire, sans appel API | décision 2026-10-11 ; décision 2026-10-09 (données de test) | §2 (test après `next build`), §11.4 | Conforme |
| Toasts : erreur sans fermeture automatique ; conflit d'état en bandeau persistant | décision 2026-10-09 ; ux UX-07 | C.5, C.8.10 ; **mais** matrice C.9 l.430 dit encore « Toast info + Actualiser » | Écart WD-05 |
| Matrice « réponse API → présentation » complète pour le catalogue du contrat | contrat §4 | C.9 sans `MFA_CODE_INVALID`, `MFA_CHALLENGE_EXPIRED`, `MFA_ENROLLMENT_REQUIRED`, `PASSWORD_POLICY_VIOLATION` | Écart WD-05 |
| Constantes d'interface nommées, aucune valeur en dur | CLAUDE.md r18 ; S-05 | `_socle-ecrans.md` S14 ; restent des littéraux (NC.3 « 90 % », NC.12 « ≥ 2 s ») | Écart WD-07 (Basse) |
| i18n FR/AR/EN : aucune chaîne en dur | CLAUDE.md r15 | clés partout ; dérogation AR/EN pour `dev.*` (`dev-composants.md` §10) | Décision D-03 |
| Compteur `page.count` | contrat §7 (toutes les listes) | S5 et NC.1 : « listes Administrateur » seulement | Écart WD-06 (Basse) |
| Pas d'intermédiaire (IR), pas de mandat | CLAUDE.md « Acteurs » | aucune occurrence | Conforme |

## Écarts

```
[CONSTAT] WD-01 Séquence de première connexion contraire au contrat
Type : Non conforme au contrat
Référence : openapi.yaml §10 (« la MFA est toujours vérifiée avant d'ouvrir une session, même partielle ») ; commun-premiere-connexion.md §3 « Après succès »
Constaté : « MFA déjà enrôlée → /login/mfa » après le changement de mot de passe. Dans le contrat, le défi MFA précède la session : `mfa/verify` renvoie `nextStep: PASSWORD_CHANGE` ; après `password/change`, `nextStep` vaut `MFA_ENROLL` (non enrôlée) ou `NONE`, jamais `MFA_CHALLENGE`. Même point dans `commun-connexion.md` §3 (parcours après succès) à vérifier.
Correctif attendu : réécrire le parcours selon §10 : login → [MFA_CHALLENGE → mfa/verify] → [PASSWORD_CHANGE] → [MFA_ENROLL] → NONE.
```

```
[CONSTAT] WD-02 Codes et clés proposés (état « N ») différents du contrat publié
Type : Non conforme au contrat
Référence : openapi.yaml 0.2.0 (`FieldErrorCode`, `ProblemCode`, `PasswordPolicyRuleCode`, §10) ; `commun-premiere-connexion.md` §5 et §7, `commun-mfa.md` §5-7, `commun-connexion.md` §2 et §6, `_besoins-contrat.md`
Constaté :
 - codes de champ `PASSWORD_TOO_WEAK` / `PASSWORD_REUSED` et clés `errors.field.passwordTooWeak|passwordReused` ; le contrat définit `PASSWORD_POLICY_VIOLATION` (une entrée par règle non respectée, `params.rule`) et `CURRENT_PASSWORD_INVALID` ;
 - règles du mot de passe en `auth.passwordChange.rule.<CODE>` ; le contrat prévoit les clés `passwordPolicy.rule.<codeEnCamelCase>` ;
 - défi MFA expiré rendu par `401 UNAUTHENTICATED` ; le contrat définit `401 MFA_CHALLENGE_EXPIRED` ; code faux : `MFA_CODE_INVALID` ou `INVALID_CREDENTIALS` (alternative) alors que le contrat fixe `MFA_CODE_INVALID` ;
 - employé ou membre famille sur le web : spec « INVALID_CREDENTIALS ou FORBIDDEN » ; le contrat fixe `403 FORBIDDEN` (provisoire) ;
 - longueur du code « à confirmer » : le contrat fixe 6 chiffres (provisoire).
Correctif attendu : aligner les specs et la section « Données et contrat » (statut E) sur le contrat 0.2.0.
```

```
[CONSTAT] WD-03 QR d'enrôlement : la spec recommande une option que le contrat n'a pas retenue
Type : Non conforme au contrat (et dépendance à valider)
Référence : openapi.yaml `MfaEnrollment` (`otpauthUri`, `secretBase32`, pas de `qrCodeSvg`) ; `commun-mfa.md` §7 (option (a) recommandée) ; décision du 2026-10-11 (chaque nouvelle dépendance est validée par l'utilisateur)
Constaté : le contrat impose la génération du QR côté client. Une bibliothèque de QR est alors une dépendance nouvelle de `apps/web`, à justifier et à faire valider par l'utilisateur après securite.
Correctif attendu : design retient l'option (b) dans la spec ; frontend propose la dépendance dans son `[LIVRÉ]` de F1/WF2 (justification, version publiée depuis plus de 14 jours).
```

```
[CONSTAT] WD-04 `returnTo` « revalidé au serveur à la connexion » : aucun paramètre au contrat
Type : Non conforme au contrat
Référence : `commun-session-expiree.md` §3.1 ; `commun-connexion.md` §3 et §11 ; openapi.yaml `LoginRequest` (`identifier`, `password`)
Constaté : la spec dit que le chemin de retour est revalidé côté serveur ; `POST /v1/auth/login` n'a pas de paramètre `returnTo` et ne renvoie aucune URL. La revalidation n'existe que côté client.
Correctif attendu : écrire « validé côté client (liste blanche de routes de l'espace du rôle) » ; si une validation serveur est voulue, `[QUESTION]` à backend.
```

```
[CONSTAT] WD-05 Matrice C.9 : conflit d'état encore en toast, nouveaux codes absents
Type : Oublié
Référence : `fondations-composants.md` C.9 (l.430 ; catalogue) ; contrat §4 ; ux R-01
Constaté : (1) `RESOURCE_STATE_CONFLICT` → « Toast info + Actualiser », en contradiction avec C.8.10 et S7.5 (déjà relevé par ux, R-01) ; (2) les codes ajoutés par WB2 (`MFA_CODE_INVALID`, `MFA_CHALLENGE_EXPIRED`, `MFA_ENROLLMENT_REQUIRED`, champ `PASSWORD_POLICY_VIOLATION` / `CURRENT_PASSWORD_INVALID`) n'ont pas de ligne. La matrice est la table de codage du gestionnaire d'erreurs ; un code absent ne reçoit aucune présentation.
Correctif attendu : corriger la cellule (bandeau persistant) et ajouter les lignes manquantes (présentation, clé `errors.*`).
```

```
[CONSTAT] WD-06 Compteur borné limité aux listes Administrateur
Type : Non conforme au contrat
Référence : openapi.yaml §7 (« convention commune à toutes les listes paginées ») ; `_socle-ecrans.md` S5, `dev-composants.md` NC.1, `_besoins-contrat.md` CT-X-1 ; ux R-02
Constaté : les specs réservent le compteur à l'Administrateur ; le contrat l'ouvre à toutes les listes.
Correctif attendu : écrire « disponible sur toute liste ; affiché là où l'écran le demande ».
```

```
[CONSTAT] WD-07 Littéraux d'interface hors de S14
Type : Non conforme à la référence (principe « aucune valeur en dur »)
Référence : CLAUDE.md r18 ; S-05
Constaté : « hauteur max 90 % de la fenêtre » (NC.3 §8), « Copié (≥ 2 s) » (NC.12, déjà `UI.copiedFeedbackMs`), facteurs d'essai 100/150/200 % (explicitement des facteurs d'outil : acceptés) ; le 90 % n'est ni un token ni une constante nommée.
Correctif attendu : nommer la valeur (token ou `UI.*`) ou la retirer.
```

### Décisions manquantes, à `main`

```
[DÉCISION] D-03 Dérogation de traduction des clés `dev.*`
Contexte : `dev-composants.md` §10 : les libellés de l'outil `/dev/composants` (`dev.*`) sont en français obligatoire, AR/EN facultatifs (repli FR), car la page n'existe pas en production ; design demande l'avis de conformite.
Avis conformite : la règle « aucune chaîne en dur, i18n FR/AR/EN » (CLAUDE.md r15) est non négociable ; seul l'utilisateur peut y déroger. La condition de sécurité est déjà posée : clés `dev.*` absentes du build de production, prouvé par test (§2.2). Pas de contre-indication fonctionnelle.
Recommandation : accepter, limitée aux clés `dev.*` d'une page absente de la production.
```

```
[DÉCISION] D-04 Écran « Mot de passe oublié » dans le périmètre WD1/WF2
Contexte : non listé dans le BOARD ; ajouté par design parce que la connexion y renvoie ; la spec 01 §5 prévoit `POST /auth/password/forgot` et `/reset`, et le contrat 0.2.0 les définit.
Avis conformite : l'écran est exigé par la spec 01 ; ce n'est pas un ajout au cahier.
Recommandation : l'ajouter à la ligne WD1 et à WF2 du BOARD (ferme B-05). Le mécanisme (lien ou code) reste en attente de décision (reset : `x-pending-decision`).
```

Rappel D-01 (premier mot de passe des comptes web, politique, codes de secours) : déjà transmis à `main` ; l'indication « Première connexion ? Saisissez le mot de passe temporaire reçu par SMS ou par e-mail » de `commun-connexion.md` repose dessus ; elle est couverte par le plan validé (« première connexion (mot de passe temporaire) ») mais la règle de délivrance pour les comptes web reste non documentée.

## Points à surveiller dans WD3 à WD5

1. Chaque nombre affiché cite son champ de contrat ; COM-04 sans solde ni motif ; le code manuel suit la décision D-02 (validité de 60 s ?).
2. Création société et commerçant : profil de commission obligatoire (critère d'acceptation 1).
3. Attribution Entreprise : `_socle-ecrans.md` S3 mentionne une exception « solde insuffisant » pour l'attribution ; le contrat réserve `INSUFFICIENT_FUNDS` au payeur (§4) : à définir au contrat Entreprise avant la spec.
4. Textes juridiques (CGU, confidentialité) : non rédigés par design (`commun-connexion.md` §3) ; ils restent une décision ouverte (`open-questions.md`).

## Non vérifié

1. Textes AR et EN : non produits.
2. Contrastes : repris de D1 (87/87), non recalculés.
3. Les 14 composants NC.x ne sont pas encore codés : aucune vérification visuelle.
4. Specs WD3 à WD5 : non reçues.

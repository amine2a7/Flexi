# Revue securite : WD1, specs d'authentification web (design)

- **Date** : 2026-10-12
- **Relecteur** : securite (en parallèle de ux et conformite)
- **Base de revue** : `docs/design/specs/` : `commun-connexion.md`, `commun-premiere-connexion.md`,
  `commun-mfa.md`, `commun-session-expiree.md`, `commun-mot-de-passe-oublie.md`, `navigation.md` N.9,
  `_besoins-contrat.md` §1 (CT-C-0 à CT-C-11, CT-X-6). Référentiels : `exigences-securite.md`
  (SEC-A1 à A8, SEC-W5), spec 01, ASVS 4.0.3 niveau 2 (ASVS 5.0 entre en vigueur en phase 1).
- **Propriétaires** : design (specs) ; backend pour ce qui relève du contrat (WB2).

## Verdict : **OK**

Aucun constat Critique ni Haute. Ouverts : 1 Moyenne (backend, contrat), 2 Basses (design).
Les quatre sujets en attente de décision de l'utilisateur ne sont pas traités comme des écarts : mon
avis figure en §3.

Points solides : message unique pour les identifiants erronés, le compte verrouillé et le mot de passe
temporaire expiré ; aucun écran « compte verrouillé » ; CSRF et `challengeId` en mémoire seulement ;
politique de mot de passe appliquée côté serveur uniquement ; secret MFA affiché une fois, jamais
rechargé ; mot de passe vidé après erreur ; `autocomplete` corrects ; réponse identique pour
« mot de passe oublié » ; canal d'envoi non révélé ; cause d'une déconnexion jamais indiquée ;
`Cache-Control: no-store` ; jeton de réinitialisation retiré de l'URL.

## 1. Constats

```
[CONSTAT] WD1-S01 Verrouillage et 429 : oracle d'existence de compte et déni de service ciblé
Sévérité : Moyenne
Fichier : docs/design/specs/_besoins-contrat.md (CT-C-1, CT-C-1b, CT-C-2) ; commun-connexion.md §6
  (état « Trop de tentatives ») ; spec 01 (« 5 échecs → blocage 15 min, puis progressif »)
Preuve : l'écran de connexion affiche un 429 avec compte à rebours. CT-C-1b exige que le compte
  verrouillé réponde comme des identifiants invalides, mais le contrat ne dit pas comment le
  429 est déclenché. Si le serveur répond 429 (ou change de délai) seulement pour un compte qui
  existe et vient d'être verrouillé, la différence trahit l'existence du compte.
Scénario d'attaque : un attaquant anonyme soumet 6 mots de passe faux pour
  « directeur@entreprise.tn ». S'il obtient un 429 pour un compte réel et un 401 pour une adresse
  inventée, il a une liste de comptes valides à hameçonner. Variante : il verrouille en boucle
  les comptes ADMIN ou COMMERÇANT connus (6 requêtes toutes les 15 min) et bloque l'encaissement
  ou la paie (déni de service ciblé).
Correctif proposé (contrat WB2, backend) :
  1) le 429 ne vient que de la limitation de débit, appliquée À L'IDENTIQUE que le compte existe ou
     non : clés « IP » et « identifiant normalisé haché », mêmes seuils, même Retry-After ;
  2) un compte verrouillé répond 401 INVALID_CREDENTIALS, même avec le bon mot de passe, avec le
     même temps de réponse (hachage Argon2id factice pour les identifiants inconnus) ;
  3) le verrouillage par compte ne doit pas permettre de bloquer un tiers de l'extérieur : soit un
     ralentissement progressif par couple (compte, IP) plutôt qu'un blocage global, soit un
     blocage global avec déblocage par mot de passe oublié et notification à l'utilisateur
     (spec 01 §7). Ce choix est à documenter dans le contrat ;
  4) même règle pour /auth/mfa/verify (CT-C-2) et /auth/password/forgot (CT-C-9).
Exigence : SEC-W5, SEC-A5 (par analogie) / ASVS 2.2.1, 3.x (4.0.3) ; API4:2023 (ressources sans limite)
```

```
[CONSTAT] WD1-S02 returnTo : règles de validation à préciser (forme décodée, caractères de contrôle, navigation)
Sévérité : Basse
Fichier : docs/design/specs/commun-session-expiree.md §3.1 ; commun-connexion.md §3 et §11
Preuve : les règles excluent « // », « \ », le schéma et l'hôte, mais ne disent pas qu'elles
  s'appliquent APRÈS décodage et normalisation, ni comment on navigue vers la cible.
Scénario d'attaque : lien hameçon /login?returnTo=/%2F%2Fevil.tn ou /%5Cevil.tn ou
  « /<TAB>/evil.tn » (les navigateurs retirent TAB et sauts de ligne des URL). Après une vraie
  connexion, la victime est envoyée sur une copie du site qui redemande son mot de passe ou son code MFA.
Correctif proposé : préciser dans §3.1 que :
  1) la valeur est décodée une fois puis rejetée si elle contient encore « % », des caractères de
     contrôle ou des espaces, « // », « \ », « /. » ou « .. » ;
  2) elle doit correspondre EXACTEMENT à une route connue de l'espace du rôle (liste blanche :
     c'est elle qui protège, les autres règles sont une défense en profondeur) ;
  3) la navigation passe par le routeur de l'application avec un chemin (jamais
     location.href = returnTo ni une URL absolue construite par concaténation) ;
  4) le serveur reste l'autorité : s'il renvoie une cible de redirection, il applique la même liste
     blanche.
Exigence : ASVS 5.1.5 (4.0.3) ; OWASP Unvalidated Redirects
```

```
[CONSTAT] WD1-S03 QR d'enrôlement MFA : mode de rendu du SVG non spécifié
Sévérité : Basse
Fichier : docs/design/specs/commun-mfa.md §7 (option a : qrCodeSvg)
Preuve : l'option (a) transporte un SVG dans du JSON, sans préciser comment le front l'affiche.
  Un SVG inséré dans le DOM (innerHTML, dangerouslySetInnerHTML) peut exécuter du script.
Scénario d'attaque : si la génération du QR côté serveur est un jour compromise ou mal paramétrée
  (dépendance, valeur réfléchie), un SVG piégé s'exécute dans l'origine du back-office, au moment
  exact où le secret MFA et le jeton CSRF sont en mémoire.
Correctif proposé : je confirme l'option (a), recommandée par design. Il faut spécifier que :
  - le QR est rendu par <img src="data:image/svg+xml;base64,…"> (un SVG dans une balise img
    n'exécute pas de script), ou que l'API renvoie un PNG en data URI ;
  - jamais innerHTML ni dangerouslySetInnerHTML ;
  - la CSP autorise img-src data: seulement, et pas script-src (vérifié en F3).
  L'option (b), une bibliothèque de QR dans le front, n'est pas nécessaire. Si elle était retenue,
  la dépendance passerait par une revue securite (SC-1).
Exigence : ASVS 5.3.3, 14.4.3 (4.0.3)
```

## 2. Réponses aux questions posées à securite

| Question | Réponse |
|---|---|
| QR : option (a) ou (b) (`commun-mfa.md` §12.3) | **(a)**, avec le rendu `img` + data URI de WD1-S03. |
| Durée de vie du `challengeId` | Recommandation : **5 min**, usage unique, invalidé après **5 codes faux** (retour à `/login`). Le défi est lié à un cookie de pré-authentification HttpOnly (pas seulement à un identifiant dans le corps), le code TOTP déjà utilisé est refusé dans sa fenêtre (anti-rejeu) et une tolérance de ±1 pas (30 s) est admise. À inscrire au contrat (backend, CT-C-2). |
| Durées de session (CT-X-6, `navigation.md` N.9, `commun-session-expiree.md` §12.2) | Le jeton d'accès de 10 à 15 min est déjà fixé (SEC-A3). L'inactivité et la durée absolue ne figurent dans aucun document : **[DÉCISION] transmise à main**. Ma recommandation : **inactivité 15 min**, **durée absolue 8 h** pour les espaces Entreprise et Commerçant, **4 h pour Administrateur**, avertissement **2 min** avant. Les deux limites doivent être **appliquées par le serveur** (expiration du refresh token par inactivité et en absolu, ASVS 3.3.2), pas seulement par le minuteur du front. « Rester connecté » prolonge l'inactivité, jamais la durée absolue. |
| Contenu de `returnTo` | Chemin seul, sans requête ni fragment (déjà prévu) ; validation de WD1-S02. |
| Réponse pour `EMPLOYEE`/`FAMILY_MEMBER` sur le web (CT-C-1c) | Acceptable : **403 FORBIDDEN** après vérification complète du mot de passe, **sans cookie de session**, avec journalisation. L'information « ce mot de passe est valide » est de toute façon obtenable par l'API mobile ; le 403 n'aggrave donc rien. Le message reste générique, sans mention du rôle. |
| Révocation des sessions après changement de mot de passe (CT-C-4, §11) | **Oui, automatique** : après tout changement ou toute réinitialisation, toutes les autres sessions et familles de refresh tokens sont révoquées et la session courante reçoit un nouveau jeton. Journal d'audit et notification à l'utilisateur. (ASVS 3.3.3 ; spec 01 §42 : audit du changement de mot de passe.) |

## 3. Avis sur les décisions en attente de l'utilisateur (pas des écarts)

1. **Codes de secours MFA** : le principe est **déjà une exigence Must** :
   `exigences-securite.md` **SEC-A4** dit « MFA TOTP obligatoire … ; codes de secours ». Restent à
   décider : le nombre, le format et la procédure de perte de l'appareil. Recommandation :
   - **10 codes** à usage unique, d'au moins 10 caractères alphanumériques, hachés côté serveur
     (Argon2id) ;
   - affichés **une seule fois** à la fin de l'enrôlement (CT-C-3b), régénérables après un défi
     MFA, ce qui invalide les anciens ;
   - un lien « Utiliser un code de secours » sur l'écran de défi, soumis aux mêmes limites de débit
     que le code TOTP ;
   - perte de l'appareil sans code : réinitialisation de la MFA par un Administrateur, en
     **double validation** (initiateur ≠ approbateur, règle 12 de CLAUDE.md), avec audit et
     notification.

   Sans cela, la récupération se fait par le support, qui devient la cible d'ingénierie sociale la plus facile.
2. **Règles du mot de passe** (SEC-A1) : recommandation, suivant l'ASVS V2.1 :
   - **12 caractères minimum** ; au moins 64 acceptés, plafond serveur de **128** pour limiter le
     coût d'Argon2id ;
   - **aucune règle de composition** (ASVS 2.1.9 : la « complexité » de SEC-A1 se traduit par la
     longueur et le refus des mots de passe compromis) ;
   - **refus des mots de passe compromis ou courants**, par une liste locale ou l'API à k-anonymat
     (aucun mot de passe ni hachage complet transmis) ;
   - refus de l'identifiant et du nom de l'entreprise ;
   - tous caractères Unicode admis, normalisés (NFKC) ;
   - aucune expiration périodique (ASVS 2.1.10) ;
   - historique des 5 derniers mots de passe, facultatif ;
   - les codes de règle sont exposés par `GET /auth/password-policy` (CT-C-5).
3. **Mot de passe oublié** : j'approuve la recommandation du lead (lien envoyé par e-mail, valable
   15 min). Le jeton fait au moins 128 bits aléatoires, il est stocké haché, à usage unique, et
   invalidé par une nouvelle demande ou un changement de mot de passe. Pour un compte joignable
   seulement par téléphone (spec 09 : aucun lien dans les SMS) : un **code SMS de 6 chiffres**,
   valable 10 min, 5 essais, lié à l'identifiant. Dans tous les cas :
   - l'envoi est fait **en file d'attente**, pour que le délai de réponse soit identique ;
   - **la réinitialisation ne désactive jamais la MFA** : le défi TOTP reste exigé à la connexion
     suivante ;
   - toutes les sessions sont révoquées ;
   - l'utilisateur est notifié.
4. **Conservation de la saisie à l'expiration** : l'option B (en mémoire seulement, champs
   sensibles vidés, jamais de soumission automatique d'une opération financière) est acceptable
   pour la sécurité, à une condition à ajouter : **la saisie conservée est liée à l'identité de
   l'utilisateur**. Si un autre utilisateur se reconnecte dans le même onglet (poste partagé en
   caisse ou en comptabilité), elle est jetée sans être affichée. Sinon, les données d'un
   utilisateur fuient vers le suivant.

## 4. Remarques pour backend (contrat WB2, sans constat)

- Une **ré-inscription MFA** d'un compte déjà inscrit exige un défi MFA valide (ou la procédure
  Administrateur). Une inscription réussie est notifiée et journalisée, ce qui limite la prise de
  contrôle d'un compte non encore inscrit dont le mot de passe a fuité.
- `CURRENT_PASSWORD_INVALID` (CT-C-4) compte dans les échecs et la limitation de débit.
- Déconnexion : propagée aux autres onglets (BroadcastChannel ou événement `storage` sans
  donnée), avec effacement du CSRF en mémoire. À traiter par frontend en F1/F3.
- Réponses d'authentification : `Cache-Control: no-store`, déjà au contrat. Le `secretBase32`
  n'est jamais journalisé ni présent dans une trace d'erreur.

## Revérification (1er aller-retour, 2026-10-12)

- **WD1-S02 fermé** : `commun-session-expiree.md` §3.1 applique les règles sur la valeur décodée
  une fois, impose la liste blanche exacte, la navigation par le routeur et la revalidation par le
  serveur, et donne des exemples rejetés.
- **WD1-S03 fermé** : `commun-mfa.md` §7 prévoit un rendu par `<img>` (data URI) ou `<canvas>`,
  jamais `innerHTML`. La bibliothèque de QR passera ma revue en F1.
- N-02 (ux) reporté : `commun-premiere-connexion.md` §3, §6, §7 et §11 ; `commun-connexion.md` §6.
- Condition de l'option B (saisie liée à l'utilisateur) notée dans §3.1.
- Reste ouvert : WD1-S01 (backend, contrat). Voir la revue WB2.

**Avis sur ux N-07** (restituer la chaîne de requête des listes après reconnexion) : acceptable si
seuls des paramètres de filtre **en liste blanche par route** et **non personnels** sont restitués :
énumérations (statut, type), dates, montants bornés, identifiants opaques. Les recherches en texte
libre (`q`, nom, téléphone, e-mail, CIN, RIB) et le curseur ne sont jamais restitués, car ils
passeraient par `/login?returnTo=…` dans l'historique, les journaux du serveur et l'en-tête
`Referer`. Les valeurs sont validées par le schéma de la route (sinon le paramètre est abandonné),
la longueur totale est bornée, et la chaîne est encodée une seule fois puis revalidée selon §3.1.

## Non vérifié

1. Le contrat d'authentification (WB2) n'est pas encore livré : toutes les recommandations
   ci-dessus sont à revérifier dans `openapi.yaml`.
2. Le comportement réel (temps de réponse identique, limitation de débit) ne pourra être vérifié
   qu'en B3 et dans les modules d'authentification (tests).
3. Je n'ai pas relu les autres specs WD (Commerçant, Entreprise, Administrateur) dans cette revue.

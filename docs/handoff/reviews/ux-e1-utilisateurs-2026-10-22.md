# Revue UX – e1 Gestion des utilisateurs (specs avant code) – 2026-10-22

**Specs relues :** `docs/design/specs/commun-statut-utilisateur.md` (C), `admin-utilisateurs.md` (A), `entreprise-employes.md` (E). Socle `_socle-ecrans.md` non relu (aucune règle à vérifier au-delà de ce qui est cité).
**Verdict : À REVOIR** (1 Bloquant, 9 Majeurs, 12 Mineurs). Les règles validées sont respectées dans l'ensemble (statuts, libellé de grâce, rappel exact, motif obligatoire, cascade famille, mot de passe jamais affiché, boutons interdits absents). Les écarts sont signalés ci-dessous.

## Conformité aux règles validées

| Règle                                                                       | Résultat                                                                                       |
| --------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Transitions Actif↔Suspendu, →Désactivé, pas de suppression                  | Conforme (A:28). Mais `INVITED` existe en filtre (E:21) sans badge ni transition : voir UX-07. |
| Suspendu = solde bloqué                                                     | Conforme (C:44, E:39), libellé « Solde disponible » incohérent : UX-06.                        |
| Libellé « Désactivé — délai de grâce jusqu'au JJ/MM/AAAA »                  | Conforme (C:20, C:65).                                                                         |
| Rappel exact du délai                                                       | Conforme (C:52) ; pluriel à protéger : UX-16.                                                  |
| Motif obligatoire (suspension, désactivation, rôle)                         | Conforme, étendu à la réactivation (C:28).                                                     |
| Cascade famille, réactivation sélective                                     | Conforme (C:45, E:42).                                                                         |
| L'entreprise ne gère que ses employés                                       | Conforme en E ; **écart** en A:149 (UX-02).                                                    |
| Super-admin seul, quatre yeux, pas d'auto-modification, dernier super-admin | **Écarts** : UX-02, UX-03, UX-04.                                                              |
| Anti-énumération                                                            | Conforme (A:121-124, E:45) ; détail UX-18.                                                     |
| Mot de passe temporaire jamais affiché                                      | Conforme (A:53, E:47).                                                                         |
| Boutons interdits absents                                                   | Conforme (C:10, E:15).                                                                         |

## Constats

[CONSTAT] UX-01 Désactivation : irréversibilité masquée par défaut
Gravité : Bloquant
Écran : C:54 et C:126 (§12.1) ; E:144
Problème : la ligne « La désactivation ne peut pas être annulée. » est « absente par défaut » alors que les transitions validées n'offrent aucun retour depuis Désactivé. L'action la plus lourde serait confirmée sans dire qu'elle est définitive.
Impact : un RH ou un admin désactive en croyant pouvoir revenir en arrière ; perte d'accès et fermeture du compte non réversibles.
Proposition : afficher la ligne irréversible par défaut dans toutes les variantes de désactivation (employé et autres) ; ne la retirer que si l'utilisateur décide un jour d'une réactivation. Ajouter « Cette action est définitive » dans le bloc `warning`, avec l'icône.
Référence : Nielsen 5 (prévention des erreurs), 3 ; point de contrôle n° 6 (réversible ou non).

[CONSTAT] UX-02 Utilisateurs internes d'entreprise : changement de rôle sans quatre yeux
Gravité : Majeur
Écran : A:149 (§12.8), A:23
Problème : la recommandation permet à `users.manage` de changer le sous-rôle d'un utilisateur interne sans double validation, ce qui contredit « super-admin seul pour les rôles, sous quatre yeux ». A:23 limite pourtant « Changer le rôle » aux administrateurs : les deux passages se contredisent.
Impact : un rôle à droits financiers peut être modifié par un seul agent.
Proposition : supprimer la recommandation §12.8 sur ce point : tout changement de rôle passe par `users.adminRoles` en double validation, y compris pour les utilisateurs internes ; `users.manage` garde statut et réinitialisation.
Référence : règle validée (quatre yeux) ; Nielsen 4 (cohérence).

[CONSTAT] UX-03 Suspension d'un administrateur sans double validation
Gravité : Majeur
Écran : C:128 (§12.3), A:145 (§12.4), A:22
Problème : seule la désactivation d'un administrateur est proposée en double validation. La suspension d'un administrateur reste en validation simple alors que le statut des administrateurs relève du super-admin « sous quatre yeux ».
Impact : un seul super-admin peut bloquer un autre administrateur ; incohérence avec la règle.
Proposition : double validation pour suspension, réactivation et désactivation d'un administrateur. Les textes `approvalNote` et « Demande soumise pour approbation » s'appliquent alors aux trois.
Référence : règle validée ; exigence audit/double validation (CLAUDE.md règle 12).

[CONSTAT] UX-04 Dernier super-administrateur : changement de rôle non couvert, et impasse avec un seul super-admin
Gravité : Majeur
Écran : C:99 (clé `lastSuperAdmin`), A:29, A:49
Problème : (a) la phrase protège de « suspendu ni désactivé » mais pas d'un changement de rôle, qui retire aussi le dernier super-admin. (b) avec un seul super-admin, personne ne peut approuver : « Créer un administrateur » envoie une demande qui ne pourra jamais être validée.
Impact : demandes bloquées sans explication, ou perte des droits de gestion.
Proposition : (a) étendre le texte : « Le dernier super-administrateur ne peut pas être suspendu, désactivé ni changer de rôle. » et masquer « Changer le rôle ». (b) si l'API indique qu'aucun approbateur n'est disponible (`approversAvailable: false`), remplacer l'action par la phrase « Un second super-administrateur est nécessaire pour valider cette demande. » À ajouter au contrat.
Référence : Nielsen 1 (visibilité de l'état), 9 (récupération d'erreur).

[CONSTAT] UX-05 Action principale de la fiche : « Suspendre » en bouton danger
Gravité : Majeur
Écran : E:7 ; A:7 contre A:47
Problème : (E) l'action principale de la fiche est une action destructive ; l'action la plus attendue (« Attribuer des crédits ») est reléguée. (A) la spec dit que l'action principale est « Suspendre/Réactiver » mais place toutes les actions dans un menu « Actions » : il n'y a donc pas de bouton principal visible.
Impact : clics accidentels sur un bouton rouge saillant ; incohérence entre la liste et la fiche ; action principale introuvable côté admin.
Proposition : fiche entreprise : principal = « Attribuer des crédits » (si éligible), « Suspendre » en `secondary` dans le menu ou à côté. Fiche admin : pas d'action principale, tout dans le menu (corriger A:7) ; « Réactiver » seule peut être visible quand le compte est suspendu.
Référence : Nielsen 5, 4 ; point n° 3 (une seule action principale claire).

[CONSTAT] UX-06 Libellé « Solde disponible » pour un solde bloqué ou d'un compte fermé
Gravité : Majeur
Écran : E:39, E:78 (`balance.label`)
Problème : le même libellé « Solde disponible » s'affiche pour un suspendu (solde bloqué) et un fermé. Le mot « disponible » est faux dans ces deux états. En outre, la fiche employé doit montrer « l'état et le solde restant » (règle validée) : A:47/A:156 n'affiche pas le solde côté admin (§12.6 ouverte).
Impact : l'utilisateur lit un montant comme dépensable alors qu'il ne l'est pas ; l'admin ne peut pas répondre à un employé en délai de grâce.
Proposition : libellé « Solde » (neutre), complété par l'état : « Solde bloqué » (suspendu, icône `Lock`), « Solde restant » (en grâce, avec la date), « Solde à la fermeture » (fermé). Trancher §12.6 : oui, l'admin voit le solde en lecture seule, rendu par `Amount` (`48 250,000 TND`), tel que renvoyé par l'API.
Référence : Nielsen 2 (langage de l'utilisateur), 1 ; point n° 4.

[CONSTAT] UX-07 Statut « Invité » sans badge ni règle
Gravité : Majeur
Écran : E:21, E:151 ; C:15-21
Problème : `INVITED` figure dans le filtre et le contrat mais pas dans la table des badges, ni dans les transitions (peut-on suspendre ou désactiver un invité ? l'inclure dans une action groupée ?). Le filtre admin (A:34) n'a pas ce statut.
Impact : ligne sans badge cohérent, sélection groupée ambiguë.
Proposition : ajouter un badge `INVITE` (icône `Mail` + texte « Invité »). Autoriser Suspendre et Désactiver sur un invité, ou les exclure explicitement ; tenir la même liste de statuts dans les deux filtres.
Référence : Nielsen 4, 1.

[CONSTAT] UX-08 Action groupée : périmètre réel non annoncé
Gravité : Majeur
Écran : E:32, E:35, E:71
Problème : avec une sélection mixte (actifs et suspendus, invités), la modale annonce « {count} employés seront suspendus » sans dire que certains sont ignorés. Le nombre de membres de la famille touchés n'est connu qu'après coup. Le résultat dit « traités / non traités » alors que le titre dit « suspendus » (E:35 contre E:71).
Impact : un RH croit suspendre 20 personnes alors qu'il en suspend 14 ; surprise sur la famille.
Proposition : le récapitulatif distingue « {n} seront suspendus » et « {m} ignorés (déjà suspendus ou désactivés) » avec liste ; l'API renvoie un aperçu du nombre de membres de famille touchés ; vider la sélection (et l'annoncer) lors d'un changement de filtre, de tri ou de page ; clé de résultat par action : « {ok} suspendus, {failed} non traités ».
Référence : Nielsen 1, 5 ; point n° 6.

[CONSTAT] UX-09 Sous-rôles administrateur : descriptions manquantes et aucun avertissement sur le super-admin
Gravité : Majeur
Écran : A:49, A:86-88
Problème : le choix de sous-rôle est la décision la plus sensible de l'écran de création, et trois des quatre descriptions sont « à fournir ». Créer un super-admin n'a aucun avertissement spécifique.
Impact : choix de droits à l'aveugle.
Proposition : fournir les descriptions avant le code (bloquant le codage de l'écran C). Dans la confirmation, ajouter pour Super-administrateur : « Ce compte aura tous les droits, dont la gestion des administrateurs. »
Référence : Nielsen 10, 5.

[CONSTAT] UX-10 Désactivation : manque la conséquence « aucun nouveau crédit »
Gravité : Mineur
Écran : C:52-53
Problème : la règle est « peut seulement dépenser son solde ». Le texte exact validé n'en dit rien sur l'attribution (alors que E:40 la bloque).
Impact : le RH peut tenter d'attribuer ensuite.
Proposition : conserver le rappel exact tel quel, et ajouter une ligne séparée : « Aucun nouveau crédit ne pourra lui être attribué. »
Référence : Nielsen 1.

[CONSTAT] UX-11 Famille : libellé de grâce non défini pour les membres
Gravité : Mineur
Écran : C:24, C:68 ; E:42, E:115
Problème : « Désactivé avec l'employé » n'est pas dans la table des badges (C:15-21) et l'on ne dit pas si un membre peut dépenser pendant la grâce de l'employé.
Impact : doute sur l'état réel du membre.
Proposition : ajouter la ligne au tableau C:15-21 ; décider (`[DÉCISION]` au lead) si le membre suit la grâce de l'employé ; si oui, utiliser le libellé exact « Désactivé — délai de grâce jusqu'au {date} ».
Référence : Nielsen 4.

[CONSTAT] UX-12 Message « compte fermé » technique
Gravité : Mineur
Écran : E:39, E:81 (`closedNote`)
Problème : « Le solde suit la règle des crédits expirés » est du jargon pour un RH ; la valeur « 0,000 ou résiduelle » est ambiguë.
Impact : l'utilisateur ne sait pas ce que devient le solde.
Proposition : après validation de la règle exacte, un texte qui dit le résultat (ex. « Compte fermé le {date}. Le solde restant a été traité comme un crédit expiré. »), montant toujours au format `0,000 TND`, jamais vide.
Référence : Nielsen 2.

[CONSTAT] UX-13 Vocabulaire de réinitialisation incohérent
Gravité : Mineur
Écran : A:82/A:90 ; E:88/E:141
Problème : « Réinitialiser le mot de passe » (admin), « Réinitialiser l'accès » (entreprise), titre « Envoyer une nouvelle invitation ». Le motif est requis côté admin (A:53) mais pas mentionné côté entreprise (E:47). L'action n'est pas exclue pour un compte suspendu ou désactivé.
Impact : deux noms pour une action ; envoi possible sur un compte bloqué.
Proposition : un seul libellé « Renvoyer l'invitation » partout ; même règle de motif aux deux endroits ; action absente si le compte est suspendu ou désactivé.
Référence : Nielsen 4.

[CONSTAT] UX-14 Texte tronqué dans la spec admin
Gravité : Mineur
Écran : A:53 (fin : « pas de . »)
Problème : phrase incomplète, intention perdue.
Proposition : compléter (ex. « pas de bouton « Copier le mot de passe » ») avant le code.
Référence : qualité de spec.

[CONSTAT] UX-15 Modales empilées et ordre des boutons sur mobile
Gravité : Mineur
Écran : A:51 (Modifier), C:120
Problème : « Modifier » ouvre une modale formulaire puis une seconde modale de motif. Sur mobile, le bouton destructif est placé en premier visuellement alors que Annuler précède dans le DOM : l'ordre de focus ne suit pas l'ordre visuel.
Impact : navigation clavier et lecteur d'écran désordonnée ; saisie en deux temps.
Proposition : un seul écran : champ Motif dans le formulaire de modification, suivi de la confirmation avec `ChangeDiff`. Sur mobile, mettre le bouton principal en premier dans le DOM aussi (pas d'inversion visuelle seule).
Référence : WCAG 1.3.2, 2.4.3.

[CONSTAT] UX-16 Pluriel de « jours »
Gravité : Mineur
Écran : C:52
Problème : « pendant {days} jours » avec `graceDays = 1` donne « 1 jours ».
Proposition : pluriel ICU {days, plural, one {# jour} other {# jours}} en gardant la phrase exacte validée ; mêmes règles en AR.
Référence : point n° 8 (cohérence), microcopie.

[CONSTAT] UX-17 Demande en attente : actions concurrentes et retrait
Gravité : Mineur
Écran : A:46, A:44
Problème : pas de règle sur les autres actions pendant qu'une demande est en attente pour le même compte, et l'initiateur ne peut pas retirer sa propre demande.
Impact : demandes contradictoires, 409 confus.
Proposition : masquer les actions de statut et de rôle tant que `pendingChange` existe ; voir la user story ci-dessous.
Référence : Nielsen 3 (contrôle de l'utilisateur).

[CONSTAT] UX-18 Anti-énumération : détails d'écran
Gravité : Mineur
Écran : A:119, A:124 ; E:45
Problème : après un doublon silencieux côté admin, le succès renvoie « un lien vers la fiche » : pour un doublon, aucune fiche nouvelle n'existe (lien différent, donc indice). Côté entreprise, le temps de réponse et le message doivent aussi rester identiques.
Proposition : le lien de succès mène toujours à la demande en attente (liste des approbations), jamais à une fiche utilisateur ; test de non-différence du message à fournir à `qualite`.
Référence : règle validée (anti-énumération).

[CONSTAT] UX-19 États vides et historique visible de l'entreprise
Gravité : Mineur
Écran : E:73, E:105 ; E:146
Problème : « Ajoutez vos employés ou importez un fichier CSV » est affiché à un READ_ONLY sans action. Les motifs et noms d'auteurs saisis par l'admin seraient visibles de l'entreprise.
Proposition : texte sans verbe d'action pour les lecteurs (« Aucun employé pour le moment. ») ; auteur affiché « Administrateur FlexiPay » sans nom ; motif admin masqué par défaut (interne), visible seulement si marqué comme partageable.
Référence : Nielsen 2, 5 ; sécurité (pas d'information interne).

[CONSTAT] UX-20 Badge long, fiche de son propre compte et erreur avec référence
Gravité : Mineur
Écran : C:20, C:100, C:95
Problème : le badge « Désactivé — délai de grâce jusqu'au … » en pastille est long : retour à la ligne à prévoir en carte 360 px et en colonne de tableau (largeur mini). Sur sa propre fiche, la section Actions peut rester vide avec son titre. La référence `requestId` doit être libellée.
Proposition : badge multiligne autorisé, `max-width` fluide ; ne pas rendre la section « Actions » vide ; libellé « Référence à communiquer au support : {id} ».
Référence : WCAG 1.4.10 (reflow), Nielsen 9.

[CONSTAT] UX-21 Compteur d'actions de masse et barre collante sur mobile
Gravité : Mineur
Écran : E:32, E:133
Problème : la barre collante en bas peut masquer « Charger plus » et le dernier élément ; avec zoom 200 % elle occupe l'écran.
Proposition : espace réservé sous la liste égal à la hauteur de la barre ; barre repliable ; `scroll-padding-bottom`.
Référence : WCAG 1.4.10, 2.4.7.

## Critères évalués (synthèse)

- **Parcours/action principale :** point d'entrée, sortie et retour définis (filtres restitués). Problèmes : UX-05, UX-17.
- **Montants :** solde tel que renvoyé, `Amount lg`, format `48 250,000 TND`, blocs LTR en RTL : bon. Libellé du solde : UX-06, UX-12. Pas de hiérarchie brut/commission ici (sans objet).
- **Erreurs/états vides :** complets (chargement, erreur, hors connexion, 403, 409). Voir UX-19, UX-20.
- **Confirmations/irréversibilité :** UX-01 (Bloquant), UX-03, UX-09. La dérogation « bouton désactivé tant que le motif est trop court » est acceptable : raison écrite + `aria-disabled` + focus initial sur le champ (C:36, C:116).
- **Masse :** UX-08, UX-21. Désactivation jamais en masse : d'accord.
- **WCAG/RTL/360 px :** socle solide (badge icône+texte, date en toutes lettres, cibles 44 px, flèche miroir, compteur LTR). Voir UX-15, UX-20, UX-21.
- **Microcopie FR :** claire, verbe + résultat sur les boutons. Voir UX-10, UX-13, UX-16.

## Avis sur les « Questions ouvertes »

**Commun (§12)** : 1 d'accord (pas de réactivation d'un désactivé au MVP) mais la ligne irréversible doit être affichée (UX-01) ; 2 d'accord (effet immédiat pour les non-employés) ; 3 d'accord, étendue à la suspension d'un administrateur (UX-03) ; 4 d'accord (10 à 500) ; 5 d'accord (motif à la réactivation) ; 6 d'accord, prérequis avant code.
**Admin (§12)** : 1 d'accord pour COMPLIANCE et FINANCE ; pour SUPPORT, ne pas créer de permission fine sans décision : lecture seule par défaut, `[DÉCISION]` au lead ; 2 d'accord pour « Opérations » à condition que l'utilisateur confirme le libellé (sa propre demande) ; 3 à fournir avant code (UX-09) ; 4 d'accord ; 5 d'accord ; 6 d'accord, oui avec lecture seule (UX-06) ; 7 d'accord (valeur figée) et afficher le texte d'aide « s'applique aux prochaines désactivations » pour éviter une fausse attente ; 8 **pas d'accord** (UX-02) ; 9 d'accord.
**Entreprise (§12)** : 1 d'accord ; 2 d'accord, limite = page, valeur lue de l'API et affichée dans la modale ; 3 d'accord pour la réinitialisation par l'entreprise (libellé unifié, UX-13) et le PIN réservé à l'admin ; 4 à reformuler (UX-12) ; 5 d'accord, conserver Service ; 6 voir commun ; 7 d'accord ; 8 d'accord avec le champ de visibilité, défaut « interne » côté admin (UX-19).

## User stories proposées (à valider par le lead, `[DÉCISION]`)

**[DÉCISION] User story proposée : retirer sa propre demande en attente**
En tant qu'administrateur initiateur, je veux retirer ma demande en attente de seconde validation, afin de corriger une erreur sans attendre un refus.
Critères d'acceptation :

- Étant donné une demande dont je suis l'initiateur, quand j'ouvre la fiche, alors je vois « Retirer la demande » avec confirmation.
- Étant donné une demande retirée, quand l'approbateur ouvre la liste, alors elle n'apparaît plus et l'audit conserve le retrait.
  Pourquoi elle manque : aucune sortie pour l'initiateur (UX-17).
  Recommandation : l'ajouter au périmètre e1.

**[DÉCISION] User story proposée : comprendre pourquoi une demande ne peut pas être validée**
En tant que super-administrateur seul, je veux être averti qu'aucun second validateur n'existe, afin de ne pas créer une demande bloquée.
Critères d'acceptation :

- Étant donné un seul super-administrateur actif, quand j'ouvre la création d'administrateur, alors un message m'explique qu'un second super-administrateur est nécessaire.
  Pourquoi elle manque : impasse non couverte (UX-04).
  Recommandation : l'ajouter ; la règle de rattrapage (premier amorçage) est à décider par l'utilisateur.

## Non vérifié

Aucun écran réel (specs seulement). Contrastes des tokens `ACTIF`, `DESACTIVE`, `DESACTIVE_GRACE` non mesurables avant leur création. `_socle-ecrans.md`, `dev-composants.md` (NC.10), `navigation.md` non relus. Traductions AR et EN inexistantes. Libellés AR de la date de grâce et du pluriel non vérifiés.

# Décisions de la nuit du 10 au 11 novembre 2026

Choix faits sans pouvoir te demander, une ligne chacun. Règle suivie : l'option la plus simple et la plus sûre pour l'argent. À valider ou corriger demain.

- Référence : `docs/specs/processus-v2.md` n'existe pas ; j'ai suivi le PDF `docs/specs/FlexiPay · Rôles et processus (1).pdf`.
- Bug 5 (déclaration de virement) : le parcours normal passe au premier essai dans le navigateur (test e2e). Le défaut corrigé est l'affichage : chaque erreur du serveur va sous son champ avec son vrai message (une date refusée n'affiche plus « Montant invalide »), et une erreur sur un champ non affiché est expliquée au-dessus du formulaire.
- Bug 6 : « Enregistrer le paiement » est possible sur un lot programmé ou libéré ; la double validation reste à l'acceptation de chaque demande et à la libération du lot.
- Bug 6 : le montant attendu est le net moins une éventuelle dette du commerçant (litige) ; un autre montant exige un motif.
- Frais : la retenue à la source n'est pas contre-passée par un litige accepté, et le rapprochement quotidien ne la contrôle pas encore (TVA et timbre seulement). À traiter avec le comptable.
- Frais : les entreprises et commerçants créés avant la mise à jour reçoivent la forme juridique PM MF par défaut ; l'équipe Opérations doit la vérifier.
- Frais : la commande peut encore être créée à partir des lignes (montants calculés à cet instant) ; l'écran web utilise toujours le devis figé.
- Mot de passe temporaire : il est renvoyé à la création d'une entreprise ou d'un commerçant, et sur « Générer un nouveau mot de passe », uniquement à un admin qui a le droit `users.manage` (aujourd'hui le Super-admin). Le Support n'en reçoit jamais ; je n'ai pas modifié la matrice des droits pour donner ce droit à Opérations.
- Mot de passe temporaire d'un employé : il n'est pas affiché à la création, car la règle de sécurité S04 impose la même réponse quand l'e-mail existe déjà. Il reste envoyé par e-mail ; l'admin peut en générer un nouveau depuis la fiche utilisateur.
- KYC : la liste des 4 pièces est fixe (RNE ou patente, carte fiscale, CIN du gérant, RIB) et n'est pas encore un paramètre du Super-admin.
- KYC : un nouveau dépôt remplace la pièce du même type (l'ancienne est conservée et marquée remplacée) ; un dossier refusé repasse « à contrôler » au premier nouveau dépôt.
- KYC : tant que son dossier n'est pas validé, une entreprise ne peut ni simuler ni passer de commande (409 avec la raison KYC_NOT_APPROVED, expliquée à l'écran).
- Départements : un département est archivé (jamais supprimé), seulement s'il n'a plus d'employé ; un département archivé ne reçoit plus d'employé.

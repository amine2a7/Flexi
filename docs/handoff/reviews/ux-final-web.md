# Revue UX finale web (mode économe, lecture de code, pas de test navigateur)

Verdict : **OK** (aucun Bloquant, aucune Haute). Parcours cohérents, un seul bouton principal par écran, confirmations présentes.

## Constats
[Moyenne] Libération d'un lot sans montant dans la confirmation
- `apps/web/src/app/[locale]/admin/reglements/[batchId]/page.tsx:188` : `summary={[]}`. Le dialogue « Libérer le lot » ne rappelle ni la référence, ni le net total, ni le nombre de commerçants.
- Impact : Finance valide un ordre bancaire sans voir le montant. Proposition : summary = référence, nombre de commerçants, net total (déjà chargés). Nielsen 5 (prévention des erreurs).

[Moyenne] Libellé du bouton ambigu (page.tsx:181 ; admin.json:177)
- « Demander la libération » dans l'en-tête, puis `releaseTitle` = « Libérer le lot » : le titre promet une action immédiate alors que c'est une demande. Aligner : « Demander la libération du lot ». Nielsen 2.

[Moyenne] Changement de grille / de RIB sans récapitulatif avant-après
- `components/admin/account-record.tsx:469-500` et `:559-592` : le formulaire part directement en double validation. Pour le RIB, le nouveau RIB saisi n'est pas rappelé avant envoi. Proposition : ligne « Actuel → Nouveau » (RIB masqué) au-dessus du bouton. Nielsen 5.

[Moyenne] Création : étape 2 sans récapitulatif des informations
- `components/admin/account-form.tsx:272-296` : l'étape 2 affiche seulement la grille ; le nom du compte créé n'est plus visible, et « Retour » est le seul moyen de vérifier. Proposition : rappeler le nom en sous-titre de l'étape 2. Nielsen 6.

[Basse] « Redemander » ne simule pas et ne signale rien
- `app/[locale]/commercant/virements/page.tsx:195-200` : bascule l'onglet et préremplit le montant, mais n'efface pas `error` / `created` et ne place pas le focus sur le champ montant. Le commerçant doit encore cliquer « Simuler » sans qu'on le lui dise. Proposition : focus sur le montant + toast « Montant repris, lancez la simulation ». Nielsen 1.

[Basse] Bouton « Simuler » grisé sans explication (virements/page.tsx:324) : le hint `amountHint` doit dire pourquoi (montant > 0 requis).

[Basse] Fermeture d'une fenêtre à moitié remplie sans avertissement (`account-form.tsx:182-190`) : perte de la saisie et de la grille (Échap ou clic extérieur). Nielsen 3/5.

[Basse] Cinq cartes en `xl:grid-cols-4` (batch page.tsx:119) : une carte orpheline sur grand écran. Passer à `xl:grid-cols-5`.

[Basse] Bouton supprimer une tranche en icône seule (commission-grid-editor.tsx:178-186) : nom accessible présent, cible à vérifier à 44 px.

## Points positifs
Grille : erreurs par ligne, aperçu en direct (brut, commission, TVA, timbre, net) avec signe débit + libellé. Doublon géré (`duplicate`). Motif obligatoire pour grille et RIB. Montant net rappelé dans le bouton de confirmation du virement. Flèches inversées en RTL. Tableaux à défilement géré par `DataTable`.

## Non vérifié
Rendu navigateur, 360 px, RTL réel, clavier/lecteur d'écran, captures. Non relus : entreprise/commandes/nouvelle, factures PDF (entreprise/factures, virements/[payoutId]), admin/securite, litiges, autres fichiers `messages/fr`.

## User stories proposées
Aucune.

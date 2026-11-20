# Rapport de la nuit du 11 au 12 novembre 2026

1. **Fini, étape A :** bug 5 `e6bc726` `35226ac`, bug 6 `2991cbe`, frais v2 `b5cc3b3`, mot de passe temporaire `548f810`, Mon dossier KYC `6cab063`, départements et postes `8318753`, attribution (filtres, plusieurs types, aperçu, modèles, Relancer) `0bea993`. Le scénario tracé est rejoué sur l'API réelle (`3a010ca`) : 16 581,000 TND, grand livre rapproché.
2. **Fini, étape B :** seed de démo `77a3686`, fiche client à onglets `96cc0e0`, comptes famille `7407f8e`, forme juridique en double validation `40521df`, rapprochement de la retenue et des frais de virement `9b8787b`, pièces KYC paramétrables `fa72ea0`, tests `68d0531`.
3. **Passe complète :** RESULTATS_PASSE
4. **7 actes :** RESULTATS_ACTES
5. **Démo lancée sur http://localhost:3104/fr (API 3200), pas sur 3101.** Un ancien serveur web cassé (PID 25240, port 3101) et deux anciennes API (PID 25364 port 3198, PID 22544 port 3199) ont survécu à leur arrêt, et je n'ai pas le droit de tuer un processus. Pour revenir à 3101 : `taskkill /PID 25240 /F`, `taskkill /PID 25364 /F`, `taskkill /PID 22544 /F`, puis `pnpm demo`.
6. **Reste à faire :** relance automatique mensuelle des modèles (« à confirmer » dans le PDF) ; transferts familiaux absents de l'historique du bénéficiaire ; plafond famille non affiché dans le portefeuille du membre ; l'admin ne peut ni ajouter un employé depuis la fiche client, ni désactiver un modèle.
7. **Plan reconstruit :** ton plan « étape A / B / 7 actes » n'était dans aucun fichier. Ma lecture est dans `docs/decisions-nuit.md` (avec toutes les décisions prises seul) ; le déroulé des 7 actes est dans `docs/demo/scenario-demo.md`.
8. **À tester en premier demain :** acte 4 (devis 16 581,000, déclaration du virement, validations de Sarra puis de Nour) ; acte 7 (Karim, net 1 214,500, « Enregistrer le paiement » → Payé) ; Administrateur › Sécurité sans « Écart du grand livre ».
9. **Puis :** Crédits › Attributions (Production / Ouvrier, aperçu, modèle, Relancer) ; Bénéficiaire › Ma famille (Sami : identifiants, transfert de 50 TND plafonné à 20 TND par jour, reprise) ; fiche Groupe Carthage Services (onglets, « Changer » la forme juridique, puis validation par `admin2@`).
10. **À montrer avec les maquettes** (pas codé) : relance automatique mensuelle des modèles, application mobile Employé et Pro, historique des transferts familiaux.

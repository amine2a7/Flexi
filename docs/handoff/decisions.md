# Journal des décisions

Une ligne par décision **prise par l'utilisateur**. Les messages entre agents ne valent jamais décision.
Une décision qui change une règle métier met aussi à jour le cahier des charges et la spec concernée.

| Date | Question | Décision | Raison | Décidé par |
|---|---|---|---|---|
| 2026-10-09 | Les hooks lisent leur entrée avec `jq`, absent de la machine (hooks inactifs) | Remplacer `jq` par un lecteur JSON en Node ; les nouveaux hooks sont en Node | Node est déjà installé, aucune nouvelle dépendance | Utilisateur |
| 2026-10-09 | Imposer techniquement les périmètres d'écriture des agents ? | Oui : hook PreToolUse `enforce-scope.js` basé sur `agent_type` | Seul moyen réel de limiter l'écriture de `securite` à `docs/security/` et `docs/handoff/` | Utilisateur |
| 2026-10-09 | Plan de mise en place de l'équipe (agents, protocole, hooks, convention `TEST-FIRST:`, racine du monorepo à backend) | Validé | — | Utilisateur |
| 2026-10-09 | Dépôt git et remote | `git init` sur `main` (protégée), remote https://github.com/amine2a7/Flexi ; premier commit des fichiers de préparation autorisé ; aucun push sans accord | — | Utilisateur |
| 2026-10-09 | Déploiement staging en phase 0 ? | Exclu de cette passe, après le choix de l'hébergeur | Hébergeur non choisi (résidence des données INPDP) | Utilisateur |
| 2026-10-09 | Périmètre de la phase 0 | 21 tâches, 5 coéquipiers (securite, design, backend, frontend, mobile) ; iOS plus tard | Pas de Mac | Utilisateur |
| 2026-10-09 | Contourner Device Guard sur le PC d'entreprise (pnpm.exe bloqué) ? | Non. Pas d'installation de pnpm@9. Environnement complet (pnpm, Docker Desktop + WSL2, Flutter, Android Studio) installé sur un PC personnel ; la phase 0 complète y reprendra | PC d'entreprise : la politique de sécurité n'est pas contournée | Utilisateur |
| 2026-10-09 | Que lancer en attendant les outils ? | Équipe réduite : design (P0-D2, P0-D3), securite (P0-S5), backend (P0-B5 : rédaction du contrat OpenAPI seulement, sans génération de client ni code). Autres tâches « En attente — outils » | Avancer sur ce qui ne demande ni pnpm, ni Docker, ni Flutter | Utilisateur |
| 2026-10-09 | Identité Git | `git config --local` : user.name « Amine Khadraoui », user.email « aminekhadraoui51@gmail.com » ; auteur du premier commit corrigé (41976ef → 0219ad1) ; config globale inchangée | Identité propre au projet | Utilisateur |
| 2026-10-09 | COM-04 : le commerçant voit-il le solde du client ? | Non. « Solde disponible » retiré du cahier. Le commerçant voit seulement « accepté » ou « refusé » (`PAYMENT_DECLINED`, sans motif ni montant) | Règle 9 (pas de solde complet) ; oracle de solde (S6-10) | Utilisateur |
| 2026-10-09 | Membre famille : visibilité et navigation | Il ne voit que le reste de sa propre limite, jamais le solde de l'employé (écran et erreurs) ; barre basse Accueil · Payer · Historique · Profil | Minimisation des données | Utilisateur |
| 2026-10-09 | Fuseau horaire métier | `Africa/Tunis` pour les règles métier (plafonds jour/mois, J+2, expirations) ; UTC dans l'API | Calendrier métier tunisien, API sans ambiguïté | Utilisateur |
| 2026-10-09 | Nom du statut de paiement | « Confirmé » / `CONFIRMED` partout (cahier aligné sur le glossaire) | Cohérence cahier / glossaire / contrat | Utilisateur |
| 2026-10-09 | Unicité de l'Idempotency-Key | Unique par (tenant, utilisateur, clé) ; spec 02 mise à jour | Pas de collision entre clients ; filet anti double exécution (S6-04, S6-11) | Utilisateur |
| 2026-10-09 | Un utilisateur dans plusieurs tenants ? | MVP : un compte = un seul tenant. Table d'appartenance prévue au modèle pour l'ouvrir plus tard ; pas de changement de tenant en session dans le MVP | Simplicité et sécurité du MVP | Utilisateur |
| 2026-10-09 | Formats des montants EN et AR | AR comme FR, en chiffres occidentaux (`48 250,000 TND`) ; EN `48,250.000 TND` | Lisibilité, cohérence | Utilisateur |
| 2026-10-09 | Écarts de design et nouveaux tokens | Validés : toasts d'erreur sans fermeture automatique (WCAG 2.2.1), historique commerçant en onglet du module Encaissement (web), nouveaux tokens acceptés | Accessibilité, conformité AA | Utilisateur |
| 2026-10-09 | Texte du refus de paiement côté commerçant | « Paiement refusé. Le client peut vérifier son application. » | — | Utilisateur |
| 2026-10-09 | Sécurité (ASVS, données de test, Firebase) | ASVS 5.0 avant la phase 1 ; données de dev et de test synthétiques uniquement, jamais de données réelles ; `google-services.json` hors Git, injecté en CI | Pentest sur la version courante ; INPDP ; pas de configuration publiée | Utilisateur |
| 2026-10-09 | Constats CF-01 à CF-09 (chaîne de dev) | À corriger dans une branche dédiée, un commit par constat, revue securite, diff complet montré avant fusion | Correction traçable et relue | Utilisateur |
| 2026-10-09 | teammate-idle.js et adresse du lead | Commit validé ; `team-lead` remplacé par `main` dans le protocole | Adresse réelle de la session du lead | Utilisateur |

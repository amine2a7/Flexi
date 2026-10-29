# Revue securite : matrice des sous-rôles admin (décision C) et diff des hooks locaux (2026-10-25)

Relecteur : securite. Base : commits `29987df` et `b680f18` (partie 1) ; `git diff` non commité de
`.claude/hooks/guard-bash.js`, `.claude/hooks/lib/shell-split.js`, `.claude/hooks/test/guard-bash.test.js`
et le fichier non suivi `.githooks/pre-push` (partie 2). Référentiels : ASVS 4.0.3 V1.4, V4.1, V4.2, V14.1.

**Verdict global : OK** (aucun Critique ni Haute ouvert). Partie 1 : OK. Partie 2 : OK pour un commit,
avec un constat Moyenne (régression partielle du garde) et deux Basse à traiter si l'utilisateur le souhaite.

## Partie 1 : matrice admin (décision C)

Points vérifiés, conformes :
- **Refus par défaut** : `permissionsOf` renvoie `[]` pour un sous-rôle absent (`permissions.ts:157`) ;
  `route-permissions.test.ts` impose `@Public`/`@Can`/`@Self` sur toute route ; les trois contrôleurs
  admin portent `@Roles('ADMIN')` au niveau de la classe (double barrière rôle + nom de permission).
- **Aucun nom partagé** entre admin et entreprise/commerçant/employé : vérifié à la main sur les 27
  permissions de `ADMIN_ALL` (`orders.confirm`/`orders.validate` ≠ `orders.read/create/declareTransfer` ;
  `payouts.decide` ≠ `payouts.read/request` ; `adminPayouts.read`, `creditOrders.read` distincts).
- **Support** : ni `dashboard.read`, ni `audit.read`, ni `userBalances.read`, ni lecture des commandes,
  virements, règlements, commissions, paramètres. Routes accessibles à Support : `merchants`,
  `merchants/:id`, `companies` (réponses `merchantAccount()` et liste entreprises sans aucun solde,
  `admin.service.ts:37-55, 300-329`), `transactions` (montant de chaque paiement, autorisé par C, pas un
  solde, `admin.service.ts:597-645`), messages de contact. **Aucune route admin exposant un solde n'est
  accessible à Support.**
- **Opérations (COMPLIANCE)** : seules décisions `kyc.decide` (+ `kycDocuments.read`) ; aucune de
  `commissions.request`, `orders.confirm`, `orders.validate`, `payouts.decide`, `approvals.decide`,
  `settings.request`. Ne décide rien sur l'argent.
- **Finance** : décisions argent + `approvals.decide` ; pas de `settings.request` ni `users.*` d'écriture.
- **Quatre yeux** : aucune ligne de service modifiée par ces commits ; seul `four-eyes.test.ts` change de
  confirmateur (COMPLIANCE → FINANCE), le contrôle initiateur ≠ approbateur reste testé.
- **Balayage HTTP** (`admin-matrix.test.ts`) : 37 routes x 4 sous-rôles, l'égalité stricte des clés
  `EXPECTED` ↔ routes fait échouer toute nouvelle route `/v1/admin` sans entrée. Le garde s'exécute avant
  tout pipe ou intercepteur, un 403 `FORBIDDEN` y est donc bien le refus de permission.
- **Miroir web** (`apps/web/src/mocks/fixtures/accounts.ts:48-142`) : ensembles identiques au serveur pour
  les 4 sous-rôles admin et les sous-rôles tenant (fixtures MSW ; le vrai filtrage reste serveur).

[CONSTAT] P1-01 Test de disjonction admin/tenant incomplet par construction
Sévérité : Basse
Fichier : apps/api/test/unit/admin-permissions.test.ts:50-57
Preuve : `tenant` = COMPANY OWNER, MERCHANT OWNER, MERCHANT CASHIER, EMPLOYEE seulement. Aujourd'hui complet
car MANAGER, ACCOUNTANT, READ_ONLY sont des sous-ensembles de OWNER, mais rien ne l'impose.
Scénario d'attaque : un développeur ajoute à COMPANY ACCOUNTANT une permission `audit.read` (nom admin) ;
le test reste vert ; une route admin `@Can('audit.read')` sans `@Roles('ADMIN')` deviendrait lisible par
le comptable d'une entreprise (journal d'audit de toute la plateforme).
Correctif proposé : itérer sur tous les couples (rôle tenant, sous-rôle) de l'enum `SubRole`, plus FAMILY_MEMBER.
Exigence : SEC-P1 / ASVS 4.1.3

[CONSTAT] P1-02 Le balayage ne couvre que le préfixe /v1/admin
Sévérité : Basse
Fichier : apps/api/test/integration/admin-matrix.test.ts:80
Preuve : `route.path.startsWith('/v1/admin')`.
Scénario d'attaque : une future route `@Roles('ADMIN')` montée ailleurs (ex. `/v1/users/:id/unlock-pin`)
échappe à la garantie « nouvelle route admin sans entrée = échec » ; une erreur de `@Can` n'y serait pas vue.
Correctif proposé : sélectionner aussi les routes dont la métadonnée ROLES contient `ADMIN` (exposer ROLES
dans `test/routes.ts`), et échouer si une route ADMIN est hors du préfixe ou si une route du préfixe n'est pas ADMIN.
Exigence : ASVS 4.1.5

[CONSTAT] P1-03 `users.read` donné à Support : le masquage du solde devra être serveur, champ par champ
Sévérité : Basse (préventif, étape 2 ; aucune route `users.*` n'existe encore)
Fichier : apps/api/src/common/permissions.ts:116-123 (et 49 `userBalances.read`, utilisé par aucune route)
Scénario d'attaque : à l'étape 2, une fiche utilisateur `@Can('users.read')` renvoie le solde et seul le web
le masque ; un agent Support appelle l'API directement et lit les soldes des employés (décision D-4 violée).
Correctif proposé : dans le service, n'ajouter le champ solde que si la session détient `userBalances.read` ;
test HTTP Support sur la fiche : clé de solde absente du JSON.
Exigence : ASVS 4.2.1, 8.3.4

## Partie 2 : hooks locaux (diff non commité et .githooks/pre-push)

Apports réels : `git push --no-verify` bloqué, `.githooks/pre-push` exigé (échec fermé), variables
`GIT_CONFIG_*`/`GIT_DIR`/`GIT_INDEX_FILE`, alias persistants, sous-commande dynamique, `xargs git`, `eval`,
écriture directe dans `.git/config` bloqués ; faux positifs heredoc (texte libre) supprimés.
`.githooks/pre-push` : n'exécute que `git hash-object` et `gitleaks git --redact` sur des SHA fournis par git
(aucune donnée contrôlable injectée), échec fermé si gitleaks absent ou en erreur. Rien de dangereux.

Comparaison HEAD / arbre de travail, garde chargé en mémoire (sortie 2 = bloqué, 0 = accepté) :

| Commande | HEAD | Arbre |
| --- | --- | --- |
| `env bash <<'EOF'` + `git commit --no-verify -m x` | 2 | **0** |
| `source /dev/stdin <<'EOF'` + idem | 2 | **0** |
| `bash.exe`, `sudo sh`, `command bash` + heredoc `git commit -n` | 2 | **0** |
| `cd .git && sed -i '/hooksPath/d' config` | 2 | **0** |
| `bash <<'EOF'` + `git commit --no-verify` | 2 | 2 |
| `git push --no-verify origin x` | 0 | 2 |
| `node -e "…execSync('git commit -n …')"` | 0 | 0 (limite préexistante) |

[CONSTAT] H-01 Corps de heredoc ignoré quand l'interpréteur est préfixé ou lu par `source`
Sévérité : Moyenne
Fichier : .claude/hooks/guard-bash.js:57, 150, 166-170
Preuve : tableau ci-dessus ; `commandName` ne saute pas `env`/`command`/`exec`/`sudo`/`nohup`/`time`, ne retire
pas `.exe`, et `source`/`.` ne sont pas dans `SHELLS`. Avant le diff, le corps était découpé en commandes.
Scénario d'attaque : un agent poussé par une injection de prompt lance
`env bash <<'EOF'` / `git commit --no-verify -am x && git push --no-verify` / `EOF` : commit et push sans
gitleaks, secret publié sur le distant. Gravité limitée : `node -e`/`python -c` contournaient déjà le garde
avant le diff, et CI garde gitleaks (non revérifié ici).
Correctif proposé : échec fermé : analyser le corps comme des commandes, sauf si tous les segments sont des
consommateurs de données connus (`cat`, `tee`, `printf`, `echo`, `git commit -F -`) ; à défaut, réutiliser dans
`commandName` la liste de préfixes de `parseGit`, retirer `.exe`, ajouter `source` et `.`. Ajouter ces cas à `BLOCK`.
Exigence : S1-01, S1-02, S1-10 / ASVS 14.1.5

[CONSTAT] H-02 Contrôle textuel de `hooksPath` retiré des segments non git
Sévérité : Basse
Fichier : .claude/hooks/guard-bash.js:182-196
Preuve : `cd .git && sed -i '/hooksPath/d' config` passe (bloqué à HEAD).
Scénario d'attaque : désactivation de `core.hooksPath` par édition de `.git/config` depuis le dossier `.git`.
Atténué : `checkNativeHook` refuse ensuite tout commit ou push (échec fermé), mais un commit lancé par un
autre moyen (IDE, `node -e`) ne passerait plus par les hooks natifs.
Correctif proposé : garder pour les segments non git non lecture seule le test `/hooks\s*path/i` de HEAD, ou
bloquer `cd` vers `.git`.
Exigence : S1-01

[CONSTAT] H-03 Bit exécutable de `.githooks/pre-push` à fixer dans l'index
Sévérité : Basse
Fichier : .githooks/pre-push (non suivi) ; `git config core.filemode` = false
Preuve : `git ls-files -s .githooks` montre `100755` pour pre-commit ; un `git add` sous Windows avec
`filemode=false` enregistre `100644` pour un nouveau fichier.
Scénario d'attaque : sur un clone Linux/macOS, git ignore un hook non exécutable (avec un simple avertissement) ;
le garde ne vérifie que l'existence : push sans scan.
Correctif proposé : au commit, `git add --chmod=+x .githooks/pre-push`, puis vérifier `100755`.
Exigence : S1-09

**Peut-il être commité tel quel ?** Oui au regard de la règle du 2026-10-11 (aucun Critique ni Haute) : le
diff renforce nettement la protection (push, variables GIT_*, alias), mais l'affaiblit sur H-01 et H-02.
Recommandation : appliquer H-03 au moment du commit (une option) ; H-01 et H-02 à la discrétion de l'utilisateur.

## Vérifications lancées
- `git show --stat 29987df b680f18`, diffs ciblés ; lecture des fichiers listés et des mappers de `admin.service.ts`.
- `npx vitest run test/unit/admin-permissions.test.ts test/unit/route-permissions.test.ts` : 2 fichiers, 6 tests verts.
- `node --test .claude/hooks/test/guard-bash.test.js .claude/hooks/test/enforce-scope.test.js` : 133/133 verts
  (`node --test .claude/hooks/test/` échoue sous Windows : chemin de dossier non résolu par Node 22, sans lien avec le diff).
- Garde HEAD vs arbre de travail chargé en mémoire (`node -e`, aucun fichier écrit) : tableau ci-dessus.

## Non vérifié
- `admin-matrix.test.ts` non relancé (base PostgreSQL de test requise) : vert d'après la livraison.
- Double validation du KYC (décision A) : `POST kyc-files/:id/approve` appelle `decideKyc` directement ; le
  contrôle quatre yeux du service KYC n'a pas été relu (hors des fichiers de la tâche).
- Implémentation du garde global (`@Roles` + `@Can`) et de `/v1/me` : non relue, couverte par les tests cités.
- gitleaks en CI et `.gitleaks.toml` (liste d'exceptions modifiable) : non relus.
- Modèle de menaces non modifié : aucun nouvel actif ; la matrice C précise un contrôle existant.

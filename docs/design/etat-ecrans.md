# État des écrans web (mis à jour le 2026-10-31)

Source : `docs/design/specs/`, `navigation.md` (modules du cahier §5.6), routes de `apps/web/src/app/[locale]`. Conforme = revu sur captures (design + ux), écarts Hauts corrigés ; écarts Moyens/Bas restants dans les revues `docs/handoff/reviews/design-ux-*-captures-2026-10-30.md`.

| Espace | Écran | Spec | Codé | Revu sur captures |
|---|---|---|---|---|
| Commun | Connexion, MFA (+ activation), première connexion, mot de passe oublié, session expirée, 404, Accès refusé, accueil, aide | oui (sauf accueil, aide) | oui | oui, Hautes corrigées |
| Commun | Bibliothèque `/dev/composants`, Paramètres du compte, Support | oui | oui | oui (via Commerçant, Entreprise) |
| Commerçant | Tableau de bord, Encaissement (+ résultat), Historique (+ détail), Créances, Virements (+ détail), Règlements, Mon commerce, Statistiques, Paramètres, Support | oui | oui | oui, Hautes corrigées sauf « Virements : séparer demande et suivi, carte Destination » (Moyenne restante) |
| Entreprise | Tableau de bord, Employés, Import CSV, Commandes (+ nouvelle, détail), Attribution, Factures, Reporting, Paramètres, Support | oui | oui | oui, Hautes corrigées |
| Administrateur | Tableau de bord, Commerçants (+ fiche), Entreprises, Utilisateurs (+ fiche), KYC (+ dossier), Commissions, Commandes (+ détail), Virements (+ détail), Validations, Règlements (+ lot), Transactions, Sécurité & conformité, Reporting, Audit, Messages (+ détail), Paramétrage | oui | oui | oui, Hautes corrigées |

Captures : `docs/design/captures/<commun|commercant|entreprise|admin>/<écran>-<fr|ar>-<desktop|mobile>.jpg` (locales, non versionnées ; régénérer avec `e2e/captures.spec.ts`).

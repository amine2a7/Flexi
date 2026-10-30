# Spec design – Entreprise › Commandes (liste, nouvelle commande, détail)
**Statut :** rétro-spec de l'écran existant (design web, mode continu, 2026-10-30) · **Auteur :** lead · **Routes :** `/entreprise/commandes`, `/entreprise/commandes/nouvelle`, `/entreprise/commandes/{id}` · **Permissions :** `orders.read` (liste, détail), `orders.create` (nouvelle, annuler), `orders.declareTransfer` (déclarer le virement)
**Contrat :** `GET/POST /v1/company/orders`, `POST /v1/company/order-quotes`, `POST /v1/company/orders/{id}/cancel`, `POST /v1/company/orders/{id}/transfer-declarations`, `GET /v1/company/funding-account`.

## 1. Objectif
Commander des crédits par type, payer par virement (référence de paiement), déclarer le virement avec sa preuve, suivre la validation. **Action principale :** liste « Nouvelle commande » ; nouvelle « Confirmer la commande » ; détail selon l'état (« Déclarer le virement » ou « Annuler »).
## 2. Structure
- **Liste** : `PageHeader` « Mes commandes » ; `FilterBar` (statut) ; `DataTable` (référence, date, crédits, frais, total mis en avant, statut `OrderStatusBadge`) ; cartes sous `breakpoint.md`.
- **Nouvelle** : lignes par type de crédit (montant TND), devis serveur (crédits, frais, total), confirmation avec récapitulatif ; écran de fin « Commande enregistrée » avec la référence de paiement.
- **Détail** : récapitulatif (`OrderSummaryCard`), compte de versement (`FundingAccountCard`, IBAN copiable), formulaire de déclaration (référence, date, montant, preuve PDF/JPEG/PNG), historique (`Timeline`).
## 3. États
Squelette, erreur + réessayer, vide (« Aucune commande » + action), conflit d'état (409 : rechargement annoncé).
## 4. Textes
`company.orders.*`, `company.newOrder.*`, `orders.*`. Aucun calcul de frais côté web (devis du serveur).

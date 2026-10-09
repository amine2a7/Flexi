# Spec 07 – Espace Commerçant (web + Flutter Pro)
**Phase 6 · Cahier :** COM-01 à COM-11, RG-1.5, RG-5

## 1. Objectif
Encaisser, suivre les ventes et créances, demander un virement avec simulation de la commission.

## 2. Règles
- Encaissement : scan du QR client ou saisie du code ; validation instantanée ; affichage prénom + initiale, catégorie, compte à rebours du QR. **Aucun solde du client** (COM-04 v4.1). Résultat : « accepté » ou « refusé » (`PAYMENT_DECLINED`, sans motif ni montant ; texte « Paiement refusé. Le client peut vérifier son application. »). Une seule initiation par QR.
- Le commerçant est crédité du **brut** ; la commission n'est visible et prélevée qu'à la demande de virement.
- **Simulation** (`GET /payouts/quote`) : montant demandé, taux, commission, net. La demande (`POST /payouts`) fige le taux et rappelle la simulation ; si le profil a changé entre la simulation et la demande, le serveur refuse et renvoie une nouvelle simulation.
- Seuil minimum de virement ; créances en litige exclues.
- Rôles : propriétaire (tout), caissier (encaisser et historique), comptable (règlements et factures).
- Annulation d'une transaction : demande motivée, validée par l'Administrateur (jamais par le commerçant seul).

## 3. API (extraits)
`POST /merchant/payments` (saisie du montant après scan) · `GET /merchant/sales?from&to` · `GET /merchant/receivables` · `GET /payouts/quote?amount=` · `POST /payouts` (Idempotency-Key) · `GET /merchant/settlements` · `GET /merchant/invoices`.

## 4. Tests
E3, E4, E5, E6, E14 ; caissier ne peut pas demander de virement ; changement de profil entre simulation et demande ; commerçant A ne voit pas les ventes de B ; paiement refusé si commerçant suspendu.

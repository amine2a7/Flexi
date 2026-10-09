# Spec 09 – Notifications, audit et reporting
**Phases 3 à 8 · Cahier :** section 11, SEC-L*

## 1. Notifications
Canaux : push (FCM/APNs), SMS, email, in-app. Modèles FR/AR/EN versionnés. Événements : compte créé (mot de passe temporaire), commande validée, crédit reçu, expiration J-30/J-7, paiement effectué, virement exécuté, litige ouvert, connexion depuis un nouvel appareil, changement de RIB.
Règles : aucun lien de connexion dans les SMS ; pas de montant détaillé sur l'écran verrouillé (paramétrable) ; préférences par utilisateur (sauf alertes de sécurité) ; file BullMQ avec réessais et dédoublonnage.

## 2. Journal d'audit
Table `audit_log` append-only : id, horodatage, acteur, rôle, action, ressource, avant/après (champs sensibles masqués), IP, appareil, `prev_hash`, `hash` (chaînage). Vérification d'intégrité périodique (job) avec alerte. Consultation réservée à Conformité.

## 3. Reporting
Tableaux de bord (Administrateur, Entreprise, Commerçant) alimentés par des vues matérialisées rafraîchies ; exports PDF/Excel asynchrones avec lien signé à durée courte ; aucune requête lourde sur la base transactionnelle en pointe.

## 4. Tests
Notification envoyée et dédoublonnée ; modification manuelle d'une ligne d'audit détectée par la vérification de chaîne ; export respecte l'isolation par tenant.

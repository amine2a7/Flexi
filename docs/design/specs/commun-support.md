# Spec design – Commun › Support
**Statut :** écrite et codée en mode continu (2026-10-30) · **Auteur :** lead · **Routes :** `/commercant/support`, `/entreprise/support` (composant partagé `SupportPage`) · **Permission :** toute session de l'espace
**Contrat :** `POST /v1/public/contact-messages` (formulaire de contact existant, limité en débit).

## 1. Objectif
Trouver la réponse à une question fréquente de son espace, sinon écrire à l'équipe FlexiPay. **Action principale :** « Envoyer » (formulaire de contact).

## 2. Structure
1. `PageHeader` « Support ».
2. Carte **Rubriques d'aide** : rubriques « Compte » + rubriques de l'espace (mêmes que la page Aide), chaque lien ouvre `/aide#<section>` (cible ≥ `size.touch-target-min`, icône + texte).
3. Carte **Nous écrire** : `ContactForm` (même composant que la page d'accueil).

## 3. États, RTL, accessibilité
États du formulaire de contact (envoi, succès, erreur, 429) ; liste sémantique `ul` ; icônes décoratives `aria-hidden`.

## 4. À confirmer par Amine
Préremplir nom et e-mail depuis la session ; suivi des demandes (tickets) : hors périmètre du MVP.

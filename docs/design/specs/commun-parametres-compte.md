# Spec design – Commun › Paramètres du compte
**Statut :** écrite et codée en mode continu (2026-10-30) · **Auteur :** lead · **Routes :** `/commercant/parametres`, `/entreprise/parametres` (composant partagé `AccountSettings`) · **Permission :** toute session de l'espace
**Contrat :** `GET /v1/me` (profil, `mfa`), `POST /v1/auth/password/change` (`currentPassword`, `newPassword`).

## 1. Objectif
Gérer ce qui appartient à la personne (pas à l'organisation) : profil en lecture, langue, mot de passe, état de la double authentification. **Action principale :** « Changer le mot de passe ».

## 2. Structure (grille 2 colonnes dès `breakpoint.lg`)
1. Carte **Profil** (`DescriptionList` : nom, rôle · sous-rôle, espace) + aide « Pour modifier ces informations, contactez l'administrateur de votre organisation. »
2. Carte **Langue** : sélecteur de langue commun (`LocaleSwitcher`).
3. Carte **Mot de passe** : mot de passe actuel, `PasswordFields` (règles, confirmation), erreurs de l'API en ligne, succès persistant (`role="status"`) « Mot de passe modifié. Vos autres sessions ont été fermées. »
4. Carte **Double authentification** : état (Activée / Non activée), codes de secours restants, aide en cas de téléphone perdu.

## 3. États
Bouton désactivé tant que les champs sont vides ou la confirmation différente ; envoi `loading` ; erreur API en `Alert danger` (saisie conservée).

## 4. À confirmer par Amine
Régénération des codes de secours depuis cette page ; paramètres de l'organisation (notifications, informations légales) pour l'entreprise : à spécifier.

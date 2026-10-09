# Charte graphique FlexiPay
Reprise de la démo CrediFlow, corrigée pour le cahier v4 (rôles Entreprise / Employé / Commerçant, sans IR). **Les valeurs font foi dans `design-tokens.json`.**

## 1. Positionnement
Confiance, sécurité, simplicité, modernité, contrôle financier, efficacité. Base bleu nuit, accents verts pour les crédits disponibles, validations et réussites. Pas de style bancaire froid, pas d'interface administrative surchargée.

## 2. Couleurs
Voir tokens. **Règles d'usage :**
- Le vert `#10B981` sert aux **fonds, icônes, barres** ; le **texte vert** utilise `#047857` (contraste AA).
- Bouton vert : texte `#0B1D33`, jamais blanc.
- `#94A3B8` est décoratif uniquement.
- Les couleurs fonctionnelles (ambre, rouge, bleu) sont réservées aux statuts.

## 3. Typographie
Inter (ou Geist Sans) ; arabe : IBM Plex Sans Arabic ou Noto Sans Arabic. Échelle dans les tokens. **Montants :** poids 700, taille `amount`, devise en `currency` (ex. **48 250,000** TND). Formats (tranché le 2026-10-09, cahier v4.1) : **FR et AR `48 250,000 TND`** (séparateur de milliers espace, 3 décimales, virgule décimale ; chiffres occidentaux en arabe) ; **EN `48,250.000 TND`**.

## 4. Grille et espacement
Mobile-first, largeur max 1280 px, multiples de 4/8, cartes espacées de 16–24, sections de 24–40, padding mobile 16–20, desktop 24–32.

## 5. Composants
| Composant | Règle |
|---|---|
| Carte desktop | rayon 16, bordure fine, ombre `card` |
| Carte mobile | rayon 24 (32 pour la carte solde) |
| Bouton | hauteur 44, rayon 12 ; un seul bouton principal par écran |
| Champ | hauteur 44, rayon 12, label au-dessus, erreur sous le champ avec icône et texte |
| Badge | pilule, fond doux + texte foncé (voir `status`) |
| Toast | vert (réussite) et information : fermeture automatique après 4 s ; rouge (erreur) : **sans fermeture automatique**, fermeture manuelle (WCAG 2.2.1, tranché le 2026-10-09) ; accessible (`role=status/alert`) |
| Tableau | en-tête collant, tri, filtres, pagination ; **en cartes sur mobile** |
| Modale | confirmation visuelle pour toute action sensible |
| Navigation desktop | sidebar bleu nuit 264 px : logo, profil + rôle, modules, déconnexion en bas |
| Navigation mobile Employé | header bleu nuit + avatar, carte solde blanche, wallets en grille 2 colonnes, actions rapides, liste de transactions ; barre basse **Accueil · Payer · Où dépenser · Historique · Profil** ; pour un **membre famille** : **Accueil · Payer · Historique · Profil** (sans « Où dépenser », tranché le 2026-10-09) |
| Navigation mobile Commerçant | barre basse **Accueil · Encaisser · Règlements · Historique · Profil** |

## 6. Icônes (Lucide)
WalletCards (solde), QrCode (paiement), Users (famille), Store (commerçants), ArrowUpRight (virements), FileText (factures), Check (validation), Settings2 (paramétrage), MapPin (où dépenser), Bell (notifications). Un label accompagne toute action ambiguë.

## 7. États obligatoires pour chaque écran
Chargement (squelette), vide (illustration + action), erreur (message + réessayer), hors connexion, session expirée, solde insuffisant (rouge, montant manquant ; **pour l'employé payeur uniquement** : le commerçant voit un refus générique, le membre famille ne voit jamais le solde de l'employé), permission refusée.

## 8. Accessibilité
Contraste AA, focus visible, navigation clavier (web), cibles ≥ 44 px (48 dp mobile), labels pour lecteurs d'écran, ne jamais transmettre une information par la couleur seule (icône + texte dans les badges), respect de la taille de police système.

## 9. Internationalisation et RTL
FR par défaut, AR (RTL) et EN. Utiliser `start/end` (jamais gauche/droite en dur), icônes directionnelles miroir, tester chaque écran en RTL.

## 10. Écrans spécifiques à concevoir
- Première connexion : bannière « mot de passe temporaire », changement obligatoire, création du PIN.
- QR employé : QR large, compte à rebours circulaire 60 s, « Rafraîchir », capture d'écran bloquée.
- Validation commerçant : client (prénom + initiale), catégorie, montant, compte à rebours ; **aucun solde ni motif de refus** (COM-04 v4.1, tranché le 2026-10-09).
- **Création société / commerçant : liste déroulante « Profil de commission ».**
- **Demande de virement : brut → commission (taux) → net en grand, confirmation.**
- Profils de commission (Administrateur) : tableau, historique, double validation.
- Famille : compteur « 3 / 4 », limites, suspension.
- Écrans de sécurité : session expirée, appareil nouveau, compte verrouillé.

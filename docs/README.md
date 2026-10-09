# Documentation FlexiPay

| Document | Contenu |
|---|---|
| `cahier-des-charges.md` | Source de vérité fonctionnelle (v4) |
| `architecture.md` | Stack, structure du dépôt, flux techniques |
| `roadmap.md` | Phases, livrables, critères de fin |
| `open-questions.md` | Décisions à prendre (juridique, métier, technique) |
| `glossaire-regles-metier.md` | Définitions et exemples chiffrés (pour les tests) |
| `design/` | Charte graphique, design tokens, checklist Figma |
| `security/` | Exigences, modèle de menaces, checklist ASVS/MASVS |
| `specs/` | Une spec par module (entrée de chaque développement) |
| `adr/` | Décisions d'architecture |
| `handoff/` | Équipe d'agents : protocole, tableau des tâches, décisions, contrats, revues, rapports |

**Ordre de lecture pour un nouveau développeur :** cahier → architecture → glossaire → spec du module.
**Règle :** toute décision qui change une règle métier met à jour le cahier **et** la spec concernée.

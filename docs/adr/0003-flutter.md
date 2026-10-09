# ADR 0003 – Mobile en Flutter
**Statut :** accepté
**Décision :** deux apps Flutter (Employé, Pro/commerçant) depuis le même dépôt.
**Raisons :** interface identique sur iOS/Android, code compilé natif (obfuscation intégrée), bon support RTL.
**Conséquences :** client API généré en Dart depuis OpenAPI ; tokens de design générés pour Flutter ; les règles métier restent côté serveur.

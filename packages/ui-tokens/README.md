# @flexipay/ui-tokens

Source unique : `docs/design/design-tokens.json`. Ce paquet en génère deux sorties, sans aucune valeur en dur dans le code.

| Sortie | Fichier | Consommateur |
|---|---|---|
| Preset Tailwind (CJS + types) | `generated/tailwind-preset.cjs` | `apps/web` |
| Constantes Dart + `FlexiTheme.light()` | `dart/lib/flexipay_tokens.dart` | `apps/mobile-employe`, `apps/mobile-pro` |

## Commandes
- `pnpm --filter @flexipay/ui-tokens generate` (ou `build`) : régénère les sorties. **Les fichiers générés sont commités** ; un test échoue s'ils ne sont pas à jour.
- `lint`, `typecheck`, `test` (dont contrastes WCAG AA et couverture de chaque token).

## Web
```ts
import preset from '@flexipay/ui-tokens/tailwind-preset';
export default { presets: [preset], content: [...] };
```
Le preset **remplace** les valeurs par défaut de Tailwind (`theme.colors`, `spacing`, `borderRadius`, `fontSize`, `fontFamily`, `fontWeight`, `boxShadow`, `screens`, `opacity`). Espacements, rayons, tailles et typographie sont en `rem` (px / 16, respect de la taille de police système) ; breakpoints en `px`. Clés non standard exposées dans `theme` : `size`, `motion` (ms), `focus`, `status` (icône Lucide, clé i18n, noms de couleurs bg/fg). Palette sombre optionnelle : `dark-*` (`bg-dark-bg`).

## Mobile (Flutter)
Dépendance par chemin : `flexipay_tokens: { path: ../../packages/ui-tokens/dart }`, puis `import 'package:flexipay_tokens/flexipay_tokens.dart';`.
Classes : `FlexiColors`, `FlexiColorsDark`, `FlexiSpace` (`space1`..`space12`), `FlexiRadius`, `FlexiSize` (dont `focusWidth`, `focusOffset`), `FlexiOpacity`, `FlexiBreakpoint`, `FlexiMotion`, `FlexiShadow`, `FlexiFont`, `FlexiTypeScale` (`TextStyle`), `FlexiStatus.all`, `FlexiTheme.light()`.
Nommage : kebab-case du JSON en camelCase (`text-muted` -> `textMuted`). Le thème sombre n'est pas généré (marqué « à valider » dans la charte). Compilation et `flutter test` : à faire quand Flutter sera installé (le Dart est pour l'instant vérifié par tests structurels côté Node).

## Ajouter ou modifier un token
Modifier uniquement le JSON, lancer `generate`, commiter les sorties. Un changement de couleur doit rester AA (tests de contraste) et être annoncé à frontend et mobile.

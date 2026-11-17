import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

import 'app/app.dart';
import 'app/dependencies.dart';

/// Les fausses données (et leurs mots de passe libres, PIN 0000 refusé, réglages de démo)
/// ne sont branchées que dans un build de démo : `--dart-define=FP_DEMO=true`.
/// Les Repository de l'API réelle sont branchés en M5.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: kDemoBuild ? fakeDataOverrides() : const [],
      child: const FlexiPayApp(),
    ),
  );
}

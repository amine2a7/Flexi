import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

import 'app/app.dart';
import 'app/dependencies.dart';

/// Même code, deux builds : `--dart-define=FP_DEMO=true` branche les fausses données (mots de
/// passe libres, réglages de démo) ; sinon les Repository de l'API, à l'adresse
/// `--dart-define=API_URL=…`.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: kDemoBuild ? fakeDataOverrides() : apiOverrides(),
      child: const FlexiPayProApp(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';

import 'app_router.dart';

/// App bénéficiaire « FlexiPay ».
class FlexiPayApp extends ConsumerWidget {
  const FlexiPayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => FpL10n.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: FpTheme.light(),
      locale: locale,
      supportedLocales: supportedAppLocales,
      localizationsDelegates: const [
        FpL10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: ref.watch(routerProvider),
    );
  }
}

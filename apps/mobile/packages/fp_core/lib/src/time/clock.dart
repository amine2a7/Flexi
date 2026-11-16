import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Horloge injectable : l'heure réelle en production, une date fixe pour la démonstration et les tests.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Date de référence des fausses données (samedi 14 novembre 2026, 13:30).
final DateTime demoNow = DateTime(2026, 11, 14, 13, 30);

/// Vrai si [a] et [b] tombent le même jour.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Profil affiché dans l'onglet Profil.
class Profile {
  const Profile({
    required this.fullName,
    required this.company,
    required this.department,
    required this.jobTitle,
    required this.paymentCount,
    required this.merchantCount,
    required this.familyCount,
    required this.hrName,
    required this.hrEmail,
    required this.supportEmail,
  });

  final String fullName;
  final String company;
  final String department;
  final String jobTitle;
  final int paymentCount;
  final int merchantCount;
  final int familyCount;
  final String hrName;
  final String hrEmail;
  final String supportEmail;
}

abstract interface class ProfileRepository {
  Future<Profile> profile();
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => throw UnimplementedError('profileRepositoryProvider'),
);

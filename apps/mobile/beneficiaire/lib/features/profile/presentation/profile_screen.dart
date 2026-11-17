import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';
import 'package:fp_ui/fp_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/data_providers.dart';
import '../../family/domain/family.dart';

/// Profil : identité, apparence (thème, langue), compte et sécurité, aide, déconnexion.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const _locales = [Locale('fr'), Locale('ar'), Locale('en')];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = FpL10n.of(context);
    final profile = ref.watch(profileProvider).value;
    final prefs = ref.watch(profilePrefsProvider);
    final locale = ref.watch(localeProvider);
    final session = ref.watch(authControllerProvider).session;
    final isFamily = session?.role == UserRole.familyMember;
    void setPrefs(ProfilePrefs p) =>
        ref.read(profilePrefsProvider.notifier).update(p);
    final job = [
      profile?.company,
      profile?.department,
      profile?.jobTitle,
    ].whereType<String>().where((s) => s.isNotEmpty).join(' · ');
    return FpTabScroll(
      gap: FpSpace.x14,
      children: [
        Semantics(
          label: l10n.myProfile,
          container: true,
          child: FpCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Avatar(
                      initial: (profile?.fullName ?? ' ')[0],
                      color: isFamily ? FpColors.gifts : FpColors.food,
                      size: 64,
                    ),
                    const SizedBox(width: FpSpace.x14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?.fullName ?? '',
                            style: FpText.body(
                              size: 20,
                              weight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            job,
                            style: FpText.body(size: 13, color: FpColors.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: FpSpace.x16),
                StatRow(
                  stats: [
                    (
                      '${profile?.paymentCount ?? 0}',
                      l10n.statPayments(profile?.paymentCount ?? 0),
                    ),
                    (
                      '${profile?.merchantCount ?? 0}',
                      l10n.statMerchants(profile?.merchantCount ?? 0),
                    ),
                    (
                      '${profile?.familyCount ?? 0}',
                      l10n.statFamilyMembers(profile?.familyCount ?? 0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        CapsLabel(l10n.appearance),
        FpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.theme, style: FpText.body(weight: FontWeight.w600)),
              const SizedBox(height: FpSpace.x10),
              // Sombre et Système masqués tant qu'il n'existe pas de palette sombre.
              SegmentedChoice(
                label: l10n.theme,
                options: [l10n.themeLight],
                selected: 0,
                onSelected: (_) {},
              ),
              const SizedBox(height: FpSpace.x16),
              Text(l10n.language, style: FpText.body(weight: FontWeight.w600)),
              const SizedBox(height: FpSpace.x10),
              SegmentedChoice(
                label: l10n.language,
                options: [l10n.langFr, l10n.langAr, l10n.langEn],
                selected: _locales.indexWhere(
                  (l) => l.languageCode == locale.languageCode,
                ),
                onSelected: (i) {
                  ref.read(localeProvider.notifier).select(_locales[i]);
                  if (_locales[i].languageCode == 'ar') context.go(Routes.home);
                },
              ),
            ],
          ),
        ),
        CapsLabel(l10n.accountSecurity),
        ListGroup(
          children: [
            if (!isFamily)
              ListRow(
                leading: const IconTile(
                  tint: FpColors.giftsTint,
                  color: FpColors.gifts,
                  icon: FpIcons.family,
                  size: 40,
                ),
                title: l10n.familyAccounts,
                subtitle: l10n.familyUsage(
                  profile?.familyCount ?? 0,
                  maxFamilyMembers,
                ),
                chevron: true,
                onTap: () => context.push(Routes.family),
              ),
            ListRow(
              leading: const IconTile(
                tint: FpColors.clothingTint,
                color: FpColors.clothing,
                icon: FpIcons.lock,
                size: 40,
              ),
              title: l10n.changePin,
              subtitle: l10n.pinDigits,
              chevron: true,
              onTap: () => context.push(Routes.changePin),
            ),
            ListRow(
              leading: const IconTile(
                tint: FpColors.greenTint,
                color: FpColors.greenDark,
                icon: FpIcons.fingerprint,
                size: 40,
              ),
              title: l10n.biometricLogin,
              trailing: FpSwitch(
                value: prefs.biometric,
                label: l10n.biometricLogin,
                onChanged: (v) => setPrefs(prefs.copyWith(biometric: v)),
              ),
            ),
            ListRow(
              leading: const IconTile(
                tint: FpColors.fuelTint,
                color: FpColors.fuel,
                icon: FpIcons.bell,
                size: 40,
              ),
              title: l10n.notificationsSetting,
              trailing: FpSwitch(
                value: prefs.notifications,
                label: l10n.notificationsSetting,
                onChanged: (v) => setPrefs(prefs.copyWith(notifications: v)),
              ),
            ),
          ],
        ),
        FpPressable(
          semanticLabel: l10n.needHelp,
          onTap: () => context.push(Routes.help),
          child: Container(
            constraints: const BoxConstraints(minHeight: 96),
            decoration: BoxDecoration(
              color: FpColors.greenTint,
              borderRadius: BorderRadius.circular(FpRadius.card),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    16,
                    16,
                    120,
                    16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.needHelp,
                        style: FpText.body(
                          size: 16,
                          weight: FontWeight.w700,
                          color: FpColors.navy,
                        ),
                      ),
                      const SizedBox(height: FpSpace.x6),
                      Text(
                        l10n.needHelpSubtitle,
                        style: FpText.body(
                          size: 13,
                          color: FpColors.inkSoft,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const PositionedDirectional(
                  end: 10,
                  bottom: -4,
                  child: Mascot(size: 96),
                ),
              ],
            ),
          ),
        ),
        FpButton(
          label: l10n.logout,
          icon: FpIcons.logout,
          variant: FpButtonVariant.danger,
          onPressed: () async {
            await ref.read(authControllerProvider.notifier).logout();
            if (context.mounted) context.go(Routes.login);
          },
        ),
      ],
    );
  }
}

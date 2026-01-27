import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../data/user_repo.dart';
import '../../models/user_profile.dart';

// ملفاتك الحالية حسب الصورة:
import 'drawer_header.dart';
import 'drawer_my_info_section.dart';
import 'dialogs/confirm_dialog.dart';
import 'dialogs/about_dialog.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    required this.uid,
    required this.userRepo,
    required this.onToggleLanguageConfirmed,
    required this.onLogoutConfirmed,
    required this.onEditLocation,
  });

  final String uid;
  final UserRepo userRepo;

  // ✅ نفس الأسماء التي تستعملها في home_screen.dart
  final Future<void> Function() onToggleLanguageConfirmed;
  final Future<void> Function() onLogoutConfirmed;
  final void Function(UserProfile profile) onEditLocation;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Drawer(
      // بدون حواف ناعمة
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: StreamBuilder<UserProfile>(
          stream: userRepo.watchUser(uid),
          builder: (context, snap) {
            if (snap.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('${t.somethingWentWrong}: ${snap.error}'),
                ),
              );
            }
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final profile = snap.data!;
            final fullName = profile.fullName.trim().isEmpty
                ? t.guest
                : profile.fullName.trim();

            return ListView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              children: [
                DrawerHeaderCard(name: fullName, email: profile.email.trim()),
                const SizedBox(height: 12),

                DrawerMyInfoSection(
                  profile: profile,
                  userRepo: userRepo,
                  onProceedEditLocation: onEditLocation,
                ),

                const SizedBox(height: 10),

                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(t.changeLanguage),
                  onTap: () async {
                    Navigator.pop(context); 
                    await Future<void>.delayed(
                      const Duration(milliseconds: 10),
                    );
                    if (!context.mounted) return;

                    await showConfirmDialog(
                      context,
                      title: t.confirmChangeLanguageTitle,
                      message: t.confirmChangeLanguageBody,
                      confirmText: t.confirmChangeLanguageCta,
                      onConfirm:
                          onToggleLanguageConfirmed, 
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(t.logout),
                  onTap: () async {
                    Navigator.pop(context); 
                    await Future<void>.delayed(
                      const Duration(milliseconds: 10),
                    );
                    if (!context.mounted) return;

                    await showConfirmDialog(
                      context,
                      title: t.confirmLogoutTitle,
                      message: t.confirmLogoutBody,
                      confirmText: t.confirmLogoutCta,
                      destructive: true,
                      onConfirm:
                          onLogoutConfirmed, 
                    );
                  },
                ),

                const Divider(height: 22),

                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(t.aboutUs),
                  onTap: () => showAboutDialogX(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

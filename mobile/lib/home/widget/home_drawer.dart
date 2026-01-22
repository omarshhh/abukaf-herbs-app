import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    required this.firstName,
    this.email,
    required this.onOpenSettings,
    required this.onOpenAbout,
  });

  final String firstName;
  final String? email;

  final VoidCallback onOpenSettings;
  final VoidCallback onOpenAbout;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(
                firstName,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: email == null || email!.trim().isEmpty
                  ? null
                  : Text(email!),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(t.settings),
              onTap: onOpenSettings,
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(t.aboutUs),
              onTap: onOpenAbout,
            ),

            const Spacer(),

            // لاحقاً: Logout / Language / Theme
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

Future<void> showAboutDialogX(BuildContext context) async {
  final t = AppLocalizations.of(context)!;

  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(t.aboutUs),
      content: SingleChildScrollView(child: Text(t.aboutUsBody)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t.close)),
      ],
    ),
  );
}

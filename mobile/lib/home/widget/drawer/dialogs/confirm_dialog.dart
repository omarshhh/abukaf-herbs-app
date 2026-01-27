import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

Future<void> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmText,
  required Future<void> Function() onConfirm,
  bool destructive = false,
}) async {
  final t = AppLocalizations.of(context)!;

  await showDialog(
    context: context,
    useRootNavigator: true,
    builder: (ctx) {
      bool loading = false;

      return StatefulBuilder(
        builder: (ctx, setSt) {
          Future<void> run() async {
            if (loading) return;
            setSt(() => loading = true);

            Navigator.pop(ctx);
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              try {
                await onConfirm();
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${t.somethingWentWrong}: $e')),
                );
              }
            });
          }

          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(t.cancel),
              ),
              FilledButton(
                onPressed: run,
                style: destructive
                    ? FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                      )
                    : null,
                child: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(confirmText),
              ),
            ],
          );
        },
      );
    },
  );
}

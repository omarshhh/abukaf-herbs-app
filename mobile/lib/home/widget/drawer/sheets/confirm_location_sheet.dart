import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

Future<void> showConfirmLocationSheet(
  BuildContext context, {
  required VoidCallback onProceed,
}) async {
  final t = AppLocalizations.of(context)!;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    showDragHandle: true,
    builder: (ctx) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    t.editLocation,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),

            _Notice(text: t.editWarningOutForDelivery),

            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  onProceed();
                },
                icon: const Icon(Icons.location_on_outlined),
                label: Text(t.continueText),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

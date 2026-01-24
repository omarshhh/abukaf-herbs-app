import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.subTotal,
    required this.deliveryFee,
    required this.total,
  });

  final double subTotal;
  final double deliveryFee;
  final double total;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Widget row(String label, String value, {bool strong = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: strong ? FontWeight.w900 : FontWeight.w800,
                  color: cs.onSurface.withOpacity(strong ? 0.90 : 0.70),
                ),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: strong ? FontWeight.w900 : FontWeight.w800,
                color: strong ? cs.tertiary : cs.onSurface.withOpacity(0.75),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: cs.outlineVariant.withOpacity(0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cs.primary.withOpacity(0.18)),
                  ),
                  child: Icon(
                    Icons.summarize_outlined,
                    size: 20,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  t.orderSummaryTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            row(
              t.labelSubtotal,
              '${subTotal.toStringAsFixed(3)} ${t.currencyJOD}',
            ),
            row(
              t.labelDeliveryFee,
              '${deliveryFee.toStringAsFixed(3)} ${t.currencyJOD}',
            ),
            Divider(color: cs.outlineVariant.withOpacity(0.6)),
            row(
              t.labelGrandTotal,
              '${total.toStringAsFixed(3)} ${t.currencyJOD}',
              strong: true,
            ),
          ],
        ),
      ),
    );
  }
}

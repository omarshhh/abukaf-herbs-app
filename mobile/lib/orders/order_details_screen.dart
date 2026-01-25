import 'package:flutter/material.dart';
import 'package:mobile/orders/models/order_model.dart';
import 'package:mobile/l10n/app_localizations.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text('${t.ordersTitle} • ${order.id}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
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
                  Text(
                    '${t.labelGrandTotal}: ${order.total.toStringAsFixed(3)} ${order.currency}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.tertiary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${t.labelSubtotal}: ${order.subTotal.toStringAsFixed(3)} ${order.currency}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${t.labelDeliveryFee}: ${order.deliveryFee.toStringAsFixed(3)} ${order.currency}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            t.labelItems,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),

          ...order.items.map((it) {
            final name = isRtl
                ? (it.nameAr.trim().isNotEmpty ? it.nameAr : it.nameEn)
                : (it.nameEn.trim().isNotEmpty ? it.nameEn : it.nameAr);

            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: cs.outlineVariant.withOpacity(0.6)),
              ),
              child: ListTile(
                leading: Icon(Icons.local_florist_outlined, color: cs.primary),
                title: Text(
                  name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                subtitle: Text(
                  '${t.labelQty}: ${it.qty} • ${it.unitPrice.toStringAsFixed(3)} ${order.currency}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: Text(
                  it.lineTotal.toStringAsFixed(3),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.tertiary,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

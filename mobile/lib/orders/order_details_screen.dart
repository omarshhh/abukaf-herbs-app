import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mobile/orders/models/order_model.dart';
import 'package:mobile/l10n/app_localizations.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final OrderModel order;

  static const String _supportPhone = '07916711117';

  String _statusLabel(AppLocalizations t, String s) {
    switch (s) {
      case 'pending':
        return t.orderStatusPending;
      case 'preparing':
        return t.orderStatusPreparing;
      case 'delivering':
        return t.orderStatusDelivering;
      case 'delivered':
        return t.orderStatusDelivered;
      case 'cancelled':
        return t.orderStatusCancelled;
      default:
        return s;
    }
  }

  ({Color bg, Color fg, IconData icon}) _statusStyle(
    ColorScheme cs,
    String status,
  ) {
    switch (status) {
      case 'delivered':
        return (
          bg: cs.tertiaryContainer,
          fg: cs.onTertiaryContainer,
          icon: Icons.check_circle_outline,
        );
      case 'cancelled':
        return (
          bg: cs.errorContainer,
          fg: cs.onErrorContainer,
          icon: Icons.cancel_outlined,
        );
      case 'delivering':
        return (
          bg: cs.primaryContainer,
          fg: cs.onPrimaryContainer,
          icon: Icons.local_shipping_outlined,
        );
      case 'preparing':
        return (
          bg: cs.secondaryContainer,
          fg: cs.onSecondaryContainer,
          icon: Icons.inventory_2_outlined,
        );
      case 'pending':
      default:
        return (
          bg: cs.surfaceContainerHighest,
          fg: cs.onSurface,
          icon: Icons.hourglass_empty,
        );
    }
  }

  String _fmtNum(double v) {
    final isInt = v.toInt().toDouble() == v;
    if (isInt) return v.toInt().toString();
    return v.toStringAsFixed(3).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  String _unitAbbr(String unitRaw) {
    final s = unitRaw.toLowerCase();
    if (s.contains('gram')) return 'g';
    if (s.contains('kilogram')) return 'kg';
    if (s.contains('ml')) return 'ml';
    if (s.contains('liter')) return 'L';
    return 'pc';
  }

  Future<void> _callSupport(BuildContext context) async {
    final uri = Uri.parse('tel:$_supportPhone');
    final ok = await launchUrl(uri);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not start phone call')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final st = _statusStyle(cs, order.status);
    final statusText = _statusLabel(t, order.status);

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: st.bg,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(st.icon, size: 18, color: st.fg),
                  const SizedBox(width: 6),
                  Text(
                    statusText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: st.fg,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Call',
            onPressed: () => _callSupport(context),
            icon: const Icon(Icons.call_outlined),
          ),
        ],
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
                    textDirection: TextDirection.ltr, 
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.tertiary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${t.labelSubtotal}: ${order.subTotal.toStringAsFixed(3)} ${order.currency}',
                    textDirection: TextDirection.ltr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${t.labelDeliveryFee}: ${order.deliveryFee.toStringAsFixed(3)} ${order.currency}',
                    textDirection: TextDirection.ltr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

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

            final unit = _unitAbbr(it.unit);

            final qtyLabel = '${_fmtNum(it.qty)} $unit';

            final minQty = (it.minQty <= 0) ? 1.0 : it.minQty;
            final minPackPrice = it.unitPrice * minQty;

            final minQtyLabel = '${_fmtNum(minQty)} $unit';
            final minPriceLabel =
                '${minPackPrice.toStringAsFixed(3)} ${order.currency}';

            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: cs.outlineVariant.withOpacity(0.6)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_florist_outlined, color: cs.primary),
                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Text(
                                qtyLabel,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: cs.onSurface.withOpacity(0.85),
                                ),
                              ),
                              const SizedBox(width: 10),

                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        minPriceLabel,
                                        textDirection: TextDirection.ltr,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: cs.onSurface.withOpacity(
                                                0.60,
                                              ),
                                            ),
                                      ),
                                      const SizedBox(width: 4),

                                      Text('/'),
                                      const SizedBox(width: 4),

                                      Flexible(
                                        child: Text(
                                          minQtyLabel,
                                          textDirection: TextDirection.ltr,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: cs.onSurface.withOpacity(
                                                  0.60,
                                                ),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      it.lineTotal.toStringAsFixed(3),
                      textDirection: TextDirection.ltr,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

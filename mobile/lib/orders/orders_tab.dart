import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/orders/data/orders_repo.dart';
import 'package:mobile/orders/models/order_model.dart';
import 'package:mobile/orders/order_details_screen.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  String _fmtDate(DateTime d) {
    final y = d.year.toString();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '$y-$m-$day  $hh:$mm';
  }

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

  /// الإلغاء مسموح فقط في pending (قيد المعالجة)
  bool _canCancel(String status) => status == 'pending';

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

  Future<void> _cancelOrder(BuildContext context, String orderId) async {
    final t = AppLocalizations.of(context)!;

    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': 'cancelled', 'updatedAt': FieldValue.serverTimestamp()},
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.orderCancelledSuccess)));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${t.errorGeneric}: $e')));
    }
  }

  void _openDetails(BuildContext context, OrderModel o) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: o)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.ordersTitle), centerTitle: true),
        body: Center(child: Text(t.errorGeneric)),
      );
    }

    final repo = OrdersRepo(FirebaseFirestore.instance);

    return Scaffold(
      appBar: AppBar(title: Text(t.ordersTitle), centerTitle: true),
      body: StreamBuilder<List<OrderModel>>(
        stream: repo.watchMyOrders(user.uid),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('${t.errorGeneric}: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snap.data!;
          if (orders.isEmpty) {
            return Center(
              child: Text(
                t.ordersPlaceholder,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final o = orders[i];
              final created = o.createdAt?.toDate();
              final when = created == null ? '-' : _fmtDate(created);

              final statusText = _statusLabel(t, o.status);
              final st = _statusStyle(cs, o.status);

              final itemCount = o.items.length;

              final names = o.items
                  .map((it) {
                    final isRtl =
                        Directionality.of(context) == TextDirection.rtl;
                    final n = isRtl ? it.nameAr : it.nameEn;
                    return n.trim().isEmpty
                        ? (isRtl ? it.nameEn : it.nameAr)
                        : n;
                  })
                  .where((s) => s.trim().isNotEmpty)
                  .toList();

              final shortNames = () {
                if (names.isEmpty) return t.orderItemsUnknown;
                final take = names.take(3).toList();
                final rest = names.length - take.length;
                return rest > 0
                    ? '${take.join(' • ')}  +$rest'
                    : take.join(' • ');
              }();

              final canCancel = _canCancel(o.status);

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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: st.bg,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: cs.outlineVariant.withOpacity(0.35),
                              ),
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
                          const Spacer(),
                          Text(
                            '${o.total.toStringAsFixed(3)} ${o.currency}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: cs.tertiary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          _InfoChip(
                            icon: Icons.calendar_month_outlined,
                            text: when,
                          ),
                          _InfoChip(
                            icon: Icons.shopping_bag_outlined,
                            text: '${t.labelItems}: $itemCount',
                          ),
                          _InfoChip(
                            icon: Icons.local_shipping_outlined,
                            text:
                                '${t.labelDeliveryFee}: ${o.deliveryFee.toStringAsFixed(3)} ${o.currency}',
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        shortNames,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(0.65),
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => _openDetails(context, o),
                              icon: const Icon(Icons.visibility_outlined),
                              label: Text(t.actionViewDetails),
                            ),
                          ),

                          if (canCancel) ...[
                            const SizedBox(width: 10),
                            TextButton.icon(
                              onPressed: () => _cancelOrder(context, o.id),
                              icon: Icon(
                                Icons.cancel_outlined,
                                size: 18,
                                color: cs.error.withOpacity(0.75),
                              ),
                              label: Text(
                                t.actionCancelOrder,
                                style: TextStyle(
                                  color: cs.error.withOpacity(0.75),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: cs.primary),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

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

  bool _canCancel(String status) {
    if (status == 'delivering' || status == 'delivered') return false;
    if (status == 'cancelled') return false;
    return true;
  }

  Future<void> _cancelOrder(BuildContext context, String orderId) async {
    final t = AppLocalizations.of(context)!;

    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': 'cancelled', 'updatedAt': FieldValue.serverTimestamp()},
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.orderCancelledSuccess)), 
      );
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

              final statusText = _statusLabel(t, o.status);
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
                          Expanded(
                            child: Text(
                              statusText,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
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
                            child: OutlinedButton.icon(
                              onPressed: () => _openDetails(context, o),
                              icon: const Icon(Icons.visibility_outlined),
                              label: Text(t.actionViewDetails), 
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: canCancel
                                  ? () => _cancelOrder(context, o.id)
                                  : null,
                              icon: const Icon(Icons.cancel_outlined),
                              label: Text(t.actionCancelOrder), 
                            ),
                          ),
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

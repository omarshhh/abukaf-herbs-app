import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mobile/orders/data/orders_repo.dart';
import 'package:mobile/orders/models/order_model.dart';

class OrdersNavIcon extends StatelessWidget {
  const OrdersNavIcon({super.key, required this.icon});

  final IconData icon;

  bool _isActiveStatus(String s) {
    return s != 'cancelled' && s != 'delivered';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return Icon(icon);

    final repo = OrdersRepo(FirebaseFirestore.instance);

    return StreamBuilder<List<OrderModel>>(
      stream: repo.watchMyOrders(user.uid),
      builder: (context, snap) {
        final orders = snap.data ?? const <OrderModel>[];
        final activeCount = orders
            .where((o) => _isActiveStatus(o.status))
            .length;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon),
            if (activeCount > 0)
              PositionedDirectional(
                top: -6,
                end: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: cs.error,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: cs.surface, width: 2),
                  ),
                  child: Text(
                    '$activeCount',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: cs.onError,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

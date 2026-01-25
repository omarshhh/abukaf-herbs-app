import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mobile/orders/data/orders_repo.dart';
import 'package:mobile/orders/models/order_model.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not signed in')),
      );
    }

    final repo = OrdersRepo(FirebaseFirestore.instance);

    return Scaffold(
      appBar: AppBar(title: const Text('Orders'), centerTitle: true),
      body: StreamBuilder<List<OrderModel>>(
        stream: repo.watchMyOrders(user.uid),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snap.data!;
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final o = orders[i];
              final created = o.createdAt?.toDate();
              final when = (created == null)
                  ? ''
                  : '${created.year}-${created.month.toString().padLeft(2, '0')}-${created.day.toString().padLeft(2, '0')}';

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6),
                  ),
                ),
                child: ListTile(
                  title: Text('Order ${o.id}', maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('Status: ${o.status}  ${when.isEmpty ? "" : "• $when"}'),
                  trailing: Text('${o.total.toStringAsFixed(3)} ${o.currency}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

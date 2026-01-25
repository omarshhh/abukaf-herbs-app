import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mobile/l10n/app_localizations.dart';

import 'package:mobile/cart/controller/cart_controller.dart';
import 'package:mobile/cart/data/user_location_repo.dart';
import 'package:mobile/cart/data/checkout_pricing_repo.dart';

import 'package:mobile/cart/widgets/cart_empty_view.dart';
import 'package:mobile/cart/widgets/cart_line_card.dart';
import 'package:mobile/cart/widgets/summary_card.dart';
import 'package:mobile/cart/widgets/payment_method_card.dart';
import 'package:mobile/cart/widgets/cart_bottom_bar.dart';

import 'package:mobile/orders/data/orders_repo.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.onGoOrders});

  final VoidCallback? onGoOrders;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _showAll = false;
  bool _creatingOrder = false;

  late final _db = FirebaseFirestore.instance;
  late final _userRepo = UserLocationRepo(_db);
  late final _pricingRepo = CheckoutPricingRepo(_db);
  late final _ordersRepo = OrdersRepo(_db);

  Future<Map<String, dynamic>?> _readUserDoc(String uid) async {
    final snap = await _db.collection('users').doc(uid).get();
    return snap.data();
  }

  String? _govKeyFromUser(Map<String, dynamic>? userData) {
    final loc = userData?['location'];
    if (loc is Map) {
      final v = loc['govKey'];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }

  Future<void> _createOrder({
    required BuildContext context,
    required String uid,
    required double deliveryFee,
  }) async {
    final t = AppLocalizations.of(context)!;

    if (_creatingOrder) return;

    final items = CartController.I.items;
    if (items.isEmpty) return;

    setState(() => _creatingOrder = true);

    try {
      final userData = await _readUserDoc(uid);
      if (userData == null) {
        throw Exception('User document not found');
      }

      final loc = (userData['location'] is Map)
          ? Map<String, dynamic>.from(userData['location'] as Map)
          : <String, dynamic>{};

      final govKey = _govKeyFromUser(userData);
      if (govKey == null) {
        throw Exception(t.locationMissingInProfile);
      }

      final subTotal = CartController.I.subTotal;
      final total = subTotal + deliveryFee;

      await _ordersRepo.createOrder(
        uid: uid,
        cartItems: items,
        subTotal: subTotal,
        deliveryFee: deliveryFee,
        total: total,
        currency: 'JOD',
        location: loc,
      );

      CartController.I.clear();

      if (!mounted) return;

      widget.onGoOrders?.call();
      

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${t.errorGeneric}: $e')));
    } finally {
      if (mounted) setState(() => _creatingOrder = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.navCart), centerTitle: true),
        body: Center(
          child: Text(
            t.errorGeneric,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.navCart), centerTitle: true),

      body: StreamBuilder<String?>(
        stream: _userRepo.watchGovKey(user.uid),
        builder: (context, govSnap) {
          if (govSnap.hasError) {
            return Center(child: Text('users/{uid} ERROR: ${govSnap.error}'));
          }
          if (!govSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final govKey = govSnap.data;
          if (govKey == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  t.locationMissingInProfile,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            );
          }

          return StreamBuilder<Map<String, dynamic>?>(
            stream: _pricingRepo.watchCheckout(),
            builder: (context, checkoutSnap) {
              if (checkoutSnap.hasError) {
                return Center(
                  child: Text(
                    'app_settings/checkout ERROR: ${checkoutSnap.error}',
                  ),
                );
              }
              if (!checkoutSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final checkoutData = checkoutSnap.data;
              final deliveryFee = _pricingRepo.deliveryFeeForGov(
                checkoutData,
                govKey,
                fallback: 2.0,
              );

              return AnimatedBuilder(
                animation: CartController.I,
                builder: (context, _) {
                  final items = CartController.I.items;

                  if (items.isEmpty) {
                    return const CartEmptyView();
                  }

                  final canCollapse = items.length > 3;
                  final visible = (!canCollapse || _showAll)
                      ? items
                      : items.take(3).toList();

                  final subTotal = CartController.I.subTotal;
                  final total = subTotal + deliveryFee;

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 110),
                    children: [
                      ...visible.map((it) => CartLineCard(item: it)),

                      if (canCollapse) ...[
                        const SizedBox(height: 6),
                        Center(
                          child: TextButton.icon(
                            onPressed: () =>
                                setState(() => _showAll = !_showAll),
                            icon: Icon(
                              _showAll
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more_rounded,
                            ),
                            label: Text(
                              _showAll ? t.actionShowLess : t.actionShowMore,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      SummaryCard(
                        subTotal: subTotal,
                        deliveryFee: deliveryFee,
                        total: total,
                      ),

                      const SizedBox(height: 12),

                      const PaymentMethodCard(),

                      const SizedBox(height: 6),
                      Text(
                        t.paymentCODOnly,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(0.55),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),

      bottomNavigationBar: StreamBuilder<String?>(
        stream: _userRepo.watchGovKey(user.uid),
        builder: (context, govSnap) {
          final govKey = govSnap.data;

          return StreamBuilder<Map<String, dynamic>?>(
            stream: _pricingRepo.watchCheckout(),
            builder: (context, checkoutSnap) {
              final checkoutData = checkoutSnap.data;
              final deliveryFee = (govKey == null)
                  ? 0.0
                  : _pricingRepo.deliveryFeeForGov(
                      checkoutData,
                      govKey,
                      fallback: 2.0,
                    );

              return AnimatedBuilder(
                animation: CartController.I,
                builder: (context, _) {
                  final disabled = CartController.I.items.isEmpty;
                  final sub = CartController.I.subTotal;
                  final total = sub + deliveryFee;

                  return CartBottomBar(
                    disabled: disabled,
                    loading: _creatingOrder,
                    label:
                        '${t.actionCheckout} • ${total.toStringAsFixed(3)} ${t.currencyJOD}',
                    onCheckout: () => _createOrder(
                      context: context,
                      uid: user.uid,
                      deliveryFee: deliveryFee,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

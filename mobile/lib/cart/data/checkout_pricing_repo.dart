import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutPricingRepo {
  const CheckoutPricingRepo(this._db);

  final FirebaseFirestore _db;

  Stream<Map<String, dynamic>?> watchCheckout() {
    return _db
        .collection('app_settings')
        .doc('checkout')
        .snapshots()
        .map((snap) => snap.data());
  }

  double deliveryFeeForGov(
    Map<String, dynamic>? checkoutData,
    String govKey, {
    double fallback = 2.0,
  }) {
    final shippingByGov = checkoutData?['shippingByGov'];
    if (shippingByGov is Map) {
      final raw = shippingByGov[govKey];
      return _asDouble(raw, fallback: fallback);
    }
    return fallback;
  }

  double _asDouble(dynamic v, {double fallback = 0}) {
    if (v is num) return v.toDouble();
    if (v is String) {
      return double.tryParse(v.trim().replaceAll(',', '.')) ?? fallback;
    }
    return fallback;
  }
}

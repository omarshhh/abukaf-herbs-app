import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  const OrderItem({
    required this.productId,
    required this.nameAr,
    required this.nameEn,
    required this.imageUrl,
    required this.unit,
    required this.unitPrice,
    required this.qty,
    required this.lineTotal,
    required this.minQty,
    required this.maxQty,
    required this.stepQty,
  });

  final String productId;
  final String nameAr;
  final String nameEn;
  final String? imageUrl;

  final String unit;
  final double unitPrice;
  final double qty;
  final double lineTotal;

  // ✅ new
  final double minQty;
  final double maxQty;
  final double stepQty;

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'nameAr': nameAr,
    'nameEn': nameEn,
    'imageUrl': imageUrl,
    'unit': unit,
    'unitPrice': unitPrice,
    'qty': qty,
    'lineTotal': lineTotal,
    // ✅ new
    'minQty': minQty,
    'maxQty': maxQty,
    'stepQty': stepQty,
  };

  static OrderItem fromMap(Map<String, dynamic> m) {
    double asDouble(dynamic v, {double fb = 0.0}) =>
        (v is num) ? v.toDouble() : double.tryParse('$v') ?? fb;

    return OrderItem(
      productId: (m['productId'] ?? '').toString(),
      nameAr: (m['nameAr'] ?? '').toString(),
      nameEn: (m['nameEn'] ?? '').toString(),
      imageUrl: (m['imageUrl'] as String?)?.toString(),
      unit: (m['unit'] ?? '').toString(),
      unitPrice: asDouble(m['unitPrice']),
      qty: asDouble(m['qty']),
      lineTotal: asDouble(m['lineTotal']),
      // ✅ new (fallback للطلبات القديمة)
      minQty: asDouble(m['minQty'], fb: 1.0),
      maxQty: asDouble(m['maxQty'], fb: 0.0),
      stepQty: asDouble(m['stepQty'], fb: 1.0),
    );
  }
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.items,
    required this.subTotal,
    required this.deliveryFee,
    required this.total,
    required this.currency,
    required this.location,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String status;

  final List<OrderItem> items;

  final double subTotal;
  final double deliveryFee;
  final double total;
  final String currency;

  final Map<String, dynamic> location;

  final Timestamp? createdAt;

  static double _asDouble(dynamic v) =>
      (v is num) ? v.toDouble() : double.tryParse('$v') ?? 0.0;

  static OrderModel fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? <String, dynamic>{};

    final rawItems = (d['items'] is List) ? (d['items'] as List) : const [];
    final items = rawItems
        .whereType<Map>()
        .map((e) => OrderItem.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    final loc = (d['location'] is Map)
        ? Map<String, dynamic>.from(d['location'] as Map)
        : <String, dynamic>{};

    return OrderModel(
      id: doc.id,
      userId: (d['userId'] ?? '').toString(),
      status: (d['status'] ?? 'pending').toString(),
      items: items,
      subTotal: _asDouble(d['subTotal']),
      deliveryFee: _asDouble(d['deliveryFee']),
      total: _asDouble(d['total']),
      currency: (d['currency'] ?? 'JOD').toString(),
      location: loc,
      createdAt: d['createdAt'] as Timestamp?,
    );
  }
}

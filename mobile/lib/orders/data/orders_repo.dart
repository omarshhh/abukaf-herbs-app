import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/cart/models/cart_item.dart';
import 'package:mobile/orders/models/order_model.dart';

class OrdersRepo {
  OrdersRepo(this._db);
  final FirebaseFirestore _db;

  Stream<List<OrderModel>> watchMyOrders(String uid) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((q) {
          final list = q.docs.map(OrderModel.fromDoc).toList();
          list.sort((a, b) {
            final ad = a.createdAt?.toDate();
            final bd = b.createdAt?.toDate();
            if (ad == null && bd == null) return 0;
            if (ad == null) return 1;
            if (bd == null) return -1;
            return bd.compareTo(ad); 
          });
          return list;
        });
  }

  Future<String> createOrder({
    required String uid,
    required List<CartItem> cartItems,
    required double subTotal,
    required double deliveryFee,
    required double total,
    required String currency,
    required Map<String, dynamic> location,
  }) async {
    final items = cartItems.map((it) {
      return OrderItem(
        productId: it.productId,
        nameAr: it.nameAr,
        nameEn: it.nameEn,
        imageUrl: it.imageUrl,
        unit: it.unit.toString(),
        unitPrice: it.unitPrice,
        qty: it.qty,
        lineTotal: it.lineTotal,
      ).toMap();
    }).toList();

    final ref = await _db.collection('orders').add({
      'userId': uid,
      'status': 'pending',
      'items': items,
      'subTotal': subTotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'currency': currency,
      'location': location,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await ref.update({'orderId': ref.id});

    return ref.id;
  }
}

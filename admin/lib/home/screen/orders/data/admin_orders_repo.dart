import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersRepo {
  AdminOrdersRepo(this.db);

  final FirebaseFirestore db;

  Stream<QuerySnapshot<Map<String, dynamic>>> watchOrdersByStatus(
    String status,
  ) {
    return db
        .collection('orders')
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<int> watchCountByStatus(String status) {
    return db
        .collection('orders')
        .where('status', isEqualTo: status)
        .snapshots()
        .map((s) => s.size);
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) {
    final update = <String, dynamic>{
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (newStatus == 'delivered') {
      update['deliveredAt'] = FieldValue.serverTimestamp();
    }

    return db.collection('orders').doc(orderId).update(update);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> readOrder(String orderId) {
    return db.collection('orders').doc(orderId).get();
  }
}

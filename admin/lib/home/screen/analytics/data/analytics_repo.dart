import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsRepo {
  AnalyticsRepo(this.db);
  final FirebaseFirestore db;

  /// طلبات تم توصيلها ضمن فترة deliveredAt
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  fetchDeliveredInRange({
    required DateTime from,
    required DateTime toExclusive,
  }) async {
    final q = await db
        .collection('orders')
        .where('status', isEqualTo: 'delivered')
        .where('deliveredAt', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('deliveredAt', isLessThan: Timestamp.fromDate(toExclusive))
        .get();

    return q.docs;
  }
}

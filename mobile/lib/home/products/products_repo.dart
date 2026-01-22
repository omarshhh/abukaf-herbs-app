import 'package:cloud_firestore/cloud_firestore.dart';

class MobileProductsRepo {
  final _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> watchByCategory({
    required String categoryId,
    int limit = 50,
  }) {
    return _db
        .collection('products')
        .where('isActive', isEqualTo: true)
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots();
  }
}

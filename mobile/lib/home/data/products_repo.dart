import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/herb_product.dart';

class MobileProductsRepo {
  final _db = FirebaseFirestore.instance;

  Stream<List<HerbProduct>> watchActiveProducts() {
    return _db
        .collection('products')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snap) {
          return snap.docs
              .map((d) => HerbProduct.fromMap(d.id, d.data()))
              .toList();
        });
  }

  Stream<List<HerbProduct>> watchByCategory({
    required String categoryId,
    int limit = 80,
  }) {
    return _db
        .collection('products')
        .where('isActive', isEqualTo: true)
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) {
          return snap.docs
              .map((d) => HerbProduct.fromMap(d.id, d.data()))
              .toList();
        });
  }

  // ✅ جديد: من أجلك
  Stream<List<HerbProduct>> watchForYouProducts({int limit = 12}) {
    return _db
        .collection('products')
        .where('isActive', isEqualTo: true)
        .where('forYou', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) {
          return snap.docs
              .map((d) => HerbProduct.fromMap(d.id, d.data()))
              .toList();
        });
  }
}

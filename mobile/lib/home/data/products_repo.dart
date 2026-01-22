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
}

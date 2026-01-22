import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widget_products/herb_product_model.dart';

class ProductsRepo {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('products');

  Stream<List<HerbProduct>> watchProducts() {
    return _col.orderBy('createdAt', descending: true).snapshots().map((snap) {
      return snap.docs.map((d) => HerbProduct.fromMap(d.data(), d.id)).toList();
    });
  }


  Stream<List<HerbProduct>> watchProductsSearch({
    required String query,
    int limit = 50,
  }) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      return _col
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((snap) {
            return snap.docs
                .map((d) => HerbProduct.fromMap(d.data(), d.id))
                .toList();
          });
    }

    return _col
        .orderBy('nameLower')
        .startAt([q])
        .endAt(['$q\uf8ff'])
        .limit(limit)
        .snapshots()
        .map((snap) {
          return snap.docs
              .map((d) => HerbProduct.fromMap(d.data(), d.id))
              .toList();
        });
  }





  Future<void> addProduct(HerbProduct p) async {
    final doc = _col.doc();
    final now = DateTime.now();

    final saved = p.copyWith(
      id: doc.id,
      createdAt: now,
    );

    await doc.set(saved.toMap());

    if (p.imageBytes != null) {
      final uploaded = await _uploadProductImage(
        productId: doc.id,
        bytes: p.imageBytes!,
        originalName: p.imageFileName,
      );

      await doc.update({
        'imageUrl': uploaded.url,
        'imageFileName': uploaded.path,
      });
    }
  }

  Future<void> updateProduct(HerbProduct p) async {
    final doc = _col.doc(p.id);

    await doc.update(p.toMap());

    if (p.imageBytes != null) {
      final uploaded = await _uploadProductImage(
        productId: p.id,
        bytes: p.imageBytes!,
        originalName: p.imageFileName,
      );

      await doc.update({
        'imageUrl': uploaded.url,
        'imageFileName': uploaded.path,
      });
    }
  }

  Future<void> toggleActive(String productId, bool next) async {
    await _col.doc(productId).update({'isActive': next});
  }

  Future<({String url, String path})> _uploadProductImage({
    required String productId,
    required Uint8List bytes,
    String? originalName,
  }) async {
    final name = (originalName ?? 'image.jpg').toLowerCase();
    final ext = name.endsWith('.png') ? 'png' : 'jpg';
    final contentType = ext == 'png' ? 'image/png' : 'image/jpeg';

    final path = 'products/$productId/main.$ext';
    final ref = _storage.ref(path);

    await ref.putData(bytes, SettableMetadata(contentType: contentType));

    final url = await ref.getDownloadURL();
    return (url: url, path: path);
  }
}

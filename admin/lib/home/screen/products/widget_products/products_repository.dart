import 'package:cloud_firestore/cloud_firestore.dart';
import 'herb_product_model.dart';
import 'storage_service.dart';

class ProductsRepository {
  ProductsRepository({FirebaseFirestore? firestore, StorageService? storage})
    : _db = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? StorageService();

  final FirebaseFirestore _db;
  final StorageService _storage;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('products');

  /// All products (latest first)
  Stream<List<HerbProduct>> streamAllProducts({int? limit}) {
    Query<Map<String, dynamic>> q = _col.orderBy('createdAt', descending: true);
    if (limit != null) q = q.limit(limit);

    return q.snapshots().map(
      (snap) =>
          snap.docs.map((d) => HerbProduct.fromMap(d.data(), d.id)).toList(),
    );
  }

  /// ✅ Search by Arabic nameLower prefix (same behavior you had in ProductsRepo)
  Stream<List<HerbProduct>> streamProductsSearch({
    required String query,
    int limit = 50,
  }) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      return _col
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map(
            (snap) => snap.docs
                .map((d) => HerbProduct.fromMap(d.data(), d.id))
                .toList(),
          );
    }

    return _col
        .orderBy('nameLower')
        .startAt([q])
        .endAt(['$q\uf8ff'])
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => HerbProduct.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  /// ✅ For You only
  Stream<List<HerbProduct>> streamForYou({int limit = 50}) {
    return _col
        .where('forYou', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => HerbProduct.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  /// ✅ يرجّع المنتج بعد ما يثبت ID الحقيقي
  Future<HerbProduct> addProduct(HerbProduct p) async {
    final ref = _col.doc(); // Firestore ID
    final productWithId = p.copyWith(id: ref.id);

    final saved = await _prepareImage(productWithId);

    // set كامل لأن هذا إنشاء
    await ref.set(saved.toMap());
    return saved;
  }

  /// ✅ Update with merge (safer: won't accidentally drop unknown fields)
  Future<void> updateProduct(HerbProduct p) async {
    final saved = await _prepareImage(p);

    // Merge true أفضل على المدى البعيد (لو أضفت حقول إضافية لاحقًا)
    await _col.doc(p.id).set(saved.toMap(), SetOptions(merge: true));
  }

  Future<void> setActive(String id, bool isActive) async {
    await _col.doc(id).update({'isActive': isActive});
  }

  Future<void> setForYou(String id, bool forYou) async {
    await _col.doc(id).update({'forYou': forYou});
  }

  Future<void> deleteProduct(String id) async {
    await _col.doc(id).delete();
  }

  Future<HerbProduct> _prepareImage(HerbProduct p) async {
    if (p.imageBytes == null) return p;

    final fileName =
        p.imageFileName ??
        'p_${p.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final url = await _storage.uploadProductImage(
      bytes: p.imageBytes!,
      fileName: fileName,
    );

    return p.copyWith(imageUrl: url, imageFileName: fileName, imageBytes: null);
  }
}

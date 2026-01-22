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

  Stream<List<HerbProduct>> streamAllProducts() {
    return _col
        .orderBy('createdAt', descending: true)
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
    await ref.set(saved.toMap());
    return saved;
  }

  Future<void> updateProduct(HerbProduct p) async {
    final saved = await _prepareImage(p);
    await _col.doc(p.id).update(saved.toMap());
  }

  Future<void> setActive(String id, bool isActive) async {
    await _col.doc(id).update({'isActive': isActive});
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

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/herb_product.dart';

class MobileProductsRepo {
  final _db = FirebaseFirestore.instance;

  Stream<List<HerbProduct>> watchActiveProducts() {
    return _db
        .collection('products')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => HerbProduct.fromMap(d.id, d.data()))
              .toList(),
        );
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
        .map(
          (snap) => snap.docs
              .map((d) => HerbProduct.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Stream<List<HerbProduct>> watchForYouProducts({int limit = 12}) {
    return _db
        .collection('products')
        .where('isActive', isEqualTo: true)
        .where('forYou', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => HerbProduct.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  // =========================
  // ✅ Simple Search (prefix)
  // =========================
  Future<List<HerbProduct>> searchProducts({
    required String query,
    String? categoryId,
    int limit = 20,
  }) async {
    final q = _normalize(query);
    if (q.isEmpty) return [];

    // Search by prefix on nameLower
    Query<Map<String, dynamic>> ref = _db
        .collection('products')
        .where('isActive', isEqualTo: true);

    if (categoryId != null && categoryId.trim().isNotEmpty) {
      ref = ref.where('categoryId', isEqualTo: categoryId.trim());
    }

    // لازم يكون عندك nameLower (موجود عندك)
    ref = ref
        .orderBy('nameLower')
        .startAt([q])
        .endAt(['$q\uf8ff'])
        .limit(limit);

    final snap = await ref.get();
    final items = snap.docs
        .map((d) => HerbProduct.fromMap(d.id, d.data()))
        .toList();

    // لو كتب أكثر من كلمة: فلترة محلية بسيطة (اختياري)
    final words = q.split(' ').where((e) => e.isNotEmpty).toList();
    if (words.length <= 1) return items;

    return items.where((p) {
      final blob = '${p.nameAr} ${p.nameEn}'.toLowerCase();
      return words.every(blob.contains);
    }).toList();
  }

  // تطبيع بسيط (كافي)
  static String _normalize(String input) {
    var s = input.trim().toLowerCase();

    // توحيد حروف عربية بسيطة
    s = s
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه');

    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return s;
  }
}

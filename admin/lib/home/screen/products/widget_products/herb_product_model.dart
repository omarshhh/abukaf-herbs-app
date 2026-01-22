import 'dart:typed_data';

enum ProductUnit {
  gram, // g
  kilogram, // kg
  ml, // ml
  liter, // L
  piece,
}

class HerbProduct {
  HerbProduct({
    required this.id,
    required this.categoryId,

    required this.name,
    required this.benefit,
    required this.preparation,

    required this.nameAr,
    required this.nameEn,
    required this.benefitAr,
    required this.benefitEn,
    required this.preparationAr,
    required this.preparationEn,

    // ✅ NEW (required)
    required this.forYou,
    required this.shortDescAr,
    required this.shortDescEn,

    required this.unit,
    required this.minQty,
    required this.maxQty,
    required this.stepQty,
    required this.unitPrice,
    required this.isActive,
    required this.createdAt,

    // Storage fields (saved in Firestore)
    this.imageUrl,
    this.imageFileName,

    // UI-only (NOT saved in Firestore)
    this.imageBytes,
  });

  String id;
  String categoryId;

  /// ✅ Backward-compatible (old) fields
  /// We keep them so old UI / mobile code doesn't break.
  /// We will store them as Arabic values (AR).
  String name;
  String benefit;
  String preparation;

  /// ✅ New bilingual fields
  String nameAr;
  String nameEn;

  String benefitAr;
  String benefitEn;

  String preparationAr;
  String preparationEn;

  /// ✅ NEW
  bool forYou;
  String shortDescAr;
  String shortDescEn;

  ProductUnit unit;
  double minQty;
  double maxQty;
  double stepQty;
  double unitPrice;

  bool isActive;

  DateTime createdAt;

  // Stored in Firestore
  String? imageUrl;
  String? imageFileName;

  // UI-only
  Uint8List? imageBytes;

  HerbProduct copyWith({
    String? id,
    String? categoryId,

    // old
    String? name,
    String? benefit,
    String? preparation,

    // new bilingual
    String? nameAr,
    String? nameEn,
    String? benefitAr,
    String? benefitEn,
    String? preparationAr,
    String? preparationEn,

    // ✅ NEW
    bool? forYou,
    String? shortDescAr,
    String? shortDescEn,

    ProductUnit? unit,
    double? minQty,
    double? maxQty,
    double? stepQty,
    double? unitPrice,
    bool? isActive,
    DateTime? createdAt,
    String? imageUrl,
    String? imageFileName,
    Uint8List? imageBytes,
  }) {
    // Prefer AR fields to keep old fields consistent
    final nextNameAr = nameAr ?? this.nameAr;
    final nextBenefitAr = benefitAr ?? this.benefitAr;
    final nextPrepAr = preparationAr ?? this.preparationAr;

    return HerbProduct(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,

      // old fields should track Arabic
      name: name ?? nextNameAr,
      benefit: benefit ?? nextBenefitAr,
      preparation: preparation ?? nextPrepAr,

      // new fields
      nameAr: nextNameAr,
      nameEn: nameEn ?? this.nameEn,
      benefitAr: nextBenefitAr,
      benefitEn: benefitEn ?? this.benefitEn,
      preparationAr: nextPrepAr,
      preparationEn: preparationEn ?? this.preparationEn,

      // ✅ NEW
      forYou: forYou ?? this.forYou,
      shortDescAr: shortDescAr ?? this.shortDescAr,
      shortDescEn: shortDescEn ?? this.shortDescEn,

      unit: unit ?? this.unit,
      minQty: minQty ?? this.minQty,
      maxQty: maxQty ?? this.maxQty,
      stepQty: stepQty ?? this.stepQty,
      unitPrice: unitPrice ?? this.unitPrice,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      imageFileName: imageFileName ?? this.imageFileName,

      // UI-only (do not push to Firestore)
      imageBytes: imageBytes ?? this.imageBytes,
    );
  }

  /// ✅ Firestore map (NO bytes here)
  /// We write bilingual fields + keep old fields for backward compatibility.
  Map<String, dynamic> toMap() {
    final arName = nameAr.trim();
    final arShort = shortDescAr.trim();
    final enShort = shortDescEn.trim();

    return {
      'categoryId': categoryId,

      // ✅ Backward compatible fields (store AR)
      'name': arName,
      'benefit': benefitAr,
      'preparation': preparationAr,

      // ✅ For search (prefix)
      'nameLower': arName.toLowerCase(),

      // ✅ New bilingual fields
      'nameAr': arName,
      'nameEn': nameEn.trim(),
      'benefitAr': benefitAr,
      'benefitEn': benefitEn,
      'preparationAr': preparationAr,
      'preparationEn': preparationEn,

      // ✅ NEW
      'forYou': forYou,
      'shortDesc': {'ar': arShort, 'en': enShort},

      'unit': unit.name,
      'minQty': minQty,
      'maxQty': maxQty,
      'stepQty': stepQty,
      'unitPrice': unitPrice,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'imageUrl': imageUrl,
      'imageFileName': imageFileName,
    };
  }

  /// ✅ Read from Firestore (with fallback for old documents)
  static HerbProduct fromMap(Map<String, dynamic> map, String docId) {
    final unitStr = (map['unit'] ?? 'gram').toString();
    final parsedUnit = ProductUnit.values.firstWhere(
      (u) => u.name == unitStr,
      orElse: () => ProductUnit.gram,
    );

    double toDouble(dynamic v, {double fallback = 0}) {
      if (v == null) return fallback;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? fallback;
    }

    int toInt(dynamic v, {int fallback = 0}) {
      if (v == null) return fallback;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? fallback;
    }

    // ✅ fallback strategy
    final nameAr = (map['nameAr'] ?? map['name'] ?? '').toString();
    final nameEn = (map['nameEn'] ?? '').toString();

    final benefitAr = (map['benefitAr'] ?? map['benefit'] ?? '').toString();
    final benefitEn = (map['benefitEn'] ?? '').toString();

    final prepAr = (map['preparationAr'] ?? map['preparation'] ?? '')
        .toString();
    final prepEn = (map['preparationEn'] ?? '').toString();

    // ✅ NEW: shortDesc map fallback
    final sd = map['shortDesc'];
    String shortAr = '';
    String shortEn = '';
    if (sd is Map) {
      shortAr = (sd['ar'] ?? '').toString();
      shortEn = (sd['en'] ?? '').toString();
    }

    return HerbProduct(
      id: docId,
      categoryId: (map['categoryId'] ?? 'herbs').toString(),

      // old fields kept = AR
      name: nameAr,
      benefit: benefitAr,
      preparation: prepAr,

      // new bilingual fields
      nameAr: nameAr,
      nameEn: nameEn,
      benefitAr: benefitAr,
      benefitEn: benefitEn,
      preparationAr: prepAr,
      preparationEn: prepEn,

      // ✅ NEW (fallback-safe)
      forYou: (map['forYou'] ?? false) == true,
      shortDescAr: shortAr,
      shortDescEn: shortEn,

      unit: parsedUnit,
      minQty: toDouble(map['minQty'], fallback: 0),
      maxQty: toDouble(map['maxQty'], fallback: 0),
      stepQty: toDouble(map['stepQty'], fallback: 1),
      unitPrice: toDouble(map['unitPrice'], fallback: 0),
      isActive: (map['isActive'] ?? true) == true,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        toInt(
          map['createdAt'],
          fallback: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
      imageUrl: map['imageUrl'] as String?,
      imageFileName: map['imageFileName'] as String?,
      imageBytes: null, // never from Firestore
    );
  }
}

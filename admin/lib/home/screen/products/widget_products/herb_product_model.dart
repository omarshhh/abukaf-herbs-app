import 'dart:typed_data';

enum ProductUnit { gram, kilogram, ml, liter, piece }

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


    this.imageUrl,
    this.imageFileName,
    this.imageBytes,
  });

  String id;
  String categoryId;

  String name;
  String benefit;
  String preparation;

  String nameAr;
  String nameEn;

  String benefitAr;
  String benefitEn;

  String preparationAr;
  String preparationEn;

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


  String? imageUrl;
  String? imageFileName;

  Uint8List? imageBytes;

  HerbProduct copyWith({
    String? id,
    String? categoryId,

    String? name,
    String? benefit,
    String? preparation,

    String? nameAr,
    String? nameEn,
    String? benefitAr,
    String? benefitEn,
    String? preparationAr,
    String? preparationEn,

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
    final nextNameAr = nameAr ?? this.nameAr;
    final nextBenefitAr = benefitAr ?? this.benefitAr;
    final nextPrepAr = preparationAr ?? this.preparationAr;

    return HerbProduct(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,

      name: name ?? nextNameAr,
      benefit: benefit ?? nextBenefitAr,
      preparation: preparation ?? nextPrepAr,

      nameAr: nextNameAr,
      nameEn: nameEn ?? this.nameEn,
      benefitAr: nextBenefitAr,
      benefitEn: benefitEn ?? this.benefitEn,
      preparationAr: nextPrepAr,
      preparationEn: preparationEn ?? this.preparationEn,

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
      imageBytes: imageBytes ?? this.imageBytes,
    );
  }

  Map<String, dynamic> toMap() {
    final arName = nameAr.trim();
    final arShort = shortDescAr.trim();
    final enShort = shortDescEn.trim();

    return {
      'categoryId': categoryId,

      'name': arName,
      'benefit': benefitAr,
      'preparation': preparationAr,

      'nameLower': arName.toLowerCase(),

      'nameAr': arName,
      'nameEn': nameEn.trim(),
      'benefitAr': benefitAr,
      'benefitEn': benefitEn,
      'preparationAr': preparationAr,
      'preparationEn': preparationEn,

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

    final nameAr = (map['nameAr'] ?? map['name'] ?? '').toString();
    final nameEn = (map['nameEn'] ?? '').toString();

    final benefitAr = (map['benefitAr'] ?? map['benefit'] ?? '').toString();
    final benefitEn = (map['benefitEn'] ?? '').toString();

    final prepAr = (map['preparationAr'] ?? map['preparation'] ?? '')
        .toString();
    final prepEn = (map['preparationEn'] ?? '').toString();

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

      name: nameAr,
      benefit: benefitAr,
      preparation: prepAr,

      nameAr: nameAr,
      nameEn: nameEn,
      benefitAr: benefitAr,
      benefitEn: benefitEn,
      preparationAr: prepAr,
      preparationEn: prepEn,

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
      imageBytes: null,
    );
  }
}

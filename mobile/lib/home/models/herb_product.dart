class HerbProduct {
  final String id;
  final String categoryId;

  final String nameAr;
  final String nameEn;

  final String benefitAr;
  final String benefitEn;

  final String preparationAr;
  final String preparationEn;

  final double unitPrice;
  final bool isActive;
  final String? imageUrl;

  const HerbProduct({
    required this.id,
    required this.categoryId,
    required this.nameAr,
    required this.nameEn,
    required this.benefitAr,
    required this.benefitEn,
    required this.preparationAr,
    required this.preparationEn,
    required this.unitPrice,
    required this.isActive,
    this.imageUrl,
  });

  factory HerbProduct.fromMap(String id, Map<String, dynamic> map) {
    // fallback للبيانات القديمة إن وجدت
    final arName = (map['nameAr'] ?? map['name'] ?? '').toString();
    final enName = (map['nameEn'] ?? '').toString();

    final arBenefit = (map['benefitAr'] ?? map['benefit'] ?? '').toString();
    final enBenefit = (map['benefitEn'] ?? '').toString();

    final arPrep = (map['preparationAr'] ?? map['preparation'] ?? '')
        .toString();
    final enPrep = (map['preparationEn'] ?? '').toString();

    double toDouble(dynamic v, {double fallback = 0}) {
      if (v == null) return fallback;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? fallback;
    }

    return HerbProduct(
      id: id,
      categoryId: (map['categoryId'] ?? 'herbs').toString(),
      nameAr: arName,
      nameEn: enName,
      benefitAr: arBenefit,
      benefitEn: enBenefit,
      preparationAr: arPrep,
      preparationEn: enPrep,
      unitPrice: toDouble(map['unitPrice'], fallback: 0),
      isActive: (map['isActive'] ?? true) == true,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  /// للبحث (AR/EN) بشكل موحد
  String searchBlob() {
    return '${nameAr.toLowerCase()} ${nameEn.toLowerCase()}';
  }
}

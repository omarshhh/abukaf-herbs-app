import 'dart:typed_data';

enum ProductUnit { gram, kilogram, ml, liter, piece }

class HerbProduct {
  final String id;
  final String categoryId;

  final String nameAr;
  final String nameEn;

  final String shortDescAr;
  final String shortDescEn;

  final String benefitAr;
  final String benefitEn;

  final String preparationAr;
  final String preparationEn;

  final double unitPrice;
  final ProductUnit unit;

  final double minQty;
  final double maxQty;
  final double stepQty;

  final bool forYou;
  final bool isActive;

  final String? imageUrl;

  const HerbProduct({
    required this.id,
    required this.categoryId,
    required this.nameAr,
    required this.nameEn,
    required this.shortDescAr,
    required this.shortDescEn,
    required this.benefitAr,
    required this.benefitEn,
    required this.preparationAr,
    required this.preparationEn,
    required this.unitPrice,
    required this.unit,
    required this.minQty,
    required this.maxQty,
    required this.stepQty,
    required this.forYou,
    required this.isActive,
    this.imageUrl,
  });

  static double _toDouble(dynamic v, {double fallback = 0}) {
    if (v == null) return fallback;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? fallback;
  }

  static ProductUnit _unitFrom(dynamic v) {
    final s = (v ?? '').toString().toLowerCase().trim();
    switch (s) {
      case 'kg':
      case 'kilogram':
        return ProductUnit.kilogram;
      case 'ml':
        return ProductUnit.ml;
      case 'l':
      case 'liter':
        return ProductUnit.liter;
      case 'piece':
        return ProductUnit.piece;
      case 'g':
      case 'gram':
      default:
        return ProductUnit.gram;
    }
  }

  factory HerbProduct.fromMap(String id, Map<String, dynamic> map) {
    String _pickLang(dynamic v, String lang) {
      if (v == null) return '';
      if (v is String) return v;
      if (v is Map) {
        final m = v.map((k, val) => MapEntry(k.toString(), val));
        final byLang = m[lang];
        if (byLang != null) return byLang.toString();
        final fallback = m['ar'] ?? m['en'];
        return fallback?.toString() ?? '';
      }
      return v.toString();
    }

    String _readLocalized({
      required String baseKey,
      required String arKey,
      required String enKey,
      required String lang,
    }) {
      final direct = map[lang == 'ar' ? arKey : enKey];
      final directStr = _pickLang(direct, lang).trim();
      if (directStr.isNotEmpty) return directStr;

      final base = map[baseKey];
      final baseStr = _pickLang(base, lang).trim();
      if (baseStr.isNotEmpty) return baseStr;

      final other = map[lang == 'ar' ? enKey : arKey];
      return _pickLang(other, lang).trim();
    }

    final nameAr = _pickLang(map['nameAr'] ?? map['name'], 'ar');
    final nameEn = _pickLang(map['nameEn'] ?? map['name'], 'en');

    final shortAr = _pickLang(map['shortDescAr'] ?? map['shortDesc'], 'ar');
    final shortEn = _pickLang(map['shortDescEn'] ?? map['shortDesc'], 'en');

    final benefitAr = _pickLang(map['benefitAr'] ?? map['benefit'], 'ar');
    final benefitEn = _pickLang(map['benefitEn'] ?? map['benefit'], 'en');

    final prepAr = _pickLang(map['preparationAr'] ?? map['preparation'], 'ar');
    final prepEn = _pickLang(map['preparationEn'] ?? map['preparation'], 'en');

    return HerbProduct(
      id: id,
      categoryId: (map['categoryId'] ?? 'herbs').toString(),
      nameAr: nameAr,
      nameEn: nameEn,
      shortDescAr: shortAr,
      shortDescEn: shortEn,
      benefitAr: benefitAr,
      benefitEn: benefitEn,
      preparationAr: prepAr,
      preparationEn: prepEn,
      unitPrice: _toDouble(map['unitPrice'], fallback: 0),
      unit: _unitFrom(map['unit']),
      minQty: _toDouble(map['minQty'], fallback: 1),
      maxQty: _toDouble(map['maxQty'], fallback: 0),
      stepQty: _toDouble(map['stepQty'], fallback: 1),
      forYou: (map['forYou'] ?? false) == true,
      isActive: (map['isActive'] ?? true) == true,
      imageUrl: map['imageUrl'] as String?,
    );
  }


  String searchBlob() => '${nameAr.toLowerCase()} ${nameEn.toLowerCase()}';
}

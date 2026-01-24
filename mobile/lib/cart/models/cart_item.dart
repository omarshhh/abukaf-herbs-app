import 'package:flutter/foundation.dart';
import 'package:mobile/home/models/herb_product.dart';

@immutable
class CartItem {
  const CartItem({
    required this.productId,
    required this.nameAr,
    required this.nameEn,
    required this.imageUrl,
    required this.unitPrice,
    required this.unit,
    required this.minQty,
    required this.maxQty,
    required this.stepQty,
    required this.qty,
  });

  final String productId;
  final String nameAr;
  final String nameEn;
  final String? imageUrl;

  final double unitPrice;
  final ProductUnit unit;

  final double minQty;
  final double maxQty;
  final double stepQty;

  final double qty;

  double get lineTotal => unitPrice * qty;

  CartItem copyWith({
    String? productId,
    String? nameAr,
    String? nameEn,
    String? imageUrl,
    double? unitPrice,
    ProductUnit? unit,
    double? minQty,
    double? maxQty,
    double? stepQty,
    double? qty,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      imageUrl: imageUrl ?? this.imageUrl,
      unitPrice: unitPrice ?? this.unitPrice,
      unit: unit ?? this.unit,
      minQty: minQty ?? this.minQty,
      maxQty: maxQty ?? this.maxQty,
      stepQty: stepQty ?? this.stepQty,
      qty: qty ?? this.qty,
    );
  }

  static CartItem fromProduct(HerbProduct p, {required double qty}) {
    final min = (p.minQty <= 0) ? 1.0 : p.minQty;
    final step = (p.stepQty <= 0) ? 1.0 : p.stepQty;
    final max = p.maxQty;

    return CartItem(
      productId: p.id,
      nameAr: p.nameAr,
      nameEn: p.nameEn,
      imageUrl: p.imageUrl,
      unitPrice: p.unitPrice,
      unit: p.unit,
      minQty: min,
      maxQty: max,
      stepQty: step,
      qty: qty,
    );
  }
}

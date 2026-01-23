import 'package:flutter/foundation.dart';
import 'package:mobile/home/models/herb_product.dart';

class CartItem {
  CartItem({
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

  final double minQty; // الحد الأدنى
  final double maxQty; // الحد الأعلى (0 => مفتوح)
  final double stepQty; // مقدار الزيادة/النقصان (0 => 1)

  double qty;

  double get lineTotal => unitPrice * qty;

  static CartItem fromProduct(HerbProduct p, double qty) {
    final min = (p.minQty <= 0) ? 1.0 : p.minQty;
    final step = (p.stepQty <= 0) ? 1.0 : p.stepQty;
    final max = p.maxQty; // قد يكون 0
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

class CartController extends ChangeNotifier {
  CartController._();
  static final CartController I = CartController._();

  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList(growable: false);

  int get linesCount => _items.length;

  bool contains(String productId) => _items.containsKey(productId);

  CartItem? getItem(String productId) => _items[productId];

  double getQty(String productId) => _items[productId]?.qty ?? 0;

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get subTotal {
    double s = 0;
    for (final it in _items.values) {
      s += it.lineTotal;
    }
    return s;
  }

  // -------------------------
  // قواعد الكمية: step/min/max
  // -------------------------
  double _toStepRounded(double v, double step) {
    final k = (v / step).roundToDouble();
    return k * step;
  }

  double _clamp(double v, double min, double max) {
    final m = max <= 0 ? v : max;
    final c = v.clamp(min, m);
    return (c is num) ? c.toDouble() : v;
  }

  /// تعيين كمية وفق قواعد المنتج، وإذا أقل من min => حذف.
  void setQtySafe(String productId, double qty) {
    final it = _items[productId];
    if (it == null) return;

    final step = it.stepQty <= 0 ? 1.0 : it.stepQty;
    final min = it.minQty <= 0 ? 1.0 : it.minQty;
    final max = it.maxQty;

    final rounded = _toStepRounded(qty, step);

    // إذا أقل من الحد الأدنى => حذف
    if (rounded < min) {
      _items.remove(productId);
      notifyListeners();
      return;
    }

    final clamped = _clamp(rounded, min, max);
    it.qty = clamped;
    notifyListeners();
  }

  /// تطبيق زيادة/نقصان بمقدار step. إذا نزل عن min => حذف.
  void applyStepDelta(String productId, {required bool inc}) {
    final it = _items[productId];
    if (it == null) return;

    final step = it.stepQty <= 0 ? 1.0 : it.stepQty;
    final next = inc ? (it.qty + step) : (it.qty - step);
    setQtySafe(productId, next);
  }

  /// إضافة/دمج كمية وفق قواعد المنتج
  void addOrMerge(HerbProduct product, double qty) {
    final id = product.id;

    final min = (product.minQty <= 0) ? 1.0 : product.minQty;
    final step = (product.stepQty <= 0) ? 1.0 : product.stepQty;
    final max = product.maxQty;

    // تأكيد أن الإضافة ليست أقل من min، وموائمة للـ step
    double normalized = _toStepRounded(qty, step);
    if (normalized < min) normalized = min;
    normalized = _clamp(normalized, min, max);

    if (_items.containsKey(id)) {
      final it = _items[id]!;
      // اجمع ثم أعِد التقريب والحدود
      final merged = _toStepRounded(it.qty + normalized, step);
      final clamped = _clamp(merged, min, max);
      it.qty = clamped;
    } else {
      final it = CartItem.fromProduct(product, normalized);
      // تأكد clamp مرة أخيرة
      it.qty = _clamp(_toStepRounded(it.qty, step), min, max);
      _items[id] = it;
    }

    notifyListeners();
  }

  void remove(String productId) {
    if (_items.remove(productId) != null) notifyListeners();
  }
}

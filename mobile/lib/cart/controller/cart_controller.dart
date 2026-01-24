import 'package:flutter/foundation.dart';
import 'package:mobile/cart/models/cart_item.dart';
import 'package:mobile/home/models/herb_product.dart';

class CartController extends ChangeNotifier {
  CartController._();
  static final CartController I = CartController._();

  final Map<String, CartItem> _items = {};

  // =========================
  // Getters
  // =========================

  List<CartItem> get items => _items.values.toList(growable: false);

  int get linesCount => _items.length;

  bool get isEmpty => _items.isEmpty;

  bool contains(String productId) => _items.containsKey(productId);

  CartItem? getItem(String productId) => _items[productId];

  double getQty(String productId) => _items[productId]?.qty ?? 0;

  double get subTotal {
    double sum = 0;
    for (final it in _items.values) {
      sum += it.lineTotal;
    }
    return sum;
  }

  // =========================
  // Helpers (internal)
  // =========================

  double _roundToStep(double value, double step) {
    if (step <= 0) return value;
    final k = (value / step).roundToDouble();
    return k * step;
  }

  double _clamp(double value, double min, double max) {
    final effectiveMax = max <= 0 ? value : max;
    final clamped = value.clamp(min, effectiveMax);
    return (clamped is num) ? clamped.toDouble() : value;
  }

  // =========================
  // Mutations
  // =========================

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }

  void remove(String productId) {
    if (_items.remove(productId) != null) {
      notifyListeners();
    }
  }

  void setQtySafe(String productId, double newQty) {
    final it = _items[productId];
    if (it == null) return;

    final step = it.stepQty <= 0 ? 1.0 : it.stepQty;
    final min = it.minQty <= 0 ? 1.0 : it.minQty;
    final max = it.maxQty;

    final rounded = _roundToStep(newQty, step);

    if (rounded < min) {
      _items.remove(productId);
      notifyListeners();
      return;
    }

    final clamped = _clamp(rounded, min, max);
    _items[productId] = it.copyWith(qty: clamped);
    notifyListeners();
  }

  void applyStepDelta(String productId, {required bool increment}) {
    final it = _items[productId];
    if (it == null) return;

    final step = it.stepQty <= 0 ? 1.0 : it.stepQty;
    final nextQty = increment ? (it.qty + step) : (it.qty - step);

    setQtySafe(productId, nextQty);
  }

  void addOrMerge(HerbProduct product, {required double qty}) {
    final id = product.id;

    final min = (product.minQty <= 0) ? 1.0 : product.minQty;
    final step = (product.stepQty <= 0) ? 1.0 : product.stepQty;
    final max = product.maxQty;

    double normalized = _roundToStep(qty, step);
    if (normalized < min) normalized = min;
    normalized = _clamp(normalized, min, max);

    if (_items.containsKey(id)) {
      final existing = _items[id]!;
      final merged = _roundToStep(existing.qty + normalized, step);
      final clamped = _clamp(merged, min, max);
      _items[id] = existing.copyWith(qty: clamped);
    } else {
      _items[id] = CartItem.fromProduct(
        product,
        qty: normalized,
      ).copyWith(qty: _clamp(_roundToStep(normalized, step), min, max));
    }

    notifyListeners();
  }
}

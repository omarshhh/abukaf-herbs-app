class CheckoutSettings {
  final double taxPercent; 
  final Map<String, double> shippingByGov; 

  CheckoutSettings({required this.taxPercent, required this.shippingByGov});

  static const List<String> govKeys = [
    'amman',
    'irbid',
    'zarqa',
    'balqa',
    'mafraq',
    'jerash',
    'ajloun',
    'madaba',
    'karak',
    'tafilah',
    'maan',
    'aqaba',
  ];

  static const Map<String, String> govLabelsAr = {
    'amman': 'عمان',
    'irbid': 'إربد',
    'zarqa': 'الزرقاء',
    'balqa': 'البلقاء',
    'mafraq': 'المفرق',
    'jerash': 'جرش',
    'ajloun': 'عجلون',
    'madaba': 'مادبا',
    'karak': 'الكرك',
    'tafilah': 'الطفيلة',
    'maan': 'معان',
    'aqaba': 'العقبة',
  };

  factory CheckoutSettings.defaults() {
    return CheckoutSettings(
      taxPercent: 0,
      shippingByGov: {for (final k in govKeys) k: 0},
    );
  }

  Map<String, dynamic> toMap() => {
    'taxPercent': taxPercent,
    'shippingByGov': shippingByGov,
  };

  factory CheckoutSettings.fromMap(Map<String, dynamic> map) {
    final rawTax = map['taxPercent'];
    final tax = (rawTax is num) ? rawTax.toDouble() : 0.0;

    final raw = map['shippingByGov'];
    final Map<String, double> shipping = {};

    if (raw is Map) {
      raw.forEach((k, v) {
        if (k is String && v is num) shipping[k] = v.toDouble();
      });
    }

    for (final k in govKeys) {
      shipping.putIfAbsent(k, () => 0);
    }

    return CheckoutSettings(taxPercent: tax, shippingByGov: shipping);
  }
}

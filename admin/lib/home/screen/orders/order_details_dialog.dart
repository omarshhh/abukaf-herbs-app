import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/admin_orders_repo.dart';
import 'data/admin_user_cache.dart';

class AdminOrderDetailsDialog extends StatelessWidget {
  const AdminOrderDetailsDialog({
    super.key,
    required this.orderId,
    required this.userCache,
  });

  final String orderId;
  final AdminUserCache userCache;

  // ========= Helpers =========

  num _toNum(dynamic v) {
    if (v is num) return v;
    return num.tryParse(v.toString()) ?? 0;
  }

  String _money(num v, String currency) => '${v.toStringAsFixed(3)} $currency';

  String _fmtQty(num v) {
    if (v % 1 == 0) return v.toStringAsFixed(0);
    return v.toStringAsFixed(2);
  }

  Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم النسخ')));
  }

  String _govAr(String govKey) {
    switch (govKey) {
      case 'ajloun':
        return 'عجلون';
      case 'amman':
        return 'عمان';
      case 'aqaba':
        return 'العقبة';
      case 'balqa':
        return 'البلقاء';
      case 'irbid':
        return 'إربد';
      case 'jerash':
        return 'جرش';
      case 'karak':
        return 'الكرك';
      case 'maan':
        return 'معان';
      case 'madaba':
        return 'مادبا';
      case 'mafraq':
        return 'المفرق';
      case 'tafilah':
        return 'الطفيلة';
      case 'zarqa':
        return 'الزرقاء';
      default:
        return govKey.trim().isEmpty ? '—' : govKey;
    }
  }

  String _unitShort(String raw) {
    final v = raw.trim();
    if (v.endsWith('.gram') || v.endsWith('.g') || v == 'gram' || v == 'g')
      return 'غ';
    if (v.endsWith('.kg') || v == 'kg') return 'كغ';
    if (v.endsWith('.ml') || v == 'ml') return 'مل';
    if (v.endsWith('.l') || v == 'l') return 'لتر';
    if (v.endsWith('.pcs') || v == 'pcs') return 'حبة';
    return '';
  }

  /// نص النسخ فقط (منظم)
  String _buildCopyBlock({
    required String customerName,
    required String phone,
    required String city,
    required String area,
    required String street,
    required String buildingNo,
    required String apartmentNo,
    required String mapsUrl,
  }) {
    final lines = <String>[
      'اسم العميل: $customerName',
      'رقم الهاتف: $phone',
      'المدينة: $city',
      'المنطقة: $area',
      if (street.trim().isNotEmpty) 'الشارع: $street',
      if (buildingNo.trim().isNotEmpty) 'البناية: $buildingNo',
      if (apartmentNo.trim().isNotEmpty) 'الشقة: $apartmentNo',
      if (mapsUrl.trim().isNotEmpty) 'Maps: $mapsUrl',
    ];
    return lines.join('\n');
  }

  // ========= UI =========

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final repo = AdminOrdersRepo(db);
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980, maxHeight: 760),
        child: Scaffold(
          backgroundColor: cs.surface,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('تفاصيل الطلب'),
            centerTitle: true,
            actions: [
              IconButton(
                tooltip: 'إغلاق',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: repo.readOrder(orderId),
            builder: (context, snap) {
              if (snap.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('خطأ: ${snap.error}'),
                );
              }
              if (!snap.hasData)
                return const Center(child: CircularProgressIndicator());

              final data = snap.data!.data();
              if (data == null)
                return const Center(child: Text('الطلب غير موجود'));

              final currency = (data['currency'] ?? 'JOD').toString();
              final total = _toNum(data['total']);
              final deliveryFee = _toNum(data['deliveryFee']);
              final subTotal = _toNum(data['subTotal']);

              final userId = (data['userId'] ?? '').toString().trim();
              final items = (data['items'] as List?)?.cast<Map>() ?? const [];

              // location
              final loc =
                  (data['location'] as Map?)?.cast<String, dynamic>() ?? {};
              final govKey = (loc['govKey'] ?? '').toString().trim();
              final city = _govAr(govKey);

              final area = (loc['area'] ?? '').toString().trim();
              final street = (loc['street'] ?? '').toString().trim();
              final buildingNo = (loc['buildingNo'] ?? '').toString().trim();
              final apartmentNo = (loc['apartmentNo'] ?? '').toString().trim();
              final mapsUrl = (loc['googleMapsUrl'] ?? '').toString().trim();

              // name/phone fallbacks
              final nameFromOrder =
                  (data['fullName'] ?? data['customerName'] ?? '')
                      .toString()
                      .trim();
              final phoneFromOrder =
                  (data['phone'] ?? data['customerPhone'] ?? '')
                      .toString()
                      .trim();
              final phoneFromLoc = (loc['phone'] ?? '').toString().trim();

              return FutureBuilder<UserMini>(
                future: userCache.getUser(userId),
                builder: (context, uSnap) {
                  final nameFromUser = (uSnap.data?.fullName ?? '').trim();
                  final phoneFromUser = (uSnap.data?.phone ?? '').trim();

                  final customerName = nameFromOrder.isNotEmpty
                      ? nameFromOrder
                      : (nameFromUser.isNotEmpty ? nameFromUser : '—');

                  final phone = phoneFromOrder.isNotEmpty
                      ? phoneFromOrder
                      : (phoneFromUser.isNotEmpty
                            ? phoneFromUser
                            : (phoneFromLoc.isNotEmpty ? phoneFromLoc : '—'));

                  final copyBlock = _buildCopyBlock(
                    customerName: customerName,
                    phone: phone,
                    city: city.isEmpty ? '—' : city,
                    area: area.isEmpty ? '—' : area,
                    street: street,
                    buildingNo: buildingNo,
                    apartmentNo: apartmentNo,
                    mapsUrl: mapsUrl,
                  );

                  return Directionality(
                    // يثبت RTL داخل الديالوج
                    textDirection: TextDirection.rtl,
                    child: ListView(
                      padding: const EdgeInsets.all(14),
                      children: [
                        // بيانات العميل والموقع (عرض Rows + نسخ)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'بيانات العميل والموقع',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const Spacer(),
                                    OutlinedButton.icon(
                                      onPressed: () =>
                                          _copy(context, copyBlock),
                                      icon: const Icon(Icons.copy, size: 18),
                                      label: const Text('نسخ الكل'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _KVRow(
                                  label: 'اسم العميل',
                                  value: customerName,
                                ),
                                const SizedBox(height: 6),
                                _KVRow(label: 'رقم الهاتف', value: phone),
                                const SizedBox(height: 10),
                                _KVRow(
                                  label: 'المدينة',
                                  value: city.isEmpty ? '—' : city,
                                ),
                                const SizedBox(height: 6),
                                _KVRow(
                                  label: 'المنطقة',
                                  value: area.isEmpty ? '—' : area,
                                ),
                                if (street.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  _KVRow(label: 'الشارع', value: street),
                                ],
                                if (buildingNo.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  _KVRow(label: 'البناية', value: buildingNo),
                                ],
                                if (apartmentNo.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  _KVRow(label: 'الشقة', value: apartmentNo),
                                ],
                                if (mapsUrl.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Text(
                                        'Maps:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Directionality(
                                          textDirection: TextDirection
                                              .ltr, // رابط LTR دائمًا
                                          child: SelectableText(
                                            mapsUrl,
                                            style: TextStyle(
                                              color: cs.primary,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      OutlinedButton.icon(
                                        onPressed: () =>
                                            _copy(context, mapsUrl),
                                        icon: const Icon(Icons.copy, size: 18),
                                        label: const Text('نسخ'),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // الملخص المالي
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الملخص المالي',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 10),
                                _kv('SubTotal', _money(subTotal, currency)),
                                _kv('Delivery', _money(deliveryFee, currency)),
                                const Divider(height: 18),
                                _kv(
                                  'Total',
                                  _money(total, currency),
                                  strong: true,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // العناصر (تكبير الكمية + ترتيب أقل سعر)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'تفاصيل العناصر',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 10),

                                ...items.map((it) {
                                  final m = it.cast<String, dynamic>();

                                  final nameAr = (m['nameAr'] ?? '')
                                      .toString()
                                      .trim();
                                  final nameEn = (m['nameEn'] ?? '')
                                      .toString()
                                      .trim();
                                  final title = nameAr.isNotEmpty
                                      ? nameAr
                                      : (nameEn.isNotEmpty ? nameEn : '—');

                                  final qty = _toNum(m['qty']);
                                  final unitRaw = (m['unit'] ?? '').toString();
                                  final unit = _unitShort(unitRaw);

                                  final qtyText = unit.isEmpty
                                      ? _fmtQty(qty)
                                      : '${_fmtQty(qty)} $unit';

                                  final lineTotal = _toNum(m['lineTotal']);

                                  final minQty = _toNum(m['minQty']);
                                  final unitPrice = _toNum(m['unitPrice']);
                                  final minPrice = minQty * unitPrice;

                                  final minQtyText = unit.isEmpty
                                      ? _fmtQty(minQty)
                                      : '${_fmtQty(minQty)} $unit';

                                  // 50 غ / 2.250 JOD
                                  final minLine =
                                      '$minQtyText / ${_money(minPrice, currency)}';

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: cs.outlineVariant.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),

                                                // الكمية أكبر وأوضح
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'الكمية: ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                    Text(
                                                      qtyText,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),

                                                // أقل سعر بصيغة نظيفة
                                                Text(
                                                  minLine,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(width: 10),

                                          // السعر على اليمين بصيغة LTR ثابتة
                                          Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Text(
                                              _money(lineTotal, currency),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  static Widget _kv(String k, String v, {bool strong = false}) {
    return Row(
      children: [
        Text(
          k,
          style: TextStyle(
            fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
        const Spacer(),
        Directionality(
          textDirection: TextDirection.ltr, // أرقام/عملة
          child: Text(
            v,
            style: TextStyle(
              fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _KVRow extends StatelessWidget {
  const _KVRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w900)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: cs.onSurface.withOpacity(0.85),
            ),
          ),
        ),
      ],
    );
  }
}

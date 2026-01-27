import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'data/analytics_repo.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

enum _RangeKind { daily, weekly, monthly }

class _AnalyticsPageState extends State<AnalyticsPage> {
  late final AnalyticsRepo _repo;

  _RangeKind _range = _RangeKind.daily;

  @override
  void initState() {
    super.initState();
    _repo = AnalyticsRepo(FirebaseFirestore.instance);
  }

  DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime _startOfMonth(DateTime d) => DateTime(d.year, d.month, 1);

  DateTime _startOfWeek(DateTime d) {
    final dayStart = _startOfDay(d);
    final diff = (dayStart.weekday - DateTime.saturday) % 7;
    return dayStart.subtract(Duration(days: diff));
  }

  ({DateTime from, DateTime to}) _currentRange() {
    final now = DateTime.now();

    switch (_range) {
      case _RangeKind.daily:
        final from = _startOfDay(now);
        return (from: from, to: from.add(const Duration(days: 1)));

      case _RangeKind.weekly:
        final from = _startOfWeek(now);
        return (from: from, to: from.add(const Duration(days: 7)));

      case _RangeKind.monthly:
        final from = _startOfMonth(now);
        final to = DateTime(from.year, from.month + 1, 1);
        return (from: from, to: to);
    }
  }

  String _rangeLabel() {
    switch (_range) {
      case _RangeKind.daily:
        return 'اليوم';
      case _RangeKind.weekly:
        return 'هذا الأسبوع';
      case _RangeKind.monthly:
        return 'هذا الشهر';
    }
  }

  String _fmtDate(DateTime d) {
    final y = d.year.toString();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  Future<_Stats> _loadStats() async {
    final r = _currentRange();
    final docs = await _repo.fetchDeliveredInRange(
      from: r.from,
      toExclusive: r.to,
    );

    int orders = 0;
    double sales = 0; 
    double delivery = 0; 
    String currency = 'JOD';

    for (final doc in docs) {
      final data = doc.data();
      orders++;

      final subTotalVal = data['subTotal'];
      if (subTotalVal is num) sales += subTotalVal.toDouble();

      final deliveryVal = data['deliveryFee'];
      if (deliveryVal is num) delivery += deliveryVal.toDouble();

      currency = (data['currency'] ?? currency).toString();
    }

    return _Stats(
      ordersCount: orders,
      salesSubTotal: sales,
      deliveryTotal: delivery,
      currency: currency,
      from: r.from,
      toExclusive: r.to,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final r = _currentRange();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الاحصائيات'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'تحديث',
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withOpacity(0.55),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: cs.outlineVariant.withOpacity(0.6)),
              ),
              child: Row(
                children: [
                  Icon(Icons.insights_outlined, color: cs.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ملخص ${_rangeLabel()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_fmtDate(r.from)}  →  ${_fmtDate(r.to.subtract(const Duration(days: 1)))}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SegmentedButton<_RangeKind>(
                    segments: const [
                      ButtonSegment(
                        value: _RangeKind.daily,
                        label: Text('يومي'),
                      ),
                      ButtonSegment(
                        value: _RangeKind.weekly,
                        label: Text('أسبوعي'),
                      ),
                      ButtonSegment(
                        value: _RangeKind.monthly,
                        label: Text('شهري'),
                      ),
                    ],
                    selected: {_range},
                    onSelectionChanged: (s) => setState(() => _range = s.first),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: FutureBuilder<_Stats>(
                future: _loadStats(),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return _ErrorState(error: snap.error.toString());
                  }
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final s = snap.data!;
                  final avg = s.ordersCount == 0
                      ? 0
                      : (s.salesSubTotal / s.ordersCount);

                  return ListView(
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _KpiCard(
                            title: 'عدد الطلبات',
                            icon: Icons.receipt_long_outlined,
                            value: '${s.ordersCount}',
                            hint: _rangeLabel(),
                          ),
                          _KpiCard(
                            title: 'المبيعات',
                            icon: Icons.payments_outlined,
                            value:
                                '${s.salesSubTotal.toStringAsFixed(3)} ${s.currency}',
                            hint: 'إجمالي المبيعات (Total Sales)',
                            ltr: true,
                          ),
                          _KpiCard(
                            title: 'متوسط الطلب',
                            icon: Icons.bar_chart_outlined,
                            value: '${avg.toStringAsFixed(3)} ${s.currency}',
                            hint: 'Sales / Orders',
                            ltr: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: cs.outlineVariant.withOpacity(0.6),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                color: cs.primary,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'إجمالي التوصيل ',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                              const Spacer(),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  '${s.deliveryTotal.toStringAsFixed(3)} ${s.currency}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stats {
  const _Stats({
    required this.ordersCount,
    required this.salesSubTotal,
    required this.deliveryTotal,
    required this.currency,
    required this.from,
    required this.toExclusive,
  });

  final int ordersCount;
  final double salesSubTotal;
  final double deliveryTotal;
  final String currency;
  final DateTime from;
  final DateTime toExclusive;
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.icon,
    required this.value,
    required this.hint,
    this.ltr = false,
  });

  final String title;
  final IconData icon;
  final String value;
  final String hint;
  final bool ltr;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: 320,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: cs.outlineVariant.withOpacity(0.6)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Directionality(
                textDirection: ltr ? TextDirection.ltr : TextDirection.rtl,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                hint,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withOpacity(0.65),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'فشل تحميل البيانات\n$error',
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}

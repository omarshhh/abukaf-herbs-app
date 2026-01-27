import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'data/admin_orders_repo.dart';
import 'data/admin_user_cache.dart';
import 'order_details_dialog.dart';
import 'widgets/status_chip.dart';

class OrdersManagementPage extends StatefulWidget {
  const OrdersManagementPage({super.key});

  @override
  State<OrdersManagementPage> createState() => _OrdersManagementPageState();
}

class _OrdersManagementPageState extends State<OrdersManagementPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  late final AdminOrdersRepo _repo;
  late final AdminUserCache _userCache;

  static const _sections = <_OrderSection>[
    _OrderSection(
      title: 'قيد المعالجة',
      status: 'pending',
      icon: Icons.hourglass_bottom,
    ),
    _OrderSection(
      title: 'قيد التحضير',
      status: 'preparing',
      icon: Icons.inventory_2_outlined,
    ),
    _OrderSection(
      title: 'قيد التوصيل',
      status: 'delivering',
      icon: Icons.local_shipping_outlined,
    ),
    _OrderSection(
      title: 'تم التوصيل',
      status: 'delivered',
      icon: Icons.check_circle_outline,
    ),
    _OrderSection(
      title: 'ملغية',
      status: 'cancelled',
      icon: Icons.cancel_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _sections.length, vsync: this);

    final db = FirebaseFirestore.instance;
    _repo = AdminOrdersRepo(db);
    _userCache = AdminUserCache(db);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) {
    final y = d.year.toString();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '$y-$m-$day  $hh:$mm';
  }

  String _statusAr(String s) {
    switch (s) {
      case 'pending':
        return 'قيد المعالجة';
      case 'preparing':
        return 'قيد التحضير';
      case 'delivering':
        return 'قيد التوصيل';
      case 'delivered':
        return 'تم التوصيل';
      case 'cancelled':
        return 'ملغي';
      default:
        return s;
    }
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

  String _approxAddress(Map<String, dynamic> order) {
    final loc = (order['location'] as Map?)?.cast<String, dynamic>() ?? {};
    final govKey = (loc['govKey'] ?? '').toString().trim();
    final area = (loc['area'] ?? '').toString().trim();

    final gov = _govAr(govKey);
    return area.isEmpty ? gov : '$gov - $area';
  }

  Future<void> _openUpdateDialog(
    BuildContext context,
    String orderId,
    String current,
  ) async {
    String selected = current;

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('تعديل حالة الطلب'),
          content: StatefulBuilder(
            builder: (ctx, setState) {
              return DropdownButtonFormField<String>(
                value: selected,
                items: const [
                  DropdownMenuItem(
                    value: 'pending',
                    child: Text('قيد المعالجة'),
                  ),
                  DropdownMenuItem(
                    value: 'preparing',
                    child: Text('قيد التحضير'),
                  ),
                  DropdownMenuItem(
                    value: 'delivering',
                    child: Text('قيد التوصيل'),
                  ),
                  DropdownMenuItem(
                    value: 'delivered',
                    child: Text('تم التوصيل'),
                  ),
                  DropdownMenuItem(value: 'cancelled', child: Text('ملغي')),
                ],
                onChanged: (v) => setState(() => selected = v ?? selected),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'الحالة',
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, selected),
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );

    if (result == null || result == current) return;

    try {
      await _repo.updateOrderStatus(orderId, result);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تحديث الحالة إلى: ${_statusAr(result)}')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل تحديث الحالة: $e')));
    }
  }

  void _openDetails(BuildContext context, String orderId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) =>
          AdminOrderDetailsDialog(orderId: orderId, userCache: _userCache),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Management'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          tabs: _sections.map((s) {
            final showCounter =
                (s.status == 'preparing' || s.status == 'delivering');

            return Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(s.icon, size: 18),
                  const SizedBox(width: 8),
                  Text(s.title),
                  if (showCounter) ...[
                    const SizedBox(width: 8),
                    StreamBuilder<int>(
                      stream: _repo.watchCountByStatus(s.status),
                      builder: (_, snap) {
                        final n = snap.data ?? 0;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: cs.surfaceContainerHighest,
                            border: Border.all(
                              color: cs.outlineVariant.withOpacity(0.6),
                            ),
                          ),
                          child: Text(
                            '$n',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: _sections.map((s) {
          return _OrdersTable(
            status: s.status,
            repo: _repo,
            userCache: _userCache,
            fmtDate: _fmtDate,
            statusAr: _statusAr,
            approxAddress: _approxAddress,
            onEditStatus: _openUpdateDialog,
            onOpenDetails: _openDetails,
          );
        }).toList(),
      ),
    );
  }
}

class _OrdersTable extends StatelessWidget {
  const _OrdersTable({
    required this.status,
    required this.repo,
    required this.userCache,
    required this.fmtDate,
    required this.statusAr,
    required this.approxAddress,
    required this.onEditStatus,
    required this.onOpenDetails,
  });

  final String status;
  final AdminOrdersRepo repo;
  final AdminUserCache userCache;

  final String Function(DateTime) fmtDate;
  final String Function(String) statusAr;
  final String Function(Map<String, dynamic>) approxAddress;

  final Future<void> Function(
    BuildContext,
    String orderId,
    String currentStatus,
  )
  onEditStatus;
  final void Function(BuildContext, String orderId) onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: repo.watchOrdersByStatus(status),
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(child: Text('خطأ: ${snap.error}'));
        }
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return const Center(
            child: Text(
              'لا توجد طلبات هنا حالياً',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Material(
              color: cs.surface,
              child: DataTable(
                headingRowHeight: 52,
                dataRowMinHeight: 56,
                dataRowMaxHeight: 76,
                columns: const [
                  DataColumn(label: Text('اسم العميل')),
                  DataColumn(label: Text('رقم الهاتف')),
                  DataColumn(label: Text('العنوان')),
                  DataColumn(label: Text('الحالة')),
                  DataColumn(label: Text('تاريخ الطلب')),
                  DataColumn(label: Text('إجراءات')),
                ],
                rows: docs.map((d) {
                  final data = d.data();
                  final orderId = d.id;

                  final userId = (data['userId'] ?? '').toString().trim();

                  final createdTs = data['createdAt'];
                  final created = (createdTs is Timestamp)
                      ? createdTs.toDate()
                      : null;
                  final createdText = created == null ? '—' : fmtDate(created);

                  final st = (data['status'] ?? '').toString();
                  final approx = approxAddress(data);

                  return DataRow(
                    cells: [
                      DataCell(
                        FutureBuilder<UserMini>(
                          future: userCache.getUser(userId),
                          builder: (context, s) {
                            if (s.hasError) return const Text('—');
                            if (!s.hasData) return const Text('...');
                            return Text(s.data!.fullName);
                          },
                        ),
                      ),
                      DataCell(
                        FutureBuilder<UserMini>(
                          future: userCache.getUser(userId),
                          builder: (context, s) {
                            if (s.hasError) return const Text('—');
                            if (!s.hasData) return const Text('...');
                            return Text(s.data!.phone);
                          },
                        ),
                      ),
                      DataCell(Text(approx)),
                      DataCell(StatusChip(status: st, label: statusAr(st))),
                      DataCell(Text(createdText)),
                      DataCell(
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () =>
                                  onEditStatus(context, orderId, st),
                              icon: const Icon(Icons.sync_alt, size: 18),
                              label: const Text('تعديل الحالة'),
                            ),
                            const SizedBox(width: 10),
                            FilledButton.icon(
                              onPressed: () => onOpenDetails(context, orderId),
                              icon: const Icon(
                                Icons.visibility_outlined,
                                size: 18,
                              ),
                              label: const Text('التفاصيل'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OrderSection {
  const _OrderSection({
    required this.title,
    required this.status,
    required this.icon,
  });

  final String title;
  final String status;
  final IconData icon;
}

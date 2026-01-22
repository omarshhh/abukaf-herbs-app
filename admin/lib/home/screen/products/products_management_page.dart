import 'dart:async';

import 'package:flutter/material.dart';

import 'widget_products/herb_product_card.dart';
import 'widget_products/herb_product_model.dart';
import 'widget_products/product_form_dialog.dart';
import 'widget_products/products_repository.dart';
import 'widget_products/products_top_bar.dart';

class ProductsManagementPage extends StatefulWidget {
  const ProductsManagementPage({super.key});

  @override
  State<ProductsManagementPage> createState() => _ProductsManagementPageState();
}

class _ProductsManagementPageState extends State<ProductsManagementPage> {
  final _repo = ProductsRepository();
  final TextEditingController _searchCtrl = TextEditingController();

  Timer? _debounce;
  String _liveQuery = '';

  String get _query => _liveQuery;

  void _onSearchChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => _liveQuery = v.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openAddDialog() async {
    final result = await showDialog<HerbProduct>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ProductFormDialog(),
    );

    if (result == null) return;

    try {
      await _repo.addProduct(result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل إضافة المنتج: $e')));
    }
  }

  Future<void> _openEditDialog(HerbProduct editing) async {
    final result = await showDialog<HerbProduct>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProductFormDialog(initial: editing),
    );

    if (result == null) return;

    final updated = result.copyWith(id: editing.id);

    try {
      await _repo.updateProduct(updated);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل تحديث المنتج: $e')));
    }
  }

  void _openDetails(HerbProduct p) {
    final title = p.nameAr.trim().isNotEmpty ? p.nameAr.trim() : p.name.trim();

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _kv('الفئة', p.categoryId),
              _kv('مرئي في الموبايل', p.isActive ? 'نعم' : 'لا'),
              _kv('ضمن اخترنالك', p.forYou ? 'نعم' : 'لا'),
              const Divider(),

              _kv('الاسم (عربي)', p.nameAr.trim().isEmpty ? '-' : p.nameAr),
              _kv('الاسم (إنجليزي)', p.nameEn.trim().isEmpty ? '-' : p.nameEn),
              const Divider(),

              _kv(
                'وصف قصير (عربي)',
                p.shortDescAr.trim().isEmpty ? '-' : p.shortDescAr,
              ),
              const SizedBox(height: 8),
              _kv(
                'وصف قصير (إنجليزي)',
                p.shortDescEn.trim().isEmpty ? '-' : p.shortDescEn,
              ),
              const Divider(),

              _kv(
                'الفوائد (عربي)',
                p.benefitAr.trim().isEmpty ? '-' : p.benefitAr,
              ),
              const SizedBox(height: 8),
              _kv(
                'الفوائد (إنجليزي)',
                p.benefitEn.trim().isEmpty ? '-' : p.benefitEn,
              ),
              const Divider(),

              _kv(
                'طريقة الاستخدام (عربي)',
                p.preparationAr.trim().isEmpty ? '-' : p.preparationAr,
              ),
              const SizedBox(height: 8),
              _kv(
                'طريقة الاستخدام (إنجليزي)',
                p.preparationEn.trim().isEmpty ? '-' : p.preparationEn,
              ),
              const Divider(),

              _kv('الحد الأدنى', p.minQty.toString()),
              _kv('الحد الأعلى', p.maxQty.toString()),
              _kv('قيمة الزيادة', p.stepQty.toString()),
              _kv('سعر الوحدة', '${p.unitPrice.toStringAsFixed(3)} دينار'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: '$k: ',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            TextSpan(text: v),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProductsTopBar(
              searchController: _searchCtrl,
              onSearchChanged: _onSearchChanged,
              onClear: () {
                _searchCtrl.clear();
                _onSearchChanged('');
              },
              onAddPressed: _openAddDialog,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<HerbProduct>>(
                stream: _repo.streamProductsSearch(query: _query, limit: 50),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(child: Text('خطأ: ${snap.error}'));
                  }
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final list = snap.data!;
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        'لا توجد منتجات.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, c) {
                      final w = c.maxWidth;
                      int crossAxisCount = 1;
                      if (w >= 1200) {
                        crossAxisCount = 3;
                      } else if (w >= 800) {
                        crossAxisCount = 2;
                      }

                      return GridView.builder(
                        itemCount: list.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.4,
                        ),
                        itemBuilder: (context, i) {
                          final p = list[i];
                          return HerbProductCard(
                            product: p,
                            onEdit: () => _openEditDialog(p),
                            onDetails: () => _openDetails(p),
                            onToggleActive: () async {
                              final next = !p.isActive;
                              try {
                                await _repo.setActive(p.id, next);
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('فشل التنفيذ: $e')),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
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

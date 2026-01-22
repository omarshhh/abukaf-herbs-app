import 'dart:async';

import 'package:admin/home/screen/products/widget_products/products_repo.dart';
import 'package:flutter/material.dart';

import 'widget_products/herb_product_card.dart';
import 'widget_products/herb_product_model.dart';
import 'widget_products/product_form_dialog.dart';
import 'widget_products/products_top_bar.dart';

class ProductsManagementPage extends StatefulWidget {
  const ProductsManagementPage({super.key});

  @override
  State<ProductsManagementPage> createState() => _ProductsManagementPageState();
}

class _ProductsManagementPageState extends State<ProductsManagementPage> {
  final _repo = ProductsRepo();
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
      ).showSnackBar(SnackBar(content: Text('Failed to add product: $e')));
    }
  }

  Future<void> _openEditDialog(HerbProduct editing) async {
    final result = await showDialog<HerbProduct>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProductFormDialog(initial: editing),
    );

    if (result == null) return;

    // important: keep same id
    final updated = result.copyWith(id: editing.id);

    try {
      await _repo.updateProduct(updated);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update product: $e')));
    }
  }

  void _openDetails(HerbProduct p) {
    final titleAr = p.nameAr.trim().isNotEmpty
        ? p.nameAr.trim()
        : p.name.trim();

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titleAr),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _kv(context, 'Category', p.categoryId),
              _kv(context, 'Visible in Mobile', p.isActive ? 'Yes' : 'No'),
              const Divider(),

              // ✅ Names
              _kv(
                context,
                'Name (AR)',
                p.nameAr.trim().isEmpty ? '-' : p.nameAr,
              ),
              _kv(
                context,
                'Name (EN)',
                p.nameEn.trim().isEmpty ? '-' : p.nameEn,
              ),

              const Divider(),

              // ✅ Benefit
              _kv(
                context,
                'Benefit (AR)',
                p.benefitAr.trim().isEmpty ? '-' : p.benefitAr,
              ),
              const SizedBox(height: 10),
              _kv(
                context,
                'Benefit (EN)',
                p.benefitEn.trim().isEmpty ? '-' : p.benefitEn,
              ),

              const Divider(),

              // ✅ Preparation
              _kv(
                context,
                'Preparation (AR)',
                p.preparationAr.trim().isEmpty ? '-' : p.preparationAr,
              ),
              const SizedBox(height: 10),
              _kv(
                context,
                'Preparation (EN)',
                p.preparationEn.trim().isEmpty ? '-' : p.preparationEn,
              ),

              const Divider(),

              // Qty + Price
              _kv(context, 'Min Qty', p.minQty.toString()),
              _kv(context, 'Max Qty', p.maxQty.toString()),
              _kv(context, 'Step Qty', p.stepQty.toString()),
              _kv(
                context,
                'Unit Price',
                '${p.unitPrice.toStringAsFixed(3)} JD',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) {
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
                stream: _repo.watchProductsSearch(query: _query, limit: 50),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(child: Text('Error: ${snap.error}'));
                  }
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final list = snap.data!;
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        'No products found.',
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
                                await _repo.toggleActive(p.id, next);
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed: $e')),
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

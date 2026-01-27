import 'package:flutter/material.dart';

import 'package:mobile/cart/cart_screen.dart';
import 'package:mobile/cart/controller/cart_controller.dart';
import 'package:mobile/cart/widgets/cart_icon_button.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../data/products_repo.dart';
import '../models/herb_product.dart';
import '../products/herb_category_product_card.dart';
import '../products/product_details_page.dart';
import '../widget/home_search_sheet.dart';

class CategoryProductsPage extends StatelessWidget {
  const CategoryProductsPage({
    super.key,
    required this.categoryId,
    required this.title,
  });

  final String categoryId;
  final String title;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final repo = MobileProductsRepo();

    void openCart() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CartScreen(
            onGoOrders: () {}, 
          ),
        ),
      );
    }

    void openSearch() {
      HomeSearchSheet.open(
        context,
        repo: repo,
        categoryId: categoryId, 
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: openSearch,
          ),
          CartIconButton(onTap: openCart),
          const SizedBox(width: 6),
        ],
      ),
      body: StreamBuilder<List<HerbProduct>>(
        stream: repo.watchByCategory(categoryId: categoryId),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('${t.errorGeneric}: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snap.data!;
          if (list.isEmpty) {
            return Center(
              child: Text(
                t.noProductsFound,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final p = list[i];

              return HerbCategoryProductCard(
                product: p,
                onOpenDetails: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsPage(
                        product: p,
                        onAddToCart: (product, qty) async {
                          CartController.I.addOrMerge(product, qty: qty);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

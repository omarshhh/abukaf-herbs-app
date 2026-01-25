import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../data/products_repo.dart';
import '../products/product_details_page.dart';
import '../../cart/controller/cart_controller.dart';
import 'for_you_strip.dart';

class HomeHeaderSliver extends StatelessWidget {
  const HomeHeaderSliver({
    super.key,
    required this.firstName, // موجود للتماشي مع الاستدعاء، غير مستخدم
    required this.productsRepo,
    required this.cart,
  });

  final String firstName;
  final MobileProductsRepo productsRepo;
  final CartController cart;

  @override
  Widget build(BuildContext context) {
    // احتفظنا بالـ padding الخارجي فقط
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== For You Strip (بدون ترحيب) =====
            ForYouStrip(
              repo: productsRepo,
              onProductTap: (p) {
                Navigator.of(context).push(
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
            ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../categories/category_products_page.dart';
import 'category_card.dart';

class CategoryItem {
  final String id;
  final String title;
  final String image;
  const CategoryItem({
    required this.id,
    required this.title,
    required this.image,
  });
}

class HomeCategoriesGridSliver extends StatelessWidget {
  const HomeCategoriesGridSliver({super.key, required this.categories});

  final List<CategoryItem> categories;

  void _openCategory(BuildContext context, CategoryItem c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryProductsPage(categoryId: c.id, title: c.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, i) {
          final c = categories[i];
          return CategoryCard(
            title: c.title,
            imagePath: c.image,
            onTap: () => _openCategory(context, c),
          );
        }, childCount: categories.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
      ),
    );
  }
}

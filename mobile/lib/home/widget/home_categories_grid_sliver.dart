import 'package:flutter/material.dart';

import 'category_card.dart';

class HomeCategoriesGridSliver extends StatelessWidget {
  const HomeCategoriesGridSliver({super.key, required this.categories});

  final List<(String, String, Widget)> categories;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsetsDirectional.only(start: 16, end: 16, bottom: 16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, i) {
          final item = categories[i];
          return CategoryCard(
            title: item.$1,
            assetPath: item.$2,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item.$3),
              );
            },
          );
        }, childCount: categories.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeSafeTopPaddingSliver extends StatelessWidget {
  const HomeSafeTopPaddingSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return SliverToBoxAdapter(child: SizedBox(height: top));
  }
}

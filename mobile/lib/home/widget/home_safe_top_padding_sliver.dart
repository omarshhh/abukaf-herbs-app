import 'package:flutter/material.dart';

class HomeSafeTopPaddingSliver extends StatelessWidget {
  const HomeSafeTopPaddingSliver({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ This padding stays even if SliverAppBar hides (floating/snap),
    // preventing any content from going under the system status bar.
    final top = MediaQuery.of(context).padding.top;

    return SliverToBoxAdapter(child: SizedBox(height: top));
  }
}

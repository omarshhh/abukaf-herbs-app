import 'package:flutter/material.dart';

class HomePinnedStatusBar extends StatelessWidget {
  const HomePinnedStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _PinnedTopSpacerDelegate(
        height: top,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class _PinnedTopSpacerDelegate extends SliverPersistentHeaderDelegate {
  _PinnedTopSpacerDelegate({required this.height, required this.color});

  final double height;
  final Color color;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // ✅ This stays pinned and prevents content from going under the status bar.
    return Container(color: color);
  }

  @override
  bool shouldRebuild(covariant _PinnedTopSpacerDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.color != color;
  }
}

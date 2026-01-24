import 'package:flutter/material.dart';
import 'package:mobile/cart/controller/cart_controller.dart';

class CartNavIcon extends StatelessWidget {
  const CartNavIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: CartController.I,
      builder: (_, __) {
        final count = CartController.I.linesCount;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon),
            if (count > 0)
              PositionedDirectional(
                top: -6,
                end: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: cs.error,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: cs.surface, width: 2),
                  ),
                  child: Text(
                    '$count',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: cs.onError,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

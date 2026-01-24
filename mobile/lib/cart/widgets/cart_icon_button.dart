import 'package:flutter/material.dart';
import 'package:mobile/cart/controller/cart_controller.dart';

class CartIconButton extends StatelessWidget {
  const CartIconButton({
    super.key,
    required this.onTap,
    this.icon,
    this.tooltip,
  });

  final VoidCallback onTap;
  final IconData? icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: CartController.I,
      builder: (context, _) {
        final count = CartController.I.linesCount;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: onTap,
              icon: Icon(icon ?? Icons.shopping_cart_outlined),
              tooltip: tooltip ?? 'Cart',
            ),
            if (count > 0)
              PositionedDirectional(
                top: -2,
                end: -2,
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

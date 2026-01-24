import 'package:flutter/material.dart';

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    super.key,
    required this.disabled,
    required this.label,
    required this.onCheckout,
  });

  final bool disabled;
  final String label;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(
            top: BorderSide(color: cs.outlineVariant.withOpacity(0.6)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: disabled ? null : onCheckout,
                icon: const Icon(Icons.receipt_long_rounded),
                label: Text(label),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, required this.label});

  final String status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Color bg;
    Color fg;

    switch (status) {
      case 'cancelled':
        bg = cs.errorContainer;
        fg = cs.onErrorContainer;
        break;
      case 'delivering':
        bg = cs.primaryContainer;
        fg = cs.onPrimaryContainer;
        break;
      case 'preparing':
        bg = cs.secondaryContainer;
        fg = cs.onSecondaryContainer;
        break;
      case 'delivered':
        bg = cs.tertiaryContainer;
        fg = cs.onTertiaryContainer;
        break;
      case 'pending':
      default:
        bg = cs.surfaceContainerHighest;
        fg = cs.onSurface;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w900, color: fg),
      ),
    );
  }
}

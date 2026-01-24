import 'package:flutter/material.dart';
import 'package:mobile/cart/controller/cart_controller.dart';
import 'package:mobile/cart/models/cart_item.dart';
import 'package:mobile/cart/widgets/qty_mini_btn.dart';
import 'package:mobile/l10n/app_localizations.dart';

class CartLineCard extends StatelessWidget {
  const CartLineCard({super.key, required this.item});

  final CartItem item;

  String _fmt(double v) {
    final isInt = v.toInt().toDouble() == v;
    if (isInt) return v.toInt().toString();
    return v.toStringAsFixed(3).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final name = isRtl
        ? (item.nameAr.trim().isNotEmpty
              ? item.nameAr.trim()
              : item.nameEn.trim())
        : (item.nameEn.trim().isNotEmpty
              ? item.nameEn.trim()
              : item.nameAr.trim());

    final u = (item.imageUrl ?? '').trim();

    final minPackPrice = item.unitPrice * item.minQty;

    final unitLabel = () {
      final s = item.unit.toString();
      if (s.contains('gram')) return t.unitGram;
      if (s.contains('kilogram')) return t.unitKilogram;
      if (s.contains('ml')) return t.unitMilliliter;
      if (s.contains('liter')) return t.unitLiter;
      return t.unitPiece;
    }();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: cs.outlineVariant.withOpacity(0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 74,
                height: 74,
                color: cs.primary.withOpacity(0.06),
                child: u.isEmpty
                    ? Icon(
                        Icons.image_outlined,
                        color: cs.primary.withOpacity(0.5),
                        size: 32,
                      )
                    : Image.network(
                        u,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.image_not_supported_rounded,
                          color: cs.error,
                          size: 32,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${minPackPrice.toStringAsFixed(3)} ${t.currencyJOD} / ${_fmt(item.minQty)} $unitLabel',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(0.60),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      QtyMiniBtn(
                        icon: Icons.remove_rounded,
                        onTap: () {
                          CartController.I.setQtySafe(
                            item.productId,
                            item.qty - item.stepQty,
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: cs.outlineVariant.withOpacity(0.6),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${t.labelQty}: ${_fmt(item.qty)}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Text(
                                '${item.lineTotal.toStringAsFixed(3)} ${t.currencyJOD}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: cs.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      QtyMiniBtn(
                        icon: Icons.add_rounded,
                        onTap: () {
                          CartController.I.setQtySafe(
                            item.productId,
                            item.qty + item.stepQty,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton.icon(
                      onPressed: () => CartController.I.remove(item.productId),
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: Text(t.actionRemove),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

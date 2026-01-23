import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/cart/cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _showAll = false;

  String _unitLabel(AppLocalizations t, unit) {
    final s = unit.toString();
    if (s.contains('gram')) return t.unitGram;
    if (s.contains('kilogram')) return t.unitKilogram;
    if (s.contains('ml')) return t.unitMilliliter;
    if (s.contains('liter')) return t.unitLiter;
    return t.unitPiece;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    const deliveryFee = 2.0;

    return Scaffold(
      appBar: AppBar(title: Text(t.navCart), centerTitle: true),
      body: AnimatedBuilder(
        animation: CartController.I,
        builder: (context, _) {
          final items = CartController.I.items;

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: cs.onSurface.withOpacity(0.35),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      t.cartEmptyTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      t.cartEmptySubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withOpacity(0.65),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final canCollapse = items.length > 3;
          final visible = (!canCollapse || _showAll)
              ? items
              : items.take(3).toList();

          final subTotal = CartController.I.subTotal;
          final total = subTotal + deliveryFee;

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 110),
            children: [
              ...visible.map((it) => _CartLineCard(item: it)),

              if (canCollapse) ...[
                const SizedBox(height: 6),
                Center(
                  child: TextButton.icon(
                    onPressed: () => setState(() => _showAll = !_showAll),
                    icon: Icon(
                      _showAll
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                    ),
                    label: Text(_showAll ? t.actionShowLess : t.actionShowMore),
                  ),
                ),
              ],

              const SizedBox(height: 12),

              _SummaryCard(
                subTotal: subTotal,
                deliveryFee: deliveryFee,
                total: total,
              ),

              const SizedBox(height: 12),

              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: cs.outlineVariant.withOpacity(0.6)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: cs.primary.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: cs.primary.withOpacity(0.18),
                              ),
                            ),
                            child: Icon(
                              Icons.payments_outlined,
                              size: 20,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            t.paymentMethodTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: cs.outlineVariant.withOpacity(0.6),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: cs.tertiary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                t.paymentCODOnly,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: AnimatedBuilder(
          animation: CartController.I,
          builder: (context, _) {
            final disabled = CartController.I.items.isEmpty;
            final sub = CartController.I.subTotal;
            final total = sub + deliveryFee;

            return Container(
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
                      onPressed: disabled
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(t.checkoutComingSoon)),
                              );
                            },
                      icon: const Icon(Icons.receipt_long_rounded),
                      label: Text(
                        '${t.actionCheckout} • ${total.toStringAsFixed(3)} ${t.currencyJOD}',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CartLineCard extends StatelessWidget {
  const _CartLineCard({required this.item});
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

                  // سعر أقل كمية بخط صغير
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
                      _QtyMiniBtn(
                        icon: Icons.remove_rounded,
                        onTap: () {
                          // نقص بمقدار step، وإذا نزل عن min => controller يحذف
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
                      _QtyMiniBtn(
                        icon: Icons.add_rounded,
                        onTap: () {
                          // زيادة بمقدار step مع احترام max داخل controller
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

class _QtyMiniBtn extends StatelessWidget {
  const _QtyMiniBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest.withOpacity(0.55),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: cs.onSurface.withOpacity(0.85)),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.subTotal,
    required this.deliveryFee,
    required this.total,
  });

  final double subTotal;
  final double deliveryFee;
  final double total;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Widget row(String label, String value, {bool strong = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: strong ? FontWeight.w900 : FontWeight.w800,
                  color: cs.onSurface.withOpacity(strong ? 0.90 : 0.70),
                ),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: strong ? FontWeight.w900 : FontWeight.w800,
                color: strong ? cs.tertiary : cs.onSurface.withOpacity(0.75),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: cs.outlineVariant.withOpacity(0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cs.primary.withOpacity(0.18)),
                  ),
                  child: Icon(
                    Icons.summarize_outlined,
                    size: 20,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  t.orderSummaryTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            row(
              t.labelSubtotal,
              '${subTotal.toStringAsFixed(3)} ${t.currencyJOD}',
            ),
            row(
              t.labelDeliveryFee,
              '${deliveryFee.toStringAsFixed(3)} ${t.currencyJOD}',
            ),
            Divider(color: cs.outlineVariant.withOpacity(0.6)),
            row(
              t.labelGrandTotal,
              '${total.toStringAsFixed(3)} ${t.currencyJOD}',
              strong: true,
            ),
          ],
        ),
      ),
    );
  }
}

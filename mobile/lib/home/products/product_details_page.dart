import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../models/herb_product.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  final HerbProduct product;
  final Future<void> Function(HerbProduct product, double qty) onAddToCart;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late double _qty;
  String? _qtyHint; // يظهر فقط عند الوصول للحدود

  @override
  void initState() {
    super.initState();
    _qty = widget.product.minQty > 0 ? widget.product.minQty : 1;
  }

  String _unitLabel(AppLocalizations t, ProductUnit u) {
    switch (u) {
      case ProductUnit.gram:
        return t.unitGram;
      case ProductUnit.kilogram:
        return t.unitKilogram;
      case ProductUnit.ml:
        return t.unitMilliliter;
      case ProductUnit.liter:
        return t.unitLiter;
      case ProductUnit.piece:
        return t.unitPiece;
    }
  }

  String _fmt(double v) {
    final isInt = v.toInt().toDouble() == v;
    if (isInt) return v.toInt().toString();
    return v.toStringAsFixed(3).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  double _toStepRounded(double v) {
    final p = widget.product;
    final step = p.stepQty <= 0 ? 1.0 : p.stepQty;
    // تقريب بسيط لتفادي أرقام مثل 0.3000000004
    final k = (v / step).roundToDouble();
    return k * step;
  }

  double _clampQty(double v) {
    final p = widget.product;
    final min = (p.minQty <= 0) ? 1.0 : p.minQty;
    final max = (p.maxQty <= 0) ? v : p.maxQty;
    final clamped = v.clamp(min, max);
    return (clamped is num) ? clamped.toDouble() : v;
  }

  void _setHint(String msg) {
    setState(() => _qtyHint = msg);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (_qtyHint == msg) setState(() => _qtyHint = null);
    });
  }

  void _inc(AppLocalizations t) {
    final p = widget.product;
    final step = p.stepQty <= 0 ? 1.0 : p.stepQty;

    final before = _qty;
    final next = _toStepRounded(_clampQty(_qty + step));

    setState(() => _qty = next);

    final max = p.maxQty;
    if (max > 0 && next >= max && before < max) {
      _setHint('${t.labelMax} ${_fmt(max)}');
    } else if (max > 0 && next >= max) {
      _setHint('${t.labelMax} ${_fmt(max)}');
    }
  }

  void _dec(AppLocalizations t) {
    final p = widget.product;
    final step = p.stepQty <= 0 ? 1.0 : p.stepQty;

    final before = _qty;
    final next = _toStepRounded(_clampQty(_qty - step));

    setState(() => _qty = next);

    final min = (p.minQty <= 0) ? 1.0 : p.minQty;
    if (next <= min && before > min) {
      _setHint('${t.labelMin} ${_fmt(min)}');
    } else if (next <= min) {
      _setHint('${t.labelMin} ${_fmt(min)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final p = widget.product;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final title = isRtl
        ? (p.nameAr.trim().isNotEmpty ? p.nameAr.trim() : p.nameEn.trim())
        : (p.nameEn.trim().isNotEmpty ? p.nameEn.trim() : p.nameAr.trim());

    final short = isRtl ? p.shortDescAr.trim() : p.shortDescEn.trim();
    final benefit = isRtl ? p.benefitAr.trim() : p.benefitEn.trim();
    final prep = isRtl ? p.preparationAr.trim() : p.preparationEn.trim();

    final unit = _unitLabel(t, p.unit);
    final total = p.unitPrice * _qty;

    final minQty = (p.minQty <= 0) ? 1.0 : p.minQty;
    final minPackPrice = p.unitPrice * minQty;
    final minPackText =
        '${minPackPrice.toStringAsFixed(3)} ${t.currencyJOD} / ${_fmt(minQty)} $unit';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 310,
            title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            actions: [
              if (p.forYou)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: cs.tertiary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: cs.tertiary.withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        t.labelForYou,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: cs.tertiary,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroImage(url: p.imageUrl),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Title + Min Pack Price =====
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: cs.outlineVariant.withOpacity(0.6),
                          ),
                        ),
                        child: Text(
                          minPackText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.tertiary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (short.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      short,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.55,
                        color: cs.onSurface.withOpacity(0.75),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // ===== Quantity Selector (no explicit min/max text) =====
                  _GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _QtyButton(
                              icon: Icons.remove_rounded,
                              onTap: () => _dec(t),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: cs.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: cs.outlineVariant.withOpacity(0.6),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${_fmt(_qty)} $unit',
                                        textAlign: isRtl
                                            ? TextAlign.right
                                            : TextAlign.left,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w900,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      '${t.labelTotal}: ${total.toStringAsFixed(3)} ${t.currencyJOD}',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: cs.onSurface.withOpacity(
                                              0.75,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _QtyButton(
                              icon: Icons.add_rounded,
                              onTap: () => _inc(t),
                            ),
                          ],
                        ),

                        if (_qtyHint != null) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 18,
                                color: cs.onSurface.withOpacity(0.65),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _qtyHint!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: cs.onSurface.withOpacity(0.70),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===== Benefits =====
                  _InfoSection(
                    title: t.sectionBenefits,
                    icon: Icons.local_florist_rounded,
                    text: benefit.isEmpty ? t.placeholderDash : benefit,
                  ),

                  const SizedBox(height: 12),

                  // ===== How to use =====
                  _InfoSection(
                    title: t.sectionHowToUse,
                    icon: Icons.menu_book_rounded,
                    text: prep.isEmpty ? t.placeholderDash : prep,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ===== Bottom Add To Cart =====
      bottomNavigationBar: SafeArea(
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
                  onPressed: () async {
                    await widget.onAddToCart(p, _qty);
                    if (!mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(t.toastAddedToCart)));
                  },
                  icon: const Icon(Icons.add_shopping_cart_rounded),
                  label: Text(
                    '${t.actionAddToCart} • ${total.toStringAsFixed(3)} ${t.currencyJOD}',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final u = (url ?? '').trim();

    if (u.isEmpty) {
      return Container(
        color: cs.primary.withOpacity(0.06),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            size: 70,
            color: cs.primary.withOpacity(0.55),
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          u,
          fit: BoxFit.cover,
          loadingBuilder: (c, child, p) => p == null
              ? child
              : const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, __, ___) => Container(
            color: cs.primary.withOpacity(0.06),
            child: Center(
              child: Icon(
                Icons.image_not_supported_rounded,
                size: 70,
                color: cs.error,
              ),
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.05),
                Colors.black.withOpacity(0.35),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: cs.outlineVariant.withOpacity(0.6)),
      ),
      child: Padding(padding: const EdgeInsets.all(14), child: child),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
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
          width: 46,
          height: 46,
          child: Icon(icon, color: cs.onSurface.withOpacity(0.85)),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.icon,
    required this.text,
  });

  final String title;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
                  child: Icon(icon, size: 20, color: cs.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.7,
                fontWeight: FontWeight.w700,
                color: cs.onSurface.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

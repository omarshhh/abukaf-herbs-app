// lib/home/widget/for_you_strip.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../data/products_repo.dart';
import '../models/herb_product.dart';

class ForYouStrip extends StatefulWidget {
  const ForYouStrip({
    super.key,
    required this.repo,
    required this.onProductTap,
    this.limit = 12,
    this.autoStepEvery = const Duration(seconds: 4),
  });

  final MobileProductsRepo repo;
  final void Function(HerbProduct product) onProductTap;
  final int limit;

  /// يتحرك خطوة واحدة كل مدة (بدون حركة مستمرة)
  final Duration autoStepEvery;

  @override
  State<ForYouStrip> createState() => _ForYouStripState();
}

class _ForYouStripState extends State<ForYouStrip> {
  final ScrollController _ctrl = ScrollController();
  Timer? _timer;

  static const double _cardWidth = 175;
  static const double _gap = 12;

  bool _started = false;

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _startStepScrollIfPossible() {
    if (_started) return;
    if (!_ctrl.hasClients) return;

    final max = _ctrl.position.maxScrollExtent;
    if (max <= 0) return;

    _started = true;

    _timer?.cancel();
    _timer = Timer.periodic(widget.autoStepEvery, (_) {
      if (!mounted) return;
      if (!_ctrl.hasClients) return;

      final max = _ctrl.position.maxScrollExtent;
      final current = _ctrl.offset;

      final step = _cardWidth + _gap;
      final target = current + step;

      // وصلنا للنهاية => رجوع للبداية بهدوء
      if (target >= max) {
        _ctrl.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
        return;
      }

      _ctrl.animateTo(
        target,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  void _pauseThenResume() {
    _timer?.cancel();
    _started = false;
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _startStepScrollIfPossible();
    });
  }

  String _unitLabel(ProductUnit unit) {
    switch (unit) {
      case ProductUnit.gram:
        return 'g';
      case ProductUnit.kilogram:
        return 'kg';
      case ProductUnit.ml:
        return 'ml';
      case ProductUnit.liter:
        return 'L';
      case ProductUnit.piece:
        return 'pcs';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return StreamBuilder<List<HerbProduct>>(
      stream: widget.repo.watchForYouProducts(limit: widget.limit),
      builder: (context, snap) {
        // ✅ لا تخفي المشاكل بصمت
        if (snap.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '${t.labelForYou}: ${snap.error}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }

        final loading = snap.connectionState == ConnectionState.waiting;
        final items = snap.data ?? const <HerbProduct>[];

        if (!loading && items.isEmpty) return const SizedBox.shrink();

        // ✅ يبدأ التحريك خطوة كل فترة بعد أول رسم
        if (!loading && items.length >= 2) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _startStepScrollIfPossible();
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              t.labelForYou,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),

            // ✅ ارتفاع مضبوط لمنع overflow
            SizedBox(
              height: 185,
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : NotificationListener<UserScrollNotification>(
                      // ✅ المستخدم سحب => وقف مؤقت
                      onNotification: (n) {
                        _pauseThenResume();
                        return false;
                      },
                      child: ListView.separated(
                        controller: _ctrl,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: _gap),
                        itemBuilder: (context, i) {
                          final p = items[i];

                          // ✅ السعر المعروض = سعر أقل كمية (unitPrice * minQty)
                          final minQty = (p.minQty <= 0) ? 1.0 : p.minQty;
                          final minPackPrice = p.unitPrice * minQty;

                          final isIntQty = minQty.toInt().toDouble() == minQty;
                          final qtyLabel = isIntQty
                              ? minQty.toInt().toString()
                              : minQty.toStringAsFixed(2);

                          return _ForYouCard(
                            product: p,
                            onTap: () => widget.onProductTap(p),
                            // مثال: "7.50 / 250 g" (سعر أقل كمية)
                            priceLabel:
                                '${minPackPrice.toStringAsFixed(2)} ${t.currencyJOD} / $qtyLabel ${_unitLabel(p.unit)}',
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _ForYouCard extends StatelessWidget {
  const _ForYouCard({
    required this.product,
    required this.priceLabel,
    required this.onTap,
  });

  final HerbProduct product;
  final String priceLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final title = isRtl
        ? (product.nameAr.trim().isNotEmpty ? product.nameAr : product.nameEn)
        : (product.nameEn.trim().isNotEmpty ? product.nameEn : product.nameAr);

    final short = (isRtl ? product.shortDescAr : product.shortDescEn).trim();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 175,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.dividerColor.withOpacity(0.8)),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ صورة ثابتة الارتفاع لتجنب overflow
            SizedBox(
              height: 105,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _ProductImage(url: product.imageUrl),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.02),
                          Colors.black.withOpacity(0.40),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 10,
                    start: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        priceLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ نص مضبوط
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        short,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          height: 1.2,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(
                            0.75,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (url == null || url!.trim().isEmpty) {
      return Container(
        color: theme.dividerColor.withOpacity(0.15),
        alignment: Alignment.center,
        child: Icon(Icons.local_florist, color: theme.hintColor, size: 40),
      );
    }

    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          color: theme.dividerColor.withOpacity(0.15),
          alignment: Alignment.center,
          child: Icon(Icons.broken_image, color: theme.hintColor, size: 34),
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: theme.dividerColor.withOpacity(0.15),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}

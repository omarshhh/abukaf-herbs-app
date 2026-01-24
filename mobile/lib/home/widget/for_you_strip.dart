import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../data/products_repo.dart';
import '../models/herb_product.dart';

class ForYouStrip extends StatelessWidget {
  const ForYouStrip({
    super.key,
    required this.repo,
    required this.onProductTap,
    this.limit = 12,
  });

  final MobileProductsRepo repo;
  final void Function(HerbProduct product) onProductTap;
  final int limit;

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
      stream: repo.watchForYouProducts(limit: limit),
      builder: (context, snap) {
        final loading = snap.connectionState == ConnectionState.waiting;
        final items = snap.data ?? const <HerbProduct>[];

        if (!loading && items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              // إذا ما عندك key بالترجمة، استبدلها بنص ثابت:
              // 'من أجلك',
              t.labelForYou,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 210,
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final p = items[i];
                        final isRtl =
                            Directionality.of(context) == TextDirection.rtl;
                        final title = isRtl
                            ? (p.nameAr.trim().isNotEmpty ? p.nameAr : p.nameEn)
                            : (p.nameEn.trim().isNotEmpty
                                  ? p.nameEn
                                  : p.nameAr);

                        final short = isRtl ? p.shortDescAr : p.shortDescEn;

                        return InkWell(
                          onTap: () => onProductTap(p),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: 175,
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: theme.dividerColor.withOpacity(0.8),
                              ),
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
                                AspectRatio(
                                  aspectRatio: 16 / 11,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      _ProductImage(url: p.imageUrl),
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
                                      PositionedDirectional(
                                        top: 10,
                                        start: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.55,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                          child: Text(
                                            '${p.unitPrice.toStringAsFixed(2)} / ${_unitLabel(p.unit)}',
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w900,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        short.trim(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              height: 1.2,
                                              color: theme
                                                  .textTheme
                                                  .bodySmall
                                                  ?.color
                                                  ?.withOpacity(0.75),
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: const [
                                          Spacer(),
                                          Icon(Icons.chevron_right, size: 18),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
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

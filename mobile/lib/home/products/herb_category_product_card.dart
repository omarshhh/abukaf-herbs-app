import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import '../models/herb_product.dart';

class HerbCategoryProductCard extends StatelessWidget {
  const HerbCategoryProductCard({
    super.key,
    required this.product,
    required this.onOpenDetails,
  });

  final HerbProduct product;
  final VoidCallback onOpenDetails;

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

  String _fmtQty(double v) {
    final isInt = v.toInt().toDouble() == v;
    if (isInt) return v.toInt().toString();
    return v.toStringAsFixed(3).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  Widget _imagePlaceholder(BuildContext context, {bool loading = false}) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.primary.withOpacity(0.06),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.photo_rounded,
            color: cs.primary.withOpacity(0.45),
            size: 34,
          ),
          if (loading)
            Positioned(
              bottom: 8,
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation(
                    cs.primary.withOpacity(0.75),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // ✅ أقوى من Directionality: اعتمد على لغة التطبيق
    final lang = Localizations.localeOf(context).languageCode.toLowerCase();
    final isRtl = lang == 'ar';
    final dir = isRtl ? TextDirection.rtl : TextDirection.ltr;

    final title = isRtl
        ? (product.nameAr.trim().isNotEmpty
              ? product.nameAr.trim()
              : product.nameEn.trim())
        : (product.nameEn.trim().isNotEmpty
              ? product.nameEn.trim()
              : product.nameAr.trim());

    final short = isRtl
        ? product.shortDescAr.trim()
        : product.shortDescEn.trim();

    final minQty = (product.minQty <= 0) ? 1.0 : product.minQty;
    final unit = _unitLabel(t, product.unit);
    final packPrice = product.unitPrice * minQty;

    final priceText =
        '${packPrice.toStringAsFixed(3)} ${t.currencyJOD} / ${_fmtQty(minQty)} $unit';

    final url = (product.imageUrl ?? '').trim();

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 86,
        height: 86, // 1*1
        child: DecoratedBox(
          decoration: BoxDecoration(color: cs.primary.withOpacity(0.06)),
          child: url.isEmpty
              ? _imagePlaceholder(context, loading: false)
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  // ✅ Placeholder أثناء التحميل
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _imagePlaceholder(context, loading: true);
                  },
                  // ✅ في حال فشل التحميل
                  errorBuilder: (_, __, ___) => Container(
                    color: cs.error.withOpacity(0.07),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: cs.error.withOpacity(0.75),
                      size: 34,
                    ),
                  ),
                ),
        ),
      ),
    );

    return Directionality(
      textDirection: dir,
      child: InkWell(
        onTap: onOpenDetails,
        borderRadius: BorderRadius.circular(18),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: cs.outlineVariant.withOpacity(0.55)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              textDirection: dir,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image,
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      if (short.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          short,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withOpacity(0.70),
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),

                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          priceText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.tertiary,
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
      ),
    );
  }
}

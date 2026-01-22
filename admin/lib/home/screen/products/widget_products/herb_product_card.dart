import 'package:flutter/material.dart';
import 'herb_product_model.dart';

class HerbProductCard extends StatelessWidget {
  const HerbProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDetails,
    required this.onToggleActive,
  });

  final HerbProduct product;
  final VoidCallback onEdit;
  final VoidCallback onDetails;
  final VoidCallback onToggleActive;

  String _unitLabel(ProductUnit u) {
    switch (u) {
      case ProductUnit.gram:
        return 'غ';
      case ProductUnit.kilogram:
        return 'كغ';
      case ProductUnit.ml:
        return 'مل';
      case ProductUnit.liter:
        return 'لتر';
      case ProductUnit.piece:
        return 'قطعة';
    }
  }

  String _categoryLabelAr(String id) {
    switch (id) {
      case 'herbs':
        return 'أعشاب';
      case 'spices':
        return 'بهارات';
      case 'oils':
        return 'زيوت';
      case 'honey':
        return 'عسل';
      case 'cosmetics':
        return 'مستحضرات تجميل';
      case 'best_sellers':
        return 'الأكثر مبيعاً';
      case 'bundles':
        return 'البكجات';
      default:
        return id;
    }
  }

  String _fmtQty(double v) {
    final asInt = v.toInt().toDouble() == v;
    if (asInt) return v.toInt().toString();
    return v.toStringAsFixed(3).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  Widget _buildImage(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final url = (product.imageUrl ?? '').trim();
    if (url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: 86,
        height: 86,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
        errorBuilder: (_, __, ___) =>
            Icon(Icons.image_not_supported, size: 40, color: cs.error),
      );
    }

    if (product.imageBytes != null) {
      return Image.memory(product.imageBytes!, fit: BoxFit.cover);
    }

    return Icon(
      Icons.image_outlined,
      color: cs.primary.withOpacity(0.65),
      size: 32,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final titleAr = product.nameAr.trim().isNotEmpty
        ? product.nameAr.trim()
        : product.name.trim();

    final shortAr = product.shortDescAr.trim();
    final catAr = _categoryLabelAr(product.categoryId);

    final statusText = product.isActive ? 'مُفعّل' : 'مُخفى';
    final statusColor = product.isActive ? cs.primary : cs.error;

    final unitText = _unitLabel(product.unit);

    final priceText = '${product.unitPrice.toStringAsFixed(3)} د.أ / $unitText';

    final minTxt = _fmtQty(product.minQty);
    final maxTxt = _fmtQty(product.maxQty);
    final stepTxt = _fmtQty(product.stepQty);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
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
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 90,
                  height: 90,
                  color: cs.primary.withOpacity(0.06),
                  child: _buildImage(context),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            titleAr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _pill(
                          context,
                          text: statusText,
                          icon: product.isActive
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: statusColor,
                        ),
                        if (product.forYou) ...[
                          const SizedBox(width: 8),
                          _pill(
                            context,
                            text: 'اخترنالك',
                            icon: Icons.star_rounded,
                            color: cs.tertiary,
                          ),
                        ],
                      ],
                    ),

                    if (shortAr.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        shortAr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(0.68),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'الفئة: $catAr',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: cs.onSurface.withOpacity(0.78),
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: cs.primary.withOpacity(0.18),
                            ),
                          ),
                          child: Text(
                            priceText,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: cs.onSurface.withOpacity(0.9),
                                ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _metricChip(
                          context,
                          label: 'أقل كمية',
                          value: '$minTxt $unitText',
                          icon: Icons.arrow_downward_rounded,
                        ),
                        _metricChip(
                          context,
                          label: 'أكثر كمية',
                          value: '$maxTxt $unitText',
                          icon: Icons.arrow_upward_rounded,
                        ),
                        _metricChip(
                          context,
                          label: 'قيمة الزيادة',
                          value: '$stepTxt $unitText',
                          icon: Icons.exposure_plus_1_rounded,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: onDetails,
                          icon: const Icon(Icons.info_outline),
                          label: const Text('تفاصيل'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit),
                          label: const Text('تعديل'),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: product.isActive ? 'إخفاء' : 'إظهار',
                          onPressed: onToggleActive,
                          icon: Icon(
                            product.isActive
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(
    BuildContext context, {
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color.withOpacity(0.95)),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: color.withOpacity(0.95),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricChip(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: cs.onSurface.withOpacity(0.75)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withOpacity(0.65),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface.withOpacity(0.92),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

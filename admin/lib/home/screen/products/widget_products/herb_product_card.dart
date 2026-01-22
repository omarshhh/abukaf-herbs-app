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
        return 'g';
      case ProductUnit.kilogram:
        return 'kg';
      case ProductUnit.ml:
        return 'ml';
      case ProductUnit.liter:
        return 'L';
      case ProductUnit.piece:
        return 'piece';
    }
  }

  Widget _buildImage(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final url = (product.imageUrl ?? '').trim();
    if (url.isNotEmpty) {
      return Image.network(
        product.imageUrl!,
        fit: BoxFit.cover,
        width: 80,
        height: 80,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Image load error: $error');
          return const Icon(
            Icons.image_not_supported,
            size: 40,
            color: Colors.red,
          );
        },
      );
    }

    if (product.imageBytes != null) {
      return Image.memory(product.imageBytes!, fit: BoxFit.cover);
    }

    return Icon(
      Icons.image_outlined,
      color: cs.primary.withOpacity(0.6),
      size: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final statusText = product.isActive ? 'Active (Visible)' : 'Hidden';
    final statusColor = product.isActive ? cs.primary : cs.error;

    final titleAr = (product.nameAr).trim().isNotEmpty
        ? product.nameAr.trim()
        : product.name.trim();

    final titleEn = product.nameEn.trim();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 86,
                height: 86,
                color: cs.primary.withOpacity(0.08),
                child: _buildImage(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Title AR (fallback to old name)
                  Text(
                    titleAr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  // ✅ Subtitle EN if exists
                  if (titleEn.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      titleEn,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.60),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],

                  const SizedBox(height: 6),

                  // ✅ Price with 3 decimals + JD
                  Text(
                    'Category: ${product.categoryId}  •  '
                    '${product.unitPrice.toStringAsFixed(3)} JD / ${_unitLabel(product.unit)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    children: [
                      _chip(context, text: statusText, color: statusColor),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: onDetails,
                        child: const Text('Details'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: onEdit,
                        child: const Text('Edit'),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: product.isActive ? 'Hide' : 'Activate',
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
    );
  }

  Widget _chip(
    BuildContext context, {
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProductsTopBar extends StatelessWidget {
  const ProductsTopBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClear,
    required this.onAddPressed,
    required this.onShippingTaxPressed, // NEW
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClear;
  final VoidCallback onAddPressed;
  final VoidCallback onShippingTaxPressed; // NEW

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'ابحث باسم العشبة',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // NEW button
          OutlinedButton.icon(
            onPressed: onShippingTaxPressed,
            icon: const Icon(Icons.local_shipping_outlined),
            label: const Text('التوصيل/الضريبة'),
          ),

          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.close),
            label: const Text('مسح'),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add),
            label: const Text('إضافة عشبة'),
          ),
        ],
      ),
    );
  }
}

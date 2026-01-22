import 'package:flutter/material.dart';

class ProductsTopBar extends StatelessWidget {
  const ProductsTopBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClear,
    required this.onAddPressed,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClear;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search by herb name',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.close),
          label: const Text('Clear'),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: onAddPressed,
          icon: const Icon(Icons.add),
          label: const Text('Add Herb'),
        ),
      ],
    );
  }
}

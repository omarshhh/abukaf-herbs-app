import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'herb_product_model.dart';
import 'product_image_picker.dart';

class ProductFormDialog extends StatefulWidget {
  const ProductFormDialog({super.key, this.initial});

  final HerbProduct? initial;

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  static final _decimalInput = FilteringTextInputFormatter.allow(
    RegExp(r'^\d*\.?\d{0,6}$'),
  );

  final _formKey = GlobalKey<FormState>();

  // ✅ Bilingual controllers
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _nameEnCtrl;

  late final TextEditingController _benefitArCtrl;
  late final TextEditingController _benefitEnCtrl;

  late final TextEditingController _prepArCtrl;
  late final TextEditingController _prepEnCtrl;

  // Numbers
  late final TextEditingController _minCtrl;
  late final TextEditingController _maxCtrl;
  late final TextEditingController _stepCtrl;
  late final TextEditingController _priceCtrl;

  String _categoryId = 'herbs';

  Uint8List? _imageBytes;
  String? _imageFileName;

  ProductUnit _unit = ProductUnit.gram;
  bool _isActive = true;

  static const _categoryItems = <DropdownMenuItem<String>>[
    DropdownMenuItem(value: 'herbs', child: Text('Herbs')),
    DropdownMenuItem(value: 'spices', child: Text('Spices')),
    DropdownMenuItem(value: 'oils', child: Text('Oils')),
    DropdownMenuItem(value: 'honey', child: Text('Honey')),
    DropdownMenuItem(value: 'cosmetics', child: Text('Cosmetics')),
    DropdownMenuItem(value: 'best_sellers', child: Text('Best Sellers')),
    DropdownMenuItem(value: 'bundles', child: Text('Bundles')),
    DropdownMenuItem(value: 'our_picks', child: Text('Our Picks')),
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.initial;

    _categoryId = p?.categoryId ?? 'herbs';

    // ✅ Fallback: old docs -> use old single-language fields.
    _nameArCtrl = TextEditingController(text: p?.nameAr ?? p?.name ?? '');
    _nameEnCtrl = TextEditingController(text: p?.nameEn ?? '');

    _benefitArCtrl = TextEditingController(
      text: p?.benefitAr ?? p?.benefit ?? '',
    );
    _benefitEnCtrl = TextEditingController(text: p?.benefitEn ?? '');

    _prepArCtrl = TextEditingController(
      text: p?.preparationAr ?? p?.preparation ?? '',
    );
    _prepEnCtrl = TextEditingController(text: p?.preparationEn ?? '');

    _minCtrl = TextEditingController(text: (p?.minQty ?? 1).toString());
    _maxCtrl = TextEditingController(text: (p?.maxQty ?? 50).toString());
    _stepCtrl = TextEditingController(text: (p?.stepQty ?? 1).toString());
    _priceCtrl = TextEditingController(text: (p?.unitPrice ?? 1).toString());

    _unit = p?.unit ?? ProductUnit.gram;
    _isActive = p?.isActive ?? true;

    _imageBytes = p?.imageBytes;
    _imageFileName = p?.imageFileName;
  }

  @override
  void dispose() {
    _nameArCtrl.dispose();
    _nameEnCtrl.dispose();
    _benefitArCtrl.dispose();
    _benefitEnCtrl.dispose();
    _prepArCtrl.dispose();
    _prepEnCtrl.dispose();

    _minCtrl.dispose();
    _maxCtrl.dispose();
    _stepCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  String? _requiredText(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    return null;
  }

  double _toDouble(String s, {double fallback = 0}) {
    final v = double.tryParse(s.trim());
    return v ?? fallback;
  }

  void _submit() {
    // ✅ Will NOT pass unless all required validators are satisfied
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final now = DateTime.now();

    final nameAr = _nameArCtrl.text.trim();
    final nameEn = _nameEnCtrl.text.trim();

    final benefitAr = _benefitArCtrl.text.trim();
    final benefitEn = _benefitEnCtrl.text.trim();

    final prepAr = _prepArCtrl.text.trim();
    final prepEn = _prepEnCtrl.text.trim();

    final product = HerbProduct(
      id: widget.initial?.id ?? 'temp',
      categoryId: _categoryId,

      // ✅ backward fields filled from AR
      name: nameAr,
      benefit: benefitAr,
      preparation: prepAr,

      // ✅ bilingual fields
      nameAr: nameAr,
      nameEn: nameEn,
      benefitAr: benefitAr,
      benefitEn: benefitEn,
      preparationAr: prepAr,
      preparationEn: prepEn,

      unit: _unit,
      minQty: _toDouble(_minCtrl.text, fallback: 0),
      maxQty: _toDouble(_maxCtrl.text, fallback: 0),
      stepQty: _toDouble(_stepCtrl.text, fallback: 1),
      unitPrice: _toDouble(_priceCtrl.text, fallback: 0),
      isActive: _isActive,
      createdAt: widget.initial?.createdAt ?? now,

      imageUrl: widget.initial?.imageUrl,
      imageFileName: _imageFileName,

      imageBytes: _imageBytes,
    );

    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Product' : 'Add Product'),
      content: SizedBox(
        width: 760,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProductImagePicker(
                  valueBytes: _imageBytes,
                  valueFileName: _imageFileName,
                  onChanged: (picked) {
                    setState(() {
                      _imageBytes = picked?.bytes;
                      _imageFileName = picked?.fileName;
                    });
                  },
                ),
                const SizedBox(height: 14),

                // Category + Name AR
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _categoryId,
                        items: _categoryItems,
                        onChanged: (v) => setState(() {
                          _categoryId = v ?? 'herbs';
                        }),
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _nameArCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Herb name (AR)',
                        ),
                        validator: _requiredText,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ✅ Name EN (REQUIRED)
                TextFormField(
                  controller: _nameEnCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Herb name (EN)',
                  ),
                  validator: _requiredText,
                ),

                const SizedBox(height: 12),

                // Unit + Active
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<ProductUnit>(
                        value: _unit,
                        items: const [
                          DropdownMenuItem(
                            value: ProductUnit.gram,
                            child: Text('Gram (g)'),
                          ),
                          DropdownMenuItem(
                            value: ProductUnit.kilogram,
                            child: Text('Kilogram (kg)'),
                          ),
                          DropdownMenuItem(
                            value: ProductUnit.ml,
                            child: Text('Milliliter (ml)'),
                          ),
                          DropdownMenuItem(
                            value: ProductUnit.liter,
                            child: Text('Liter (L)'),
                          ),
                          DropdownMenuItem(
                            value: ProductUnit.piece,
                            child: Text('Piece'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _unit = v ?? ProductUnit.gram),
                        decoration: const InputDecoration(labelText: 'Unit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SwitchListTile.adaptive(
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                        title: const Text('Active (Visible in mobile)'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Qty fields
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [_decimalInput],
                        decoration: const InputDecoration(labelText: 'Min qty'),
                        validator: (v) {
                          final x = double.tryParse((v ?? '').trim());
                          if (x == null) return 'Invalid number';
                          if (x < 0) return 'Must be >= 0';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _maxCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [_decimalInput],
                        decoration: const InputDecoration(labelText: 'Max qty'),
                        validator: (v) {
                          final x = double.tryParse((v ?? '').trim());
                          if (x == null) return 'Invalid number';
                          if (x < 0) return 'Must be >= 0';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _stepCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [_decimalInput],
                        decoration: const InputDecoration(
                          labelText: 'Step qty',
                        ),
                        validator: (v) {
                          final x = double.tryParse((v ?? '').trim());
                          if (x == null) return 'Invalid number';
                          if (x <= 0) return 'Must be > 0';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Price (required already)
                TextFormField(
                  controller: _priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [_decimalInput],
                  decoration: const InputDecoration(
                    labelText: 'Unit price (JD)',
                  ),
                  validator: (v) {
                    final s = (v ?? '').trim();
                    if (s.isEmpty) return 'Required';
                    final x = double.tryParse(s);
                    if (x == null) return 'Invalid number';
                    if (x < 0) return 'Must be >= 0';
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // ✅ Benefit AR/EN (BOTH REQUIRED)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _benefitArCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Benefit (AR)',
                        ),
                        validator: _requiredText,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _benefitEnCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Benefit (EN)',
                        ),
                        validator: _requiredText,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ✅ Preparation AR/EN (BOTH REQUIRED)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _prepArCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Preparation (AR)',
                        ),
                        validator: _requiredText,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _prepEnCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Preparation (EN)',
                        ),
                        validator: _requiredText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(isEdit ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}

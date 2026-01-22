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

  // ✅ Short desc (AR/EN)
  late final TextEditingController _shortDescArCtrl;
  late final TextEditingController _shortDescEnCtrl;

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

  bool _forYou = false;

  static const _categoryItems = <DropdownMenuItem<String>>[
    DropdownMenuItem(value: 'herbs', child: Text('أعشاب')),
    DropdownMenuItem(value: 'spices', child: Text('بهارات')),
    DropdownMenuItem(value: 'oils', child: Text('زيوت')),
    DropdownMenuItem(value: 'honey', child: Text('عسل')),
    DropdownMenuItem(value: 'cosmetics', child: Text('مستحضرات تجميل')),
    DropdownMenuItem(value: 'best_sellers', child: Text('الأكثر مبيعاً')),
    DropdownMenuItem(value: 'bundles', child: Text('البكجات')),
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.initial;

    _categoryId = p?.categoryId ?? 'herbs';

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

    _forYou = p?.forYou ?? false;
    _shortDescArCtrl = TextEditingController(text: p?.shortDescAr ?? '');
    _shortDescEnCtrl = TextEditingController(text: p?.shortDescEn ?? '');

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
    _shortDescArCtrl.dispose();
    _shortDescEnCtrl.dispose();
    _minCtrl.dispose();
    _maxCtrl.dispose();
    _stepCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  String? _requiredTextAr(String? v) {
    if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
    return null;
  }

  String? _requiredShortAr(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'هذا الحقل مطلوب';
    if (s.length < 10) return 'قصير جداً (الحد الأدنى 10 أحرف)';
    return null;
  }

  double _toDouble(String s, {double fallback = 0}) {
    final v = double.tryParse(s.trim());
    return v ?? fallback;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final now = DateTime.now();

    final nameAr = _nameArCtrl.text.trim();
    final nameEn = _nameEnCtrl.text.trim();

    final benefitAr = _benefitArCtrl.text.trim();
    final benefitEn = _benefitEnCtrl.text.trim();

    final prepAr = _prepArCtrl.text.trim();
    final prepEn = _prepEnCtrl.text.trim();

    final shortAr = _shortDescArCtrl.text.trim();
    final shortEn = _shortDescEnCtrl.text.trim();

    final product = HerbProduct(
      id: widget.initial?.id ?? 'temp',
      categoryId: _categoryId,

      name: nameAr,
      benefit: benefitAr,
      preparation: prepAr,

      nameAr: nameAr,
      nameEn: nameEn,
      benefitAr: benefitAr,
      benefitEn: benefitEn,
      preparationAr: prepAr,
      preparationEn: prepEn,

      forYou: _forYou,
      shortDescAr: shortAr,
      shortDescEn: shortEn,

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
      title: Text(isEdit ? 'تعديل منتج' : 'إضافة منتج'),
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
                  valueUrl: widget.initial?.imageUrl,
                  onChanged: (picked) {
                    setState(() {
                      _imageBytes = picked?.bytes;
                      _imageFileName = picked?.fileName;
                    });
                  },
                ),
                const SizedBox(height: 14),

                // الفئة + اسم عربي
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _categoryId,
                        items: _categoryItems,
                        onChanged: (v) =>
                            setState(() => _categoryId = v ?? 'herbs'),
                        decoration: const InputDecoration(labelText: 'الفئة'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _nameArCtrl,
                        decoration: const InputDecoration(
                          labelText: 'اسم المنتج (عربي)',
                        ),
                        validator: _requiredTextAr,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // اسم إنجليزي (مطلوب)
                TextFormField(
                  controller: _nameEnCtrl,
                  decoration: const InputDecoration(
                    labelText: 'اسم المنتج (إنجليزي)',
                  ),
                  validator: _requiredTextAr,
                  textDirection: TextDirection.ltr,
                ),

                const SizedBox(height: 12),

                // الوحدة + حالة الظهور
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<ProductUnit>(
                        value: _unit,
                        items: const [
                          DropdownMenuItem(
                            value: ProductUnit.gram,
                            child: Text('غرام (g)'),
                          ),
                          DropdownMenuItem(
                            value: ProductUnit.kilogram,
                            child: Text('كيلوغرام (kg)'),
                          ),
                          DropdownMenuItem(
                            value: ProductUnit.ml,
                            child: Text('مل (ml)'),
                          ),
                          DropdownMenuItem(
                            value: ProductUnit.liter,
                            child: Text('لتر (L)'),
                          ),
                          DropdownMenuItem(
                            value: ProductUnit.piece,
                            child: Text('قطعة'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _unit = v ?? ProductUnit.gram),
                        decoration: const InputDecoration(labelText: 'الوحدة'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SwitchListTile.adaptive(
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                        title: const Text('مرئي في تطبيق الموبايل'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // اخترنالك
                SwitchListTile.adaptive(
                  value: _forYou,
                  onChanged: (v) => setState(() => _forYou = v),
                  title: const Text('عرض ضمن "اخترنالك"'),
                  contentPadding: EdgeInsets.zero,
                ),

                const SizedBox(height: 12),

                // وصف قصير عربي/إنجليزي (مطلوب)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _shortDescArCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'وصف قصير (عربي)',
                        ),
                        validator: _requiredShortAr,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _shortDescEnCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'وصف قصير (إنجليزي)',
                        ),
                        validator: _requiredShortAr,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // الكميات
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [_decimalInput],
                        decoration: const InputDecoration(
                          labelText: 'الحد الأدنى للكمية',
                        ),
                        validator: (v) {
                          final x = double.tryParse((v ?? '').trim());
                          if (x == null) return 'رقم غير صالح';
                          if (x < 0) return 'يجب أن يكون >= 0';
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
                        decoration: const InputDecoration(
                          labelText: 'الحد الأعلى للكمية',
                        ),
                        validator: (v) {
                          final x = double.tryParse((v ?? '').trim());
                          if (x == null) return 'رقم غير صالح';
                          if (x < 0) return 'يجب أن يكون >= 0';
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
                          labelText: 'قيمة الزيادة',
                        ),
                        validator: (v) {
                          final x = double.tryParse((v ?? '').trim());
                          if (x == null) return 'رقم غير صالح';
                          if (x <= 0) return 'يجب أن يكون > 0';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // السعر
                TextFormField(
                  controller: _priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [_decimalInput],
                  decoration: const InputDecoration(
                    labelText: 'سعر الوحدة (دينار)',
                  ),
                  validator: (v) {
                    final s = (v ?? '').trim();
                    if (s.isEmpty) return 'هذا الحقل مطلوب';
                    final x = double.tryParse(s);
                    if (x == null) return 'رقم غير صالح';
                    if (x < 0) return 'يجب أن يكون >= 0';
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // الفوائد
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _benefitArCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'الفوائد (عربي)',
                        ),
                        validator: _requiredTextAr,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _benefitEnCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'الفوائد (إنجليزي)',
                        ),
                        validator: _requiredTextAr,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // طريقة الاستخدام
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _prepArCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'طريقة الاستخدام (عربي)',
                        ),
                        validator: _requiredTextAr,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _prepEnCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'طريقة الاستخدام (إنجليزي)',
                        ),
                        validator: _requiredTextAr,
                        textDirection: TextDirection.ltr,
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
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(isEdit ? 'حفظ' : 'إضافة'),
        ),
      ],
    );
  }
}

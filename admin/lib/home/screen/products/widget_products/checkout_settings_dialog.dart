import 'package:flutter/material.dart';
import 'checkout_settings_model.dart';

class CheckoutSettingsDialog extends StatefulWidget {
  const CheckoutSettingsDialog({
    super.key,
    required this.initial,
    required this.onSave,
  });

  final CheckoutSettings initial;
  final Future<void> Function(CheckoutSettings updated) onSave;

  @override
  State<CheckoutSettingsDialog> createState() => _CheckoutSettingsDialogState();
}

class _CheckoutSettingsDialogState extends State<CheckoutSettingsDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _taxCtrl;
  late final Map<String, TextEditingController> _govCtrls;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _taxCtrl = TextEditingController(
      text: widget.initial.taxPercent.toString(),
    );
    _govCtrls = {
      for (final e in widget.initial.shippingByGov.entries)
        e.key: TextEditingController(text: e.value.toString()),
    };
  }

  @override
  void dispose() {
    _taxCtrl.dispose();
    for (final c in _govCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  double _parseNum(String s) {
    final v = double.tryParse(s.trim().replaceAll(',', '.'));
    return v ?? 0.0;
  }

  String? _validateNonNegative(String? v) {
    final x = _parseNum(v ?? '');
    if (x < 0) return 'القيمة لا يمكن أن تكون سالبة';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final tax = _parseNum(_taxCtrl.text);

      final shipping = <String, double>{};
      for (final entry in _govCtrls.entries) {
        shipping[entry.key] = _parseNum(entry.value.text);
      }

      final updated = CheckoutSettings(
        taxPercent: tax,
        shippingByGov: shipping,
      );
      await widget.onSave(updated);

      if (!mounted) return;
      Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('إعدادات التوصيل والضريبة'),
        content: SizedBox(
          width: 520,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _taxCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'نسبة الضريبة (%)',
                      hintText: 'مثال: 16',
                      prefixIcon: Icon(Icons.percent),
                    ),
                    validator: _validateNonNegative,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'أسعار التوصيل حسب المحافظة',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  ..._govCtrls.entries.map((e) {
                    final label = CheckoutSettings.govLabelsAr[e.key] ?? e.key;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: e.value,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: label, // عرض عربي
                          prefixIcon: const Icon(Icons.location_on_outlined),
                        ),
                        validator: _validateNonNegative,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            onPressed: _saving ? null : _submit,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}

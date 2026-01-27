import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../../data/user_repo.dart';
import '../../../models/user_profile.dart';

class EditPhoneSheet extends StatefulWidget {
  const EditPhoneSheet({
    super.key,
    required this.userRepo,
    required this.profile,
  });

  final UserRepo userRepo;
  final UserProfile profile;

  static Future<void> open(
    BuildContext context, {
    required UserRepo userRepo,
    required UserProfile profile,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => EditPhoneSheet(userRepo: userRepo, profile: profile),
    );
  }

  @override
  State<EditPhoneSheet> createState() => _EditPhoneSheetState();
}

class _EditPhoneSheetState extends State<EditPhoneSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneCtrl;

  bool _saving = false;

  // Availability
  Timer? _debounce;
  bool _checking = false;
  bool? _available; // null=unknown, true=available, false=taken
  String? _checkError;

  // Keep current stored phone normalized for comparisons
  late final String _currentNormalized;

  @override
  void initState() {
    super.initState();

    _currentNormalized = _normalizeJordanPhone(widget.profile.phone);

    // عرض للمستخدم بصيغة 07xxxxxxxx
    _phoneCtrl = TextEditingController(
      text: _toLocal07Display(_currentNormalized),
    );

    _phoneCtrl.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _phoneCtrl.removeListener(_onPhoneChanged);
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _safeClose() {
    FocusManager.instance.primaryFocus?.unfocus();
    Future<void>.delayed(const Duration(milliseconds: 80), () {
      if (mounted) Navigator.pop(context);
    });
  }

  // ========= Phone utils =========

  // يقبل فقط: 07xxxxxxxx (10) أو 7xxxxxxxx (9)
  bool _looksLikeJordanPhone(String value) {
    final v = value.trim().replaceAll(' ', '');
    if (!RegExp(r'^\d+$').hasMatch(v)) return false;
    if (v.startsWith('07') && v.length == 10) return true;
    if (v.startsWith('7') && v.length == 9) return true;
    return false;
  }

  // يحول إلى صيغة التخزين: +9627xxxxxxxx
  String _normalizeJordanPhone(String value) {
    final v = value.trim().replaceAll(' ', '');

    // already normalized
    if (RegExp(r'^\+9627\d{8}$').hasMatch(v)) return v;

    if (RegExp(r'^7\d{8}$').hasMatch(v)) return '+962$v';

    if (RegExp(r'^07\d{8}$').hasMatch(v)) return '+962${v.substring(1)}';

    return v; // fallback
  }

  // عرض للمستخدم بصيغة 07xxxxxxxx
  String _toLocal07Display(String normalizedOrRaw) {
    final v = normalizedOrRaw.trim();
    if (RegExp(r'^\+9627\d{8}$').hasMatch(v)) {
      // +9627xxxxxxxx -> 07xxxxxxxx
      return '0${v.substring(4)}';
    }
    // لو مخزن عندك 07.. أو 7.. رجّعها بشكل 07..
    if (RegExp(r'^7\d{8}$').hasMatch(v)) return '0$v';
    if (RegExp(r'^07\d{8}$').hasMatch(v)) return v;

    return v;
  }

  // ========= live check =========

  void _onPhoneChanged() {
    final raw = _phoneCtrl.text.trim();

    // reset quick
    setState(() {
      _checkError = null;
      _available = null;
    });

    // لا تفحص إلا إذا شكله صحيح
    if (!_looksLikeJordanPhone(raw)) {
      return;
    }

    final normalized = _normalizeJordanPhone(raw);

    // لو نفس الرقم الحالي → اعتبره متاح (لأن المستخدم نفسه)
    if (normalized == _currentNormalized) {
      setState(() => _available = true);
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      await _checkAvailability(normalized);
    });
  }

  Future<void> _checkAvailability(String normalized) async {
    if (!mounted) return;
    setState(() {
      _checking = true;
      _checkError = null;
      _available = null;
    });

    try {
      final ok = await widget.userRepo.isPhoneAvailable(normalized);
      if (!mounted) return;
      setState(() {
        _available = ok;
        _checking = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _checking = false;
        _checkError = e.toString();
        _available = null;
      });
    }
  }

  String? _validatePhone(AppLocalizations t, String? v) {
    final s = (v ?? '').trim().replaceAll(' ', '');
    if (s.isEmpty) return t.fieldRequired;

    if (!RegExp(r'^\d+$').hasMatch(s)) return t.invalidPhone;

    if (s.length > 10) return t.phoneMax10Digits;

    if (!_looksLikeJordanPhone(s)) return t.invalidPhone;

    final normalized = _normalizeJordanPhone(s);

    // صيغة خاطئة
    if (!RegExp(r'^\+9627\d{8}$').hasMatch(normalized)) {
      return t.invalidPhone;
    }

    // إذا فحصنا وطلع مستخدم
    if (normalized != _currentNormalized && _available == false) {
      return t.phoneAlreadyUsed;
    }

    return null;
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context)!;
    if (_saving) return;

    if (!_formKey.currentState!.validate()) return;

    final normalized = _normalizeJordanPhone(_phoneCtrl.text);

    // guard: إذا مستخدم
    if (normalized != _currentNormalized && _available == false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorPhoneAlreadyUsed)));
      return;
    }

    setState(() => _saving = true);
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      // ✅ لازم تكون هذه الدالة بتعمل transaction على phone_index + users
      await widget.userRepo.changePhoneWithIndex(
        uid: widget.profile.uid,
        oldPhone: _currentNormalized,
        newPhone: normalized,
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${t.failedToSave}: $e')));
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    final normalizedTyped = _looksLikeJordanPhone(_phoneCtrl.text)
        ? _normalizeJordanPhone(_phoneCtrl.text)
        : null;

    final showStatus =
        normalizedTyped != null && normalizedTyped != _currentNormalized;

    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottom),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetHeader(
                title: t.editPhone,
                saving: _saving,
                onClose: _safeClose,
              ),
              const SizedBox(height: 10),

              // التنبيه داخل صفحة التعديل فقط
              _InlineNotice(text: t.editWarningOutForDelivery),
              const SizedBox(height: 12),

              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                maxLength: 10,
                inputFormatters:  [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  labelText: t.phone,
                  prefixIcon: const Icon(Icons.call_outlined),
                  hintText: '07xxxxxxxx',
                  counterText: '',
                ),
                validator: (v) => _validatePhone(t, v),
                onChanged: (v) {
                  // auto-normalize display:
                  // إذا كتب 7xxxxxxxx خلّيه يظهر 07xxxxxxxx
                  final s = v.trim();
                  if (RegExp(r'^7\d{0,8}$').hasMatch(s)) {
                    final fixed = '0$s';
                    if (_phoneCtrl.text != fixed) {
                      final sel = _phoneCtrl.selection;
                      _phoneCtrl.value = _phoneCtrl.value.copyWith(
                        text: fixed,
                        selection: TextSelection.collapsed(
                          offset: (sel.baseOffset + 1).clamp(0, fixed.length),
                        ),
                      );
                    }
                  }
                },
                onFieldSubmitted: (_) => _save(),
              ),

              if (showStatus) ...[
                const SizedBox(height: 6),
                _AvailabilityLine(
                  checking: _checking,
                  available: _available,
                  error: _checkError,
                ),
              ],

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(t.save),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvailabilityLine extends StatelessWidget {
  const _AvailabilityLine({
    required this.checking,
    required this.available,
    required this.error,
  });

  final bool checking;
  final bool? available;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (checking) {
      return Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text(t.checkingPhone),
        ],
      );
    }

    if (error != null && error!.isNotEmpty) {
      return Text(
        '${t.somethingWentWrong}: $error',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    }

    if (available == true) {
      return Text(
        t.phoneAvailable,
        style: const TextStyle(fontWeight: FontWeight.w800),
      );
    }

    if (available == false) {
      return Text(
        t.phoneAlreadyUsed,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.error,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _InlineNotice extends StatelessWidget {
  const _InlineNotice({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.title,
    required this.saving,
    required this.onClose,
  });

  final String title;
  final bool saving;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ),
        TextButton(onPressed: saving ? null : onClose, child: Text(t.close)),
      ],
    );
  }
}

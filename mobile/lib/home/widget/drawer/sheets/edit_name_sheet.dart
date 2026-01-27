import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../../data/user_repo.dart';
import '../../../models/user_profile.dart';

class EditNameSheet extends StatefulWidget {
  const EditNameSheet({
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
      builder: (_) => EditNameSheet(userRepo: userRepo, profile: profile),
    );
  }

  @override
  State<EditNameSheet> createState() => _EditNameSheetState();
}

class _EditNameSheetState extends State<EditNameSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstCtrl;
  late final TextEditingController _lastCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _firstCtrl = TextEditingController(text: widget.profile.firstName);
    _lastCtrl = TextEditingController(text: widget.profile.lastName);
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    super.dispose();
  }

  void _safeClose() {
    FocusManager.instance.primaryFocus?.unfocus();
    Future<void>.delayed(const Duration(milliseconds: 80), () {
      if (mounted) Navigator.pop(context);
    });
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context)!;
    if (_saving) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      await widget.userRepo.updateName(
        uid: widget.profile.uid,
        firstName: _firstCtrl.text,
        lastName: _lastCtrl.text,
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

  String? _req(AppLocalizations t, String? v) {
    if (v == null || v.trim().isEmpty) return t.fieldRequired;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        // ✅ مهم: يلغي الفوكس قبل الخروج (Back أو سحب)
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
                title: t.editName,
                saving: _saving,
                onClose: _safeClose,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _firstCtrl,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: t.firstName,
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
                validator: (v) => _req(t, v),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _lastCtrl,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: t.lastName,
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
                validator: (v) => _req(t, v),
                onFieldSubmitted: (_) => _save(),
              ),

              const SizedBox(height: 16),

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

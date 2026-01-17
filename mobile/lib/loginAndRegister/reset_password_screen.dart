import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations t) async {
    final ok = _formKey.currentState!.validate();
    if (!ok) return;

    setState(() => _loading = true);

    try {
      final email = _emailController.text.trim();

      print('🔄 Attempting to send reset email to: $email'); // ✅ Debug

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      print('✅ Reset email sent successfully!'); // ✅ Debug

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.resetPasswordEmailSent)));

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException: ${e.code} - ${e.message}'); // ✅ Debug

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.resetPasswordEmailSent)));
      Navigator.pop(context);
    } catch (e) {
      print('❌ Unknown error: $e'); // ✅ Debug
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(t.forgotPassword)),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    t.resetPasswordSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: t.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return t.errorEmailRequired;

                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(v)) return t.errorInvalidEmail;

                      return null;
                    },
                    onFieldSubmitted: _loading ? null : (_) => _submit(t),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _loading ? null : () => _submit(t),
                    child: _loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(t.resetPasswordSendButton),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

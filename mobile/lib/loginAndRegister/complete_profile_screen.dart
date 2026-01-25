import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/auth/auth_gate.dart';

import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/loginAndRegister/complete_profile_service.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  bool _looksLikeJordanPhone(String input) {
    final v = input.trim().replaceAll(' ', '');
    return RegExp(r'^7\d{8}$').hasMatch(v) ||
        RegExp(r'^07\d{8}$').hasMatch(v) ||
        RegExp(r'^\+9627\d{8}$').hasMatch(v);
  }

  String _mapCompleteProfileError(AppLocalizations t, Object e) {
    if (e is FirebaseException && e.plugin == 'cloud_firestore') {
      if (e.code == 'already-exists') return t.errorPhoneAlreadyUsed;
    }

    if (e is FirebaseAuthException) {
      if (e.code == 'no-current-user') return t.errorUnauthorized;
    }
    final msg = e.toString().toLowerCase();
    if (msg.contains('network') || msg.contains('unavailable')) {
      return t.errorNetwork;
    }

    return t.errorSomethingWrong;
  }

  Future<void> _submit(AppLocalizations t) async {
    if (_loading) return;

    final ok = _formKey.currentState!.validate();
    if (!ok) return;

    setState(() => _loading = true);

    try {
      await CompleteProfileService.completeProfile(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phoneRaw: phoneController.text,
      );

      if (!mounted) return;

      await Future.delayed(const Duration(milliseconds: 500));

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final profileCompleted = userDoc.data()?['profileCompleted'] ?? false;

        if (!profileCompleted) {
          
          await Future.delayed(const Duration(seconds: 1));
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.savedSuccess)));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      final msg = _mapCompleteProfileError(t, e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
        appBar: AppBar(
          title: Text(t.completeProfileTitle),
          automaticallyImplyLeading: false, 
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [


                  Center(
                    child: Image.asset(
                      'assets/images/user_icon.png',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  Text(
                    t.registerWelcomeTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 24),


                  // Header text
                  Text(
                    t.completeProfileSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                 

                  Row(
                    children: [
                      // First name
                      Expanded(
                        child: TextFormField(
                          controller: firstNameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: t.firstName,
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return t.errorFirstNameRequired;
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Last name
                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: t.lastName,
                            prefixIcon: const Icon(Icons.badge_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return t.errorLastNameRequired;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Phone (Jordan)
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: t.phoneNumber,
                      hintText: '7xxxxxxxx / 07xxxxxxxx',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      prefix: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          '+962',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return t.errorPhoneRequired;
                      if (!_looksLikeJordanPhone(v)) return t.errorInvalidPhone;
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      if (!_loading) _submit(t);
                    },
                  ),

                  const SizedBox(height: 20),

                  // Save button
                  ElevatedButton(
                    onPressed: _loading ? null : () => _submit(t),
                    child: _loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(t.completeProfileSaveButton),
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

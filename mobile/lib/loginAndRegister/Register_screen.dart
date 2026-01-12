import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/auth/auth_gate.dart';
import 'package:mobile/loginAndRegister/register_service.dart';
import 'package:flutter/foundation.dart';



class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;


  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool _looksLikeEmail(String value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(value.trim());
  }

  bool _looksLikeJordanPhone(String value) {
    final v = value.trim().replaceAll(' ', '');

    // 7XXXXXXXX
    final noZero = RegExp(r'^7\d{8}$');

    // 07XXXXXXXX
    final withZero = RegExp(r'^07\d{8}$');

    return noZero.hasMatch(v) || withZero.hasMatch(v);
  }


  String _normalizeJordanPhone(String value) {
    final v = value.trim().replaceAll(' ', '');

    // 7XXXXXXXX → +9627XXXXXXXX
    if (RegExp(r'^7\d{8}$').hasMatch(v)) {
      return '+962$v';
    }

    // 07XXXXXXXX → +9627XXXXXXXX
    if (RegExp(r'^07\d{8}$').hasMatch(v)) {
      return '+962${v.substring(1)}';
    }

    return v;
  }



  String _mapAuthErrorToMessage(AppLocalizations t, FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return t.errorEmailAlreadyUsed;
      case 'invalid-email':
        return t.errorInvalidEmail;
      case 'weak-password':
        return t.errorPasswordWeak;
      default:
        return t.errorSomethingWrong;
    }
  }




  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(t.registerTitle)),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  // First name
                  TextFormField(
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

                  const SizedBox(height: 12),

                  // Last name
                  TextFormField(
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


                  const SizedBox(height: 12),

                  // Phone
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
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
                      if (value == null || value.trim().isEmpty) {
                        return t.errorPhoneRequired;
                      }
                      if (!_looksLikeJordanPhone(value)) {
                        return t.errorInvalidPhone;
                      }
                      return null;
                    },
                  ),



                  const SizedBox(height: 12),

                  // Email
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: t.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return t.errorEmailRequired;
                      }
                      if (!_looksLikeEmail(value)) {
                        return t.errorInvalidEmail;
                      }
                      return null;
                    },
                  ),


                  const SizedBox(height: 12),

                  // Password
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: t.password,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return t.errorPasswordRequired;
                      }
                      if (value.length < 8) {
                        return t.errorPasswordShort;
                      }
                      return null;
                    },
                  ),


                  const SizedBox(height: 12),

                  // Confirm password
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: t.confirmPassword,
                      prefixIcon: const Icon(Icons.lock_reset),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          );
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return t.errorConfirmPasswordRequired;
                      }
                      if (value != passwordController.text) {
                        return t.errorPasswordsNotMatch;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Create account button
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            final ok = _formKey.currentState!.validate();
                            if (!ok) return;

                            setState(() => _isLoading = true);

                            final firstName = firstNameController.text.trim();
                            final lastName = lastNameController.text.trim();
                            final phone = _normalizeJordanPhone(
                              phoneController.text,
                            );
                            final email = emailController.text.trim();
                            final password = passwordController.text;

                            try {
                              await RegisterService.registerUser(
                                firstName: firstName,
                                lastName: lastName,
                                phone: phone,
                                email: email,
                                password: password,
                              );

                              if (!mounted) return;

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AuthGate(),
                                ),
                                (route) => false,
                              );
                            } on FirebaseAuthException catch (e) {
                              final msg = _mapAuthErrorToMessage(t, e);
                              if (mounted) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(msg)));
                              }
                            } on FirebaseException catch (e) {
                              final isPhoneTaken =
                                  e.code == 'already-exists' ||
                                  (e.message?.toLowerCase().contains(
                                        'already exists',
                                      ) ==
                                      true);

                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  
                                  SnackBar(
                                    content: Text(
                                      isPhoneTaken
                                          ? t.errorPhoneAlreadyUsed
                                          : t.errorSomethingWrong,
                                    ),
                                  ),
                                );
                              }
                            } catch (_) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(t.errorUnknown)),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => _isLoading = false);
                            }
                          },
                    child: _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(t.createAccount),
                  ),
                  const SizedBox(height: 12),

                  // Back to login
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(t.alreadyHaveAccountLogin),
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

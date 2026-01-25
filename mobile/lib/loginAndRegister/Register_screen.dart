import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/auth/auth_gate.dart';
import 'package:mobile/loginAndRegister/register_service.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;
  bool _submitted = false;

  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

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
    final v = value.trim();

    if (!RegExp(r'^\d+$').hasMatch(v)) return false;

    if (v.startsWith('07') && v.length == 10) return true;

    if (v.startsWith('7') && v.length == 9) return true;

    return false;
  }

  String _normalizeJordanPhone(String value) {
    final v = value.trim().replaceAll(' ', '');

    if (RegExp(r'^7\d{8}$').hasMatch(v)) {
      return '+962$v';
    }

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

  String? _validateFirstName(AppLocalizations t, String? value) {
    if (value == null || value.trim().isEmpty) {
      return t.errorFirstNameRequired;
    }
    return null;
  }

  String? _validateLastName(AppLocalizations t, String? value) {
    if (value == null || value.trim().isEmpty) {
      return t.errorLastNameRequired;
    }
    return null;
  }

  String? _validatePhone(AppLocalizations t, String? value) {
    if (value == null || value.trim().isEmpty) {
      return t.errorPhoneRequired;
    }
    if (!_looksLikeJordanPhone(value)) {
      return t.errorInvalidPhone;
    }
    return null;
  }

  String? _validateEmail(AppLocalizations t, String? value) {
    if (value == null || value.trim().isEmpty) {
      return t.errorEmailRequired;
    }
    if (!_looksLikeEmail(value)) {
      return t.errorInvalidEmail;
    }
    return null;
  }

  String? _validatePassword(AppLocalizations t, String? value) {
    if (value == null || value.isEmpty) {
      return t.errorPasswordRequired;
    }
    if (value.length < 8) {
      return t.errorPasswordShort;
    }
    return null;
  }

  String? _validateConfirmPassword(AppLocalizations t, String? value) {
    if (value == null || value.isEmpty) {
      return t.errorConfirmPasswordRequired;
    }
    if (value != passwordController.text) {
      return t.errorPasswordsNotMatch;
    }
    return null;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LOGO
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

                Row(
                  children: [
                    // First name
                    Expanded(
                      child: TextField(
                        controller: firstNameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: t.firstName,
                          prefixIcon: const Icon(Icons.person_outline),
                          errorText: _submitted ? _firstNameError : null,
                        ),
                        onChanged: (value) {
                          if (_submitted && _firstNameError != null) {
                            setState(() => _firstNameError = null);
                          }
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Last name
                    Expanded(
                      child: TextField(
                        controller: lastNameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: t.lastName,
                          prefixIcon: const Icon(Icons.badge_outlined),
                          errorText: _submitted ? _lastNameError : null,
                        ),
                        onChanged: (value) {
                          if (_submitted && _lastNameError != null) {
                            setState(() => _lastNameError = null);
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Phone
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
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
                        ),
                      ),
                    ),
                    errorText: _submitted ? _phoneError : null,
                  ),
                  onChanged: (value) {
                    if (_submitted && _phoneError != null) {
                      setState(() => _phoneError = null);
                    }
                  },
                ),

                const SizedBox(height: 12),

                // Email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: t.email,
                    prefixIcon: const Icon(Icons.email_outlined),
                    errorText: _submitted ? _emailError : null,
                  ),
                  onChanged: (value) {
                    if (_submitted && _emailError != null) {
                      setState(() => _emailError = null);
                    }
                  },
                ),

                const SizedBox(height: 12),

                // Password
                TextField(
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
                    errorText: _submitted ? _passwordError : null,
                  ),
                  onChanged: (value) {
                    if (_submitted && _passwordError != null) {
                      setState(() => _passwordError = null);
                    }
                  },
                ),

                const SizedBox(height: 12),

                // Confirm password
                TextField(
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
                    errorText: _submitted ? _confirmPasswordError : null,
                  ),
                  onChanged: (value) {
                    if (_submitted && _confirmPasswordError != null) {
                      setState(() => _confirmPasswordError = null);
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Create account button
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _submitted = true;
                            _firstNameError = _validateFirstName(
                              t,
                              firstNameController.text,
                            );
                            _lastNameError = _validateLastName(
                              t,
                              lastNameController.text,
                            );
                            _phoneError = _validatePhone(
                              t,
                              phoneController.text,
                            );
                            _emailError = _validateEmail(
                              t,
                              emailController.text,
                            );
                            _passwordError = _validatePassword(
                              t,
                              passwordController.text,
                            );
                            _confirmPasswordError = _validateConfirmPassword(
                              t,
                              confirmPasswordController.text,
                            );
                          });

                          if (_firstNameError != null ||
                              _lastNameError != null ||
                              _phoneError != null ||
                              _emailError != null ||
                              _passwordError != null ||
                              _confirmPasswordError != null) {
                            return;
                          }

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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/loginAndRegister/Register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/auth/auth_gate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _loading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Map FirebaseAuth errors to localized messages
  String _mapAuthErrorToMessage(AppLocalizations t, FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return t.errorInvalidCredentials;

    case 'invalid-email':
      return t.errorInvalidEmail;

    case 'user-disabled':
      return t.errorAccountDisabled;

    case 'too-many-requests':
      return t.errorSomethingWrong;

    case 'network-request-failed':
      return t.errorNetwork;

    default:
      return t.errorLoginFailed;
  }
}

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // LOGO
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  Text(
                    t.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Email
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: t.email),
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return t.errorEmailRequired;

                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(v)) return t.errorInvalidEmail;

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // Password
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: t.password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return t.errorPasswordRequired;
                      }
                      return null;
                    },
                  ),

                  // Forgot password
                  Align(
                    alignment: Directionality.of(context) == TextDirection.rtl
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // tODO: Implement reset password later
                      },
                      child: Text(t.forgotPassword),
                    ),
                  ),

                  // Login button
                  ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            final ok = _formKey.currentState!.validate();
                            if (!ok) return;

                            final email = emailController.text.trim();
                            final password = passwordController.text;

                            setState(() => _loading = true);

                            try {
                              // Perform Firebase email/password login
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                              if (!mounted) return;

                              //  Go to AuthGate 
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AuthGate(),
                                ),
                                (_) => false,
                              );
                            } on FirebaseAuthException catch (e) {
                              if (!mounted) return;

                              debugPrint(
                                'Login error: ${e.code} - ${e.message}',
                              );

                              final msg = _mapAuthErrorToMessage(t, e);

                              //  Show error to the user
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(msg)));
                            } finally {
                              if (mounted) setState(() => _loading = false);
                            }
                          },
                    child: _loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(t.loginButton),
                  ),

                  const SizedBox(height: 12),

                  // Google login (later)
                  OutlinedButton(
                    onPressed: () {
                      // tODO: Implement Google sign-in later
                    },
                    child: Text(t.googleLoginButton),
                  ),

                  // Register screen
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      t.noAccountRegister,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
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

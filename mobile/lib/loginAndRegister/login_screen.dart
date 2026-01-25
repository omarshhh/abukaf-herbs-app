import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/loginAndRegister/Register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/auth/auth_gate.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/loginAndRegister/reset_password_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {



  bool _submitted = false;
  String? _emailErrorText;
  String? _passwordErrorText;

  String? _validateEmail(AppLocalizations t, String v) {
    final value = v.trim();
    if (value.isEmpty) return t.errorEmailRequired;

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return t.errorInvalidEmail;

    return null;
  }

  String? _validatePassword(AppLocalizations t, String v) {
    if (v.isEmpty) return t.errorPasswordRequired;
    return null;
  }



  Future<void> _callPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (!await launchUrl(uri)) {
      throw 'Could not call $phone';
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    final uri = Uri.parse('https://wa.me/$phone');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open WhatsApp';
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  // google sign-in
  Future<void> _signInWithGoogle(AppLocalizations t) async {
    setState(() => _loading = true);

    final googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.errorGoogleCanceled)));
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCred.user;
      if (user == null) throw Exception('Google user is null');

      debugPrint('SIGNED IN: uid=${user.uid}, email=${user.email}');


      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      debugPrint('Google sign-in error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorGoogleFailed)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _obscurePassword = true;
  bool _loading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                    decoration: InputDecoration(
                      labelText: t.email,
                      errorText: _submitted ? _emailErrorText : null,
                    ),
                    onChanged: (_) {
                      if (_submitted && _emailErrorText != null) {
                        setState(() => _emailErrorText = null);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  // Password
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: t.password,
                      errorText: _submitted ? _passwordErrorText : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    onChanged: (_) {
                      if (_submitted && _passwordErrorText != null) {
                        setState(() => _passwordErrorText = null);
                      }
                    },
                  ),


                  // Forgot password
                  Align(
                    alignment: Directionality.of(context) == TextDirection.rtl
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(t.forgotPassword),
                    ),
                  ),

                  // Login button
                  ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() {
                              _submitted = true;
                              _emailErrorText = _validateEmail(
                                t,
                                emailController.text,
                              );
                              _passwordErrorText = _validatePassword(
                                t,
                                passwordController.text,
                              );
                            });

                            final ok =
                                _emailErrorText == null &&
                                _passwordErrorText == null;
                            if (!ok) return;

                            final email = emailController.text.trim();
                            final password = passwordController.text;

                            setState(() => _loading = true);

                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                              final uid =
                                  FirebaseAuth.instance.currentUser!.uid;

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .set({
                                    'lastLoginAt': FieldValue.serverTimestamp(),
                                    'provider': 'password',
                                    'email': email.toLowerCase(),
                                  }, SetOptions(merge: true));

                              if (!mounted) return;

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

                  // Google login 
                  OutlinedButton(
                    onPressed: _loading ? null : () => _signInWithGoogle(t),
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

                  SizedBox(height: 55),

                  Text(
                    t.contactUs, 
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Facebook
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.facebook),
                        iconSize: 25,
                        tooltip: 'Facebook',
                        onPressed: () =>
                            _openUrl('https://www.facebook.com/AboKafJo'),
                      ),

                      const SizedBox(width: 10),

                      // Instagram
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.instagram),
                        iconSize: 25,
                        tooltip: 'Instagram',
                        onPressed: () => _openUrl(
                          'https://www.instagram.com/abu_kaf_for_herbs',
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Threads
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.threads),
                        iconSize: 25,
                        tooltip: 'Threads',
                        onPressed: () => _openUrl(
                          'https://www.threads.net/@abu_kaf_for_herbs',
                        ),
                      ),

                      const SizedBox(width: 10),

                      // WhatsApp
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.whatsapp),
                        iconSize: 25,
                        tooltip: 'WhatsApp',
                        onPressed: () => _openWhatsApp('962791671117'),
                      ),

                      const SizedBox(width: 10),

                      // Phone call
                      IconButton(
                        icon: const Icon(Icons.phone_outlined),
                        iconSize: 25,
                        tooltip: 'Call us',
                        onPressed: () => _callPhone('0791671117'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}

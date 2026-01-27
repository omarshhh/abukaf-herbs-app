import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/l10n/app_localizations.dart';

import 'firebase_options.dart';
import 'theam.dart';
import 'auth/auth_gate.dart';
import 'no_internet/internet_gate.dart';
import 'l10n/locale_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_locale == null) {
      final device = View.of(context).platformDispatcher.locale;
      LocaleService.resolveInitialLocale(device).then((loc) {
        if (!mounted) return;
        setState(() => _locale = loc);
      });
    }
  }

  Future<void> setLocale(Locale locale) async {
    await LocaleService.setLocaleForUser(locale);
    if (!mounted) return;
    setState(() => _locale = locale);
  }

  Future<void> toggleLocale() async {
    final cur = _locale?.languageCode ?? 'en';
    final next = (cur == 'ar') ? const Locale('en') : const Locale('ar');
    await setLocale(next);
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      themeMode: ThemeMode.light,

      locale: _locale, 

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar'), Locale('en')],
      builder: (context, child) {
        return InternetGate(child: child ?? const SizedBox.shrink());
      },
      home: const AuthGate(),
    );
  }
}

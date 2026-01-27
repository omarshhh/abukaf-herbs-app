import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static const _prefsKey = 'app_locale'; 

  static const supported = [Locale('ar'), Locale('en')];

  static bool _isSupported(Locale? l) {
    if (l == null) return false;
    return supported.any((x) => x.languageCode == l.languageCode);
  }

  static Locale _fallbackDeviceLocale(Locale device) {
    if (_isSupported(device)) return Locale(device.languageCode);
    return const Locale('en');
  }
  static Future<Locale> resolveInitialLocale(Locale deviceLocale) async {
    final prefs = await SharedPreferences.getInstance();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = snap.data();
      final code = (data?['locale'] ?? '').toString().trim().toLowerCase();
      if (code == 'ar' || code == 'en') {
        await prefs.setString(_prefsKey, code);
        return Locale(code);
      }
    }

    final saved = (prefs.getString(_prefsKey) ?? '').trim().toLowerCase();
    if (saved == 'ar' || saved == 'en') {
      return Locale(saved);
    }

    final initial = _fallbackDeviceLocale(deviceLocale);
    await prefs.setString(_prefsKey, initial.languageCode);
    return initial;
  }

  static Future<void> setLocaleForUser(Locale locale) async {
    if (!_isSupported(locale)) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {
          'locale': locale.languageCode,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );
    }
  }
}

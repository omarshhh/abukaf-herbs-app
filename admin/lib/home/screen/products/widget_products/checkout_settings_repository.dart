import 'package:cloud_firestore/cloud_firestore.dart';
import 'checkout_settings_model.dart';

class CheckoutSettingsRepository {
  CheckoutSettingsRepository(this._db);

  final FirebaseFirestore _db;

  static const String _col = 'app_settings';
  static const String _doc = 'checkout';

  DocumentReference<Map<String, dynamic>> _ref() =>
      _db.collection(_col).doc(_doc);

  Future<CheckoutSettings> getSettings() async {
    final snap = await _ref().get();

    if (!snap.exists || snap.data() == null) {
      final defaults = CheckoutSettings.defaults();

      try {
        await _ref().set(defaults.toMap(), SetOptions(merge: true));
      } catch (_) {
      }

      return defaults;
    }

    return CheckoutSettings.fromMap(snap.data()!);
  }

  Stream<CheckoutSettings> watchSettings() {
    return _ref().snapshots().map((s) {
      final data = s.data();
      if (data == null) return CheckoutSettings.defaults();
      return CheckoutSettings.fromMap(data);
    });
  }

  Future<void> saveSettings(CheckoutSettings settings) async {
    await _ref().set(settings.toMap(), SetOptions(merge: true));
  }
}

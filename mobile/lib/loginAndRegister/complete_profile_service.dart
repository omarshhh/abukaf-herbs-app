import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompleteProfileService {
  static Future<void> completeProfile({
    required String firstName,
    required String lastName,
    required String phoneRaw,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'no-current-user');
    }

    final uid = user.uid;
    final email = user.email?.trim().toLowerCase();

    final phone = _normalizeJordanPhone(phoneRaw);

    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final phoneRef = FirebaseFirestore.instance
        .collection('phone_index')
        .doc(phone);

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final userSnap = await tx.get(userRef);
      final userData = userSnap.data() as Map<String, dynamic>?;

      final oldPhone = (userData?['phone'] as String?)?.trim();
      final oldPhoneNorm = (oldPhone == null || oldPhone.isEmpty)
          ? null
          : _normalizeJordanPhone(oldPhone);

      final isChangingPhone =
          oldPhoneNorm != null &&
          oldPhoneNorm.isNotEmpty &&
          oldPhoneNorm != phone;

      final phoneSnap = await tx.get(phoneRef);
      if (phoneSnap.exists) {
        final existingUid =
            (phoneSnap.data() as Map<String, dynamic>)['uid'] as String?;
        if (existingUid != null && existingUid != uid) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'already-exists',
            message: 'Phone number already exists',
          );
        }
      }

      tx.set(phoneRef, {
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (isChangingPhone) {
        final oldPhoneRef = FirebaseFirestore.instance
            .collection('phone_index')
            .doc(oldPhoneNorm);
        tx.delete(oldPhoneRef);
      }

      tx.set(userRef, {
        'uid': uid,
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'phone': phone,
        if (email != null) 'email': email,

        'profileCompleted': true,
        'profileCompletedAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  static String _normalizeJordanPhone(String value) {
    final v = value.trim().replaceAll(' ', '');

    if (RegExp(r'^7\d{8}$').hasMatch(v)) {
      return '+962$v';
    }

    if (RegExp(r'^07\d{8}$').hasMatch(v)) {
      return '+962${v.substring(1)}';
    }

    if (RegExp(r'^\+9627\d{8}$').hasMatch(v)) {
      return v;
    }

    return v;
  }
}

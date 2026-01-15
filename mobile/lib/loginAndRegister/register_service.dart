import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterService {
  static Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
  }) async {
    // 1) Create Auth user (email uniqueness handled by Firebase)
    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = cred.user!.uid;

    final phoneRef = FirebaseFirestore.instance
        .collection('phone_index')
        .doc(phone);

    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    // 2) Firestore Transaction (atomic)
    try {
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final phoneSnap = await tx.get(phoneRef);

        if (phoneSnap.exists) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'already-exists',
            message: 'Phone number already exists',
          );
        }

        tx.set(phoneRef, {
          'uid': uid,
          'createdAt': FieldValue.serverTimestamp(),
        });

        tx.set(userRef, {
          'uid': uid,
          'firstName': firstName.trim(),
          'lastName': lastName.trim(),
          'phone': phone.trim(),
          'email': email.trim().toLowerCase(),
          'role': 'user',

          // ✅ This flow collects all profile data now
          'profileCompleted': true,

          // Meta
          'provider': 'password',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        });

      });
    } catch (e) {
      // Rollback Auth if Firestore fails
      try {
        await cred.user?.delete();
      } catch (_) {}

      rethrow; 
    }
  }
}

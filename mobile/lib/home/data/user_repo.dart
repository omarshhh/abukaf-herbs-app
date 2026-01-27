import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserRepo {
  final FirebaseFirestore _db;
  UserRepo(this._db);

  DocumentReference<Map<String, dynamic>> userRef(String uid) =>
      _db.collection('users').doc(uid);

  DocumentReference<Map<String, dynamic>> phoneRef(String phone) =>
      _db.collection('phone_index').doc(phone);

  Stream<UserProfile> watchUser(String uid) {
    return userRef(uid).snapshots().map((d) => UserProfile.fromDoc(d));
  }

  Future<void> updateName({
    required String uid,
    required String firstName,
    required String lastName,
  }) async {
    await userRef(uid).update({
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }


  Future<bool> isPhoneAvailable(String normalizedPhone) async {
    final ref = _db.collection('phone_index').doc(normalizedPhone);
    final snap = await ref.get();
    return !snap.exists;
  }


  Future<void> changePhoneWithIndex({
    required String uid,
    required String oldPhone,
    required String newPhone,
  }) async {
    if (oldPhone == newPhone) return;

    final userRef = _db.collection('users').doc(uid);
    final oldRef = _db.collection('phone_index').doc(oldPhone);
    final newRef = _db.collection('phone_index').doc(newPhone);

    await _db.runTransaction((tx) async {
      // تأكد أن newPhone غير محجوز
      final newSnap = await tx.get(newRef);
      if (newSnap.exists) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'already-exists',
          message: 'Phone number already exists',
        );
      }

      // احذف القديم (إن وجد)
      if (oldPhone.trim().isNotEmpty) {
        final oldSnap = await tx.get(oldRef);
        if (oldSnap.exists) {
          tx.delete(oldRef);
        }
      }

      // احجز الجديد
      tx.set(newRef, {'uid': uid, 'createdAt': FieldValue.serverTimestamp()});

      // حدث user doc
      tx.update(userRef, {
        'phone': newPhone,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> changePhone({
    required String uid,
    required String newPhone,
  }) async {
    final normalized = newPhone.trim();

    await _db.runTransaction((tx) async {
      final uref = userRef(uid);
      final uSnap = await tx.get(uref);
      final uData = uSnap.data() ?? <String, dynamic>{};
      final oldPhone = (uData['phone'] ?? '').toString().trim();

      if (normalized.isEmpty) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'invalid-argument',
          message: 'Phone is empty',
        );
      }

      if (oldPhone == normalized) return;

      final newPhoneRef = phoneRef(normalized);
      final newPhoneSnap = await tx.get(newPhoneRef);

      if (newPhoneSnap.exists) {
        final holder = (newPhoneSnap.data()?['uid'] ?? '').toString();
        if (holder.isNotEmpty && holder != uid) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'already-exists',
            message: 'Phone number already exists',
          );
        }
      }

      tx.set(newPhoneRef, {
        'uid': uid,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': newPhoneSnap.exists
            ? (newPhoneSnap.data()?['createdAt'] ??
                  FieldValue.serverTimestamp())
            : FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      tx.update(uref, {
        'phone': normalized,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (oldPhone.isNotEmpty) {
        final oldRef = phoneRef(oldPhone);
        final oldSnap = await tx.get(oldRef);
        if (oldSnap.exists) {
          final holder = (oldSnap.data()?['uid'] ?? '').toString();
          if (holder == uid) {
            tx.delete(oldRef);
          }
        }
      }
    });
  }
}

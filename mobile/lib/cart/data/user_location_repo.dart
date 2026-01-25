import 'package:cloud_firestore/cloud_firestore.dart';

class UserLocationRepo {
  const UserLocationRepo(this._db);

  final FirebaseFirestore _db;

  Stream<String?> watchGovKey(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((snap) {
      final data = snap.data();
      if (data == null) return null;

      final location = data['location'];
      if (location is! Map) return null;

      final govKey = location['govKey'];
      if (govKey is String && govKey.trim().isNotEmpty) {
        return govKey.trim();
      }

      return null;
    });
  }
}

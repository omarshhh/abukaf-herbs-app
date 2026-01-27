import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserCache {
  AdminUserCache(this.db);

  final FirebaseFirestore db;

  final Map<String, Future<UserMini>> _memo = {};

  Future<UserMini> getUser(String uid) {
    final key = uid.trim();
    if (key.isEmpty) {
      return Future.value(const UserMini(fullName: '—', phone: '—'));
    }

    return _memo.putIfAbsent(key, () async {
      final doc = await db.collection('users').doc(key).get();
      final data = doc.data() ?? {};

      // Fallbacks for name fields
      final fullNameDirect =
          (data['fullName'] ?? data['name'] ?? data['displayName'] ?? '')
              .toString()
              .trim();

      final first = (data['firstName'] ?? '').toString().trim();
      final last = (data['lastName'] ?? '').toString().trim();
      final computed = ('$first $last').trim();

      final fullName = fullNameDirect.isNotEmpty
          ? fullNameDirect
          : (computed.isNotEmpty ? computed : '—');

      final phone = (data['phone'] ?? data['mobile'] ?? '').toString().trim();

      return UserMini(fullName: fullName, phone: phone.isEmpty ? '—' : phone);
    });
  }
}

class UserMini {
  const UserMini({required this.fullName, required this.phone});

  final String fullName;
  final String phone;
}

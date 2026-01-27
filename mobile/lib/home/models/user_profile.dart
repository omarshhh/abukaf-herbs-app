import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone; // keep as string
  final Map<String, dynamic>? location;

  const UserProfile({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.location,
  });

  String get fullName {
    final fn = firstName.trim();
    final ln = lastName.trim();
    if (fn.isEmpty && ln.isEmpty) return '';
    if (ln.isEmpty) return fn;
    if (fn.isEmpty) return ln;
    return '$fn $ln';
  }

  factory UserProfile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return UserProfile(
      uid: doc.id,
      firstName: (data['firstName'] ?? '').toString(),
      lastName: (data['lastName'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      phone: (data['phone'] ?? '').toString(),
      location: (data['location'] is Map<String, dynamic>)
          ? (data['location'] as Map<String, dynamic>)
          : null,
    );
  }
}

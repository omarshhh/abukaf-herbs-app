import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/auth/location_gate.dart';
import 'package:mobile/home/home_screen.dart';
import 'package:mobile/loginAndRegister/complete_profile_screen.dart';

class ProfileGate extends StatefulWidget {
  const ProfileGate({super.key});

  @override
  State<ProfileGate> createState() => _ProfileGateState();
}

class _ProfileGateState extends State<ProfileGate> {
  bool _loading = true;
  bool _docExists = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  String _asTrimmedString(dynamic v) {
    if (v == null) return '';
    if (v is String) return v.trim();
    return v.toString().trim();
  }

  bool _hasBasics(Map<String, dynamic> data) {
    final first = _asTrimmedString(data['firstName']);
    final last = _asTrimmedString(data['lastName']);
    final phone = _asTrimmedString(data['phone']);
    return first.isNotEmpty && last.isNotEmpty && phone.isNotEmpty;
  }

  Future<void> _checkProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint('[ProfileGate] currentUser is null');
      if (mounted) setState(() => _loading = false);
      return;
    }

    final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      final doc = await ref.get();

      _docExists = doc.exists;
      final data = doc.data() ?? {};

      final completedFlag = (data['profileCompleted'] == true);
      final basics = _hasBasics(data);

      _completed = completedFlag || basics;

      debugPrint('[ProfileGate] uid=${user.uid}');
      debugPrint('[ProfileGate] exists=$_docExists completed=$_completed');
      debugPrint(
        '[ProfileGate] completedFlag=$completedFlag hasBasics=$basics',
      );
      debugPrint('[ProfileGate] data=$data');
    } catch (e) {
      debugPrint('[ProfileGate] get failed: $e');

      _docExists = false;
      _completed = false;
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_docExists || !_completed) {
      return const CompleteProfileScreen();
    }

    return const LocationGate();
  }
}

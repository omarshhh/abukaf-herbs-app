
import 'package:admin/auth/device_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminGate extends StatelessWidget {
  const AdminGate({super.key});

  static const String _adminEmail = 'abukafherbs@gmail.com';

  bool _isAdmin(User user) {
    final email = (user.email ?? '').trim().toLowerCase();
    return email == _adminEmail;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('غير مسجل الدخول')));
    }

    if (_isAdmin(user)) {
      return const DeviceGate();
    }

    return const _SignOutAndWait();
  }
}

class _SignOutAndWait extends StatefulWidget {
  const _SignOutAndWait();

  @override
  State<_SignOutAndWait> createState() => _SignOutAndWaitState();
}

class _SignOutAndWaitState extends State<_SignOutAndWait> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseAuth.instance.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

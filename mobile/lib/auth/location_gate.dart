import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mobile/home/home_screen.dart';
import 'package:mobile/location/location_form_page.dart';

class LocationGate extends StatefulWidget {
  const LocationGate({super.key});

  @override
  State<LocationGate> createState() => _LocationGateState();
}

class _LocationGateState extends State<LocationGate> {
  static const Duration _minSplash = Duration(milliseconds: 450);

  bool _readyToDecide = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_minSplash, () {
      if (!mounted) return;
      setState(() => _readyToDecide = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) {
      return const _GateLoading();
    }

    final ref = FirebaseFirestore.instance.collection('users').doc(u.uid);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: ref.snapshots(),
      builder: (context, snap) {
        if (!_readyToDecide ||
            snap.connectionState == ConnectionState.waiting) {
          return const _GateLoading();
        }

        if (snap.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: ${snap.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final data = snap.data?.data() ?? {};
        final hasLocation = data['hasLocation'] == true;
        final loc = data['location'];
        final ok = hasLocation && loc is Map;

        if (ok) {
          return const HomeScreen();
        }

        return LocationFormPage(
          userDocRef: ref,
          initialUserData: data,
          isFirstTime: true,
        );
      },
    );
  }
}

class _GateLoading extends StatelessWidget {
  const _GateLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

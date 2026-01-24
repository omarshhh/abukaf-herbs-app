import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/home/home_screen.dart';
import 'package:mobile/location/location_form_page.dart';


class LocationGate extends StatelessWidget {
  const LocationGate({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final u = FirebaseAuth.instance.currentUser;
    if (u == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final ref = FirebaseFirestore.instance.collection('users').doc(u.uid);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: ref.snapshots(),
      builder: (context, snap) {
        if (snap.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(t.locationGateTitle), centerTitle: true),
            body: Center(child: Text('خطأ: ${snap.error}')),
          );
        }

        if (!snap.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text(t.locationGateTitle), centerTitle: true),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final data = snap.data!.data() ?? {};
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

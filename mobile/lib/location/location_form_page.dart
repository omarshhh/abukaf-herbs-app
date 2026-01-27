import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mobile/l10n/app_localizations.dart';

import 'location_map_page.dart';
import 'location_model.dart';

class LocationFormPage extends StatefulWidget {
  const LocationFormPage({
    super.key,
    required this.userDocRef,
    required this.initialUserData,
    required this.isFirstTime,
  });

  final DocumentReference<Map<String, dynamic>> userDocRef;
  final Map<String, dynamic> initialUserData;
  final bool isFirstTime;

  @override
  State<LocationFormPage> createState() => _LocationFormPageState();
}

class _LocationFormPageState extends State<LocationFormPage> {
  final _formKey = GlobalKey<FormState>();

  late String _govKey;
  late final TextEditingController _areaCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _buildingCtrl;
  late final TextEditingController _apartmentCtrl;

  @override
  void initState() {
    super.initState();

    final loc = widget.initialUserData['location'];
    final initial = (loc is Map<String, dynamic>)
        ? UserLocation.fromMap(loc)
        : null;

    _govKey = initial?.govKey ?? 'amman';
    _areaCtrl = TextEditingController(text: initial?.area ?? '');
    _streetCtrl = TextEditingController(text: initial?.street ?? '');
    _buildingCtrl = TextEditingController(text: initial?.buildingNo ?? '');
    _apartmentCtrl = TextEditingController(text: initial?.apartmentNo ?? '');
  }

  @override
  void dispose() {
    _areaCtrl.dispose();
    _streetCtrl.dispose();
    _buildingCtrl.dispose();
    _apartmentCtrl.dispose();
    super.dispose();
  }

  String? _req(AppLocalizations t, String? v) {
    if (v == null || v.trim().isEmpty) return t.locationFieldRequired;
    return null;
  }

  void _next() {
    final t = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final draft = UserLocationDraft(
      govKey: _govKey,
      area: _areaCtrl.text.trim(),
      street: _streetCtrl.text.trim(),
      buildingNo: _buildingCtrl.text.trim(),
      apartmentNo: _apartmentCtrl.text.trim(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocationMapPage(
          userDocRef: widget.userDocRef,
          draft: draft,
          initialLatLng: UserLocation.tryLatLng(
            widget.initialUserData['location'],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFirstTime ? t.locationSetupTitle : t.locationEditTitle,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              t.locationEnterAddress,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _govKey,
              items: JordanGovs.govKeys.map((k) {
                return DropdownMenuItem(
                  value: k,
                  child: Text(JordanGovs.label(t, k)),
                );
              }).toList(),
              onChanged: (v) => setState(() => _govKey = v ?? 'amman'),
              decoration: InputDecoration(
                labelText: t.locationGovLabel,
                prefixIcon: const Icon(Icons.location_city_outlined),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? t.locationChooseGov : null,
            ),

            const SizedBox(height: 12),
            TextFormField(
              controller: _areaCtrl,
              validator: (v) => _req(t, v),
              decoration: InputDecoration(
                labelText: t.locationAreaLabel,
                prefixIcon: const Icon(Icons.place_outlined),
              ),
            ),

            const SizedBox(height: 12),
            TextFormField(
              controller: _streetCtrl,
              validator: (v) => _req(t, v),
              decoration: InputDecoration(
                labelText: t.locationStreetLabel,
                prefixIcon: const Icon(Icons.signpost_outlined),
              ),
            ),

            const SizedBox(height: 12),
            TextFormField(
              controller: _buildingCtrl,
              validator: (v) => _req(t, v),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: t.locationBuildingLabel,
                prefixIcon: const Icon(Icons.apartment_outlined),
              ),
            ),

            const SizedBox(height: 12),
            TextFormField(
              controller: _apartmentCtrl,
              validator: (v) => _req(t, v),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: t.locationApartmentLabel,
                prefixIcon: const Icon(Icons.door_front_door_outlined),
              ),
            ),

            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _next,
              icon: const Icon(Icons.map_outlined),
              label: Text(t.locationNextToMap),
            ),
          ],
        ),
      ),
    );
  }
}

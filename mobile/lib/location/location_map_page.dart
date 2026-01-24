import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/home/home_screen.dart';

import 'location_model.dart';

class LocationMapPage extends StatefulWidget {
  const LocationMapPage({
    super.key,
    required this.userDocRef,
    required this.draft,
    required this.initialLatLng,
  });

  final DocumentReference<Map<String, dynamic>> userDocRef;
  final UserLocationDraft draft;
  final LatLng? initialLatLng;

  @override
  State<LocationMapPage> createState() => _LocationMapPageState();
}

class _LocationMapPageState extends State<LocationMapPage> {
  GoogleMapController? _map;

  LatLng? _picked; // مركز الكاميرا (الدبوس)
  bool _saving = false;

  bool _checking = true;
  bool _permissionGranted = false;

  static const LatLng _fallback = LatLng(31.9539, 35.9106); // Amman

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    setState(() => _checking = true);

    final ok = await _requireLocationPermissionBlocking();
    if (!mounted) return;

    if (!ok) {
      // المستخدم اختار "رجوع"
      return;
    }

    // الآن permission Granted
    setState(() {
      _permissionGranted = true;
      _checking = true; // ما زلنا نجلب الموقع
    });

    await _centerOnCurrentLocation();
    if (!mounted) return;

    setState(() => _checking = false);
  }

  /// Blocking loop:
  /// - لا يترك المستخدم يكمل إلا إذا صار Granted
  /// - أو يرجع للخلف إذا اختار Back
  Future<bool> _requireLocationPermissionBlocking() async {
    final t = AppLocalizations.of(context)!;

    while (mounted) {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        final go = await _showBlockingDialog(
          title: t.locationPermissionTitle,
          message: t.locationServiceDisabledMessage,
          primaryLabel: t.actionRetry,
          secondaryLabel: t.actionBack,
          primaryIcon: Icons.location_on_outlined,
        );

        if (go != true) {
          // رجوع
          if (mounted) Navigator.pop(context);
          return false;
        }

        // retry -> يعيد الحلقة (بعد ما المستخدم يشغل GPS)
        continue;
      }

      var perm = await Geolocator.checkPermission();

      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }

      if (perm == LocationPermission.whileInUse ||
          perm == LocationPermission.always) {
        return true;
      }

      // deniedForever أو denied مرة ثانية
      final isForever = perm == LocationPermission.deniedForever;

      final go = await _showBlockingDialog(
        title: t.locationPermissionTitle,
        message: isForever
            ? t.locationPermissionDeniedForeverMessage
            : t.locationPermissionRequiredMessage,
        primaryLabel: isForever ? t.actionOpenSettings : t.locationRequestAgain,
        secondaryLabel: t.actionBack,
        primaryIcon: isForever ? Icons.settings : Icons.my_location,
      );

      if (go != true) {
        if (mounted) Navigator.pop(context);
        return false;
      }

      if (isForever) {
        await Geolocator.openAppSettings();
      } else {
        await Geolocator.requestPermission();
      }

      // ثم نعيد الحلقة للتحقق مرة أخرى
    }

    return false;
  }

  Future<bool?> _showBlockingDialog({
    required String title,
    required String message,
    required String primaryLabel,
    required String secondaryLabel,
    required IconData primaryIcon,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(secondaryLabel),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: Icon(primaryIcon),
            label: Text(primaryLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _centerOnCurrentLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final here = LatLng(pos.latitude, pos.longitude);

      if (!mounted) return;
      setState(() => _picked = here);

      _map?.animateCamera(CameraUpdate.newLatLngZoom(here, 16));
    } catch (_) {
      // لو فشل الجلب لأي سبب، نستخدم initial/fallback لكن الإذن ما زال مطلوب (ومتحقق)
      if (!mounted) return;
      final start = widget.initialLatLng ?? _fallback;
      setState(() => _picked = start);
      _map?.animateCamera(CameraUpdate.newLatLngZoom(start, 14));
    }
  }

  String _googleMapsUrl(LatLng p) =>
      'https://www.google.com/maps?q=${p.latitude},${p.longitude}';

  Future<void> _save() async {
    final t = AppLocalizations.of(context)!;

    final p = _picked;
    if (p == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.locationPickFirst)));
      return;
    }

    setState(() => _saving = true);
    try {
      final model = UserLocation(
        govKey: widget.draft.govKey,
        area: widget.draft.area,
        street: widget.draft.street,
        buildingNo: widget.draft.buildingNo,
        apartmentNo: widget.draft.apartmentNo,
        lat: p.latitude,
        lng: p.longitude,
        googleMapsUrl: _googleMapsUrl(p),
      );

      await widget.userDocRef.set({
        'hasLocation': true,
        'location': model.toMap(),
        'locationUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.locationSaveFailed(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final start = _picked ?? widget.initialLatLng ?? _fallback;

    return Scaffold(
      appBar: AppBar(title: Text(t.locationPickOnMapTitle), centerTitle: true),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: start, zoom: 14),
            myLocationEnabled: _permissionGranted,
            myLocationButtonEnabled: _permissionGranted,
            onMapCreated: (c) {
              _map = c;
              final p = _picked;
              if (p != null) {
                _map!.animateCamera(CameraUpdate.newLatLngZoom(p, 16));
              }
            },
            onCameraMove: (pos) {
              // لا تسمح بتغيير الدبوس إذا الإذن غير مفعّل (Blocking)
              if (!_permissionGranted) return;
              setState(() => _picked = pos.target);
            },
          ),

          // دبوس ثابت بالمنتصف
          IgnorePointer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 34),
                child: Icon(Icons.place, size: 46, color: cs.primary),
              ),
            ),
          ),

          // Overlay يمنع التفاعل طالما الإذن غير Granted أو أثناء الفحص
          if (!_permissionGranted || _checking)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withOpacity(0.12),
                child: Center(
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: cs.outlineVariant.withOpacity(0.6),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _permissionGranted
                                ? t.locationDetecting
                                : t.locationWaitingPermission,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              child: FilledButton.icon(
                onPressed: (_saving || _checking || !_permissionGranted)
                    ? null
                    : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(t.locationSave),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

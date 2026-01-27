import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile/l10n/app_localizations.dart';

class UserLocationDraft {
  final String govKey; 
  final String area;
  final String street;
  final String buildingNo;
  final String apartmentNo;

  UserLocationDraft({
    required this.govKey,
    required this.area,
    required this.street,
    required this.buildingNo,
    required this.apartmentNo,
  });
}

class UserLocation {
  final String govKey; 
  final String area;
  final String street;
  final String buildingNo;
  final String apartmentNo;
  final double lat;
  final double lng;
  final String googleMapsUrl;

  UserLocation({
    required this.govKey,
    required this.area,
    required this.street,
    required this.buildingNo,
    required this.apartmentNo,
    required this.lat,
    required this.lng,
    required this.googleMapsUrl,
  });

  Map<String, dynamic> toMap() => {
    'govKey': govKey,
    'area': area,
    'street': street,
    'buildingNo': buildingNo,
    'apartmentNo': apartmentNo,
    'lat': lat,
    'lng': lng,
    'googleMapsUrl': googleMapsUrl,
  };

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(
      govKey: (map['govKey'] ?? 'amman').toString(),
      area: (map['area'] ?? '').toString(),
      street: (map['street'] ?? '').toString(),
      buildingNo: (map['buildingNo'] ?? '').toString(),
      apartmentNo: (map['apartmentNo'] ?? '').toString(),
      lat: (map['lat'] is num) ? (map['lat'] as num).toDouble() : 0.0,
      lng: (map['lng'] is num) ? (map['lng'] as num).toDouble() : 0.0,
      googleMapsUrl: (map['googleMapsUrl'] ?? '').toString(),
    );
  }

  static LatLng? tryLatLng(dynamic raw) {
    if (raw is Map) {
      final lat = raw['lat'];
      final lng = raw['lng'];
      if (lat is num && lng is num) {
        return LatLng(lat.toDouble(), lng.toDouble());
      }
    }
    return null;
  }
}

class JordanGovs {
  static const govKeys = [
    'amman',
    'irbid',
    'zarqa',
    'balqa',
    'mafraq',
    'jerash',
    'ajloun',
    'madaba',
    'karak',
    'tafilah',
    'maan',
    'aqaba',
  ];

  static String label(AppLocalizations t, String key) {
    switch (key) {
      case 'amman':
        return t.govAmman;
      case 'irbid':
        return t.govIrbid;
      case 'zarqa':
        return t.govZarqa;
      case 'balqa':
        return t.govBalqa;
      case 'mafraq':
        return t.govMafraq;
      case 'jerash':
        return t.govJerash;
      case 'ajloun':
        return t.govAjloun;
      case 'madaba':
        return t.govMadaba;
      case 'karak':
        return t.govKarak;
      case 'tafilah':
        return t.govTafilah;
      case 'maan':
        return t.govMaan;
      case 'aqaba':
        return t.govAqaba;
      default:
        return key;
    }
  }
}

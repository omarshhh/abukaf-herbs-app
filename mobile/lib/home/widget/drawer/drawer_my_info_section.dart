import 'package:flutter/material.dart';
import 'package:mobile/home/data/user_repo.dart';
import 'package:mobile/home/models/user_profile.dart';
import 'package:mobile/l10n/app_localizations.dart';

import 'sheets/edit_name_sheet.dart';
import 'sheets/edit_phone_sheet.dart';
import 'sheets/confirm_location_sheet.dart';

class DrawerMyInfoSection extends StatelessWidget {
  const DrawerMyInfoSection({
    super.key,
    required this.profile,
    required this.userRepo,
    required this.onProceedEditLocation,
  });

  final UserProfile profile;
  final UserRepo userRepo;
  final void Function(UserProfile profile) onProceedEditLocation;

  Future<void> _closeDrawerIfAny(BuildContext context) async {
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold != null && scaffold.isDrawerOpen) {
      Navigator.of(context).pop(); 
      await Future<void>.delayed(const Duration(milliseconds: 80));
    }
  }

  Future<void> _openEditName(BuildContext context) async {
    await _closeDrawerIfAny(context);
    if (!context.mounted) return;
    await EditNameSheet.open(context, userRepo: userRepo, profile: profile);
  }

  Future<void> _openEditPhone(BuildContext context) async {
    await _closeDrawerIfAny(context);
    if (!context.mounted) return;
    await EditPhoneSheet.open(context, userRepo: userRepo, profile: profile);
  }

  Future<void> _openLocationFlow(BuildContext context) async {
    await _closeDrawerIfAny(context);
    if (!context.mounted) return;

    await showConfirmLocationSheet(
      context,
      onProceed: () => onProceedEditLocation(profile),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 4),
      childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      leading: const Icon(Icons.badge_outlined),
      title: Text(
        t.myInfoTitle,
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      subtitle: Text(t.myInfoSubtitle),
      children: [
        _RowItem(
          label: t.myNameLabel,
          value: profile.fullName.trim().isEmpty
              ? t.guest
              : profile.fullName.trim(),
          onEdit: () => _openEditName(context),
        ),
        const SizedBox(height: 10),
        _RowItem(
          label: t.myPhoneLabel,
          value: profile.phone.trim().isEmpty ? t.notSet : profile.phone.trim(),
          onEdit: () => _openEditPhone(context),
        ),
        const SizedBox(height: 10),
        _RowItem(
          label: t.myLocationLabel,
          value: _locationSummary(profile.location, t),
          onEdit: () => _openLocationFlow(context),
        ),
      ],
    );
  }

  String _locationSummary(Map<String, dynamic>? loc, AppLocalizations t) {
    if (loc == null) return t.noAddress;

    final gov = (loc['govKey'] ?? '').toString().trim();
    final area = (loc['area'] ?? '').toString().trim();
    final street = (loc['street'] ?? '').toString().trim();
    final building = (loc['buildingNo'] ?? '').toString().trim();
    final apartment = (loc['apartmentNo'] ?? '').toString().trim();

    final parts = <String>[];

    if (gov.isNotEmpty) parts.add(gov);
    if (area.isNotEmpty) parts.add(area);
    if (street.isNotEmpty) parts.add(street);
    if (building.isNotEmpty) parts.add('${t.buildingLabel} $building');
    if (apartment.isNotEmpty) parts.add('${t.apartmentLabel} $apartment');

    if (parts.isEmpty) return t.noAddress;
    return parts.join(' - ');
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  final String label;
  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(value, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined)),
        ],
      ),
    );
  }
}

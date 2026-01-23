import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.navCart), centerTitle: true),
    );
  }
}

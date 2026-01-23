import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'no_internet_page.dart';

class InternetGate extends StatefulWidget {
  const InternetGate({super.key, required this.child});
  final Widget child;

  @override
  State<InternetGate> createState() => _InternetGateState();
}

class _InternetGateState extends State<InternetGate> {
  late final StreamSubscription<List<ConnectivityResult>> _sub;
  bool _hasInternet = true;

  Future<void> _check() async {
    final hasInternet = await InternetConnection().hasInternetAccess;

    if (!mounted) return;
    setState(() => _hasInternet = hasInternet);
  }

  @override
  void initState() {
    super.initState();
    _check();
    _sub = Connectivity().onConnectivityChanged.listen((_) => _check());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_hasInternet) const Positioned.fill(child: NoInternetPage()),
      ],
    );
  }
}

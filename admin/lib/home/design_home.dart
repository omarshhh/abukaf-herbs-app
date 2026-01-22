import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screen/analytics/analytics_page.dart';
import 'screen/orders/orders_management_page.dart';
import 'screen/products/products_management_page.dart';

enum AdminSection { analytics, orders, products }

class DesignHome extends StatefulWidget {
  const DesignHome({super.key});

  @override
  State<DesignHome> createState() => _DesignHomeState();
}

class _DesignHomeState extends State<DesignHome> {
  AdminSection _current = AdminSection.analytics; 

  String _title(AdminSection s) {
    switch (s) {
      case AdminSection.analytics:
        return 'Analytics';
      case AdminSection.orders:
        return 'Orders Management';
      case AdminSection.products:
        return 'Products Management';
    }
  }

  Widget _page(AdminSection s) {
    switch (s) {
      case AdminSection.analytics:
        return const AnalyticsPage();
      case AdminSection.orders:
        return const OrdersManagementPage();
      case AdminSection.products:
        return const ProductsManagementPage();
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  TextButton _navItem(String label, AdminSection section) {
    final selected = _current == section;
    final cs = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: () => setState(() => _current = section),
      style: TextButton.styleFrom(
        foregroundColor: selected ? cs.primary : cs.onSurface.withOpacity(0.7),
        textStyle: TextStyle(
          fontWeight: selected ? FontWeight.w900 : FontWeight.w800,
        ),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title(_current)),
        actions: [
          _navItem('Analytics', AdminSection.analytics),
          _navItem('Orders', AdminSection.orders),
          _navItem('Products', AdminSection.products),
          const SizedBox(width: 12),
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _page(_current),
    );
  }
}

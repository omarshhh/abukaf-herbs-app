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
        return 'لوحة الإحصائيات';
      case AdminSection.orders:
        return 'إدارة الطلبات';
      case AdminSection.products:
        return 'إدارة المنتجات';
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
        foregroundColor: selected ? cs.primary : cs.onSurface.withOpacity(0.75),
        textStyle: TextStyle(
          fontWeight: selected ? FontWeight.w900 : FontWeight.w800,
        ),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title(_current)),
          actions: [
            _navItem('الإحصائيات', AdminSection.analytics),
            _navItem('الطلبات', AdminSection.orders),
            _navItem('المنتجات', AdminSection.products),
            const SizedBox(width: 12),
            IconButton(
              tooltip: 'تسجيل الخروج',
              onPressed: _logout,
              icon: const Icon(Icons.logout),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: _page(_current),
      ),
    );
  }
}

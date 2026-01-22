import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

import 'categories/herbs.dart';
import 'categories/spices.dart';
import 'categories/oils.dart';
import 'categories/honey.dart';
import 'categories/cosmetics.dart';
import 'categories/best_sellers.dart';
import 'categories/bundles.dart';

import 'widget/home_drawer.dart';
import 'widget/home_sliver_app_bar.dart';
import 'widget/home_header_sliver.dart';
import 'widget/home_categories_grid_sliver.dart';
import 'widget/home_search_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    const firstName = 'زائر';

    final pages = [
      _CategoriesTab(firstName: firstName),
      const _OrdersTab(),
      const _ProfileTab(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: t.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: t.navOrders,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: t.navProfile,
          ),
        ],
      ),
    );
  }
}

class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab({required this.firstName});

  final String firstName;

  void _openSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.85,
        child: HomeSearchSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final categories = [
      (t.catHerbs, 'assets/categories/herbs.png', const Herbs()),
      (t.catSpices, 'assets/categories/spices.png', const Spices()),
      (t.catOils, 'assets/categories/oils.png', const Oils()),
      (t.catHoney, 'assets/categories/honey.png', const Honey()),
      (t.catCosmetics,'assets/categories/cosmetics.png', const Cosmetics()),
      (t.catBestSellers, 'assets/categories/best_sellers.png',const BestSellers(),),
      (t.catBundles, 'assets/categories/bundles.png', const Bundles()),
    ];

    return Scaffold(
      drawer: HomeDrawer(
        firstName: firstName,
        email: null,
        onOpenSettings: () {
          Navigator.pop(context);
        },
        onOpenAbout: () {
          Navigator.pop(context);
        },
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                HomeSliverAppBar(onSearchPressed: () => _openSearch(context)),
                HomeHeaderSliver(firstName: firstName),
                HomeCategoriesGridSliver(categories: categories),
              ],
            ),

            // ✅ This paints ONLY the system status bar area (Wi-Fi/Time)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).padding.top,
              child: ColoredBox(
                color:
                    Theme.of(context).appBarTheme.backgroundColor ??
                    Theme.of(context).colorScheme.surface,
              ),
            ),
          ],
        ),
      ),
    );

  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.ordersTitle), centerTitle: true),
      body: Center(
        child: Text(
          t.ordersPlaceholder,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.profileTitle), centerTitle: true),
      body: Center(
        child: Text(
          t.profilePlaceholder,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/cart/cart_screen.dart';
import 'package:mobile/cart/controller/cart_controller.dart';
import 'package:mobile/cart/widgets/cart_nav_icon.dart';
import 'package:mobile/home/data/products_repo.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/orders/orders_tab.dart';

import 'widget/home_categories_grid_sliver.dart';
import 'widget/home_drawer.dart';
import 'widget/home_header_sliver.dart';
import 'widget/home_search_sheet.dart';
import 'widget/home_sliver_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final MobileProductsRepo _productsRepo = MobileProductsRepo();
  final CartController _cart = CartController.I;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    const firstName = 'زائر';

    final pages = [
      _CategoriesTab(
        firstName: firstName,
        productsRepo: _productsRepo,
        cart: _cart,
      ),
      const OrdersTab(),
      CartScreen(onGoOrders: () => setState(() => _index = 1)),
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
            icon: const CartNavIcon(icon: Icons.shopping_cart_outlined),
            selectedIcon: const CartNavIcon(icon: Icons.shopping_cart),
            label: t.navCart,
          ),
        ],
      ),
    );
  }
}

class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab({
    required this.firstName,
    required this.productsRepo,
    required this.cart,
  });

  final String firstName;
  final MobileProductsRepo productsRepo;
  final CartController cart;

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

    final categories = <CategoryItem>[
      CategoryItem(
        id: 'herbs',
        title: t.catHerbs,
        image: 'assets/categories/herbs.png',
      ),
      CategoryItem(
        id: 'spices',
        title: t.catSpices,
        image: 'assets/categories/spices.png',
      ),
      CategoryItem(
        id: 'oils',
        title: t.catOils,
        image: 'assets/categories/oils.png',
      ),
      CategoryItem(
        id: 'honey',
        title: t.catHoney,
        image: 'assets/categories/honey.png',
      ),
      CategoryItem(
        id: 'cosmetics',
        title: t.catCosmetics,
        image: 'assets/categories/cosmetics.png',
      ),
      CategoryItem(
        id: 'best_sellers',
        title: t.catBestSellers,
        image: 'assets/categories/best_sellers.png',
      ),
      CategoryItem(
        id: 'bundles',
        title: t.catBundles,
        image: 'assets/categories/bundles.png',
      ),
    ];

    return Scaffold(
      drawer: HomeDrawer(
        firstName: firstName,
        email: null,
        onOpenSettings: () => Navigator.pop(context),
        onOpenAbout: () => Navigator.pop(context),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                HomeSliverAppBar(onSearchPressed: () => _openSearch(context)),

                HomeHeaderSliver(
                  firstName: firstName,
                  productsRepo: productsRepo,
                  cart: cart,
                ),

                HomeCategoriesGridSliver(categories: categories),
              ],
            ),

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

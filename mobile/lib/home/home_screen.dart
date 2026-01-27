import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mobile/cart/cart_screen.dart';
import 'package:mobile/cart/controller/cart_controller.dart';
import 'package:mobile/cart/widgets/cart_nav_icon.dart';
import 'package:mobile/home/data/products_repo.dart';
import 'package:mobile/home/data/user_repo.dart';
import 'package:mobile/home/models/user_profile.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/location/location_form_page.dart';
import 'package:mobile/main.dart';
import 'package:mobile/orders/orders_tab.dart';
import 'package:mobile/orders/widgets/orders_nav_icon.dart';

import 'widget/home_categories_grid_sliver.dart';
import 'widget/drawer/home_drawer.dart';
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
  final UserRepo _userRepo = UserRepo(FirebaseFirestore.instance);

  void _openSearch(BuildContext context) {
    HomeSearchSheet.open(context, repo: _productsRepo, categoryId: null);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<UserProfile?>(
      stream: (uid == null) ? Stream.value(null) : _userRepo.watchUser(uid),
      builder: (context, snap) {
        final user = snap.data;
        final firstName = (user?.firstName.trim().isNotEmpty ?? false)
            ? user!.firstName.trim()
            : t.guest;

        return Scaffold(
          extendBody: true,
          drawer: uid == null
              ? null
              : HomeDrawer(
                  uid: uid,
                  userRepo: _userRepo,
                  onToggleLanguageConfirmed: () async {
                    await MyApp.of(context).toggleLocale();
                  },
                  onLogoutConfirmed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  onEditLocation: (profile) {
                    final userRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile.uid);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LocationFormPage(
                          userDocRef: userRef,
                          initialUserData: {'location': profile.location},
                          isFirstTime: false,
                        ),
                      ),
                    );
                  },
                ),
          body: IndexedStack(
            index: _index,
            children: [
              _HomeTab(
                firstName: firstName,
                productsRepo: _productsRepo,
                cart: _cart,
                onSearchPressed: () => _openSearch(context),
              ),
              const OrdersTab(),
              CartScreen(onGoOrders: () => setState(() => _index = 1)),
            ],
          ),
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
                icon: const OrdersNavIcon(icon: Icons.receipt_long_outlined),
                selectedIcon: const OrdersNavIcon(icon: Icons.receipt_long),
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
      },
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.firstName,
    required this.productsRepo,
    required this.cart,
    required this.onSearchPressed,
  });

  final String firstName;
  final MobileProductsRepo productsRepo;
  final CartController cart;
  final VoidCallback onSearchPressed;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final bottomInset = MediaQuery.of(context).padding.bottom;
    final navH = NavigationBarTheme.of(context).height ?? 80.0;

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

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              HomeSliverAppBar(onSearchPressed: onSearchPressed),
              HomeHeaderSliver(
                firstName: firstName,
                productsRepo: productsRepo,
                cart: cart,
              ),
              HomeCategoriesGridSliver(categories: categories),
              SliverToBoxAdapter(
                child: SizedBox(height: 12 + navH + bottomInset),
              ),
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
    );
  }
}

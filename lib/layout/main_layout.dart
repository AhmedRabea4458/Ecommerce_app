import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/constants/app_colors.dart';
import 'package:project/screens/add_product.dart';
import 'package:project/screens/cart.dart';
import 'package:project/screens/home_page.dart';
import 'package:project/screens/my_products.dart';
import 'package:project/screens/profile_page.dart';
import 'package:project/screens/wishlist_screen.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/services/user_service.dart';
import '../cubits/profile/theme_cubit.dart';
import '../utils/debouncer.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_search_bar.dart';

enum UserRole { customer, seller, unknown }

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;
  UserRole userRole = UserRole.unknown;
  bool _isRoleLoaded = false;

  String searchQuery = '';
  late Debouncer _debouncer;

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  void onSearchChanged(String value) {
    _debouncer.run(() {
      setState(() {
        searchQuery = value.toLowerCase();
      });
    });
  }

  List<Widget> get pages {
    switch (userRole) {
      case UserRole.customer:
        return [
          HomePage(
            searchQuery: searchQuery,
            onSearchChanged: onSearchChanged,
          ),
          WishlistScreen(),
          Cart(),
          ProfilePage()
        ];
      case UserRole.seller:
        return [
          MyProducts(
            searchQuery: searchQuery,
            onSearchChanged: onSearchChanged,
          ),
          AddProduct(),
          ProfilePage()
        ];
      default:
        return [const SizedBox()];
    }
  }

  List<PreferredSizeWidget> get appBars {
    bool isDark = context.watch<ThemeCubit>().state;

    switch (userRole) {
      case UserRole.customer:
        return [
          CustomAppBar(
            title: "MobiTech",
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchBar(onChanged: onSearchChanged),
              ),
            ),
          ),
          CustomAppBar(
            title: "FavoritesItems",
            centerTitle: true,

            ),

          const CustomAppBar(title: "My Cart", centerTitle: true),
          CustomAppBar(
            title: "Profile",
            centerTitle: true,
            leading: IconButton(
              icon:
              Icon(Icons.logout, color: AppColors.primaryTextColor(isDark)),
              onPressed: _logout,
            ),
          ),
        ];
      case UserRole.seller:
        return [
          CustomAppBar(
            title: "My Products",
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchBar(onChanged: onSearchChanged),
              ),
            ),
          ),
          const CustomAppBar(title: "Add Product", centerTitle: true),
          CustomAppBar(
            title: "Profile",
            centerTitle: true,
            leading: IconButton(
              icon:
              Icon(Icons.logout, color: AppColors.primaryTextColor(isDark)),
              onPressed: _logout,
            ),
          ),
        ];
      default:
        return [const CustomAppBar(title: "Loading...", centerTitle: true)];
    }
  }

  List<BottomNavigationBarItem> get navItems {
    switch (userRole) {
      case UserRole.customer:
        return const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'MyFav',
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ];
      case UserRole.seller:
        return const [
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory), label: 'My Products'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ];
      default:
        return const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Loading'),
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: 500);
    _loadUserRole();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  Future<void> _loadUserRole() async {
    final roleString = await _userService.getUserRole();
    print("================ ROLE ================");
    print(roleString);
    print("======================================");

    final loadedRole = switch (roleString) {
      'customer' => UserRole.customer,
      'seller' => UserRole.seller,
      _ => UserRole.unknown,
    };

    if (mounted) {
      setState(() {
        userRole = loadedRole;
        _isRoleLoaded = true;
      });
    }
  }

  Future<void> _logout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/welcome', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state;

    if (!_isRoleLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final safeIndex = selectedIndex.clamp(0, pages.length - 1);

    return Scaffold(
      appBar: appBars[safeIndex],
      body: IndexedStack(
        index: safeIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: safeIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primaryColor(isDark),
        selectedItemColor: AppColors.primaryTextColor(isDark),
        unselectedItemColor: AppColors.secondaryTextColor(isDark),
        selectedFontSize: 14,
        unselectedFontSize: 13,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primaryTextColor(isDark),
        ),
        items: navItems,
      ),
    );

  }
}

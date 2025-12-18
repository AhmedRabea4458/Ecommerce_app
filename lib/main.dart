import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/constants/app_colors.dart';
import 'package:project/cubits/product/products_cubit.dart';
import 'package:project/cubits/user/user_cubit.dart';
import 'package:project/routs/app_routs.dart';
import 'package:project/screens/splash_page.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/services/product_service.dart';
import 'package:project/services/user_service.dart';
import 'cubits/Wishlist/favorites_cubit.dart';
import 'cubits/auth/auth_cubit.dart';
import 'cubits/profile/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(AuthService()),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider(
          create: (_) => UserCubit(
            UserService(),
            AuthService(),
          ),
        ),
        BlocProvider(
          create: (_) => ProductsCubit(
            ProductService(),
          ),
        ),
        BlocProvider(
          create: (_) => FavoritesCubit(UserService())..loadWishlist(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.login,
            onGenerateRoute: Routes.generateRoute,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.lightBackground,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              iconTheme: const IconThemeData(color: Colors.black),

            ),
            darkTheme: ThemeData(
              scaffoldBackgroundColor: AppColors.darkBackground,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),

            home: SplashPage(),

          );
        },
      ),
    );
  }
}






//aarr882000@gmail.com

//aarr882004@gmail.com
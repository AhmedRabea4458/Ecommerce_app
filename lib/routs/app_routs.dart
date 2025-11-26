import 'package:flutter/material.dart';
import 'package:project/model/product.dart';
import 'package:project/screens/become_vendor.dart';
import 'package:project/screens/check_out.dart';
import 'package:project/screens/edit_product.dart';
import 'package:project/screens/edit_profile.dart';
import 'package:project/screens/login_page.dart';
import 'package:project/screens/product_details.dart';
import 'package:project/screens/signup_page.dart';
import 'package:project/screens/welcome_page.dart';

class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String welcome = '/welcome';
  static const String details = '/details';
  static const String editProduct = '/edit_product';
  static const String checkOut = '/check_out';
  static const String vendor = '/become_vendor';
  static const String editProfile = '/edit_profile';




  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) =>  LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) =>  SignUpPage());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfile());

      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case checkOut:
        return MaterialPageRoute(builder: (_) => const CheckoutPage());
      case vendor:
        return MaterialPageRoute(builder: (_) => const BecomeVendor());
      case details:
        final args = settings.arguments as Map<String, dynamic>;
        final Product product = args['product'] as Product;

        return MaterialPageRoute(
          builder: (_) => ProductDetails(product: product),
        );
      case editProduct:
        final args = settings.arguments as Map<String, dynamic>;
        final Product product = args['product'] as Product;

        return MaterialPageRoute(
          builder: (_) => EditProduct(product: product),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('مسار غير معروف: ${settings.name}')),
          ),
        );
    }
  }
}

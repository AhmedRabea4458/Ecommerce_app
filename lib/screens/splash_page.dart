import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/cubits/user/user_cubit.dart';
import 'package:project/cubits/user/user_state.dart';
import '../cubits/product/products_cubit.dart';
import '../layout/main_layout.dart';
import '../services/product_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUser();
  }

  void _navigateOnce(VoidCallback action) {
    if (_navigated) return;
    _navigated = true;
    action();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          _navigateOnce(() {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => ProductsCubit(ProductService()),
                  child: const MainLayout(),
                ),
              ),
                  (route) => false,
            );
          });
        } else if (state is UserNotLoggedIn) {
          _navigateOnce(() {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/welcome',
                  (route) => false,
            );
          });
        }
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

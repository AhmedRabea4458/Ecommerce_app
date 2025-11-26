import 'package:flutter/material.dart';
import 'package:project/constants/app_colors.dart';
import 'package:project/screens/login_page.dart';
import 'package:project/screens/signup_page.dart';
import 'package:project/widgets/custom_button.dart';
import '../widgets/gap.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/vertical-banners-sales-promo.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              // Dark overlay
              Positioned.fill(
                child: Container(
                  color: const Color.fromARGB(130, 0, 0, 0),
                ),
              ),

              // Bottom content
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "MobiTech Store",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                       Gap(h: 8),
                      Text(
                        "Your one-stop shop for mobile accessories",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                       Gap(h: 35),

                      // Sign In / Sign Up buttons
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(title: "Log In", onPressed: (){
                            Navigator.popAndPushNamed(context, '/login');
                          },
                              icon: Icons.login),
                           Gap(h: 16),
                          CustomButton(title: "Sign Up", onPressed: (){
                            Navigator.popAndPushNamed(context, '/signup');
                          }
                            ,color: Colors.grey,icon: Icons.person_add,),
                        ],
                      ),
                       Gap(h: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

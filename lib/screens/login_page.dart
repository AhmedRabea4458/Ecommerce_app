import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/utils/translate_error.dart';
import 'package:project/widgets/custom_appbar.dart';
import 'package:project/widgets/custom_message.dart';
import 'package:project/widgets/gap.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom _textfield.dart';
import '../cubits/profile/theme_cubit.dart';

import '../constants/app_colors.dart';
import '../cubits/auth/auth_cubit.dart';
import '../cubits/auth/auth_state.dart';
import '../layout/main_layout.dart';
import '../widgets/auth_link_text.dart';
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogInSuccess) {
          ShowAwesomeDialog.success(
            context,
            "تم تسجيل الدخول بنجاح",
            onOk: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainLayout()),
                    (_) => false,
              );
            },
          );
        } else if (state is LogInFailure) {
          if (state.error == 'يجب تفعيل البريد الإلكتروني أولاً') {
            ShowAwesomeDialog.warning(
              context,
              state.error,
              onOk: () async {
                await FirebaseAuth.instance.currentUser
                    ?.sendEmailVerification();
              },
            );
          } else {
            ShowAwesomeDialog.error(context, state.error);
          }
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.primary,
          body: Column(
            children: [
              const SizedBox(height: 90),

              // Header
              const Icon(Icons.lock_outline,
                  size: 80, color: Colors.white),
              const SizedBox(height: 10),
              const Text(
                "Welcome Back",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Log in to continue",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 40),

              // Bottom Sheet
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                    isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),

                          CustomTextField(
                            controller: emailController,
                            hint: "Email",
                            prefixIcon: Icons.email,
                          ),

                          Gap(h: 16),

                          CustomTextField(
                            controller: passwordController,
                            hint: "Password",
                            prefixIcon: Icons.lock,
                            obscureText: true,
                          ),

                          Gap(h: 30),

                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return CustomButton(
                                title: "Log In",
                                isLoading: state is LogInLoading,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().LogIn(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );
                                  }
                                },
                              );
                            },
                          ),

                          Gap(h: 20),

                          AuthLinkText(
                            text: "Don't have an account?",
                            link: "Sign Up",
                            onTap: () => Navigator.popAndPushNamed(
                                context, '/signup'),
                          ),
                        ],
                      ),
                    ),
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

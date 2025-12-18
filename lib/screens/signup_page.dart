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
import '../widgets/auth_link_text.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          ShowAwesomeDialog.info(
            context,
            "تم إرسال رابط التفعيل إلى بريدك الإلكتروني",
            onOk: () {
              Navigator.popAndPushNamed(context, '/login');
            },
          );
        } else if (state is SignUpFailure) {
          ShowAwesomeDialog.error(
            context,
            translateFirebaseError(state.error),
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.primary,
          body: Column(
            children: [
              const SizedBox(height: 80),

              // Header
              const Icon(Icons.shopping_bag,
                  size: 80, color: Colors.white),
              const SizedBox(height: 10),
              const Text(
                "Create Account",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Sign up to continue",
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
                            controller: fullNameController,
                            hint: "Full Name",
                            prefixIcon: Icons.person,
                          ),

                          Gap(h: 16),

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

                          Gap(h: 16),

                          CustomTextField(
                            controller: confirmPasswordController,
                            hint: "Confirm Password",
                            prefixIcon: Icons.lock,
                            obscureText: true,
                          ),

                          Gap(h: 30),

                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return CustomButton(
                                title: "Sign Up",
                                isLoading: state is SignUpLoading,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().signUp(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                      fullNameController.text.trim(),
                                    );
                                  }
                                },
                              );
                            },
                          ),

                          Gap(h: 20),

                          AuthLinkText(
                            text: "Already have an account?",
                            link: "Log In",
                            onTap: () => Navigator.popAndPushNamed(
                                context, '/login'),
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

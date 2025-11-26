import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/utils/translate_error.dart';
import 'package:project/widgets/custom_appbar.dart';
import 'package:project/widgets/custom_message.dart';
import 'package:project/widgets/gap.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom _textfield.dart';

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

      return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            ShowAwesomeDialog.info(context, "تم إرسال رابط التفعيل إلى بريدك الإلكتروني", onOk: () {
              Navigator.popAndPushNamed(context, '/login');
            });
          } else if (state is SignUpFailure) {
            ShowAwesomeDialog.error(context, translateFirebaseError(state.error));
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(title: "Sign Up",centerTitle: true,),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                reverse: true,

                child: Column(
                  children: [
                    CustomTextField(
                      controller: fullNameController,
                      hint: "Full Name",
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال الاسم بالكامل';
                        }
                        if (value.trim().length < 3) {
                          return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    Gap(h: 16),
                    CustomTextField(
                      controller: emailController,
                      hint: "Email",
                      prefixIcon: Icons.email,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'البريد الإلكتروني غير صالح';
                        }
                        return null;
                      },
                    ),
                    Gap(h: 16),
                    CustomTextField(
                      controller: passwordController,
                      hint: "Password",
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال كلمة السر';
                        }
                        if (value.length < 6) {
                          return 'كلمة السر يجب أن تكون 6 أحرف على الأقل';
                        }

                        return null;
                      },
                    ),
                    Gap(h: 16),
                    CustomTextField(
                      controller: confirmPasswordController,
                      hint: "Confirm Password",
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى تأكيد كلمة السر';
                        }
                        if (value != passwordController.text) {
                          return 'كلمة السر غير متطابقة';
                        }
                        return null;
                      },
                    ),

                    Gap(h: 20),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          title: "Sign Up",
                          isLoading: state is SignUpLoading,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
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
                    AuthLinkText(
                      text: "Do you have an account?",
                      link: "Log In",
                      onTap: () =>  Navigator.popAndPushNamed(context, '/login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

    );
  }
}

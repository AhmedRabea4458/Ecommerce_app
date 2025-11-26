import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/cubits/auth/auth_state.dart';
import '../cubits/auth/auth_cubit.dart';
import '../layout/main_layout.dart';
import '../widgets/auth_link_text.dart';
import '../widgets/custom _textfield.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_message.dart';
import '../widgets/gap.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
      if (state is LogInSuccess) {
        ShowAwesomeDialog.success(context, "تم تسجيل الدخول بنجاح.", onOk: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainLayout()),
                (route) => false,
          );
        });
      } else if (state is LogInFailure) {
        print(state.error);

        if (state.error == 'يجب تفعيل البريد الإلكتروني أولاً') {
          ShowAwesomeDialog.warning(
            context,
            state.error,
            onOk: () async {
              await FirebaseAuth.instance.currentUser?.sendEmailVerification();
            },
          );
        } else {
          ShowAwesomeDialog.error(context, state.error);
        }
      }
    },
    child:Scaffold(
      appBar: CustomAppBar(
        title: "تسجيل الدخول",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                   Gap(h: 20),
                  CustomTextField(
                    controller: emailController,
                    hint: "email",
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
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
                   Gap(h: 20),
                  CustomTextField(
                    controller: passwordController,
                    hint: "password",
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
                   Gap(h: 25),
                   BlocBuilder<AuthCubit, AuthState>(
                   builder: (context, state) {
                     return CustomButton(title: 'Log In',
                         isLoading: state is LogInLoading,
                         onPressed: () {
                           if (_formKey.currentState!.validate()) {
                             context.read<AuthCubit>().LogIn(
                               emailController.text.trim(),
                               passwordController.text.trim(),
                             );
                           }
                         }
                     );

                   }
                   ),
                    Gap(h: 20),
                    AuthLinkText(
                    text: "Don't have an account?",
                    link: "Sign Up",
                    onTap: () =>  Navigator.popAndPushNamed(context, '/signup'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),

    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/cubits/user/user_cubit.dart';
import 'package:project/cubits/user/user_state.dart';
import '../../cubits/auth/auth_state.dart';
import 'custom _textfield.dart';
import 'custom_button.dart';
import 'gap.dart';

class EditProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const EditProfileForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: nameController,
            hint: "الاسم",
            prefixIcon: Icons.person,
            validator: (value) =>
            value == null || value.isEmpty ? 'يرجى إدخال الاسم' : null,
          ),
          Gap(h: 16),
          CustomTextField(
            controller: phoneController,
            hint: "Phone Number",
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال رقم الهاتف';
              }
              if (!RegExp(r'^[0-9]{10,11}$').hasMatch(value)) {
                return 'رقم الهاتف غير صحيح';
              }
              return null;
            },
          ),
          Gap(h: 16),
          CustomTextField(
            controller: addressController,
            hint: "Address",
            prefixIcon: Icons.home,
          ),
          Gap(h: 24),
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              return CustomButton(
                title: "Save Updates",
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (formKey.currentState!.validate()) {
                    final cubit = context.read<UserCubit>();
                    cubit.updateUserProfile(
                      name: nameController.text.trim(),
                      phone: phoneController.text.trim(),
                      address: addressController.text.trim(),
                    );
                  }
                },
                isLoading: state is AuthLoading,
              );
            },
          ),
        ],
      ),
    );
  }
}

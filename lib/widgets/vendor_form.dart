import 'package:flutter/material.dart';
import 'package:project/widgets/custom_button.dart';
import 'package:project/widgets/custom_message.dart';
import 'package:project/widgets/gap.dart';

import 'custom _textfield.dart';

class VendorForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController businessNameController;
  final TextEditingController phoneController;
  final VoidCallback onSubmit;
  final bool isLoading;

  const VendorForm({
    super.key,
    required this.formKey,
    required this.businessNameController,
    required this.phoneController,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Gap(h: 20),
          CustomTextField(
            controller: businessNameController,
            hint: "Business Name",
            prefixIcon: Icons.store,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال اسم النشاط التجاري';
              }
              return null;
            },
          ),
          Gap(h: 20),
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
          Gap(h: 25),
          CustomButton(
            title: 'Send Request',
            onPressed: onSubmit,
            isLoading: isLoading,
          ),
          Gap(h: 20),
        ],
      ),
    );
  }
}

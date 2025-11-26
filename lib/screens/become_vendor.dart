import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/services/user_service.dart';
import 'package:project/widgets/custom_appbar.dart';
import 'package:project/widgets/custom_button.dart';
import 'package:project/widgets/gap.dart';
import 'package:project/widgets/custom _textfield.dart';
import 'package:project/widgets/custom_message.dart';

class BecomeVendor extends StatefulWidget {
  const BecomeVendor({super.key});

  @override
  State<BecomeVendor> createState() => _BecomeVendorState();
}

class _BecomeVendorState extends State<BecomeVendor> {
  final _formKey = GlobalKey<FormState>();
  final businessNameController = TextEditingController();
  final phoneController = TextEditingController();
  final UserService _userervice=UserService();
  final AuthService _authService = AuthService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  void _loadCurrentUserData() async {
    final userModel = await _userervice.getUserData();
    if (userModel != null) {
      phoneController.text = userModel.phone ?? '';
    }
  }

  Future<void> _submitVendorRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final user = _authService.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'vendorRequest': true,
          'vendorStatus': 'pending',
          'businessName': businessNameController.text.trim(),
          'phone': phoneController.text.trim(),
        });

        ShowAwesomeDialog.success(
          context,
          "تم إرسال طلبك بنجاح. سيتم مراجعة طلبك قريبًا.",
          onOk: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      ShowAwesomeDialog.error(context, "حدث خطأ: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Become Vendor",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(h: 20),
                CustomTextField(
                  controller: businessNameController,
                  hint: "businessName",
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
                  hint: "PhoneNumber",
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
                  onPressed: _submitVendorRequest,
                  isLoading: _loading,
                ),
                Gap(h: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

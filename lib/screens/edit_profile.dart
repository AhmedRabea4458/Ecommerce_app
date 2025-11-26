import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/cubits/user/user_cubit.dart';
import 'package:project/cubits/user/user_state.dart';
import 'package:project/widgets/custom_appbar.dart';
import 'package:project/widgets/custom_message.dart';
import '../cubits/auth/auth_cubit.dart';
import '../cubits/auth/auth_state.dart';
import '../widgets/edit_profile_form.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = context.read<UserCubit>().user;
    if (user != null) {
      nameController.text = user.name ?? '';
      phoneController.text = user.phone ?? '';
      addressController.text = user.address ?? '';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "تعديل الملف الشخصي"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: BlocListener<UserCubit, UserState>(
            listener: (context, state) {
              if (state is UserLoaded) {
                ShowAwesomeDialog.success(
                  context,
                  "تم حفظ التعديلات بنجاح.",
                  onOk: () => Navigator.pop(context),
                );
              } else if (state is UserError) {
                ShowAwesomeDialog.error(context, state.message);
              }
            },
            child: EditProfileForm(
              formKey: _formKey,
              nameController: nameController,
              phoneController: phoneController,
              addressController: addressController,
            ),
          ),
        ),
      ),
    );
  }
}

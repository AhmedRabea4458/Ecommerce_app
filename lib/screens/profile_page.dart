import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:project/widgets/custom_message.dart';
import '../constants/app_colors.dart';
import '../cubits/profile/theme_cubit.dart';
import '../cubits/user/user_cubit.dart';
import '../cubits/user/user_state.dart';
import '../model/user.dart';
import '../services/image_service.dart';
import '../widgets/custom_header_text.dart';
import '../widgets/gap.dart';
import '../widgets/profile_item.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUser();
  }

  File? _selectedImage;
  final ImageService _imageService = ImageService();

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  void _onTap(UserModel user) async {
    await pickImage();
    if (_selectedImage != null) {
      await _uploadAndSaveImage(user);
    } else {
      ShowAwesomeDialog.error(context, "الرجاء اختيار صورة أولاً!");
    }
  }

  Future<void> _uploadAndSaveImage(UserModel user) async {
    try {
      final imageUrl = await _imageService.processAndUpload(_selectedImage!);
      if (imageUrl == null) {
        ShowAwesomeDialog.error(context, "فشل رفع الصورة!");
        return;
      }
      await context.read<UserCubit>().updateProfileImage(imageUrl);
      ShowAwesomeDialog.success(context, "تم تغيير الصورة بنجاح!");
    } catch (e) {
      ShowAwesomeDialog.error(context, "حدث خطأ أثناء رفع الصورة: $e");
    }
  }


  Widget _buildAvatar(UserModel user, bool isDarkMode) {
    ImageProvider? imageProvider;
    if (_selectedImage != null) {
      imageProvider = FileImage(_selectedImage!);
    } else if (user.image?.isNotEmpty == true) {
      imageProvider = NetworkImage(user.image!);
    }

    return InkWell(
      onTap: () => _onTap(user),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: AppColors.primaryColor(isDarkMode),
        backgroundImage: imageProvider,
        child: imageProvider == null
            ? const Icon(Icons.person, size: 50)
            : null,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    final bool isDarkMode = context
        .watch<ThemeCubit>()
        .state;

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color:
        AppColors.primaryTextColor(isDarkMode)),
      ),
    );
  }

  Widget _buildProfileContent(UserModel user, String role, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Gap(h: 20),
          _buildAvatar(user, isDarkMode),
          Gap(h: 10),
          CustomHeaderText(text: user.name ?? "User Name"),
          Text(
            user.email ?? "example@gmail.com",
            style: TextStyle(color: AppColors.secondaryTextColor(isDarkMode)),
          ),
          Gap(h: 30),
          _sectionTitle("Account"),
          ProfileItem(
            icon: Icons.edit,
            title: "Edit Profile",
            onTap: () => Navigator.pushNamed(context, '/edit_profile'),
          ),
          if (role == "customer")
            ProfileItem(
              icon: Icons.store,
              title: "Become a Vendor",
              onTap: () => Navigator.pushNamed(context, '/become_vendor'),
            ),
          Gap(h: 20),
          _sectionTitle("Settings"),
          ProfileItem(
            icon: Icons.help_outline,
            title: "Help & Support",
            onTap: () {},
          ),
          SwitchListTile(
            title: Text(
              "Dark Mode",
              style: TextStyle(color: AppColors.primaryTextColor(isDarkMode)),
            ),
            value: isDarkMode,
            onChanged: (val) => context.read<ThemeCubit>().toggleTheme(),
            activeColor: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = context
        .watch<ThemeCubit>()
        .state;

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserError) {
          return Center(child: Text(state.message));
        } else if (state is UserLoaded) {
          final user = state.user;
          final role = user.role ?? "customer";
          print("==========================");

          print("Loaded user UID: ${user.uid}");
          print("Loaded user UID: ${user.role}");
          print("==========================");


          return SingleChildScrollView(
            child: _buildProfileContent(user , role, isDarkMode),
          );
        } else {
          return const Center(child: Text("لا يوجد بيانات مستخدم."));
        }
      },
    );
  }
}

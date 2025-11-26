import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_colors.dart';
import '../cubits/profile/theme_cubit.dart';

class ProfileItem  extends StatelessWidget {
  IconData? icon;
      String ?title;
  void Function()? onTap;
   ProfileItem({super.key,this.title,this.icon,this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeCubit>().state;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(
        title!,
        style: TextStyle(color: AppColors.primaryTextColor(isDarkMode)),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    ) ;
  }
}



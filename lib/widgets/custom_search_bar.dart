import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_colors.dart';
import '../cubits/profile/theme_cubit.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeCubit>().state;

    return TextField(
      onChanged: onChanged,
      style: TextStyle(
        color: AppColors.primaryTextColor(isDarkMode),
      ),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Search Product",
        hintStyle: TextStyle(color: AppColors.secondaryTextColor(isDarkMode)),
        filled: true,
        fillColor: AppColors.primaryColor(isDarkMode),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:  BorderSide(color: AppColors.secondaryTextColor(isDarkMode), width: 2),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_colors.dart';
import '../cubits/profile/theme_cubit.dart';

class AuthLinkText extends StatelessWidget {
  const AuthLinkText({super.key, this.onTap, required this.text,required this.link});

  final void Function()? onTap;
  final String text;
  final String link;


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeCubit>().state;

    return Column(
        children: [
          Text(
              text,
            style:  TextStyle(
              color: AppColors.primaryTextColor(isDarkMode),
              fontSize: 16,
          ),),
          GestureDetector(
          onTap: onTap,
          child: Text(
            link,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
              ),
        ],
      );
  }
}

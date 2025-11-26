import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/constants/app_colors.dart';

import '../cubits/profile/theme_cubit.dart';

class CustomHeaderText extends StatelessWidget {
   CustomHeaderText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeCubit>().state;

    return Text(text,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold
        ,color: AppColors.primaryTextColor(isDarkMode)),);
  }
}

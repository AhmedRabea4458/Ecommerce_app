import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_colors.dart';
import '../cubits/profile/theme_cubit.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.hint,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    required this.prefixIcon,
    this.controller,
    this.labelText,
    this.validator,
    this.minLines,
    this.maxLines
  });

  final IconData prefixIcon;
  final bool obscureText;
  final String? hint;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? labelText;
  final String? Function(String?)? validator;
  final int? minLines;
  final int? maxLines;


  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeCubit>().state;

    return TextFormField(
      style: TextStyle(color: AppColors.secondaryTextColor(isDarkMode)),
      controller: widget.controller,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      validator: widget.validator,
      minLines: widget.minLines,
      maxLines: widget.maxLines ?? (widget.obscureText ? 1 : null),
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: widget.obscureText
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        )
            : null,
        filled: true,
        fillColor: AppColors.primaryColor(isDarkMode),
        hintText: widget.hint,
        hintStyle: TextStyle(color: AppColors.secondaryTextColor(isDarkMode)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide( width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

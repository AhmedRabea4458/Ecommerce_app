import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/constants/app_colors.dart';

import '../cubits/profile/theme_cubit.dart';

class CategorySelector extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<String>? onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    this.onCategorySelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String selectedCategory = 'All';

  @override
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context
        .watch<ThemeCubit>()
        .state;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: widget.categories.map((category) {
          final isSelected = category == selectedCategory;

          final backgroundColor = isSelected
              ? (isDarkMode ? Colors.white : AppColors.primary)
              : (isDarkMode ? AppColors.darkBackground : AppColors
              .lightBackground); // Unselected

          final textColor = isSelected
              ? (isDarkMode ? Colors.black : Colors.white)
              : AppColors.secondaryTextColor(isDarkMode);

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });

              if (widget.onCategorySelected != null) {
                widget.onCategorySelected!(selectedCategory);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.secondary
                      : AppColors.secondaryTextColor(isDarkMode).withOpacity(
                      0.4),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
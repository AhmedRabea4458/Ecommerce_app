import 'package:flutter/material.dart';
import 'package:project/widgets/custom_header_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final double elevation;
  final TextStyle? titleStyle;

  const CustomAppBar({
    super.key,
     this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.centerTitle = true,
    this.elevation = 0,
    this.titleStyle,
  });

  @override
  Size get preferredSize => Size.fromHeight(bottom == null ? kToolbarHeight : kToolbarHeight + bottom!.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      centerTitle: centerTitle,
      title: CustomHeaderText(
         text: title!,
      ),
   leading: leading,
      actions: actions,
      bottom: bottom,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ShowAwesomeDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String description,
    DialogType dialogType = DialogType.info,
    String btnOkText = "حسناً",
    String? btnCancelText,
    VoidCallback? btnOkOnPress,
    VoidCallback? btnCancelOnPress,
    bool dismissOnTouchOutside = true,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.scale,
      title: title,
      desc: description,
      btnOkText: btnOkText,
      btnCancelText: btnCancelText,
      btnOkOnPress: btnOkOnPress ?? () {},
      btnCancelOnPress: btnCancelOnPress,
      dismissOnTouchOutside: dismissOnTouchOutside,
    ).show();
  }
  static void success(BuildContext context, String description,
      {String title = "نجاح", VoidCallback? onOk}) {
    show(
      context: context,
      title: title,
      description: description,
      dialogType: DialogType.success,
      btnOkOnPress: onOk,
    );
  }

  static void error(BuildContext context, String description,
      {String title = "خطأ", VoidCallback? onOk}) {
    show(
      context: context,
      title: title,
      description: description,
      dialogType: DialogType.error,
      btnOkOnPress: onOk,
    );
  }


  static void warning(BuildContext context, String description,
      {String title = "تحذير", VoidCallback? onOk}) {
    show(
      context: context,
      title: title,
      description: description,
      dialogType: DialogType.warning,
      btnOkOnPress: onOk,
    );
  }

  static void info(BuildContext context, String description,
      {String title = "معلومة", VoidCallback? onOk}) {
    show(
      context: context,
      title: title,
      description: description,
      dialogType: DialogType.info,
      btnOkOnPress: onOk,
    );
  }
}

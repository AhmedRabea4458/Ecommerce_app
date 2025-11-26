import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
class CustomMessageYesOrNo{
  final String title;
  final String description;
  final void Function()? btnOkOnPress;
  final DialogType dialogType;
  final void Function()? btnCancelOnPress;

  const CustomMessageYesOrNo({
    this.btnCancelOnPress,
    this.btnOkOnPress,
    required this.dialogType,
    required this.title,
    required this.description,
  });

  void show(BuildContext context){
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.scale,
      title: title,
      desc: description,
      btnOkText:"yes" ,
      btnCancelText: "No",
      btnCancelOnPress: btnCancelOnPress,
      btnOkOnPress: btnOkOnPress,
    ).show();
  }
}

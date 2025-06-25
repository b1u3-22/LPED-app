import 'package:app/global/dialog_action_base.dart';
import 'package:app/global/dialog_base.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class ConfirmationDialogBase extends StatelessWidget {
  final String title;
  final String content;
  final Function()? onConfirm;
  final Function()? onCancel;

  const ConfirmationDialogBase({
    super.key,
    required this.title,
    required this.content,
    this.onConfirm,
    this.onCancel
  });

  @override
  Widget build(BuildContext context) {
    return DialogBase(
      title: title,
      content: Text(content, style: textStyle,),
      actions: [
        DialogActionBase(
          label: "Cancel",
          callback: onCancel
        ),
        DialogActionBase(
          label: "Confirm",
          callback: onConfirm,
        ),
      ],
    );
  }
}
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class DialogActionBase extends StatelessWidget {
  final Function()? callback;
  final String label;
  final Icon? icon;

  const DialogActionBase({super.key, this.callback, required this.label, this.icon});
  
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (callback == null) {
          Navigator.of(context).pop();
        }
        else {
          callback!();
        }
      }, 
      child: FittedBox(
        child: Row(
          children: [
            Text(label, style: buttonStyle),
            if (icon != null) SizedBox(width: 5,),
            if (icon != null) icon!
          ],
        ),
      )
    );
  }
}
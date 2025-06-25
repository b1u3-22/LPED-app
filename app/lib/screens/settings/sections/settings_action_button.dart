//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 01:44:23
//  Modified time: 	13-05-2025 22:44:45
//  Description: 		This file contains single settings action button
//

import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class SettingsActionButton extends StatelessWidget {
  final String text;
  final String? subText;
  final Icon? icon;
  final Function? action;

  const SettingsActionButton({super.key, required this.text, this.subText, this.icon, this.action});
  
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: ElevatedButton(
        onPressed: () {
          if (action != null) action!();
        },
        child: Row(
          children: [
            Text(text, style: textStyle,),
            if (subText != null) SizedBox(width: 5),
            if (subText != null) Text(subText!, style: badgeStyle),
            if (icon != null) SizedBox(width: 5),
            if (icon != null) Icon(icon!.icon)
          ],
        )
      )
    );
  }
}
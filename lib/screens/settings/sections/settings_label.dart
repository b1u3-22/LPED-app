//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 02:03:09
//  Modified time: 	13-05-2025 22:42:47
//  Description: 		This file contains settings label widget that is used to provide labels to other widget, such as lists, switches, ...
//

import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class SettingsLabel extends StatelessWidget {
  final String text;

  const SettingsLabel({super.key, required this.text});
  
  @override
  Widget build(BuildContext context) {
    return Text(text, style: labelStyle);
  }
}
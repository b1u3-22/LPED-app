//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 01:55:59
//  Modified time: 	13-05-2025 22:34:54
//  Description: 		This file contains Settings Title component that is used throughout the settings page as a title
//

import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class SettingsTitle extends StatelessWidget {
  final String text;
  
  const SettingsTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25),
        Text(text, style: heading2Style, textAlign: TextAlign.center),
      ],
    );
  }
}
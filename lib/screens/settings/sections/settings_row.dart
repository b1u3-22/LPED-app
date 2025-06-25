//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 01:53:08
//  Modified time: 	13-05-2025 22:39:27
//  Description: 		This file contains Settings Row component that is used as a single row with two items in settings page
//

import 'package:flutter/material.dart';

class SettingsRow extends StatelessWidget {
  final Widget left;
  final Widget right;

  const SettingsRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            left,
            right
          ],
        ),
        SizedBox(height: 5)
      ],
    );
  }
}
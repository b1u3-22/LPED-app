//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 14:39:54
//  Modified time: 	13-05-2025 22:54:14
//  Description: 		This file contains the single option for led mode drop down, which displays the name of the mode
//

import 'package:app/models/led_mode/led_mode_list.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class LedModeDropDownRow extends StatelessWidget {
  final LedModeListModel model;

  const LedModeDropDownRow({super.key, required this.model});
  
  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem(
      value: model.value,
      child: Row(
        children: [
          Text(model.name, style: textStyle),
        ],
      )
    );
  }
}
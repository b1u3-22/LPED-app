//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 14:06:18
//  Modified time: 	13-05-2025 22:48:02
//  Description: 		This file contains single sensitivity option for the sensitivity drop down, which displays the name and value
//

import 'package:app/models/sensitivity/sensitivity_list.dart';
import 'package:app/services/bluetooth/bluetooth.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class SensitivityDropDownRow extends StatelessWidget {
  final SensitivityListModel model;

  const SensitivityDropDownRow({super.key, required this.model});
  
  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem(
      value: model.value,
      child: Row(
        children: [
          Text(model.name, style: textStyle),
          SizedBox(width: 5),
          Text("±${(model.value / LPEDBluetooth.accelerometerDivisor).toStringAsFixed(2)}g", style: badgeStyle)
        ],
      )
    );
  }
}
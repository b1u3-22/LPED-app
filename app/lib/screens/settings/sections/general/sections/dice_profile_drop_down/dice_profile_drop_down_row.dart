//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 03:38:33
//  Modified time: 	13-05-2025 23:31:41
//  Description: 		This file contains single option in the dice drop down selector, and it displays the profile name and number of sides
//

import 'package:app/models/dice_definition/dice_definition_list.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class DiceProfileDropDownRow extends StatelessWidget {
  final DiceDefinitionListModel model;
  
  const DiceProfileDropDownRow({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem(
      value: model.id,
      child: Row(
        children: [
          Text(model.name, style: textStyle),
          SizedBox(width: 5),
          Text("Sides: ${model.numberOfSides}", style: badgeStyle)
        ],
      )
    );
  }
}
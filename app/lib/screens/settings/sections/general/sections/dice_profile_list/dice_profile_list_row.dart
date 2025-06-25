//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		13-05-2025 16:09:21
//  Modified time: 	13-05-2025 22:57:08
//  Description: 		This file contains the profile list row, which displays the profiles name, number of sides and buttons for delete and edit
//

import 'package:app/models/dice_definition/dice_definition_base.dart';
import 'package:app/models/dice_definition/dice_definition_list.dart';
import 'package:app/global/settings_field.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class DiceProfileListRow extends StatelessWidget {
  final DiceDefinitionListModel model;
  final bool currentlyUsed;
  final Function(int id) onDelete;
  final Function(int id) onEdit;
  final Function(DiceDefinitionListModel model, String newName) onNameChange;

  const DiceProfileListRow({
    super.key, 
    required this.model, 
    required this.currentlyUsed,
    required this.onDelete,
    required this.onEdit,
    required this.onNameChange
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 110,
                  child: SettingsField(
                    prefilled: model.name,
                    onSubmitted: (String newName) => onNameChange(model, newName),
                  ),
                ),
                SizedBox(width: 25),
                Text(
                  "Sides: ${model.numberOfSides}/${DiceDefinitionBaseModel.sidesMaxLen}",
                  style: badgeStyle,
                )
              ],
            ),
            Row(
              children: [
                if (!currentlyUsed)
                  IconButton(
                    onPressed: () => onDelete(model.id), 
                    icon: Icon(Icons.delete)
                  ),
                IconButton(
                  onPressed: () => onEdit(model.id), 
                  icon: Icon(Icons.build, color: currentlyUsed ? Theme.of(context).colorScheme.tertiary: null)
                ) 
              ],
            )
          ],
        ),
        Divider()
      ],
    );
  }
  
}
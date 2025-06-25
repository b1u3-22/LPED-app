//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 02:39:23
//  Modified time: 	13-05-2025 22:56:48
//  Description: 		This file contians the profile list, which displays the profile list rows
//

import 'package:app/models/dice_definition/dice_definition_list.dart';
import 'package:app/screens/settings/sections/general/sections/dice_profile_list/dice_profile_list_row.dart';
import 'package:app/screens/settings/sections/settings_list.dart';
import 'package:flutter/material.dart';

class DiceProfileList extends StatelessWidget {
  final List<DiceDefinitionListModel> profiles;
  final int currentProfileID;
  final Function(int id) onProfileDelete;
  final Function(int id) onProfileEdit;
  final Function(DiceDefinitionListModel model, String name) onProfileNameChange;

  const DiceProfileList({
    super.key, 
    required this.profiles, 
    required this.currentProfileID,
    required this.onProfileDelete,
    required this.onProfileEdit,
    required this.onProfileNameChange
  });

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      children: [
        for (DiceDefinitionListModel model in profiles)
          DiceProfileListRow(
            model: model, 
            currentlyUsed: model.id == currentProfileID,
            onDelete: onProfileDelete,
            onEdit: onProfileEdit,
            onNameChange: onProfileNameChange,
          )
      ]
    );
  }

}
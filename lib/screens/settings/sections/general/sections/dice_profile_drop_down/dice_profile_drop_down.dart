//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 02:05:22
//  Modified time: 	13-05-2025 23:31:18
//  Description: 		This file contains dice profile drop down selector, that is used to select specific dice profile
//

import 'package:app/models/dice_definition/dice_definition_list.dart';
import 'package:app/screens/settings/sections/general/sections/dice_profile_drop_down/dice_profile_drop_down_row.dart';
import 'package:flutter/material.dart';

class DiceProfileDropDown extends StatelessWidget {
  final List<DiceDefinitionListModel> supportedDiceProfiles;
  final int currentProfileID;
  final Function(int newID) newProfileSelected; 

  const DiceProfileDropDown({super.key, required this.supportedDiceProfiles, required this.currentProfileID, required this.newProfileSelected});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: DropdownButton(
        value: currentProfileID,
        items: [
          for (DiceDefinitionListModel model in supportedDiceProfiles)
            DropdownMenuItem(
              value: model.id,
              child: DiceProfileDropDownRow(model: model),
            )
        ], 
        onChanged: (newID) {
          if (newID == null) {
            return;
          }

          else {
            newProfileSelected(newID);
          }
        }
      ),
    );
  }
}
//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		13-05-2025 16:09:21
//  Modified time: 	13-05-2025 22:45:53
//  Description:    This file contains the profile subpage, that displays settings for the currently selected profile 		
//

import 'package:app/models/dice_definition/dice_definition_base.dart';
import 'package:app/models/dice_definition/dice_definition_detail.dart';
import 'package:app/screens/settings/sections/profile/sensitivity_drop_down/sensitivity_drop_down.dart';
import 'package:app/screens/settings/sections/profile/side_list/side_list.dart';
import 'package:app/screens/settings/sections/settings_action_button.dart';
import 'package:app/screens/settings/sections/settings_action_list.dart';
import 'package:app/global/settings_field.dart';
import 'package:app/screens/settings/sections/settings_label.dart';
import 'package:app/screens/settings/sections/settings_page.dart';
import 'package:app/screens/settings/sections/settings_row.dart';
import 'package:app/screens/settings/sections/settings_title.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final DiceDefinitionDetailModel profile;
  final Function(DiceDefinitionDetailModel model, String newName) changeProfileName;
  final Function(DiceDefinitionDetailModel model, int newSensitivity) changeSensitivity;
  final Function(DiceDefinitionDetailModel model) addSide;
  final Function(DiceDefinitionDetailModel model, int sideIndex) deleteSide;
  final Function(DiceDefinitionDetailModel model, int sideIndex, int newMode) changeSideLedMode;
  final Function(DiceDefinitionDetailModel model, int sideIndex, int newNumber) changeSideNumber;
  final Function(DiceDefinitionDetailModel model, int sideIndex) changeSideVector;


  const ProfileSection({
    super.key,
    required this.profile,
    required this.changeProfileName,
    required this.changeSensitivity,
    required this.addSide,
    required this.deleteSide,
    required this.changeSideLedMode,
    required this.changeSideNumber,
    required this.changeSideVector
  });

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      children: [
        SettingsField(
          prefilled: profile.name,
          style: heading1Style,
          align: TextAlign.center,
          maxLength: DiceDefinitionBaseModel.nameMaxLen - 1,
          onSubmitted: (newName) => changeProfileName(profile, newName),
        ),
        SizedBox(height: 50),
        SettingsRow(
          left: SettingsLabel(text: "Sensitivity"), 
          right: SensitivityDropDown(
            currentSensitivity: profile.range,
            newSensitivitySelected: (newSensitivity) => changeSensitivity(profile, newSensitivity)
          )
        ),
        SettingsTitle(text: "Actions"),
        SettingsActionList(
          children: [
            SettingsActionButton(
              text: "New side",
              subText: "${profile.sides.length}/${DiceDefinitionBaseModel.sidesMaxLen}",
              action: () => addSide(profile),
            )
          ],
        ),
        SettingsTitle(text: "Sides"),
        SideList(
          sides: profile.sides, 
          deleteSide: (sideIndex) => deleteSide(profile, sideIndex), 
          changeSideLedMode: (sideIndex, newMode) => changeSideLedMode(profile, sideIndex, newMode), 
          changeSideNumber: (sideIndex, newNumber) => changeSideNumber(profile, sideIndex, newNumber), 
          changeSideVector: (sideIndex) => changeSideVector(profile, sideIndex)
        )
      ],
    );
  }
}
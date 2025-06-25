//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		13-05-2025 16:09:21
//  Modified time: 	13-05-2025 23:57:17
//  Description: 		This file contains the first step for add profile dialog, and it allows for setting the name and dice type (number of sides and multiplier)
//

import 'package:app/global/stepped_dialog/stepped_dialog_step_base.dart';
import 'package:app/models/dice_definition/dice_definition_base.dart';
import 'package:app/models/dice_definition/dice_definition_detail.dart';
import 'package:app/screens/settings/flows/add_dice_definition/sections/name_step/dice_type_list.dart/dice_type_descriptor.dart';
import 'package:app/screens/settings/flows/add_dice_definition/sections/name_step/dice_type_list.dart/dice_type_list.dart';
import 'package:app/global/settings_field.dart';
import 'package:app/screens/settings/sections/settings_label.dart';
import 'package:app/screens/settings/sections/settings_row.dart';
import 'package:flutter/widgets.dart';

class NameStep extends SteppedDialogStepBase {
  final DiceDefinitionDetailModel profile;
  final Function(String newName) changeName;
  final Function(int newSensitivity) changeSensitivity;
  final Function(int newNumberOfSides, int multiplier) changeNumberOfSides;

  const NameStep({
    super.key,
    required this.profile,
    required this.changeName,
    required this.changeSensitivity,
    required this.changeNumberOfSides,
  });

  @override
  bool nextStep(int currentStep) {
    return true;
  }

  @override
  bool previousStep(int currentStep) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Give your new profile a name and choose a dice type."
        ),
        SettingsRow(
          left: SettingsLabel(text: "Name"), 
          right: SizedBox(
            width: 110,
            child: SettingsField(
              prefilled: profile.name,
              onSubmitted: changeName,
              maxLength: DiceDefinitionBaseModel.nameMaxLen - 1,
            )
          )
        ),
        DiceTypeList(
          changeNumberOfSides: changeNumberOfSides,
          types: [
            DiceTypeDescriptor(
              label: "D4", 
              numberOfSides: 4
            ),
            DiceTypeDescriptor(
              label: "D6", 
              numberOfSides: 6
            ),
            DiceTypeDescriptor(
              label: "D8", 
              numberOfSides: 8
            ),
            DiceTypeDescriptor(
              label: "D10", 
              numberOfSides: 10
            ),
            DiceTypeDescriptor(
              label: "D12", 
              numberOfSides: 12
            ),
            DiceTypeDescriptor(
              label: "D20", 
              numberOfSides: 20
            ),
            DiceTypeDescriptor(
              label: "D100", 
              numberOfSides: 10,
              multiplier: 10
            ),
            DiceTypeDescriptor(
              label: "Custom", 
              numberOfSides: 6,
              editable: true
            ),
          ],
        )
      ],
    );
  }
}
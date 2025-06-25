//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		13-05-2025 16:09:21
//  Modified time: 	13-05-2025 23:53:43
//  Description:    This file contains the selection step for the add side dialog
//                  It allows for number and blink mode setting 		
//

import 'package:app/global/stepped_dialog/stepped_dialog_step_base.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/sections/profile/led_mode_drop_down/led_mode_drop_down.dart';
import 'package:app/global/settings_field.dart';
import 'package:app/screens/settings/sections/settings_label.dart';
import 'package:app/screens/settings/sections/settings_row.dart';
import 'package:flutter/material.dart';

class SelectionStep extends SteppedDialogStepBase {
  final SideDefinitionListModel side;
  final Function(int newNumber) changeSideNumber;
  final Function(int ledMode) changeLedMode;

  const SelectionStep({
    super.key,
    required this.side,
    required this.changeSideNumber, 
    required this.changeLedMode
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
        Text("Select a number and blink mode for your new side\n\n"),
        SettingsRow(
          left: SettingsLabel(text: "Side number"), 
          right: SizedBox(
            width: 50,
            child: SettingsField(
              prefilled: side.number.toString(),
              keyboardType: TextInputType.number,
              onSubmitted: (value) => changeSideNumber(int.tryParse(value) ?? 0),
            ),
          )
        ),
        SettingsRow(
          left: SettingsLabel(text: "Blink mode"), 
          right: LedModeDropDown(
            value: side.blinkMode,
            newModeSelected: changeLedMode 
          )
        )
      ],
    );
  }
}
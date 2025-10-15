//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 14:06:09
//  Modified time: 	13-05-2025 22:47:35
//  Description: 		This file contains sensitivity drop down, that is used to select sensitivity for profile
//

import 'package:app/models/sensitivity/sensitivity_list.dart';
import 'package:app/screens/settings/sections/profile/sections/sensitivity_drop_down/sensitivity_drop_down_row.dart';
import 'package:app/services/bluetooth/bluetooth.dart';
import 'package:flutter/material.dart';

class SensitivityDropDown extends StatelessWidget {
  final int currentSensitivity;
  final Function(int newSensitivity) newSensitivitySelected;  

  const SensitivityDropDown({super.key, required this.currentSensitivity, required this.newSensitivitySelected});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: DropdownButton(
        value: currentSensitivity,
        items: [
          for (SensitivityListModel model in LPEDBluetooth.sensitivities)
            DropdownMenuItem(
              value: model.value,
              child: SensitivityDropDownRow(model: model)
            )
        ], 
        onChanged: (newSensitivity) {
          if (newSensitivity != null) {
            newSensitivitySelected(newSensitivity);
          }
        }
      )
    );
  }
}
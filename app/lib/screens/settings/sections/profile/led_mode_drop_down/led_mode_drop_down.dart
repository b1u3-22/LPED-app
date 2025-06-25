//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 14:39:45
//  Modified time: 	13-05-2025 22:53:56
//  Description: 		This file contains led mode drop down, for selecting from the side row
//

import 'package:app/models/led_mode/led_mode_list.dart';
import 'package:app/screens/settings/sections/profile/led_mode_drop_down/led_mode_drop_down_row.dart';
import 'package:app/services/bluetooth/bluetooth.dart';
import 'package:flutter/material.dart';

class LedModeDropDown extends StatelessWidget {
  final Function(int newMode) newModeSelected;  
  final int value;

  const LedModeDropDown({super.key, this.value = 0, required this.newModeSelected});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: DropdownButton(
        value: value,
        items: [
          for (LedModeListModel model in LPEDBluetooth.ledModes)
            DropdownMenuItem(
              value: model.value,
              child: LedModeDropDownRow(model: model)
            )
        ], 
        onChanged: (newMode) {
          if (newMode != null) newModeSelected(newMode);
        }
      )
    );
  }
}
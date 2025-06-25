//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		13-05-2025 16:09:21
//  Modified time: 	13-05-2025 22:46:48
//  Description:    This file contains side list row, that displays the sides number, led mode and vector		
//

import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/sections/profile/led_mode_drop_down/led_mode_drop_down.dart';
import 'package:app/global/settings_field.dart';
import 'package:app/services/bluetooth/bluetooth.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class SideListRow extends StatelessWidget {
  final SideDefinitionListModel model;
  final Function(int newLedMode) onLedModeChange;
  final Function(String newNumber) onNumberChange;
  final Function() onDelete;
  final Function() onVectorChange; 

  const SideListRow({
    super.key,
    required this.model, 
    required this.onLedModeChange,
    required this.onNumberChange,
    required this.onDelete,
    required this.onVectorChange
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              child: SettingsField(
                prefilled: model.number.toString(),
                style: labelStyle,
                align: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("X: ${(model.vector[0] / LPEDBluetooth.accelerometerDivisor).toStringAsFixed(2)}g", style: badgeStyle,),
                Text("Y: ${(model.vector[1] / LPEDBluetooth.accelerometerDivisor).toStringAsFixed(2)}g", style: badgeStyle,),
                Text("Z: ${(model.vector[2] / LPEDBluetooth.accelerometerDivisor).toStringAsFixed(2)}g", style: badgeStyle,),
              ],
            ),
            LedModeDropDown(
              value: model.blinkMode,
              newModeSelected: onLedModeChange
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onDelete, 
                  icon: Icon(Icons.delete)
                ),
                IconButton(
                  onPressed: onVectorChange, 
                  icon: Icon(Icons.my_location),
                  color: Theme.of(context).colorScheme.tertiary,
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
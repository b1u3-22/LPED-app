//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:31:22
//  Modified time: 	13-05-2025 23:46:24
//  Description: 		This file contains function to display the delete profile dialog
//

import 'package:app/models/device/device_list.dart';
import 'package:app/models/dice_definition/dice_definition_list.dart';
import 'package:app/screens/settings/flows/delete_dice_definition/delete_dice_definition_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteDiceDefinitionDialog(BuildContext context, DeviceListModel device, DiceDefinitionListModel profile, Function() onConfirm) async {
  showDialog(
    context: context, 
    builder: (_) => DeleteDiceDefinitionDialog(
      device: device, 
      profile: profile,
      onConfirm: onConfirm
    )
  );
}
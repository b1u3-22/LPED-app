//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:47:50
//  Modified time: 	13-05-2025 23:45:42
//  Description: 		This file contains function to display the delete side dialog
//

import 'package:app/models/device/device_list.dart';
import 'package:app/models/dice_definition/dice_definition_list.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/flows/delete_side_definition/delete_side_definition_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteSideDefinitionDialog(BuildContext context, DeviceListModel device,  SideDefinitionListModel sideProfile, DiceDefinitionListModel diceProfile, Function() onConfirm) async {
  showDialog(
    context: context, 
    builder: (_) => DeleteSideDefinitionDialog(
      device: device, 
      sideProfile: sideProfile,
      diceProfile: diceProfile,
      onConfirm: onConfirm
    )
  );
}
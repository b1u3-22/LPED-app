//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:31:16
//  Modified time: 	13-05-2025 23:46:48
//  Description: 		This file contains confirmation dialog for deleting dice profile
//

import 'package:app/global/confirmation_dialog_base.dart';
import 'package:app/models/device/device_list.dart';
import 'package:app/models/dice_definition/dice_definition_list.dart';
import 'package:flutter/material.dart';

class DeleteDiceDefinitionDialog extends StatelessWidget {
  final DeviceListModel device;
  final DiceDefinitionListModel profile;
  final Function() onConfirm;

  const DeleteDiceDefinitionDialog({
    super.key, 
    required this.device, 
    required this.profile,
    required this.onConfirm
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialogBase(
      title: "Delete profile ${profile.name} from ${device.name}", 
      content: 
        "Do you wish to delete profile ${profile.name}?\n\n"
        "This profile currently contains ${profile.numberOfSides} sides "
        "and these will also be deleted.",
      onConfirm: onConfirm,
    );
  }
}
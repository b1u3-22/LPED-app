//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:47:39
//  Modified time: 	13-05-2025 23:45:58
//  Description: 		This file contains confirmation dialog for side deletion
//

import 'package:app/global/confirmation_dialog_base.dart';
import 'package:app/models/device/device_list.dart';
import 'package:app/models/dice_definition/dice_definition_list.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:flutter/material.dart';

class DeleteSideDefinitionDialog extends StatelessWidget {
  final DeviceListModel device;
  final SideDefinitionListModel sideProfile;
  final DiceDefinitionListModel diceProfile;
  final Function() onConfirm;

  const DeleteSideDefinitionDialog({
    super.key, 
    required this.device, 
    required this.sideProfile,
    required this.diceProfile,
    required this.onConfirm
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialogBase(
      title: "Delete side ${sideProfile.number} from profile ${diceProfile.name}", 
      content: 
        "Do you wish to delete side with number ${sideProfile.number}"
        "that is inside ${diceProfile.name} profile in device ${device.name}?",
      onConfirm: onConfirm,
    );
  }
}
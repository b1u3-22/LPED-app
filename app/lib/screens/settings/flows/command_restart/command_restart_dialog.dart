//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:25:30
//  Modified time: 	13-05-2025 23:48:48
//  Description: 		This file contains the confirmation dialog for restart
//

import 'package:app/global/confirmation_dialog_base.dart';
import 'package:app/models/device/device_list.dart';
import 'package:flutter/material.dart';

class CommandRestartDialog extends StatelessWidget {
  final DeviceListModel device;
  final Function() onConfirm;

  const CommandRestartDialog({super.key, required this.device, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialogBase(
      title: "Restart ${device.name}", 
      content: 
        "Are you sure you want to restart ${device.name}? \n\n"
        "This will cause the dice to disconnect",
      onConfirm: onConfirm,
    );
  }
}
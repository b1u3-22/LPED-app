//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:13:56
//  Modified time: 	13-05-2025 23:49:28
//  Description: 		This file contains the confirmation dialog for factory reset
//

import 'package:app/global/confirmation_dialog_base.dart';
import 'package:app/models/device/device_list.dart';
import 'package:flutter/material.dart';

class CommandClearMemoryDialog extends StatelessWidget {
  final DeviceListModel device;
  final Function() onConfirm;

  const CommandClearMemoryDialog({super.key, required this.device, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialogBase(
      title: "Factory reset ${device.name}", 
      content: 
        "Are you sure you want to factory reset ${device.name}? \n\n"
        "This will erase all profiles and user preferences from the dice",
      onConfirm: onConfirm,
    );
  }
}
//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		15-04-2025 19:14:32
//  Modified time: 	14-05-2025 00:39:09
//  Description: 		This file contains confirmation dialog for removing a device
//

import 'package:app/global/confirmation_dialog_base.dart';
import 'package:flutter/material.dart';

class DeleteDeviceDialog extends StatelessWidget {
  final String deviceName;
  final Function() deleteDeviceCallback;

  const DeleteDeviceDialog({super.key, required this.deviceName, required this.deleteDeviceCallback});
  
  @override
  Widget build(BuildContext context) {
    return ConfirmationDialogBase(
      title: "Delete $deviceName",
      content: "Do you wish to delete $deviceName?",
      onConfirm: deleteDeviceCallback,
    );
  }
}
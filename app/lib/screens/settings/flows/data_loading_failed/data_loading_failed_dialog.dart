//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:27:09
//  Modified time: 	13-05-2025 23:47:26
//  Description: 		This file contains confirmation dialog for factory reset upon data loading failure
//

import 'package:app/global/confirmation_dialog_base.dart';
import 'package:app/models/device/device_list.dart';
import 'package:flutter/material.dart';

class DataLoadingFailedDialog extends StatelessWidget {
  final DeviceListModel device;
  final Function() onConfirm;
  final Function() onCancel;

  const DataLoadingFailedDialog({super.key, required this.device, required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialogBase(
      title: "Failed to read data from ${device.name}", 
      content: 
        "Data loading from ${device.name} failed.\n"
        "This can mean that the data are corrupted or that the device failed to respond.\n\n"
        "Do you wish to try a factory reset? \n"
        "Note that this will erase all profiles and user preferences",
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }
}
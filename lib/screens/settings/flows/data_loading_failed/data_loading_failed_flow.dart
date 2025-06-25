//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:27:15
//  Modified time: 	13-05-2025 23:47:07
//  Description: 		This file contains function to display the data loading failed dialog
//

import 'package:app/models/device/device_list.dart';
import 'package:app/screens/settings/flows/data_loading_failed/data_loading_failed_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showDataLoadingFailedDialog(BuildContext context, DeviceListModel device, Function() onConfirm, Function() onCancel) async {
  await showDialog(
    context: context, 
    builder: (_) => DataLoadingFailedDialog(
      device: device, 
      onConfirm: onConfirm,
      onCancel: onCancel,
    )
  );
}
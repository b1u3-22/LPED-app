//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		15-04-2025 19:22:14
//  Modified time: 	14-05-2025 00:41:02
//  Description: 		This file contains function to display the delete dialog
//

import 'package:app/screens/devices/flows/delete_device/delete_device_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteDeviceDialog(BuildContext context, String deviceName, Function() deleteCallback) {
  return showDialog(
    context: context, 
    builder: (_)  => DeleteDeviceDialog(
      deviceName: deviceName, 
      deleteDeviceCallback: deleteCallback
    )
  );
}
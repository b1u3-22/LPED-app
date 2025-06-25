//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:25:37
//  Modified time: 	13-05-2025 23:47:53
//  Description: 		This file contains function to display the restart dialog
//

import 'package:app/models/device/device_list.dart';
import 'package:app/screens/settings/flows/command_restart/command_restart_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCommandRestartDialog(BuildContext context, DeviceListModel device, Function() onConfirm) async {
  showDialog(
    context: context, 
    builder: (_) => CommandRestartDialog(
      device: device, 
      onConfirm: onConfirm
    )
  );
}
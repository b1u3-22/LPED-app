//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:14:03
//  Modified time: 	13-05-2025 23:49:12
//  Description: 		This file contains function to display the command clear dialog
//

import 'package:app/models/device/device_list.dart';
import 'package:app/screens/settings/flows/command_clear_memory/command_clear_memory_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCommandClearMemoryDialog(BuildContext context, DeviceListModel device, Function() onConfirm) async {
  showDialog(
    context: context, 
    builder: (_) => CommandClearMemoryDialog(
      device: device, 
      onConfirm: onConfirm
    )
  );
}
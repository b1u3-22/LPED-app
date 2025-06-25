import 'package:app/models/device/device_list.dart';
import 'package:app/global/history_dialog/clear_history_confirmation/clear_history_confirmation.dart';
import 'package:flutter/material.dart';

Future<void> showHistoryConfirmationDialog(BuildContext context, DeviceListModel device, Function() onConfirm) async {
  await showDialog(
    context: context, 
    builder: (_) => ClearHistoryConfirmation(
      device: device, 
      onConfirm: onConfirm,
    )
  );
}
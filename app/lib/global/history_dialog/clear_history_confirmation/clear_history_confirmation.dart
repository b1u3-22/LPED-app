import 'package:app/global/confirmation_dialog_base.dart';
import 'package:app/models/device/device_list.dart';
import 'package:flutter/material.dart';

class ClearHistoryConfirmation extends StatelessWidget {
  final DeviceListModel device;
  final Function()? onConfirm;

  const ClearHistoryConfirmation({super.key, required this.device, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialogBase(
      title: "Clear history of ${device.name}", 
      content: "This will permanently delete all logs of landed sides",
      onConfirm: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        device.clearHistory();
        if (onConfirm != null) onConfirm!();
      },
    );
  }
}
import 'package:app/models/device/device_play.dart';
import 'package:app/screens/play/flows/start_game/start_game_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showStartGameDialog(
    BuildContext context, 
    List<DevicePlayModel> devices,
    Function(int timerLength, List<List<DevicePlayModel>> playerDevices) onStart,
    Function(List<List<DevicePlayModel>>) blinkDevices,
  ) async 
  {
  showDialog(
    context: context, 
    builder: (_) => StartGameDialog(
      devices: devices,
      onStart: onStart,
      blinkDevices: blinkDevices,
    )
  );
}
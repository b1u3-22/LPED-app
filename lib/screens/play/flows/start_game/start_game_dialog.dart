import 'package:app/global/stepped_dialog/stepped_dialog_base.dart';
import 'package:app/models/device/device_play.dart';
import 'package:app/screens/play/flows/start_game/sections/start_game_blink_step.dart';
import 'package:app/screens/play/flows/start_game/sections/start_game_parameters_step.dart';
import 'package:flutter/material.dart';

class StartGameDialog extends StatefulWidget {
  final List<DevicePlayModel> devices;
  final Function(int timerLength, List<List<DevicePlayModel>> playerDevices) onStart;
  final Function(List<List<DevicePlayModel>>) blinkDevices;

  const StartGameDialog({
    super.key,
    required this.devices,
    required this.onStart,
    required this.blinkDevices
  });
  
    @override
  State<StartGameDialog> createState() => _StartGameDialogState();
}

class _StartGameDialogState extends State<StartGameDialog> {
  int _timerLength = 30;
  int _numberOfPlayers = 1;
  late List<DevicePlayModel> _allDevices;
  List<List<DevicePlayModel>> _playerDevices = [];

  @override
  void initState() {
    super.initState();
    _allDevices = widget.devices;
    _recalculateGroups(_numberOfPlayers);
  }

  void _recalculateGroups(int newPlayerNumber) {
    int devicesForEachPlayer = _allDevices.length ~/ newPlayerNumber;

    print(devicesForEachPlayer);
    print(_allDevices);

    if (devicesForEachPlayer == 0) return;

    List<List<DevicePlayModel>> newGroups = [];

    for (int playerGroup = 0; playerGroup < _allDevices.length; playerGroup += devicesForEachPlayer) {
      print(newGroups);
      newGroups.add(_allDevices.sublist(playerGroup, playerGroup + devicesForEachPlayer));
    }

    setState(() {
      _playerDevices = newGroups;
    });
  }

  @override
  Widget build(BuildContext context) {
    _allDevices = widget.devices;

    return SteppedDialogBase(
      title: "Create new profile", 
      finishButtonText: "Start",
      steps: [
        StartGameParametersStep(
          timerLength: _timerLength,
          playerNumber: _numberOfPlayers,
          onChange: (int newTimerLength, int newPlayerNumber) {
            _recalculateGroups(newPlayerNumber);

            setState(() {
              _timerLength = newTimerLength;
              _numberOfPlayers = newPlayerNumber;
            });
          } 
        ),
        StartGameBlinkStep(
          blinkDice: () => widget.blinkDevices(_playerDevices)
        )
      ], 

      onFinish: () => widget.onStart(_timerLength, _playerDevices)
    );
  }

}
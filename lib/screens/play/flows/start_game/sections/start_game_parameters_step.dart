import 'package:app/global/stepped_dialog/stepped_dialog_step_base.dart';
import 'package:app/screens/settings/sections/settings_row.dart';
import 'package:flutter/material.dart';

class StartGameParametersStep extends SteppedDialogStepBase {
  final int timerLength;
  final int playerNumber;
  final Function(int newTimerLength, int newPlayerNumber) onChange;

  const StartGameParametersStep({super.key, required this.timerLength, required this.playerNumber, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SettingsRow(
          left: Text("Time"), 
          right: Expanded(
            child: Slider(
              min: 10,      // TODO: do not hardcode values
              max: 60,
              divisions: 5,
              label: "$timerLength s",
              value: timerLength.toDouble(), 
              onChanged: (newTime) => onChange(newTime.toInt(), playerNumber)
            ),
          )
        ),
        SettingsRow(
          left: Text("Players"), 
          right: Expanded(
            child: Slider(
              min: 1,      // TODO: do not hardcode values
              max: 3,
              divisions: 2,
              label: "$playerNumber players",
              value: playerNumber.toDouble(), 
              onChanged: (newNumberOfPlayers) => onChange(timerLength, newNumberOfPlayers.toInt())
            )
          )
        )
      ],
    );
  }

  @override
  bool nextStep(int currentStep) {
    return true;
  }

  @override
  bool previousStep(int currentStep) {
    return true;
  }

}
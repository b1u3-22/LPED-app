import 'package:app/global/stepped_dialog/stepped_dialog_step_base.dart';
import 'package:app/screens/settings/sections/settings_action_button.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class StartGameBlinkStep extends SteppedDialogStepBase {
  final Function() blinkDice;
  
  const StartGameBlinkStep({super.key, required this.blinkDice});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Click the button to identify dice. After that, you can start the game!"),
        SettingsActionButton(
          text: "Blink with dice",
          action: blinkDice,
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
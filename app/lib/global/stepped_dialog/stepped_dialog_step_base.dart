import 'package:flutter/material.dart';

abstract class SteppedDialogStepBase extends StatelessWidget {
  const SteppedDialogStepBase({super.key});

  bool nextStep(int currentStep);
  bool previousStep(int currentStep);
}
import 'package:app/global/dialog_action_base.dart';
import 'package:app/global/dialog_base.dart';
import 'package:app/global/stepped_dialog/stepped_dialog_step_base.dart';
import 'package:flutter/material.dart';

class SteppedDialogBase extends StatefulWidget {
  final String title;
  final List<SteppedDialogStepBase> steps;
  final Function() onFinish;
  final Function()? onCancel;


  const SteppedDialogBase({
    super.key,
    required this.title,
    required this.steps,
    required this.onFinish,
    this.onCancel
  });

  bool _nextStep(int currentStep) {
    //return steps[currentStep].nextStep(currentStep);
    return true;
  }

  bool _previousStep(int currentStep) {
    //return steps[currentStep].previousStep(currentStep);
    return true;
  }

  @override
  State<SteppedDialogBase> createState() => _SteppedDialogBaseState();
}

class _SteppedDialogBaseState extends State<SteppedDialogBase>{
  int _currentStep = 0;

  void _incrementStep() {
    if (widget._nextStep(_currentStep)) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void _decrementStep() {
    if (widget._previousStep(_currentStep)) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogBase(
      title: widget.title,
      content: widget.steps[_currentStep],
      actions: [
        DialogActionBase(
          label: "Cancel",
          callback: widget.onCancel
        ),
        if (_currentStep > 0)
          DialogActionBase(
            label: "Previous",
            callback: _decrementStep,
          ),
        DialogActionBase(
          label: _currentStep == widget.steps.length - 1 ? "Finish" : "Next",
          callback: () {
            _currentStep == widget.steps.length - 1 ? widget.onFinish() : _incrementStep();
          },
        ),
      ],
    );
  }
}
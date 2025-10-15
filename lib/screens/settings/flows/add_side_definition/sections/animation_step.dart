import 'package:app/global/stepped_dialog/stepped_dialog_step_base.dart';
import 'package:app/models/animation/animation/animation_detail.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/sections/settings_side_animation_edit.dart';
import 'package:flutter/material.dart';

class AnimationStep extends SteppedDialogStepBase {
  final SideDefinitionListModel side;
  final Function(AnimationDetailModel newAnimation) changeAnimation;

  const AnimationStep({
    super.key, 
    required this.side,
    required this.changeAnimation
  });

  @override
  bool nextStep(int currentStep) {
    return true;
  }

  @override
  bool previousStep(int currentStep) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSideAnimationEdit(
      side: side, 
      onChange: changeAnimation,
    );
  }
}
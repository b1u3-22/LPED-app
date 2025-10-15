import 'package:app/models/animation/animation/animation_detail.dart';
import 'package:app/models/animation/animation_step/animation_step_detail.dart';
import 'package:app/screens/settings/sections/settings_animation_step_list_row.dart';
import 'package:app/screens/settings/sections/settings_list.dart';
import 'package:flutter/material.dart';

class SettingsAnimationStepList extends StatelessWidget {
  final List<AnimationStepDetailModel> steps;
  final Function(int stepIndex) onDelete;
  final Function(int stepIndex, int newColorIndex, int newDuration) onChange;
  final Function(int stepIndex) onCopy;

  const SettingsAnimationStepList({
    super.key,
    required this.steps,
    required this.onDelete,
    required this.onChange,
    required this.onCopy
  });

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      children: [
        for (int animationStepIndex = 0; animationStepIndex < steps.length; animationStepIndex++)
          SettingsAnimationStepListRow(
            model: steps[animationStepIndex], 
            onDelete: () => onDelete(animationStepIndex), 
            onChange: (int colorIndex, int duration) => onChange(animationStepIndex, colorIndex, duration),
            onCopy: () => onCopy(animationStepIndex),
          )
      ]
    );
  }
}

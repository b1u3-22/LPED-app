//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 22:23:28
//  Modified time: 	13-05-2025 23:56:43
//  Description: 		This file contains the step for side vector set inside the add dice profile dialog
//

import 'package:app/global/stepped_dialog/stepped_dialog_step_base.dart';
import 'package:app/models/animation/animation/animation_detail.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/sections/settings_side_animation_edit.dart';
import 'package:app/screens/settings/sections/settings_side_vector_edit.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class SideStep extends SteppedDialogStepBase {
  final int sideIndex;
  final int maxSides;
  final SideDefinitionListModel side;

  final Function(List<int> newVector) changeVector;
  final Function() captureVector;
  final Function(AnimationDetailModel newAnimation) changeAnimation;

  const SideStep({
    super.key,
    required this.sideIndex,
    required this.maxSides,
    required this.side,
    required this.changeVector,
    required this.captureVector,
    required this.changeAnimation
  });

  @override
  bool nextStep(int currentStep) {
    return sideIndex == maxSides;
  }

  @override
  bool previousStep(int currentStep) {
    return sideIndex == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Side ${sideIndex + 1}/$maxSides", style: heading3Style,),
        SizedBox(height: 25),
        SettingsSideVectorEdit(
          side: side,
          changeVector: changeVector, 
          captureVector: captureVector
        ),
        SettingsSideAnimationEdit(
          side: side, 
          onChange: changeAnimation
        )
      ],
    );
  }
}
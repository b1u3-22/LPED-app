//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 18:38:01
//  Modified time: 	13-05-2025 23:51:29
//  Description: 		This file contains the vector adding step for side adding dialog
//

import 'package:app/global/stepped_dialog/stepped_dialog_step_base.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/sections/settings_side_vector_edit.dart';
import 'package:flutter/material.dart';

class VectorStep extends SteppedDialogStepBase {
  final SideDefinitionListModel side;
  final Function(List<int> newVector) changeVector;
  final Function() captureVector;

  const VectorStep({
    super.key, 
    required this.side, 
    required this.changeVector,
    required this.captureVector
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
    return SettingsSideVectorEdit(
      side: side, 
      changeVector: changeVector, 
      captureVector: captureVector
    );
  }
}
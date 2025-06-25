//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:55:08
//  Modified time: 	13-05-2025 23:50:30
//  Description: 		This file contains the stepped dialog for adding new side
//                  First step involves setting the number and blink mode
//                  Second step uses the vector edit section for vector adding
//

import 'package:app/global/stepped_dialog/stepped_dialog_base.dart';
import 'package:app/models/dice_definition/dice_definition_detail.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/flows/add_side_definition/sections/selection_step.dart';
import 'package:app/screens/settings/flows/add_side_definition/sections/vector_step.dart';
import 'package:flutter/material.dart';

class AddSideDefinitionDialog extends StatefulWidget {
  final DiceDefinitionDetailModel diceProfile;
  final Function(DiceDefinitionDetailModel profile, SideDefinitionListModel newSide) onFinish;
  final Future<List<int>>Function() captureVector;

  const AddSideDefinitionDialog({
    super.key, 
    required this.diceProfile,
    required this.onFinish,
    required this.captureVector
  });

  @override
  State<AddSideDefinitionDialog> createState() => _AddSideDefinitionDialogState();
}

class _AddSideDefinitionDialogState extends State<AddSideDefinitionDialog>{
  late SideDefinitionListModel newSide;

  @override
  void initState() {
    newSide = SideDefinitionListModel(
      blinkMode: 0, 
      number: widget.diceProfile.numberOfSides + 1, 
      vector: [0, 0, 0]
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SteppedDialogBase(
      title: "Add new side", 
      steps: [
        SelectionStep(
          side: newSide, 
          changeSideNumber: (newNumber) => setState(() => newSide.number = newNumber), 
          changeLedMode: (newLedMode) => setState(() => newSide.blinkMode = newLedMode)
        ),
        VectorStep(
          side: newSide, 
          changeVector: (newVector) => setState(() => newSide.vector = newVector), 
          captureVector: () => widget.captureVector()
        )
      ], 
      onFinish: () => widget.onFinish(widget.diceProfile, newSide), 
    );
  }
}

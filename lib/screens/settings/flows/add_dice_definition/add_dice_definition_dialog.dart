//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:03:39
//  Modified time: 	13-05-2025 23:54:37
//  Description: 		This file contains the add dice profile dialog
//                  It is multi-step dialog: 
//                  1. Name and number of sides selection
//                  2. Vector set for all sides
//

import 'package:app/global/stepped_dialog/stepped_dialog_base.dart';
import 'package:app/models/dice_definition/dice_definition_detail.dart';
import 'package:app/models/sensitivity/sensitivity_base.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/flows/add_dice_definition/sections/name_step/name_step.dart';
import 'package:app/screens/settings/flows/add_dice_definition/sections/side_step.dart';
import 'package:flutter/material.dart';

class AddDiceDefinitionDialog extends StatefulWidget {
  final Function(DiceDefinitionDetailModel) addDiceProfile;
  final Future<List<int>>Function() captureVector;

  const AddDiceDefinitionDialog({
    super.key,
    required this.addDiceProfile,
    required this.captureVector
  });
  
    @override
  State<AddDiceDefinitionDialog> createState() => _AddDiceDefinitionDialogState();
}

class _AddDiceDefinitionDialogState extends State<AddDiceDefinitionDialog> {
  DiceDefinitionDetailModel newProfile = DiceDefinitionDetailModel(
    name: "New profile", 
    numberOfSides: 0,
    range: SensitivityBaseModel.sensitivityMediumValue
  );

  int currentSideIndex = 0;
  int multiplier = 1;
  SideDefinitionListModel currentSide = SideDefinitionListModel(number: 1, vector: [0, 0, 0]);

  void _changeNumberOfSides(int newNumberOfSides, int multiplier) {
    setState(() {
      newProfile.numberOfSides = newNumberOfSides;
      newProfile.sides.clear();
      for (int i = 0; i < newNumberOfSides; i++) {
        newProfile.sides.add(SideDefinitionListModel(number: (i + 1) * multiplier, vector: [0, 0, 0]));
      }
    });
  }

  @override
  void initState() {
    _changeNumberOfSides(6, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SteppedDialogBase(
      title: "Create new profile", 
      steps: [
        NameStep(
          profile: newProfile, 
          changeName: (newName) => setState(() => newProfile.name = newName), 
          changeSensitivity: (newSensitivity) => setState(() => newProfile.range = newSensitivity), 
          changeNumberOfSides: _changeNumberOfSides, 
        ),
        for (int i = 0; i < newProfile.numberOfSides; i++) 
          SideStep(
            sideIndex: i, 
            maxSides: newProfile.numberOfSides, 
            side: newProfile.sides[i], 
            changeVector: (newVector) => newProfile.sides[i].vector = newVector , 
            captureVector: widget.captureVector, 
          )
      ], 

      onFinish: () => widget.addDiceProfile(newProfile)
    );
  }

}
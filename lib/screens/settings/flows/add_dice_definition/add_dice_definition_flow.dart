//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:04:09
//  Modified time: 	13-05-2025 23:54:23
//  Description: 		This file contains function to display the add dice profile dialog
//

import 'package:app/models/dice_definition/dice_definition_detail.dart';
import 'package:app/screens/settings/flows/add_dice_definition/add_dice_definition_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showAddDiceDefinitionDialog(
    BuildContext context, 
    Function(DiceDefinitionDetailModel diceProfile) onFinish,
    Future<List<int>>Function() captureVector
  ) async 
  {
  showDialog(
    context: context, 
    builder: (_) => AddDiceDefinitionDialog(
      addDiceProfile: onFinish,
      captureVector: captureVector,
    )
  );
}
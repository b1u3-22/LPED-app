//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 16:55:16
//  Modified time: 	13-05-2025 23:50:11
//  Description: 		This file contains function to display the add side dialog
//

import 'package:app/models/dice_definition/dice_definition_detail.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/flows/add_side_definition/add_side_definition_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showAddSideDefinitionDialog(
    BuildContext context, 
    DiceDefinitionDetailModel diceProfile,
    Function(DiceDefinitionDetailModel diceProfile, SideDefinitionListModel newSide) onFinish,
    Future<List<int>>Function() captureVector
  ) async 
  {
  showDialog(
    context: context, 
    builder: (_) => AddSideDefinitionDialog(
      diceProfile: diceProfile,
      onFinish: onFinish,
      captureVector: captureVector,
    )
  );
}
//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 21:21:45
//  Modified time: 	13-05-2025 23:33:29
//  Description: 		This file contains function to display the update side dialog
//

import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/flows/update_side_definition/update_side_definition_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showUpdateSideDefinitionDialog(BuildContext context, SideDefinitionListModel side, Future<List<int>>Function() captureVector, Function(SideDefinitionListModel updatedSide) onConfirm, Function() onCancel) async {
  showDialog(
    context: context, 
    builder: (_) => UpdateSideDefinitionDialog(
      side: side,
      captureVector: captureVector,
      onConfirm: onConfirm,
      onCancel: onCancel,
    )
  );
}
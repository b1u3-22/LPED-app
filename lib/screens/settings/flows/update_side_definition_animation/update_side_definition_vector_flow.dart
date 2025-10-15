//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 21:21:45
//  Modified time: 	13-05-2025 23:33:29
//  Description: 		This file contains function to display the update side dialog
//

import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/flows/update_side_definition_animation/update_side_definition_vector_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showUpdateSideDefinitionAnimationDialog(BuildContext context, SideDefinitionListModel side, Function(SideDefinitionListModel updatedSide) onConfirm, Function() onCancel) async {
  showDialog(
    context: context, 
    builder: (_) => UpdateSideDefinitionAnimationDialog(
      side: side,
      onConfirm: onConfirm,
      onCancel: onCancel,
    )
  );
}
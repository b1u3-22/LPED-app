//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 21:21:36
//  Modified time: 	13-05-2025 23:45:16
//  Description: 		This file contains the update side dialog, which enables to change the side vector
//

import 'package:app/global/dialog_action_base.dart';
import 'package:app/global/dialog_base.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/sections/settings_side_vector_edit.dart';
import 'package:flutter/material.dart';

class UpdateSideDefinitionDialog extends StatefulWidget {
  final SideDefinitionListModel side;
  final Future<List<int>>Function() captureVector;
  final Function(SideDefinitionListModel updatedSide) onConfirm;
  final Function() onCancel;

  const UpdateSideDefinitionDialog({
    super.key, 
    required this.side,
    required this.captureVector,
    required this.onConfirm,
    required this.onCancel
  });

  @override
  State<UpdateSideDefinitionDialog> createState() => _UpdateSideDefinitionDialogState();
}

class _UpdateSideDefinitionDialogState extends State<UpdateSideDefinitionDialog>{
  late SideDefinitionListModel _side;

  @override
  void initState() {
    super.initState();
    _side = SideDefinitionListModel.from(widget.side);
  }

  void _updateSide(List<int> newVector) {
    _side.vector = newVector;
  }

  @override
  Widget build(BuildContext context) {
    return DialogBase(
      title: "Edit position of side ${widget.side.number}",
      content: SettingsSideVectorEdit(
        side: _side, 
        changeVector: _updateSide, 
        captureVector: widget.captureVector
      ),
      actions: [
        DialogActionBase(
          label: "Cancel",
        ),
        DialogActionBase(
          label: "Confirm",
          callback: () => widget.onConfirm(_side),
        ),
      ],
    );
  }
}
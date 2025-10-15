//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 21:21:36
//  Modified time: 	13-05-2025 23:45:16
//  Description: 		This file contains the update side dialog, which enables to change the side vector
//

import 'package:app/global/dialog_action_base.dart';
import 'package:app/global/dialog_base.dart';
import 'package:app/models/animation/animation/animation_detail.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/sections/settings_side_animation_edit.dart';
import 'package:flutter/material.dart';

class UpdateSideDefinitionAnimationDialog extends StatefulWidget {
  final SideDefinitionListModel side;
  final Function(SideDefinitionListModel updatedSide) onConfirm;
  final Function() onCancel;

  const UpdateSideDefinitionAnimationDialog({
    super.key, 
    required this.side,
    required this.onConfirm,
    required this.onCancel
  });

  @override
  State<UpdateSideDefinitionAnimationDialog> createState() => _UpdateSideDefinitionAnimationDialogState();
}

class _UpdateSideDefinitionAnimationDialogState extends State<UpdateSideDefinitionAnimationDialog>{
  late SideDefinitionListModel _side;

  @override
  void initState() {
    super.initState();
    _side = SideDefinitionListModel.from(widget.side);
  }

  void _updateSide(AnimationDetailModel newAnimation) {
    _side.animation = newAnimation;
  }

  @override
  Widget build(BuildContext context) {
    return DialogBase(
      title: "Edit animation of side ${widget.side.number}",
      content: SettingsSideAnimationEdit(
        side: _side, 
        onChange: (newAnimation) => _updateSide(newAnimation),
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
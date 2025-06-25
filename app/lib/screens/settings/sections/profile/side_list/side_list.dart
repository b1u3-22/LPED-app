//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 02:11:05
//  Modified time: 	13-05-2025 22:46:24
//  Description: 		This file contains side list, that displays multiple side list rows
//

import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/sections/profile/side_list/side_list_row.dart';
import 'package:app/screens/settings/sections/settings_list.dart';
import 'package:flutter/material.dart';

class SideList extends StatelessWidget {
  final List<SideDefinitionListModel> sides;
  final Function(int sideIndex) deleteSide;
  final Function(int sideIndex, int newLedMode) changeSideLedMode;
  final Function(int sideIndex, int newSideNumber) changeSideNumber;
  final Function(int sideIndex) changeSideVector;

  const SideList({
    super.key,
    required this.sides,
    required this.deleteSide,
    required this.changeSideLedMode,
    required this.changeSideNumber,
    required this.changeSideVector
  });

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      children: [
        for (int sideIndex = 0; sideIndex < sides.length; sideIndex++)
          SideListRow(
            model: sides[sideIndex], 
            onLedModeChange: (newMode) => changeSideLedMode(sideIndex, newMode), 
            onNumberChange: (newNumber) => changeSideNumber(sideIndex, int.tryParse(newNumber) ?? 0), 
            onDelete: () => deleteSide(sideIndex), 
            onVectorChange: () => changeSideVector(sideIndex)
          )
      ]
    );
  }
}
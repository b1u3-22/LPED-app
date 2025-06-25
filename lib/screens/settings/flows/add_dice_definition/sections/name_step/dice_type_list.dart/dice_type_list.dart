//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		04-05-2025 02:03:15
//  Modified time: 	13-05-2025 23:59:37
//  Description: 		This file contains the list that shows multiple dice type cards
//

import 'package:app/screens/settings/flows/add_dice_definition/sections/name_step/dice_type_list.dart/dice_type_card.dart';
import 'package:app/screens/settings/flows/add_dice_definition/sections/name_step/dice_type_list.dart/dice_type_descriptor.dart';
import 'package:flutter/material.dart';

class DiceTypeList extends StatefulWidget {
  final List<DiceTypeDescriptor> types;
  final Function(int newNumberOfSides, int multiplier) changeNumberOfSides;
  
  const DiceTypeList({super.key, required this.types, required this.changeNumberOfSides});

  @override
  State<DiceTypeList> createState() => _DiceTypeListState();
}

class _DiceTypeListState extends State<DiceTypeList>{
  int _selectedIndex = 1;

  void _cardClicked(int newNumber, int multiplier, int index) {
    setState(() => _selectedIndex = index);
    widget.changeNumberOfSides(newNumber, multiplier);
  }

  void _cardChangeNumber(int newNumber, int index) {
    setState(() => widget.types[index].numberOfSides = newNumber); 
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: [
        for (int typeIndex = 0; typeIndex < widget.types.length; typeIndex++)
          DiceTypeCard(
          label: widget.types[typeIndex].label,
          numberOfSides: widget.types[typeIndex].numberOfSides,
          editable: widget.types[typeIndex].editable,
          onClick: (newNumber, multiplier, index) => _cardClicked(newNumber, multiplier, index), 
          changeCustomNumber: (newNumber, index) => _cardChangeNumber(newNumber, index),
          id: typeIndex,
          selected: _selectedIndex == typeIndex,
          multiplier: widget.types[typeIndex].multiplier,
        )
      ],
    );
  }

}
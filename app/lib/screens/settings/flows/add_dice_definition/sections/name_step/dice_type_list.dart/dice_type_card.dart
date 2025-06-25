//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		13-05-2025 16:09:21
//  Modified time: 	14-05-2025 00:03:04
//  Description: 		This file contains the dice type card, which shows the types label, number of sides and indication if it is selected
//

import 'dart:math';

import 'package:app/models/dice_definition/dice_definition_base.dart';
import 'package:app/global/settings_field.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class DiceTypeCard extends StatelessWidget {
  static const defaultCustomNumberOfSides = 6;

  final int numberOfSides;
  final String label;
  final Image? image;
  final Function(int numberOfSides, int multiplier, int id) onClick;
  final Function(int newNumber, int id) changeCustomNumber;
  final bool selected;
  final bool editable;
  final int id;
  final int multiplier;

  const DiceTypeCard({
    super.key, 
    this.numberOfSides = defaultCustomNumberOfSides, 
    required this.label,
    required this.onClick,
    required this.id,
    this.selected = false,
    this.editable = false,
    required this.changeCustomNumber,
    this.image,
    this.multiplier = 1
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: selected? 2 : 0
        )
      ),
      child: InkWell(
        onTap: () => onClick(numberOfSides, multiplier, id),
        child: SizedBox(
          height: editable? 80 : 60,
          width: editable? 80 : 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (image != null) image!,
              if (image != null) SizedBox(height: 5),
              Text(label, style: heading3Style, textAlign: TextAlign.center,),
              if (!editable)  Text("Sides: $numberOfSides", style: badgeStyle, textAlign: TextAlign.center,)
              else SizedBox(
                width: 50,
                child: SettingsField(
                  prefilled: numberOfSides.toString(),
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  align: TextAlign.center,
                  onSubmitted: (newValue) => 
                    changeCustomNumber(
                      min(
                        int.tryParse(newValue) ?? defaultCustomNumberOfSides, 
                        DiceDefinitionBaseModel.sidesMaxLen
                      ), 
                      id)
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
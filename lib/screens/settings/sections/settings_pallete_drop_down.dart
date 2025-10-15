import 'package:app/models/animation/pallete/pallete_list.dart';
import 'package:app/screens/settings/sections/settings_pallete_drop_down_row.dart';
import 'package:flutter/material.dart';

class SettingsPalleteDropDown extends StatelessWidget {
  final int currentSelectedColor;
  final Function(int newIndex) newColorSelected; 

  const SettingsPalleteDropDown({
    super.key, 
    required this.currentSelectedColor, 
    required this.newColorSelected
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: DropdownButton(
        value: currentSelectedColor,
        items: [
          for (int colorIndex = 0; colorIndex < Pallete.palette.length; colorIndex++)
            DropdownMenuItem(
              value: colorIndex,
              child: SettingsPalleteDropDownRow(colorIndex: colorIndex, color: Pallete.palette[colorIndex]),
            )
        ], 
        onChanged: (newIndex) {
          if (newIndex == null) {
            return;
          }

          else {
            newColorSelected(newIndex);
          }
        }
      ),
    );
  }
}
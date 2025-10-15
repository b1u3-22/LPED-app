import 'package:app/models/animation/fade_type/fade_type_list.dart';
import 'package:app/screens/settings/sections/settings_fade_type_drop_down_row.dart';
import 'package:app/services/bluetooth/bluetooth.dart';
import 'package:flutter/material.dart';

class SettingsFadeTypeDropDown extends StatelessWidget {
  final Function(int newMode) newTypeSelected;  
  final int value;

  const SettingsFadeTypeDropDown({super.key, this.value = 0, required this.newTypeSelected});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: DropdownButton(
        value: value,
        items: [
          for (FadeTypeListModel model in LPEDBluetooth.fadeTypes)
            DropdownMenuItem(
              value: model.value,
              child: SettingsFadeTypeDropDownRow(model: model)
            )
        ], 
        onChanged: (newMode) {
          if (newMode != null) newTypeSelected(newMode);
        }
      )
    );
  }
}
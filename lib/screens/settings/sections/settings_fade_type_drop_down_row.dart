import 'package:app/models/animation/fade_type/fade_type_list.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class SettingsFadeTypeDropDownRow extends StatelessWidget {
  final FadeTypeListModel model;

  const SettingsFadeTypeDropDownRow({super.key, required this.model});
  
  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem(
      value: model.value,
      child: Row(
        children: [
          Text(model.name, style: textStyle),
        ],
      )
    );
  }
}
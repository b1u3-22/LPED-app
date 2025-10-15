import 'package:app/models/animation/pallete/pallete_item.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class SettingsPalleteDropDownRow extends StatelessWidget {
  final PalleteItem color;
  final int colorIndex;
  
  const SettingsPalleteDropDownRow({super.key, required this.color, required this.colorIndex});

  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem(
      value: colorIndex,
      child: Row(
        children: [
          Text(color.name, style: textStyle),
          SizedBox(width: 5),
          Container(
            width: textStyle.fontSize,
            height: textStyle.fontSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Color.fromARGB(255, color.color[0], color.color[1], color.color[2])
            ),
          ),
        ]

      )    
    );
  }
}
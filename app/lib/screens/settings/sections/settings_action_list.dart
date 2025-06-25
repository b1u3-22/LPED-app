//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 02:31:20
//  Modified time: 	13-05-2025 22:43:24
//  Description: 		This file contains settings action list, that displays multiple settings actions
//

import 'package:app/screens/settings/sections/settings_action_button.dart';
import 'package:flutter/material.dart';

class SettingsActionList extends StatelessWidget {
  final List<SettingsActionButton> children;

  const SettingsActionList({super.key, required this.children});
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 1,
      children: children,
    );
  }
}
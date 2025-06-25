//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 03:27:28
//  Modified time: 	13-05-2025 22:42:13
//  Description:    This file contains Settings list base widget for displaying lists of children 		
//

import 'package:flutter/widgets.dart';

class SettingsList extends StatelessWidget {
  final List<Widget> children;

  const SettingsList({super.key, required this.children});
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: children,
    );
  }
}
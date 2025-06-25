//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 01:58:27
//  Modified time: 	13-05-2025 22:40:53
//  Description: 		This file contains Settings Page base widget
//

import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final List<Widget> children;

  const SettingsPage({super.key, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
            maxHeight: constraints.maxHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        );
      },
    );
  }
}
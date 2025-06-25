//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		04-05-2025 02:03:27
//  Modified time: 	14-05-2025 00:02:25
//  Description: 		This file contains the dice type descriptor, which is a helper class for declaring available dice types
//

import 'dart:ui';

class DiceTypeDescriptor {
  final String label;
  int numberOfSides;
  final bool editable;
  final Image? image;
  final int multiplier;

  DiceTypeDescriptor({
    required this.label, 
    required this.numberOfSides, 
    this.multiplier = 1,
    this.editable = false,
    this.image
  });
}
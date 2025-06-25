import 'dart:convert';
import 'dart:math';

import 'package:app/models/dice_definition/dice_definition_base.dart';

class DiceDefinitionListModel extends DiceDefinitionBaseModel {
  late String name;
  late int id;
  late int numberOfSides;
  late int range;

  DiceDefinitionListModel.fromIntList(List<int> byteArray) {
    // Get name, drop all zeroes and transform to String
    List<int> nameByte = byteArray.sublist(
      DiceDefinitionBaseModel.namePosition,
      DiceDefinitionBaseModel.namePosition + DiceDefinitionBaseModel.nameMaxLen
    );
    nameByte.removeWhere((value) {return value == 0;});
    name = String.fromCharCodes(nameByte);

    id = byteArray.elementAt(
      DiceDefinitionBaseModel.idPosition
    );

    numberOfSides = byteArray.elementAt(
      DiceDefinitionBaseModel.numberOfSidesPosition
    );

    range = (byteArray.elementAt(
      DiceDefinitionBaseModel.rangePosition + 1
    ) << 8);

    range |= byteArray.elementAt(
      DiceDefinitionBaseModel.rangePosition
    );

    print("id: $id, sides: $numberOfSides, range: $range");
  }
  
  DiceDefinitionListModel({required this.name, required this.id, required this.numberOfSides, required this.range});

  @override
  List<int> toByteArray() {
    List<int> outputByte = [];

    // Add name
    outputByte.addAll(
      utf8.encode(name)
      .sublist(
        0, 
        min(DiceDefinitionBaseModel.nameMaxLen, name.length)
      )
    ); 

    // Pad remaining name length with zeroes
    for (int i = name.length; i < DiceDefinitionBaseModel.nameMaxLen; i++) {
      outputByte.add(0);
    }

    outputByte.add(id);
    outputByte.add(numberOfSides);
    outputByte.add(DiceDefinitionBaseModel.padding); // Padding between number_of_sides and range members of dice_definition_t structure
    outputByte.add(range.toUnsigned(16) & 0xFF);
    outputByte.add((range.toUnsigned(16) >> 8) & 0xFF);

    return outputByte;
  }
  
  @override
  List<int> toUpdateByteArray() {
    return toByteArray();
  }
}
import 'package:app/models/dice_definition/dice_definition_base.dart';
import 'package:app/models/dice_definition/dice_definition_list.dart';
import 'package:app/models/side_definition/side_definition_base.dart';
import 'package:app/models/side_definition/side_definition_list.dart';

class DiceDefinitionDetailModel extends DiceDefinitionListModel {
  late List<SideDefinitionListModel> sides;

  DiceDefinitionDetailModel({
    super.id = 0,
    required super.name, 
    required super.numberOfSides,
    required super.range
  }) {
    sides = [];
  }

  DiceDefinitionDetailModel.fromIntList(List<int> byteArray) : super.fromIntList(byteArray) {
    sides = [];
    
    for (
        int i = DiceDefinitionBaseModel.sidesPosition; 
        i < DiceDefinitionBaseModel.sidesPosition + DiceDefinitionBaseModel.sidesMaxLen * SideDefinitionBaseModel.totalLen;
        i += SideDefinitionBaseModel.totalLen
      ) {
        print(byteArray.sublist(i, i + SideDefinitionBaseModel.totalLen).toString());
        sides.add(
          SideDefinitionListModel.fromIntList(byteArray.sublist(i, i + SideDefinitionBaseModel.totalLen))
        );
      }
    // Drop non-defined sides
    sides.removeWhere((side) {return side.number == 0;});
  }

  @override
  List<int> toByteArray() {
    List<int> outputByte = super.toByteArray();

    for (SideDefinitionListModel side in sides) {
      outputByte.addAll(side.toByteArray());
    }

    // Fill remaining side positions with zeros
    for (int i = sides.length; i < DiceDefinitionBaseModel.sidesMaxLen; i++) {
      for (int o = 0; o < SideDefinitionBaseModel.totalLen; o++) {
        outputByte.add(0);
      }
    }

    return outputByte;
  }

  @override
  List<int> toUpdateByteArray() {
    return super.toByteArray();
  }
}
import 'package:app/models/side_definition/side_definition_base.dart';

class SideDefinitionListModel extends SideDefinitionBaseModel {
  late int blinkMode;
  late int number;
  late List<int> vector;

  SideDefinitionListModel.fromIntList(List<int> byteArray) {
    blinkMode = byteArray.elementAt(SideDefinitionBaseModel.blinkModePosition);
    number = byteArray.elementAt(SideDefinitionBaseModel.numberPosition);
    vector = [];
    for ( 
          int i = SideDefinitionBaseModel.vectorPosition; 
          i < SideDefinitionBaseModel.vectorPosition + SideDefinitionBaseModel.vectorDimension * 2;
          i += 2
        ) {
          vector.add(
            ((byteArray[i + 1]).toUnsigned(8) << 8 | byteArray[i].toUnsigned(8)).toSigned(16)
          );
        }
  }

  SideDefinitionListModel({required this.blinkMode, required this.number, required this.vector});
  
  SideDefinitionListModel.from(SideDefinitionListModel original) : 
    blinkMode = original.blinkMode, 
    number = original.number,
    vector = List<int>.from(original.vector);

  @override
  List<int> toByteArray() {
    List<int> outputByte = [];

    outputByte.add(number);
    outputByte.add(blinkMode);

    for (int vvector in vector) {
      outputByte.add(vvector & 0xFF);       // add LSB of vector
      outputByte.add(vvector >> 8 & 0xFF);  // add MSB of vector
    }

    return outputByte;
  }
  
  @override
  List<int> toUpdateByteArray() {
    return toByteArray();
  }
}
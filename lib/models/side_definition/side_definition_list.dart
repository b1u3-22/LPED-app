import 'package:app/models/animation/animation/animation_detail.dart';
import 'package:app/models/side_definition/side_definition_base.dart';

class SideDefinitionListModel extends SideDefinitionBaseModel {
  late int number;
  late AnimationDetailModel animation;
  late List<int> vector;

  SideDefinitionListModel.fromIntList(List<int> byteArray) {
    number = byteArray.elementAt(SideDefinitionBaseModel.numberPosition);

    animation = AnimationDetailModel.fromIntList(
      byteArray.sublist(
        SideDefinitionBaseModel.animationPosition, 
        SideDefinitionBaseModel.animationPosition + SideDefinitionBaseModel.animationSize
      )
    );

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

  SideDefinitionListModel({required this.number, required this.vector});

  SideDefinitionListModel.withAnimation({required this.number, required this.vector, required this.animation});
  
  SideDefinitionListModel.from(SideDefinitionListModel original) : 
    number = original.number,
    animation = original.animation,
    vector = List<int>.from(original.vector);

  @override
  List<int> toByteArray() {
    List<int> outputByte = [];

    outputByte.add(number);

    outputByte.addAll(animation.toByteArray());

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
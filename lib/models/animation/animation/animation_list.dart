import 'package:app/models/animation/animation/animation_base.dart';

class AnimationListModel extends AnimationBaseModel {
  static const sizeInBytes = 1; // Size in bytes for the "header" which is just the number of steps and fade type

  late int fadeType;
  late int numberOfSteps;

  AnimationListModel(int newFadeMode, int newNumberOfSteps): 
    fadeType = newFadeMode,
    numberOfSteps = newNumberOfSteps;
  
  AnimationListModel.fromIntList(List<int> byteArray) {
    fadeType = byteArray[0] & AnimationBaseModel.fadeTypeBitMask;
    numberOfSteps = (byteArray[0] >> AnimationBaseModel.fadeTypeBitSize) & AnimationBaseModel.numberOfStepsBitMask;
  }

  @override
  List<int> toByteArray() {
    return [
      fadeType | numberOfSteps << AnimationBaseModel.fadeTypeBitSize
    ];
  }
}
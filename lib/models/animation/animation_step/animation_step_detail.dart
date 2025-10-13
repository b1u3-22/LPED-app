import 'package:app/models/animation/animation_step/animation_step_base.dart';

class AnimationStepDetailModel extends AnimationStepBaseModel {
  late int colorIndex;
  late int duration;

  AnimationStepDetailModel(int newColor, int newDuration) : 
    colorIndex =  newColor,
    duration =    newDuration;
    
  AnimationStepDetailModel.fromIntList(List<int> byteArray) {
    colorIndex = byteArray[0] & AnimationStepBaseModel.colorIndexBitMask;
    duration = (byteArray[0] >> AnimationStepBaseModel.colorIndexBitSize) & AnimationStepBaseModel.durationBitMask; 
  }

  @override
  List<int> toByteArray() {
    return [
      duration << 4 | colorIndex
    ];
  }
}
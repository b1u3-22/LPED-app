import 'package:app/models/animation/animation/animation_base.dart';
import 'package:app/models/animation/animation/animation_list.dart';
import 'package:app/models/animation/animation_step/animation_step_base.dart';
import 'package:app/models/animation/animation_step/animation_step_detail.dart';
import 'package:app/models/animation/fade_type/fade_type_base.dart';
import 'package:app/models/animation/pallete/pallete_list.dart';

class AnimationDetailModel extends AnimationListModel {
  late List<AnimationStepDetailModel> steps;

  AnimationDetailModel(int fadeType, this.steps) : super(fadeType, steps.length);

  AnimationDetailModel.fromIntList(List<int> byteArray) : super.fromIntList(byteArray) {
    List<int> stepsByteArray = byteArray.sublist(AnimationListModel.sizeInBytes);

    List<AnimationStepDetailModel> newSteps = [];

    for (int stepIndex = 0; stepIndex < numberOfSteps; stepIndex += 1) {
      newSteps.add(
        AnimationStepDetailModel.fromIntList(stepsByteArray.sublist(stepIndex * AnimationStepBaseModel.sizeInBytes, stepIndex * AnimationStepBaseModel.sizeInBytes + AnimationStepBaseModel.sizeInBytes))
      );
    }

    steps = newSteps;
  }

  AnimationDetailModel.generateBlink(int number) : super(0, 0) {
    fadeType = FadeTypeBaseModel.fadeTypeFastValue;
    steps = [];    

    for (int animationStep = 0; animationStep < number % (AnimationBaseModel.numberOfStepsMaxValue / 2); animationStep++) {
      steps.add(AnimationStepDetailModel(Pallete.colorRedBright, 1));
      steps.add(AnimationStepDetailModel(Pallete.colorOff, 1));
    }

    steps.removeLast(); // remove the last off

    numberOfSteps = steps.length;
  }

  AnimationDetailModel.empty(): super(0, 0) {
    steps = [];
  }

  @override
  List<int> toByteArray() {
    // add fade and number of steps
    List<int> output = super.toByteArray();

    // add steps 
    for (int step = 0; step < numberOfSteps; step++) {
      output.addAll(steps[step].toByteArray());
    }

    // pad remaining steps
    for (int emptyStep = numberOfSteps; emptyStep < AnimationBaseModel.numberOfStepsMaxValue; emptyStep++) {
      for (int stepByte = 0; stepByte < AnimationStepBaseModel.sizeInBytes; stepByte++) {
        output.add(0);
      }
    }

    return output;
  }
}
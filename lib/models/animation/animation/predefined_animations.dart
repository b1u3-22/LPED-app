import 'package:app/models/animation/animation/animation_detail.dart';
import 'package:app/models/animation/animation_step/animation_step_detail.dart';
import 'package:app/models/animation/fade_type/fade_type_base.dart';
import 'package:app/models/animation/pallete_list.dart';

abstract class PredefinedAnimations {
  static AnimationDetailModel identifyAnimation = AnimationDetailModel(
    FadeTypeBaseModel.fadeTypeGradValue, 
    [
      AnimationStepDetailModel(Pallete.colorRedBright, 15),
      AnimationStepDetailModel(Pallete.colorGreenBright, 15),
      AnimationStepDetailModel(Pallete.colorBlueBright, 15)
    ]
  );
}
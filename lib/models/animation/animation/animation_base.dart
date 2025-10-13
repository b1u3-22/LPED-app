abstract class AnimationBaseModel {
  static const int fadeTypeMaxValue = 4;
  static const int numberOfStepsMaxValue = 64;

  static const int fadeTypeBitSize = 2;

  static const int fadeTypeBitMask = 3;
  static const int numberOfStepsBitMask = 63;

  List<int> toByteArray();
}
abstract class AnimationStepBaseModel {
  static const int colorIndexMaxValue = 15;
  static const int durationMaxValue = 15;

  static const int sizeInBytes = 1;
  static const int colorIndexBitSize = 4;

  static const colorIndexBitMask = 15;
  static const durationBitMask = 15;

  List<int> toByteArray();
}
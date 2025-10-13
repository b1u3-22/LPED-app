import 'package:app/models/updatable.dart';

abstract class SideDefinitionBaseModel extends Updatable {
  static const totalLen = 72;
  static const numberPosition = 0;
  static const animationPosition = 1;

  static const animationSize = 65;

  static const vectorPosition = animationPosition + animationSize;
  static const vectorDimension = 3;

  List<int> toByteArray();
}
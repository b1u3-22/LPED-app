import 'package:app/models/updatable.dart';

abstract class SideDefinitionBaseModel extends Updatable {
  static const totalLen = 8;
  static const blinkModePosition = 1;
  static const numberPosition = 0;
  static const vectorPosition = 2;
  static const vectorDimension = 3;

  List<int> toByteArray();
}
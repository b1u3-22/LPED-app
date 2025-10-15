import 'package:app/models/updatable.dart';

abstract class DiceDefinitionBaseModel extends Updatable {
  static const int sidesMaxLen = 20;
  static const int namePosition = 0;
  static const int nameMaxLen = 21;
  static const int idPosition = 21;
  static const int numberOfSidesPosition = 22;
  static const int paddingPosition = 23;
  static const int rangePosition = 24;
  static const int rangeLen = 2;
  static const int sidesPosition = 26;
  static const int padding = 0;
  static const int diceDefinitionsMax = 10;

  List<int> toByteArray();
}
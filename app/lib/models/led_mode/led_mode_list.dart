import 'package:app/models/led_mode/led_mode_base.dart';

class LedModeListModel extends LedModeBaseModel {
  final String name;
  final int value;

  LedModeListModel({required this.name, required this.value});
}
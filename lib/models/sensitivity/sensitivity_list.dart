import 'package:app/models/sensitivity/sensitivity_base.dart';

class SensitivityListModel extends SensitivityBaseModel {
  final String name;
  final int value;

  SensitivityListModel({required this.name, required this.value});
}
import 'package:app/models/device/device_play.dart';
import 'package:flutter/material.dart';

class ListOfDevicePlayModels extends ValueNotifier<List<DevicePlayModel>> {
  ListOfDevicePlayModels(super.value);


  void updateNumber(int newNumber, int index) {
    if (index < 0 || index >= value.length) return;
    value[index].updateNumber(newNumber);
    notifyListeners();
  }

  void updateCapState(int newCapState, int index) {
    if (index < 0 || index >= value.length) return;
    value[index].updateCapState(newCapState);
    notifyListeners();
  }

  void updateVisible(bool newVisibility, int index) {
    if (index < 0 || index >= value.length) return;
    value[index].updateVisible(newVisibility);
    notifyListeners();
  }

}
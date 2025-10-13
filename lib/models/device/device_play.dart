import 'dart:async';

import 'package:app/models/device/device_list.dart';
import 'package:app/services/storage.dart';

class DevicePlayModel extends DeviceListModel {
  int number = 0;
  bool visible = true;
  bool included = true;
  int id = 0;
  StreamSubscription<List<int>>? capStateNotifications;
  StreamSubscription<List<int>>? diceNumberIndications;

  DevicePlayModel.fromJSON(super.json) : super.fromJSON();

  DevicePlayModel.fromAttributes({required super.mac, required super.name, required super.capState, required super.lastMes}) : super.fromAttributes();
  
  bool isValidId(int newId) {
    if (newId > id || newId == 0) {
      id = newId;
      return true;
    } 
    
    return false;
  }

  void updateLastId(int newId) {
    if (id < 0) return;
    id = newId;
  }

  void updateCapState(int newCapState) {
    if (newCapState < 0) return;
    capState = newCapState;
    lastMes = DateTime.now();
    Storage().saveDevice(this);
  }

  void updateNumber(int newNumber) {
    number = newNumber;
    lastMes = DateTime.now();

    if (newNumber > 0) updateHistory(number);
    Storage().saveDevice(this);
  }

  void updateVisible(bool newVisibility) {
    visible = newVisibility;
  }

  void updateIncluded(bool newIncluded) {
    included = newIncluded;
  }
}
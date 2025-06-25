import 'package:app/models/device/device_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ListOfDeviceDiscoveryModels extends ValueNotifier<List<DeviceDiscoveryModel>> {
  

  ListOfDeviceDiscoveryModels(super.value);

  void refreshDevices() {
    for (DeviceDiscoveryModel device in value) {
      device.seen = false;
    }
  }

  void removeUnseenDevices() {
    for (DeviceDiscoveryModel device in value) {
      if (!device.seen) value.remove(device);
    }

    notifyListeners();
  }

  int deviceAlreadyDiscovered(String mac) {
    if (value.isEmpty) return -1;

    for (int i = 0; i < value.length; i++) {
      if (value[i].mac == mac) return i;
    }
    return -1;
  }



  void updateRSSIfromScanResult(int deviceIndex, ScanResult result) {
    if (deviceIndex < 0 || deviceIndex >= value.length) return;

    value[deviceIndex].rssi = result.rssi;
    value[deviceIndex].seen = true;
    notifyListeners();
  }
}
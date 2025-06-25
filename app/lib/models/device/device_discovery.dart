import 'package:app/models/device/device_base.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceDiscoveryModel extends DeviceBase {
  late String name;
  DateTime lastMes = DateTime.now();
  late int rssi;
  late bool seen;

  DeviceDiscoveryModel({required this.name, required super.mac});
  DeviceDiscoveryModel.fromScanResult(ScanResult result) {
    name = result.advertisementData.advName;
    mac = result.device.remoteId.toString();
    rssi = result.rssi;
    seen = true;
  }

  @override
  void fromJSON(Map<String, dynamic> json) {
    name = json["name"] as String;
    mac = json["mac"] as String;
    lastMes = DateTime.parse(json["lastMes"]);
    rssi = json["rssi"] as int;
  }

  @override
  Map<String, dynamic> toJSON() {
    // RSSI is not saved, as it is only used when discovering devices
    return {"mac": mac, "name": name, "lastMes": lastMes.toIso8601String()};
  }
}
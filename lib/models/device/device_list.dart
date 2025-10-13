import 'package:app/models/device/device_base.dart';
import 'package:app/services/storage.dart';

class DeviceListModel extends DeviceBase {
  String name       = "";
  int capState      = 100;
  DateTime lastMes  = DateTime.fromMillisecondsSinceEpoch(0);
  int numberOfSides = 6;
  Map<String, int> history = {};

  DeviceListModel.fromJSON(Map<String, dynamic> json) {
      name = json["name"] as String;
      mac = json["mac"] as String;
      capState = json["capState"] ?? 0;
      lastMes = DateTime.parse(json["lastMes"]);
      numberOfSides = json["sides"] ?? 6;
      
      final rawHistory = json["history"] as Map<String, dynamic>?;
      history = rawHistory?.map((key, value) => MapEntry(key, value as int)) ?? {};
  }

  DeviceListModel.fromAttributes({required super.mac, required this.name, required this.capState, required this.lastMes});
  
  @override
  void fromJSON(Map<String, dynamic> json) {
    DeviceListModel.fromJSON(json);
  }
  
  @override
  Map<String, dynamic> toJSON() {
    return {"name": name, "mac": mac, "capState": capState, "lastMes": lastMes.toIso8601String(), "sides": numberOfSides, "history": history};
  }

  void updateHistory(int number) {
     int currentCount = history[number.toString()] ?? 0;
     history.addAll({number.toString(): currentCount + 1});
     Storage().saveDevice(this);
  }

  void clearHistory() {
    history = {};
    Storage().saveDevice(this);
  }
}
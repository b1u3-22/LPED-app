abstract class DeviceBase {
  String mac;

  DeviceBase({this.mac = ""});

  void fromJSON(Map<String, dynamic> json); // Assign attributes from JSON
  Map<String, dynamic> toJSON();
}
//
// 	 Author: 			    Jiří Sedlák (xsedla2e)
// 	 Create Time: 		15-04-2025 18:38:25
// 	 Modified time: 	13-05-2025 21:05:20
// 	 Description: 	  This file contains function for working with the persistent 
//                    storage of devices
//

import 'dart:convert';
import 'dart:io';
import 'package:app/models/device/device_base.dart';
import 'package:app/models/device/device_list.dart';
import 'package:app/models/device/device_play.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  late Directory saveDir;

  static final Storage _storageSingleton = Storage._create();

  factory Storage() {
    return _storageSingleton;
  }
  
  Storage._create(); // In case more non-future fields need to be initialized


  /// Init function for the storage, that initializes the working dir
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    saveDir = await getApplicationDocumentsDirectory();
  }

  /// Function to get the filename for specific device
  static String getDeviceFileName(String mac) {
    return "device_${mac.replaceAll(":", "_")}";
  }

  /// Function to get the filename for list of mac addresses
  static String getMacListFileName() {
    return "macs_list";
  }

  /// Function to read contents of specific file with given filename
  /// It returns the read contents as String or null, in case the reading failed
  String? _read(String filename) {
    try {
      final file = File("${saveDir.path}/$filename");
      if (file.existsSync()) {
        return file.readAsStringSync();
      } 

      return null;
    } catch(e) {
      return null;
    }
  } 

  /// Write given content to file with given filename
  void _write(String filename, String content) {
    final file = File("${saveDir.path}/$filename");
    file.writeAsStringSync(content);
  }

  /// Returns list of mac addresses of all saved devices
  List<String> getAllDevicesMacs() {
    String? raw = _read(getMacListFileName());
    if (raw == null) return [];

    Map<String, dynamic> json = jsonDecode(raw);
    
    List<String> macs;
    if (json["macs"].runtimeType != List) {macs = [];}
    else                                  {macs = List<String>.from( json["macs"] as List);}
    return macs;
  }

  /// Add a new mac to the list of saved devices
  void _addMac(String mac) {
    List<String> macs = getAllDevicesMacs();
    // Do not add mac if it already exists in the list
    // This is needed because the saveDevice is used for both 
    // updating a device and creating a new entry
    if (macs.contains(mac)) return;
    macs.add(mac);
    _write(getMacListFileName(), jsonEncode({"macs": macs}));
  }

  /// Delete mac from the list of saved devices
  void _deleteMac(String mac) {
    List<String> macs = getAllDevicesMacs();
    macs.remove(mac);
    _write(getMacListFileName(), jsonEncode({"macs": macs}));
  }

  /// Get list of all devices as DeviceListModel that correspond to the given macs
  List<DeviceListModel> getAllDevicesListModelsFromMacs(List<String> macs) {
    List<DeviceListModel> devices = [];
    String? raw = "";

    for (String mac in macs) {
        raw = _read(getDeviceFileName(mac));
        
        // Failed while reading the device file, which means that the device
        // no longer exists, so we remove it from mac list
        if (raw == null) {
          _deleteMac(mac);
          continue;
        }

        devices.add(DeviceListModel.fromJSON(jsonDecode(raw)));
    }

    return devices;
  }

  /// Get list of all saved devices as a DeviceListModels
  List<DeviceListModel> getAllDevicesListModels() {
    return getAllDevicesListModelsFromMacs(getAllDevicesMacs());
  }

  /// Get list of all devices as DevicePlayModel that correspond to the given macs
  List<DevicePlayModel> getAllDevicesPlayModelsFromMacs(List<String> macs) {
    List<DevicePlayModel> devices = [];
    String? raw = "";

    for (String mac in macs) {
        raw = _read(getDeviceFileName(mac));
        
        // Failed while reading the device file, which means that the device
        // no longer exists, so we remove it from mac list
        if (raw == null) {
          _deleteMac(mac);
          continue;
        }

        devices.add(DevicePlayModel.fromJSON(jsonDecode(raw)));
    }

    return devices;
  }

  /// Get all saved devices as DevicePlayModel
  List<DevicePlayModel> getAllDevicesPlayModels() {
    return getAllDevicesPlayModelsFromMacs(getAllDevicesMacs());
  }

  /// Add new or update existing given device
  void saveDevice(DeviceBase device) {
    // Get existing parameters
    String? raw = _read(getDeviceFileName(device.mac));
    raw ??= "{}";

    Map<String, dynamic> json = jsonDecode(raw);
    
    // Add parameters from given device
    json.addAll(device.toJSON());
    
    // Save parameters to storage
    _write(getDeviceFileName(device.mac), jsonEncode(json));

    // Add mac to list
    _addMac(device.mac);
  }

  /// Delete device that has the given mac
  void removeDeviceByMac(String mac) {
    File file = File("${saveDir.path}/${getDeviceFileName(mac)}");
    file.deleteSync();
    _deleteMac(mac);
  }

  /// Delete given device
  void removeDevice(DeviceBase device) {
    removeDeviceByMac(device.mac);
  }

  /// Get device that has the given mac as DeviceListModel
  DeviceListModel? getDeviceListModelByMac(String mac) {
    String? raw = _read(getDeviceFileName(mac));
    if (raw == null) return null;

    Map<String, dynamic> json = jsonDecode(raw);
    return DeviceListModel.fromJSON(json);
  }
} 
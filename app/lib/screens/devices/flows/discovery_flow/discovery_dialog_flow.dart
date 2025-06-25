//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		15-04-2025 18:38:25
//  Modified time: 	14-05-2025 00:36:28
//  Description: 		This file contains functions to display discovery dialog and to start scanning
//

import 'dart:async';

import 'package:app/models/device/device_discovery.dart';
import 'package:app/models/device/list_of_device_discovery.dart';
import 'package:app/screens/devices/flows/discovery_flow/discovery_dialog.dart';
import 'package:app/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Start scanning for devices with "LPED" in the name
StreamSubscription<List<ScanResult>> _startScanning(ListOfDeviceDiscoveryModels devices) {
  FlutterBluePlus.startScan(
    timeout: Duration(minutes: 15),
    withKeywords: ["LPED"],
    continuousUpdates: true,
    removeIfGone: Duration(seconds: 1)
  );
  List<String> macs = Storage().getAllDevicesMacs();
  StreamSubscription<List<ScanResult>> scanSubscription = FlutterBluePlus.onScanResults.listen((results) {
    if (results.isEmpty) return;

    // refresh sets all devices to "unseen" so that any that were not updated or added
    // this scan results will be removed by removeUnseenDevices, however, we do not get 
    // any notification, since nothing is in search results, I need to find a workaround
    // for this
    devices.refreshDevices();

    for (ScanResult result in results) {
      // Ignore all non-connectable LPED devices
      if (!result.advertisementData.connectable) continue; 

      // Ignore all already-added LPED devices
      if (macs.contains(result.device.remoteId.toString())) continue;

      // If device is already in the list, update it's RSSI
      int deviceIndex = devices.deviceAlreadyDiscovered(result.device.remoteId.toString());
      if (deviceIndex != -1) {
        devices.updateRSSIfromScanResult(deviceIndex, result);
        continue;
      }

      // If device is connectable, and is not already in the list, add it into the list
      devices.value = [...devices.value, DeviceDiscoveryModel.fromScanResult(result)];
    }

    devices.removeUnseenDevices();
  });

  return scanSubscription;
}

/// Function to show the discovery dialog
Future<void> showDiscoveryDialog(BuildContext context) async {
  await FlutterBluePlus.turnOn();
  if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.off) {
    if (!context.mounted) return;

    ListOfDeviceDiscoveryModels foundDevices = ListOfDeviceDiscoveryModels([]);
    StreamSubscription<List<ScanResult>> scanSubscription = _startScanning(foundDevices);

    await showDialog(
      context: context,
      builder: (_) => DiscoveryDialog(
        foundDevices: foundDevices
      )
    );

    FlutterBluePlus.cancelWhenScanComplete(scanSubscription);
    FlutterBluePlus.stopScan();
  }

  else {
    Fluttertoast.showToast(msg: "You have to enable Bluetooth to add a new device");
    return;
  }
}
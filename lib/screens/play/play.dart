//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		15-04-2025 18:38:25
//  Modified time: 	14-05-2025 00:08:21
//  Description: 		This file contains the play page that is displaying the landed numbers in real time
//

import 'dart:async';
import 'package:app/global/history_dialog/clear_history_confirmation/clear_history_confirmation_flow.dart';
import 'package:app/services/bluetooth/bluetooth.dart';
import 'package:app/screens/play/sections/play_card.dart';
import 'package:app/models/device/device_play.dart';
import 'package:app/services/storage.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class PlayPage extends StatefulWidget {

  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage>{
  late StreamSubscription<List<ScanResult>> scanSubscription;
  late StreamSubscription<BluetoothAdapterState> adapterStateSubscription;

  List<DevicePlayModel> devices = Storage().getAllDevicesPlayModels();
  int _sum = 0;

  /// Calculate sum from all currently landed numbers
  int _getSum() {
    int output = 0;
    for (DevicePlayModel device in devices) {
      if (device.visible && device.included && device.number > 0) output += device.number;
    }
    return output;
  }

  /// Update the play cards and sum
  void update() {
    if (!mounted) return;
    setState(() {
      _sum = _getSum();
    });
  }

  /// Get device index inside the devices list
  int _getDeviceIndexByMac(String mac) {
    for (int i = 0; i < devices.length; i++) {
      if (devices[i].mac == mac) return i;
    }

    return -1;
  }

  /// Change the device visibility inside the play page and update
  void changeVisibilityOfDevice(String mac, bool visibility) {
    int deviceIndex = _getDeviceIndexByMac(mac);
    if (deviceIndex < 0) return;

    devices[deviceIndex].updateVisible(visibility);
    update();
  }

  /// Change the device inclusion in sum and update
  void changeInclusionOfDevice(String mac, bool included) {
    int deviceIndex = _getDeviceIndexByMac(mac);
    if (deviceIndex < 0) return;

    devices[deviceIndex].updateIncluded(included);
    update();
  }

  /// Open the clear history dialog and if confirmed, update
  void clearHistoryOfDevice(String mac) {
    int deviceIndex = _getDeviceIndexByMac(mac);
    if (deviceIndex < 0) return;

    showHistoryConfirmationDialog(
      context, 
      devices[deviceIndex], 
      () => update()
    );    
  }

  /// Start scanning for the non-connectable advertisement from all devices where we saved the MAC address
  void _startScan() {
    FlutterBluePlus.startScan(
      timeout: Duration(hours: 24),
      withRemoteIds: Storage().getAllDevicesMacs(),
      continuousUpdates: true,
      continuousDivisor: 1
    );

    scanSubscription = FlutterBluePlus.onScanResults.listen((results) {_translateMessages(results);});
  }

  /// Stop scanning for messages
  void _stopScan() {
    if (!FlutterBluePlus.isScanningNow) return;
    FlutterBluePlus.stopScan();
    FlutterBluePlus.cancelWhenScanComplete(scanSubscription);
  }

  /// Translate incoming messages
  void _translateMessages(List<ScanResult> results) {
    if (results.isEmpty) return;

      int id;
      int messageType;
      int message;
      int deviceIndex;

      for (ScanResult result in results) {
        deviceIndex = _getDeviceIndexByMac(result.device.remoteId.toString());
        // If device was not found, continue with next result, but this shouldn't happen
        // since we already filter by only our saved macs
        if (deviceIndex < 0) continue;

        // Check if new id is valid
        id = LPEDBluetooth.idFromMfgData(result.advertisementData.manufacturerData);
        if (!devices[deviceIndex].isValidId(id)) continue;

        // Split the rest of manufacturer data
        messageType = LPEDBluetooth.messageTypeFromMfgData(result.advertisementData.manufacturerData);
        message = LPEDBluetooth.messageFromMfgData(result.advertisementData.manufacturerData);

        switch(messageType) {
          case LPEDBluetooth.diceNumber: 
            devices[deviceIndex].updateNumber(message);
          case LPEDBluetooth.capState:
            devices[deviceIndex].updateCapState(LPEDBluetooth.capStateFromMessage(message));
          case LPEDBluetooth.rolling:
            devices[deviceIndex].updateNumber(-1);
            devices[deviceIndex].updateCapState(LPEDBluetooth.capStateFromMessage(message)); 
        }
      }

      update();
  }

  @override
  void initState() {
    super.initState();

    adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on)  {_startScan();}
      else                                    {_stopScan();}
    });

    // Check if bluetooth is turned on
    // If yes, start scanning immediately 
    if (FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on) {_startScan();}

    // If not, try to turn it on
    else {FlutterBluePlus.turnOn();}
  }

  @override
  void dispose() {
    _stopScan();
    adapterStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Wrap(
                  children: [
                      for (DevicePlayModel device in devices) 
                        if (device.visible) 
                          PlayCard.fromDevicePlayModel(
                          model: device, 
                          changeVisibilityCallback: changeVisibilityOfDevice,
                          changeInclusionCallback: changeInclusionOfDevice,
                          clearHistoryCallback: () => clearHistoryOfDevice(device.mac),
                        )
                  ],
                )
              ),
            ),
            
            Align(
              alignment: Alignment.bottomCenter,
              child: Text("Sum: ${_sum.toString()}", style: heading2Style, textAlign: TextAlign.center,),
            )
          ],
        )
      )
    );
  }
}
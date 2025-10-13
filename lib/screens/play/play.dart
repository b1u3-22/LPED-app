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

  // TODO: maybe make this function async instead of .then() hellscape
  void _connectDeviceAndSubscribe(BluetoothDevice device) {
    device.connect(timeout: Duration(seconds: 15))
    .then((value) {
      if (!device.isConnected) return; // connection failed

      int deviceIndex = _getDeviceIndexByMac(device.remoteId.toString());
      if (deviceIndex < 0) return; // Device not found in our list

      // check comm mode of that device, since it might not have commMode = true
      // but just wants to connect for configuration 
      // (commMode = false and placed in dock for v2 or button long pressed for v1)
      LPEDBluetooth.readCommMode(device).then((value) {
        if (value ?? false) {
          // set the accelerometer to int mode in case it was left in trigger
          LPEDBluetooth.writeCommand(device, LPEDBluetooth.gattCommandEnableDockConn).then((value) {
            // set cap state notification callback 
            devices[deviceIndex].capStateNotifications = 
              device.servicesList[LPEDBluetooth.gattCapServiceIndex]
                    .characteristics[LPEDBluetooth.gattCapStateIndex]
                    .onValueReceived.listen((value) {
                      devices[deviceIndex].updateCapState(value[0]);
                    });

            // stop the notification subscription when the device disconnects 
            device.cancelWhenDisconnected(devices[deviceIndex].capStateNotifications!);
            
            // subscribe to cap state notifications 
            device.servicesList[LPEDBluetooth.gattCapServiceIndex]
                  .characteristics[LPEDBluetooth.gattCapStateIndex]
                  .setNotifyValue(true);

            // set dice number notification callback 
            devices[deviceIndex].diceNumberIndications = 
              device.servicesList[LPEDBluetooth.gattDiceServiceIndex]
                    .characteristics[LPEDBluetooth.gattDiceNumberIndex]
                    .onValueReceived.listen((value) {
                      switch (LPEDBluetooth.diceStatusFromIndication(value)) {
                        case LPEDBluetooth.diceNumber: 
                          devices[deviceIndex].updateNumber(LPEDBluetooth.diceNumberFromIndication(value));
                          break;
                        case LPEDBluetooth.rolling:
                          devices[deviceIndex].updateNumber(PlayCard.rollingValue);
                          break;
                        case LPEDBluetooth.unknown:
                          devices[deviceIndex].updateNumber(PlayCard.unknownValue);
                          break;
                      }
                    });

            // stop the notification subscription when the device disconnects 
            device.cancelWhenDisconnected(devices[deviceIndex].diceNumberIndications!);

            // subscribe to cap state notifications 
            device.servicesList[LPEDBluetooth.gattDiceServiceIndex]
                  .characteristics[LPEDBluetooth.gattDiceNumberIndex]
                  .setNotifyValue(true);
          });
        }
      });
    });
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
        // check if device is connectable (indicating connection base comunication mode)
        if (result.advertisementData.connectable) {
          _connectDeviceAndSubscribe(result.device);

          // skip the rest of the steps that are for non-connectable dice
          continue;
        }


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
            devices[deviceIndex].updateCapState(message);
          case LPEDBluetooth.rolling:
            devices[deviceIndex].updateNumber(PlayCard.rollingValue);
            devices[deviceIndex].updateCapState(message); 
          case LPEDBluetooth.unknown:
            devices[deviceIndex].updateNumber(PlayCard.unknownValue);
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
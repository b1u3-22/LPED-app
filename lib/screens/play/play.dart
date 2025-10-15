//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		15-04-2025 18:38:25
//  Modified time: 	14-05-2025 00:08:21
//  Description: 		This file contains the play page that is displaying the landed numbers in real time
//

import 'dart:async';
import 'package:app/global/history_dialog/clear_history_confirmation/clear_history_confirmation_flow.dart';
import 'package:app/models/animation/animation/animation_detail.dart';
import 'package:app/models/animation/animation/predefined_animations.dart';
import 'package:app/models/animation/pallete/pallete_list.dart';
import 'package:app/models/dice_definition/dice_definition_base.dart';
import 'package:app/screens/play/flows/end_game/end_game_flow.dart';
import 'package:app/screens/play/flows/start_game/start_game_flow.dart';
import 'package:app/services/bluetooth/bluetooth.dart';
import 'package:app/screens/play/sections/play_card.dart';
import 'package:app/models/device/device_play.dart';
import 'package:app/services/storage.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class PlayPage extends StatefulWidget {

  static const List<int> groupColorIndexes = [2, 10, 14];

  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();

  /// Calculates points for set of given devices based on ruleset: 
  /// Pair - 100 points 
  /// Triple - 200 points 
  /// For each six - 50 points 
  /// 
  /// Pairs and triples are compatible - e.g. 3 3 3 2 1 5 
  /// would count as pair of 3 and triple of 3
  /// Same for every six - e.g. 6 6 6 6 6 6 (best throw)
  /// would count as 3 pairs of 6, 2 pairs of 6 and 6x6
  /// 
  /// Bonus for each pair - 50 (e.g. 2 pairs = +50, 3 pairs = +100)
  /// Bonus for each triple - 100
  /// 
  /// This method is universal and **works** with any number of dice
  /// this does not imply it is **fair** for any number of dice
  /// Same applies to multi-sided dice.
  static int calculatePoints(List<DevicePlayModel> devices) {
    // construct help array for number counts
    List<int> counts = [];
    for (int i = 0; i < DiceDefinitionBaseModel.sidesMaxLen; i++) {counts.add(0);}

    // calculate occurances for each number
    for (var device in devices) {
      if (device.number > 0) counts[device.number]++;
    }

    int score = 0;
    
    // Add points for each 6
    score += counts[6] * 50;

    // Add points for pairs
    for (var count in counts) {score += (count ~/ 2) * 100;}

    // Add points for triples
    for (var count in counts) {score += (count ~/ 3) * 200;}

    // Add points for multiple pairs 
    int pairsTotal = 0;
    for (var count in counts) {pairsTotal += count ~/ 2;}
    if (pairsTotal >= 2) score += (pairsTotal - 1) * 50;

    // Add points for multiple triples 
    int triplesTotal = 0;
    for (var count in counts) {triplesTotal += count ~/ 2;}
    if (triplesTotal >= 2) score += (triplesTotal - 1) * 100;

    return score;
  }

}

class _PlayPageState extends State<PlayPage>{
  late StreamSubscription<List<ScanResult>> scanSubscription;
  late StreamSubscription<BluetoothAdapterState> adapterStateSubscription;

  List<DevicePlayModel> devices = Storage().getAllDevicesPlayModels();
  // ignore: prefer_final_fields
  List<String> _devicesBlacklist = [];
  int _sum = 0;
  bool inGame = false;
  List<List<DevicePlayModel>> _deviceGroups = [];

  /// Calculate sum from all currently landed numbers
  int _getSum() {
    int output = 0;
    for (DevicePlayModel device in devices) {
      if (device.visible && device.included && device.number > 0) output += device.number;
    }
    return output;
  }

  void blinkWithDevices(List<List<DevicePlayModel>> deviceGroups) {
    for (int group = 0; group < deviceGroups.length; group++) {
      AnimationDetailModel colorBlinkSolid = AnimationDetailModel.fromColor(PlayPage.groupColorIndexes[group]);

      for (var device in deviceGroups[group]) {
        blinkWithDevice(device.mac, colorBlinkSolid);
      }
    }
  }

  void _startGame(int timerLength, List<List<DevicePlayModel>> deviceGroups) {
    setState(() {
      _deviceGroups = deviceGroups;
      inGame = true;
    });

    Navigator.of(context).pop();

    Future.delayed(Duration(seconds: timerLength), () => _endGame());
  }

  void _endGame() {
    List<int> scores = [];
    for (var group in _deviceGroups) {
      scores.add(PlayPage.calculatePoints(group));
    }

    showEndGameDialog(
      context, 
      scores, 
      () {
        setState(() {
          inGame = false;
        });
        Navigator.of(context).pop();
      }
    );
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

  void blinkWithDevice(String mac, AnimationDetailModel animation) {
    // TODO: add popup with error
    if (_getDeviceIndexByMac(mac) == -1) return;

    for (BluetoothDevice bluetoothDevice in FlutterBluePlus.connectedDevices) {
      if (bluetoothDevice.remoteId.toString() == mac) {
        LPEDBluetooth.writeAnimation(bluetoothDevice, PredefinedAnimations.identifyAnimation);
        break;
      }
    }
  }

void _disconnectFromAllDevices() {
  for (BluetoothDevice bluetoothDevice in FlutterBluePlus.connectedDevices) {
    if (devices.isEmpty) return;

    for (DevicePlayModel device in devices) {
      if (device.mac == bluetoothDevice.remoteId.toString()) {
        bluetoothDevice.disconnect();
        break;
      }
    }
  }
}

Future<void> _connectDeviceAndSubscribe(BluetoothDevice device) async {
  // dont try to connect to already connected devices
  if (device.isConnected) return;

  try {
    // Connect with a timeout
    await device.connect(timeout: const Duration(seconds: 15));

    // check the connection succeeded
    if (!device.isConnected) {
      return;
    }

    // find the device
    final int deviceIndex = _getDeviceIndexByMac(device.remoteId.toString());
    if (deviceIndex < 0) return; // device not found

    // discover all services
    final List<BluetoothService> services = await device.discoverServices();
    if (services.length <= LPEDBluetooth.gattDiceServiceIndex) return;

    // check communication mode, device might be in connection mode for 
    // configuration only
    final bool commMode = await LPEDBluetooth.readCommMode(device) ?? false;
    if (!commMode) {
      _devicesBlacklist.removeWhere((mac) => mac == device.remoteId.toString());
      return;
    }

    // listen to connection status
    final StreamSubscription<BluetoothConnectionState> connSub =
        device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        _devicesBlacklist.removeWhere(
            (mac) => mac == device.remoteId.toString());
        // cancel subscription when disconnected
        devices[deviceIndex].capStateSubscription?.cancel();
        devices[deviceIndex].diceNumberSubscription?.cancel();
      }
    });

    // save connection state
    devices[deviceIndex].connectionSubscription = connSub;

    // Enable dock‑mode command
    // await LPEDBluetooth.writeCommand(
    //     device, LPEDBluetooth.gattCommandEnableDockConn);

    // gatt characteristic with capacitor state
    final BluetoothCharacteristic capState = device.servicesList[
        LPEDBluetooth.gattCapServiceIndex].characteristics[
        LPEDBluetooth.gattCapStateIndex];

    // enable notifications for cap state
    await capState.setNotifyValue(true);

    // listen for cap state changes
    final StreamSubscription<List<int>> capStateSubscription = capState.onValueReceived
        .listen((value) {
          devices[deviceIndex].updateCapState(value[0]);
          update();
        });

    // save the capacitor state subscription
    devices[deviceIndex].capStateSubscription = capStateSubscription;

    // dice status characteristic
    final BluetoothCharacteristic diceNumber = device.servicesList[
        LPEDBluetooth.gattDiceServiceIndex].characteristics[
        LPEDBluetooth.gattDiceNumberIndex];

    // subscribe to dice number changes
    await diceNumber.setNotifyValue(true);

    // listen for and parse dice number/status changes
    final StreamSubscription<List<int>> diceNumberSubscription = diceNumber.onValueReceived
        .listen((value) {
      switch (LPEDBluetooth.diceStatusFromNotification(value)) {
        case LPEDBluetooth.diceNumber:
          devices[deviceIndex]
              .updateNumber(LPEDBluetooth.diceNumberFromNotification(value));
          break;
        case LPEDBluetooth.rolling:
          devices[deviceIndex].updateNumber(PlayCard.rollingValue);
          break;
        case LPEDBluetooth.unknown:
          devices[deviceIndex].updateNumber(PlayCard.unknownValue);
          break;
      }
      update();
    });

    devices[deviceIndex].diceNumberSubscription = diceNumberSubscription;
  } catch (e) {
    // TODO: add error popup
    // remove device so that it can be connected in the future
    _devicesBlacklist.removeWhere((mac) => mac == device.remoteId.toString());
  }
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
        if (_devicesBlacklist.contains(result.device.remoteId.toString())) continue;

        // check if device is connectable (indicating connection base comunication mode)
        if (result.advertisementData.connectable) {
          _connectDeviceAndSubscribe(result.device);
          _devicesBlacklist.add(result.device.remoteId.toString());

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
    _disconnectFromAllDevices();
    adapterStateSubscription.cancel();
    _devicesBlacklist = [];
    super.dispose();
  }

  @override
  void deactivate() {
    _stopScan();
    _disconnectFromAllDevices();
    adapterStateSubscription.cancel();
    _devicesBlacklist = [];
    super.deactivate();
  }

  @override
  void activate() {
    _devicesBlacklist = [];
    _startScan();
    super.activate();
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
          if (inGame) 
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int group = 0; group < _deviceGroups.length; group++)
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(
                            255, 
                            Pallete.palette[PlayPage.groupColorIndexes[group]].color[0], 
                            Pallete.palette[PlayPage.groupColorIndexes[group]].color[1], 
                            Pallete.palette[PlayPage.groupColorIndexes[group]].color[2]
                          )
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Column(
                        children: [
                          Wrap(
                            children: [
                              for (var device in _deviceGroups[group]) 
                                PlayCard.fromDevicePlayModel(
                                  model: device, 
                                  changeVisibilityCallback: changeVisibilityOfDevice,
                                  changeInclusionCallback: changeInclusionOfDevice,
                                  clearHistoryCallback: () => clearHistoryOfDevice(device.mac),
                                  identifyCallback: (String mac) => blinkWithDevice(mac, PredefinedAnimations.identifyAnimation),
                                )
                            ],
                          ),
                          Text("Score: ${PlayPage.calculatePoints(_deviceGroups[group])}")
                        ],
                      )
                    )
                  )
              ],
            ),



          if (!inGame)
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
                          identifyCallback: (String mac) => blinkWithDevice(mac, PredefinedAnimations.identifyAnimation),
                        )
                  ],
                )
              ),
            ),
            
            if (!inGame)
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Text("Sum: ${_sum.toString()}", style: heading2Style, textAlign: TextAlign.center,),
                    FittedBox(
                      child: ElevatedButton(
                        onPressed: () => showStartGameDialog(
                          context, 
                          devices, 
                          _startGame, 
                          (List<List<DevicePlayModel>> deviceGroups) => blinkWithDevices(deviceGroups)), 
                        child: Row(
                          children: [
                            Text("New game"),
                            Icon(Icons.casino)
                          ],
                        )
                      ),
                    )
                  ],
                )
              )
          ],
        )
      )
    );
  }
}
//
// 	 Author: 			    Jiří Sedlák (xsedla2e)
// 	 Create Time: 		15-04-2025 18:38:25
// 	 Modified time: 	13-05-2025 21:29:00
// 	 Description: 	  This file contains functions and predefined values
//                    for communication with dice
//

import 'dart:math';

import 'package:app/models/dice_definition/dice_definition_detail.dart';
import 'package:app/models/dice_definition/dice_definition_list.dart';
import 'package:app/models/led_mode/led_mode_base.dart';
import 'package:app/models/led_mode/led_mode_list.dart';
import 'package:app/models/sensitivity/sensitivity_base.dart';
import 'package:app/models/sensitivity/sensitivity_list.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/models/updatable.dart';
import 'package:app/services/bluetooth/gatt_result/gatt_result_read.dart';
import 'package:app/services/bluetooth/gatt_result/gatt_result_write.dart';
import 'package:app/services/bluetooth/gatt_update_action.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class LPEDBluetooth {
  /// Status message type that carries landed side number
  static const int diceNumber = 1;

  /// Status message type that carries number of sides for a dice
  static const int sidesNumber = 2;

  /// Status message type that carries capacitor state of charge
  static const int capState = 3;

  /// Status message type that carries rolling or start of motion
  static const int rolling = 4;

  /// Maximum value of capacitor state
  static const int messageCapStateMax = 255;

  /// Value that represents 0% of charge of capacitor
  static const int messageCapStateMin = 121;

  /// Index of the LPED GATT Services
  static const int gattServiceIndex = 2;

  /// Index of side blinking characteristic                      
  static const int gattSideBlinkIndex = 0;     

  /// Index of error blinking characteristic               
  static const int gattErrorBlinkIndex = 1;         

  /// Index of complete (detail) dice definition characteristic          
  static const int gattDiceDefinitionIndex = 2;               

  /// Index of list of supported dice definitions (only ids) characteristic
  static const int gattSupportedDiceDefinitionIDsIndex = 3;  

  /// Index of current dice definition id characteristic 
  static const int gattCurrentDiceDefinitionIDIndex = 4;      

  /// Index of selected dice definition (only parameters, no sides -> list model) characteristic
  static const int gattSelectedDiceListDefinitionIndex = 5;   

  /// Index of GATT characteristic for sending updated dice (header only)/side definitions (requires update header  @see updateHeaderInBytes())
  static const int gattUpdateIndex = 6;

  /// Index of acceleration values from the die characteristic
  static const int gattAccelerometerIndex = 7;

  // Index of characteristic for sending specific commands to
  static const int gattCommandIndex = 8;

  /// Index of current state of charge of the capacitor in the die
  static const int gattCapStateIndex = 9;

  /// GATT command that restart dice
  static const int gattCommandRestart = 0;

  /// GATT command that factory resets dice
  static const int gattCommandClearMemory = 1;

  /// GATT command that will disable dock connection detection
  static const int gattCommandDisableDockConn = 2;

  /// GATT command that will enable dock connection detection
  static const int gattCommandEnableDockConn = 3;

  /// Divisor to convert acceleration value to gs
  static const int accelerometerDivisor = 1024;

  /// Available LED blink modes for die sides
  static List<LedModeListModel> ledModes = [
    LedModeListModel(name: "Off", value: LedModeBaseModel.ledOffValue),
    LedModeListModel(name: "Slow", value: LedModeBaseModel.ledSlowBlinkValue),
    LedModeListModel(name: "Normal", value: LedModeBaseModel.ledNormalBlinkValue),
    LedModeListModel(name: "Fast", value: LedModeBaseModel.ledFastBlinkValue),
  ];

  /// Available sensitivities
  static List<SensitivityListModel> sensitivities = [
    SensitivityListModel(name: "Low", value: SensitivityBaseModel.sensitivityLowValue),
    SensitivityListModel(name: "Medium", value: SensitivityBaseModel.sensitivityMediumValue),
    SensitivityListModel(name: "High", value: SensitivityBaseModel.sensitivityHighValue),
  ];

  /// ID of advertisement message from its manufacturer data
  static int idFromMfgData(Map<int, List<int>> mfgData) {
    if (mfgData.isEmpty || mfgData[mfgData.keys.first] == null || mfgData[mfgData.keys.first]!.isEmpty) return 0;
    return mfgData[mfgData.keys.first]![0].toUnsigned(8);
  }

  /// Type of advertisement message from its manufacturer data
  static int messageTypeFromMfgData(Map<int, List<int>> mfgData) {
    if (mfgData.isEmpty || mfgData[mfgData.keys.first] == null || mfgData[mfgData.keys.first]!.length < 2) return 0;
    return mfgData[mfgData.keys.first]![1].toUnsigned(8);
  }

  /// Message content of advertisement message from its manufacturer data
  static int messageFromMfgData(Map<int, List<int>> mfgData) {
    if (mfgData.isEmpty || mfgData[mfgData.keys.first] == null || mfgData[mfgData.keys.first]!.length < 4) return 0;
    return (
      mfgData[mfgData.keys.first]![2] | 
      mfgData[mfgData.keys.first]![3] >> 8
    ).toUnsigned(16);
  }

  /// Capacitor state, mapped to 0% - 100% from advertisement message or capacitor state characteristic
  static double capStateFromMessage(int message) {
    return max(0, ((((message - messageCapStateMin) / (messageCapStateMax - messageCapStateMin))) * 100));
  }

  /// Create header update from given parameters and return list of integers that represent individual bytes
  static List<int> updateHeaderInBytes(GattUpdateAction action, int diceId, int sideIndex, Updatable? data) {
    List<int> outputByte = [
      action.index, 
      diceId, 
      sideIndex
    ];

    if (data != null) outputByte.addAll(data.toUpdateByteArray());
    return outputByte;
  }

  /// Get acceleration vector from message, this will return a list with three integers - [x, y, z]
  static List<int> accStateFromMessage(List<int> byteArray) {
    if (byteArray.length != 6) {
      print("input not valid: ${byteArray.toString()}");
      
      return [0, 0, 0];
    }

    List<int> outputAccValues = [];
    for (int i = 0; i < 6; i +=2) {
      outputAccValues.add(((byteArray[i + 1]).toUnsigned(8) << 8 | byteArray[i].toUnsigned(8)).toSigned(16));
    }

    return outputAccValues;
  }

  /// Read given characteristic at [characteristicIndex] from given service at [serviceIndex]
  /// from given [device]. Returns GattResultRead, that has success flag and data field
  static Future<GattResultRead> readGATTCharacteristic(BluetoothDevice device, int serviceIndex, int characteristicIndex, {int timeout = 15}) async {
    if (device.isDisconnected) return GattResultRead(successful: false, data: []);
    
    try {
      return GattResultRead(
        successful: true, 
        data: await device.servicesList[serviceIndex].characteristics[characteristicIndex].read(timeout: timeout)
      );

    } catch (error) {
      print("Reading of characteristic $characteristicIndex from service $serviceIndex failed: \n\n ${error.toString()}");
      return GattResultRead(
        successful: false, 
        data: []
      );
    }
  } 

  /// Write given [data] to characteristic at [characteristicIndex] in service with index [serviceIndex] in a [device]
  static Future<GattResultWrite> writeGATTCharacteristic(BluetoothDevice device, int serviceIndex, int characteristicIndex, List<int> data, {int timeout = 15, bool ignoreErrors = false}) async {
    if (device.isDisconnected) return GattResultWrite(successful: false);

    try {
      await device.servicesList[serviceIndex].characteristics[characteristicIndex].write(data, timeout: timeout);
      return GattResultWrite(
        successful: true, 
      );

    } catch (error) {
      if (ignoreErrors) {
        return GattResultWrite(
          successful: true, 
        ); 
      }

      print("Writing to characteristic $characteristicIndex from service $serviceIndex with data: ${data.toString()} failed: \n\n ${error.toString()}");
      return GattResultWrite(
        successful: false, 
      );
    }
  }

  // ================================================================================================================
  // Support functions for reading specific dice parameters. They either return the value or null if the read failed

  /// Read side blink value from [device] and return it if successful, otherwise null will be returned
  static Future<bool?> readSideBlink(BluetoothDevice device) async {
    GattResultRead result = await LPEDBluetooth.readGATTCharacteristic(device, gattServiceIndex, gattSideBlinkIndex);
  
    return result.successful ? result.data[0] == 1 : null;
  }

  /// Read error blink value from [device] and return it if successful, otherwise null will be returned
  static Future<bool?> readErrorBlink(BluetoothDevice device) async {
    GattResultRead result = await LPEDBluetooth.readGATTCharacteristic(device, gattServiceIndex, gattErrorBlinkIndex);
    return result.successful ? result.data[0] == 1 : null;
  }

  /// Read current profile ID from [device] and return it if successful, otherwise null will be returned
  static Future<int?> readCurrentDiceID(BluetoothDevice device) async {
    GattResultRead result = await LPEDBluetooth.readGATTCharacteristic(device, gattServiceIndex, gattCurrentDiceDefinitionIDIndex);
    return result.successful ? result.data[0] : null;
  }

  /// Read currently selected profile from [device] and return it if successful, otherwise null will be returned
  static Future<DiceDefinitionDetailModel?> readCurrentDiceDefinition(BluetoothDevice device) async {
    GattResultRead result = await LPEDBluetooth.readGATTCharacteristic(device, gattServiceIndex, gattDiceDefinitionIndex);
    return result.successful ? DiceDefinitionDetailModel.fromIntList(result.data) : null;
  }

  /// Read headers of all supported profiles from [device] and return it if successful, otherwise null will be returned
  static Future<List<DiceDefinitionListModel>?> readSupportedDiceDefinitions(BluetoothDevice device) async {
    List<DiceDefinitionListModel> supportedDiceDefs = [];
    GattResultWrite writeResult;
    GattResultRead readResult = await LPEDBluetooth.readGATTCharacteristic(device, gattServiceIndex, gattSupportedDiceDefinitionIDsIndex);
    if (!readResult.successful) return null;

    readResult.data.removeWhere((id) {return id == 0;});  // Remove all 0, which are empty IDs

    for (int id in readResult.data) {
      writeResult = await LPEDBluetooth.writeGATTCharacteristic(device, gattServiceIndex, gattSelectedDiceListDefinitionIndex, [id]);
      if (!writeResult.successful) return null;

      readResult = await LPEDBluetooth.readGATTCharacteristic(device, gattServiceIndex, gattSelectedDiceListDefinitionIndex);
      if (!readResult.successful) return null;

      supportedDiceDefs.add(DiceDefinitionListModel.fromIntList(readResult.data));
    }

    return supportedDiceDefs;
    
  }

  /// Read side blink value from [device] and return it if successful, otherwise null will be returned
  static Future<double?> readCapState(BluetoothDevice device) async {
    GattResultRead result = await LPEDBluetooth.readGATTCharacteristic(device, gattServiceIndex, gattCapStateIndex);
    if (!result.successful) return null;
  
    return LPEDBluetooth.capStateFromMessage(result.data[0]);
  }

  /// Read acceleration vector from [device] and return it if successful, otherwise null will be returned
  static Future<List<int>?> readAccelerometerValues(BluetoothDevice device) async {
    GattResultRead result = await LPEDBluetooth.readGATTCharacteristic(device, gattServiceIndex, gattAccelerometerIndex);
    if (!result.successful) return null;

    return accStateFromMessage(result.data);
  }

  // ========================================================================================================================
  // Support function for writing specific dice parameters, they return either true, if no error occurred, or false otherwise

  /// Write new side blink value [blink] to [device], return true if error occurred, otherwise false
  static Future<bool> writeSideBlink(BluetoothDevice device, bool blink) async {
    GattResultWrite result = await LPEDBluetooth.writeGATTCharacteristic(device, gattServiceIndex, gattSideBlinkIndex, [blink ? 1 : 0]);
    return result.successful;
  } 

  /// Write new error blink value [blink] to [device], return true if error occurred, otherwise false
  static Future<bool> writeErrorBlink(BluetoothDevice device, bool blink) async {
    GattResultWrite result = await LPEDBluetooth.writeGATTCharacteristic(device, gattServiceIndex, gattErrorBlinkIndex, [blink ? 1 : 0]);
    return result.successful;
  }

  /// Change selected profile by writing new ID with value [id] to [device], return true if error occurred, otherwise false
  static Future<bool> writeCurrentDiceID(BluetoothDevice device, int id) async {
    if (id == 0) return false;

    GattResultWrite result = await LPEDBluetooth.writeGATTCharacteristic(device, gattServiceIndex, gattCurrentDiceDefinitionIDIndex, [id]);
    return result.successful;
  }

  /// Add new dice profile [newDefinition] to [device], return true if error occurred, otherwise false
  static Future<bool> writeAddDiceDefinition(BluetoothDevice device, DiceDefinitionDetailModel newDefinition) async {
    GattResultWrite result = await LPEDBluetooth.writeGATTCharacteristic(
      device, 
      gattServiceIndex, 
      gattUpdateIndex, 
      updateHeaderInBytes(
        GattUpdateAction.diceDefinitionAdd, 
        newDefinition.id, 
        0, 
        newDefinition
      )
    );

    return result.successful;
  }

  /// Delete dice profile with ID [definitionID] from [device], return true if error occurred, otherwise false
  static Future<bool> writeDeleteDiceDefinition(BluetoothDevice device, int definitionID) async {
    GattResultWrite result = await LPEDBluetooth.writeGATTCharacteristic(
      device, 
      gattServiceIndex, 
      gattUpdateIndex, 
      updateHeaderInBytes(
        GattUpdateAction.diceDefinitionDelete, 
        definitionID, 
        0, 
        null
      )
    );

    return result.successful;
  }

  /// Update existing dice profile [updatedDefinition] in [device], return true if error occurred, otherwise false
  static Future<bool> writeUpdateDiceDefinition(BluetoothDevice device, DiceDefinitionListModel updatedDefinition) async {
    GattResultWrite result = await LPEDBluetooth.writeGATTCharacteristic(
      device, 
      gattServiceIndex, 
      gattUpdateIndex, 
      updateHeaderInBytes(
        GattUpdateAction.diceDefinitionUpdate, 
        updatedDefinition.id, 
        0, 
        updatedDefinition
      )
    );

    return result.successful;
  }

  /// Add new side to profile with id [diceDefinitionID] in [device], return true if error occurred, otherwise false
  static Future<bool> writeAddSideDefinition(BluetoothDevice device, int diceDefinitionID, SideDefinitionListModel newSideDefinition) async {
    GattResultWrite result = await LPEDBluetooth.writeGATTCharacteristic(
      device, 
      gattServiceIndex, 
      gattUpdateIndex, 
      updateHeaderInBytes(
        GattUpdateAction.sideDefinitionAdd, 
        diceDefinitionID, 
        0, 
        newSideDefinition
      )
    );

    return result.successful;
  }

  /// Delete side with index [sideDefinitionIndex] from profile with id [diceDefinitionID] in [device], return true if error occurred, otherwise false
  static Future<bool> writeDeleteSideDefinition(BluetoothDevice device, int diceDefinitionID, int sideDefinitionIndex) async {
    GattResultWrite result = await LPEDBluetooth.writeGATTCharacteristic(
      device, 
      gattServiceIndex, 
      gattUpdateIndex, 
      updateHeaderInBytes(
        GattUpdateAction.sideDefinitionDelete, 
        diceDefinitionID, 
        sideDefinitionIndex, 
        null
      )
    );

    return result.successful;
  }

  /// Update [sideDefinition] with index [sideDefinitionIndex] in profile with id [diceDefinitionID] in [device], return true if error occurred, otherwise false
  static Future<bool> writeUpdateSideDefinition(BluetoothDevice device, int diceDefinitionID, int sideDefinitionIndex, SideDefinitionListModel sideDefinition) async {
    GattResultWrite result = await LPEDBluetooth.writeGATTCharacteristic(
      device, 
      gattServiceIndex, 
      gattUpdateIndex, 
      updateHeaderInBytes(
        GattUpdateAction.sideDefinitionUpdate, 
        diceDefinitionID, 
        sideDefinitionIndex, 
        sideDefinition
      )
    );

    return result.successful;
  }

  /// Execute [command] in [device], return true if error occurred, otherwise false
  static Future<bool> writeCommand(BluetoothDevice device, int command) async {
    if (command == gattCommandRestart) {
      await writeGATTCharacteristic(device, gattServiceIndex, gattCommandIndex, [command], timeout: 1, ignoreErrors: true);
      return true;
    }

    GattResultWrite result = await writeGATTCharacteristic(device, gattServiceIndex, gattCommandIndex, [command]);
    return result.successful;
  }
}


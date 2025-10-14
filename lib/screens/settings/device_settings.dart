//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		15-04-2025 18:38:25
//  Modified time: 	13-05-2025 22:10:50
//  Description: 		This file contains the device settings page, that displays the general and profile subsections
//


import 'dart:async';

import 'package:app/models/device/device_list.dart';
import 'package:app/models/dice_definition/dice_definition_base.dart';
import 'package:app/models/dice_definition/dice_definition_detail.dart';
import 'package:app/models/dice_definition/dice_definition_list.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/devices/devices.dart';
import 'package:app/screens/settings/flows/add_dice_definition/add_dice_definition_flow.dart';
import 'package:app/screens/settings/flows/add_side_definition/add_side_definition_flow.dart';
import 'package:app/global/history_dialog/clear_history_confirmation/clear_history_confirmation_flow.dart';
import 'package:app/screens/settings/flows/command_clear_memory/command_clear_memory_flow.dart';
import 'package:app/screens/settings/flows/command_restart/command_restart_flow.dart';
import 'package:app/screens/settings/flows/data_loading_failed/data_loading_failed_flow.dart';
import 'package:app/screens/settings/flows/delete_dice_definition/delete_dice_definition_flow.dart';
import 'package:app/screens/settings/flows/delete_side_definition/delete_side_definition_flow.dart';
import 'package:app/screens/settings/flows/update_side_definition/update_side_definition_flow.dart';
import 'package:app/screens/settings/sections/general/general_section.dart';
import 'package:app/screens/settings/sections/loading_section.dart';
import 'package:app/screens/settings/sections/profile/profile_section.dart';
import 'package:app/screens/settings/sections/settings_page_wrapper.dart';
import 'package:app/services/bluetooth/bluetooth.dart';
import 'package:app/services/storage.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// This class represents the device settings page and displays the general and profile subsections
class DeviceSettingsPage extends StatefulWidget {
  final DeviceListModel device;
  final Function closedCallback;

  const DeviceSettingsPage({super.key, required this.device, required this.closedCallback});
  DeviceSettingsPage.fromMac({super.key, required String mac, required this.closedCallback}) : device = Storage().getDeviceListModelByMac(mac)!;

  @override
  State<DeviceSettingsPage> createState() => _DeviceSettingsPageState();
}

class _DeviceSettingsPageState extends State<DeviceSettingsPage>{

  // Bluetooth status helper variables
  bool _connecting = true;
  String _statusMessage = "Searching for device";
  StreamSubscription<BluetoothAdapterState>? _bluetoothAdapterState;
  StreamSubscription<BluetoothConnectionState>? _connectionState;
  StreamSubscription<List<ScanResult>>? _scan;
  late BluetoothDevice _bluetoothDevice;

  // Dice parameters
  late bool _sideBlink;
  late bool _errorBlink;
  late bool _commMode;
  late List<DiceDefinitionListModel> _supportedDiceProfiles;
  late int _currentProfileID;
  late DiceDefinitionDetailModel _currentProfile;

  int _trigger = 0; // Used to change page to profile settings
  Timer? _capStateTimer; // for periodic cap state check

  /// Change dice name to [newName]
  void _setDeviceName(String newName) {
    setState(() => widget.device.name = newName);
    Storage().saveDevice(widget.device);
  }

  /// Change side blink setting to [newBlink]
  void _setSideBlink(bool newBlink) {
    LPEDBluetooth.writeSideBlink(_bluetoothDevice, newBlink).then((result) {
      if (result) {
        setState(() => _sideBlink = newBlink);
      }
      else {
        _exitWithError("Failed to change value of side blink");
      }
    });
  }

  /// Change error blink setting to [newBlink]
  void _setErrorBlink(bool newBlink) {
    LPEDBluetooth.writeErrorBlink(_bluetoothDevice, newBlink).then((result) {
      if (result) {
        setState(() => _errorBlink = newBlink);
      }
      else {
        _exitWithError("Failed to change value of side blink");
      }
    });
  }

  /// Change communication mode setting to [newComm]
  void _setCommMode(bool newComm) {
    LPEDBluetooth.writeCommMode(_bluetoothDevice, newComm).then((result) {
      if (result) {
        setState(() => _commMode = newComm);
      }
      else {
        _exitWithError("Failed to change value of side blink");
      }
    });
  }

  /// Select new profile with id [newID] as the current one
  void _setCurrentProfileID(int newID) {
    LPEDBluetooth.writeCurrentDiceID(_bluetoothDevice, newID).then((result) {
      if (result) {
        setState(() => _currentProfileID = newID);
        _getCurrentProfile();
      }
      else {
        _exitWithError("Failed to select new profile");
      }
    });
  }

  /// Display the factory reset flow, and if confirmed, erase all data from the dice
  void _factoryResetCommand() {
    showCommandClearMemoryDialog(
      context, 
      widget.device, 
      () async {
        var result = await LPEDBluetooth.writeCommand(_bluetoothDevice, LPEDBluetooth.gattCommandClearMemory);
        if (!result) {
          _exitWithError("Failed to factory reset ${widget.device.name}");
          return;
        }
        _reloadCommand();
        if (mounted) Navigator.of(context).pop();
      } 
    );
  }

  /// Reload all data from the dice
  void _reloadCommand() {
    _loadData().then((_) => Fluttertoast.showToast(msg: "Data reloaded"));
  }

  /// Display the restart flow and if confirmed, restart the dice
  void _restartCommand() {
    showCommandRestartDialog(
      context, 
      widget.device, 
      () async {
        Navigator.of(context).pop();
        var result = await LPEDBluetooth.writeCommand(_bluetoothDevice, LPEDBluetooth.gattCommandRestart);
        if (!result) {
          _exitWithError("Failed to restart ${widget.device.name}");
          return;
        }
      } 
    );
  }

  /// Get acceleration values from dice
  Future<List<int>> _getVector() async {
    var result = await LPEDBluetooth.readAccelerometerValues(_bluetoothDevice);
    if (result == null) {
      _exitWithError("Could not read acceleration vector");
      return [0, 0, 0];
    }

    return result;
  }

  /// Display the create new profile dialog
  void _startCreatingNewProfile() {
    if (_supportedDiceProfiles.length >= DiceDefinitionBaseModel.diceDefinitionsMax) {
      Fluttertoast.showToast(msg: "Profile limit reached, delete a profile to add a new one");
      return;
    }
    showAddDiceDefinitionDialog(
      context, 
      (newProfile) {
        Navigator.of(context).pop();
        _addNewProfile(newProfile);
      }, 
      _getVector
    );
  }

  /// Add [newProfile] to the dice and refresh the supported profiles
  void _addNewProfile(DiceDefinitionDetailModel newProfile) async {
    var supportedProfilesOriginal = List<DiceDefinitionListModel>.from(_supportedDiceProfiles);
    newProfile.numberOfSides = 0;

    // Write basic profile information
    var result = await LPEDBluetooth.writeAddDiceDefinition(_bluetoothDevice, newProfile);
    if (!result) {
      Fluttertoast.showToast(msg: "Failed to add your new profile ${newProfile.name}");
      return;
    }

    // Get new profile id by getting all supported profiles first, and then
    // removing all previously existing profiles, resulting in only
    // the new profile with an id
    await _getSupportedProfiles();
    var supportedProfilesNew = List<DiceDefinitionListModel>.from(_supportedDiceProfiles);
    supportedProfilesNew.removeWhere(
      (newSuppProf) => supportedProfilesOriginal.any(
        (origSuppProf) => origSuppProf.id == newSuppProf.id
      )
    );
    var newProfileID = supportedProfilesNew.first.id;

    // Add all sides to the profile
    for (var side in newProfile.sides) {
      result = await LPEDBluetooth.writeAddSideDefinition(
        _bluetoothDevice, 
        newProfileID, 
        side
      );

      if (!result) {
        Fluttertoast.showToast(msg: "Failed to add side to your new profile ${newProfile.name}");
        return;
      }
    }

    await _getSupportedProfiles();
  }

  /// Select the profile with id [profileID] and switch to profile subpage
  void _editProfile(int profileID) async {
    Fluttertoast.showToast(msg: "Loading data for selected profile");
    LPEDBluetooth.writeCurrentDiceID(_bluetoothDevice, profileID).then((result) async {
      if (result) {
        setState(() => _currentProfileID = profileID);
        var newResult = await _getCurrentProfile();
        if (newResult) {
          Fluttertoast.showToast(msg: "Failed to load selected profile");
          return;
        }
        setState(() => _trigger += 1);
      }
      else {
        Fluttertoast.showToast(msg: "Failed to select new profile");
      }
    });
  }

  /// Display the delete profile flow for profile with ID [profileID]
  void _startDeletingProfile(int profileID) {
    if (profileID == _currentProfileID) {
      Fluttertoast.showToast(msg: "You cannot delete profile if it is the currently selected one");
      return;
    }

    showDeleteDiceDefinitionDialog(
      context, 
      widget.device, 
      _supportedDiceProfiles.firstWhere((profile) => profile.id == profileID), 
      () {
        Navigator.of(context).pop();
        _deleteProfile(profileID);
      }
    );
  }

  /// Delete profile with id [profileID] from the dice and refresh the supported profiles
  void _deleteProfile(int profileID) async {
    setState(() => _supportedDiceProfiles.removeWhere((profile) => profile.id == profileID));

    var result = await LPEDBluetooth.writeDeleteDiceDefinition(_bluetoothDevice, profileID);
    if (!result) {
      Fluttertoast.showToast(msg: "Failed to delete a profile");
    }

    await _getSupportedProfiles();
  }

  /// Change name of [profile] to [newName] and refresh the selected profile and supported profiles
  void _renameProfile(DiceDefinitionListModel profile, String newName) async {
    DiceDefinitionListModel newProfile = profile;
    newProfile.name = newName;
    var result = await LPEDBluetooth.writeUpdateDiceDefinition(_bluetoothDevice, profile);
    if (!result) {
      Fluttertoast.showToast(msg: "Failed to rename profile ${profile.name}");
      return;
    }

    await _getSupportedProfiles();
    if (profile.id == _currentProfileID) await _getCurrentProfile();
  }

  /// Change sensitivity of [profile] to [newSensitivity] and refresh the selected profile and supported profiles
  void _setProfileSensitivity(DiceDefinitionDetailModel profile, int newSensitivity) async {
    setState(() => profile.range = newSensitivity);

    var result = await LPEDBluetooth.writeUpdateDiceDefinition(_bluetoothDevice, profile);
    if (!result) {
      Fluttertoast.showToast(msg: "Failed to change sensitivity for profile ${profile.name}");
      return;
    }

    await _getSupportedProfiles();
    if (profile.id == _currentProfileID) await _getCurrentProfile();
  }

  /// Display the add side to [profile] flow
  void _startAddingSideToProfile(DiceDefinitionDetailModel profile) {
    showAddSideDefinitionDialog(
      context, 
      profile, 
      _addSideToProfile, 
      _getVector
    );
  }

  /// Add [side] to [profile] and refresh the selected profile and supported profiles
  void _addSideToProfile(DiceDefinitionDetailModel profile, SideDefinitionListModel side) async {
    setState(() => profile.sides.add(side));

    var result = await LPEDBluetooth.writeAddSideDefinition(_bluetoothDevice, profile.id, side);
    if (!result) {
      Fluttertoast.showToast(msg: "Failed to add side to profile ${profile.name}");
      return;
    }

    if (mounted) Navigator.of(context).pop();
    await _getSupportedProfiles();
    if (profile.id == _currentProfileID) await _getCurrentProfile();
  }

  /// Display the flow for deleting side at [sideIndex] from [profile]
  void _startDeletingSideFromProfile(DiceDefinitionDetailModel profile, int sideIndex) {
    showDeleteSideDefinitionDialog(
      context, 
      widget.device, 
      profile.sides[sideIndex], 
      profile, 
      () => _deleteSideFromProfile(profile, sideIndex)
    );
  }

  /// Delete side at [sideIndex] inside [profile] and refresh the selected profile and supported profiles
  void _deleteSideFromProfile(DiceDefinitionDetailModel profile, int sideIndex) async {
    Navigator.of(context).pop();
    setState(() => _currentProfile.sides.removeAt(sideIndex));

    var result = await LPEDBluetooth.writeDeleteSideDefinition(_bluetoothDevice, profile.id, sideIndex);
    if (!result) {
      Fluttertoast.showToast(msg: "Failed to delete side from profile ${profile.name}");
      return;
    }

    _getSupportedProfiles();
    if (profile.id == _currentProfileID) await _getCurrentProfile();
  }

  /// Change number to [newNumber] for side at [sideIndex] inside [profile] and refresh the selected profile and supported profiles
  void _setSideNumber(DiceDefinitionDetailModel profile, int sideIndex, int newNumber) async {
    setState(() => profile.sides[sideIndex].number = newNumber);

    var result = await LPEDBluetooth.writeUpdateSideDefinition(_bluetoothDevice, profile.id, sideIndex, profile.sides[sideIndex]);
    if (!result) {
      Fluttertoast.showToast(msg: "Failed to change number");
      return;
    }

    _getSupportedProfiles();
    if (profile.id == _currentProfileID) await _getCurrentProfile();
  }

  /// Display the edit vector flow for side at [sideIndex] inside [profile]
  void _startChangingSideVector(DiceDefinitionDetailModel profile, int sideIndex) {
    showUpdateSideDefinitionDialog(
      context, 
      profile.sides[sideIndex], 
      _getVector, 
      (newSide) {
        _changeSideVector(profile, newSide, sideIndex);
        Navigator.of(context).pop();
      },
      () {
        _getCurrentProfile();
        Navigator.of(context).pop();
      }
    );
  }

  /// Update [newSide] at [sideIndex] inside [profile] and refresh the selected profile and supported profiles
  void _changeSideVector(DiceDefinitionDetailModel profile, SideDefinitionListModel newSide, int sideIndex) async {
    setState(() => profile.sides[sideIndex] = newSide);

    var result = await LPEDBluetooth.writeUpdateSideDefinition(_bluetoothDevice, profile.id, sideIndex, profile.sides[sideIndex]);
    if (!result) {
      Fluttertoast.showToast(msg: "Failed to change vector");
      return;
    }

    _getSupportedProfiles();
    if (profile.id == _currentProfileID) await _getCurrentProfile();
  }

  /// Display the data loading failed flow, which will ask user for factory reset
  Future<void> _dataLoadingFailed() async {
    await showDataLoadingFailedDialog(
      context, 
      widget.device, 
      () async {
        var result = await LPEDBluetooth.writeCommand(_bluetoothDevice, LPEDBluetooth.gattCommandClearMemory);
        if (!result) {
          _exitWithError("Failed to factory reset ${widget.device.name}");
          return;
        }
      },
      () => _exitWithError("${widget.device.name} disconnected")
    );
  }

  /// Get side blink from device and update the value
  Future<bool> _getSideBlink() async {
    var result = await LPEDBluetooth.readSideBlink(_bluetoothDevice);
    if (result == null) {
      return true;
    }
    setState(() => _sideBlink = result);
    return false;
  }

  /// Get error blink from device and update the value
  Future<bool> _getErrorBlink() async {
    var result = await LPEDBluetooth.readErrorBlink(_bluetoothDevice);
    if (result == null) {
      return true;
    }
    setState(() => _errorBlink = result);
    return false;
  }

  /// Get communication mode from device and update the value
  Future<bool> _getCommMode() async {
    var result = await LPEDBluetooth.readCommMode(_bluetoothDevice);
    if (result == null) {
      return true;
    }
    setState(() => _commMode = result);
    return false;
  }

  /// Get currently selected profile ID and update the value
  Future<bool> _getCurrentProfileID() async {
    var result = await LPEDBluetooth.readCurrentDiceID(_bluetoothDevice);
    if (result == null) {
      return true;
    }
    setState(() => _currentProfileID = result);
    return false;
  }

  /// Get list of headers of all available profiles and update the value
  Future<bool> _getSupportedProfiles() async {
    var result = await LPEDBluetooth.readSupportedDiceDefinitions(_bluetoothDevice);
    if (result == null) {
      return true;
    }
    setState(() => _supportedDiceProfiles = result);
    return false;
  }

  /// Get current profile ID and update the value
  Future<bool> _getCurrentProfile() async {
    var result = await LPEDBluetooth.readCurrentDiceDefinition(_bluetoothDevice);
    if (result == null) {
      return true;
    }
    setState(() => _currentProfile = result);
    return false;
  }

  /// Clear all recorded logs of landed sides and update the history
  void _clearHistory() {
    showHistoryConfirmationDialog(context, widget.device, () => setState(() => widget.device.history = {}));
  }

  /// Load all data from dice
  Future<void> _loadData() async {
    setState(() => _statusMessage = "Loading data from ${widget.device.name}");

    var result = false;

    do {
      result = await _getSideBlink();
      result |= await _getErrorBlink();
      result |= await _getCommMode();
      result |= await _getCurrentProfileID();
      result |= await _getSupportedProfiles();
      result |= await _getCurrentProfile();
      result |= !(await LPEDBluetooth.writeCommand(_bluetoothDevice, LPEDBluetooth.gattCommandDisableDockConn));

      if (result) {
        await _dataLoadingFailed();
      }

      // Start periodic function for capacitor state 
      _capStateTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
        var newCapState = await LPEDBluetooth.readCapState(_bluetoothDevice);
        if (newCapState != null) {
          
          // Only save cap state if it was acquired outside of the charging station
          if (newCapState < 87) {
            widget.device.capState = newCapState;
            Storage().saveDevice(widget.device);
          }
        
          if (newCapState < 15) {
            Fluttertoast.showToast(
              msg: "${widget.device.name} has a low battery, please put it in charging dock",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              textColor: errorTextStyle.color
            );
          }
        }
      });

    } while (result);
  }

  /// Exit the settings and show message to user
  void _exitWithError(String errorMessage) {
    if (!mounted) return;
    Fluttertoast.showToast(msg: errorMessage);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => DevicesPage()),
    );
  }

  /// Start searching for dice with the required MAC address
  void _startScan() {
    FlutterBluePlus.startScan(
      timeout: Duration(minutes: 5),
      withRemoteIds: [widget.device.mac],
      continuousUpdates: true,
      removeIfGone: Duration(seconds: 1),
    );

    _scan = FlutterBluePlus.onScanResults.listen((results) => _connectToDevice(results));
  }

  // Stop scan and any other state listeners
  void _stopScan() {
    if (FlutterBluePlus.isScanningNow && _scan != null) FlutterBluePlus.cancelWhenScanComplete(_scan!);
    if (_bluetoothAdapterState != null) _bluetoothAdapterState!.cancel();
    if (_connectionState != null) {
      _bluetoothDevice.disconnect();
      _connectionState!.cancel();
    }
    if (_capStateTimer != null) _capStateTimer!.cancel();
  }

  /// Connect to found device
  void _connectToDevice(List<ScanResult> results) {
    if (results.isEmpty || !mounted) return;

      for (ScanResult result in results) {
        if (result.advertisementData.connectable) {
          // try to connect to the first device with the correct MAC and connectable advertisement
          setState(() => _statusMessage = "Connecting to ${widget.device.name}");
          result.device.connect(timeout: Duration(seconds: 15))
          .then((value) {
            if (results[0].device.isConnected) {  
              _bluetoothDevice = results[0].device;
              
              // Create listener for the connection state, so that the settings page
              // can be closed when dice disconnects
              _connectionState = _bluetoothDevice.connectionState.listen((state) {
                if (state == BluetoothConnectionState.disconnected) {
                  _exitWithError("${widget.device.name} disconnected");
                }
              });

              // Try to load services
              _bluetoothDevice.discoverServices(timeout: 15)
              .then((value) {
                if (value.length < LPEDBluetooth.gattDiceServiceIndex) {
                  _exitWithError("Connection to ${widget.device.name} failed!");
                }
                else {
                  // Load all data
                   _loadData().then((_) => setState(() => _connecting = false));
                  } 
              });
            }
            else {
              _exitWithError("Connection to ${widget.device.name} failed!");
            }
          });
          break;
        }
      }
  }

  @override
  void initState() {
    setState(() => _statusMessage = "Searching for ${widget.device.name}");

    _bluetoothAdapterState = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on)  {_startScan();}
      else                                    {_stopScan();}
    });

    // Check if bluetooth is turned on
    // If yes, start scanning immediately 
    if (FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on) {_startScan();}

    // If not, try to turn it on
    else {FlutterBluePlus.turnOn();}

    super.initState();
  }

  @override
  void dispose() {
    _stopScan();
    widget.closedCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_connecting) {
      return LoadingSection(statusMessage: _statusMessage);
    }

    else {
      return SettingsPageWrapper(
        triggerCounter: _trigger,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.settings_applications), 
            label: "General"
          ),
          NavigationDestination(
            icon: Icon(Icons.tune), 
            label: "Profile"
          ),
        ], 
        pages: [
          GeneralSection(
            deviceMac: widget.device.mac,
            history: widget.device.history,
            deviceName: widget.device.name, 
            sideBlink: _sideBlink, 
            errorBlink: _errorBlink, 
            commMode: _commMode,
            supportedProfiles: _supportedDiceProfiles, 
            currentProfileID: _currentProfileID, 
            changeDeviceName: _setDeviceName, 
            sideBlinkChanged: _setSideBlink, 
            errorBlinkChanged: _setErrorBlink, 
            commModeChanged: _setCommMode,
            selectDiceProfile: _setCurrentProfileID, 
            commandRestart: _restartCommand, 
            commandFactoryReset: _factoryResetCommand, 
            commandReload: _reloadCommand, 
            addDiceProfile: _startCreatingNewProfile, 
            editDiceProfile: _editProfile, 
            deleteDiceProfile: _startDeletingProfile, 
            renameDiceProfile: _renameProfile,
            clearHistoryCallback: _clearHistory,
          ),
          ProfileSection(
            profile: _currentProfile, 
            changeProfileName: _renameProfile, 
            changeSensitivity: _setProfileSensitivity, 
            addSide: _startAddingSideToProfile, 
            deleteSide: _startDeletingSideFromProfile,
            changeSideNumber: _setSideNumber, 
            changeSideVector: _startChangingSideVector
          )
        ]
      );
    } 
  }

}
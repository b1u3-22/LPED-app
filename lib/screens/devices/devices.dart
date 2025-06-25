//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		13-05-2025 16:09:21
//  Modified time: 	14-05-2025 00:17:20
//  Description: 		This file contains the devices page, that displays saved devices and allows for additions of new ones
//

import 'package:app/screens/devices/sections/device_card.dart';
import 'package:app/models/device/device_list.dart';
import 'package:app/screens/devices/flows/discovery_flow/discovery_dialog_flow.dart';
import 'package:app/services/storage.dart';
import 'package:flutter/material.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage>{
  List<DeviceListModel> devices = Storage().getAllDevicesListModels();

  /// Open the discovery dialog for adding new devices
  void _openDiscoveryDialog() {
    showDiscoveryDialog(context)
    .then((_) {
      setState(() {
        devices = Storage().getAllDevicesListModels();
      });
    });
  }

  /// Update devices upon change from other pages
  void _devicesChanged() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          devices = Storage().getAllDevicesListModels();
        });
      });
  }

  /// Change the dice name and save it
  void _changeDeviceName(DeviceListModel device, String newName) {
    setState(() => device.name = newName);
    Storage().saveDevice(device);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        onPressed: _openDiscoveryDialog,
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.center,
              direction: Axis.horizontal,
              children: [
                for (DeviceListModel device in devices)
                  DeviceCard(
                    name: device.name,
                    mac: device.mac,
                    capState: device.capState,
                    lastMes: device.lastMes,
                    history: device.history,
                    deleteCallback: _devicesChanged,
                    settingsClosedCallback: _devicesChanged,
                    historyCleared: _devicesChanged,
                    changeName: (newName) => _changeDeviceName(device, newName),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
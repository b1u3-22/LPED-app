//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		15-04-2025 18:38:25
//  Modified time: 	14-05-2025 00:37:45
//  Description: 		This file contains the list of found devices in the discovery dialog
//

import 'package:app/models/device/device_discovery.dart';
import 'package:app/screens/devices/flows/discovery_flow/sections/device_row.dart';
import 'package:flutter/material.dart';

class DiscoveryDialogFoundDevices extends StatelessWidget {
  final List<DeviceDiscoveryModel> devices;

  const DiscoveryDialogFoundDevices({super.key, required this.devices});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [for (DeviceDiscoveryModel device in devices) 
        DeviceDiscoveryRow(name: device.name, rssi: device.rssi, mac: device.mac)]
    );
  }

}
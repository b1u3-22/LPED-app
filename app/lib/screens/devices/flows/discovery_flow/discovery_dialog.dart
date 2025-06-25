//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		15-04-2025 18:38:25
//  Modified time: 	14-05-2025 00:36:06
//  Description: 		This file contains the discovery dialog for adding new devices
//

import 'package:app/global/dialog_base.dart';
import 'package:app/models/device/list_of_device_discovery.dart';
import 'package:app/screens/devices/flows/discovery_flow/sections/actions/close.dart';
import 'package:app/screens/devices/flows/discovery_flow/sections/found.dart';
import 'package:app/screens/devices/flows/discovery_flow/sections/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiscoveryDialog extends StatelessWidget {
  final ListOfDeviceDiscoveryModels foundDevices;
  
  const DiscoveryDialog({super.key, required this.foundDevices});

  @override
  Widget build(BuildContext context) {
    return DialogBase(
      title: "Add a new device",
      content: ValueListenableBuilder(
        valueListenable: foundDevices, 
        builder: (context, discoveredDevices, __) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (discoveredDevices.isEmpty)
                DiscoveryDialogLoading()
              else 
                DiscoveryDialogFoundDevices(devices: discoveredDevices)
            ],
          );
        }
      ),
      actions: [
        DiscoveryDialogActionClose()
      ],
    );
  }
}
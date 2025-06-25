//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		15-04-2025 18:38:25
//  Modified time: 	14-05-2025 00:38:08
//  Description: 		This file contains the single row for found devices in the discovery dialog
//

import 'package:app/models/device/device_discovery.dart';
import 'package:app/services/storage.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class DeviceDiscoveryRow extends StatefulWidget {

  final String name;
  final String mac;
  final int rssi;

  const DeviceDiscoveryRow({super.key, required this.name, required this.rssi, required this.mac});

  @override
  State<DeviceDiscoveryRow> createState() => _DeviceDiscoveryRowState();
}

class _DeviceDiscoveryRowState extends State<DeviceDiscoveryRow>{
  bool _added = false;

  void addThisDevice() {
    Storage().saveDevice(DeviceDiscoveryModel(name: widget.name, mac: widget.mac));
    setState(() {
      _added = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.name, style: textStyle),
            Text(widget.mac, style: badgeStyle)
          ],
        ),
        Text("${widget.rssi.toString()}dBm", style: TextStyle()),
        _added  ? Column(
                    children: [
                      Icon(Icons.check), 
                      Text("Added", style: badgeStyle)
                    ]
                  )
                : IconButton(onPressed: addThisDevice, icon: Icon(Icons.add))
      ],
    );
  }
}
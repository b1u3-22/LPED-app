//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		13-05-2025 16:09:22
//  Modified time: 	14-05-2025 00:19:16
//  Description: 		This file contains the device card for devices page. It allows for deletion, showing details and opening settings
//                  It shows the device name, mac, last known cap state and last received status message (from play)
//

import 'package:app/global/history_dialog/clear_history_confirmation/clear_history_confirmation_flow.dart';
import 'package:app/global/history_dialog/history_dialog_flow.dart';
import 'package:app/global/settings_field.dart';
import 'package:app/models/device/device_list.dart';
import 'package:app/screens/devices/flows/delete_device/delete_device_dialog_flow.dart';
import 'package:app/screens/settings/device_settings.dart';
import 'package:app/services/storage.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class DeviceCard extends StatefulWidget {

  final String name;
  final String mac;
  final double capState;
  final DateTime lastMes;
  final Map<String, int> history;
  final Function() deleteCallback;
  final Function() settingsClosedCallback;
  final Function() historyCleared;
  final Function(String newName) changeName;

  const DeviceCard({
    super.key, 
    required this.name, 
    required this.mac, 
    required this.capState, 
    required this.lastMes, 
    required this.history,
    required this.deleteCallback,
    required this.settingsClosedCallback,
    required this.historyCleared,
    required this.changeName
  });
  

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard>{
  /// Delete device from storage, call the devices page update method and exit the delete dialog
  void _delete() {
    Storage().removeDeviceByMac(widget.mac);
    widget.deleteCallback();
    Navigator.of(context).pop();
  }
 
  /// Open dialog for deletion
  void _openDelete() {
    showDeleteDeviceDialog(
      context, 
      widget.name, 
      _delete
    );
  }

  /// Open settings for the device
  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => 
          DeviceSettingsPage.fromMac(
            mac: widget.mac,
            closedCallback: widget.settingsClosedCallback
          )
      )
    );
  }

  /// Open details of the device (name, mac and history)
  void _openDetails() {
    DeviceListModel? device = Storage().getDeviceListModelByMac(widget.mac);
    if (device == null) return; 

    showHistoryDialog(
      context, 
      widget.history, 
      widget.name, 
      widget.mac, 
      () => 
        showHistoryConfirmationDialog(
          context, 
          device, 
          widget.historyCleared
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.battery_4_bar, size: textStyle.fontSize),
                      SizedBox(width: 2,),
                      Text("${widget.capState.round().toString()}%", style: badgeStyle)
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.history, size: textStyle.fontSize),
                      SizedBox(width: 2,),
                      Text(timeago.format(widget.lastMes), style: badgeStyle)
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
              SettingsField(
                prefilled: widget.name, 
                style: heading3Style,
                align: TextAlign.center,
                onSubmitted: widget.changeName,
                verticalAlign: TextAlignVertical.bottom,
              ),
              SizedBox(height: 10),
              Text(widget.mac, style: textStyle, textAlign: TextAlign.center),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: textStyle.fontSize! + 15,
                    height: textStyle.fontSize! + 15,
                    child: IconButton(
                      onPressed: _openSettings, 
                      icon: Icon(Icons.settings), 
                      color: Theme.of(context).colorScheme.tertiary, 
                      iconSize: textStyle.fontSize! + 8, 
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                  SizedBox(
                    width: textStyle.fontSize! + 15,
                    height: textStyle.fontSize! + 15,
                    child: IconButton(
                      onPressed: _openDetails, 
                      icon: Icon(Icons.info), 
                      iconSize: textStyle.fontSize! + 8, 
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                  SizedBox(
                    width: textStyle.fontSize! + 15,
                    height: textStyle.fontSize! + 15,
                    child: IconButton(
                      onPressed: _openDelete, 
                      icon: Icon(Icons.delete), 
                      iconSize: textStyle.fontSize! + 8, 
                      padding: EdgeInsets.all(0),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}
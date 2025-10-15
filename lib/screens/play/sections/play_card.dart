//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		13-05-2025 16:09:21
//  Modified time: 	14-05-2025 00:12:40
//  Description: 		This file contains the play device card that is displayed in the play page
//                  It shows the landed number, or "U" for undefined, or "R" for Rolling
//                  It also has a red border, when battery is below 15%
//

import 'package:app/models/device/device_play.dart';
import 'package:app/screens/play/flows/play_menu_flow.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class PlayCard extends StatefulWidget {

  static const rollingValue = -1;
  static const unknownValue = -2;

  final String mac;
  final String name;
  final int number;
  final int capState;
  final bool visible;
  final bool included;
  final Map<String, int> history;
  final Function(String, bool) changeVisibilityCallback;
  final Function(String, bool) changeInclusionCallback;
  final Function() clearHistoryCallback;
  final Function(String) identifyCallback;
  final bool connected;

  const PlayCard({
    super.key, 
    required this.name, 
    required this.mac, 
    required this.number, 
    required this.capState,
    required this.visible, 
    required this.included,
    required this.changeVisibilityCallback,
    required this.changeInclusionCallback,
    required this.history,
    required this.clearHistoryCallback,
    required this.identifyCallback,
    required this.connected
  });
  PlayCard.fromDevicePlayModel({
    super.key, 
    required DevicePlayModel model, 
    required this.changeVisibilityCallback, 
    required this.changeInclusionCallback,
    required this.clearHistoryCallback,
    required this.identifyCallback
  }) : 
    mac = model.mac, 
    name = model.name,
    number = model.number,
    capState = model.capState,
    visible = model.visible,
    included = model.included,
    history = model.history,
    connected = model.connectionSubscription != null;

  @override
  State<PlayCard> createState() => _PlayCardState();
}

class _PlayCardState extends State<PlayCard>{
  void _openMenu(LongPressStartDetails details) {
    showPlayMenu(
      context, 
      details, 
      widget.mac, 
      widget.name, 
      widget.capState,
      widget.visible, 
      widget.included, 
      widget.changeVisibilityCallback, 
      widget.changeInclusionCallback,
      widget.history,
      widget.clearHistoryCallback,
      widget.identifyCallback,
      widget.connected
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (LongPressStartDetails details) {
        _openMenu(details);
      },
      child: Card(
        child: Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            border: widget.capState < 15 ? Border.all(color: Colors.red) : Border.all(width: 0),
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          alignment: Alignment.center,
          child: Text(
            widget.number > 0 ? widget.number.toString() :
            widget.number == PlayCard.rollingValue ? "R" : "U", 
            style: widget.included ? 
              TextStyle(
                fontSize: titleTextStyle.fontSize,
                fontWeight: titleTextStyle.fontWeight,
                color: Theme.of(context).textTheme.titleLarge!.color
              ) 
            : 
              TextStyle(
                fontSize: titleTextStyle.fontSize,
                fontWeight: titleTextStyle.fontWeight,
                color: Theme.of(context).textTheme.titleLarge!.color!.withValues(alpha: 0.45)
              ),
          )
        ),
      )
    );
  }
}
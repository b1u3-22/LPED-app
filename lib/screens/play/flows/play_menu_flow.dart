//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		13-05-2025 16:09:21
//  Modified time: 	14-05-2025 00:14:11
//  Description: 		This file contains the context menu for the play card
//                  It shows the device name, mac and cap state, along with buttons for include/exclude, visibility and history
//

import 'package:app/global/history_dialog/history_dialog_flow.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

List<PopupMenuItem> _menuContent(
    BuildContext context, 
    String mac, 
    String name, 
    int capState,
    bool deviceVisible, 
    bool deviceIncluded, 
    Function(String mac, bool newVisibility) visibilityCallback, 
    Function(String mac, bool newInclusion) inclusionCallback,
    Map<String, int> history,
    Function() clearHistoryCallback
  ) {
  return [
    PopupMenuItem(
        child: Column(
          children: [
            Text(name, style: heading3Style,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, size: badgeStyle.fontSize,),
                    SizedBox(width: 2,),
                    Text(mac, style: badgeStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("${capState.round()}%", style: badgeStyle,),
                    SizedBox(width: 2,),
                    Icon(Icons.battery_4_bar, size: badgeStyle.fontSize,)
                  ],
                )
              ],
            ),
            PopupMenuDivider(height: 5,)
          ],
        )
      ),
      (deviceVisible ? 
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              visibilityCallback(mac, false);
              Navigator.of(context).pop();
            }, 
            child: Row(
              children: [
                Icon(Icons.visibility_off),
                SizedBox(width: 5,),
                Text("Hide", style: textStyle,)
              ],
            )
          )
        )
      : 
      PopupMenuItem(
        child: TextButton(
          onPressed: () {
            visibilityCallback(mac, true);
            Navigator.of(context).pop();
          }, 
          child: Row(
            children: [
              Icon(Icons.visibility),
              SizedBox(width: 5,),
              Text("Show", style: textStyle,)
            ],
          )
        )
      )),
      (deviceIncluded ? 
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              inclusionCallback(mac, false);
              Navigator.of(context).pop();
            }, 
            child: Row(
              children: [
                Icon(Icons.close),
                SizedBox(width: 5,),
                Text("Exclude", style: textStyle,)
              ],
            )
          )
        )
      : 
      PopupMenuItem(
        child: TextButton(
          onPressed: () {
            inclusionCallback(mac, true);
            Navigator.of(context).pop();
          }, 
          child: Row(
            children: [
              Icon(Icons.add),
              SizedBox(width: 5,),
              Text("Include", style: textStyle,)
            ],
          )
        )
      )
    ),
    PopupMenuItem(
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            showHistoryDialog(context, history, name, mac, clearHistoryCallback);
          }, 
          child: Row(
            children: [
              Icon(Icons.history),
              SizedBox(width: 5,),
              Text("History", style: textStyle,)
            ],
          )
        )
      )
  ];
}

/// Function for displaying the play card context menu
Future<void> showPlayMenu(
    BuildContext context, 
    LongPressStartDetails details,
    String mac, 
    String name, 
    int capState,
    bool deviceVisible, 
    bool deviceIncluded, 
    Function(String mac, bool newVisibility) visibilityCallback, 
    Function(String mac, bool newInclusion) inclusionCallback,
    Map<String, int> history,
    Function() clearHistoryCallback
  ) { 

  return showMenu(
    context: context, 
    position: RelativeRect.fromLTRB(
      details.globalPosition.dx, 
      details.globalPosition.dy, 
      MediaQuery.of(context).size.width - details.globalPosition.dx, 
      MediaQuery.of(context).size.height - details.globalPosition.dy
    ),
    items: _menuContent(
      context, 
      mac, 
      name, 
      capState,
      deviceVisible, 
      deviceIncluded, 
      visibilityCallback, 
      inclusionCallback,
      history,
      clearHistoryCallback
    )
  );
}
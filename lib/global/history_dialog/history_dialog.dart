import 'package:app/global/dialog_action_base.dart';
import 'package:app/global/dialog_base.dart';
import 'package:app/global/history_dialog/history_list/history_list.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class HistoryDialog extends StatelessWidget {
  final String name;
  final String mac;
  final Map<String, int> history;
  final Function() clearHistoryCallback;

  const HistoryDialog({super.key, required this.name, required this.mac, required this.history, required this.clearHistoryCallback});
  
  int _getTotalCount() {
    int count = 0;
    for (MapEntry<String, int> entry in history.entries) {
      count += entry.value;
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return DialogBase(
      title: "Details & history",
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Name:", textAlign: TextAlign.left, style: textStyle.copyWith(fontWeight:  FontWeight.bold)),
              Text(name, textAlign: TextAlign.right, style: textStyle)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("MAC:", textAlign: TextAlign.left, style: textStyle.copyWith(fontWeight:  FontWeight.bold)),
              Text(mac, textAlign: TextAlign.right, style: textStyle)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Throws total:", textAlign: TextAlign.left, style: textStyle.copyWith(fontWeight:  FontWeight.bold)),
              Text(_getTotalCount().toString(), textAlign: TextAlign.right, style: textStyle)
            ],
          ),
          SizedBox(height: 20),
          HistoryList(
            history: history,
            total: _getTotalCount(),
          ),
          ElevatedButton(
            onPressed: clearHistoryCallback, 
            child: Text("Clear history", style: textStyle,)
          )
        ],
      ),
      actions: [
        DialogActionBase(
          label: "Close"
        ),
      ],
    );
  }
}
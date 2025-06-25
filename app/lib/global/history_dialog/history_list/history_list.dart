import 'package:app/global/history_dialog/history_list/history_list_row.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final Map<String, int> history;
  final int total;

  const HistoryList({super.key, required this.history, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Number", style: textStyle,),
            Text("%", style: textStyle),
            Text("Count", style: textStyle)
          ],
        ),
        Divider(height: 5, thickness: 5,),
        if (history.entries.isNotEmpty)
          Column(
            children: [
              for (MapEntry historyEntry in history.entries) 
                HistoryListRow(number: historyEntry.key, count: historyEntry.value, percentage: historyEntry.value / total * 100,)
            ],
          )
        else 
          Column(
            children: [
              SizedBox(height: 50,),
              Text("No history data")
            ],
          )
      ],
    );
  }
}
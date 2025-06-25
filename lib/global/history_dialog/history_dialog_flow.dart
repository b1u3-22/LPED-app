import 'package:app/global/history_dialog/history_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showHistoryDialog(
    BuildContext context, 
    Map<String, int> history,
    String name,
    String mac,
    Function() clearHistoryCallback
  ) async 
  {
  showDialog(
    context: context, 
    builder: (_) => HistoryDialog(
      history: Map.fromEntries(history.entries.toList()..sort((a, b) => a.key.compareTo(b.key))),
      name: name,
      mac: mac,
      clearHistoryCallback: clearHistoryCallback,
    )
  );
}
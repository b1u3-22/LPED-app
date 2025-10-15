import 'package:app/screens/play/flows/end_game/end_game_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showEndGameDialog(BuildContext context, List<int> scores, Function() onClose) async {
  showDialog(
    context: context, 
    builder: (_) => EndGameDialog(
      scores: scores,
      onClose: onClose,
    )
  );
}
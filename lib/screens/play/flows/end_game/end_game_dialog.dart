import 'package:app/global/dialog_action_base.dart';
import 'package:app/global/dialog_base.dart';
import 'package:app/models/animation/pallete/pallete_list.dart';
import 'package:app/screens/play/play.dart';
import 'package:flutter/material.dart';

class EndGameDialog extends StatelessWidget {
  final List<int> scores;
  final Function() onClose;

  const EndGameDialog({super.key, required this.scores, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return DialogBase(
      title: "Time is up!", 
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int score = 0; score < scores.length; score++) 
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(
                    255, 
                    Pallete.palette[PlayPage.groupColorIndexes[score]].color[0], 
                    Pallete.palette[PlayPage.groupColorIndexes[score]].color[1], 
                    Pallete.palette[PlayPage.groupColorIndexes[score]].color[2]
                  )
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Text("Final score: ${scores[score]}"),
            )
        ],
      ),
      actions: [
        DialogActionBase(
          label: "Close",
          callback: onClose
        ),
      ],
    );
  }
}
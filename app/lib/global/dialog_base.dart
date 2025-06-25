import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class DialogBase extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  const DialogBase({super.key, this.title = "", required this.content, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      title: Text(title, style: heading2Style, textAlign: TextAlign.center,),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenSize.width * 0.8,
          maxHeight: screenSize.height * 0.8,
        ),
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: content,
            ),
          )
        )
      ),
      actions: actions,
    );
  }
}
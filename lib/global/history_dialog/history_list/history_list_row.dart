import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class HistoryListRow extends StatelessWidget{
  final String number;
  final int count;
  final double percentage;

  const HistoryListRow({super.key, required this.number, required this.count, required this.percentage});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(number, style: textStyle, textAlign: TextAlign.left),
            Text("${percentage.toStringAsFixed(2)}%", style: textStyle, textAlign: TextAlign.center,),
            Text(count.toString(), style: textStyle, textAlign: TextAlign.right),
          ],
        ),
        Divider()
      ],
    );
  }
}
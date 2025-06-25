//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		15-04-2025 18:38:25
//  Modified time: 	14-05-2025 00:37:18
//  Description: 		This file contains loading section for the discovery dialog
//

import 'package:app/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DiscoveryDialogLoading extends StatelessWidget {
  const DiscoveryDialogLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Searching for devices",
          style: heading3Style,
        ),
        SizedBox(height: 10,),
        SpinKitRipple(
          color: Theme.of(context).colorScheme.primary,
          size: 50
        )
      ],
    );
  }

}
//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		15-04-2025 18:49:03
//  Modified time: 	13-05-2025 22:45:07
//  Description:    This file contains loading section that is displayed while connecting and loading data from the device 		
//

import 'package:app/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSection extends StatelessWidget {
  final String statusMessage;

  const LoadingSection({super.key, required this.statusMessage});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpinKitRipple(
            color: Theme.of(context).colorScheme.primary,
            size: 50
          ),
          SizedBox(height: 10),
          Text(statusMessage, style: heading3Style,)
        ],
      )
    );
  }
}
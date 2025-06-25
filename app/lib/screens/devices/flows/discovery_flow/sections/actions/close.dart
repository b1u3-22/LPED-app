//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		15-04-2025 18:38:25
//  Modified time: 	14-05-2025 00:38:49
//  Description: 		This file contains action for closing the discovery dialog
//

import 'package:app/global/dialog_action_base.dart';
import 'package:flutter/material.dart';

class DiscoveryDialogActionClose extends StatelessWidget {
  const DiscoveryDialogActionClose({super.key});

  @override
  Widget build(BuildContext context) {
    return DialogActionBase(
      label: "Close",
    );
  }
}
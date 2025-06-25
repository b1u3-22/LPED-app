//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		13-05-2025 16:09:21
//  Modified time: 	13-05-2025 22:37:01
//  Description: 		This file contains side vector edit section used in profile creation, side creation and side edit
//

import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/global/settings_field.dart';
import 'package:app/screens/settings/sections/settings_label.dart';
import 'package:app/screens/settings/sections/settings_row.dart';
import 'package:app/services/bluetooth/bluetooth.dart';
import 'package:flutter/material.dart';

class SettingsSideVectorEdit extends StatefulWidget {
  final SideDefinitionListModel side;
  final Function(List<int>) changeVector;
  final Function() captureVector;

  const SettingsSideVectorEdit({
    super.key, 
    required this.side,
    required this.changeVector,
    required this.captureVector
  });

  @override
  State<SettingsSideVectorEdit> createState() => _SettingsSideVectorEditState();
}

class _SettingsSideVectorEditState extends State<SettingsSideVectorEdit>{
  late SideDefinitionListModel _side;
  final List<TextEditingController> _controllers = [TextEditingController(), TextEditingController(), TextEditingController()];

  _updateControllers() {
    setState(() {
      for (int i = 0; i < _side.vector.length; i++) {
        _controllers[i].text = (_side.vector[i] / LPEDBluetooth.accelerometerDivisor).toStringAsFixed(2);
      }
    });
  }

  @override
  void initState() {
    _side = widget.side;
    _updateControllers();
    super.initState();
  }

  void _changeVector(String newValue, int vectorIndex) {
    double newValueDouble = double.tryParse(newValue) ?? 0.0;
    setState(() => _side.vector[vectorIndex] = (newValueDouble * LPEDBluetooth.accelerometerDivisor).toInt());
    _updateControllers();
    widget.changeVector(_side.vector);
  }

  void _captureVector() {
    widget.captureVector().then((newVector) {
      setState(() => _side.vector = newVector);
      _updateControllers();
      widget.changeVector(_side.vector);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Place the side so that your number ${_side.number} is facing up " 
        "and press \"Capture\" or enter the values manually\n\n"),
        SettingsRow(
          left: SettingsLabel(text: "X [g]:"), 
          right: SizedBox(
            width: 50,
            child: SettingsField(
              controller: _controllers[0],
              keyboardType: TextInputType.number,
              onSubmitted: (newValue) => _changeVector(newValue, 0),
            ),
          )
        ),
        SettingsRow(
          left: SettingsLabel(text: "Y [g]:"), 
          right: SizedBox(
            width: 50,
            child: SettingsField(
              controller: _controllers[1],
              keyboardType: TextInputType.number,
              onSubmitted: (newValue) => _changeVector(newValue, 1),
            ),
          )
        ),
        SettingsRow(
          left: SettingsLabel(text: "Z [g]:"), 
          right: SizedBox(
            width: 50,
            child: SettingsField(
              controller: _controllers[2],
              keyboardType: TextInputType.number,
              onSubmitted: (newValue) => _changeVector(newValue, 2),
            ),
          )
        ),
        ElevatedButton(
          onPressed: _captureVector, 
          child: SettingsLabel(text: "Capture")
        )
      ],
    );
  }
}
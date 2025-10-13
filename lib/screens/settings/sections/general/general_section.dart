//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		13-05-2025 16:09:21
//  Modified time: 	13-05-2025 22:54:55
//  Description: 		This file contains the general settings subpage, which serves for 
//                  changing the global blink options, selecting a profile and running actions
//

import 'package:app/global/history_dialog/history_dialog_flow.dart';
import 'package:app/models/dice_definition/dice_definition_base.dart';
import 'package:app/models/dice_definition/dice_definition_list.dart';
import 'package:app/screens/settings/sections/general/sections/dice_profile_drop_down/dice_profile_drop_down.dart';
import 'package:app/screens/settings/sections/general/sections/dice_profile_list/dice_profile_list.dart';
import 'package:app/screens/settings/sections/settings_action_button.dart';
import 'package:app/screens/settings/sections/settings_action_list.dart';
import 'package:app/global/settings_field.dart';
import 'package:app/screens/settings/sections/settings_label.dart';
import 'package:app/screens/settings/sections/settings_page.dart';
import 'package:app/screens/settings/sections/settings_row.dart';
import 'package:app/screens/settings/sections/settings_title.dart';
import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class GeneralSection extends StatelessWidget {
  // Values
  final Map<String, int> history;
  final String deviceName;
  final String deviceMac;
  final bool sideBlink;
  final bool errorBlink;
  final bool commMode;
  final List<DiceDefinitionListModel> supportedProfiles;
  final int currentProfileID;
  
  // Callbacks
  final Function() clearHistoryCallback;
  final Function(String newName) changeDeviceName;
  final Function(bool newBlink) sideBlinkChanged;
  final Function(bool newBlink) errorBlinkChanged;
  final Function (bool newCommMode) commModeChanged;
  final Function(int id) selectDiceProfile;
  final Function() commandRestart;
  final Function() commandFactoryReset;
  final Function() commandReload;
  final Function() addDiceProfile;
  final Function(int id) editDiceProfile;
  final Function(int id) deleteDiceProfile;
  final Function(DiceDefinitionListModel model, String newName) renameDiceProfile;

  const GeneralSection({
    super.key, 
    required this.history,
    required this.deviceName,
    required this.deviceMac,
    required this.sideBlink, 
    required this.errorBlink, 
    required this.commMode,
    required this.supportedProfiles,
    required this.currentProfileID,
    required this.clearHistoryCallback,
    required this.changeDeviceName,
    required this.sideBlinkChanged,
    required this.errorBlinkChanged,
    required this.commModeChanged,
    required this.selectDiceProfile,
    required this.commandRestart,
    required this.commandFactoryReset,
    required this.commandReload,
    required this.addDiceProfile,
    required this.editDiceProfile,
    required this.deleteDiceProfile,
    required this.renameDiceProfile
  });
  
  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      children: [
        SettingsField(
          prefilled: deviceName,
          style: heading1Style,
          align: TextAlign.center,
          onSubmitted: changeDeviceName,
        ),
        SizedBox(height: 50),
        SettingsRow(
          left: SettingsLabel(text: "Blink on land"), 
          right: Switch(
            value: sideBlink, 
            onChanged: (newBlink) => sideBlinkChanged(newBlink)
          )
        ),
        SettingsRow(
          left: SettingsLabel(text: "Blink on error"), 
          right: Switch(
            value: errorBlink, 
            onChanged: (newBlink) => errorBlinkChanged(newBlink)
          )
        ),
        SettingsRow(
          left: SettingsLabel(text: "Connected mode"), 
          right: Switch(
            value: commMode, 
            onChanged: (newMode) => commModeChanged(newMode)
          )
        ),
        SettingsRow(
          left: SettingsLabel(text: "Selected profile"), 
          right: DiceProfileDropDown(
            supportedDiceProfiles: supportedProfiles, 
            currentProfileID: currentProfileID,
            newProfileSelected: selectDiceProfile,
          )
        ),
        SettingsTitle(text: "Actions"),
        SettingsActionList(
          children: [
            SettingsActionButton(
              text: "Restart",
              icon: Icon(Icons.restart_alt),
              action: commandRestart,
            ),
            SettingsActionButton(
              text: "Factory reset",
              icon: Icon(Icons.disabled_by_default),
              action: commandFactoryReset,
            ),
            SettingsActionButton(
              text: "Reload",
              icon: Icon(Icons.sync),
              action: commandReload,
            ),
            SettingsActionButton(
              text: "Add new profile",
              subText: "${supportedProfiles.length}/${DiceDefinitionBaseModel.diceDefinitionsMax}",
              action: addDiceProfile,
            ),
            SettingsActionButton(
              text: "Show details",
              icon: Icon(Icons.history),
              action: () => showHistoryDialog(context, history, deviceName, deviceMac, clearHistoryCallback),
            )
          ]
        ),
        SettingsTitle(text: "Profiles"),
        DiceProfileList(
          profiles: supportedProfiles,
          currentProfileID: currentProfileID,
          onProfileDelete: deleteDiceProfile,
          onProfileEdit: editDiceProfile,
          onProfileNameChange: renameDiceProfile,
        )
      ],
    );
  }
}

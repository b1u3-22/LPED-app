import 'package:app/models/animation/animation/animation_base.dart';
import 'package:app/models/animation/animation/animation_detail.dart';
import 'package:app/models/animation/animation_step/animation_step_base.dart';
import 'package:app/models/animation/animation_step/animation_step_detail.dart';
import 'package:app/models/side_definition/side_definition_list.dart';
import 'package:app/screens/settings/sections/settings_animation_step_list.dart';
import 'package:app/screens/settings/sections/settings_fade_type_drop_down.dart';
import 'package:app/screens/settings/sections/settings_label.dart';
import 'package:app/screens/settings/sections/settings_row.dart';
import 'package:flutter/material.dart';

class SettingsSideAnimationEdit extends StatefulWidget {
  final SideDefinitionListModel side;
  final Function(AnimationDetailModel steps) onChange;

  const SettingsSideAnimationEdit({
    super.key, 
    required this.side,
    required this.onChange
  });

  @override
  State<StatefulWidget> createState() => _SettingsSideAnimationEditState();

}

class _SettingsSideAnimationEditState extends State<SettingsSideAnimationEdit>{
  late SideDefinitionListModel _side;
  
  @override
  void initState() {
    super.initState();
    _side = SideDefinitionListModel.withAnimation(number: widget.side.number, vector: widget.side.vector, animation: widget.side.animation);
  }

  void _generateBlinkingPattern() {
    setState(() {
      AnimationDetailModel temp = AnimationDetailModel.generateBlink(_side.number);
      _side.animation = temp;
      _side.animation.numberOfSteps = temp.steps.length;
      widget.onChange(_side.animation);
    });
  }

  void _addAnimationStep() {
    setState(() {
      List<AnimationStepDetailModel> temp = _side.animation.steps;
      temp.add(AnimationStepDetailModel(0, (AnimationStepBaseModel.durationMaxValue / 2).floor()));
      _side.animation.steps = temp;
      _side.animation.numberOfSteps = temp.length;
      widget.onChange(_side.animation);
    });
  }

  void _deleteAnimationStep(int stepIndex) {
    setState(() {
      List<AnimationStepDetailModel> temp = _side.animation.steps;
      temp.removeAt(stepIndex);
      _side.animation.steps = temp;
      _side.animation.numberOfSteps = temp.length;
      widget.onChange(_side.animation);
    });
  }

  void _deleteAllAnimationSteps() {
    setState(() {
      _side.animation.steps = [];
      _side.animation.numberOfSteps = 0;
      widget.onChange(_side.animation);
    });
  }

  void _changeAnimationStep(int stepIndex, int colorIndex, int duration) {
    setState(() {
      _side.animation.steps[stepIndex].colorIndex = colorIndex;
      _side.animation.steps[stepIndex].duration = duration;
      widget.onChange(_side.animation);
    });
  }

  void _changeAnimationFadeType(int newFadeType) {
    setState(() {
      _side.animation.fadeType = newFadeType;
      widget.onChange(_side.animation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Customize animation for side ${_side.number}." 
        "You can add up to ${AnimationBaseModel.numberOfStepsMaxValue} steps."
        "You can also generate a blinking pattern."
        "\n\n"),
        Column(
          children: [
            ElevatedButton(
              onPressed: _generateBlinkingPattern, 
              child: SettingsLabel(text: "Generate blink")
            ),
            ElevatedButton(
              onPressed: _deleteAllAnimationSteps, 
              child: SettingsLabel(text: "Delete all")
            )
          ],
        ),
        SettingsRow(
          left: SettingsLabel(text: "Fade type"), 
          right: SettingsFadeTypeDropDown(
            value: _side.animation.fadeType, 
            newTypeSelected: (newFadeType) => _changeAnimationFadeType(newFadeType)
          ),
        ),
        SettingsAnimationStepList(
          steps: _side.animation.steps, 
          onDelete: (int stepIndex) => _deleteAnimationStep(stepIndex), 
          onChange: (int stepIndex, int colorIndex, int duration) => _changeAnimationStep(stepIndex, colorIndex, duration)
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: _addAnimationStep, 
              child: SettingsLabel(text: "Add step")
            ),
          ],
        )
      ],
    );
  } 
}
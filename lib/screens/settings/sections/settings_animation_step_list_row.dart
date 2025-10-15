import 'package:app/models/animation/animation_step/animation_step_base.dart';
import 'package:app/models/animation/animation_step/animation_step_detail.dart';
import 'package:app/screens/settings/sections/settings_pallete_drop_down.dart';
import 'package:flutter/material.dart';

class SettingsAnimationStepListRow extends StatefulWidget {
  final AnimationStepDetailModel model;
  final Function() onDelete;
  final Function() onCopy;
  final Function(int newColorIndex, int newDuration) onChange;

  const SettingsAnimationStepListRow({
    super.key,
    required this.model,
    required this.onDelete,
    required this.onChange,
    required this.onCopy
  });

  @override
  State<StatefulWidget> createState() => SettingsAnimationStepListRowState();

}

class SettingsAnimationStepListRowState extends State<SettingsAnimationStepListRow>{
  late AnimationStepDetailModel _model;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _model = AnimationStepDetailModel(widget.model.colorIndex, widget.model.duration);

    return Column(
      children: [
        FittedBox(
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SettingsPalleteDropDown(
                  currentSelectedColor: _model.colorIndex, 
                  newColorSelected: (newColorIndex) {
                    setState(() {
                      _model.colorIndex = newColorIndex;
                    });
                    widget.onChange(newColorIndex, _model.duration);
                  }
                ),
                Slider(
                  min: 0,
                  max: AnimationStepBaseModel.durationMaxValue.toDouble(),
                  label: "${((_model.duration + 1) * 100) / 1000}s",
                  value: _model.duration.toDouble(), 
                  divisions:  AnimationStepBaseModel.durationMaxValue + 1,
                  onChanged: (newDuration) {
                    setState(() {
                      _model.duration = newDuration.toInt();
                    });
                    widget.onChange(_model.colorIndex, newDuration.toInt());
                  }
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: widget.onDelete, 
                      icon: Icon(Icons.delete)
                    ),
                    IconButton(
                      onPressed: widget.onCopy, 
                      icon: Icon(Icons.copy)
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}



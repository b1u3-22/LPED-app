import 'package:app/typography.dart';
import 'package:flutter/material.dart';

class SettingsField extends StatefulWidget {
  final String prefilled;
  final TextEditingController? controller;
  final TextStyle style;
  final TextAlign align;
  final TextAlignVertical verticalAlign;
  final Function(String value)? onSubmitted;
  final bool resetOnTapOutside;
  final TextInputType keyboardType;
  final int? maxLength;

  const SettingsField({
    super.key, 
    this.prefilled = "", 
    this.controller,
    this.style = textStyle, 
    this.align = TextAlign.start,
    this.verticalAlign = TextAlignVertical.center,
    this.onSubmitted, 
    this.resetOnTapOutside = true,
    this.keyboardType = TextInputType.text,
    this.maxLength
  });
  
  @override
  State<SettingsField> createState() => _SettingsFieldState();
}

class _SettingsFieldState extends State<SettingsField>{
  late TextEditingController _controller;


  @override
  void initState() {
    _controller = TextEditingController(text: widget.prefilled);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller ?? _controller,
      style: widget.style,
      textAlign: widget.align,
      textAlignVertical: widget.verticalAlign,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8)
      ),
      onSubmitted: (value) {
        if (widget.onSubmitted != null) widget.onSubmitted!(value);
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
        if (widget.resetOnTapOutside) {
          setState(() {
            _controller.text = widget.prefilled;
          });
        }
      },
    );
  }
}
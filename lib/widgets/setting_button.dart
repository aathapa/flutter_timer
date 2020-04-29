import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final int value;
  final String setting;
  final Function callback;

  SettingButton({
    this.color,
    this.text,
    this.size,
    this.value,
    this.setting,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(this.text, style: TextStyle(color: Colors.white)),
      onPressed: () => callback(setting, value),
      color: color,
      minWidth: this.size,
    );
  }
}

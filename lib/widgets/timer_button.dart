import 'package:flutter/material.dart';

class TimerButton extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final Function onPressed;

  const TimerButton({this.text, this.color, this.size, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      color: color,
      minWidth: size,
    );
  }
}

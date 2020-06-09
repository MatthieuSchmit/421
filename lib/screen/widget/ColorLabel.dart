/*
 * 421 - /ColorLabel
 *
 * by Matthieu at 2020-06-09 18:17
 *
 */

import 'package:flutter/material.dart';

class ColorLabel extends StatelessWidget {
  final String text;
  final Color color;

  ColorLabel({this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.color,
      height: 30.0,
      width: 50.0,
      child: Center(
        child: Text(text),
      ),
    );
  }

}

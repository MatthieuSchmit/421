/*
 * 421 - /Dice
 *
 * by Matthieu at 2020-06-07 10:18
 *
 */

import 'package:flutter/material.dart';

class Dice extends StatelessWidget {
  final int dice;
  final double width;

  Dice({
    this.width,
    this.dice
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width, // MediaQuery.of(context).size.width / 9,
      child: Image.asset('assets/Alea_${this.dice}.png'),
    );
  }
}

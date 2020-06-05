/*
 * 421 - /Rules
 *
 * by Matthieu at 2020-06-04 19:42
 *
 */

import 'package:flutter/material.dart';

class Rules extends StatefulWidget {
  Rules({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RulesState createState() => _RulesState();
}

class _RulesState extends State<Rules> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rules"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              _combinations(),
            ],
          ),
        ),
      )
    );
  }

  Widget _combinations() {
    List<String> combis = ['421','111','166','666','115','555','114','444','113','333','112','222','654','543','432','321'];
    List<Widget> list = [];

    combis.asMap().forEach((index, element) {
      list.add(_rowCombination(element.substring(0,1), element.substring(1,2), element.substring(2), index));
    });

    return Column(
      children: list,
    );
  }

  Widget _rowCombination(String a, String b, String c, int position) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('#${position+1}'),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 8,
          child: Image.asset('assets/Alea_$a.png'),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 8,
          child: Image.asset('assets/Alea_$b.png'),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 8,
          child: Image.asset('assets/Alea_$c.png'),
        ),
      ],
    );
  }

}


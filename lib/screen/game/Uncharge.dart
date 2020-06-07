/*
 * 421 - /Uncharge
 *
 * by Matthieu at 2020-06-07 12:15
 *
 */

import 'package:flutter/material.dart';
import 'package:quatre_cent_vingt_et_un/model/Party.dart';
import 'package:quatre_cent_vingt_et_un/screen/widget/Dice.dart';

class Uncharge extends StatelessWidget {

  Party party;
  final String playerID;

  Uncharge({this.party, this.playerID});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _listPlayers(context),
        ],
      ),
    );
  }

  Widget _listPlayers(BuildContext context) {
    List<Widget> list = [];

    this.party.players.asMap().forEach((key, player) {
      list.add(Container(
        padding: EdgeInsets.all(5.0),
        color: (this.party.firstIndex == key) ? Colors.lightGreenAccent : ((this.party.lastIndex == key) ? Colors.redAccent : Colors.white),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Text(player.name),
                  Text('${player.token}  '),
                  (this.playerID == player.id) ? Text('YOU') : Text(''),
                  (this.party.winners.contains(player.id)) ? Text('#1') : Text(''),
                  Text('${player.point}'),
                ],
              ),
            ),
            Dice(
              width: MediaQuery.of(context).size.width / 9,
              dice: player.dice1,
            ),
            SizedBox(width: 5.0),
            Dice(
              width: MediaQuery.of(context).size.width / 9,
              dice: player.dice2,
            ),
            SizedBox(width: 5.0),
            Dice(
              width: MediaQuery.of(context).size.width / 9,
              dice: player.dice3,
            ),
          ],
        ),
      ));
    });

    return Column(children: list);
  }



}

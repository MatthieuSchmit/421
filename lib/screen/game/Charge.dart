/*
 * 421 - /Charge
 *
 * by Matthieu at 2020-06-07 10:32
 *
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quatre_cent_vingt_et_un/helper/Game.dart';
import 'package:quatre_cent_vingt_et_un/helper/GameCommunication.dart';
import 'package:quatre_cent_vingt_et_un/model/Party.dart';
import 'package:quatre_cent_vingt_et_un/screen/widget/Dice.dart';

class Charge extends StatelessWidget {

  Party party;
  final String playerID;

  Charge({this.party, this.playerID});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _listPlayers(context),
          SizedBox(height: 20.0),
          (this.party.token == 0) ? _viewEndGame(context) : _viewGame(context),
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
                  Text('${player.token}'),
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

  Widget _viewGame(BuildContext context) {
    if (this.party.players[this.party.playIndex].dice1 != 0) {
      // Finish
      return Column(
        children: <Widget>[
          Text('FINISH ROUND'),
          Text('LOOSER : ${this.party.players[this.party.lastIndex].name}'),
          Text('get ${this.party.players[this.party.firstIndex].point} tokens'),
          FlatButton(
            child: Text('OK'),
            onPressed: _endRound,
          ),
        ],
      );
    } else if (this.party.players[this.party.playIndex].id == this.playerID) {
      // Your turn
      return Column(
        children: <Widget>[
          Text("Remaining tokens : ${this.party.token}"),
          RaisedButton(
            onPressed: _playAction,
            child: Text('ROLL'),
          )
        ],
      );
    } else {
      // Not your turn - Wait
      return Text("Remaining tokens : ${this.party.token}");
    }
  }

  Widget _viewEndGame(BuildContext context) {
    List<Widget> list = [];
    this.party.winners.forEach((element) {
      list.add(Text(element));
    });

    return Column(
      children: <Widget>[
        Text('Charge finie'),
        (this.party.winners.length != 0) ? Text('First winners :') : Text(''),
        (this.party.winners.length != 0) ? Column(children: list) : Text(''),
        FlatButton(
          child: Text('Continue'),
          onPressed: () {
            this.party.nbRound = 2;
            game.send('action_party', json.encode(this.party));
          },
        )
      ],
    );
  }

  ///
  /// ACTIONS
  ///

  _playAction() {
    // roll dices
    List<int> dices = sortDesc(rollDices(3));

    // set result
    this.party.players[this.party.playIndex].dice1 = dices[0];
    this.party.players[this.party.playIndex].dice2 = dices[1];
    this.party.players[this.party.playIndex].dice3 = dices[2];

    // get point
    this.party.players[this.party.playIndex].point = getPoint(dices);

    // set next player
    int nextIndex = this.party.playIndex + 1;
    if (nextIndex == this.party.players.length) {
      nextIndex = 0;
    }
    this.party.playIndex = nextIndex;

    // set looser and winner
    this.party = setRanking(this.party);

    // notify server
    game.send('action_party', json.encode(this.party));
  }

  _endRound() {
    // Set token
    int tokenToTake = 0;
    if (this.party.players[this.party.firstIndex].point > this.party.token) {
      tokenToTake = this.party.token;
    } else {
      tokenToTake = this.party.players[this.party.firstIndex].point;
    }
    this.party.players[this.party.lastIndex].token = tokenToTake + this.party.players[this.party.lastIndex].token;
    this.party.token = this.party.token - tokenToTake;

    // Reset dices and points
    this.party.players.forEach((player) {
      player.point = 0;
      player.dice1 = 0;
      player.dice2 = 0;
      player.dice3 = 0;
    });

    this.party.firstIndex = this.party.lastIndex;
    this.party.playIndex = this.party.lastIndex;

    // notify server
    game.send('action_party', json.encode(this.party));
  }

}


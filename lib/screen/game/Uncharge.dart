/*
 * 421 - /Uncharge
 *
 * by Matthieu at 2020-06-07 12:15
 *
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quatre_cent_vingt_et_un/helper/Game.dart';
import 'package:quatre_cent_vingt_et_un/helper/GameCommunication.dart';
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
          (this.party.token == 21) ? _viewEndGame(context) : _viewGame(context),
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
                  Text(
                    player.name,
                    style: TextStyle(
                      fontWeight: (this.playerID == player.id) ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  Text(' - ${player.token} token(s) '),
                  (this.party.winners.contains(player.id)) ? Text(' #1') : Text(''),
                  Text('${player.point}'),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Dice(
                  width: MediaQuery.of(context).size.width / 9,
                  dice: player.dice1,
                ),
                (player.lock1) ? Icon(Icons.lock) : Text('')
              ],
            ),
            SizedBox(width: 5.0),
            Column(
              children: <Widget>[
                Dice(
                  width: MediaQuery.of(context).size.width / 9,
                  dice: player.dice2,
                ),
                (player.lock2) ? Icon(Icons.lock) : Text('')
              ],
            ),
            SizedBox(width: 5.0),
            Column(
              children: <Widget>[
                Dice(
                  width: MediaQuery.of(context).size.width / 9,
                  dice: player.dice3,
                ),
                (player.lock3) ? Icon(Icons.lock) : Text('')
              ],
            ),
          ],
        ),
      ));
    });

    return Column(children: list);
  }

  Widget _viewGame(BuildContext context) {
    if (this.party.players[this.party.playIndex].hasPlay) {
      // Finish
      return Column(
        children: <Widget>[
          Text('FINISH ROUND'),
          Text('LOOSER : ${this.party.players[this.party.lastIndex].name}'),
          Text('get ${this.party.players[this.party.firstIndex].point} tokens'),
          Text('from ${this.party.players[this.party.firstIndex].name}'),
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
          Text("Roll : ${this.party.rolled}/${this.party.maxRolled}"),
          Row(
            children: <Widget>[
              GestureDetector(
                child: Column(
                  children: <Widget>[
                    Dice(
                      width: MediaQuery.of(context).size.width / 8,
                      dice: this.party.players[this.party.playIndex].dice1,
                    ),
                    Icon((this.party.players[this.party.playIndex].lock1) ? Icons.lock : Icons.lock_open)
                  ],
                ),
                onTap: () {
                  if (this.party.players[this.party.playIndex].dice1 != 0) {
                    this.party.players[this.party.playIndex].lock1 = !this.party.players[this.party.playIndex].lock1;
                    game.send('action_party', json.encode(this.party));
                  }
                },
              ),
              GestureDetector(
                child: Column(
                  children: <Widget>[
                    Dice(
                      width: MediaQuery.of(context).size.width / 8,
                      dice: this.party.players[this.party.playIndex].dice2,
                    ),
                    Icon((this.party.players[this.party.playIndex].lock2) ? Icons.lock : Icons.lock_open)
                  ],
                ),
                onTap: () {
                  if (this.party.players[this.party.playIndex].dice2 != 0) {
                    this.party.players[this.party.playIndex].lock2 = !this.party.players[this.party.playIndex].lock2;
                    game.send('action_party', json.encode(this.party));
                  }
                },
              ),
              GestureDetector(
                child: Column(
                  children: <Widget>[
                    Dice(
                      width: MediaQuery.of(context).size.width / 8,
                      dice: this.party.players[this.party.playIndex].dice3,
                    ),
                    Icon((this.party.players[this.party.playIndex].lock3) ? Icons.lock : Icons.lock_open)
                  ],
                ),
                onTap: () {
                  if (this.party.players[this.party.playIndex].dice3 != 0) {
                    this.party.players[this.party.playIndex].lock3 = !this.party.players[this.party.playIndex].lock3;
                    game.send('action_party', json.encode(this.party));
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              FlatButton(
                child: Text('Roll'),
                onPressed: _playAction,
              ),
              FlatButton(
                child: Text('Done'),
                onPressed: _nextPlayer,
              )
            ],
          )
        ],
      );
    } else {
      // Not your turn - Wait
      return Text("");
    }
  }

  Widget _viewEndGame(BuildContext context) {
    return Text('End game');
  }


  _playAction() {
    if (this.party.players[this.party.playIndex].lock1 && this.party.players[this.party.playIndex].lock2 && this.party.players[this.party.playIndex].lock3) {
      // forbidden
    } else {
      if (this.party.rolled == this.party.maxRolled) {
        print("Max roll - ${this.party.rolled} = ${this.party.maxRolled}");
        _nextPlayer();
      } else {
        this.party.rolled ++;
        this.party.players[this.party.playIndex] = rollUncharge(this.party.players[this.party.playIndex]);

        game.send('action_party', json.encode(this.party));
      }
    }
  }

  _nextPlayer() {
    // Unlock
    this.party.players[this.party.playIndex].lock1 = false;
    this.party.players[this.party.playIndex].lock2 = false;
    this.party.players[this.party.playIndex].lock3 = false;
    this.party.players[this.party.playIndex].hasPlay = true;

    // Set max roll
    if (this.party.firstPlayerIndex == this.party.playIndex) {
      this.party.maxRolled = this.party.rolled;
    }
    this.party.rolled = 0;

    // set next player
    int nextIndex = this.party.playIndex + 1;
    if (nextIndex == this.party.players.length) {
      nextIndex = 0;
    }
    this.party.playIndex = nextIndex;
    this.party = setRanking(this.party);

    game.send('action_party', json.encode(this.party));
  }

  _endRound() {
    // set tokens
    int tokenToTake = this.party.players[this.party.firstIndex].point;
    if (tokenToTake > this.party.players[this.party.firstIndex].token) {
      tokenToTake = this.party.players[this.party.firstIndex].token;
    }
    this.party.players[this.party.firstIndex].token = this.party.players[this.party.firstIndex].token - tokenToTake;
    this.party.players[this.party.lastIndex].token = this.party.players[this.party.lastIndex].token + tokenToTake;

    // reset dices
    this.party.players.forEach((player) {
      player.dice1 = 0;
      player.dice2 = 0;
      player.dice3 = 0;
      player.hasPlay = false;
      player.lock1 = false;
      player.lock2 = false;
      player.lock3 = false;
    });
    this.party.rolled = 0;
    this.party.maxRolled = 3;

    this.party.playIndex = this.party.lastIndex;
    this.party.firstIndex = this.party.lastIndex;
    this.party.firstPlayerIndex = this.party.lastIndex;

    // notify
    game.send('action_party', json.encode(this.party));
  }


}

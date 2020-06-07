/*
 * 421 - /RoundSecond
 *
 * by Matthieu at 2020-06-05 21:59
 *
 */
/*
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quatre_cent_vingt_et_un/helper/GameCommunication.dart';
import 'package:quatre_cent_vingt_et_un/model/Party.dart';
import 'package:quatre_cent_vingt_et_un/model/Player.dart';

class RoundSecond extends StatefulWidget {
  RoundSecond({
    Key key,
    this.party,
    this.playerID
  }): super(key: key);

  Party party;
  String playerID;

  @override
  _RoundSecondState createState() => _RoundSecondState();

}

class _RoundSecondState extends State<RoundSecond> {

  int _playerIndex;

  @override
  void initState() {
    super.initState();
    game.addListener(_onAction);
  }

  @override
  void dispose(){
    game.removeListener(_onAction);
    super.dispose();
  }

  _onAction(message) {
    switch (message['action']) {
      case 'resigned':
        Navigator.of(context).pop();
        break;

      case 'party_action':

        Map<String,dynamic> data = json.decode(message['data']);
        List<dynamic> players = data['players'];
        widget.party.players = [];
        players.forEach((element) {
          Player player = new Player.fromJson(element);
          widget.party.players.add(player);
        });

        setState(() {});

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Round 1 - ${widget.party.name}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _viewPlayers(),
            SizedBox(height: 20.0),
            _viewGame(),
          ],
        ),
      ),
    );
  }

  Widget _viewPlayers() {
    List<Widget> list = [];

    widget.party.players.asMap().forEach((key, player) {
      list.add(Row(
        children: <Widget>[
          Expanded(
            child: Text(player.name),
          ),
          Text(player.ranking),

//          (player.ranking == '1') ? _label(Colors.green, '#1') : Text(''),
//          (player.ranking == '${widget.party.players.length}') ? _label(Colors.red, 'Looser') : Text(''),

          Column(
            children: <Widget>[
              _dice(player.dice1),
              (player.lock1) ? Icon(Icons.lock) : Text(''),
            ],
          ),
          SizedBox(width: 10.0),
          Column(
            children: <Widget>[
              _dice(player.dice2),
              (player.lock2) ? Icon(Icons.lock) : Text(''),
            ],
          ),
          SizedBox(width: 10.0),
          Column(
            children: <Widget>[
              _dice(player.dice3),
              (player.lock3) ? Icon(Icons.lock) : Text(''),
            ],
          ),
          Text('  ')
        ],
      ));
    });

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: list,
      ),
    );
  }

  Widget _viewGame() {
    Widget toReturn = Text('');

    int i = 0;
    bool found = false;
    while(i < widget.party.players.length && !found) {
      if (widget.party.players[i].id == widget.playerID) {
        setState(() {
          _playerIndex = i;
        });
        toReturn = Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Column(
                    children: <Widget>[
                      _dice(widget.party.players[i].dice1),
                      Icon((widget.party.players[i].lock1) ? Icons.lock : Icons.lock_open)
                    ],
                  ),
                  onTap: () {
                    print("tap");
                    setState(() {
                      widget.party.players[_playerIndex].lock1 = !(widget.party.players[_playerIndex].lock1);
                    });
                    game.send('action_party', json.encode(widget.party));
                  },
                ),
                SizedBox(width: 10.0),
                GestureDetector(
                  child: Column(
                    children: <Widget>[
                      _dice(widget.party.players[i].dice2),
                      Icon((widget.party.players[i].lock2) ? Icons.lock : Icons.lock_open)
                    ],
                  ),
                  onTap: () {
                    print("tap");
                    setState(() {
                      widget.party.players[_playerIndex].lock2 = !(widget.party.players[_playerIndex].lock2);
                    });
                    game.send('action_party', json.encode(widget.party));
                  },
                ),
                SizedBox(width: 10.0),
                GestureDetector(
                  child: Column(
                    children: <Widget>[
                      _dice(widget.party.players[i].dice3),
                      Icon((widget.party.players[i].lock3) ? Icons.lock : Icons.lock_open)
                    ],
                  ),
                  onTap: () {
                    print("tap");
                    setState(() {
                      widget.party.players[_playerIndex].lock3 = !(widget.party.players[_playerIndex].lock3);
                    });
                    game.send('action_party', json.encode(widget.party));
                  },
                ),
              ],
            ),

            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('Roll'),
                  onPressed: () {
                    _roll();
                    _mathRanking();
                    game.send('action_party', json.encode(widget.party));
                  },
                ),
                RaisedButton(
                  child: Text('Next'),
                  onPressed: () {

                  },
                )
              ],
            ),
          ],
        );
      }
      i++;
    }

    return toReturn;
  }

  Widget _dice(String nb) {
    return Container(
      width: MediaQuery.of(context).size.width / 8,
      child: Image.asset('assets/Alea_$nb.png'),
    );
  }

  Widget _label(Color color, String txt) {
    return Container(
      width: 50.0,
      height: 30.0,
      color: color,
      margin: EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          txt,
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  _roll() {
    Random random = new Random();
    Player player = widget.party.players[_playerIndex];

    setState(() {
      int a = (player.lock1) ? int.parse(player.dice1) : random.nextInt(6) + 1;
      int b = (player.lock2) ? int.parse(player.dice2) : random.nextInt(6) + 1;
      int c = (player.lock3) ? int.parse(player.dice3) : random.nextInt(6) + 1;

      if (a > b && a > c) {
        widget.party.players[_playerIndex].dice1 = a.toString();
        if (b > c) {
          // A B C
          widget.party.players[_playerIndex].dice2 = b.toString();
          widget.party.players[_playerIndex].dice3 = c.toString();
        } else {
          // A C B
          widget.party.players[_playerIndex].dice2 = c.toString();
          widget.party.players[_playerIndex].dice3 = b.toString();
          // swap lock 2 / 3
          bool temp = widget.party.players[_playerIndex].lock2;
          widget.party.players[_playerIndex].lock2 = widget.party.players[_playerIndex].lock3;
          widget.party.players[_playerIndex].lock3 = temp;
        }
      } else if (b > a && b > c) {
        widget.party.players[_playerIndex].dice1 = b.toString();
        if (a > c) {
          // B A C
          widget.party.players[_playerIndex].dice2 = a.toString();
          widget.party.players[_playerIndex].dice3 = c.toString();
          // swap lock 1 / 2
          bool temp = widget.party.players[_playerIndex].lock2;
          widget.party.players[_playerIndex].lock2 = widget.party.players[_playerIndex].lock1;
          widget.party.players[_playerIndex].lock1 = temp;
        } else {
          // B C A
          widget.party.players[_playerIndex].dice2 = c.toString();
          widget.party.players[_playerIndex].dice3 = a.toString();
          // swap all
          bool temp1 = widget.party.players[_playerIndex].lock1;
          bool temp2 = widget.party.players[_playerIndex].lock2;
          widget.party.players[_playerIndex].lock2 = widget.party.players[_playerIndex].lock3;
          widget.party.players[_playerIndex].lock3 = temp1;
          widget.party.players[_playerIndex].lock1 = temp2;
        }
      } else {
        widget.party.players[_playerIndex].dice1 = c.toString();
        if (a > b) {
          // C A B
          widget.party.players[_playerIndex].dice2 = a.toString();
          widget.party.players[_playerIndex].dice3 = b.toString();
          // swaps all
          bool temp1 = widget.party.players[_playerIndex].lock1;
          bool temp2 = widget.party.players[_playerIndex].lock2;
          widget.party.players[_playerIndex].lock1 = widget.party.players[_playerIndex].lock3;
          widget.party.players[_playerIndex].lock2 = temp1;
          widget.party.players[_playerIndex].lock3 = temp2;

        } else {
          // C B A
          widget.party.players[_playerIndex].dice2 = b.toString();
          widget.party.players[_playerIndex].dice3 = a.toString();
          // swap 1 / 3
          bool temp = widget.party.players[_playerIndex].lock1;
          widget.party.players[_playerIndex].lock1 = widget.party.players[_playerIndex].lock3;
          widget.party.players[_playerIndex].lock3 = temp;
        }
      }


      // Set ranking (1 -> 17)
      int total = (int.parse(widget.party.players[_playerIndex].dice1) * 100)
        + (int.parse(widget.party.players[_playerIndex].dice2) * 10)
        + int.parse(widget.party.players[_playerIndex].dice3);
      if (total != 0) {
        setState(() {
          switch (total) {
            case 421:
              player.ranking = '1';
              break;
            case 111:
              player.ranking = '2';
              break;
            case 611:
              player.ranking = '3';
              break;
            case 666:
              player.ranking = '4';
              break;
            case 511:
              player.ranking = '5';
              break;
            case 555:
              player.ranking = '6';
              break;
            case 411:
              player.ranking = '7';
              break;
            case 444:
              player.ranking = '8';
              break;
            case 311:
              player.ranking = '9';
              break;
            case 333:
              player.ranking = '10';
              break;
            case 211:
              player.ranking = '11';
              break;
            case 222:
              player.ranking = '12';
              break;
            case 654:
              player.ranking = '13';
              break;
            case 543:
              player.ranking = '14';
              break;
            case 432:
              player.ranking = '15';
              break;
            case 321:
              player.ranking = '16';
              break;
            case 221:
              player.ranking = '17';
              break;
          }
        });
      }

    });
  }

  _mathRanking() {



    widget.party.players.asMap().forEach((index, player) {
      int total = (int.parse(player.dice1) * 100) + (int.parse(player.dice2) * 10) + int.parse(player.dice3);
      // Set ranking (1 from 17)

    });
  }

}

*/
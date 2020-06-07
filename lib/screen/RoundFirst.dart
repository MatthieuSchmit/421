/*
 * 421 - /RoundFirst
 *
 * by Matthieu at 2020-06-05 12:10
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

class RoundFirst extends StatefulWidget {
  RoundFirst({
    Key key,
    this.party,
    this.playerID,
  }): super(key: key);

  Party party;
  String playerID;

  @override
  _RoundFirstState createState() => _RoundFirstState();

}

class _RoundFirstState extends State<RoundFirst> {

  int _playerIndex;

  String _firstToPlay;

  @override
  void initState() {
    super.initState();

    _firstToPlay = widget.party.playIndex;

    int i = 0;
    bool found = false;
    while(i < widget.party.players.length && !found) {
      if (widget.party.players[i].id == widget.playerID) {
        setState(() {
          _playerIndex = i;
        });
      }
      i++;
    }

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

        widget.party.token = data['token'];
        widget.party.lastIndex = data['lastIndex'];
        widget.party.firstIndex = data['firstIndex'];
        widget.party.playIndex = data['playIndex'];

        if (widget.party.token == 0) {
          List<dynamic> winners = data['winners'];
          widget.party.winners = [];
          winners.forEach((element) {
            widget.party.winners.add(element);
          });
        }

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

            Text('Jetons à distribuer : ${widget.party.token}'),

            SizedBox(height: 20.0),
            (widget.party.token == 0) ? _viewEndGame() : _viewGame(),
            //_viewEndRound(),
          ],
        ),
      ),
    );
  }

  Widget _viewPlayers() {
    List<Widget> list = [];

    widget.party.players.asMap().forEach((key, player) {
      list.add(Container(
        padding: EdgeInsets.all(5.0),
        color: (widget.party.firstIndex == '$key') ? Colors.lightGreenAccent : ((widget.party.lastIndex == '$key') ? Colors.redAccent : Colors.white),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Text(player.name),
                  _label(Colors.white, '${player.token}'),
                  (widget.playerID == player.id) ? _label(Colors.yellow, 'you') : Text(''),
                  (widget.party.winners.contains(player.id)) ? Text('#1') : Text(''),
                ],
              ),
            ),
            Text(player.ranking),
            _dice(player.dice1),
            SizedBox(width: 5.0),
            _dice(player.dice2),
            SizedBox(width: 5.0),
            _dice(player.dice3),

          ],
        ),
      ));
    });

    return Column(
      children: list,
    );
  }

  Widget _viewGame() {
    if (widget.party.players[int.parse(widget.party.playIndex)].dice1 != '0') {
      // Déjà joué => finish
      return Column(
        children: <Widget>[
          Text('Tour complet'),
          Text('LOOSER : ${widget.party.players[int.parse(widget.party.lastIndex)].name}'),
          Text('+ ${widget.party.players[int.parse(widget.party.firstIndex)].ranking} tokens'),
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              _endRound();
            },
          )
        ],
      );
    } else if (widget.party.players[int.parse(widget.party.playIndex)].id == widget.playerID) {
      // Your turn
      setState(() {
        _playerIndex = int.parse(widget.party.playIndex);
      });
      return RaisedButton(
        onPressed: () {
          _roll();
          _mathRanking();
          setState(() {
            int nextIndex = _playerIndex + 1;
            if (nextIndex == widget.party.players.length) {
              nextIndex = 0;
            }
            widget.party.playIndex = '$nextIndex';
          });
          game.send('action_party', json.encode(widget.party));
        },
        child: Text('Play'),
      );
    } else {
      // Not your turn - wait
      return Text('');
    }
  }

  Widget _viewEndGame() {
    List<Widget> list = [];
    widget.party.winners.forEach((element) {
      list.add(Text(element));
    });

    return Column(
      children: <Widget>[
        Text('Charge finie'),
        Text('First Winners : '),
        Column(children: list),
      ],
    );
  }

  Widget _dice(String nb) {
    return Container(
      width: MediaQuery.of(context).size.width / 9,
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

  _endRound() {
    // Set token

    int tokenToTake = 0;
    if (int.parse(widget.party.players[int.parse(widget.party.firstIndex)].ranking) > widget.party.token) {
      tokenToTake = widget.party.token;
    } else {
      tokenToTake = int.parse(widget.party.players[int.parse(widget.party.firstIndex)].ranking);
    }

    widget.party.players[int.parse(widget.party.lastIndex)].token
    = widget.party.players[int.parse(widget.party.lastIndex)].token
      + tokenToTake;
    widget.party.token = widget.party.token - tokenToTake;

    widget.party.players.forEach((element) {
      element.ranking = '0';
      element.dice1 = '0';
      element.dice2 = '0';
      element.dice3 = '0';
    });

    widget.party.playIndex = widget.party.lastIndex;
    widget.party.firstIndex = widget.party.lastIndex;

    setState(() {});

    if (widget.party.token == 0) _endGame();

    game.send('action_party', json.encode(widget.party));

  }

  _endGame() {
    widget.party.players.asMap().forEach((key, player) {
      if (player.token == 0) {
        // Winner
        widget.party.winners.add(player.id);
      }
    });
    setState(() {});
  }

  _roll() {
    Random random = new Random();
    Player player = widget.party.players[_playerIndex];

    setState(() {
      int a = random.nextInt(6) + 1;
      int b = random.nextInt(6) + 1;
      int c = random.nextInt(6) + 1;

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
        }
      } else if (b > a && b > c) {
        widget.party.players[_playerIndex].dice1 = b.toString();
        if (a > c) {
          // B A C
          widget.party.players[_playerIndex].dice2 = a.toString();
          widget.party.players[_playerIndex].dice3 = c.toString();
        } else {
          // B C A
          widget.party.players[_playerIndex].dice2 = c.toString();
          widget.party.players[_playerIndex].dice3 = a.toString();
        }
      } else {
        widget.party.players[_playerIndex].dice1 = c.toString();
        if (a > b) {
          // C A B
          widget.party.players[_playerIndex].dice2 = a.toString();
          widget.party.players[_playerIndex].dice3 = b.toString();

        } else {
          // C B A
          widget.party.players[_playerIndex].dice2 = b.toString();
          widget.party.players[_playerIndex].dice3 = a.toString();
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
              player.ranking = '10';
              break;
            case 111:
              player.ranking = '7';
              break;
            case 611:
            case 666:
              player.ranking = '6';
              break;
            case 511:
            case 555:
              player.ranking = '5';
              break;
            case 411:
            case 444:
              player.ranking = '4';
              break;
            case 311:
            case 333:
              player.ranking = '3';
              break;
            case 211:
            case 222:
              player.ranking = '2';
              break;
            case 321:
            case 432:
            case 543:
            case 654:
              player.ranking = '2';
              break;
            default:
              player.ranking = '1';
              break;
          }
        });
      }

    });
  }

  _mathRanking() {
    widget.party.players.asMap().forEach((index, player) {
      if (player.ranking != '0') {
        if (int.parse(widget.party.players[int.parse(widget.party.firstIndex)].ranking) < int.parse(player.ranking)) {
          // Player become first
          widget.party.firstIndex = '$index';
        } else if (int.parse(widget.party.players[int.parse(widget.party.lastIndex)].ranking) > int.parse(player.ranking)) {
          // Player become last
          widget.party.lastIndex = '$index';
        } else {
          // 1 point
          int totalF = (int.parse(widget.party.players[int.parse(widget.party.firstIndex)].dice1)*100)
            + (int.parse(widget.party.players[int.parse(widget.party.firstIndex)].dice2)*10)
            + int.parse(widget.party.players[int.parse(widget.party.firstIndex)].dice3);
          int totalL = (int.parse(widget.party.players[int.parse(widget.party.lastIndex)].dice1)*100)
            + (int.parse(widget.party.players[int.parse(widget.party.lastIndex)].dice2)*10)
            + int.parse(widget.party.players[int.parse(widget.party.lastIndex)].dice3);
          int totalP = (int.parse(player.dice1)*100)
            + (int.parse(player.dice2)*10)
            + int.parse(player.dice3);

          if (totalP > totalF && widget.party.players[int.parse(widget.party.firstIndex)].ranking == player.ranking) {
            widget.party.firstIndex = '$index';
          } else if (totalP < totalF && widget.party.players[int.parse(widget.party.lastIndex)].ranking == player.ranking) {
            widget.party.lastIndex = '$index';
          }
        }
      }
    });

    setState(() {});

  }

}
*/
/*
 * 421 - /StartPage
 *
 * by Matthieu at 2020-06-04 12:36
 *
 */

import 'dart:convert';

import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quatre_cent_vingt_et_un/helper/Game.dart';
import 'package:quatre_cent_vingt_et_un/helper/GameCommunication.dart';
import 'package:quatre_cent_vingt_et_un/model/Party.dart';
import 'package:quatre_cent_vingt_et_un/model/Player.dart';
import 'package:quatre_cent_vingt_et_un/screen/game/Charge.dart';
import 'package:quatre_cent_vingt_et_un/screen/rule/Rules.dart';
import 'package:quatre_cent_vingt_et_un/screen/widget/Dice.dart';

import 'game/Uncharge.dart';
import 'widget/ColorLabel.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  static final TextEditingController _name = new TextEditingController();
  static final TextEditingController _game = new TextEditingController();

  String playerName;
  String playerID;
  Party _party;

  @override
  void initState() {
    super.initState();
    game.addListener(_onGameDataReceived);
  }

  @override
  void dispose() {
    game.removeListener(_onGameDataReceived);
    super.dispose();
  }

  _onGameDataReceived(message) {
    switch (message["action"]) {

      //
      case "party_info":
        //print(message['data']);
        if (_party == null) {
          _party = new Party.fromJson(message["data"]);
        }
        List<dynamic> players = message['data']['players'];
        players.forEach((element) {
          Player player = new Player.fromJson(element);
          if (_party.players.indexWhere((e) => e.id == player.id) == -1) {
            _party.players.add(player);
          }
        });
        if (_party.host == playerID) {
          game.send('action_party', json.encode(_party));
        }
        setState(() {});
        break;

      // Launch party
      case 'party_play':
        _party.open = false;
        setState(() {});
        break;


      // Update _party after each player's action
      case 'party_action':

        Map<String,dynamic> data = json.decode(message['data']);

        List<dynamic> players = data['players'];
        _party.players = [];
        players.forEach((element) {
          Player player = new Player.fromJson(element);
          _party.players.add(player);
        });

        _party.token = data['token'];
        _party.lastIndex = data['lastIndex'];
        _party.firstIndex = data['firstIndex'];
        _party.playIndex = data['playIndex'];
        _party.nbRound = data['nbRound'];

        _party.maxRolled = data['maxRolled'];
        _party.rolled = data['rolled'];
        _party.firstPlayerIndex = data['firstPlayerIndex'];

        if (_party.token == 0) {
          List<dynamic> winners = data['winners'];
          _party.winners = [];
          winners.forEach((element) {
            _party.winners.add(element);
          });
        }

        setState(() {});

        break;

      // The player just join
      case 'joined':
        print(message['data']);
        playerID = message['data']['id'];
        break;

      case 'eject':
        _party = null;
        setState(() {});
        break;
    }
  }

  /// ------------------------------------------------------
  /// The user wants to join, so let's send his/her name
  /// As the user has a name, we may now show the other players
  /// ------------------------------------------------------
  _onGameJoin() {
    game.send('join', _name.text);

    /// Force a rebuild
    setState(() {});
  }

  Widget _bodyHome() {
    if (game.playerName != "") {
      return new Container();
    }
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _name,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              icon: const Icon(Icons.person),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: _onGameJoin,
              child: Text('Join !'),
            ),
          )
        ],
      ),
    );
  }

  // List of players + button 'play'
  Widget _bodyGame() {
    if (_party == null) return Container();

    if (!_party.open && _party.nbRound == 1) return Charge(playerID: playerID, party: _party);

    if (!_party.open && _party.nbRound == 2) return Uncharge(playerID: playerID, party: _party);

    List<Widget> list = [];

    list.add(Center(
      child: Text(
        'id: ${_party.id}'
      ),
    ));

    int index = 0;
    _party.players.asMap().forEach((key,player) {
      if (player.id == playerID) index = key;
      list.add(Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                (_party.host == player.id) ? ColorLabel(text: 'Host',color: Colors.yellow) : Text(''),
                SizedBox(width: 10.0),
                Text(
                  player.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                /*
                (playerID == player.id || playerID == _party.host) ? FlatButton(
                  child: Text('Eject'),
                  onPressed: () {
                    game.send('eject', json.encode(player.id));
                  },
                ) : Text(''),
                */
              ],
            ),
          ),
          Dice(dice: player.dice1, width: MediaQuery.of(context).size.width/8),
        ],
      ));
    });


    if (_party.players[index].dice1 == 0) {
      list.add(ListTile(
        title: Center(
          child: Text('Roll'),
        ),
        onTap: () {
          _party.players[index].dice1 = rollDices(1)[0];
          _party.players.sort((b,a) => a.dice1.compareTo(b.dice1));
          game.send('action_party', json.encode(_party));
        },
      ));
    }



    if (_party.host == playerID) {
      list.add(ListTile(
        title: Center(
          child: Text('Play'),
        ),
        onTap: () {

          _party.players.forEach((element) {
            element.dice1 = 0;
          });

          game.send('play_party', _party.id);
        },
      ));
    }

    list.add(QrImage(
      data: _party.id,
      version: QrVersions.auto,
      size: MediaQuery.of(context).size.width * 0.7,
    ),);

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(children: list),
    );
  }

  // View to create / join a party
  Widget _bodyFormGame() {
    if (_party != null || game.playerName == "") return new Container();

    return Column(
      children: <Widget>[
        TextField(
          controller: _game,
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
            hintText: 'Game\'s name / id',
            contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(32.0),
            ),
            icon: const Icon(Icons.person),
          ),
        ),
        Row(
          children: <Widget>[
            RaisedButton(
              child: Text('Create'),
              onPressed: () {
                game.send('new_party', _game.text);
                /// Force a rebuild
                setState(() {});
              },
            ),
            RaisedButton(
              child: Text('Join'),
              onPressed: () {
                print(_game.text);
                game.send('join_party', _game.text);
                /// Force a rebuild
                setState(() {});
              },
            )
          ],
        ),
        RaisedButton(
          child: Text('Scan'),
          onPressed: _scan,
        )
      ],
    );
  }


  // Launch the camera
  Future _scan() async {
    try {
      String barcode = (await BarcodeScanner.scan()).rawContent;
      game.send('join_party', barcode);
      /// Force a rebuild
      setState(() {});
    } on PlatformException catch(e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        print('The user did not grant the camera persmission');
      } else {
        print('Error... : $e');
      }
    } on FormatException {
      print('Error...');
    } catch(e) {
      print('Error... : $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: new AppBar(
          title: (_party == null) ? Text('421') : Text(_party.name),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(
                  builder: (BuildContext context)
                  => new Rules(),
                ));
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _bodyHome(),
              _bodyFormGame(),
              _bodyGame(),
            ],
          ),
        ),
      ),
    );
  }

}

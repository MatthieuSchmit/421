/*
 * 421 - /StartPage
 *
 * by Matthieu at 2020-06-04 12:36
 *
 */

import 'package:flutter/material.dart';
import 'package:quatre_cent_vingt_et_un/helper/GameCommunication.dart';
import 'package:quatre_cent_vingt_et_un/model/Party.dart';
import 'package:quatre_cent_vingt_et_un/model/Player.dart';
import 'package:quatre_cent_vingt_et_un/screen/rule/Rules.dart';

import 'GamePage.dart';
import 'RoundFirst.dart';


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

      case "party_info":
        print(message['data']);
        if (_party == null) {
          _party = new Party.fromJson(message["data"]);
        }
        List<dynamic> players = message['data']['players'];
        _party.players = [];
        players.forEach((element) {
          _party.players.add(new Player.fromJson(element));
        });
        setState(() {});
        break;

      case 'party_play':
        _party.open = false;
        Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context)
          => RoundFirst(
            party: _party,
            playerID: playerID,
          ),
        ));
        break;

      case 'joined':
        print(message['data']);
        playerID = message['data']['id'];
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

    List<Widget> list = [];

    list.add(Center(
      child: Text(
        'id: ${_party.id}'
      ),
    ));

    _party.players.forEach((player) {
      list.add(ListTile(
        leading: (_party.host == player.id) ? Text('Host') : Text(''),
        title: Text(player.name),
        trailing: (_party.host == playerID) ? RaisedButton(
          onPressed: (){
            game.send('eject', player.id);
          },
          child: Text('Eject'),
        ) : Text(''),
      ));
    });

    if (_party.host == playerID) {
      list.add(ListTile(
        title: Center(
          child: Text('Play'),
        ),
        onTap: () {
          game.send('play_party', _party.id);
        },
      ));
    }

    return new Column(
      children: list,
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
        )
      ],
    );
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

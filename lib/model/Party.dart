/*
 * 421 - /Party
 *
 * by Matthieu at 2020-06-04 16:22
 *
 */

import 'package:quatre_cent_vingt_et_un/model/Player.dart';

class Party {
  String id;
  String name;
  List<Player> players;
  int index;
  String host;
  bool open = true;
  int nbRound = 1;
  int token = 21;
  int rolled = 3;

  Party({this.id, this.name, this.players, this.index, this.host});

  factory Party.fromJson(Map<String,dynamic> parsedJson) {
    return Party(
      id: parsedJson["id"],
      name: parsedJson["name"],
      players: [], // parsedJson["players"],

      index: (parsedJson['index'] is int) ? parsedJson['index'] : int.parse(parsedJson['index']),

      //index: parsedJson["index"],
      host: parsedJson['host'],
    );
  }

  Map<String,dynamic> toJson() {
    return {
      "id": this.id,
      "name" : this.name,
      "index" : this.index,
      "host" : this.host,
      "open" : this.open,
      "players" : this.players,
      "nbRound" : this.nbRound,

    };
  }

}

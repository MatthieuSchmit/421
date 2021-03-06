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

  int playIndex = 0;
  int firstIndex = 0;
  int lastIndex = 0;

  List<String> winners = [];
  List<String> ranking = [];

  int nbRound = 1;
  int token = 21;

  int maxRolled;
  int rolled;
  int firstPlayerIndex = 0;

  Party({
    this.id, this.name, this.players, this.index, this.host, this.playIndex,
    this.firstIndex, this.lastIndex, this.token, this.firstPlayerIndex,
    this.rolled, this.maxRolled
  });

  factory Party.fromJson(Map<String,dynamic> parsedJson) {
    return Party(
      id: parsedJson["id"],
      name: parsedJson["name"],
      players: [],
      index: (parsedJson['index'] is int) ? parsedJson['index'] : int.parse(parsedJson['index']),
      host: parsedJson['host'],
      playIndex: parsedJson['playIndex'] ?? 0,

      firstIndex: parsedJson['firstIndex'] ?? 0,
      lastIndex: parsedJson['lastIndex'] ?? 0,
      token: parsedJson['token'] ?? 21,
      firstPlayerIndex: parsedJson['firstPlayerIndex'] ?? 0,
      rolled: parsedJson['rolled'] ?? 0,
      maxRolled: parsedJson['maxRolled'] ?? 3,
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
      "playIndex" : this.playIndex,
      "firstIndex" : this.firstIndex,
      "lastIndex" : this.lastIndex,
      "token" : this.token,

      "winners" : this.winners,
      "ranking" : this.ranking,
      "firstPlayerIndex" : this.firstPlayerIndex,
      "rolled" : this.rolled,
      "maxRolled" : this.maxRolled
    };
  }

}

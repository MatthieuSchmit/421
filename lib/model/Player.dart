/*
 * 421 - /Player
 *
 * by Matthieu at 2020-06-05 14:25
 *
 */

class Player {
  String id;
  String name;
  String dice1;
  String dice2;
  String dice3;
  bool lock1;
  bool lock2;
  bool lock3;

  String ranking = '0';

  int token = 0;

  Player({this.id, this.name, this.dice1, this.dice2, this.dice3, this.lock1, this.lock2, this.lock3, this.ranking, this.token});

  factory Player.fromJson(Map<String,dynamic> parsedJson) {
    return Player(
      id: parsedJson['id'],
      name: parsedJson['name'],

      dice1: parsedJson['dice1'] ?? '0',
      dice2: parsedJson['dice2'] ?? '0',
      dice3: parsedJson['dice3'] ?? '0',

      lock1: parsedJson['lock1'] ?? false,
      lock2: parsedJson['lock2'] ?? false,
      lock3: parsedJson['lock3'] ?? false,

      ranking: parsedJson['ranking'] ?? '0',
      token: parsedJson['token'] ?? 0
    );
  }

  Map<String,dynamic> toJson() {
    return {
      'id' : this.id,
      'name' : this.name,
      'dice1' : this.dice1,
      'dice2' : this.dice2,
      'dice3' : this.dice3,
      'lock1' : this.lock1,
      'lock2' : this.lock2,
      'lock3' : this.lock3,
      'ranking' : this.ranking,
      'token' : this.token
    };
  }

}


/*
 * 421 - /Game
 *
 * by Matthieu at 2020-06-07 09:49
 *
 */

import 'dart:math';

import 'package:quatre_cent_vingt_et_un/model/Party.dart';
import 'package:quatre_cent_vingt_et_un/model/Player.dart';

/// Roll [nb] dices
List<int> rollDices(int nb) {
  List<int> results = [];

  Random random = new Random();

  for(int i=0; i<nb; i++) {
    results.add((random.nextInt(6) + 1));
  }

  return results;
}

/// Roll unlocked dices
Player rollUncharge(Player player) {
  // temp value
  bool temp1 = player.lock1;
  bool temp2 = player.lock2;
  bool temp3 = player.lock3;
  // roll
  Random random = new Random();
  int a = (player.lock1) ? player.dice1 : random.nextInt(6) + 1;
  int b = (player.lock2) ? player.dice2 : random.nextInt(6) + 1;
  int c = (player.lock3) ? player.dice3 : random.nextInt(6) + 1;
  // sort
  List<int> results = sortDesc([a,b,c]);
  // change locks
  player.lock1 = false;
  player.lock2 = false;
  player.lock3 = false;
  if (temp1) {
    int position = results.indexWhere((element) => player.dice1 == element);
    switch (position) {
      case 0:
        player.lock1 = temp1;
        break;
      case 1:
        player.lock2 = temp1;
        break;
      case 2:
        player.lock3 = temp1;
        break;
    }
  }
  if (temp2) {
    int position = results.indexWhere((element) => player.dice2 == element);
    switch (position) {
      case 0:
        player.lock1 = temp2;
        break;
      case 1:
        player.lock2 = temp2;
        break;
      case 2:
        player.lock3 = temp2;
        break;
    }
  }
  if (temp3) {
    int position = results.indexWhere((element) => player.dice3 == element);
    switch (position) {
      case 0:
        player.lock1 = temp3;
        break;
      case 1:
        player.lock2 = temp3;
        break;
      case 2:
        player.lock3 = temp3;
        break;
    }
  }

  // set result
  player.dice1 = results[0];
  player.dice2 = results[1];
  player.dice3 = results[2];

  player.point = getPoint(results);

  return player;
}

/// Sort desc
List<int> sortDesc(List<int> arr) {
  arr.sort((b, a) => a.compareTo(b));
  return arr;
}

/// Sort asc
List<int> sortAsc(List<int> arr) {
  arr.sort((a, b) => a.compareTo(b));
  return arr;
}

/// Get points
int getPoint(List<int> dices) {

  // 421
  if (dices.contains(4) && dices.contains(2) && dices.contains(1)) return 10;
  // 111
  if ((dices.where((e) => e == 1)).length == 3) return 7;
  // 11x
  if ((dices.where((e) => e == 1)).length == 2) {
    if (dices.contains(6)) return 6; // 116
    if (dices.contains(5)) return 5; // 115
    if (dices.contains(4)) return 4; // 114
    if (dices.contains(3)) return 3; // 113
    if (dices.contains(2)) return 2; // 112
  }
  // 666
  if ((dices.where((e) => e == 6)).length == 3) return 6;
  // 555
  if ((dices.where((e) => e == 5)).length == 3) return 5;
  // 444
  if ((dices.where((e) => e == 4)).length == 3) return 4;
  // 333
  if ((dices.where((e) => e == 3)).length == 3) return 3;
  // 222
  if ((dices.where((e) => e == 2)).length == 3) return 2;
  // 123
  if (dices.contains(1) && dices.contains(2) && dices.contains(3)) return 2;
  // 234
  if (dices.contains(4) && dices.contains(2) && dices.contains(3)) return 2;
  // 345
  if (dices.contains(5) && dices.contains(4) && dices.contains(3)) return 2;
  // 456
  if (dices.contains(4) && dices.contains(5) && dices.contains(6)) return 2;

  // Rest
  return 1;

  /*
  int total = dices[0] * 100 + dices[1] * 10 + dices[2];

  switch (total) {
    case 421:
      return 10;
      break;
    case 111:
      return 7;
      break;
    case 611:
    case 666:
      return 6;
      break;
    case 511:
    case 555:
      return 5;
      break;
    case 411:
    case 444:
      return 4;
      break;
    case 311:
    case 333:
      return 3;
      break;
    case 211:
    case 222:
    case 321:
    case 432:
    case 543:
    case 654:
      return 2;
      break;
    default:
      return 1;
      break;
  }
  */

}

/// Get ranking
int getRanking(List<int> dices) {
  // 421
  if (dices.contains(4) && dices.contains(2) && dices.contains(1)) return 1;
  // 111
  if ((dices.where((e) => e == 1)).length == 3) return 2;
  // 11x
  if ((dices.where((e) => e == 1)).length == 2) {
    if (dices.contains(6)) return 3; // 116
    if (dices.contains(5)) return 5; // 115
    if (dices.contains(4)) return 7; // 114
    if (dices.contains(3)) return 9; // 113
    if (dices.contains(2)) return 11; // 112
  }
  // 666
  if ((dices.where((e) => e == 6)).length == 3) return 4;
  // 555
  if ((dices.where((e) => e == 5)).length == 3) return 6;
  // 444
  if ((dices.where((e) => e == 4)).length == 3) return 8;
  // 333
  if ((dices.where((e) => e == 3)).length == 3) return 10;
  // 222
  if ((dices.where((e) => e == 2)).length == 3) return 12;
  // 123
  if (dices.contains(1) && dices.contains(2) && dices.contains(3)) return 16;
  // 234
  if (dices.contains(4) && dices.contains(2) && dices.contains(3)) return 15;
  // 345
  if (dices.contains(5) && dices.contains(4) && dices.contains(3)) return 14;
  // 456
  if (dices.contains(4) && dices.contains(5) && dices.contains(6)) return 13;

  // Rest
  return 17;
}

/// Set winner and looser
Party setRanking(Party party) {
  party.players.asMap().forEach((key, player) {
    if (player.point != 0) {
      int rankingPlayer = getRanking([player.dice1, player.dice2, player.dice3]);
      int rankingFirst = getRanking([party.players[party.firstIndex].dice1, party.players[party.firstIndex].dice2, party.players[party.firstIndex].dice3]);
      int rankingLast = getRanking([party.players[party.lastIndex].dice1, party.players[party.lastIndex].dice2, party.players[party.lastIndex].dice3]);

      // Testing first
      if (rankingPlayer == 17 && rankingFirst == 17) {
        // test combination
        List<int> sortPlayer = sortDesc([player.dice1, player.dice2, player.dice3]);
        List<int> sortFirst = sortDesc([party.players[party.firstIndex].dice1, party.players[party.firstIndex].dice2, party.players[party.firstIndex].dice3]);
        int totalPlayer = sortPlayer[0]*100 + sortPlayer[1]*10 + sortPlayer[2];
        int totalFirst = sortFirst[0]*100 + sortFirst[1]*10 + sortFirst[2];
        if (totalPlayer > totalFirst) {
          party.firstIndex = key;
        }
      } else if (rankingPlayer < rankingFirst) {
        // player first
        party.firstIndex = key;
      }

      // Testing last
      if (rankingPlayer == 17 && rankingLast == 17) {
        // test combination
        List<int> sortPlayer = sortDesc([player.dice1, player.dice2, player.dice3]);
        List<int> sortLast = sortDesc([party.players[party.lastIndex].dice1, party.players[party.lastIndex].dice2, party.players[party.lastIndex].dice3]);
        int totalPlayer = sortPlayer[0]*100 + sortPlayer[1]*10 + sortPlayer[2];
        int totalLast = sortLast[0]*100 + sortLast[1]*10 + sortLast[2];
        if (totalPlayer < totalLast) {
          party.lastIndex = key;
        }
      } else if (rankingPlayer > rankingLast) {
        // player last
        party.lastIndex = key;
      }
    }
  });

  return party;
}


/// Set winner and looser
Party setRanking_(Party party) {
  party.winners = [];
  party.players.asMap().forEach((key, player) {
    if (player.point != 0) {
      if (party.players[party.firstIndex].point < player.point) {
        // player become first
        party.firstIndex = key;
      } else if (party.players[party.lastIndex].point > player.point) {
        // player become last
        party.lastIndex = key;
      } else {
        // 1 point
        int totalFirst = (party.players[party.firstIndex].dice1 * 100) + (party.players[party.firstIndex].dice2 * 10) + party.players[party.firstIndex].dice3;
        int totalLast = (party.players[party.lastIndex].dice1 * 100) + (party.players[party.lastIndex].dice2 * 10) + party.players[party.lastIndex].dice3;
        int totalPlayer = (player.dice1 * 100) + (player.dice2 * 10) + player.dice3;

        if (totalPlayer > totalFirst && party.players[party.firstIndex].point == player.point) {
          party.firstIndex = key;
        } else if(totalPlayer < totalLast && party.players[party.lastIndex].point == player.point) {
          party.lastIndex = key;
        }

      }
    }
    if (player.token == 0) {
      party.winners.add(player.id);
    }
  });

  return party;
}







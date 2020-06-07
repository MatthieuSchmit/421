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

}

/// Set winner and looser
Party setRanking(Party party) {
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







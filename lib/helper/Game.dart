/*
 * 421 - /Game
 *
 * by Matthieu at 2020-06-07 09:49
 *
 */

import 'dart:math';

import 'package:quatre_cent_vingt_et_un/model/Party.dart';

/// Roll [nb] dices
List<int> rollDices(int nb) {
  List<int> results = [];

  Random random = new Random();

  for(int i=0; i<nb; i++) {
    results.add((random.nextInt(6) + 1));
  }

  return results;
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
    } else {
      party.winners.add(player.id);
    }
  });

  return party;
}







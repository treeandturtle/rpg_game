import 'dart:io';

import 'package:rpg_game/character_model.dart';
import 'package:rpg_game/game_model.dart';
import 'package:rpg_game/monster.model.dart';

void main() {
  print('환영합니다! RPG 게임을 시작합니다.');
  print('게임을 시작하기 전에 캐릭터의 이름을 입력해주세요.');

  final RegExp nameRegExp = RegExp(r'^[a-zA-Z가-힣]+$');
  String? name = stdin.readLineSync();
  while (name == null || name.isEmpty || !nameRegExp.hasMatch(name)) {
    print('이름은 영문만 사용할 수 있고, 공백이나 특수문자/숫자는 허용되지 않습니다.');
    print('이름을 다시 입력하세요:');
    name = stdin.readLineSync();
  }
  Character character = loadCharacterStats(name);
  character.healthIncrease(character); // 도전 기능 1: 캐릭터의 체력 증가
  List<Monster> monsters = loadMonsterStats();

  Game game = Game(character: character, monsters: monsters);
  game.startgame();
}

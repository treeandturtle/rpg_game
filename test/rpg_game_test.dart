import 'dart:io';

import 'package:rpg_game/character_model.dart';
import 'package:rpg_game/game_model.dart';
import 'package:rpg_game/monster.model.dart';

void main() {
  print('현재 작업 디렉토리: ${Directory.current.path}');

  final file = File('characters.txt');
  print('파일 존재 여부: ${file.existsSync()}');
  print('이름을 입력하세요');
  String? name = stdin.readLineSync();
  while (name == null || name.isEmpty) {
    print('이름을 다시 입력하세요');
    name = stdin.readLineSync();
  }
  Character character = loadCharacterStats(name);
  List<Monster> monsters = loadMonsterStats();

  Game(character: character, monsters: monsters);
}

import 'dart:io';
import 'dart:math';

import 'package:rpg_game/character_model.dart';

class Monster {
  String name;
  int health;
  int attackPower;
  int defense = 0;

  Monster({
    required this.name,
    required this.health,
    required this.attackPower,
  });

  void attackCharacter(Character character) {
    int damage = attackPower - character.defense;
    if (damage > 0) {
      character.health -= damage;
      print('$name은 ${character.name}에게 $damage의 피해를 입혔습니다.');
    } else {
      print('$name이 약해 ${character.name}에게 피해를 입히지 못했습니다.');
    }
  }

  void showStatus() {
    print('$name의 상태: 체력 $health, 공격력 $attackPower, 방어력 $defense');
  }
}

List<Monster> loadMonsterStats() {
  final File file;
  final List<String> lines;
  try {
    file = File('monsters.txt');
    lines = file.readAsLinesSync();
  } catch (e) {
    throw FileSystemException('monsters.txt 파일을 찾을 수 없습니다. 파일이 존재하는지 확인하세요.');
  }

  Random random = Random();
  List<Monster> monsters = [];

  for (var line in lines) {
    final parts = line.split(',');
    if (parts.length != 3) {
      throw FormatException('monsters.txt 내용이 올바르지 않아요!');
    }

    String name = parts[0];
    int health = int.parse(parts[1]);
    int maxAttack = int.parse(parts[2]);

    int attack = random.nextInt(maxAttack) + 1;

    monsters.add(Monster(name: name, health: health, attackPower: attack));
  }

  return monsters;
}

import 'dart:io';
import 'dart:math';

import 'package:rpg_game/abstract_model.dart';

//클래스 Monster는 RPG 게임에서 몬스터를 나타내는 모델입니다.
// attackCharacter 메서드를 통해 캐릭터를 공격하고,
// showStatus 메서드를 통해 몬스터의 상태를 출력합니다.
// loadMonsterStats 메서드를 통해 몬스터의 상태를 파일에서 불러옵니다.
class Monster extends Unit {
  int turnCounter = 0;
  Monster(String name, int health, int attackpower)
    : super(name, health, attackpower, 0);

  @override
  void attack(Unit character) {
    int damage = attackPower - character.defense;
    if (damage > 0) {
      character.health -= damage;
      print('$name은 ${character.name}에게 $damage의 피해를 입혔습니다.');
    } else {
      print('$name이 약해 ${character.name}에게 피해를 입히지 못했습니다.');
    }
  }

  @override
  void showStatus() {
    print('$name의 상태: 체력 $health, 공격력 $attackPower, 방어력 $defense');
  }

  void increaseDefense() {
    turnCounter++;

    if (turnCounter >= 3) {
      defense += 2;
      print('$name의 방어력이 증가했습니다! 현재 방어력: $defense');
      turnCounter = 0; // 다시 카운터 초기화
    }
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

    monsters.add(Monster(name, health, attack));
  }

  return monsters;
}

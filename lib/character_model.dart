import 'dart:io';
import 'dart:math';

import 'package:rpg_game/abstract_model.dart';
import 'package:rpg_game/monster.model.dart';

// class Character는 RPG 게임에서 플레이어의 캐릭터를 나타내는 모델입니다.
// attackMonster 메서드를 통해 몬스터를 공격하고,
// showStatus 메서드를 통해 캐릭터의 상태를 출력하며,
// defend 메서드를 통해 몬스터의 공격에 대비할 수 있습니다.
//loadCharacterStats 메서드를 통해 캐릭터의 상태를 파일에서 불러옵니다.
//healthincrease 메서드를 통해 캐릭터의 체력을 증가시킬 수 있습니다.(도전 기능 1 )
class Character extends Unit {
  bool hasUsedItem = false; // 아이템 사용 여부
  bool isItemEffectActive = false; // 이번 턴에 발동 중인지
  Character(super.name, super.health, super.attackPower, super.defense);

  @override
  void attack(Unit target) {
    int actualAttackPower = isItemEffectActive ? attackPower * 2 : attackPower;
    int damage = actualAttackPower - target.defense;
    if (damage > 0) {
      target.health -= damage;
      print('$name은 ${target.name}에게 $damage의 피해를 입혔습니다.');
    } else {
      print('$name이 약해 ${target.name}에게 피해를 입히지 못했습니다.');
    }
    if (isItemEffectActive) {
      print('아이템 효과가 이번 턴으로 끝났습니다.');
      isItemEffectActive = false;
    }
  }

  @override
  void showStatus() {
    print('$name의 상태: 체력 $health, 공격력 $attackPower, 방어력 $defense');
  }

  void defend(Monster monster) {
    print('$name이 방어 자세를 취했습니다.');
    health += monster.attackPower; // ? 이해는 잘 안되지만 몬스터의 공격력 만큼 증가하고
    defense--; // 방어력을 감소 시킨다
    print('$name의 체력이 $health으로 증가했습니다. 방어력은 $defense로 감소했습니다.');
  }

  void healthIncrease(Unit target) {
    int heal = Random().nextInt(2) + 1;
    if (heal == 1) {
      target.health += 10; // 캐릭터의 체력을 10 증가시킴
      print('${target.name}의 체력이 10 증가했습니다. 현재 체력: ${target.health}');
    } else {
      print('보너스 체력을 얻지 못했습니다 다음 기회에 ㅠㅠ');
    }
  }

  void choiceItem() {
    if (hasUsedItem) {
      print('$name은 아이템을 사용할 수 없습니다. 아이템 개수가 부족합니다.');
    } else {
      hasUsedItem = true; // 한 번만 사용
      isItemEffectActive = true; // 이번 턴에 발동!

      print('$name이 아이템을 사용하여 공격력이 2배 증가했습니다. 현재 공격력: ${attackPower * 2}');
    }
  }
}

Character loadCharacterStats(String name) {
  final File file;
  final String contents;
  try {
    file = File('character.txt');
    contents = file.readAsStringSync().trim();
  } catch (e) {
    throw FileSystemException('monsters.txt 파일을 찾을 수 없습니다. 파일이 존재하는지 확인하세요.');
  }

  final parts = contents.split(',');
  if (parts.length != 3) {
    throw FormatException('characters.txt 내용이 올바르지 않아요!');
  }

  int health = int.parse(parts[0]);
  int attack = int.parse(parts[1]);
  int defense = int.parse(parts[2]);

  return Character(name, health, attack, defense);
}

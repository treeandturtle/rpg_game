import 'dart:io';
import 'dart:math';
import 'package:rpg_game/character_model.dart';
import 'package:rpg_game/monster.model.dart';

/// RPG 게임의 핵심 로직을 담당하는 Game 클래스입니다.
/// getRandomMonsters 메서드를 통해 몬스터를 랜덤으로 선택하고,
/// battle 메서드를 통해 캐릭터와 몬스터 간의 전투를 진행합니다.
/// startgame 메서드를 통해 게임을 시작하고, 목표한 몬스터를 처치하는 것을 목표로 합니다.
/// 게임 결과는 saveGameResult 메서드를 통해 파일에 저장됩니다.

class Game {
  Character character;
  List<Monster> monsters = [];
  int monsterindex = 0; // 몬스터의 index
  final random = Random();
  bool isGameOver = false; // 게임 종료 여부

  Game({required this.character, required this.monsters});
  int deadmonsters = 0; // monster.length보다 클수 없다.|

  void startgame() {
    int targetnumber = random.nextInt(monsters.length) + 1; //목표 숫자 생성
    print('목표 : $targetnumber마리의 몬스터를 처치하세요.');
    prinBar();
    while (!isGameOver) {
      Monster targetmonster;
      if (targetnumber == deadmonsters) {
        isGameOver = true;
      }

      // 게임이 종료되지 않았을 때만 몬스터를 불러옴
      try {
        targetmonster = getRandomMonsters();
        print('현재 처치한 몬스터 수: $deadmonsters');
      } catch (e) {
        print('몬스터를 불러오는 중 오류가 발생했습니다: $e');
        return; // 게임 종료
      }

      //내부 몬스터 배틀 while 루프
      while (character.health > 0 && !isGameOver) {
        // 몬스터의 체력이 0이 아니면 계속 배틀
        if (targetmonster.health > 0) {
          rebattle(targetmonster);
        }
        // 몬스터의 체력이 0이하가 되면
        else {
          print('${targetmonster.name}를 처치 했습니다!');
          monsters.removeAt(monsterindex); // 몬스터 리스트에서 제거

          // 몬스터 처치 후 상태 출력
          if (targetnumber == deadmonsters) {
            print('모든 몬스터를 처치했습니다! 승리를 축하합니다~!! 게임을 종료합니다.');
            prinBar();
            saveGameResult(character, true); // 게임 결과 저장
            isGameOver = true; // 게임 종료
          }
          // 남은 몬스터가 있을 경우
          else {
            print('남은 몬스터 수: ${targetnumber - deadmonsters}');

            checkFight(); // 다음 몬스터와 대결 여부 확인
            break; // 두번째 while문 루프 탈출
          }
        }
      }
    }
  }

  /// 몬스터와의 전투를 진행하는 메서드
  /// 사용자가 공격 또는 방어를 선택할 수 있으며,
  /// 몬스터의 체력이 0 이하가 되면 처치한 몬스터 수를 증가시킵니다.
  void battle(Monster monster) {
    print('무엇을 하실 건가요? 공격하기(1), 방어하기(2), 아이템 사용하기(3)');
    String? choice = stdin.readLineSync();
    // 실패시 반복 로직이 없는 이유는 startgame 메서드에서 반복을 하기 때문에
    switch (choice) {
      case '1':
        character.attack(monster);
        if (monster.health > 0) {
          monster.attack(character);
          monster.increaseDefense(); // 몬스터의 방어력 증가 여부 확인
        } else {
          deadmonsters++;
          print('${monster.name}을 처치했습니다!');
        }

        break;
      case '2':
        if (character.defense > 0) {
          character.defend(monster);
          monster.increaseDefense(); // 몬스터의 방어력 증가 여부 확인
        } else {
          print('${character.name}은 방어력이 부족하여 방어할 수 없습니다.');
        }
        break;
      case '3':
        character.choiceItem();
        if (character.isItemEffectActive) {
          character.attack(monster);
          if (monster.health > 0) {
            monster.attack(character);
            monster.increaseDefense(); // 몬스터의 방어력 증가 여부 확인
          } else {
            deadmonsters++;
            print('${monster.name}을 처치했습니다!');
          }
        }
      default:
        print('잘못된 선택입니다. 다시 시도하세요.');
    }
  }

  // 몬스터를 랜덤으로 선택하는 메서드
  /// monsters 리스트에서 랜덤으로 몬스터를 선택하여 반환합니다.
  Monster getRandomMonsters() {
    monsterindex = random.nextInt(
      max(1, monsters.length),
    ); // monsters의 index 랜덤 생성
    return monsters[monsterindex]; // monsters의 index에 해당하는 몬스터를 반환
  }

  void rebattle(targetmonster) {
    // 몬스터의 체력이 0이 아니면 계속 배틀

    print('현재 몬스터: ${targetmonster.name}');
    character.showStatus();
    targetmonster.showStatus();
    prinBar();
    battle(targetmonster);
    prinBar();

    if (character.health <= 0) {
      print('${character.name}의 체력이 0이 되었습니다. 게임 오버!');
      prinBar();
      saveGameResult(character, false); // 게임 결과 저장
      isGameOver = true; // 게임 종료
    } // 몬스터와 배틀 로직
  }

  void checkFight() {
    while (!isGameOver) {
      // 반복 대결 확인
      print('다음 몬스터와 대결하시겠습니까? (y/n)');
      String? choice = stdin.readLineSync();
      if (choice?.toLowerCase() == 'n') {
        print('게임을 종료합니다.');
        saveGameResult(character, false); // 게임 결과 저장
        isGameOver = true;
      } else if (choice?.toLowerCase() == 'y') {
        print('다음 몬스터와 대결을 시작합니다.');
        break; // 내부 루프 탈출
      } else {
        print('잘못된 입력입니다. 다시 입력해주세요.');
      }
    }
  }
}

// 게임 결과 저장
// 결과 저장 여부 확인 후 파일에 저장
// 결과 저장은 승리/패배 여부에 따라 다르게 처리
void saveGameResult(Character character, bool isWin) {
  while (true) {
    print('결과를 저장하시겠습니까? (y/n)');
    String? input = stdin.readLineSync();
    final File file;

    if (input?.toLowerCase() == 'y') {
      String result =
          '''

--------------------
게임 결과
--------------------
이름: ${character.name}
남은 체력: ${character.health}
결과: ${isWin ? '승리' : '패배'}
--------------------
''';
      try {
        file = File('result.txt');
        file.writeAsStringSync(result, mode: FileMode.append);
      } catch (e) {
        print('결과 저장 중 오류가 발생했습니다: $e');
        return; // 오류 발생 시 함수 종료
      }
      print('결과가 result.txt 파일에 저장되었습니다.');
      break; // 결과 저장 완료
    } else if (input?.toLowerCase() == 'n') {
      print('결과 저장을 취소했습니다.');
      break; // 결과 저장 취소
    } else {
      print('잘못된 입력입니다. 다시 입력해주세요.');
      continue; // 잘못된 입력 시 다시 묻기(사실 필요는 없지만 명시하기 위해 다시 돈다는 것을)
    }
  }
}

void prinBar() {
  print(
    '---------------------------------------------------------------------',
  );
}

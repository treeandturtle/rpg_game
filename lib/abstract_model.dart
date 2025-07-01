abstract class Unit {
  String name;
  int health;
  int attackPower;
  int defense;

  Unit(this.name, this.health, this.attackPower, this.defense);

  void showStatus() {
    print('$name | HP: $health | ATK: $attackPower | DEF: $defense');
  }

  void attack(Unit target);
}

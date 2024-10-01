final class User {
  User(this.id, this.name, this.age);

  final String id;
  final String name;
  final int age;

  @override
  String toString() {
    return 'User{id: $id, name: $name, age: $age}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          age == other.age;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ age.hashCode;
}

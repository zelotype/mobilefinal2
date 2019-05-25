import 'package:sqflite/sqflite.dart';

final String userTable = "user";
final String idColumn = "_id";
final String usernameColumn = "username";
final String nameColumn = "name";
final String ageColumn = "age";
final String passwordColumn = "password";
final String quoteColumn = "quote";

class User {
  int id;
  String username;
  String name;
  String age;
  String password;
  String quote;

  User();

  User.formMap(Map<String, dynamic> map) {
    this.id = map[idColumn];
    this.username = map[usernameColumn];
    this.name = map[nameColumn];
    this.age = map[ageColumn];
    this.password = map[passwordColumn];
    this.quote = map[quoteColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      usernameColumn: username,
      nameColumn: name,
      ageColumn: age,
      passwordColumn: password,
      quoteColumn: quote,
    };
    if (id != null) {
      map[idColumn] = id; 
    }
    return map;
  }

  @override
  String toString() { return 'id: ${this.id}, username:  ${this.username}, name:  ${this.name}, age:  ${this.age}, password:  ${this.password}, quote:  ${this.quote}'; }

}

class RegisterProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $userTable (
        $idColumn integer primary key autoincrement,
        $usernameColumn text not null unique,
        $nameColumn text not null,
        $ageColumn text not null,
        $passwordColumn text not null,
        $quoteColumn text
      )
      ''');
    });
  }

  Future<User> insertUser(User user) async {
    user.id = await db.insert(userTable, user.toMap());
    return user;
  }

  Future<User> getUser(int id) async {
    List<Map<String, dynamic>> maps = await db.query(userTable,
        columns: [idColumn, usernameColumn, nameColumn, ageColumn, passwordColumn, quoteColumn],
        where: '$idColumn = ?',
        whereArgs: [id]);
        maps.length > 0 ? new User.formMap(maps.first) : null;
  }

  Future<int> deleteUser(int id) async {
    return await db.delete(userTable, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    return db.update(userTable, user.toMap(),
        where: '$idColumn = ?', whereArgs: [user.id]);
  }
  
  Future<List<User>> getAllUser() async {
    await this.open("user.db");
    var res = await db.query(userTable, columns: [idColumn, usernameColumn, nameColumn, ageColumn, passwordColumn, quoteColumn]);
    List<User> userList = res.isNotEmpty ? res.map((c) => User.formMap(c)).toList() : [];
    return userList;
  }

  Future close() async => db.close();

}
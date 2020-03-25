import 'package:flutter/material.dart';
import 'package:basic_sqflite_entity_framework/DbUtils.dart';
import 'package:basic_sqflite_entity_framework/TableColumn.dart';
import 'package:basic_sqflite_entity_framework/TableColumnTypes.dart';
import 'package:basic_sqflite_entity_framework/TableSchema.dart';
import 'package:basic_sqflite_entity_framework/TableModel.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Db.users.insert(User(name: 'Ehsan')).then((int resultId) {

      print('insert main ' + resultId.toString());
      
      Db.users.all().then((dynamic result) {
        print('all ' + result.toString());
      });
      
    });

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Hello'),),
        body: Container(
          child: Text('Hello'),
        ),
      ),
    );
  }
  
}

class User extends TableModel {

  int id;
  String name;

  User({this.id, this.name});

  @override
  Map<String, dynamic> toMap() => {
    'id': this.id,
    'name': this.name,
  };

  @override
  String toString() {
    return 'User{id: $id, name: $name}';
  }

}


class Db {

  static DbUtils users = DbUtils(TableSchema(
    databaseName: 'Karbara',
    tableName: 'Users',

    columns: <TableColumn>[
      TableColumn( name: 'id', type: TableColumnTypes.PRIMARY_KEY_INT ),
      TableColumn( name: 'name', type: TableColumnTypes.TEXT ),
    ],

    fromMap: (Map<String, dynamic> map) => User(
      id: map['id'],
      name: map['name'],
    ),

  ));

} 

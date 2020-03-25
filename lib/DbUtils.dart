import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'TableModel.dart';
import 'TableSchema.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbUtils {
  
  final TableSchema tableSchema;

  DbUtils(this.tableSchema);

  Future<Database> getDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), tableSchema.databaseName + '.db'),

      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE " +
              tableSchema.tableName +
              "(" + tableSchema.columnsToString() + ")",
        );
      },

      version: 1,
    );
  }

  

  Future<List<TableModel>> all() async {
    Database db = await getDatabase();
    
    List<Map<String, dynamic>> listResult = await db.query(tableSchema.tableName);

    await db.close();

    return toList(listResult);
  }


  Future<int> insert(TableModel tableModel) async {
    Database db = await getDatabase();

    int resultId = await db.insert(
      tableSchema.tableName,
      tableModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.close();

    return resultId;
  }

  Future<List<int>> insertRange(List<TableModel> tableModelsList) async {
    Database db = await getDatabase();
    List<int> resultIds = List<int>();

    for (int i = 0; i < tableModelsList.length; i++) {
      int id = await db.insert(
        tableSchema.tableName,
        tableModelsList[i].toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      resultIds.add(id);
    }

    await db.close();

    return resultIds;
  }

  
  Future<TableModel> singleOrDefault([
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    dynamic defaultValue,
  ]) async {
    Database db = await getDatabase();

    List<Map<String, dynamic>> listResult = await db.query(
      tableSchema.tableName,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      limit: 1,
    );

    await db.close();

    return listResult.length > 0 ? toList(listResult).first : defaultValue;
  }

  Future<List<TableModel>> select([
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String having,
    String orderBy,
  ]) async {
    Database db = await getDatabase();

    List<Map<String, dynamic>> listResult = await db.query(
      tableSchema.tableName,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
    );

    await db.close();

    return toList(listResult);
  }

  Future<void> update({@required TableModel tableModel, @required String where, @required List<dynamic> whereArgs}) async {
    Database db = await getDatabase();

    await db.update(
      tableSchema.tableName,
      tableModel.toMap(),
      where: where,
      whereArgs: whereArgs,
    );

    await db.close();
  }

  Future<void> updateById({@required int id, @required TableModel tableModel}) async {
    Database db = await getDatabase();

    await update(
      tableModel: tableModel,
      where: "id = ?",
      whereArgs: [id],
    );

    await db.close();
  }

  Future<void> delete({@required String where, @required List<dynamic> whereArgs}) async {
    Database db = await getDatabase();

    await db.delete(
      tableSchema.tableName,
      where: where,
      whereArgs: whereArgs,
    );

    await db.close();
  }

  Future<void> deleteById(int id) async {
    await delete( 
      where: "id = ?", 
      whereArgs: [id]
    );
  }


  List<TableModel> toList(List<Map<String, dynamic>> listResult) {
    return List.generate(
      listResult.length,
      (eachMapIndex) => tableSchema.fromMap(listResult[eachMapIndex]),
    );
  }

  // TableModel get() => tableSchema.fromMap(singleResult);
}

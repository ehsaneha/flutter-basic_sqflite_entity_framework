
import 'package:flutter/cupertino.dart';
import 'TableModel.dart';

import 'TableColumn.dart';

class TableSchema {
  final String tableName;
  final String databaseName;
  final List<TableColumn> columns;
  final TableModel Function(Map<String, dynamic>) fromMap;

  TableSchema({
    @required this.tableName, 
    @required this.databaseName,
    @required this.columns, 
    @required this.fromMap, 
  });

  String columnsToString() {
    String result = '';

    columns.forEach((TableColumn tf) {
      result += (tf.name + ' ' + tf.type + ',');
    });

    return result.substring(0, result.length-1);
  }

}
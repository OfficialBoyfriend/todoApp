import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:todoApp/model/todo.dart';

part 'database.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called todos_file.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'todos_file.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [
  Todo
], queries: {
  '_getByType':
      'SELECT * FROM todo WHERE todo_type = ? order by is_finish, date, time',
  '_completeTask': 'UPDATE todo SET is_finish = 1 WHERE id = ?',
  '_deleteTask': 'DELETE FROM todo WHERE id = ?'
})
class Database extends _$Database with ChangeNotifier {
  // we tell the database where to store the data with this constructor
  // 我们使用此构造函数告诉数据库在哪里存储数据
  Database() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations are covered later in this readme.
  // 每当您更改或添加表格定义时，都应更改此数字。本自述文件稍后将介绍迁移。
  @override
  int get schemaVersion => 1;

  // 获取指定类型待办事务
  Stream<List<TodoData>> getTodoByType(int type) => _getByType(type).watch();

  // 插入待办事务
  Future insertTodoEntries(TodoData entry) {
    return transaction(() async {
      await into(todo).insert(entry);
    });
  }

  // 完成指定待办
  Future completeTodoEntries(int id) {
    return transaction(() async {
      await _completeTask(id);
    });
  }

  // 删除指定待办
  Future deleteTodoEntries(int id) {
    return transaction(() async {
      await _deleteTask(id);
    });
  }
}

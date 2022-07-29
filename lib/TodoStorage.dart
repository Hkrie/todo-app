import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '_todo.dart';

class TodoStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/openTodo.txt');
  }

  Future<String> getPath() async{
    return await _localPath;
  }

  Future<List<Todo>?> readTodos() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents);
      List<Todo> todoList = <Todo>[];

      for( String todo in jsonData){
        todoList.add(Todo.fromJson(jsonDecode(todo)));
      }

      return todoList;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  Future<File> writeTodos(List<Todo> todoList) async {
    final file = await _localFile;
    final List<String> todoListString = <String>[];
    for( var todo in todoList){
      todoListString.add(jsonEncode(todo));
    }
    // Write the file
    return file.writeAsString(jsonEncode(todoListString));
  }
}

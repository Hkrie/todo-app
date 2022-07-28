import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '_todo.dart';

class DoneTodoStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/doneTodo.txt');
  }

  Future<String> getPath() async{
    return await _localPath;
  }

  Future<List<Todo>?> readDoneTodo() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return jsonDecode(contents);
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  Future<File> writeDoneTodo(List<Todo> doneTodoList) async {
    final file = await _localFile;
    final String doneTodoListString = jsonEncode(doneTodoList);

    // Write the file
    return file.writeAsString(doneTodoListString);
  }
}

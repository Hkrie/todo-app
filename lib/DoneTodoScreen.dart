import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DoneTodoStorage.dart';
import '_todo.dart';
import 'dart:developer';

class DoneTodoScreen extends StatefulWidget {
  const DoneTodoScreen(
      {Key? key, required this.doneTodoList, required this.storage})
      : super(key: key);
  final List<Todo> doneTodoList;
  final DoneTodoStorage storage;

  @override
  State<DoneTodoScreen> createState() => _DoneTodoScreenState();
}

class _DoneTodoScreenState extends State<DoneTodoScreen> {
  List<Todo> doneTodoList = <Todo>[];
  List<Todo> savedList = <Todo>[];
  final TextStyle biggerFont = const TextStyle(fontSize: 18);

  _saveDoneTodos(List<Todo> todoList) {
    widget.storage.writeDoneTodo(todoList);
  }

  _deleteAllDoneTodos() {
    _saveDoneTodos(List.from(doneTodoList));
    doneTodoList = <Todo>[];
    Navigator.pop(context, DoneTodoResult(null, doneTodoList));
  }

  @override
  Widget build(BuildContext context) {
    widget.storage.writeDoneTodo(doneTodoList);

    doneTodoList = widget.doneTodoList;

    final tiles = doneTodoList.map((doneTodoItem) {
      return ListTile(
        trailing: const Icon(
          Icons.check_box,
          semanticLabel: "Remove from done",
        ),
        onTap: () {
          Navigator.pop(context, DoneTodoResult(doneTodoItem, null));
        },
        title: Text(
          doneTodoItem.todoText,
          style: biggerFont,
        ),
      );
    });

    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(context: context, tiles: tiles).toList()
        : <Widget>[];
    final savedListLength = savedList.length.toString();
    return Scaffold(
      appBar: AppBar(title: Text('Done Todos $savedListLength'), actions: [
        IconButton(
          onPressed: _deleteAllDoneTodos,
          icon: const Icon(Icons.delete),
          tooltip: 'Delete all doneTodos',
        ),
      ]),
      body: ListView(children: divided),
    );
  }
}

class DoneTodoResult {
  Todo? previouslyDoneTodo;
  List<Todo>? doneTodoList;

  DoneTodoResult(this.previouslyDoneTodo, this.doneTodoList);
}

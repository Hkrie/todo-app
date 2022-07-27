import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_todo.dart';

class DoneTodoScreen extends StatefulWidget {
  const DoneTodoScreen({Key? key, required this.doneTodoList})
      : super(key: key);
  final List<Todo> doneTodoList;

  @override
  State<DoneTodoScreen> createState() => _DoneTodoScreenState();
}

class _DoneTodoScreenState extends State<DoneTodoScreen> {
  @override
  Widget build(BuildContext context) {
    final doneTodoList = widget.doneTodoList;
    const biggerFont = TextStyle(fontSize: 18);

    final tiles = doneTodoList.map((doneTodoItem) {
      return ListTile(
        trailing: const Icon(
          Icons.check_box,
          semanticLabel: "Remove from done",
        ),
        onTap: () {
          Navigator.pop(context, doneTodoItem);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Done Todos'),
      ),
      body: ListView(children: divided),
    );
  }
}

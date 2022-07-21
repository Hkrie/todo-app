// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo List',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
          ),
        ),
        home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _todos = <String>[];
  final _doneTodo = <String>[];
  final _biggerFont = const TextStyle(fontSize: 18);

  void _addTodo() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final myController = TextEditingController();

      @override
      void dispose() {
        // Clean up the controller when the widget is disposed.
        myController.dispose();
        super.dispose();
      }

      return Scaffold(
          appBar: AppBar(
            title: const Text('Add Todo'),
          ),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onSubmitted: (textValue) {
                    setState(() {
                      _todos.add(textValue);
                    });
                    Navigator.of(context).pop();
                  },
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter a new Thing to do',
                  ),
                  controller: myController,
                ),
                const SizedBox(height: 16),
                IconButton(
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        _todos.add(myController.text);
                      });
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
          ));
    }));
  }

  void _showDoneTodo() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final tiles = _doneTodo.map((string) {
        return ListTile(
          trailing: const Icon(
            Icons.check_box,
            semanticLabel: "Remove from done",
          ),
          onTap: () {
            setState(() {
              _doneTodo.remove(string);
              _todos.add(string);
            });
            Navigator.of(context).pop();
          },
          title: Text(
            string,
            style: _biggerFont,
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
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            onPressed: _addTodo,
            icon: const Icon(Icons.add),
            tooltip: 'Add Todo',
          ),
          IconButton(
            onPressed: _showDoneTodo,
            icon: const Icon(Icons.check_box),
            tooltip: 'Show Done Todos',
          )
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _todos.length * 2,
          itemBuilder: (context, i) {
            if (i.isOdd) return const Divider();
            final index = i ~/ 2;
            final alreadyDone = _doneTodo.contains(_todos[index]);
            return ListTile(
              title: Text(
                _todos[index],
                style: _biggerFont,
              ),
              trailing: Icon(
                alreadyDone ? Icons.check_box : Icons.check_box_outline_blank,
                color: alreadyDone ? Colors.blue : null,
                semanticLabel: alreadyDone ? "Remove from done" : "Finish",
              ),
              onTap: () {
                setState(() {
                  if (alreadyDone) {
                    _doneTodo.remove(_todos[index]);
                  } else {
                    _doneTodo.add(_todos[index]);
                    _todos.remove(_todos[index]);
                  }
                });
              },
            );
          }),
    );
  }
}


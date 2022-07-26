import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_list/DoneTodoScreen.dart';
import 'package:todo_list/TodoStorage.dart';
import './_todo.dart';
import 'AddTodoScreen.dart';

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
        home: TodoList(storage: TodoStorage()));
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key, required this.storage}) : super(key: key);
  final TodoStorage storage;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<Todo> _todos = <Todo>[];
  List<Todo> _doneTodos = <Todo>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  final _normalFont = const TextStyle(fontSize: 14);

  Widget slideIt(
      BuildContext context, Todo? removedItem, int index, animation) {
    Todo item = removedItem ?? _todos[index];
    final alreadyDone = _doneTodos.contains(item);
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: SizedBox(
          child: ListTile(
        title: Text(
          item.todoText,
          style: _biggerFont,
        ),
        subtitle: Text(
          item.todoPriority,
          style: _normalFont,
        ),
        trailing: Icon(
          alreadyDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: alreadyDone ? Colors.blue : null,
          semanticLabel: alreadyDone ? "Remove from done" : "Finish",
        ),
        onTap: () {
          _doneTodos.add(item);
          int removeIndex = _todos.indexOf(item);
          Todo removedItem = _todos.removeAt(removeIndex);

          listKey.currentState?.removeItem(removeIndex,
              (_, animation) => slideIt(context, removedItem, index, animation),
              duration: const Duration(milliseconds: 500));
        },
      )),
    );
  }

  _convertPriority(prio) {
    switch (prio) {
      case 'Highest':
        return 1;
      case 'High':
        return 2;
      case 'normal':
        return 3;
      case 'low':
        return 4;
      case 'lowest':
        return 5;
    }
  }

  _sortTodosList() {
    List<Todo> sortedTodos = List.from(_todos);

    sortedTodos.sort((a, b) => _convertPriority(a.todoPriority)
        .compareTo(_convertPriority(b.todoPriority)));
    setState(() {
      _todos = sortedTodos;
    });
  }

  _writeOpenTodos() {
    widget.storage.writeTodos(_todos);
  }

  _readAndLoadSavedOpenTodos() async {
    final savedTodos = await widget.storage.readTodos();
    if (savedTodos != null) {
      _todos = savedTodos;
      _todos.asMap().forEach((index, value) => {
            listKey.currentState!
                .insertItem(index, duration: const Duration(milliseconds: 500))
          });
    }
  }

  @override
  void initState() {
    super.initState();
    _readAndLoadSavedOpenTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            onPressed: _sortTodosList,
            icon: const Icon(Icons.sort),
            tooltip: 'Sort Todo List',
          ),
          IconButton(
            onPressed: () async {
              final newTodo = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTodoScreen(oldTodoList: _todos)),
              );
              if (newTodo != null) {
                listKey.currentState!.insertItem(_todos.length,
                    duration: const Duration(milliseconds: 500));
                _todos.add(newTodo);
                _writeOpenTodos();
              }
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add Todo',
          ),
          IconButton(
            onPressed: () async {
              final DoneTodoResult? result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DoneTodoScreen(
                          doneTodoList: _doneTodos,
                        )),
              );
              if (result != null) {
                if (result.previouslyDoneTodo != null) {
                  setState(() {
                    _doneTodos.remove(result.previouslyDoneTodo);
                  });
                  listKey.currentState!.insertItem(_todos.length,
                      duration: const Duration(milliseconds: 500));
                  _todos.add(result.previouslyDoneTodo!);
                  _writeOpenTodos();
                }

                if (result.doneTodoList != null) {
                  _doneTodos = result.doneTodoList!;
                }
              }
            },
            icon: const Icon(Icons.check_box),
            tooltip: 'Show Done Todos',
          )
        ],
      ),
      body: AnimatedList(
        key: listKey,
        initialItemCount: _todos.length,
        itemBuilder: (context, index, animation) {
          return slideIt(context, null, index, animation);
        },
      ),
    );
  }
}

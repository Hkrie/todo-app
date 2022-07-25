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
        home: const TodoList());
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final _todos = <String>[];
  final _doneTodos = <String>[];
  final _biggerFont = const TextStyle(fontSize: 18);

  Widget slideIt(BuildContext context, String? removedItem, int index, animation) {
    String item = removedItem ?? _todos[index];
    final alreadyDone = _doneTodos.contains(item);
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: SizedBox(
          child: ListTile(
            title: Text(
              item + _todos.length.toString(),
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadyDone ? Icons.check_box : Icons.check_box_outline_blank,
              color: alreadyDone ? Colors.blue : null,
              semanticLabel: alreadyDone ? "Remove from done" : "Finish",
            ),
            onTap: () {
              _doneTodos.add(item);
              int removeIndex = _todos.indexOf(item);
              String removedItem = _todos.removeAt(removeIndex);


              listKey.currentState?.removeItem(
                  removeIndex, (_, animation) => slideIt(context,removedItem, index, animation),
                  duration: const Duration(milliseconds: 500));
            },
          )),
    );
  }

  void _addTodo() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final myController = TextEditingController();

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
                    listKey.currentState!.insertItem(_todos.length,
                        duration: const Duration(milliseconds: 500));
                    _todos.add(textValue);
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
                      listKey.currentState!.insertItem(0,
                          duration: const Duration(milliseconds: 500));
                      _todos.insert(0, myController.text);
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
      final tiles = _doneTodos.map((string) {
        return ListTile(
          trailing: const Icon(
            Icons.check_box,
            semanticLabel: "Remove from done",
          ),
          onTap: () {
            listKey.currentState!.insertItem(_todos.length,
                duration: const Duration(milliseconds: 500));
            _todos.add(string);
            _doneTodos.remove(string);
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
        title: const Text('Todo List'),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_todo.dart';
import 'main.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen(
      {Key? key, required this.oldTodoList, required this.doneTodoList})
      : super(key: key);
  final List<Todo> oldTodoList;
  final List<Todo> doneTodoList;

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final myController = TextEditingController();
  String dropdownValue = 'normal';

  @override
  Widget build(BuildContext context) {
    final oldTodoList = widget.oldTodoList;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Todo'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter a new Thing to do',
                ),
                controller: myController,
              ),
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['Highest', 'High', 'normal', 'low', 'lowest']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              IconButton(
                  color: Colors.blue,
                  onPressed: () {
                    // listKey.currentState!.insertItem(0,
                    //     duration: const Duration(milliseconds: 500));
                    // _todos.insert(0, _Todo(myController.text, dropdownValue));
                    // Navigator.of(context).pop();
                    final Todo newTodo =
                        Todo(myController.text, dropdownValue, null);
                    Navigator.pop(context, newTodo);
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
        ));
  }
}

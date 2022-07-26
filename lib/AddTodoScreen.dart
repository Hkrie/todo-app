import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_todo.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen(
      {Key? key, required this.oldTodoList})
      : super(key: key);
  final List<Todo> oldTodoList;

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final myController = TextEditingController();
  String dropdownValue = 'normal';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final oldTodoList = widget.oldTodoList;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Todo'),
        ),
        body: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    autofocus: true,
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
                    items: <String>[
                      'Highest',
                      'High',
                      'normal',
                      'low',
                      'lowest'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: IconButton(
                          color: Colors.blue,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final Todo newTodo =
                                  Todo(myController.text, dropdownValue, null);
                              Navigator.pop(context, newTodo);
                            }
                          },
                          icon: const Icon(Icons.add)))
                ],
              ),
            )));
  }
}

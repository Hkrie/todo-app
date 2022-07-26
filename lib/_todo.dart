import 'package:uuid/uuid.dart';

// Create uuid object
var uuid = Uuid();

class Todo {
  String todoText;
  String todoPriority;
  String id;

  Todo(this.todoText, this.todoPriority, id) : id = id ?? uuid.v1();
}

import 'package:uuid/uuid.dart';

// Create uuid object
var uuid = Uuid();

class Todo {
  String todoText;
  String todoPriority;
  String id;

  Todo(this.todoText, this.todoPriority, id) : id = id ?? uuid.v1();

  Todo.fromJson(Map<String, dynamic> json)
      : todoText = json['todoText'],
        todoPriority = json['todoPriority'],
        id = json['id'];

  Map<String, dynamic> toJson() =>
      {'todoText': todoText, 'todoPriority': todoPriority, 'id': id};
}

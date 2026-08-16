// app_repository.dart
import 'package:todolist/database/app_database.dart';
import 'package:todolist/database/todo.dart';

abstract class AppRepository {
  List<Todo> getTodoList();
  void addTodo(Todo todo);
  void updateTodo(int index, String title);
  void deleteTodo(int index);
}

class AppRepositoryImpl extends AppRepository {
  final AppDatabase db;

  AppRepositoryImpl({required this.db});

  @override
  List<Todo> getTodoList() => db.getTodoList();

  @override
  void addTodo(Todo todo) => db.addTodo(todo);

  @override
  void updateTodo(int index, String title) => db.updateTodo(index, title);

  @override
  void deleteTodo(int index) => db.deleteTodo(index);
}
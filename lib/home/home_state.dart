import 'package:todolist/database/todo.dart';

enum TodoStatus {
  success,
  empty,
  error,
  isLoading
}

class HomeState {
  final List<Todo> todoList;
  final TodoStatus status;

  const HomeState({required this.todoList, required this.status});

  HomeState copyWith({List<Todo>? todoList, TodoStatus? status}) {
    return HomeState(todoList: todoList ?? this.todoList, status: status ?? this.status);
  }
}
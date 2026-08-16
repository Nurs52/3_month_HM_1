import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/database/app_repository.dart';
import 'package:todolist/database/todo.dart';
import 'package:todolist/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppRepositoryImpl repo;

  List<Todo> todoList = [];

  HomeCubit({required this.repo})
    : super(HomeState(todoList: [], status: .isLoading));

  void getTodoList() {
    //просит у Repository список задач
    todoList = repo.getTodoList();

    if (todoList.isEmpty) {
      emit(state.copyWith(status: .empty));
    } else {
      emit(state.copyWith(status: .success));
    }
  }
}

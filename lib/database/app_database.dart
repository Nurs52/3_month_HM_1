import 'package:todolist/database/app_database.dart';
import 'package:todolist/database/todo.dart';
import 'package:hive/hive.dart';

class AppDatabase {
  //создаем box для наших задач
  final Box box = Hive.box('todoBox');

  List<Todo> _todoList = [];

  //при инициализации класса AppDatabase, подгружаем последние данные из Hive
  AppDatabase() {
    loadTodos();
  }

  void loadTodos() {
    //достаем список задач из box по ключу "todos"
    final data = box.get('todos', defaultValue: []);

    //превращаем в объекты дарт и ложим в наш список
    _todoList = List<Map>.from(data).map((e) {
      return Todo(
        id: e['id'],
        title: e['title'],
        createdAt: e['createdAt'],
        isDone: e['isDone'],
      );
    }).toList();
  }

  void saveTodos() {
    //берем наш список и превращаем в список для hive,
    //где объект представлен в виде ключа и значения
    final data = _todoList.map((todo) {
      return {
        "id": todo.id,
        "title": todo.title,
        "createdAt": todo.createdAt,
        "isDone": todo.isDone,
      };
    }).toList();

    box.put('todos', data);
  }

  //READ
  List<Todo> getTodoList() {
    return _todoList;
  }

  //CREATE
  void addTodo(Todo todo) {
    _todoList.insert(0, todo);
    saveTodos();
  }

  //UPDATE
  void updateTodo(int index, String title) {
    _todoList[index].title = title;
    saveTodos();
  }

  //DELETE
  void deleteTodo(int index) {
    _todoList.removeAt(index);
    saveTodos();
  }
}

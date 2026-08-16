import 'package:flutter/material.dart';
import 'package:todolist/add/add_page.dart';
import 'package:todolist/add/detail/detail_page.dart';
import 'package:todolist/settings/themeSettingsPage.dart';
import 'package:todolist/database/app_database.dart';
import 'package:todolist/database/todo.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 1. Инициализируем базу данных вместо обычного List<String>
  final AppDatabase db = AppDatabase();
  List<Todo> _todoList = [];

  @override
  void initState() {
    super.initState();
    _loadTodos(); // 2. Загружаем данные из базы при запуске
    print("Home Page - initState");
  }

  // Метод для обновления списка на экране после любых изменений
  void _loadTodos() {
    setState(() {
      _todoList = db.getTodoList();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("Home Page - didChangeDepencies");
  }

  @override
  Widget build(BuildContext context) {
    print('Home Page - build');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: _themeSettings,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(color: Colors.black, height: 1.0),
        ),
      ),

      // 3. ОБНОВЛЕННЫЙ LISTVIEW.BUILDER
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          final todo = _todoList[index];

          return GestureDetector(
            onTap: () async {
              // Переход на экран деталей с передачей объекта Todo и индекса
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPage(todo: todo, index: index),
                ),
              );

              // Обработка действий после возврата (редактирование или удаление)
              if (result != null && result is Map) {
                if (result['action'] == 'update') {
                  db.updateTodo(result['index'], result['newTitle']);
                  _loadTodos(); // Обновляем экран
                } else if (result['action'] == 'delete') {
                  db.deleteTodo(result['index']);
                  _loadTodos(); // Обновляем экран
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: todo.isDone, // Берем статус из Todo
                    onChanged: (bool? value) {
                      // Логика чекбокса
                    },
                    side: const BorderSide(color: Colors.white, width: 2),
                    activeColor: Colors.white,
                    checkColor: Colors.blue,
                  ),
                  Expanded(
                    child: Text(
                      todo.title, // Берем текст задачи из Todo
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        todo.createdAt, // Берем дату создания из Todo
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _onAddTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '+ Добавить задачу',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _themeSettings() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ThemeSettingsPage()),
    );
  }

  // 4. ОБНОВЛЕННЫЙ МЕТОД ДОБАВЛЕНИЯ (теперь сохраняет объект Todo)
  void _onAddTap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPage()),
    );

    if (result != null && result.toString().trim().isNotEmpty) {
      // Создаем новую задачу
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch, // Генерируем уникальный ID
        title: result,
        createdAt:
            '31 июля', // Пока хардкодим, потом можно брать DateTime.now()
        isDone: false,
      );

      db.addTodo(newTodo); // Сохраняем в Hive через AppDatabase
      _loadTodos(); // Перерисовываем список
    }
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("Home Page didUpdateWidget");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("Home Page - deactivate");
  }

  @override
  void dispose() {
    print("Home Page - dispose");
    super.dispose();
  }
}

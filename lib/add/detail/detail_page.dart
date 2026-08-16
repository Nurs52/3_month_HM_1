import 'package:flutter/material.dart';
import 'package:todolist/database/todo.dart';

class DetailPage extends StatefulWidget {
  final Todo todo;
  final int index;

  const DetailPage({
    super.key,
    required this.todo,
    required this.index,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController _controller;
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    // Достаем свойство title из модельки Todo и подставляем в контроллер
    _controller = TextEditingController(text: widget.todo.title);
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    final isDifferent = _controller.text.trim() != widget.todo.title;
    
    if ((hasText && isDifferent) != _isChanged) {
      setState(() {
        _isChanged = hasText && isDifferent;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF4F3F9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.todo.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFF007AFF), size: 26),
            onPressed: () {
              // Возвращаем флаг удаления задачи обратно на главный экран
              Navigator.pop(context, {'action': 'delete', 'index': widget.index});
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE3E2E8),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.black12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isChanged
                      ? () {
                          // Возвращаем новые данные на главный экран
                          Navigator.pop(context, {
                            'action': 'update',
                            'index': widget.index,
                            'newTitle': _controller.text.trim(),
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    disabledBackgroundColor: const Color(0xFFAFAEB5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Сохранить изменения',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
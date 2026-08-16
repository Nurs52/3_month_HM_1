import 'dart:async';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late Timer _timer;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('Add Page - initState');

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final date = DateTime.now();
      print('${date.minute} : ${date.second}');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Add Page - build');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Новая задача',
          style: TextStyle(color: Colors.black),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(color: Colors.black, height: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Введите название задачи',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _onSaveTop,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Сохранить',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSaveTop() {
    Navigator.pop(context, _textEditingController.text);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('Add Page - didChangeDependencies');
  }

  @override
  void didUpdateWidget(covariant AddPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('Add Page - didUpdateWidget');
  }

  @override
  void deactivate() {
    print('Add Page - deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    _timer.cancel();
    _textEditingController.dispose();
    print('Add Page - dispose');
    super.dispose();
  }
}
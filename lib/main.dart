import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/home/home_page.dart';
import 'package:todolist/onboarding/onboarding_page.dart';
import 'package:todolist/settings/setting_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация локальной базы данных Hive и открытие бокса для задач
  await Hive.initFlutter();
  await Hive.openBox('todoBox');

  final preferences = await SharedPreferences.getInstance();
  final isOnboardingViewed =
      preferences.getBool(OnboardingPage.viewedKey) ?? false;

  runApp(MyApp(isOnboardingViewed: isOnboardingViewed));
}

class MyApp extends StatelessWidget {
  final bool isOnboardingViewed;

  const MyApp({super.key, required this.isOnboardingViewed});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingCubit(),
      child: BlocBuilder<SettingCubit, bool>(
        builder: (context, isDarkTheme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'To do list',
            themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              scaffoldBackgroundColor: const Color(0xFFF4F3F9),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: const Color(0xFF1E1B28),
            ),
            home: isOnboardingViewed
                ? const MyHomePage(title: 'Мои задачи')
                : const OnboardingPage(),
          );
        },
      ),
    );
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingCubit extends Cubit<bool> {
  SettingCubit() : super(false);

  void toggleTheme(bool isDarkTheme) {
    emit(isDarkTheme);
  }
}
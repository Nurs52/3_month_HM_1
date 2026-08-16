import 'package:flutter/material.dart';
import 'package:todolist/settings/setting_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});
  
    @override
  Widget build(BuildContext context) {
    
   
    return  BlocBuilder<SettingCubit, bool>(
      builder: (context, isDarkTheme) { 

      final Color _backroundgColor = isDarkTheme
        ? const Color(0xFF1E1B28)
        : const Color(0xFFEEECF2);
    final Color _cardColor = isDarkTheme
        ? const Color(0xFF35323E)
        : Colors.white;
    final Color _textColor = isDarkTheme ? Colors.white : Colors.black;

    final Color _dividerColor = isDarkTheme ? Colors.white24 : Colors.black12;
      
      return Scaffold(
      backgroundColor: _backroundgColor,
      appBar: AppBar(
        backgroundColor: _backroundgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _textColor),
        title: Text('Настройки', style: TextStyle(color: _textColor)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: _dividerColor, height: 1.0),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(16.0),
          ),

          child: SwitchListTile(
            activeColor: const Color(0xFF2563EB),
            title: Text(
              'Тёмная тема',
              style: TextStyle(
                color: _textColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),

            subtitle: Text(
              isDarkTheme
                  ? 'Использовать светлое\nоформление приложения'
                  : 'Использовать тёмное\nоформление приложения',
              style: TextStyle(
                color: _textColor.withOpacity(0.6),
                fontSize: 14,
              ),
            ),

            value: isDarkTheme,
            onChanged: (bool value) {
              context.read<SettingCubit>().toggleTheme(value);
            },
          ),
        ),
      ),
    );
    }
    );
    
  }

  
}
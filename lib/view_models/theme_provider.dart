import 'package:flutter_riverpod/legacy.dart';
import 'package:mvvm_state_management/enums/theme_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends StateNotifier<ThemeEnum> {
  ThemeProvider() : super(ThemeEnum.light) {
    _loadTheme();
  }

  final perfKey = 'isDarkMode';

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool(perfKey) ?? false;

    state = isDarkMode ? ThemeEnum.dark : ThemeEnum.light;
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeEnum.dark) {
      state = ThemeEnum.light;
      await prefs.setBool(perfKey, false);
    } else {
      state = ThemeEnum.dark;
      await prefs.setBool(perfKey, true);
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeProvider, ThemeEnum>(
  (_) => ThemeProvider(),
);

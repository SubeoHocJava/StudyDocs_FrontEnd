import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';
import '../domain/repository/theme_repository.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository themeRepository;

  ThemeBloc({required this.themeRepository}) : super(const ThemeState()) {
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<ToggleTheme>(_onToggleTheme);
    
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = await themeRepository.getThemeMode();
    add(ThemeModeChanged(mode));
  }

  Future<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    await themeRepository.saveThemeMode(event.mode);
    emit(state.copyWith(themeMode: event.mode));
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    add(ThemeModeChanged(newMode));
  }
}

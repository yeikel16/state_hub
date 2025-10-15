import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_theme_state.dart';
part 'app_theme_cubit.g.dart';

@injectable
class AppThemeCubit extends HydratedCubit<AppThemeState> {
  AppThemeCubit()
    : super(
        const AppThemeState(
          themeMode: ThemeMode.light,
          aviableSchemes: FlexScheme.values,
          schemeSelected: FlexScheme.dellGenoa,
        ),
      );

  static const FlexScheme defaultScheme = FlexScheme.dellGenoa;

  void changeThemeMode(ThemeMode themeMode) {
    emit(state.copyWith(themeMode: themeMode));
  }

  void changeScheme(FlexScheme scheme) {
    emit(state.copyWith(schemeSelected: scheme));
  }

  @override
  AppThemeState? fromJson(Map<String, dynamic> json) {
    try {
      return AppThemeState.fromJson(json);
    } on Exception {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AppThemeState state) {
    return state.toJson();
  }
}

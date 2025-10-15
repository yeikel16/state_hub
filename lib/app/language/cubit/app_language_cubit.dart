import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppLanguageCubit extends HydratedCubit<Locale> {
  AppLanguageCubit() : super(const Locale('en'));

  void changeLanguage(Locale locale) {
    emit(locale);
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    final languageCode = json['languageCode'] as String?;
    if (languageCode == null) return null;
    return Locale(languageCode);
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    return {'languageCode': state.languageCode};
  }
}

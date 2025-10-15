part of 'app_theme_cubit.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class AppThemeState extends Equatable {
  const AppThemeState({
    required this.themeMode,
    required this.aviableSchemes,
    required this.schemeSelected,
  });

  factory AppThemeState.fromJson(Map<String, dynamic> json) =>
      _$AppThemeStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppThemeStateToJson(this);

  @JsonKey(
    toJson: _themeModeToJson,
    fromJson: _themeModeFromJson,
  )
  final ThemeMode themeMode;
  final List<FlexScheme> aviableSchemes;
  final FlexScheme schemeSelected;

  @override
  List<Object> get props => [themeMode, aviableSchemes, schemeSelected];

  AppThemeState copyWith({
    ThemeMode? themeMode,
    List<FlexScheme>? aviableSchemes,
    FlexScheme? schemeSelected,
  }) {
    return AppThemeState(
      themeMode: themeMode ?? this.themeMode,
      aviableSchemes: aviableSchemes ?? this.aviableSchemes,
      schemeSelected: schemeSelected ?? this.schemeSelected,
    );
  }

  static int _themeModeToJson(ThemeMode mode) {
    return mode.index;
  }

  static ThemeMode _themeModeFromJson(int index) {
    return ThemeMode.values[index];
  }
}

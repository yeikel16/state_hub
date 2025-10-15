import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_hub/app/language/language.dart';
import 'package:state_hub/app/theme/cubit/app_theme_cubit.dart';
import 'package:state_hub/l10n/l10n.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 8),
        ThemeSection(),
        Divider(),
        ColorSchemeSection(),
        Divider(),
        LanguageSection(),
      ],
    );
  }
}

class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.appearance,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        BlocBuilder<AppThemeCubit, AppThemeState>(
          builder: (context, state) {
            return RadioGroup<ThemeMode>(
              groupValue: state.themeMode,
              onChanged: (value) {
                if (value != null) {
                  context.read<AppThemeCubit>().changeThemeMode(value);
                }
              },
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text(l10n.light),
                    secondary: const Icon(Icons.light_mode),
                    value: ThemeMode.light,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(l10n.dark),
                    secondary: const Icon(Icons.dark_mode),
                    value: ThemeMode.dark,
                  ),
                  Builder(
                    builder: (context) {
                      final brightness = MediaQuery.platformBrightnessOf(
                        context,
                      );
                      final currentTheme = brightness == Brightness.dark
                          ? l10n.dark
                          : l10n.light;

                      return RadioListTile<ThemeMode>(
                        title: Text(l10n.system),
                        subtitle: Text(l10n.followSystemTheme(currentTheme)),
                        secondary: const Icon(Icons.brightness_auto),
                        value: ThemeMode.system,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class ColorSchemeSection extends StatelessWidget {
  const ColorSchemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.colorScheme,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        BlocBuilder<AppThemeCubit, AppThemeState>(
          builder: (context, state) {
            return ListTile(
              leading: Icon(
                Icons.palette,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                state.schemeSelected.name.replaceAll('_', ' '),
              ),
              subtitle: Text(l10n.tapToChangeColorScheme),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                await _showColorSchemeDialog(context, state);
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> _showColorSchemeDialog(
    BuildContext context,
    AppThemeState state,
  ) {
    final l10n = context.l10n;

    return showDialog<void>(
      context: context,
      builder: (dialogContext) => Builder(
        builder: (context) {
          return AlertDialog(
            title: Text(l10n.selectColorScheme),
            content: SizedBox(
              width: double.maxFinite,
              child: Builder(
                builder: (context) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (MediaQuery.widthOf(context) / 80)
                          .toInt(),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    shrinkWrap: true,
                    itemCount: state.aviableSchemes.length,
                    itemBuilder: (context, index) {
                      final scheme = state.aviableSchemes[index];
                      final isSelected = scheme == state.schemeSelected;
                      final brightness = Theme.brightnessOf(context);
                      final colors = scheme.colors(brightness);

                      return InkWell(
                        onTap: () {
                          context.read<AppThemeCubit>().changeScheme(scheme);
                          Navigator.of(dialogContext).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected ? Border.all(width: 2) : null,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: colors.primary,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: colors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.cancel),
              ),
            ],
          );
        },
      ),
    );
  }
}

class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.language,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        BlocBuilder<AppLanguageCubit, Locale>(
          builder: (context, locale) {
            return RadioGroup<String>(
              groupValue: locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  context.read<AppLanguageCubit>().changeLanguage(
                    Locale(value),
                  );
                }
              },
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Text(l10n.english),
                    secondary: const Icon(Icons.language),
                    value: 'en',
                  ),
                  RadioListTile<String>(
                    title: Text(l10n.spanish),
                    secondary: const Icon(Icons.language),
                    value: 'es',
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

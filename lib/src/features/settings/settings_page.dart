import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_hub/app/theme/cubit/app_theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Appearance',
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
                  const RadioListTile<ThemeMode>(
                    title: Text('Light'),
                    subtitle: Text('Use light theme'),
                    secondary: Icon(Icons.light_mode),
                    value: ThemeMode.light,
                  ),
                  const RadioListTile<ThemeMode>(
                    title: Text('Dark'),
                    subtitle: Text('Use dark theme'),
                    secondary: Icon(Icons.dark_mode),
                    value: ThemeMode.dark,
                  ),
                  Builder(
                    builder: (context) {
                      final brightness = MediaQuery.platformBrightnessOf(
                        context,
                      );
                      final currentTheme = brightness == Brightness.dark
                          ? 'Dark'
                          : 'Light';

                      return RadioListTile<ThemeMode>(
                        title: const Text('System'),
                        subtitle: Text(
                          'Follow system theme (currently $currentTheme)',
                        ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Color Scheme',
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
              subtitle: const Text('Tap to change color scheme'),
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
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => Builder(
        builder: (context) {
          return AlertDialog(
            title: const Text('Select Color Scheme'),
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
                child: const Text('Cancel'),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Language',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('English'),
          subtitle: const Text('App language'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Language selection coming soon!'),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

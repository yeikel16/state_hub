import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:state_hub/app/language/language.dart';
import 'package:state_hub/app/routes/routes.dart';
import 'package:state_hub/app/theme/theme.dart';
import 'package:state_hub/l10n/l10n.dart';
import 'package:state_hub/src/features/favorites/bloc/favorites_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetIt.I<FavoritesBloc>()..add(const LoadFavorites()),
        ),
        BlocProvider(
          create: (context) => GetIt.I<AppThemeCubit>(),
        ),
        BlocProvider(
          create: (context) => GetIt.I<AppLanguageCubit>(),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<AppLanguageCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              locale: locale,
              themeMode: themeState.themeMode,
              theme: AppTheme.light(scheme: themeState.schemeSelected),
              darkTheme: AppTheme.dark(scheme: themeState.schemeSelected),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: appRouter,
            );
          },
        );
      },
    );
  }
}

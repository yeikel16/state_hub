import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
      builder: (context, state) {
        return MaterialApp.router(
          themeMode: state.themeMode,
          theme: AppTheme.light(scheme: state.schemeSelected),
          darkTheme: AppTheme.dark(scheme: state.schemeSelected),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: appRouter,
        );
      },
    );
  }
}

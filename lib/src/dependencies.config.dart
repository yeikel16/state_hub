// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:state_hub/app/theme/cubit/app_theme_cubit.dart' as _i67;
import 'package:state_hub/src/data/data_source/api.dart' as _i212;
import 'package:state_hub/src/data/data_source/favorites_data_source.dart'
    as _i388;
import 'package:state_hub/src/data/repository/favorites_repository.dart'
    as _i751;
import 'package:state_hub/src/data/repository/properties_repository.dart'
    as _i24;
import 'package:state_hub/src/features/favorites/bloc/favorites_bloc.dart'
    as _i327;
import 'package:state_hub/src/features/properties/blocs/properties_bloc/properties_bloc.dart'
    as _i331;
import 'package:state_hub/src/features/properties/blocs/properties_filter_bloc/properties_filter_bloc.dart'
    as _i731;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i67.AppThemeCubit>(() => _i67.AppThemeCubit());
    gh.lazySingleton<_i388.FavoritesDataSource>(
      () => _i388.InMemoryFavoritesDataSource(),
    );
    gh.lazySingleton<_i212.PropertiesApi>(() => _i212.LocalPropertiesApi());
    gh.lazySingleton<_i24.PropertiesRepository>(
      () => _i24.PropertiesRepository(api: gh<_i212.PropertiesApi>()),
    );
    gh.factory<_i331.PropertiesBloc>(
      () => _i331.PropertiesBloc(
        propertiesRepository: gh<_i24.PropertiesRepository>(),
      ),
    );
    gh.factory<_i731.PropertiesFilterBloc>(
      () => _i731.PropertiesFilterBloc(
        propertiesRepository: gh<_i24.PropertiesRepository>(),
      ),
    );
    gh.lazySingleton<_i751.FavoritesRepository>(
      () => _i751.FavoritesRepository(
        dataSource: gh<_i388.FavoritesDataSource>(),
      ),
    );
    gh.factory<_i327.FavoritesBloc>(
      () => _i327.FavoritesBloc(
        favoritesRepository: gh<_i751.FavoritesRepository>(),
      ),
    );
    return this;
  }
}

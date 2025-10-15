import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:state_hub/src/core/core.dart';
import 'package:state_hub/src/data/repository/properties_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'properties_filter_event.dart';
part 'properties_filter_state.dart';

@injectable
class PropertiesFilterBloc
    extends Bloc<PropertiesFilterEvent, PropertiesFilterState> {
  PropertiesFilterBloc({
    required PropertiesRepository propertiesRepository,
  }) : _propertiesRepository = propertiesRepository,
       super(const PropertiesFilterState()) {
    on<PropertiesFilterSearchChanged>(
      _onSearchChanged,
      transformer: (events, mapper) {
        return restartable<PropertiesFilterSearchChanged>().call(
          events.debounce(const Duration(milliseconds: 300)),
          mapper,
        );
      },
    );

    on<PropertiesFilterCityChanged>(
      _onCityChanged,
      transformer: restartable(),
    );

    on<PropertiesFilterCitiesRequested>(
      _onCitiesRequested,
      transformer: droppable(),
    );

    on<PropertiesFilterCleared>(
      _onCleared,
      transformer: restartable(),
    );
  }

  final PropertiesRepository _propertiesRepository;

  Future<void> _onSearchChanged(
    PropertiesFilterSearchChanged event,
    Emitter<PropertiesFilterState> emit,
  ) async {
    final trimmedQuery = event.query.trim();
    emit(
      state.copyWith(
        searchQuery: () => trimmedQuery.isEmpty ? null : trimmedQuery,
      ),
    );
  }

  Future<void> _onCityChanged(
    PropertiesFilterCityChanged event,
    Emitter<PropertiesFilterState> emit,
  ) async {
    emit(state.copyWith(selectedCity: () => event.city));
  }

  Future<void> _onCitiesRequested(
    PropertiesFilterCitiesRequested event,
    Emitter<PropertiesFilterState> emit,
  ) async {
    if (state.availableCities.isNotEmpty) return;

    emit(state.copyWith(isLoadingCities: true));

    try {
      final cities = await _propertiesRepository.getCities();
      emit(
        state.copyWith(
          availableCities: cities,
          isLoadingCities: false,
        ),
      );
    } on AppException {
      emit(state.copyWith(isLoadingCities: false));
      // Log error but don't throw, cities are optional
      // Consider adding error state if needed
    }
  }

  Future<void> _onCleared(
    PropertiesFilterCleared event,
    Emitter<PropertiesFilterState> emit,
  ) async {
    emit(
      PropertiesFilterState(
        availableCities: state.availableCities,
        isLoadingCities: state.isLoadingCities,
      ),
    );
  }
}

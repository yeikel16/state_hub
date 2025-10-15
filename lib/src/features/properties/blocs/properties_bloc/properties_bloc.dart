import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:state_hub/src/core/core.dart';
import 'package:state_hub/src/data/models/models.dart';
import 'package:state_hub/src/data/repository/properties_repository.dart';

part 'properties_event.dart';
part 'properties_state.dart';

@injectable
class PropertiesBloc extends Bloc<PropertiesEvent, PropertiesState> {
  PropertiesBloc({
    required PropertiesRepository propertiesRepository,
  }) : _propertiesRepository = propertiesRepository,
       super(const PropertiesState()) {
    on<LoadProperties>(
      _onPropertiesRequested,
      transformer: droppable(),
    );
  }

  final PropertiesRepository _propertiesRepository;
  static const int pageSize = 10;

  Future<void> _onPropertiesRequested(
    LoadProperties event,
    Emitter<PropertiesState> emit,
  ) async {
    // Detectar si los filtros cambiaron
    final filtersChanged =
        state.query != event.query || state.city != event.city;

    // Si los filtros cambiaron, resetear
    // Si no cambiaron pero ya llegamos al máximo, no hacer nada
    if (!filtersChanged && state.hasReachedMax) {
      return;
    }

    // Emitir estado de carga
    emit(
      state.copyWith(
        isLoading: true,
        error: () => null,
      ),
    );

    try {
      // Si los filtros cambiaron, empezar desde página 1
      // Si no, cargar la siguiente página
      final page = filtersChanged ? 1 : state.currentPage + 1;

      final result = await _propertiesRepository.getProperties(
        query: event.query,
        city: event.city,
        page: page,
      );

      // Si los filtros cambiaron, reemplazar la lista
      // Si no, agregar a la lista existente
      final properties = filtersChanged
          ? result.items
          : [...state.properties, ...result.items];

      emit(
        PropertiesState(
          properties: properties,
          hasReachedMax: !result.hasNext,
          currentPage: page,
          query: event.query,
          city: event.city,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: () => e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: () => 'An unexpected error occurred: $e',
        ),
      );
    }
  }
}

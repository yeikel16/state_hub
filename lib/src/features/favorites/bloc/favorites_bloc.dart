import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:state_hub/src/core/core.dart';
import 'package:state_hub/src/data/models/models.dart';
import 'package:state_hub/src/data/repository/favorites_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

@injectable
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({
    required FavoritesRepository favoritesRepository,
  }) : _favoritesRepository = favoritesRepository,
       super(const FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  final FavoritesRepository _favoritesRepository;

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: () => null));

    try {
      final favorites = await _favoritesRepository.getFavoriteProperties();

      emit(
        state.copyWith(
          favorites: favorites,
          isLoading: false,
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

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    final oldState = state;
    final isFavorite = state.isFavorite(event.property.id);

    emit(state.copyWith(error: () => null));

    if (isFavorite) {
      final updatedFavorites = state.favorites
          .where((p) => p.id != event.property.id)
          .toList();

      emit(state.copyWith(favorites: updatedFavorites));
    } else {
      emit(state.copyWith(favorites: [...state.favorites, event.property]));
    }

    try {
      await _favoritesRepository.toggleFavoriteProperty(event.property);
    } on AppException catch (e) {
      emit(
        state.copyWith(
          favorites: oldState.favorites,
          error: () => e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          favorites: oldState.favorites,
          error: () => 'An unexpected error occurred: $e',
        ),
      );
    }

    add(const LoadFavorites());
  }
}

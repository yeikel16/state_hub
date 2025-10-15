part of 'favorites_bloc.dart';

class FavoritesState extends Equatable {
  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
    this.error,
  });

  final List<PropertyModel> favorites;
  final bool isLoading;
  final String? error;

  FavoritesState copyWith({
    List<PropertyModel>? favorites,
    bool? isLoading,
    String? Function()? error,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
    );
  }

  bool isFavorite(int propertyId) {
    return favorites.any((property) => property.id == propertyId);
  }

  @override
  List<Object?> get props => [favorites, isLoading, error];
}

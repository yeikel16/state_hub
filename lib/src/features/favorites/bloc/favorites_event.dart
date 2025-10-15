part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

final class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

final class ToggleFavorite extends FavoritesEvent {
  const ToggleFavorite(this.property);

  final PropertyModel property;

  @override
  List<Object?> get props => [property];
}

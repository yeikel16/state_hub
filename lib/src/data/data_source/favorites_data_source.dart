import 'package:injectable/injectable.dart';
import 'package:state_hub/src/data/models/models.dart';

abstract class FavoritesDataSource {
  Future<List<PropertyModel>> getFavoriteProperties();
  Future<void> addFavoriteProperty(PropertyModel property);
  Future<void> removeFavoriteProperty(int propertyId);
  Future<bool> isFavoriteProperty(int propertyId);
  Future<void> clearFavorites();
}

@LazySingleton(as: FavoritesDataSource)
class InMemoryFavoritesDataSource implements FavoritesDataSource {
  final Set<PropertyModel> _favoriteProperties = <PropertyModel>{};

  @override
  Future<List<PropertyModel>> getFavoriteProperties() async {
    return _favoriteProperties.toList();
  }

  @override
  Future<void> addFavoriteProperty(PropertyModel property) async {
    _favoriteProperties.add(property);
  }

  @override
  Future<void> removeFavoriteProperty(int propertyId) async {
    _favoriteProperties.removeWhere((property) => property.id == propertyId);
  }

  @override
  Future<bool> isFavoriteProperty(int propertyId) async {
    return _favoriteProperties.any((property) => property.id == propertyId);
  }

  @override
  Future<void> clearFavorites() async {
    _favoriteProperties.clear();
  }
}

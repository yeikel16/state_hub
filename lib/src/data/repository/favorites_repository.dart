import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:state_hub/src/core/core.dart';
import 'package:state_hub/src/data/data_source/favorites_data_source.dart';
import 'package:state_hub/src/data/models/models.dart';

@lazySingleton
class FavoritesRepository {
  FavoritesRepository({required FavoritesDataSource dataSource})
      : _dataSource = dataSource;

  final FavoritesDataSource _dataSource;

  Future<List<PropertyModel>> getFavoriteProperties() async {
    try {
      return await _dataSource.getFavoriteProperties();
    } on PlatformException catch (e) {
      throw CacheException('Platform error: ${e.message}');
    } catch (e) {
      throw UnknownException('Unexpected error: $e');
    }
  }

  Future<void> addFavoriteProperty(PropertyModel property) async {
    try {
      await _dataSource.addFavoriteProperty(property);
    } on PlatformException catch (e) {
      throw CacheException('Platform error: ${e.message}');
    } catch (e) {
      throw UnknownException('Unexpected error: $e');
    }
  }

  Future<void> removeFavoriteProperty(int propertyId) async {
    try {
      await _dataSource.removeFavoriteProperty(propertyId);
    } on PlatformException catch (e) {
      throw CacheException('Platform error: ${e.message}');
    } catch (e) {
      throw UnknownException('Unexpected error: $e');
    }
  }

  Future<bool> isFavoriteProperty(int propertyId) async {
    try {
      return await _dataSource.isFavoriteProperty(propertyId);
    } on PlatformException catch (e) {
      throw CacheException('Platform error: ${e.message}');
    } catch (e) {
      throw UnknownException('Unexpected error: $e');
    }
  }

  Future<void> toggleFavoriteProperty(PropertyModel property) async {
    try {
      final isFavorite = await _dataSource.isFavoriteProperty(property.id);
      if (isFavorite) {
        await _dataSource.removeFavoriteProperty(property.id);
      } else {
        await _dataSource.addFavoriteProperty(property);
      }
    } on PlatformException catch (e) {
      throw CacheException('Platform error: ${e.message}');
    } catch (e) {
      throw UnknownException('Unexpected error: $e');
    }
  }

  Future<void> clearFavorites() async {
    try {
      await _dataSource.clearFavorites();
    } on PlatformException catch (e) {
      throw CacheException('Platform error: ${e.message}');
    } catch (e) {
      throw UnknownException('Unexpected error: $e');
    }
  }
}

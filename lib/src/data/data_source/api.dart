import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:state_hub/src/data/models/models.dart';

abstract class PropertiesApi {
  Future<PaginateModel<PropertyModel>> getProperties({
    String? query,
    String? city,
    int page = 1,
    int limit = 10,
  });

  Future<List<String>> getCities();
}

@LazySingleton(as: PropertiesApi)
class LocalPropertiesApi extends PropertiesApi {
  List<PropertyModel>? _cachedProperties;

  Future<List<PropertyModel>> _loadProperties() async {
    if (_cachedProperties != null) return _cachedProperties!;

    final jsonString = await rootBundle.loadString(
      'assets/data/properties.json',
    );
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final propertiesList = jsonData['properties'] as List<dynamic>;

    _cachedProperties = propertiesList
        .map((json) => PropertyModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return _cachedProperties!;
  }

  @override
  Future<List<String>> getCities() async {
    final properties = await _loadProperties();
    final cities = properties.map((property) => property.city).toSet().toList()
      ..sort();
    return cities;
  }

  @override
  Future<PaginateModel<PropertyModel>> getProperties({
    String? query,
    String? city,
    int page = 1,
    int limit = 10,
  }) async {
    final allProperties = await _loadProperties();

    var filteredProperties = allProperties;

    if (city != null && city.isNotEmpty) {
      filteredProperties = filteredProperties
          .where(
            (property) => property.city.toLowerCase() == city.toLowerCase(),
          )
          .toList();
    }

    if (query != null && query.isNotEmpty) {
      final queryLower = query.toLowerCase();
      filteredProperties = filteredProperties
          .where(
            (property) =>
                property.title.toLowerCase().contains(queryLower) ||
                property.description.toLowerCase().contains(queryLower) ||
                property.city.toLowerCase().contains(queryLower),
          )
          .toList();
    }

    final startIndex = (page - 1) * limit;
    final endIndex = (startIndex + limit).clamp(0, filteredProperties.length);

    final paginatedItems = startIndex < filteredProperties.length
        ? filteredProperties.sublist(startIndex, endIndex)
        : <PropertyModel>[];

    return PaginateModel<PropertyModel>(
      items: paginatedItems,
      hasPrevius: page > 1,
      hasNext: endIndex < filteredProperties.length,
    );
  }
}

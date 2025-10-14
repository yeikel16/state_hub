import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:state_hub/src/core/core.dart';
import 'package:state_hub/src/data/data_source/api.dart';
import 'package:state_hub/src/data/models/models.dart';

@lazySingleton
class PropertiesRepository {
  PropertiesRepository({required PropertiesApi api}) : _api = api;

  final PropertiesApi _api;

  Future<PaginateModel<PropertyModel>> getProperties({
    String? query,
    String? city,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      return await _api.getProperties(
        query: query,
        city: city,
        page: page,
        limit: limit,
      );
    } on SocketException catch (e) {
      throw NetworkException('No internet connection: ${e.message}');
    } on HttpException catch (e) {
      throw ServerException('HTTP error: ${e.message}');
    } on FormatException catch (e) {
      throw DataException('Invalid data format: ${e.message}');
    } on PlatformException catch (e) {
      throw DataException('Platform error: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Request timeout: ${e.message}');
    } catch (e) {
      throw UnknownException('Unexpected error: $e');
    }
  }

  Future<List<String>> getCities() async {
    try {
      return await _api.getCities();
    } on SocketException catch (e) {
      throw NetworkException('No internet connection: ${e.message}');
    } on HttpException catch (e) {
      throw ServerException('HTTP error: ${e.message}');
    } on FormatException catch (e) {
      throw DataException('Invalid data format: ${e.message}');
    } on PlatformException catch (e) {
      throw DataException('Platform error: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Request timeout: ${e.message}');
    } catch (e) {
      throw UnknownException('Unexpected error: $e');
    }
  }
}

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_hub/src/core/core.dart';
import 'package:state_hub/src/data/data_source/api.dart';
import 'package:state_hub/src/data/models/models.dart';
import 'package:state_hub/src/data/repository/properties_repository.dart';

class MockPropertiesApi extends Mock implements PropertiesApi {}

void main() {
  group('PropertiesRepository', () {
    late PropertiesRepository repository;
    late MockPropertiesApi mockApi;

    setUp(() {
      mockApi = MockPropertiesApi();
      repository = PropertiesRepository(api: mockApi);
    });

    group('getProperties', () {
      final mockProperties = [
        const PropertyModel(
          id: 1,
          title: 'Modern Apartment',
          city: 'Miami',
          price: 1200,
          image: 'https://example.com/image1.jpg',
          description: 'Spacious apartment with ocean view',
        ),
        const PropertyModel(
          id: 2,
          title: 'Downtown Loft',
          city: 'New York',
          price: 2500,
          image: 'https://example.com/image2.jpg',
          description: 'Industrial-style loft',
        ),
      ];

      final mockPaginatedResult = PaginateModel<PropertyModel>(
        items: mockProperties,
        hasPrevius: false,
        hasNext: false,
      );

      test('returns properties successfully', () async {
        when(
          () => mockApi.getProperties(
            query: any(named: 'query'),
            city: any(named: 'city'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => mockPaginatedResult);

        final result = await repository.getProperties();

        expect(result, mockPaginatedResult);
        verify(() => mockApi.getProperties()).called(1);
      });

      test('passes parameters correctly', () async {
        when(
          () => mockApi.getProperties(
            query: any(named: 'query'),
            city: any(named: 'city'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => mockPaginatedResult);

        await repository.getProperties(
          query: 'apartment',
          city: 'Miami',
          page: 2,
          limit: 5,
        );

        verify(
          () => mockApi.getProperties(
            query: 'apartment',
            city: 'Miami',
            page: 2,
            limit: 5,
          ),
        ).called(1);
      });

      test('throws NetworkException on SocketException', () async {
        when(
          () => mockApi.getProperties(
            query: any(named: 'query'),
            city: any(named: 'city'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(const SocketException('No internet connection'));

        expect(
          () => repository.getProperties(),
          throwsA(isA<NetworkException>()),
        );
      });

      test('throws ServerException on HttpException', () async {
        when(
          () => mockApi.getProperties(
            query: any(named: 'query'),
            city: any(named: 'city'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(const HttpException('Server error'));

        expect(
          () => repository.getProperties(),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws DataException on FormatException', () async {
        when(
          () => mockApi.getProperties(
            query: any(named: 'query'),
            city: any(named: 'city'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(const FormatException('Invalid format'));

        expect(
          () => repository.getProperties(),
          throwsA(isA<DataException>()),
        );
      });

      test('throws DataException on PlatformException', () async {
        when(
          () => mockApi.getProperties(
            query: any(named: 'query'),
            city: any(named: 'city'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(PlatformException(code: 'PLATFORM_ERROR'));

        expect(
          () => repository.getProperties(),
          throwsA(isA<DataException>()),
        );
      });

      test('throws UnknownException on unexpected error', () async {
        when(
          () => mockApi.getProperties(
            query: any(named: 'query'),
            city: any(named: 'city'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(Exception('Unexpected error'));

        expect(
          () => repository.getProperties(),
          throwsA(isA<UnknownException>()),
        );
      });
    });

    group('getCities', () {
      const mockCities = ['Miami', 'New York', 'Boston'];

      test('returns cities successfully', () async {
        when(() => mockApi.getCities()).thenAnswer((_) async => mockCities);

        final result = await repository.getCities();

        expect(result, mockCities);
        verify(() => mockApi.getCities()).called(1);
      });

      test('throws NetworkException on SocketException', () async {
        when(
          () => mockApi.getCities(),
        ).thenThrow(const SocketException('No internet connection'));

        expect(
          () => repository.getCities(),
          throwsA(isA<NetworkException>()),
        );
      });

      test('throws ServerException on HttpException', () async {
        when(
          () => mockApi.getCities(),
        ).thenThrow(const HttpException('Server error'));

        expect(
          () => repository.getCities(),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws UnknownException on unexpected error', () async {
        when(() => mockApi.getCities()).thenThrow(Exception('Unexpected'));

        expect(
          () => repository.getCities(),
          throwsA(isA<UnknownException>()),
        );
      });
    });
  });
}

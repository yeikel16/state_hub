import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_hub/src/core/core.dart';
import 'package:state_hub/src/data/data_source/favorites_data_source.dart';
import 'package:state_hub/src/data/models/models.dart';
import 'package:state_hub/src/data/repository/favorites_repository.dart';

class MockFavoritesDataSource extends Mock implements FavoritesDataSource {}

void main() {
  group('FavoritesRepository', () {
    late FavoritesRepository repository;
    late MockFavoritesDataSource mockDataSource;

    const mockProperty = PropertyModel(
      id: 1,
      title: 'Modern Apartment',
      city: 'Miami',
      price: 1200,
      image: 'https://example.com/image1.jpg',
      description: 'Spacious apartment',
    );

    setUpAll(() {
      registerFallbackValue(mockProperty);
    });

    setUp(() {
      mockDataSource = MockFavoritesDataSource();
      repository = FavoritesRepository(dataSource: mockDataSource);
    });

    group('getFavoriteProperties', () {
      final mockProperties = [
        const PropertyModel(
          id: 1,
          title: 'Modern Apartment',
          city: 'Miami',
          price: 1200,
          image: 'https://example.com/image1.jpg',
          description: 'Spacious apartment',
        ),
        const PropertyModel(
          id: 2,
          title: 'Downtown Loft',
          city: 'New York',
          price: 2500,
          image: 'https://example.com/image2.jpg',
          description: 'Industrial loft',
        ),
      ];

      test('returns favorite properties successfully', () async {
        when(
          () => mockDataSource.getFavoriteProperties(),
        ).thenAnswer((_) async => mockProperties);

        final result = await repository.getFavoriteProperties();

        expect(result, mockProperties);
        verify(() => mockDataSource.getFavoriteProperties()).called(1);
      });

      test('throws CacheException on PlatformException', () async {
        when(
          () => mockDataSource.getFavoriteProperties(),
        ).thenThrow(PlatformException(code: 'PLATFORM_ERROR'));

        expect(
          () => repository.getFavoriteProperties(),
          throwsA(isA<CacheException>()),
        );
      });

      test('throws UnknownException on unexpected error', () async {
        when(
          () => mockDataSource.getFavoriteProperties(),
        ).thenThrow(Exception('Unexpected error'));

        expect(
          () => repository.getFavoriteProperties(),
          throwsA(isA<UnknownException>()),
        );
      });
    });

    group('addFavoriteProperty', () {
      test('adds property successfully', () async {
        when(
          () => mockDataSource.addFavoriteProperty(any()),
        ).thenAnswer((_) async {});

        await repository.addFavoriteProperty(mockProperty);

        verify(
          () => mockDataSource.addFavoriteProperty(mockProperty),
        ).called(1);
      });

      test('throws CacheException on PlatformException', () async {
        when(
          () => mockDataSource.addFavoriteProperty(any()),
        ).thenThrow(PlatformException(code: 'PLATFORM_ERROR'));

        expect(
          () => repository.addFavoriteProperty(mockProperty),
          throwsA(isA<CacheException>()),
        );
      });

      test('throws UnknownException on unexpected error', () async {
        when(
          () => mockDataSource.addFavoriteProperty(any()),
        ).thenThrow(Exception('Unexpected error'));

        expect(
          () => repository.addFavoriteProperty(mockProperty),
          throwsA(isA<UnknownException>()),
        );
      });
    });

    group('removeFavoriteProperty', () {
      test('removes property successfully', () async {
        when(
          () => mockDataSource.removeFavoriteProperty(any()),
        ).thenAnswer((_) async {});

        await repository.removeFavoriteProperty(1);

        verify(() => mockDataSource.removeFavoriteProperty(1)).called(1);
      });

      test('throws CacheException on PlatformException', () async {
        when(
          () => mockDataSource.removeFavoriteProperty(any()),
        ).thenThrow(PlatformException(code: 'PLATFORM_ERROR'));

        expect(
          () => repository.removeFavoriteProperty(1),
          throwsA(isA<CacheException>()),
        );
      });

      test('throws UnknownException on unexpected error', () async {
        when(
          () => mockDataSource.removeFavoriteProperty(any()),
        ).thenThrow(Exception('Unexpected error'));

        expect(
          () => repository.removeFavoriteProperty(1),
          throwsA(isA<UnknownException>()),
        );
      });
    });

    group('isFavoriteProperty', () {
      test('returns true when property is favorite', () async {
        when(
          () => mockDataSource.isFavoriteProperty(any()),
        ).thenAnswer((_) async => true);

        final result = await repository.isFavoriteProperty(1);

        expect(result, true);
        verify(() => mockDataSource.isFavoriteProperty(1)).called(1);
      });

      test('returns false when property is not favorite', () async {
        when(
          () => mockDataSource.isFavoriteProperty(any()),
        ).thenAnswer((_) async => false);

        final result = await repository.isFavoriteProperty(1);

        expect(result, false);
        verify(() => mockDataSource.isFavoriteProperty(1)).called(1);
      });

      test('throws CacheException on PlatformException', () async {
        when(
          () => mockDataSource.isFavoriteProperty(any()),
        ).thenThrow(PlatformException(code: 'PLATFORM_ERROR'));

        expect(
          () => repository.isFavoriteProperty(1),
          throwsA(isA<CacheException>()),
        );
      });

      test('throws UnknownException on unexpected error', () async {
        when(
          () => mockDataSource.isFavoriteProperty(any()),
        ).thenThrow(Exception('Unexpected error'));

        expect(
          () => repository.isFavoriteProperty(1),
          throwsA(isA<UnknownException>()),
        );
      });
    });

    group('toggleFavoriteProperty', () {
      const mockProperty = PropertyModel(
        id: 1,
        title: 'Modern Apartment',
        city: 'Miami',
        price: 1200,
        image: 'https://example.com/image1.jpg',
        description: 'Spacious apartment',
      );

      test('adds property when not in favorites', () async {
        when(
          () => mockDataSource.isFavoriteProperty(any()),
        ).thenAnswer((_) async => false);
        when(
          () => mockDataSource.addFavoriteProperty(any()),
        ).thenAnswer((_) async {});

        await repository.toggleFavoriteProperty(mockProperty);

        verify(() => mockDataSource.isFavoriteProperty(1)).called(1);
        verify(
          () => mockDataSource.addFavoriteProperty(mockProperty),
        ).called(1);
        verifyNever(() => mockDataSource.removeFavoriteProperty(any()));
      });

      test('removes property when in favorites', () async {
        when(
          () => mockDataSource.isFavoriteProperty(any()),
        ).thenAnswer((_) async => true);
        when(
          () => mockDataSource.removeFavoriteProperty(any()),
        ).thenAnswer((_) async {});

        await repository.toggleFavoriteProperty(mockProperty);

        verify(() => mockDataSource.isFavoriteProperty(1)).called(1);
        verify(() => mockDataSource.removeFavoriteProperty(1)).called(1);
        verifyNever(() => mockDataSource.addFavoriteProperty(any()));
      });

      test('throws CacheException on PlatformException', () async {
        when(
          () => mockDataSource.isFavoriteProperty(any()),
        ).thenThrow(PlatformException(code: 'PLATFORM_ERROR'));

        expect(
          () => repository.toggleFavoriteProperty(mockProperty),
          throwsA(isA<CacheException>()),
        );
      });

      test('throws UnknownException on unexpected error', () async {
        when(
          () => mockDataSource.isFavoriteProperty(any()),
        ).thenThrow(Exception('Unexpected error'));

        expect(
          () => repository.toggleFavoriteProperty(mockProperty),
          throwsA(isA<UnknownException>()),
        );
      });
    });

    group('clearFavorites', () {
      test('clears favorites successfully', () async {
        when(() => mockDataSource.clearFavorites()).thenAnswer((_) async {});

        await repository.clearFavorites();

        verify(() => mockDataSource.clearFavorites()).called(1);
      });

      test('throws CacheException on PlatformException', () async {
        when(
          () => mockDataSource.clearFavorites(),
        ).thenThrow(PlatformException(code: 'PLATFORM_ERROR'));

        expect(
          () => repository.clearFavorites(),
          throwsA(isA<CacheException>()),
        );
      });

      test('throws UnknownException on unexpected error', () async {
        when(
          () => mockDataSource.clearFavorites(),
        ).thenThrow(Exception('Unexpected error'));

        expect(
          () => repository.clearFavorites(),
          throwsA(isA<UnknownException>()),
        );
      });
    });
  });
}

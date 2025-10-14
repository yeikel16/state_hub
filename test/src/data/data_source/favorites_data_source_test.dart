import 'package:flutter_test/flutter_test.dart';
import 'package:state_hub/src/data/data_source/favorites_data_source.dart';
import 'package:state_hub/src/data/models/models.dart';

void main() {
  group('InMemoryFavoritesDataSource', () {
    late InMemoryFavoritesDataSource dataSource;

    setUp(() {
      dataSource = InMemoryFavoritesDataSource();
    });

    group('getFavoriteProperties', () {
      test('returns empty list initially', () async {
        final result = await dataSource.getFavoriteProperties();

        expect(result, isEmpty);
      });

      test('returns list with added properties', () async {
        const property1 = PropertyModel(
          id: 1,
          title: 'Modern Apartment',
          city: 'Miami',
          price: 1200,
          image: 'https://example.com/image1.jpg',
          description: 'Spacious apartment',
        );

        const property2 = PropertyModel(
          id: 2,
          title: 'Downtown Loft',
          city: 'New York',
          price: 2500,
          image: 'https://example.com/image2.jpg',
          description: 'Industrial loft',
        );

        await dataSource.addFavoriteProperty(property1);
        await dataSource.addFavoriteProperty(property2);

        final result = await dataSource.getFavoriteProperties();

        expect(result.length, 2);
        expect(result, containsAll([property1, property2]));
      });
    });

    group('addFavoriteProperty', () {
      test('adds property to favorites', () async {
        const property = PropertyModel(
          id: 1,
          title: 'Modern Apartment',
          city: 'Miami',
          price: 1200,
          image: 'https://example.com/image1.jpg',
          description: 'Spacious apartment',
        );

        await dataSource.addFavoriteProperty(property);

        final result = await dataSource.getFavoriteProperties();
        expect(result, contains(property));
        expect(result.length, 1);
      });

      test('does not add duplicate properties', () async {
        const property = PropertyModel(
          id: 1,
          title: 'Modern Apartment',
          city: 'Miami',
          price: 1200,
          image: 'https://example.com/image1.jpg',
          description: 'Spacious apartment',
        );

        await dataSource.addFavoriteProperty(property);
        await dataSource.addFavoriteProperty(property);

        final result = await dataSource.getFavoriteProperties();
        expect(result.length, 1);
      });
    });

    group('removeFavoriteProperty', () {
      test('removes property from favorites', () async {
        const property = PropertyModel(
          id: 1,
          title: 'Modern Apartment',
          city: 'Miami',
          price: 1200,
          image: 'https://example.com/image1.jpg',
          description: 'Spacious apartment',
        );

        await dataSource.addFavoriteProperty(property);
        await dataSource.removeFavoriteProperty(1);

        final result = await dataSource.getFavoriteProperties();
        expect(result, isEmpty);
      });

      test('does nothing if property not in favorites', () async {
        const property = PropertyModel(
          id: 1,
          title: 'Modern Apartment',
          city: 'Miami',
          price: 1200,
          image: 'https://example.com/image1.jpg',
          description: 'Spacious apartment',
        );

        await dataSource.addFavoriteProperty(property);
        await dataSource.removeFavoriteProperty(999);

        final result = await dataSource.getFavoriteProperties();
        expect(result.length, 1);
        expect(result, contains(property));
      });
    });

    group('isFavoriteProperty', () {
      test('returns true for favorite property', () async {
        const property = PropertyModel(
          id: 1,
          title: 'Modern Apartment',
          city: 'Miami',
          price: 1200,
          image: 'https://example.com/image1.jpg',
          description: 'Spacious apartment',
        );

        await dataSource.addFavoriteProperty(property);

        final result = await dataSource.isFavoriteProperty(1);
        expect(result, true);
      });

      test('returns false for non-favorite property', () async {
        final result = await dataSource.isFavoriteProperty(1);
        expect(result, false);
      });

      test('returns false after removing property', () async {
        const property = PropertyModel(
          id: 1,
          title: 'Modern Apartment',
          city: 'Miami',
          price: 1200,
          image: 'https://example.com/image1.jpg',
          description: 'Spacious apartment',
        );

        await dataSource.addFavoriteProperty(property);
        await dataSource.removeFavoriteProperty(1);

        final result = await dataSource.isFavoriteProperty(1);
        expect(result, false);
      });
    });

    group('clearFavorites', () {
      test('clears all favorite properties', () async {
        const property1 = PropertyModel(
          id: 1,
          title: 'Modern Apartment',
          city: 'Miami',
          price: 1200,
          image: 'https://example.com/image1.jpg',
          description: 'Spacious apartment',
        );

        const property2 = PropertyModel(
          id: 2,
          title: 'Downtown Loft',
          city: 'New York',
          price: 2500,
          image: 'https://example.com/image2.jpg',
          description: 'Industrial loft',
        );

        await dataSource.addFavoriteProperty(property1);
        await dataSource.addFavoriteProperty(property2);
        await dataSource.clearFavorites();

        final result = await dataSource.getFavoriteProperties();
        expect(result, isEmpty);
      });

      test('does nothing if no favorites exist', () async {
        await dataSource.clearFavorites();

        final result = await dataSource.getFavoriteProperties();
        expect(result, isEmpty);
      });
    });
  });
}

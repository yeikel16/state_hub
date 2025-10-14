import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_hub/src/data/data_source/api.dart';
import 'package:state_hub/src/data/models/models.dart';

class MockLocalPropertiesApi extends Mock implements LocalPropertiesApi {}

void main() {
  group('LocalPropertiesApi', () {
    late LocalPropertiesApi api;

    setUp(() {
      api = MockLocalPropertiesApi();
    });

    group('getProperties', () {
      final mockProperties = [
        const PropertyModel(
          id: 1,
          title: 'Modern Apartment',
          city: 'Miami',
          price: 1200,
          image: 'https://picsum.photos/seed/prop1/400/300',
          description: 'Spacious 2-bedroom apartment with ocean view.',
        ),
        const PropertyModel(
          id: 2,
          title: 'Downtown Loft',
          city: 'New York',
          price: 2500,
          image: 'https://picsum.photos/seed/prop2/400/300',
          description: 'Industrial-style loft in the heart of Manhattan.',
        ),
        const PropertyModel(
          id: 3,
          title: 'Beach House',
          city: 'Miami',
          price: 3500,
          image: 'https://picsum.photos/seed/prop3/400/300',
          description: 'Stunning beachfront property with direct access.',
        ),
      ];

      test('returns paginated properties', () async {
        final expectedResult = PaginateModel<PropertyModel>(
          items: mockProperties,
          hasPrevius: false,
          hasNext: false,
        );

        when(() => api.getProperties()).thenAnswer((_) async => expectedResult);

        final result = await api.getProperties();

        expect(result.items.length, 3);
        expect(result.hasPrevius, false);
        expect(result.hasNext, false);
        verify(() => api.getProperties()).called(1);
      });

      test('filters properties by city', () async {
        final miamiProperties = mockProperties
            .where((p) => p.city == 'Miami')
            .toList();

        final expectedResult = PaginateModel<PropertyModel>(
          items: miamiProperties,
          hasPrevius: false,
          hasNext: false,
        );

        when(
          () => api.getProperties(city: 'Miami'),
        ).thenAnswer((_) async => expectedResult);

        final result = await api.getProperties(city: 'Miami');

        expect(result.items.length, 2);
        expect(result.items.every((p) => p.city == 'Miami'), true);
        verify(() => api.getProperties(city: 'Miami')).called(1);
      });

      test('filters properties by query', () async {
        final filteredProperties = mockProperties
            .where((p) => p.title.toLowerCase().contains('apartment'))
            .toList();

        final expectedResult = PaginateModel<PropertyModel>(
          items: filteredProperties,
          hasPrevius: false,
          hasNext: false,
        );

        when(
          () => api.getProperties(query: 'apartment'),
        ).thenAnswer((_) async => expectedResult);

        final result = await api.getProperties(query: 'apartment');

        expect(result.items.length, 1);
        expect(result.items.first.title, 'Modern Apartment');
        verify(() => api.getProperties(query: 'apartment')).called(1);
      });

      test('supports pagination', () async {
        final firstPage = [mockProperties.first];

        final expectedResult = PaginateModel<PropertyModel>(
          items: firstPage,
          hasPrevius: false,
          hasNext: true,
        );

        when(
          () => api.getProperties(limit: 1),
        ).thenAnswer((_) async => expectedResult);

        final result = await api.getProperties(limit: 1);

        expect(result.items.length, 1);
        expect(result.hasPrevius, false);
        expect(result.hasNext, true);
        verify(() => api.getProperties(limit: 1)).called(1);
      });
    });

    group('getCities', () {
      test('returns list of cities', () async {
        const expectedCities = ['Miami', 'New York', 'Boston'];

        when(() => api.getCities()).thenAnswer((_) async => expectedCities);

        final result = await api.getCities();

        expect(result, expectedCities);
        verify(() => api.getCities()).called(1);
      });

      test('returns sorted unique cities', () async {
        const expectedCities = ['Boston', 'Miami', 'New York'];

        when(() => api.getCities()).thenAnswer((_) async => expectedCities);

        final result = await api.getCities();

        expect(result, expectedCities);
        for (var i = 1; i < result.length; i++) {
          expect(result[i - 1].compareTo(result[i]), lessThan(0));
        }
        verify(() => api.getCities()).called(1);
      });
    });
  });
}

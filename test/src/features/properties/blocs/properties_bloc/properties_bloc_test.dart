import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_hub/src/core/core.dart';
import 'package:state_hub/src/data/models/models.dart';
import 'package:state_hub/src/data/repository/properties_repository.dart';
import 'package:state_hub/src/features/properties/blocs/blocs.dart';

class MockPropertiesRepository extends Mock implements PropertiesRepository {}

void main() {
  group('PropertiesBloc', () {
    late PropertiesRepository mockRepository;

    setUp(() {
      mockRepository = MockPropertiesRepository();
    });

    test('initial state is PropertiesState with default values', () {
      final bloc = PropertiesBloc(propertiesRepository: mockRepository);
      expect(
        bloc.state,
        const PropertiesState(),
      );
    });

    group('LoadProperties', () {
      final mockProperties = List.generate(
        10,
        (i) => PropertyModel(
          id: i + 1,
          title: 'Property ${i + 1}',
          city: 'Miami',
          price: 1000.0 + i * 100,
          image: 'https://example.com/image${i + 1}.jpg',
          description: 'Description ${i + 1}',
        ),
      );

      final mockPaginatedResult = PaginateModel<PropertyModel>(
        items: mockProperties,
        hasPrevius: false,
        hasNext: true,
      );

      blocTest<PropertiesBloc, PropertiesState>(
        'loads first page successfully',
        build: () {
          when(
            () => mockRepository.getProperties(
              query: any(named: 'query'),
              city: any(named: 'city'),
            ),
          ).thenAnswer((_) async => mockPaginatedResult);
          return PropertiesBloc(propertiesRepository: mockRepository);
        },
        act: (bloc) => bloc.add(const LoadProperties(query: null, city: null)),
        expect: () => [
          const PropertiesState(isLoading: true),
          PropertiesState(
            properties: mockProperties,
            currentPage: 1,
          ),
        ],
        verify: (_) {
          verify(
            () => mockRepository.getProperties(),
          ).called(1);
        },
      );

      blocTest<PropertiesBloc, PropertiesState>(
        'loads with hasReachedMax when no more data',
        build: () {
          when(
            () => mockRepository.getProperties(
              query: any(named: 'query'),
              city: any(named: 'city'),
            ),
          ).thenAnswer(
            (_) async => PaginateModel<PropertyModel>(
              items: mockProperties,
              hasPrevius: false,
              hasNext: false,
            ),
          );
          return PropertiesBloc(propertiesRepository: mockRepository);
        },
        act: (bloc) => bloc.add(const LoadProperties(query: null, city: null)),
        expect: () => [
          const PropertiesState(isLoading: true),
          PropertiesState(
            properties: mockProperties,
            hasReachedMax: true,
            currentPage: 1,
          ),
        ],
      );

      blocTest<PropertiesBloc, PropertiesState>(
        'passes query and city filters to repository',
        build: () {
          when(
            () => mockRepository.getProperties(
              query: 'apartment',
              city: 'Miami',
            ),
          ).thenAnswer((_) async => mockPaginatedResult);
          return PropertiesBloc(propertiesRepository: mockRepository);
        },
        act: (bloc) => bloc.add(
          const LoadProperties(query: 'apartment', city: 'Miami'),
        ),
        expect: () => [
          const PropertiesState(isLoading: true),
          PropertiesState(
            properties: mockProperties,
            currentPage: 1,
            query: 'apartment',
            city: 'Miami',
          ),
        ],
        verify: (_) {
          verify(
            () => mockRepository.getProperties(
              query: 'apartment',
              city: 'Miami',
            ),
          ).called(1);
        },
      );

      blocTest<PropertiesBloc, PropertiesState>(
        'emits error on AppException',
        build: () {
          when(
            () => mockRepository.getProperties(
              query: any(named: 'query'),
              city: any(named: 'city'),
            ),
          ).thenThrow(const NetworkException('No internet connection'));
          return PropertiesBloc(propertiesRepository: mockRepository);
        },
        act: (bloc) => bloc.add(const LoadProperties(query: null, city: null)),
        expect: () => [
          const PropertiesState(isLoading: true),
          const PropertiesState(
            error: 'No internet connection',
          ),
        ],
      );

      blocTest<PropertiesBloc, PropertiesState>(
        'emits error on unexpected exception',
        build: () {
          when(
            () => mockRepository.getProperties(
              query: any(named: 'query'),
              city: any(named: 'city'),
            ),
          ).thenThrow(Exception('Unexpected error'));
          return PropertiesBloc(propertiesRepository: mockRepository);
        },
        act: (bloc) => bloc.add(const LoadProperties(query: null, city: null)),
        expect: () => [
          const PropertiesState(isLoading: true),
          isA<PropertiesState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.error, 'error', contains('unexpected')),
        ],
      );
    });

    group('Pagination', () {
      final page1Properties = List.generate(
        10,
        (i) => PropertyModel(
          id: i + 1,
          title: 'Property ${i + 1}',
          city: 'Miami',
          price: 1000.0 + i * 100,
          image: 'https://example.com/image${i + 1}.jpg',
          description: 'Description ${i + 1}',
        ),
      );

      final page2Properties = List.generate(
        10,
        (i) => PropertyModel(
          id: i + 11,
          title: 'Property ${i + 11}',
          city: 'Miami',
          price: 2000.0 + i * 100,
          image: 'https://example.com/image${i + 11}.jpg',
          description: 'Description ${i + 11}',
        ),
      );

      blocTest<PropertiesBloc, PropertiesState>(
        'loads next page and appends to current properties',
        build: () {
          when(
            () => mockRepository.getProperties(
              page: 2,
            ),
          ).thenAnswer(
            (_) async => PaginateModel<PropertyModel>(
              items: page2Properties,
              hasPrevius: true,
              hasNext: false,
            ),
          );
          return PropertiesBloc(propertiesRepository: mockRepository);
        },
        seed: () => PropertiesState(
          properties: page1Properties,
          currentPage: 1,
        ),
        act: (bloc) => bloc.add(const LoadProperties(query: null, city: null)),
        expect: () => [
          PropertiesState(
            properties: page1Properties,
            isLoading: true,
            currentPage: 1,
          ),
          PropertiesState(
            properties: [...page1Properties, ...page2Properties],
            hasReachedMax: true,
            currentPage: 2,
          ),
        ],
        verify: (_) {
          verify(
            () => mockRepository.getProperties(
              page: 2,
            ),
          ).called(1);
        },
      );

      blocTest<PropertiesBloc, PropertiesState>(
        'does not load next page when hasReachedMax is true',
        build: () => PropertiesBloc(propertiesRepository: mockRepository),
        seed: () => PropertiesState(
          properties: page1Properties,
          hasReachedMax: true,
          currentPage: 1,
        ),
        act: (bloc) => bloc.add(const LoadProperties(query: null, city: null)),
        expect: () => <PropertiesState>[],
        verify: (_) {
          verifyNever(
            () => mockRepository.getProperties(
              query: any(named: 'query'),
              city: any(named: 'city'),
              page: any(named: 'page'),
            ),
          );
        },
      );

      blocTest<PropertiesBloc, PropertiesState>(
        'emits error on pagination exception',
        build: () {
          when(
            () => mockRepository.getProperties(
              page: 2,
            ),
          ).thenThrow(const NetworkException('No internet'));
          return PropertiesBloc(propertiesRepository: mockRepository);
        },
        seed: () => PropertiesState(
          properties: page1Properties,
          currentPage: 1,
        ),
        act: (bloc) => bloc.add(const LoadProperties(query: null, city: null)),
        expect: () => [
          PropertiesState(
            properties: page1Properties,
            isLoading: true,
            currentPage: 1,
          ),
          PropertiesState(
            properties: page1Properties,
            currentPage: 1,
            error: 'No internet',
          ),
        ],
      );
    });

    group('Filter changes', () {
      final miamiProperties = List.generate(
        10,
        (i) => PropertyModel(
          id: i + 1,
          title: 'Miami Property ${i + 1}',
          city: 'Miami',
          price: 1000.0 + i * 100,
          image: 'https://example.com/image${i + 1}.jpg',
          description: 'Description ${i + 1}',
        ),
      );

      final newYorkProperties = List.generate(
        10,
        (i) => PropertyModel(
          id: i + 11,
          title: 'New York Property ${i + 11}',
          city: 'New York',
          price: 2000.0 + i * 100,
          image: 'https://example.com/image${i + 11}.jpg',
          description: 'Description ${i + 11}',
        ),
      );

      blocTest<PropertiesBloc, PropertiesState>(
        'resets to page 1 when filters change',
        build: () {
          when(
            () => mockRepository.getProperties(
              city: 'New York',
            ),
          ).thenAnswer(
            (_) async => PaginateModel<PropertyModel>(
              items: newYorkProperties,
              hasPrevius: false,
              hasNext: false,
            ),
          );
          return PropertiesBloc(propertiesRepository: mockRepository);
        },
        seed: () => PropertiesState(
          properties: miamiProperties,
          currentPage: 2,
          city: 'Miami',
        ),
        act: (bloc) => bloc.add(
          const LoadProperties(query: null, city: 'New York'),
        ),
        expect: () => [
          PropertiesState(
            properties: miamiProperties,
            isLoading: true,
            currentPage: 2,
            city: 'Miami',
          ),
          PropertiesState(
            properties: newYorkProperties,
            hasReachedMax: true,
            currentPage: 1,
            city: 'New York',
          ),
        ],
        verify: (_) {
          verify(
            () => mockRepository.getProperties(
              city: 'New York',
            ),
          ).called(1);
        },
      );

      blocTest<PropertiesBloc, PropertiesState>(
        'resets to page 1 when query changes',
        build: () {
          when(
            () => mockRepository.getProperties(
              query: 'apartment',
            ),
          ).thenAnswer(
            (_) async => PaginateModel<PropertyModel>(
              items: miamiProperties,
              hasPrevius: false,
              hasNext: false,
            ),
          );
          return PropertiesBloc(propertiesRepository: mockRepository);
        },
        seed: () => PropertiesState(
          properties: newYorkProperties,
          currentPage: 3,
          query: 'house',
        ),
        act: (bloc) => bloc.add(
          const LoadProperties(query: 'apartment', city: null),
        ),
        expect: () => [
          PropertiesState(
            properties: newYorkProperties,
            isLoading: true,
            currentPage: 3,
            query: 'house',
          ),
          PropertiesState(
            properties: miamiProperties,
            hasReachedMax: true,
            currentPage: 1,
            query: 'apartment',
          ),
        ],
        verify: (_) {
          verify(
            () => mockRepository.getProperties(
              query: 'apartment',
            ),
          ).called(1);
        },
      );
    });
  });
}

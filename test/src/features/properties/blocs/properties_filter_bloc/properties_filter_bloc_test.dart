import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_hub/src/core/core.dart';
import 'package:state_hub/src/data/repository/properties_repository.dart';
import 'package:state_hub/src/features/properties/blocs/blocs.dart';

class MockPropertiesRepository extends Mock implements PropertiesRepository {}

void main() {
  group('PropertiesFilterBloc', () {
    late PropertiesRepository mockRepository;

    setUp(() {
      mockRepository = MockPropertiesRepository();
    });

    test('initial state is PropertiesFilterState with default values', () {
      final bloc = PropertiesFilterBloc(
        propertiesRepository: mockRepository,
      );

      expect(
        bloc.state,
        const PropertiesFilterState(),
      );
    });

    group('PropertiesFilterSearchChanged', () {
      blocTest<PropertiesFilterBloc, PropertiesFilterState>(
        'emits state with search query',
        build: () => PropertiesFilterBloc(
          propertiesRepository: mockRepository,
        ),
        act: (bloc) => bloc.add(
          const PropertiesFilterSearchChanged('apartment'),
        ),
        wait: const Duration(milliseconds: 350),
        expect: () => [
          const PropertiesFilterState(searchQuery: 'apartment'),
        ],
      );

      blocTest<PropertiesFilterBloc, PropertiesFilterState>(
        'emits state with null when query is empty',
        build: () => PropertiesFilterBloc(
          propertiesRepository: mockRepository,
        ),
        act: (bloc) => bloc.add(
          const PropertiesFilterSearchChanged(''),
        ),
        wait: const Duration(milliseconds: 350),
        expect: () => [
          const PropertiesFilterState(),
        ],
      );

      blocTest<PropertiesFilterBloc, PropertiesFilterState>(
        'trims whitespace from query',
        build: () => PropertiesFilterBloc(
          propertiesRepository: mockRepository,
        ),
        act: (bloc) => bloc.add(
          const PropertiesFilterSearchChanged('  apartment  '),
        ),
        wait: const Duration(milliseconds: 350),
        expect: () => [
          const PropertiesFilterState(searchQuery: 'apartment'),
        ],
      );

      blocTest<PropertiesFilterBloc, PropertiesFilterState>(
        'debounces multiple search events',
        build: () => PropertiesFilterBloc(
          propertiesRepository: mockRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const PropertiesFilterSearchChanged('a'))
            ..add(const PropertiesFilterSearchChanged('ap'))
            ..add(const PropertiesFilterSearchChanged('apa'))
            ..add(const PropertiesFilterSearchChanged('apart'))
            ..add(const PropertiesFilterSearchChanged('apartment'));
        },
        wait: const Duration(milliseconds: 350),
        expect: () => [
          const PropertiesFilterState(searchQuery: 'apartment'),
        ],
      );
    });

    group('PropertiesFilterCityChanged', () {
      blocTest<PropertiesFilterBloc, PropertiesFilterState>(
        'emits state with selected city',
        build: () => PropertiesFilterBloc(
          propertiesRepository: mockRepository,
        ),
        act: (bloc) => bloc.add(
          const PropertiesFilterCityChanged('Miami'),
        ),
        expect: () => [
          const PropertiesFilterState(selectedCity: 'Miami'),
        ],
      );

      blocTest<PropertiesFilterBloc, PropertiesFilterState>(
        'emits state with null when city is cleared',
        build: () => PropertiesFilterBloc(
          propertiesRepository: mockRepository,
        ),
        seed: () => const PropertiesFilterState(selectedCity: 'Miami'),
        act: (bloc) => bloc.add(
          const PropertiesFilterCityChanged(null),
        ),
        expect: () => [
          const PropertiesFilterState(),
        ],
      );
    });

    group('PropertiesFilterCitiesRequested', () {
      const mockCities = ['Miami', 'New York', 'Boston'];

      blocTest<PropertiesFilterBloc, PropertiesFilterState>(
        'loads cities successfully',
        build: () {
          when(
            () => mockRepository.getCities(),
          ).thenAnswer((_) async => mockCities);
          return PropertiesFilterBloc(
            propertiesRepository: mockRepository,
          );
        },
        act: (bloc) => bloc.add(const PropertiesFilterCitiesRequested()),
        expect: () => [
          const PropertiesFilterState(isLoadingCities: true),
          const PropertiesFilterState(
            availableCities: mockCities,
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.getCities()).called(1);
        },
      );

      blocTest<PropertiesFilterBloc, PropertiesFilterState>(
        'does not reload cities if already loaded',
        build: () {
          when(
            () => mockRepository.getCities(),
          ).thenAnswer((_) async => mockCities);
          return PropertiesFilterBloc(
            propertiesRepository: mockRepository,
          );
        },
        seed: () => const PropertiesFilterState(
          availableCities: mockCities,
        ),
        act: (bloc) => bloc.add(const PropertiesFilterCitiesRequested()),
        expect: () => <String>[],
        verify: (_) {
          verifyNever(() => mockRepository.getCities());
        },
      );

      blocTest<PropertiesFilterBloc, PropertiesFilterState>(
        'handles error when loading cities',
        build: () {
          when(
            () => mockRepository.getCities(),
          ).thenThrow(const NetworkException('No internet'));
          return PropertiesFilterBloc(
            propertiesRepository: mockRepository,
          );
        },
        act: (bloc) => bloc.add(const PropertiesFilterCitiesRequested()),
        expect: () => [
          const PropertiesFilterState(isLoadingCities: true),
          const PropertiesFilterState(),
        ],
      );

      blocTest<PropertiesFilterBloc, PropertiesFilterState>(
        'drops concurrent city requests',
        build: () {
          when(() => mockRepository.getCities()).thenAnswer(
            (_) => Future.delayed(
              const Duration(milliseconds: 100),
              () => mockCities,
            ),
          );
          return PropertiesFilterBloc(
            propertiesRepository: mockRepository,
          );
        },
        act: (bloc) {
          bloc
            ..add(const PropertiesFilterCitiesRequested())
            ..add(const PropertiesFilterCitiesRequested())
            ..add(const PropertiesFilterCitiesRequested());
        },
        wait: const Duration(milliseconds: 150),
        expect: () => [
          const PropertiesFilterState(isLoadingCities: true),
          const PropertiesFilterState(
            availableCities: mockCities,
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.getCities()).called(1);
        },
      );
    });

    group('PropertiesFilterCleared', () {
      const mockCities = ['Miami', 'New York'];

      blocTest<PropertiesFilterBloc, PropertiesFilterState>(
        'clears all filters but keeps cities',
        build: () => PropertiesFilterBloc(
          propertiesRepository: mockRepository,
        ),
        seed: () => const PropertiesFilterState(
          searchQuery: 'apartment',
          selectedCity: 'Miami',
          availableCities: mockCities,
        ),
        act: (bloc) => bloc.add(const PropertiesFilterCleared()),
        expect: () => [
          const PropertiesFilterState(
            availableCities: mockCities,
          ),
        ],
      );
    });

    group('hasActiveFilters', () {
      test('returns true when search query is set', () {
        const state = PropertiesFilterState(searchQuery: 'apartment');
        expect(state.hasActiveFilters, true);
      });

      test('returns true when city is selected', () {
        const state = PropertiesFilterState(selectedCity: 'Miami');
        expect(state.hasActiveFilters, true);
      });

      test('returns true when both filters are set', () {
        const state = PropertiesFilterState(
          searchQuery: 'apartment',
          selectedCity: 'Miami',
        );
        expect(state.hasActiveFilters, true);
      });

      test('returns false when no filters are set', () {
        const state = PropertiesFilterState();
        expect(state.hasActiveFilters, false);
      });

      test('returns false when search query is empty string', () {
        const state = PropertiesFilterState(searchQuery: '');
        expect(state.hasActiveFilters, false);
      });

      test('returns false when city is empty string', () {
        const state = PropertiesFilterState(selectedCity: '');
        expect(state.hasActiveFilters, false);
      });
    });
  });
}

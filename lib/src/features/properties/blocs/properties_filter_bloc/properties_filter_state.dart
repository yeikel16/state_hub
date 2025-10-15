part of 'properties_filter_bloc.dart';

class PropertiesFilterState extends Equatable {
  const PropertiesFilterState({
    this.searchQuery,
    this.selectedCity,
    this.availableCities = const [],
    this.isLoadingCities = false,
  });

  final String? searchQuery;
  final String? selectedCity;
  final List<String> availableCities;
  final bool isLoadingCities;

  bool get hasActiveFilters =>
      (searchQuery != null && searchQuery!.isNotEmpty) ||
      (selectedCity != null && selectedCity!.isNotEmpty);

  PropertiesFilterState copyWith({
    ValueGetter<String?>? searchQuery,
    ValueGetter<String?>? selectedCity,
    List<String>? availableCities,
    bool? isLoadingCities,
  }) {
    return PropertiesFilterState(
      searchQuery: searchQuery != null ? searchQuery() : this.searchQuery,
      selectedCity: selectedCity != null ? selectedCity() : this.selectedCity,
      availableCities: availableCities ?? this.availableCities,
      isLoadingCities: isLoadingCities ?? this.isLoadingCities,
    );
  }

  @override
  List<Object?> get props => [
    searchQuery,
    selectedCity,
    availableCities,
    isLoadingCities,
  ];
}

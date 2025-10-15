part of 'properties_bloc.dart';

class PropertiesState extends Equatable {
  const PropertiesState({
    this.properties = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.currentPage = 0,
    this.query,
    this.city,
    this.error,
  });

  final List<PropertyModel> properties;
  final bool isLoading;
  final bool hasReachedMax;
  final int currentPage;
  final String? query;
  final String? city;
  final String? error;

  PropertiesState copyWith({
    List<PropertyModel>? properties,
    bool? isLoading,
    bool? hasReachedMax,
    int? currentPage,
    ValueGetter<String?>? query,
    ValueGetter<String?>? city,
    ValueGetter<String?>? error,
  }) {
    return PropertiesState(
      properties: properties ?? this.properties,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      query: query != null ? query() : this.query,
      city: city != null ? city() : this.city,
      error: error != null ? error() : this.error,
    );
  }

  PropertiesState clearError() {
    return PropertiesState(
      properties: properties,
      isLoading: isLoading,
      hasReachedMax: hasReachedMax,
      currentPage: currentPage,
      query: query,
      city: city,
    );
  }

  @override
  List<Object?> get props => [
        properties,
        isLoading,
        hasReachedMax,
        currentPage,
        query,
        city,
        error,
      ];
}

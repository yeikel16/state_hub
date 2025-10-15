part of 'properties_filter_bloc.dart';

sealed class PropertiesFilterEvent extends Equatable {
  const PropertiesFilterEvent();

  @override
  List<Object?> get props => [];
}

final class PropertiesFilterSearchChanged extends PropertiesFilterEvent {
  const PropertiesFilterSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class PropertiesFilterCityChanged extends PropertiesFilterEvent {
  const PropertiesFilterCityChanged(this.city);

  final String? city;

  @override
  List<Object?> get props => [city];
}

final class PropertiesFilterCitiesRequested extends PropertiesFilterEvent {
  const PropertiesFilterCitiesRequested();
}

final class PropertiesFilterCleared extends PropertiesFilterEvent {
  const PropertiesFilterCleared();
}

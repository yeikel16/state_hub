part of 'properties_bloc.dart';

sealed class PropertiesEvent extends Equatable {
  const PropertiesEvent();

  @override
  List<Object?> get props => [];
}

final class LoadProperties extends PropertiesEvent {
  const LoadProperties({
    required this.query,
    required this.city,
  });

  final String? query;
  final String? city;

  @override
  List<Object?> get props => [query, city];
}

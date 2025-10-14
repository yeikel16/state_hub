import 'package:equatable/equatable.dart';

class PaginateModel<T> extends Equatable {
  const PaginateModel({
    required this.items,
    required this.hasPrevius,
    required this.hasNext,
  });

  final List<T> items;
  final bool hasPrevius;
  final bool hasNext;

  @override
  List<Object> get props => [items, hasPrevius, hasNext];
}

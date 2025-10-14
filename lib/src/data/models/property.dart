import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'property.g.dart';

@JsonSerializable()
class PropertyModel extends Equatable {
  const PropertyModel({
    required this.id,
    required this.title,
    required this.city,
    required this.price,
    required this.image,
    required this.description,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  final int id;
  final String title;
  final String city;
  final double price;
  final String? image;
  final String description;
  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      title,
      city,
      price,
      image,
      description,
    ];
  }
}

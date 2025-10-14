// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      city: json['city'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String?,
      description: json['description'] as String,
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'city': instance.city,
      'price': instance.price,
      'image': instance.image,
      'description': instance.description,
    };

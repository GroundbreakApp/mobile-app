// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaModel _$MediaModelFromJson(Map json) => MediaModel(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      gifUrl: json['gifUrl'] as String? ?? '',
      calendlyUrl: json['calendlyUrl'] as String? ?? '',
      creator: json['creator'] as String? ?? '',
      createdAt: Serialization.dateTimeFromJson(json['createdAt']),
      updatedAt: Serialization.dateTimeFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$MediaModelToJson(MediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'gifUrl': instance.gifUrl,
      'calendlyUrl': instance.calendlyUrl,
      'creator': instance.creator,
      'createdAt': Serialization.dateTimeToJson(instance.createdAt),
      'updatedAt': Serialization.dateTimeToJson(instance.updatedAt),
    };

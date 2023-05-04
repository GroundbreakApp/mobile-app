// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ground_break/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'media_model.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class MediaModel extends Equatable {
  MediaModel({
    this.id = '',
    required this.url,
    required this.gifUrl,
    required this.calendlyUrl,
    this.creator = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  @JsonKey()
  final String id;
  @JsonKey(defaultValue: '')
  final String url;
  @JsonKey(defaultValue: '')
  final String gifUrl;
  @JsonKey(defaultValue: '')
  final String calendlyUrl;
  @JsonKey()
  final String creator;
  @JsonKey(
    toJson: Serialization.dateTimeToJson,
    fromJson: Serialization.dateTimeFromJson,
    includeIfNull: true,
  )
  final DateTime? createdAt;
  @JsonKey(
    toJson: Serialization.dateTimeToJson,
    fromJson: Serialization.dateTimeFromJson,
    includeIfNull: true,
  )
  final DateTime? updatedAt;

  factory MediaModel.fromJson(Map<dynamic, dynamic> json) =>
      _$MediaModelFromJson(json);

  factory MediaModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) =>
      MediaModel.fromJson(doc.data()!);

  Map<String, dynamic> toJson() => _$MediaModelToJson(this);

  MediaModel copyWith({
    String? id,
    String? url,
    String? gifUrl,
    String? calendlyUrl,
    String? creator,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MediaModel(
      id: id ?? this.id,
      url: url ?? this.url,
      gifUrl: gifUrl ?? this.gifUrl,
      calendlyUrl: calendlyUrl ?? this.calendlyUrl,
      creator: creator ?? this.creator,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object> get props => [
        id,
        url,
        gifUrl,
        calendlyUrl,
        creator,
      ];
}

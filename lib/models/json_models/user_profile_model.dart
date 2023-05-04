// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class UserProfileModel extends Equatable {
  const UserProfileModel({
    required this.uid,
    this.displayName = '',
    this.email = '',
    this.organization = '',
  });

  @JsonKey(defaultValue: '')
  final String uid;
  @JsonKey()
  final String displayName;
  @JsonKey()
  final String email;
  @JsonKey()
  final String organization;

  factory UserProfileModel.fromJson(Map<dynamic, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  factory UserProfileModel.fromSnapshot(
          DocumentSnapshot<Map<String, dynamic>> doc) =>
      UserProfileModel.fromJson(doc.data()!);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  UserProfileModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? organization,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      organization: organization ?? this.organization,
    );
  }

  @override
  List<Object> get props => [
        uid,
        displayName,
        email,
        organization,
      ];
}

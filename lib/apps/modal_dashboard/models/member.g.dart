// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
  id: json['id'] as String?,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  gender: json['gender'] as String?,
  email: json['email'] as String?,
  status: json['status'] as String?,
  username: json['username'] as String?,
  avatar: json['avatar'] as String?,
);

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'gender': instance.gender,
  'email': instance.email,
  'username': instance.username,
  'avatar': instance.avatar,
  'status': instance.status,
};

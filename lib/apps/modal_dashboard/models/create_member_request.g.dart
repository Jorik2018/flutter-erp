// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_member_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateMemberRequest _$CreateMemberRequestFromJson(Map<String, dynamic> json) =>
    CreateMemberRequest(
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$CreateMemberRequestToJson(
  CreateMemberRequest instance,
) => <String, dynamic>{
  'full_name': instance.fullName,
  'email': instance.email,
  'password': instance.password,
};

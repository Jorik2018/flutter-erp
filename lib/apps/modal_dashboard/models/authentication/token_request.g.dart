// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenRequest _$TokenRequestFromJson(Map<String, dynamic> json) => TokenRequest(
  phone: json['phone_number'] as String,
  password: json['password'] as String,
  clientId: json['client_id'] as String,
  clientSecret: json['client_secret'] as String,
  grantType: json['grant_type'] as String,
);

Map<String, dynamic> _$TokenRequestToJson(TokenRequest instance) =>
    <String, dynamic>{
      'phone_number': instance.phone,
      'password': instance.password,
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
      'grant_type': instance.grantType,
    };

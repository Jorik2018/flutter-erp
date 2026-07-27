// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
  accessToken: json['access_token'] as String,
  tokenType: json['token_type'] as String,
  expiresAt: (json['expires_at'] as num).toInt(),
  refreshToken: json['refresh_token'] as String,
  user: Member.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
  'access_token': instance.accessToken,
  'token_type': instance.tokenType,
  'expires_at': instance.expiresAt,
  'refresh_token': instance.refreshToken,
  'user': instance.user,
};

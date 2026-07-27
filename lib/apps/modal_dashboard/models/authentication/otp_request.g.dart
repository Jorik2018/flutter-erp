// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTPRequest _$OTPRequestFromJson(Map<String, dynamic> json) => OTPRequest(
  mobile: json['mobile'] as String,
  clientId: json['client_id'] as String,
  clientSecret: json['client_secret'] as String,
);

Map<String, dynamic> _$OTPRequestToJson(OTPRequest instance) =>
    <String, dynamic>{
      'mobile': instance.mobile,
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
    };

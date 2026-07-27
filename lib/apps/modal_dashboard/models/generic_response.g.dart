// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericResponse _$GenericResponseFromJson(Map<String, dynamic> json) =>
    GenericResponse(
      success: json['success'] as bool,
      error: json['error'] as String,
      errorCode: (json['errorCode'] as num).toInt(),
      result: json['result'],
    );

Map<String, dynamic> _$GenericResponseToJson(GenericResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'errorCode': instance.errorCode,
      'result': instance.result,
    };

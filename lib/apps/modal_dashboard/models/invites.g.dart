// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invites.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invites _$InvitesFromJson(Map<String, dynamic> json) => Invites(
  totalCount: (json['total_count'] as num?)?.toInt(),
  pageNumber: (json['page_number'] as num?)?.toInt(),
  pageSize: (json['page_size'] as num?)?.toInt(),
  invites: (json['invites'] as List<dynamic>?)
      ?.map((e) => Invite.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$InvitesToJson(Invites instance) => <String, dynamic>{
  'total_count': instance.totalCount,
  'page_number': instance.pageNumber,
  'page_size': instance.pageSize,
  'invites': instance.invites,
};

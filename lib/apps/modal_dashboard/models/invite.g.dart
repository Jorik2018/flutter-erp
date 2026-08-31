// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invite _$InviteFromJson(Map<String, dynamic> json) => Invite(
  id: json['id'] as String?,
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  date: (json['date'] as num?)?.toInt(),
  status: json['status'] as String?,
  sender: json['sender'] == null
      ? null
      : Member.fromJson(json['sender'] as Map<String, dynamic>),
  receiver: json['receiver'] == null
      ? null
      : Member.fromJson(json['receiver'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InviteToJson(Invite instance) => <String, dynamic>{
  'id': instance.id,
  'categories': instance.categories,
  'date': instance.date,
  'status': instance.status,
  'sender': instance.sender,
  'receiver': instance.receiver,
};

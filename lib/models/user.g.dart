// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  name: json['name'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  id: json['id'] as String?,
  photoUrl: json['photoUrl'] as String?,
  email: json['email'] as String?,
  displayName: json['displayName'] as String?,
  bio: json['bio'] as String?,
  followers: json['followers'] as Map<String, dynamic>?,
  following: json['following'] as Map<String, dynamic>?,
  token: json['token'] as String?,
  phoneNumber: json['mobileNumber'] as String?,
  isLogged: json['isLogged'] as bool?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'email': instance.email,
  'id': instance.id,
  'photoUrl': instance.photoUrl,
  'name': instance.name,
  'displayName': instance.displayName,
  'bio': instance.bio,
  'followers': instance.followers,
  'following': instance.following,
  'mobileNumber': instance.phoneNumber,
  'token': instance.token,
  'isLogged': instance.isLogged,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
};

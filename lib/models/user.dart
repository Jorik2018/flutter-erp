import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

const String ADMIN_PERMISSION = 'admin';
const String CUSTOMER_PERMISSION = 'customer';

@immutable
@JsonSerializable()
class User extends Equatable {
  final String? email;
  final String? id;
  final String? photoUrl;
  final String? name;
  final String? displayName;
  final String? bio;

  final Map<String, dynamic>? followers;
  final Map<String, dynamic>? following;

  final String? phoneNumber;
  final String? token;
  final bool? isLogged;

  final String? firstName;
  final String? lastName;
  final String? status;
  final int? createdAt;
  final int? updatedAt;
  final bool? isActive;
  final int? dob;

  final List<String> permisions;
  final List<String> favorites;

  final String? pass;

  final String? headline;

  final String? connections;
  final String? viewProfile;

  const User({
    this.headline,
    this.status,
    this.connections,
    this.viewProfile,
    this.email,
    this.pass,
    this.id,
    this.photoUrl,
    this.name,
    this.displayName,
    this.bio,
    this.followers,
    this.following,
    this.phoneNumber,
    this.token,
    this.isLogged,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.dob,
    this.permisions = const [],
    this.favorites = const [],
  });

  bool get isAdmin => permisions.contains(ADMIN_PERMISSION);

  factory User.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);

    // Compatibilidad con modelos antiguos.
    normalized['id'] ??= normalized['uid'];
    normalized['photoUrl'] ??= normalized['profileImageUrl'];
    normalized['mobileNumber'] ??= normalized['phone'];

    return _$UserFromJson(normalized);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromDocument(DocumentSnapshot document) {
    final data =
        document.data() as Map<String, dynamic>? ?? <String, dynamic>{};

    return User.fromJson({...data, 'id': document.id});
  }

  User copyWith({
    String? email,
    String? id,
    String? photoUrl,
    String? name,
    String? displayName,
    String? bio,
    Map<String, dynamic>? followers,
    Map<String, dynamic>? following,
    String? mobileNumber,
    String? token,
    bool? isLogged,
    String? firstName,
    String? lastName,
    int? createdAt,
    int? updatedAt,
    bool? isActive,
    int? dob,
    List<String>? permisions,
    List<String>? favorites,
  }) {
    return User(
      email: email ?? this.email,
      id: id ?? this.id,
      photoUrl: photoUrl ?? this.photoUrl,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      phoneNumber: mobileNumber ?? this.phoneNumber,
      token: token ?? this.token,
      isLogged: isLogged ?? this.isLogged,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      dob: dob ?? this.dob,
      permisions: permisions ?? this.permisions,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [
    email,
    id,
    photoUrl,
    name,
    displayName,
    bio,
    followers,
    following,
    phoneNumber,
    token,
    isLogged,
    firstName,
    lastName,
    createdAt,
    updatedAt,
    isActive,
    dob,
    permisions,
    favorites,
  ];
}

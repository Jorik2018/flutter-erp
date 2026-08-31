import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

const String adminPermission = 'admin';
const String customerPermission = 'customer';

@immutable
class AppUser extends Equatable {
  final String? id;
  final String? email;
  final String? name;
  final String? firstName;
  final String? lastName;

  final String? photoUrl;
  final String? displayName;
  final String? bio;
  final String? phone;

  final String? token;
  final bool? isLogged;

  final int? createdAt;
  final int? updatedAt;
  final bool? isActive;
  final int? dob;

  final Map<String, dynamic>? followers;
  final Map<String, dynamic>? following;

  final List<String> permissions;
  final List<String> favorites;

  const AppUser({
    this.id,
    this.email,
    this.name,
    this.firstName,
    this.lastName,
    this.photoUrl,
    this.displayName,
    this.bio,
    this.phone,
    this.token,
    this.isLogged,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.dob,
    this.followers,
    this.following,
    this.permissions = const [],
    this.favorites = const [],
  });

  bool get isAdmin => permissions.contains(adminPermission);

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? firstName,
    String? lastName,
    String? photoUrl,
    String? displayName,
    String? bio,
    String? phone,
    String? token,
    bool? isLogged,
    int? createdAt,
    int? updatedAt,
    bool? isActive,
    int? dob,
    Map<String, dynamic>? followers,
    Map<String, dynamic>? following,
    List<String>? permissions,
    List<String>? favorites,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      photoUrl: photoUrl ?? this.photoUrl,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      token: token ?? this.token,
      isLogged: isLogged ?? this.isLogged,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      dob: dob ?? this.dob,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      permissions: permissions ?? this.permissions,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    firstName,
    lastName,
    photoUrl,
    displayName,
    bio,
    phone,
    token,
    isLogged,
    createdAt,
    updatedAt,
    isActive,
    dob,
    followers,
    following,
    permissions,
    favorites,
  ];
}

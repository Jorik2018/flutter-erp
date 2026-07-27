import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/singtaxi/models/profile.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  // collection reference
  final CollectionReference userProfile = FirebaseFirestore.instance.collection(
    'profile',
  );

  Future updateUserData(
    bool driver,
    String name,
    String talkative,
    int number,
    double rating,
    bool gender,
    String email,
    String license,
    String carplate,
    String payment,
  ) async {
    return await userProfile.doc(uid).set({
      'name': name,
      'driver': driver,
      'talkative': talkative,
      'number': number,
      'rating': rating,
      'gender': gender,
      'email': email,
      'license': license,
      'carplate': carplate,
      'payment': payment,
    });
  }

  List<Profile> _profileListFromSnapshot(QuerySnapshot<Object?> snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return Profile(
        name: data['name'] as String? ?? '',
        email: data['email'] as String? ?? '',
      );
    }).toList();
  }

  Stream<List<Profile>> get profile {
    /**The argument type 'List<Profile> Function(QuerySnapshot<Map<String, dynamic>>)' can't be assigned to the parameter type 'List<Profile> Function(QuerySnapshot<Object?>) */
    return userProfile.snapshots().map(_profileListFromSnapshot);
  }
}

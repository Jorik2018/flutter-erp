// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/result.dart';
import 'package:flutter_erp/models/user.dart' as app_user;
import '../services/authentication_service.dart';
import '../utils/common.dart';

class UserRepository {
  final _authService = AuthenicationService.instance;

  final usersCollection = FirebaseFirestore.instance.collection("users");

  ValueNotifier<app_user.User?> currentUserNotifier =
      ValueNotifier<app_user.User?>(null);

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _userStreamSubscriptions;

  StreamSubscription? _authStreamSubscription;

  String? get currentUserUID => _authService.auth.currentUser?.uid;

  set setCurrentUser(app_user.User? user) {
    currentUserNotifier.value = user;
    currentUserNotifier.notifyListeners();
  }

  UserRepository() {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authStreamSubscription?.cancel();
    _authStreamSubscription = null;

    _authStreamSubscription = _authService.authStates().listen((firebaseUser) {
      if (firebaseUser != null) {
        final String uid = firebaseUser.uid;
        getCurrentUser(uid);
        fodaPrint("CURRENT USER -> $uid");
      } else {
        fodaPrint("NO CURRENT USER");
      }
    });
  }

  Future<Result<app_user.User>> getCurrentUser(String uid) async {
    try {
      final userSnapshot = await usersCollection.doc(uid).get();
      if (!userSnapshot.exists) {
        return const Failure(UserNotFoundError());
      }
      final app_user.User user = app_user.User.fromDocument(userSnapshot);
      if (user.name != 'admin') {
        await logout();
        fodaPrint("user is not an admin");
        return const Failure(UserNotAdminError());
      }
      setCurrentUser = user;
      listenToCurrentUser(user.id!);
      return Success(user);
    } catch (e) {
      return Failure(UnexpectedError(e.toString()));
    }
  }

  Future<Result<app_user.User>> login(String email, String password) async {
    try {
      final logIn = await _authService.logIn(email, password);
      switch (logIn) {
        case Success(data: final firebaseUser):
          return await getCurrentUser(firebaseUser.uid);
        case Failure(error: final error):
          return Failure(error);
      }
    } catch (e) {
      return Failure(UnexpectedError(e.toString()));
    }
  }

  Stream<app_user.User?> listenToCurrentUser(String uid) async* {
    try {
      _userStreamSubscriptions?.cancel();
      _userStreamSubscriptions = null;

      final snapshots = usersCollection.doc(uid).snapshots();

      _userStreamSubscriptions = snapshots.listen((document) {
        if (document.exists) {
          final user = app_user.User.fromDocument(document);
          setCurrentUser = user;
        }
      });
    } catch (e) {
      fodaPrint(e);
    }

    yield currentUserNotifier.value;
  }

  Future<void> logout() async {
    setCurrentUser = null;
    await _authService.logout();
  }
}

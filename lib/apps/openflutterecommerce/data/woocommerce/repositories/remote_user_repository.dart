import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_erp/apps/openflutterecommerce/config/server_addresses.dart';
import 'package:flutter_erp/apps/openflutterecommerce/data/model/app_user.dart';
import 'package:flutter_erp/apps/openflutterecommerce/data/repositories/abstract/user_repository.dart';

import '../utils.dart';

class RemoteUserRepository extends UserRepository {
  @override
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    var data = <String, String>{'username': email, 'password': password};

    var response = await Dio().post(ServerAddresses.authToken, data: data);
    var jsonResponse = response.data is String
        ? json.decode(response.data)
        : response.data;
    if (response.statusCode != 200) {
      throw jsonResponse['message'];
    }
    return jsonResponse['token'];
  }

  @override
  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      var dio = Dio();
      var data = <String, String>{
        'name': name,
        'username': email,
        'password': password,
      };

      var response = await dio.post(ServerAddresses.signUp, data: data);
      Map jsonResponse = response.data is String
          ? json.decode(response.data)
          : response.data;
      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }
      return jsonResponse['token'];
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<AppUser> getUser() async {
    try {
      // TODO api call for user information
      await Future.delayed(Duration(seconds: 2));

      return AppUser();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      var dio = Dio();
      var data = <String, String>{'email': email};

      var response = await dio.post(ServerAddresses.forgotPassword, data: data);
      Map jsonResponse = response.data is String
          ? json.decode(response.data)
          : response.data;
      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }
    } catch (error) {
      rethrow;
    }
  }
}

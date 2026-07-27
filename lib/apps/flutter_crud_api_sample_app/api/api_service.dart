import 'package:flutter_erp/apps/flutter_crud_api_sample_app/model/profile.dart';
import 'package:flutter_erp/apps/wonders/logic/common/http_client.dart';

class ApiService {
  final String baseUrl = "http://api.bengkelrobot.net:8001";

  Future<List<Profile>?> getProfiles() async {
    try {
      final response = await HttpClient.get("$baseUrl/api/profile");
      if (response.statusCode == 200) {
        return profileFromJson(response.body!);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateProfile(Profile data) async {
    final response = await HttpClient.send(
      method: MethodType.put,
      "$baseUrl/api/profile/${data.id}",
      body: profileToJson(data),
      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProfile(int id) async {
    final response = await HttpClient.send(
      method: MethodType.delete,
      "$baseUrl/api/profile/$id",
      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createProfile(Profile data) async {
    try {
      final response = await HttpClient.send(
        "$baseUrl/api/profile",
        body: profileToJson(data),
        headers: {"content-type": "application/json"},
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

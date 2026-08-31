import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/common/model/common_response.dart';

class LoginResponse extends CommonResponse {
  Payload? payload;

  LoginResponse({Error? error, this.payload, String? status})
    : super(error: error, status: status);

  LoginResponse.fromJson(Map<String, dynamic> json)
    : payload = json['payload'] != null
          ? Payload.fromJson(json['payload'] as Map<String, dynamic>)
          : null,
      super(
        error: json['error'] != null
            ? Error.fromJson(json['error'] as Map<String, dynamic>)
            : null,
        status: json['status'] as String?,
      );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (error != null) {
      data['error'] = error!.toJson();
    }

    if (payload != null) {
      data['payload'] = payload!.toJson();
    }

    data['status'] = status;

    return data;
  }
}

class Payload {
  final String? passengerId;
  final String? name;
  final String? email;
  final String? mobile;
  final String? profilePicture;
  final int? credits;
  final String? accessToken;

  const Payload({
    this.passengerId,
    this.name,
    this.email,
    this.mobile,
    this.profilePicture,
    this.credits,
    this.accessToken,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      passengerId: json['passenger_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      profilePicture: json['profile_picture'] as String?,
      credits: json['credits'] as int?,
      accessToken: json['access_token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passenger_id': passengerId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'profile_picture': profilePicture,
      'credits': credits,
      'access_token': accessToken,
    };
  }
}

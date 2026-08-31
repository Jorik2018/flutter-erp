class CommonResponse {
  Error? error;
  String? status;

  CommonResponse({this.error, this.status});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'] != null
        ? Error.fromJson(json['error'] as Map<String, dynamic>)
        : null;

    status = json['status'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {'error': error?.toJson(), 'status': status};
  }
}

class Error {
  final String name;
  final String message;
  final int code;

  Error({required this.name, required this.message, required this.code});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      name: json['name'] as String,
      message: json['message'] as String,
      code: json['code'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'message': message, 'code': code};
  }
}

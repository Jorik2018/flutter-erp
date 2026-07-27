import 'package:flutter_erp/apps/flutter_inventary/main.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

final dio = Dio();

Future<Map> sendPostHTTPRequest(String url, String token, Map data) async {
  try {
    var response = await dio.post(
      '{dotenv.env[API_INVENTARY]}/$url',
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.getItem("token")}'
        },
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return {"status": true, "data": response.data};
    } else {
      return {"status": false, "data": response.data};
    }
  } catch (e) {
    return {"status": false, "data": {}};
  }
}

Future<Map> sendGetHTTPRequest(String url, String token) async {
  try {
    var response = await dio.get(
      '${dotenv.env['API_INVENTARY']}/$url',
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.getItem("token")}'
        },
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return {"status": true, "data": response.data};
    } else {
      return {"status": false, "data": response.data};
    }
  } catch (e) {
    return {"status": false, "data": {}};
  }
}
 await dio.put(
      'dotenv.env[API_INVENTARY]/$url',
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.getItem("token")}'
        },
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return {"status": true, "data": response.data};
    } else {
      return {"status": false, "data": response.datasCode == 200) {
      return {"status": true, "data": response.body};
    } else {
      return {"status": false, "data": response.body};
    }
  } catch (e) {
    return {"status": false, "data": {}};
  }
}
 await dio.delete(
      '${dotenv.env['API_INVENTARY']}/$url',
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.getItem("token")}'
        },
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return {"status": true, "data": response.data};
    } else {
      return {"status": false, "data": response.datasCode == 200) {
      return {"status": true, "data": response.body};
    } else {
      return {"status": false, "data": response.body};
    }
  } catch (e) {
    return {"status": false, "data": {}};
  }
}

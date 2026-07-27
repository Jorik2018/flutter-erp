import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_erp/apps/tourism_demo/models/destination.dart';

class ServerAPI {
  static String host = 'https://jsonplaceholder.typicode.com/posts';

  // DESTINATIONS
  Future<List<Destination>> fetchDestinations() async {
    print('fetching destinations...');
    var url = '$host';
    final dio = Dio();

    Response response = await dio.get(
      url,
      options: Options(
        headers: {
          'Content-type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
      ),
    );
    List responseJSON = response.data is String
        ? json.decode(response.data)
        : response.data;
    List<Destination> destinations = responseJSON
        .map((destination) => Destination.fromJson(destination))
        .toList();

    print('${destinations.length} destinations fetched...');

    return destinations;
  }
}

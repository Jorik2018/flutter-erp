import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_erp/apps/openflutterecommerce/config/server_addresses.dart';
import 'package:flutter_erp/apps/openflutterecommerce/data/model/filter_rules.dart';
import 'package:flutter_erp/apps/openflutterecommerce/data/model/sort_rules.dart';
import 'package:flutter_erp/apps/openflutterecommerce/data/error/exceptions.dart';
import 'package:flutter_erp/apps/wonders/logic/common/http_client.dart';

class NetworkRequest {
  static const STATUS_OK = 200;
  static const STATUS_CREATED = 201;

  final Map<String, String> _jsonHeaders = {'content-type': 'application/json'};

  final RequestType type;
  final String address;
  final Map<String, dynamic>? body;
  Map<String, String>? headers;
  final List<int>? listBody;
  final String? plainBody;

  NetworkRequest(
    this.type,
    this.address, {
    this.body,
    this.plainBody,
    this.listBody,
    this.headers,
  });

  Future<HttpResponse> getResult() async {
    print('ADDRESS: $address');
    if (listBody != null) {
      print('listBody: ${jsonEncode(listBody)}');
    }
    if (plainBody != null) {
      print('plainBody: $plainBody');
    }
    if (body != null) {
      print('body: ${jsonEncode(body)}');
    }
    HttpResponse response;
    headers ??= _jsonHeaders;
    try {
      String uri = address; //Uri.parse(address);
      switch (type) {
        case RequestType.post:
          response = await HttpClient.send(
            address,
            body: jsonEncode(body) ?? plainBody ?? listBody,
            headers: headers,
          );
          break;
        case RequestType.get:
          response = await HttpClient.get(address, headers: headers);
          break;
        case RequestType.put:
          response = await HttpClient.send(
            address,
            method: MethodType.put,
            body: body ?? plainBody ?? listBody,
            headers: headers,
          );
          break;
        case RequestType.delete:
          response = await HttpClient.send(
            address,
            method: MethodType.delete,
            headers: headers,
          );
          break;
      }
      print('RESULT: ${response.body}');
      if (response.statusCode != STATUS_OK) {
        throw HttpRequestException();
      }
      return response;
    } catch (exception) {
      if (exception is HttpRequestException) {
        rethrow;
      } else {
        throw RemoteServerException();
      }
    }
  }

  factory NetworkRequest.productList(
    HttpClient client,
    int pageIndex,
    int pageSize,
    int categoryId,
    FilterRules filterRules,
    SortRules sortRules,
  ) {
    List<String> parameters = [];
    if (pageIndex != null) {
      parameters.add('page=${pageIndex + 1}');
    }
    if (pageSize != null) {
      parameters.add('per_page=$pageSize');
    }
    if (categoryId != null) {
      parameters.add('category=$categoryId');
    }
    if (sortRules != null) {
      parameters.add('orderby=${sortRules.jsonRuleName}');
      parameters.add('order=${sortRules.jsonOrder}');
    }
    //TODO add filter rules here
    String serverAddress =
        ServerAddresses.serverAddress + '?' + parameters.join('&');
    return NetworkRequest(RequestType.get, serverAddress);
  }
}

enum RequestType { post, get, put, delete }

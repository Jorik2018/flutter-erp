import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_erp/apps/openflutterecommerce/config/server_addresses.dart';
import 'package:flutter_erp/apps/openflutterecommerce/data/error/exceptions.dart';
import 'package:flutter_erp/apps/openflutterecommerce/domain/usecases/products/products_by_filter_params.dart';

abstract class WoocommercWrapperAbstract {
  Future<List<dynamic>> getCategoryList({int parentId = 0});
  Future<List<dynamic>> getProductList(ProductsByFilterParams params);
  Future<List<dynamic>> getPromoList({int userId = 0});
}

class WoocommerceWrapper implements WoocommercWrapperAbstract {
  final Dio client;

  WoocommerceWrapper({required this.client});

  @override
  Future<List<dynamic>> getProductList(ProductsByFilterParams params) {
    //TODO: make remote request using all paramaters
    return _getApiRequest(ServerAddresses.products);
  }

  @override
  Future<List<dynamic>> getCategoryList({int parentId = 0}) {
    return _getApiRequest(ServerAddresses.productCategories);
  }

  @override
  Future<List> getPromoList({int userId = 0}) {
    return _getApiRequest(ServerAddresses.promos);
  }

  Future<List<dynamic>> _getApiRequest(String url) async {
    final response = await client.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode == 200) {
      return response.data is String
          ? json.decode(response.data)
          : response.data;
    } else {
      throw HttpRequestException();
    }
  }
}

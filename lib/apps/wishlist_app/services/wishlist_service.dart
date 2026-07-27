import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/api/add_item_request_dto.dart';
import '../models/api/edit_item_request_dto.dart';
import '../models/api/item_dto.dart';
import '../models/item.dart';
import '../models/wishlist.dart';
class WishlistService {
  
  static const String itemsApiUrl = 'https://modern-relieved-lime.glitch.me';
  final Dio _dio = Dio();
  WishlistService();
  Future<Wishlist> getWishList() async {
    final Response response = await _dio.get('$itemsApiUrl/api/wishlist/items');
    if (response.statusCode == 200) {
      final List<dynamic> decodedJsonList = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      final List<ItemDTO> items = List<ItemDTO>.from(decodedJsonList.map((json) => ItemDTO.fromJson(json as Map<String, dynamic>)));
      return Wishlist(items?.map((ItemDTO itemDTO) => Item(
              id: itemDTO.id,
              name: itemDTO.name,
              description: itemDTO.description,
              url: itemDTO.url))
          ?.toList());
    }
    throw Exception('Could not get the wishlist2');
  }
  Future<String> addItem(Item item) async {
    final AddItemRequestDTO addItemRequest = AddItemRequestDTO(
        name: item.name, description: item.description, url: item.url);
    // TODO: send additional info to be able to access protected endpoint
    final Response response = await _dio.post(
      '$itemsApiUrl/api/wishlist/items',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: jsonEncode(addItemRequest.toJson()));
    if (response.statusCode == 201) {
      return response.data is String ? response.data : jsonEncode(response.data);
    }
    throw Exception('Could not add item');
  }
  Future<String> editItem(Item item) async {
    final EditItemRequestDTO editItemRequest = EditItemRequestDTO(
        name: item.name, description: item.description, url: item.url);
    // TODO: send additional info to be able to access protected endpoint
    final Response response = await _dio.put(
      '$itemsApiUrl/api/wishlist/items/${item.id}',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: jsonEncode(editItemRequest.toJson()));
    if (response.statusCode == 200) {
      return response.data is String ? response.data : jsonEncode(response.data);
    }
    throw Exception('Could not add item');
  }
  Future<void> deleteItem(Item item) async {
    // TODO: send additional info to be able to access protected endpoint
    final Response response = await _dio.delete(
      '$itemsApiUrl/api/wishlist/items/${item.id}',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    if (response.statusCode != 204) {
      throw Exception('Could not delete item');
    }
  }
}
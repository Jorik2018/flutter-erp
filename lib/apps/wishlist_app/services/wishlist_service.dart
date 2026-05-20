import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api/add_item_request_dto.dart';
import '../models/api/edit_item_request_dto.dart';
import '../models/api/item_dto.dart';
import '../models/item.dart';
import '../models/wishlist.dart';
class WishlistService {
  
  static const String itemsApiUrl = 'modern-relieved-lime.glitch.me';
  WishlistService();
  Future<Wishlist> getWishList() async {
    final http.Response response = await http.get(Uri.https(itemsApiUrl,'/api/wishlist/items'));
    if (response.statusCode == 200) {
      final List<dynamic> decodedJsonList = jsonDecode(response.body);
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
    final http.Response response = await http.post(Uri.https(itemsApiUrl,'/api/wishlist/items'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(addItemRequest.toJson()));
    if (response.statusCode == 201) {
      return response.body;
    }
    throw Exception('Could not add item');
  }
  Future<String> editItem(Item item) async {
    final EditItemRequestDTO editItemRequest = EditItemRequestDTO(
        name: item.name, description: item.description, url: item.url);
    // TODO: send additional info to be able to access protected endpoint
    final http.Response response = await http.put(Uri.https('$itemsApiUrl','/api/wishlist/items/${item.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(editItemRequest.toJson()));
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('Could not add item');
  }
  Future<void> deleteItem(Item item) async {
    // TODO: send additional info to be able to access protected endpoint
    final http.Response response = await http.delete(
      Uri.https('$itemsApiUrl','/api/wishlist/items/${item.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Could not delete item');
    }
  }
}
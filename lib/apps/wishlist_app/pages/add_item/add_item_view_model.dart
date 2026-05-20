import 'package:flutter/foundation.dart';
import '../../models/item.dart';
import '../../services/wishlist_service.dart';

class AddItemViewModel extends ChangeNotifier {
  final WishlistService wishlistService;
  bool _addingItem = false;
  bool get addingItem => _addingItem;
  AddItemViewModel(
    this.wishlistService,
  );
  Future<void> addItem(Item item) async {
    try {
      _addingItem = true;
      notifyListeners();
      await wishlistService.addItem(item);
    } finally {
      _addingItem = false;
      notifyListeners();
    }
  }
}
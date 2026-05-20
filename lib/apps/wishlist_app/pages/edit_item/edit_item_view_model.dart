import 'package:flutter/foundation.dart';
import '../../models/item.dart';
import '../../services/wishlist_service.dart';

class EditItemViewModel extends ChangeNotifier {
  final WishlistService wishlistService;
  bool _editingItem = false;
  bool get editingItem => _editingItem;
  EditItemViewModel(
    this.wishlistService,
  );
  Future<void> editItem(Item item) async {
    try {
      _editingItem = true;
      notifyListeners();
      await wishlistService.editItem(item);
    } finally {
      _editingItem = false;
      notifyListeners();
    }
  }
}
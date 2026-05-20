import 'package:flutter/foundation.dart';
import '../../models/item.dart';
import '../../models/wishlist.dart';
import '../../services/wishlist_service.dart';

class WishlistViewModel extends ChangeNotifier {
  final WishlistService wishlistService;
  Future<Wishlist>? _wishlistFuture;
  Future<Wishlist>? get wishlistFuture => _wishlistFuture;
  WishlistViewModel(this.wishlistService);
  Future<void> loadInitialWishlist() =>
      _wishlistFuture = wishlistService.getWishList();
  Future<void> refreshWishlist() async {
    _wishlistFuture = wishlistService.getWishList();
    notifyListeners();
    await _wishlistFuture;
  }

  Future<void> deleteItem(Item item) async {
    await wishlistService.deleteItem(item);
    await refreshWishlist();
  }

  Future<void> signOut() {
    // TODO: handle signing out
    return Future.value(null);
  }
}
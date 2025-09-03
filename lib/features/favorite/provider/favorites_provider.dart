import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';
import 'package:restaurant_app/utils/result_state.dart';

class FavoritesProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  List<Restaurant> _favoriteRestaurants = [];
  ResultState _state = ResultState.loading;
  String _message = '';

  List<Restaurant> get favoriteRestaurants => _favoriteRestaurants;
  ResultState get state => _state;
  String get message => _message;

  FavoritesProvider({required this.databaseHelper}) {
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final favorites = await databaseHelper.getFavorites();
      if (favorites.isEmpty) {
        _state = ResultState.noData;
        _message = 'Belum ada restoran favorit.';
        _favoriteRestaurants = [];
      } else {
        _state = ResultState.hasData;
        _favoriteRestaurants = favorites;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Gagal memuat daftar favorit. Coba lagi nanti.';
    }
    notifyListeners();
  }

  Future<void> refreshFavorites() async {
    await fetchFavorites();
  }

  Future<bool> addFavorite(Restaurant restaurant) async {
    try {
      debugPrint(
        'FavoritesProvider: Attempting to add favorite: ${restaurant.id}',
      );
      await databaseHelper.insertFavorite(restaurant);

      await fetchFavorites();
      debugPrint(
        'FavoritesProvider: Favorite added successfully: ${restaurant.id}',
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFavorite(String id) async {
    try {
      debugPrint('FavoritesProvider: Attempting to remove favorite: $id');
      await databaseHelper.removeFavorite(id);

      await fetchFavorites();
      debugPrint('FavoritesProvider: Favorite removed successfully: $id');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearFavorites() async {
    try {
      await databaseHelper.clearFavorites();
      _favoriteRestaurants.clear();
      _state = ResultState.noData;
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Gagal menghapus semua favorit. Coba lagi nanti.';
    }
  }

  bool isFavorite(String id) {
    return _favoriteRestaurants.any((restaurant) => restaurant.id == id);
  }
}

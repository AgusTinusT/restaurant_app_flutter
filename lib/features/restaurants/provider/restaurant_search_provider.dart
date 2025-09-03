import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  RestaurantSearchProvider() {
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchQuery = _searchController.text;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    if (!_isSearching) {
      _searchController.clear();
      _searchQuery = '';
    }
    notifyListeners();
  }

  List<Restaurant> filterRestaurants(List<Restaurant> restaurants) {
    if (_searchQuery.isEmpty) {
      return restaurants;
    }
    final query = _searchQuery.toLowerCase();
    return restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(query) ||
          restaurant.description.toLowerCase().contains(query);
    }).toList();
  }

  void setInitialSearchQuery(String? query) {
    if (query != null && query.isNotEmpty && _searchQuery.isEmpty) {
      _searchController.text = query;
      _searchQuery = query;
      _isSearching = true;
      notifyListeners();
    }
  }
}

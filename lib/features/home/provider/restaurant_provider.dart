import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';
import 'package:restaurant_app/utils/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  late List<Restaurant> _allRestaurants;
  List<Restaurant> _filteredRestaurants = [];
  String _searchTerm = '';
  late ResultState _state;
  String _message = '';

  String get message => _message;
  List<Restaurant> get restaurants => _filteredRestaurants;
  ResultState get state => _state;

  Future<void> refresh() async {
    _searchTerm = '';
    await _fetchAllRestaurant();
  }

  Future<void> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantList = await apiService.fetchRestaurants();
      _allRestaurants = restaurantList;
      if (restaurantList.isEmpty) {
        _state = ResultState.noData;
        _message = 'Empty Data';
        _filteredRestaurants = [];
      } else {
        _state = ResultState.hasData;
        _filterRestaurants();
      }
    } catch (e) {
      _state = ResultState.error;
      _message = "Error --> ${e.toString().replaceFirst("Exception: ", "")}";
    } finally {
      notifyListeners();
    }
  }

  void search(String query) {
    _searchTerm = query;
    _filterRestaurants();
    notifyListeners();
  }

  void _filterRestaurants() {
    if (_searchTerm.isEmpty) {
      _filteredRestaurants = _allRestaurants;
    } else {
      _filteredRestaurants =
          _allRestaurants
              .where(
                (restaurant) => restaurant.name.toLowerCase().contains(
                  _searchTerm.toLowerCase(),
                ),
              )
              .toList();
    }

    if (_state == ResultState.hasData && _filteredRestaurants.isEmpty) {
      _message = 'No results found for "$_searchTerm"';
    }
  }
}

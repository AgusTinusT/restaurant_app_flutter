import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:restaurant_app/utils/result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  RestaurantDetailProvider({required this.apiService, required this.id})
    : _state = ResultState.loading;

  RestaurantDetail? _restaurantDetail;
  ResultState _state;
  String _message = '';

  String get message => _message;
  RestaurantDetail? get result => _restaurantDetail;
  ResultState get state => _state;

  Future<void> fetchRestaurantDetail() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      _restaurantDetail = await apiService.fetchRestaurantDetail(id);
      _message = '';
      _state = ResultState.hasData;
    } catch (e) {
      _state = ResultState.error;
      _message = e.toString().replaceFirst("Exception: ", "");
    } finally {
      notifyListeners();
    }
  }
}

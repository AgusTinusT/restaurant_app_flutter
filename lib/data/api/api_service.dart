import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:restaurant_app/data/model/restaurant_detail_response.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';
import 'package:restaurant_app/data/model/restaurant_response.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  static const String _listUrl = '$_baseUrl/list';
  static const String _detailUrl = '$_baseUrl/detail/';

  Future<List<Restaurant>> fetchRestaurants() async {
    final response = await http.get(Uri.parse(_listUrl));

    if (response.statusCode == 200) {
      final restaurantResponse = RestaurantResponse.fromJson(
        json.decode(response.body),
      );
      if (!restaurantResponse.error) {
        return restaurantResponse.restaurants;
      } else {
        throw Exception(
          'Gagal memuat daftar restoran: ${restaurantResponse.message}',
        );
      }
    } else {
      throw Exception('Gagal terhubung ke server');
    }
  }

  Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$_detailUrl$id'));

    if (response.statusCode == 200) {
      final detailResponse = RestaurantDetailResponse.fromJson(
        json.decode(response.body),
      );
      if (!detailResponse.error) {
        return detailResponse.restaurant;
      } else {
        throw Exception(
          'Gagal memuat detail restoran: ${detailResponse.message}',
        );
      }
    } else {
      throw Exception('Gagal terhubung ke server');
    }
  }

  static String buildPictureUrl(
    String pictureId, {
    String resolution = 'medium',
  }) {
    return '$_baseUrl/images/$resolution/$pictureId';
  }
}

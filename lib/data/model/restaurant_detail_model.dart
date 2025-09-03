import 'package:restaurant_app/data/model/category_model.dart';
import 'package:restaurant_app/data/model/customer_review_model.dart';
import 'package:restaurant_app/data/model/menu_model.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<Category> categories;
  final Menu menu;
  final double rating;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menu,
    required this.rating,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        city: json['city'],
        address: json['address'],
        pictureId: json['pictureId'],

        categories: List<Category>.from(
          json["categories"].map((x) => Category.fromJson(x)),
        ),

        menu: Menu.fromJson(json['menus']),

        rating: (json['rating'] as num).toDouble(),

        customerReviews: List<CustomerReview>.from(
          json["customerReviews"].map((x) => CustomerReview.fromJson(x)),
        ),
      );
}

extension RestaurantDetailExtension on RestaurantDetail {
  Restaurant toRestaurant() {
    return Restaurant(
      id: id,
      name: name,
      description: description,
      city: city,
      pictureId: pictureId,
      rating: rating,
    );
  }
}

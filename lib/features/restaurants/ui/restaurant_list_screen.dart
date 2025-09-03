import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/features/detail/ui/detail_screen.dart';
import 'package:restaurant_app/features/home/provider/restaurant_provider.dart';
import 'package:restaurant_app/features/restaurants/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/widgets/restaurant_card.dart';

class RestaurantListScreen extends StatelessWidget {
  final String? initialSearchQuery;

  const RestaurantListScreen({super.key, this.initialSearchQuery});

  static const routeName = '/restaurants';

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<RestaurantSearchProvider>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchProvider.setInitialSearchQuery(initialSearchQuery);
    });

    return Scaffold(
      appBar: AppBar(
        title: Consumer<RestaurantSearchProvider>(
          builder: (context, searchProvider, child) {
            return searchProvider.isSearching
                ? TextField(
                  controller: searchProvider.searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search restaurants...',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  autofocus: true,
                )
                : const Text('All Restaurants');
          },
        ),
        actions: [
          Consumer<RestaurantSearchProvider>(
            builder: (context, searchProvider, child) {
              return IconButton(
                icon: Icon(
                  searchProvider.isSearching ? Icons.clear : Icons.search,
                ),
                onPressed: () {
                  searchProvider.toggleSearch();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, restaurantProvider, child) {
          return Consumer<RestaurantSearchProvider>(
            builder: (context, searchProvider, child) {
              final filteredRestaurants = searchProvider.filterRestaurants(
                restaurantProvider.restaurants,
              );

              if (filteredRestaurants.isEmpty) {
                return const Center(child: Text('No restaurants found.'));
              }
              return ListView.builder(
                itemCount: filteredRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = filteredRestaurants[index];
                  return RestaurantCard(
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        DetailScreen.routeName,
                        arguments: restaurant.id,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

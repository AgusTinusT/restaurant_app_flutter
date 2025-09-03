import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/features/favorite/provider/favorites_provider.dart';
import 'package:restaurant_app/features/setting/provider/navigation_routes.dart';
import 'package:restaurant_app/widgets/restaurant_card.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = '/favorites';
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoritesProvider>(context, listen: false).refreshFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, provider, child) {
        if (provider.favoriteRestaurants.isEmpty) {
          return _buildEmptyState(context);
        } else {
          return ListView.builder(
            itemCount: provider.favoriteRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = provider.favoriteRestaurants[index];
              return RestaurantCard(
                restaurant: restaurant,
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      NavigationRoute.detailRoute.name,
                      arguments: restaurant.id,
                    ).then((_) {
                      Provider.of<FavoritesProvider>(
                        // ignore: use_build_context_synchronously
                        context,
                        listen: false,
                      ).refreshFavorites();
                    }),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No favorite restaurants yet.',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
